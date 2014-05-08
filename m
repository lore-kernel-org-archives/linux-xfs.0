Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D8F317F96
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 03:20:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 729D18F804B
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 01:20:05 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IfG3qO7KbhZxf7KA for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 01:20:01 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WiJYV-0001jE-Bc
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WiJYV-0006wz-AH
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/18] xfs: remove mp->m_dir_geo from directory logging
Date: Thu,  8 May 2014 18:19:43 +1000
Message-Id: <1399537188-26509-14-git-send-email-david@fromorbit.com>
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

We don't pass the xfs_da_args or the geometry all the way down to
the directory buffer logging code, hence we have to use
mp->m_dir_geo here. Fix this to use the geometry passed via the
xfs_da_args, and convert all the directory logging functions for
consistency.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2.h       |  12 +++---
 fs/xfs/xfs_dir2_block.c |  39 +++++++++---------
 fs/xfs/xfs_dir2_data.c  |  59 ++++++++++++---------------
 fs/xfs/xfs_dir2_leaf.c  | 103 +++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_dir2_node.c  |  68 +++++++++++++++-----------------
 fs/xfs/xfs_dir2_priv.h  |   4 +-
 6 files changed, 137 insertions(+), 148 deletions(-)

diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index f2f6bb8..608f5b8 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -151,16 +151,16 @@ extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 
 extern void xfs_dir2_data_freescan(struct xfs_inode *dp,
 		struct xfs_dir2_data_hdr *hdr, int *loghead);
-extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_inode *dp,
+extern void xfs_dir2_data_log_entry(struct xfs_da_args *args,
 		struct xfs_buf *bp, struct xfs_dir2_data_entry *dep);
