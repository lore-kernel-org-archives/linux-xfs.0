Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3237829DF5
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 14:48:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0BB6C30405F
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 12:48:50 -0800 (PST)
Received: from mail-lf0-f45.google.com (mail-lf0-f45.google.com
	[209.85.215.45]) by cuda.sgi.com with ESMTP id 2qwpr90bQgj0i2Op
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Nov 2015 12:48:46 -0800 (PST)
Received: by lfaz4 with SMTP id z4so213882381lfa.0
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 12:48:45 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 30 Nov 2015 22:48:45 +0200
Message-ID: <CAN9JxOBRynxTiEcsgYWKO2SVNFwdeV7gDHfZcbPb4umWXsj5DQ@mail.gmail.com>
Subject: XFS corruption - Ubuntu 14.04 VM with RDM
From: Amir Soroka <amirsoroka@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4843747567338040095=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4843747567338040095==
Content-Type: multipart/alternative; boundary=001a11c37fbaccec750525c82a2b

--001a11c37fbaccec750525c82a2b
Content-Type: text/plain; charset=UTF-8

Hello,
We have a corruption issue. Would be happy to get a solution.

Configuration is Ubuntu 14.04 (generic) as a VM over ESXi 5.5, with 1.6 TB
RDM - storage has a Cache battery, Raid 6, SSD disks.
During some heavy indexing activity we get a corruption as you can see
below.
Some more information:
* Mount options: defaults,noatime,nodiratime,nobarrier,inode64,logbufs=8 0 0
* XFS was created like this: mkfs.xfs -f -d su=131072,sw=8 -i size=1024
/dev/sdb1
* Parted command was: /sbin/parted -s $i mklabel gpt mkpart /dev/sdb1 xfs
2048s 100%


