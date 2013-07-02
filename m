Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D4F57F58
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 11:02:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C92E8F8068
	for <xfs@oss.sgi.com>; Tue,  2 Jul 2013 09:02:30 -0700 (PDT)
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id 8ZC1sAfkKJskxTT5
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Jul 2013 09:02:28 -0700 (PDT)
Received: by mail-ee0-f53.google.com with SMTP id c41so2867511eek.12
	for <xfs@oss.sgi.com>; Tue, 02 Jul 2013 09:02:27 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 2 Jul 2013 09:02:27 -0700
Message-ID: <CAHWZUV8hkyWGpO+zrAM_u5DFsRoxtaAOhGE2dWVFoFpMAcNY+Q@mail.gmail.com>
Subject: Flush and XFS deadlock in D state at fclose (after heavy XFS writes)
From: Norman Cheung <brjerome.1@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0885114832256501100=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0885114832256501100==
Content-Type: multipart/alternative; boundary=047d7b603a12bbfcaa04e0897825

--047d7b603a12bbfcaa04e0897825
Content-Type: text/plain; charset=ISO-8859-1

I initial message was bounced due to large message size; and since then
re-posting seems not to work.  Using a different email address hoping would
help. If you get this in duplicate, my apologies.

I had this issue with Kernel 3.0.13 and reported in this forum ~4 months
ago. I'd been working with Suse support to resolve but getting no where.  I
will be grateful should someone can help and give me some pointers to solve
or work around this hang.  Suse has asked me to reproduce it with
3.0.80-0.5(their latest release) so all the attached traces were produced
against this kernel.

My application has ~10+ threads running non-stop with high CPU usage (close
to 100% and each is locked to a specific CPU with 32 CPUs in the server).
 The processing runs in a 5 minute cycle. After the second minute 5 of
these threads start writing to disk for 3 minutes. Each thread writes a
file ~16G in size.  The threads run with very high priority (-2, much
higher than flush, I also tried threads with same priority as pdflush,
fails sooner)

Disk is a raid-5, I have also tried 5 X raid-0, one raid per disk writing
thread same result.

Below are the traces from magic sysrq "w"

If I use O_DIRECT write, my application will run for 5-6 days and hang.  If
I use buffered write, it will hang after 3-4 hours.

And when I attached GDB to my applications, the flush-8:16 will immediately
free from D state, and my application too.

Without knowing the internal of flush(write back) and XFS, this is my guess
looking at the trace below:
Could it be that flush(xfs_fs_write_inode)  and my application
(xfs_file_release at fclose) are holding the same lock?  Or could it be
that some resources in the system (e.g. page cache?) is exhausted and
waiting for hang in waiting for reclaim.

Stack trace of a few thread of interests.  The entire dump if interested, I
can send in a separate mail:

Jun 28 19:34:11 IMCNode000 kernel: [29127.580426] SysRq : Show Blocked State
Jun 28 19:34:11 IMCNode000 kernel: [29127.580434]   task
     PC stack   pid father
