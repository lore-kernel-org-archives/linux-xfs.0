Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42854 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdFBVZF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 17:25:05 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52LP4Nl015834
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:25:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v52LP4ha006106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:25:04 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v52LP3oA007740
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:25:04 GMT
Subject: [PATCH 10/13] xfs: refactor the ifork block counting function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 14:25:01 -0700
Message-ID: <149643870157.23065.16428953914864164786.stgit@birch.djwong.org>
In-Reply-To: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the inode fork block counting function to count extents for us
at the same time.  This will be used by the bmbt scrubber function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |  105 +++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_bmap_util.h |    4 ++
 2 files changed, 67 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fe83bbc..fc15305 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -226,7 +226,7 @@ xfs_bmap_count_leaves(
 	xfs_ifork_t		*ifp,
 	xfs_extnum_t		idx,
 	int			numrecs,
-	int			*count)
+	unsigned long long	*count)
 {
 	int		b;
 
@@ -245,7 +245,7 @@ xfs_bmap_disk_count_leaves(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*block,
 	int			numrecs,
-	int			*count)
+	unsigned long long	*count)
 {
 	int		b;
 	xfs_bmbt_rec_t	*frp;
@@ -260,17 +260,18 @@ xfs_bmap_disk_count_leaves(
  * Recursively walks each level of a btree
  * to count total fsblocks in use.
  */
-STATIC int                                     /* error */
+STATIC int
 xfs_bmap_count_tree(
-	xfs_mount_t     *mp,            /* file system mount point */
-	xfs_trans_t     *tp,            /* transaction pointer */
-	xfs_ifork_t	*ifp,		/* inode fork pointer */
-	xfs_fsblock_t   blockno,	/* file system block number */
-	int             levelin,	/* level in btree */
-	int		*count)		/* Count of blocks */
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_ifork	*ifp,
+	xfs_fsblock_t		blockno,
+	int			levelin,
+	unsigned int		*nextents,
+	unsigned long long	*count)
 {
 	int			error;
-	xfs_buf_t		*bp, *nbp;
+	struct xfs_buf		*bp, *nbp;
 	int			level = levelin;
 	__be64			*pp;
 	xfs_fsblock_t           bno = blockno;
@@ -303,8 +304,9 @@ xfs_bmap_count_tree(
 		/* Dive to the next level */
 		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
-		if (unlikely((error =
-		     xfs_bmap_count_tree(mp, tp, ifp, bno, level, count)) < 0)) {
+		error = xfs_bmap_count_tree(mp, tp, ifp, bno, level, nextents,
+				count);
+		if (error) {
 			xfs_trans_brelse(tp, bp);
 			XFS_ERROR_REPORT("xfs_bmap_count_tree(1)",
 					 XFS_ERRLEVEL_LOW, mp);
@@ -316,6 +318,7 @@ xfs_bmap_count_tree(
 		for (;;) {
 			nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
 			numrecs = be16_to_cpu(block->bb_numrecs);
+			(*nextents) += numrecs;
 			xfs_bmap_disk_count_leaves(mp, block, numrecs, count);
 			xfs_trans_brelse(tp, bp);
 			if (nextbno == NULLFSBLOCK)
@@ -336,44 +339,61 @@ xfs_bmap_count_tree(
 /*
  * Count fsblocks of the given fork.
  */
-static int					/* error */
+int
 xfs_bmap_count_blocks(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_inode_t		*ip,		/* incore inode */
-	int			whichfork,	/* data or attr fork */
-	int			*count)		/* out: count of blocks */
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	unsigned int		*nextents,
+	unsigned long long	*count)
 {
 	struct xfs_btree_block	*block;	/* current btree block */
 	xfs_fsblock_t		bno;	/* block # of "block" */
-	xfs_ifork_t		*ifp;	/* fork structure */
+	struct xfs_ifork	*ifp;	/* fork structure */
 	int			level;	/* btree level, for checking */
-	xfs_mount_t		*mp;	/* file system mount structure */
+	struct xfs_mount	*mp;	/* file system mount structure */
 	__be64			*pp;	/* pointer to block address */
+	int			error;
 
 	bno = NULLFSBLOCK;
 	mp = ip->i_mount;
+	*nextents = 0;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if ( XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ) {
-		xfs_bmap_count_leaves(ifp, 0, xfs_iext_count(ifp), count);
+	if (!ifp)
 		return 0;
-	}
 
-	/*
-	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
-	 */
-	block = ifp->if_broot;
-	level = be16_to_cpu(block->bb_level);
-	ASSERT(level > 0);
-	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
-	bno = be64_to_cpu(*pp);
-	ASSERT(bno != NULLFSBLOCK);
-	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
-	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
-
-	if (unlikely(xfs_bmap_count_tree(mp, tp, ifp, bno, level, count) < 0)) {
-		XFS_ERROR_REPORT("xfs_bmap_count_blocks(2)", XFS_ERRLEVEL_LOW,
-				 mp);
-		return -EFSCORRUPTED;
+	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
+	case XFS_DINODE_FMT_EXTENTS:
+		*nextents = xfs_iext_count(ifp);
+		xfs_bmap_count_leaves(ifp, 0, (*nextents), count);
+		return 0;
+	case XFS_DINODE_FMT_BTREE:
+		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+			error = xfs_iread_extents(tp, ip, whichfork);
+			if (error)
+				return error;
+		}
+
+		/*
+		 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
+		 */
+		block = ifp->if_broot;
+		level = be16_to_cpu(block->bb_level);
+		ASSERT(level > 0);
+		pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
+		bno = be64_to_cpu(*pp);
+		ASSERT(bno != NULLFSBLOCK);
+		ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
+		ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
+
+		error = xfs_bmap_count_tree(mp, tp, ifp, bno, level,
+				nextents, count);
+		if (error) {
+			XFS_ERROR_REPORT("xfs_bmap_count_blocks(2)",
+					XFS_ERRLEVEL_LOW, mp);
+			return -EFSCORRUPTED;
+		}
+		return 0;
 	}
 
 	return 0;
@@ -1789,8 +1809,9 @@ xfs_swap_extent_forks(
 	int			*target_log_flags)
 {
 	struct xfs_ifork	tempifp, *ifp, *tifp;
-	int			aforkblks = 0;
-	int			taforkblks = 0;
+	unsigned long long	aforkblks = 0;
+	unsigned long long	taforkblks = 0;
+	unsigned int		junk;
 	xfs_extnum_t		nextents;
 	uint64_t		tmp;
 	int			error;
@@ -1800,14 +1821,14 @@ xfs_swap_extent_forks(
 	 */
 	if ( ((XFS_IFORK_Q(ip) != 0) && (ip->i_d.di_anextents > 0)) &&
 	     (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
-		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK,
+		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &junk,
 				&aforkblks);
 		if (error)
 			return error;
 	}
 	if ( ((XFS_IFORK_Q(tip) != 0) && (tip->i_d.di_anextents > 0)) &&
 	     (tip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
-		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK,
+		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK, &junk,
 				&taforkblks);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 135d826..993973c 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -70,4 +70,8 @@ int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
 
 xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
 
+int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
+			  int whichfork, unsigned int *nextents,
+			  unsigned long long *count);
+
 #endif	/* __XFS_BMAP_UTIL_H__ */

