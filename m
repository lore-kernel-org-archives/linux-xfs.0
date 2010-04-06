Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o360jfES034782 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 19:45:41 -0500
Received: from peace.netnation.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 947B72991D1
	for <xfs@oss.sgi.com>; Mon,  5 Apr 2010 17:47:31 -0700 (PDT)
Received: from peace.netnation.com (newpeace.netnation.com [204.174.223.7]) by
	cuda.sgi.com with ESMTP id 3BYTdTzgyCaSUf9s for
	<xfs@oss.sgi.com>; Mon, 05 Apr 2010 17:47:31 -0700 (PDT)
Received: from sim by peace.netnation.com with local (Exim 4.63)
	(envelope-from <sim@netnation.com>) id 1Nywx0-0000wt-MM
	for xfs@oss.sgi.com; Mon, 05 Apr 2010 17:47:30 -0700
Date: Mon, 5 Apr 2010 17:47:30 -0700
From: Simon Kirby <sim@hostway.ca>
Subject: Assertion fail in xfs_reclaim_inode [2.6.33.2]
Message-ID: <20100406004730.GB11263@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We're seeing crashing from XFS likely resulting from some storage
corruption.  This seems to be getting tickled from backups every two
days as it happens at the same time of day each time on whichever box
is active for these storage volumes.  We've seen it about 4 times now.

This was captured over a serial console over IPMI serial-over-LAN, and
it seemed the serial console loglevel was not low enough to see the
priority-less printk() in assfail() in fs/xfs/support/debug.c, so all we
got this time was this backtrace:

------------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:109!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/block/etherd!e8.2/removable
CPU 6
Pid: 5935, comm: xfssyncd Not tainted 2.6.33.2-hw #1 0H723K/PowerEdge 1950
RIP: 0010:[<ffffffff812c2daa>]  [<ffffffff812c2daa>] assfail+0x1a/0x20
RSP: 0018:ffff880436ea5d50  EFLAGS: 00010282
RAX: 000000000000006b RBX: ffff880296549a40 RCX: 0000000000000086
RDX: ffff880028380000 RSI: 0000000000000046 RDI: 0000000000000246
RBP: ffff880436ea5d50 R08: ffffffff817aa810 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000004 R12: ffff880296549b38
R13: ffff88043676b200 R14: 0000000000000002 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f144cc9e000 CR3: 000000043bdb2000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process xfssyncd (pid: 5935, threadinfo ffff880436ea4000, task ffff88043f3c6270)
Stack:
 ffff880436ea5d80 ffffffff812c19a6 ffff88043676b200 ffff88043676b248
<0> 0000000000000000 0000000000000001 ffff880436ea5df0 ffffffff812c2671
<0> ffff880436ea5e10 000000028129f8c4 ffffffff812c1950 ffff880439e0dc00
Call Trace:
 [<ffffffff812c19a6>] xfs_reclaim_inode+0x56/0x120
 [<ffffffff812c2671>] xfs_inode_ag_walk+0x81/0x120
 [<ffffffff812c1950>] ? xfs_reclaim_inode+0x0/0x120
 [<ffffffff812c2785>] xfs_inode_ag_iterator+0x75/0xb0
 [<ffffffff812c1950>] ? xfs_reclaim_inode+0x0/0x120
 [<ffffffff812c27da>] xfs_reclaim_inodes+0x1a/0x20
 [<ffffffff812c280e>] xfs_sync_worker+0x2e/0x70
 [<ffffffff812c1d83>] xfssyncd+0x163/0x200
 [<ffffffff812c1c20>] ? xfssyncd+0x0/0x200
 [<ffffffff8106aa66>] kthread+0x96/0xb0
 [<ffffffff8100ace4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106a9d0>] ? kthread+0x0/0xb0
 [<ffffffff8100ace0>] ? kernel_thread_helper+0x0/0x10
Code: 81 c7 44 24 08 01 00 00 00 e8 d3 11 0a 00 c9 c3 90 55 89 d1 31 c0 48 89 f2 48 89 fe 48 c7 c7 e8 a7 7a 81 48 89 e5 e8 b3 32 39 00 <0f> 0b eb fe 66 90 55 48 89 e5 41 57 41 56 49 89 c
e 41 55 49 89
RIP  [<ffffffff812c2daa>] assfail+0x1a/0x20
 RSP <ffff880436ea5d50>
---[ end trace 270a46c35e0ea9b1 ]---

Seems to be from the only assert in xfs_reclaim_inode:

        ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));

Would any of the patches in the stable queue-2.6.32 be missing from
2.6.33 but perhaps fix this issue?

Simon-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
