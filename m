Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9P6XBrj102650 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 01:33:11 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rjggcUrfaBVMgLKh for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 23:34:54 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TRH1f-0000AG-Su
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:43 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TRH1Q-00054X-Hv
	for xfs@oss.sgi.com; Thu, 25 Oct 2012 17:34:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/25] xfs: factor dir2 free block reading
Date: Thu, 25 Oct 2012 17:34:04 +1100
Message-Id: <1351146854-19343-16-git-send-email-david@fromorbit.com>
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

Also factor out the updating of the free block when removing entries
from leaf blocks, and add a verifier callback for reads.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_leaf.c |    3 +-
 fs/xfs/xfs_dir2_node.c |  218 +++++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_dir2_priv.h |    2 +
 3 files changed, 143 insertions(+), 80 deletions(-)

diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 86e3dc1..6c1359d 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1863,8 +1863,7 @@ xfs_dir2_node_to_leaf(
 	/*
 	 * Read the freespace block.
 	 */
-	error = xfs_da_read_buf(tp, dp,  mp->m_dirfreeblk, -1, &fbp,
-				XFS_DATA_FORK, NULL);
+	error = xfs_dir2_free_read(tp, dp,  mp->m_dirfreeblk, &fbp);
 	if (error)
 		return error;
 	free = fbp->b_addr;
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 290c2b1..d7f899d 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -55,6 +55,57 @@ static int xfs_dir2_leafn_remove(xfs_da_args_t *args, struct xfs_buf *bp,
 static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
 				     xfs_da_state_blk_t *fblk);
 
+static void
+xfs_dir2_free_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_dir2_free_hdr *hdr = bp->b_addr;
+	int			block_ok = 0;
+
+	block_ok = hdr->magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC);
+	if (!block_ok) {
+		XFS_CORRUPTION_ERROR("xfs_dir2_free_verify magic",
+				     XFS_ERRLEVEL_LOW, mp, hdr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
+
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
+static int
+__xfs_dir2_free_read(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		fbno,
+	xfs_daddr_t		mappedbno,
+	struct xfs_buf		**bpp)
+{
+	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
+					XFS_DATA_FORK, xfs_dir2_free_verify);
+}
+
+int
+xfs_dir2_free_read(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		fbno,
+	struct xfs_buf		**bpp)
+{
+	return __xfs_dir2_free_read(tp, dp, fbno, -1, bpp);
+}
+
+static int
+xfs_dir2_free_try_read(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		fbno,
+	struct xfs_buf		**bpp)
+{
+	return __xfs_dir2_free_read(tp, dp, fbno, -2, bpp);
+}
+
 /*
  * Log entries from a freespace block.
  */
@@ -394,12 +445,10 @@ xfs_dir2_leafn_lookup_for_addname(
 				 */
 				if (curbp)
 					xfs_trans_brelse(tp, curbp);
-				/*
-				 * Read the free block.
-				 */
-				error = xfs_da_read_buf(tp, dp,
+
+				error = xfs_dir2_free_read(tp, dp,
 						xfs_dir2_db_to_da(mp, newfdb),
-						-1, &curbp, XFS_DATA_FORK, NULL);
+						&curbp);
 				if (error)
 					return error;
 				free = curbp->b_addr;
@@ -825,6 +874,77 @@ xfs_dir2_leafn_rebalance(
 	}
 }
 
+static int
+xfs_dir2_data_block_free(
+	xfs_da_args_t		*args,
+	struct xfs_dir2_data_hdr *hdr,
+	struct xfs_dir2_free	*free,
+	xfs_dir2_db_t		fdb,
+	int			findex,
+	struct xfs_buf		*fbp,
+	int			longest)
+{
+	struct xfs_trans	*tp = args->trans;
+	int			logfree = 0;
+
+	if (!hdr) {
+		/* One less used entry in the free table.  */
+		be32_add_cpu(&free->hdr.nused, -1);
+		xfs_dir2_free_log_header(tp, fbp);
+
+		/*
+		 * If this was the last entry in the table, we can trim the
+		 * table size back.  There might be other entries at the end
+		 * referring to non-existent data blocks, get those too.
+		 */
+		if (findex == be32_to_cpu(free->hdr.nvalid) - 1) {
+			int	i;		/* free entry index */
+
+			for (i = findex - 1; i >= 0; i--) {
+				if (free->bests[i] != cpu_to_be16(NULLDATAOFF))
+					break;
+			}
+			free->hdr.nvalid = cpu_to_be32(i + 1);
+			logfree = 0;
+		} else {
+			/* Not the last entry, just punch it out.  */
+			free->bests[findex] = cpu_to_be16(NULLDATAOFF);
+			logfree = 1;
+		}
+		/*
+		 * If there are no useful entries left in the block,
+		 * get rid of the block if we can.
+		 */
+		if (!free->hdr.nused) {
+			int error;
+
+			error = xfs_dir2_shrink_inode(args, fdb, fbp);
+			if (error == 0) {
+				fbp = NULL;
+				logfree = 0;
+			} else if (error != ENOSPC || args->total != 0)
+				return error;
+			/*
+			 * It's possible to get ENOSPC if there is no
+			 * space reservation.  In this case some one
+			 * else will eventually get rid of this block.
+			 */
+		}
+	} else {
+		/*
+		 * Data block is not empty, just set the free entry to the new
+		 * value.
+		 */
+		free->bests[findex] = cpu_to_be16(longest);
+		logfree = 1;
+	}
+
+	/* Log the free entry that changed, unless we got rid of it.  */
+	if (logfree)
+		xfs_dir2_free_log_bests(tp, fbp, findex, findex);
+	return 0;
+}
+
 /*
  * Remove an entry from a node directory.
  * This removes the leaf entry and the data entry,
@@ -908,15 +1028,14 @@ xfs_dir2_leafn_remove(
 		xfs_dir2_db_t	fdb;		/* freeblock block number */
 		int		findex;		/* index in freeblock entries */
 		xfs_dir2_free_t	*free;		/* freeblock structure */
-		int		logfree;	/* need to log free entry */
 
 		/*
 		 * Convert the data block number to a free block,
 		 * read in the free block.
 		 */
 		fdb = xfs_dir2_db_to_fdb(mp, db);
-		error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, fdb),
-					-1, &fbp, XFS_DATA_FORK, NULL);
+		error = xfs_dir2_free_read(tp, dp, xfs_dir2_db_to_da(mp, fdb),
+					   &fbp);
 		if (error)
 			return error;
 		free = fbp->b_addr;
