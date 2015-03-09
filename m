Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 816EA7F3F
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 10:50:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 328DB30404E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 08:50:48 -0700 (PDT)
Received: from mail.rvx.is (mail.rvx.is [178.19.51.189]) by cuda.sgi.com with
	ESMTP id Hcugi7AAXFsxw5gj (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 08:50:43 -0700 (PDT)
Date: Mon, 9 Mar 2015 15:50:40 +0000 (GMT)
From: Rui Gomes <rgomes@rvx.is>
Message-ID: <1145328183.409860.1425916240318.JavaMail.zimbra@rvx.is>
Subject: xfs_repair segfault
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_409854_2088855061.1425916240313"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: =?utf-8?B?w5NtYXI=?= Hermannsson <omar@rvx.is>

------=_Part_409854_2088855061.1425916240313
Content-Type: multipart/alternative;
	boundary="----=_Part_409855_120350181.1425916240313"

------=_Part_409855_120350181.1425916240313
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello Guys, 

I have a XFS filesystem that went rough, the file system got corrupted without any hardware failure or power outage what is strange enough. 
But after trying to run xfs_repair it segmented fault, this system was originally CentOs6.5, we upgraded to Centos7 using xfsprogs-3.2.0-0.10.alpha2.el7.x86_64, and run the newer version of the xfs_repair, same result segmentation fault. 


Full output and GDB Backtrace in the attachment, do you guys have any advice how can we get xfs_repair to do a clean run? 



Regards 

------------------------------- 
Rui Gomes 
CTO 


RVX - Reykjavik Visual Effects 
Seljavegur 2, 
101 Reykjavik 
Iceland 


Tel: + 354 527 3330 
Mob: + 354 663 3360 

------=_Part_409855_120350181.1425916240313
Content-Type: multipart/related;
	boundary="----=_Part_409856_847653372.1425916240313"

------=_Part_409856_847653372.1425916240313
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"font-family: arial, helvetica, sans-serif; font-s=
ize: 12pt; color: #000000"><div>Hello Guys,&nbsp;</div><div><br data-mce-bo=
gus=3D"1"></div><div>I have a XFS filesystem that went rough, the file syst=
em got corrupted&nbsp;without any hardware failure or power outage what is =
strange enough.</div><div>But after trying to run xfs_repair it segmented f=
ault, this system was originally CentOs6.5, we upgraded to Centos7 using xf=
sprogs-3.2.0-0.10.alpha2.el7.x86_64, and run the newer version of the xfs_r=
epair, same result segmentation fault.</div><div><br data-mce-bogus=3D"1"><=
/div><div><br data-mce-bogus=3D"1"></div><div>Full output and GDB&nbsp;Back=
trace in the attachment, do you guys have any advice how can we get xfs_rep=
air to do a clean run?</div><div><br></div><div><br data-mce-bogus=3D"1"></=
div><div><br></div><div data-marker=3D"__SIG_PRE__"><div style=3D"color: #0=
00000; font-family: 'times new roman', 'new york', times, serif; font-size:=
 16px; font-style: normal; font-variant: normal; font-weight: normal; lette=
r-spacing: normal; line-height: normal; orphans: auto; text-align: start; t=
ext-indent: 0px; text-transform: none; white-space: normal; widows: auto; w=
ord-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #fdfdfd=
;" data-mce-style=3D"color: #000000; font-family: 'times new roman', 'new y=
ork', times, serif; font-size: 16px; font-style: normal; font-variant: norm=
al; font-weight: normal; letter-spacing: normal; line-height: normal; orpha=
ns: auto; text-align: start; text-indent: 0px; text-transform: none; white-=
space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: =
0px; background-color: #fdfdfd;">Regards<br><div style=3D"font-family: Cali=
bri, sans-serif; font-size: 14px;" data-mce-style=3D"font-family: Calibri, =
sans-serif; font-size: 14px;"><strong style=3D"font-family: Arial; font-siz=
e: 10px;" data-mce-style=3D"font-family: Arial; font-size: 10px;"><br class=
=3D"Apple-interchange-newline">-------------------------------</strong></di=
v><div style=3D"font-family: Helvetica; font-size: medium;" data-mce-style=
=3D"font-family: Helvetica; font-size: medium;"><div><strong style=3D"font-=
family: Arial;" data-mce-style=3D"font-family: Arial;"><span style=3D"font-=
size: x-small;" data-mce-style=3D"font-size: x-small;">Rui Gomes</span></st=
rong></div><div><span style=3D"font-size: x-small;" data-mce-style=3D"font-=
size: x-small;">CTO</span></div><div><span style=3D"font-size: x-small;" da=
ta-mce-style=3D"font-size: x-small;">&nbsp;</span></div></div></div><div st=
yle=3D"color: #000000; font-family: 'times new roman', 'new york', times, s=
erif; font-size: 16px; font-style: normal; font-variant: normal; font-weigh=
t: normal; letter-spacing: normal; line-height: normal; orphans: auto; text=
-align: start; text-indent: 0px; text-transform: none; white-space: normal;=
 widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; backgroun=
d-color: #fdfdfd;" data-mce-style=3D"color: #000000; font-family: 'times ne=
w roman', 'new york', times, serif; font-size: 16px; font-style: normal; fo=
nt-variant: normal; font-weight: normal; letter-spacing: normal; line-heigh=
t: normal; orphans: auto; text-align: start; text-indent: 0px; text-transfo=
rm: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-tex=
t-stroke-width: 0px; background-color: #fdfdfd;"><br></div><div style=3D"co=
lor: #000000; font-family: 'times new roman', 'new york', times, serif; fon=
t-size: 16px; font-style: normal; font-variant: normal; font-weight: normal=
; letter-spacing: normal; line-height: normal; orphans: auto; text-align: s=
tart; text-indent: 0px; text-transform: none; white-space: normal; widows: =
auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: =
#fdfdfd;" data-mce-style=3D"color: #000000; font-family: 'times new roman',=
 'new york', times, serif; font-size: 16px; font-style: normal; font-varian=
t: normal; font-weight: normal; letter-spacing: normal; line-height: normal=
; orphans: auto; text-align: start; text-indent: 0px; text-transform: none;=
 white-space: normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-=
width: 0px; background-color: #fdfdfd;"><img src=3D"cid:6afed02bc68e74babda=
273cb39990210068d863d@zimbra" data-mce-src=3D"https://mail.rvx.is/home/rgom=
es@rvx.is/Briefcase/rvx-logo.png" doc=3D"Briefcase/rvx-logo.png"><br class=
=3D"Apple-interchange-newline"><div style=3D"font-size: medium; font-family=
: Calibri;" data-mce-style=3D"font-size: medium; font-family: Calibri;"><st=
rong><span style=3D"font-family: Arial;" data-mce-style=3D"font-family: Ari=
al;"><span style=3D"font-family: Helvetica; font-size: x-small;" data-mce-s=
tyle=3D"font-family: Helvetica; font-size: x-small;">RVX - Reykjavik Visual=
 Effects</span></span></strong><div style=3D"font-family: Calibri, sans-ser=
if;" data-mce-style=3D"font-family: Calibri, sans-serif;"><div><span style=
=3D"font-family: Arial;" data-mce-style=3D"font-family: Arial;">Seljavegur =
2,&nbsp;</span><div><span style=3D"font-family: Helvetica;" data-mce-style=
=3D"font-family: Helvetica;"><span style=3D"font-family: Arial;" data-mce-s=
tyle=3D"font-family: Arial;">101 Reykjavik<br>Iceland</span></span></div><d=
iv><span style=3D"font-family: Helvetica;" data-mce-style=3D"font-family: H=
elvetica;"><span style=3D"font-family: Arial;" data-mce-style=3D"font-famil=
y: Arial;"><br></span></span></div><div><span style=3D"font-family: Helveti=
ca;" data-mce-style=3D"font-family: Helvetica;"><span style=3D"font-family:=
 Arial;" data-mce-style=3D"font-family: Arial;"><span style=3D"color: #00cc=
ff;" data-mce-style=3D"color: #00ccff;"><a target=3D"_blank" title=3D"http:=
//www.rvx.is" href=3D"http://www.rvx.is" data-mce-href=3D"http://www.rvx.is=
"><span style=3D"font-family: Arial;" data-mce-style=3D"font-family: Arial;=
"></span></a></span><br></span></span></div><span style=3D"font-family: Hel=
vetica;" data-mce-style=3D"font-family: Helvetica;"><span style=3D"font-fam=
ily: Arial;" data-mce-style=3D"font-family: Arial;">Tel: +<span class=3D"Ap=
ple-converted-space">&nbsp;</span><span class=3D"Object" id=3D"OBJ_PREFIX_D=
WT239_com_zimbra_phone" style=3D"color: #336699; text-decoration: none; cur=
sor: pointer;" data-mce-style=3D"color: #336699; text-decoration: none; cur=
sor: pointer;"><a href=3D"callto:354 527 3330" style=3D"color: #336699; tex=
t-decoration: none; cursor: pointer;" data-mce-href=3D"callto:354 527 3330"=
 data-mce-style=3D"color: #336699; text-decoration: none; cursor: pointer;"=
>354 527 3330</a></span></span></span><br data-mce-bogus=3D"1"></div><div><=
span style=3D"font-family: Helvetica;" data-mce-style=3D"font-family: Helve=
tica;"><span style=3D"font-family: Arial;" data-mce-style=3D"font-family: A=
rial;">Mob: +<span class=3D"Apple-converted-space">&nbsp;</span><span class=
=3D"Object" id=3D"OBJ_PREFIX_DWT240_com_zimbra_phone" style=3D"color: #3366=
99; text-decoration: none; cursor: pointer;" data-mce-style=3D"color: #3366=
99; text-decoration: none; cursor: pointer;"><a href=3D"callto:354 663 3360=
" style=3D"color: #336699; text-decoration: none; cursor: pointer;" data-mc=
e-href=3D"callto:354 663 3360" data-mce-style=3D"color: #336699; text-decor=
ation: none; cursor: pointer;">354 663 3360</a></span></span></span><br dat=
a-mce-bogus=3D"1"></div></div></div></div></div></div></body></html>
------=_Part_409856_847653372.1425916240313
Content-Type: image/png; name=rvx-logo.png
Content-Disposition: attachment; filename=rvx-logo.png
Content-Transfer-Encoding: base64
Content-ID: <6afed02bc68e74babda273cb39990210068d863d@zimbra>

iVBORw0KGgoAAAANSUhEUgAAAFAAAAAiCAYAAADI+15nAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJ
bWFnZVJlYWR5ccllPAAAAyRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdp
bj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6
eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0
NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJo
dHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlw
dGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAv
IiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RS
ZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpD
cmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoTWFjaW50b3NoKSIgeG1wTU06SW5zdGFu
Y2VJRD0ieG1wLmlpZDpCQTE4QkE3RDRFQTUxMUUzODA5RkEyQzM3OEM2ODkzMiIgeG1wTU06RG9j
dW1lbnRJRD0ieG1wLmRpZDpCQTE4QkE3RTRFQTUxMUUzODA5RkEyQzM3OEM2ODkzMiI+IDx4bXBN
TTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkJBMThCQTdCNEVBNTExRTM4
MDlGQTJDMzc4QzY4OTMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOkJBMThCQTdDNEVBNTEx
RTM4MDlGQTJDMzc4QzY4OTMyIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4
bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+caZpBAAABSRJREFUeNq0WnmIT0Ecn3Wz68yROy1y
FUKiROTIFWuVyJIjJHfK8Yc7W87kKvdVqw3lyFJuZWn9wbrXuo9Y5L5ZMzWPz05v5s28+frW94/f
e5/vd+Z93sx8j/djjLHfXAsd9BfXAq65XLdyHcC1JIuWPdJejNeb0UkS11fS9xeuCcr9djD3N1zr
eIw1Avi6F1wsJNBHXIdGDJ4G+L2EBA4Dv1kazH7AZMYcpyq8KKFDdAS+43raoBe43tGs3C1ci2sm
UFGukGClJBEReAjGH6nB1Of6GXC9YoyzGexP4g2VhB9cW1g4rCTffo5iv9Zgsw9wwwjIEy/lm/T3
Tf7WyRwY+y7XMg7jdADb71ybmAgUeibkLNFJMa4LFPtuGmwqYA4REDgc/B2IwJbiegvw8yzHKMH1
Ctilq4Dgxitlj7uukE1ge06DKcv1A6z0KoTbd4gFvjvgv3JNtrCZCjYPuSbqCHzAdTT8fhGxJVSp
oZwzdTW4XYAZ60FeZdi+H7mWs7TLtAg6gdTk+h7wKWEgJDBBBong2pr/sCJ6A+aEB4H4sjMc7MSL
/QS2qQZsBuCO6kBIoJDWMtcT135ybeUwuXngb64GI3LG15BT1opJYBaM1c/RdhbYPtZkBNbbXSVQ
yDq4fsEhoEwBu6UG3EbATY5BXhV5hgr7t1xLO9qLgHID5rBMuS/83Yb7C0zOwgisJM/A4N6oGG92
jgHXBXDZntt3S8wV3NWQus2Fe/lRKU8YgWrlUGAZMbeDzZiI1OcZYBs4PvwxsO3ucY5mKJlDgpzL
F7jeJ8qJjkDh7Dzc32ixLZCU5hH4lYCd5fDQ1eGMfmmofGykNqRVhbLWPeKQWxoJFNJSBpKgCdDW
8vy7Y3Futgf8VYeHHm9Z9djKTPCH0fmzLAG9CBSyGjA5cvup0kNGqgA3wXLy+WDT1NLmBNh0IiCw
pBJQbM5wJwIrcH0OuPFwT6Qgq2CVBlG7hOXYS8BukeP2feSQHURJZ4W8W/JIIiFQbRm9kX3ASyEd
mWtcqzlMvAXY5jlu3+WELbG6yg467GJsQ2CCbDCYeoIbuJaPMflc8NEmAnvWAesimSHP04eSQCaj
6g9lkJsymjb2mDy2mVYYcLVgxecRktdLsyDuyeYHGYFMZuwB/orDWWeSZFa0s11Mg5vkeF7aSGn5
MgK/65Xfi6gJFFv0qWcZFibZFpH1HGCaEY2LFcdT+Xy4IkW3pxElgUx2WbD9X4PgQaYpq8C0fXOJ
yFMrjsGaM/E4NYFqLrab4GGQoLDqAgmeTUTgQfB5LCQqf9SQS0Kg+CbwHWw7EzzQKab/6INbPJlg
rL5Kq6phRIXyxJRhxCFQSLqS//kGlHHgbxtcr+fZuVFFRNb74HO+oUK5Zmh5eROYKJuRgf1MzwfD
Ht876PHNgDGmExC4kNl/ncMK5SfTfK2MS6AQ/Mr2QXY3fAQ7IQOV7fubxe9eB9JQqTh6WtjsBPzZ
sPLRh0Ah2Fr3/ccBfqbMkJESP7X6Cs7V9h8KIst4C3Zp1AQ2Yv++jvk2OJNY0X8vLNY0MeJIisdu
mciKfq2sTEmg2lVx6mRE1KVBpBdnY1UPn4myyol7loq06jLYr6MmsJy0d+6lhcigkLo0y3P1pROU
oO0hVxUttbaUBArpz2J0c0OkjIzChaZzxyNn7ejhC78mXgzqdioC1Si638PPDqUerejhC6umzQSp
VoF6Lgd/x7hO1FnBv0K0jumnK2yXXR7z6QJzeeZ5jmKm8Lfs/CPAAAAzyyAUt8eVAAAAAElFTkSu
QmCC
------=_Part_409856_847653372.1425916240313--

------=_Part_409855_120350181.1425916240313--

------=_Part_409854_2088855061.1425916240313
Content-Type: text/plain; name=gdb.txt
Content-Disposition: attachment; filename=gdb.txt
Content-Transfer-Encoding: base64

U3RhcnRpbmcgcHJvZ3JhbTogL3Vzci9zYmluL3hmc19yZXBhaXIgLW4gLVAgLW0gNTAwMDAwMDAw
MDAwMDAwIC9kZXYvc2RiMQpbVGhyZWFkIGRlYnVnZ2luZyB1c2luZyBsaWJ0aHJlYWRfZGIgZW5h
YmxlZF0KVXNpbmcgaG9zdCBsaWJ0aHJlYWRfZGIgbGlicmFyeSAiL2xpYjY0L2xpYnRocmVhZF9k
Yi5zby4xIi4KW05ldyBUaHJlYWQgMHg3ZmZmYjBlYzk3MDAgKExXUCAxNjE1MSldCltOZXcgVGhy
ZWFkIDB4N2ZmZmIwNmM4NzAwIChMV1AgMTYxNTIpXQpbTmV3IFRocmVhZCAweDdmZmZhZmVjNzcw
MCAoTFdQIDE2MTUzKV0KW05ldyBUaHJlYWQgMHg3ZmZmYWY2YzY3MDAgKExXUCAxNjE1NCldCltO
ZXcgVGhyZWFkIDB4N2ZmZmFlZWM1NzAwIChMV1AgMTYxNTUpXQpbTmV3IFRocmVhZCAweDdmZmZh
ZTZjNDcwMCAoTFdQIDE2MTU2KV0KW05ldyBUaHJlYWQgMHg3ZmZmYWRlYzM3MDAgKExXUCAxNjE1
NyldCltOZXcgVGhyZWFkIDB4N2ZmZmFkNmMyNzAwIChMV1AgMTYxNTgpXQpbTmV3IFRocmVhZCAw
eDdmZmZhY2VjMTcwMCAoTFdQIDE2MTU5KV0KW05ldyBUaHJlYWQgMHg3ZmZmYWM2YzA3MDAgKExX
UCAxNjE2MCldCltOZXcgVGhyZWFkIDB4N2ZmZmFiZWJmNzAwIChMV1AgMTYxNjEpXQpbTmV3IFRo
cmVhZCAweDdmZmZhYjZiZTcwMCAoTFdQIDE2MTYyKV0KW05ldyBUaHJlYWQgMHg3ZmZmYWFlYmQ3
MDAgKExXUCAxNjE2MyldCltOZXcgVGhyZWFkIDB4N2ZmZmFhNmJjNzAwIChMV1AgMTYxNjQpXQpb
TmV3IFRocmVhZCAweDdmZmZhOWViYjcwMCAoTFdQIDE2MTY1KV0KW05ldyBUaHJlYWQgMHg3ZmZm
YTk2YmE3MDAgKExXUCAxNjE2NildCltOZXcgVGhyZWFkIDB4N2ZmZmE4ZWI5NzAwIChMV1AgMTYx
NjcpXQpbTmV3IFRocmVhZCAweDdmZmZhODZiODcwMCAoTFdQIDE2MTY4KV0KW05ldyBUaHJlYWQg
MHg3ZmZmYTdlYjc3MDAgKExXUCAxNjE2OSldCltOZXcgVGhyZWFkIDB4N2ZmZmE3NmI2NzAwIChM
V1AgMTYxNzApXQpbTmV3IFRocmVhZCAweDdmZmZhNmViNTcwMCAoTFdQIDE2MTcxKV0KW05ldyBU
aHJlYWQgMHg3ZmZmYTY2YjQ3MDAgKExXUCAxNjE3MildCltOZXcgVGhyZWFkIDB4N2ZmZmE1ZWIz
NzAwIChMV1AgMTYxNzMpXQpbTmV3IFRocmVhZCAweDdmZmZhNTZiMjcwMCAoTFdQIDE2MTc0KV0K
W05ldyBUaHJlYWQgMHg3ZmZmYTRlYjE3MDAgKExXUCAxNjE3NSldCltOZXcgVGhyZWFkIDB4N2Zm
ZmE0NmIwNzAwIChMV1AgMTYxNzYpXQpbTmV3IFRocmVhZCAweDdmZmZhM2VhZjcwMCAoTFdQIDE2
MTc3KV0KW05ldyBUaHJlYWQgMHg3ZmZmYTM2YWU3MDAgKExXUCAxNjE3OCldCltOZXcgVGhyZWFk
IDB4N2ZmZmEyZWFkNzAwIChMV1AgMTYxNzkpXQpbTmV3IFRocmVhZCAweDdmZmZhMjZhYzcwMCAo
TFdQIDE2MTgwKV0KW05ldyBUaHJlYWQgMHg3ZmZmYTFlYWI3MDAgKExXUCAxNjE4MSldCltOZXcg
VGhyZWFkIDB4N2ZmZmExNmFhNzAwIChMV1AgMTYxODIpXQpbVGhyZWFkIDB4N2ZmZmFjNmMwNzAw
IChMV1AgMTYxNjApIGV4aXRlZF0KW1RocmVhZCAweDdmZmZhODZiODcwMCAoTFdQIDE2MTY4KSBl
eGl0ZWRdCltUaHJlYWQgMHg3ZmZmYWNlYzE3MDAgKExXUCAxNjE1OSkgZXhpdGVkXQpbVGhyZWFk
IDB4N2ZmZmE3NmI2NzAwIChMV1AgMTYxNzApIGV4aXRlZF0KW1RocmVhZCAweDdmZmZhNTZiMjcw
MCAoTFdQIDE2MTc0KSBleGl0ZWRdCltUaHJlYWQgMHg3ZmZmYTZlYjU3MDAgKExXUCAxNjE3MSkg
ZXhpdGVkXQpbVGhyZWFkIDB4N2ZmZmE5NmJhNzAwIChMV1AgMTYxNjYpIGV4aXRlZF0KW1RocmVh
ZCAweDdmZmZhOWViYjcwMCAoTFdQIDE2MTY1KSBleGl0ZWRdCltUaHJlYWQgMHg3ZmZmYWE2YmM3
MDAgKExXUCAxNjE2NCkgZXhpdGVkXQpbVGhyZWFkIDB4N2ZmZmFiZWJmNzAwIChMV1AgMTYxNjEp
IGV4aXRlZF0KW1RocmVhZCAweDdmZmZhYjZiZTcwMCAoTFdQIDE2MTYyKSBleGl0ZWRdCltUaHJl
YWQgMHg3ZmZmYTRlYjE3MDAgKExXUCAxNjE3NSkgZXhpdGVkXQpbVGhyZWFkIDB4N2ZmZmExNmFh
NzAwIChMV1AgMTYxODIpIGV4aXRlZF0KW1RocmVhZCAweDdmZmZhOGViOTcwMCAoTFdQIDE2MTY3
KSBleGl0ZWRdCltUaHJlYWQgMHg3ZmZmYTVlYjM3MDAgKExXUCAxNjE3MykgZXhpdGVkXQpbVGhy
ZWFkIDB4N2ZmZmEyZWFkNzAwIChMV1AgMTYxNzkpIGV4aXRlZF0KW1RocmVhZCAweDdmZmZhZTZj
NDcwMCAoTFdQIDE2MTU2KSBleGl0ZWRdCltUaHJlYWQgMHg3ZmZmYWRlYzM3MDAgKExXUCAxNjE1
NykgZXhpdGVkXQpbVGhyZWFkIDB4N2ZmZmE3ZWI3NzAwIChMV1AgMTYxNjkpIGV4aXRlZF0KW1Ro
cmVhZCAweDdmZmZhZWVjNTcwMCAoTFdQIDE2MTU1KSBleGl0ZWRdCltUaHJlYWQgMHg3ZmZmYWQ2
YzI3MDAgKExXUCAxNjE1OCkgZXhpdGVkXQpbVGhyZWFkIDB4N2ZmZmExZWFiNzAwIChMV1AgMTYx
ODEpIGV4aXRlZF0KW1RocmVhZCAweDdmZmZiMGVjOTcwMCAoTFdQIDE2MTUxKSBleGl0ZWRdCltU
aHJlYWQgMHg3ZmZmYWZlYzc3MDAgKExXUCAxNjE1MykgZXhpdGVkXQpbVGhyZWFkIDB4N2ZmZmEy
NmFjNzAwIChMV1AgMTYxODApIGV4aXRlZF0KW1RocmVhZCAweDdmZmZiMDZjODcwMCAoTFdQIDE2
MTUyKSBleGl0ZWRdCltUaHJlYWQgMHg3ZmZmYWFlYmQ3MDAgKExXUCAxNjE2MykgZXhpdGVkXQpb
VGhyZWFkIDB4N2ZmZmEzZWFmNzAwIChMV1AgMTYxNzcpIGV4aXRlZF0KW1RocmVhZCAweDdmZmZh
NjZiNDcwMCAoTFdQIDE2MTcyKSBleGl0ZWRdCltUaHJlYWQgMHg3ZmZmYWY2YzY3MDAgKExXUCAx
NjE1NCkgZXhpdGVkXQpbVGhyZWFkIDB4N2ZmZmE0NmIwNzAwIChMV1AgMTYxNzYpIGV4aXRlZF0K
W1RocmVhZCAweDdmZmZhMzZhZTcwMCAoTFdQIDE2MTc4KSBleGl0ZWRdCgpQcm9ncmFtIHJlY2Vp
dmVkIHNpZ25hbCBTSUdBQlJULCBBYm9ydGVkLgoweDAwMDA3ZmZmZjc0Mjc1YzkgaW4gX19HSV9y
YWlzZSAoc2lnPXNpZ0BlbnRyeT02KSBhdCAuLi9ucHRsL3N5c2RlcHMvdW5peC9zeXN2L2xpbnV4
L3JhaXNlLmM6NTYKNTYJICByZXR1cm4gSU5MSU5FX1NZU0NBTEwgKHRna2lsbCwgMywgcGlkLCBz
ZWxmdGlkLCBzaWcpOwojMCAgMHgwMDAwN2ZmZmY3NDI3NWM5IGluIF9fR0lfcmFpc2UgKHNpZz1z
aWdAZW50cnk9NikgYXQgLi4vbnB0bC9zeXNkZXBzL3VuaXgvc3lzdi9saW51eC9yYWlzZS5jOjU2
CiMxICAweDAwMDA3ZmZmZjc0MjhjZDggaW4gX19HSV9hYm9ydCAoKSBhdCBhYm9ydC5jOjkwCiMy
ICAweDAwMDA3ZmZmZjc0NjdkYjcgaW4gX19saWJjX21lc3NhZ2UgKGRvX2Fib3J0PWRvX2Fib3J0
QGVudHJ5PTIsIGZtdD1mbXRAZW50cnk9MHg3ZmZmZjc1NmY1NjEgIioqKiAlcyAqKio6ICVzIHRl
cm1pbmF0ZWRcbiIpIGF0IC4uL3N5c2RlcHMvdW5peC9zeXN2L2xpbnV4L2xpYmNfZmF0YWwuYzox
OTYKIzMgIDB4MDAwMDdmZmZmNzRmZjljNyBpbiBfX0dJX19fZm9ydGlmeV9mYWlsIChtc2c9bXNn
QGVudHJ5PTB4N2ZmZmY3NTZmNTA3ICJidWZmZXIgb3ZlcmZsb3cgZGV0ZWN0ZWQiKSBhdCBmb3J0
aWZ5X2ZhaWwuYzozMQojNCAgMHgwMDAwN2ZmZmY3NGZkYjkwIGluIF9fR0lfX19jaGtfZmFpbCAo
KSBhdCBjaGtfZmFpbC5jOjI4CiM1ICAweDAwMDAwMDAwMDA0MTRlYTggaW4gbWVtbW92ZSAoX19s
ZW49MTg0NDY3NDQwNzM3MDk1NTE2MTUsIF9fc3JjPTB4MWU1NjIwOTQsIF9fZGVzdD0weDdmZmZm
ZmZmZDhmMCkgYXQgL3Vzci9pbmNsdWRlL2JpdHMvc3RyaW5nMy5oOjU3CiM2ICBwcm9jZXNzX3Nm
X2RpcjIgKGRpcm5hbWU9MHg0NmIwZTIgIiIsIHJlcGFpcj08c3ludGhldGljIHBvaW50ZXI+LCBw
YXJlbnQ9MHg3ZmZmZmZmZmRjMjAsIGRpbm9fZGlydHk9MHg3ZmZmZmZmZmRjMTgsIGlub19kaXNj
b3Zlcnk9MSwgZGlwPTB4MWU1NjIwMDAsIGlubz0yNjAyNTYyNTYsIG1wPTB4MWU1NjIwOTEpIGF0
IGRpcjIuYzo5OTIKIzcgIHByb2Nlc3NfZGlyMiAobXA9bXBAZW50cnk9MHg3ZmZmZmZmZmUwMjAs
IGlubz1pbm9AZW50cnk9MjYwMjU2MjU2LCBkaXA9ZGlwQGVudHJ5PTB4MWU1NjIwMDAsIGlub19k
aXNjb3Zlcnk9aW5vX2Rpc2NvdmVyeUBlbnRyeT0xLCBkaW5vX2RpcnR5PWRpbm9fZGlydHlAZW50
cnk9MHg3ZmZmZmZmZmRjMTgsIGRpcm5hbWU9ZGlybmFtZUBlbnRyeT0weDQ2YjBlMiAiIiwgCiAg
ICBwYXJlbnQ9cGFyZW50QGVudHJ5PTB4N2ZmZmZmZmZkYzIwLCBibGttYXA9MHgwKSBhdCBkaXIy
LmM6MTk4OAojOCAgMHgwMDAwMDAwMDAwNDExODlmIGluIHByb2Nlc3NfZGlub2RlX2ludCAobXA9
bXBAZW50cnk9MHg3ZmZmZmZmZmUwMjAsIGRpbm89ZGlub0BlbnRyeT0weDFlNTYyMDAwLCBhZ25v
PWFnbm9AZW50cnk9MCwgaW5vPWlub0BlbnRyeT0yNjAyNTYyNTYsIHdhc19mcmVlPTxvcHRpbWl6
ZWQgb3V0PiwgZGlydHk9ZGlydHlAZW50cnk9MHg3ZmZmZmZmZmRjMTgsIAogICAgdXNlZD11c2Vk
QGVudHJ5PTB4N2ZmZmZmZmZkYzE0LCB2ZXJpZnlfbW9kZT12ZXJpZnlfbW9kZUBlbnRyeT0wLCB1
bmNlcnRhaW49dW5jZXJ0YWluQGVudHJ5PTAsIGlub19kaXNjb3Zlcnk9aW5vX2Rpc2NvdmVyeUBl
bnRyeT0xLCBjaGVja19kdXBzPWNoZWNrX2R1cHNAZW50cnk9MCwgZXh0cmFfYXR0cl9jaGVjaz1l
eHRyYV9hdHRyX2NoZWNrQGVudHJ5PTEsIAogICAgaXNhX2Rpcj1pc2FfZGlyQGVudHJ5PTB4N2Zm
ZmZmZmZkYzFjLCBwYXJlbnQ9cGFyZW50QGVudHJ5PTB4N2ZmZmZmZmZkYzIwKSBhdCBkaW5vZGUu
YzoyODgxCiM5ICAweDAwMDAwMDAwMDA0MTI0Y2UgaW4gcHJvY2Vzc19kaW5vZGUgKG1wPW1wQGVu
dHJ5PTB4N2ZmZmZmZmZlMDIwLCBkaW5vPWRpbm9AZW50cnk9MHgxZTU2MjAwMCwgYWdubz1hZ25v
QGVudHJ5PTAsIGlubz1pbm9AZW50cnk9MjYwMjU2MjU2LCB3YXNfZnJlZT08b3B0aW1pemVkIG91
dD4sIGRpcnR5PWRpcnR5QGVudHJ5PTB4N2ZmZmZmZmZkYzE4LCB1c2VkPXVzZWRAZW50cnk9MHg3
ZmZmZmZmZmRjMTQsIAogICAgaW5vX2Rpc2NvdmVyeT1pbm9fZGlzY292ZXJ5QGVudHJ5PTEsIGNo
ZWNrX2R1cHM9Y2hlY2tfZHVwc0BlbnRyeT0wLCBleHRyYV9hdHRyX2NoZWNrPWV4dHJhX2F0dHJf
Y2hlY2tAZW50cnk9MSwgaXNhX2Rpcj1pc2FfZGlyQGVudHJ5PTB4N2ZmZmZmZmZkYzFjLCBwYXJl
bnQ9cGFyZW50QGVudHJ5PTB4N2ZmZmZmZmZkYzIwKSBhdCBkaW5vZGUuYzoyOTg5CiMxMCAweDAw
MDAwMDAwMDA0MGI5NmYgaW4gcHJvY2Vzc19pbm9kZV9jaHVuayAobXA9bXBAZW50cnk9MHg3ZmZm
ZmZmZmUwMjAsIGFnbm89YWdub0BlbnRyeT0wLCBmaXJzdF9pcmVjPWZpcnN0X2lyZWNAZW50cnk9
MHg3ZmZmOWM1NWI1ODAsIGlub19kaXNjb3Zlcnk9aW5vX2Rpc2NvdmVyeUBlbnRyeT0xLCBjaGVj
a19kdXBzPWNoZWNrX2R1cHNAZW50cnk9MCwgCiAgICBleHRyYV9hdHRyX2NoZWNrPWV4dHJhX2F0
dHJfY2hlY2tAZW50cnk9MSwgYm9ndXM9Ym9ndXNAZW50cnk9MHg3ZmZmZmZmZmRjYTQsIG51bV9p
bm9zPTxvcHRpbWl6ZWQgb3V0PikgYXQgZGlub19jaHVua3MuYzo3NzIKIzExIDB4MDAwMDAwMDAw
MDQwY2RkZCBpbiBwcm9jZXNzX2FnaW5vZGVzIChtcD0weDdmZmZmZmZmZTAyMCwgcGZfYXJncz1w
Zl9hcmdzQGVudHJ5PTB4MCwgYWdubz1hZ25vQGVudHJ5PTAsIGlub19kaXNjb3Zlcnk9aW5vX2Rp
c2NvdmVyeUBlbnRyeT0xLCBjaGVja19kdXBzPWNoZWNrX2R1cHNAZW50cnk9MCwgZXh0cmFfYXR0
cl9jaGVjaz1leHRyYV9hdHRyX2NoZWNrQGVudHJ5PTEpCiAgICBhdCBkaW5vX2NodW5rcy5jOjEw
MjUKIzEyIDB4MDAwMDAwMDAwMDQxOTY0ZSBpbiBwcm9jZXNzX2FnX2Z1bmMgKHdxPTB4N2ZmZmZm
ZmZkZDkwLCBhZ25vPTAsIGFyZz0weDApIGF0IHBoYXNlMy5jOjc3CiMxMyAweDAwMDAwMDAwMDA0
MjY1ZGEgaW4gcHJlZmV0Y2hfYWdfcmFuZ2UgKHdvcms9MHg3ZmZmZmZmZmRkOTAsIHN0YXJ0X2Fn
PTxvcHRpbWl6ZWQgb3V0PiwgZW5kX2FnPTMyLCBkaXJzX29ubHk9ZmFsc2UsIGZ1bmM9MHg0MTk2
MDAgPHByb2Nlc3NfYWdfZnVuYz4pIGF0IHByZWZldGNoLmM6OTA3CiMxNCAweDAwMDAwMDAwMDA0
MjY2NmMgaW4gZG9faW5vZGVfcHJlZmV0Y2ggKG1wPW1wQGVudHJ5PTB4N2ZmZmZmZmZlMDIwLCBz
dHJpZGU9MCwgZnVuYz1mdW5jQGVudHJ5PTB4NDE5NjAwIDxwcm9jZXNzX2FnX2Z1bmM+LCBjaGVj
a19jYWNoZT1jaGVja19jYWNoZUBlbnRyeT1mYWxzZSwgZGlyc19vbmx5PWRpcnNfb25seUBlbnRy
eT1mYWxzZSkgYXQgcHJlZmV0Y2guYzo5NzAKIzE1IDB4MDAwMDAwMDAwMDQxOTc1ZCBpbiBwcm9j
ZXNzX2FncyAobXA9MHg3ZmZmZmZmZmUwMjApIGF0IHBoYXNlMy5jOjg1CiMxNiBwaGFzZTMgKG1w
PW1wQGVudHJ5PTB4N2ZmZmZmZmZlMDIwKSBhdCBwaGFzZTMuYzoxMjEKIzE3IDB4MDAwMDAwMDAw
MDQwMzg4ZSBpbiBtYWluIChhcmdjPTxvcHRpbWl6ZWQgb3V0PiwgYXJndj08b3B0aW1pemVkIG91
dD4pIGF0IHhmc19yZXBhaXIuYzo3ODUKQSBkZWJ1Z2dpbmcgc2Vzc2lvbiBpcyBhY3RpdmUuCgoJ
SW5mZXJpb3IgMSBbcHJvY2VzcyAxNjE0N10gd2lsbCBiZSBraWxsZWQuCgpRdWl0IGFueXdheT8g
KHkgb3Igbikg
------=_Part_409854_2088855061.1425916240313
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_409854_2088855061.1425916240313--
