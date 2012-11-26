Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAQLhUfU232179 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 15:43:30 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZNQSPO7fsZo2VvSm for <xfs@oss.sgi.com>;
	Mon, 26 Nov 2012 13:45:44 -0800 (PST)
Date: Tue, 27 Nov 2012 08:45:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: fix direct IO nested transaction deadlock.
Message-ID: <20121126214541.GP32450@dastard>
References: <1353641065-14983-1-git-send-email-david@fromorbit.com>
	<1353641065-14983-3-git-send-email-david@fromorbit.com>
	<50B390CA.3010203@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50B390CA.3010203@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 26, 2012 at 09:54:50AM -0600, Mark Tinguely wrote:
> On 11/22/12 21:24, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >The direct IO path can do a nested transaction reservation when
> >writing past the EOF. The first transaction is the append
> >transaction for setting the filesize at IO completion, but we can
> >also need a transaction for allocation of blocks. If the log is low
> >on space due to reservations and small log, the append transaction
> >can be granted after wating for space as the only active transaction
> >in the system. This then attempts a reservation for an allocation,
> >which there isn't space in the log for, and the reservation sleeps.
> >The result is that there is nothing left in the system to wake up
> >all the processes waiting for log space to come free.
> >
> >The stack trace that shows this deadlock is relatively innocuous:
> >
> >  xlog_grant_head_wait
> >  xlog_grant_head_check
> >  xfs_log_reserve
> >  xfs_trans_reserve
> >  xfs_iomap_write_direct
> >  __xfs_get_blocks
> >  xfs_get_blocks_direct
> >  do_blockdev_direct_IO
> >  __blockdev_direct_IO
> >  xfs_vm_direct_IO
> >  generic_file_direct_write
> >  xfs_file_dio_aio_writ
> >  xfs_file_aio_write
> >  do_sync_write
> >  vfs_write
> >
> >This was discovered on a filesystem with a log of only 10MB, and a
> >log stripe unit of 256k whih increased the base reservations by
> >512k. Hence a allocation transaction requires 1.2MB of log space to
> >be available instead of only 260k, and so greatly increased the
> >chance that there wouldn't be enough log space available for the
> >nested transaction to succeed. The key to reproducing it is this
> >mkfs command:
> >
> >mkfs.xfs -f -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b $SCRATCH_DEV
> >
> >The test case was a 1000 fsstress processes running with random
> >freeze and unfreezes every few seconds. Thanks to Eryu Guan
> >(eguan@redhat.com) for writing the test that found this on a system
> >with a somewhat unique default configuration....
> >
> >cc:<stable@vger.kernel.org>
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >Signed-off-by: Dave Chinner<david@fromorbit.com>
> >---
> 
> 
> This is a good work-around

It's not a work-around. Nested transaction reserves are a bug.
Always have been, always will be.


> but with a bit more filesystem traffic (I
> used your filesystem, fsstress and added the rm/copies from bug 922
> because I knew it stressed the log), we can easily (couple hours) hang

Script, please.

> the filesystem. There are many processes waiting for log space, here is
> one in xfs_end_io():
> 
> PID: 20256  TASK: ffff88034c5b4140  CPU: 2   COMMAND: "fsstress"
>  #0 [ffff88034b8dd688] __schedule at ffffffff8142fbbe
>  #1 [ffff88034b8dd710] schedule at ffffffff8142ffe4
>  #2 [ffff88034b8dd720] xlog_grant_head_wait at ffffffffa05231f8 [xfs]
>  #3 [ffff88034b8dd790] xlog_grant_head_check at ffffffffa05233fc [xfs]
>  #4 [ffff88034b8dd7d0] xfs_log_reserve at ffffffffa05249c2 [xfs]
>  #5 [ffff88034b8dd830] xfs_trans_reserve at ffffffffa0520b43 [xfs]
>  #6 [ffff88034b8dd890] xfs_iomap_write_unwritten at ffffffffa04c874e [xfs]
>  #7 [ffff88034b8dd960] xfs_end_io at ffffffffa04b6e62 [xfs]
>  #8 [ffff88034b8dd990] xfs_finish_ioend_sync at ffffffffa04b6f81 [xfs]
>  #9 [ffff88034b8dd9a0] xfs_end_io_direct_write at ffffffffa04b6fd9 [xfs]
> #10 [ffff88034b8dd9b0] dio_complete at ffffffff81184f8e
> #11 [ffff88034b8dd9d0] do_blockdev_direct_IO at ffffffff81187578
> #12 [ffff88034b8ddba0] __blockdev_direct_IO at ffffffff81187850
> #13 [ffff88034b8ddbe0] xfs_vm_direct_IO at ffffffffa04b71a8 [xfs]
> #14 [ffff88034b8ddc70] generic_file_direct_write at ffffffff810f8b9e
> #15 [ffff88034b8ddce0] xfs_file_dio_aio_write at ffffffffa04bf9b4 [xfs]
> #16 [ffff88034b8ddd80] xfs_file_aio_write at ffffffffa04bfeea [xfs]
> #17 [ffff88034b8ddde0] do_sync_write at ffffffff8114cf83
> #18 [ffff88034b8ddf00] vfs_write at ffffffff8114d5fe
> #19 [ffff88034b8ddf30] sys_write at ffffffff8114d91d
> #20 [ffff88034b8ddf80] system_call_fastpath at ffffffff814391e9

