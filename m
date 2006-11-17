Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Nov 2006 08:25:24 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAHGPEaG011136
	for <xfs@oss.sgi.com>; Fri, 17 Nov 2006 08:25:17 -0800
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/related;
	boundary="----_=_NextPart_001_01C70A62.1E1EC3CD";
	type="multipart/alternative"
Subject: mkfs.xfs kernel panic with mdadm on RH4U3 kernel
Date: Fri, 17 Nov 2006 11:04:53 -0500
Message-ID: <A4F4647B12DBAD40B07041547CA2526404215D1F@msgusaebk01.autodesk.com>
From: "Billy Russell" <billy.russell@autodesk.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Jean Blouin <jean.blouin@autodesk.com>, Dominique Bocquet <dominique.bocquet@autodesk.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C70A62.1E1EC3CD
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_002_01C70A62.1E1EC3CD"

------_=_NextPart_002_01C70A62.1E1EC3CD
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Hi all

=20

            I have encountered a problem on RH4 U2 and U3 with mdadm as
the volume manager and XFS as the filesystem. The issue seems to be a
max capacity problem that did not exist on a 64bit RH3 kernel. We were
previously running on the ia32e kernel supplied with CXFS 3.4.6 for
Linux. With this Kernel we were able to use mdadm and a 13TB filesystem
with great performance and no capacity issues.

=20

            The configuration has been tested on 2 different platforms
