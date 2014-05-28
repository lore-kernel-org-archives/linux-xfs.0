Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F082E7F51
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 01:04:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D6F5D8F8074
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 23:04:55 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0sq3nuJ4UaIlkEnB for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 23:04:53 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WpWyk-0005og-2q
	for xfs@oss.sgi.com; Wed, 28 May 2014 16:04:46 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WpWyk-0003lT-1d
	for xfs@oss.sgi.com; Wed, 28 May 2014 16:04:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/16] xfs: convert directory db conversion to xfs_da_geometry
Date: Wed, 28 May 2014 16:04:33 +1000
Message-Id: <1401257083-13433-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1401257083-13433-1-git-send-email-david@fromorbit.com>
References: <1401257083-13433-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_da_format.c    |  4 ++--
 fs/xfs/xfs_dir2.c         | 13 +++++++++----
 fs/xfs/xfs_dir2_block.c   | 15 +++++++++------
 fs/xfs/xfs_dir2_data.c    |  3 ++-
 fs/xfs/xfs_dir2_leaf.c    | 30 +++++++++++++++++-------------
 fs/xfs/xfs_dir2_node.c    | 27 ++++++++++++++++-----------
 fs/xfs/xfs_dir2_priv.h    | 22 ++++++++++------------
 fs/xfs/xfs_dir2_readdir.c | 45 ++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_dir2_sf.c      |  4 ++--
 9 files changed, 93 insertions(+), 70 deletions(-)

diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index a2d0682..ac8474e 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -611,7 +611,7 @@ xfs_dir2_free_bests_p(struct xfs_dir2_free *free)
 static xfs_dir2_db_t
 xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
-	return xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET) +
+	return xfs_dir2_byte_to_db(mp->m_dir_geo, XFS_DIR2_FREE_OFFSET) +
 			(db / xfs_dir2_free_max_bests(mp));
 }
 
@@ -643,7 +643,7 @@ xfs_dir3_free_bests_p(struct xfs_dir2_free *free)
 static xfs_dir2_db_t
 xfs_dir3_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
-	return xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET) +
+	return xfs_dir2_byte_to_db(mp->m_dir_geo, XFS_DIR2_FREE_OFFSET) +
 			(db / xfs_dir3_free_max_bests(mp));
 }
 
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index ae94617..866a671 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -117,9 +117,14 @@ xfs_da_mount(
 	dageo->fsblog = mp->m_sb.sb_blocklog;
 	dageo->blksize = 1 << dageo->blklog;
 	dageo->fsbcount = 1 << mp->m_sb.sb_dirblklog;
-	dageo->datablk = xfs_dir2_byte_to_da(mp, XFS_DIR2_DATA_OFFSET);
-	dageo->leafblk = xfs_dir2_byte_to_da(mp, XFS_DIR2_LEAF_OFFSET);
-	dageo->freeblk = xfs_dir2_byte_to_da(mp, XFS_DIR2_FREE_OFFSET);
+
+	/*
+	 * Now we've set up the block conversion variables, we can calculate the
+	 * segment block constants using the geometry structure.
+	 */
+	dageo->datablk = xfs_dir2_byte_to_da(dageo, XFS_DIR2_DATA_OFFSET);
+	dageo->leafblk = xfs_dir2_byte_to_da(dageo, XFS_DIR2_LEAF_OFFSET);
+	dageo->freeblk = xfs_dir2_byte_to_da(dageo, XFS_DIR2_FREE_OFFSET);
 	dageo->node_ents = (dageo->blksize - nodehdr_size) /
 				(uint)sizeof(xfs_da_node_entry_t);
 	dageo->magicpct = (dageo->blksize * 37) / 100;
@@ -744,7 +749,7 @@ xfs_dir2_shrink_inode(
 	/*
 	 * If it's not a data block, we're done.
 	 */
-	if (db >= xfs_dir2_byte_to_db(mp, XFS_DIR2_LEAF_OFFSET))
+	if (db >= xfs_dir2_byte_to_db(args->geo, XFS_DIR2_LEAF_OFFSET))
 		return 0;
 	/*
 	 * If the block isn't the last one in the directory, we're done.
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index dd9d005..bc08216 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -639,7 +639,8 @@ xfs_dir2_block_lookup(
 	 * Get the offset from the leaf entry, to point to the data.
 	 */
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo,
+						be32_to_cpu(blp[ent].address)));
 	/*
 	 * Fill in inode number, CI name if appropriate, release the block.
 	 */
