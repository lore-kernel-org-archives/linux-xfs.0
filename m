Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 57AE57CA4
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 10:15:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 278A38F8033
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 08:15:33 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id LUOh5Gcp8NmpaAgo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 05 Sep 2016 08:15:31 -0700 (PDT)
Date: Mon, 5 Sep 2016 17:15:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160905151529.GB16726@lst.de>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811234335.GX16044@dastard> <20160812025026.GA975@lst.de>
	<20160812095813.GZ16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160812095813.GZ16044@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: peterz@infradead.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Hi Dave,

I looked into killing the mrlock and ran into an unexpected problem.

Currently mr_writer tracks that there is someone holding a write lock,
lockdep on the other hand checks if the calling thread has that lock.

While that generally is the right semantic, our hack to offload
btree splits to a work item offends lockdep.  E.g. this callstack
now asserts:

generic/256	[   32.729465] run fstests generic/256 at 2016-09-05 15:09:48
[   33.078511] XFS (vdc): Mounting V5 Filesystem
[   33.090875] XFS (vdc): Ending clean mount
[   59.158520] XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/xfs_trans_inode.c, line: 100
[   59.159559] ------------[ cut here ]------------
[   59.160034] kernel BUG at fs/xfs/xfs_message.c:113!
[   59.160367] invalid opcode: 0000 [#1] SMP
[   59.160633] Modules linked in:
[   59.160846] CPU: 3 PID: 7284 Comm: kworker/3:3 Not tainted 4.8.0-rc2+ #1149
[   59.161056] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[   59.161056] Workqueue: xfsalloc xfs_btree_split_worker
[   59.161056] task: ffff880136d25ac0 task.stack: ffff8800bb864000
[   59.161056] RIP: 0010:[<ffffffff8159309d>]  [<ffffffff8159309d>] assfail+0x1d/0x20
[   59.161056] RSP: 0018:ffff8800bb867ba0  EFLAGS: 00010282
[   59.161056] RAX: 00000000ffffffea RBX: ffff8801339f3300 RCX: 0000000000000021
[   59.161056] RDX: ffff8800bb867ac8 RSI: 000000000000000a RDI: ffffffff82403b91
[   59.161056] RBP: ffff8800bb867ba0 R08: 0000000000000000 R09: 0000000000000000
[   59.161056] R10: 000000000000000a R11: f000000000000000 R12: 0000000000000001
[   59.161056] R13: ffff8801356aaaf8 R14: ffff8800bb867bd8 R15: ffff8801352d1d98
[   59.161056] FS:  0000000000000000(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
[   59.161056] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   59.161056] CR2: 000000000061ee00 CR3: 00000000bb956000 CR4: 00000000000006e0
[   59.161056] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   59.161056] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   59.161056] Stack:
[   59.161056]  ffff8800bb867bc8 ffffffff815b467d ffff8801352d1d98 ffff8800bba0fadc
[   59.161056]  ffff8800bb867d10 ffff8800bb867c88 ffffffff81536c0d ffff8801356aaaf8
[   59.161056]  ffff88013ad64000 ffff8801370e3340 ffff8801373d5600 0000000000000000
[   59.161056] Call Trace:
[   59.161056]  [<ffffffff815b467d>] xfs_trans_log_inode+0x5d/0xd0
[   59.161056]  [<ffffffff81536c0d>] xfs_bmbt_alloc_block+0x15d/0x220
[   59.161056]  [<ffffffff8153d526>] __xfs_btree_split+0xb6/0xae0
[   59.161056]  [<ffffffff81e33907>] ? _raw_spin_unlock_irq+0x27/0x40
[   59.161056]  [<ffffffff8153dfc1>] xfs_btree_split_worker+0x71/0xb0
[   59.161056]  [<ffffffff810f58a1>] process_one_work+0x1c1/0x600
[   59.161056]  [<ffffffff810f581b>] ? process_one_work+0x13b/0x600
[   59.161056]  [<ffffffff810f5d44>] worker_thread+0x64/0x4a0
[   59.161056]  [<ffffffff810f5ce0>] ? process_one_work+0x600/0x600
[   59.161056]  [<ffffffff810fb951>] kthread+0xf1/0x110
[   59.161056]  [<ffffffff81e341ef>] ret_from_fork+0x1f/0x40
[   59.161056]  [<ffffffff810fb860>] ? kthread_create_on_node+0x200/0x200

While it previously did fine.  I fear there might be other locking
asserts in the code called from that work item as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
