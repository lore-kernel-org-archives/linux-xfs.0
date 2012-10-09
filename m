Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q993oA8T212983 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 22:50:10 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wFmwkHAXbRQ2ZxcT for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 20:51:38 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLQr0-0002Po-Ty
	for xfs@oss.sgi.com; Tue, 09 Oct 2012 14:51:34 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLQqq-0008Ps-RE
	for xfs@oss.sgi.com; Tue, 09 Oct 2012 14:51:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/19] xfs: factor dir2 leaf read
Date: Tue,  9 Oct 2012 14:51:07 +1100
Message-Id: <1349754670-32009-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1349754670-32009-1-git-send-email-david@fromorbit.com>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_leaf.c |   73 ++++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_dir2_node.c |    6 ++--
 fs/xfs/xfs_dir2_priv.h |    2 ++
 3 files changed, 67 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 0fdf765..a510af5 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -48,6 +48,62 @@ static void xfs_dir2_leaf_log_bests(struct xfs_trans *tp, struct xfs_buf *bp,
 				    int first, int last);
 static void xfs_dir2_leaf_log_tail(struct xfs_trans *tp, struct xfs_buf *bp);
 
+static void
+xfs_dir2_leaf_verify(
+	struct xfs_buf		*bp,
+	__be16			magic)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_dir2_leaf_hdr *hdr = bp->b_addr;
+	int			block_ok = 0;
+
+	block_ok = hdr->info.magic == magic;
+	if (!block_ok) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
+static void
+xfs_dir2_leaf1_verify(
+	struct xfs_buf		*bp)
+{
+	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
+}
+
+static void
+xfs_dir2_leafn_verify(
+	struct xfs_buf		*bp)
+{
+	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
+}
+
+static int
+xfs_dir2_leaf_read(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dir2_db_t		fbno,
+	int			map_type,
+	struct xfs_buf		**bpp)
+{
+	return xfs_da_read_buf(tp, dp, fbno, map_type, bpp,
+					XFS_DATA_FORK, xfs_dir2_leaf1_verify);
+}
+
+int
+xfs_dir2_leafn_read(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dir2_db_t		fbno,
+	int			map_type,
+	struct xfs_buf		**bpp)
+{
+	return xfs_da_read_buf(tp, dp, fbno, map_type, bpp,
+					XFS_DATA_FORK, xfs_dir2_leafn_verify);
+}
 
 /*
  * Convert a block form directory to a leaf form directory.
@@ -311,14 +367,11 @@ xfs_dir2_leaf_addname(
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
-	/*
-	 * Read the leaf block.
-	 */
-	error = xfs_da_read_buf(tp, dp, mp->m_dirleafblk, -1, &lbp,
-				XFS_DATA_FORK, NULL);
+
+	error = xfs_dir2_leaf_read(tp, dp, mp->m_dirleafblk, -1, &lbp);
 	if (error)
 		return error;
-	ASSERT(lbp != NULL);
+
 	/*
 	 * Look up the entry by hash value and name.
 	 * We know it's not there, our caller has already done a lookup.
@@ -1369,13 +1422,11 @@ xfs_dir2_leaf_lookup_int(
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
-	/*
-	 * Read the leaf block into the buffer.
-	 */
-	error = xfs_da_read_buf(tp, dp, mp->m_dirleafblk, -1, &lbp,
-							XFS_DATA_FORK, NULL);
+
+	error = xfs_dir2_leaf_read(tp, dp, mp->m_dirleafblk, -1, &lbp);
 	if (error)
 		return error;
+
 	*lbpp = lbp;
 	leaf = lbp->b_addr;
 	xfs_dir2_leaf_check(dp, lbp);
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index e585c71..08fbba1 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1232,11 +1232,11 @@ xfs_dir2_leafn_toosmall(
 		/*
 		 * Read the sibling leaf block.
 		 */
-		error = xfs_da_read_buf(state->args->trans, state->args->dp,
-					blkno, -1, &bp, XFS_DATA_FORK, NULL);
+		error = xfs_dir2_leafn_read(state->args->trans, state->args->dp,
+					    blkno, -1, &bp);
 		if (error)
 			return error;
-		ASSERT(bp != NULL);
+
 		/*
 		 * Count bytes in the two blocks combined.
 		 */
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 9c238e8..986c654 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -70,6 +70,8 @@ extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
 		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
 
 /* xfs_dir2_leaf.c */
+extern int xfs_dir2_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dir2_db_t fbno, int map_type, struct xfs_buf **bpp);
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
 		struct xfs_buf *dbp);
 extern int xfs_dir2_leaf_addname(struct xfs_da_args *args);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