@@ -723,7 +724,7 @@ xfs_dir2_block_lookup_int(
 		 * Get pointer to the entry from the leaf.
 		 */
 		dep = (xfs_dir2_data_entry_t *)
-			((char *)hdr + xfs_dir2_dataptr_to_off(mp, addr));
+			((char *)hdr + xfs_dir2_dataptr_to_off(args->geo, addr));
 		/*
 		 * Compare name and if it's an exact match, return the index
 		 * and buffer. If it's the first case-insensitive match, store
@@ -795,8 +796,9 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
-	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
+	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
+			xfs_dir2_dataptr_to_off(args->geo,
+						be32_to_cpu(blp[ent].address)));
 	/*
 	 * Mark the data entry's space free.
 	 */
@@ -870,8 +872,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
-	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
+	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
+			xfs_dir2_dataptr_to_off(args->geo,
+						be32_to_cpu(blp[ent].address)));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 890c940..d355ec7 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -172,7 +172,8 @@ __xfs_dir3_data_check(
 		lastfree = 0;
 		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 		    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
-			addr = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
+			addr = xfs_dir2_db_off_to_dataptr(mp->m_dir_geo,
+				mp->m_dirdatablk,
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)hdr));
 			name.name = dep->name;
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 046ba4a..2b3ddd0 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -347,8 +347,8 @@ xfs_dir3_leaf_get_buf(
 	int			error;
 
 	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
-	ASSERT(bno >= xfs_dir2_byte_to_db(mp, XFS_DIR2_LEAF_OFFSET) &&
-	       bno < xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET));
+	ASSERT(bno >= xfs_dir2_byte_to_db(args->geo, XFS_DIR2_LEAF_OFFSET) &&
+	       bno < xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET));
 
 	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(args->geo, bno),
 			       -1, &bp, XFS_DATA_FORK);
@@ -404,7 +404,7 @@ xfs_dir2_block_to_leaf(
 		return error;
 	}
 	ldb = xfs_dir2_da_to_db(args->geo, blkno);
-	ASSERT(ldb == xfs_dir2_byte_to_db(mp, XFS_DIR2_LEAF_OFFSET));
+	ASSERT(ldb == xfs_dir2_byte_to_db(args->geo, XFS_DIR2_LEAF_OFFSET));
 	/*
 	 * Initialize the leaf block, get a buffer for it.
 	 */
