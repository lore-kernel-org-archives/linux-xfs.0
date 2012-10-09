Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q993o9x8212975 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 22:50:09 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hqaI0Xi7U5yeRLKV for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 20:51:37 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLQr0-0002Ps-LP
	for xfs@oss.sgi.com; Tue, 09 Oct 2012 14:51:34 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLQqq-0008Pc-IB
	for xfs@oss.sgi.com; Tue, 09 Oct 2012 14:51:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/19] xfs: factor dir2 block read operations
Date: Tue,  9 Oct 2012 14:51:03 +1100
Message-Id: <1349754670-32009-13-git-send-email-david@fromorbit.com>
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

In preparation for verifying dir2 block format buffers, factor
the read operations out of the block operations (lookup, addname,
getdents) and some of the additional logic to make it easier to
understand an dmodify the code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_block.c |  386 +++++++++++++++++++++++++----------------------
 1 file changed, 209 insertions(+), 177 deletions(-)

diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 53666ca..25ce409 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -56,6 +56,178 @@ xfs_dir_startup(void)
 	xfs_dir_hash_dotdot = xfs_da_hashname((unsigned char *)"..", 2);
 }
 
+static int
+xfs_dir2_block_read(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+
+	return xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, bpp,
+					XFS_DATA_FORK, NULL);
+}
+
+static void
+xfs_dir2_block_need_space(
+	struct xfs_dir2_data_hdr	*hdr,
+	struct xfs_dir2_block_tail	*btp,
+	struct xfs_dir2_leaf_entry	*blp,
+	__be16				**tagpp,
+	struct xfs_dir2_data_unused	**dupp,
+	struct xfs_dir2_data_unused	**enddupp,
+	int				*compact,
+	int				len)
+{
+	struct xfs_dir2_data_free	*bf;
+	__be16				*tagp = NULL;
+	struct xfs_dir2_data_unused	*dup = NULL;
+	struct xfs_dir2_data_unused	*enddup = NULL;
+
+	*compact = 0;
+	bf = hdr->bestfree;
+
+	/*
+	 * If there are stale entries we'll use one for the leaf.
+	 */
+	if (btp->stale) {
+		if (be16_to_cpu(bf[0].length) >= len) {
+			/*
+			 * The biggest entry enough to avoid compaction.
+			 */
+			dup = (xfs_dir2_data_unused_t *)
+			      ((char *)hdr + be16_to_cpu(bf[0].offset));
+			goto out;
+		}
+
+		/*
+		 * Will need to compact to make this work.
+		 * Tag just before the first leaf entry.
+		 */
+		*compact = 1;
+		tagp = (__be16 *)blp - 1;
+
+		/* Data object just before the first leaf entry.  */
+		dup = (xfs_dir2_data_unused_t *)((char *)hdr + be16_to_cpu(*tagp));
+
+		/*
+		 * If it's not free then the data will go where the
+		 * leaf data starts now, if it works at all.
+		 */
+		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			if (be16_to_cpu(dup->length) + (be32_to_cpu(btp->stale) - 1) *
+			    (uint)sizeof(*blp) < len)
+				dup = NULL;
+		} else if ((be32_to_cpu(btp->stale) - 1) * (uint)sizeof(*blp) < len)
+			dup = NULL;
+		else
+			dup = (xfs_dir2_data_unused_t *)blp;
+		goto out;
+	}
+
+	/*
+	 * no stale entries, so just use free space.
+	 * Tag just before the first leaf entry.
+	 */
+	tagp = (__be16 *)blp - 1;
+
+	/* Data object just before the first leaf entry.  */
+	enddup = (xfs_dir2_data_unused_t *)((char *)hdr + be16_to_cpu(*tagp));
+
+	/*
+	 * If it's not free then can't do this add without cleaning up:
+	 * the space before the first leaf entry needs to be free so it
+	 * can be expanded to hold the pointer to the new entry.
+	 */
+	if (be16_to_cpu(enddup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+		/*
+		 * Check out the biggest freespace and see if it's the same one.
+		 */
+		dup = (xfs_dir2_data_unused_t *)
+		      ((char *)hdr + be16_to_cpu(bf[0].offset));
+		if (dup != enddup) {
+			/*
+			 * Not the same free entry, just check its length.
+			 */
+			if (be16_to_cpu(dup->length) < len)
+				dup = NULL;
+			goto out;
+		}
+
+		/*
+		 * It is the biggest freespace, can it hold the leaf too?
+		 */
+		if (be16_to_cpu(dup->length) < len + (uint)sizeof(*blp)) {
+			/*
+			 * Yes, use the second-largest entry instead if it works.
+			 */
+			if (be16_to_cpu(bf[1].length) >= len)
+				dup = (xfs_dir2_data_unused_t *)
+				      ((char *)hdr + be16_to_cpu(bf[1].offset));
+			else
+				dup = NULL;
+		}
+	}
+out:
+	*tagpp = tagp;
+	*dupp = dup;
+	*enddupp = enddup;
+}
+
+/*
+ * compact the leaf entries.
+ * Leave the highest-numbered stale entry stale.
+ * XXX should be the one closest to mid but mid is not yet computed.
+ */
+static void
+xfs_dir2_block_compact(
+	struct xfs_trans		*tp,
+	struct xfs_buf			*bp,
+	struct xfs_dir2_data_hdr	*hdr,
+	struct xfs_dir2_block_tail	*btp,
+	struct xfs_dir2_leaf_entry	*blp,
+	int				*needlog,
+	int				*lfloghigh,
+	int				*lfloglow)
+{
+	int			fromidx;	/* source leaf index */
+	int			toidx;		/* target leaf index */
+	int			needscan = 0;
+	int			highstale;	/* high stale index */
+
+	fromidx = toidx = be32_to_cpu(btp->count) - 1;
+	highstale = *lfloghigh = -1;
+	for (; fromidx >= 0; fromidx--) {
+		if (blp[fromidx].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR)) {
+			if (highstale == -1)
+				highstale = toidx;
+			else {
+				if (*lfloghigh == -1)
+					*lfloghigh = toidx;
+				continue;
+			}
+		}
+		if (fromidx < toidx)
+			blp[toidx] = blp[fromidx];
+		toidx--;
+	}
+	*lfloglow = toidx + 1 - (be32_to_cpu(btp->stale) - 1);
+	*lfloghigh -= be32_to_cpu(btp->stale) - 1;
+	be32_add_cpu(&btp->count, -(be32_to_cpu(btp->stale) - 1));
+	xfs_dir2_data_make_free(tp, bp,
+		(xfs_dir2_data_aoff_t)((char *)blp - (char *)hdr),
+		(xfs_dir2_data_aoff_t)((be32_to_cpu(btp->stale) - 1) * sizeof(*blp)),
+		needlog, &needscan);
+	blp += be32_to_cpu(btp->stale) - 1;
+	btp->stale = cpu_to_be32(1);
+	/*
+	 * If we now need to rebuild the bestfree map, do so.
+	 * This needs to happen before the next call to use_free.
+	 */
+	if (needscan)
+		xfs_dir2_data_freescan(tp->t_mountp, hdr, needlog);
+}
+
 /*
  * Add an entry to a block directory.
  */
