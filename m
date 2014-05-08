Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 85F037F7E
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 03:20:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B1368F804B
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 01:20:07 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8VKQsnYPSKzf3jvA for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 01:20:03 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WiJYV-0001j3-9y
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WiJYV-0006wk-99
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/18] xfs: convert m_dirblksize to xfs_da_geometry
Date: Thu,  8 May 2014 18:19:40 +1000
Message-Id: <1399537188-26509-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1399537188-26509-1-git-send-email-david@fromorbit.com>
References: <1399537188-26509-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_da_btree.c     |  4 ++--
 fs/xfs/xfs_da_btree.h     |  8 ++++----
 fs/xfs/xfs_da_format.c    | 36 ++++++++++++++++++------------------
 fs/xfs/xfs_dir2.c         |  6 +++---
 fs/xfs/xfs_dir2.h         | 10 ++++++----
 fs/xfs/xfs_dir2_block.c   | 32 ++++++++++++++++----------------
 fs/xfs/xfs_dir2_data.c    | 17 ++++++++++-------
 fs/xfs/xfs_dir2_leaf.c    | 35 ++++++++++++++++++-----------------
 fs/xfs/xfs_dir2_node.c    | 42 ++++++++++++++++++++++--------------------
 fs/xfs/xfs_dir2_readdir.c | 11 +++++------
 fs/xfs/xfs_dir2_sf.c      | 14 ++++++++------
 fs/xfs/xfs_fsops.c        |  4 +++-
 fs/xfs/xfs_mount.h        |  1 -
 fs/xfs/xfs_trans_resv.c   |  2 +-
 14 files changed, 116 insertions(+), 106 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 4d0a1e8..b9b007d 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2169,8 +2169,8 @@ xfs_da3_swap_lastblock(
 	/*
 	 * Copy the last block into the dead buffer and log it.
 	 */
-	memcpy(dead_buf->b_addr, last_buf->b_addr, mp->m_dirblksize);
-	xfs_trans_log_buf(tp, dead_buf, 0, mp->m_dirblksize - 1);
+	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
+	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	dead_info = dead_buf->b_addr;
 	/*
 	 * Get values from the moved block.
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index ce2580c..55417be 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -277,17 +277,17 @@ xfs_dir2_da_to_byte(struct xfs_da_geometry *geo, xfs_dablk_t da)
  * Directory tail pointer accessor functions. Based on block geometry.
  */
 static inline struct xfs_dir2_block_tail *
-xfs_dir2_block_tail_p(struct xfs_mount *mp, struct xfs_dir2_data_hdr *hdr)
+xfs_dir2_block_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_data_hdr *hdr)
 {
 	return ((struct xfs_dir2_block_tail *)
-		((char *)hdr + mp->m_dirblksize)) - 1;
+		((char *)hdr + geo->blksize)) - 1;
 }
 
 static inline struct xfs_dir2_leaf_tail *
-xfs_dir2_leaf_tail_p(struct xfs_mount *mp, struct xfs_dir2_leaf *lp)
+xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
 {
 	return (struct xfs_dir2_leaf_tail *)
-		((char *)lp + mp->m_dirblksize -
+		((char *)lp + geo->blksize -
 		  sizeof(struct xfs_dir2_leaf_tail));
 }
 
diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index c782f2c..d70c05b 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -426,9 +426,9 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
  * Directory Leaf block operations
  */
 static int
-xfs_dir2_max_leaf_ents(struct xfs_mount *mp)
+xfs_dir2_max_leaf_ents(struct xfs_da_geometry *geo)
 {
-	return (mp->m_dirblksize - sizeof(struct xfs_dir2_leaf_hdr)) /
+	return (geo->blksize - sizeof(struct xfs_dir2_leaf_hdr)) /
 		(uint)sizeof(struct xfs_dir2_leaf_entry);
 }
 
@@ -439,9 +439,9 @@ xfs_dir2_leaf_ents_p(struct xfs_dir2_leaf *lp)
 }
 
 static int
-xfs_dir3_max_leaf_ents(struct xfs_mount *mp)
+xfs_dir3_max_leaf_ents(struct xfs_da_geometry *geo)
 {
-	return (mp->m_dirblksize - sizeof(struct xfs_dir3_leaf_hdr)) /
+	return (geo->blksize - sizeof(struct xfs_dir3_leaf_hdr)) /
 		(uint)sizeof(struct xfs_dir2_leaf_entry);
 }
 
