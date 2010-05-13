Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4D8gsaF214456 for <xfs@oss.sgi.com>; Thu, 13 May 2010 03:42:54 -0500
Received: from n8a.bullet.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 5B68433CA9F
	for <xfs@oss.sgi.com>; Thu, 13 May 2010 01:45:07 -0700 (PDT)
Received: from n8a.bullet.mail.mud.yahoo.com (n8a.bullet.mail.mud.yahoo.com
	[209.191.87.104]) by cuda.sgi.com with SMTP id NpihS5HoNyE2MNqB
	for <xfs@oss.sgi.com>; Thu, 13 May 2010 01:45:07 -0700 (PDT)
Message-ID: <606770.71420.qm@web112907.mail.gq1.yahoo.com>
References: <28512276.post@talk.nabble.com> <4BE82955.2080009@sandeen.net>
	<978493.86662.qm@web112902.mail.gq1.yahoo.com>
	<20100510222211.3e73cdeb@galadriel.home>
	<132290.52744.qm@web112902.mail.gq1.yahoo.com>
	<20100512142902.47d1022a@harpe.intellique.com>
Date: Thu, 13 May 2010 01:38:25 -0700 (PDT)
From: Leo Davis <leo1783@yahoo.com>
Subject: Re: bad primary superblock - bad magic number !!!
In-Reply-To: <20100512142902.47d1022a@harpe.intellique.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1342829191255397796=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

--===============1342829191255397796==
Content-Type: multipart/alternative; boundary="0-334650543-1273739905=:71420"

--0-334650543-1273739905=:71420
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

=0A=0A>Uh, you should try the other way around to avoid breaking the=0A>fil=
esystem :=0A=0A>dd if=3D/dev/cciss/c0d2 of=3D/dev/null bs=3D131072=0A=0A>If=
 no error occurs it should be OK.=0A=0Ai did that on all 4 luns=0A#dd if=3D=
/dev/cciss/c0d2 of=3D/dev/null bs=3D131072 =0A796+1 records in=0A796+1 reco=
rds out=0A=0A#dd if=3D/dev/cciss/c0d0 of=3D/dev/null bs=3D131072 =0A796+1 r=
ecords in=0A796+1 records out=0A=0A# dd if=3D/dev/cciss/c0d1 of=3D/dev/null=
 bs=3D131072=0A68675509+1 records in=0A68675509+1 records out=0A=0A## dd if=
=3D/dev/cciss/c0d3 of=3D/dev/null bs=3D131072=0A68675509+1 records in=0A686=
75509+1 records out=0A=0AI also had a serial cable attached to my P800 cont=
roller to capture any traces..this is what that picked up:=0A=0A/dev/cciss/=
c0d0: [05/12 13:38:28]Int13 BIOS unit 0x81 =3D CISS LUN 0x0000004000000=0A0=
00=0A/dev/cciss/c0d0: [05/12 13:38:28]Int13 BIOS unit 0x82 =3D CISS LUN 0x0=
100004000000=0A000=0A/dev/cciss/c0d0: [05/12 13:38:28]Int13 BIOS unit 0x83 =
=3D CISS LUN 0x0200004000000=0A000=0A/dev/cciss/c0d0: [05/12 13:38:28]Int13=
 BIOS unit 0x84 =3D CISS LUN 0x0300004000000=0A000=0A/dev/cciss/c0d0: [05/1=
3 09:13:03]PR=3D030fefb8h D245 Op=3D1c PLErr=3D04 IopErr=3D30 S=3D00=0A STa=
g=3D0x018d Has/dev/cciss/c0d0: hAddr=3D0x00e59c6c PLLog=3D0x31190000=0A/dev=
/cciss/c0d0: [05/13 09:21:04]Ctlr SCSI Request, Illegal CDB Opcode=3D0x3c=
=0A/dev/cciss/c0d0: [05/13 09:21:08]BadReq:CDB0-15=3D260008000000A200A00000=
0000000000=0A,LUN=3D00000000L00/dev/cciss/c0d0: 000000H=0A/dev/cciss/c0d0: =
[05/13 09:21:08]BadReq:CDB0-15=3D260009000000A200A000000000000000=0A,LUN=3D=
00000000L00/dev/cciss/c0d0: 000000H=0A/dev/cciss/c0d0: [05/13 09:21:08]BadR=
eq:CDB0-15=3D26000A000000A200A000000000000000=0A,LUN=3D00000000L00/dev/ccis=
s/c0d0: 000000H=0A/dev/cciss/c0d0: [05/13 09:21:08]BadReq:CDB0-15=3D26000B0=
00000A200A000000000000000=0A,LUN=3D00000000L00/dev/cciss/c0d0: 000000H=0A/d=
ev/cciss/c0d0: [05/13 09:21:08]BadReq:CDB0-15=3D26000C000000A200A0000000000=
00000=0A..the spew continues..=0A=0A=0AAny thoughts here?=0A=0A=0A=0A=0A___=
_____________________________=0AFrom: Emmanuel Florac <eflorac@intellique.c=
om>=0ATo: Leo Davis <leo1783@yahoo.com>=0ACc: xfs@oss.sgi.com=0ASent: Wed, =
May 12, 2010 1:29:02 PM=0ASubject: Re: bad primary superblock - bad magic n=
umber !!!=0A=0ALe Wed, 12 May 2010 02:19:16 -0700 (PDT)=0ALeo Davis <leo178=
3@yahoo.com> =E9crivait:=0A=0A> havent had much success with testing the ha=
rd drives, tried mhdd &=0A> seatools with no luck yet.=0A=0AWhat do you mea=
n? Does the tools report any problem with the drives?=0A=0A> So is I do a -=
 dd if=3D/dev/random of=3Ddev/cciss/c0d2 , that should fail=0A> and therby =
