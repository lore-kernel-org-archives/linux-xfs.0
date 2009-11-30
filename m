Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAUDLZMU009205 for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 07:21:35 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0021314EAEF0
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2009 05:22:04 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id FdKHMZUYHYhJmDsu for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2009 05:22:04 -0800 (PST)
Date: Mon, 30 Nov 2009 08:22:03 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.31.6: XFS DEBUG: Assertions cause kernel OOPS.
Message-ID: <alpine.DEB.2.00.0911300819010.20343@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I wanted to compile my kernel with DEBUG for XFS and also kernel frame pointers
to catch any issues.

However, DEBUG for XFS does more harm than good?

I tried to install bonnie++:
# apt-get install -y bonnie++

And then this happened:

[ 1578.768558] Assertion failed: *nmap >= 1, file: fs/xfs/xfs_bmap.c, line: 4846
[ 1578.768633] ------------[ cut here ]------------
[ 1578.768690] kernel BUG at fs/xfs/support/debug.c:109!
[ 1578.768742] invalid opcode: 0000 [#1] SMP 
[ 1578.768839] last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host15/target15:0:0/15:0:0:0/queue_depth
[ 1578.768939] CPU 1 
[ 1578.769016] Pid: 3273, comm: dpkg Not tainted 2.6.31.6 #6 
[ 1578.769083] RIP: 0010:[<ffffffff81243ada>]  [<ffffffff81243ada>] assfail+0x1a/0x20
[ 1578.769203] RSP: 0018:ffff880121d4bc08  EFLAGS: 00010296
[ 1578.769252] RAX: 0000000000000054 RBX: 0000000000000000 RCX: ffffffff81364fb0
[ 1578.769252] RDX: ffff880028038000 RSI: 0000000000000046 RDI: ffffffff816b4730
[ 1578.769252] RBP: ffff880121d4bc08 R08: 0000000000000000 R09: 0000000000000006
[ 1578.769252] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000800000000
[ 1578.769252] R13: ffff88012a295580 R14: 0000000000000002 R15: ffff88012a522000
[ 1578.769252] FS:  00007f2a7367d790(0000) GS:ffff880028038000(0000) knlGS:0000000000000000
[ 1578.769252] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1578.769252] CR2: 000000000204e000 CR3: 0000000121d53000 CR4: 00000000000026e0
[ 1578.769252] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1578.769252] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1578.769252] Process dpkg (pid: 3273, threadinfo ffff880121d4a000, task ffff88012b98b990)
[ 1578.769252] Stack:
[ 1578.769252]  ffff880121d4bdb8 ffffffff811eb916 0000000121d4bc38 000000000204e000
[ 1578.769252] <0> ffff8801244a85d0 0000000000000286 ffff880121d4bc68 ffffffff81260c51
[ 1578.769252] <0> ffff880121d4bc68 0000000000000000 000000080204e000 00000000007ffff8
[ 1578.769252] Call Trace:
[ 1578.769252]  [<ffffffff811eb916>] xfs_bmapi+0x66/0x1940
[ 1578.769252]  [<ffffffff81260c51>] ? __up_read+0x91/0xb0
[ 1578.769252]  [<ffffffff8123a0a7>] ? xfs_buf_free+0xc7/0x110
[ 1578.769252]  [<ffffffff8123a1e6>] ? xfs_buf_rele+0xf6/0x130
[ 1578.769252]  [<ffffffff8122e70a>] ? xfs_trans_brelse+0x19a/0x2a0
[ 1578.769252]  [<ffffffff811f7ac7>] ? xfs_da_brelse+0x77/0x120
[ 1578.769252]  [<ffffffff810bf63d>] ? filldir+0x9d/0xe0
[ 1578.769252]  [<ffffffff8120225a>] xfs_dir2_leaf_getdents+0x61a/0x780
[ 1578.769252]  [<ffffffff810bf5a0>] ? filldir+0x0/0xe0
[ 1578.769252]  [<ffffffff810bf5a0>] ? filldir+0x0/0xe0
[ 1578.769252]  [<ffffffff811fc6ec>] xfs_readdir+0x10c/0x110
[ 1578.769252]  [<ffffffff810bf5a0>] ? filldir+0x0/0xe0
[ 1578.769252]  [<ffffffff8123b4f4>] xfs_file_readdir+0x34/0x50
[ 1578.769252]  [<ffffffff810bf7f8>] vfs_readdir+0xa8/0xc0
[ 1578.769252]  [<ffffffff810bf963>] sys_getdents+0x83/0xe0
[ 1578.769252]  [<ffffffff8102d1ab>] system_call_fastpath+0x16/0x1b
[ 1578.769252] Code: 57 81 48 c7 c7 8e 94 57 81 e8 b3 19 02 00 c9 c3 90 55 89 d1 48 89 e5 48 89 f2 31 c0 48 89 fe 48 c7 c7 f0 d0 59 81 e8 15 6a 25 00 <0f> 0b eb fe 66 90 55 48 89 e5 41 57 41 56 49 89 ce 41 55 49 89 
[ 1578.773074] RIP  [<ffffffff81243ada>] assfail+0x1a/0x20
[ 1578.773074]  RSP <ffff880121d4bc08>
[ 1578.773343] ---[ end trace 00b4a182e72dfb60 ]---

Will recompile without XFS DEBUG but FYI.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
