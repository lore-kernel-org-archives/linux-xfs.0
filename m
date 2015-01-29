Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D7357F63
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 11:37:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1CE79304043
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 09:36:57 -0800 (PST)
Received: from smtp.tsag.net (smtp.tsag.net [208.118.68.4]) by cuda.sgi.com
	with ESMTP id 5cPcGBtWqUvBGzHj for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 09:36:56 -0800 (PST)
Received: from exchange.tsag.local (exchange.tsag.local [10.254.0.249]) by
	smtp.tsag.net with ESMTP id VZujxrXledHXs3EG for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2015 10:36:54 -0700 (MST)
From: Gerard Beekmans <GBeekmans@tsag.net>
Subject: Unable to mount and repair filesystems
Date: Thu, 29 Jan 2015 17:36:53 +0000
Message-ID: <D90435AEFF34654AA1122988C66C8678023F0277C9@exchange.tsag.local>
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
Content-Type: multipart/mixed; boundary="===============5934177781757357330=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5934177781757357330==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D90435AEFF34654AA1122988C66C8678023F0277C9exchangetsagl_"

--_000_D90435AEFF34654AA1122988C66C8678023F0277C9exchangetsagl_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

One of our VMware VMs crashed which has resulted in a few XFS filesystems u=
nable to mount and be repaired.

Some VM details:

-          Distribution is CentOS 7

-          Partitions reside inside LVM

-          Tried CentOS provided xfsprogs-3.2.0-alpha2 as well as manually =
compiling 3.2.2

When attempting to mount:

[71895.922382] XFS (dm-9): Mounting Filesystem
[71895.994614] XFS (dm-9): Starting recovery (logdev: internal)
[71896.000910] XFS (dm-9): Metadata corruption detected at xfs_agf_read_ver=
ify+0x70/0x120 [xfs], block 0x753001
[71896.002304] XFS (dm-9): Unmount and run xfs_repair
[71896.003649] XFS (dm-9): First 64 bytes of corrupted metadata buffer:
[71896.005049] ffff8800b1200c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00  ................
[71896.006468] ffff8800b1200c10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00  ................
[71896.007799] ffff8800b1200c20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00  ................
[71896.009116] ffff8800b1200c30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00  ................
[71896.010482] XFS (dm-9): metadata I/O error: block 0x753001 ("xfs_trans_r=
ead_buf_map") error 117 numblks 1
mount: mount /dev/mapper/data-srv on /srv failed: Structure needs cleaning


xfs_repair:

xfs_repair /dev/mapper/data-srv
Phase 1 - find and verify superblock...
couldn't verify primary superblock - bad magic number !!!

attempting to find secondary superblock...
...
Found candidate secondary superblock...
Unable to verify superblock, continuing...

And on it goes until it eventually gives up.

There are two XFS partitions that are having these issues. The other 8 this=
 VM has ended up repairing and mounting properly.

If there is anything I can do to fix these issues that would be appreciated=
. I have a bit of time before this VM needs to be up and running (which wil=
l involve formatting the filesystem and restoring from a backup). I'd love =
to help out the XFS project by providing any debug information you might fi=
nd useful.

Regards,

Gerard Beekmans


--_000_D90435AEFF34654AA1122988C66C8678023F0277C9exchangetsagl_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:374356896;
	mso-list-type:hybrid;
	mso-list-template-ids:-1938898078 -1988609116 67698691 67698693 67698689 6=
7698691 67698693 67698689 67698691 67698693;}
@list l0:level1
	{mso-level-start-at:0;
	mso-level-number-format:bullet;
	mso-level-text:-;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Calibri",sans-serif;
	mso-fareast-font-family:Calibri;
	mso-bidi-font-family:"Times New Roman";}
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
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">One of our VMware VMs crashed which has resulted in =
a few XFS filesystems unable to mount and be repaired.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Some VM details:<o:p></o:p></p>
<p class=3D"MsoListParagraph" style=3D"text-indent:-.25in;mso-list:l0 level=
1 lfo1"><![if !supportLists]><span style=3D"mso-list:Ignore">-<span style=
=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;
</span></span><![endif]>Distribution is CentOS 7<o:p></o:p></p>
<p class=3D"MsoListParagraph" style=3D"text-indent:-.25in;mso-list:l0 level=
1 lfo1"><![if !supportLists]><span style=3D"mso-list:Ignore">-<span style=
=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;
</span></span><![endif]>Partitions reside inside LVM<o:p></o:p></p>
<p class=3D"MsoListParagraph" style=3D"text-indent:-.25in;mso-list:l0 level=
1 lfo1"><![if !supportLists]><span style=3D"mso-list:Ignore">-<span style=
=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;
</span></span><![endif]>Tried CentOS provided xfsprogs-3.2.0-alpha2 as well=
 as manually compiling 3.2.2<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">When attempting to mount:<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">[71895.922382] XFS (dm-9): Mounting Filesystem<o:p><=