[   10.395575] XFS (sdb1): Mounting V4 Filesystem
[   10.430107] XFS (sdb1): Ending clean mount
[  675.504000] XFS (sdb1): Metadata corruption detected at
xfs_agf_read_verify+0x61/0x100 [xfs], block 0x1
[  675.504043] XFS (sdb1): Unmount and run xfs_repair
[  675.504062] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[  675.504218] XFS (sdb1): metadata I/O error: block 0x1
("xfs_trans_read_buf_map") error 117 numblks 1
[  675.504257] XFS (sdb1): page discard on page ffffea003fbdc280, inode
0x86, offset 0.
[  677.186009] XFS (sdb1): Metadata corruption detected at
xfs_agf_read_verify+0x61/0x100 [xfs], block 0x1
[  677.186052] XFS (sdb1): Unmount and run xfs_repair
[  677.186070] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[  677.186239] XFS (sdb1): metadata I/O error: block 0x1
("xfs_trans_read_buf_map") error 117 numblks 1
[  677.186283] XFS (sdb1): page discard on page ffffea0000d8d480, inode
0x87, offset 0.
[ 4203.145905] XFS (sdb1): Metadata corruption detected at
xfs_agf_read_verify+0x61/0x100 [xfs], block 0x1
[ 4203.145957] XFS (sdb1): Unmount and run xfs_repair
[ 4203.145976] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[ 4203.146132] XFS (sdb1): metadata I/O error: block 0x1
("xfs_trans_read_buf_map") error 117 numblks 1
[ 4203.146171] XFS (sdb1): page discard on page ffffea002c1399c0, inode
0x60003c0c, offset 0.
[84997.832171] XFS (sdb1): Metadata corruption detected at
xfs_inode_buf_verify+0x7d/0xe0 [xfs], block 0x110
[84997.835828] XFS (sdb1): Unmount and run xfs_repair
[84997.836502] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[84997.839848] XFS (sdb1): Metadata corruption detected at
xfs_inode_buf_verify+0x7d/0xe0 [xfs], block 0x110
[84997.841188] XFS (sdb1): Unmount and run xfs_repair
[84997.841872] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[84997.845252] XFS (sdb1): Metadata corruption detected at
xfs_inode_buf_verify+0x7d/0xe0 [xfs], block 0x110
[84997.846523] XFS (sdb1): Unmount and run xfs_repair
[84997.847154] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[84997.850467] XFS (sdb1): Metadata corruption detected at
xfs_inode_buf_verify+0x7d/0xe0 [xfs], block 0x110
[84997.851714] XFS (sdb1): Unmount and run xfs_repair
[84997.852319] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[84997.855469] XFS (sdb1): Metadata corruption detected at
xfs_inode_buf_verify+0x7d/0xe0 [xfs], block 0x110
[84997.856718] XFS (sdb1): Unmount and run xfs_repair
[84997.857340] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[84997.860366] XFS (sdb1): Metadata corruption detected at
xfs_inode_buf_verify+0x7d/0xe0 [xfs], block 0x110
[84997.861521] XFS (sdb1): Unmount and run xfs_repair
[84997.862117] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[84997.865178] XFS (sdb1): Metadata corruption detected at
xfs_inode_buf_verify+0x7d/0xe0 [xfs], block 0x110
[84997.866356] XFS (sdb1): Unmount and run xfs_repair
[84997.866962] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[84997.869987] XFS (sdb1): Metadata corruption detected at
xfs_inode_buf_verify+0x7d/0xe0 [xfs], block 0x110
[84997.871163] XFS (sdb1): Unmount and run xfs_repair
[84997.871760] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[84997.874798] XFS (sdb1): metadata I/O error: block 0x110
("xfs_trans_read_buf_map") error 117 numblks 16
[84997.875947] XFS (sdb1): xfs_do_force_shutdown(0x1) called from line 315
of file
/build/linux-lts-vivid-6tG2ln/linux-lts-vivid-3.19.0/fs/xfs/xfs_trans_buf.c.
Return address = 0xffffffffc02596ab
[84997.888409] XFS (sdb1): I/O Error Detected. Shutting down filesystem
[84997.889017] XFS (sdb1): Please umount the filesystem and rectify the
problem(s)
[84997.889643] XFS (sdb1): xfs_imap_to_bp: xfs_trans_read_buf() returned
error -117.
[85011.531433] XFS (sdb1): xfs_log_force: error -5 returned.
[85041.596418] XFS (sdb1): xfs_log_force: error -5 returned.
[85071.661447] XFS (sdb1): xfs_log_force: error -5 returned.
[85101.726398] XFS (sdb1): xfs_log_force: error -5 returned.
[85131.791376] XFS (sdb1): xfs_log_force: error -5 returned.
[85161.856372] XFS (sdb1): xfs_log_force: error -5 returned.
[85191.921373] XFS (sdb1): xfs_log_force: error -5 returned.
[85221.986341] XFS (sdb1): xfs_log_force: error -5 returned.
[85252.051322] XFS (sdb1): xfs_log_force: error -5 returned.
[85282.117357] XFS (sdb1): xfs_log_force: error -5 returned.
[85312.181319] XFS (sdb1): xfs_log_force: error -5 returned.
[85342.246276] XFS (sdb1): xfs_log_force: error -5 returned.
[85372.311273] XFS (sdb1): xfs_log_force: error -5 returned.
[85402.376250] XFS (sdb1): xfs_log_force: error -5 returned.
[85432.441269] XFS (sdb1): xfs_log_force: error -5 returned.
[85462.506208] XFS (sdb1): xfs_log_force: error -5 returned.
[85492.571203] XFS (sdb1): xfs_log_force: error -5 returned.
[85522.636192] XFS (sdb1): xfs_log_force: error -5 returned.
[85552.701213] XFS (sdb1): xfs_log_force: error -5 returned.
[85582.766164] XFS (sdb1): xfs_log_force: error -5 returned.
[85612.831140] XFS (sdb1): xfs_log_force: error -5 returned.
[85642.896133] XFS (sdb1): xfs_log_force: error -5 returned.
[85672.961128] XFS (sdb1): xfs_log_force: error -5 returned.
[85703.026104] XFS (sdb1): xfs_log_force: error -5 returned.
[85733.091083] XFS (sdb1): xfs_log_force: error -5 returned.
[85763.156070] XFS (sdb1): xfs_log_force: error -5 returned.
[85793.221079] XFS (sdb1): xfs_log_force: error -5 returned.
[85823.286041] XFS (sdb1): xfs_log_force: error -5 returned.
[85853.351019] XFS (sdb1): xfs_log_force: error -5 returned.
[85883.416016] XFS (sdb1): xfs_log_force: error -5 returned.
[85913.481014] XFS (sdb1): xfs_log_force: error -5 returned.
[85923.032422] XFS (sdb1): xfs_log_force: error -5 returned.
[85923.033429] XFS (sdb1): xfs_log_force: error -5 returned.
[85923.033601] XFS (sdb1): xfs_log_force: error -5 returned.
[86173.742817] XFS (sdb1): Mounting V4 Filesystem
[86173.780730] XFS (sdb1): Starting recovery (logdev: internal)
[86173.787173] XFS (sdb1): Metadata corruption detected at
xfs_agf_read_verify+0x61/0x100 [xfs], block 0x1
[86173.788445] XFS (sdb1): Unmount and run xfs_repair
[86173.789072] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[86173.792242] XFS (sdb1): metadata I/O error: block 0x1
("xfs_trans_read_buf_map") error 117 numblks 1
[86187.845410] XFS (sdb1): Mounting V4 Filesystem
[86187.881669] XFS (sdb1): Ending clean mount