@@ -63,7 +235,6 @@ int						/* error */
 xfs_dir2_block_addname(
 	xfs_da_args_t		*args)		/* directory op arguments */
 {
-	xfs_dir2_data_free_t	*bf;		/* bestfree table in block */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
 	struct xfs_buf		*bp;		/* buffer for block */
@@ -94,134 +265,44 @@ xfs_dir2_block_addname(
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
-	/*
-	 * Read the (one and only) directory block into dabuf bp.
-	 */
-	error = xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, &bp,
-				XFS_DATA_FORK, NULL);
+
+	/* Read the (one and only) directory block into bp. */
+	error = xfs_dir2_block_read(tp, dp, &bp);
 	if (error)
 		return error;
-	ASSERT(bp != NULL);
-	hdr = bp->b_addr;
-	/*
-	 * Check the magic number, corrupted if wrong.
-	 */
-	if (unlikely(hdr->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))) {
-		XFS_CORRUPTION_ERROR("xfs_dir2_block_addname",
-				     XFS_ERRLEVEL_LOW, mp, hdr);
-		xfs_trans_brelse(tp, bp);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
+
 	len = xfs_dir2_data_entsize(args->namelen);
+
 	/*
 	 * Set up pointers to parts of the block.
 	 */
-	bf = hdr->bestfree;
+	hdr = bp->b_addr;
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
+
 	/*
-	 * No stale entries?  Need space for entry and new leaf.
-	 */
-	if (!btp->stale) {
-		/*
-		 * Tag just before the first leaf entry.
-		 */
-		tagp = (__be16 *)blp - 1;
-		/*
-		 * Data object just before the first leaf entry.
-		 */
-		enddup = (xfs_dir2_data_unused_t *)((char *)hdr + be16_to_cpu(*tagp));
-		/*
-		 * If it's not free then can't do this add without cleaning up:
-		 * the space before the first leaf entry needs to be free so it
-		 * can be expanded to hold the pointer to the new entry.
-		 */
-		if (be16_to_cpu(enddup->freetag) != XFS_DIR2_DATA_FREE_TAG)
-			dup = enddup = NULL;
-		/*
-		 * Check out the biggest freespace and see if it's the same one.
-		 */
-		else {
-			dup = (xfs_dir2_data_unused_t *)
-			      ((char *)hdr + be16_to_cpu(bf[0].offset));
-			if (dup == enddup) {
-				/*
-				 * It is the biggest freespace, is it too small
-				 * to hold the new leaf too?
-				 */
-				if (be16_to_cpu(dup->length) < len + (uint)sizeof(*blp)) {
-					/*
-					 * Yes, we use the second-largest
-					 * entry instead if it works.
-					 */
-					if (be16_to_cpu(bf[1].length) >= len)
-						dup = (xfs_dir2_data_unused_t *)
-						      ((char *)hdr +
-						       be16_to_cpu(bf[1].offset));
-					else
-						dup = NULL;
-				}
-			} else {
-				/*
-				 * Not the same free entry,
-				 * just check its length.
-				 */
-				if (be16_to_cpu(dup->length) < len) {
-					dup = NULL;
-				}
-			}
-		}
-		compact = 0;
-	}
-	/*
-	 * If there are stale entries we'll use one for the leaf.
-	 * Is the biggest entry enough to avoid compaction?
-	 */
-	else if (be16_to_cpu(bf[0].length) >= len) {
-		dup = (xfs_dir2_data_unused_t *)
-		      ((char *)hdr + be16_to_cpu(bf[0].offset));
-		compact = 0;
-	}
-	/*
-	 * Will need to compact to make this work.
+	 * Find out if we can reuse stale entries or whether we need extra
+	 * space for entry and new leaf.
 	 */
-	else {
-		/*
-		 * Tag just before the first leaf entry.
-		 */
-		tagp = (__be16 *)blp - 1;
-		/*
-		 * Data object just before the first leaf entry.
-		 */
-		dup = (xfs_dir2_data_unused_t *)((char *)hdr + be16_to_cpu(*tagp));
-		/*
-		 * If it's not free then the data will go where the
-		 * leaf data starts now, if it works at all.
-		 */
-		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			if (be16_to_cpu(dup->length) + (be32_to_cpu(btp->stale) - 1) *
-			    (uint)sizeof(*blp) < len)
-				dup = NULL;
-		} else if ((be32_to_cpu(btp->stale) - 1) * (uint)sizeof(*blp) < len)
-			dup = NULL;
-		else
-			dup = (xfs_dir2_data_unused_t *)blp;
-		compact = 1;
-	}
+	xfs_dir2_block_need_space(hdr, btp, blp, &tagp, &dup,
+				  &enddup, &compact, len);
+
 	/*
-	 * If this isn't a real add, we're done with the buffer.
+	 * Done everything we need for a space check now.
 	 */
