Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9C5igGP072602 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 00:44:42 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2dTmy2PRzhMjFABN for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 22:46:12 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TMY3S-0003ag-9z
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:45:02 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TMY38-00057I-6K
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 23/23] xfs: connect up write verifiers to new buffers
Date: Fri, 12 Oct 2012 16:44:29 +1100
Message-Id: <1350020669-19504-24-git-send-email-david@fromorbit.com>
In-Reply-To: <1350020669-19504-1-git-send-email-david@fromorbit.com>
References: <1350020669-19504-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Metadata buffers that are read from disk have write verifiers
already attached to them, but newly allocated buffers do not. Add
appropriate write verifiers to all new metadata buffers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c        |    6 +--
 fs/xfs/xfs_alloc.h        |    2 +
 fs/xfs/xfs_alloc_btree.c  |    1 +
 fs/xfs/xfs_attr_leaf.c    |    4 +-
 fs/xfs/xfs_bmap.c         |    2 +
 fs/xfs/xfs_bmap_btree.c   |    3 +-
 fs/xfs/xfs_bmap_btree.h   |    1 +
 fs/xfs/xfs_btree.c        |    1 +
 fs/xfs/xfs_btree.h        |    2 +
 fs/xfs/xfs_da_btree.c     |    3 ++
 fs/xfs/xfs_dir2_block.c   |    2 +
 fs/xfs/xfs_dir2_data.c    |   11 +++--
 fs/xfs/xfs_dir2_leaf.c    |   19 ++++++---
 fs/xfs/xfs_dir2_node.c    |   24 +++++++----
 fs/xfs/xfs_dir2_priv.h    |    2 +
 fs/xfs/xfs_dquot.c        |  104 ++++++++++++++++++++++-----------------------
 fs/xfs/xfs_fsops.c        |    7 ++-
 fs/xfs/xfs_ialloc.c       |    5 ++-
 fs/xfs/xfs_ialloc.h       |    4 +-
 fs/xfs/xfs_ialloc_btree.c |    1 +
 fs/xfs/xfs_inode.c        |   14 +++++-
 fs/xfs/xfs_inode.h        |    1 +
 fs/xfs/xfs_mount.c        |    2 +-
 fs/xfs/xfs_mount.h        |    1 +
 24 files changed, 135 insertions(+), 87 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index df3eb0b..7ac8965 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -458,7 +458,7 @@ xfs_agfl_write_verify(
 	xfs_agfl_verify(bp);
 }
 
-void
+static void
 xfs_agfl_read_verify(
 	struct xfs_buf	*bp)
 {
@@ -2159,14 +2159,14 @@ xfs_agf_verify(
 	}
 }
 
-static void
+void
 xfs_agf_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_agf_verify(bp);
 }
 
-void
+static void
 xfs_agf_read_verify(
 	struct xfs_buf	*bp)
 {
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index feacb06..4b6c2c4 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -231,4 +231,6 @@ xfs_alloc_get_rec(
 	xfs_extlen_t		*len,	/* output: length of extent */
 	int			*stat);	/* output: success/failure */
 
+void xfs_agf_write_verify(struct xfs_buf *bp);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index 6fc432b..7f8e704 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -389,6 +389,7 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_allocbt_key_diff,
 	.read_verify		= xfs_allocbt_read_verify,
+	.write_verify		= xfs_allocbt_write_verify,
 #ifdef DEBUG
 	.keys_inorder		= xfs_allocbt_keys_inorder,
 	.recs_inorder		= xfs_allocbt_recs_inorder,
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index bb96c55..5d56886 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -923,7 +923,7 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 					    XFS_ATTR_FORK);
 	if (error)
 		goto out;
-	ASSERT(bp2 != NULL);
+	bp2->b_pre_io = bp1->b_pre_io;
 	memcpy(bp2->b_addr, bp1->b_addr, XFS_LBSIZE(dp->i_mount));
 	bp1 = NULL;
 	xfs_trans_log_buf(args->trans, bp2, 0, XFS_LBSIZE(dp->i_mount) - 1);
@@ -977,7 +977,7 @@ xfs_attr_leaf_create(
 					    XFS_ATTR_FORK);
 	if (error)
 		return(error);