Thanks,
Amir

--001a11c37fbaccec750525c82a2b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hello,</div><div>We have a corruption issue. Would be=
 happy to get a solution.</div><div><br></div><div>Configuration is Ubuntu =
14.04 (generic) as a VM over ESXi 5.5, with 1.6 TB RDM - storage has a Cach=
e battery, Raid 6, SSD disks.</div><div>During some heavy indexing activity=
 we get a corruption as you can see below.</div><div>Some more information:=
</div><div>* Mount options: defaults,noatime,nodiratime,nobarrier,inode64,l=
ogbufs=3D8 0 0</div><div>* XFS was created like this: mkfs.xfs -f -d su=3D1=
31072,sw=3D8 -i size=3D1024 /dev/sdb1</div><div>* Parted command was: /sbin=
/parted -s $i mklabel gpt mkpart /dev/sdb1 xfs 2048s 100%</div><div><br></d=
iv><div><br></div><div>[ =C2=A0 10.395575] XFS (sdb1): Mounting V4 Filesyst=
em</div><div>[ =C2=A0 10.430107] XFS (sdb1): Ending clean mount</div><div>[=
 =C2=A0675.504000] XFS (sdb1): Metadata corruption detected at xfs_agf_read=
_verify+0x61/0x100 [xfs], block 0x1</div><div>[ =C2=A0675.504043] XFS (sdb1=
): Unmount and run xfs_repair</div><div>[ =C2=A0675.504062] XFS (sdb1): Fir=
st 64 bytes of corrupted metadata buffer:</div><div>[ =C2=A0675.504218] XFS=
 (sdb1): metadata I/O error: block 0x1 (&quot;xfs_trans_read_buf_map&quot;)=
 error 117 numblks 1</div><div>[ =C2=A0675.504257] XFS (sdb1): page discard=
 on page ffffea003fbdc280, inode 0x86, offset 0.</div><div>[ =C2=A0677.1860=
09] XFS (sdb1): Metadata corruption detected at xfs_agf_read_verify+0x61/0x=
100 [xfs], block 0x1</div><div>[ =C2=A0677.186052] XFS (sdb1): Unmount and =
run xfs_repair</div><div>[ =C2=A0677.186070] XFS (sdb1): First 64 bytes of =
corrupted metadata buffer:</div><div>[ =C2=A0677.186239] XFS (sdb1): metada=
ta I/O error: block 0x1 (&quot;xfs_trans_read_buf_map&quot;) error 117 numb=
lks 1</div><div>[ =C2=A0677.186283] XFS (sdb1): page discard on page ffffea=
0000d8d480, inode 0x87, offset 0.</div><div>[ 4203.145905] XFS (sdb1): Meta=
data corruption detected at xfs_agf_read_verify+0x61/0x100 [xfs], block 0x1=
</div><div>[ 4203.145957] XFS (sdb1): Unmount and run xfs_repair</div><div>=
[ 4203.145976] XFS (sdb1): First 64 bytes of corrupted metadata buffer:</di=
v><div>[ 4203.146132] XFS (sdb1): metadata I/O error: block 0x1 (&quot;xfs_=
trans_read_buf_map&quot;) error 117 numblks 1</div><div>[ 4203.146171] XFS =
(sdb1): page discard on page ffffea002c1399c0, inode 0x60003c0c, offset 0.<=
/div><div>[84997.832171] XFS (sdb1): Metadata corruption detected at xfs_in=
ode_buf_verify+0x7d/0xe0 [xfs], block 0x110</div><div>[84997.835828] XFS (s=
db1): Unmount and run xfs_repair</div><div>[84997.836502] XFS (sdb1): First=
 64 bytes of corrupted metadata buffer:</div><div>[84997.839848] XFS (sdb1)=
