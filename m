Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAE6ok4I035039 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 00:50:46 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nMmunJytibx77tI6 for <xfs@oss.sgi.com>;
	Tue, 13 Nov 2012 22:52:47 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1TYWps-0001oo-3B
	for xfs@oss.sgi.com; Wed, 14 Nov 2012 17:52:32 +1100
Date: Wed, 14 Nov 2012 17:52:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 28/32 V2] xfs: add pre-write metadata buffer verifier callbacks
Message-ID: <20121114065231.GF1710@dastard>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-29-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352721264-3700-29-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs: add pre-write metadata buffer verifier callbacks

From: Dave Chinner <dchinner@redhat.com>

These verifiers are essentially the same code as the read verifiers,
but do not require ioend processing. Hence factor the read verifier
functions and add a new write verifier wrapper that is used as the
callback.

This is done as one large patch for all verifiers rather than one
patch per verifier as the change is largely mechanical. This
includes hooking up the write verifier via the read verifier
function.

Hooking up the write verifier for buffers obtained via
xfs_trans_get_buf() will be done in a separate patch as that touches
code in many different places rather than just the verifier
functions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
V2: fold in quotacheck dquot verifier changes.

 fs/xfs/xfs_alloc.c        |   35 ++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_alloc_btree.c  |   21 +++++++++++++++++----
 fs/xfs/xfs_attr_leaf.c    |   19 +++++++++++++++++--
 fs/xfs/xfs_attr_leaf.h    |    2 +-
 fs/xfs/xfs_bmap_btree.c   |   21 +++++++++++++++++----
 fs/xfs/xfs_da_btree.c     |   37 +++++++++++++++++++++++++------------
 fs/xfs/xfs_dir2_block.c   |   16 +++++++++++++++-
 fs/xfs/xfs_dir2_data.c    |   19 +++++++++++++++++--
 fs/xfs/xfs_dir2_leaf.c    |   31 ++++++++++++++++++++++++-------
 fs/xfs/xfs_dir2_node.c    |   17 ++++++++++++++++-
 fs/xfs/xfs_dir2_priv.h    |    2 +-
 fs/xfs/xfs_dquot.c        |   27 +++++++++++++++++++++------
 fs/xfs/xfs_dquot.h        |    2 +-
 fs/xfs/xfs_ialloc.c       |   17 ++++++++++++++++-
 fs/xfs/xfs_ialloc_btree.c |   19 ++++++++++++++++---
 fs/xfs/xfs_inode.c        |   19 +++++++++++++++++--
 fs/xfs/xfs_inode.h        |    2 +-
 fs/xfs/xfs_itable.c       |    2 +-
 fs/xfs/xfs_mount.c        |   19 +++++++++++++++++--
 fs/xfs/xfs_qm.c           |    2 +-
 20 files changed, 273 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 578afd9..472ddc6 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -430,8 +430,8 @@ xfs_alloc_fixup_trees(
 	return 0;
 }
 