@@ -670,7 +670,7 @@ xfs_dir2_leaf_addname(
 	     index++, lep++) {
 		if (be32_to_cpu(lep->address) == XFS_DIR2_NULL_DATAPTR)
 			continue;
-		i = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
+		i = xfs_dir2_dataptr_to_db(args->geo, be32_to_cpu(lep->address));
 		ASSERT(i < be32_to_cpu(ltp->bestcount));
 		ASSERT(bestsp[i] != cpu_to_be16(NULLDATAOFF));
 		if (be16_to_cpu(bestsp[i]) >= length) {
@@ -889,7 +889,8 @@ xfs_dir2_leaf_addname(
 	 * Fill in the new leaf entry.
 	 */
 	lep->hashval = cpu_to_be32(args->hashval);
-	lep->address = cpu_to_be32(xfs_dir2_db_off_to_dataptr(mp, use_block,
+	lep->address = cpu_to_be32(
+				xfs_dir2_db_off_to_dataptr(args->geo, use_block,
 				be16_to_cpu(*tagp)));
 	/*
 	 * Log the leaf fields and give up the buffers.
@@ -1185,7 +1186,7 @@ xfs_dir2_leaf_lookup(
 	 */
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
-	       xfs_dir2_dataptr_to_off(dp->i_mount, be32_to_cpu(lep->address)));
+	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
 	/*
 	 * Return the found inode number & CI name if appropriate
 	 */
@@ -1260,7 +1261,8 @@ xfs_dir2_leaf_lookup_int(
 		/*
 		 * Get the new data block number.
 		 */
-		newdb = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
+		newdb = xfs_dir2_dataptr_to_db(args->geo,
+					       be32_to_cpu(lep->address));
 		/*
 		 * If it's not the same as the old data block number,
 		 * need to pitch the old one and read the new one.
@@ -1281,7 +1283,8 @@ xfs_dir2_leaf_lookup_int(
 		 * Point to the data entry.
 		 */
 		dep = (xfs_dir2_data_entry_t *)((char *)dbp->b_addr +
-			xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
+			xfs_dir2_dataptr_to_off(args->geo,
+						be32_to_cpu(lep->address)));
 		/*
 		 * Compare name and if it's an exact match, return the index
 		 * and buffer. If it's the first case-insensitive match, store
@@ -1380,9 +1383,9 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &ents[index];
-	db = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
-	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
+	db = xfs_dir2_dataptr_to_db(args->geo, be32_to_cpu(lep->address));
+	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
+		xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
@@ -1515,7 +1518,7 @@ xfs_dir2_leaf_replace(
 	 */
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
-	       xfs_dir2_dataptr_to_off(dp->i_mount, be32_to_cpu(lep->address)));
+	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
 	ASSERT(args->inumber != be64_to_cpu(dep->inumber));
 	/*
 	 * Put the new inode number in, log it.
@@ -1800,7 +1803,8 @@ xfs_dir2_node_to_leaf(
 	 * Get rid of the freespace block.
 	 */
 	error = xfs_dir2_shrink_inode(args,
-			xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET), fbp);
+			xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET),
+			fbp);
 	if (error) {
 		/*
 		 * This can't fail here because it can only happen when
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 3b70d56..89777bf 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -316,7 +316,7 @@ xfs_dir2_leaf_to_node(
 	if ((error = xfs_dir2_grow_inode(args, XFS_DIR2_FREE_SPACE, &fdb))) {
 		return error;
 	}
-	ASSERT(fdb == xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET));
+	ASSERT(fdb == xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET));
 	/*
 	 * Get the buffer for the new freespace block.
 	 */
@@ -451,7 +451,7 @@ xfs_dir2_leafn_add(
 				       highstale, &lfloglow, &lfloghigh);
 
 	lep->hashval = cpu_to_be32(args->hashval);
-	lep->address = cpu_to_be32(xfs_dir2_db_off_to_dataptr(mp,
+	lep->address = cpu_to_be32(xfs_dir2_db_off_to_dataptr(args->geo,
 				args->blkno, args->index));
 
 	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
@@ -577,7 +577,8 @@ xfs_dir2_leafn_lookup_for_addname(
 		/*
 		 * Pull the data block number from the entry.
 		 */
-		newdb = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
+		newdb = xfs_dir2_dataptr_to_db(args->geo,
+					       be32_to_cpu(lep->address));
 		/*
 		 * For addname, we're looking for a place to put the new entry.
 		 * We want to use a data block with an entry of equal
@@ -723,7 +724,8 @@ xfs_dir2_leafn_lookup_for_entry(
 		/*
 		 * Pull the data block number from the entry.
 		 */
-		newdb = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
+		newdb = xfs_dir2_dataptr_to_db(args->geo,
+					       be32_to_cpu(lep->address));
 		/*
 		 * Not adding a new entry, so we really want to find
 		 * the name given to us.
@@ -761,7 +763,8 @@ xfs_dir2_leafn_lookup_for_entry(
 		 * Point to the data entry.
 		 */
 		dep = (xfs_dir2_data_entry_t *)((char *)curbp->b_addr +
-			xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
+			xfs_dir2_dataptr_to_off(args->geo,
+						be32_to_cpu(lep->address)));
 		/*
 		 * Compare the entry and if it's an exact match, return
 		 * EEXIST immediately. If it's the first case-insensitive
@@ -1196,9 +1199,9 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
+	db = xfs_dir2_dataptr_to_db(args->geo, be32_to_cpu(lep->address));
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address));
 	ASSERT(dblk->index == off);
 
 	/*
@@ -1260,7 +1263,8 @@ xfs_dir2_leafn_remove(
 		struct xfs_dir3_icfree_hdr freehdr;
 		dp->d_ops->free_hdr_from_disk(&freehdr, free);
 		ASSERT(freehdr.firstdb == dp->d_ops->free_max_bests(mp) *
-			  (fdb - xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET)));
+			(fdb - xfs_dir2_byte_to_db(args->geo,
+						   XFS_DIR2_FREE_OFFSET)));
 	}
 #endif
 		/*
@@ -1751,7 +1755,7 @@ xfs_dir2_node_addname_int(
 			 * us a freespace block to start with.
 			 */
 			if (++fbno == 0)
-				fbno = xfs_dir2_byte_to_db(mp,
+				fbno = xfs_dir2_byte_to_db(args->geo,
 							XFS_DIR2_FREE_OFFSET);
 			/*
 			 * If it's ifbno we already looked at it.
@@ -1893,7 +1897,7 @@ xfs_dir2_node_addname_int(
 			 * Remember the first slot as our empty slot.
 			 */
 			freehdr.firstdb =
-				(fbno - xfs_dir2_byte_to_db(mp,
+				(fbno - xfs_dir2_byte_to_db(args->geo,
 							XFS_DIR2_FREE_OFFSET)) *
 					dp->d_ops->free_max_bests(mp);
 		} else {
@@ -2194,7 +2198,8 @@ xfs_dir2_node_replace(
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
-		       xfs_dir2_dataptr_to_off(state->mp, be32_to_cpu(lep->address)));
+		       xfs_dir2_dataptr_to_off(args->geo,
+					       be32_to_cpu(lep->address)));
 		ASSERT(inum != be64_to_cpu(dep->inumber));
 		/*
 		 * Fill in the new inode number and log the entry.
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 18e3086..071b685 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -48,19 +48,18 @@ xfs_dir2_byte_to_dataptr(xfs_dir2_off_t by)
  * Convert byte in space to (DB) block
  */
 static inline xfs_dir2_db_t
-xfs_dir2_byte_to_db(struct xfs_mount *mp, xfs_dir2_off_t by)
+xfs_dir2_byte_to_db(struct xfs_da_geometry *geo, xfs_dir2_off_t by)
 {
-	return (xfs_dir2_db_t)
-		(by >> (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog));
+	return (xfs_dir2_db_t)(by >> geo->blklog);
 }
 
 /*
  * Convert dataptr to a block number
  */
 static inline xfs_dir2_db_t
-xfs_dir2_dataptr_to_db(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
+xfs_dir2_dataptr_to_db(struct xfs_da_geometry *geo, xfs_dir2_dataptr_t dp)
 {
-	return xfs_dir2_byte_to_db(mp, xfs_dir2_dataptr_to_byte(dp));
+	return xfs_dir2_byte_to_db(geo, xfs_dir2_dataptr_to_byte(dp));
 }
 
 /*
@@ -76,9 +75,9 @@ xfs_dir2_byte_to_off(struct xfs_da_geometry *geo, xfs_dir2_off_t by)
  * Convert dataptr to a byte offset in a block
  */
 static inline xfs_dir2_data_aoff_t
-xfs_dir2_dataptr_to_off(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
+xfs_dir2_dataptr_to_off(struct xfs_da_geometry *geo, xfs_dir2_dataptr_t dp)
 {
-	return xfs_dir2_byte_to_off(mp->m_dir_geo, xfs_dir2_dataptr_to_byte(dp));
+	return xfs_dir2_byte_to_off(geo, xfs_dir2_dataptr_to_byte(dp));
 }
 
 /*
@@ -104,20 +103,19 @@ xfs_dir2_db_to_da(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
  * Convert byte in space to (DA) block
  */
 static inline xfs_dablk_t
-xfs_dir2_byte_to_da(struct xfs_mount *mp, xfs_dir2_off_t by)
+xfs_dir2_byte_to_da(struct xfs_da_geometry *geo, xfs_dir2_off_t by)
 {
-	return xfs_dir2_db_to_da(mp->m_dir_geo, xfs_dir2_byte_to_db(mp, by));
+	return xfs_dir2_db_to_da(geo, xfs_dir2_byte_to_db(geo, by));
 }
 
 /*
  * Convert block and offset to dataptr
  */
 static inline xfs_dir2_dataptr_t
-xfs_dir2_db_off_to_dataptr(struct xfs_mount *mp, xfs_dir2_db_t db,
+xfs_dir2_db_off_to_dataptr(struct xfs_da_geometry *geo, xfs_dir2_db_t db,
 			   xfs_dir2_data_aoff_t o)
 {
-	return xfs_dir2_byte_to_dataptr(
-				xfs_dir2_db_off_to_byte(mp->m_dir_geo, db, o));
+	return xfs_dir2_byte_to_dataptr(xfs_dir2_db_off_to_byte(geo, db, o));
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 57e9247..c2a6387 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -87,8 +87,10 @@ xfs_dir2_sf_getdents(
 	xfs_dir2_dataptr_t	dot_offset;
 	xfs_dir2_dataptr_t	dotdot_offset;
 	xfs_ino_t		ino;
+	struct xfs_da_geometry	*geo;
 
 	mp = dp->i_mount;
+	geo = mp->m_dir_geo;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
 	/*
@@ -109,7 +111,7 @@ xfs_dir2_sf_getdents(
 	/*
 	 * If the block number in the offset is out of range, we're done.
 	 */
-	if (xfs_dir2_dataptr_to_db(mp, ctx->pos) > mp->m_dirdatablk)
+	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > mp->m_dirdatablk)
 		return 0;
 
 	/*
@@ -118,9 +120,9 @@ xfs_dir2_sf_getdents(
 	 * XXX(hch): the second argument is sometimes 0 and sometimes
 	 * mp->m_dirdatablk.
 	 */
-	dot_offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
+	dot_offset = xfs_dir2_db_off_to_dataptr(geo, mp->m_dirdatablk,
 						dp->d_ops->data_dot_offset);
-	dotdot_offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
+	dotdot_offset = xfs_dir2_db_off_to_dataptr(geo, mp->m_dirdatablk,
 						dp->d_ops->data_dotdot_offset);
 
 	/*
@@ -149,7 +151,7 @@ xfs_dir2_sf_getdents(
 	for (i = 0; i < sfp->count; i++) {
 		__uint8_t filetype;
 
-		off = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
+		off = xfs_dir2_db_off_to_dataptr(geo, mp->m_dirdatablk,
 				xfs_dir2_sf_get_offset(sfep));
 
 		if (ctx->pos > off) {
@@ -166,7 +168,7 @@ xfs_dir2_sf_getdents(
 		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 	}
 
-	ctx->pos = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0) &
+	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, mp->m_dirdatablk + 1, 0) &
 			0x7fffffff;
 	return 0;
 }
@@ -190,12 +192,14 @@ xfs_dir2_block_getdents(
 	char			*ptr;		/* current data entry */
 	int			wantoff;	/* starting block offset */
 	xfs_off_t		cook;
+	struct xfs_da_geometry	*geo;
 
 	mp = dp->i_mount;
+	geo = mp->m_dir_geo;
 	/*
 	 * If the block number in the offset is out of range, we're done.
 	 */
-	if (xfs_dir2_dataptr_to_db(mp, ctx->pos) > mp->m_dirdatablk)
+	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > mp->m_dirdatablk)
 		return 0;
 
 	error = xfs_dir3_block_read(NULL, dp, &bp);
@@ -206,7 +210,7 @@ xfs_dir2_block_getdents(
 	 * Extract the byte offset we start at from the seek pointer.
 	 * We'll skip entries before this.
 	 */
-	wantoff = xfs_dir2_dataptr_to_off(mp, ctx->pos);
+	wantoff = xfs_dir2_dataptr_to_off(geo, ctx->pos);
 	hdr = bp->b_addr;
 	xfs_dir3_data_check(dp, bp);
 	/*
@@ -244,7 +248,7 @@ xfs_dir2_block_getdents(
 		if ((char *)dep - (char *)hdr < wantoff)
 			continue;
 
-		cook = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
+		cook = xfs_dir2_db_off_to_dataptr(geo, mp->m_dirdatablk,
 					    (char *)dep - (char *)hdr);
 
 		ctx->pos = cook & 0x7fffffff;
@@ -264,7 +268,7 @@ xfs_dir2_block_getdents(
 	 * Reached the end of the block.
 	 * Set the offset to a non-existent block 1 and return.
 	 */
-	ctx->pos = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0) &
+	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, mp->m_dirdatablk + 1, 0) &
 			0x7fffffff;
 	xfs_trans_brelse(NULL, bp);
 	return 0;
@@ -300,6 +304,7 @@ xfs_dir2_leaf_readbuf(
 	int			length;
 	int			i;
 	int			j;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
 
 	/*
 	 * If we have a buffer, we need to release it and
@@ -342,14 +347,14 @@ xfs_dir2_leaf_readbuf(
 	 * run out of data blocks, get some more mappings.
 	 */
 	if (1 + mip->ra_want > mip->map_blocks &&
-	    mip->map_off < xfs_dir2_byte_to_da(mp, XFS_DIR2_LEAF_OFFSET)) {
+	    mip->map_off < xfs_dir2_byte_to_da(geo, XFS_DIR2_LEAF_OFFSET)) {
 		/*
 		 * Get more bmaps, fill in after the ones
 		 * we already have in the table.
 		 */
 		mip->nmap = mip->map_size - mip->map_valid;
 		error = xfs_bmapi_read(dp, mip->map_off,
-				xfs_dir2_byte_to_da(mp, XFS_DIR2_LEAF_OFFSET) -
+				xfs_dir2_byte_to_da(geo, XFS_DIR2_LEAF_OFFSET) -
 								mip->map_off,
 				&map[mip->map_valid], &mip->nmap, 0);
 
@@ -370,7 +375,7 @@ xfs_dir2_leaf_readbuf(
 			i = mip->map_valid + mip->nmap - 1;
 			mip->map_off = map[i].br_startoff + map[i].br_blockcount;
 		} else
-			mip->map_off = xfs_dir2_byte_to_da(mp,
+			mip->map_off = xfs_dir2_byte_to_da(geo,
 							XFS_DIR2_LEAF_OFFSET);
 
 		/*
@@ -396,14 +401,14 @@ xfs_dir2_leaf_readbuf(
 	 * No valid mappings, so no more data blocks.
 	 */
 	if (!mip->map_valid) {
-		*curoff = xfs_dir2_da_to_byte(mp->m_dir_geo, mip->map_off);
+		*curoff = xfs_dir2_da_to_byte(geo, mip->map_off);
 		goto out;
 	}
 
 	/*
 	 * Read the directory block starting at the first mapping.
 	 */
-	mip->curdb = xfs_dir2_da_to_db(mp->m_dir_geo, map->br_startoff);
+	mip->curdb = xfs_dir2_da_to_db(geo, map->br_startoff);
 	error = xfs_dir3_data_read(NULL, dp, map->br_startoff,
 			map->br_blockcount >= mp->m_dirblkfsbs ?
 			    XFS_FSB_TO_DADDR(mp, map->br_startblock) : -1, &bp);
@@ -504,6 +509,7 @@ xfs_dir2_leaf_getdents(
 	xfs_dir2_off_t		newoff;		/* new curoff after new blk */
 	char			*ptr = NULL;	/* pointer to current data */
 	struct xfs_dir2_leaf_map_info *map_info;
+	struct xfs_da_geometry	*geo;
 
 	/*
 	 * If the offset is at or past the largest allowed value,
@@ -513,6 +519,7 @@ xfs_dir2_leaf_getdents(
 		return 0;
 
 	mp = dp->i_mount;
+	geo = mp->m_dir_geo;
 
 	/*
 	 * Set up to bmap a number of blocks based on the caller's
@@ -536,8 +543,8 @@ xfs_dir2_leaf_getdents(
 	 * Force this conversion through db so we truncate the offset
 	 * down to get the start of the data block.
 	 */
-	map_info->map_off = xfs_dir2_db_to_da(mp->m_dir_geo,
-					      xfs_dir2_byte_to_db(mp, curoff));
+	map_info->map_off = xfs_dir2_db_to_da(geo,
+					      xfs_dir2_byte_to_db(geo, curoff));
 
 	/*
 	 * Loop over directory entries until we reach the end offset.
@@ -571,7 +578,7 @@ xfs_dir2_leaf_getdents(
 			 * Make sure we're in the right block.
 			 */
 			else if (curoff > newoff)
-				ASSERT(xfs_dir2_byte_to_db(mp, curoff) ==
+				ASSERT(xfs_dir2_byte_to_db(geo, curoff) ==
 				       map_info->curdb);
 			hdr = bp->b_addr;
 			xfs_dir3_data_check(dp, bp);
@@ -608,8 +615,8 @@ xfs_dir2_leaf_getdents(
 				 * Now set our real offset.
 				 */
 				curoff =
-					xfs_dir2_db_off_to_byte(mp->m_dir_geo,
-					    xfs_dir2_byte_to_db(mp, curoff),
+					xfs_dir2_db_off_to_byte(geo,
+					    xfs_dir2_byte_to_db(geo, curoff),
 					    (char *)ptr - (char *)hdr);
 				if (ptr >= (char *)hdr + mp->m_dirblksize) {
 					continue;
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 7aab8ec..4dc4193 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -104,8 +104,8 @@ xfs_dir2_block_sfsize(
 		/*
 		 * Calculate the pointer to the entry at hand.
 		 */
-		dep = (xfs_dir2_data_entry_t *)
-		      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, addr));
+		dep = (xfs_dir2_data_entry_t *)((char *)hdr +
+				xfs_dir2_dataptr_to_off(mp->m_dir_geo, addr));
 		/*
 		 * Detect . and .., so we can special-case them.
 		 * . is not included in sf directories.
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