Jun 28 19:34:11 IMCNode000 kernel: [29127.580629] flush-8:16      D
0000000000000400     0  5502      2 0x00000000
Jun 28 19:34:11 IMCNode000 kernel: [29127.580636]  ffff883e5bbb7b90
0000000000000046 ffff8819c91d25c0 ffff883e5bbb6010
Jun 28 19:34:11 IMCNode000 kernel: [29127.580643]  0000000000011180
0000000000011180 ffff883e5bbb7fd8 ffff883e5bbb7fd8
Jun 28 19:34:11 IMCNode000 kernel: [29127.580651]  0000000000011180
ffff883e5b8aa0c0 ffff8819c91d25c0 ffff8819dc99a3c0
Jun 28 19:34:11 IMCNode000 kernel: [29127.580658] Call Trace:
Jun 28 19:34:11 IMCNode000 kernel: [29127.580711]  [<ffffffffa04a2cd5>]
xfs_ioend_wait+0x85/0xb0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.580800]  [<ffffffffa04acb28>]
xfs_fs_write_inode+0xb8/0x190 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.580880]  [<ffffffff81177793>]
writeback_single_inode+0x2f3/0x360
Jun 28 19:34:11 IMCNode000 kernel: [29127.580889]  [<ffffffff81177ee4>]
writeback_sb_inodes+0xc4/0x1a0
Jun 28 19:34:11 IMCNode000 kernel: [29127.580897]  [<ffffffff81178743>]
writeback_inodes_wb+0xd3/0x160
Jun 28 19:34:11 IMCNode000 kernel: [29127.580904]  [<ffffffff81178b8b>]
wb_writeback+0x3bb/0x400
Jun 28 19:34:11 IMCNode000 kernel: [29127.580911]  [<ffffffff81178e0b>]
wb_do_writeback+0x23b/0x250
Jun 28 19:34:11 IMCNode000 kernel: [29127.580918]  [<ffffffff81178f04>]
bdi_writeback_thread+0xe4/0x240
Jun 28 19:34:11 IMCNode000 kernel: [29127.580926]  [<ffffffff8107c646>]
kthread+0x96/0xa0
Jun 28 19:34:11 IMCNode000 kernel: [29127.580936]  [<ffffffff81450e44>]
kernel_thread_helper+0x4/0x10
Jun 28 19:34:11 IMCNode000 kernel: [29127.580954] Tigris_IMC.exe  D
0000000100669478     0  6347   6269 0x00000000
Jun 28 19:34:11 IMCNode000 kernel: [29127.580960]  ffff8819dc9b5848
0000000000000086 0000000000000000 ffff8819dc9b4010
Jun 28 19:34:11 IMCNode000 kernel: [29127.580968]  0000000000011180
0000000000011180 ffff8819dc9b5fd8 ffff8819dc9b5fd8
Jun 28 19:34:11 IMCNode000 kernel: [29127.580975]  0000000000011180
ffff8819dc9b2540 0000000085227080 ffff883e86942400
Jun 28 19:34:11 IMCNode000 kernel: [29127.580982] Call Trace:
Jun 28 19:34:11 IMCNode000 kernel: [29127.580991]  [<ffffffff81446555>]
schedule_timeout+0x205/0x2a0
Jun 28 19:34:11 IMCNode000 kernel: [29127.580998]  [<ffffffff814472f8>]
__down+0x68/0xb0
Jun 28 19:34:11 IMCNode000 kernel: [29127.581008]  [<ffffffff81082097>]
down+0x47/0x50
Jun 28 19:34:11 IMCNode000 kernel: [29127.581030]  [<ffffffffa04a3ce9>]
xfs_buf_lock+0x59/0xc0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581104]  [<ffffffffa04a522b>]
_xfs_buf_find+0x11b/0x210 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581176]  [<ffffffffa04a5356>]
xfs_buf_get+0x36/0x1d0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581248]  [<ffffffffa04a5514>]
xfs_buf_read+0x24/0x110 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581322]  [<ffffffffa049a8ce>]
xfs_trans_read_buf+0x28e/0x3e0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581393]  [<ffffffffa0467f5e>]
xfs_btree_read_buf_block+0x5e/0xd0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581438]  [<ffffffffa0468682>]
xfs_btree_lookup_get_block+0x82/0xf0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581480]  [<ffffffffa0468d32>]
xfs_btree_lookup+0xd2/0x470 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581522]  [<ffffffffa045f967>]
xfs_bmap_del_extent+0x147/0xac0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581560]  [<ffffffffa0463857>]
xfs_bunmapi+0x5d7/0xbc0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581601]  [<ffffffffa0482cc8>]
xfs_itruncate_finish+0x168/0x330 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581657]  [<ffffffffa049e5ce>]
xfs_free_eofblocks+0x1ce/0x2b0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581725]  [<ffffffffa049f18c>]
xfs_release+0x13c/0x230 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581793]  [<ffffffffa04a6f00>]
xfs_file_release+0x10/0x20 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.581855]  [<ffffffff81153e83>]
__fput+0xb3/0x200
Jun 28 19:34:11 IMCNode000 kernel: [29127.581863]  [<ffffffff8114fefc>]
filp_close+0x5c/0x90
Jun 28 19:34:11 IMCNode000 kernel: [29127.581870]  [<ffffffff8114ffd7>]
sys_close+0xa7/0x100
Jun 28 19:34:11 IMCNode000 kernel: [29127.581879]  [<ffffffff8144fd12>]
system_call_fastpath+0x16/0x1b
Jun 28 19:34:11 IMCNode000 kernel: [29127.581897]  [<00007f90392c2ea0>]
0x7f90392c2e9f
Jun 28 19:34:11 IMCNode000 kernel: [29127.581903] Tigris_IMC.exe  D
ffff887ef8994710     0  6352   6269 0x00000000
Jun 28 19:34:11 IMCNode000 kernel: [29127.581909]  ffff8819dcbe7848
0000000000000086 ffffffffa0480c7e ffff8819dcbe6010
Jun 28 19:34:11 IMCNode000 kernel: [29127.581916]  0000000000011180
0000000000011180 ffff8819dcbe7fd8 ffff8819dcbe7fd8
Jun 28 19:34:11 IMCNode000 kernel: [29127.581923]  0000000000011180
ffff8819dcbe4680 ffff883e85249e80 ffff883e86a123c0
Jun 28 19:34:11 IMCNode000 kernel: [29127.581930] Call Trace:
Jun 28 19:34:11 IMCNode000 kernel: [29127.581940]  [<ffffffff81446555>]
schedule_timeout+0x205/0x2a0
Jun 28 19:34:11 IMCNode000 kernel: [29127.581952]  [<ffffffff814472f8>]
__down+0x68/0xb0
Jun 28 19:34:11 IMCNode000 kernel: [29127.581959]  [<ffffffff81082097>]
down+0x47/0x50
Jun 28 19:34:11 IMCNode000 kernel: [29127.581979]  [<ffffffffa04a3ce9>]
xfs_buf_lock+0x59/0xc0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582050]  [<ffffffffa04a522b>]
_xfs_buf_find+0x11b/0x210 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582121]  [<ffffffffa04a5356>]
xfs_buf_get+0x36/0x1d0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582191]  [<ffffffffa04a5514>]
xfs_buf_read+0x24/0x110 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582264]  [<ffffffffa049a8ce>]
xfs_trans_read_buf+0x28e/0x3e0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582330]  [<ffffffffa0467f5e>]
xfs_btree_read_buf_block+0x5e/0xd0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582371]  [<ffffffffa0468682>]
xfs_btree_lookup_get_block+0x82/0xf0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582413]  [<ffffffffa0468d32>]
xfs_btree_lookup+0xd2/0x470 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582454]  [<ffffffffa045f967>]
xfs_bmap_del_extent+0x147/0xac0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582494]  [<ffffffffa0463857>]
xfs_bunmapi+0x5d7/0xbc0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582541]  [<ffffffffa0482cc8>]
xfs_itruncate_finish+0x168/0x330 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582597]  [<ffffffffa049e5ce>]
xfs_free_eofblocks+0x1ce/0x2b0 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582665]  [<ffffffffa049f18c>]
xfs_release+0x13c/0x230 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582733]  [<ffffffffa04a6f00>]
xfs_file_release+0x10/0x20 [xfs]
Jun 28 19:34:11 IMCNode000 kernel: [29127.582794]  [<ffffffff81153e83>]
__fput+0xb3/0x200
Jun 28 19:34:11 IMCNode000 kernel: [29127.582801]  [<ffffffff8114fefc>]
filp_close+0x5c/0x90
Jun 28 19:34:11 IMCNode000 kernel: [29127.582807]  [<ffffffff8114ffd7>]
sys_close+0xa7/0x100
Jun 28 19:34:11 IMCNode000 kernel: [29127.582814]  [<ffffffff8144fd12>]
system_call_fastpath+0x16/0x1b
Jun 28 19:34:11 IMCNode000 kernel: [29127.582823]  [<00007f90392c2ea0>]
0x7f90392c2e9f