That's waiting on unwritten extent conversion, so is a different
problem to the one that this patch fixes because there are no nested
transactions with the bug fix in place.

> I still believe we should continue to push the AIL when the last push
> was not enough to satisfy the first waiter, but that is just a minor
> optimization so we do not have to wait until the next sync.

There's no indication that the push target is the problem because
the AIL is empty i.e. the push has worked correctly.

> Now that Brian fixed the locking issue,

Remind me again what that was?

> the current hangs happen because
> the sync worker is responsible to force the writing of the CIL but the
> sync worker needs log space for the dummy record.

The sync worker is responsible for idling the log, not much else.

> xfs_ail ffff88034c798640:
> struct xfs_ail {
>   xa_mount = 0xffff88034fdd3000,
>   xa_task = 0xffff88034fe364c0,
>   xa_ail = {
>     next = 0xffff88034c798650, 	<- empty
>     prev = 0xffff88034c798650
>   },

If the AIL is empty, then the log is not being pinned. What's the
rest of the AIL look like? The push target would be very
enlightening, especially if that's comapred against the grant heads
and the LSNs held in the log structure.

> The CIL is hold some entries,
> xfs_cil_ctx ffff88035159b7c0
> struct xfs_cil_ctx {
>   cil = 0xffff88034c159ec0,
>   sequence = 0x1de0,
>   start_lsn = 0x0,
>   commit_lsn = 0x0,
>   ticket = 0xffff8802b80c0e30,
>   nvecs = 0xa9,
>   space_used = 0x3d30,

space_used = 15,664 bytes. There's very little space consumed by the
CIL.

But without the struct log, struct xfs_cil or the full struct
xfs_ail, I have no way of even confirming that it is a similar
problem.

Further, I need the full output of the first ticket on the reserve
grant head wait queue to determine if there really is enough space
in the log for that ticket to be woken.....

> PID: 21396  TASK: ffff8802b816e080  CPU: 0   COMMAND: "kworker/0:0"
>  #0 [ffff8802b8361b78] __schedule at ffffffff8142fbbe
>  #1 [ffff8802b8361c00] schedule at ffffffff8142ffe4
>  #2 [ffff8802b8361c10] xlog_grant_head_wait at ffffffffa05231f8 [xfs]
>  #3 [ffff8802b8361c80] xlog_grant_head_check at ffffffffa05233fc [xfs]
>  #4 [ffff8802b8361cc0] xfs_log_reserve at ffffffffa05249c2 [xfs]
>  #5 [ffff8802b8361d20] xfs_trans_reserve at ffffffffa0520b43 [xfs]
>  #6 [ffff8802b8361d80] xfs_fs_log_dummy at ffffffffa04c28ae [xfs]
>  #7 [ffff8802b8361db0] xfs_log_worker at ffffffffa0525ea8 [xfs]
>  #8 [ffff8802b8361dd0] process_one_work at ffffffff8105afc6
>  #9 [ffff8802b8361e50] worker_thread at ffffffff8105be00
> #10 [ffff8802b8361ec0] kthread at ffffffff81061b1b
> #11 [ffff8802b8361f50] ret_from_fork at ffffffff8143913c
> 
> This patch is a good band aid, but we need to do a log rework as
> discussed in:
> 
> http://oss.sgi.com/archives/xfs/2012-09/msg00020.html

The AIL list empty, and the CIL is close to empty - I'm not sure
that a log force would do anything because it won't change the
AIL/CIL state very much at all. Besides, that thread is refering to
*removing* regular log forces while the log is active, not adding
them, so it's not likely to help here at all, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
