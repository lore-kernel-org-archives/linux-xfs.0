Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9EA267FBE
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 08:06:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F1698F8049
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 06:06:31 -0700 (PDT)
Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	by cuda.sgi.com with ESMTP id qb0TuQ4LXRHfllDV (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 06:06:29 -0700 (PDT)
Received: from xhc-rcd-x12.cisco.com (xhc-rcd-x12.cisco.com [173.37.183.86])
	by rcdn-core2-6.cisco.com (8.14.5/8.14.5) with ESMTP id r7ED6AGi026931
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 13:06:10 GMT
From: "Semion Zak (sezak)" <sezak@cisco.com>
Subject: xfs_repair deletes files after power cut
Date: Wed, 14 Aug 2013 13:06:08 +0000
Message-ID: <345BE8CDF5F1514CB9B5CB3FFFA9B65920197D@xmb-aln-x14.cisco.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_005_345BE8CDF5F1514CB9B5CB3FFFA9B65920197Dxmbalnx14ciscocom_"
MIME-Version: 1.0
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: "xtv-fs-group-nds-dg(mailer list)" <xtv-fs-group-nds-dg@cisco.com>

--_005_345BE8CDF5F1514CB9B5CB3FFFA9B65920197Dxmbalnx14ciscocom_
Content-Type: multipart/alternative;
	boundary="_000_345BE8CDF5F1514CB9B5CB3FFFA9B65920197Dxmbalnx14ciscocom_"

--_000_345BE8CDF5F1514CB9B5CB3FFFA9B65920197Dxmbalnx14ciscocom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,



There is a problem in XFS: xfs_repair deletes files after power cut because=
 of "data fork in rt inode x claims used rt block y"



Scenario:

Empty XFS partition and real-time partition with extent size 3008 sectors.

1. In a loop simultaneously:

a. 2 threads simultaneously write 1 stream file in real time partition

b. 1 thread writes 3 files into data partition.

c. 1 thread makes holes in the stream files

d. In the middle of the loop switch off the disk power.

2. Drop caches ("echo 3>/proc/sys/vm/drop_caches")

3. Unmount XFS

4. Switch the disk power on

5. Mount XFS (to replay log)

6. Unmount XFS

7. Repair XFS

8. Mount XFS



After the first mount (step 5) stream file exist in real time partition.

After the second mount (step 8) stream file is absent because is deleted by=
 repair (see attached repair_log):



data fork in rt inode 197 claims used rt block 202731

bad data fork in inode 197

cleared inode 197

...

entry "0.STR" in shortform directory 195 references free inode 197

junking entry "0.STR" in directory inode 195



Seems to be the xfs_repair bug because the streams files bitmap after the f=
irst mount seems to be OK (see attached bitmap1), without overlapped extent=
s.



The only file in RT partition 0.STR:

/rt/000000R0.DIR/0.STR:

               0: [0..144383]: hole

               1: [144384..147391]: 607625024..607628031

               2: [147392..291775]: hole

               3: [291776..294783]: 607772416..607775423

               4: [294784..436159]: hole

               5: [436160..439167]: 607916800..607919807

               6: [439168..583551]: hole

               7: [583552..586559]: 608064192..608067199

               8: [586560..727935]: hole

               9: [727936..730943]: 608208576..608211583

               10: [730944..875327]: hole

               11: [875328..878335]: 608355968..608358975

               12: [878336..1019711]: hole

               13: [1019712..1022719]: 608500352..608503359

               14: [1022720..1167103]: hole

               15: [1167104..1170111]: 608647744..608650751

               16: [1170112..1311487]: hole

               17: [1311488..1314495]: 608792128..608795135

               18: [1314496..1458879]: hole

               19: [1458880..1461887]: 608939520..608942527

               20: [1461888..1603263]: hole

               21: [1603264..1606271]: 609083904..609086911

               22: [1606272..1750655]: hole

               23: [1750656..1753663]: 609231296..609234303

               24: [1753664..1895039]: hole

               25: [1895040..1898047]: 609375680..609378687

               26: [1898048..2042431]: hole

               27: [2042432..2045439]: 609523072..609526079

               28: [2045440..2186815]: hole

               29: [2186816..2189823]: 609667456..609670463

               30: [2189824..2334207]: hole

               31: [2334208..2334719]: 609814848..609815359

               32: [2334720..3853247]: 609815360..611333887

The only strange thing is that 2 the last extents are contiguous and could =
be united into 1 extent.

It is strange but is not a good reason to erase the file:

data fork in rt inode 197 claims used rt block 202731

bad data fork in inode 197

cleared inode 197

...

entry "0.STR" in shortform directory 195 references free inode 197

junking entry "0.STR" in directory inode 195



Block 202731corresponds to sector 202731* 3008 =3D 609814848, beginning of =
31th extent.

This block is not used in other extents, so it is not an error.



* kernel version (uname -a):

Linux SZUbuntu 3.10.4-031004-generic #201307282043 SMP Mon Jul 29 00:52:09 =
UTC 2013 i686 i686 i686 GNU/Linux

* xfsprogs version (xfs_repair -V)

xfs_repair version 3.1.9

* number of CPUs: 1 Core 2 Duo

* contents of /proc/meminfo

MemTotal:        1989360 kB

MemFree:          134036 kB

Buffers:           36512 kB

Cached:          1208408 kB

SwapCached:            0 kB

Active:           790032 kB

Inactive:         990384 kB

Active(anon):     621884 kB

Inactive(anon):   582020 kB

Active(file):     168148 kB

Inactive(file):   408364 kB

Unevictable:          32 kB

Mlocked:              32 kB

HighTotal:       1174216 kB

HighFree:          55364 kB

LowTotal:         815144 kB

LowFree:           78672 kB

SwapTotal:             0 kB

SwapFree:              0 kB

Dirty:                12 kB

Writeback:             0 kB

AnonPages:        535536 kB

Mapped:           171040 kB

Shmem:            668400 kB

Slab:              42020 kB

SReclaimable:      23712 kB

SUnreclaim:        18308 kB

KernelStack:        4000 kB

PageTables:        11120 kB

NFS_Unstable:          0 kB

Bounce:                0 kB

WritebackTmp:          0 kB

CommitLimit:      994680 kB

Committed_AS:    4103576 kB

VmallocTotal:     122880 kB

VmallocUsed:       20204 kB

VmallocChunk:      61320 kB

HardwareCorrupted:     0 kB

AnonHugePages:         0 kB

HugePages_Total:       0

HugePages_Free:        0

HugePages_Rsvd:        0

HugePages_Surp:        0

Hugepagesize:       2048 kB

DirectMap4k:       14328 kB

DirectMap2M:      899072 kB

* contents of /proc/mounts

rootfs / rootfs rw 0 0

sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0

proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0

udev /dev devtmpfs rw,relatime,size=3D986132k,nr_inodes=3D199513,mode=3D755=
 0 0

devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmod=
e=3D000 0 0

tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=3D198936k,mode=3D755 0 0

/dev/disk/by-uuid/2bd39f09-5ca0-41a5-a4af-1f5985fb1f69 / ext4 rw,relatime,e=
rrors=3Dremount-ro,data=3Dordered 0 0

none /sys/fs/cgroup tmpfs rw,relatime,size=3D4k,mode=3D755 0 0

none /sys/fs/fuse/connections fusectl rw,relatime 0 0

none /sys/kernel/debug debugfs rw,relatime 0 0

none /sys/kernel/security securityfs rw,relatime 0 0

none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=3D5120k 0 0

none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0

none /run/user tmpfs rw,nosuid,nodev,noexec,relatime,size=3D102400k,mode=3D=
755 0 0

binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw,nosuid,nodev,noexec,rel=
atime 0 0

rpc_pipefs /run/rpc_pipefs rpc_pipefs rw,relatime 0 0

gvfsd-fuse /run/user/szak/gvfs fuse.gvfsd-fuse rw,nosuid,nodev,relatime,use=
r_id=3D1000,group_id=3D1000 0 0

10.63.7.58:/ms/stb_storage/7401_fs/build/szak /mnt/nfs nfs rw,relatime,vers=
=3D3,rsize=3D131072,wsize=3D131072,namle55,hard,nolock,proto=3Dtcp,timeo=3D=
600,retrans=3D2,sec=3Dsys,mountaddr=3D10.63.7.58,mountvers=3D3,mountport=3D=
1234,mountproudp,local_lock=3Dall,addr=3D10.63.7.58 0 0

/dev/sdc2 /rt xfs rw,relatime,attr2,inode64,rtdev=3D/dev/sdc3,noquota 0 0

* contents of /proc/partitions

major minor  #blocks  name



   8        0  976762584 sda

   8        1  477894656 sda1

   8        2  488381144 sda2

   8        3   10485760 sda3

  11        0    1048575 sr0

   8       16   78156288 sdb

   8       17     248832 sdb1

   8       18          1 sdb2

   8       21   77904896 sdb5

252        0   75812864 dm-0

252        1    2088960 dm-1

   8       32 2930266584 sdc

   8       33  976561152 sdc1

   8       34    9765888 sdc2

   8       35 1943938503 sdc3

* RAID layout (hardware and/or software):

No raid, /dev/sdc:

Number  Start (sector)    End (sector)  Size       Code  Name

   1            2048      1953124351   931.3 GiB   8300  Linux filesystem

   2      1953124352      1972656127   9.3 GiB     8300  Linux filesystem

   3      1972656128      5860533134   1.8 TiB     8300  Linux filesystem

* LVM configuration: no LVM

* type of disks you are using: WD30EURS

* write cache status of drives: write-caching =3D  1 (on)

* size of BBWC and mode it is running in: No

* xfs_info output on the filesystem in question:

meta-data=3D/dev/sdc2              isize=3D256    agcount=3D16, agsize=3D15=
2592 blks

         =3D                       sectsz=3D4096  attr=3D2

data     =3D                       bsize=3D4096   blocks=3D2441472, imaxpct=
=3D25

         =3D                       sunit=3D0      swidth=3D0 blks

naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0

log      =3Dinternal               bsize=3D4096   blocks=3D2560, version=3D=
2

         =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-coun=
t=3D1

realtime =3Dexternal               extsz=3D1540096 blocks=3D485984625, rtex=
tents=3D1292512

* dmesg output showing all error messages and stack traces:

[166770.764560] XFS (sdc2): Mounting Filesystem

[166770.865189] XFS (sdc2): Starting recovery (logdev: internal)

[166771.042071] XFS (sdc2): Ending recovery (logdev: internal)

[166918.066626] XFS (sdc2): Mounting Filesystem

[166918.159045] XFS (sdc2): Ending clean mount



Thank you.



Semion



--_000_345BE8CDF5F1514CB9B5CB3FFFA9B65920197Dxmbalnx14ciscocom_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
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
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
	{mso-style-priority:99;
	mso-style-link:"Plain Text Char";
	margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:36.0pt;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
span.EmailStyle18
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.PlainTextChar
	{mso-style-name:"Plain Text Char";
	mso-style-priority:99;
	mso-style-link:"Plain Text";
	font-family:"Calibri","sans-serif";}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:416096463;
	mso-list-template-ids:-1234519774;}
@list l0:level1
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:36.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level2
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:72.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:108.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:144.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level5
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:180.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:216.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:252.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level8
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:288.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l0:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:324.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l1
	{mso-list-id:542207068;
	mso-list-type:hybrid;
	mso-list-template-ids:368882416 67698703 67698713 67698715 67698703 676987=
13 67698715 67698703 67698713 67698715;}
@list l1:level1
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l1:level2
	{mso-level-number-format:alpha-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l1:level3
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	text-indent:-9.0pt;}
@list l1:level4
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l1:level5
	{mso-level-number-format:alpha-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l1:level6
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	text-indent:-9.0pt;}
@list l1:level7
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l1:level8
	{mso-level-number-format:alpha-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l1:level9
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	text-indent:-9.0pt;}
ol
	{margin-bottom:0cm;}
ul
	{margin-bottom:0cm;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoPlainText">Hello,<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">There is a problem in XFS: xfs_repair deletes fil=
es after power cut because of &#8220;data fork in rt inode x claims used rt=
 block y&#8221;<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Scenario:<o:p></o:p></p>
<p class=3D"MsoPlainText">Empty XFS partition and real-time partition with =
extent size 3008 sectors.<o:p></o:p></p>
<p class=3D"MsoPlainText">1. In a loop simultaneously: <o:p></o:p></p>
<p class=3D"MsoPlainText" style=3D"margin-left:36.0pt">a. 2 threads simulta=
neously write 1 stream file in real time partition
<o:p></o:p></p>
<p class=3D"MsoPlainText" style=3D"margin-left:36.0pt">b. 1 thread writes 3=
 files into data partition.<o:p></o:p></p>
<p class=3D"MsoPlainText" style=3D"margin-left:36.0pt">c. 1 thread makes ho=
les in the stream files
<o:p></o:p></p>
<p class=3D"MsoPlainText" style=3D"margin-left:36.0pt">d. In the middle of =
the loop switch off the disk power.<o:p></o:p></p>
<p class=3D"MsoPlainText">2. Drop caches (&quot;echo 3&gt;/proc/sys/vm/drop=
_caches&quot;)<o:p></o:p></p>
<p class=3D"MsoPlainText">3. Unmount XFS<o:p></o:p></p>
<p class=3D"MsoPlainText">4. Switch the disk power on<o:p></o:p></p>
<p class=3D"MsoPlainText">5. Mount XFS (to replay log)<o:p></o:p></p>
<p class=3D"MsoPlainText">6. Unmount XFS<o:p></o:p></p>
<p class=3D"MsoPlainText">7. Repair XFS<o:p></o:p></p>
<p class=3D"MsoPlainText">8. Mount XFS<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">After the first mount (step 5) stream file exist =
in real time partition.<o:p></o:p></p>
<p class=3D"MsoPlainText">After the second mount (step 8) stream file is ab=
sent because is deleted by repair (see attached repair_log):<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">data fork in rt inode 1=
97 claims used rt block 202731<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">bad data fork in inode =
197<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">cleared inode 197<o:p><=
/o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&#8230;<o:p></o:p></spa=
n></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">entry &quot;0.STR&quot;=
 in shortform directory 195 references free inode 197<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">junking entry &quot;0.S=
TR&quot; in directory inode 195<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Seems to be the xfs_repair bug because the stream=
s files bitmap after the first mount seems to be OK (see attached bitmap1),=
 without overlapped extents.<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">The only file in RT partition 0.STR:<o:p></o:p></=
p>
<p class=3D"MsoPlainText"><span style=3D"color:red">/rt/000000R0.DIR/0.STR:=
<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0: [0..144383=
]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1: [144384..1=
47391]: 607625024..607628031<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2: [147392..2=
91775]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3: [291776..2=
94783]: 607772416..607775423<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4: [294784..4=
36159]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5: [436160..4=
39167]: 607916800..607919807<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6: [439168..5=
83551]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7: [583552..5=
86559]: 608064192..608067199<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8: [586560..7=
27935]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9: [727936..7=
30943]: 608208576..608211583<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10: [730944..=
875327]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 11: [875328..=
878335]: 608355968..608358975<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 12: [878336..=
1019711]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 13: [1019712.=
.1022719]: 608500352..608503359<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14: [1022720.=
.1167103]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15: [1167104.=
.1170111]: 608647744..608650751<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 16: [1170112.=
.1311487]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17: [1311488.=
.1314495]: 608792128..608795135<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18: [1314496.=
.1458879]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 19: [1458880.=
.1461887]: 608939520..608942527<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20: [1461888.=
.1603263]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 21: [1603264.=
.1606271]: 609083904..609086911<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 22: [1606272.=
.1750655]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 23: [1750656.=
.1753663]: 609231296..609234303<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 24: [1753664.=
.1895039]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 25: [1895040.=
.1898047]: 609375680..609378687<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 26: [1898048.=
.2042431]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 27: [2042432.=
.2045439]: 609523072..609526079<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 28: [2045440.=
.2186815]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 29: [2186816.=
.2189823]: 609667456..609670463<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 30: [2189824.=
.2334207]: hole<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31: [2334208.=
.2334719]: 609814848..609815359<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32: [2334720.=
.3853247]: 609815360..611333887<o:p></o:p></span></p>
<p class=3D"MsoPlainText">The only strange thing is that 2 the last extents=
 are contiguous and could be united into 1 extent.<o:p></o:p></p>
<p class=3D"MsoPlainText">It is strange but is not a good reason to erase t=
he file:<o:p></o:p></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">data fork in rt inode 1=
97 claims used rt block 202731<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">bad data fork in inode =
197<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">cleared inode 197<o:p><=
/o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&#8230;<o:p></o:p></spa=
n></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">entry &quot;0.STR&quot;=
 in shortform directory 195 references free inode 197<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">junking entry &quot;0.S=
TR&quot; in directory inode 195<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red"><o:p>&nbsp;</o:p></span=
></p>
<p class=3D"MsoPlainText">Block 202731corresponds to sector 202731* 3008 =
=3D 609814848, beginning of 31th extent.<o:p></o:p></p>
<p class=3D"MsoPlainText">This block is not used in other extents, so it is=
 not an error.<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">&#8226; kernel version (uname -a):<o:p></o:p></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Linux SZUbuntu 3.10.4-0=
31004-generic #201307282043 SMP Mon Jul 29 00:52:09 UTC 2013 i686 i686 i686=
 GNU/Linux<o:p></o:p></span></p>
<p class=3D"MsoPlainText">&#8226; xfsprogs version (xfs_repair -V)<o:p></o:=
p></p>
<p class=3D"MsoPlainText" style=3D"text-indent:36.0pt"><span style=3D"color=
:red">xfs_repair version 3.1.9<o:p></o:p></span></p>
<p class=3D"MsoPlainText">&#8226; number of CPUs<span style=3D"color:red">:=
 1 Core 2 Duo<o:p></o:p></span></p>
<p class=3D"MsoPlainText">&#8226; contents of /proc/meminfo<o:p></o:p></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">MemTotal:&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; 1989360 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">MemFree:&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 134036 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Buffers:&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 36512 kB<o:p></o:p></span></p=
>
<p class=3D"MsoPlainText"><span style=3D"color:red">Cached:&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1208408 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">SwapCached:&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<o:p></o:p></spa=
n></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Active:&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 790032 kB<o:p></o:p></span></p=
>
<p class=3D"MsoPlainText"><span style=3D"color:red">Inactive:&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 990384 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Active(anon):&nbsp;&nbs=
p;&nbsp;&nbsp; 621884 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Inactive(anon):&nbsp;&n=
bsp; 582020 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Active(file):&nbsp;&nbs=
p;&nbsp;&nbsp; 168148 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Inactive(file):&nbsp;&n=
bsp; 408364 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Unevictable:&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Mlocked:&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32 kB<o:p><=
/o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">HighTotal:&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; 1174216 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">HighFree:&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 55364 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">LowTotal:&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 815144 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">LowFree:&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 78672 kB<o:p></o:p></span></p=
>
<p class=3D"MsoPlainText"><span style=3D"color:red">SwapTotal:&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<o:p></o:p>=
</span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">SwapFree:&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<o:p><=
/o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Dirty:&nbsp; &nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1=
2 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Writeback:&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<o:p></o:p>=
</span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">AnonPages:&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 535536 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Mapped:&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 171040 kB<o:p></o:p></span></p=
>
<p class=3D"MsoPlainText"><span style=3D"color:red">Shmem:&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 668400 kB<o:p></o:p></spa=
n></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Slab:&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 42020 kB<o:p><=
/o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">SReclaimable:&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; 23712 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">SUnreclaim:&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18308 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">KernelStack:&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4000 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">PageTables:&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 11120 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">NFS_Unstable:&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Bounce:&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">WritebackTmp:&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">CommitLimit:&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 994680 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Committed_AS:&nbsp;&nbs=
p;&nbsp; 4103576 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">VmallocTotal:&nbsp;&nbs=
p;&nbsp;&nbsp; 122880 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">VmallocUsed:&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; 20204 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">VmallocChunk:&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; 61320 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">HardwareCorrupted:&nbsp=
;&nbsp;&nbsp;&nbsp; 0 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">AnonHugePages:&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">HugePages_Total:&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">HugePages_Free:&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">HugePages_Rsvd:&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">HugePages_Surp:&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Hugepagesize:&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; 2048 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">DirectMap4k:&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; 14328 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">DirectMap2M:&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 899072 kB<o:p></o:p></span></p>
<p class=3D"MsoPlainText">&#8226; contents of /proc/mounts<o:p></o:p></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">rootfs / rootfs rw 0 0<=
o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">sysfs /sys sysfs rw,nos=
uid,nodev,noexec,relatime 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">proc /proc proc rw,nosu=
id,nodev,noexec,relatime 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">udev /dev devtmpfs rw,r=
elatime,size=3D986132k,nr_inodes=3D199513,mode=3D755 0 0<o:p></o:p></span><=
/p>
<p class=3D"MsoPlainText"><span style=3D"color:red">devpts /dev/pts devpts =
rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmode=3D000 0 0<o:p></o:p><=
/span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">tmpfs /run tmpfs rw,nos=
uid,noexec,relatime,size=3D198936k,mode=3D755 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">/dev/disk/by-uuid/2bd39=
f09-5ca0-41a5-a4af-1f5985fb1f69 / ext4 rw,relatime,errors=3Dremount-ro,data=
=3Dordered 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">none /sys/fs/cgroup tmp=
fs rw,relatime,size=3D4k,mode=3D755 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">none /sys/fs/fuse/conne=
ctions fusectl rw,relatime 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">none /sys/kernel/debug =
debugfs rw,relatime 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">none /sys/kernel/securi=
ty securityfs rw,relatime 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">none /run/lock tmpfs rw=
,nosuid,nodev,noexec,relatime,size=3D5120k 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">none /run/shm tmpfs rw,=
nosuid,nodev,relatime 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">none /run/user tmpfs rw=
,nosuid,nodev,noexec,relatime,size=3D102400k,mode=3D755 0 0<o:p></o:p></spa=
n></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">binfmt_misc /proc/sys/f=
s/binfmt_misc binfmt_misc rw,nosuid,nodev,noexec,relatime 0 0<o:p></o:p></s=
pan></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">rpc_pipefs /run/rpc_pip=
efs rpc_pipefs rw,relatime 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">gvfsd-fuse /run/user/sz=
ak/gvfs fuse.gvfsd-fuse rw,nosuid,nodev,relatime,user_id=3D1000,group_id=3D=
1000 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">10.63.7.58:/ms/stb_stor=
age/7401_fs/build/szak /mnt/nfs nfs rw,relatime,vers=3D3,rsize=3D131072,wsi=
ze=3D131072,namle55,hard,nolock,proto=3Dtcp,timeo=3D600,retrans=3D2,sec=3Ds=
ys,mountaddr=3D10.63.7.58,mountvers=3D3,mountport=3D1234,mountproudp,local_=
lock=3Dall,addr=3D10.63.7.58
 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">/dev/sdc2 /rt xfs rw,re=
latime,attr2,inode64,rtdev=3D/dev/sdc3,noquota 0 0<o:p></o:p></span></p>
<p class=3D"MsoPlainText">&#8226; contents of /proc/partitions<o:p></o:p></=
p>
<p class=3D"MsoPlainText"><span style=3D"color:red">major minor&nbsp; #bloc=
ks&nbsp; name<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red"><o:p>&nbsp;</o:p></span=
></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 8&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;0&nbsp; 976762584 sda<o:p></o:p></span></=
p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 8&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 477894656 sda1<o:p></o:p></span><=
/p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 8&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 488381144 sda2<o:p></o:p></span><=
/p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 8&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 10485760 sda3<o:p></o:p></s=
pan></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp; 11&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 1048575 sr0<o:p></o:p></sp=
an></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 8&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp; 78156288 sdb<o:p></o:p></span></=
p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 8&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 17&nbsp;&nbsp;&nbsp;&nbsp; 248832 sdb1<o:p></o:=
p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 8&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 18&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; 1 sdb2<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 8&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 21&nbsp;&nbsp; 77904896 sdb5<o:p></o:p></span><=
/p>
<p class=3D"MsoPlainText"><span style=3D"color:red">252&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; 75812864 dm-0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">252&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 2088960 dm-1<o:p></o:p></span></=
p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 8&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 32 2930266584 sdc<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 8&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 33&nbsp; 976561152 sdc1<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 8&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 34&nbsp;&nbsp;&nbsp; 9765888 sdc2<o:p></o:p></s=
pan></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 8&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 35 1943938503 sdc3<o:p></o:p></span></p>
<p class=3D"MsoPlainText">&#8226; RAID layout (hardware and/or software):<o=
:p></o:p></p>
<p class=3D"MsoPlainText">No raid, /dev/sdc:<o:p></o:p></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">Number&nbsp; Start (sec=
tor)&nbsp;&nbsp;&nbsp; End (sector)&nbsp; Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; Code&nbsp; Name<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 1&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2048&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; 1953124351&nbsp;&nbsp; 931.3 GiB&nbsp;&nbsp; 8300&nbsp; L=
inux filesystem<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 2&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; 1953124352&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1972656127&n=
bsp;&nbsp; 9.3 GiB&nbsp;&nbsp;&nbsp;&nbsp; 8300&nbsp; Linux filesystem<o:p>=
</o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp; 3&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; 1972656128&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5860533134&n=
bsp;&nbsp; 1.8 TiB&nbsp;&nbsp;&nbsp;&nbsp; 8300&nbsp; Linux filesystem<o:p>=
</o:p></span></p>
<p class=3D"MsoPlainText">&#8226; LVM configuration: no LVM<o:p></o:p></p>
<p class=3D"MsoPlainText">&#8226; type of disks you are using: WD30EURS<o:p=
></o:p></p>
<p class=3D"MsoPlainText">&#8226; write cache status of drives: <span style=
=3D"color:red">write-caching =3D&nbsp; 1 (on)</span><o:p></o:p></p>
<p class=3D"MsoPlainText">&#8226; size of BBWC and mode it is running in: N=
o<o:p></o:p></p>
<p class=3D"MsoPlainText">&#8226; xfs_info output on the filesystem in ques=
tion:<o:p></o:p></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">meta-data=3D/dev/sdc2&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; isize=3D256&nbsp;&nbsp;&nbsp; agcount=3D16, agsize=3D152592 blks<o:p></o:=
p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; sectsz=3D4096&nbsp; attr=3D2<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">data&nbsp;&nbsp;&nbsp;&=
nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=3D=
4096&nbsp;&nbsp; blocks=3D2441472, imaxpct=3D25<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; sunit=3D0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; swidth=3D0 blks<o:p></o=
:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">naming&nbsp;&nbsp; =3Dv=
ersion 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; bsize=3D4096&nbsp;&nbsp; ascii-ci=3D0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">log&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; =3Dinternal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=3D4096&nbsp;&nbsp; blocks=3D2560, ver=
sion=3D2<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; sectsz=3D4096&nbsp; sunit=3D1 blks, lazy-count=3D1<o:p></o:p></=
span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">realtime =3Dexternal&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; extsz=3D1540096 blocks=3D485984625, rtextents=3D1292512<o:p></o:p></=
span></p>
<p class=3D"MsoPlainText">&#8226; dmesg output showing all error messages a=
nd stack traces:<o:p></o:p></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">[166770.764560] XFS (sd=
c2): Mounting Filesystem<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">[166770.865189] XFS (sd=
c2): Starting recovery (logdev: internal)<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">[166771.042071] XFS (sd=
c2): Ending recovery (logdev: internal)<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">[166918.066626] XFS (sd=
c2): Mounting Filesystem<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"color:red">[166918.159045] XFS (sd=
c2): Ending clean mount<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Thank you.<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Semion<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_345BE8CDF5F1514CB9B5CB3FFFA9B65920197Dxmbalnx14ciscocom_--