-	ASSERT(bp != NULL);
+	bp->b_pre_io = xfs_attr_leaf_write_verify;
 	leaf = bp->b_addr;
 	memset((char *)leaf, 0, XFS_LBSIZE(dp->i_mount));
 	hdr = &leaf->hdr;
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 8e944bb..fe5438b 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3124,6 +3124,7 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the child block.
 	 */
+	abp->b_pre_io = xfs_bmbt_write_verify;
 	ablock = XFS_BUF_TO_BLOCK(abp);
 	ablock->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
 	ablock->bb_level = 0;
@@ -3270,6 +3271,7 @@ xfs_bmap_local_to_extents(
 		ASSERT(args.len == 1);
 		*firstblock = args.fsbno;
 		bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
+		bp->b_pre_io = xfs_bmbt_write_verify;
 		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
 		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
 		xfs_bmap_forkoff_reset(args.mp, ip, whichfork);
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 17d7423..79758e1 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -749,7 +749,7 @@ xfs_bmbt_verify(
 	}
 }
 
-static void
+void
 xfs_bmbt_write_verify(
 	struct xfs_buf	*bp)
 {
@@ -806,6 +806,7 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
 	.read_verify		= xfs_bmbt_read_verify,
+	.write_verify		= xfs_bmbt_write_verify,
 #ifdef DEBUG
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index 1d00fbe..938c859 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -233,6 +233,7 @@ extern int xfs_bmbt_get_maxrecs(struct xfs_btree_cur *, int level);
 extern int xfs_bmdr_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 extern int xfs_bmbt_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 extern void xfs_bmbt_read_verify(struct xfs_buf *bp);
+extern void xfs_bmbt_write_verify(struct xfs_buf *bp);
 
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index b680949..1ccd42b 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -981,6 +981,7 @@ xfs_btree_get_buf_block(
 	if (!*bpp)
 		return ENOMEM;
 
+	(*bpp)->b_pre_io = cur->bc_ops->write_verify;
 	*block = XFS_BUF_TO_BLOCK(*bpp);
 	return 0;
 }
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index 7c3cb8d..2ac403a 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -189,6 +189,8 @@ struct xfs_btree_ops {
 			      union xfs_btree_key *key);
 
 	void	(*read_verify)(struct xfs_buf *bp);
+	void	(*write_verify)(struct xfs_buf *bp);
+
 #ifdef DEBUG
 	/* check that k1 is lower than k2 */
 	int	(*keys_inorder)(struct xfs_btree_cur *cur,
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 179173e..eff604f 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -192,6 +192,7 @@ xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
 	xfs_trans_log_buf(tp, bp,
 		XFS_DA_LOGRANGE(node, &node->hdr, sizeof(node->hdr)));
 
+	bp->b_pre_io = xfs_da_node_write_verify;
 	*bpp = bp;
 	return(0);
 }
@@ -391,6 +392,8 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	}
 	memcpy(node, oldroot, size);
 	xfs_trans_log_buf(tp, bp, 0, size - 1);
+
+	bp->b_pre_io = blk1->bp->b_pre_io;
 	blk1->bp = bp;
 	blk1->blkno = blkno;
 
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 0f8793c..e2fdc6f 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -1010,6 +1010,7 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Start converting it to block form.
 	 */
+	dbp->b_pre_io = xfs_dir2_block_write_verify;
 	hdr->magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
 	needlog = 1;
 	needscan = 0;
@@ -1139,6 +1140,7 @@ xfs_dir2_sf_to_block(
 		kmem_free(sfp);
 		return error;
 	}
+	bp->b_pre_io = xfs_dir2_block_write_verify;
 	hdr = bp->b_addr;
 	hdr->magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
 	/*
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 0af533b..c759c7b 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -185,7 +185,7 @@ __xfs_dir2_data_check(
 	return 0;
 }
 
-void
+static void
 xfs_dir2_data_verify(
 	struct xfs_buf		*bp)
 {
@@ -202,14 +202,14 @@ xfs_dir2_data_verify(
 	}
 }
 
-static void
+void
 xfs_dir2_data_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_dir2_data_verify(bp);
 }
 
-void
+static void
 xfs_dir2_data_read_verify(
 	struct xfs_buf	*bp)
 {
@@ -482,10 +482,9 @@ xfs_dir2_data_init(
 	 */
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, blkno), -1, &bp,
 		XFS_DATA_FORK);