-extern void xfs_dir2_data_log_header(struct xfs_trans *tp, struct xfs_inode *dp,
+extern void xfs_dir2_data_log_header(struct xfs_da_args *args,
 		struct xfs_buf *bp);
-extern void xfs_dir2_data_log_unused(struct xfs_trans *tp, struct xfs_buf *bp,
-		struct xfs_dir2_data_unused *dup);
-extern void xfs_dir2_data_make_free(struct xfs_trans *tp, struct xfs_inode *dp,
+extern void xfs_dir2_data_log_unused(struct xfs_da_args *args,
+		struct xfs_buf *bp, struct xfs_dir2_data_unused *dup);
+extern void xfs_dir2_data_make_free(struct xfs_da_args *args,
 		struct xfs_buf *bp, xfs_dir2_data_aoff_t offset,
 		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
-extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_inode *dp,
+extern void xfs_dir2_data_use_free(struct xfs_da_args *args,
 		struct xfs_buf *bp, struct xfs_dir2_data_unused *dup,
 		xfs_dir2_data_aoff_t offset, xfs_dir2_data_aoff_t len,
 		int *needlogp, int *needscanp);
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 4204df9..c7cd315 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -281,8 +281,7 @@ out:
  */
 static void
 xfs_dir2_block_compact(
-	struct xfs_trans		*tp,
-	struct xfs_inode		*dp,
+	struct xfs_da_args		*args,
 	struct xfs_buf			*bp,
 	struct xfs_dir2_data_hdr	*hdr,
 	struct xfs_dir2_block_tail	*btp,
@@ -315,7 +314,7 @@ xfs_dir2_block_compact(
 	*lfloglow = toidx + 1 - (be32_to_cpu(btp->stale) - 1);
 	*lfloghigh -= be32_to_cpu(btp->stale) - 1;
 	be32_add_cpu(&btp->count, -(be32_to_cpu(btp->stale) - 1));
-	xfs_dir2_data_make_free(tp, dp, bp,
+	xfs_dir2_data_make_free(args, bp,
 		(xfs_dir2_data_aoff_t)((char *)blp - (char *)hdr),
 		(xfs_dir2_data_aoff_t)((be32_to_cpu(btp->stale) - 1) * sizeof(*blp)),
 		needlog, &needscan);
@@ -325,7 +324,7 @@ xfs_dir2_block_compact(
 	 * This needs to happen before the next call to use_free.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(dp, hdr, needlog);
+		xfs_dir2_data_freescan(args->dp, hdr, needlog);
 }
 
 /*
@@ -420,7 +419,7 @@ xfs_dir2_block_addname(
 	 * If need to compact the leaf entries, do it now.
 	 */
 	if (compact) {
-		xfs_dir2_block_compact(tp, dp, bp, hdr, btp, blp, &needlog,
+		xfs_dir2_block_compact(args, bp, hdr, btp, blp, &needlog,
 				      &lfloghigh, &lfloglow);
 		/* recalculate blp post-compaction */
 		blp = xfs_dir2_block_leaf_p(btp);
@@ -455,7 +454,7 @@ xfs_dir2_block_addname(
 		/*
 		 * Mark the space needed for the new leaf entry, now in use.
 		 */
-		xfs_dir2_data_use_free(tp, dp, bp, enddup,
+		xfs_dir2_data_use_free(args, bp, enddup,
 			(xfs_dir2_data_aoff_t)
 			((char *)enddup - (char *)hdr + be16_to_cpu(enddup->length) -
 			 sizeof(*blp)),
@@ -542,7 +541,7 @@ xfs_dir2_block_addname(
 	/*
 	 * Mark space for the data entry used.
 	 */
-	xfs_dir2_data_use_free(tp, dp, bp, dup,
+	xfs_dir2_data_use_free(args, bp, dup,
 		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr),
 		(xfs_dir2_data_aoff_t)len, &needlog, &needscan);
 	/*
@@ -560,9 +559,9 @@ xfs_dir2_block_addname(
 	if (needscan)
 		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dp, bp);
+		xfs_dir2_data_log_header(args, bp);
 	xfs_dir2_block_log_tail(tp, bp);
-	xfs_dir2_data_log_entry(tp, dp, bp, dep);
+	xfs_dir2_data_log_entry(args, bp, dep);
 	xfs_dir3_data_check(dp, bp);
 	return 0;
 }
@@ -803,7 +802,7 @@ xfs_dir2_block_removename(
 	 * Mark the data entry's space free.
 	 */
 	needlog = needscan = 0;
-	xfs_dir2_data_make_free(tp, dp, bp,
+	xfs_dir2_data_make_free(args, bp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
 		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
 	/*
@@ -822,7 +821,7 @@ xfs_dir2_block_removename(
 	if (needscan)
 		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dp, bp);
+		xfs_dir2_data_log_header(args, bp);
 	xfs_dir3_data_check(dp, bp);
 	/*
 	 * See if the size as a shortform is good enough.
@@ -881,7 +880,7 @@ xfs_dir2_block_replace(
 	 */
 	dep->inumber = cpu_to_be64(args->inumber);
 	dp->d_ops->data_put_ftype(dep, args->filetype);
-	xfs_dir2_data_log_entry(args->trans, dp, bp, dep);
+	xfs_dir2_data_log_entry(args, bp, dep);
 	xfs_dir3_data_check(dp, bp);
 	return 0;
 }
@@ -1004,7 +1003,7 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Use up the space at the end of the block (blp/btp).
 	 */
-	xfs_dir2_data_use_free(tp, dp, dbp, dup, args->geo->blksize - size, size,
+	xfs_dir2_data_use_free(args, dbp, dup, args->geo->blksize - size, size,
 		&needlog, &needscan);
 	/*
 	 * Initialize the block tail.
@@ -1030,7 +1029,7 @@ xfs_dir2_leaf_to_block(
 	if (needscan)
 		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dp, dbp);
+		xfs_dir2_data_log_header(args, dbp);
 	/*
 	 * Pitch the old leaf block.
 	 */
@@ -1143,7 +1142,7 @@ xfs_dir2_sf_to_block(
 	 */
 	dup = dp->d_ops->data_unused_p(hdr);
 	needlog = needscan = 0;
-	xfs_dir2_data_use_free(tp, dp, bp, dup, args->geo->blksize - i,
+	xfs_dir2_data_use_free(args, bp, dup, args->geo->blksize - i,
 			       i, &needlog, &needscan);
 	ASSERT(needscan == 0);
 	/*
@@ -1157,7 +1156,7 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Remove the freespace, we'll manage it.
 	 */
-	xfs_dir2_data_use_free(tp, dp, bp, dup,
+	xfs_dir2_data_use_free(args, bp, dup,
 		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr),
 		be16_to_cpu(dup->length), &needlog, &needscan);
 	/*
@@ -1170,7 +1169,7 @@ xfs_dir2_sf_to_block(
 	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
-	xfs_dir2_data_log_entry(tp, dp, bp, dep);
+	xfs_dir2_data_log_entry(args, bp, dep);
 	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
 	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
 				(char *)dep - (char *)hdr));
@@ -1184,7 +1183,7 @@ xfs_dir2_sf_to_block(
 	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
-	xfs_dir2_data_log_entry(tp, dp, bp, dep);
+	xfs_dir2_data_log_entry(args, bp, dep);
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
 	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
 				(char *)dep - (char *)hdr));
@@ -1218,7 +1217,7 @@ xfs_dir2_sf_to_block(
 			dup->length = cpu_to_be16(newoffset - offset);
 			*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16(
 				((char *)dup - (char *)hdr));
-			xfs_dir2_data_log_unused(tp, bp, dup);
+			xfs_dir2_data_log_unused(args, bp, dup);
 			xfs_dir2_data_freeinsert(hdr,
 						 dp->d_ops->data_bestfree_p(hdr),
 						 dup, &dummy);
@@ -1235,7 +1234,7 @@ xfs_dir2_sf_to_block(
 		memcpy(dep->name, sfep->name, dep->namelen);
 		tagp = dp->d_ops->data_entry_tag_p(dep);
 		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
-		xfs_dir2_data_log_entry(tp, dp, bp, dep);
+		xfs_dir2_data_log_entry(args, bp, dep);
 		name.name = sfep->name;
 		name.len = sfep->namelen;
 		blp[2 + i].hashval = cpu_to_be32(mp->m_dirnameops->
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index b73d61a..8c2f642 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -630,8 +630,8 @@ xfs_dir3_data_init(
 	/*
 	 * Log it and return it.
 	 */
-	xfs_dir2_data_log_header(tp, dp, bp);
-	xfs_dir2_data_log_unused(tp, bp, dup);
+	xfs_dir2_data_log_header(args, bp);
+	xfs_dir2_data_log_unused(args, bp, dup);
 	*bpp = bp;
 	return 0;
 }
@@ -641,8 +641,7 @@ xfs_dir3_data_init(
  */
 void
 xfs_dir2_data_log_entry(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp,
+	struct xfs_da_args	*args,
 	struct xfs_buf		*bp,
 	xfs_dir2_data_entry_t	*dep)		/* data entry pointer */
 {
@@ -653,8 +652,8 @@ xfs_dir2_data_log_entry(
 	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
-	xfs_trans_log_buf(tp, bp, (uint)((char *)dep - (char *)hdr),
-		(uint)((char *)(dp->d_ops->data_entry_tag_p(dep) + 1) -
+	xfs_trans_log_buf(args->trans, bp, (uint)((char *)dep - (char *)hdr),
+		(uint)((char *)(args->dp->d_ops->data_entry_tag_p(dep) + 1) -
 		       (char *)hdr - 1));
 }
 
@@ -663,8 +662,7 @@ xfs_dir2_data_log_entry(
  */
 void
 xfs_dir2_data_log_header(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp,
+	struct xfs_da_args	*args,
 	struct xfs_buf		*bp)
 {
 #ifdef DEBUG
@@ -676,7 +674,8 @@ xfs_dir2_data_log_header(
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 #endif
 
-	xfs_trans_log_buf(tp, bp, 0, dp->d_ops->data_entry_offset - 1);
+	xfs_trans_log_buf(args->trans, bp, 0,
+			  args->dp->d_ops->data_entry_offset - 1);
 }
 
 /*
@@ -684,7 +683,7 @@ xfs_dir2_data_log_header(
  */
 void
 xfs_dir2_data_log_unused(
-	struct xfs_trans	*tp,
+	struct xfs_da_args	*args,
 	struct xfs_buf		*bp,
 	xfs_dir2_data_unused_t	*dup)		/* data unused pointer */
 {
@@ -698,13 +697,13 @@ xfs_dir2_data_log_unused(
 	/*
 	 * Log the first part of the unused entry.
 	 */
-	xfs_trans_log_buf(tp, bp, (uint)((char *)dup - (char *)hdr),
+	xfs_trans_log_buf(args->trans, bp, (uint)((char *)dup - (char *)hdr),
 		(uint)((char *)&dup->length + sizeof(dup->length) -
 		       1 - (char *)hdr));
 	/*
 	 * Log the end (tag) of the unused entry.
 	 */
-	xfs_trans_log_buf(tp, bp,
+	xfs_trans_log_buf(args->trans, bp,
 		(uint)((char *)xfs_dir2_data_unused_tag_p(dup) - (char *)hdr),
 		(uint)((char *)xfs_dir2_data_unused_tag_p(dup) - (char *)hdr +
 		       sizeof(xfs_dir2_data_off_t) - 1));
@@ -716,8 +715,7 @@ xfs_dir2_data_log_unused(
  */
 void
 xfs_dir2_data_make_free(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp,
+	struct xfs_da_args	*args,
 	struct xfs_buf		*bp,
 	xfs_dir2_data_aoff_t	offset,		/* starting byte offset */
 	xfs_dir2_data_aoff_t	len,		/* length in bytes */
@@ -727,37 +725,33 @@ xfs_dir2_data_make_free(
 	xfs_dir2_data_hdr_t	*hdr;		/* data block pointer */
 	xfs_dir2_data_free_t	*dfp;		/* bestfree pointer */
 	char			*endptr;	/* end of data area */
-	xfs_mount_t		*mp;		/* filesystem mount point */
 	int			needscan;	/* need to regen bestfree */
 	xfs_dir2_data_unused_t	*newdup;	/* new unused entry */
 	xfs_dir2_data_unused_t	*postdup;	/* unused entry after us */
 	xfs_dir2_data_unused_t	*prevdup;	/* unused entry before us */
 	struct xfs_dir2_data_free *bf;
-	struct xfs_da_geometry	*geo;
 
-	mp = tp->t_mountp;
 	hdr = bp->b_addr;
-	geo = mp->m_dir_geo;
 
 	/*
 	 * Figure out where the end of the data area is.
 	 */
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	    hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC))
-		endptr = (char *)hdr + geo->blksize;
+		endptr = (char *)hdr + args->geo->blksize;
 	else {
 		xfs_dir2_block_tail_t	*btp;	/* block tail */
 
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 			hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
-		btp = xfs_dir2_block_tail_p(geo, hdr);
+		btp = xfs_dir2_block_tail_p(args->geo, hdr);
 		endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	}
 	/*
 	 * If this isn't the start of the block, then back up to
 	 * the previous entry and see if it's free.
 	 */
-	if (offset > dp->d_ops->data_entry_offset) {
+	if (offset > args->dp->d_ops->data_entry_offset) {
 		__be16			*tagp;	/* tag just before us */
 
 		tagp = (__be16 *)((char *)hdr + offset) - 1;
@@ -783,7 +777,7 @@ xfs_dir2_data_make_free(
 	 * Previous and following entries are both free,
 	 * merge everything into a single free entry.
 	 */
-	bf = dp->d_ops->data_bestfree_p(hdr);
+	bf = args->dp->d_ops->data_bestfree_p(hdr);
 	if (prevdup && postdup) {
 		xfs_dir2_data_free_t	*dfp2;	/* another bestfree pointer */
 
@@ -805,7 +799,7 @@ xfs_dir2_data_make_free(
 		be16_add_cpu(&prevdup->length, len + be16_to_cpu(postdup->length));
 		*xfs_dir2_data_unused_tag_p(prevdup) =
 			cpu_to_be16((char *)prevdup - (char *)hdr);
-		xfs_dir2_data_log_unused(tp, bp, prevdup);
+		xfs_dir2_data_log_unused(args, bp, prevdup);
 		if (!needscan) {
 			/*
 			 * Has to be the case that entries 0 and 1 are
@@ -840,7 +834,7 @@ xfs_dir2_data_make_free(
 		be16_add_cpu(&prevdup->length, len);
 		*xfs_dir2_data_unused_tag_p(prevdup) =
 			cpu_to_be16((char *)prevdup - (char *)hdr);
-		xfs_dir2_data_log_unused(tp, bp, prevdup);
+		xfs_dir2_data_log_unused(args, bp, prevdup);
 		/*
 		 * If the previous entry was in the table, the new entry
 		 * is longer, so it will be in the table too.  Remove
@@ -868,7 +862,7 @@ xfs_dir2_data_make_free(
 		newdup->length = cpu_to_be16(len + be16_to_cpu(postdup->length));
 		*xfs_dir2_data_unused_tag_p(newdup) =
 			cpu_to_be16((char *)newdup - (char *)hdr);
-		xfs_dir2_data_log_unused(tp, bp, newdup);
+		xfs_dir2_data_log_unused(args, bp, newdup);
 		/*
 		 * If the following entry was in the table, the new entry
 		 * is longer, so it will be in the table too.  Remove
@@ -895,7 +889,7 @@ xfs_dir2_data_make_free(
 		newdup->length = cpu_to_be16(len);
 		*xfs_dir2_data_unused_tag_p(newdup) =
 			cpu_to_be16((char *)newdup - (char *)hdr);
-		xfs_dir2_data_log_unused(tp, bp, newdup);
+		xfs_dir2_data_log_unused(args, bp, newdup);
 		xfs_dir2_data_freeinsert(hdr, bf, newdup, needlogp);
 	}
 	*needscanp = needscan;
@@ -906,8 +900,7 @@ xfs_dir2_data_make_free(
  */
 void
 xfs_dir2_data_use_free(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp,
+	struct xfs_da_args	*args,
 	struct xfs_buf		*bp,
 	xfs_dir2_data_unused_t	*dup,		/* unused entry */
 	xfs_dir2_data_aoff_t	offset,		/* starting offset to use */
@@ -938,7 +931,7 @@ xfs_dir2_data_use_free(
 	 * Look up the entry in the bestfree table.
 	 */
 	oldlen = be16_to_cpu(dup->length);
-	bf = dp->d_ops->data_bestfree_p(hdr);
+	bf = args->dp->d_ops->data_bestfree_p(hdr);
 	dfp = xfs_dir2_data_freefind(hdr, bf, dup);
 	ASSERT(dfp || oldlen <= be16_to_cpu(bf[2].length));
 	/*
@@ -970,7 +963,7 @@ xfs_dir2_data_use_free(
 		newdup->length = cpu_to_be16(oldlen - len);
 		*xfs_dir2_data_unused_tag_p(newdup) =
 			cpu_to_be16((char *)newdup - (char *)hdr);
-		xfs_dir2_data_log_unused(tp, bp, newdup);
+		xfs_dir2_data_log_unused(args, bp, newdup);
 		/*
 		 * If it was in the table, remove it and add the new one.
 		 */
@@ -998,7 +991,7 @@ xfs_dir2_data_use_free(
 		newdup->length = cpu_to_be16(((char *)hdr + offset) - (char *)newdup);
 		*xfs_dir2_data_unused_tag_p(newdup) =
 			cpu_to_be16((char *)newdup - (char *)hdr);
-		xfs_dir2_data_log_unused(tp, bp, newdup);
+		xfs_dir2_data_log_unused(args, bp, newdup);
 		/*
 		 * If it was in the table, remove it and add the new one.
 		 */
@@ -1026,13 +1019,13 @@ xfs_dir2_data_use_free(
 		newdup->length = cpu_to_be16(((char *)hdr + offset) - (char *)newdup);
 		*xfs_dir2_data_unused_tag_p(newdup) =
 			cpu_to_be16((char *)newdup - (char *)hdr);
-		xfs_dir2_data_log_unused(tp, bp, newdup);
+		xfs_dir2_data_log_unused(args, bp, newdup);
 		newdup2 = (xfs_dir2_data_unused_t *)((char *)hdr + offset + len);
 		newdup2->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 		newdup2->length = cpu_to_be16(oldlen - len - be16_to_cpu(newdup->length));
 		*xfs_dir2_data_unused_tag_p(newdup2) =
 			cpu_to_be16((char *)newdup2 - (char *)hdr);
-		xfs_dir2_data_log_unused(tp, bp, newdup2);
+		xfs_dir2_data_log_unused(args, bp, newdup2);
 		/*
 		 * If the old entry was in the table, we need to scan
 		 * if the 3rd entry was valid, since these entries
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index e517bd0..fb0aad4 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -41,9 +41,10 @@
  */
 static int xfs_dir2_leaf_lookup_int(xfs_da_args_t *args, struct xfs_buf **lbpp,
 				    int *indexp, struct xfs_buf **dbpp);
-static void xfs_dir3_leaf_log_bests(struct xfs_trans *tp, struct xfs_buf *bp,
-				    int first, int last);
-static void xfs_dir3_leaf_log_tail(struct xfs_trans *tp, struct xfs_buf *bp);
+static void xfs_dir3_leaf_log_bests(struct xfs_da_args *args,
+				    struct xfs_buf *bp, int first, int last);
+static void xfs_dir3_leaf_log_tail(struct xfs_da_args *args,
+				   struct xfs_buf *bp);
 
 /*
  * Check the internal consistency of a leaf1 block.
@@ -357,9 +358,9 @@ xfs_dir3_leaf_get_buf(
 		return error;
 
 	xfs_dir3_leaf_init(mp, tp, bp, dp->i_ino, magic);
-	xfs_dir3_leaf_log_header(tp, dp, bp);
+	xfs_dir3_leaf_log_header(args, bp);
 	if (magic == XFS_DIR2_LEAF1_MAGIC)
-		xfs_dir3_leaf_log_tail(tp, bp);
+		xfs_dir3_leaf_log_tail(args, bp);
 	*bpp = bp;
 	return 0;
 }
@@ -428,21 +429,21 @@ xfs_dir2_block_to_leaf(
 	leafhdr.count = be32_to_cpu(btp->count);
 	leafhdr.stale = be32_to_cpu(btp->stale);
 	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
-	xfs_dir3_leaf_log_header(tp, dp, lbp);
+	xfs_dir3_leaf_log_header(args, lbp);
 
 	/*
 	 * Could compact these but I think we always do the conversion
 	 * after squeezing out stale entries.
 	 */
 	memcpy(ents, blp, be32_to_cpu(btp->count) * sizeof(xfs_dir2_leaf_entry_t));
-	xfs_dir3_leaf_log_ents(tp, dp, lbp, 0, leafhdr.count - 1);
+	xfs_dir3_leaf_log_ents(args, lbp, 0, leafhdr.count - 1);
 	needscan = 0;
 	needlog = 1;
 	/*
 	 * Make the space formerly occupied by the leaf entries and block
 	 * tail be free.
 	 */
-	xfs_dir2_data_make_free(tp, dp, dbp,
+	xfs_dir2_data_make_free(args, dbp,
 		(xfs_dir2_data_aoff_t)((char *)blp - (char *)hdr),
 		(xfs_dir2_data_aoff_t)((char *)hdr + args->geo->blksize -
 				       (char *)blp),
@@ -470,10 +471,10 @@ xfs_dir2_block_to_leaf(
 	 * Log the data header and leaf bests table.
 	 */
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dp, dbp);
+		xfs_dir2_data_log_header(args, dbp);
 	xfs_dir3_leaf_check(dp, lbp);
 	xfs_dir3_data_check(dp, dbp);
-	xfs_dir3_leaf_log_bests(tp, lbp, 0, 0);
+	xfs_dir3_leaf_log_bests(args, lbp, 0, 0);
 	return 0;
 }
 
@@ -811,14 +812,15 @@ xfs_dir2_leaf_addname(
 			memmove(&bestsp[0], &bestsp[1],
 				be32_to_cpu(ltp->bestcount) * sizeof(bestsp[0]));
 			be32_add_cpu(&ltp->bestcount, 1);
-			xfs_dir3_leaf_log_tail(tp, lbp);
-			xfs_dir3_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
+			xfs_dir3_leaf_log_tail(args, lbp);
+			xfs_dir3_leaf_log_bests(args, lbp, 0,
+						be32_to_cpu(ltp->bestcount) - 1);
 		}
 		/*
 		 * If we're filling in a previously empty block just log it.
 		 */
 		else
-			xfs_dir3_leaf_log_bests(tp, lbp, use_block, use_block);
+			xfs_dir3_leaf_log_bests(args, lbp, use_block, use_block);
 		hdr = dbp->b_addr;
 		bf = dp->d_ops->data_bestfree_p(hdr);
 		bestsp[use_block] = bf[0].length;
@@ -849,7 +851,7 @@ xfs_dir2_leaf_addname(
 	/*
 	 * Mark the initial part of our freespace in use for the new entry.
 	 */
-	xfs_dir2_data_use_free(tp, dp, dbp, dup,
+	xfs_dir2_data_use_free(args, dbp, dup,
 		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr), length,
 		&needlog, &needscan);
 	/*
@@ -871,8 +873,8 @@ xfs_dir2_leaf_addname(
 	 * Need to log the data block's header.
 	 */
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dp, dbp);
-	xfs_dir2_data_log_entry(tp, dp, dbp, dep);
+		xfs_dir2_data_log_header(args, dbp);
+	xfs_dir2_data_log_entry(args, dbp, dep);
 	/*
 	 * If the bests table needs to be changed, do it.
 	 * Log the change unless we've already done that.
@@ -880,7 +882,7 @@ xfs_dir2_leaf_addname(
 	if (be16_to_cpu(bestsp[use_block]) != be16_to_cpu(bf[0].length)) {
 		bestsp[use_block] = bf[0].length;
 		if (!grown)
-			xfs_dir3_leaf_log_bests(tp, lbp, use_block, use_block);
+			xfs_dir3_leaf_log_bests(args, lbp, use_block, use_block);
 	}
 
 	lep = xfs_dir3_leaf_find_entry(&leafhdr, ents, index, compact, lowstale,
@@ -897,8 +899,8 @@ xfs_dir2_leaf_addname(
 	 * Log the leaf fields and give up the buffers.
 	 */
 	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
-	xfs_dir3_leaf_log_header(tp, dp, lbp);
-	xfs_dir3_leaf_log_ents(tp, dp, lbp, lfloglow, lfloghigh);
+	xfs_dir3_leaf_log_header(args, lbp);
+	xfs_dir3_leaf_log_ents(args, lbp, lfloglow, lfloghigh);
 	xfs_dir3_leaf_check(dp, lbp);
 	xfs_dir3_data_check(dp, dbp);
 	return 0;
@@ -950,9 +952,9 @@ xfs_dir3_leaf_compact(
 	leafhdr->stale = 0;
 
 	dp->d_ops->leaf_hdr_to_disk(leaf, leafhdr);
-	xfs_dir3_leaf_log_header(args->trans, dp, bp);
+	xfs_dir3_leaf_log_header(args, bp);
 	if (loglow != -1)
-		xfs_dir3_leaf_log_ents(args->trans, dp, bp, loglow, to - 1);
+		xfs_dir3_leaf_log_ents(args, bp, loglow, to - 1);
 }
 
 /*
@@ -1054,7 +1056,7 @@ xfs_dir3_leaf_compact_x1(
  */
 static void
 xfs_dir3_leaf_log_bests(
-	xfs_trans_t		*tp,		/* transaction pointer */
+	struct xfs_da_args	*args,
 	struct xfs_buf		*bp,		/* leaf buffer */
 	int			first,		/* first entry to log */
 	int			last)		/* last entry to log */
@@ -1067,10 +1069,11 @@ xfs_dir3_leaf_log_bests(
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC));
 
-	ltp = xfs_dir2_leaf_tail_p(tp->t_mountp->m_dir_geo, leaf);
+	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	firstb = xfs_dir2_leaf_bests_p(ltp) + first;
 	lastb = xfs_dir2_leaf_bests_p(ltp) + last;
-	xfs_trans_log_buf(tp, bp, (uint)((char *)firstb - (char *)leaf),
+	xfs_trans_log_buf(args->trans, bp,
+		(uint)((char *)firstb - (char *)leaf),
 		(uint)((char *)lastb - (char *)leaf + sizeof(*lastb) - 1));
 }
 
@@ -1079,8 +1082,7 @@ xfs_dir3_leaf_log_bests(
  */
 void
 xfs_dir3_leaf_log_ents(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp,
+	struct xfs_da_args	*args,
 	struct xfs_buf		*bp,
 	int			first,
 	int			last)
@@ -1095,10 +1097,11 @@ xfs_dir3_leaf_log_ents(
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
 
-	ents = dp->d_ops->leaf_ents_p(leaf);
+	ents = args->dp->d_ops->leaf_ents_p(leaf);
 	firstlep = &ents[first];
 	lastlep = &ents[last];
-	xfs_trans_log_buf(tp, bp, (uint)((char *)firstlep - (char *)leaf),
+	xfs_trans_log_buf(args->trans, bp,
+		(uint)((char *)firstlep - (char *)leaf),
 		(uint)((char *)lastlep - (char *)leaf + sizeof(*lastlep) - 1));
 }
 
@@ -1107,8 +1110,7 @@ xfs_dir3_leaf_log_ents(
  */
 void
 xfs_dir3_leaf_log_header(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp,
+	struct xfs_da_args	*args,
 	struct xfs_buf		*bp)
 {
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
@@ -1118,8 +1120,9 @@ xfs_dir3_leaf_log_header(
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
 
-	xfs_trans_log_buf(tp, bp, (uint)((char *)&leaf->hdr - (char *)leaf),
-			  dp->d_ops->leaf_hdr_size - 1);
+	xfs_trans_log_buf(args->trans, bp,
+			  (uint)((char *)&leaf->hdr - (char *)leaf),
+			  args->dp->d_ops->leaf_hdr_size - 1);
 }
 
 /*
@@ -1127,21 +1130,20 @@ xfs_dir3_leaf_log_header(
  */
 STATIC void
 xfs_dir3_leaf_log_tail(
-	struct xfs_trans	*tp,
+	struct xfs_da_args	*args,
 	struct xfs_buf		*bp)
 {
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
-	struct xfs_mount	*mp = tp->t_mountp;
 
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
 
-	ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
-	xfs_trans_log_buf(tp, bp, (uint)((char *)ltp - (char *)leaf),
-		(uint)(mp->m_dir_geo->blksize - 1));
+	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
+	xfs_trans_log_buf(args->trans, bp, (uint)((char *)ltp - (char *)leaf),
+		(uint)(args->geo->blksize - 1));
 }
 
 /*
@@ -1395,7 +1397,7 @@ xfs_dir2_leaf_removename(
 	/*
 	 * Mark the former data entry unused.
 	 */
-	xfs_dir2_data_make_free(tp, dp, dbp,
+	xfs_dir2_data_make_free(args, dbp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
 		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
 	/*
@@ -1403,10 +1405,10 @@ xfs_dir2_leaf_removename(
 	 */
 	leafhdr.stale++;
 	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
-	xfs_dir3_leaf_log_header(tp, dp, lbp);
+	xfs_dir3_leaf_log_header(args, lbp);
 
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
-	xfs_dir3_leaf_log_ents(tp, dp, lbp, index, index);
+	xfs_dir3_leaf_log_ents(args, lbp, index, index);
 
 	/*
 	 * Scan the freespace in the data block again if necessary,
@@ -1415,14 +1417,14 @@ xfs_dir2_leaf_removename(
 	if (needscan)
 		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dp, dbp);
+		xfs_dir2_data_log_header(args, dbp);
 	/*
 	 * If the longest freespace in the data block has changed,
 	 * put the new value in the bests table and log that.
 	 */
 	if (be16_to_cpu(bf[0].length) != oldbest) {
 		bestsp[db] = bf[0].length;
-		xfs_dir3_leaf_log_bests(tp, lbp, db, db);
+		xfs_dir3_leaf_log_bests(args, lbp, db, db);
 	}
 	xfs_dir3_data_check(dp, dbp);
 	/*
@@ -1463,8 +1465,9 @@ xfs_dir2_leaf_removename(
 			memmove(&bestsp[db - i], bestsp,
 				(be32_to_cpu(ltp->bestcount) - (db - i)) * sizeof(*bestsp));
 			be32_add_cpu(&ltp->bestcount, -(db - i));
-			xfs_dir3_leaf_log_tail(tp, lbp);
-			xfs_dir3_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
+			xfs_dir3_leaf_log_tail(args, lbp);
+			xfs_dir3_leaf_log_bests(args, lbp, 0,
+						be32_to_cpu(ltp->bestcount) - 1);
 		} else
 			bestsp[db] = cpu_to_be16(NULLDATAOFF);
 	}
@@ -1527,7 +1530,7 @@ xfs_dir2_leaf_replace(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tp = args->trans;
-	xfs_dir2_data_log_entry(tp, dp, dbp, dep);
+	xfs_dir2_data_log_entry(args, dbp, dep);
 	xfs_dir3_leaf_check(dp, lbp);
 	xfs_trans_brelse(tp, lbp);
 	return 0;
@@ -1648,8 +1651,8 @@ xfs_dir2_leaf_trim_data(
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	be32_add_cpu(&ltp->bestcount, -1);
 	memmove(&bestsp[1], &bestsp[0], be32_to_cpu(ltp->bestcount) * sizeof(*bestsp));
-	xfs_dir3_leaf_log_tail(tp, lbp);
-	xfs_dir3_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
+	xfs_dir3_leaf_log_tail(args, lbp);
+	xfs_dir3_leaf_log_bests(args, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
 	return 0;
 }
 
@@ -1795,9 +1798,9 @@ xfs_dir2_node_to_leaf(
 		freehdr.nvalid * sizeof(xfs_dir2_data_off_t));
 
 	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
-	xfs_dir3_leaf_log_header(tp, dp, lbp);
-	xfs_dir3_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
-	xfs_dir3_leaf_log_tail(tp, lbp);
+	xfs_dir3_leaf_log_header(args, lbp);
+	xfs_dir3_leaf_log_bests(args, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
+	xfs_dir3_leaf_log_tail(args, lbp);
 	xfs_dir3_leaf_check(dp, lbp);
 
 	/*
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index de5b2996..cd0bb58 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -241,8 +241,7 @@ xfs_dir3_free_get_buf(
  */
 STATIC void
 xfs_dir2_free_log_bests(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp,
+	struct xfs_da_args	*args,
 	struct xfs_buf		*bp,
 	int			first,		/* first entry to log */
 	int			last)		/* last entry to log */
@@ -251,10 +250,10 @@ xfs_dir2_free_log_bests(
 	__be16			*bests;
 
 	free = bp->b_addr;
-	bests = dp->d_ops->free_bests_p(free);
+	bests = args->dp->d_ops->free_bests_p(free);
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
-	xfs_trans_log_buf(tp, bp,
+	xfs_trans_log_buf(args->trans, bp,
 		(uint)((char *)&bests[first] - (char *)free),
 		(uint)((char *)&bests[last] - (char *)free +
 		       sizeof(bests[0]) - 1));
@@ -265,8 +264,7 @@ xfs_dir2_free_log_bests(
  */
 static void
 xfs_dir2_free_log_header(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp,
+	struct xfs_da_args	*args,
 	struct xfs_buf		*bp)
 {
 #ifdef DEBUG
@@ -276,7 +274,8 @@ xfs_dir2_free_log_header(
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 #endif
-	xfs_trans_log_buf(tp, bp, 0, dp->d_ops->free_hdr_size - 1);
+	xfs_trans_log_buf(args->trans, bp, 0,
+			  args->dp->d_ops->free_hdr_size - 1);
 }
 
 /*
@@ -350,8 +349,8 @@ xfs_dir2_leaf_to_node(
 	freehdr.nvalid = be32_to_cpu(ltp->bestcount);
 
 	dp->d_ops->free_hdr_to_disk(fbp->b_addr, &freehdr);
-	xfs_dir2_free_log_bests(tp, dp, fbp, 0, freehdr.nvalid - 1);
-	xfs_dir2_free_log_header(tp, dp, fbp);
+	xfs_dir2_free_log_bests(args, fbp, 0, freehdr.nvalid - 1);
+	xfs_dir2_free_log_header(args, fbp);
 
 	/*
 	 * Converting the leaf to a leafnode is just a matter of changing the
@@ -365,7 +364,7 @@ xfs_dir2_leaf_to_node(
 		leaf->hdr.info.magic = cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
 	lbp->b_ops = &xfs_dir3_leafn_buf_ops;
 	xfs_trans_buf_set_type(tp, lbp, XFS_BLFT_DIR_LEAFN_BUF);
-	xfs_dir3_leaf_log_header(tp, dp, lbp);
+	xfs_dir3_leaf_log_header(args, lbp);
 	xfs_dir3_leaf_check(dp, lbp);
 	return 0;
 }
@@ -455,8 +454,8 @@ xfs_dir2_leafn_add(
 				args->blkno, args->index));
 
 	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
-	xfs_dir3_leaf_log_header(tp, dp, bp);
-	xfs_dir3_leaf_log_ents(tp, dp, bp, lfloglow, lfloghigh);
+	xfs_dir3_leaf_log_header(args, bp);
+	xfs_dir3_leaf_log_ents(args, bp, lfloglow, lfloghigh);
 	xfs_dir3_leaf_check(dp, bp);
 	return 0;
 }
@@ -851,7 +850,6 @@ xfs_dir3_leafn_moveents(
 	int				start_d,/* destination leaf index */
 	int				count)	/* count of leaves to copy */
 {
-	struct xfs_trans		*tp = args->trans;
 	int				stale;	/* count stale leaves copied */
 
 	trace_xfs_dir2_leafn_moveents(args, start_s, start_d, count);
@@ -870,7 +868,7 @@ xfs_dir3_leafn_moveents(
 	if (start_d < dhdr->count) {
 		memmove(&dents[start_d + count], &dents[start_d],
 			(dhdr->count - start_d) * sizeof(xfs_dir2_leaf_entry_t));
-		xfs_dir3_leaf_log_ents(tp, args->dp, bp_d, start_d + count,
+		xfs_dir3_leaf_log_ents(args, bp_d, start_d + count,
 				       count + dhdr->count - 1);
 	}
 	/*
@@ -892,8 +890,7 @@ xfs_dir3_leafn_moveents(
 	 */
 	memcpy(&dents[start_d], &sents[start_s],
 		count * sizeof(xfs_dir2_leaf_entry_t));
-	xfs_dir3_leaf_log_ents(tp, args->dp, bp_d,
-			       start_d, start_d + count - 1);
+	xfs_dir3_leaf_log_ents(args, bp_d, start_d, start_d + count - 1);
 
 	/*
 	 * If there are source entries after the ones we copied,
@@ -902,8 +899,7 @@ xfs_dir3_leafn_moveents(
 	if (start_s + count < shdr->count) {
 		memmove(&sents[start_s], &sents[start_s + count],
 			count * sizeof(xfs_dir2_leaf_entry_t));
-		xfs_dir3_leaf_log_ents(tp, args->dp, bp_s,
-				       start_s, start_s + count - 1);
+		xfs_dir3_leaf_log_ents(args, bp_s, start_s, start_s + count - 1);
 	}
 
 	/*
@@ -1039,8 +1035,8 @@ xfs_dir2_leafn_rebalance(
 	/* log the changes made when moving the entries */
 	dp->d_ops->leaf_hdr_to_disk(leaf1, &hdr1);
 	dp->d_ops->leaf_hdr_to_disk(leaf2, &hdr2);
-	xfs_dir3_leaf_log_header(args->trans, dp, blk1->bp);
-	xfs_dir3_leaf_log_header(args->trans, dp, blk2->bp);
+	xfs_dir3_leaf_log_header(args, blk1->bp);
+	xfs_dir3_leaf_log_header(args, blk2->bp);
 
 	xfs_dir3_leaf_check(dp, blk1->bp);
 	xfs_dir3_leaf_check(dp, blk2->bp);
@@ -1083,7 +1079,6 @@ xfs_dir3_data_block_free(
 	struct xfs_buf		*fbp,
 	int			longest)
 {
-	struct xfs_trans	*tp = args->trans;
 	int			logfree = 0;
 	__be16			*bests;
 	struct xfs_dir3_icfree_hdr freehdr;
@@ -1097,7 +1092,7 @@ xfs_dir3_data_block_free(
 		 * value.
 		 */
 		bests[findex] = cpu_to_be16(longest);
-		xfs_dir2_free_log_bests(tp, dp, fbp, findex, findex);
+		xfs_dir2_free_log_bests(args, fbp, findex, findex);
 		return 0;
 	}
 
@@ -1125,7 +1120,7 @@ xfs_dir3_data_block_free(
 	}
 
 	dp->d_ops->free_hdr_to_disk(free, &freehdr);
-	xfs_dir2_free_log_header(tp, dp, fbp);
+	xfs_dir2_free_log_header(args, fbp);
 
 	/*
 	 * If there are no useful entries left in the block, get rid of the
@@ -1149,7 +1144,7 @@ xfs_dir3_data_block_free(
 
 	/* Log the free entry that changed, unless we got rid of it.  */
 	if (logfree)
-		xfs_dir2_free_log_bests(tp, dp, fbp, findex, findex);
+		xfs_dir2_free_log_bests(args, fbp, findex, findex);
 	return 0;
 }
 
@@ -1211,10 +1206,10 @@ xfs_dir2_leafn_remove(
 	 */
 	leafhdr.stale++;
 	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
-	xfs_dir3_leaf_log_header(tp, dp, bp);
+	xfs_dir3_leaf_log_header(args, bp);
 
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
-	xfs_dir3_leaf_log_ents(tp, dp, bp, index, index);
+	xfs_dir3_leaf_log_ents(args, bp, index, index);
 
 	/*
 	 * Make the data entry free.  Keep track of the longest freespace
@@ -1226,7 +1221,7 @@ xfs_dir2_leafn_remove(
 	bf = dp->d_ops->data_bestfree_p(hdr);
 	longest = be16_to_cpu(bf[0].length);
 	needlog = needscan = 0;
-	xfs_dir2_data_make_free(tp, dp, dbp, off,
+	xfs_dir2_data_make_free(args, dbp, off,
 		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
 	/*
 	 * Rescan the data block freespaces for bestfree.
@@ -1235,7 +1230,7 @@ xfs_dir2_leafn_remove(
 	if (needscan)
 		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dp, dbp);
+		xfs_dir2_data_log_header(args, dbp);
 	xfs_dir3_data_check(dp, dbp);
 	/*
 	 * If the longest data block freespace changes, need to update
@@ -1569,8 +1564,8 @@ xfs_dir2_leafn_unbalance(
 	/* log the changes made when moving the entries */
 	dp->d_ops->leaf_hdr_to_disk(save_leaf, &savehdr);
 	dp->d_ops->leaf_hdr_to_disk(drop_leaf, &drophdr);
-	xfs_dir3_leaf_log_header(args->trans, dp, save_blk->bp);
-	xfs_dir3_leaf_log_header(args->trans, dp, drop_blk->bp);
+	xfs_dir3_leaf_log_header(args, save_blk->bp);
+	xfs_dir3_leaf_log_header(args, drop_blk->bp);
 
 	xfs_dir3_leaf_check(dp, save_blk->bp);
 	xfs_dir3_leaf_check(dp, drop_blk->bp);
@@ -1931,7 +1926,7 @@ xfs_dir2_node_addname_int(
 		if (bests[findex] == cpu_to_be16(NULLDATAOFF)) {
 			freehdr.nused++;
 			dp->d_ops->free_hdr_to_disk(fbp->b_addr, &freehdr);
-			xfs_dir2_free_log_header(tp, dp, fbp);
+			xfs_dir2_free_log_header(args, fbp);
 		}
 		/*
 		 * Update the real value in the table.
@@ -1975,7 +1970,7 @@ xfs_dir2_node_addname_int(
 	/*
 	 * Mark the first part of the unused space, inuse for us.
 	 */
-	xfs_dir2_data_use_free(tp, dp, dbp, dup,
+	xfs_dir2_data_use_free(args, dbp, dup,
 		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr), length,
 		&needlog, &needscan);
 	/*
@@ -1988,7 +1983,7 @@ xfs_dir2_node_addname_int(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
-	xfs_dir2_data_log_entry(tp, dp, dbp, dep);
+	xfs_dir2_data_log_entry(args, dbp, dep);
 	/*
 	 * Rescan the block for bestfree if needed.
 	 */
@@ -1998,7 +1993,7 @@ xfs_dir2_node_addname_int(
 	 * Log the data block header if needed.
 	 */
 	if (needlog)
-		xfs_dir2_data_log_header(tp, dp, dbp);
+		xfs_dir2_data_log_header(args, dbp);
 	/*
 	 * If the freespace entry is now wrong, update it.
 	 */
@@ -2011,7 +2006,7 @@ xfs_dir2_node_addname_int(
 	 * Log the freespace entry if needed.
 	 */
 	if (logfree)
-		xfs_dir2_free_log_bests(tp, dp, fbp, findex, findex);
+		xfs_dir2_free_log_bests(args, fbp, findex, findex);
 	/*
 	 * Return the data block and offset in args, then drop the data block.
 	 */
@@ -2208,8 +2203,7 @@ xfs_dir2_node_replace(
 		 */
 		dep->inumber = cpu_to_be64(inum);
 		args->dp->d_ops->data_put_ftype(dep, args->filetype);
-		xfs_dir2_data_log_entry(args->trans, args->dp,
-					state->extrablk.bp, dep);
+		xfs_dir2_data_log_entry(args, state->extrablk.bp, dep);
 		rval = 0;
 	}
 	/*
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 2429960..07bfb4b 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -77,9 +77,9 @@ extern void xfs_dir3_leaf_compact_x1(struct xfs_dir3_icleaf_hdr *leafhdr,
 		int *lowstalep, int *highstalep, int *lowlogp, int *highlogp);
 extern int xfs_dir3_leaf_get_buf(struct xfs_da_args *args, xfs_dir2_db_t bno,
 		struct xfs_buf **bpp, __uint16_t magic);
-extern void xfs_dir3_leaf_log_ents(struct xfs_trans *tp, struct xfs_inode *dp,
+extern void xfs_dir3_leaf_log_ents(struct xfs_da_args *args,
 		struct xfs_buf *bp, int first, int last);
-extern void xfs_dir3_leaf_log_header(struct xfs_trans *tp, struct xfs_inode *dp,
+extern void xfs_dir3_leaf_log_header(struct xfs_da_args *args,
 		struct xfs_buf *bp);
 extern int xfs_dir2_leaf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_leaf_removename(struct xfs_da_args *args);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
