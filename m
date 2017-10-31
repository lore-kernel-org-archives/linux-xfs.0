Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51538 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753051AbdJaOXE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 10:23:04 -0400
Received: from bzq-164-168-31-210.red.bezeqint.net ([31.168.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e9XRX-0007dj-L2
        for linux-xfs@vger.kernel.org; Tue, 31 Oct 2017 14:23:04 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/18] xfs: iterate over extents in xfs_iextents_copy
Date: Tue, 31 Oct 2017 16:22:22 +0200
Message-Id: <20171031142230.11755-11-hch@lst.de>
In-Reply-To: <20171031142230.11755-1-hch@lst.de>
References: <20171031142230.11755-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This actually makes the function very slightly less efficient for now as we
detour through the expanded irect format between the in-core extent format
and the on-disk one instead of just endian swapping them.  But with the
incore extent btree the in-core one will use a different format and the
representation will be entirely hidden.  It also happens to make the
function a whole more readable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 53 +++++++++++-------------------------------
 1 file changed, 13 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index abe601b48c9c..7dd77b497fc2 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -725,9 +725,6 @@ xfs_iext_count(struct xfs_ifork *ifp)
 /*
  * Convert in-core extents to on-disk form
  *
- * For either the data or attr fork in extent format, we need to endian convert
- * the in-core extent as we place them into the on-disk inode.
- *
  * In the case of the data fork, the in-core and on-disk fork sizes can be
  * different due to delayed allocation extents. We only copy on-disk extents
  * here, so callers must always use the physical fork size to determine the
@@ -736,55 +733,31 @@ xfs_iext_count(struct xfs_ifork *ifp)
  */
 int
 xfs_iextents_copy(
-	xfs_inode_t		*ip,
-	xfs_bmbt_rec_t		*dp,
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_rec	*dp,
 	int			whichfork)
 {
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			copied;
-	int			i;
-	xfs_ifork_t		*ifp;
-	int			nrecs;
-	xfs_fsblock_t		start_block;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_bmbt_irec	rec;
+	int			copied = 0, i = 0;
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 	ASSERT(ifp->if_bytes > 0);
 
-	nrecs = xfs_iext_count(ifp);
-	ASSERT(nrecs > 0);
-
-	/*
-	 * There are some delayed allocation extents in the
-	 * inode, so copy the extents one at a time and skip
-	 * the delayed ones.  There must be at least one
-	 * non-delayed extent.
-	 */
-	copied = 0;
-	for (i = 0; i < nrecs; i++) {
-		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
-
-		start_block = xfs_bmbt_get_startblock(ep);
-		if (isnullstartblock(start_block)) {
-			/*
-			 * It's a delayed allocation extent, so skip it.
-			 */
+	while (xfs_iext_get_extent(ifp, i++, &rec)) {
+		if (isnullstartblock(rec.br_startblock))
 			continue;
-		}
-
+		xfs_bmbt_disk_set_all(dp, &rec);
 		trace_xfs_write_extent(ip, i, state, _RET_IP_);
-
-		/* Translate to on disk format */
-		put_unaligned_be64(ep->l0, &dp->l0);
-		put_unaligned_be64(ep->l1, &dp->l1);
 		ASSERT(xfs_bmbt_validate_extent(ip->i_mount, whichfork, dp));
-
+		copied += sizeof(struct xfs_bmbt_rec);
 		dp++;
-		copied++;
 	}
-	ASSERT(copied != 0);
 
-	return (copied * (uint)sizeof(xfs_bmbt_rec_t));
+	ASSERT(copied > 0);
+	ASSERT(copied <= ifp->if_bytes);
+	return copied;
 }
 
 /*
-- 
2.14.2

