Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C44ED7F80
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 15:45:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6B1B2304043
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 13:45:32 -0700 (PDT)
Received: from mail1.dothill.com (mail1.dothill.com [155.254.1.50]) by
	cuda.sgi.com with ESMTP id ROe62uW7gA3YsTOD for
	<xfs@oss.sgi.com>; Tue, 15 Oct 2013 13:45:31 -0700 (PDT)
From: Mike Jensen <Mike.Jensen@dothill.com>
Date: Tue, 15 Oct 2013 14:45:28 -0600
Subject: XFS - configuration for multi-thread high-speed streams
Message-ID: <C08036CF9E2BAC498EFDA29CB9BDF25B34B9D1E06D@dc-ex1.power.com>
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
Content-Type: multipart/mixed; boundary="===============0348591283630238364=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0348591283630238364==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_C08036CF9E2BAC498EFDA29CB9BDF25B34B9D1E06Ddcex1powercom_"

--_000_C08036CF9E2BAC498EFDA29CB9BDF25B34B9D1E06Ddcex1powercom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Group - 1st time post, looks like just use the email address I have seen=
 from other posts
If the setup/info/questions below are not suitable for this list, is there =
another xfs list available for these??

Thanks
mike

Configuration -


-          RH 6.4 on HP G8 server w/16GB mem (could add a lot more)

-          12Gb SAS connections (2) to storage

-          Storage

-          96 LFF HDD's (4TB 7K NLSAS) presently organized as 8 x 10+2 R6 r=
aidsets

-          8 volumes mapped to host ports (MPIO engaged)

-          Mdadm used to stripe (/dev/dm*) LUNs into a single md device (ap=
prox. 300+TB file system space)

-          Mkfs.xfs used to lay down file system

-

-          Workload

-          Application creates file of specified length in dir of mount poi=
nt, IO's then issued to file(s), each file receives 1 stream of IO

-          1 x high speed stream 1000MB/s Seq W (IO's arrive as 512KB -=3D>=
 4MB frame would be 8 x 512KB IO's)

-          2 x med-speed streams 200MB/s Seq W "

-          30-50 low speed streams 10MB/s Seq W "

Objectives/Questions -


-          Would like to optimize xfs/mount parameters to make maximal use =
of storage assets

-          Thinking of using 15K HDD R1 set for log files - would this get =
all/most of metadata or just a subset?  Right now seeing metadata writes ar=
riving with data writes and want to peel them off the 7K HDD's

-          Would using sub-directories for each file ensure that each subdi=
r/file would be in it's own alloc group? And that would keep the streaming =
data in a separate AG - could help the storage more efficiently destage the=
 writes from cache to disk


--_000_C08036CF9E2BAC498EFDA29CB9BDF25B34B9D1E06Ddcex1powercom_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40"><head><meta http-equiv=3DContent-Type content=
=3D"text/html; charset=3Dus-ascii"><meta name=3DGenerator content=3D"Micros=
oft Word 14 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
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
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:308828040;
	mso-list-type:hybrid;
	mso-list-template-ids:-1234300568 -382555044 67698691 67698693 67698689 67=
698691 67698693 67698689 67698691 67698693;}
@list l0:level1
	{mso-level-start-at:2101;
	mso-level-number-format:bullet;
	mso-level-text:-;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Calibri","sans-serif";
	mso-fareast-font-family:Calibri;}
@list l0:level2
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l0:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l0:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Symbol;}
@list l0:level5
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l0:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l0:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Symbol;}
@list l0:level8
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l0:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue vli=
nk=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal>Hi Group - 1<sup=
>st</sup> time post, looks like just use the email address I have seen from=
 other posts<o:p></o:p></p><p class=3DMsoNormal>If the setup/info/questions=
 below are not suitable for this list, is there another xfs list available =
for these??<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p clas=
s=3DMsoNormal>Thanks<o:p></o:p></p><p class=3DMsoNormal>mike<o:p></o:p></p>=
<p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Configuratio=
n &#8211;<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=
=3DMsoListParagraph style=3D'text-indent:-.25in;mso-list:l0 level1 lfo1'><!=
[if !supportLists]><span style=3D'mso-list:Ignore'>-<span style=3D'font:7.0=
pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; </span></span><![endif]>RH 6.4 on HP G8 server w/16GB mem (could add a lo=
t more)<o:p></o:p></p><p class=3DMsoListParagraph style=3D'text-indent:-.25=
in;mso-list:l0 level1 lfo1'><![if !supportLists]><span style=3D'mso-list:Ig=
nore'>-<span style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><![endif]>12Gb SAS connection=
s (2) to storage<o:p></o:p></p><p class=3DMsoListParagraph style=3D'text-in=
dent:-.25in;mso-list:l0 level1 lfo1'><![if !supportLists]><span style=3D'ms=
o-list:Ignore'>-<span style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><![endif]>Storage<o:=
p></o:p></p><p class=3DMsoListParagraph style=3D'text-indent:-.25in;mso-lis=
t:l0 level1 lfo1'><![if !supportLists]><span style=3D'mso-list:Ignore'>-<sp=
an style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; </span></span><![endif]>96 LFF HDD&#8217;s (4TB 7K NL=
SAS) presently organized as 8 x 10+2 R6 raidsets<o:p></o:p></p><p class=3DM=
soListParagraph style=3D'text-indent:-.25in;mso-list:l0 level1 lfo1'><![if =
!supportLists]><span style=3D'mso-list:Ignore'>-<span style=3D'font:7.0pt "=
Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </=
span></span><![endif]>8 volumes mapped to host ports (MPIO engaged)<o:p></o=
:p></p><p class=3DMsoListParagraph style=3D'text-indent:-.25in;mso-list:l0 =
level1 lfo1'><![if !supportLists]><span style=3D'mso-list:Ignore'>-<span st=
yle=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; </span></span><![endif]>Mdadm used to stripe (/dev/dm*) LU=
Ns into a single md device (approx. 300+TB file system space)<o:p></o:p></p=
><p class=3DMsoListParagraph style=3D'text-indent:-.25in;mso-list:l0 level1=
 lfo1'><![if !supportLists]><span style=3D'mso-list:Ignore'>-<span style=3D=
