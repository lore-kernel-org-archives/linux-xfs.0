Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40840 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932547AbeFFKks (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jun 2018 06:40:48 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] iomap: complete partial direct I/O writes synchronously
Date: Wed,  6 Jun 2018 12:40:31 +0200
Message-Id: <20180606104033.4947-5-hch@lst.de>
In-Reply-To: <20180606104033.4947-1-hch@lst.de>
References: <20180606104033.4947-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

According to xfstest generic/240, applications seem to expect direct I/O
writes to either complete as a whole or to fail; short direct I/O writes
are apparently not appreciated.  This means that when only part of an
asynchronous direct I/O write succeeds, we can either fail the entire
write, or we can wait for the partial write to complete and retry the
remaining write as buffered I/O.  The old __blockdev_direct_IO helper
has code for waiting for partial writes to complete; the new
iomap_dio_rw iomap helper does not.

The above mentioned fallback mode is needed for gfs2, which doesn't
allow block allocations under direct I/O to avoid taking cluster-wide
exclusive locks.  As a consequence, an asynchronous direct I/O write to
a file range that contains a hole will result in a short write.  In that
case, wait for the short write to complete to allow gfs2 to recover.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 206539d369a8..f428baa32185 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -811,6 +811,7 @@ struct iomap_dio {
 	atomic_t		ref;
 	unsigned		flags;
 	int			error;
+	bool			wait_for_completion;
 
 	union {
 		/* used during submission and for synchronous completion: */
@@ -914,9 +915,8 @@ static void iomap_dio_bio_end_io(struct bio *bio)
 		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));
 
 	if (atomic_dec_and_test(&dio->ref)) {
-		if (is_sync_kiocb(dio->iocb)) {
+		if (dio->wait_for_completion) {
 			struct task_struct *waiter = dio->submit.waiter;
-
 			WRITE_ONCE(dio->submit.waiter, NULL);
 			wake_up_process(waiter);
 		} else if (dio->flags & IOMAP_DIO_WRITE) {
@@ -1130,13 +1130,12 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	dio->end_io = end_io;
 	dio->error = 0;
 	dio->flags = 0;
+	dio->wait_for_completion = is_sync_kiocb(iocb);
 
 	dio->submit.iter = iter;
-	if (is_sync_kiocb(iocb)) {
-		dio->submit.waiter = current;
-		dio->submit.cookie = BLK_QC_T_NONE;
-		dio->submit.last_queue = NULL;
-	}
+	dio->submit.waiter = current;
+	dio->submit.cookie = BLK_QC_T_NONE;
+	dio->submit.last_queue = NULL;
 
 	if (iov_iter_rw(iter) == READ) {
 		if (pos >= dio->i_size)
@@ -1186,7 +1185,7 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		dio_warn_stale_pagecache(iocb->ki_filp);
 	ret = 0;
 
-	if (iov_iter_rw(iter) == WRITE && !is_sync_kiocb(iocb) &&
+	if (iov_iter_rw(iter) == WRITE && !dio->wait_for_completion &&
 	    !inode->i_sb->s_dio_done_wq) {
 		ret = sb_init_dio_done_wq(inode->i_sb);
 		if (ret < 0)
@@ -1201,8 +1200,10 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 				iomap_dio_actor);
 		if (ret <= 0) {
 			/* magic error code to fall back to buffered I/O */
-			if (ret == -ENOTBLK)
+			if (ret == -ENOTBLK) {
+				dio->wait_for_completion = true;
 				ret = 0;
+			}
 			break;
 		}
 		pos += ret;
@@ -1223,7 +1224,7 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
 	if (!atomic_dec_and_test(&dio->ref)) {
-		if (!is_sync_kiocb(iocb))
+		if (!dio->wait_for_completion)
 			return -EIOCBQUEUED;
 
 		for (;;) {
-- 
2.14.2

