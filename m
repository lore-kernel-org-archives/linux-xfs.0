Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53302 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387821AbfBMJxp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 04:53:45 -0500
From: Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH v2 6/9] xfs: Add b_rd_hint to xfs_buf
Date: Wed, 13 Feb 2019 17:50:41 +0800
Message-Id: <20190213095044.29628-7-bob.liu@oracle.com>
In-Reply-To: <20190213095044.29628-1-bob.liu@oracle.com>
References: <20190213095044.29628-1-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a new field b_rd_hint to xfs_buf.  We will
need this to properly initialize the new bio->bi_rw_hint when
submitting the read request.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_buf.c |  6 +++++-
 fs/xfs/xfs_buf.h | 12 ++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e2683c8e868c..6098195ecaf4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1338,8 +1338,11 @@ xfs_buf_bio_end_io(
 	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
 
-	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
+	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
+		if (bp->b_flags & XBF_RW_HINT)
+			bitmap_copy(bp->b_rd_hint, bio->bi_rd_hint, BLKDEV_MAX_MIRRORS);
 		xfs_buf_ioend_async(bp);
+	}
 	bio_put(bio);
 }
 
@@ -1385,6 +1388,7 @@ xfs_buf_ioapply_map(
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
+	bitmap_copy(bio->bi_rd_hint, bp->b_rd_hint, BLKDEV_MAX_MIRRORS);
 	bio_set_op_attrs(bio, op, op_flags);
 
 	for (; size && nr_pages; nr_pages--, page_index++) {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 989b97a17486..af9bdff29e66 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -40,6 +40,7 @@ typedef enum {
 #define XBF_SYNCIO	 (1 << 10)/* treat this buffer as synchronous I/O */
 #define XBF_FUA		 (1 << 11)/* force cache write through mode */
 #define XBF_FLUSH	 (1 << 12)/* flush the disk cache before a write */
+#define XBF_RW_HINT	 (1 << 13)/* Read/write hint used for alt dev retry */
 
 /* flags used only as arguments to access routines */
 #define XBF_TRYLOCK	 (1 << 16)/* lock requested, but do not wait */
@@ -65,6 +66,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_SYNCIO,		"SYNCIO" }, \
 	{ XBF_FUA,		"FUA" }, \
 	{ XBF_FLUSH,		"FLUSH" }, \
+	{ XBF_RW_HINT,		"RW_HINT" }, \
 	{ XBF_TRYLOCK,		"TRYLOCK" },	/* should never be set */\
 	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
@@ -197,6 +199,16 @@ typedef struct xfs_buf {
 	unsigned long		b_first_retry_time; /* in jiffies */
 	int			b_last_error;
 
+	/*
+	 * Bitmask used by block device for alternate device retry
+	 *
+	 * To retry a read with the next device, resubmit the bio with
+	 * the bi_rd_hint returned from the last read.
+	 * Otherwise use bitmap_zero() if we don't care about alt mirror
+	 * device retry.
+         */
+	DECLARE_BITMAP(b_rd_hint, BLKDEV_MAX_MIRRORS);
+
 	const struct xfs_buf_ops	*b_ops;
 	bool			b_alt_retry;	/* toggle alt device retry */
 } xfs_buf_t;
-- 
2.17.1
