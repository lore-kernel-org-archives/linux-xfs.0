Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51272 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933367AbdCHAWN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 19:22:13 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] xfs: only reclaim unwritten COW extents periodically
Date: Tue,  7 Mar 2017 16:22:06 -0800
Message-Id: <20170308002206.17274-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

We only want to reclaim preallocations from our periodic work item.
Currenrly this is archived by looking for a diry inode, but that check
is rather fragile.  Instead add a flag to xfs_reflink_cancel_cow_* so
that the caller can ask for just cancelling unwritten extents in the COw
fork.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

 fs/xfs/xfs_aops.c    |  2 +-
 fs/xfs/xfs_icache.c  |  2 +-
 fs/xfs/xfs_inode.c   |  2 +-
 fs/xfs/xfs_reflink.c | 21 ++++++++++++++-------
 fs/xfs/xfs_reflink.h |  4 ++--
 fs/xfs/xfs_super.c   |  2 +-
 6 files changed, 20 insertions(+), 13 deletions(-)

Changes since V1:
 - use a bool instead of a flags field, better comments

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index bf65a9ea8642..aa8a6f0d09c3 100644
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
index da6d08fb359c..1df9f10a7eea 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -548,14 +548,17 @@ xfs_reflink_trim_irec_to_next_cow(
 }
 
 /*
- * Cancel all pending CoW reservations for some block range of an inode.
+ * Cancel CoW reservations for some block range of an inode.
+ * If cancel_all is true this function cancels all COW fork extents for the
+ * inode, if cancel_all is false only unwritten extents are cancelled.
  */
 int
 xfs_reflink_cancel_cow_blocks(
 	struct xfs_inode		*ip,
 	struct xfs_trans		**tpp,
 	xfs_fileoff_t			offset_fsb,
-	xfs_fileoff_t			end_fsb)
+	xfs_fileoff_t			end_fsb,
+	bool				cancel_all)
 {
 	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec		got, del;
@@ -579,7 +582,7 @@ xfs_reflink_cancel_cow_blocks(
 					&idx, &got, &del);
 			if (error)
 				break;
-		} else {
+		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_all) {
 			xfs_trans_ijoin(*tpp, ip, 0);
 			xfs_defer_init(&dfops, &firstfsb);
 
@@ -621,13 +624,16 @@ xfs_reflink_cancel_cow_blocks(
 }
 
 /*
- * Cancel all pending CoW reservations for some byte range of an inode.
+ * Cancel CoW reservations for some byte range of an inode.
+ * If cancel_all is true this function cancels all COW fork extents for the
+ * inode, if cancel_all is false only unwritten extents are cancelled.
  */
 int
 xfs_reflink_cancel_cow_range(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		count)
+	xfs_off_t		count,
+	bool			cancel_all)
 {
 	struct xfs_trans	*tp;
 	xfs_fileoff_t		offset_fsb;
@@ -653,7 +659,8 @@ xfs_reflink_cancel_cow_range(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/* Scrape out the old CoW reservations */
-	error = xfs_reflink_cancel_cow_blocks(ip, &tp, offset_fsb, end_fsb);
+	error = xfs_reflink_cancel_cow_blocks(ip, &tp, offset_fsb, end_fsb,
+			cancel_all);
 	if (error)
 		goto out_cancel;
 
@@ -1450,7 +1457,7 @@ xfs_reflink_clear_inode_flag(
 	 * We didn't find any shared blocks so turn off the reflink flag.
 	 * First, get rid of any leftover CoW mappings.
 	 */
-	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF);
+	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF, true);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 33ac9b8db683..02f5ea5fa388 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -39,9 +39,9 @@ extern void xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
 
 extern int xfs_reflink_cancel_cow_blocks(struct xfs_inode *ip,
 		struct xfs_trans **tpp, xfs_fileoff_t offset_fsb,
-		xfs_fileoff_t end_fsb);
+		xfs_fileoff_t end_fsb, bool cancel_all);
 extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
-		xfs_off_t count);
+		xfs_off_t count, bool cancel_all);
 extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 890862f2447c..685c042a120f 100644
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