-	if (args->op_flags & XFS_DA_OP_JUSTCHECK)
+	if (args->op_flags & XFS_DA_OP_JUSTCHECK) {
 		xfs_trans_brelse(tp, bp);
+		if (!dup)
+			return XFS_ERROR(ENOSPC);
+		return 0;
+	}
+
 	/*
 	 * If we don't have space for the new entry & leaf ...
 	 */
 	if (!dup) {
-		/*
-		 * Not trying to actually do anything, or don't have
-		 * a space reservation: return no-space.
-		 */
-		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
+		/* Don't have a space reservation: return no-space.  */
+		if (args->total == 0)
 			return XFS_ERROR(ENOSPC);
 		/*
 		 * Convert to the next larger format.
@@ -232,65 +313,24 @@ xfs_dir2_block_addname(
 			return error;
 		return xfs_dir2_leaf_addname(args);
 	}
-	/*
-	 * Just checking, and it would work, so say so.
-	 */
-	if (args->op_flags & XFS_DA_OP_JUSTCHECK)
-		return 0;
+
 	needlog = needscan = 0;
+
 	/*
 	 * If need to compact the leaf entries, do it now.
-	 * Leave the highest-numbered stale entry stale.
-	 * XXX should be the one closest to mid but mid is not yet computed.
-	 */
-	if (compact) {
-		int	fromidx;		/* source leaf index */
-		int	toidx;			/* target leaf index */
-
-		for (fromidx = toidx = be32_to_cpu(btp->count) - 1,
-			highstale = lfloghigh = -1;
-		     fromidx >= 0;
-		     fromidx--) {
-			if (blp[fromidx].address ==
-			    cpu_to_be32(XFS_DIR2_NULL_DATAPTR)) {
-				if (highstale == -1)
-					highstale = toidx;
-				else {
-					if (lfloghigh == -1)
-						lfloghigh = toidx;
-					continue;
-				}
-			}
-			if (fromidx < toidx)
-				blp[toidx] = blp[fromidx];
-			toidx--;
-		}
-		lfloglow = toidx + 1 - (be32_to_cpu(btp->stale) - 1);
-		lfloghigh -= be32_to_cpu(btp->stale) - 1;
-		be32_add_cpu(&btp->count, -(be32_to_cpu(btp->stale) - 1));
-		xfs_dir2_data_make_free(tp, bp,
-			(xfs_dir2_data_aoff_t)((char *)blp - (char *)hdr),
-			(xfs_dir2_data_aoff_t)((be32_to_cpu(btp->stale) - 1) * sizeof(*blp)),
-			&needlog, &needscan);
-		blp += be32_to_cpu(btp->stale) - 1;
-		btp->stale = cpu_to_be32(1);
-		/*
-		 * If we now need to rebuild the bestfree map, do so.
-		 * This needs to happen before the next call to use_free.
-		 */
-		if (needscan) {
-			xfs_dir2_data_freescan(mp, hdr, &needlog);
-			needscan = 0;
-		}
-	}
-	/*
-	 * Set leaf logging boundaries to impossible state.
-	 * For the no-stale case they're set explicitly.
 	 */
+	if (compact)
+		xfs_dir2_block_compact(tp, bp, hdr, btp, blp, &needlog,
+				      &lfloghigh, &lfloglow);
 	else if (btp->stale) {
+		/*
+		 * Set leaf logging boundaries to impossible state.
+		 * For the no-stale case they're set explicitly.
+		 */
 		lfloglow = be32_to_cpu(btp->count);
 		lfloghigh = -1;
 	}
+
 	/*
 	 * Find the slot that's first lower than our hash value, -1 if none.
 	 */
@@ -450,18 +490,13 @@ xfs_dir2_block_getdents(
 	/*
 	 * If the block number in the offset is out of range, we're done.
 	 */
-	if (xfs_dir2_dataptr_to_db(mp, *offset) > mp->m_dirdatablk) {
+	if (xfs_dir2_dataptr_to_db(mp, *offset) > mp->m_dirdatablk)
 		return 0;
-	}
-	/*
-	 * Can't read the block, give up, else get dabuf in bp.
-	 */
-	error = xfs_da_read_buf(NULL, dp, mp->m_dirdatablk, -1,
-				&bp, XFS_DATA_FORK, NULL);
+
+	error = xfs_dir2_block_read(NULL, dp, &bp);
 	if (error)
 		return error;
 
-	ASSERT(bp != NULL);
 	/*
 	 * Extract the byte offset we start at from the seek pointer.
 	 * We'll skip entries before this.
@@ -637,14 +672,11 @@ xfs_dir2_block_lookup_int(
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
-	/*
-	 * Read the buffer, return error if we can't get it.
-	 */
-	error = xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, &bp,
-				XFS_DATA_FORK, NULL);
+
+	error = xfs_dir2_block_read(tp, dp, &bp);
 	if (error)
 		return error;
-	ASSERT(bp != NULL);
+
 	hdr = bp->b_addr;
 	xfs_dir2_data_check(dp, bp);
 	btp = xfs_dir2_block_tail_p(mp, hdr);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
