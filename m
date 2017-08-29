Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754535AbdH2Oh7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Aug 2017 10:37:59 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A556C8A004
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2017 14:37:59 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7046918B37
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2017 14:37:59 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/9] xfs: remove unnecessary dirty bli format check for ordered bufs
Date: Tue, 29 Aug 2017 10:37:51 -0400
Message-Id: <20170829143758.58990-3-bfoster@redhat.com>
In-Reply-To: <20170829143758.58990-1-bfoster@redhat.com>
References: <20170829143758.58990-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_buf_item_unlock() historically checked the dirty state of the
buffer by manually checking the buffer log formats for dirty
segments. The introduction of ordered buffers invalidated this check
because ordered buffers have dirty bli's but no dirty (logged)
segments. The check was updated to accommodate ordered buffers by
looking at the bli state first and considering the blf only if the
bli is clean.

This logic is safe but unnecessary. There is no valid case where the
bli is clean yet the blf has dirty segments. The bli is set dirty
whenever the blf is logged (via xfs_trans_log_buf()) and the blf is
cleared in the only place BLI_DIRTY is cleared (xfs_trans_binval()).

Remove the conditional blf dirty checks and replace with an assert
that should catch any discrepencies between bli and blf dirty
states. Refactor the old blf dirty check into a helper function to
be used by the assert.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 62 ++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_buf_item.h |  1 +
 2 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index cdae0ad5e0..ff076d1 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -575,26 +575,18 @@ xfs_buf_item_unlock(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	bool			clean;
-	bool			aborted;
-	int			flags;
+	bool			aborted = !!(lip->li_flags & XFS_LI_ABORTED);
+	bool			hold = !!(bip->bli_flags & XFS_BLI_HOLD);
+	bool			dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
+	bool			ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
 
 	/* Clear the buffer's association with this transaction. */
 	bp->b_transp = NULL;
 
 	/*
-	 * If this is a transaction abort, don't return early.  Instead, allow
-	 * the brelse to happen.  Normally it would be done for stale
-	 * (cancelled) buffers at unpin time, but we'll never go through the
-	 * pin/unpin cycle if we abort inside commit.
+	 * The per-transaction state has been copied above so clear it from the
+	 * bli.
 	 */
-	aborted = (lip->li_flags & XFS_LI_ABORTED) ? true : false;
-	/*
-	 * Before possibly freeing the buf item, copy the per-transaction state
-	 * so we can reference it safely later after clearing it from the
-	 * buffer log item.
-	 */
-	flags = bip->bli_flags;
 	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
 
 	/*
@@ -602,7 +594,7 @@ xfs_buf_item_unlock(
 	 * unlock the buffer and free the buf item when the buffer is unpinned
 	 * for the last time.
 	 */
-	if (flags & XFS_BLI_STALE) {
+	if (bip->bli_flags & XFS_BLI_STALE) {
 		trace_xfs_buf_item_unlock_stale(bip);
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 		if (!aborted) {
@@ -620,20 +612,11 @@ xfs_buf_item_unlock(
 	 * regardless of whether it is dirty or not. A dirty abort implies a
 	 * shutdown, anyway.
 	 *
-	 * Ordered buffers are dirty but may have no recorded changes, so ensure
-	 * we only release clean items here.
+	 * The bli dirty state should match whether the blf has logged segments
+	 * except for ordered buffers, where only the bli should be dirty.
 	 */
-	clean = (flags & XFS_BLI_DIRTY) ? false : true;
-	if (clean) {
-		int i;
-		for (i = 0; i < bip->bli_format_count; i++) {
-			if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
-				     bip->bli_formats[i].blf_map_size)) {
-				clean = false;
-				break;
-			}
-		}
-	}
+	ASSERT((!ordered && dirty == xfs_buf_item_dirty_format(bip)) ||
+	       (ordered && dirty && !xfs_buf_item_dirty_format(bip)));
 
 	/*
 	 * Clean buffers, by definition, cannot be in the AIL. However, aborted
@@ -652,11 +635,11 @@ xfs_buf_item_unlock(
 			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
 			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
-		} else if (clean)
+		} else if (!dirty)
 			xfs_buf_item_relse(bp);
 	}
 
-	if (!(flags & XFS_BLI_HOLD))
+	if (!hold)
 		xfs_buf_relse(bp);
 }
 
@@ -945,6 +928,25 @@ xfs_buf_item_log(
 }
 
 
+/*
+ * Return true if the buffer has any ranges logged/dirtied by a transaction,
+ * false otherwise.
+ */
+bool
+xfs_buf_item_dirty_format(
+	struct xfs_buf_log_item	*bip)
+{
+	int			i;
+
+	for (i = 0; i < bip->bli_format_count; i++) {
+		if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
+			     bip->bli_formats[i].blf_map_size))
+			return true;
+	}
+
+	return false;
+}
+
 STATIC void
 xfs_buf_item_free(
 	xfs_buf_log_item_t	*bip)
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index e0e744a..9690ce6 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -64,6 +64,7 @@ typedef struct xfs_buf_log_item {
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_relse(struct xfs_buf *);
 void	xfs_buf_item_log(xfs_buf_log_item_t *, uint, uint);
+bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_attach_iodone(struct xfs_buf *,
 			      void(*)(struct xfs_buf *, xfs_log_item_t *),
 			      xfs_log_item_t *);
-- 
2.9.5