--_005_345BE8CDF5F1514CB9B5CB3FFFA9B65920197Dxmbalnx14ciscocom_
Content-Type: application/octet-stream; name="bitmap1"
Content-Description: bitmap1
Content-Disposition: attachment; filename="bitmap1"; size=1246;
	creation-date="Wed, 14 Aug 2013 12:27:04 GMT";
	modification-date="Wed, 14 Aug 2013 12:20:39 GMT"
Content-Transfer-Encoding: base64

L3J0LzAwMDAwMFIwLkRJUi8wLlNUUjoKCTA6IFswLi4xNDQzODNdOiBob2xlCgkxOiBbMTQ0Mzg0
Li4xNDczOTFdOiA2MDc2MjUwMjQuLjYwNzYyODAzMQoJMjogWzE0NzM5Mi4uMjkxNzc1XTogaG9s
ZQoJMzogWzI5MTc3Ni4uMjk0NzgzXTogNjA3NzcyNDE2Li42MDc3NzU0MjMKCTQ6IFsyOTQ3ODQu
LjQzNjE1OV06IGhvbGUKCTU6IFs0MzYxNjAuLjQzOTE2N106IDYwNzkxNjgwMC4uNjA3OTE5ODA3
Cgk2OiBbNDM5MTY4Li41ODM1NTFdOiBob2xlCgk3OiBbNTgzNTUyLi41ODY1NTldOiA2MDgwNjQx
OTIuLjYwODA2NzE5OQoJODogWzU4NjU2MC4uNzI3OTM1XTogaG9sZQoJOTogWzcyNzkzNi4uNzMw
OTQzXTogNjA4MjA4NTc2Li42MDgyMTE1ODMKCTEwOiBbNzMwOTQ0Li44NzUzMjddOiBob2xlCgkx
MTogWzg3NTMyOC4uODc4MzM1XTogNjA4MzU1OTY4Li42MDgzNTg5NzUKCTEyOiBbODc4MzM2Li4x
MDE5NzExXTogaG9sZQoJMTM6IFsxMDE5NzEyLi4xMDIyNzE5XTogNjA4NTAwMzUyLi42MDg1MDMz
NTkKCTE0OiBbMTAyMjcyMC4uMTE2NzEwM106IGhvbGUKCTE1OiBbMTE2NzEwNC4uMTE3MDExMV06
IDYwODY0Nzc0NC4uNjA4NjUwNzUxCgkxNjogWzExNzAxMTIuLjEzMTE0ODddOiBob2xlCgkxNzog
WzEzMTE0ODguLjEzMTQ0OTVdOiA2MDg3OTIxMjguLjYwODc5NTEzNQoJMTg6IFsxMzE0NDk2Li4x
NDU4ODc5XTogaG9sZQoJMTk6IFsxNDU4ODgwLi4xNDYxODg3XTogNjA4OTM5NTIwLi42MDg5NDI1
MjcKCTIwOiBbMTQ2MTg4OC4uMTYwMzI2M106IGhvbGUKCTIxOiBbMTYwMzI2NC4uMTYwNjI3MV06
IDYwOTA4MzkwNC4uNjA5MDg2OTExCgkyMjogWzE2MDYyNzIuLjE3NTA2NTVdOiBob2xlCgkyMzog
WzE3NTA2NTYuLjE3NTM2NjNdOiA2MDkyMzEyOTYuLjYwOTIzNDMwMwoJMjQ6IFsxNzUzNjY0Li4x
ODk1MDM5XTogaG9sZQoJMjU6IFsxODk1MDQwLi4xODk4MDQ3XTogNjA5Mzc1NjgwLi42MDkzNzg2
ODcKCTI2OiBbMTg5ODA0OC4uMjA0MjQzMV06IGhvbGUKCTI3OiBbMjA0MjQzMi4uMjA0NTQzOV06
IDYwOTUyMzA3Mi4uNjA5NTI2MDc5CgkyODogWzIwNDU0NDAuLjIxODY4MTVdOiBob2xlCgkyOTog
WzIxODY4MTYuLjIxODk4MjNdOiA2MDk2Njc0NTYuLjYwOTY3MDQ2MwoJMzA6IFsyMTg5ODI0Li4y
MzM0MjA3XTogaG9sZQoJMzE6IFsyMzM0MjA4Li4yMzM0NzE5XTogNjA5ODE0ODQ4Li42MDk4MTUz
NTkKCTMyOiBbMjMzNDcyMC4uMzg1MzI0N106IDYwOTgxNTM2MC4uNjExMzMzODg3Cg==

