Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0DA947F66
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 19:08:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54C9EAC004
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 17:08:03 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	umTM7kGbdC7rURtM for <xfs@oss.sgi.com>;
	Thu, 22 May 2014 17:08:01 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wncxn-00071p-73
	for xfs@oss.sgi.com; Fri, 23 May 2014 10:03:55 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wncxn-0005TV-6H
	for xfs@oss.sgi.com; Fri, 23 May 2014 10:03:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/16] xfs: convert directory dablk conversion to
	xfs_da_geometry
Date: Fri, 23 May 2014 10:03:41 +1000
Message-Id: <1400803432-20048-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1400803432-20048-1-git-send-email-david@fromorbit.com>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_btree.h     | 15 +++++++--------
 fs/xfs/xfs_dir2.c         |  4 ++--
 fs/xfs/xfs_dir2_data.c    |  4 ++--
 fs/xfs/xfs_dir2_leaf.c    | 21 +++++++++++----------
 fs/xfs/xfs_dir2_node.c    | 41 +++++++++++++++++++++++------------------
 fs/xfs/xfs_dir2_readdir.c |  6 +++---
 6 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index e9496a9..8db83fc 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -232,9 +232,9 @@ xfs_dir2_db_off_to_byte(struct xfs_da_geometry *geo, xfs_dir2_db_t db,
  * Convert block (DB) to block (dablk)
  */
 static inline xfs_dablk_t
-xfs_dir2_db_to_da(struct xfs_mount *mp, xfs_dir2_db_t db)
+xfs_dir2_db_to_da(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 {
-	return (xfs_dablk_t)(db << mp->m_sb.sb_dirblklog);
+	return (xfs_dablk_t)(db << (geo->blklog - geo->fsblog));
 }
 
 /*
@@ -243,7 +243,7 @@ xfs_dir2_db_to_da(struct xfs_mount *mp, xfs_dir2_db_t db)
 static inline xfs_dablk_t
 xfs_dir2_byte_to_da(struct xfs_mount *mp, xfs_dir2_off_t by)
 {
-	return xfs_dir2_db_to_da(mp, xfs_dir2_byte_to_db(mp, by));
+	return xfs_dir2_db_to_da(mp->m_dir_geo, xfs_dir2_byte_to_db(mp, by));
 }
 
 /*
@@ -261,19 +261,18 @@ xfs_dir2_db_off_to_dataptr(struct xfs_mount *mp, xfs_dir2_db_t db,
  * Convert block (dablk) to block (DB)
  */
 static inline xfs_dir2_db_t
-xfs_dir2_da_to_db(struct xfs_mount *mp, xfs_dablk_t da)
+xfs_dir2_da_to_db(struct xfs_da_geometry *geo, xfs_dablk_t da)
 {
-	return (xfs_dir2_db_t)(da >> mp->m_sb.sb_dirblklog);
+	return (xfs_dir2_db_t)(da >> (geo->blklog - geo->fsblog));
 }
 
 /*
  * Convert block (dablk) to byte offset in space
  */
 static inline xfs_dir2_off_t
-xfs_dir2_da_to_byte(struct xfs_mount *mp, xfs_dablk_t da)
+xfs_dir2_da_to_byte(struct xfs_da_geometry *geo, xfs_dablk_t da)
 {
-	return xfs_dir2_db_off_to_byte(mp->m_dir_geo,
-				       xfs_dir2_da_to_db(mp, da), 0);
+	return xfs_dir2_db_off_to_byte(geo, xfs_dir2_da_to_db(geo, da), 0);
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index a7d3884..f76008c 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -624,7 +624,7 @@ xfs_dir2_grow_inode(
 	if (error)
 		return error;
 
-	*dbp = xfs_dir2_da_to_db(mp, (xfs_dablk_t)bno);
+	*dbp = xfs_dir2_da_to_db(args->geo, (xfs_dablk_t)bno);
 
 	/*
 	 * Update file's size if this is the data space and it grew.
@@ -705,7 +705,7 @@ xfs_dir2_shrink_inode(
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
-	da = xfs_dir2_db_to_da(mp, db);
+	da = xfs_dir2_db_to_da(args->geo, db);
 	/*
 	 * Unmap the fsblock(s).
 	 */
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index bae8b5b..890c940 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -584,8 +584,8 @@ xfs_dir3_data_init(
 	/*
 	 * Get the buffer set up for the block.
 	 */
-	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, blkno), -1, &bp,
-		XFS_DATA_FORK);
+	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, blkno),
+			       -1, &bp, XFS_DATA_FORK);
 	if (error)
 		return error;
 	bp->b_ops = &xfs_dir3_data_buf_ops;
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index dc4ef19..046ba4a 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -350,8 +350,8 @@ xfs_dir3_leaf_get_buf(
 	ASSERT(bno >= xfs_dir2_byte_to_db(mp, XFS_DIR2_LEAF_OFFSET) &&
 	       bno < xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET));
 
-	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, bno), -1, &bp,
-			       XFS_DATA_FORK);
+	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, bno),
+			       -1, &bp, XFS_DATA_FORK);
 	if (error)
 		return error;
 