xfsprogs-3.1.6-0.7.1

xfs_info /raid
meta-data=/dev/sdb1              isize=256    agcount=4, agsize=243896192
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=975584768, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=476359, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


fdisk -l

WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util fdisk
doesn't support GPT. Use GNU Parted.
Disk /dev/sdb: 3996.0 GB, 3995997306880 bytes
255 heads, 63 sectors/track, 485819 cylinders, total 7804682240 sectors
Units = sectors of 1 * 512 = 512 bytes Sector size (logical/physical): 512
bytes / 512 bytes I/O size (minimum/optimal): 512 bytes / 512 bytes Disk
identifier: 0x80560481

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb4               1           1           0+  ee  GPT

 /proc/partitions
major minor  #blocks  name

   8       16 3902341120 sdb
   8       17 3902339072 sdb1
   8        0  124022784 sda
   8        1    1051648 sda1
   8        2    1051648 sda2
   8        3  121918464 sda3

/proc/meminfo
MemTotal:       526536468 kB
MemFree:        520264928 kB
Buffers:           16644 kB
Cached:           706520 kB
SwapCached:            0 kB
Active:           580108 kB
Inactive:         240800 kB
Active(anon):      98036 kB
Inactive(anon):       68 kB
Active(file):     482072 kB
Inactive(file):   240732 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       1051644 kB
SwapFree:        1051644 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:         97868 kB
Mapped:            13212 kB
Shmem:               236 kB
Slab:             125960 kB
SReclaimable:      17020 kB
SUnreclaim:       108940 kB
KernelStack:        3264 kB
PageTables:         3120 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    522322744 kB
Committed_AS:     432276 kB
VmallocTotal:   34359738367 kB
VmallocUsed:     1100980 kB
VmallocChunk:   34090199776 kB
HardwareCorrupted:     0 kB
AnonHugePages:     16384 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      129732 kB
DirectMap2M:     6133760 kB
DirectMap1G:    530579456 kB


