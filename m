Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F33007F4E
	for <xfs@oss.sgi.com>; Sun, 12 Apr 2015 18:22:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D6B918F8033
	for <xfs@oss.sgi.com>; Sun, 12 Apr 2015 16:22:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	T3GcQu1C7pPOBBNq for <xfs@oss.sgi.com>;
	Sun, 12 Apr 2015 16:22:14 -0700 (PDT)
Date: Mon, 13 Apr 2015 09:22:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfs: fix direct IO completion issues
Message-ID: <20150412232200.GL15810@dastard>
References: <1428673080-23052-1-git-send-email-david@fromorbit.com>
	<20150412150932.GA10115@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150412150932.GA10115@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Apr 12, 2015 at 08:09:32AM -0700, Christoph Hellwig wrote:
> On Fri, Apr 10, 2015 at 11:37:55PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > This patchset addresses the deeper problems Brian outlined in the
> > description of this patch:
> > 
> > http://oss.sgi.com/archives/xfs/2015-04/msg00071.html
> > 
> > The basic issues is that DIO completion can run in interrupt context
> > and it does things it should not do in interrupt context because Bad
> > Things Will Happen.
> 
> Where do we complete DIO writes from irq context?  Since my direct-io.c
> changes from a few years ago that should not be the case.

Yes, that's what I thought, too. However any AIO direct IO write
that does not call set_buffer_defer_completion() will run completion
in interrupt context. The current code in __xfs_get_blocks() sets
that flag only when:

                if (create && ISUNWRITTEN(&imap)) {
                        if (direct) {
                                bh_result->b_private = inode;
                                set_buffer_defer_completion(bh_result);
                        }
                        set_buffer_unwritten(bh_result);
                }

And hence only writes into unwritten extents will be deferred to the
DIO completion workqueue.  Hence sub-block writes that extend EOF
(the trace below), or extending writes into blocks beyond EOF
allocated by delalloc speculative prealloc will run transactions in
irq context to update the on-disk EOF.

This is the stack trace from testing the simple "use a spinlock
around i_size_write()" patches that pointed out how wrong we'd been:

[  375.648323] run fstests generic/036 at 2015-04-08 08:58:45
[  380.661832] BUG: spinlock cpu recursion on CPU#3, aio-dio-fcntl-r/27068
[  380.662898]  lock: 0xffff8800afe88b70, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: 3
[  380.664232] CPU: 3 PID: 27068 Comm: aio-dio-fcntl-r Not tainted 4.0.0-rc4-dgc+ #870
[  380.665393] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[  380.665769]  ffff8800afe88b70 ffff88013fd83bf8 ffffffff81dccb34 0000000000000000
[  380.665769]  0000000000000000 ffff88013fd83c18 ffffffff81dc6754 ffff8800afe88b70
[  380.665769]  ffffffff821ed962 ffff88013fd83c38 ffffffff81dc677f ffff8800afe88b70
[  380.665769] Call Trace:
[  380.665769]  <IRQ>  [<ffffffff81dccb34>] dump_stack+0x4c/0x65
[  380.665769]  [<ffffffff81dc6754>] spin_dump+0x90/0x95
[  380.665769]  [<ffffffff81dc677f>] spin_bug+0x26/0x2b
[  380.665769]  [<ffffffff810e4058>] do_raw_spin_lock+0x128/0x1a0
[  380.665769]  [<ffffffff81dd7dd5>] _raw_spin_lock+0x15/0x20
[  380.665769]  [<ffffffff814f49cc>] xfs_end_io_direct_write+0x5c/0x110
[  380.665769]  [<ffffffff812085c3>] dio_complete+0xf3/0x160
[  380.665769]  [<ffffffff812086a3>] dio_bio_end_aio+0x73/0x100
[  380.665769]  [<ffffffff810c85e2>] ? default_wake_function+0x12/0x20
[  380.665769]  [<ffffffff817c461b>] bio_endio+0x5b/0xa0
[  380.665769]  [<ffffffff817cc3a0>] blk_update_request+0x90/0x370
[  380.665769]  [<ffffffff817d565a>] blk_mq_end_request+0x1a/0x70
[  380.665769]  [<ffffffff81ad393f>] virtblk_request_done+0x3f/0x70
[  380.665769]  [<ffffffff817d5fce>] __blk_mq_complete_request+0x8e/0x120
[  380.665769]  [<ffffffff817d6076>] blk_mq_complete_request+0x16/0x20
[  380.665769]  [<ffffffff81ad347e>] virtblk_done+0x6e/0xf0
[  380.665769]  [<ffffffff81893af5>] vring_interrupt+0x35/0x60
[  380.665769]  [<ffffffff810f27de>] handle_irq_event_percpu+0x3e/0x1c0
[  380.665769]  [<ffffffff810f29a1>] handle_irq_event+0x41/0x70
[  380.665769]  [<ffffffff810f573f>] handle_edge_irq+0x7f/0x120
[  380.665769]  [<ffffffff8104d2f2>] handle_irq+0x22/0x40
[  380.665769]  [<ffffffff81ddaf31>] do_IRQ+0x51/0xf0
[  380.665769]  [<ffffffff81dd8fad>] common_interrupt+0x6d/0x6d
[  380.665769]  <EOI>  [<ffffffff810e4033>] ? do_raw_spin_lock+0x103/0x1a0
[  380.665769]  [<ffffffff81dd7dd5>] _raw_spin_lock+0x15/0x20
[  380.665769]  [<ffffffff81502f28>] xfs_file_aio_write_checks+0x58/0x130
[  380.665769]  [<ffffffff815030ce>] xfs_file_dio_aio_write+0xce/0x410
[  380.665769]  [<ffffffff811d0f08>] ? __sb_start_write+0x58/0x120
[  380.665769]  [<ffffffff815036fe>] xfs_file_write_iter+0x7e/0x120
[  380.665769]  [<ffffffff81503680>] ? xfs_file_buffered_aio_write+0x270/0x270
[  380.665769]  [<ffffffff81218cd3>] aio_run_iocb+0x203/0x3c0
[  380.665769]  [<ffffffff810c107d>] ? __might_sleep+0x4d/0x90
[  380.665769]  [<ffffffff810c107d>] ? __might_sleep+0x4d/0x90
[  380.665769]  [<ffffffff81219b4f>] do_io_submit+0x19f/0x410
[  380.665769]  [<ffffffff81219dd0>] SyS_io_submit+0x10/0x20
[  380.665769]  [<ffffffff81dd84c9>] system_call_fastpath+0x12/0x17

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
