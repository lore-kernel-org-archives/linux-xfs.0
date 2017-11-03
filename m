Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40751 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754474AbdKCOqs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:46:48 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdF9-00027B-Ei
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:46:47 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/21] xfs: pass struct xfs_bmbt_irec to xfs_bmbt_validate_extent
Date: Fri,  3 Nov 2017 17:45:38 +0300
Message-Id: <20171103144539.2187-21-hch@lst.de>
In-Reply-To: <20171103144539.2187-1-hch@lst.de>
References: <20171103144539.2187-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This removed an unaligned load per extent, as well as the manual poking
into the on-disk extent format.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
 fs/xfs/libxfs/xfs_bmap_btree.h | 4 ++--
 fs/xfs/libxfs/xfs_inode_fork.c | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 57c974fea3a9..4e0e10472434 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1261,13 +1261,13 @@ xfs_iread_extents(
 		 */
 		frp = XFS_BMBT_REC_ADDR(mp, block, 1);
 		for (j = 0; j < num_recs; j++, frp++, i++) {
-			if (!xfs_bmbt_validate_extent(mp, whichfork, frp)) {
+			xfs_bmbt_disk_get_all(frp, &new);
+			if (!xfs_bmbt_validate_extent(mp, whichfork, &new)) {
 				XFS_ERROR_REPORT("xfs_bmap_read_extents(2)",
 						 XFS_ERRLEVEL_LOW, mp);
 				error = -EFSCORRUPTED;
 				goto out_brelse;
 			}
-			xfs_bmbt_disk_get_all(frp, &new);
 			xfs_iext_insert(ip, &icur, &new, state);
 			trace_xfs_read_extent(ip, &icur, state, _THIS_IP_);
 			xfs_iext_next(ifp, &icur);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 714bfbaf9b2d..135b8c56d23e 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -122,9 +122,9 @@ extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
  * Check that the extent does not contain an invalid unwritten extent flag.
  */
 static inline bool xfs_bmbt_validate_extent(struct xfs_mount *mp, int whichfork,
-		struct xfs_bmbt_rec *ep)
+		struct xfs_bmbt_irec *irec)
 {
-	if (get_unaligned_be64(&ep->l0) >> (64 - BMBT_EXNTFLAG_BITLEN) == 0)
+	if (irec->br_state == XFS_EXT_NORM)
 		return true;
 	if (whichfork == XFS_DATA_FORK &&
 	    xfs_sb_version_hasextflgbit(&mp->m_sb))
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 71901ee2e35c..9ff7e33accd5 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -355,13 +355,13 @@ xfs_iformat_extents(
 
 		xfs_iext_first(ifp, &icur);
 		for (i = 0; i < nex; i++, dp++) {
-			if (!xfs_bmbt_validate_extent(mp, whichfork, dp)) {
+			xfs_bmbt_disk_get_all(dp, &new);
+			if (!xfs_bmbt_validate_extent(mp, whichfork, &new)) {
 				XFS_ERROR_REPORT("xfs_iformat_extents(2)",
 						 XFS_ERRLEVEL_LOW, mp);
 				return -EFSCORRUPTED;
 			}
 
-			xfs_bmbt_disk_get_all(dp, &new);
 			xfs_iext_insert(ip, &icur, &new, state);
 			trace_xfs_read_extent(ip, &icur, state, _THIS_IP_);
 			xfs_iext_next(ifp, &icur);
@@ -704,9 +704,9 @@ xfs_iextents_copy(
 	for_each_iext(ifp, &icur, &rec) {
 		if (isnullstartblock(rec.br_startblock))
 			continue;
+		ASSERT(xfs_bmbt_validate_extent(ip->i_mount, whichfork, &rec));
 		xfs_bmbt_disk_set_all(dp, &rec);
 		trace_xfs_write_extent(ip, &icur, state, _RET_IP_);
-		ASSERT(xfs_bmbt_validate_extent(ip->i_mount, whichfork, dp));
 		copied += sizeof(struct xfs_bmbt_rec);
 		dp++;
 	}
-- 
2.14.2

