Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5S9R7Xq019717 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 04:27:08 -0500
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 66CFE14B1537
	for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 02:34:33 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id 5oFAmNF8nJoUzL5R for <xfs@oss.sgi.com>;
	Mon, 28 Jun 2010 02:34:33 -0700 (PDT)
Date: Mon, 28 Jun 2010 11:29:48 +0200
From: "Steffen Knauf" <Steffen.Knauf@gmx.net>
Message-ID: <20100628092948.323370@gmx.net>
MIME-Version: 1.0
Subject: Kernel Panic: Assertion failed: __xfs_iflags_test(ip,
	XFS_IRECLAIMABLE), file: fs/xfs/linux-2.6/xfs_sync.c, line: 727
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
To: xfs-oss <xfs@oss.sgi.com>

hi,

Hello,

i have lot's of trouble with a webserver which die with a kernel panic every week. Perhaps someone have an idea? 

Linux Kernel version: 2.6.33

Kernel log:
---------------------------------------------------
Jun 27 04:53:19 web18 kernel: [415526.149123] Assertion failed: __xfs_iflags_test(ip, XFS_IRECLAIMABLE), file: fs/xfs/linux-2.6/xfs_sync.c, line: 727
Jun 27 04:53:19 web18 kernel: [415526.151594] ------------[ cut here ]------------
Jun 27 04:53:19 web18 kernel: [415526.152503] kernel BUG at fs/xfs/support/debug.c:109!
Jun 27 04:53:19 web18 kernel: [415526.152503] invalid opcode: 0000 [#1] SMP
Jun 27 04:53:19 web18 kernel: [415526.152503] last sysfs file: /sys/class/net/lo/operstate
Jun 27 04:53:19 web18 kernel: [415526.152503] CPU 2
Jun 27 04:53:19 web18 kernel: [415526.152503] Pid: 1479, comm: xfssyncd Tainted: G        W  2.6.33-cxo-15032010-v003 #1 0NJ023/PowerEdge 2850
Jun 27 04:53:19 web18 kernel: [415526.152503] RIP: 0010:[<ffffffffa018e3fc>]  [<ffffffffa018e3fc>] assfail+0x1a/0x1e [xfs]
Jun 27 04:53:19 web18 kernel: [415526.152503] RSP: 0018:ffff88033c27dda0  EFLAGS: 00010282
Jun 27 04:53:19 web18 kernel: [415526.152503] RAX: 000000000000007b RBX: ffff8801c87d5000 RCX: 0000000000000082
Jun 27 04:53:19 web18 kernel: [415526.152503] RDX: ffff880028280000 RSI: 0000000000000082 RDI: 0000000000000246
Jun 27 04:53:19 web18 kernel: [415526.152503] RBP: ffff88033bd74400 R08: 000000000000c887 R09: 0000000000000004
Jun 27 04:53:19 web18 kernel: [415526.152503] R10: ffffffff81324d10 R11: ffff88033cf1fc80 R12: 0000000000000002
Jun 27 04:53:19 web18 kernel: [415526.152503] R13: 0000000000000000 R14: 0000000000000001 R15: ffff88033c254c00
Jun 27 04:53:19 web18 kernel: [415526.152503] FS:  0000000000000000(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
Jun 27 04:53:19 web18 kernel: [415526.152503] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 27 04:53:19 web18 kernel: [415526.152503] CR2: 00007f140bb085f0 CR3: 0000000049f70000 CR4: 00000000000006e0
Jun 27 04:53:19 web18 kernel: [415526.152503] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 27 04:53:19 web18 kernel: [415526.152503] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 27 04:53:19 web18 kernel: [415526.152503] Process xfssyncd (pid: 1479, threadinfo ffff88033c27c000, task ffff88033e6489c0)
Jun 27 04:53:19 web18 kernel: [415526.152503] Stack:
Jun 27 04:53:19 web18 kernel: [415526.152503]  ffff88033c254c00 ffffffffa018d402 ffff88033bd74448 ffff88033bd74400
Jun 27 04:53:19 web18 kernel: [415526.152503] <0> 0000000000000000 ffffffffa018de09 ffff88033e4d8000 0000000200000000
Jun 27 04:53:19 web18 kernel: [415526.152503] <0> ffffffffa018d3c8 ffffffff812f145e 0170446300000000 0000000000000000
Jun 27 04:53:19 web18 kernel: [415526.152503] Call Trace:
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffffa018d402>] ? xfs_reclaim_inode+0x3a/0xde [xfs]
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffffa018de09>] ? xfs_inode_ag_walk+0x97/0xd6 [xfs]
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffffa018d3c8>] ? xfs_reclaim_inode+0x0/0xde [xfs]
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffff812f145e>] ? schedule_timeout+0x1fa/0x21a
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffffa018de98>] ? xfs_inode_ag_iterator+0x50/0x7a [xfs]
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffffa018d3c8>] ? xfs_reclaim_inode+0x0/0xde [xfs]
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffffa018defe>] ? xfs_sync_worker+0x26/0x5f [xfs]
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffffa018d726>] ? xfssyncd+0x14f/0x1ba [xfs]
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffffa018d5d7>] ? xfssyncd+0x0/0x1ba [xfs]
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffff81053e19>] ? kthread+0x79/0x81
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffff81003864>] ? kernel_thread_helper+0x4/0x10
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffff81053da0>] ? kthread+0x0/0x81
Jun 27 04:53:19 web18 kernel: [415526.152503]  [<ffffffff81003860>] ? kernel_thread_helper+0x0/0x10
Jun 27 04:53:19 web18 kernel: [415526.152503] Code: 44 24 08 01 00 00 00 e8 1d b3 fe e0 48 83 c4 18 c3 89 d1 48 83 ec 08 48 89 f2 31 c0 48 89 fe 48 c7 c7 97 c7 19 a0 e8 99 1f 16 e1 <0f> 0b eb fe 41 56 41 55 49 89 d5 41 54 49 89 cc 55 89 fd 48 c7
Jun 27 04:53:19 web18 kernel: [415526.152503] RIP  [<ffffffffa018e3fc>] assfail+0x1a/0x1e [xfs]
Jun 27 04:53:19 web18 kernel: [415526.152503]  RSP <ffff88033c27dda0>
Jun 27 04:53:19 web18 kernel: [415526.211649] ---[ end trace 323be1c96277b67a ]---
---------------------------------------------------

greets 

Steffen
-- 
GMX DSL: Internet-, Telefon- und Handy-Flat ab 19,99 EUR/mtl.  
Bis zu 150 EUR Startguthaben inklusive! http://portal.gmx.net/de/go/dsl

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
