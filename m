Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9P6XEk2102681 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 01:33:14 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	63SQc0yzKqK2Jwaq for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 23:34:57 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TRH1q-0000Ay-Mu
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:54 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TRH1f-000552-W7
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 22/25] xfs: add pre-write metadata buffer verifier callbacks
Date: Thu, 25 Oct 2012 17:34:11 +1100
Message-Id: <1351146854-19343-23-git-send-email-david@fromorbit.com>
In-Reply-To: <1351146854-19343-1-git-send-email-david@fromorbit.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_alloc.c        |   38 +++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_alloc_btree.c  |   21 +++++++++++++++++----
 fs/xfs/xfs_attr_leaf.c    |   19 +++++++++++++++++--
 fs/xfs/xfs_attr_leaf.h    |    2 +-
 fs/xfs/xfs_bmap_btree.c   |   21 +++++++++++++++++----
 fs/xfs/xfs_da_btree.c     |   30 ++++++++++++++++++------------
 fs/xfs/xfs_dir2_block.c   |   16 +++++++++++++++-
 fs/xfs/xfs_dir2_data.c    |   19 +++++++++++++++++--
 fs/xfs/xfs_dir2_leaf.c    |   31 ++++++++++++++++++++++++-------
 fs/xfs/xfs_dir2_node.c    |   17 ++++++++++++++++-
 fs/xfs/xfs_dir2_priv.h    |    2 +-
 fs/xfs/xfs_dquot.c        |   22 ++++++++++++++++++----
 fs/xfs/xfs_ialloc.c       |   17 ++++++++++++++++-
 fs/xfs/xfs_ialloc_btree.c |   19 ++++++++++++++++---
 fs/xfs/xfs_inode.c        |   19 +++++++++++++++++--
 fs/xfs/xfs_inode.h        |    2 +-
 fs/xfs/xfs_itable.c       |    2 +-
 fs/xfs/xfs_mount.c        |   19 +++++++++++++++++--
 18 files changed, 262 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 0fa37a7..5f42e53 100644
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
@@ -459,11 +459,25 @@ xfs_agfl_read_verify(
 	}
 
 	if (!agfl_ok) {
-		XFS_CORRUPTION_ERROR("xfs_agfl_read_verify",
-				     XFS_ERRLEVEL_LOW, mp, agfl);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, agfl);
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
@@ -2130,7 +2144,7 @@ xfs_alloc_put_freelist(
 }
 
 static void
-xfs_agf_read_verify(
+xfs_agf_verify(
 	struct xfs_buf	*bp)
  {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
@@ -2157,7 +2171,21 @@ xfs_agf_read_verify(
 				     XFS_ERRLEVEL_LOW, mp, agf);
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
index 4167e72..6fc432b 100644
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
@@ -311,11 +311,24 @@ xfs_allocbt_read_verify(
 
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
index 5ba92eb..bb96c55 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -87,7 +87,7 @@ STATIC void xfs_attr_leaf_moveents(xfs_attr_leafblock_t *src_leaf,
 					 xfs_mount_t *mp);
 STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
 
-void
+static void
 xfs_attr_leaf_verify(
 	struct xfs_buf		*bp)
 {
@@ -100,11 +100,26 @@ xfs_attr_leaf_verify(
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
@@ -114,7 +129,7 @@ xfs_attr_leaf_read(
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
index 7656c14..179173e 100644
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
@@ -107,12 +107,17 @@ __xfs_da_node_verify(
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
@@ -120,21 +125,22 @@ xfs_da_node_verify(
 
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
@@ -149,7 +155,7 @@ xfs_da_node_read(
 	int			which_fork)
 {
 	return xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
-					which_fork, xfs_da_node_verify);
+					which_fork, xfs_da_node_read_verify);
 }
 
 /*========================================================================
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
index 795cfdd..0af533b 100644
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
index aa06174..4aeef62 100644
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
index 2e18382..eff7586 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -361,7 +361,7 @@ xfs_qm_dqalloc(
 }
 
 STATIC void
-xfs_dquot_read_verify(
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
+static void
+xfs_dquot_buf_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_dquot_buf_verify(bp);
+	bp->b_pre_io = xfs_dquot_buf_write_verify;
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp, 0);
 }
@@ -521,7 +535,7 @@ xfs_qm_dqtobp(
 		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 					   dqp->q_blkno,
 					   mp->m_quotainfo->qi_dqchunklen,
-					   0, &bp, xfs_dquot_read_verify);
+					   0, &bp, xfs_dquot_buf_read_verify);
 
 		if (error == EFSCORRUPTED && (flags & XFS_QMOPT_DQREPAIR)) {
 			xfs_dqid_t firstid = (xfs_dqid_t)map.br_startoff *
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 9311ae5..f260a36 100644
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
@@ -1493,6 +1493,21 @@ xfs_agi_read_verify(
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
index 0905e72..875ceb2 100644
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
index 3c1d831..32b6d70 100644
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
index 8699e5e..a622f6f 100644
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
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