-void
-xfs_agfl_read_verify(
+static void
+xfs_agfl_verify(
 	struct xfs_buf	*bp)
 {
 #ifdef WHEN_CRCS_COME_ALONG
@@ -463,6 +463,21 @@ xfs_agfl_read_verify(
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
 #endif
+}
+
+static void
+xfs_agfl_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_agfl_verify(bp);
+}
+
+void
+xfs_agfl_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_agfl_verify(bp);
+	bp->b_pre_io = xfs_agfl_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
@@ -2129,7 +2144,7 @@ xfs_alloc_put_freelist(
 }
 
 static void
-xfs_agf_read_verify(
+xfs_agf_verify(
 	struct xfs_buf	*bp)
  {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
@@ -2164,7 +2179,21 @@ xfs_agf_read_verify(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, agf);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
+}
+
+static void
+xfs_agf_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_agf_verify(bp);
+}
 
+void
+xfs_agf_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_agf_verify(bp);
+	bp->b_pre_io = xfs_agf_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index 46961e5..6e98b22 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -272,8 +272,8 @@ xfs_allocbt_key_diff(
 	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
-void
-xfs_allocbt_read_verify(
+static void
+xfs_allocbt_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
@@ -323,11 +323,24 @@ xfs_allocbt_read_verify(
 
 	if (!sblock_ok) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		XFS_CORRUPTION_ERROR("xfs_allocbt_read_verify",
-					XFS_ERRLEVEL_LOW, mp, block);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, block);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
+}
 
+static void
+xfs_allocbt_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_allocbt_verify(bp);
+}
+
+void
+xfs_allocbt_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_allocbt_verify(bp);
+	bp->b_pre_io = xfs_allocbt_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index efe170d..57729d7 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -88,7 +88,7 @@ STATIC void xfs_attr_leaf_moveents(xfs_attr_leafblock_t *src_leaf,
 					 xfs_mount_t *mp);
 STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
 
-void
+static void
 xfs_attr_leaf_verify(
 	struct xfs_buf		*bp)
 {
@@ -101,11 +101,26 @@ xfs_attr_leaf_verify(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
+}
+
+static void
+xfs_attr_leaf_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_attr_leaf_verify(bp);
+}
 
+void
+xfs_attr_leaf_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_attr_leaf_verify(bp);
+	bp->b_pre_io = xfs_attr_leaf_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
 
+
 int
 xfs_attr_leaf_read(
 	struct xfs_trans	*tp,
@@ -115,7 +130,7 @@ xfs_attr_leaf_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
-					XFS_ATTR_FORK, xfs_attr_leaf_verify);
+				XFS_ATTR_FORK, xfs_attr_leaf_read_verify);
 }
 
 /*========================================================================
diff --git a/fs/xfs/xfs_attr_leaf.h b/fs/xfs/xfs_attr_leaf.h
index 098e9a5..3bbf627 100644
--- a/fs/xfs/xfs_attr_leaf.h
+++ b/fs/xfs/xfs_attr_leaf.h
@@ -264,6 +264,6 @@ int	xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize,
 int	xfs_attr_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			struct xfs_buf **bpp);
-void	xfs_attr_leaf_verify(struct xfs_buf *bp);
+void	xfs_attr_leaf_read_verify(struct xfs_buf *bp);
 
 #endif	/* __XFS_ATTR_LEAF_H__ */
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index bddca9b..17d7423 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -708,8 +708,8 @@ xfs_bmbt_key_diff(
 				      cur->bc_rec.b.br_startoff;
 }
 
-void
-xfs_bmbt_read_verify(
+static void
+xfs_bmbt_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
@@ -744,11 +744,24 @@ xfs_bmbt_read_verify(
 
 	if (!lblock_ok) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		XFS_CORRUPTION_ERROR("xfs_bmbt_read_verify",
-					XFS_ERRLEVEL_LOW, mp, block);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, block);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
+}
 
+static void
+xfs_bmbt_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_bmbt_verify(bp);
+}
+
+void
+xfs_bmbt_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_bmbt_verify(bp);
+	bp->b_pre_io = xfs_bmbt_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 93ebc0f..6bb0a59 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -92,7 +92,7 @@ STATIC int	xfs_da_blk_unlink(xfs_da_state_t *state,
 STATIC void	xfs_da_state_kill_altpath(xfs_da_state_t *state);
 
 static void
-__xfs_da_node_verify(
+xfs_da_node_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
@@ -108,12 +108,17 @@ __xfs_da_node_verify(
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
 
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp, 0);
 }
 
 static void
-xfs_da_node_verify(
+xfs_da_node_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_da_node_verify(bp);
+}
+
+static void
+xfs_da_node_read_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
@@ -121,21 +126,22 @@ xfs_da_node_verify(
 
 	switch (be16_to_cpu(info->magic)) {
 		case XFS_DA_NODE_MAGIC:
-			__xfs_da_node_verify(bp);
-			return;
+			xfs_da_node_verify(bp);
+			break;
 		case XFS_ATTR_LEAF_MAGIC:
-			xfs_attr_leaf_verify(bp);
+			xfs_attr_leaf_read_verify(bp);
 			return;
 		case XFS_DIR2_LEAFN_MAGIC:
-			xfs_dir2_leafn_verify(bp);
+			xfs_dir2_leafn_read_verify(bp);
 			return;
 		default:
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
+					     mp, info);
+			xfs_buf_ioerror(bp, EFSCORRUPTED);
 			break;
 	}
 
-	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, info);
-	xfs_buf_ioerror(bp, EFSCORRUPTED);
-
+	bp->b_pre_io = xfs_da_node_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
@@ -150,7 +156,7 @@ xfs_da_node_read(
 	int			which_fork)
 {
 	return xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
-					which_fork, xfs_da_node_verify);
+					which_fork, xfs_da_node_read_verify);
 }
 
 /*========================================================================
@@ -816,7 +822,14 @@ xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
 	xfs_da_blkinfo_onlychild_validate(bp->b_addr,
 					be16_to_cpu(oldroot->hdr.level));
 
+	/*
+	 * This could be copying a leaf back into the root block in the case of
+	 * there only being a single leaf block left in the tree. Hence we have
+	 * to update the pre_io pointer as well to match the buffer type change
+	 * that could occur.
+	 */
 	memcpy(root_blk->bp->b_addr, bp->b_addr, state->blocksize);
