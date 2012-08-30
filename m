Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7VJWdrR220251 for <xfs@oss.sgi.com>; Fri, 31 Aug 2012 14:32:39 -0500
Received: from nm38-vm4.bullet.mail.bf1.yahoo.com
	(nm38-vm4.bullet.mail.bf1.yahoo.com [72.30.239.20]) by
	cuda.sgi.com with SMTP id DFxV8h3P7ggdAWoW for
	<xfs@oss.sgi.com>; Thu, 30 Aug 2012 06:43:50 -0700 (PDT)
Message-ID: <1346334229.58787.YahooMailClassic@web140702.mail.bf1.yahoo.com>
Date: Thu, 30 Aug 2012 06:43:49 -0700 (PDT)
From: Gim Leong Chin <chin_gim_leong@yahoo.com>
Subject: XFS Mount Recovery Failed on Root File System After Power Outage
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7237441943493730872=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7237441943493730872==
Content-Type: multipart/alternative; boundary="-589800495-399632349-1346334229=:58787"

---589800495-399632349-1346334229=:58787
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi


I just had a power outage and my Acer notebook computer running openSUSE 11=
.4 x86_64 with kernel 2.6.37 stopped as a result.

After I reset the circuit breaker I was unable to boot the OS.

I booted up the openSUSE 11.4 rescue disk (installation media).=A0 I ran th=
e S.M.A.R.T. short self-test with smartctl on the W.D. Caviar Black 320 GB =
drive and there were no errors.=A0 The S.M.A.R.T. parameters all look OK.=
=A0 I have not run the long self test though.

I am able to mount the /home to /mnt on the rescue session and I see no err=
or in /var/log/messages.

I then tried again to mount the root file system to /mnt.=A0=A0

Aug 30 14:21:59 Rescue kernel: [=A0 811.166914] XFS mounting filesystem sdb=
2
Aug 30 14:21:59 Rescue kernel: [=A0 811.212169] Starting XFS recovery on fi=
lesystem: sdb2 (logdev: internal)
Aug 30 14:21:59 Rescue kernel: [=A0 811.334157] XFS: Invalid block length (=
0xfffffffc) given for buffer
Aug 30 14:21:59 Rescue kernel: [=A0 811.334175] XFS: log mount/recovery fai=
led: error 117
Aug 30 14:21:59 Rescue kernel: [=A0 811.334230] XFS: log mount failed

XFS Check will not run since log recovery mount has not been done.

What is the cause of the recovery failure and what is the recommended cours=
e of action?

The XFS Check and XFS Repair versions on the rescue disk are 3.1.4.=A0 Are =
they sufficient to do any repair?

If I need a newer version of XFS Check and XFS Repair I will need to think =
of something since there is no compiler on the Rescue system and my openSUS=
E 11.4 desktop is down with hardware failure.

Thank you for your assistance.



GL
---589800495-399632349-1346334229=:58787
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<table cellspacing=3D"0" cellpadding=3D"0" border=3D"0" ><tr><td valign=3D"=
top" style=3D"font: inherit;"><SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM: non=
e; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; DISPLAY: inline !i=
mportant; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; FLOAT=
: none; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webk=
it-text-size-adjust: auto; -webkit-text-stroke-width: 0px">Hi</SPAN><BR sty=
le=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); =
TEXT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH=
: medium; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTE=
R-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-=
adjust: auto; -webkit-text-stroke-width: 0px"><BR style=3D"WIDOWS: 2; TEXT-=
TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; OUTL=
INE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: 14px/1=
6px
 monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: normal; COLOR:=
 rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -webkit-tex=
t-stroke-width: 0px"><BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROU=
ND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-=
COLOR: invert; OUTLINE-WIDTH: medium; FONT: 14px/16px monospace; WHITE-SPAC=
E: normal; ORPHANS: 2; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPAC=
ING: 0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px"><=
SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,25=
5,255); TEXT-INDENT: 0px; DISPLAY: inline !important; FONT: 14px/16px monos=
pace; WHITE-SPACE: normal; ORPHANS: 2; FLOAT: none; LETTER-SPACING: normal;=
 COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -web=
kit-text-stroke-width: 0px">I just had a power outage and my Acer notebook =
computer running openSUSE 11.4 x86_64 with kernel 2.6.37 stopped as a
 result.</SPAN><BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COL=
OR: rgb(255,255,255); TEXT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR:=
 invert; OUTLINE-WIDTH: medium; FONT: 14px/16px monospace; WHITE-SPACE: nor=
mal; ORPHANS: 2; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0=
px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px"><BR sty=
le=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); =
TEXT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH=
: medium; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTE=
R-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-=
adjust: auto; -webkit-text-stroke-width: 0px"><SPAN style=3D"WIDOWS: 2; TEX=
T-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; DI=
SPLAY: inline !important; FONT: 14px/16px monospace; WHITE-SPACE: normal; O=
RPHANS: 2; FLOAT: none; LETTER-SPACING: normal; COLOR: rgb(0,0,0);
 WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-wid=