Many thanks in advance,

Norman

--047d7b603a12bbfcaa04e0897825
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I initial message was bounced due to large message size; a=
nd since then re-posting seems not to work. =A0Using a different email addr=
ess hoping would help. If you get this in duplicate, my apologies.<div><br>=
</div>
<div><div>I had this issue with Kernel 3.0.13 and reported in this forum ~4=
 months ago. I&#39;d been working with Suse support to resolve but getting =
no where. =A0I will be grateful should someone can help and give me some po=
inters to solve or work around this hang. =A0Suse has asked me to reproduce=
 it with 3.0.80-0.5(their latest release) so all the attached traces were p=
roduced against this kernel.</div>
<div><br></div><div>My application has ~10+ threads running non-stop with h=
igh CPU usage (close to 100% and each is locked to a specific CPU with 32 C=
PUs in the server). =A0The processing runs in a 5 minute cycle. After the s=
econd minute 5 of these threads start writing to disk for 3 minutes. Each t=
hread writes a file ~16G in size. =A0The threads run with very high priorit=
y (-2, much higher than flush, I also tried threads with same priority as p=
dflush, fails sooner)</div>
<div><br></div><div>Disk is a raid-5, I have also tried 5 X raid-0, one rai=
d per disk writing thread same result.</div><div><br></div><div>Below are t=
he traces from magic sysrq &quot;w&quot;</div><div><br></div><div>If I use =
O_DIRECT write, my application will run for 5-6 days and hang. =A0If I use =
buffered write, it will hang after 3-4 hours.=A0</div>
<div><br></div><div>And when I attached GDB to my applications, the flush-8=
:16 will immediately free from D state, and my application too.</div><div><=
br></div><div>Without knowing the internal of flush(write back) and XFS, th=
is is my guess looking at the trace below:</div>
<div>Could it be that flush(xfs_fs_write_inode) =A0and my application (xfs_=
file_release at fclose) are holding the same lock? =A0Or could it be that s=
ome resources in the system (e.g. page cache?) is exhausted and waiting for=
 hang in waiting for reclaim.</div>
