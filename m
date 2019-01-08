Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:49115 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727848AbfAHHqu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 02:46:50 -0500
Date: Tue, 8 Jan 2019 18:46:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Broken dio refcounting leads to livelock?
Message-ID: <20190108074644.GX4205@dastard>
References: <20190108002633.GL12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108002633.GL12689@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, Jan 07, 2019 at 04:26:33PM -0800, Darrick J. Wong wrote:
> Hi Christoph,
> 
> I have a question about refcounting in struct iomap_dio:
> 
> As I mentioned late last year, I've been seeing a livelock since the
> early 4.20-rcX era in iomap_dio_rw when running generic/323.  The
> relevant part of the function starts around line 1910:

Looking at iomap_dio_bio_end_io(), it has completion code that runs
only when dio->ref hits zero. i.e. it assumes that if it sees a zero
refcount, it holds the last reference and can free dio. Otherwise it
doesn't touch dio.

> 
> 	blk_finish_plug(&plug);
> 
> 	if (ret < 0)
> 		iomap_dio_set_error(dio, ret);
> 
> 	/*
> 	 * If all the writes we issued were FUA, we don't need to flush the
> 	 * cache on IO completion. Clear the sync flag for this case.
> 	 */
> 	if (dio->flags & IOMAP_DIO_WRITE_FUA)
> 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
> 
> 	if (!atomic_dec_and_test(&dio->ref)) {

So we've dropped the IO submission reference to the dio here, which
means the onl remaining references are the bio references. We run
this code if there are remaining bio references, which given the
above it means that dio can be freed at any time after this by IO
completion. That means it's never safe to reference dio after this.

Yup, that's a use after free.

> 		int clang = 0;
> 
> 		if (!dio->wait_for_completion)
> 			return -EIOCBQUEUED;

Ok, dio->wait_for_completion is unchanging at this point, so it
doesn't matter if we do this check before or after we drop the
dio->ref. That simplifies things.

> 
> 		for (;;) {
> 			set_current_state(TASK_UNINTERRUPTIBLE);
> 			if (!READ_ONCE(dio->submit.waiter))
> 				break;
> 
> 			if (!(iocb->ki_flags & IOCB_HIPRI) ||
> 			    !dio->submit.last_queue ||
> 			    !blk_poll(dio->submit.last_queue,
> 					 dio->submit.cookie, true))
> 				io_schedule(); <--------- here
> 		}
> 		__set_current_state(TASK_RUNNING);

This is an IO wait, which means we do not want to free the dio
structure until after we've been woken. And that also means we
are going to be running iomap_dio_complete() below, so we /must/
hold on to the dio reference here. Which means we need to change
the iomap_dio_bio_end_io() code because it only triggers a wakeup
if it's dropping the last dio->ref.

OK, so something like the patch below?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

iomap: fix iomap dio reference counts

From: Dave Chinner <dchinner@redhat.com>

The iomap dio structure could be referenced after contexts had
dropped their reference, resulting in use-after free conditions
being created. Rework the reference counting to ensure that we never
access the dio structure without having a valid reference count or
having guaranteed that the context holds the last reference will
free it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c | 75 +++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 55 insertions(+), 20 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index a3088fae567b..ee71e2ec93d4 100644
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
@@ -1916,27 +1936,42 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
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
