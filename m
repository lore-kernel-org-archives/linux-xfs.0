Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36236 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfAHBQV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jan 2019 20:16:21 -0500
Date: Mon, 7 Jan 2019 17:16:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Broken dio refcounting leads to livelock?
Message-ID: <20190108011605.GM12689@magnolia>
References: <20190108002633.GL12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108002633.GL12689@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Jan 07, 2019 at 04:26:33PM -0800, Darrick J. Wong wrote:
> Hi Christoph,
> 
> I have a question about refcounting in struct iomap_dio:
> 
> As I mentioned late last year, I've been seeing a livelock since the
> early 4.20-rcX era in iomap_dio_rw when running generic/323.  The
> relevant part of the function starts around line 1910:
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
> 		int clang = 0;
> 
> 		if (!dio->wait_for_completion)
> 			return -EIOCBQUEUED;
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
> 	}
> 
> 	ret = iomap_dio_complete(dio);
> 
> I finally had time to look into this, and I noticed garbage values for
> dio->submit.waiter in *dio right before we call io_schedule.  I suspect
> this is a use-after-free, so I altered iomap_dio_complete to memset the
> entire structure to 0x5C just prior to kfreeing the *dio, and sure
> enough I saw 0x5C in all the dio fields right before the io_schedule
> call.
> 
> Next I instrumented all the places where we access dio->ref to see
> what's going on, and observed the following sequence:
> 
>  1. ref == 2 just before the blk_finish_plug call.
>     dio->wait_for_completion == false.
>  2. ref == 2 just before the "if (!atomic_dec_and_test(...))"
>  3. ref == 1 just after the "if (!atomic_dec_and_test(...))"
> 
> Next we apparently end up in iomap_dio_bio_end_io:
> 
>  4. ref == 1 just before the "if (atomic_dec_and_test(...))"
>  5. ref == 0 just after the "if (atomic_dec_and_test(...))"
>  6. iomap_dio_bio_end_io calls iomap_dio_complete, frees the dio after
>     poisoning it with 0x5C as described above.
> 
> Then we jump back to iomap_dio_rw, and:
> 
>  7. ref = 0x5c5c5c5c just before the "if (!(iocb->ki_flags & IOCB_HIPRI)...)"
>     However, dio->wait_for_completion is 0x5c5c5c5c so we incorrectly
>     call io_schedule and never wake up.
> 
> KASAN confirms this diagnosis.  I noticed that only ~100us elapse
> between the unplug and the bio endio function being called; I've found
> that I can reproduce this in a qemu vm with a virtio-scsi device backed
> by a tmpfs file on the host.  My guess is that with slower scsi device
> the dispatch would take long enough that iomap_dio_rw would have
> returned -EIOCBQUEUED long before the bio end_io function gets called
> and frees the dio?
> 
> Anyhow, I'm not sure how to fix this.  It's clear that iomap_dio_rw
> can't drop its ref to the dio until it's done using the dio fields.
> It's tempting to change the if (!atomic_dec_and_test()) to a if
> (atomic_read() > 1) and only drop the ref just before returning
> -EIOCBQUEUED or just before calling iomap_dio_complete... but that just
> pushes the livelock to kill_ioctx.

No it doesn't, silly me just had debugging crapola all over iomap.c.

> Brain scrambled, kicking to the list to see if anyone has something
> smarter to say. ;)

I have a gross brainscrambled patch that makes the regression go away.
No idea what other subtle breakage this might cause...

--D

---
 fs/iomap.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index a3088fae567b..cdea2a83ef78 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1535,16 +1535,18 @@ static void iomap_dio_bio_end_io(struct bio *bio)
 {
 	struct iomap_dio *dio = bio->bi_private;
 	bool should_dirty = (dio->flags & IOMAP_DIO_DIRTY);
+	int dio_ref = atomic_dec_return(&dio->ref);
 
 	if (bio->bi_status)
 		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));
 
-	if (atomic_dec_and_test(&dio->ref)) {
-		if (dio->wait_for_completion) {
-			struct task_struct *waiter = dio->submit.waiter;
-			WRITE_ONCE(dio->submit.waiter, NULL);
-			blk_wake_io_task(waiter);
-		} else if (dio->flags & IOMAP_DIO_WRITE) {
+	if (dio_ref == 1 && dio->wait_for_completion) {
+		struct task_struct *waiter = dio->submit.waiter;
+
+		WRITE_ONCE(dio->submit.waiter, NULL);
+		blk_wake_io_task(waiter);
+	} else if (dio_ref == 0) {
+		if (dio->flags & IOMAP_DIO_WRITE) {
 			struct inode *inode = file_inode(dio->iocb->ki_filp);
 
 			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
@@ -1916,9 +1918,12 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (dio->flags & IOMAP_DIO_WRITE_FUA)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
-	if (!atomic_dec_and_test(&dio->ref)) {
-		if (!dio->wait_for_completion)
+	if (atomic_read(&dio->ref) > 1) {
+		if (!dio->wait_for_completion) {
+			if (atomic_dec_and_test(&dio->ref))
+				return iomap_dio_complete(dio);
 			return -EIOCBQUEUED;
+		}
 
 		for (;;) {
 			set_current_state(TASK_UNINTERRUPTIBLE);
@@ -1934,6 +1939,7 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		__set_current_state(TASK_RUNNING);
 	}
 
+	atomic_dec(&dio->ref);
 	ret = iomap_dio_complete(dio);
 
 	return ret;