+	root_blk->bp->b_pre_io = bp->b_pre_io;
 	xfs_trans_log_buf(args->trans, root_blk->bp, 0, state->blocksize - 1);
 	error = xfs_da_shrink_inode(args, child, bp);
 	return(error);
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index ca03b10..0f8793c 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -71,7 +71,21 @@ xfs_dir2_block_verify(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
+}
 
+static void
+xfs_dir2_block_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dir2_block_verify(bp);
+}
+
+void
+xfs_dir2_block_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dir2_block_verify(bp);
+	bp->b_pre_io = xfs_dir2_block_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
@@ -85,7 +99,7 @@ xfs_dir2_block_read(
 	struct xfs_mount	*mp = dp->i_mount;
 
 	return xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, bpp,
-					XFS_DATA_FORK, xfs_dir2_block_verify);
+				XFS_DATA_FORK, xfs_dir2_block_read_verify);
 }
 
 static void
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 1a43c85..b555585 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -200,11 +200,26 @@ xfs_dir2_data_verify(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
+}
+
+static void
+xfs_dir2_data_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dir2_data_verify(bp);
+}
 
+void
+xfs_dir2_data_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dir2_data_verify(bp);
+	bp->b_pre_io = xfs_dir2_data_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
 
+
 int
 xfs_dir2_data_read(
 	struct xfs_trans	*tp,
@@ -214,7 +229,7 @@ xfs_dir2_data_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
-					XFS_DATA_FORK, xfs_dir2_data_verify);
+				XFS_DATA_FORK, xfs_dir2_data_read_verify);
 }
 
 int
@@ -225,7 +240,7 @@ xfs_dir2_data_readahead(
 	xfs_daddr_t		mapped_bno)
 {
 	return xfs_da_reada_buf(tp, dp, bno, mapped_bno,
-					XFS_DATA_FORK, xfs_dir2_data_verify);
+				XFS_DATA_FORK, xfs_dir2_data_read_verify);
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 8a95547..5b3bcab 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -62,23 +62,40 @@ xfs_dir2_leaf_verify(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
+}
+
+static void
+xfs_dir2_leaf1_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
+}
 
+static void
+xfs_dir2_leaf1_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
+	bp->b_pre_io = xfs_dir2_leaf1_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
 
 static void
-xfs_dir2_leaf1_verify(
-	struct xfs_buf		*bp)
+xfs_dir2_leafn_write_verify(
+	struct xfs_buf	*bp)
 {
-	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
+	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 }
 
 void
-xfs_dir2_leafn_verify(
-	struct xfs_buf		*bp)
+xfs_dir2_leafn_read_verify(
+	struct xfs_buf	*bp)
 {
 	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
+	bp->b_pre_io = xfs_dir2_leafn_write_verify;
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
 }
 
 static int
