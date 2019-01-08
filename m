Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46112 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728794AbfAHVH2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 16:07:28 -0500
Date: Tue, 8 Jan 2019 13:07:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Broken dio refcounting leads to livelock?
Message-ID: <20190108210716.GV12689@magnolia>
References: <20190108002633.GL12689@magnolia>
 <20190108074644.GX4205@dastard>
 <20190108200803.GS12689@magnolia>
 <x49tvii7tvk.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49tvii7tvk.fsf@segfault.boston.devel.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 08, 2019 at 03:54:23PM -0500, Jeff Moyer wrote:
> "Darrick J. Wong" <darrick.wong@oracle.com> writes:
> 
> > It looks like we're issuing two bios to satisfy a particular dio.
> > However, the first bio completes before the submitter calls finish_plug??
> >
> > I guess this means that blk_start_plug no longer plugs up io requests,
> > which means that the end_io function tries to wake up the submitter
> > before it's even had a chance to issue the second bio.
> 
> blk_start_plug was always a hint.  If you exceed a certain number of
> requests (BLK_MAX_REQUEST_COUNT, which is 16) or a certain size of
> request (BLK_PLUG_FLUSH_SIZE, which is 128k), the block layer will flush
> the plug list.
> 
> > This is surprising to me, because I was under the impression that
> > blk_{start,finish}_plug held all the bios so there was no chance that
> > any of them would issue (let alone call end_io) before finish_plug.
> 
> Definitely not the case.  The plug list is just a performance
> optimization.

Ahh, fun!  I had not realized that it was merely a suggestion.

$ git grep blk_start_plug Documentation/
$ echo $?
1

In that case we definitely need something to prevent the endio from
trying to wake up a submitter that's still submitting.  Below is the
amended patch I'm using to run generic/013 and generic/323 in a loop.
No crashes so far.

--D

From: Dave Chinner <dchinner@redhat.com>
Subject: [PATCH] iomap: fix iomap dio reference counts

The iomap dio structure could be referenced after contexts had
dropped their reference, resulting in use-after free conditions
being created. Rework the reference counting to ensure that we never
access the dio structure without having a valid reference count or
having guaranteed that the context holds the last reference will
free it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick: elevate dio refcount during block plug]
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c |   82 +++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 62 insertions(+), 20 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index a3088fae567b..8e7eea407a0a 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1539,12 +1539,31 @@ static void iomap_dio_bio_end_io(struct bio *bio)
 	if (bio->bi_status)
 		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));
 
-	if (atomic_dec_and_test(&dio->ref)) {
-		if (dio->wait_for_completion) {
+	/*
+	 * If we have a waiter, then this is a sync IO and the waiter will still
+	 * hold a reference to the dio. If this is the last IO reference, we
+	 * cannot reference the dio after we drop the reference as the waiter
+	 * may be woken immediately and free the dio before we are don with it.
+	 * Hence we check for two references, do the wakeup, then drop the final
+	 * IO reference. The ordering of clearing the submit.waiter, waking the
+	 * waiter and then dropping the reference matches the order of checks in
+	 * the wait loop to avoid wakeup races.
+	 */
+	if (dio->wait_for_completion) {
+		if (atomic_read(&dio->ref) == 2) {
 			struct task_struct *waiter = dio->submit.waiter;
 			WRITE_ONCE(dio->submit.waiter, NULL);
 			blk_wake_io_task(waiter);
-		} else if (dio->flags & IOMAP_DIO_WRITE) {
+		}
+		atomic_dec(&dio->ref);
+	} else if (atomic_dec_and_test(&dio->ref)) {
+		/*
+		 * There is no waiter so we are finishing async IO. If the
+		 * refcount drops to zero then we are responsible for running
+		 * the appropriate IO completion to finish and free the dio
+		 * context.
+		 */
+		if (dio->flags & IOMAP_DIO_WRITE) {
 			struct inode *inode = file_inode(dio->iocb->ki_filp);
 
 			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
@@ -1553,6 +1572,7 @@ static void iomap_dio_bio_end_io(struct bio *bio)
 			iomap_dio_complete_work(&dio->aio.work);
 		}
 	}
+	/* not safe to use dio past this point */
 
 	if (should_dirty) {
 		bio_check_pages_dirty(bio);
@@ -1887,6 +1907,12 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 
 	inode_dio_begin(inode);
 
+	/*
+	 * The presence of a plug does not prevent IOs from issuing, so elevate
+	 * the refcount on the dio so that a fast end_io can't try to wake us
+	 * up before we're even done issuing IO.
+	 */
+	atomic_inc(&dio->ref);
 	blk_start_plug(&plug);
 	do {
 		ret = iomap_apply(inode, pos, count, flags, ops, dio,
@@ -1905,6 +1931,7 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 			break;
 	} while ((count = iov_iter_count(iter)) > 0);
 	blk_finish_plug(&plug);
+	atomic_dec(&dio->ref);
 
 	if (ret < 0)
 		iomap_dio_set_error(dio, ret);
@@ -1916,27 +1943,42 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (dio->flags & IOMAP_DIO_WRITE_FUA)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
-	if (!atomic_dec_and_test(&dio->ref)) {
-		if (!dio->wait_for_completion)
-			return -EIOCBQUEUED;
+	/*
+	 * If this is async IO, and we drop the last reference here we need
+	 * to complete the IO, otherwise we return EIOCBQUEUED. The order of
+	 * checks is important here because we can be racing with Io completion
+	 * to drop the last reference and free the dio, so we must check the dio
+	 * state before we drop the reference to avoid use-after-free
+	 * situations.
+	 */
+	if (!dio->wait_for_completion) {
+		if (atomic_dec_and_test(&dio->ref))
+			return iomap_dio_complete(dio);
+		return -EIOCBQUEUED;
+	}
 
-		for (;;) {
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			if (!READ_ONCE(dio->submit.waiter))
-				break;
+	/*
+	 * This is sync IO and we have to access the dio structure to determine
+	 * if we need to wait and/or poll the block device for completion. hence
+	 * we need to hold on to our reference until IO completion has dropped
+	 * all the IO references and woken us before we drop our reference and
+	 * complete the IO.
+	 */
+	while (atomic_read(&dio->ref) > 1) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!READ_ONCE(dio->submit.waiter))
+			break;
 
-			if (!(iocb->ki_flags & IOCB_HIPRI) ||
-			    !dio->submit.last_queue ||
-			    !blk_poll(dio->submit.last_queue,
-					 dio->submit.cookie, true))
-				io_schedule();
-		}
-		__set_current_state(TASK_RUNNING);
+		if (!(iocb->ki_flags & IOCB_HIPRI) ||
+		    !dio->submit.last_queue ||
+		    !blk_poll(dio->submit.last_queue,
+				 dio->submit.cookie, true))
+			io_schedule();
 	}
+	__set_current_state(TASK_RUNNING);
+	atomic_dec(&dio->ref);
 
-	ret = iomap_dio_complete(dio);
-
-	return ret;
+	return iomap_dio_complete(dio);
 
 out_free_dio:
 	kfree(dio);
