Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 396187CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 15:17:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A78E304032
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 13:17:00 -0700 (PDT)
Received: from dayis01iron01.ad.reyrey.com ([192.112.245.69]) by cuda.sgi.com
	with ESMTP id rZ55BDrcp9aXQ7LU (version=TLSv1.2 cipher=RC4-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 13:16:57 -0700 (PDT)
From: "Simpson, John R" <john_simpson@reyrey.com>
Date: Thu, 7 Apr 2016 16:16:55 -0400
Subject: Determining whether stripe unit and stripe size were detected
	correctly
Message-ID: <5BDD118B6525E24D82051EDA520EB5FC0105339D@IS-EXMB07-RP.ad.reyrey.com>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2167273139738264519=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2167273139738264519==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_5BDD118B6525E24D82051EDA520EB5FC0105339DISEXMB07RPadrey_"

--_000_5BDD118B6525E24D82051EDA520EB5FC0105339DISEXMB07RPadrey_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Greetings,

                I'm in the process of tracking down lower than expected per=
formance and occasional blocked tasks on some internal file servers with XF=
S datastores.  Several sources have pointed out the importance of using the=
 correct stripe unit and stripe size when formatting and mounting XFS files=
ystems, and that XFS can detect these values for some, but not all, hardwar=
e RAID controllers.  The servers in question are PowerEdge R510b servers wi=
th PERC H700 controllers.  Datastores are RAID5 with a 128K stripe.

                Is there any way to determine if the stripe unit and stripe=
 size were detected correctly?  These values were not specified when the fi=
lesystems were formatted or mounted.  If they were not detected, is there a=
ny way to determine them programmatically?

                If this is not the correct forum for this question please p=
oint me in the right direction.

Best regards,

John Simpson

Format command: mkfs.xfs /dev/sdb1
Fstab entry: /dev/sdb1       /DS01   xfs     defaults,logbufs=3D8      1 2

# uname -a
Linux reyqa-ribs001 2.6.32-573.12.1.el6.x86_64 #1 SMP Tue Dec 15 21:19:08 U=
TC 2015 x86_64 x86_64 x86_64 GNU/Linux

# cat /etc/redhat-release
CentOS release 6.7 (Final)

# rpm -qi xfsprogs
Name        : xfsprogs                     Relocations: (not relocatable)
Version     : 3.1.1                             Vendor: CentOS
Release     : 16.el6                        Build Date: Wed 15 Oct 2014 10:=
16:05 AM EDT
Install Date: Wed 25 Feb 2015 11:46:11 AM EST      Build Host: c6b8.bsys.de=
v.centos.org
Group       : System Environment/Base       Source RPM: xfsprogs-3.1.1-16.e=
l6.src.rpm
Size        : 3325667                          License: GPL+ and LGPLv2+
Signature   : RSA/SHA1, Fri 17 Oct 2014 04:00:19 PM EDT, Key ID 0946fca2c10=
5b9de
Packager    : CentOS BuildSystem <http://bugs.centos.org>
URL         : http://oss.sgi.com/projects/xfs/
Summary     : Utilities for managing the XFS filesystem
Description :
A set of commands to use the XFS filesystem, including mkfs.xfs.

XFS is a high performance journaling filesystem which originated
on the SGI IRIX platform.  It is completely multi-threaded, can
support large files and large filesystems, extended attributes,
variable block sizes, is extent based, and makes extensive use of
Btrees (directories, extents, free space) to aid both performance
and scalability.

Refer to the documentation at http://oss.sgi.com/projects/xfs/
for complete details.  This implementation is on-disk compatible
with the IRIX version of XFS.

# xfs_info /DS01
meta-data=3D/dev/sdb1              isize=3D256    agcount=3D5, agsize=3D268=
435455 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D0
data     =3D                       bsize=3D4096   blocks=3D1212415488, imax=
pct=3D5
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

John Simpson


--_000_5BDD118B6525E24D82051EDA520EB5FC0105339DISEXMB07RPadrey_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40"><head><meta http-equiv=3DContent-Type content=
=3D"text/html; charset=3Dus-ascii"><meta name=3DGenerator content=3D"Micros=
oft Word 12 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:"Arial Black";
	panose-1:2 11 10 4 2 1 2 2 2 4;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{mso-style-priority:99;
	mso-style-link:"Balloon Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:8.0pt;
	font-family:"Tahoma","sans-serif";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.BalloonTextChar
	{mso-style-name:"Balloon Text Char";
	mso-style-priority:99;
	mso-style-link:"Balloon Text";
	font-family:"Tahoma","sans-serif";}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue vli=
nk=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal>Greetings,<o:p><=
/o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; I&#8217;m in the process of tracking down lower than expected =
performance and occasional blocked tasks on some internal file servers with=
 XFS datastores.&nbsp; Several sources have pointed out the importance of u=
sing the correct stripe unit and stripe size when formatting and mounting X=
FS filesystems, and that XFS can detect these values for some, but not all,=
 hardware RAID controllers.&nbsp; The servers in question are PowerEdge R51=
0b servers with PERC H700 controllers.&nbsp; Datastores are RAID5 with a 12=
8K stripe.<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=
=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; Is there any way to determine if the stripe un=
it and stripe size were detected correctly?&nbsp; These values were not spe=
cified when the filesystems were formatted or mounted.&nbsp; If they were n=
ot detected, is there any way to determine them programmatically?<o:p></o:p=
></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; If this is not the correct forum for this question please point me=
 in the right direction.<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:=
p></p><p class=3DMsoNormal>Best regards,<o:p></o:p></p><p class=3DMsoNormal=
><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>John Simpson<o:p></o:p></p><p cl=
ass=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Format command: m=
kfs.xfs /dev/sdb1<o:p></o:p></p><p class=3DMsoNormal>Fstab entry: /dev/sdb1=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /DS01&nbsp;&nbsp; xfs&nbsp;&nbsp;&nbsp=
;&nbsp; defaults,logbufs=3D8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 2<o:p></o:p></=
p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal><span styl=
e=3D'font-family:Consolas'># uname -a<o:p></o:p></span></p><p class=3DMsoNo=
rmal><span style=3D'font-family:Consolas'>Linux reyqa-ribs001 2.6.32-573.12=
.1.el6.x86_64 #1 SMP Tue Dec 15 21:19:08 UTC 2015 x86_64 x86_64 x86_64 GNU/=
Linux<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:=
Consolas'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=3D'f=
ont-family:Consolas'># cat /etc/redhat-release<o:p></o:p></span></p><p clas=
s=3DMsoNormal><span style=3D'font-family:Consolas'>CentOS release 6.7 (Fina=
l)<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:Con=
solas'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=3D'font=
-family:Consolas'># rpm -qi xfsprogs<o:p></o:p></span></p><p class=3DMsoNor=
mal><span style=3D'font-family:Consolas'>Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; : xfsprogs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Reloca=
tions: (not relocatable)<o:p></o:p></span></p><p class=3DMsoNormal><span st=
yle=3D'font-family:Consolas'>Version&nbsp;&nbsp;&nbsp;&nbsp; : 3.1.1&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; Vendor: CentOS<o:p></o:p></span></p><p class=3DMsoNormal><span =
style=3D'font-family:Consolas'>Release&nbsp;&nbsp;&nbsp;&nbsp; : 16.el6&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Build Date: Wed=
 15 Oct 2014 10:16:05 AM EDT<o:p></o:p></span></p><p class=3DMsoNormal><spa=
n style=3D'font-family:Consolas'>Install Date: Wed 25 Feb 2015 11:46:11 AM =
EST&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Build Host: c6b8.bsys.dev.centos.org<o:p>=
</o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:Consolas'>=
Group&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : System Environment/Base&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; Source RPM: xfsprogs-3.1.1-16.el6.src.rpm<o:p>=
</o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:Consolas'>=
Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 3325667&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; License: GPL+ and =
LGPLv2+<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-famil=
y:Consolas'>Signature&nbsp;&nbsp; : RSA/SHA1, Fri 17 Oct 2014 04:00:19 PM E=
DT, Key ID 0946fca2c105b9de<o:p></o:p></span></p><p class=3DMsoNormal><span=
 style=3D'font-family:Consolas'>Packager&nbsp;&nbsp;&nbsp; : CentOS BuildSy=
stem &lt;http://bugs.centos.org&gt;<o:p></o:p></span></p><p class=3DMsoNorm=
al><span style=3D'font-family:Consolas'>URL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; : http://oss.sgi.com/projects/xfs/<o:p></o:p></span></p><p=
 class=3DMsoNormal><span style=3D'font-family:Consolas'>Summary&nbsp;&nbsp;=
&nbsp;&nbsp; : Utilities for managing the XFS filesystem<o:p></o:p></span><=
/p><p class=3DMsoNormal><span style=3D'font-family:Consolas'>Description :<=
o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:Consol=
as'>A set of commands to use the XFS filesystem, including mkfs.xfs.<o:p></=
o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:Consolas'><o=
:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:C=
onsolas'>XFS is a high performance journaling filesystem which originated<o=
:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:Consola=
s'>on the SGI IRIX platform.&nbsp; It is completely multi-threaded, can<o:p=
></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:Consolas'=
>support large files and large filesystems, extended attributes,<o:p></o:p>=
</span></p><p class=3DMsoNormal><span style=3D'font-family:Consolas'>variab=
le block sizes, is extent based, and makes extensive use of<o:p></o:p></spa=
n></p><p class=3DMsoNormal><span style=3D'font-family:Consolas'>Btrees (dir=
ectories, extents, free space) to aid both performance<o:p></o:p></span></p=
><p class=3DMsoNormal><span style=3D'font-family:Consolas'>and scalability.=
<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:Conso=
las'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span style=3D'font-f=
amily:Consolas'>Refer to the documentation at http://oss.sgi.com/projects/x=
fs/<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:Co=
nsolas'>for complete details.&nbsp; This implementation is on-disk compatib=
le<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:Con=
solas'>with the IRIX version of XFS.<o:p></o:p></span></p><p class=3DMsoNor=
mal><span style=3D'font-family:Consolas'><o:p>&nbsp;</o:p></span></p><p cla=
ss=3DMsoNormal><span style=3D'font-family:Consolas'># xfs_info /DS01<o:p></=
o:p></span></p><p class=3DMsoNormal><span style=3D'font-family:Consolas'>me=
ta-data=3D/dev/sdb1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; isize=3D256&nbsp;&nbsp;&nbsp; agcount=3D5, agsize=3D=
268435455 blks<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'fon=
t-family:Consolas'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=3D512&nbsp;&nb=
sp; attr=3D2, projid32bit=3D0<o:p></o:p></span></p><p class=3DMsoNormal><sp=
an style=3D'font-family:Consolas'>data&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=3D4096&nbsp;&nbsp; b=
locks=3D1212415488, imaxpct=3D5<o:p></o:p></span></p><p class=3DMsoNormal><=
span style=3D'font-family:Consolas'>&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; suni=
t=3D0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; swidth=3D0 blks<o:p></o:p></span></p><p=
 class=3DMsoNormal><span style=3D'font-family:Consolas'>naming&nbsp;&nbsp; =
=3Dversion 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; bsize=3D4096&nbsp;&nbsp; ascii-ci=3D0<o:p></o:p></span></p>=
<p class=3DMsoNormal><span style=3D'font-family:Consolas'>log&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; =3Dinternal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=3D4096&nbsp;&nbsp; blocks=3D521=
728, version=3D2<o:p></o:p></span></p><p class=3DMsoNormal><span style=3D'f=
ont-family:Consolas'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=3D512&nbsp;&=
nbsp; sunit=3D0 blks, lazy-count=3D1<o:p></o:p></span></p><p class=3DMsoNor=
mal><span style=3D'font-family:Consolas'>realtime =3Dnone&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; extsz=3D4096&nbsp;&nbsp; blocks=3D0, rtextents=3D0<o:p></o:=
p></span></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal=
 style=3D'mso-margin-top-alt:auto'><span style=3D'font-size:10.0pt;font-fam=
ily:"Arial Black","sans-serif";color:#002878;letter-spacing:1.0pt'>John Sim=
pson</span><span style=3D'font-size:10.0pt;font-family:"Arial Black","sans-=
serif";color:#002878;letter-spacing:1.0pt'>&nbsp;</span><span style=3D'font=
-size:13.5pt;font-family:"Times New Roman","serif";color:black'><br><br></s=
pan><o:p></o:p></p></div></body></html>=

--_000_5BDD118B6525E24D82051EDA520EB5FC0105339DISEXMB07RPadrey_--


--===============2167273139738264519==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2167273139738264519==--