@@ -90,7 +107,7 @@ xfs_dir2_leaf_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
-					XFS_DATA_FORK, xfs_dir2_leaf1_verify);
+				XFS_DATA_FORK, xfs_dir2_leaf1_read_verify);
 }
 
 int
@@ -102,7 +119,7 @@ xfs_dir2_leafn_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
-					XFS_DATA_FORK, xfs_dir2_leafn_verify);
+				XFS_DATA_FORK, xfs_dir2_leafn_read_verify);
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 7c6f956..a58abe1 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -69,11 +69,26 @@ xfs_dir2_free_verify(
 				     XFS_ERRLEVEL_LOW, mp, hdr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
+}
+
+static void
+xfs_dir2_free_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dir2_free_verify(bp);
+}
 
+void
+xfs_dir2_free_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dir2_free_verify(bp);
+	bp->b_pre_io = xfs_dir2_free_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
 
+
 static int
 __xfs_dir2_free_read(
 	struct xfs_trans	*tp,
@@ -83,7 +98,7 @@ __xfs_dir2_free_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
-					XFS_DATA_FORK, xfs_dir2_free_verify);
+				XFS_DATA_FORK, xfs_dir2_free_read_verify);
 }
 
 int
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index daf5d0f..7ec61af 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -72,7 +72,7 @@ extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
 		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
 
 /* xfs_dir2_leaf.c */
-extern void xfs_dir2_leafn_verify(struct xfs_buf *bp);
+extern void xfs_dir2_leafn_read_verify(struct xfs_buf *bp);
 extern int xfs_dir2_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 0ba0f09..b38a10e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -360,8 +360,8 @@ xfs_qm_dqalloc(
 	return (error);
 }
 
-void
-xfs_dquot_read_verify(
+static void
+xfs_dquot_buf_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
@@ -388,12 +388,26 @@ xfs_dquot_read_verify(
 		error = xfs_qm_dqcheck(mp, ddq, id + i, 0, XFS_QMOPT_DOWARN,
 					"xfs_dquot_read_verify");
 		if (error) {
-			XFS_CORRUPTION_ERROR("xfs_dquot_read_verify",
-					     XFS_ERRLEVEL_LOW, mp, d);
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, d);
 			xfs_buf_ioerror(bp, EFSCORRUPTED);
 			break;
 		}
 	}
+}
+
+static void
+xfs_dquot_buf_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dquot_buf_verify(bp);
+}
+
+void
+xfs_dquot_buf_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dquot_buf_verify(bp);
+	bp->b_pre_io = xfs_dquot_buf_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
@@ -413,7 +427,7 @@ xfs_qm_dqrepair(
 
 	/*
 	 * Read the buffer without verification so we get the corrupted
-	 * buffer returned to us.
+	 * buffer returned to us. make sure we verify it on write, though.
 	 */
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, dqp->q_blkno,
 				   mp->m_quotainfo->qi_dqchunklen,
@@ -423,6 +437,7 @@ xfs_qm_dqrepair(
 		ASSERT(*bpp == NULL);
 		return XFS_ERROR(error);
 	}
+	(*bpp)->b_pre_io = xfs_dquot_buf_write_verify;
 
 	ASSERT(xfs_buf_islocked(*bpp));
 	d = (struct xfs_dqblk *)(*bpp)->b_addr;
@@ -521,7 +536,7 @@ xfs_qm_dqtobp(
 		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 					   dqp->q_blkno,
 					   mp->m_quotainfo->qi_dqchunklen,
-					   0, &bp, xfs_dquot_read_verify);
+					   0, &bp, xfs_dquot_buf_read_verify);
 
 		if (error == EFSCORRUPTED && (flags & XFS_QMOPT_DQREPAIR)) {
 			xfs_dqid_t firstid = (xfs_dqid_t)map.br_startoff *
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index a08ba92..5438d88 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -140,7 +140,7 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
 
 extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
 					uint, struct xfs_dquot	**);
