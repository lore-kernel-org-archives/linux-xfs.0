Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35140 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfAQH5L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 02:57:11 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] iomap: fix a use after free in iomap_dio_rw
Date: Thu, 17 Jan 2019 08:57:07 +0100
Message-Id: <20190117075707.8640-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Chandan Rajendra <chandan@linux.ibm.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

Introduce a local wait_for_completion variable to avoid an access to the
potentially freed dio struture after dropping the last reference count.

Also use the chance to document the completion behavior to make the
refcounting clear to the reader of the code.

Fixes: ff6a9292e6 ("iomap: implement direct I/O")
Reported-by: Chandan Rajendra <chandan@linux.ibm.com>
Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Chandan Rajendra <chandan@linux.ibm.com>
Tested-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

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
-- 
2.20.1
