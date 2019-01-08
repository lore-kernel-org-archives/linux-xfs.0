Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50472 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733177AbfAHUIS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 15:08:18 -0500
Date: Tue, 8 Jan 2019 12:08:03 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Broken dio refcounting leads to livelock?
Message-ID: <20190108200803.GS12689@magnolia>
References: <20190108002633.GL12689@magnolia>
 <20190108074644.GX4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108074644.GX4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 08, 2019 at 06:46:44PM +1100, Dave Chinner wrote:
> On Mon, Jan 07, 2019 at 04:26:33PM -0800, Darrick J. Wong wrote:
> > Hi Christoph,
> > 
> > I have a question about refcounting in struct iomap_dio:
> > 
> > As I mentioned late last year, I've been seeing a livelock since the
> > early 4.20-rcX era in iomap_dio_rw when running generic/323.  The
> > relevant part of the function starts around line 1910:
> 
> Looking at iomap_dio_bio_end_io(), it has completion code that runs
> only when dio->ref hits zero. i.e. it assumes that if it sees a zero
> refcount, it holds the last reference and can free dio. Otherwise it
> doesn't touch dio.
> 
> > 
> > 	blk_finish_plug(&plug);
> > 
> > 	if (ret < 0)
> > 		iomap_dio_set_error(dio, ret);
> > 
> > 	/*
> > 	 * If all the writes we issued were FUA, we don't need to flush the
> > 	 * cache on IO completion. Clear the sync flag for this case.
> > 	 */
> > 	if (dio->flags & IOMAP_DIO_WRITE_FUA)
> > 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
> > 
> > 	if (!atomic_dec_and_test(&dio->ref)) {
> 
> So we've dropped the IO submission reference to the dio here, which
> means the onl remaining references are the bio references. We run
> this code if there are remaining bio references, which given the
> above it means that dio can be freed at any time after this by IO
> completion. That means it's never safe to reference dio after this.
> 
> Yup, that's a use after free.
> 
> > 		int clang = 0;
> > 
> > 		if (!dio->wait_for_completion)
> > 			return -EIOCBQUEUED;
> 
> Ok, dio->wait_for_completion is unchanging at this point, so it
> doesn't matter if we do this check before or after we drop the
> dio->ref. That simplifies things.
> 
> > 
> > 		for (;;) {
> > 			set_current_state(TASK_UNINTERRUPTIBLE);
> > 			if (!READ_ONCE(dio->submit.waiter))
> > 				break;
> > 
> > 			if (!(iocb->ki_flags & IOCB_HIPRI) ||
> > 			    !dio->submit.last_queue ||
> > 			    !blk_poll(dio->submit.last_queue,
> > 					 dio->submit.cookie, true))
> > 				io_schedule(); <--------- here
> > 		}
> > 		__set_current_state(TASK_RUNNING);
> 
> This is an IO wait, which means we do not want to free the dio
> structure until after we've been woken. And that also means we
> are going to be running iomap_dio_complete() below, so we /must/
> hold on to the dio reference here. Which means we need to change
> the iomap_dio_bio_end_io() code because it only triggers a wakeup
> if it's dropping the last dio->ref.
> 
> OK, so something like the patch below?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> iomap: fix iomap dio reference counts
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> The iomap dio structure could be referenced after contexts had
> dropped their reference, resulting in use-after free conditions
> being created. Rework the reference counting to ensure that we never
> access the dio structure without having a valid reference count or
> having guaranteed that the context holds the last reference will
> free it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/iomap.c | 75 +++++++++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 55 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index a3088fae567b..ee71e2ec93d4 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -1539,12 +1539,31 @@ static void iomap_dio_bio_end_io(struct bio *bio)
>  	if (bio->bi_status)
>  		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));
>  
> -	if (atomic_dec_and_test(&dio->ref)) {
> -		if (dio->wait_for_completion) {
> +	/*
> +	 * If we have a waiter, then this is a sync IO and the waiter will still
> +	 * hold a reference to the dio. If this is the last IO reference, we
> +	 * cannot reference the dio after we drop the reference as the waiter
> +	 * may be woken immediately and free the dio before we are don with it.
> +	 * Hence we check for two references, do the wakeup, then drop the final
> +	 * IO reference. The ordering of clearing the submit.waiter, waking the
> +	 * waiter and then dropping the reference matches the order of checks in
> +	 * the wait loop to avoid wakeup races.
> +	 */
> +	if (dio->wait_for_completion) {
> +		if (atomic_read(&dio->ref) == 2) {
>  			struct task_struct *waiter = dio->submit.waiter;
>  			WRITE_ONCE(dio->submit.waiter, NULL);
>  			blk_wake_io_task(waiter);

This blows up because waiter == NULL, which implies that this is the
second time through this code block for a given dio.  That doesn't sound
right... (more after the traceback)

BUG: unable to handle kernel NULL pointer dereference at 0000000000000800
#PF error: [normal kernel read fault]
PGD 0 P4D 0 
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 1 PID: 3438 Comm: fsstress Not tainted 5.0.0-rc1-xfsx #rc1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:__lock_acquire+0x40b/0x15f0
Code: d2 48 8b bc 24 98 00 00 00 65 48 33 3c 25 28 00 00 00 44 89 d0 0f 85 83 0f 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <49> 81 3b a0 63 70 82 41 b8 00 00 00 00 44 0f 45 c0 83 fe 01 0f 87
RSP: 0018:ffff88803ea03c80 EFLAGS: 00010002
RAX: 0000000000000001 RBX: 0000000000000800 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff88803ea03d50 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000800 R12: ffff88803cd18000
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
FS:  00007f508846cb80(0000) GS:ffff88803ea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000800 CR3: 000000002f9fa001 CR4: 00000000001606a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 ? __lock_is_held+0x51/0x90
 ? __lock_is_held+0x51/0x90
 ? kvm_clock_read+0x14/0x30
 ? __lock_acquire+0x26c/0x15f0
 ? kvm_clock_read+0x14/0x30
 lock_acquire+0x90/0x180
 ? try_to_wake_up+0x3f/0x560
 ? ring_buffer_unlock_commit+0x21/0x120
 _raw_spin_lock_irqsave+0x3e/0x80
 ? try_to_wake_up+0x3f/0x560
 try_to_wake_up+0x3f/0x560
 ? __trace_bprintk+0x6e/0x80
 iomap_dio_bio_end_io+0x1a6/0x1d0
 blk_update_request+0xd7/0x2f0
 scsi_end_request+0x32/0x3a0
 scsi_io_completion+0x79/0x610
 blk_done_softirq+0xb1/0xe0
 __do_softirq+0xe5/0x4b2
 ? kvm_sched_clock_read+0x5/0x10
 irq_exit+0xbc/0xe0
 call_function_single_interrupt+0xf/0x20
 </IRQ>
RIP: 0010:__list_del_entry_valid+0x3d/0x4c
Code: c8 0f 84 5a 00 00 00 48 b9 00 02 00 00 00 00 ad de 48 39 ca 0f 84 7d 00 00 00 48 8b 32 48 39 fe 0f 85 5d 00 00 00 48 8b 50 08 <48> 39 f2 0f 85 42 00 00 00 b8 01 00 00 00 c3 48 89 d1 48 c7 c7 e8
RSP: 0018:ffffc90005f2f9f0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff04
RAX: ffff88802f9da110 RBX: ffff888078313a00 RCX: dead000000000200
RDX: ffff88803dbd3eb0 RSI: ffff88803dbd3eb0 RDI: ffff88803dbd3eb0
RBP: ffff8880370c7800 R08: 0000000000003bac R09: 000000000000000c
R10: 0000000000000000 R11: ffff88803c586c00 R12: ffff888078942c00
R13: ffff88803dbd3eb0 R14: ffff88803c586c00 R15: ffff88803dbd3e40
 xfs_log_commit_cil+0x554/0x880 [xfs]
 ? xfs_trans_roll+0x7e/0x190 [xfs]
 __xfs_trans_commit+0xd3/0x630 [xfs]
 ? xfs_defer_trans_roll+0x16e/0x5b0 [xfs]
 ? xfs_defer_finish_noroll+0xf1/0x7e0 [xfs]
 xfs_trans_roll+0x7e/0x190 [xfs]
 xfs_defer_trans_roll+0x16e/0x5b0 [xfs]
 ? __xfs_trans_commit+0x1c3/0x630 [xfs]
 xfs_defer_finish_noroll+0xf1/0x7e0 [xfs]
 ? xfs_iomap_write_unwritten+0xf4/0x390 [xfs]
 __xfs_trans_commit+0x1c3/0x630 [xfs]
 xfs_iomap_write_unwritten+0xf4/0x390 [xfs]
 iomap_dio_complete+0x3c/0x130
 ? iomap_dio_rw+0x404/0x520
 iomap_dio_rw+0x3e7/0x520
 ? xfs_file_dio_aio_write+0x132/0x3d0 [xfs]
 xfs_file_dio_aio_write+0x132/0x3d0 [xfs]
 xfs_file_write_iter+0xf2/0x1d0 [xfs]
 __vfs_write+0x1a1/0x200
 vfs_write+0xba/0x1c0
 ksys_write+0x52/0xc0
 do_syscall_64+0x4a/0x150
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f5087c3c281
Code: c3 0f 1f 84 00 00 00 00 00 48 8b 05 59 8d 20 00 c3 0f 1f 84 00 00 00 00 00 8b 05 8a d1 20 00 85 c0 75 16 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 57 f3 c3 0f 1f 44 00 00 41 54 55 49 89 d4 53
RSP: 002b:00007fff0879c828 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f5087c3c281
RDX: 0000000000019000 RSI: 00005585ac58a200 RDI: 0000000000000003
RBP: 00000000001dd000 R08: 0000000000000007 R09: 0000000000000000
R10: 00005585ac54a010 R11: 0000000000000246 R12: 0000000000000254
R13: 0000000000019000 R14: 00005585ac58a200 R15: 0000000000000000
Modules linked in: xfs libcrc32c bfq dax_pmem device_dax nd_pmem sch_fq_codel ip_tables x_tables nfsv4 af_packet

Oh sh*t, we're committing the unwritten extent conversion before the
disk write even finishes!

I added some tracepoints to see what's going on with the dio here:
The iomap_dio_bio_end_io event is right at the top of the function.

dio0 is right after we set dio->submit.waiter = current
dio1 is right before we call blk_finish_plug
dio2 is right before we check !dio->wait_for_completion
dio3 is just before the final iomap_dio_complete

fsstress-3438    1.... 5060291us : iomap_dio_rw: dio0 xffff88802a88cc00 ref 1 wfc 1 waiter xffff88803cd18000
fsstress-3437    1..s1 5061648us : iomap_dio_bio_end_io: dio xffff88802a88cc00 ref 2 wfc 1 waiter xffff88803cd18000
fsstress-3438    1.... 5062366us : iomap_dio_rw: dio1 xffff88802a88cc00 ref 3 wfc 1 waiter x0
fsstress-3438    1.... 5062388us : iomap_dio_rw: dio2 xffff88802a88cc00 ref 3 wfc 1 waiter x0
fsstress-3438    1.... 5062388us : iomap_dio_rw: dio3 xffff88802a88cc00 ref 3 wfc 1 waiter x0
fsstress-3438    1..s1 5062494us : iomap_dio_bio_end_io: dio xffff88802a88cc00 ref 2 wfc 1 waiter x0

It looks like we're issuing two bios to satisfy a particular dio.
However, the first bio completes before the submitter calls finish_plug??

I guess this means that blk_start_plug no longer plugs up io requests,
which means that the end_io function tries to wake up the submitter
before it's even had a chance to issue the second bio.

This is surprising to me, because I was under the impression that
blk_{start,finish}_plug held all the bios so there was no chance that
any of them would issue (let alone call end_io) before finish_plug.

/sys/block/sda/queue/scheduler = [bfq] none
/sys/block/sdf/queue/scheduler = [bfq] none

Changing the scheduler to none doesn't help.

However, elevating &dio->ref for the duration of the plug does seem to
work around this problem...

--D

> -		} else if (dio->flags & IOMAP_DIO_WRITE) {
> +		}
> +		atomic_dec(&dio->ref);
> +	} else if (atomic_dec_and_test(&dio->ref)) {
> +		/*
> +		 * There is no waiter so we are finishing async IO. If the
> +		 * refcount drops to zero then we are responsible for running
> +		 * the appropriate IO completion to finish and free the dio
> +		 * context.
> +		 */
> +		if (dio->flags & IOMAP_DIO_WRITE) {
>  			struct inode *inode = file_inode(dio->iocb->ki_filp);
>  
>  			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
> @@ -1553,6 +1572,7 @@ static void iomap_dio_bio_end_io(struct bio *bio)
>  			iomap_dio_complete_work(&dio->aio.work);
>  		}
>  	}
> +	/* not safe to use dio past this point */
>  
>  	if (should_dirty) {
>  		bio_check_pages_dirty(bio);
> @@ -1916,27 +1936,42 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	if (dio->flags & IOMAP_DIO_WRITE_FUA)
>  		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
>  
> -	if (!atomic_dec_and_test(&dio->ref)) {
> -		if (!dio->wait_for_completion)
> -			return -EIOCBQUEUED;
> +	/*
> +	 * If this is async IO, and we drop the last reference here we need
> +	 * to complete the IO, otherwise we return EIOCBQUEUED. The order of
> +	 * checks is important here because we can be racing with Io completion
> +	 * to drop the last reference and free the dio, so we must check the dio
> +	 * state before we drop the reference to avoid use-after-free
> +	 * situations.
> +	 */
> +	if (!dio->wait_for_completion) {
> +		if (atomic_dec_and_test(&dio->ref))
> +			return iomap_dio_complete(dio);
> +		return -EIOCBQUEUED;
> +	}
>  
> -		for (;;) {
> -			set_current_state(TASK_UNINTERRUPTIBLE);
> -			if (!READ_ONCE(dio->submit.waiter))
> -				break;
> +	/*
> +	 * This is sync IO and we have to access the dio structure to determine
> +	 * if we need to wait and/or poll the block device for completion. hence
> +	 * we need to hold on to our reference until IO completion has dropped
> +	 * all the IO references and woken us before we drop our reference and
> +	 * complete the IO.
> +	 */
> +	while (atomic_read(&dio->ref) > 1) {
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		if (!READ_ONCE(dio->submit.waiter))
> +			break;
>  
> -			if (!(iocb->ki_flags & IOCB_HIPRI) ||
> -			    !dio->submit.last_queue ||
> -			    !blk_poll(dio->submit.last_queue,
> -					 dio->submit.cookie, true))
> -				io_schedule();
> -		}
> -		__set_current_state(TASK_RUNNING);
> +		if (!(iocb->ki_flags & IOCB_HIPRI) ||
> +		    !dio->submit.last_queue ||
> +		    !blk_poll(dio->submit.last_queue,
> +				 dio->submit.cookie, true))
> +			io_schedule();
>  	}
> +	__set_current_state(TASK_RUNNING);
> +	atomic_dec(&dio->ref);
>  
> -	ret = iomap_dio_complete(dio);
> -
> -	return ret;
> +	return iomap_dio_complete(dio);
>  
>  out_free_dio:
>  	kfree(dio);