-	if (error) {
+	if (error)
 		return error;
-	}
-	ASSERT(bp != NULL);
+	bp->b_pre_io = xfs_dir2_data_write_verify;
 
 	/*
 	 * Initialize the header.
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 5b3bcab..3002ab7 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -81,7 +81,7 @@ xfs_dir2_leaf1_read_verify(
 	xfs_buf_ioend(bp, 0);
 }
 
-static void
+void
 xfs_dir2_leafn_write_verify(
 	struct xfs_buf	*bp)
 {
@@ -198,6 +198,7 @@ xfs_dir2_block_to_leaf(
 	/*
 	 * Fix up the block header, make it a data block.
 	 */
+	dbp->b_pre_io = xfs_dir2_data_write_verify;
 	hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 	if (needscan)
 		xfs_dir2_data_freescan(mp, hdr, &needlog);
@@ -1243,15 +1244,14 @@ xfs_dir2_leaf_init(
 	 * Get the buffer for the block.
 	 */
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, bno), -1, &bp,
-		XFS_DATA_FORK);
-	if (error) {
+			       XFS_DATA_FORK);
+	if (error)
 		return error;
-	}
-	ASSERT(bp != NULL);
-	leaf = bp->b_addr;
+
 	/*
 	 * Initialize the header.
 	 */
+	leaf = bp->b_addr;
 	leaf->hdr.info.magic = cpu_to_be16(magic);
 	leaf->hdr.info.forw = 0;
 	leaf->hdr.info.back = 0;
@@ -1264,10 +1264,12 @@ xfs_dir2_leaf_init(
 	 * the block.
 	 */
 	if (magic == XFS_DIR2_LEAF1_MAGIC) {
+		bp->b_pre_io = xfs_dir2_leaf1_write_verify;
 		ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 		ltp->bestcount = 0;
 		xfs_dir2_leaf_log_tail(tp, bp);
-	}
+	} else
+		bp->b_pre_io = xfs_dir2_leafn_write_verify;
 	*bpp = bp;
 	return 0;
 }
@@ -1951,7 +1953,10 @@ xfs_dir2_node_to_leaf(
 		xfs_dir2_leaf_compact(args, lbp);
 	else
 		xfs_dir2_leaf_log_header(tp, lbp);
+
+	lbp->b_pre_io = xfs_dir2_leaf1_write_verify;
 	leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAF1_MAGIC);
+
 	/*
 	 * Set up the leaf tail from the freespace block.
 	 */
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index a58abe1..da90a91 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -197,11 +197,12 @@ xfs_dir2_leaf_to_node(
 	/*
 	 * Get the buffer for the new freespace block.
 	 */
-	if ((error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, fdb), -1, &fbp,
-			XFS_DATA_FORK))) {
+	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, fdb), -1, &fbp,
+				XFS_DATA_FORK);
+	if (error)
 		return error;
-	}
-	ASSERT(fbp != NULL);
+	fbp->b_pre_io = xfs_dir2_free_write_verify;
+
 	free = fbp->b_addr;
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
@@ -223,7 +224,10 @@ xfs_dir2_leaf_to_node(
 		*to = cpu_to_be16(off);
 	}
 	free->hdr.nused = cpu_to_be32(n);
+
+	lbp->b_pre_io = xfs_dir2_leafn_write_verify;
 	leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAFN_MAGIC);
+
 	/*
 	 * Log everything.
 	 */