--_005_345BE8CDF5F1514CB9B5CB3FFFA9B65920197Dxmbalnx14ciscocom_
Content-Type: application/octet-stream; name="repair_log1"
Content-Description: repair_log1
Content-Disposition: attachment; filename="repair_log1"; size=1735;
	creation-date="Wed, 14 Aug 2013 12:27:04 GMT";
	modification-date="Wed, 14 Aug 2013 12:20:39 GMT"
Content-Transfer-Encoding: base64

UGhhc2UgMSAtIGZpbmQgYW5kIHZlcmlmeSBzdXBlcmJsb2NrLi4uClBoYXNlIDIgLSB1c2luZyBp
bnRlcm5hbCBsb2cKICAgICAgICAtIHplcm8gbG9nLi4uCiAgICAgICAgLSBzY2FuIGZpbGVzeXN0
ZW0gZnJlZXNwYWNlIGFuZCBpbm9kZSBtYXBzLi4uCiAgICAgICAgLSBmb3VuZCByb290IGlub2Rl
IGNodW5rClBoYXNlIDMgLSBmb3IgZWFjaCBBRy4uLgogICAgICAgIC0gc2NhbiBhbmQgY2xlYXIg
YWdpIHVubGlua2VkIGxpc3RzLi4uCiAgICAgICAgLSBwcm9jZXNzIGtub3duIGlub2RlcyBhbmQg
cGVyZm9ybSBpbm9kZSBkaXNjb3ZlcnkuLi4KICAgICAgICAtIGFnbm8gPSAwCmRhdGEgZm9yayBp
biBydCBpbm9kZSAxOTcgY2xhaW1zIHVzZWQgcnQgYmxvY2sgMjAyNzMxCmJhZCBkYXRhIGZvcmsg
aW4gaW5vZGUgMTk3CmNsZWFyZWQgaW5vZGUgMTk3CiAgICAgICAgLSBhZ25vID0gMQogICAgICAg
IC0gYWdubyA9IDIKICAgICAgICAtIGFnbm8gPSAzCiAgICAgICAgLSBhZ25vID0gNAogICAgICAg
IC0gYWdubyA9IDUKICAgICAgICAtIGFnbm8gPSA2CiAgICAgICAgLSBhZ25vID0gNwogICAgICAg
IC0gYWdubyA9IDgKICAgICAgICAtIGFnbm8gPSA5CiAgICAgICAgLSBhZ25vID0gMTAKICAgICAg
ICAtIGFnbm8gPSAxMQogICAgICAgIC0gYWdubyA9IDEyCiAgICAgICAgLSBhZ25vID0gMTMKICAg
ICAgICAtIGFnbm8gPSAxNAogICAgICAgIC0gYWdubyA9IDE1CiAgICAgICAgLSBwcm9jZXNzIG5l
d2x5IGRpc2NvdmVyZWQgaW5vZGVzLi4uClBoYXNlIDQgLSBjaGVjayBmb3IgZHVwbGljYXRlIGJs
b2Nrcy4uLgogICAgICAgIC0gc2V0dGluZyB1cCBkdXBsaWNhdGUgZXh0ZW50IGxpc3QuLi4KICAg
ICAgICAtIGNoZWNrIGZvciBpbm9kZXMgY2xhaW1pbmcgZHVwbGljYXRlIGJsb2Nrcy4uLgogICAg
ICAgIC0gYWdubyA9IDAKZW50cnkgIjAuU1RSIiBpbiBzaG9ydGZvcm0gZGlyZWN0b3J5IDE5NSBy
ZWZlcmVuY2VzIGZyZWUgaW5vZGUgMTk3Cmp1bmtpbmcgZW50cnkgIjAuU1RSIiBpbiBkaXJlY3Rv
cnkgaW5vZGUgMTk1CiAgICAgICAgLSBhZ25vID0gMQogICAgICAgIC0gYWdubyA9IDIKICAgICAg
ICAtIGFnbm8gPSAzCiAgICAgICAgLSBhZ25vID0gNAogICAgICAgIC0gYWdubyA9IDUKICAgICAg
ICAtIGFnbm8gPSA2CiAgICAgICAgLSBhZ25vID0gNwogICAgICAgIC0gYWdubyA9IDgKICAgICAg
ICAtIGFnbm8gPSA5CiAgICAgICAgLSBhZ25vID0gMTAKICAgICAgICAtIGFnbm8gPSAxMQogICAg
ICAgIC0gYWdubyA9IDEyCiAgICAgICAgLSBhZ25vID0gMTMKICAgICAgICAtIGFnbm8gPSAxNAog
ICAgICAgIC0gYWdubyA9IDE1ClBoYXNlIDUgLSByZWJ1aWxkIEFHIGhlYWRlcnMgYW5kIHRyZWVz
Li4uCiAgICAgICAgLSBnZW5lcmF0ZSByZWFsdGltZSBzdW1tYXJ5IGluZm8gYW5kIGJpdG1hcC4u
LgogICAgICAgIC0gcmVzZXQgc3VwZXJibG9jay4uLgpQaGFzZSA2IC0gY2hlY2sgaW5vZGUgY29u
bmVjdGl2aXR5Li4uCiAgICAgICAgLSByZXNldHRpbmcgY29udGVudHMgb2YgcmVhbHRpbWUgYml0
bWFwIGFuZCBzdW1tYXJ5IGlub2RlcwogICAgICAgIC0gdHJhdmVyc2luZyBmaWxlc3lzdGVtIC4u
LgogICAgICAgIC0gdHJhdmVyc2FsIGZpbmlzaGVkIC4uLgogICAgICAgIC0gbW92aW5nIGRpc2Nv
bm5lY3RlZCBpbm9kZXMgdG8gbG9zdCtmb3VuZCAuLi4KUGhhc2UgNyAtIHZlcmlmeSBhbmQgY29y
cmVjdCBsaW5rIGNvdW50cy4uLgpkb25lCg==

--_005_345BE8CDF5F1514CB9B5CB3FFFA9B65920197Dxmbalnx14ciscocom_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--_005_345BE8CDF5F1514CB9B5CB3FFFA9B65920197Dxmbalnx14ciscocom_--
