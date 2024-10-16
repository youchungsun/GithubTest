<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"        %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"          %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"      %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"   %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt"         %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>성신양회 착지 관리 시스템</title>
<LINK rel=apple-touch-icon href="/images/bi.ico" >
<LINK rel="shortcut icon" href="/images/bi.ico" >
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC0mqTfpFKUAYhk1f8ALZN6rlOy4tr_sTw&callback=initMap"></script>
<script src="/js/common.js"></script>

<script language="javascript" type="text/javascript">

    /* if (document.location.protocol == 'http:') {
        document.location.href = document.location.href.replace('http:', 'https:');
    } 11123432423423423432*/
         
</script>

<script type="text/javascript">   
    
$(document).ready(function () {
	
	
	$("#txtCardNo").focus();
	$("#txtCardNo").focus();
    	
	setTimeout(function () {
		$('#MainImage').fadeOut("slow");
	}, 3000);

	//0.5초마다 깜박임 설정
	var intervalID = setInterval(function () {
		$('#Wait').fadeToggle("fast");
		$('#Fail').hide();
	}, 500);

	// 구글 지오로케이션을 활용한 위치정보 가져오기
	function clickLocation() {
		if (navigator.geolocation) {
			function success(position) {				
				var latitude = position.coords.latitude;				
				var longitude = position.coords.longitude;				
				var latlng = new google.maps.LatLng(latitude, longitude);
				var myOptions = {
					zoom: 16,
					center: latlng,
					mapTypeId: google.maps.MapTypeId.ROADMAP
				}

				var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
				var marker = new google.maps.Marker({
					position: latlng,
					map: map
				});

				var geocoder = new google.maps.Geocoder();

					geocoder.geocode({ 'latLng': latlng },
						function (results, status) {
							if (status == google.maps.GeocoderStatus.OK) {

								//#은 iD 값과 동일하게 하여 데이터를 가져오는 방법
								// asp.net 에서는 별도의 변수에 값을 저장하여 사용 가능함 (별거 아니지만 이거 찾으려고 개고생 -_-)

								$('#address').html(results[0].formatted_address);
								$('#lat').html(results[0].geometry.location.lat());
								$('#lng').html(results[0].geometry.location.lng());
								$('#NowAddress').html(results[0].formatted_address);

								var address            = results[0].formatted_address;
									txtLatitude.value  = latitude;
									txtLongitude.value = longitude;
									txtAddress.value   = address;

								//                             new google.maps.InfoWindow({
								//                                 content: address 
								//                             }).open(map, new google.maps.Marker({
								//                                 position: latlng,
								//                                 map: map
								//                             }));
                          
								setTimeout(function () {
									clearInterval(intervalID);                                
								}, 100);
							} else {
								//                             alert("Geocoder failed due to: " + status);
								alert("위치정보를 가져오지 못했습니다. 다시 시도해 주세요");
								
								//5초 후 종료
								setTimeout(function () {
									clearInterval(intervalID);
									$('#Wait').hide();
									$('#Fail').fadeIn("slow");
								}, 5000);
							}
						});
						// 아래는 지도 클릭 시 정보를 가져오는 이벤트 
						///////////////////////////////////////////////////////////////
						//                    google.maps.event.addListener(map, 'click', function (event) {
						//                        var location = event.latLng;
						//                        geocoder.geocode({ 'latLng': location },
						//    	    	            function (results, status) {
						//    	    	                if (status == google.maps.GeocoderStatus.OK) {
						//    	    	                    $('#address').html(results[0].formatted_address);
						//    	    	                    $('#lat').html(results[0].geometry.location.lat());
						//    	    	                    $('#lng').html(results[0].geometry.location.lng());
						
						//    	    	                    var latitude = results[0].geometry.location.lat();
						//    	    	                    var longitude = results[0].geometry.location.lng();
						//    	    	                    var address = results[0].formatted_address;
						
						//    	    	                    txtLatitude.value = latitude;
						//    	    	                    txtLongitude.value = longitude;
						//    	    	                    txtAddress.value = address;
						//    	    	                }
						//    	    	                else {
						//    	    	                    alert("Geocoder failed due to: " + status);
						//    	    	                }
						//    	    	            });
						//                        if (!marker) {
						//                            marker = new google.maps.Marker({
						//                                position: location,
						//                                map: map
						//                            });
						//                        }
						//                        else {
						//                            marker.setMap(null);
						//                            marker = new google.maps.Marker({
						//                                position: location,
						//                                map: map
						//                            });
						//                        }
						//                        map.setCenter(location);
						//                    });
						// 여기까지
			}
                
			function error(errormsg) {
				//                    alert(errormsg);
				//alert("위치정보를 가져오지 못했습니다. 다시 시도해 주세요");
				setTimeout(function () {
					clearInterval(intervalID);
					$('#Wait').hide();
					$('#Fail').fadeIn("slow");
				}, 5000);
			}
			navigator.geolocation.getCurrentPosition(success, error);
		} else {
			alert("No support");
		}
	}

	//페이지 로드와 동시에 주소값을 가져오는 함수를 호출함        
	clickLocation();

	//저장 버튼을 클릭 시 숨겨놓은 이벤트 버튼과 프로그래스 바를 활성화 시킴
	$("#GeoSave").click(function () {
		if ($.trim($("#txtCardNo").val()).length == 0) {
			alert('카드번호를 입력해 주세요');
			return;
		}

		if ($.trim($("#txtCardNo").val()).length <= 3) {
			alert('카드번호 4자리를 입력해 주세요');
			return;
		}

		if ($.trim($("#txtAddress").val()).length == 0) {
			alert('위치정보를 가져오지 못했습니다. 다시 시도해 주세요');
			return;
		}

		//$('#BtnSave').trigger('click');
		layer_open('layer2');
		progress(100, $('#progressBar'));
            
		// 저장 전 입력한 카드번호 체크 로직
		var actionUrl     = "/geo/checkGeoSystem.do";
		var params = [];
			params.push( { "name":"txtCardNo"    , "value": $("#txtCardNo").val()    } );            
		var strCallbackNm = "callbackSearchCardNo";
		var asyncYn       = "false";
            
		setTimeout(function () {
			doSearchAjax( actionUrl, params, strCallbackNm , asyncYn);
		}, 2000);
	});

	//메인 이미지를 클릭 시 주소를 다시 가져옴
	$("#MainTitle").click(function () {
		//$('#BtnAddressRefresh').trigger('click');
		layer_open('layer2');
		refresh("2000");
		progress(100, $('#progressBar'));
	});
});


