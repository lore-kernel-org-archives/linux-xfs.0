Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:35615 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728535AbeKIH4w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 02:56:52 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] iomap: dio data corruption and spurious errors when pipes fill
Date: Fri,  9 Nov 2018 09:19:09 +1100
Message-Id: <20181108221909.27602-3-david@fromorbit.com>
In-Reply-To: <20181108221909.27602-1-david@fromorbit.com>
References: <20181108221909.27602-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When doing direct IO to a pipe for do_splice_direct(), then pipe is
trivial to fill up and overflow as it can only hold 16 pages. At
this point bio_iov_iter_get_pages() then returns -EFAULT, and we
abort the IO submission process. Unfortunately, iomap_dio_rw()
propagates the error back up the stack.

The error is converted from the EFAULT to EAGAIN in
generic_file_splice_read() to tell the splice layers that the pipe
is full. do_splice_direct() completely fails to handle EAGAIN errors
(it aborts on error) and returns EAGAIN to the caller.

copy_file_write() then compeltely fails to handle EAGAIN as well,
and so returns EAGAIN to userspace, having failed to copy the data
it was asked to.

Avoid this whole steaming pile of fail by having iomap_dio_rw()
silently swallow EFAULT errors and so do short reads.

To make matters worse, iomap_dio_actor() has a stale data exposure
bug bio_iov_iter_get_pages() fails - it does not zero the tail block
that it may have been left uncovered by partial IO. Fix the error
handling case to drop to the sub-block zeroing rather than
immmediately returning the -EFAULT error.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 7aacd48c593e..2fda13bc37d8 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1775,7 +1775,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 	struct bio *bio;
 	bool need_zeroout = false;
 	bool use_fua = false;
-	int nr_pages, ret;
+	int nr_pages, ret = 0;
 	size_t copied = 0;
 
 	if ((pos | length | align) & ((1 << blkbits) - 1))
@@ -1839,8 +1839,14 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 
 		ret = bio_iov_iter_get_pages(bio, &iter);
 		if (unlikely(ret)) {
+			/*
+			 * We have to stop part way through an IO. We must fall through
+			 * to the sub-block tail zeroing here, otherwise this
+			 * short IO may expose stale data in the tail of the
+			 * block we haven't written data to.
+			 */
 			bio_put(bio);
-			return copied ? copied : ret;
+			goto zero_tail;
 		}
 
 		n = bio->bi_iter.bi_size;
@@ -1877,6 +1883,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 	 * the block tail in the latter case, we can expose stale data via mmap
 	 * reads of the EOF block.
 	 */
+zero_tail:
 	if (need_zeroout ||
 	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
 		/* zero out from the end of the write to the end of the block */
@@ -1884,7 +1891,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		if (pad)
 			iomap_dio_zero(dio, iomap, pos, fs_block_size - pad);
 	}
-	return copied;
+	return copied ? copied : ret;
 }
 
 static loff_t
@@ -2079,6 +2086,15 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 				dio->wait_for_completion = true;
 				ret = 0;
 			}
+
+			/*
+			 * splicing to pipes can fail on a full pipe. We have to
+			 * swallow this to make it look like a short IO
+			 * otherwise the higher splice layers will completely
+			 * mishandle the error and stop moving data.
+			 */
+			if (ret == -EFAULT)
+				ret = 0;
 			break;
 		}
 		pos += ret;
-- 
2.19.1
