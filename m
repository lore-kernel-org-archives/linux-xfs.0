Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q993oK0Q213047 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 22:50:20 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7IdDwqQyqZ06hwab for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 20:51:49 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLQrA-0002Q6-Rq
	for xfs@oss.sgi.com; Tue, 09 Oct 2012 14:51:44 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLQqq-0008Po-Lk
	for xfs@oss.sgi.com; Tue, 09 Oct 2012 14:51:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/19] xfs: factor out dir2 data block reading
Date: Tue,  9 Oct 2012 14:51:06 +1100
Message-Id: <1349754670-32009-16-git-send-email-david@fromorbit.com>
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

And add a verifier callback function while there.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_block.c |    3 +--
 fs/xfs/xfs_dir2_data.c  |   32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dir2_leaf.c  |   38 +++++++++++++++++---------------------
 fs/xfs/xfs_dir2_node.c  |    8 ++++----
 fs/xfs/xfs_dir2_priv.h  |    2 ++
 5 files changed, 56 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 599fefe..54bf4ca 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -970,8 +970,7 @@ xfs_dir2_leaf_to_block(
 	 * Read the data block if we don't already have it, give up if it fails.
 	 */
 	if (!dbp) {
-		error = xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, &dbp,
-					XFS_DATA_FORK, NULL);
+		error = xfs_dir2_data_read(tp, dp, mp->m_dirdatablk, -1, &dbp);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index c45107d..ba46e32 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -185,6 +185,38 @@ __xfs_dir2_data_check(
 	return 0;
 }
 
+static void
+xfs_dir2_data_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
+	int			block_ok = 0;
+
+	block_ok = hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC);
+	block_ok |= __xfs_dir2_data_check(NULL, bp);
+
+	if (!block_ok) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
+int
+xfs_dir2_data_read(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		bno,
+	xfs_daddr_t		mapped_bno,
+	struct xfs_buf		**bpp)
+{
+	return xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
+					XFS_DATA_FORK, xfs_dir2_data_verify);
+}
+
 /*
  * Given a data block and an unused entry from that block,
  * return the bestfree entry if any that corresponds to it.
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 6c1359d..0fdf765 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -493,14 +493,14 @@ xfs_dir2_leaf_addname(
 		hdr = dbp->b_addr;
 		bestsp[use_block] = hdr->bestfree[0].length;
 		grown = 1;
-	}
-	/*
-	 * Already had space in some data block.
-	 * Just read that one in.
-	 */
-	else {
-		error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, use_block),
-					-1, &dbp, XFS_DATA_FORK, NULL);
+	} else {
+		/*
+		 * Already had space in some data block.
+		 * Just read that one in.
+		 */
+		error = xfs_dir2_data_read(tp, dp,
+					   xfs_dir2_db_to_da(mp, use_block),
+					   -1, &dbp);
 		if (error) {
 			xfs_trans_brelse(tp, lbp);
 			return error;
@@ -508,7 +508,6 @@ xfs_dir2_leaf_addname(
 		hdr = dbp->b_addr;
 		grown = 0;
 	}
-	xfs_dir2_data_check(dp, dbp);
 	/*
 	 * Point to the biggest freespace in our data block.
 	 */
@@ -891,10 +890,9 @@ xfs_dir2_leaf_readbuf(
 	 * Read the directory block starting at the first mapping.
 	 */
 	mip->curdb = xfs_dir2_da_to_db(mp, map->br_startoff);
-	error = xfs_da_read_buf(NULL, dp, map->br_startoff,
+	error = xfs_dir2_data_read(NULL, dp, map->br_startoff,
 			map->br_blockcount >= mp->m_dirblkfsbs ?
-			    XFS_FSB_TO_DADDR(mp, map->br_startblock) : -1,
-			&bp, XFS_DATA_FORK, NULL);
+			    XFS_FSB_TO_DADDR(mp, map->br_startblock) : -1, &bp);
 
 	/*
 	 * Should just skip over the data block instead of giving up.
@@ -1408,14 +1406,13 @@ xfs_dir2_leaf_lookup_int(
 		if (newdb != curdb) {
 			if (dbp)
 				xfs_trans_brelse(tp, dbp);
-			error = xfs_da_read_buf(tp, dp,
-						xfs_dir2_db_to_da(mp, newdb),
-						-1, &dbp, XFS_DATA_FORK, NULL);
+			error = xfs_dir2_data_read(tp, dp,
+						   xfs_dir2_db_to_da(mp, newdb),
+						   -1, &dbp);
 			if (error) {
 				xfs_trans_brelse(tp, lbp);
 				return error;
 			}
-			xfs_dir2_data_check(dp, dbp);
 			curdb = newdb;
 		}
 		/*
@@ -1450,9 +1447,9 @@ xfs_dir2_leaf_lookup_int(
 		ASSERT(cidb != -1);
 		if (cidb != curdb) {
 			xfs_trans_brelse(tp, dbp);
-			error = xfs_da_read_buf(tp, dp,
-						xfs_dir2_db_to_da(mp, cidb),
-						-1, &dbp, XFS_DATA_FORK, NULL);
+			error = xfs_dir2_data_read(tp, dp,
+						   xfs_dir2_db_to_da(mp, cidb),
+						   -1, &dbp);
 			if (error) {
 				xfs_trans_brelse(tp, lbp);
 				return error;
@@ -1737,8 +1734,7 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Read the offending data block.  We need its buffer.
 	 */
-	error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, db), -1, &dbp,
-				XFS_DATA_FORK, NULL);
+	error = xfs_dir2_data_read(tp, dp, xfs_dir2_db_to_da(mp, db), -1, &dbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index e9b0bce..e585c71 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -583,9 +583,9 @@ xfs_dir2_leafn_lookup_for_entry(
 				ASSERT(state->extravalid);
 				curbp = state->extrablk.bp;
 			} else {
-				error = xfs_da_read_buf(tp, dp,
+				error = xfs_dir2_data_read(tp, dp,
 						xfs_dir2_db_to_da(mp, newdb),
-						-1, &curbp, XFS_DATA_FORK, NULL);
+						-1, &curbp);
 				if (error)
 					return error;
 			}
@@ -1692,8 +1692,8 @@ xfs_dir2_node_addname_int(
 		/*
 		 * Read the data block in.
 		 */
-		error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, dbno),
-					-1, &dbp, XFS_DATA_FORK, NULL);
+		error = xfs_dir2_data_read(tp, dp, xfs_dir2_db_to_da(mp, dbno),
+					   -1, &dbp);
 		if (error)
 			return error;
 		hdr = dbp->b_addr;
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 35f87d4..9c238e8 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -46,6 +46,8 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 #define	xfs_dir2_data_check(dp,bp)
 #endif
 extern bool __xfs_dir2_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
+extern int xfs_dir2_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
 
 extern struct xfs_dir2_data_free *
 xfs_dir2_data_freeinsert(struct xfs_dir2_data_hdr *hdr,
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