// 프로그래스 바를 작동하게 하는 펑션 (구글링)
// animate 오른쪽에 숫자가 클수록 진행 속도는 느려짐
function progress(percent, $element) {
	var progressBarWidth = percent * $element.width() / 100;
	$element.find('div').animate({ width: progressBarWidth }, 10000).html();
}

// 저장 클릭 시 팝업을 생성하는 펑션 (구글링)
function layer_open(el) {
	var temp = $('#' + el);
	var bg = temp.prev().hasClass('bg'); //dimmed 레이어를 감지하기 위한 boolean 변수
	
	if (bg) {
		$('.layer').fadeIn(); //'bg' 클래스가 존재하면 레이어가 나타나고 배경은 dimmed 된다. 
	} else {
		temp.fadeIn();
	}

	// 화면의 중앙에 레이어를 띄운다.
	if (temp.outerHeight() < $(document).height()) temp.css('margin-top', '-' + temp.outerHeight() / 2 + 'px');
	else temp.css('top', '0px');
	if (temp.outerWidth() < $(document).width()) temp.css('margin-left', '-' + temp.outerWidth() / 2 + 'px');
	else temp.css('left', '0px');

	temp.find('a.cbtn').click(function (e) {
		if (bg) {
			$('.layer').fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다. 
		} else {
			temp.fadeOut();
		}
		e.preventDefault();
	});

	//        $('.layer .bg').click(function (e) {	//배경을 클릭하면 레이어를 사라지게 하는 이벤트 핸들러
	//            $('.layer').fadeOut();
	//            e.preventDefault();
	//        });
}
    

function callbackSearchCardNo( jsonData ){
	var data       = jsonData.Data;
	var returnBool = jsonData.returnBool;
	var returnMsg  = "";
	var params     = jsonData.params;
    	
    	
	$("#txtCardNo").val( params.txtCardNo );
  	
	if( returnBool == "False" ) {
		returnMsg  = jsonData.returnMsg;
		alert( returnMsg );
		$("#txtCardNo").css("background-color" , "LightPink");
		
		// 프로그래스바를 초기화 호출
		fClearEvent();
	} else {    		
		var actionUrl     = "/geo/saveGeoSystem.do";
		var params = [];
			params.push( { "name":"txtCardNo"    , "value": $("#txtCardNo").val()    } );
			params.push( { "name":"txtLatitude"  , "value": $("#txtLatitude").val()  } );
			params.push( { "name":"txtLongitude" , "value": $("#txtLongitude").val() } );
			params.push( { "name":"txtAddress"   , "value": $("#txtAddress").val()   } );
        
		var strCallbackNm = "callbackSaveCardNo";
		var asyncYn       = "false";
		
		doSearchAjax( actionUrl, params, strCallbackNm , asyncYn);
	}
}

