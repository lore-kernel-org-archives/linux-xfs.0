Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41733 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdB1Atz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2017 19:49:55 -0500
Received: from [8.25.222.2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1ciVyZ-0005zs-6u
        for linux-xfs@vger.kernel.org; Tue, 28 Feb 2017 00:49:11 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: only reclaim unwritten COW extents periodically
Date: Mon, 27 Feb 2017 16:49:10 -0800
Message-Id: <20170228004910.9495-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We only want to reclaim preallocations from our periodic work item.
Currenrly this is archived by looking for a diry inode, but that check
is rather fragile.  Instead add flags to the xfs_reflink_cancel_cow_* so
that the caller can ask for just cancelling unwritten extents in the COw
fork.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c    |  2 +-
 fs/xfs/xfs_icache.c  |  2 +-
 fs/xfs/xfs_inode.c   |  2 +-
 fs/xfs/xfs_reflink.c | 14 +++++++++-----
 fs/xfs/xfs_reflink.h |  5 +++--
 fs/xfs/xfs_super.c   |  2 +-
 6 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b480647e00e7..290c0fb306e7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -293,7 +293,7 @@ xfs_end_io(
 			goto done;
 		if (ioend->io_bio->bi_error) {
 			error = xfs_reflink_cancel_cow_range(ip,
-					ioend->io_offset, ioend->io_size);
+					ioend->io_offset, ioend->io_size, 0);
 			goto done;
 		}
 		error = xfs_reflink_end_cow(ip, ioend->io_offset,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7234b9748c36..1f7d158266c1 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1608,7 +1608,7 @@ xfs_inode_free_cowblocks(
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 
-	ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF);
+	ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, XFS_CC_UNWRITTEN);
 
 	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index edfa6a55b064..164e74a511b1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1615,7 +1615,7 @@ xfs_itruncate_extents(
 
 	/* Remove all pending CoW reservations. */
 	error = xfs_reflink_cancel_cow_blocks(ip, &tp, first_unmap_block,
-			last_block);
+			last_block, 0);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 08ca9f81b087..83605af3b135 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -551,7 +551,8 @@ xfs_reflink_cancel_cow_blocks(
 	struct xfs_inode		*ip,
 	struct xfs_trans		**tpp,
 	xfs_fileoff_t			offset_fsb,
-	xfs_fileoff_t			end_fsb)
+	xfs_fileoff_t			end_fsb,
+	unsigned			flags)
 {
 	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec		got, del;
@@ -575,7 +576,8 @@ xfs_reflink_cancel_cow_blocks(
 					&idx, &got, &del);
 			if (error)
 				break;
-		} else {
+		} else if (del.br_state == XFS_EXT_UNWRITTEN ||
+			   !(flags & XFS_CC_UNWRITTEN)) {
 			xfs_trans_ijoin(*tpp, ip, 0);
 			xfs_defer_init(&dfops, &firstfsb);
 
@@ -623,7 +625,8 @@ int
 xfs_reflink_cancel_cow_range(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		count)
+	xfs_off_t		count,
+	unsigned		flags)
 {
 	struct xfs_trans	*tp;
 	xfs_fileoff_t		offset_fsb;
@@ -649,7 +652,8 @@ xfs_reflink_cancel_cow_range(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/* Scrape out the old CoW reservations */
-	error = xfs_reflink_cancel_cow_blocks(ip, &tp, offset_fsb, end_fsb);
+	error = xfs_reflink_cancel_cow_blocks(ip, &tp, offset_fsb, end_fsb,
+			flags);
 	if (error)
 		goto out_cancel;
 
@@ -1437,7 +1441,7 @@ xfs_reflink_clear_inode_flag(
 	 * We didn't find any shared blocks so turn off the reflink flag.
 	 * First, get rid of any leftover CoW mappings.
 	 */
-	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF);
+	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF, 0);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 33ac9b8db683..9416279b3c89 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -37,11 +37,12 @@ extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
 extern void xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
 		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap);
 
+#define XFS_CC_UNWRITTEN	0x01
 extern int xfs_reflink_cancel_cow_blocks(struct xfs_inode *ip,
 		struct xfs_trans **tpp, xfs_fileoff_t offset_fsb,
-		xfs_fileoff_t end_fsb);
+		xfs_fileoff_t end_fsb, unsigned flags);
 extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
-		xfs_off_t count);
+		xfs_off_t count, unsigned flags);
 extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 890862f2447c..9136854030d5 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -953,7 +953,7 @@ xfs_fs_destroy_inode(
 	XFS_STATS_INC(ip->i_mount, vn_remove);
 
 	if (xfs_is_reflink_inode(ip)) {
-		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF);
+		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, 0);
 		if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount))
 			xfs_warn(ip->i_mount,
 "Error %d while evicting CoW blocks for inode %llu.",
-- 
2.11.0

