Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6636F7CA0
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 12:51:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E81088F8033
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 10:51:06 -0700 (PDT)
Received: from exch-spam02.ulaval.ca (exch-spam02.ulaval.ca [132.203.244.24])
	by cuda.sgi.com with ESMTP id PT2Dm78dxEKuZWXF (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Apr 2016 10:51:01 -0700 (PDT)
From: =?iso-8859-1?Q?St=E9phane_Larose?= <Stephane.Larose@ibis.ulaval.ca>
Subject: xfs_repair couldn't verify primary superblock
Date: Wed, 20 Apr 2016 17:50:59 +0000
Message-ID: <d738a94784a0426e97752f92f38325a0@ul-exc-pr-mbx11.ulaval.ca>
Content-Language: fr-FR
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9163573559556542887=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============9163573559556542887==
Content-Language: fr-FR
Content-Type: multipart/alternative;
	boundary="_000_d738a94784a0426e97752f92f38325a0ulexcprmbx11ulavalca_"

--_000_d738a94784a0426e97752f92f38325a0ulexcprmbx11ulavalca_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,

When I try to mount a cleany unmounted XFS filesystem, I get those errors i=
n the log :

[1650856.121229] XFS (dm-24): Mounting V4 Filesystem
[1650856.135455] XFS (dm-24): Log inconsistent or not a log (last=3D=3D0, f=
irst!=3D1)
[1650856.135461] XFS (dm-24): empty log check failed
[1650856.135463] XFS (dm-24): log mount/recovery failed: error 22
[1650856.135495] XFS (dm-24): log mount failed

I have tried xfs_repair but...

manitou:~ # xfs_repair /dev/dm-24
Phase 1 - find and verify superblock...
couldn't verify primary superblock - not enough secondary superblocks with =
matching geometry !!!

attempting to find secondary superblock...
........................................

After a lot of dots, xfs_repair can't find secondary superblocks.

This is where my knowledge of XFS filesystem stops. Looking at the superblo=
ck information, I have a feeling that the primary superblock is fine but no=
t the secondary superblocks (strange blocksize and dblocks numbers). Is the=
re any way to copy the primary superblock to the secondary superblocks? May=
be this is not a good idea?

Thank you for any help!

manitou:~ # xfs_db /dev/dm-24
xfs_db> sb 0
xfs_db> p
magicnum =3D 0x58465342
blocksize =3D 4096
dblocks =3D 805306368
rblocks =3D 0
rextents =3D 0
uuid =3D 1da22ae2-a572-4db7-b177-b90021a20863
logstart =3D 536870916
rootino =3D 128
rbmino =3D 129
rsumino =3D 130
rextsize =3D 1
agblocks =3D 201326592
agcount =3D 4
rbmblocks =3D 0
logblocks =3D 393216
versionnum =3D 0xb4a4
sectsize =3D 512
inodesize =3D 256
inopblock =3D 16
fname =3D "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog =3D 12
sectlog =3D 9
inodelog =3D 8
inopblog =3D 4
agblklog =3D 28
rextslog =3D 0
inprogress =3D 0
imax_pct =3D 5
icount =3D 15424
ifree =3D 147
fdblocks =3D 269387727
frextents =3D 0
uquotino =3D 0
gquotino =3D null
qflags =3D 0
flags =3D 0
shared_vn =3D 0
inoalignmt =3D 2
unit =3D 0
width =3D 0
dirblklog =3D 0
logsectlog =3D 0
logsectsize =3D 0
logsunit =3D 1
features2 =3D 0x8a
bad_features2 =3D 0x8a
features_compat =3D 0
features_ro_compat =3D 0
features_incompat =3D 0
features_log_incompat =3D 0
crc =3D 0 (unchecked)
pquotino =3D 0
lsn =3D 0
xfs_db> sb 1
xfs_db> p
magicnum =3D 0xf6b89fbf
blocksize =3D 1483932129
dblocks =3D 15694009933101722137
rblocks =3D 11068626756016902811
rextents =3D 1593063622148300128
uuid =3D 6d1ec280-7f96-c817-0f72-d68433061de8
logstart =3D 17414611744493230066
rootino =3D 9197560587205818314
rbmino =3D 1554642860151675405
rsumino =3D 377387355824336886
rextsize =3D 1433889823
agblocks =3D 3940333176
agcount =3D 2930968516
rbmblocks =3D 422920841
logblocks =3D 4017127169
versionnum =3D 0xd520
sectsize =3D 19409
inodesize =3D 16393
inopblock =3D 2470
fname =3D "\323R|\0066\274\271\252\240\370-\231"
blocklog =3D 164
sectlog =3D 42
inodelog =3D 53
inopblog =3D 10
agblklog =3D 72
rextslog =3D 24
inprogress =3D 224
imax_pct =3D 46
icount =3D 11911544493988237103
ifree =3D 3385761089021187134
fdblocks =3D 9395999607433847230
frextents =3D 7946546560364525221
uquotino =3D 15084273978162174417
gquotino =3D 478665847475212977
qflags =3D 0x1301
flags =3D 0x37
shared_vn =3D 3
inoalignmt =3D 3222551805
unit =3D 3368784749
width =3D 3167603851
dirblklog =3D 130
logsectlog =3D 143
logsectsize =3D 2101
logsunit =3D 2030308911
features2 =3D 0x5d5cbbfe
bad_features2 =3D 0x2afcd122
features_compat =3D 0x2a3d35d5
features_ro_compat =3D 0xa4e58ba9
features_incompat =3D 0x13dccb60
features_log_incompat =3D 0xe79d437a
crc =3D 0xbd38d745 (unchecked)
pquotino =3D 7778233919291903441
lsn =3D 0xa8ffb559acd96aea
xfs_db> sb 2
xfs_db> p
magicnum =3D 0x41474341
blocksize =3D 1195590471
dblocks =3D 4847921951085253716
rblocks =3D 4846789398308864835
rextents =3D 4702132125296707412
uuid =3D 41544354-5441-4141-4754-544743544743
logstart =3D 4703821056660554049
rootino =3D 4703802364996815473
rbmino =3D 7814906735281653061
rsumino =3D 4991471925827290437
rextsize =3D 1162167621
agblocks =3D 1162167621
agcount =3D 1162167621
rbmblocks =3D 1162167621
logblocks =3D 1162167621
versionnum =3D 0x4545
sectsize =3D 17733
inodesize =3D 17733
inopblock =3D 17733
fname =3D "EEEEEEEEEEEE"
blocklog =3D 69
sectlog =3D 69
inodelog =3D 69
inopblog =3D 69
agblklog =3D 69
rextslog =3D 69
inprogress =3D 69
imax_pct =3D 69
icount =3D 4991471925827290437
ifree =3D 4991471925827290437
fdblocks =3D 4991471925827290437
frextents =3D 4991471925827290437
uquotino =3D 4991471925827290437
gquotino =3D 4991471925827290437
qflags =3D 0x4545
flags =3D 0x45
shared_vn =3D 69
inoalignmt =3D 1162167621
unit =3D 1162167621
width =3D 1162167621
dirblklog =3D 69
logsectlog =3D 69
logsectsize =3D 17733
logsunit =3D 1162167621
features2 =3D 0x45454545
bad_features2 =3D 0x45454545
features_compat =3D 0x45454545
features_ro_compat =3D 0x45454545
features_incompat =3D 0x450a6461
features_log_incompat =3D 0x74612e75
crc =3D 0x6e697469 (unchecked)
pquotino =3D 8531350831795363699
lsn =3D 0x74617420302e3032
xfs_db>

---
St=E9phane Larose
Analyste de l'informatique
Institut de Biologie Int=E9grative et des Syst=E8mes (IBIS)
Pavillon Charles-Eug=E8ne-Marchand
Universit=E9 Laval


--_000_d738a94784a0426e97752f92f38325a0ulexcprmbx11ulavalca_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;
	mso-fareast-language:EN-US;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;
	mso-fareast-language:EN-US;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"FR-CA" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hello,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">When I try to mount a cleany un=
mounted XFS filesystem, I get those errors in the log&nbsp;:<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[1650856.121229] XFS (dm-24): M=
ounting V4 Filesystem<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[1650856.135455] XFS (dm-24): L=
og inconsistent or not a log (last=3D=3D0, first!=3D1)<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[1650856.135461] XFS (dm-24): e=
mpty log check failed<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">[1650856.135463] XFS (dm-24): l=
og mount/recovery failed: error 22<o:p></o:p></span></p>
<p class=3D"MsoNormal">[1650856.135495] XFS (dm-24): log mount failed<o:p><=
/o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">I have tried xfs_repair but&#82=
30;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">manitou:~ # xfs_repair /dev/dm-=
24 <o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Phase 1 - find and verify super=
block...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">couldn't verify primary superbl=
ock - not enough secondary superblocks with matching geometry !!!<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">attempting to find secondary su=
perblock...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">...............................=
.........<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">After a lot of dots, xfs_repair=
 can&#8217;t find secondary superblocks.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">This is where my knowledge of X=
FS filesystem stops. Looking at the superblock information, I have a feelin=
g that the primary superblock is fine but not the secondary superblocks (st=
range blocksize and dblocks numbers).
 Is there any way to copy the primary superblock to the secondary superbloc=
ks? Maybe this is not a good idea?<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Thank you for any help!<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">manitou:~ # xfs_db /dev/dm-24<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">xfs_db&gt; sb 0<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">xfs_db&gt; p<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">magicnum =3D 0x58465342<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">blocksize =3D 4096<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">dblocks =3D 805306368<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rblocks =3D 0<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rextents =3D 0<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">uuid =3D 1da22ae2-a572-4db7-b17=
7-b90021a20863<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logstart =3D 536870916<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rootino =3D 128<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rbmino =3D 129<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rsumino =3D 130<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rextsize =3D 1<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">agblocks =3D 201326592<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">agcount =3D 4<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rbmblocks =3D 0<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logblocks =3D 393216<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">versionnum =3D 0xb4a4<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">sectsize =3D 512<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inodesize =3D 256<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inopblock =3D 16<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">fname =3D &quot;\000\000\000\00=
0\000\000\000\000\000\000\000\000&quot;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">blocklog =3D 12<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">sectlog =3D 9<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inodelog =3D 8<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inopblog =3D 4<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">agblklog =3D 28<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rextslog =3D 0<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inprogress =3D 0<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">imax_pct =3D 5<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">icount =3D 15424<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">ifree =3D 147<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">fdblocks =3D 269387727<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">frextents =3D 0<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">uquotino =3D 0<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">gquotino =3D null<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">qflags =3D 0<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">flags =3D 0<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">shared_vn =3D 0<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inoalignmt =3D 2<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">unit =3D 0<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-US">width =3D 0<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">dirblklog =3D 0<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logsectlog =3D 0<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logsectsize =3D 0<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logsunit =3D 1<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features2 =3D 0x8a<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">bad_features2 =3D 0x8a<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features_compat =3D 0<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features_ro_compat =3D 0<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features_incompat =3D 0<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features_log_incompat =3D 0<o:p=
></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">crc =3D 0 (unchecked)<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">pquotino =3D 0<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">lsn =3D 0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">xfs_db&gt; sb 1<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">xfs_db&gt; p<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">magicnum =3D 0xf6b89fbf<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">blocksize =3D 1483932129<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">dblocks =3D 1569400993310172213=
7<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rblocks =3D 1106862675601690281=
1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rextents =3D 159306362214830012=
8<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">uuid =3D 6d1ec280-7f96-c817-0f7=
2-d68433061de8<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logstart =3D 174146117444932300=
66<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rootino =3D 9197560587205818314=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rbmino =3D 1554642860151675405<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rsumino =3D 377387355824336886<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rextsize =3D 1433889823<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">agblocks =3D 3940333176<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">agcount =3D 2930968516<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rbmblocks =3D 422920841<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logblocks =3D 4017127169<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">versionnum =3D 0xd520<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">sectsize =3D 19409<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inodesize =3D 16393<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inopblock =3D 2470<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">fname =3D &quot;\323R|\0066\274=
\271\252\240\370-\231&quot;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">blocklog =3D 164<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">sectlog =3D 42<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inodelog =3D 53<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inopblog =3D 10<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">agblklog =3D 72<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rextslog =3D 24<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inprogress =3D 224<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">imax_pct =3D 46<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">icount =3D 11911544493988237103=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">ifree =3D 3385761089021187134<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">fdblocks =3D 939599960743384723=
0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">frextents =3D 79465465603645252=
21<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">uquotino =3D 150842739781621744=
17<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">gquotino =3D 478665847475212977=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">qflags =3D 0x1301<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">flags =3D 0x37<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">shared_vn =3D 3<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inoalignmt =3D 3222551805<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">unit =3D 3368784749<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">width =3D 3167603851<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">dirblklog =3D 130<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logsectlog =3D 143<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logsectsize =3D 2101<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logsunit =3D 2030308911<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features2 =3D 0x5d5cbbfe<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">bad_features2 =3D 0x2afcd122<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features_compat =3D 0x2a3d35d5<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features_ro_compat =3D 0xa4e58b=
a9<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features_incompat =3D 0x13dccb6=
0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features_log_incompat =3D 0xe79=
d437a<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">crc =3D 0xbd38d745 (unchecked)<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">pquotino =3D 777823391929190344=
1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">lsn =3D 0xa8ffb559acd96aea<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">xfs_db&gt; sb 2<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">xfs_db&gt; p<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">magicnum =3D 0x41474341<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">blocksize =3D 1195590471<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">dblocks =3D 4847921951085253716=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rblocks =3D 4846789398308864835=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rextents =3D 470213212529670741=
2<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">uuid =3D 41544354-5441-4141-475=
4-544743544743<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logstart =3D 470382105666055404=
9<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rootino =3D 4703802364996815473=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rbmino =3D 7814906735281653061<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rsumino =3D 4991471925827290437=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rextsize =3D 1162167621<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">agblocks =3D 1162167621<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">agcount =3D 1162167621<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rbmblocks =3D 1162167621<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logblocks =3D 1162167621<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">versionnum =3D 0x4545<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">sectsize =3D 17733<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inodesize =3D 17733<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inopblock =3D 17733<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">fname =3D &quot;EEEEEEEEEEEE&qu=
ot;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">blocklog =3D 69<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">sectlog =3D 69<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inodelog =3D 69<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inopblog =3D 69<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">agblklog =3D 69<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">rextslog =3D 69<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inprogress =3D 69<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">imax_pct =3D 69<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">icount =3D 4991471925827290437<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">ifree =3D 4991471925827290437<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">fdblocks =3D 499147192582729043=
7<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">frextents =3D 49914719258272904=
37<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">uquotino =3D 499147192582729043=
7<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">gquotino =3D 499147192582729043=
7<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">qflags =3D 0x4545<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">flags =3D 0x45<o:p></o:p></span=
></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">shared_vn =3D 69<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inoalignmt =3D 1162167621<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">unit =3D 1162167621<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">width =3D 1162167621<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">dirblklog =3D 69<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logsectlog =3D 69<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logsectsize =3D 17733<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">logsunit =3D 1162167621<o:p></o=
:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features2 =3D 0x45454545<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">bad_features2 =3D 0x45454545<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features_compat =3D 0x45454545<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features_ro_compat =3D 0x454545=
45<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features_incompat =3D 0x450a646=
1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">features_log_incompat =3D 0x746=
12e75<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">crc =3D 0x6e697469 (unchecked)<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">pquotino =3D 853135083179536369=
9<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">lsn =3D 0x74617420302e3032<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">xfs_db&gt;<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"mso-fareast-language:FR-CA">---<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"mso-fareast-language:FR-CA">St=E9phan=
e Larose<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"mso-fareast-language:FR-CA">Analyste =
de l'informatique<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"mso-fareast-language:FR-CA">Institut =
de Biologie Int=E9grative et des Syst=E8mes (IBIS)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"mso-fareast-language:FR-CA">Pavillon =
Charles-Eug=E8ne-Marchand<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"mso-fareast-language:FR-CA">Universit=
=E9 Laval<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_d738a94784a0426e97752f92f38325a0ulexcprmbx11ulavalca_--


--===============9163573559556542887==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9163573559556542887==--
