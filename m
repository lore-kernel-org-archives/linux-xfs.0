Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2KFFHWp244040 for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 10:15:18 -0500
Received: from mailer.inet01.de (mailer.inet01.de [80.190.245.39]) by
	cuda.sgi.com with ESMTP id 713VMUBpmovR8oH6 for
	<xfs@oss.sgi.com>; Tue, 20 Mar 2012 08:15:14 -0700 (PDT)
Received: from mail.inetmx.net (c50 [192.168.77.50])
	by mailer.inet01.de (Postfix) with ESMTPS id C93FA6E529
	for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 16:15:13 +0100 (CET)
Received: from noname (77-20-124-124-dynip.superkabel.de [77.20.124.124])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested) (Authenticated sender: web17p1)
	by mail.inetmx.net (Postfix) with ESMTPSA id D14B586904
	for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 16:14:56 +0100 (CET)
From: "Martin" <martin@inetsolutions.de>
Subject: memory out with XFS quotacheck oom-killer
Date: Tue, 20 Mar 2012 16:15:12 +0100
Message-ID: <000501cd06ac$3fb68440$bf238cc0$@de>
MIME-Version: 1.0
Content-Language: de
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6248542112273898542=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============6248542112273898542==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0006_01CD06B4.A17AEC40"
Content-Language: de

This is a multi-part message in MIME format.

------=_NextPart_000_0006_01CD06B4.A17AEC40
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



Linux version 2.6.32-5-amd64 (Debian 2.6.32-31) on VM
=20
/etc/fstab
.
/dev/sdb1   /web   xfs   =
uquota,gquota,noatime,nodiratime,nobarrier,logbufs=3D8   0   2
..
=20
#df
=20
/dev/sdb1            419359452 227861008 191498444  55% /web


