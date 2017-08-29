Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754544AbdH2OiA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Aug 2017 10:38:00 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 19D257E435
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2017 14:38:00 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDD986FF01
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2017 14:37:59 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 5/9] xfs: don't log dirty ranges for ordered buffers
Date: Tue, 29 Aug 2017 10:37:54 -0400
Message-Id: <20170829143758.58990-6-bfoster@redhat.com>
In-Reply-To: <20170829143758.58990-1-bfoster@redhat.com>
References: <20170829143758.58990-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Ordered buffers are attached to transactions and pushed through the
logging infrastructure just like normal buffers with the exception
that they are not actually written to the log. Therefore, we don't
need to log dirty ranges of ordered buffers. xfs_trans_log_buf() is
called on ordered buffers to set up all of the dirty state on the
transaction, buffer and log item and prepare the buffer for I/O.

Now that xfs_trans_dirty_buf() is available, call it from
xfs_trans_ordered_buf() so the latter is now mutually exclusive with
xfs_trans_log_buf(). This reflects the implementation of ordered
buffers and helps eliminate confusion over the need to log ranges of
ordered buffers just to set up internal log state.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree.c  |  6 ++----
 fs/xfs/libxfs/xfs_ialloc.c |  2 --
 fs/xfs/xfs_trans_buf.c     | 26 ++++++++++++++------------
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index e0bcc4a..0b7905a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4464,12 +4464,10 @@ xfs_btree_block_change_owner(
 	 * though, so everything is consistent in memory.
 	 */
 	if (bp) {
-		if (cur->bc_tp) {
+		if (cur->bc_tp)
 			xfs_trans_ordered_buf(cur->bc_tp, bp);
-			xfs_btree_log_block(cur, bp, XFS_BB_OWNER);
-		} else {
+		else
 			xfs_buf_delwri_queue(bp, bbcoi->buffer_list);
-		}
 	} else {
 		ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
 		ASSERT(level == cur->bc_nlevels - 1);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 1e0658a..988bb3f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -378,8 +378,6 @@ xfs_ialloc_inode_init(
 				 * transaction and pin the log appropriately.
 				 */
 				xfs_trans_ordered_buf(tp, fbuf);
-				xfs_trans_log_buf(tp, fbuf, 0,
-						  BBTOB(fbuf->b_length) - 1);
 			}
 		} else {
 			fbuf->b_flags |= XBF_DONE;
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 8c99813..3089e80 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -560,16 +560,12 @@ xfs_trans_log_buf(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
 	ASSERT(first <= last && last < BBTOB(bp->b_length));
+	ASSERT(!(bip->bli_flags & XFS_BLI_ORDERED));
 
 	xfs_trans_dirty_buf(tp, bp);
 
-	/*
-	 * If we have an ordered buffer we are not logging any dirty range but
-	 * it still needs to be marked dirty and that it has been logged.
-	 */
 	trace_xfs_trans_log_buf(bip);
-	if (!(bip->bli_flags & XFS_BLI_ORDERED))
-		xfs_buf_item_log(bip, first, last);
+	xfs_buf_item_log(bip, first, last);
 }
 
 
@@ -722,12 +718,11 @@ xfs_trans_inode_alloc_buf(
 }
 
 /*
- * Mark the buffer as ordered for this transaction. This means
- * that the contents of the buffer are not recorded in the transaction
- * but it is tracked in the AIL as though it was. This allows us
- * to record logical changes in transactions rather than the physical
- * changes we make to the buffer without changing writeback ordering
- * constraints of metadata buffers.
+ * Mark the buffer as ordered for this transaction. This means that the contents
+ * of the buffer are not recorded in the transaction but it is tracked in the
+ * AIL as though it was. This allows us to record logical changes in
+ * transactions rather than the physical changes we make to the buffer without
+ * changing writeback ordering constraints of metadata buffers.
  */
 void
 xfs_trans_ordered_buf(
@@ -739,9 +734,16 @@ xfs_trans_ordered_buf(
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+	ASSERT(!xfs_buf_item_dirty_format(bip));
 
 	bip->bli_flags |= XFS_BLI_ORDERED;
 	trace_xfs_buf_item_ordered(bip);
+
+	/*
+	 * We don't log a dirty range of an ordered buffer but it still needs
+	 * to be marked dirty and that it has been logged.
+	 */
+	xfs_trans_dirty_buf(tp, bp);
 }
 
 /*
-- 
2.9.5

