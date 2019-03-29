Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35370 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729046AbfC2OZO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 10:25:14 -0400
From: Bob Liu <bob.liu@oracle.com>
Subject: [PATCH v3 3/3] fs: xfs: add read_verifier() function
Date: Fri, 29 Mar 2019 22:23:46 +0800
Message-Id: <20190329142346.1677-4-bob.liu@oracle.com>
In-Reply-To: <20190329142346.1677-1-bob.liu@oracle.com>
References: <20190329142346.1677-1-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, axboe@kernel.dk, tytso@mit.edu, Bob Liu <bob.liu@oracle.com>

This patch adds an new read_verifier function and pass to
the block layer to verify reads.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 fs/xfs/xfs_buf.c | 23 +++++++++++++++++++++--
 fs/xfs/xfs_buf.h |  1 +
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4f5f2ff3f70f..f3185dd9a557 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1243,7 +1243,8 @@ xfs_buf_ioend(
 		xfs_buf_ioerror(bp, bp->b_io_error);
 
 	/* Only validate buffers that were read without errors */
-	if (read && !bp->b_error && bp->b_ops) {
+	if (read && !bp->b_error && bp->b_ops &&
+	    !(bp->b_flags & _XBF_NOVERIFY)) {
 		ASSERT(!bp->b_iodone);
 		bp->b_ops->verify_read(bp);
 	}
@@ -1343,6 +1344,24 @@ xfs_buf_bio_end_io(
 	bio_put(bio);
 }
 
+int read_verifier(struct bio *bio)
+{
+	struct xfs_buf *bp = (struct xfs_buf *)bio->bi_private;
+
+	if (bp && !bp->b_error && bp->b_ops && bp->b_ops->verify_read) {
+		if (xfs_buf_is_vmapped(bp))
+			invalidate_kernel_vmap_range(bp->b_addr,
+						     xfs_buf_vmap_len(bp));
+		bp->b_ops->verify_read(bp);
+		/* set bit so that endio won't verify it again */
+		if (!bp->b_error)
+			bp->b_flags |= _XBF_NOVERIFY;
+		return bp->b_error;
+	} else {
+		return 0;
+	}
+}
+
 static void
 xfs_buf_ioapply_map(
 	struct xfs_buf	*bp,
@@ -1409,7 +1428,7 @@ xfs_buf_ioapply_map(
 			flush_kernel_vmap_range(bp->b_addr,
 						xfs_buf_vmap_len(bp));
 		}
-		submit_bio(bio);
+		submit_bio_verify(bio, &read_verifier);
 		if (size)
 			goto next_chunk;
 	} else {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b9f5511ea998..499637c61001 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -50,6 +50,7 @@ typedef enum {
 #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
 #define _XBF_COMPOUND	 (1 << 23)/* compound buffer */
+#define _XBF_NOVERIFY	 (1 << 24)/* verify_read should not be called */
 
 typedef unsigned int xfs_buf_flags_t;
 
-- 
2.17.1