#cat /proc/meminfo
=20
MemTotal:        2059676 kB
MemFree:         1217536 kB
Buffers:            4424 kB
Cached:           665212 kB
SwapCached:            0 kB
Active:           123396 kB
Inactive:         558180 kB
Active(anon):      11952 kB
Inactive(anon):      104 kB
Active(file):     111444 kB
Inactive(file):   558076 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:        392184 kB
SwapFree:         392184 kB
Dirty:               448 kB
Writeback:             0 kB
AnonPages:         11940 kB
Mapped:             8472 kB
Shmem:               116 kB
Slab:             106380 kB
SReclaimable:      88992 kB
SUnreclaim:        17388 kB
KernelStack:        2008 kB
PageTables:         1588 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1422020 kB
Committed_AS:      54892 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      274196 kB
VmallocChunk:   34359444756 kB
HardwareCorrupted:     0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       10240 kB
DirectMap2M:     2086912 kB
=20
We add the quota's to fstab and restart.=20
=20
Now we get:
=20
Mar 20 14:40:56 nfs kernel: [7224126.442126] XFS mounting filesystem =
sdb1
Mar 20 14:41:10 nfs kernel: [7224139.613379] XFS mounting filesystem =
sdb1
Mar 20 14:41:10 nfs kernel: [7224139.772452] XFS quotacheck sdb1: Please =
wait.
Mar 20 14:43:02 nfs kernel: [7224251.264262] file invoked oom-killer: =
gfp_mask=3D0x201da, order=3D0, oom_adj=3D0
Mar 20 14:43:02 nfs kernel: [7224251.264268] file cpuset=3D/ =
mems_allowed=3D0
Mar 20 14:43:02 nfs kernel: [7224251.264270] Pid: 9585, comm: file Not =
tainted 2.6.32-5-amd64 #1
Mar 20 14:43:02 nfs kernel: [7224251.264272] Call Trace:
Mar 20 14:43:02 nfs kernel: [7224251.264282]  [<ffffffff810b60e8>] ? =
oom_kill_process+0x7f/0x23f
Mar 20 14:43:02 nfs kernel: [7224251.264285]  [<ffffffff810b660c>] ? =
__out_of_memory+0x12a/0x141
Mar 20 14:43:02 nfs kernel: [7224251.264287]  [<ffffffff810b6763>] ? =
out_of_memory+0x140/0x172
Mar 20 14:43:02 nfs kernel: [7224251.264290]  [<ffffffff810ba4c1>] ? =
__alloc_pages_nodemask+0x4e5/0x5f4
Mar 20 14:43:02 nfs kernel: [7224251.264293]  [<ffffffff810bba25>] ? =
__do_page_cache_readahead+0x9b/0x1b4
Mar 20 14:43:02 nfs kernel: [7224251.264295]  [<ffffffff810bbb5a>] ? =
ra_submit+0x1c/0x20
Mar 20 14:43:02 nfs kernel: [7224251.264298]  [<ffffffff810bbe49>] ? =
page_cache_async_readahead+0x75/0xad
Mar 20 14:43:02 nfs kernel: [7224251.264301]  [<ffffffff810b4767>] ? =
filemap_fault+0xae/0x2f6
Mar 20 14:43:02 nfs kernel: [7224251.264305]  [<ffffffff810ca796>] ? =
__do_fault+0x54/0x3c3
Mar 20 14:43:02 nfs kernel: [7224251.264309]  [<ffffffff81040432>] ? =
set_next_entity+0x34/0x56
Mar 20 14:43:02 nfs kernel: [7224251.264313]  [<ffffffff810ccabf>] ? =
handle_mm_fault+0x3b8/0x80f
Mar 20 14:43:02 nfs kernel: [7224251.264316]  [<ffffffff8103a990>] ? =
pick_next_task+0x21/0x3c
Mar 20 14:43:02 nfs kernel: [7224251.264320]  [<ffffffff8101654b>] ? =
sched_clock+0x5/0x8
Mar 20 14:43:02 nfs kernel: [7224251.264323]  [<ffffffff8101180e>] ? =
call_function_single_interrupt+0xe/0x20
Mar 20 14:43:02 nfs kernel: [7224251.264327]  [<ffffffff812fe6b6>] ? =
do_page_fault+0x2e0/0x2fc
Mar 20 14:43:02 nfs kernel: [7224251.264329]  [<ffffffff812fc555>] ? =
page_fault+0x25/0x30
Mar 20 14:43:02 nfs kernel: [7224251.264331] Mem-Info:
Mar 20 14:43:02 nfs kernel: [7224251.264332] Node 0 DMA per-cpu:
Mar 20 14:43:02 nfs kernel: [7224251.264334] CPU    0: hi:    0, btch:   =
1 usd:   0
Mar 20 14:43:02 nfs kernel: [7224251.264335] CPU    1: hi:    0, btch:   =
1 usd:   0
Mar 20 14:43:02 nfs kernel: [7224251.264337] CPU    2: hi:    0, btch:   =
1 usd:   0
Mar 20 14:43:02 nfs kernel: [7224251.264338] CPU    3: hi:    0, btch:   =
1 usd:   0
Mar 20 14:43:02 nfs kernel: [7224251.264339] Node 0 DMA32 per-cpu:
Mar 20 14:43:02 nfs kernel: [7224251.264341] CPU    0: hi:  186, btch:  =
31 usd:  67
Mar 20 14:43:02 nfs kernel: [7224251.264342] CPU    1: hi:  186, btch:  =
31 usd:  63
Mar 20 14:43:02 nfs kernel: [7224251.264344] CPU    2: hi:  186, btch:  =
31 usd:  57
Mar 20 14:43:02 nfs kernel: [7224251.264345] CPU    3: hi:  186, btch:  =
31 usd:  40
Mar 20 14:43:02 nfs kernel: [7224251.264349] active_anon:84 =
inactive_anon:343 isolated_anon:0
Mar 20 14:43:02 nfs kernel: [7224251.264350]  active_file:318 =
inactive_file:3150 isolated_file:0
Mar 20 14:43:02 nfs kernel: [7224251.264350]  unevictable:0 dirty:7 =
writeback:0 unstable:0
Mar 20 14:43:02 nfs kernel: [7224251.264351]  free:3434 =
slab_reclaimable:496871 slab_unreclaimable:5914
Mar 20 14:43:02 nfs kernel: [7224251.264352]  mapped:654 shmem:0 =
pagetables:510 bounce:0
Mar 20 14:43:02 nfs kernel: [7224251.264353] Node 0 DMA free:8040kB =
min:40kB low:48kB high:60kB active_anon:0kB inactive_anon:0kB active_f
Mar 20 14:43:02 nfs kernel: [7224251.264361] lowmem_reserve[]: 0 2004 =
2004 2004
Mar 20 14:43:02 nfs kernel: [7224251.264363] Node 0 DMA32 free:5696kB =
min:5704kB low:7128kB high:8556kB active_anon:336kB inactive_anon:13
Mar 20 14:43:02 nfs kernel: [7224251.264371] lowmem_reserve[]: 0 0 0 0
Mar 20 14:43:02 nfs kernel: [7224251.264373] Node 0 DMA: 4*4kB 7*8kB =
14*16kB 24*32kB 13*64kB 6*128kB 7*256kB 3*512kB 0*1024kB 1*2048kB 0*4
Mar 20 14:43:02 nfs kernel: [7224251.264379] Node 0 DMA32: 298*4kB =
497*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB
Mar 20 14:43:02 nfs kernel: [7224251.264384] 3830 total pagecache pages
Mar 20 14:43:02 nfs kernel: [7224251.264386] 334 pages in swap cache
Mar 20 14:43:02 nfs kernel: [7224251.264387] Swap cache stats: add =
12771, delete 12437, find 1426/2906
Mar 20 14:43:02 nfs kernel: [7224251.264388] Free swap  =3D 375488kB
Mar 20 14:43:02 nfs kernel: [7224251.264389] Total swap =3D 392184kB
Mar 20 14:43:02 nfs kernel: [7224251.268966] 524272 pages RAM
Mar 20 14:43:02 nfs kernel: [7224251.268968] 9417 pages reserved
Mar 20 14:43:02 nfs kernel: [7224251.268969] 1144 pages shared
=20
What can we do? The system is productive, we only want to add quota =
support for xfs.
=20
Thanks
Martin
------=_NextPart_000_0006_01CD06B4.A17AEC40
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta =
http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 12 =
(filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Verdana;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
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
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:36.0pt;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
span.E-MailFormatvorlage17
	{mso-style-type:personal-compose;
	font-family:"Verdana","sans-serif";
	color:black;
	font-weight:normal;
	font-style:normal;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:70.85pt 70.85pt 2.0cm 70.85pt;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:134181472;
	mso-list-type:hybrid;
	mso-list-template-ids:-1464025160 67567633 67567641 67567643 67567631 =
67567641 67567643 67567631 67567641 67567643;}
@list l0:level1
	{mso-level-text:"%1\)";
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
ol
	{margin-bottom:0cm;}
ul
	{margin-bottom:0cm;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DDE link=3Dblue =
vlink=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal><span =
lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black'=
>Linux version 2.6.32-5-amd64 (Debian 2.6.32-31) on =
VM<o:p></o:p></span></p><p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black'=
><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black'=
>/etc/fstab<o:p></o:p></span></p><p class=3DMsoNormal><i><span =
lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black'=
>&#8230;<o:p></o:p></span></i></p><p class=3DMsoNormal><i><span =
lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black'=
>/dev/sdb1&nbsp;&nbsp; /web&nbsp;&nbsp; xfs&nbsp;&nbsp; =
uquota,gquota,noatime,nodiratime,nobarrier,logbufs=3D8&nbsp;&nbsp; =
0&nbsp;&nbsp; 2<o:p></o:p></span></i></p><p class=3DMsoNormal><i><span =
lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Verdana","sans-serif";color:black'=
>&#8230;.<o:p></o:p></span></i></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>#df<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>/dev/sdb1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; 419359452 227861008 191498444&nbsp; 55% =
/web<br><br><o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>#cat /proc/meminfo<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span =
lang=3DEN-US>MemTotal:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2059676 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>MemFree:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
1217536 kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Buffers:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; 4424 kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Cached:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; 665212 kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>SwapCached:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; 0 kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Active:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; 123396 kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Inactive:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
558180 kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Active(anon):&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 11952 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Inactive(anon):&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 104 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Active(file):&nbsp;&nbsp;&nbsp;&nbsp; 111444 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Inactive(file):&nbsp;&nbsp; 558076 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Unevictable:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; 0 kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mlocked:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<o:p></o:p></span></p><p =
class=3DMsoNormal><span =
lang=3DEN-US>SwapTotal:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 392184 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>SwapFree:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
392184 kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Dirty:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 448 kB<o:p></o:p></span></p><p =
class=3DMsoNormal><span =
lang=3DEN-US>Writeback:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; 0 kB<o:p></o:p></span></p><p =
class=3DMsoNormal><span =
lang=3DEN-US>AnonPages:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
11940 kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mapped:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 8472 kB<o:p></o:p></span></p><p =
class=3DMsoNormal><span =
lang=3DEN-US>Shmem:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 116 kB<o:p></o:p></span></p><p =
class=3DMsoNormal><span =
lang=3DEN-US>Slab:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; 106380 kB<o:p></o:p></span></p><p =
class=3DMsoNormal><span =
lang=3DEN-US>SReclaimable:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 88992 =
kB<o:p></o:p></span></p><p =
class=3DMsoNormal>SUnreclaim:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
17388 kB<o:p></o:p></p><p =
class=3DMsoNormal>KernelStack:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
2008 kB<o:p></o:p></p><p =
class=3DMsoNormal>PageTables:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 1588 kB<o:p></o:p></p><p class=3DMsoNormal><span =
lang=3DEN-US>NFS_Unstable:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; 0 kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Bounce:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<o:p></o:p></span></p><p =
class=3DMsoNormal><span =
lang=3DEN-US>WritebackTmp:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; 0 kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>CommitLimit:&nbsp;&nbsp;&nbsp;&nbsp; 1422020 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Committed_AS:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 54892 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>VmallocTotal:&nbsp;&nbsp; 34359738367 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>VmallocUsed:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 274196 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>VmallocChunk:&nbsp;&nbsp; 34359444756 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>HardwareCorrupted:&nbsp;&nbsp;&nbsp;&nbsp; 0 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>HugePages_Total:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>HugePages_Free:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>HugePages_Rsvd:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>HugePages_Surp:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Hugepagesize:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2048 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>DirectMap4k:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10240 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>DirectMap2M:&nbsp;&nbsp;&nbsp;&nbsp; 2086912 =
kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>We add the quota&#8217;s to fstab and restart. =
<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Now we get:<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:40:56 nfs kernel: [7224126.442126] XFS mounting =
filesystem sdb1<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:41:10 nfs kernel: [7224139.613379] XFS mounting =
filesystem sdb1<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:41:10 nfs kernel: [7224139.772452] XFS quotacheck =
sdb1: Please wait.<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264262] file invoked =
oom-killer: gfp_mask=3D0x201da, order=3D0, =
oom_adj=3D0<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264268] file =
cpuset=3D/ mems_allowed=3D0<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264270] Pid: 9585, comm: file Not tainted 2.6.32-5-amd64 =
#1<o:p></o:p></span></p><p class=3DMsoNormal><span lang=3DEN-US>Mar 20 =
14:43:02 nfs kernel: [7224251.264272] Call =
Trace:<o:p></o:p></span></p><p class=3DMsoNormal><span lang=3DEN-US>Mar =
20 14:43:02 nfs kernel: [7224251.264282]&nbsp; =
[&lt;ffffffff810b60e8&gt;] ? =
oom_kill_process+0x7f/0x23f<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264285]&nbsp; [&lt;ffffffff810b660c&gt;] ? =
__out_of_memory+0x12a/0x141<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264287]&nbsp; [&lt;ffffffff810b6763&gt;] ? =
out_of_memory+0x140/0x172<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264290]&nbsp; [&lt;ffffffff810ba4c1&gt;] ? =
__alloc_pages_nodemask+0x4e5/0x5f4<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264293]&nbsp; [&lt;ffffffff810bba25&gt;] ? =
__do_page_cache_readahead+0x9b/0x1b4<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264295]&nbsp; [&lt;ffffffff810bbb5a&gt;] ? =
ra_submit+0x1c/0x20<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264298]&nbsp; =
[&lt;ffffffff810bbe49&gt;] ? =
page_cache_async_readahead+0x75/0xad<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264301]&nbsp; [&lt;ffffffff810b4767&gt;] ? =
filemap_fault+0xae/0x2f6<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264305]&nbsp; =
[&lt;ffffffff810ca796&gt;] ? =
__do_fault+0x54/0x3c3<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264309]&nbsp; =
[&lt;ffffffff81040432&gt;] ? =
set_next_entity+0x34/0x56<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264313]&nbsp; [&lt;ffffffff810ccabf&gt;] ? =
handle_mm_fault+0x3b8/0x80f<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264316]&nbsp; [&lt;ffffffff8103a990&gt;] ? =
pick_next_task+0x21/0x3c<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264320]&nbsp; =
[&lt;ffffffff8101654b&gt;] ? sched_clock+0x5/0x8<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264323]&nbsp; [&lt;ffffffff8101180e&gt;] ? =
call_function_single_interrupt+0xe/0x20<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264327]&nbsp; [&lt;ffffffff812fe6b6&gt;] ? =
do_page_fault+0x2e0/0x2fc<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264329]&nbsp; [&lt;ffffffff812fc555&gt;] ? =
page_fault+0x25/0x30<o:p></o:p></span></p><p class=3DMsoNormal>Mar 20 =
14:43:02 nfs kernel: [7224251.264331] Mem-Info:<o:p></o:p></p><p =
class=3DMsoNormal>Mar 20 14:43:02 nfs kernel: [7224251.264332] Node 0 =
DMA per-cpu:<o:p></o:p></p><p class=3DMsoNormal>Mar 20 14:43:02 nfs =
kernel: [7224251.264334] CPU&nbsp;&nbsp;&nbsp; 0: hi:&nbsp;&nbsp;&nbsp; =
0, btch:&nbsp;&nbsp; 1 usd:&nbsp;&nbsp; 0<o:p></o:p></p><p =
class=3DMsoNormal>Mar 20 14:43:02 nfs kernel: [7224251.264335] =
CPU&nbsp;&nbsp;&nbsp; 1: hi:&nbsp;&nbsp;&nbsp; 0, btch:&nbsp;&nbsp; 1 =
usd:&nbsp;&nbsp; 0<o:p></o:p></p><p class=3DMsoNormal>Mar 20 14:43:02 =
nfs kernel: [7224251.264337] CPU&nbsp;&nbsp;&nbsp; 2: =
hi:&nbsp;&nbsp;&nbsp; 0, btch:&nbsp;&nbsp; 1 usd:&nbsp;&nbsp; =
0<o:p></o:p></p><p class=3DMsoNormal>Mar 20 14:43:02 nfs kernel: =
[7224251.264338] CPU&nbsp;&nbsp;&nbsp; 3: hi:&nbsp;&nbsp;&nbsp; 0, =
btch:&nbsp;&nbsp; 1 usd:&nbsp;&nbsp; 0<o:p></o:p></p><p =
class=3DMsoNormal>Mar 20 14:43:02 nfs kernel: [7224251.264339] Node 0 =
DMA32 per-cpu:<o:p></o:p></p><p class=3DMsoNormal>Mar 20 14:43:02 nfs =
kernel: [7224251.264341] CPU&nbsp;&nbsp;&nbsp; 0: hi:&nbsp; 186, =
btch:&nbsp; 31 usd:&nbsp; 67<o:p></o:p></p><p class=3DMsoNormal>Mar 20 =
14:43:02 nfs kernel: [7224251.264342] CPU&nbsp;&nbsp;&nbsp; 1: hi:&nbsp; =
186, btch:&nbsp; 31 usd:&nbsp; 63<o:p></o:p></p><p class=3DMsoNormal>Mar =
20 14:43:02 nfs kernel: [7224251.264344] CPU&nbsp;&nbsp;&nbsp; 2: =
hi:&nbsp; 186, btch:&nbsp; 31 usd:&nbsp; 57<o:p></o:p></p><p =
class=3DMsoNormal>Mar 20 14:43:02 nfs kernel: [7224251.264345] =
CPU&nbsp;&nbsp;&nbsp; 3: hi:&nbsp; 186, btch:&nbsp; 31 usd:&nbsp; =
40<o:p></o:p></p><p class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 =
nfs kernel: [7224251.264349] active_anon:84 inactive_anon:343 =
isolated_anon:0<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264350]&nbsp; =
active_file:318 inactive_file:3150 =
isolated_file:0<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264350] =
&nbsp;unevictable:0 dirty:7 writeback:0 =
unstable:0<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264351]&nbsp; =
free:3434 slab_reclaimable:496871 =
slab_unreclaimable:5914<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264352]&nbsp; =
mapped:654 shmem:0 pagetables:510 bounce:0<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264353] Node 0 DMA free:8040kB min:40kB low:48kB high:60kB =
active_anon:0kB inactive_anon:0kB active_f<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264361] lowmem_reserve[]: 0 2004 2004 =
2004<o:p></o:p></span></p><p class=3DMsoNormal><span lang=3DEN-US>Mar 20 =
14:43:02 nfs kernel: [7224251.264363] Node 0 DMA32 free:5696kB =
min:5704kB low:7128kB high:8556kB active_anon:336kB =
inactive_anon:13<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264371] =
lowmem_reserve[]: 0 0 0 0<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264373] Node 0 DMA: 4*4kB 7*8kB 14*16kB 24*32kB 13*64kB 6*128kB =
7*256kB 3*512kB 0*1024kB 1*2048kB 0*4<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264379] Node 0 DMA32: 298*4kB 497*8kB 1*16kB 0*32kB 0*64kB =
0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264384] 3830 total pagecache pages<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264386] 334 pages in swap cache<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Mar 20 14:43:02 nfs kernel: =
[7224251.264387] Swap cache stats: add 12771, delete 12437, find =
1426/2906<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264388] Free =
swap&nbsp; =3D 375488kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.264389] Total swap =3D =
392184kB<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.268966] 524272 pages =
RAM<o:p></o:p></span></p><p class=3DMsoNormal><span lang=3DEN-US>Mar 20 =
14:43:02 nfs kernel: [7224251.268968] 9417 pages =
reserved<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Mar 20 14:43:02 nfs kernel: [7224251.268969] 1144 pages =
shared<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>What can we do? The system is productive, we only want to =
add quota support for xfs.<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Thanks<o:p></o:p></span></p><p =
class=3DMsoNormal><span =
lang=3DEN-US>Martin<o:p></o:p></span></p></div></body></html>
------=_NextPart_000_0006_01CD06B4.A17AEC40--


--===============6248542112273898542==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6248542112273898542==--