and both QLogic and Atto FC cards as well as RH4U2 and RH4U3. Below if
the scenario (what fails and what doesn't) as well as the netdump log
file.

=20

=20

External 4 Gig FC RAID storage.

8 LUNs of 726 gigs

Mdadm 1.6.0-2

Open src XFS=20

This failed

=20

External 4 Gig FC RAID storage.

8 LUNs of 726 gigs

Mdadm 2.5.2-1

Open src XFS=20

This failed

=20

=20

External 4 Gig FC RAID storage.

8 LUNs of 726 gigs

Mdadm 2.5.2-1

CXFS 4.0 version of XFS=20

This failed

=20

External 4 Gig FC RAID storage.

6 LUNs of 726 gigs

This passes with any version of XFS and MDADM

=20

=20

If I use XVM and XFS I can configure the full storage configuration,
make a filesystem and run fine. There is some kind of link between mdadm
and XFS that is failing.

=20

Any help would be appreciated.

=20

LOG FILE FROM NETDUMP

=20

Unable to handle kernel paging request at 000001015a441340 RIP:

<ffffffffa0b9fab4>{:raid0:raid0_make_request+444}

PML4 8063 PGD 0

Oops: 0000 [1] SMP

CPU 2

Modules linked in: netconsole netdump raid0 celerityfc(U) wacom(U) sg
mvfs(U) vnode(U) nfsd exportfs md5 ipv6 parport_pc lp parport autofs4
nfs lockd nfs_acl sunrpc ics_sdp(U) ics_offload(U) ipoib(U) ics_dsc(U)
mt25218vpd(U) ibt(U) mst(U) ide_scsi xfs(U) dmapi(U) dm_mirror dm_mod
ohci1394 ieee1394 ohci_hcd0000010071d3db40
<ffffffff8024b0ea>{generic_make_request+355}
<ffffffff80134e7e>{autoremove_wake_function+0}

       <ffffffff8024b1f6>{submit_bio+247}
<ffffffff8017c6b8>{bio_alloc+288}

       <ffffffff8017a5e6>{submit_bh+255}
<ffffffff8017c115>{block_read_full_page+584}

       <ffffffff8017e847>{blkdev_get_block+0}
<ffffffff80159814>{do_generic_mapping_read+567}

       <ffffffff801599d4>{file_read_actor+0}
<ffffffff8015af96>{__generic_file_aio_write_nolock+731}

       <ffffffff8015b59c>{__generic_file_aio_read+385}
<ffffffff8015b737>{generic_file_read+187}

       <ffffffff801e8b09>{__up_read+16}
<ffffffff80134e7e>{autoremove_wake_function+0}

       <ffffffff80134e7e>{autoremove_wake_function+0}
<ffffffff80191a38>{dnotify_parent+34}

       <ffffffff80177f43>{vfs_read+207}
<ffffffff80178287>{sys_pread64+86}

       <ffffffff80110236>{system_call+126}

=20

Code: 48 8b 14 d0 48 8b 42 28 48 89 43 10 48 03 4a 40 b8 01 00 00

RIP <ffffffffa0b9fab4>{:raid0:raid0_make_request+444} RSP
<0000010071d3dac8>

CR2: 000001015a441340

=20

=20

=20

 Billy Russell

Storage & Networking Technical Lead

Autodesk - Media and Entertainment Division

10 rue Duke

Montreal, QC. H3C 2L7

514-954-7377 (office)=20

billy.russell@autodesk.com <mailto:billy.russell@autodesk.com>=20

=20


------_=_NextPart_002_01C70A62.1E1EC3CD
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" xmlns=3D"http://ww=
w.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<!--[if !mso]>
<style>
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style>
<![endif]--><o:SmartTagType
 namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags" name=3D"State"=
/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"place"/>
<o:SmartTagType namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"City"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1027" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Hi all<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; I
have encountered a problem on RH4 U2 and U3 with mdadm as the volume manager
and XFS as the filesystem. The issue seems to be a max capacity problem that
did not exist on a 64bit RH3 kernel. We were previously running on the ia32e
kernel supplied with CXFS 3.4.6 for Linux. With this Kernel we were able to=
 use
mdadm and a 13TB filesystem with great performance and no capacity issues.<=
o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; The
configuration has been tested on 2 different platforms and both QLogic and =
Atto
FC cards as well as RH4U2 and RH4U3. Below if the scenario (what fails and =
what
doesn&#8217;t) as well as the netdump log file.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>External 4 Gig FC RAID storage.<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><b><font size=3D2 face=3DArial><span style=3D'font-siz=
e:10.0pt;
font-family:Arial;font-weight:bold'>8 LUNs of 726 gigs<o:p></o:p></span></f=
ont></b></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Mdadm 1.6.0-2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Open src XFS <o:p></o:p></span></font></p>

<p class=3DMsoNormal><b><font size=3D2 face=3DArial><span style=3D'font-siz=
e:10.0pt;
font-family:Arial;font-weight:bold'>This failed<o:p></o:p></span></font></b=
></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>External 4 Gig FC RAID storage.<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><b><font size=3D2 face=3DArial><span style=3D'font-siz=
e:10.0pt;
font-family:Arial;font-weight:bold'>8 LUNs of 726 gigs<o:p></o:p></span></f=
ont></b></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Mdadm 2.5.2-1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Open src XFS <o:p></o:p></span></font></p>

<p class=3DMsoNormal><b><font size=3D2 face=3DArial><span style=3D'font-siz=
e:10.0pt;
font-family:Arial;font-weight:bold'>This failed<o:p></o:p></span></font></b=
></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>External 4 Gig FC RAID storage.<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><b><font size=3D2 face=3DArial><span style=3D'font-siz=
e:10.0pt;
font-family:Arial;font-weight:bold'>8 LUNs of 726 gigs<o:p></o:p></span></f=
ont></b></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Mdadm 2.5.2-1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>CXFS 4.0 version of XFS <o:p></o:p></span></font></p>

<p class=3DMsoNormal><b><font size=3D2 face=3DArial><span style=3D'font-siz=
e:10.0pt;
font-family:Arial;font-weight:bold'>This failed<o:p></o:p></span></font></b=
></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>External 4 Gig FC RAID storage.<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><b><font size=3D2 face=3DArial><span style=3D'font-siz=
e:10.0pt;
font-family:Arial;font-weight:bold'>6 LUNs of 726 gigs<o:p></o:p></span></f=
ont></b></p>

<p class=3DMsoNormal><b><font size=3D2 face=3DArial><span style=3D'font-siz=
e:10.0pt;
font-family:Arial;font-weight:bold'>This passes with any version of XFS and
MDADM<o:p></o:p></span></font></b></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>If I use <b><span style=3D'font-weight:bold'>XVM and XFS=
</span></b>
I can configure the full storage configuration, make a filesystem and run f=
ine.
There is some kind of link between mdadm and XFS that is failing.<o:p></o:p=
></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Any help would be appreciated.<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><b><font size=3D2 face=3DArial><span style=3D'font-siz=
e:10.0pt;
font-family:Arial;font-weight:bold'>LOG FILE FROM NETDUMP<o:p></o:p></span>=
</font></b></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>Unable to handle kernel paging request at
000001015a441340 RIP:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>&lt;ffffffffa0b9fab4&gt;{:raid0:raid0_make_reque=
st+444}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>PML4 8063 PGD 0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>Oops: 0000 [1] SMP<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>CPU 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>Modules linked in: netconsole netdump raid0
celerityfc(U) wacom(U) sg mvfs(U) vnode(U) nfsd exportfs md5 ipv6 parport_p=
c lp
parport autofs4 nfs lockd nfs_acl sunrpc ics_sdp(U) ics_offload(U) ipoib(U)
ics_dsc(U) mt25218vpd(U) ibt(U) mst(U) ide_scsi xfs(U) dmapi(U) dm_mirror
dm_mod ohci1394 ieee1394 ohci_hcd0000010071d3db40
&lt;ffffffff8024b0ea&gt;{generic_make_request+355}
&lt;ffffffff80134e7e&gt;{autoremove_wake_function+0}<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&lt;ffffffff8024b1f6&gt;{submit_bio+247}
&lt;ffffffff8017c6b8&gt;{bio_alloc+288}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&lt;ffffffff8017a5e6&gt;{submit_bh+255}
&lt;ffffffff8017c115&gt;{block_read_full_page+584}<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &lt;fffffff=
f8017e847&gt;{blkdev_get_block+0}
&lt;ffffffff80159814&gt;{do_generic_mapping_read+567}<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&lt;ffffffff801599d4&gt;{file_read_actor+0}
&lt;ffffffff8015af96&gt;{__generic_file_aio_write_nolock+731}<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&lt;ffffffff8015b59c&gt;{__generic_file_aio_read+385}
&lt;ffffffff8015b737&gt;{generic_file_read+187}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&lt;ffffffff801e8b09&gt;{__up_read+16} &lt;ffffffff80134e7e&gt;{autoremove_=
wake_function+0}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&lt;ffffffff80134e7e&gt;{autoremove_wake_function+0}
&lt;ffffffff80191a38&gt;{dnotify_parent+34}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&lt;ffffffff80177f43&gt;{vfs_read+207} &lt;ffffffff80178287&gt;{sys_pread64=
+86}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&lt;ffffffff80110236&gt;{system_call+126}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>Code: 48 8b 14 d0 48 8b 42 28 48 89 43 10 48 03 =
4a
40 b8 01 00 00<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>RIP
&lt;ffffffffa0b9fab4&gt;{:raid0:raid0_make_request+444} RSP
&lt;0000010071d3dac8&gt;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span style=3D'fon=
t-size:10.0pt;
font-family:"Courier New"'>CR2: 000001015a441340<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><!--[if gte vml 1]><v:shapetype id=3D"_x0000_t75" coor=
dsize=3D"21600,21600"=20
 o:spt=3D"75" o:preferrelative=3D"t" path=3D"m@4@5l@4@11@9@11@9@5xe" filled=
=3D"f"=20
 stroked=3D"f">
 <v:stroke joinstyle=3D"miter" />
 <v:formulas>
  <v:f eqn=3D"if lineDrawn pixelLineWidth 0" />
  <v:f eqn=3D"sum @0 1 0" />
  <v:f eqn=3D"sum 0 0 @1" />
  <v:f eqn=3D"prod @2 1 2" />
  <v:f eqn=3D"prod @3 21600 pixelWidth" />
  <v:f eqn=3D"prod @3 21600 pixelHeight" />
  <v:f eqn=3D"sum @0 0 1" />
  <v:f eqn=3D"prod @6 1 2" />
  <v:f eqn=3D"prod @7 21600 pixelWidth" />
  <v:f eqn=3D"sum @8 21600 0" />
  <v:f eqn=3D"prod @7 21600 pixelHeight" />
  <v:f eqn=3D"sum @10 21600 0" />
 </v:formulas>
 <v:path o:extrusionok=3D"f" gradientshapeok=3D"t" o:connecttype=3D"rect" />
 <o:lock v:ext=3D"edit" aspectratio=3D"t" />
</v:shapetype><v:shape id=3D"_x0000_s1026" type=3D"#_x0000_t75" style=3D'po=
sition:absolute;
 margin-left:0;margin-top:0;width:12pt;height:70.5pt;z-index:1;
 mso-position-horizontal:left;mso-position-vertical:top;
 mso-position-vertical-relative:line' o:allowoverlap=3D"f">
 <v:imagedata src=3D"cid:image001.png@01C70A37.CF788690" o:title=3D"adsk" />
 <w:wrap type=3D"square"/>
</v:shape><![endif]--><![if !vml]><img width=3D16 height=3D94
src=3D"cid:image003.jpg@01C70A37.CF788690" align=3Dleft hspace=3D12 v:shape=
s=3D"_x0000_s1026"><![endif]><b><font
size=3D1 color=3Dblack face=3DArial><span style=3D'font-size:8.0pt;font-fam=
ily:Arial;
color:black;font-weight:bold'>Billy Russell</span></font></b><font size=3D2
color=3Dblack face=3DArial><span style=3D'font-size:10.0pt;font-family:Aria=
l;
color:black'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><b><font size=3D1 color=3Dblack face=3DArial><span
style=3D'font-size:8.0pt;font-family:Arial;color:black;font-weight:bold'>St=
orage
&amp; Networking Technical Lead</span></font></b><font size=3D2 color=3Dbla=
ck
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial;color:black'=
><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3D"#333333" face=3DArial><span
style=3D'font-size:8.0pt;font-family:Arial;color:#333333'>Autodesk &#8211; =
Media
and Entertainment Division</span></font><font size=3D2 color=3D"#333333"
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial;color:#33333=
3'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 color=3D"#333333" face=3DArial><span
style=3D'font-size:8.0pt;font-family:Arial;color:#333333'>10 rue Duke</span=
></font><font
size=3D2 color=3D"#333333" face=3DArial><span style=3D'font-size:10.0pt;fon=
t-family:
Arial;color:#333333'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><st1:place w:st=3D"on"><st1:City w:st=3D"on"><font siz=
e=3D1
  color=3D"#333333" face=3DArial><span style=3D'font-size:8.0pt;font-family=
:Arial;
  color:#333333'>Montreal</span></font></st1:City><font size=3D1 color=3D"#=
333333"
 face=3DArial><span style=3D'font-size:8.0pt;font-family:Arial;color:#33333=
3'>, <st1:State
 w:st=3D"on">QC</st1:State></span></font></st1:place><font size=3D1 color=
=3D"#333333"
face=3DArial><span style=3D'font-size:8.0pt;font-family:Arial;color:#333333=
'>. H3C
2L7</span></font><font size=3D2 color=3D"#333333" face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial;color:#333333'><o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font size=3D1 color=3D"#333333" face=3DArial><span
style=3D'font-size:8.0pt;font-family:Arial;color:#333333'>514-954-7377 (off=
ice) <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><a href=3D"mailto:billy.russell@autodesk.com"><font size=3D1 face=
=3DArial><span
style=3D'font-size:8.0pt;font-family:Arial'>billy.russell@autodesk.com</spa=
n></font></a></span></font><font
size=3D2 face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial'><o=
:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_002_01C70A62.1E1EC3CD--

------_=_NextPart_001_01C70A62.1E1EC3CD
Content-Type: image/jpeg;
	name="image003.jpg"
Content-Transfer-Encoding: base64
Content-ID: <image003.jpg@01C70996.F24B3D30>
Content-Description: image003.jpg
Content-Location: image003.jpg

/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAoHBwgHBgoICAgLCgoLDhgQDg0N
Dh0VFhEYIx8lJCIfIiEmKzcvJik0KSEiMEExNDk7Pj4+JS5ESUM8SDc9Pjv/
2wBDAQoLCw4NDhwQEBw7KCIoOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7
Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozv/wAARCABeABADASIAAhEBAxEB/8QA
HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUF
BAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkK
FhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1
dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXG
x8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEB
AQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAEC
AxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRom
JygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU
1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD0vxDOltZQ
3UlsZ44plZ8E/IvduPSq+qeJ4IraOLSyLq8nAMMaDPB7n0qotr4pa3Mlxqdv
bKSQUkjU4GcDJxis9dH1bRDJLZ39n9om+YRqihn56DPb2FdcKcNE2nb7vyPI
q16t24xaTWu11+J0Hiq1ludOiMcBuEinR5YR1dR1Arm7vT7i7tLrUJtOuBcz
yLHZRhTmBV6E+grpPFN1Nb6dEIpjAJpkjkmHWNSeTWD9tax0DUI49RkeeK72
27s+5pMbePcHmnRbUVbuLF8jqNPt+Ni3d+L7S5tmSfR7qW3c7CSoKMc4wD61
k/aNO09hc2nh66juNwETXIYqGz79/Suq1rSpJtMiTTljSW2mWaNCMKxBzj9a
yb2XXtet/wCzX0tbVGI8yVnyFwc5FVTlC2isuupFeFW9pO7tpZLf1NTxVcyw
aZGkc5gWeZY5Jh/Ap6msTUtKstCs11HTtQlF0jAqrSbhLk8jA65rY8Qa3p1s
gsbkRTtI6rNC+RtQ9W6dutYU8nhfTIzeaX5d1eKR5UbszAHPUD2qaSkorR/o
y8VKLm3daLq9V6I3/Ey6fDbQ3N3ZtcETIFWJRuZuwOeo9qx7vxBDBCDbeHJo
Z2IWJ5rcKN2en1roNenubezia1tY7qUzIqrIpIUk8Hjpg9+1Ymqr4jv9PaC9
gsbS3JBabzPuYPXrSpWaXNt6/oXirxlLk3t2v+JZ1DxVKNSfS9MtVa4Q7Wed
wqA+3PNZUmmatrepXOnX+pfPFEsirH/q8k9CK66/0fT9TG27tUkI6NjDD8Rz
XK634cl0ayub2x1CURlNsiPyxXjgNTpTgrJaP0uRiqdVXnU1iuztp2P/2Q==

------_=_NextPart_001_01C70A62.1E1EC3CD
Content-Type: image/jpeg;
	name="image003.jpg"
Content-Transfer-Encoding: base64
Content-ID: <image003.jpg@01C70A37.CF788690>
Content-Description: image003.jpg
Content-Location: image003-1.jpg

/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAoHBwgHBgoICAgLCgoLDhgQDg0N
Dh0VFhEYIx8lJCIfIiEmKzcvJik0KSEiMEExNDk7Pj4+JS5ESUM8SDc9Pjv/
2wBDAQoLCw4NDhwQEBw7KCIoOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7
Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozv/wAARCABeABADASIAAhEBAxEB/8QA
HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUF
BAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkK
FhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1
dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXG
x8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEB
AQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAEC
AxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRom
JygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU
1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD0vxDOltZQ
3UlsZ44plZ8E/IvduPSq+qeJ4IraOLSyLq8nAMMaDPB7n0qotr4pa3Mlxqdv
bKSQUkjU4GcDJxis9dH1bRDJLZ39n9om+YRqihn56DPb2FdcKcNE2nb7vyPI
q16t24xaTWu11+J0Hiq1ludOiMcBuEinR5YR1dR1Arm7vT7i7tLrUJtOuBcz
yLHZRhTmBV6E+grpPFN1Nb6dEIpjAJpkjkmHWNSeTWD9tax0DUI49RkeeK72
27s+5pMbePcHmnRbUVbuLF8jqNPt+Ni3d+L7S5tmSfR7qW3c7CSoKMc4wD61
k/aNO09hc2nh66juNwETXIYqGz79/Suq1rSpJtMiTTljSW2mWaNCMKxBzj9a
yb2XXtet/wCzX0tbVGI8yVnyFwc5FVTlC2isuupFeFW9pO7tpZLf1NTxVcyw
aZGkc5gWeZY5Jh/Ap6msTUtKstCs11HTtQlF0jAqrSbhLk8jA65rY8Qa3p1s
gsbkRTtI6rNC+RtQ9W6dutYU8nhfTIzeaX5d1eKR5UbszAHPUD2qaSkorR/o
y8VKLm3daLq9V6I3/Ey6fDbQ3N3ZtcETIFWJRuZuwOeo9qx7vxBDBCDbeHJo
Z2IWJ5rcKN2en1roNenubezia1tY7qUzIqrIpIUk8Hjpg9+1Ymqr4jv9PaC9
gsbS3JBabzPuYPXrSpWaXNt6/oXirxlLk3t2v+JZ1DxVKNSfS9MtVa4Q7Wed
wqA+3PNZUmmatrepXOnX+pfPFEsirH/q8k9CK66/0fT9TG27tUkI6NjDD8Rz
XK634cl0ayub2x1CURlNsiPyxXjgNTpTgrJaP0uRiqdVXnU1iuztp2P/2Q==

------_=_NextPart_001_01C70A62.1E1EC3CD
Content-Type: image/png;
	name="image001.png"
Content-Transfer-Encoding: base64
Content-ID: <image001.png@01C70A37.CF788690>
Content-Description: image001.png
Content-Location: image001.png

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

------_=_NextPart_001_01C70A62.1E1EC3CD--
