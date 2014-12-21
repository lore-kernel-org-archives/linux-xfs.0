Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B11EE7F4E
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 05:42:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 71D3D8F8037
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 03:42:22 -0800 (PST)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
	[209.85.212.171]) by cuda.sgi.com with ESMTP id
	h26REQs7aHhFtgnU (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Dec 2014 03:42:20 -0800 (PST)
Received: by mail-wi0-f171.google.com with SMTP id bs8so5739888wib.16
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2014 03:42:18 -0800 (PST)
Received: from alyakaslap (bzq-169-168-31-234.red.bezeqint.net.
	[31.168.169.234])
	by mx.google.com with ESMTPSA id eu8sm9188544wib.21.2014.12.21.03.42.17
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
	Sun, 21 Dec 2014 03:42:17 -0800 (PST)
Message-ID: <B97466D39E354AFB808620584A4ABE5C@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
Subject: XFS corruption
Date: Sun, 21 Dec 2014 13:42:16 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2939495995121571597=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============2939495995121571597==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0024_01D01D23.EEF29300"

This is a multi-part message in MIME format.

------=_NextPart_000_0024_01D01D23.EEF29300
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Greetings,
we encountered XFS corruption:

kernel: [774772.852316] ffff8801018c5000: 05 d1 fd 01 fd ff 2f ec 2f 8d =
82 6a 81 fe c2 0f  .....././..j....    =20
kernel: [774772.854820] XFS (dm-72): Internal error xfs_bmbt_verify at =
line 747 of file =
/mnt/share/builds/14.09--3.8.13-030813-generic/2014-11-30_15-47-58--14.09=
-1419-28/src/zadara-btrfs/fs/xfs/xfs_bmap_btree.c.  Caller =
0xffffffffa077b6be
kernel: [774772.854820]                                                  =
                                      =20
kernel: [774772.860766] Pid: 14643, comm: kworker/0:0H Tainted: GF       =
W  O 3.8.13-030813-generic #20130511184
kernel: [774772.860771] Call Trace:                                      =
                                      =20
kernel: [774772.860909]  [<ffffffffa074abaf>] xfs_error_report+0x3f/0x50 =
[xfs]                                 =20
kernel: [774772.860961]  [<ffffffffa077b6be>] ? =
xfs_bmbt_read_verify+0xe/0x10 [xfs]                            =20
kernel: [774772.860985]  [<ffffffffa074ac1e>] =
xfs_corruption_error+0x5e/0x90 [xfs]                             =20
kernel: [774772.861014]  [<ffffffffa077b537>] xfs_bmbt_verify+0x77/0x1e0 =
[xfs]                                 =20
kernel: [774772.861047]  [<ffffffffa077b6be>] ? =
xfs_bmbt_read_verify+0xe/0x10 [xfs]                            =20
kernel: [774772.861077]  [<ffffffff810135aa>] ? __switch_to+0x12a/0x4a0  =
                                      =20
kernel: [774772.861129]  [<ffffffff81096cd8>] ? =
set_next_entity+0xa8/0xc0                                      =20
kernel: [774772.861145]  [<ffffffffa077b6be>] =
xfs_bmbt_read_verify+0xe/0x10 [xfs]                              =20
kernel: [774772.861157]  [<ffffffffa074848f>] =
xfs_buf_iodone_work+0x3f/0xa0 [xfs]                              =20
kernel: [774772.861161]  [<ffffffff81078b81>] =
process_one_work+0x141/0x490                                     =20
kernel: [774772.861164]  [<ffffffff81079b48>] worker_thread+0x168/0x400  =
                                      =20
kernel: [774772.861166]  [<ffffffff810799e0>] ? =
manage_workers+0x120/0x120                                     =20
kernel: [774772.861170]  [<ffffffff8107f050>] kthread+0xc0/0xd0          =
                                      =20
kernel: [774772.861172]  [<ffffffff8107ef90>] ? =
flush_kthread_worker+0xb0/0xb0                                 =20
kernel: [774772.861193]  [<ffffffff816f61ec>] ret_from_fork+0x7c/0xb0    =
                                      =20
kernel: [774772.861199]  [<ffffffff8107ef90>] ? =
flush_kthread_worker+0xb0/0xb0                                 =20
kernel: [774772.861318] XFS (dm-72): Corruption detected. Unmount and =
run xfs_repair                           =20
kernel: [774772.863449] XFS (dm-72): metadata I/O error: block =
0x2434e3e8 ("xfs_trans_read_buf_map") error 117 numblks 8

All the corruption reports were for the same block 0x2434e3e8, which =
according to the code is simply disk address (xfs_daddr_t) 607445992. So =
there was only one block corrupted.

Some time later, XFS crashed with:
[813114.622928] NULL pointer dereference[813114.622928]  at =
0000000000000008
[813114.622928] IP: [<ffffffffa077bad9>] xfs_bmbt_get_all+0x9/0x20 [xfs]
[813114.622928] PGD 0=20
[813114.622928] Oops: 0000 [#1] SMP=20
[813114.622928] CPU 2=20
[813114.622928] Pid: 31120, comm: smbd Tainted: GF       W  O =
3.8.13-030813-generic #201305111843 Bochs Bochs
[813114.622928] RIP: 0010:[<ffffffffa077bad9>]  [<ffffffffa077bad9>] =
xfs_bmbt_get_all+0x9/0x20 [xfs]
[813114.622928] RSP: 0018:ffff88010a193798  EFLAGS: 00010297
[813114.622928] RAX: 0000000000000964 RBX: ffff880180fa9c38 RCX: =
ffffa5a5a5a5a5a5
[813114.622928] RDX: ffff88010a193898 RSI: ffff88010a193898 RDI: =
0000000000000000
[813114.622928] RBP: ffff88010a1937f8 R08: ffff88010a193898 R09: =
ffff88010a1938b8
[813114.622928] R10: ffffea0005de0940 R11: 0000000000004d0e R12: =
ffff88010a1938dc
[813114.622928] R13: ffff88010a1938e0 R14: ffff88010a193898 R15: =
ffff88010a1938b8
[813114.622928] FS:  00007eff2dc7e700(0000) GS:ffff88021fd00000(0000) =
knlGS:0000000000000000
[813114.622928] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[813114.622928] CR2: 0000000000000008 CR3: 0000000109574000 CR4: =
00000000001406e0
[813114.622928] DR0: 0000000000000000 DR1: 0000000000000000 DR2: =
0000000000000000
[813114.622928] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: =
0000000000000400
[813114.622928] Process smbd (pid: 31120, threadinfo ffff88010a192000, =
task ffff88011687ae80)
[813114.622928] Stack:
[813114.622928]  ffff88010a1937f8 ffffffffa076f85a ffffffffffffffff =
0000000000000000
[813114.622928]  ffffffff816ec509 000000000a193830 ffffffff816ed31d =
ffff88010a193898
[813114.622928]  ffff880180fa9c00 0000000000000000 ffff88010a1938dc =
ffff88010a1938e0
[813114.622928] Call Trace:
[813114.622928]  [<ffffffffa076f85a>] ? =
xfs_bmap_search_multi_extents+0xaa/0x110 [xfs]
[813114.622928]  [<ffffffff816ec509>] ? schedule+0x29/0x70
[813114.622928]  [<ffffffff816ed31d>] ? =
rwsem_down_failed_common+0xcd/0x170
[813114.622928]  [<ffffffffa076f92e>] xfs_bmap_search_extents+0x6e/0xf0 =
[xfs]
[813114.622928]  [<ffffffffa0778d6c>] xfs_bmapi_read+0xfc/0x2f0 [xfs]
[813114.622928]  [<ffffffffa0792a49>] ? xfs_ilock_map_shared+0x49/0x60 =
[xfs]
[813114.622928]  [<ffffffffa07459a8>] __xfs_get_blocks+0xe8/0x550 [xfs]
[813114.622928]  [<ffffffff8135d8c4>] ? =
call_rwsem_down_read_failed+0x14/0x30
[813114.622928]  [<ffffffffa0745e41>] xfs_get_blocks+0x11/0x20 [xfs]
[813114.622928]  [<ffffffff811d05b7>] block_read_full_page+0x127/0x360
[813114.622928]  [<ffffffffa0745e30>] ? xfs_get_blocks_direct+0x20/0x20 =
[xfs]
[813114.622928]  [<ffffffff811d9b0f>] do_mpage_readpage+0x35f/0x550
[813114.622928]  [<ffffffff816f1025>] ? do_async_page_fault+0x35/0x90
[813114.622928]  [<ffffffff816edd48>] ? async_page_fault+0x28/0x30
[813114.622928]  [<ffffffff811d9d4f>] mpage_readpage+0x4f/0x70
[813114.622928]  [<ffffffffa0745e30>] ? xfs_get_blocks_direct+0x20/0x20 =
[xfs]
[813114.622928]  [<ffffffff81134da8>] ? file_read_actor+0x68/0x160
[813114.622928]  [<ffffffff81134e04>] ? file_read_actor+0xc4/0x160
[813114.622928]  [<ffffffff81354bfe>] ? radix_tree_lookup_slot+0xe/0x10
[813114.622928]  [<ffffffffa07451b8>] xfs_vm_readpage+0x18/0x20 [xfs]
[813114.622928]  [<ffffffff811364ad>] =
do_generic_file_read.constprop.31+0x10d/0x440
[813114.622928]  [<ffffffff811374d1>] generic_file_aio_read+0xe1/0x220
[813114.622928]  [<ffffffffa074fb98>] xfs_file_aio_read+0x1c8/0x330 =
[xfs]
[813114.622928]  [<ffffffff8119ad93>] do_sync_read+0xa3/0xe0
[813114.622928]  [<ffffffff8119b4d0>] vfs_read+0xb0/0x180
[813114.622928]  [<ffffffff8119b77a>] sys_pread64+0x9a/0xa0
[813114.622928]  [<ffffffff816f629d>] system_call_fastpath+0x1a/0x1f
[813114.622928] Code: d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 =
c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 =
89 f2 <48> 8b 77 08 48 8b 3f 48 89 e5 e8 48 f8 ff ff 5d c3 66 0f 1f 44=20
[813114.622928] RIP  [<ffffffffa077bad9>] xfs_bmbt_get_all+0x9/0x20 =
[xfs]
[813114.622928]  RSP <ffff88010a193798>
[813114.622928] CR2: 0000000000000008
[813114.721138] ---[ end trace cce2a358d4050d3d ]---

We are running XFS based on kernel 3.8.13, with our changes for =
large-block discard in =
https://github.com/zadarastorage/zadara-xfs-pushback.

We analyzed several suspects, but all of them fall on disk addresses not =
near the corrupted disk address. I realize that running somewhat =
outdated kernel + our changes within XFSs, points back at us, but this =
is first time we see XFS corruption after about a year of this code =
being exercised. So posting here, just in case this is a known issue.

I must point out that xfs_repair was able to fix this, which was =
awesome!

Thanks,
Alex.


------=_NextPart_000_0024_01D01D23.EEF29300
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML><HEAD></HEAD>
<BODY dir=3Dltr>
<DIV dir=3Dltr>
<DIV style=3D"FONT-FAMILY: 'Verdana'; COLOR: #000000; FONT-SIZE: 10pt">
<DIV>Greetings,</DIV>
<DIV>we encountered XFS corruption:</DIV>
<DIV>&nbsp;</DIV>
<DIV>kernel: [774772.852316] ffff8801018c5000: 05 d1 fd 01 fd ff 2f ec =
2f 8d 82=20
6a 81 fe c2 0f&nbsp; .....././..j....&nbsp;&nbsp;&nbsp;&nbsp; </DIV>
<DIV>kernel: [774772.854820] XFS (dm-72): Internal error xfs_bmbt_verify =
at line=20
747 of file=20
/mnt/share/builds/14.09--3.8.13-030813-generic/2014-11-30_15-47-58--14.09=
-1419-28/src/zadara-btrfs/fs/xfs/xfs_bmap_btree.c.&nbsp;=20
Caller 0xffffffffa077b6be</DIV>
<DIV>kernel:=20
[774772.854820]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.860766] Pid: 14643, comm: kworker/0:0H Tainted:=20
GF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; W&nbsp; O 3.8.13-030813-generic=20
#20130511184</DIV>
<DIV>kernel: [774772.860771] Call=20
Trace:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.860909]&nbsp; [&lt;ffffffffa074abaf&gt;]=20
xfs_error_report+0x3f/0x50=20
[xfs]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.860961]&nbsp; [&lt;ffffffffa077b6be&gt;] ?=20
xfs_bmbt_read_verify+0xe/0x10=20
[xfs]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.860985]&nbsp; [&lt;ffffffffa074ac1e&gt;]=20
xfs_corruption_error+0x5e/0x90=20
[xfs]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861014]&nbsp; [&lt;ffffffffa077b537&gt;]=20
xfs_bmbt_verify+0x77/0x1e0=20
[xfs]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861047]&nbsp; [&lt;ffffffffa077b6be&gt;] ?=20
xfs_bmbt_read_verify+0xe/0x10=20
[xfs]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861077]&nbsp; [&lt;ffffffff810135aa&gt;] ?=20
__switch_to+0x12a/0x4a0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861129]&nbsp; [&lt;ffffffff81096cd8&gt;] ?=20
set_next_entity+0xa8/0xc0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861145]&nbsp; [&lt;ffffffffa077b6be&gt;]=20
xfs_bmbt_read_verify+0xe/0x10=20
[xfs]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861157]&nbsp; [&lt;ffffffffa074848f&gt;]=20
xfs_buf_iodone_work+0x3f/0xa0=20
[xfs]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861161]&nbsp; [&lt;ffffffff81078b81&gt;]=20
process_one_work+0x141/0x490&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861164]&nbsp; [&lt;ffffffff81079b48&gt;]=20
worker_thread+0x168/0x400&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861166]&nbsp; [&lt;ffffffff810799e0&gt;] ?=20
manage_workers+0x120/0x120&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861170]&nbsp; [&lt;ffffffff8107f050&gt;]=20
kthread+0xc0/0xd0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861172]&nbsp; [&lt;ffffffff8107ef90&gt;] ?=20
flush_kthread_worker+0xb0/0xb0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861193]&nbsp; [&lt;ffffffff816f61ec&gt;]=20
ret_from_fork+0x7c/0xb0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861199]&nbsp; [&lt;ffffffff8107ef90&gt;] ?=20
flush_kthread_worker+0xb0/0xb0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.861318] XFS (dm-72): Corruption detected. Unmount =
and run=20
xfs_repair&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;=20
</DIV>
<DIV>kernel: [774772.863449] XFS (dm-72): metadata I/O error: block =
0x2434e3e8=20
("xfs_trans_read_buf_map") error 117 numblks 8</DIV>
<DIV>&nbsp;</DIV>
<DIV>All the corruption reports were for the same block 0x2434e3e8, =
which=20
according to the code is simply disk address (xfs_daddr_t) 607445992. So =
there=20
was only one block corrupted.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Some time later, XFS crashed with:</DIV>
<DIV>[813114.622928] NULL pointer dereference[813114.622928]&nbsp; at=20
0000000000000008</DIV>
<DIV>[813114.622928] IP: [&lt;ffffffffa077bad9&gt;] =
xfs_bmbt_get_all+0x9/0x20=20
[xfs]</DIV>
<DIV>[813114.622928] PGD 0 </DIV>
<DIV>[813114.622928] Oops: 0000 [#1] SMP </DIV>
<DIV>[813114.622928] CPU 2 </DIV>
<DIV>[813114.622928] Pid: 31120, comm: smbd Tainted:=20
GF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; W&nbsp; O 3.8.13-030813-generic=20
#201305111843 Bochs Bochs</DIV>
<DIV>[813114.622928] RIP: 0010:[&lt;ffffffffa077bad9&gt;]&nbsp;=20
[&lt;ffffffffa077bad9&gt;] xfs_bmbt_get_all+0x9/0x20 [xfs]</DIV>
<DIV>[813114.622928] RSP: 0018:ffff88010a193798&nbsp; EFLAGS: =
00010297</DIV>
<DIV>[813114.622928] RAX: 0000000000000964 RBX: ffff880180fa9c38 RCX:=20
ffffa5a5a5a5a5a5</DIV>
<DIV>[813114.622928] RDX: ffff88010a193898 RSI: ffff88010a193898 RDI:=20
0000000000000000</DIV>
<DIV>[813114.622928] RBP: ffff88010a1937f8 R08: ffff88010a193898 R09:=20
ffff88010a1938b8</DIV>
<DIV>[813114.622928] R10: ffffea0005de0940 R11: 0000000000004d0e R12:=20
ffff88010a1938dc</DIV>
<DIV>[813114.622928] R13: ffff88010a1938e0 R14: ffff88010a193898 R15:=20
ffff88010a1938b8</DIV>
<DIV>[813114.622928] FS:&nbsp; 00007eff2dc7e700(0000) =
GS:ffff88021fd00000(0000)=20
knlGS:0000000000000000</DIV>
<DIV>[813114.622928] CS:&nbsp; 0010 DS: 0000 ES: 0000 CR0:=20
0000000080050033</DIV>
<DIV>[813114.622928] CR2: 0000000000000008 CR3: 0000000109574000 CR4:=20
00000000001406e0</DIV>
<DIV>[813114.622928] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000</DIV>
<DIV>[813114.622928] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400</DIV>
<DIV>[813114.622928] Process smbd (pid: 31120, threadinfo =
ffff88010a192000, task=20
ffff88011687ae80)</DIV>
<DIV>[813114.622928] Stack:</DIV>
<DIV>[813114.622928]&nbsp; ffff88010a1937f8 ffffffffa076f85a =
ffffffffffffffff=20
0000000000000000</DIV>
<DIV>[813114.622928]&nbsp; ffffffff816ec509 000000000a193830 =
ffffffff816ed31d=20
ffff88010a193898</DIV>
<DIV>[813114.622928]&nbsp; ffff880180fa9c00 0000000000000000 =
ffff88010a1938dc=20
ffff88010a1938e0</DIV>
<DIV>[813114.622928] Call Trace:</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffffa076f85a&gt;] ?=20
xfs_bmap_search_multi_extents+0xaa/0x110 [xfs]</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff816ec509&gt;] ? =
schedule+0x29/0x70</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff816ed31d&gt;] ?=20
rwsem_down_failed_common+0xcd/0x170</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffffa076f92e&gt;]=20
xfs_bmap_search_extents+0x6e/0xf0 [xfs]</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffffa0778d6c&gt;] =
xfs_bmapi_read+0xfc/0x2f0=20
[xfs]</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffffa0792a49&gt;] ?=20
xfs_ilock_map_shared+0x49/0x60 [xfs]</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffffa07459a8&gt;]=20
__xfs_get_blocks+0xe8/0x550 [xfs]</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff8135d8c4&gt;] ?=20
call_rwsem_down_read_failed+0x14/0x30</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffffa0745e41&gt;] =
xfs_get_blocks+0x11/0x20=20
[xfs]</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff811d05b7&gt;]=20
block_read_full_page+0x127/0x360</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffffa0745e30&gt;] ?=20
xfs_get_blocks_direct+0x20/0x20 [xfs]</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff811d9b0f&gt;]=20
do_mpage_readpage+0x35f/0x550</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff816f1025&gt;] ?=20
do_async_page_fault+0x35/0x90</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff816edd48&gt;] ?=20
async_page_fault+0x28/0x30</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff811d9d4f&gt;]=20
mpage_readpage+0x4f/0x70</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffffa0745e30&gt;] ?=20
xfs_get_blocks_direct+0x20/0x20 [xfs]</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff81134da8&gt;] ?=20
file_read_actor+0x68/0x160</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff81134e04&gt;] ?=20
file_read_actor+0xc4/0x160</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff81354bfe&gt;] ?=20
radix_tree_lookup_slot+0xe/0x10</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffffa07451b8&gt;] =
xfs_vm_readpage+0x18/0x20=20
[xfs]</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff811364ad&gt;]=20
do_generic_file_read.constprop.31+0x10d/0x440</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff811374d1&gt;]=20
generic_file_aio_read+0xe1/0x220</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffffa074fb98&gt;]=20
xfs_file_aio_read+0x1c8/0x330 [xfs]</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff8119ad93&gt;]=20
do_sync_read+0xa3/0xe0</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff8119b4d0&gt;] =
vfs_read+0xb0/0x180</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff8119b77a&gt;]=20
sys_pread64+0x9a/0xa0</DIV>
<DIV>[813114.622928]&nbsp; [&lt;ffffffff816f629d&gt;]=20
system_call_fastpath+0x1a/0x1f</DIV>
<DIV>[813114.622928] Code: d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b =
7d f8 c9=20
c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 =
f2=20
&lt;48&gt; 8b 77 08 48 8b 3f 48 89 e5 e8 48 f8 ff ff 5d c3 66 0f 1f 44 =
</DIV>
<DIV>[813114.622928] RIP&nbsp; [&lt;ffffffffa077bad9&gt;]=20
xfs_bmbt_get_all+0x9/0x20 [xfs]</DIV>
<DIV>[813114.622928]&nbsp; RSP &lt;ffff88010a193798&gt;</DIV>
<DIV>[813114.622928] CR2: 0000000000000008</DIV>
<DIV>[813114.721138] ---[ end trace cce2a358d4050d3d ]---</DIV>
<DIV>&nbsp;</DIV>
<DIV>We are running XFS based on kernel 3.8.13, with our changes for =
large-block=20
discard in <A=20
href=3D"https://github.com/zadarastorage/zadara-xfs-pushback">https://git=
hub.com/zadarastorage/zadara-xfs-pushback</A>.</DIV>
<DIV>&nbsp;</DIV>
<DIV>We analyzed several suspects, but all of them fall on disk =
addresses not=20
near the corrupted disk address. I realize that running somewhat =
outdated kernel=20
+ our changes within XFSs, points back at us, but this is first time we =
see XFS=20
corruption after about a year of this code being exercised. So posting =
here,=20
just in case this is a known issue.</DIV>
<DIV>&nbsp;</DIV>
<DIV>I must point out that xfs_repair was able to fix this, which was=20
awesome!</DIV>
<DIV>&nbsp;</DIV>
<DIV>Thanks,</DIV>
<DIV>Alex.</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV></DIV></DIV></BODY></HTML>

------=_NextPart_000_0024_01D01D23.EEF29300--


--===============2939495995121571597==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2939495995121571597==--