confirm that the drive or array has issues...do i make any=0A> sense here?=
=0A=0AUh, you should try the other way around to avoid breaking the=0Afiles=
ystem :=0A=0Add if=3D/dev/cciss/c0d2 of=3D/dev/null bs=3D131072=0A=0AIf no =
error occurs it should be OK.=0A=0A-- =0A----------------------------------=
--------------------------------------=0AEmmanuel Florac     |   Direction =
technique=0A                    |   Intellique=0A                    |    <=
eflorac@intellique.com>=0A                    |   +33 1 78 94 84 02=0A-----=
-------------------------------------------------------------------=0A=0A=
=0A=0A      
--0-334650543-1273739905=:71420
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D"text/css"><!-- DIV {margin:0px;} --></style></he=
ad><body><div style=3D"font-family:times new roman,new york,times,serif;fon=
t-size:12pt">=0A<div style=3D"font-family: times new roman,new york,times,s=
erif; font-size: 12pt;"><div><br></div><div style=3D"font-family: times new=
 roman,new york,times,serif; font-size: 12pt;">&gt;Uh, you should try the o=
ther way around to avoid breaking the<br>&gt;filesystem :<br><br>&gt;dd if=
=3D/dev/cciss/c0d2 of=3D/dev/null bs=3D131072<br><br>&gt;If no error occurs=
 it should be OK.<br><br>i did that on all 4 luns<br>#dd if=3D/dev/cciss/c0=
d2 of=3D/dev/null bs=3D131072 <br>796+1 records in<br>796+1 records out<br>=
<br>#dd if=3D/dev/cciss/c0d0 of=3D/dev/null bs=3D131072 <br>796+1 records i=
n<br>=0A796+1 records out<br><br># dd if=3D/dev/cciss/c0d1 of=3D/dev/null b=
s=3D131072<br>68675509+1 records in<br>68675509+1 records out<br><br>## dd =
if=3D/dev/cciss/c0d3 of=3D/dev/null bs=3D131072<br>68675509+1 records in<br=
>68675509+1 records out<br><br>I also had a serial cable attached to my P80=
0 controller to capture any traces..this is what that picked up:<br><br>/de=
v/cciss/c0d0: [05/12 13:38:28]Int13 BIOS unit 0x81 =3D CISS LUN 0x000000400=
0000<br>000<br>/dev/cciss/c0d0: [05/12 13:38:28]Int13 BIOS unit 0x82 =3D CI=
SS LUN 0x0100004000000<br>000<br>/dev/cciss/c0d0: [05/12 13:38:28]Int13 BIO=
S unit 0x83 =3D CISS LUN 0x0200004000000<br>000<br>/dev/cciss/c0d0: [05/12 =
13:38:28]Int13 BIOS unit 0x84 =3D CISS LUN 0x0300004000000<br>000<br>/dev/c=
ciss/c0d0: [05/13 09:13:03]PR=3D030fefb8h D245 Op=3D1c PLErr=3D04 IopErr=3D=
30 S=3D00<br>&nbsp;STag=3D0x018d Has/dev/cciss/c0d0: hAddr=3D0x00e59c6c PLL=
og=3D0x31190000<br>/dev/cciss/c0d0: [05/13 09:21:04]Ctlr SCSI Request, Ille=
gal CDB
 Opcode=3D0x3c<br>/dev/cciss/c0d0: [05/13 09:21:08]BadReq:CDB0-15=3D2600080=