@@ -403,7 +403,7 @@ xfs_dir2_block_to_leaf(
 	if ((error = xfs_da_grow_inode(args, &blkno))) {
 		return error;
 	}
-	ldb = xfs_dir2_da_to_db(mp, blkno);
+	ldb = xfs_dir2_da_to_db(args->geo, blkno);
 	ASSERT(ldb == xfs_dir2_byte_to_db(mp, XFS_DIR2_LEAF_OFFSET));
 	/*
 	 * Initialize the leaf block, get a buffer for it.
@@ -828,8 +828,8 @@ xfs_dir2_leaf_addname(
 		 * Just read that one in.
 		 */
 		error = xfs_dir3_data_read(tp, dp,
-					   xfs_dir2_db_to_da(mp, use_block),
-					   -1, &dbp);
+				   xfs_dir2_db_to_da(args->geo, use_block),
+				   -1, &dbp);
 		if (error) {
 			xfs_trans_brelse(tp, lbp);
 			return error;
@@ -1269,8 +1269,8 @@ xfs_dir2_leaf_lookup_int(
 			if (dbp)
 				xfs_trans_brelse(tp, dbp);
 			error = xfs_dir3_data_read(tp, dp,
-						   xfs_dir2_db_to_da(mp, newdb),
-						   -1, &dbp);
+					   xfs_dir2_db_to_da(args->geo, newdb),
+					   -1, &dbp);
 			if (error) {
 				xfs_trans_brelse(tp, lbp);
 				return error;
@@ -1310,8 +1310,8 @@ xfs_dir2_leaf_lookup_int(
 		if (cidb != curdb) {
 			xfs_trans_brelse(tp, dbp);
 			error = xfs_dir3_data_read(tp, dp,
-						   xfs_dir2_db_to_da(mp, cidb),
-						   -1, &dbp);
+					   xfs_dir2_db_to_da(args->geo, cidb),
+					   -1, &dbp);
 			if (error) {
 				xfs_trans_brelse(tp, lbp);
 				return error;
@@ -1609,7 +1609,8 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Read the offending data block.  We need its buffer.
 	 */
-	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(mp, db), -1, &dbp);
+	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(args->geo, db),
+				   -1, &dbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 1bcaaa0..3b70d56 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -195,17 +195,18 @@ xfs_dir2_free_try_read(
 
 static int
 xfs_dir3_free_get_buf(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp,
+	xfs_da_args_t		*args,
 	xfs_dir2_db_t		fbno,
 	struct xfs_buf		**bpp)
 {
+	struct xfs_trans	*tp = args->trans;
+	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_buf		*bp;
 	int			error;
 	struct xfs_dir3_icfree_hdr hdr;
 
-	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, fbno),
+	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, fbno),
 				   -1, &bp, XFS_DATA_FORK);
 	if (error)
 		return error;
@@ -319,7 +320,7 @@ xfs_dir2_leaf_to_node(
 	/*
 	 * Get the buffer for the new freespace block.
 	 */
-	error = xfs_dir3_free_get_buf(tp, dp, fdb, &fbp);
+	error = xfs_dir3_free_get_buf(args, fdb, &fbp);
 	if (error)
 		return error;
 
@@ -605,7 +606,8 @@ xfs_dir2_leafn_lookup_for_addname(
 					xfs_trans_brelse(tp, curbp);
 
 				error = xfs_dir2_free_read(tp, dp,
-						xfs_dir2_db_to_da(mp, newfdb),
+						xfs_dir2_db_to_da(args->geo,
+								  newfdb),
 						&curbp);
 				if (error)
 					return error;
@@ -746,7 +748,8 @@ xfs_dir2_leafn_lookup_for_entry(
 				curbp = state->extrablk.bp;
 			} else {
 				error = xfs_dir3_data_read(tp, dp,
-						xfs_dir2_db_to_da(mp, newdb),
+						xfs_dir2_db_to_da(args->geo,
+								  newdb),
 						-1, &curbp);
 				if (error)
 					return error;
@@ -1246,7 +1249,8 @@ xfs_dir2_leafn_remove(
 		 * read in the free block.
 		 */
 		fdb = dp->d_ops->db_to_fdb(mp, db);
-		error = xfs_dir2_free_read(tp, dp, xfs_dir2_db_to_da(mp, fdb),
+		error = xfs_dir2_free_read(tp, dp,
+					   xfs_dir2_db_to_da(args->geo, fdb),
 					   &fbp);
 		if (error)
 			return error;
@@ -1336,7 +1340,7 @@ xfs_dir2_leafn_split(
 	/*
 	 * Initialize the new leaf block.
 	 */
-	error = xfs_dir3_leaf_get_buf(args, xfs_dir2_da_to_db(mp, blkno),
+	error = xfs_dir3_leaf_get_buf(args, xfs_dir2_da_to_db(args->geo, blkno),
 				      &newblk->bp, XFS_DIR2_LEAFN_MAGIC);
 	if (error)
 		return error;
@@ -1729,7 +1733,7 @@ xfs_dir2_node_addname_int(
 
 		if ((error = xfs_bmap_last_offset(dp, &fo, XFS_DATA_FORK)))
 			return error;
-		lastfbno = xfs_dir2_da_to_db(mp, (xfs_dablk_t)fo);
+		lastfbno = xfs_dir2_da_to_db(args->geo, (xfs_dablk_t)fo);
 		fbno = ifbno;
 	}
 	/*
@@ -1766,8 +1770,8 @@ xfs_dir2_node_addname_int(
 			 * to avoid it.
 			 */
 			error = xfs_dir2_free_try_read(tp, dp,
-						xfs_dir2_db_to_da(mp, fbno),
-						&fbp);
+					xfs_dir2_db_to_da(args->geo, fbno),
+					&fbp);
 			if (error)
 				return error;
 			if (!fbp)
@@ -1837,8 +1841,8 @@ xfs_dir2_node_addname_int(
 		 */
 		fbno = dp->d_ops->db_to_fdb(mp, dbno);
 		error = xfs_dir2_free_try_read(tp, dp,
-					       xfs_dir2_db_to_da(mp, fbno),
-					       &fbp);
+				       xfs_dir2_db_to_da(args->geo, fbno),
+				       &fbp);
 		if (error)
 			return error;
 
@@ -1878,7 +1882,7 @@ xfs_dir2_node_addname_int(
 			/*
 			 * Get a buffer for the new block.
 			 */
-			error = xfs_dir3_free_get_buf(tp, dp, fbno, &fbp);
+			error = xfs_dir3_free_get_buf(args, fbno, &fbp);
 			if (error)
 				return error;
 			free = fbp->b_addr;
@@ -1946,7 +1950,8 @@ xfs_dir2_node_addname_int(
 		/*
 		 * Read the data block in.
 		 */
-		error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(mp, dbno),
+		error = xfs_dir3_data_read(tp, dp,
+					   xfs_dir2_db_to_da(args->geo, dbno),
 					   -1, &dbp);
 		if (error)
 			return error;
@@ -2265,9 +2270,9 @@ xfs_dir2_node_trim_free(
 	/*
 	 * Blow the block away.
 	 */
-	if ((error =
-	    xfs_dir2_shrink_inode(args, xfs_dir2_da_to_db(mp, (xfs_dablk_t)fo),
-		    bp))) {
+	error = xfs_dir2_shrink_inode(args,
+			xfs_dir2_da_to_db(args->geo, (xfs_dablk_t)fo), bp);
+	if (error) {
 		/*
 		 * Can't fail with ENOSPC since that only happens with no
 		 * space reservation, when breaking up an extent into two
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index ec912c8..57e9247 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -396,14 +396,14 @@ xfs_dir2_leaf_readbuf(
 	 * No valid mappings, so no more data blocks.
 	 */
 	if (!mip->map_valid) {
-		*curoff = xfs_dir2_da_to_byte(mp, mip->map_off);
+		*curoff = xfs_dir2_da_to_byte(mp->m_dir_geo, mip->map_off);
 		goto out;
 	}
 
 	/*
 	 * Read the directory block starting at the first mapping.
 	 */
-	mip->curdb = xfs_dir2_da_to_db(mp, map->br_startoff);
+	mip->curdb = xfs_dir2_da_to_db(mp->m_dir_geo, map->br_startoff);
 	error = xfs_dir3_data_read(NULL, dp, map->br_startoff,
 			map->br_blockcount >= mp->m_dirblkfsbs ?
 			    XFS_FSB_TO_DADDR(mp, map->br_startblock) : -1, &bp);
@@ -536,7 +536,7 @@ xfs_dir2_leaf_getdents(
 	 * Force this conversion through db so we truncate the offset
 	 * down to get the start of the data block.
 	 */
-	map_info->map_off = xfs_dir2_db_to_da(mp,
+	map_info->map_off = xfs_dir2_db_to_da(mp->m_dir_geo,
 					      xfs_dir2_byte_to_db(mp, curoff));
 
 	/*
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