'font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; </span></span><![endif]>Mkfs.xfs used to lay down file system<o:=
p></o:p></p><p class=3DMsoListParagraph style=3D'text-indent:-.25in;mso-lis=
t:l0 level1 lfo1'><![if !supportLists]><span style=3D'mso-list:Ignore'>-<sp=
an style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; </span></span><![endif]><o:p>&nbsp;</o:p></p><p class=
=3DMsoListParagraph style=3D'text-indent:-.25in;mso-list:l0 level1 lfo1'><!=
[if !supportLists]><span style=3D'mso-list:Ignore'>-<span style=3D'font:7.0=
pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; </span></span><![endif]>Workload<o:p></o:p></p><p class=3DMsoListParagrap=
h style=3D'text-indent:-.25in;mso-list:l0 level1 lfo1'><![if !supportLists]=
><span style=3D'mso-list:Ignore'>-<span style=3D'font:7.0pt "Times New Roma=
n"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><!=
[endif]>Application creates file of specified length in dir of mount point,=
 IO&#8217;s then issued to file(s), each file receives 1 stream of IO<o:p><=
/o:p></p><p class=3DMsoListParagraph style=3D'text-indent:-.25in;mso-list:l=
0 level1 lfo1'><![if !supportLists]><span style=3D'mso-list:Ignore'>-<span =
style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; </span></span><![endif]>1 x high speed stream 1000MB/s S=
eq W (IO&#8217;s arrive as 512KB -=3D&gt; 4MB frame would be 8 x 512KB IO&#=
8217;s)<o:p></o:p></p><p class=3DMsoListParagraph style=3D'text-indent:-.25=
in;mso-list:l0 level1 lfo1'><![if !supportLists]><span style=3D'mso-list:Ig=
nore'>-<span style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><![endif]>2 x med-speed strea=
ms 200MB/s Seq W &#8220;<o:p></o:p></p><p class=3DMsoListParagraph style=3D=
'text-indent:-.25in;mso-list:l0 level1 lfo1'><![if !supportLists]><span sty=
le=3D'mso-list:Ignore'>-<span style=3D'font:7.0pt "Times New Roman"'>&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><![endif]>30=
-50 low speed streams 10MB/s Seq W &#8220;<o:p></o:p></p><p class=3DMsoNorm=
al><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Objectives/Questions &#8211;<o=
:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoListPa=
ragraph style=3D'text-indent:-.25in;mso-list:l0 level1 lfo1'><![if !support=
Lists]><span style=3D'mso-list:Ignore'>-<span style=3D'font:7.0pt "Times Ne=
w Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></s=
pan><![endif]>Would like to optimize xfs/mount parameters to make maximal u=
se of storage assets<o:p></o:p></p><p class=3DMsoListParagraph style=3D'tex=
t-indent:-.25in;mso-list:l0 level1 lfo1'><![if !supportLists]><span style=
=3D'mso-list:Ignore'>-<span style=3D'font:7.0pt "Times New Roman"'>&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><![endif]>Thin=
king of using 15K HDD R1 set for log files &#8211; would this get all/most =
of metadata or just a subset?&nbsp; Right now seeing metadata writes arrivi=
ng with data writes and want to peel them off the 7K HDD&#8217;s<o:p></o:p>=
</p><p class=3DMsoListParagraph style=3D'text-indent:-.25in;mso-list:l0 lev=
el1 lfo1'><![if !supportLists]><span style=3D'mso-list:Ignore'>-<span style=
=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; </span></span><![endif]>Would using sub-directories for each =
file ensure that each subdir/file would be in it&#8217;s own alloc group? A=
nd that would keep the streaming data in a separate AG &#8211; could help t=
he storage more efficiently destage the writes from cache to disk<o:p></o:p=
></p><p class=3DMsoNormal style=3D'margin-left:.25in'><o:p>&nbsp;</o:p></p>=
</div></body></html>=

--_000_C08036CF9E2BAC498EFDA29CB9BDF25B34B9D1E06Ddcex1powercom_--


--===============0348591283630238364==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0348591283630238364==--