// 저장 후 콜백 함수
function callbackSaveCardNo( jsonData ){
	var returnBool = jsonData.returnResult.returnBool;
	var returnMsg  = jsonData.returnResult.returnMsg;
	
	if( returnBool == "True" ) {
		alert( returnMsg );
		location.href="http://m.naver.com";
	} else {
		alert( returnMsg );
		fClearEvent();
		$("#txtCardNo").css("background-color" , "LightPink");
	}
}

// 새로고침
function refresh( val ){
	setTimeout(function () {
		location.reload();
	}, val);
}
    
// 프로그래스바를 초기화 한다.
function fClearEvent() {
	$('.layer').fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다.
	$('#progressBar').empty().append("<div></div>");	// animate를 초기화
}


</script> 

<style type="text/css">
    
.LineHeight
{
    line-height:0.5em
} 

.map{
  height:100%;
}

.Geo
{
border:1px solid #83A0D4; -webkit-border-radius: 0px; -moz-border-radius: 0px;border-radius: 0px;font-size:30px;font-family:arial, helvetica, sans-serif; padding: 15px 15px 15px 15px; text-decoration:none; ;text-shadow: 1px 1px 0 rgba(0,0,0,0.3);font-weight:bold; color: #FFFFFF;
 background-color: #16A5F7; background-image: -webkit-gradient(linear, left top, left bottom, from(#16A5F7), to(#0A5A8F));
 background-image: -webkit-linear-gradient(top, #16A5F7, #0A5A8F);
 background-image: -moz-linear-gradient(top, #16A5F7, #0A5A8F);
 background-image: -ms-linear-gradient(top, #16A5F7, #0A5A8F);
 background-image: -o-linear-gradient(top, #16A5F7, #0A5A8F);
 background-image: linear-gradient(to bottom, #16A5F7, #0A5A8F);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#16A5F7, endColorstr=#0A5A8F)
 width = "100%";
 text-align: center; 
 
 
}
.NowAddress
{
 border:0px solid #2a2c2f;-webkit-box-shadow: #FFFFFF 0px 0px 10px inset;-moz-box-shadow: #FFFFFF 0px 0px 10px inset; box-shadow: #FFFFFF 0px 0px 10px inset; -webkit-border-radius: 0px; -moz-border-radius: 0px;border-radius: 0px;font-size:12px; font-family:굴림; padding: 5px 5px 5px 5px; text-decoration:none;  color: #FFFFFF;
 background-color: #45484d; background-image: -webkit-gradient(linear, left top, left bottom, from(#45484d), to(#000000));
 background-image: -webkit-linear-gradient(top, #45484d, #000000);
 background-image: -moz-linear-gradient(top, #45484d, #000000);
 background-image: -ms-linear-gradient(top, #45484d, #000000);
 background-image: -o-linear-gradient(top, #45484d, #000000);
 background-image: linear-gradient(to bottom, #45484d, #000000);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#45484d, endColorstr=#000000);
 width = "100%";
 text-align: center; 
}
.MainTitle
{
 border:1px solid #83A0D4; -webkit-border-radius: 0px; -moz-border-radius: 0px;border-radius: 0px;font-size:22px;font-family:arial, helvetica, sans-serif; padding: 6px 6px 6px 6px; text-decoration:none; ;text-shadow: 1px 1px 0 rgba(0,0,0,0.3);font-weight:bold; color: #FFFFFF;
 background-color: #16A5F7; background-image: -webkit-gradient(linear, left top, left bottom, from(#16A5F7), to(#0A5A8F));
 background-image: -webkit-linear-gradient(top, #16A5F7, #0A5A8F);
 background-image: -moz-linear-gradient(top, #16A5F7, #0A5A8F);
 background-image: -ms-linear-gradient(top, #16A5F7, #0A5A8F);
 background-image: -o-linear-gradient(top, #16A5F7, #0A5A8F);
 background-image: linear-gradient(to bottom, #16A5F7, #0A5A8F);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#16A5F7, endColorstr=#0A5A8F)
 width = "100%";
 text-align: center; 
}

.Card
{
 border:5px solid #16A5F7; -webkit-border-radius: 0px; -moz-border-radius: 0px;border-radius: 0px;font-size:22px;font-family:arial, helvetica, sans-serif; padding: 6px 6px 6px 6px; text-decoration:none; ;text-shadow: 1px 1px 0 rgba(0,0,0,0.3);font-weight:bold; color: #1F1F1F;
 background-color: #FFFFFF; background-image: -webkit-gradient(linear, left top, left bottom, from(#16A5F7), to(#0A5A8F));
 background-image: -webkit-linear-gradient(top, #FFFFFF, #FFFFFF);
 background-image: -moz-linear-gradient(top, #FFFFFF, #FFFFFF);
 background-image: -ms-linear-gradient(top, #FFFFFF, #FFFFFF);
 background-image: -o-linear-gradient(top, #FFFFFF, #FFFFFF);
 background-image: linear-gradient(to bottom, #FFFFFF, #FFFFFF);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#16A5F7, endColorstr=#0A5A8F)
 width = "100%";
 text-align: center; 
}


#progressBar {
        width: 100%;
        height: 22px;
        background-color: #DFDFDF;
}
 
#progressBar div {
        height: 100%;
        color: #fff;
        text-align: right;
        line-height: 22px; /* same as #progressBar height if we want text middle aligned */
        width: 0;
        background-color: #16A5F7;
}


#MainImage {
        position:fixed; _position:absolute; top:0; left:0; width:100%; height:100%; z-index:100;
        
}



.layer {display:none; position:fixed; _position:absolute; top:0; left:0; width:100%; height:100%; z-index:100;}
		.layer {display:none; position:fixed; _position:absolute; top:0; left:0; width:100%; height:100%; z-index:100;}
		.layer .bg {position:absolute; top:0; left:0; width:100%; height:100%; background:#000; opacity:.5; filter:alpha(opacity=50);}
		.layer .pop-layer {display:block;}

	.pop-layer {display:none; position: absolute; top: 50%; left: 50%; width: 95%; height:auto;  background-color:#fff; border: 5px solid #3571B5; z-index: 10;}	
	.pop-layer .pop-container {padding: 20px 25px;}
	.pop-layer p.ctxt {color: #666; line-height: 25px;}
	.pop-layer .btn-r {width: 100%; margin:10px 0 20px; padding-top: 10px; border-top: 1px solid #DDD; text-align:right;}

	a.cbtn {display:inline-block; height:25px; padding:0 14px 0; border:1px solid #304a8a; background-color:#3f5a9d; font-size:13px; color:#fff; line-height:25px;}	
	a.cbtn:hover {border: 1px solid #091940; background-color:#1f326a; color:#fff;}

</style>

</head>
<body>
	<form id="form1" name="form1" method="post">
		<div id="MainTitle" class="MainTitle">착지관리 시스템</div>
		<div id="NowAddress" class="NowAddress"></div>
		<div id="LineHeight" class="LineHeight">
			<tr><td width="1%" valign="top" align="left">&nbsp;</td></tr>
		</div>

		<table id="GeoETC" border="0" width="100%" class="Card">
			<tr>
				<td>
					<th align="center" Width="50%"><span id="Label1" Font-Size="20pt" Font-Bold="True" Width="80%">카드번호</span></th>
					<th align="center" Width="43%">
						<input type="number" name="txtCardNo" id="txtCardNo" maxlength="4" style="font-size:22pt;font-weight:bold;width:100%;text-align:center;" pattern="[0-9]*" inputmode="numeric" min="0" />
					</th>
					<th align="center" Width="7%"></th>
				</td>
			</tr>
		</table>

		<div id="Div1" class="LineHeight">
			<tr><td width="1%" valign="top" align="left">&nbsp;</td></tr>
		</div>

		<div id="GeoSave" class="Geo">도 착 완 료</div>

		<%-- 한줄띄기 --%>
		<div id="Div2" class="LineHeight">
			<tr><td width="1%" valign="top" align="left">&nbsp;</td></tr>
		</div>

		<table id="GeoMap" border="0" width="100%">
			<tr>
				<td colspan="2">
					<div id="map_canvas" style="border: thin solid #302D27; width: 100%; height: 250px;" class="map">
						<div id="Wait"><IMG src="/images/Wait.JPG" width="100%"></div>
						<div id="Fail"><IMG src="/images/Fail.JPG" width="100%"></div>
						<br />
					</div>
				</td>
			</tr>
		</table>

		<div id="Hidden" style="visibility: " dir="ltr">
			<table id="GeoValue" border="0" width="100%">
				<tr>
					<input type="hidden" id="txtLatitude"  name="txtLatitude"  />
					<input type="hidden" id="txtLongitude" name="txtLongitude" />
					<input type="hidden" id="txtAddress"   name="txtAddress"   />
				</tr>
			</table>
		</div>

		<a href="#" class="btn-example" onclick="layer_open('layer2');return false;"></a>
		<div class="layer">
			<div class="bg"></div>
			<div id="layer2" class="pop-layer">
				<div class="pop-container">
					<div class="pop-conts">
						<!--content //-->
						<p class="ctxt mb20">처리 중입니다. 잠시만 기다려 주세요.<br>
						<div id="progressBar">
							<div></div>
						</div>
						</p>
					</div>
				</div>
			</div>
		</div>

		<div id="MainImage"><IMG src="/images/Main.JPG"></div>

	</form>
</body>
</html>