@@ -632,6 +636,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.index = (int)((char *)dep -
 							(char *)curbp->b_addr);
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
+			curbp->b_pre_io = xfs_dir2_data_write_verify;
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 		}
@@ -646,6 +651,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.index = -1;
 			state->extrablk.blkno = curdb;
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
+			curbp->b_pre_io = xfs_dir2_data_write_verify;
 		} else {
 			/* If the curbp is not the CI match block, drop it */
 			if (state->extrablk.bp != curbp)
@@ -1638,12 +1644,12 @@ xfs_dir2_node_addname_int(
 			/*
 			 * Get a buffer for the new block.
 			 */
-			if ((error = xfs_da_get_buf(tp, dp,
-						   xfs_dir2_db_to_da(mp, fbno),
-						   -1, &fbp, XFS_DATA_FORK))) {
+			error = xfs_da_get_buf(tp, dp,
+					       xfs_dir2_db_to_da(mp, fbno),
+					       -1, &fbp, XFS_DATA_FORK);
+			if (error)
 				return error;
-			}
-			ASSERT(fbp != NULL);
+			fbp->b_pre_io = xfs_dir2_free_write_verify;
 
 			/*
 			 * Initialize the new block to be empty, and remember
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 4aeef62..ac49e12 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -45,6 +45,7 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 #else
 #define	xfs_dir2_data_check(dp,bp)
 #endif
+extern void xfs_dir2_data_write_verify(struct xfs_buf *bp);
 extern bool __xfs_dir2_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 extern int xfs_dir2_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
@@ -73,6 +74,7 @@ extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
 
 /* xfs_dir2_leaf.c */
 extern void xfs_dir2_leafn_read_verify(struct xfs_buf *bp);
+extern void xfs_dir2_leafn_write_verify(struct xfs_buf *bp);
 extern int xfs_dir2_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index eff7586..d6d4d6b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -249,6 +249,57 @@ xfs_qm_init_dquot_blk(
 }
 
 
+STATIC void
+xfs_dquot_buf_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
+	struct xfs_disk_dquot	*ddq;
+	xfs_dqid_t		id = 0;
+	int			i;
+
+	/*
+	 * On the first read of the buffer, verify that each dquot is valid.
+	 * We don't know what the id of the dquot is supposed to be, just that
+	 * they should be increasing monotonically within the buffer. If the
+	 * first id is corrupt, then it will fail on the second dquot in the
+	 * buffer so corruptions could point to the wrong dquot in this case.
+	 */
+	for (i = 0; i < mp->m_quotainfo->qi_dqperchunk; i++) {
+		int	error;
+
+		ddq = &d[i].dd_diskdq;
+
+		if (i == 0)
+			id = be32_to_cpu(ddq->d_id);
+
+		error = xfs_qm_dqcheck(mp, ddq, id + i, 0, XFS_QMOPT_DOWARN,
+					"xfs_dquot_read_verify");
+		if (error) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, d);
+			xfs_buf_ioerror(bp, EFSCORRUPTED);
+			break;
+		}
+	}
+}
+
+static void
+xfs_dquot_buf_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dquot_buf_verify(bp);
+}
+
+static void
+xfs_dquot_buf_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dquot_buf_verify(bp);
+	bp->b_pre_io = xfs_dquot_buf_write_verify;
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
 
 /*
  * Allocate a block and fill it with dquots.
@@ -315,6 +366,7 @@ xfs_qm_dqalloc(
 	error = xfs_buf_geterror(bp);
 	if (error)
 		goto error1;
+	bp->b_pre_io = xfs_dquot_buf_write_verify;
 
 	/*
 	 * Make a chunk of dquots out of this buffer and log
@@ -360,58 +412,6 @@ xfs_qm_dqalloc(
 	return (error);
 }
 
-STATIC void
-xfs_dquot_buf_verify(
-	struct xfs_buf		*bp)
-{
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
-	struct xfs_disk_dquot	*ddq;
-	xfs_dqid_t		id = 0;
-	int			i;
-
-	/*
-	 * On the first read of the buffer, verify that each dquot is valid.
-	 * We don't know what the id of the dquot is supposed to be, just that
-	 * they should be increasing monotonically within the buffer. If the
-	 * first id is corrupt, then it will fail on the second dquot in the
-	 * buffer so corruptions could point to the wrong dquot in this case.
-	 */
-	for (i = 0; i < mp->m_quotainfo->qi_dqperchunk; i++) {
-		int	error;
-
-		ddq = &d[i].dd_diskdq;
-
-		if (i == 0)
-			id = be32_to_cpu(ddq->d_id);
-
-		error = xfs_qm_dqcheck(mp, ddq, id + i, 0, XFS_QMOPT_DOWARN,
-					"xfs_dquot_read_verify");
-		if (error) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, d);
-			xfs_buf_ioerror(bp, EFSCORRUPTED);
-			break;
-		}
-	}
-}
-
-static void
-xfs_dquot_buf_write_verify(
-	struct xfs_buf	*bp)
-{
-	xfs_dquot_buf_verify(bp);
-}
-
-static void
-xfs_dquot_buf_read_verify(
-	struct xfs_buf	*bp)
-{
-	xfs_dquot_buf_verify(bp);
-	bp->b_pre_io = xfs_dquot_buf_write_verify;
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
-}
-
 STATIC int
 xfs_qm_dqrepair(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 302b99c..8ebc457 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -200,6 +200,7 @@ xfs_growfs_data_private(
 			error = ENOMEM;
 			goto error0;
 		}
+		bp->b_pre_io = xfs_agf_write_verify;
 		agf = XFS_BUF_TO_AGF(bp);
 		memset(agf, 0, mp->m_sb.sb_sectsize);
 		agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
@@ -237,6 +238,7 @@ xfs_growfs_data_private(
 			error = ENOMEM;
 			goto error0;
 		}
+		bp->b_pre_io = xfs_agi_write_verify;
 		agi = XFS_BUF_TO_AGI(bp);
 		memset(agi, 0, mp->m_sb.sb_sectsize);
 		agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
@@ -419,9 +421,10 @@ xfs_growfs_data_private(
 			bp = xfs_trans_get_buf(NULL, mp->m_ddev_targp,
 				  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 				  XFS_FSS_TO_BB(mp, 1), 0);
-			if (bp)
+			if (bp) {
 				xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
-			else
+				bp->b_pre_io = xfs_sb_write_verify;
+			} else
 				error = ENOMEM;
 		}
 
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index f260a36..12d1c94 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -210,6 +210,7 @@ xfs_ialloc_inode_init(
 		 *	to log a whole cluster of inodes instead of all the
 		 *	individual transactions causing a lot of log traffic.
 		 */
+		fbuf->b_pre_io = xfs_inode_buf_write_verify;
 		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
 		for (i = 0; i < ninodes; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
@@ -1495,14 +1496,14 @@ xfs_agi_verify(
 	xfs_check_agi_unlinked(agi);
 }
 
-static void
+void
 xfs_agi_write_verify(
 	struct xfs_buf	*bp)
 {
 	xfs_agi_verify(bp);
 }
 
-void
+static void
 xfs_agi_read_verify(
 	struct xfs_buf	*bp)
 {
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index 1fd6ea4..7a169e3 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -147,7 +147,9 @@ int xfs_inobt_lookup(struct xfs_btree_cur *cur, xfs_agino_t ino,
 /*
  * Get the data from the pointed-to record.
  */
-extern int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
+int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
 		xfs_inobt_rec_incore_t *rec, int *stat);
 
+void xfs_agi_write_verify(struct xfs_buf *bp);
+
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index 15a79f8..7761e1e 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -271,6 +271,7 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.read_verify		= xfs_inobt_read_verify,
+	.write_verify		= xfs_inobt_write_verify,
 #ifdef DEBUG
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 875ceb2..4f2e99a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -420,7 +420,7 @@ xfs_inode_buf_verify(
 	xfs_inobp_check(mp, bp);
 }
 
-static void
+void
 xfs_inode_buf_write_verify(
 	struct xfs_buf	*bp)
 {
@@ -1781,6 +1781,18 @@ xfs_ifree_cluster(
 
 		if (!bp)
 			return ENOMEM;
+
+		/*
+		 * This buffer may not have been correctly initialised as we
+		 * didn't read it from disk. That's not important because we are
+		 * only using to mark the buffer as stale in the log, and to
+		 * attach stale cached inodes on it. That means it will never be
+		 * dispatched for IO. If it is, we want to know about it, and we
+		 * want it to fail. We can acheive this by adding a write
+		 * verifier to the buffer.
+		 */
+		 bp->b_pre_io = xfs_inode_buf_write_verify;
+
 		/*
 		 * Walk the inodes already attached to the buffer and mark them
 		 * stale. These will all have the flush locks held, so an
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 32b6d70..a866d28 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -555,6 +555,7 @@ int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, uint);
 void		xfs_inode_buf_read_verify(struct xfs_buf *);
+void		xfs_inode_buf_write_verify(struct xfs_buf *);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3fec161..1311185 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -631,7 +631,7 @@ xfs_sb_verify(
 		xfs_buf_ioerror(bp, error);
 }
 
-static void
+void
 xfs_sb_write_verify(
 	struct xfs_buf	*bp)
 {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 82b8fda..69e4082 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -383,6 +383,7 @@ extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 #endif	/* __KERNEL__ */
 
 extern void	xfs_sb_read_verify(struct xfs_buf *);
+extern void	xfs_sb_write_verify(struct xfs_buf *bp);
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
 extern int	xfs_initialize_perag(struct xfs_mount *, xfs_agnumber_t,
 					xfs_agnumber_t *);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