: Metadata corruption detected at xfs_inode_buf_verify+0x7d/0xe0 [xfs], blo=
ck 0x110</div><div>[84997.841188] XFS (sdb1): Unmount and run xfs_repair</d=
iv><div>[84997.841872] XFS (sdb1): First 64 bytes of corrupted metadata buf=
fer:</div><div>[84997.845252] XFS (sdb1): Metadata corruption detected at x=
fs_inode_buf_verify+0x7d/0xe0 [xfs], block 0x110</div><div>[84997.846523] X=
FS (sdb1): Unmount and run xfs_repair</div><div>[84997.847154] XFS (sdb1): =
First 64 bytes of corrupted metadata buffer:</div><div>[84997.850467] XFS (=
sdb1): Metadata corruption detected at xfs_inode_buf_verify+0x7d/0xe0 [xfs]=
, block 0x110</div><div>[84997.851714] XFS (sdb1): Unmount and run xfs_repa=
ir</div><div>[84997.852319] XFS (sdb1): First 64 bytes of corrupted metadat=
a buffer:</div><div>[84997.855469] XFS (sdb1): Metadata corruption detected=
 at xfs_inode_buf_verify+0x7d/0xe0 [xfs], block 0x110</div><div>[84997.8567=
18] XFS (sdb1): Unmount and run xfs_repair</div><div>[84997.857340] XFS (sd=
b1): First 64 bytes of corrupted metadata buffer:</div><div>[84997.860366] =
XFS (sdb1): Metadata corruption detected at xfs_inode_buf_verify+0x7d/0xe0 =
[xfs], block 0x110</div><div>[84997.861521] XFS (sdb1): Unmount and run xfs=
_repair</div><div>[84997.862117] XFS (sdb1): First 64 bytes of corrupted me=
tadata buffer:</div><div>[84997.865178] XFS (sdb1): Metadata corruption det=
ected at xfs_inode_buf_verify+0x7d/0xe0 [xfs], block 0x110</div><div>[84997=
.866356] XFS (sdb1): Unmount and run xfs_repair</div><div>[84997.866962] XF=
S (sdb1): First 64 bytes of corrupted metadata buffer:</div><div>[84997.869=
987] XFS (sdb1): Metadata corruption detected at xfs_inode_buf_verify+0x7d/=
0xe0 [xfs], block 0x110</div><div>[84997.871163] XFS (sdb1): Unmount and ru=
n xfs_repair</div><div>[84997.871760] XFS (sdb1): First 64 bytes of corrupt=
ed metadata buffer:</div><div>[84997.874798] XFS (sdb1): metadata I/O error=
: block 0x110 (&quot;xfs_trans_read_buf_map&quot;) error 117 numblks 16</di=
v><div>[84997.875947] XFS (sdb1): xfs_do_force_shutdown(0x1) called from li=
ne 315 of file /build/linux-lts-vivid-6tG2ln/linux-lts-vivid-3.19.0/fs/xfs/=
xfs_trans_buf.c.=C2=A0 Return address =3D 0xffffffffc02596ab</div><div>[849=
97.888409] XFS (sdb1): I/O Error Detected. Shutting down filesystem</div><d=
iv>[84997.889017] XFS (sdb1): Please umount the filesystem and rectify the =
problem(s)</div><div>[84997.889643] XFS (sdb1): xfs_imap_to_bp: xfs_trans_r=
ead_buf() returned error -117.</div><div>[85011.531433] XFS (sdb1): xfs_log=
_force: error -5 returned.</div><div>[85041.596418] XFS (sdb1): xfs_log_for=
ce: error -5 returned.</div><div>[85071.661447] XFS (sdb1): xfs_log_force: =
error -5 returned.</div><div>[85101.726398] XFS (sdb1): xfs_log_force: erro=
r -5 returned.</div><div>[85131.791376] XFS (sdb1): xfs_log_force: error -5=
 returned.</div><div>[85161.856372] XFS (sdb1): xfs_log_force: error -5 ret=