th: 0px">After I reset the circuit breaker I was unable to boot the OS.</SP=
AN><BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,=
255,255); TEXT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUT=
LINE-WIDTH: medium; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS=
: 2; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-=
text-size-adjust: auto; -webkit-text-stroke-width: 0px"><BR style=3D"WIDOWS=
: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT:=
 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FO=
NT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: n=
ormal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto=
; -webkit-text-stroke-width: 0px"><SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM:=
 none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; DISPLAY:
 inline !important; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS=
: 2; FLOAT: none; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: =
0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px">I boot=
ed up the openSUSE 11.4 rescue disk (installation media).&nbsp; I ran the S=
.M.A.R.T. short self-test with smartctl on the W.D. Caviar Black 320 GB dri=
ve and there were no errors.&nbsp; The S.M.A.R.T. parameters all look OK.&n=
bsp; I have not run the long self test though.</SPAN><BR style=3D"WIDOWS: 2=
; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0p=
x; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT:=
 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: norm=
al; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -=
webkit-text-stroke-width: 0px"><BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none=
; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; OUTLINE-STYLE:
 none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: 14px/16px monosp=
ace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: normal; COLOR: rgb(0,=
0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -webkit-text-strok=
e-width: 0px"><SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-CO=
LOR: rgb(255,255,255); TEXT-INDENT: 0px; DISPLAY: inline !important; FONT: =
14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; FLOAT: none; LETTER-S=
PACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adj=
ust: auto; -webkit-text-stroke-width: 0px">I am able to mount the /home to =
/mnt on the rescue session and I see no error in /var/log/messages.</SPAN><=
BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,=
255); TEXT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE=
-WIDTH: medium; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2;=
 LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px;
 -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px"><BR style=
=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TE=
XT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: =
medium; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-=
SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-ad=
just: auto; -webkit-text-stroke-width: 0px"><SPAN style=3D"WIDOWS: 2; TEXT-=
TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; DISP=
LAY: inline !important; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORP=
HANS: 2; FLOAT: none; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACI=
NG: 0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px">I =
then tried again to mount the root file system to /mnt.&nbsp;<SPAN class=3D=
Apple-converted-space>&nbsp;</SPAN></SPAN><BR style=3D"WIDOWS: 2; TEXT-TRAN=
SFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px;
 OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: 1=
4px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: normal=
; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -we=
bkit-text-stroke-width: 0px"><BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; =
BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; OUTLINE-STYLE: none; =
OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: 14px/16px monospace; WH=
ITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: normal; COLOR: rgb(0,0,0); W=
ORD-SPACING: 0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width=
: 0px"><SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rg=
b(255,255,255); TEXT-INDENT: 0px; DISPLAY: inline !important; FONT: 14px/16=
px monospace; WHITE-SPACE: normal; ORPHANS: 2; FLOAT: none; LETTER-SPACING:=
 normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: au=
to; -webkit-text-stroke-width: 0px">Aug 30 14:21:59 Rescue kernel:
 [&nbsp; 811.166914] XFS mounting filesystem sdb2</SPAN><BR style=3D"WIDOWS=
: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT:=
 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FO=
NT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: n=
ormal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto=
; -webkit-text-stroke-width: 0px"><SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM:=
 none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; DISPLAY: inlin=
e !important; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; F=
LOAT: none; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -=
webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px">Aug 30 14:21=
:59 Rescue kernel: [&nbsp; 811.212169] Starting XFS recovery on filesystem:=
 sdb2 (logdev: internal)</SPAN><BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none=
; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; OUTLINE-STYLE:
 none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: 14px/16px monosp=
ace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: normal; COLOR: rgb(0,=
0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -webkit-text-strok=
e-width: 0px"><SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-CO=
LOR: rgb(255,255,255); TEXT-INDENT: 0px; DISPLAY: inline !important; FONT: =
14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; FLOAT: none; LETTER-S=
PACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adj=
ust: auto; -webkit-text-stroke-width: 0px">Aug 30 14:21:59 Rescue kernel: [=
&nbsp; 811.334157] XFS: Invalid block length (0xfffffffc) given for buffer<=
/SPAN><BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(2=
55,255,255); TEXT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; =
OUTLINE-WIDTH: medium; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPH=
ANS: 2; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px;
 -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px"><SPAN styl=
e=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); T=
EXT-INDENT: 0px; DISPLAY: inline !important; FONT: 14px/16px monospace; WHI=
TE-SPACE: normal; ORPHANS: 2; FLOAT: none; LETTER-SPACING: normal; COLOR: r=
gb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -webkit-text-=
stroke-width: 0px">Aug 30 14:21:59 Rescue kernel: [&nbsp; 811.334175] XFS: =
log mount/recovery failed: error 117</SPAN><BR style=3D"WIDOWS: 2; TEXT-TRA=
NSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; OUTLINE=
-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: 14px/16px=
 monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: normal; COLOR:=
 rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -webkit-tex=
t-stroke-width: 0px"><SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGR=
OUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; DISPLAY: inline
 !important; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; FL=