<div>=A0</div><div>Stack trace of a few thread of interests. =A0The entire =
dump if interested, I can send in a separate mail:</div><div><br></div><div=
>Jun 28 19:34:11 IMCNode000 kernel: [29127.580426] SysRq : Show Blocked Sta=
te</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.580434] =A0 task =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PC stack =A0 pid father</div><div>Jun 2=
8 19:34:11 IMCNode000 kernel: [29127.580629] flush-8:16 =A0 =A0 =A0D 000000=
0000000400 =A0 =A0 0 =A05502 =A0 =A0 =A02 0x00000000</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.580636] =A0ffff883e5bbb7b90 =
0000000000000046 ffff8819c91d25c0 ffff883e5bbb6010</div><div>Jun 28 19:34:1=
1 IMCNode000 kernel: [29127.580643] =A00000000000011180 0000000000011180 ff=
ff883e5bbb7fd8 ffff883e5bbb7fd8</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.580651] =A00000000000011180 =
ffff883e5b8aa0c0 ffff8819c91d25c0 ffff8819dc99a3c0</div><div>Jun 28 19:34:1=
1 IMCNode000 kernel: [29127.580658] Call Trace:</div><div>Jun 28 19:34:11 I=
MCNode000 kernel: [29127.580711] =A0[&lt;ffffffffa04a2cd5&gt;] xfs_ioend_wa=
it+0x85/0xb0 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.580800] =A0[&lt;ffffffffa04a=
cb28&gt;] xfs_fs_write_inode+0xb8/0x190 [xfs]</div><div>Jun 28 19:34:11 IMC=
Node000 kernel: [29127.580880] =A0[&lt;ffffffff81177793&gt;] writeback_sing=
le_inode+0x2f3/0x360</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.580889] =A0[&lt;ffffffff8117=
7ee4&gt;] writeback_sb_inodes+0xc4/0x1a0</div><div>Jun 28 19:34:11 IMCNode0=
00 kernel: [29127.580897] =A0[&lt;ffffffff81178743&gt;] writeback_inodes_wb=
+0xd3/0x160</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.580904] =A0[&lt;ffffffff8117=
8b8b&gt;] wb_writeback+0x3bb/0x400</div><div>Jun 28 19:34:11 IMCNode000 ker=
nel: [29127.580911] =A0[&lt;ffffffff81178e0b&gt;] wb_do_writeback+0x23b/0x2=
50</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.580918] =A0[&lt;ffffffff8117=
8f04&gt;] bdi_writeback_thread+0xe4/0x240</div><div>Jun 28 19:34:11 IMCNode=
000 kernel: [29127.580926] =A0[&lt;ffffffff8107c646&gt;] kthread+0x96/0xa0<=
/div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.580936] =A0[&lt;ffffffff8145=
0e44&gt;] kernel_thread_helper+0x4/0x10</div><div>Jun 28 19:34:11 IMCNode00=
0 kernel: [29127.580954] Tigris_IMC.exe =A0D 0000000100669478 =A0 =A0 0 =A0=
6347 =A0 6269 0x00000000</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.580960] =A0ffff8819dc9b5848 =
0000000000000086 0000000000000000 ffff8819dc9b4010</div><div>Jun 28 19:34:1=
1 IMCNode000 kernel: [29127.580968] =A00000000000011180 0000000000011180 ff=
ff8819dc9b5fd8 ffff8819dc9b5fd8</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.580975] =A00000000000011180 =
ffff8819dc9b2540 0000000085227080 ffff883e86942400</div><div>Jun 28 19:34:1=
1 IMCNode000 kernel: [29127.580982] Call Trace:</div><div>Jun 28 19:34:11 I=
MCNode000 kernel: [29127.580991] =A0[&lt;ffffffff81446555&gt;] schedule_tim=
eout+0x205/0x2a0</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.580998] =A0[&lt;ffffffff8144=
72f8&gt;] __down+0x68/0xb0</div><div>Jun 28 19:34:11 IMCNode000 kernel: [29=
127.581008] =A0[&lt;ffffffff81082097&gt;] down+0x47/0x50</div><div>Jun 28 1=
9:34:11 IMCNode000 kernel: [29127.581030] =A0[&lt;ffffffffa04a3ce9&gt;] xfs=
_buf_lock+0x59/0xc0 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.581104] =A0[&lt;ffffffffa04a=
522b&gt;] _xfs_buf_find+0x11b/0x210 [xfs]</div><div>Jun 28 19:34:11 IMCNode=
000 kernel: [29127.581176] =A0[&lt;ffffffffa04a5356&gt;] xfs_buf_get+0x36/0=
x1d0 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.581248] =A0[&lt;ffffffffa04a=
5514&gt;] xfs_buf_read+0x24/0x110 [xfs]</div><div>Jun 28 19:34:11 IMCNode00=
0 kernel: [29127.581322] =A0[&lt;ffffffffa049a8ce&gt;] xfs_trans_read_buf+0=
x28e/0x3e0 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.581393] =A0[&lt;ffffffffa046=
7f5e&gt;] xfs_btree_read_buf_block+0x5e/0xd0 [xfs]</div><div>Jun 28 19:34:1=
1 IMCNode000 kernel: [29127.581438] =A0[&lt;ffffffffa0468682&gt;] xfs_btree=
_lookup_get_block+0x82/0xf0 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.581480] =A0[&lt;ffffffffa046=
8d32&gt;] xfs_btree_lookup+0xd2/0x470 [xfs]</div><div>Jun 28 19:34:11 IMCNo=
de000 kernel: [29127.581522] =A0[&lt;ffffffffa045f967&gt;] xfs_bmap_del_ext=
ent+0x147/0xac0 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.581560] =A0[&lt;ffffffffa046=
3857&gt;] xfs_bunmapi+0x5d7/0xbc0 [xfs]</div><div>Jun 28 19:34:11 IMCNode00=
0 kernel: [29127.581601] =A0[&lt;ffffffffa0482cc8&gt;] xfs_itruncate_finish=
+0x168/0x330 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.581657] =A0[&lt;ffffffffa049=
e5ce&gt;] xfs_free_eofblocks+0x1ce/0x2b0 [xfs]</div><div>Jun 28 19:34:11 IM=
CNode000 kernel: [29127.581725] =A0[&lt;ffffffffa049f18c&gt;] xfs_release+0=
x13c/0x230 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.581793] =A0[&lt;ffffffffa04a=
6f00&gt;] xfs_file_release+0x10/0x20 [xfs]</div><div>Jun 28 19:34:11 IMCNod=
e000 kernel: [29127.581855] =A0[&lt;ffffffff81153e83&gt;] __fput+0xb3/0x200=
</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.581863] =A0[&lt;ffffffff8114=
fefc&gt;] filp_close+0x5c/0x90</div><div>Jun 28 19:34:11 IMCNode000 kernel:=
 [29127.581870] =A0[&lt;ffffffff8114ffd7&gt;] sys_close+0xa7/0x100</div><di=
