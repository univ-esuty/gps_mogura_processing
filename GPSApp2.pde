import ketai.sensors.*;
import android.view.MotionEvent;
import ketai.ui.*;

double longitude, latitude, altitude;       // 現在の経度、緯度、高度を入れる変数
KetaiLocation location;                     // GPS信号を取得するためのオブジェクト
KetaiGesture gesture;

double templocationX;
double templocationY;
double templocationZ;

double PlotX;
double PlotY;
double tempPlotX;
double tempPlotY;
float range = 250000;

int isPlot = 0;

int score = 0;
float moguraX ,moguraY;


//--------------------------------------------------------------------------
void setup(){
  background(255);
  
  location = new KetaiLocation(this);
  gesture = new KetaiGesture(this);
  
  orientation(LANDSCAPE);           // 横長になるようにディスプレイ表示を固定する。縦長に固定したいならPORTRAITと書く
  fullScreen();
  textSize(32);
  textAlign(LEFT, TOP);
  
  templocationX = longitude;
  templocationY = latitude;
  PlotX = width/2;
  PlotY = height/2;
  tempPlotX = width/2;
  tempPlotY = height/2;
  
  fill(0,0,255);
  ellipse(width/2,height/2,10,10);
  
  mogura();
}

//--------------------------------------------------------------------------
void draw(){
  // 測位できない場合はエラー文を表示する
  if (location.getProvider() == "none"){
    fill(255, 0, 0);
    text("location data is unavailable", 50, 50);
    return;
  }
  

  // 経度、緯度、高度の各値を表示する
  fill(255);
  rect(0,0,width,50);
  fill(0);
  
  text("経度:" + longitude +
       "/緯度:" + latitude
   ,0, 0
   );
   
   text("Score " + score,width-300,0);
   text("Range " + range/10000,width-550,0);
   
   //線の描画
   fill(0,0,255);
   ellipse((float)(PlotX),(float)(PlotY),10,10);
   stroke(0,0,255);
   line((float)PlotX,(float)PlotY,(float)tempPlotX,(float)tempPlotY);
   stroke(0);
   
  //プロットをする
  if(isPlot == 1){
    isPlot = 0;
    
    tempPlotX = PlotX;
    tempPlotY = PlotY;
    
    PlotX = ((longitude - templocationX) * range) + width/2;
    PlotY = ((latitude - templocationY) * -range) + height/2;
    
    //Goalの判定
    if(dist((float)PlotX,(float)PlotY,moguraX+75,moguraY+75) <= 75){
      Goal();
    }
    
  }
  
  //Reset Button
  fill(255);
  rect(width-100,0,100,50);
  fill(0);
  text("Reset",width-100,0);
}

//--------------------------------------------------------------------------
// 前回の測定時から1m以上移動した場合、または10秒経過した場合にこの関数が呼び出される。
// 各引数には最新の経度・緯度・高度が代入される。
//
void onLocationEvent(double _latitude, double _longitude){
  longitude = _longitude;
  latitude  = _latitude;

  isPlot = 1;
}

void OnReset(){
  background(255);
  
  templocationX = longitude;
  templocationY = latitude;
  PlotX = width/2;
  PlotY = height/2;
  tempPlotX = width/2;
  tempPlotY = height/2;
  
  fill(0,0,255);
  ellipse(width/2,height/2,10,10);
  
  mogura();
}

void Goal(){
  score++;
  OnReset();
}

void mogura(){
   PImage mogura;
   mogura = loadImage("mogura.png");
   moguraX = random(100,width-250); moguraY = random(100,height-250);
   image(mogura,moguraX,moguraY);
}

public boolean surfaceTouchEvent(MotionEvent e){
  super.surfaceTouchEvent(e);
  return gesture.surfaceTouchEvent(e);
}

void onTap(float x, float y){
  if(x >= width-100 && y <= 50){
    OnReset();
  }
}

void onPinch(float x, float y, float d){
  if(d < 0){
    range += 2000;
  }else if(d > 0){
    if(range > 0)
      range -= 2000;
  }
}