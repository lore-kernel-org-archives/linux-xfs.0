Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4DAwKWd220503 for <xfs@oss.sgi.com>; Thu, 13 May 2010 05:58:20 -0500
Received: from n1-vm1.bullet.mail.gq1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 1236E33D093
	for <xfs@oss.sgi.com>; Thu, 13 May 2010 04:00:34 -0700 (PDT)
Received: from n1-vm1.bullet.mail.gq1.yahoo.com
	(n1-vm1.bullet.mail.gq1.yahoo.com [67.195.23.153]) by
	cuda.sgi.com with SMTP id gM4YNnHFVTWEHQ4G for
	<xfs@oss.sgi.com>; Thu, 13 May 2010 04:00:34 -0700 (PDT)
Message-ID: <408113.19031.qm@web112903.mail.gq1.yahoo.com>
References: <28512276.post@talk.nabble.com> <4BE82955.2080009@sandeen.net>
	<978493.86662.qm@web112902.mail.gq1.yahoo.com>
	<20100510222211.3e73cdeb@galadriel.home>
	<132290.52744.qm@web112902.mail.gq1.yahoo.com>
	<20100512142902.47d1022a@harpe.intellique.com>
	<606770.71420.qm@web112907.mail.gq1.yahoo.com>
	<20100513114151.110fe8f9@galadriel.home>
Date: Thu, 13 May 2010 04:00:33 -0700 (PDT)
From: Leo Davis <leo1783@yahoo.com>
Subject: Re: bad primary superblock - bad magic number !!!
In-Reply-To: <20100513114151.110fe8f9@galadriel.home>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0926775519701652717=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

--===============0926775519701652717==
Content-Type: multipart/alternative; boundary="0-326434168-1273748433=:19031"

--0-326434168-1273748433=:19031
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

>If I understand correctly, c0d0 represents a drive (the first one).=0A>App=
arently this drive is dead, or close. You should probably ditch it.=0A=0Ano=
pe, c0d0 represents ( ControllerNumber[c0] LogicalDriveNumber[d0] )=0Aso it=
s 12 disks in 2 partitions- c0d0 and c0d1=0Ac0d0 holds configuration inform=
ation=0AI boot from a different device, the raid set is used only for stori=
ng data.=0A=0Acheers=0A=0A=0A=0A=0A________________________________=0AFrom:=
 Emmanuel Florac <eflorac@intellique.com>=0ATo: Leo Davis <leo1783@yahoo.co=
m>=0ACc: xfs@oss.sgi.com=0ASent: Thu, May 13, 2010 10:41:51 AM=0ASubject: R=
e: bad primary superblock - bad magic number !!!=0A=0ALe Thu, 13 May 2010 0=
1:38:25 -0700 (PDT) vous =E9criviez:=0A=0A> /dev/cciss/c0d0: [05/13=0A> 09:=
21:08]BadReq:CDB0-15=3D26000C000000A200A000000000000000 ..the spew=0A> cont=
inues..=0A> =0A> =0A> Any thoughts here?=0A> =0A=0AIf I understand correctl=
y, c0d0 represents a drive (the first one).=0AApparently this drive is dead=
, or close. You should probably ditch it.=0A=0A-- =0A----------------------=
--------------------------------------------------=0AEmmanuel Florac     | =
  Direction technique=0A                    |   Intellique=0A              =
      |    <eflorac@intellique.com>=0A                    |   +33 1 78 94 8=
4 02=0A--------------------------------------------------------------------=
----=0A=0A=0A=0A      
--0-326434168-1273748433=:19031
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D"text/css"><!-- DIV {margin:0px;} --></style></he=
ad><body><div style=3D"font-family:times new roman,new york,times,serif;fon=
t-size:12pt"><div>&gt;If I understand correctly, c0d0 represents a drive (t=
he first one).<br>&gt;Apparently this drive is dead, or close. You should p=
robably ditch it.<br><br>nope, c0d0 represents ( ControllerNumber[c0] Logic=
alDriveNumber[d0] )<br>so its 12 disks in 2 partitions- c0d0 and c0d1<br>c0=
d0 holds configuration information<br>I boot from a different device, the r=
aid set is used only for storing data.<br><br>cheers<br></div><div style=3D=
"font-family: times new roman,new york,times,serif; font-size: 12pt;"><br><=
div style=3D"font-family: arial,helvetica,sans-serif; font-size: 13px;"><fo=
nt face=3D"Tahoma" size=3D"2"><hr size=3D"1"><b><span style=3D"font-weight:=
 bold;">From:</span></b> Emmanuel Florac &lt;eflorac@intellique.com&gt;<br>=
<b><span style=3D"font-weight: bold;">To:</span></b> Leo Davis
 &lt;leo1783@yahoo.com&gt;<br><b><span style=3D"font-weight: bold;">Cc:</sp=
an></b> xfs@oss.sgi.com<br><b><span style=3D"font-weight: bold;">Sent:</spa=
n></b> Thu, May 13, 2010 10:41:51 AM<br><b><span style=3D"font-weight: bold=
;">Subject:</span></b> Re: bad primary superblock - bad magic number !!!<br=
></font><br>=0ALe Thu, 13 May 2010 01:38:25 -0700 (PDT) vous =E9criviez:<br=
><br>&gt; /dev/cciss/c0d0: [05/13<br>&gt; 09:21:08]BadReq:CDB0-15=3D26000C0=
00000A200A000000000000000 ..the spew<br>&gt; continues..<br>&gt; <br>&gt; <=
br>&gt; Any thoughts here?<br>&gt; <br><br>If I understand correctly, c0d0 =
represents a drive (the first one).<br>Apparently this drive is dead, or cl=
ose. You should probably ditch it.<br><br>-- <br>--------------------------=
----------------------------------------------<br>Emmanuel Florac&nbsp; &nb=
sp;  |&nbsp;  Direction technique<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; |&nbsp;  Intellique<br>&nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |&nbsp;&nbsp;&nbsp; &lt;<=
a ymailto=3D"mailto:eflorac@intellique.com" href=3D"mailto:eflorac@intelliq=
ue.com">eflorac@intellique.com</a>&gt;<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |&nbsp;  +33 1 78 94 84
 02<br>--------------------------------------------------------------------=
----<br></div></div>=0A</div><br>=0A=0A      </body></html>
--0-326434168-1273748433=:19031--


--===============0926775519701652717==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0926775519701652717==--