/o:p></p>
<p class=3D"MsoNormal">[71895.994614] XFS (dm-9): Starting recovery (logdev=
: internal)<o:p></o:p></p>
<p class=3D"MsoNormal">[71896.000910] XFS (dm-9): Metadata corruption detec=
ted at xfs_agf_read_verify&#43;0x70/0x120 [xfs], block 0x753001<o:p></o:p><=
/p>
<p class=3D"MsoNormal">[71896.002304] XFS (dm-9): Unmount and run xfs_repai=
r<o:p></o:p></p>
<p class=3D"MsoNormal">[71896.003649] XFS (dm-9): First 64 bytes of corrupt=
ed metadata buffer:<o:p></o:p></p>
<p class=3D"MsoNormal">[71896.005049] ffff8800b1200c00: 00 00 00 00 00 00 0=
0 00 00 00 00 00 00 00 00 00&nbsp; ................<o:p></o:p></p>
<p class=3D"MsoNormal">[71896.006468] ffff8800b1200c10: 00 00 00 00 00 00 0=
0 00 00 00 00 00 00 00 00 00&nbsp; ................<o:p></o:p></p>
<p class=3D"MsoNormal">[71896.007799] ffff8800b1200c20: 00 00 00 00 00 00 0=
0 00 00 00 00 00 00 00 00 00&nbsp; ................<o:p></o:p></p>
<p class=3D"MsoNormal">[71896.009116] ffff8800b1200c30: 00 00 00 00 00 00 0=
0 00 00 00 00 00 00 00 00 00&nbsp; ................<o:p></o:p></p>
<p class=3D"MsoNormal">[71896.010482] XFS (dm-9): metadata I/O error: block=
 0x753001 (&quot;xfs_trans_read_buf_map&quot;) error 117 numblks 1<o:p></o:=
p></p>
<p class=3D"MsoNormal">mount: mount /dev/mapper/data-srv on /srv failed: St=
ructure needs cleaning<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">xfs_repair:<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">xfs_repair /dev/mapper/data-srv<o:p></o:p></p>
<p class=3D"MsoNormal">Phase 1 - find and verify superblock...<o:p></o:p></=
p>
<p class=3D"MsoNormal">couldn't verify primary superblock - bad magic numbe=
r !!!<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">attempting to find secondary superblock...<o:p></o:p=
></p>
<p class=3D"MsoNormal">&#8230;<o:p></o:p></p>
<p class=3D"MsoNormal">Found candidate secondary superblock&#8230;<o:p></o:=
p></p>
<p class=3D"MsoNormal">Unable to verify superblock, continuing&#8230;<o:p><=
/o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">And on it goes until it eventually gives up.<o:p></o=
:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">There are two XFS partitions that are having these i=
ssues. The other 8 this VM has ended up repairing and mounting properly.<o:=
p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">If there is anything I can do to fix these issues th=
at would be appreciated. I have a bit of time before this VM needs to be up=
 and running (which will involve formatting the filesystem and restoring fr=
om a backup). I&#8217;d love to help out
 the XFS project by providing any debug information you might find useful.<=
o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Regards,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Gerard Beekmans<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_D90435AEFF34654AA1122988C66C8678023F0277C9exchangetsagl_--


--===============5934177781757357330==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5934177781757357330==--
