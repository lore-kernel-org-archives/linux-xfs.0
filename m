Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47897 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdJWGae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 02:30:34 -0400
Received: from [46.125.250.114] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e6WFt-0002rY-SF
        for linux-xfs@vger.kernel.org; Mon, 23 Oct 2017 06:30:34 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] xfs: merge xfs_bmap_read_extents into xfs_iread_extents
Date: Mon, 23 Oct 2017 08:30:16 +0200
Message-Id: <20171023063017.11520-4-hch@lst.de>
In-Reply-To: <20171023063017.11520-1-hch@lst.de>
References: <20171023063017.11520-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_iread_extents is just a trivial wrapper, there is no good reason
to keep the two separate.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c       | 83 +++++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_bmap.h       |  2 -
 fs/xfs/libxfs/xfs_inode_fork.c | 37 -------------------
 3 files changed, 49 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 19ec8b1f99dd..53ff6d92b532 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1164,32 +1164,37 @@ xfs_bmap_add_attrfork(
  */
 
 /*
- * Read in the extents to if_extents.
- * All inode fields are set up by caller, we just traverse the btree
- * and copy the records in.
+ * Read in extents from a btree-format inode.
  */
-int					/* error */
-xfs_bmap_read_extents(
-	xfs_trans_t		*tp,	/* transaction pointer */
-	xfs_inode_t		*ip,	/* incore inode */
-	int			whichfork) /* data or attr fork */
+int
+xfs_iread_extents(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			whichfork)
 {
-	struct xfs_btree_block	*block;	/* current btree block */
-	xfs_fsblock_t		bno;	/* block # of "block" */
-	xfs_buf_t		*bp;	/* buffer for "block" */
-	int			error;	/* error return value */
-	xfs_extnum_t		i, j;	/* index into the extents list */
-	xfs_ifork_t		*ifp;	/* fork structure */
-	int			level;	/* btree level, for checking */
-	xfs_mount_t		*mp;	/* file system mount structure */
-	__be64			*pp;	/* pointer to block address */
-	/* REFERENCED */
-	xfs_extnum_t		room;	/* number of entries there's room for */
+	struct xfs_mount	*mp = ip->i_mount;
 	int			state = xfs_bmap_fork_to_state(whichfork);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	xfs_extnum_t		nextents = XFS_IFORK_NEXTENTS(ip, whichfork);
+	struct xfs_btree_block	*block = ifp->if_broot;
+	xfs_fsblock_t		bno;
+	struct xfs_buf		*bp;
+	xfs_extnum_t		i, j;
+	int			level;
+	__be64			*pp;
+	int			error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	if (unlikely(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
+	ifp->if_bytes = 0;
+	ifp->if_real_bytes = 0;
+	xfs_iext_add(ifp, 0, nextents);
 
-	mp = ip->i_mount;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	block = ifp->if_broot;
 	/*
 	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
 	 */
@@ -1206,21 +1211,22 @@ xfs_bmap_read_extents(
 		error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
 				XFS_BMAP_BTREE_REF, &xfs_bmbt_buf_ops);
 		if (error)
-			return error;
+			goto out;
 		block = XFS_BUF_TO_BLOCK(bp);
 		if (level == 0)
 			break;
 		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
 		XFS_WANT_CORRUPTED_GOTO(mp,
-			XFS_FSB_SANITY_CHECK(mp, bno), error0);
+			XFS_FSB_SANITY_CHECK(mp, bno), out_brelse);
 		xfs_trans_brelse(tp, bp);
 	}
+
 	/*
 	 * Here with bp and block set to the leftmost leaf node in the tree.
 	 */
-	room = xfs_iext_count(ifp);
 	i = 0;
+
 	/*
 	 * Loop over all leaf nodes.  Copy information to the extent records.
 	 */
@@ -1230,14 +1236,15 @@ xfs_bmap_read_extents(
 		xfs_extnum_t	num_recs;
 
 		num_recs = xfs_btree_get_numrecs(block);
-		if (unlikely(i + num_recs > room)) {
-			ASSERT(i + num_recs <= room);
+		if (unlikely(i + num_recs > nextents)) {
+			ASSERT(i + num_recs <= nextents);
 			xfs_warn(ip->i_mount,
 				"corrupt dinode %Lu, (btree extents).",
 				(unsigned long long) ip->i_ino);
-			XFS_CORRUPTION_ERROR("xfs_bmap_read_extents(1)",
+			XFS_CORRUPTION_ERROR(__func__,
 				XFS_ERRLEVEL_LOW, ip->i_mount, block);
-			goto error0;
+			error = -EFSCORRUPTED;
+			goto out_brelse;
 		}
 		/*
 		 * Read-ahead the next leaf block, if any.
@@ -1266,16 +1273,24 @@ xfs_bmap_read_extents(
 		error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
 				XFS_BMAP_BTREE_REF, &xfs_bmbt_buf_ops);
 		if (error)
-			return error;
+			goto out;
 		block = XFS_BUF_TO_BLOCK(bp);
 	}
-	if (i != XFS_IFORK_NEXTENTS(ip, whichfork))
-		return -EFSCORRUPTED;
+
+	if (i != XFS_IFORK_NEXTENTS(ip, whichfork)) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
 	ASSERT(i == xfs_iext_count(ifp));
+
+	ifp->if_flags |= XFS_IFEXTENTS;
 	return 0;
-error0:
+
+out_brelse:
 	xfs_trans_brelse(tp, bp);
-	return -EFSCORRUPTED;
+out:
+	xfs_iext_destroy(ifp);
+	return error;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 6c426cdfb758..de34bad03c46 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -198,8 +198,6 @@ int	xfs_bmap_last_before(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_bmap_last_offset(struct xfs_inode *ip, xfs_fileoff_t *unused,
 		int whichfork);
 int	xfs_bmap_one_block(struct xfs_inode *ip, int whichfork);
-int	xfs_bmap_read_extents(struct xfs_trans *tp, struct xfs_inode *ip,
-		int whichfork);
 int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 48a5dec360cd..c70f9ef07b6d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -443,43 +443,6 @@ xfs_iformat_btree(
 	return 0;
 }
 
-/*
- * Read in extents from a btree-format inode.
- * Allocate and fill in if_extents.  Real work is done in xfs_bmap.c.
- */
-int
-xfs_iread_extents(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	int		whichfork)
-{
-	int		error;
-	xfs_ifork_t	*ifp;
-	xfs_extnum_t	nextents;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	if (unlikely(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
-		XFS_ERROR_REPORT("xfs_iread_extents", XFS_ERRLEVEL_LOW,
-				 ip->i_mount);
-		return -EFSCORRUPTED;
-	}
-	nextents = XFS_IFORK_NEXTENTS(ip, whichfork);
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-
-	/*
-	 * We know that the size is valid (it's checked in iformat_btree)
-	 */
-	ifp->if_bytes = ifp->if_real_bytes = 0;
-	xfs_iext_add(ifp, 0, nextents);
-	error = xfs_bmap_read_extents(tp, ip, whichfork);
-	if (error) {
-		xfs_iext_destroy(ifp);
-		return error;
-	}
-	ifp->if_flags |= XFS_IFEXTENTS;
-	return 0;
-}
 /*
  * Reallocate the space for if_broot based on the number of records
  * being added or deleted as indicated in rec_diff.  Move the records
-- 
2.14.2

