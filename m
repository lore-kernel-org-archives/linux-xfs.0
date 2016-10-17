Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758961AbcJQUWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 16:22:45 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] xfs: merge discard requests
Date: Mon, 17 Oct 2016 22:22:33 +0200
Message-Id: <1476735753-5861-4-git-send-email-hch@lst.de>
In-Reply-To: <1476735753-5861-1-git-send-email-hch@lst.de>
References: <1476735753-5861-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: michaelcallahan@fb.com

We often have multiple busy extent entries that are adjacent.  Merge them
before calling __blkdev_issue_discard to give the drive larger request.

To allow for better merging the busy extent sort function is also updated
to sort for the full block number and not just the AG number.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extent_busy.c | 12 ++++++++----
 fs/xfs/xfs_log_cil.c     | 44 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 162dc18..50c277e 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -596,9 +596,13 @@ xfs_extent_busy_clear(
 int
 xfs_extent_busy_ag_cmp(
 	void			*priv,
-	struct list_head	*a,
-	struct list_head	*b)
+	struct list_head	*l1,
+	struct list_head	*l2)
 {
-	return container_of(a, struct xfs_extent_busy, list)->agno -
-		container_of(b, struct xfs_extent_busy, list)->agno;
+	struct xfs_extent_busy	*b1 =
+		container_of(l1, struct xfs_extent_busy, list);
+	struct xfs_extent_busy	*b2 =
+		container_of(l2, struct xfs_extent_busy, list);
+
+	return b1->agno - b2->agno || b1->bno - b2->bno;
 }
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 82f1cbc..c30b19f 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -526,11 +526,14 @@ xlog_discard_busy_extents(
 	struct xfs_mount	*mp,
 	struct xfs_cil_ctx	*ctx)
 {
+	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
 	struct list_head	*list = &ctx->busy_extents;
 	struct xfs_extent_busy	*busyp;
 	struct bio		*bio = NULL;
 	struct blk_plug		plug;
 	int			error = 0;
+	bool			have_prev = false;
+	sector_t		bno, len, prev_bno, prev_len;
 
 	ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
 
@@ -539,18 +542,37 @@ xlog_discard_busy_extents(
 		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
 					 busyp->length);
 
-		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
-				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
-				XFS_FSB_TO_BB(mp, busyp->length),
-				GFP_NOFS, 0, &bio);
-		if (error && error != -EOPNOTSUPP) {
-			xfs_info(mp,
-	 "discard failed for extent [0x%llx,%u], error %d",
-				 (unsigned long long)busyp->bno,
-				 busyp->length,
-				 error);
-			break;
+		bno = XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno);
+		len = XFS_FSB_TO_BB(mp, busyp->length);
+
+		if (have_prev) {
+			if (prev_bno + prev_len == bno) {
+				prev_len += len;
+				continue;
+			}
+
+			error = __blkdev_issue_discard(bdev, prev_bno, prev_len,
+					GFP_NOFS, 0, &bio);
+			if (error && error != -EOPNOTSUPP)
+				goto done;
 		}
+
+		prev_bno = bno;
+		prev_len = len;
+		have_prev = true;
+	}
+
+	if (have_prev) {
+		error = __blkdev_issue_discard(bdev, prev_bno, prev_len,
+				GFP_NOFS, 0, &bio);
+	}
+
+done:
+	if (error && error != -EOPNOTSUPP) {
+		xfs_info(mp,
+			"discard failed for extent [0x%llx,0x%llx], error %d",
+			(unsigned long long)bno, (unsigned long long)len,
+			error);
 	}
 
 	if (bio) {
-- 
2.1.4

