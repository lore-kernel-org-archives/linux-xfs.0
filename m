Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F9B27F54
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:07:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5324D304032
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:07:32 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	W7OSaxTFtmeoB53B for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:07:29 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTpO-0006Lv-SG
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTpO-0002Ca-RZ
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/16] xfs: vectorise directory leaf operations
Date: Mon, 30 Sep 2013 13:07:11 +1000
Message-Id: <1380510433-8353-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510433-8353-1-git-send-email-david@fromorbit.com>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
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

Next step in the vectorisation process is the directory free block
encode/decode operations. There are relatively few of these, though
there are quite a numberof calls to them.

Binary sizes:

   text    data     bss     dec     hex filename
 794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
 792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
 792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
 789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
 789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
 789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
 789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6
 791421   96802    1096  889319   d91e7 fs/xfs/xfs.o.p7
 791701   96802    1096  889599   d92ff fs/xfs/xfs.o.p8

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_format.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_da_format.h | 39 ---------------------
 fs/xfs/xfs_dir2.h      |  5 +++
 fs/xfs/xfs_dir2_leaf.c |  2 +-
 fs/xfs/xfs_dir2_node.c | 61 +++++++++++++++++----------------
 5 files changed, 129 insertions(+), 70 deletions(-)

diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index d81cff7..a76b044e 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -629,6 +629,80 @@ xfs_da3_node_hdr_to_disk(
 /*
  * Directory free space block operations
  */
+static int
+xfs_dir2_free_hdr_size(void)
+{
+	return sizeof(struct xfs_dir2_free_hdr);
+}
+
+static int
+xfs_dir2_free_max_bests(struct xfs_mount *mp)
+{
+	return (mp->m_dirblksize - xfs_dir2_free_hdr_size()) /
+		sizeof(xfs_dir2_data_off_t);
+}
+
+static __be16 *
+xfs_dir2_free_bests_p(struct xfs_dir2_free *free)
+{
+	return (__be16 *)((char *)free + xfs_dir2_free_hdr_size());
+}
+
+/*
+ * Convert data space db to the corresponding free db.
+ */
+static xfs_dir2_db_t
+xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
+{
+	return XFS_DIR2_FREE_FIRSTDB(mp) + db / xfs_dir2_free_max_bests(mp);
+}
+
+/*
+ * Convert data space db to the corresponding index in a free db.
+ */
+static int
+xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
+{
+	return db % xfs_dir2_free_max_bests(mp);
+}
+
+static int
+xfs_dir3_free_hdr_size(void)
+{
+	return sizeof(struct xfs_dir3_free_hdr);
+}
+
+static int
+xfs_dir3_free_max_bests(struct xfs_mount *mp)
+{
+	return (mp->m_dirblksize - xfs_dir3_free_hdr_size()) /
+		sizeof(xfs_dir2_data_off_t);
+}
+
+static __be16 *
+xfs_dir3_free_bests_p(struct xfs_dir2_free *free)
+{
+	return (__be16 *)((char *)free + xfs_dir3_free_hdr_size());
+}
+
+/*
+ * Convert data space db to the corresponding free db.
+ */
+static xfs_dir2_db_t
+xfs_dir3_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
+{
+	return XFS_DIR2_FREE_FIRSTDB(mp) + db / xfs_dir3_free_max_bests(mp);
+}
+
+/*
+ * Convert data space db to the corresponding index in a free db.
+ */
+static int
+xfs_dir3_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
+{
+	return db % xfs_dir3_free_max_bests(mp);
+}
+
 static void
 xfs_dir2_free_hdr_from_disk(
 	struct xfs_dir3_icfree_hdr	*to,
@@ -721,6 +795,14 @@ const struct xfs_dir_ops xfs_dir2_ops = {
 	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
+
+	.free_hdr_size = xfs_dir2_free_hdr_size,
+	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
+	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
+	.free_max_bests = xfs_dir2_free_max_bests,
+	.free_bests_p = xfs_dir2_free_bests_p,
+	.db_to_fdb = xfs_dir2_db_to_fdb,
+	.db_to_fdindex = xfs_dir2_db_to_fdindex,
 };
 
 const struct xfs_dir_ops xfs_dir2_ftype_ops = {
@@ -761,8 +843,13 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
 
+	.free_hdr_size = xfs_dir2_free_hdr_size,
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
 	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
+	.free_max_bests = xfs_dir2_free_max_bests,
+	.free_bests_p = xfs_dir2_free_bests_p,
+	.db_to_fdb = xfs_dir2_db_to_fdb,
+	.db_to_fdindex = xfs_dir2_db_to_fdindex,
 };
 
 const struct xfs_dir_ops xfs_dir3_ops = {
@@ -803,8 +890,13 @@ const struct xfs_dir_ops xfs_dir3_ops = {
 	.node_hdr_from_disk = xfs_da3_node_hdr_from_disk,
 	.node_tree_p = xfs_da3_node_tree_p,
 
+	.free_hdr_size = xfs_dir3_free_hdr_size,
 	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
 	.free_hdr_from_disk = xfs_dir3_free_hdr_from_disk,
+	.free_max_bests = xfs_dir2_free_max_bests,
+	.free_bests_p = xfs_dir3_free_bests_p,
+	.db_to_fdb = xfs_dir3_db_to_fdb,
+	.db_to_fdindex = xfs_dir3_db_to_fdindex,
 };
 
 const struct xfs_dir_ops xfs_dir2_nondir_ops = {
diff --git a/fs/xfs/xfs_da_format.h b/fs/xfs/xfs_da_format.h
index 1ff7b9f..a19d3f8 100644
--- a/fs/xfs/xfs_da_format.h
+++ b/fs/xfs/xfs_da_format.h
@@ -704,45 +704,6 @@ struct xfs_dir3_icfree_hdr {
 
 };
 
-static inline int
-xfs_dir3_free_hdr_size(struct xfs_mount *mp)
-{
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		return sizeof(struct xfs_dir3_free_hdr);
-	return sizeof(struct xfs_dir2_free_hdr);
-}
-
-static inline int
-xfs_dir3_free_max_bests(struct xfs_mount *mp)
-{
-	return (mp->m_dirblksize - xfs_dir3_free_hdr_size(mp)) /
-		sizeof(xfs_dir2_data_off_t);
-}
-
-static inline __be16 *
-xfs_dir3_free_bests_p(struct xfs_mount *mp, struct xfs_dir2_free *free)
-{
-	return (__be16 *)((char *)free + xfs_dir3_free_hdr_size(mp));
-}
-
-/*
- * Convert data space db to the corresponding free db.
- */
-static inline xfs_dir2_db_t
-xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
-{
-	return XFS_DIR2_FREE_FIRSTDB(mp) + db / xfs_dir3_free_max_bests(mp);
-}
-
-/*
- * Convert data space db to the corresponding index in a free db.
- */
-static inline int
-xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
-{
-	return db % xfs_dir3_free_max_bests(mp);
-}
-
 /*
  * Single block format.
  *
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 6119534..4264cb9 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -92,10 +92,15 @@ struct xfs_dir_ops {
 	struct xfs_da_node_entry *
 		(*node_tree_p)(struct xfs_da_intnode *dap);
 
+	int	(*free_hdr_size)(void);
 	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
 				    struct xfs_dir3_icfree_hdr *from);
 	void	(*free_hdr_from_disk)(struct xfs_dir3_icfree_hdr *to,
 				      struct xfs_dir2_free *from);
+	int	(*free_max_bests)(struct xfs_mount *mp);
+	__be16 * (*free_bests_p)(struct xfs_dir2_free *free);
+	xfs_dir2_db_t (*db_to_fdb)(struct xfs_mount *mp, xfs_dir2_db_t db);
+	int	(*db_to_fdindex)(struct xfs_mount *mp, xfs_dir2_db_t db);
 };
 
 extern const struct xfs_dir_ops *
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 2fb8db9..a3c21b1 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1785,7 +1785,7 @@ xfs_dir2_node_to_leaf(
 	/*
 	 * Set up the leaf bests table.
 	 */
-	memcpy(xfs_dir2_leaf_bests_p(ltp), xfs_dir3_free_bests_p(mp, free),
+	memcpy(xfs_dir2_leaf_bests_p(ltp), dp->d_ops->free_bests_p(free),
 		freehdr.nvalid * sizeof(xfs_dir2_data_off_t));
 
 	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index aea65ce..cd83037 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -240,6 +240,7 @@ xfs_dir3_free_get_buf(
 STATIC void
 xfs_dir2_free_log_bests(
 	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
 	struct xfs_buf		*bp,
 	int			first,		/* first entry to log */
 	int			last)		/* last entry to log */
@@ -248,7 +249,7 @@ xfs_dir2_free_log_bests(
 	__be16			*bests;
 
 	free = bp->b_addr;
-	bests = xfs_dir3_free_bests_p(tp->t_mountp, free);
+	bests = dp->d_ops->free_bests_p(free);
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 	xfs_trans_log_buf(tp, bp,
@@ -263,6 +264,7 @@ xfs_dir2_free_log_bests(
 static void
 xfs_dir2_free_log_header(
 	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
 	struct xfs_buf		*bp)
 {
 #ifdef DEBUG
@@ -272,7 +274,7 @@ xfs_dir2_free_log_header(
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 #endif
-	xfs_trans_log_buf(tp, bp, 0, xfs_dir3_free_hdr_size(tp->t_mountp) - 1);
+	xfs_trans_log_buf(tp, bp, 0, dp->d_ops->free_hdr_size() - 1);
 }
 
 /*
@@ -332,7 +334,7 @@ xfs_dir2_leaf_to_node(
 	 * Count active entries.
 	 */
 	from = xfs_dir2_leaf_bests_p(ltp);
-	to = xfs_dir3_free_bests_p(mp, free);
+	to = dp->d_ops->free_bests_p(free);
 	for (i = n = 0; i < be32_to_cpu(ltp->bestcount); i++, from++, to++) {
 		if ((off = be16_to_cpu(*from)) != NULLDATAOFF)
 			n++;
@@ -346,8 +348,8 @@ xfs_dir2_leaf_to_node(
 	freehdr.nvalid = be32_to_cpu(ltp->bestcount);
 
 	dp->d_ops->free_hdr_to_disk(fbp->b_addr, &freehdr);
-	xfs_dir2_free_log_bests(tp, fbp, 0, freehdr.nvalid - 1);
-	xfs_dir2_free_log_header(tp, fbp);
+	xfs_dir2_free_log_bests(tp, dp, fbp, 0, freehdr.nvalid - 1);
+	xfs_dir2_free_log_header(tp, dp, fbp);
 
 	/*
 	 * Converting the leaf to a leafnode is just a matter of changing the
@@ -468,7 +470,7 @@ xfs_dir2_free_hdr_check(
 
 	dp->d_ops->free_hdr_from_disk(&hdr, bp->b_addr);
 
-	ASSERT((hdr.firstdb % xfs_dir3_free_max_bests(dp->i_mount)) == 0);
+	ASSERT((hdr.firstdb % dp->d_ops->free_max_bests(dp->i_mount)) == 0);
 	ASSERT(hdr.firstdb <= db);
 	ASSERT(db < hdr.firstdb + hdr.nvalid);
 }
@@ -590,7 +592,7 @@ xfs_dir2_leafn_lookup_for_addname(
 			 * Convert the data block to the free block
 			 * holding its freespace information.
 			 */
-			newfdb = xfs_dir2_db_to_fdb(mp, newdb);
+			newfdb = dp->d_ops->db_to_fdb(mp, newdb);
 			/*
 			 * If it's not the one we have in hand, read it in.
 			 */
@@ -613,11 +615,11 @@ xfs_dir2_leafn_lookup_for_addname(
 			/*
 			 * Get the index for our entry.
 			 */
-			fi = xfs_dir2_db_to_fdindex(mp, curdb);
+			fi = dp->d_ops->db_to_fdindex(mp, curdb);
 			/*
 			 * If it has room, return it.
 			 */
-			bests = xfs_dir3_free_bests_p(mp, free);
+			bests = dp->d_ops->free_bests_p(free);
 			if (unlikely(bests[fi] == cpu_to_be16(NULLDATAOFF))) {
 				XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
 							XFS_ERRLEVEL_LOW, mp);
@@ -1080,15 +1082,14 @@ xfs_dir3_data_block_free(
 	struct xfs_inode	*dp = args->dp;
 
 	dp->d_ops->free_hdr_from_disk(&freehdr, free);
-
-	bests = xfs_dir3_free_bests_p(tp->t_mountp, free);
+	bests = dp->d_ops->free_bests_p(free);
 	if (hdr) {
 		/*
 		 * Data block is not empty, just set the free entry to the new
 		 * value.
 		 */
 		bests[findex] = cpu_to_be16(longest);
-		xfs_dir2_free_log_bests(tp, fbp, findex, findex);
+		xfs_dir2_free_log_bests(tp, dp, fbp, findex, findex);
 		return 0;
 	}
 
@@ -1116,7 +1117,7 @@ xfs_dir3_data_block_free(
 	}
 
 	dp->d_ops->free_hdr_to_disk(free, &freehdr);
-	xfs_dir2_free_log_header(tp, fbp);
+	xfs_dir2_free_log_header(tp, dp, fbp);
 
 	/*
 	 * If there are no useful entries left in the block, get rid of the
@@ -1140,7 +1141,7 @@ xfs_dir3_data_block_free(
 
 	/* Log the free entry that changed, unless we got rid of it.  */
 	if (logfree)
-		xfs_dir2_free_log_bests(tp, fbp, findex, findex);
+		xfs_dir2_free_log_bests(tp, dp, fbp, findex, findex);
 	return 0;
 }
 
@@ -1243,7 +1244,7 @@ xfs_dir2_leafn_remove(
 		 * Convert the data block number to a free block,
 		 * read in the free block.
 		 */
-		fdb = xfs_dir2_db_to_fdb(mp, db);
+		fdb = dp->d_ops->db_to_fdb(mp, db);
 		error = xfs_dir2_free_read(tp, dp, xfs_dir2_db_to_da(mp, fdb),
 					   &fbp);
 		if (error)
@@ -1253,14 +1254,14 @@ xfs_dir2_leafn_remove(
 	{
 		struct xfs_dir3_icfree_hdr freehdr;
 		dp->d_ops->free_hdr_from_disk(&freehdr, free);
-		ASSERT(freehdr.firstdb == xfs_dir3_free_max_bests(mp) *
+		ASSERT(freehdr.firstdb == dp->d_ops->free_max_bests(mp) *
 					  (fdb - XFS_DIR2_FREE_FIRSTDB(mp)));
 	}
 #endif
 		/*
 		 * Calculate which entry we need to fix.
 		 */
-		findex = xfs_dir2_db_to_fdindex(mp, db);
+		findex = dp->d_ops->db_to_fdindex(mp, db);
 		longest = be16_to_cpu(bf[0].length);
 		/*
 		 * If the data block is now empty we can get rid of it
@@ -1688,7 +1689,7 @@ xfs_dir2_node_addname_int(
 		ifbno = fblk->blkno;
 		free = fbp->b_addr;
 		findex = fblk->index;
-		bests = xfs_dir3_free_bests_p(mp, free);
+		bests = dp->d_ops->free_bests_p(free);
 		dp->d_ops->free_hdr_from_disk(&freehdr, free);
 
 		/*
@@ -1781,7 +1782,7 @@ xfs_dir2_node_addname_int(
 		 * and the freehdr are actually initialised if they are placed
 		 * there, so we have to do it here to avoid warnings. Blech.
 		 */
-		bests = xfs_dir3_free_bests_p(mp, free);
+		bests = dp->d_ops->free_bests_p(free);
 		dp->d_ops->free_hdr_from_disk(&freehdr, free);
 		if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
 		    be16_to_cpu(bests[findex]) >= length)
@@ -1833,7 +1834,7 @@ xfs_dir2_node_addname_int(
 		 * Get the freespace block corresponding to the data block
 		 * that was just allocated.
 		 */
-		fbno = xfs_dir2_db_to_fdb(mp, dbno);
+		fbno = dp->d_ops->db_to_fdb(mp, dbno);
 		error = xfs_dir2_free_try_read(tp, dp,
 					       xfs_dir2_db_to_da(mp, fbno),
 					       &fbp);
@@ -1850,12 +1851,12 @@ xfs_dir2_node_addname_int(
 			if (error)
 				return error;
 
-			if (unlikely(xfs_dir2_db_to_fdb(mp, dbno) != fbno)) {
+			if (unlikely(dp->d_ops->db_to_fdb(mp, dbno) != fbno)) {
 				xfs_alert(mp,
 			"%s: dir ino %llu needed freesp block %lld for\n"
 			"  data block %lld, got %lld ifbno %llu lastfbno %d",
 					__func__, (unsigned long long)dp->i_ino,
-					(long long)xfs_dir2_db_to_fdb(mp, dbno),
+					(long long)dp->d_ops->db_to_fdb(mp, dbno),
 					(long long)dbno, (long long)fbno,
 					(unsigned long long)ifbno, lastfbno);
 				if (fblk) {
@@ -1880,30 +1881,30 @@ xfs_dir2_node_addname_int(
 			if (error)
 				return error;
 			free = fbp->b_addr;
-			bests = xfs_dir3_free_bests_p(mp, free);
+			bests = dp->d_ops->free_bests_p(free);
 			dp->d_ops->free_hdr_from_disk(&freehdr, free);
 
 			/*
 			 * Remember the first slot as our empty slot.
 			 */
 			freehdr.firstdb = (fbno - XFS_DIR2_FREE_FIRSTDB(mp)) *
-					xfs_dir3_free_max_bests(mp);
+					dp->d_ops->free_max_bests(mp);
 		} else {
 			free = fbp->b_addr;
-			bests = xfs_dir3_free_bests_p(mp, free);
+			bests = dp->d_ops->free_bests_p(free);
 			dp->d_ops->free_hdr_from_disk(&freehdr, free);
 		}
 
 		/*
 		 * Set the freespace block index from the data block number.
 		 */
-		findex = xfs_dir2_db_to_fdindex(mp, dbno);
+		findex = dp->d_ops->db_to_fdindex(mp, dbno);
 		/*
 		 * If it's after the end of the current entries in the
 		 * freespace block, extend that table.
 		 */
 		if (findex >= freehdr.nvalid) {
-			ASSERT(findex < xfs_dir3_free_max_bests(mp));
+			ASSERT(findex < dp->d_ops->free_max_bests(mp));
 			freehdr.nvalid = findex + 1;
 			/*
 			 * Tag new entry so nused will go up.
@@ -1917,7 +1918,7 @@ xfs_dir2_node_addname_int(
 		if (bests[findex] == cpu_to_be16(NULLDATAOFF)) {
 			freehdr.nused++;
 			dp->d_ops->free_hdr_to_disk(fbp->b_addr, &freehdr);
-			xfs_dir2_free_log_header(tp, fbp);
+			xfs_dir2_free_log_header(tp, dp, fbp);
 		}
 		/*
 		 * Update the real value in the table.
@@ -1987,7 +1988,7 @@ xfs_dir2_node_addname_int(
 	/*
 	 * If the freespace entry is now wrong, update it.
 	 */
-	bests = xfs_dir3_free_bests_p(mp, free); /* gcc is so stupid */
+	bests = dp->d_ops->free_bests_p(free); /* gcc is so stupid */
 	if (be16_to_cpu(bests[findex]) != be16_to_cpu(bf[0].length)) {
 		bests[findex] = bf[0].length;
 		logfree = 1;
@@ -1996,7 +1997,7 @@ xfs_dir2_node_addname_int(
 	 * Log the freespace entry if needed.
 	 */
 	if (logfree)
-		xfs_dir2_free_log_bests(tp, fbp, findex, findex);
+		xfs_dir2_free_log_bests(tp, dp, fbp, findex, findex);
 	/*
 	 * Return the data block and offset in args, then drop the data block.
 	 */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