v>
Jun 28 19:34:11 IMCNode000 kernel: [29127.581879] =A0[&lt;ffffffff8144fd12&=
gt;] system_call_fastpath+0x16/0x1b</div><div>Jun 28 19:34:11 IMCNode000 ke=
rnel: [29127.581897] =A0[&lt;00007f90392c2ea0&gt;] 0x7f90392c2e9f</div><div=
>
Jun 28 19:34:11 IMCNode000 kernel: [29127.581903] Tigris_IMC.exe =A0D ffff8=
87ef8994710 =A0 =A0 0 =A06352 =A0 6269 0x00000000</div><div>Jun 28 19:34:11=
 IMCNode000 kernel: [29127.581909] =A0ffff8819dcbe7848 0000000000000086 fff=
fffffa0480c7e ffff8819dcbe6010</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.581916] =A00000000000011180 =
0000000000011180 ffff8819dcbe7fd8 ffff8819dcbe7fd8</div><div>Jun 28 19:34:1=
1 IMCNode000 kernel: [29127.581923] =A00000000000011180 ffff8819dcbe4680 ff=
ff883e85249e80 ffff883e86a123c0</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.581930] Call Trace:</div><di=
v>Jun 28 19:34:11 IMCNode000 kernel: [29127.581940] =A0[&lt;ffffffff8144655=
5&gt;] schedule_timeout+0x205/0x2a0</div><div>Jun 28 19:34:11 IMCNode000 ke=
rnel: [29127.581952] =A0[&lt;ffffffff814472f8&gt;] __down+0x68/0xb0</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.581959] =A0[&lt;ffffffff8108=
2097&gt;] down+0x47/0x50</div><div>Jun 28 19:34:11 IMCNode000 kernel: [2912=
7.581979] =A0[&lt;ffffffffa04a3ce9&gt;] xfs_buf_lock+0x59/0xc0 [xfs]</div><=
div>
Jun 28 19:34:11 IMCNode000 kernel: [29127.582050] =A0[&lt;ffffffffa04a522b&=
gt;] _xfs_buf_find+0x11b/0x210 [xfs]</div><div>Jun 28 19:34:11 IMCNode000 k=
ernel: [29127.582121] =A0[&lt;ffffffffa04a5356&gt;] xfs_buf_get+0x36/0x1d0 =
[xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.582191] =A0[&lt;ffffffffa04a=
5514&gt;] xfs_buf_read+0x24/0x110 [xfs]</div><div>Jun 28 19:34:11 IMCNode00=
0 kernel: [29127.582264] =A0[&lt;ffffffffa049a8ce&gt;] xfs_trans_read_buf+0=
x28e/0x3e0 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.582330] =A0[&lt;ffffffffa046=
7f5e&gt;] xfs_btree_read_buf_block+0x5e/0xd0 [xfs]</div><div>Jun 28 19:34:1=
1 IMCNode000 kernel: [29127.582371] =A0[&lt;ffffffffa0468682&gt;] xfs_btree=
_lookup_get_block+0x82/0xf0 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.582413] =A0[&lt;ffffffffa046=
8d32&gt;] xfs_btree_lookup+0xd2/0x470 [xfs]</div><div>Jun 28 19:34:11 IMCNo=
de000 kernel: [29127.582454] =A0[&lt;ffffffffa045f967&gt;] xfs_bmap_del_ext=
ent+0x147/0xac0 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.582494] =A0[&lt;ffffffffa046=
3857&gt;] xfs_bunmapi+0x5d7/0xbc0 [xfs]</div><div>Jun 28 19:34:11 IMCNode00=
0 kernel: [29127.582541] =A0[&lt;ffffffffa0482cc8&gt;] xfs_itruncate_finish=
+0x168/0x330 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.582597] =A0[&lt;ffffffffa049=
e5ce&gt;] xfs_free_eofblocks+0x1ce/0x2b0 [xfs]</div><div>Jun 28 19:34:11 IM=
CNode000 kernel: [29127.582665] =A0[&lt;ffffffffa049f18c&gt;] xfs_release+0=
x13c/0x230 [xfs]</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.582733] =A0[&lt;ffffffffa04a=
6f00&gt;] xfs_file_release+0x10/0x20 [xfs]</div><div>Jun 28 19:34:11 IMCNod=
e000 kernel: [29127.582794] =A0[&lt;ffffffff81153e83&gt;] __fput+0xb3/0x200=
</div>
<div>Jun 28 19:34:11 IMCNode000 kernel: [29127.582801] =A0[&lt;ffffffff8114=
fefc&gt;] filp_close+0x5c/0x90</div><div>Jun 28 19:34:11 IMCNode000 kernel:=
 [29127.582807] =A0[&lt;ffffffff8114ffd7&gt;] sys_close+0xa7/0x100</div><di=