OAT: none; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -w=
ebkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px">Aug 30 14:21:=
59 Rescue kernel: [&nbsp; 811.334230] XFS: log mount failed</SPAN><BR style=
=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TE=
XT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: =
medium; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-=
SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-ad=
just: auto; -webkit-text-stroke-width: 0px"><BR style=3D"WIDOWS: 2; TEXT-TR=
ANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; OUTLIN=
E-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: 14px/16p=
x monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: normal; COLOR=
: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto;
 -webkit-text-stroke-width: 0px"><SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM: =
none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; DISPLAY: inline=
 !important; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; FL=
OAT: none; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -w=
ebkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px">XFS Check wil=
l not run since log recovery mount has not been done.</SPAN><BR style=3D"WI=
DOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-IND=
ENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium=
; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACIN=
G: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px"><BR style=3D"WIDOWS: 2; TEXT-TRANSFOR=
M: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; OUTLINE-STYL=
E: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: 14px/16px
 monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: normal; COLOR:=
 rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -webkit-tex=
t-stroke-width: 0px"><SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGR=
OUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; DISPLAY: inline !important;=
 FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; FLOAT: none; L=
ETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-s=
ize-adjust: auto; -webkit-text-stroke-width: 0px">What is the cause of the =
recovery failure and what is the recommended course of action?</SPAN><BR st=
yle=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255);=
 TEXT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDT=
H: medium; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETT=
ER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size=
-adjust: auto; -webkit-text-stroke-width: 0px"><BR style=3D"WIDOWS: 2;
 TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px=
; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: =
14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: norma=
l; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -w=
ebkit-text-stroke-width: 0px"><SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM: non=
e; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; DISPLAY: inline !i=
mportant; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; FLOAT=
: none; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webk=
it-text-size-adjust: auto; -webkit-text-stroke-width: 0px">The XFS Check an=
d XFS Repair versions on the rescue disk are 3.1.4.&nbsp; Are they sufficie=
nt to do any repair?</SPAN><BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BA=
CKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; OUTLINE-STYLE: none; OU=
TLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: 14px/16px monospace;
 WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: normal; COLOR: rgb(0,0,0)=
; WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-wi=
dth: 0px"><BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: r=
gb(255,255,255); TEXT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: inve=
rt; OUTLINE-WIDTH: medium; FONT: 14px/16px monospace; WHITE-SPACE: normal; =
ORPHANS: 2; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -=
webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px"><SPAN style=
=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TE=
XT-INDENT: 0px; DISPLAY: inline !important; FONT: 14px/16px monospace; WHIT=
E-SPACE: normal; ORPHANS: 2; FLOAT: none; LETTER-SPACING: normal; COLOR: rg=
b(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -webkit-text-s=
troke-width: 0px">If I need a newer version of XFS Check and XFS Repair I w=
ill need to think of something since there is no compiler on the Rescue
 system and my openSUSE 11.4 desktop is down with hardware failure.</SPAN><=
BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,=
255); TEXT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE=
-WIDTH: medium; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2;=
 LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text=
-size-adjust: auto; -webkit-text-stroke-width: 0px"><BR style=3D"WIDOWS: 2;=
 TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px=
; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: =
14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: norma=
l; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -w=
ebkit-text-stroke-width: 0px"><SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM: non=
e; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; DISPLAY: inline !i=
mportant; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2;
 FLOAT: none; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px;=
 -webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px">Thank you =
for your assistance.</SPAN><BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BA=
CKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; OUTLINE-STYLE: none; OU=
TLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: 14px/16px monospace; WHIT=
E-SPACE: normal; ORPHANS: 2; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WOR=
D-SPACING: 0px; -webkit-text-size-adjust: auto; -webkit-text-stroke-width: =
0px"><BR style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(25=
5,255,255); TEXT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; O=
UTLINE-WIDTH: medium; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHA=
NS: 2; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webki=
t-text-size-adjust: auto; -webkit-text-stroke-width: 0px"><BR style=3D"WIDO=
WS: 2; TEXT-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255);
 TEXT-INDENT: 0px; OUTLINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDT=
H: medium; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETT=
ER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size=
-adjust: auto; -webkit-text-stroke-width: 0px"><BR style=3D"WIDOWS: 2; TEXT=
-TRANSFORM: none; BACKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; OUT=
LINE-STYLE: none; OUTLINE-COLOR: invert; OUTLINE-WIDTH: medium; FONT: 14px/=
16px monospace; WHITE-SPACE: normal; ORPHANS: 2; LETTER-SPACING: normal; CO=
LOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-text-size-adjust: auto; -webkit=
-text-stroke-width: 0px"><SPAN style=3D"WIDOWS: 2; TEXT-TRANSFORM: none; BA=
CKGROUND-COLOR: rgb(255,255,255); TEXT-INDENT: 0px; DISPLAY: inline !import=
ant; FONT: 14px/16px monospace; WHITE-SPACE: normal; ORPHANS: 2; FLOAT: non=
e; LETTER-SPACING: normal; COLOR: rgb(0,0,0); WORD-SPACING: 0px; -webkit-te=
xt-size-adjust: auto; -webkit-text-stroke-width:
 0px">GL</SPAN></td></tr></table>
---589800495-399632349-1346334229=:58787--


--===============7237441943493730872==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7237441943493730872==--
