Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbeK1Own (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 09:52:43 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v1 4/7] xfs: Add b_rw_hint to xfs_buf
Date: Tue, 27 Nov 2018 20:49:48 -0700
Message-Id: <1543376991-5764-5-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com, allison.henderson@oracle.com

This patch adds a new field b_rw_hint to xfs_buf.  We will
need this to properly initialize the new bio->bi_rw_hint when
submitting the read request.  When the read completes, we
then store the returned mirror in the b_rw_hint.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_buf.c | 5 ++++-
 fs/xfs/xfs_buf.h | 7 +++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b21ea2b..dd8ba59 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1322,8 +1322,10 @@ xfs_buf_bio_end_io(
 	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
 
-	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
+	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
+		bp->b_rw_hint = bio->bi_rw_hint;
 		xfs_buf_ioend_async(bp);
+	}
 	bio_put(bio);
 }
 
@@ -1369,6 +1371,7 @@ xfs_buf_ioapply_map(
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
+	bio->bi_rw_hint = bp->b_rw_hint;
 	bio_set_op_attrs(bio, op, op_flags);
 
 	for (; size && nr_pages; nr_pages--, page_index++) {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b9f5511..db138e5 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -197,6 +197,13 @@ typedef struct xfs_buf {
 	unsigned long		b_first_retry_time; /* in jiffies */
 	int			b_last_error;
 
+	/*
+	 * If b_rw_hint is set before a read, it specifies an alternate mirror
+	 * to read from.  Upon bio completion, b_rw_hint stores the last mirror
+	 * that was read from
+	 */
+	unsigned short		b_rw_hint;
+
 	const struct xfs_buf_ops	*b_ops;
 } xfs_buf_t;
 
-- 
2.7.4