@@ -954,68 +1073,12 @@ xfs_dir2_leafn_remove(
 		 * If we got rid of the data block, we can eliminate that entry
 		 * in the free block.
 		 */
-		if (hdr == NULL) {
-			/*
-			 * One less used entry in the free table.
-			 */
-			be32_add_cpu(&free->hdr.nused, -1);
-			xfs_dir2_free_log_header(tp, fbp);
-			/*
-			 * If this was the last entry in the table, we can
-			 * trim the table size back.  There might be other
-			 * entries at the end referring to non-existent
-			 * data blocks, get those too.
-			 */
-			if (findex == be32_to_cpu(free->hdr.nvalid) - 1) {
-				int	i;		/* free entry index */
-
-				for (i = findex - 1;
-				     i >= 0 &&
-				     free->bests[i] == cpu_to_be16(NULLDATAOFF);
-				     i--)
-					continue;
-				free->hdr.nvalid = cpu_to_be32(i + 1);
-				logfree = 0;
-			}
-			/*
-			 * Not the last entry, just punch it out.
-			 */
-			else {
-				free->bests[findex] = cpu_to_be16(NULLDATAOFF);
-				logfree = 1;
-			}
-			/*
-			 * If there are no useful entries left in the block,
-			 * get rid of the block if we can.
-			 */
-			if (!free->hdr.nused) {
-				error = xfs_dir2_shrink_inode(args, fdb, fbp);
-				if (error == 0) {
-					fbp = NULL;
-					logfree = 0;
-				} else if (error != ENOSPC || args->total != 0)
-					return error;
-				/*
-				 * It's possible to get ENOSPC if there is no
-				 * space reservation.  In this case some one
-				 * else will eventually get rid of this block.
-				 */
-			}
-		}
-		/*
-		 * Data block is not empty, just set the free entry to
-		 * the new value.
-		 */
-		else {
-			free->bests[findex] = cpu_to_be16(longest);
-			logfree = 1;
-		}
-		/*
-		 * Log the free entry that changed, unless we got rid of it.
-		 */
-		if (logfree)
-			xfs_dir2_free_log_bests(tp, fbp, findex, findex);
+		error = xfs_dir2_data_block_free(args, hdr, free,
+						 fdb, findex, fbp, longest);
+		if (error)
+			return error;
 	}
+
 	xfs_dir2_leafn_check(dp, bp);
 	/*
 	 * Return indication of whether this leaf block is empty enough
@@ -1453,9 +1516,9 @@ xfs_dir2_node_addname_int(
 			 * This should be really rare, so there's no reason
 			 * to avoid it.
 			 */
-			error = xfs_da_read_buf(tp, dp,
-						xfs_dir2_db_to_da(mp, fbno), -2,
-						&fbp, XFS_DATA_FORK, NULL);
+			error = xfs_dir2_free_try_read(tp, dp,
+						xfs_dir2_db_to_da(mp, fbno),
+						&fbp);
 			if (error)
 				return error;
 			if (!fbp)
@@ -1518,8 +1581,9 @@ xfs_dir2_node_addname_int(
 		 * that was just allocated.
 		 */
 		fbno = xfs_dir2_db_to_fdb(mp, dbno);
-		error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, fbno), -2,
-					&fbp, XFS_DATA_FORK, NULL);
+		error = xfs_dir2_free_try_read(tp, dp,
+					       xfs_dir2_db_to_da(mp, fbno),
+					       &fbp);
 		if (error)
 			return error;
 
@@ -1915,17 +1979,15 @@ xfs_dir2_node_trim_free(
 	/*
 	 * Read the freespace block.
 	 */
-	error = xfs_da_read_buf(tp, dp, (xfs_dablk_t)fo, -2, &bp,
-				XFS_DATA_FORK, NULL);
+	error = xfs_dir2_free_try_read(tp, dp, fo, &bp);
 	if (error)
 		return error;
 	/*
 	 * There can be holes in freespace.  If fo is a hole, there's
 	 * nothing to do.
 	 */
-	if (bp == NULL) {
+	if (!bp)
 		return 0;
-	}
 	free = bp->b_addr;
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
 	/*
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index e1c02ca..91d936b 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -117,6 +117,8 @@ extern int xfs_dir2_node_removename(struct xfs_da_args *args);
 extern int xfs_dir2_node_replace(struct xfs_da_args *args);
 extern int xfs_dir2_node_trim_free(struct xfs_da_args *args, xfs_fileoff_t fo,
 		int *rvalp);
+extern int xfs_dir2_free_read(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dablk_t fbno, struct xfs_buf **bpp);
 
 /* xfs_dir2_sf.c */
 extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