urned.</div><div>[85191.921373] XFS (sdb1): xfs_log_force: error -5 returne=
d.</div><div>[85221.986341] XFS (sdb1): xfs_log_force: error -5 returned.</=
div><div>[85252.051322] XFS (sdb1): xfs_log_force: error -5 returned.</div>=
<div>[85282.117357] XFS (sdb1): xfs_log_force: error -5 returned.</div><div=
>[85312.181319] XFS (sdb1): xfs_log_force: error -5 returned.</div><div>[85=
342.246276] XFS (sdb1): xfs_log_force: error -5 returned.</div><div>[85372.=
311273] XFS (sdb1): xfs_log_force: error -5 returned.</div><div>[85402.3762=
50] XFS (sdb1): xfs_log_force: error -5 returned.</div><div>[85432.441269] =
XFS (sdb1): xfs_log_force: error -5 returned.</div><div>[85462.506208] XFS =
(sdb1): xfs_log_force: error -5 returned.</div><div>[85492.571203] XFS (sdb=
1): xfs_log_force: error -5 returned.</div><div>[85522.636192] XFS (sdb1): =
xfs_log_force: error -5 returned.</div><div>[85552.701213] XFS (sdb1): xfs_=
log_force: error -5 returned.</div><div>[85582.766164] XFS (sdb1): xfs_log_=
force: error -5 returned.</div><div>[85612.831140] XFS (sdb1): xfs_log_forc=
e: error -5 returned.</div><div>[85642.896133] XFS (sdb1): xfs_log_force: e=
rror -5 returned.</div><div>[85672.961128] XFS (sdb1): xfs_log_force: error=
 -5 returned.</div><div>[85703.026104] XFS (sdb1): xfs_log_force: error -5 =
returned.</div><div>[85733.091083] XFS (sdb1): xfs_log_force: error -5 retu=
rned.</div><div>[85763.156070] XFS (sdb1): xfs_log_force: error -5 returned=
.</div><div>[85793.221079] XFS (sdb1): xfs_log_force: error -5 returned.</d=
iv><div>[85823.286041] XFS (sdb1): xfs_log_force: error -5 returned.</div><=
div>[85853.351019] XFS (sdb1): xfs_log_force: error -5 returned.</div><div>=
[85883.416016] XFS (sdb1): xfs_log_force: error -5 returned.</div><div>[859=
13.481014] XFS (sdb1): xfs_log_force: error -5 returned.</div><div>[85923.0=
32422] XFS (sdb1): xfs_log_force: error -5 returned.</div><div>[85923.03342=
9] XFS (sdb1): xfs_log_force: error -5 returned.</div><div>[85923.033601] X=
FS (sdb1): xfs_log_force: error -5 returned.</div><div>[86173.742817] XFS (=
sdb1): Mounting V4 Filesystem</div><div>[86173.780730] XFS (sdb1): Starting=
 recovery (logdev: internal)</div><div>[86173.787173] XFS (sdb1): Metadata =
corruption detected at xfs_agf_read_verify+0x61/0x100 [xfs], block 0x1</div=
><div>[86173.788445] XFS (sdb1): Unmount and run xfs_repair</div><div>[8617=
3.789072] XFS (sdb1): First 64 bytes of corrupted metadata buffer:</div><di=
v>[86173.792242] XFS (sdb1): metadata I/O error: block 0x1 (&quot;xfs_trans=
_read_buf_map&quot;) error 117 numblks 1</div><div>[86187.845410] XFS (sdb1=
): Mounting V4 Filesystem</div><div>[86187.881669] XFS (sdb1): Ending clean=
 mount</div><div><br></div><div>Thanks,</div><div>Amir</div></div>

--001a11c37fbaccec750525c82a2b--


--===============4843747567338040095==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4843747567338040095==--