-extern void		xfs_dquot_read_verify(struct xfs_buf *bp);
+extern void		xfs_dquot_buf_read_verify(struct xfs_buf *bp);
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 5bd255e..070f418 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1473,7 +1473,7 @@ xfs_check_agi_unlinked(
 #endif
 
 static void
-xfs_agi_read_verify(
+xfs_agi_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
@@ -1502,6 +1502,21 @@ xfs_agi_read_verify(
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
 	xfs_check_agi_unlinked(agi);
+}
+
+static void
+xfs_agi_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_agi_verify(bp);
+}
+
+void
+xfs_agi_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_agi_verify(bp);
+	bp->b_pre_io = xfs_agi_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index 11306c6..15a79f8 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -183,7 +183,7 @@ xfs_inobt_key_diff(
 }
 
 void
-xfs_inobt_read_verify(
+xfs_inobt_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
@@ -211,11 +211,24 @@ xfs_inobt_read_verify(
 
 	if (!sblock_ok) {
 		trace_xfs_btree_corrupt(bp, _RET_IP_);
-		XFS_CORRUPTION_ERROR("xfs_inobt_read_verify",
-					XFS_ERRLEVEL_LOW, mp, block);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, block);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
+}
+
+static void
+xfs_inobt_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_inobt_verify(bp);
+}
 
+void
+xfs_inobt_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_inobt_verify(bp);
+	bp->b_pre_io = xfs_inobt_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3a243d0..910b2da 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -382,7 +382,7 @@ xfs_inobp_check(
 }
 #endif
 
-void
+static void
 xfs_inode_buf_verify(
 	struct xfs_buf	*bp)
 {
@@ -418,6 +418,21 @@ xfs_inode_buf_verify(
 		}
 	}
 	xfs_inobp_check(mp, bp);
+}
+
+static void
+xfs_inode_buf_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_inode_buf_verify(bp);
+}
+
+void
+xfs_inode_buf_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_inode_buf_verify(bp);
+	bp->b_pre_io = xfs_inode_buf_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
@@ -447,7 +462,7 @@ xfs_imap_to_bp(
 	buf_flags |= XBF_UNMAPPED;
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
 				   (int)imap->im_len, buf_flags, &bp,
-				   xfs_inode_buf_verify);
+				   xfs_inode_buf_read_verify);
 	if (error) {
 		if (error == EAGAIN) {
 			ASSERT(buf_flags & XBF_TRYLOCK);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1a89211..a322c19 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -554,7 +554,7 @@ int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 			       struct xfs_buf **, uint, uint);
 int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
 			  struct xfs_inode *, uint);
-void		xfs_inode_buf_verify(struct xfs_buf *);
+void		xfs_inode_buf_read_verify(struct xfs_buf *);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 0f18d41..7f86fda 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -397,7 +397,7 @@ xfs_bulkstat(
 							& ~r.ir_free)
 						xfs_btree_reada_bufs(mp, agno,
 							agbno, nbcluster,
-							xfs_inode_buf_verify);
+							xfs_inode_buf_read_verify);
 				}
 				irbp->ir_startino = r.ir_startino;
 				irbp->ir_freecount = r.ir_freecount;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bff18d7..c85da75 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -612,8 +612,8 @@ xfs_sb_to_disk(
 	}
 }
 
-void
-xfs_sb_read_verify(
+static void
+xfs_sb_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
@@ -629,6 +629,21 @@ xfs_sb_read_verify(
 	error = xfs_mount_validate_sb(mp, &sb, bp->b_bn == XFS_SB_DADDR);
 	if (error)
 		xfs_buf_ioerror(bp, error);
+}
+
+static void
+xfs_sb_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_sb_verify(bp);
+}
+
+void
+xfs_sb_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_sb_verify(bp);
+	bp->b_pre_io = xfs_sb_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index a6dfb97..bd40ae9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -893,7 +893,7 @@ xfs_qm_dqiter_bufs(
 		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
 			      XFS_FSB_TO_DADDR(mp, bno),
 			      mp->m_quotainfo->qi_dqchunklen, 0, &bp,
-			      xfs_dquot_read_verify);
+			      xfs_dquot_buf_read_verify);
 		if (error)
 			break;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
