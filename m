Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38190 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdB1Atz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2017 19:49:55 -0500
Received: from [8.25.222.2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1ciVzD-00061X-EF
        for linux-xfs@vger.kernel.org; Tue, 28 Feb 2017 00:49:51 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: fix and streamline error handling in xfs_end_io
Date: Mon, 27 Feb 2017 16:49:50 -0800
Message-Id: <20170228004950.9609-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

There are two different cases of buffered I/O errors:

 - first we can have an already shutdown fs.  In that case we should skip
   any on-disk operations and just clean up the appen transaction if
   present and destroy the ioend
 - a real I/O error.  In that case we should cleanup any lingering COW
   blocks.  This gets skipped in the current code and is fixed by this
   patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 59 +++++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 290c0fb306e7..fe244648fff0 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -274,54 +274,49 @@ xfs_end_io(
 	struct xfs_ioend	*ioend =
 		container_of(work, struct xfs_ioend, io_work);
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	xfs_off_t		offset = ioend->io_offset;
+	size_t			size = ioend->io_size;
 	int			error = ioend->io_bio->bi_error;
 
 	/*
-	 * Set an error if the mount has shut down and proceed with end I/O
-	 * processing so it can perform whatever cleanups are necessary.
+	 * Just clean up the in-memory strutures if the fs has been shut down.
 	 */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		error = -EIO;
+		goto done;
+	}
 
 	/*
-	 * For a CoW extent, we need to move the mapping from the CoW fork
-	 * to the data fork.  If instead an error happened, just dump the
-	 * new blocks.
+	 * Clean up any COW blocks on an I/O error.
 	 */
-	if (ioend->io_type == XFS_IO_COW) {
-		if (error)
-			goto done;
-		if (ioend->io_bio->bi_error) {
-			error = xfs_reflink_cancel_cow_range(ip,
-					ioend->io_offset, ioend->io_size, 0);
-			goto done;
+	if (unlikely(error)) {
+		switch (ioend->io_type) {
+		case XFS_IO_COW:
+			xfs_reflink_cancel_cow_range(ip, offset, size, 0);
+			break;
 		}
-		error = xfs_reflink_end_cow(ip, ioend->io_offset,
-				ioend->io_size);
-		if (error)
-			goto done;
+
+		goto done;
 	}
 
 	/*
-	 * For unwritten extents we need to issue transactions to convert a
-	 * range to normal written extens after the data I/O has finished.
-	 * Detecting and handling completion IO errors is done individually
-	 * for each case as different cleanup operations need to be performed
-	 * on error.
+	 * Success:  commit the COW or unwritten blocks if needed.
 	 */
-	if (ioend->io_type == XFS_IO_UNWRITTEN) {
-		if (error)
-			goto done;
-		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
-						  ioend->io_size);
-	} else if (ioend->io_append_trans) {
-		error = xfs_setfilesize_ioend(ioend, error);
-	} else {
-		ASSERT(!xfs_ioend_is_append(ioend) ||
-		       ioend->io_type == XFS_IO_COW);
+	switch (ioend->io_type) {
+	case XFS_IO_COW:
+		error = xfs_reflink_end_cow(ip, offset, size);
+		break;
+	case XFS_IO_UNWRITTEN:
+		error = xfs_iomap_write_unwritten(ip, offset, size);
+		break;
+	default:
+		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_append_trans);
+		break;
 	}
 
 done:
+	if (ioend->io_append_trans)
+		error = xfs_setfilesize_ioend(ioend, error);
 	xfs_destroy_ioend(ioend, error);
 }
 
-- 
2.11.0

