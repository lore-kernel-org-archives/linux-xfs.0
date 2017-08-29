Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44716 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbdH2RtN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 13:49:13 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dmkdU-0007jp-Am
        for linux-xfs@vger.kernel.org; Tue, 29 Aug 2017 17:49:12 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/8] xfs: rewrite xfs_bmap_count_leaves using xfs_iext_get_extent
Date: Tue, 29 Aug 2017 19:48:34 +0200
Message-Id: <20170829174835.2218-8-hch@lst.de>
In-Reply-To: <20170829174835.2218-1-hch@lst.de>
References: <20170829174835.2218-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This avoids poking into the internals of the extent list.  Also return
the number of extents as the return value instead of an additional
by reference argument, and make it available to callers outside of
xfs_bmap_util.c

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 21 ++++++++++-----------
 fs/xfs/xfs_bmap_util.h |  1 +
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 93e955262d07..ea737ebafc53 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -222,22 +222,21 @@ xfs_bmap_eof(
  * Count leaf blocks given a range of extent records.  Delayed allocation
  * extents are not counted towards the totals.
  */
-STATIC void
+xfs_extnum_t
 xfs_bmap_count_leaves(
 	struct xfs_ifork	*ifp,
-	xfs_extnum_t		*numrecs,
 	xfs_filblks_t		*count)
 {
-	xfs_extnum_t		i;
-	xfs_extnum_t		nr_exts = xfs_iext_count(ifp);
-
-	for (i = 0; i < nr_exts; i++) {
-		xfs_bmbt_rec_host_t *frp = xfs_iext_get_ext(ifp, i);
-		if (!isnullstartblock(xfs_bmbt_get_startblock(frp))) {
-			(*numrecs)++;
-			*count += xfs_bmbt_get_blockcount(frp);
+	struct xfs_bmbt_irec	got;
+	xfs_extnum_t		numrecs = 0, i = 0;
+
+	while (xfs_iext_get_extent(ifp, i++, &got)) {
+		if (!isnullstartblock(got.br_startblock)) {
+			*count += got.br_blockcount;
+			numrecs++;
 		}
 	}
+	return numrecs;
 }
 
 /*
@@ -370,7 +369,7 @@ xfs_bmap_count_blocks(
 
 	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
 	case XFS_DINODE_FMT_EXTENTS:
-		xfs_bmap_count_leaves(ifp, nextents, count);
+		*nextents = xfs_bmap_count_leaves(ifp, count);
 		return 0;
 	case XFS_DINODE_FMT_BTREE:
 		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 0cede1043571..0eaa81dc49be 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -70,6 +70,7 @@ int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
 
 xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
 
+xfs_extnum_t xfs_bmap_count_leaves(struct xfs_ifork *ifp, xfs_filblks_t *count);
 int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 			  int whichfork, xfs_extnum_t *nextents,
 			  xfs_filblks_t *count);
-- 
2.11.0