@@ -592,9 +592,9 @@ xfs_da3_node_hdr_to_disk(
  * Directory free space block operations
  */
 static int
-xfs_dir2_free_max_bests(struct xfs_mount *mp)
+xfs_dir2_free_max_bests(struct xfs_da_geometry *geo)
 {
-	return (mp->m_dirblksize - sizeof(struct xfs_dir2_free_hdr)) /
+	return (geo->blksize - sizeof(struct xfs_dir2_free_hdr)) /
 		sizeof(xfs_dir2_data_off_t);
 }
 
@@ -608,25 +608,25 @@ xfs_dir2_free_bests_p(struct xfs_dir2_free *free)
  * Convert data space db to the corresponding free db.
  */
 static xfs_dir2_db_t
-xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
+xfs_dir2_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 {
-	return xfs_dir2_byte_to_db(mp->m_dir_geo, XFS_DIR2_FREE_OFFSET) +
-			(db / xfs_dir2_free_max_bests(mp));
+	return xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET) +
+			(db / xfs_dir2_free_max_bests(geo));
 }
 
 /*
  * Convert data space db to the corresponding index in a free db.
  */
 static int
-xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
+xfs_dir2_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 {
-	return db % xfs_dir2_free_max_bests(mp);
+	return db % xfs_dir2_free_max_bests(geo);
 }
 
 static int
-xfs_dir3_free_max_bests(struct xfs_mount *mp)
+xfs_dir3_free_max_bests(struct xfs_da_geometry *geo)
 {
-	return (mp->m_dirblksize - sizeof(struct xfs_dir3_free_hdr)) /
+	return (geo->blksize - sizeof(struct xfs_dir3_free_hdr)) /
 		sizeof(xfs_dir2_data_off_t);
 }
 
@@ -640,19 +640,19 @@ xfs_dir3_free_bests_p(struct xfs_dir2_free *free)
  * Convert data space db to the corresponding free db.
  */
 static xfs_dir2_db_t
-xfs_dir3_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
+xfs_dir3_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 {
-	return xfs_dir2_byte_to_db(mp->m_dir_geo, XFS_DIR2_FREE_OFFSET) +
-			(db / xfs_dir3_free_max_bests(mp));
+	return xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET) +
+			(db / xfs_dir3_free_max_bests(geo));
 }
 
 /*
  * Convert data space db to the corresponding index in a free db.
  */
 static int
-xfs_dir3_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
+xfs_dir3_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
 {
-	return db % xfs_dir3_free_max_bests(mp);
+	return db % xfs_dir3_free_max_bests(geo);
 }
 
 static void
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index d74c292..6e8107c 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -650,8 +650,8 @@ xfs_dir2_isblock(
 	mp = dp->i_mount;
 	if ((rval = xfs_bmap_last_offset(dp, &last, XFS_DATA_FORK)))
 		return rval;
-	rval = XFS_FSB_TO_B(mp, last) == mp->m_dirblksize;
-	ASSERT(rval == 0 || dp->i_d.di_size == mp->m_dirblksize);
+	rval = XFS_FSB_TO_B(mp, last) == mp->m_dir_geo->blksize;
+	ASSERT(rval == 0 || dp->i_d.di_size == mp->m_dir_geo->blksize);
 	*vp = rval;
 	return 0;
 }
