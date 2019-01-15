Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54701 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728336AbfAOS1q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Jan 2019 13:27:46 -0500
Date: Tue, 15 Jan 2019 19:27:45 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: BUG: iomap_dio_rw() accesses freed memory
Message-ID: <20190115182745.GA12295@lst.de>
References: <2762504.H5M01fycxG@localhost.localdomain> <20190110142552.GA9661@lst.de> <1829543.H1xe2kokQy@localhost.localdomain> <20190110170935.GY12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190110170935.GY12689@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Chandan Rajendra <chandan@linux.ibm.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

So after review that thread and this thread I still don't really
see a refcounting problem, just a use after free of the
wait_for_completion member for fast aio completions.

Chandan, can you give this patch a spin?

diff --git a/fs/iomap.c b/fs/iomap.c
index cb184ff68680..47362397cb82 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1813,6 +1813,7 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos, start = pos;
 	loff_t end = iocb->ki_pos + count - 1, ret = 0;
 	unsigned int flags = IOMAP_DIRECT;
+	bool wait_for_completion = is_sync_kiocb(iocb);
 	struct blk_plug plug;
 	struct iomap_dio *dio;
 
@@ -1832,7 +1833,6 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	dio->end_io = end_io;
 	dio->error = 0;
 	dio->flags = 0;
-	dio->wait_for_completion = is_sync_kiocb(iocb);
 
 	dio->submit.iter = iter;
 	dio->submit.waiter = current;
@@ -1887,7 +1887,7 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		dio_warn_stale_pagecache(iocb->ki_filp);
 	ret = 0;
 
-	if (iov_iter_rw(iter) == WRITE && !dio->wait_for_completion &&
+	if (iov_iter_rw(iter) == WRITE && !wait_for_completion &&
 	    !inode->i_sb->s_dio_done_wq) {
 		ret = sb_init_dio_done_wq(inode->i_sb);
 		if (ret < 0)
@@ -1903,7 +1903,7 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		if (ret <= 0) {
 			/* magic error code to fall back to buffered I/O */
 			if (ret == -ENOTBLK) {
-				dio->wait_for_completion = true;
+				wait_for_completion = true;
 				ret = 0;
 			}
 			break;
@@ -1925,8 +1925,24 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (dio->flags & IOMAP_DIO_WRITE_FUA)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
+	/*
+	 * We are about to drop our additional submission reference, which
+	 * might be the last reference to the dio.  There are three three
+	 * different ways we can progress here:
+	 *
+	 *  (a) If this is the last reference we will always complete and free
+	 *	the dio ourselves. right here.
+	 *  (b) If this is not the last reference, and we serve an asynchronous
+	 *	iocb, we must never touch the dio after the decrement, the
+	 *	I/O completion handler will complete and free it.
+	 *  (c) If this is not the last reference, but we serve a synchronous
+	 *	iocb, the I/O completion handler will wake us up on the drop
+	 *	of the final reference, and we will complete and free it here
+	 *	after we got woken by the I/O completion handler.
+	 */
+	dio->wait_for_completion = wait_for_completion;
 	if (!atomic_dec_and_test(&dio->ref)) {
-		if (!dio->wait_for_completion)
+		if (!wait_for_completion)
 			return -EIOCBQUEUED;
 
 		for (;;) {
@@ -1943,9 +1959,7 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		__set_current_state(TASK_RUNNING);
 	}
 
-	ret = iomap_dio_complete(dio);
-
-	return ret;
+	return iomap_dio_complete(dio);
 
 out_free_dio:
 	kfree(dio);
