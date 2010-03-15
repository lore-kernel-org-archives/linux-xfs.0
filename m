Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FGahOn065052 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 11:36:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AEFC142E991
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 09:38:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id OUrbPjX2ZG0WQG3a for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 09:38:18 -0700 (PDT)
Date: Mon, 15 Mar 2010 12:38:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Delayed logging
Message-ID: <20100315163818.GA30402@infradead.org>
References: <20100315043000.GK4732@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100315043000.GK4732@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Next xfstests failure in 014 (note that this is all without even
enabling the delaylog mount option):

[  392.576013] Assertion failed: xfs_alloc_busy_search(mp, busyp->agno,
busyp->bno, busyp->length) == busyp, file: fs/xfs/xfs_alloc.c, line:
2653
[  392.586038] ------------[ cut here ]------------
[  392.589862] kernel BUG at fs/xfs/support/debug.c:109!
[  392.589862] invalid opcode: 0000 [#1] SMP 
[  392.589862] last sysfs file:
/sys/devices/virtio-pci/virtio1/block/vdb/removable
[  392.589862] Modules linked in:
[  392.589862] 
[  392.589862] Pid: 328, comm: xfslogd/0 Not tainted 2.6.33-xfs #491
/Bochs
[  392.589862] EIP: 0060:[<c04ef33e>] EFLAGS: 00010282 CPU: 0
[  392.589862] EIP is at assfail+0x1e/0x30
[  392.589862] EAX: 00000095 EBX: f6aad3f0 ECX: f7119280 EDX: 01704000
[  392.589862] ESI: f5ac0a88 EDI: 0000b4b5 EBP: f724fe2c ESP: f724fe1c
[  392.589862]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  392.589862] Process xfslogd/0 (pid: 328, ti=f724e000 task=f7119280 task.ti=f724e000)
[  392.589862] Stack:
[  392.589862]  c0b75db8 c0b6a3b4 c0b2db8f 00000a5d f724fe54 c047c086 00000003 f56f5600
[  392.589862] <0> 00000fb4 00000003 00000000 f575a59c f575a5a8 f575a5a8 f724fe6c c04d67d8
[  392.589862] <0> f5ac0a88 00000000 f575a438 00000000 f724fe84 c04d6eb3 00000000 f575a43c
[  392.589862] Call Trace:
[  392.589862]  [<c047c086>] ? xfs_alloc_clear_busy+0x56/0xe0
[  392.589862]  [<c04d67d8>] ? xfs_trans_free_busy+0x38/0x50
[  392.589862]  [<c04d6eb3>] ? xfs_trans_committed+0x73/0x90
[  392.589862]  [<c04c5a12>] ? xlog_state_do_callback+0x282/0x3c0
[  392.589862]  [<c04c5fe4>] ? xlog_state_done_syncing+0xc4/0xe0
[  392.589862]  [<c04c60f1>] ? xlog_iodone+0xf1/0x160
[  392.589862]  [<c04e53b0>] ? xfs_buf_iodone_work+0x0/0xd0
[  392.589862]  [<c04e53df>] ? xfs_buf_iodone_work+0x2f/0xd0
[  392.589862]  [<c04e53b0>] ? xfs_buf_iodone_work+0x0/0xd0
[  392.589862]  [<c017a7c4>] ? worker_thread+0x154/0x270
[  392.589862]  [<c017a763>] ? worker_thread+0xf3/0x270
[  392.589862]  [<c017e1f0>] ? autoremove_wake_function+0x0/0x40
[  392.589862]  [<c017a670>] ? worker_thread+0x0/0x270
[  392.589862]  [<c017de3c>] ? kthread+0x6c/0x80
[  392.589862]  [<c017ddd0>] ? kthread+0x0/0x80
[  392.589862]  [<c012effa>] ? kernel_thread_helper+0x6/0x1c
[  392.589862] Code: 00 e8 f7 57 18 00 c9 c3 90 8d 74 26 00 55 89 e5 83 ec 10 89 4c 24 0c 89 54 24 08 89 44 24 04 c7 04 24 b8 5d b7 c0 e8 59 a2 3f 00 <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