00000A200A000000000000000<br>,LUN=3D00000000L00/dev/cciss/c0d0: 000000H<br>=
/dev/cciss/c0d0: [05/13 09:21:08]BadReq:CDB0-15=3D260009000000A200A00000000=
0000000<br>,LUN=3D00000000L00/dev/cciss/c0d0: 000000H<br>/dev/cciss/c0d0: [=
05/13 09:21:08]BadReq:CDB0-15=3D26000A000000A200A000000000000000<br>,LUN=3D=
00000000L00/dev/cciss/c0d0: 000000H<br>/dev/cciss/c0d0: [05/13 09:21:08]Bad=
Req:CDB0-15=3D26000B000000A200A000000000000000<br>,LUN=3D00000000L00/dev/cc=
iss/c0d0: 000000H<br>/dev/cciss/c0d0: [05/13 09:21:08]BadReq:CDB0-15=3D2600=
0C000000A200A000000000000000<br>..the spew continues..<br><br><br>Any thoug=
hts here?<br><br><br><div style=3D"font-family: arial,helvetica,sans-serif;=
 font-size: 13px;"><font face=3D"Tahoma" size=3D"2"><hr size=3D"1"><b><span=
 style=3D"font-weight: bold;">From:</span></b> Emmanuel Florac &lt;eflorac@=
intellique.com&gt;<br><b><span style=3D"font-weight: bold;">To:</span></b> =
Leo Davis
 &lt;leo1783@yahoo.com&gt;<br><b><span style=3D"font-weight: bold;">Cc:</sp=
an></b> xfs@oss.sgi.com<br><b><span style=3D"font-weight: bold;">Sent:</spa=
n></b> Wed, May 12, 2010=0A 1:29:02 PM<br><b><span style=3D"font-weight: bo=
ld;">Subject:</span></b> Re: bad primary superblock - bad magic number !!!<=
br></font><br>=0ALe Wed, 12 May 2010 02:19:16 -0700 (PDT)<br>Leo Davis &lt;=
<a rel=3D"nofollow" ymailto=3D"mailto:leo1783@yahoo.com" target=3D"_blank" =
href=3D"mailto:leo1783@yahoo.com">leo1783@yahoo.com</a>&gt; =E9crivait:<br>=
<br>&gt; havent had much success with testing the hard drives, tried mhdd &=
amp;<br>&gt; seatools with no luck yet.<br><br>What do you mean? Does the t=
ools report any problem with the drives?<br><br>&gt; So is I do a - dd if=
=3D/dev/random of=3Ddev/cciss/c0d2 , that should fail<br>&gt; and therby co=
nfirm that the drive or array has issues...do i make any<br>&gt; sense here=
?<br><br>Uh, you should try the other way around to avoid breaking the<br>f=
ilesystem :<br><br>dd if=3D/dev/cciss/c0d2 of=3D/dev/null bs=3D131072<br><b=
r>If no error occurs it should be OK.<br><br>-- <br>-----------------------=
-------------------------------------------------<br>Emmanuel Florac&nbsp; =
&nbsp;  |&nbsp;  Direction technique<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;
 &nbsp; |&nbsp; =0A Intellique<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; |&nbsp;&nbsp;&nbsp; &lt;<a rel=3D"nofollow" ym=
ailto=3D"mailto:eflorac@intellique.com" target=3D"_blank" href=3D"mailto:ef=
lorac@intellique.com">eflorac@intellique.com</a>&gt;<br>&nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |&nbsp;  +33 1 78 94 84 =
02<br>---------------------------------------------------------------------=
---<br></div></div>=0A</div>=0A</div><br>=0A=0A      </body></html>
--0-334650543-1273739905=:71420--


--===============1342829191255397796==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1342829191255397796==--
