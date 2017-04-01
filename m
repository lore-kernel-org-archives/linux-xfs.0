Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34244 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbdDAGgt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Apr 2017 02:36:49 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/26] xfs: only reclaim unwritten COW extents periodically
Date: Sat,  1 Apr 2017 08:35:08 +0200
Message-Id: <20170401063512.25313-23-hch@lst.de>
In-Reply-To: <20170401063512.25313-1-hch@lst.de>
References: <20170401063512.25313-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit 3802a345321a08093ba2ddb1849e736f84e8d450 upstream.

We only want to reclaim preallocations from our periodic work item.
Currently this is archived by looking for a dirty inode, but that check
is rather fragile.  Instead add a flag to xfs_reflink_cancel_cow_* so
that the caller can ask for just cancelling unwritten extents in the COW
fork.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix typos in commit message]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    |  2 +-
 fs/xfs/xfs_icache.c  |  2 +-
 fs/xfs/xfs_inode.c   |  2 +-
 fs/xfs/xfs_reflink.c | 23 ++++++++++++++++-------
 fs/xfs/xfs_reflink.h |  4 ++--
 fs/xfs/xfs_super.c   |  2 +-
 6 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1ff9df7a3ce8..407d840c5c16 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -293,7 +293,7 @@ xfs_end_io(
 			goto done;
 		if (ioend->io_bio->bi_error) {
 			error = xfs_reflink_cancel_cow_range(ip,
-					ioend->io_offset, ioend->io_size);
+					ioend->io_offset, ioend->io_size, true);
 			goto done;
 		}
 		error = xfs_reflink_end_cow(ip, ioend->io_offset,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7234b9748c36..3531f8f72fa5 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1608,7 +1608,7 @@ xfs_inode_free_cowblocks(
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 
-	ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF);
+	ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
 
 	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index edfa6a55b064..7eaf1ef74e3c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1615,7 +1615,7 @@ xfs_itruncate_extents(
 
 	/* Remove all pending CoW reservations. */
 	error = xfs_reflink_cancel_cow_blocks(ip, &tp, first_unmap_block,
-			last_block);
+			last_block, true);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 22d631b08ee4..a72cd2e3c048 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -549,14 +549,18 @@ xfs_reflink_trim_irec_to_next_cow(
 }
 
 /*
- * Cancel all pending CoW reservations for some block range of an inode.
+ * Cancel CoW reservations for some block range of an inode.
+ *
+ * If cancel_real is true this function cancels all COW fork extents for the
+ * inode; if cancel_real is false, real extents are not cleared.
  */
 int
 xfs_reflink_cancel_cow_blocks(
 	struct xfs_inode		*ip,
 	struct xfs_trans		**tpp,
 	xfs_fileoff_t			offset_fsb,
-	xfs_fileoff_t			end_fsb)
+	xfs_fileoff_t			end_fsb,
+	bool				cancel_real)
 {
 	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec		got, del;
@@ -580,7 +584,7 @@ xfs_reflink_cancel_cow_blocks(
 					&idx, &got, &del);
 			if (error)
 				break;
-		} else {
+		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
 			xfs_trans_ijoin(*tpp, ip, 0);
 			xfs_defer_init(&dfops, &firstfsb);
 
@@ -622,13 +626,17 @@ xfs_reflink_cancel_cow_blocks(
 }
 
 /*
- * Cancel all pending CoW reservations for some byte range of an inode.
+ * Cancel CoW reservations for some byte range of an inode.
+ *
+ * If cancel_real is true this function cancels all COW fork extents for the
+ * inode; if cancel_real is false, real extents are not cleared.
  */
 int
 xfs_reflink_cancel_cow_range(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		count)
+	xfs_off_t		count,
+	bool			cancel_real)
 {
 	struct xfs_trans	*tp;
 	xfs_fileoff_t		offset_fsb;
@@ -654,7 +662,8 @@ xfs_reflink_cancel_cow_range(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/* Scrape out the old CoW reservations */
-	error = xfs_reflink_cancel_cow_blocks(ip, &tp, offset_fsb, end_fsb);
+	error = xfs_reflink_cancel_cow_blocks(ip, &tp, offset_fsb, end_fsb,
+			cancel_real);
 	if (error)
 		goto out_cancel;
 
@@ -1451,7 +1460,7 @@ xfs_reflink_clear_inode_flag(
 	 * We didn't find any shared blocks so turn off the reflink flag.
 	 * First, get rid of any leftover CoW mappings.
 	 */
-	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF);
+	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF, true);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 1583c4727cb1..b715bacb2ea2 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -39,9 +39,9 @@ extern void xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
 
 extern int xfs_reflink_cancel_cow_blocks(struct xfs_inode *ip,
 		struct xfs_trans **tpp, xfs_fileoff_t offset_fsb,
-		xfs_fileoff_t end_fsb);
+		xfs_fileoff_t end_fsb, bool cancel_real);
 extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
-		xfs_off_t count);
+		xfs_off_t count, bool cancel_real);
 extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index eecbaac08eba..d80187b0e726 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -953,7 +953,7 @@ xfs_fs_destroy_inode(
 	XFS_STATS_INC(ip->i_mount, vn_remove);
 
 	if (xfs_is_reflink_inode(ip)) {
-		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF);
+		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
 		if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount))
 			xfs_warn(ip->i_mount,
 "Error %d while evicting CoW blocks for inode %llu.",
-- 
2.11.0