@@ -671,7 +671,7 @@ xfs_dir2_isleaf(
 	mp = dp->i_mount;
 	if ((rval = xfs_bmap_last_offset(dp, &last, XFS_DATA_FORK)))
 		return rval;
-	*vp = last == mp->m_dir_geo->leafblk + (1 << mp->m_sb.sb_dirblklog);
+	*vp = last == mp->m_dir_geo->leafblk + mp->m_dir_geo->blksize;
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 7b09ef0..85f6be6 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -80,7 +80,7 @@ struct xfs_dir_ops {
 				    struct xfs_dir3_icleaf_hdr *from);
 	void	(*leaf_hdr_from_disk)(struct xfs_dir3_icleaf_hdr *to,
 				      struct xfs_dir2_leaf *from);
-	int	(*leaf_max_ents)(struct xfs_mount *mp);
+	int	(*leaf_max_ents)(struct xfs_da_geometry *geo);
 	struct xfs_dir2_leaf_entry *
 		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
 
@@ -97,10 +97,12 @@ struct xfs_dir_ops {
 				    struct xfs_dir3_icfree_hdr *from);
 	void	(*free_hdr_from_disk)(struct xfs_dir3_icfree_hdr *to,
 				      struct xfs_dir2_free *from);
-	int	(*free_max_bests)(struct xfs_mount *mp);
+	int	(*free_max_bests)(struct xfs_da_geometry *geo);
 	__be16 * (*free_bests_p)(struct xfs_dir2_free *free);
-	xfs_dir2_db_t (*db_to_fdb)(struct xfs_mount *mp, xfs_dir2_db_t db);
-	int	(*db_to_fdindex)(struct xfs_mount *mp, xfs_dir2_db_t db);
+	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
+				   xfs_dir2_db_t db);
+	int	(*db_to_fdindex)(struct xfs_da_geometry *geo,
+				 xfs_dir2_db_t db);
 };
 
 extern const struct xfs_dir_ops *
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index d950cde..4204df9 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -377,7 +377,7 @@ xfs_dir2_block_addname(
 	 * Set up pointers to parts of the block.
 	 */
 	hdr = bp->b_addr;
-	btp = xfs_dir2_block_tail_p(mp, hdr);
+	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 
 	/*
@@ -581,7 +581,7 @@ xfs_dir2_block_log_leaf(
 	xfs_dir2_leaf_entry_t	*blp;
 	xfs_dir2_block_tail_t	*btp;
 
-	btp = xfs_dir2_block_tail_p(tp->t_mountp, hdr);
+	btp = xfs_dir2_block_tail_p(tp->t_mountp->m_dir_geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	xfs_trans_log_buf(tp, bp, (uint)((char *)&blp[first] - (char *)hdr),
 		(uint)((char *)&blp[last + 1] - (char *)hdr - 1));
@@ -598,7 +598,7 @@ xfs_dir2_block_log_tail(
 	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
 	xfs_dir2_block_tail_t	*btp;
 
-	btp = xfs_dir2_block_tail_p(tp->t_mountp, hdr);
+	btp = xfs_dir2_block_tail_p(tp->t_mountp->m_dir_geo, hdr);
 	xfs_trans_log_buf(tp, bp, (uint)((char *)btp - (char *)hdr),
 		(uint)((char *)(btp + 1) - (char *)hdr - 1));
 }
@@ -633,7 +633,7 @@ xfs_dir2_block_lookup(
 	mp = dp->i_mount;
 	hdr = bp->b_addr;
 	xfs_dir3_data_check(dp, bp);
-	btp = xfs_dir2_block_tail_p(mp, hdr);
+	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Get the offset from the leaf entry, to point to the data.
@@ -686,7 +686,7 @@ xfs_dir2_block_lookup_int(
 
 	hdr = bp->b_addr;
 	xfs_dir3_data_check(dp, bp);
-	btp = xfs_dir2_block_tail_p(mp, hdr);
+	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Loop doing a binary search for our hash value.
@@ -791,7 +791,7 @@ xfs_dir2_block_removename(
 	tp = args->trans;
 	mp = dp->i_mount;
 	hdr = bp->b_addr;
-	btp = xfs_dir2_block_tail_p(mp, hdr);
+	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Point to the data entry using the leaf entry.
@@ -867,7 +867,7 @@ xfs_dir2_block_replace(
 	dp = args->dp;
 	mp = dp->i_mount;
 	hdr = bp->b_addr;
-	btp = xfs_dir2_block_tail_p(mp, hdr);
+	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Point to the data entry we need to change.
@@ -941,7 +941,7 @@ xfs_dir2_leaf_to_block(
 	leaf = lbp->b_addr;
 	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
-	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 
 	ASSERT(leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
 	       leafhdr.magic == XFS_DIR3_LEAF1_MAGIC);
@@ -951,13 +951,13 @@ xfs_dir2_leaf_to_block(
 	 * been left behind during no-space-reservation operations.
 	 * These will show up in the leaf bests table.
 	 */
-	while (dp->i_d.di_size > mp->m_dirblksize) {
+	while (dp->i_d.di_size > args->geo->blksize) {
 		int hdrsz;
 
 		hdrsz = dp->d_ops->data_entry_offset;
 		bestsp = xfs_dir2_leaf_bests_p(ltp);
 		if (be16_to_cpu(bestsp[be32_to_cpu(ltp->bestcount) - 1]) ==
-					    mp->m_dirblksize - hdrsz) {
+					    args->geo->blksize - hdrsz) {
 			if ((error =
 			    xfs_dir2_leaf_trim_data(args, lbp,
 				    (xfs_dir2_db_t)(be32_to_cpu(ltp->bestcount) - 1))))
@@ -985,7 +985,7 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Look at the last data entry.
 	 */
-	tagp = (__be16 *)((char *)hdr + mp->m_dirblksize) - 1;
+	tagp = (__be16 *)((char *)hdr + args->geo->blksize) - 1;
 	dup = (xfs_dir2_data_unused_t *)((char *)hdr + be16_to_cpu(*tagp));
 	/*
 	 * If it's not free or is too short we can't do it.
@@ -1004,12 +1004,12 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Use up the space at the end of the block (blp/btp).
 	 */
-	xfs_dir2_data_use_free(tp, dp, dbp, dup, mp->m_dirblksize - size, size,
+	xfs_dir2_data_use_free(tp, dp, dbp, dup, args->geo->blksize - size, size,
 		&needlog, &needscan);
 	/*
 	 * Initialize the block tail.
 	 */
-	btp = xfs_dir2_block_tail_p(mp, hdr);
+	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	btp->count = cpu_to_be32(leafhdr.count - leafhdr.stale);
 	btp->stale = 0;
 	xfs_dir2_block_log_tail(tp, dbp);
@@ -1143,13 +1143,13 @@ xfs_dir2_sf_to_block(
 	 */
 	dup = dp->d_ops->data_unused_p(hdr);
 	needlog = needscan = 0;
-	xfs_dir2_data_use_free(tp, dp, bp, dup, mp->m_dirblksize - i, i, &needlog,
-		&needscan);
+	xfs_dir2_data_use_free(tp, dp, bp, dup, args->geo->blksize - i,
+			       i, &needlog, &needscan);
 	ASSERT(needscan == 0);
 	/*
 	 * Fill in the tail.
 	 */
-	btp = xfs_dir2_block_tail_p(mp, hdr);
+	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	btp->count = cpu_to_be32(sfp->count + 2);	/* ., .. */
 	btp->stale = 0;
 	blp = xfs_dir2_block_leaf_p(btp);
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 6c23f86..b73d61a 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -80,7 +80,7 @@ __xfs_dir3_data_check(
 	switch (hdr->magic) {
 	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
 	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
-		btp = xfs_dir2_block_tail_p(mp, hdr);
+		btp = xfs_dir2_block_tail_p(geo, hdr);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endp = (char *)lep;
 
@@ -96,7 +96,7 @@ __xfs_dir3_data_check(
 		break;
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
-		endp = (char *)hdr + mp->m_dirblksize;
+		endp = (char *)hdr + geo->blksize;
 		break;
 	default:
 		XFS_ERROR_REPORT("Bad Magic", XFS_ERRLEVEL_LOW, mp);
@@ -511,6 +511,7 @@ xfs_dir2_data_freescan(
 	struct xfs_dir2_data_free *bf;
 	char			*endp;		/* end of block's data */
 	char			*p;		/* current entry pointer */
+	struct xfs_da_geometry	*geo = dp->i_mount->m_dir_geo;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
@@ -529,10 +530,10 @@ xfs_dir2_data_freescan(
 	p = (char *)dp->d_ops->data_entry_p(hdr);
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
-		btp = xfs_dir2_block_tail_p(dp->i_mount, hdr);
+		btp = xfs_dir2_block_tail_p(geo, hdr);
 		endp = (char *)xfs_dir2_block_leaf_p(btp);
 	} else
-		endp = (char *)hdr + dp->i_mount->m_dirblksize;
+		endp = (char *)hdr + geo->blksize;
 	/*
 	 * Loop over the block's entries.
 	 */
@@ -622,7 +623,7 @@ xfs_dir3_data_init(
 	dup = dp->d_ops->data_unused_p(hdr);
 	dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 
-	t = mp->m_dirblksize - (uint)dp->d_ops->data_entry_offset;
+	t = args->geo->blksize - (uint)dp->d_ops->data_entry_offset;
 	bf[0].length = cpu_to_be16(t);
 	dup->length = cpu_to_be16(t);
 	*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16((char *)dup - (char *)hdr);
@@ -732,22 +733,24 @@ xfs_dir2_data_make_free(
 	xfs_dir2_data_unused_t	*postdup;	/* unused entry after us */
 	xfs_dir2_data_unused_t	*prevdup;	/* unused entry before us */
 	struct xfs_dir2_data_free *bf;
+	struct xfs_da_geometry	*geo;
 
 	mp = tp->t_mountp;
 	hdr = bp->b_addr;
+	geo = mp->m_dir_geo;
 
 	/*
 	 * Figure out where the end of the data area is.
 	 */
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	    hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC))
-		endptr = (char *)hdr + mp->m_dirblksize;
+		endptr = (char *)hdr + geo->blksize;
 	else {
 		xfs_dir2_block_tail_t	*btp;	/* block tail */
 
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 			hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
-		btp = xfs_dir2_block_tail_p(mp, hdr);
+		btp = xfs_dir2_block_tail_p(geo, hdr);
 		endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	}
 	/*
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index a1f1310..e517bd0 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -92,6 +92,7 @@ xfs_dir3_leaf_check_int(
 	int			i;
 	const struct xfs_dir_ops *ops;
 	struct xfs_dir3_icleaf_hdr leafhdr;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
 
 	/*
 	 * we can be passed a null dp here from a verifier, so we need to go the
@@ -105,14 +106,14 @@ xfs_dir3_leaf_check_int(
 	}
 
 	ents = ops->leaf_ents_p(leaf);
-	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
 
 	/*
 	 * XXX (dgc): This value is not restrictive enough.
 	 * Should factor in the size of the bests table as well.
 	 * We can deduce a value for that from di_size.
 	 */
-	if (hdr->count > ops->leaf_max_ents(mp))
+	if (hdr->count > ops->leaf_max_ents(geo))
 		return false;
 
 	/* Leaves and bests don't overlap in leaf format. */
@@ -323,7 +324,7 @@ xfs_dir3_leaf_init(
 	if (type == XFS_DIR2_LEAF1_MAGIC) {
 		struct xfs_dir2_leaf_tail *ltp;
 
-		ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+		ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
 		ltp->bestcount = 0;
 		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
 		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_LEAF1_BUF);
@@ -415,7 +416,7 @@ xfs_dir2_block_to_leaf(
 	leaf = lbp->b_addr;
 	hdr = dbp->b_addr;
 	xfs_dir3_data_check(dp, dbp);
-	btp = xfs_dir2_block_tail_p(mp, hdr);
+	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	bf = dp->d_ops->data_bestfree_p(hdr);
 	ents = dp->d_ops->leaf_ents_p(leaf);
@@ -443,7 +444,7 @@ xfs_dir2_block_to_leaf(
 	 */
 	xfs_dir2_data_make_free(tp, dp, dbp,
 		(xfs_dir2_data_aoff_t)((char *)blp - (char *)hdr),
-		(xfs_dir2_data_aoff_t)((char *)hdr + mp->m_dirblksize -
+		(xfs_dir2_data_aoff_t)((char *)hdr + args->geo->blksize -
 				       (char *)blp),
 		&needlog, &needscan);
 	/*
@@ -461,7 +462,7 @@ xfs_dir2_block_to_leaf(
 	/*
 	 * Set up leaf tail and bests table.
 	 */
-	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	ltp->bestcount = cpu_to_be32(1);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	bestsp[0] =  bf[0].length;
@@ -653,7 +654,7 @@ xfs_dir2_leaf_addname(
 	 */
 	index = xfs_dir2_leaf_search_hash(args, lbp);
 	leaf = lbp->b_addr;
-	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
@@ -1066,7 +1067,7 @@ xfs_dir3_leaf_log_bests(
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC));
 
-	ltp = xfs_dir2_leaf_tail_p(tp->t_mountp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(tp->t_mountp->m_dir_geo, leaf);
 	firstb = xfs_dir2_leaf_bests_p(ltp) + first;
 	lastb = xfs_dir2_leaf_bests_p(ltp) + last;
 	xfs_trans_log_buf(tp, bp, (uint)((char *)firstb - (char *)leaf),
@@ -1138,9 +1139,9 @@ xfs_dir3_leaf_log_tail(
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
 
-	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
 	xfs_trans_log_buf(tp, bp, (uint)((char *)ltp - (char *)leaf),
-		(uint)(mp->m_dirblksize - 1));
+		(uint)(mp->m_dir_geo->blksize - 1));
 }
 
 /*
@@ -1388,7 +1389,7 @@ xfs_dir2_leaf_removename(
 		xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
-	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	ASSERT(be16_to_cpu(bestsp[db]) == oldbest);
 	/*
@@ -1428,7 +1429,7 @@ xfs_dir2_leaf_removename(
 	 * If the data block is now empty then get rid of the data block.
 	 */
 	if (be16_to_cpu(bf[0].length) ==
-			mp->m_dirblksize - dp->d_ops->data_entry_offset) {
+			args->geo->blksize - dp->d_ops->data_entry_offset) {
 		ASSERT(db != args->geo->datablk);
 		if ((error = xfs_dir2_shrink_inode(args, db, dbp))) {
 			/*
@@ -1618,7 +1619,7 @@ xfs_dir2_leaf_trim_data(
 		return error;
 
 	leaf = lbp->b_addr;
-	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 
 #ifdef DEBUG
 {
@@ -1628,7 +1629,7 @@ xfs_dir2_leaf_trim_data(
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
 	ASSERT(be16_to_cpu(bf[0].length) ==
-	       mp->m_dirblksize - dp->d_ops->data_entry_offset);
+	       args->geo->blksize - dp->d_ops->data_entry_offset);
 	ASSERT(db == be32_to_cpu(ltp->bestcount) - 1);
 }
 #endif
@@ -1740,7 +1741,7 @@ xfs_dir2_node_to_leaf(
 	/*
 	 * If it's not the single leaf block, give up.
 	 */
-	if (XFS_FSB_TO_B(mp, fo) > XFS_DIR2_LEAF_OFFSET + mp->m_dirblksize)
+	if (XFS_FSB_TO_B(mp, fo) > XFS_DIR2_LEAF_OFFSET + args->geo->blksize)
 		return 0;
 	lbp = state->path.blk[0].bp;
 	leaf = lbp->b_addr;
@@ -1764,7 +1765,7 @@ xfs_dir2_node_to_leaf(
 	 * Now see if the leafn and free data will fit in a leaf1.
 	 * If not, release the buffer and give up.
 	 */
-	if (xfs_dir3_leaf_size(&leafhdr, freehdr.nvalid) > mp->m_dirblksize) {
+	if (xfs_dir3_leaf_size(&leafhdr, freehdr.nvalid) > args->geo->blksize) {
 		xfs_trans_brelse(tp, fbp);
 		return 0;
 	}
@@ -1784,7 +1785,7 @@ xfs_dir2_node_to_leaf(
 	/*
 	 * Set up the leaf tail from the freespace block.
 	 */
-	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	ltp->bestcount = cpu_to_be32(freehdr.nvalid);
 
 	/*
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 89777bf..ef34c19 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -327,9 +327,9 @@ xfs_dir2_leaf_to_node(
 	free = fbp->b_addr;
 	dp->d_ops->free_hdr_from_disk(&freehdr, free);
 	leaf = lbp->b_addr;
-	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	ASSERT(be32_to_cpu(ltp->bestcount) <=
-				(uint)dp->i_d.di_size / mp->m_dirblksize);
+				(uint)dp->i_d.di_size / args->geo->blksize);
 
 	/*
 	 * Copy freespace entries from the leaf block to the new block.
@@ -416,7 +416,7 @@ xfs_dir2_leafn_add(
 	 * a compact.
 	 */
 
-	if (leafhdr.count == dp->d_ops->leaf_max_ents(mp)) {
+	if (leafhdr.count == dp->d_ops->leaf_max_ents(args->geo)) {
 		if (!leafhdr.stale)
 			return XFS_ERROR(ENOSPC);
 		compact = leafhdr.stale > 1;
@@ -472,7 +472,8 @@ xfs_dir2_free_hdr_check(
 
 	dp->d_ops->free_hdr_from_disk(&hdr, bp->b_addr);
 
-	ASSERT((hdr.firstdb % dp->d_ops->free_max_bests(dp->i_mount)) == 0);
+	ASSERT((hdr.firstdb %
+		dp->d_ops->free_max_bests(dp->i_mount->m_dir_geo)) == 0);
 	ASSERT(hdr.firstdb <= db);
 	ASSERT(db < hdr.firstdb + hdr.nvalid);
 }
@@ -595,7 +596,7 @@ xfs_dir2_leafn_lookup_for_addname(
 			 * Convert the data block to the free block
 			 * holding its freespace information.
 			 */
-			newfdb = dp->d_ops->db_to_fdb(mp, newdb);
+			newfdb = dp->d_ops->db_to_fdb(args->geo, newdb);
 			/*
 			 * If it's not the one we have in hand, read it in.
 			 */
@@ -619,7 +620,7 @@ xfs_dir2_leafn_lookup_for_addname(
 			/*
 			 * Get the index for our entry.
 			 */
-			fi = dp->d_ops->db_to_fdindex(mp, curdb);
+			fi = dp->d_ops->db_to_fdindex(args->geo, curdb);
 			/*
 			 * If it has room, return it.
 			 */
@@ -1251,7 +1252,7 @@ xfs_dir2_leafn_remove(
 		 * Convert the data block number to a free block,
 		 * read in the free block.
 		 */
-		fdb = dp->d_ops->db_to_fdb(mp, db);
+		fdb = dp->d_ops->db_to_fdb(args->geo, db);
 		error = xfs_dir2_free_read(tp, dp,
 					   xfs_dir2_db_to_da(args->geo, fdb),
 					   &fbp);
@@ -1262,7 +1263,7 @@ xfs_dir2_leafn_remove(
 	{
 		struct xfs_dir3_icfree_hdr freehdr;
 		dp->d_ops->free_hdr_from_disk(&freehdr, free);
-		ASSERT(freehdr.firstdb == dp->d_ops->free_max_bests(mp) *
+		ASSERT(freehdr.firstdb == dp->d_ops->free_max_bests(args->geo) *
 			(fdb - xfs_dir2_byte_to_db(args->geo,
 						   XFS_DIR2_FREE_OFFSET)));
 	}
@@ -1270,13 +1271,13 @@ xfs_dir2_leafn_remove(
 		/*
 		 * Calculate which entry we need to fix.
 		 */
-		findex = dp->d_ops->db_to_fdindex(mp, db);
+		findex = dp->d_ops->db_to_fdindex(args->geo, db);
 		longest = be16_to_cpu(bf[0].length);
 		/*
 		 * If the data block is now empty we can get rid of it
 		 * (usually).
 		 */
-		if (longest == mp->m_dirblksize -
+		if (longest == args->geo->blksize -
 			       dp->d_ops->data_entry_offset) {
 			/*
 			 * Try to punch out the data block.
@@ -1595,7 +1596,7 @@ xfs_dir2_node_addname(
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
-	state->blocksize = state->mp->m_dirblksize;
+	state->blocksize = state->args->geo->blksize;
 	state->node_ents = state->mp->m_dir_node_ents;
 	/*
 	 * Look up the name.  We're not supposed to find it, but
@@ -1843,7 +1844,7 @@ xfs_dir2_node_addname_int(
 		 * Get the freespace block corresponding to the data block
 		 * that was just allocated.
 		 */
-		fbno = dp->d_ops->db_to_fdb(mp, dbno);
+		fbno = dp->d_ops->db_to_fdb(args->geo, dbno);
 		error = xfs_dir2_free_try_read(tp, dp,
 				       xfs_dir2_db_to_da(args->geo, fbno),
 				       &fbp);
@@ -1860,12 +1861,13 @@ xfs_dir2_node_addname_int(
 			if (error)
 				return error;
 
-			if (unlikely(dp->d_ops->db_to_fdb(mp, dbno) != fbno)) {
+			if (dp->d_ops->db_to_fdb(args->geo, dbno) != fbno) {
 				xfs_alert(mp,
 			"%s: dir ino %llu needed freesp block %lld for\n"
 			"  data block %lld, got %lld ifbno %llu lastfbno %d",
 					__func__, (unsigned long long)dp->i_ino,
-					(long long)dp->d_ops->db_to_fdb(mp, dbno),
+					(long long)dp->d_ops->db_to_fdb(
+								args->geo, dbno),
 					(long long)dbno, (long long)fbno,
 					(unsigned long long)ifbno, lastfbno);
 				if (fblk) {
@@ -1899,7 +1901,7 @@ xfs_dir2_node_addname_int(
 			freehdr.firstdb =
 				(fbno - xfs_dir2_byte_to_db(args->geo,
 							XFS_DIR2_FREE_OFFSET)) *
-					dp->d_ops->free_max_bests(mp);
+					dp->d_ops->free_max_bests(args->geo);
 		} else {
 			free = fbp->b_addr;
 			bests = dp->d_ops->free_bests_p(free);
@@ -1909,13 +1911,13 @@ xfs_dir2_node_addname_int(
 		/*
 		 * Set the freespace block index from the data block number.
 		 */
-		findex = dp->d_ops->db_to_fdindex(mp, dbno);
+		findex = dp->d_ops->db_to_fdindex(args->geo, dbno);
 		/*
 		 * If it's after the end of the current entries in the
 		 * freespace block, extend that table.
 		 */
 		if (findex >= freehdr.nvalid) {
-			ASSERT(findex < dp->d_ops->free_max_bests(mp));
+			ASSERT(findex < dp->d_ops->free_max_bests(args->geo));
 			freehdr.nvalid = findex + 1;
 			/*
 			 * Tag new entry so nused will go up.
@@ -2040,7 +2042,7 @@ xfs_dir2_node_lookup(
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
-	state->blocksize = state->mp->m_dirblksize;
+	state->blocksize = args->geo->blksize;
 	state->node_ents = state->mp->m_dir_node_ents;
 	/*
 	 * Fill in the path to the entry in the cursor.
@@ -2095,7 +2097,7 @@ xfs_dir2_node_removename(
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
-	state->blocksize = state->mp->m_dirblksize;
+	state->blocksize = args->geo->blksize;
 	state->node_ents = state->mp->m_dir_node_ents;
 
 	/* Look up the entry we're deleting, set up the cursor. */
@@ -2165,7 +2167,7 @@ xfs_dir2_node_replace(
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
-	state->blocksize = state->mp->m_dirblksize;
+	state->blocksize = args->geo->blksize;
 	state->node_ents = state->mp->m_dir_node_ents;
 	inum = args->inumber;
 	/*
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 8cb5340..fa393d5 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -216,7 +216,7 @@ xfs_dir2_block_getdents(
 	/*
 	 * Set up values for the loop.
 	 */
-	btp = xfs_dir2_block_tail_p(mp, hdr);
+	btp = xfs_dir2_block_tail_p(geo, hdr);
 	ptr = (char *)dp->d_ops->data_entry_p(hdr);
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 
@@ -338,7 +338,7 @@ xfs_dir2_leaf_readbuf(
 	/*
 	 * Recalculate the readahead blocks wanted.
 	 */
-	mip->ra_want = howmany(bufsize + mp->m_dirblksize,
+	mip->ra_want = howmany(bufsize + geo->blksize,
 			       mp->m_sb.sb_blocksize) - 1;
 	ASSERT(mip->ra_want >= 0);
 
@@ -526,8 +526,7 @@ xfs_dir2_leaf_getdents(
 	 * buffer size, the directory block size, and the filesystem
 	 * block size.
 	 */
-	length = howmany(bufsize + mp->m_dirblksize,
-				     mp->m_sb.sb_blocksize);
+	length = howmany(bufsize + geo->blksize, mp->m_sb.sb_blocksize);
 	map_info = kmem_zalloc(offsetof(struct xfs_dir2_leaf_map_info, map) +
 				(length * sizeof(struct xfs_bmbt_irec)),
 			       KM_SLEEP | KM_NOFS);
@@ -557,7 +556,7 @@ xfs_dir2_leaf_getdents(
 		 * If we have no buffer, or we're off the end of the
 		 * current buffer, need to get another one.
 		 */
-		if (!bp || ptr >= (char *)bp->b_addr + mp->m_dirblksize) {
+		if (!bp || ptr >= (char *)bp->b_addr + geo->blksize) {
 
 			error = xfs_dir2_leaf_readbuf(dp, bufsize, map_info,
 						      &curoff, &bp);
@@ -618,7 +617,7 @@ xfs_dir2_leaf_getdents(
 					xfs_dir2_db_off_to_byte(geo,
 					    xfs_dir2_byte_to_db(geo, curoff),
 					    (char *)ptr - (char *)hdr);
-				if (ptr >= (char *)hdr + mp->m_dirblksize) {
+				if (ptr >= (char *)hdr + geo->blksize) {
 					continue;
 				}
 			}
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 10f4c2a..53c3be6 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -82,8 +82,10 @@ xfs_dir2_block_sfsize(
 	xfs_ino_t		parent = 0;	/* parent inode number */
 	int			size=0;		/* total computed size */
 	int			has_ftype;
+	struct xfs_da_geometry	*geo;
 
 	mp = dp->i_mount;
+	geo = mp->m_dir_geo;
 
 	/*
 	 * if there is a filetype field, add the extra byte to the namelen
@@ -92,7 +94,7 @@ xfs_dir2_block_sfsize(
 	has_ftype = xfs_sb_version_hasftype(&mp->m_sb) ? 1 : 0;
 
 	count = i8count = namelen = 0;
-	btp = xfs_dir2_block_tail_p(mp, hdr);
+	btp = xfs_dir2_block_tail_p(geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 
 	/*
@@ -105,7 +107,7 @@ xfs_dir2_block_sfsize(
 		 * Calculate the pointer to the entry at hand.
 		 */
 		dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-				xfs_dir2_dataptr_to_off(mp->m_dir_geo, addr));
+				xfs_dir2_dataptr_to_off(geo, addr));
 		/*
 		 * Detect . and .., so we can special-case them.
 		 * . is not included in sf directories.
@@ -195,7 +197,7 @@ xfs_dir2_block_to_sf(
 	/*
 	 * Set up to loop over the block's entries.
 	 */
-	btp = xfs_dir2_block_tail_p(mp, hdr);
+	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	ptr = (char *)dp->d_ops->data_entry_p(hdr);
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	sfep = xfs_dir2_sf_firstentry(sfp);
@@ -586,7 +588,7 @@ xfs_dir2_sf_addname_pick(
 	 * we'll go back, convert to block, then try the insert and convert
 	 * to leaf.
 	 */
-	if (used + (holefit ? 0 : size) > mp->m_dirblksize)
+	if (used + (holefit ? 0 : size) > args->geo->blksize)
 		return 0;
 	/*
 	 * If changing the inode number size, do it the hard way.
@@ -601,7 +603,7 @@ xfs_dir2_sf_addname_pick(
 	/*
 	 * If it won't fit at the end then do it the hard way (use the hole).
 	 */
-	if (used + size > mp->m_dirblksize)
+	if (used + size > args->geo->blksize)
 		return 2;
 	/*
 	 * Do it the easy way.
@@ -652,7 +654,7 @@ xfs_dir2_sf_check(
 	ASSERT((char *)sfep - (char *)sfp == dp->i_d.di_size);
 	ASSERT(offset +
 	       (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
-	       (uint)sizeof(xfs_dir2_block_tail_t) <= mp->m_dirblksize);
+	       (uint)sizeof(xfs_dir2_block_tail_t) <= args->geo->blksize);
 }
 #endif	/* DEBUG */
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 97886a7..d229556 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -24,6 +24,8 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
@@ -105,7 +107,7 @@ xfs_fs_geometry(
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;
-		geo->dirblocksize = mp->m_dirblksize;
+		geo->dirblocksize = mp->m_dir_geo->blksize;
 	}
 	if (new_version >= 4) {
 		geo->flags |=
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a23e7b6..4e3f6ce 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -154,7 +154,6 @@ typedef struct xfs_mount {
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	const struct xfs_dir_ops *m_dir_inode_ops; /* vector of dir inode ops */
 	const struct xfs_dir_ops *m_nondir_inode_ops; /* !dir inode ops */
-	int			m_dirblksize;	/* directory block sz--bytes */
 	uint			m_chsize;	/* size of next field */
 	atomic_t		m_active_trans;	/* number trans frozen */
 #ifdef HAVE_PERCPU_SB
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index 63a42a1..f2bda7c 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -610,7 +610,7 @@ xfs_calc_addafork_reservation(
 	return XFS_DQUOT_LOGRES(mp) +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(1, mp->m_dirblksize) +
+		xfs_calc_buf_res(1, mp->m_dir_geo->blksize) +
 		xfs_calc_buf_res(XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1,
 				 XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