v>
Jun 28 19:34:11 IMCNode000 kernel: [29127.582814] =A0[&lt;ffffffff8144fd12&=
gt;] system_call_fastpath+0x16/0x1b</div><div>Jun 28 19:34:11 IMCNode000 ke=
rnel: [29127.582823] =A0[&lt;00007f90392c2ea0&gt;] 0x7f90392c2e9f</div><div=
>
<br></div><div><br></div><div>xfsprogs-3.1.6-0.7.1</div><div><br></div><div=
>xfs_info /raid</div><div>meta-data=3D/dev/sdb1 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
isize=3D256 =A0 =A0agcount=3D4, agsize=3D243896192 blks</div><div>=A0 =A0 =
=A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D512 =A0=
 attr=3D2</div>
<div>data =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4=
096 =A0 blocks=3D975584768, imaxpct=3D5</div><div>=A0 =A0 =A0 =A0 =A0=3D =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sunit=3D0 =A0 =A0 =A0swidth=3D0=
 blks</div><div>naming =A0 =3Dversion 2 =A0 =A0 =A0 =A0 =A0 =A0 =A0bsize=3D=
4096 =A0 ascii-ci=3D0</div>
<div>log =A0 =A0 =A0=3Dinternal =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =
=A0 blocks=3D476359, version=3D2</div><div>=A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D512 =A0 sunit=3D0 blks, lazy-c=
ount=3D1</div><div>realtime =3Dnone =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext=
sz=3D4096 =A0 blocks=3D0, rtextents=3D0</div>
<div><br></div><div><br></div><div>fdisk -l</div><div><br></div><div>WARNIN=
G: GPT (GUID Partition Table) detected on &#39;/dev/sdb&#39;! The util fdis=
k doesn&#39;t support GPT. Use GNU Parted.</div><div>Disk /dev/sdb: 3996.0 =
GB, 3995997306880 bytes</div>
<div>255 heads, 63 sectors/track, 485819 cylinders, total 7804682240 sector=
s Units =3D sectors of 1 * 512 =3D 512 bytes Sector size (logical/physical)=
: 512 bytes / 512 bytes I/O size (minimum/optimal): 512 bytes / 512 bytes D=
isk identifier: 0x80560481</div>
<div><br></div><div>=A0 =A0Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End=
 =A0 =A0 =A0Blocks =A0 Id =A0System</div><div>/dev/sdb4 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 1 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0 =A0 0+ =A0ee =A0GPT</div><=
div><br></div><div>=A0/proc/partitions</div><div>major minor =A0#blocks =A0=
name</div>
<div><br></div><div>=A0 =A08 =A0 =A0 =A0 16 3902341120 sdb</div><div>=A0 =
=A08 =A0 =A0 =A0 17 3902339072 sdb1</div><div>=A0 =A08 =A0 =A0 =A0 =A00 =A0=
124022784 sda</div><div>=A0 =A08 =A0 =A0 =A0 =A01 =A0 =A01051648 sda1</div>=
<div>=A0 =A08 =A0 =A0 =A0 =A02 =A0 =A01051648 sda2</div><div>=A0 =A08 =A0 =
=A0 =A0 =A03 =A0121918464 sda3</div>
<div><br></div><div>/proc/meminfo</div><div>MemTotal: =A0 =A0 =A0 526536468=
 kB</div><div>MemFree: =A0 =A0 =A0 =A0520264928 kB</div><div>Buffers: =A0 =
=A0 =A0 =A0 =A0 16644 kB</div><div>Cached: =A0 =A0 =A0 =A0 =A0 706520 kB</d=
iv><div>SwapCached: =A0 =A0 =A0 =A0 =A0 =A00 kB</div>
<div>Active: =A0 =A0 =A0 =A0 =A0 580108 kB</div><div>Inactive: =A0 =A0 =A0 =
=A0 240800 kB</div><div>Active(anon): =A0 =A0 =A098036 kB</div><div>Inactiv=
e(anon): =A0 =A0 =A0 68 kB</div><div>Active(file): =A0 =A0 482072 kB</div><=
div>Inactive(file): =A0 240732 kB</div>
<div>Unevictable: =A0 =A0 =A0 =A0 =A0 0 kB</div><div>Mlocked: =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0 kB</div><div>SwapTotal: =A0 =A0 =A0 1051644 kB</div><div>=
SwapFree: =A0 =A0 =A0 =A01051644 kB</div><div>Dirty: =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 0 kB</div><div>Writeback: =A0 =A0 =A0 =A0 =A0 =A0 0 kB</div>
<div>AnonPages: =A0 =A0 =A0 =A0 97868 kB</div><div>Mapped: =A0 =A0 =A0 =A0 =
=A0 =A013212 kB</div><div>Shmem: =A0 =A0 =A0 =A0 =A0 =A0 =A0 236 kB</div><d=
iv>Slab: =A0 =A0 =A0 =A0 =A0 =A0 125960 kB</div><div>SReclaimable: =A0 =A0 =
=A017020 kB</div><div>SUnreclaim: =A0 =A0 =A0 108940 kB</div>
<div>KernelStack: =A0 =A0 =A0 =A03264 kB</div><div>PageTables: =A0 =A0 =A0 =
=A0 3120 kB</div><div>NFS_Unstable: =A0 =A0 =A0 =A0 =A00 kB</div><div>Bounc=
e: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00 kB</div><div>WritebackTmp: =A0 =A0 =A0 =
=A0 =A00 kB</div><div>CommitLimit: =A0 =A0522322744 kB</div>
<div>Committed_AS: =A0 =A0 432276 kB</div><div>VmallocTotal: =A0 3435973836=
7 kB</div><div>VmallocUsed: =A0 =A0 1100980 kB</div><div>VmallocChunk: =A0 =
34090199776 kB</div><div>HardwareCorrupted: =A0 =A0 0 kB</div><div>AnonHuge=
Pages: =A0 =A0 16384 kB</div>
<div>HugePages_Total: =A0 =A0 =A0 0</div><div>HugePages_Free: =A0 =A0 =A0 =
=A00</div><div>HugePages_Rsvd: =A0 =A0 =A0 =A00</div><div>HugePages_Surp: =
=A0 =A0 =A0 =A00</div><div>Hugepagesize: =A0 =A0 =A0 2048 kB</div><div>Dire=
ctMap4k: =A0 =A0 =A0129732 kB</div><div>
DirectMap2M: =A0 =A0 6133760 kB</div><div>DirectMap1G: =A0 =A0530579456 kB<=
/div><div><br></div><div><br></div><div>Many thanks in advance,</div><div><=
br></div><div>Norman=A0</div></div><div><br></div></div>

--047d7b603a12bbfcaa04e0897825--


--===============0885114832256501100==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0885114832256501100==--
