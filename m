Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k8lK056125 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 754C81EE3236
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	h4qYdTLkaT1FboFB for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:06 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIX-0001xm-LL
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:05 +0000
Message-Id: <20110701094605.621819832@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 16/27] xfs: avoid usage of struct xfs_dir2_block
References: <20110701094321.936534538@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-avoid-xfs_dir2_block_t
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

In most places we can simply pass around and use the struct xfs_dir2_data_hdr,
which is the first and most important member of struct xfs_dir2_block instead
of the full structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2011-06-30 09:35:55.810069526 +0200
+++ xfs/fs/xfs/xfs_dir2_block.c	2011-06-30 09:38:36.586734196 +0200
@@ -67,7 +67,7 @@ xfs_dir2_block_addname(
 	xfs_da_args_t		*args)		/* directory op arguments */
 {
 	xfs_dir2_data_free_t	*bf;		/* bestfree table in block */
-	xfs_dir2_block_t	*block;		/* directory block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
 	xfs_dabuf_t		*bp;		/* buffer for block */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
@@ -105,13 +105,13 @@ xfs_dir2_block_addname(
 		return error;
 	}
 	ASSERT(bp != NULL);
-	block = bp->data;
+	hdr = bp->data;
 	/*
 	 * Check the magic number, corrupted if wrong.
 	 */
-	if (unlikely(be32_to_cpu(block->hdr.magic) != XFS_DIR2_BLOCK_MAGIC)) {
+	if (unlikely(hdr->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))) {
 		XFS_CORRUPTION_ERROR("xfs_dir2_block_addname",
-				     XFS_ERRLEVEL_LOW, mp, block);
+				     XFS_ERRLEVEL_LOW, mp, hdr);
 		xfs_da_brelse(tp, bp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
@@ -119,8 +119,8 @@ xfs_dir2_block_addname(
 	/*
 	 * Set up pointers to parts of the block.
 	 */
-	bf = block->hdr.bestfree;
-	btp = xfs_dir2_block_tail_p(mp, block);
+	bf = hdr->bestfree;
+	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * No stale entries?  Need space for entry and new leaf.
@@ -133,7 +133,7 @@ xfs_dir2_block_addname(
 		/*
 		 * Data object just before the first leaf entry.
 		 */
-		enddup = (xfs_dir2_data_unused_t *)((char *)block + be16_to_cpu(*tagp));
+		enddup = (xfs_dir2_data_unused_t *)((char *)hdr + be16_to_cpu(*tagp));
 		/*
 		 * If it's not free then can't do this add without cleaning up:
 		 * the space before the first leaf entry needs to be free so it
@@ -146,7 +146,7 @@ xfs_dir2_block_addname(
 		 */
 		else {
 			dup = (xfs_dir2_data_unused_t *)
-			      ((char *)block + be16_to_cpu(bf[0].offset));
+			      ((char *)hdr + be16_to_cpu(bf[0].offset));
 			if (dup == enddup) {
 				/*
 				 * It is the biggest freespace, is it too small
@@ -159,7 +159,7 @@ xfs_dir2_block_addname(
 					 */
 					if (be16_to_cpu(bf[1].length) >= len)
 						dup = (xfs_dir2_data_unused_t *)
-						      ((char *)block +
+						      ((char *)hdr +
 						       be16_to_cpu(bf[1].offset));
 					else
 						dup = NULL;
@@ -182,7 +182,7 @@ xfs_dir2_block_addname(
 	 */
 	else if (be16_to_cpu(bf[0].length) >= len) {
 		dup = (xfs_dir2_data_unused_t *)
-		      ((char *)block + be16_to_cpu(bf[0].offset));
+		      ((char *)hdr + be16_to_cpu(bf[0].offset));
 		compact = 0;
 	}
 	/*
@@ -196,7 +196,7 @@ xfs_dir2_block_addname(
 		/*
 		 * Data object just before the first leaf entry.
 		 */
-		dup = (xfs_dir2_data_unused_t *)((char *)block + be16_to_cpu(*tagp));
+		dup = (xfs_dir2_data_unused_t *)((char *)hdr + be16_to_cpu(*tagp));
 		/*
 		 * If it's not free then the data will go where the
 		 * leaf data starts now, if it works at all.
@@ -272,7 +272,7 @@ xfs_dir2_block_addname(
 		lfloghigh -= be32_to_cpu(btp->stale) - 1;
 		be32_add_cpu(&btp->count, -(be32_to_cpu(btp->stale) - 1));
 		xfs_dir2_data_make_free(tp, bp,
-			(xfs_dir2_data_aoff_t)((char *)blp - (char *)block),
+			(xfs_dir2_data_aoff_t)((char *)blp - (char *)hdr),
 			(xfs_dir2_data_aoff_t)((be32_to_cpu(btp->stale) - 1) * sizeof(*blp)),
 			&needlog, &needscan);
 		blp += be32_to_cpu(btp->stale) - 1;
@@ -282,7 +282,7 @@ xfs_dir2_block_addname(
 		 * This needs to happen before the next call to use_free.
 		 */
 		if (needscan) {
-			xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog);
+			xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)hdr, &needlog);
 			needscan = 0;
 		}
 	}
@@ -318,7 +318,7 @@ xfs_dir2_block_addname(
 		 */
 		xfs_dir2_data_use_free(tp, bp, enddup,
 			(xfs_dir2_data_aoff_t)
-			((char *)enddup - (char *)block + be16_to_cpu(enddup->length) -
+			((char *)enddup - (char *)hdr + be16_to_cpu(enddup->length) -
 			 sizeof(*blp)),
 			(xfs_dir2_data_aoff_t)sizeof(*blp),
 			&needlog, &needscan);
@@ -331,7 +331,7 @@ xfs_dir2_block_addname(
 		 * This needs to happen before the next call to use_free.
 		 */
 		if (needscan) {
-			xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block,
+			xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)hdr,
 				&needlog);
 			needscan = 0;
 		}
@@ -397,13 +397,13 @@ xfs_dir2_block_addname(
 	 */
 	blp[mid].hashval = cpu_to_be32(args->hashval);
 	blp[mid].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
-				(char *)dep - (char *)block));
+				(char *)dep - (char *)hdr));
 	xfs_dir2_block_log_leaf(tp, bp, lfloglow, lfloghigh);
 	/*
 	 * Mark space for the data entry used.
 	 */
 	xfs_dir2_data_use_free(tp, bp, dup,
-		(xfs_dir2_data_aoff_t)((char *)dup - (char *)block),
+		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr),
 		(xfs_dir2_data_aoff_t)len, &needlog, &needscan);
 	/*
 	 * Create the new data entry.
@@ -412,12 +412,12 @@ xfs_dir2_block_addname(
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, args->namelen);
 	tagp = xfs_dir2_data_entry_tag_p(dep);
-	*tagp = cpu_to_be16((char *)dep - (char *)block);
+	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog);
+		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, bp);
 	xfs_dir2_block_log_tail(tp, bp);
@@ -438,6 +438,7 @@ xfs_dir2_block_getdents(
 	filldir_t		filldir)
 {
 	xfs_dir2_block_t	*block;		/* directory block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dabuf_t		*bp;		/* buffer for block */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* block data entry */
@@ -471,11 +472,12 @@ xfs_dir2_block_getdents(
 	 */
 	wantoff = xfs_dir2_dataptr_to_off(mp, *offset);
 	block = bp->data;
+	hdr = &block->hdr;
 	xfs_dir2_data_check(dp, bp);
 	/*
 	 * Set up values for the loop.
 	 */
-	btp = xfs_dir2_block_tail_p(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, hdr);
 	ptr = (char *)block->u;
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 
@@ -502,11 +504,11 @@ xfs_dir2_block_getdents(
 		/*
 		 * The entry is before the desired starting point, skip it.
 		 */
-		if ((char *)dep - (char *)block < wantoff)
+		if ((char *)dep - (char *)hdr < wantoff)
 			continue;
 
 		cook = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-					    (char *)dep - (char *)block);
+					    (char *)dep - (char *)hdr);
 
 		/*
 		 * If it didn't fit, set the final offset to here & return.
@@ -540,17 +542,14 @@ xfs_dir2_block_log_leaf(
 	int			first,		/* index of first logged leaf */
 	int			last)		/* index of last logged leaf */
 {
-	xfs_dir2_block_t	*block;		/* directory block structure */
-	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
-	xfs_dir2_block_tail_t	*btp;		/* block tail */
-	xfs_mount_t		*mp;		/* filesystem mount point */
+	xfs_dir2_data_hdr_t	*hdr = bp->data;
+	xfs_dir2_leaf_entry_t	*blp;
+	xfs_dir2_block_tail_t	*btp;
 
-	mp = tp->t_mountp;
-	block = bp->data;
-	btp = xfs_dir2_block_tail_p(mp, block);
+	btp = xfs_dir2_block_tail_p(tp->t_mountp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
-	xfs_da_log_buf(tp, bp, (uint)((char *)&blp[first] - (char *)block),
-		(uint)((char *)&blp[last + 1] - (char *)block - 1));
+	xfs_da_log_buf(tp, bp, (uint)((char *)&blp[first] - (char *)hdr),
+		(uint)((char *)&blp[last + 1] - (char *)hdr - 1));
 }
 
 /*
@@ -561,15 +560,12 @@ xfs_dir2_block_log_tail(
 	xfs_trans_t		*tp,		/* transaction structure */
 	xfs_dabuf_t		*bp)		/* block buffer */
 {
-	xfs_dir2_block_t	*block;		/* directory block structure */
-	xfs_dir2_block_tail_t	*btp;		/* block tail */
-	xfs_mount_t		*mp;		/* filesystem mount point */
+	xfs_dir2_data_hdr_t	*hdr = bp->data;
+	xfs_dir2_block_tail_t	*btp;
 
-	mp = tp->t_mountp;
-	block = bp->data;
-	btp = xfs_dir2_block_tail_p(mp, block);
-	xfs_da_log_buf(tp, bp, (uint)((char *)btp - (char *)block),
-		(uint)((char *)(btp + 1) - (char *)block - 1));
+	btp = xfs_dir2_block_tail_p(tp->t_mountp, hdr);
+	xfs_da_log_buf(tp, bp, (uint)((char *)btp - (char *)hdr),
+		(uint)((char *)(btp + 1) - (char *)hdr - 1));
 }
 
 /*
@@ -580,7 +576,7 @@ int						/* error */
 xfs_dir2_block_lookup(
 	xfs_da_args_t		*args)		/* dir lookup arguments */
 {
-	xfs_dir2_block_t	*block;		/* block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
 	xfs_dabuf_t		*bp;		/* block buffer */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
@@ -600,14 +596,14 @@ xfs_dir2_block_lookup(
 		return error;
 	dp = args->dp;
 	mp = dp->i_mount;
-	block = bp->data;
+	hdr = bp->data;
 	xfs_dir2_data_check(dp, bp);
-	btp = xfs_dir2_block_tail_p(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Get the offset from the leaf entry, to point to the data.
 	 */
-	dep = (xfs_dir2_data_entry_t *)((char *)block +
+	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
 		xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
 	/*
 	 * Fill in inode number, CI name if appropriate, release the block.
@@ -628,7 +624,7 @@ xfs_dir2_block_lookup_int(
 	int			*entno)		/* returned entry number */
 {
 	xfs_dir2_dataptr_t	addr;		/* data entry address */
-	xfs_dir2_block_t	*block;		/* block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
 	xfs_dabuf_t		*bp;		/* block buffer */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
@@ -654,9 +650,9 @@ xfs_dir2_block_lookup_int(
 		return error;
 	}
 	ASSERT(bp != NULL);
-	block = bp->data;
+	hdr = bp->data;
 	xfs_dir2_data_check(dp, bp);
-	btp = xfs_dir2_block_tail_p(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Loop doing a binary search for our hash value.
@@ -694,7 +690,7 @@ xfs_dir2_block_lookup_int(
 		 * Get pointer to the entry from the leaf.
 		 */
 		dep = (xfs_dir2_data_entry_t *)
-			((char *)block + xfs_dir2_dataptr_to_off(mp, addr));
+			((char *)hdr + xfs_dir2_dataptr_to_off(mp, addr));
 		/*
 		 * Compare name and if it's an exact match, return the index
 		 * and buffer. If it's the first case-insensitive match, store
@@ -733,7 +729,7 @@ int						/* error */
 xfs_dir2_block_removename(
 	xfs_da_args_t		*args)		/* directory operation args */
 {
-	xfs_dir2_block_t	*block;		/* block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf pointer */
 	xfs_dabuf_t		*bp;		/* block buffer */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
@@ -760,20 +756,20 @@ xfs_dir2_block_removename(
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
-	block = bp->data;
-	btp = xfs_dir2_block_tail_p(mp, block);
+	hdr = bp->data;
+	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
 	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)block + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
+	      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
 	/*
 	 * Mark the data entry's space free.
 	 */
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(tp, bp,
-		(xfs_dir2_data_aoff_t)((char *)dep - (char *)block),
+		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
 		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
 	/*
 	 * Fix up the block tail.
@@ -789,15 +785,15 @@ xfs_dir2_block_removename(
 	 * Fix up bestfree, log the header if necessary.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog);
+		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, bp);
 	xfs_dir2_data_check(dp, bp);
 	/*
 	 * See if the size as a shortform is good enough.
 	 */
-	if ((size = xfs_dir2_block_sfsize(dp, block, &sfh)) >
-	    XFS_IFORK_DSIZE(dp)) {
+	size = xfs_dir2_block_sfsize(dp, hdr, &sfh);
+	if (size > XFS_IFORK_DSIZE(dp)) {
 		xfs_da_buf_done(bp);
 		return 0;
 	}
@@ -815,7 +811,7 @@ int						/* error */
 xfs_dir2_block_replace(
 	xfs_da_args_t		*args)		/* directory operation args */
 {
-	xfs_dir2_block_t	*block;		/* block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
 	xfs_dabuf_t		*bp;		/* block buffer */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
@@ -836,14 +832,14 @@ xfs_dir2_block_replace(
 	}
 	dp = args->dp;
 	mp = dp->i_mount;
-	block = bp->data;
-	btp = xfs_dir2_block_tail_p(mp, block);
+	hdr = bp->data;
+	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Point to the data entry we need to change.
 	 */
 	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)block + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
+	      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
@@ -882,7 +878,7 @@ xfs_dir2_leaf_to_block(
 	xfs_dabuf_t		*dbp)		/* data buffer */
 {
 	__be16			*bestsp;	/* leaf bests table */
-	xfs_dir2_block_t	*block;		/* block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	xfs_dir2_data_unused_t	*dup;		/* unused data entry */
@@ -917,7 +913,7 @@ xfs_dir2_leaf_to_block(
 	while (dp->i_d.di_size > mp->m_dirblksize) {
 		bestsp = xfs_dir2_leaf_bests_p(ltp);
 		if (be16_to_cpu(bestsp[be32_to_cpu(ltp->bestcount) - 1]) ==
-		    mp->m_dirblksize - (uint)sizeof(block->hdr)) {
+		    mp->m_dirblksize - (uint)sizeof(*hdr)) {
 			if ((error =
 			    xfs_dir2_leaf_trim_data(args, lbp,
 				    (xfs_dir2_db_t)(be32_to_cpu(ltp->bestcount) - 1))))
@@ -935,18 +931,18 @@ xfs_dir2_leaf_to_block(
 		    XFS_DATA_FORK))) {
 		goto out;
 	}
-	block = dbp->data;
-	ASSERT(be32_to_cpu(block->hdr.magic) == XFS_DIR2_DATA_MAGIC);
+	hdr = dbp->data;
+	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC);
 	/*
 	 * Size of the "leaf" area in the block.
 	 */
-	size = (uint)sizeof(block->tail) +
+	size = (uint)sizeof(xfs_dir2_block_tail_t) +
 	       (uint)sizeof(*lep) * (be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale));
 	/*
 	 * Look at the last data entry.
 	 */
-	tagp = (__be16 *)((char *)block + mp->m_dirblksize) - 1;
-	dup = (xfs_dir2_data_unused_t *)((char *)block + be16_to_cpu(*tagp));
+	tagp = (__be16 *)((char *)hdr + mp->m_dirblksize) - 1;
+	dup = (xfs_dir2_data_unused_t *)((char *)hdr + be16_to_cpu(*tagp));
 	/*
 	 * If it's not free or is too short we can't do it.
 	 */
@@ -958,7 +954,7 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Start converting it to block form.
 	 */
-	block->hdr.magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
+	hdr->magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
 	needlog = 1;
 	needscan = 0;
 	/*
@@ -969,7 +965,7 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Initialize the block tail.
 	 */
-	btp = xfs_dir2_block_tail_p(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, hdr);
 	btp->count = cpu_to_be32(be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale));
 	btp->stale = 0;
 	xfs_dir2_block_log_tail(tp, dbp);
@@ -988,7 +984,7 @@ xfs_dir2_leaf_to_block(
 	 * Scan the bestfree if we need it and log the data block header.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog);
+		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
 	/*
@@ -1002,8 +998,8 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Now see if the resulting block can be shrunken to shortform.
 	 */
-	if ((size = xfs_dir2_block_sfsize(dp, block, &sfh)) >
-	    XFS_IFORK_DSIZE(dp)) {
+	size = xfs_dir2_block_sfsize(dp, hdr, &sfh);
+	if (size > XFS_IFORK_DSIZE(dp)) {
 		error = 0;
 		goto out;
 	}
@@ -1025,6 +1021,7 @@ xfs_dir2_sf_to_block(
 {
 	xfs_dir2_db_t		blkno;		/* dir-relative block # (0) */
 	xfs_dir2_block_t	*block;		/* block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
 	xfs_dabuf_t		*bp;		/* block buffer */
 	xfs_dir2_block_tail_t	*btp;		/* block tail pointer */
@@ -1095,7 +1092,8 @@ xfs_dir2_sf_to_block(
 		return error;
 	}
 	block = bp->data;
-	block->hdr.magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
+	hdr = &block->hdr;
+	hdr->magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
 	/*
 	 * Compute size of block "tail" area.
 	 */
@@ -1113,45 +1111,45 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Fill in the tail.
 	 */
-	btp = xfs_dir2_block_tail_p(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, hdr);
 	btp->count = cpu_to_be32(sfp->count + 2);	/* ., .. */
 	btp->stale = 0;
 	blp = xfs_dir2_block_leaf_p(btp);
-	endoffset = (uint)((char *)blp - (char *)block);
+	endoffset = (uint)((char *)blp - (char *)hdr);
 	/*
 	 * Remove the freespace, we'll manage it.
 	 */
 	xfs_dir2_data_use_free(tp, bp, dup,
-		(xfs_dir2_data_aoff_t)((char *)dup - (char *)block),
+		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr),
 		be16_to_cpu(dup->length), &needlog, &needscan);
 	/*
 	 * Create entry for .
 	 */
 	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)block + XFS_DIR2_DATA_DOT_OFFSET);
+	      ((char *)hdr + XFS_DIR2_DATA_DOT_OFFSET);
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
 	tagp = xfs_dir2_data_entry_tag_p(dep);
-	*tagp = cpu_to_be16((char *)dep - (char *)block);
+	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, bp, dep);
 	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
 	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
-				(char *)dep - (char *)block));
+				(char *)dep - (char *)hdr));
 	/*
 	 * Create entry for ..
 	 */
 	dep = (xfs_dir2_data_entry_t *)
-		((char *)block + XFS_DIR2_DATA_DOTDOT_OFFSET);
+		((char *)hdr + XFS_DIR2_DATA_DOTDOT_OFFSET);
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
 	tagp = xfs_dir2_data_entry_tag_p(dep);
-	*tagp = cpu_to_be16((char *)dep - (char *)block);
+	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, bp, dep);
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
 	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
-				(char *)dep - (char *)block));
+				(char *)dep - (char *)hdr));
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
 	/*
 	 * Loop over existing entries, stuff them in.
@@ -1177,14 +1175,13 @@ xfs_dir2_sf_to_block(
 		 * There should be a hole here, make one.
 		 */
 		if (offset < newoffset) {
-			dup = (xfs_dir2_data_unused_t *)
-			      ((char *)block + offset);
+			dup = (xfs_dir2_data_unused_t *)((char *)hdr + offset);
 			dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 			dup->length = cpu_to_be16(newoffset - offset);
 			*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16(
-				((char *)dup - (char *)block));
+				((char *)dup - (char *)hdr));
 			xfs_dir2_data_log_unused(tp, bp, dup);
-			(void)xfs_dir2_data_freeinsert((xfs_dir2_data_t *)block,
+			(void)xfs_dir2_data_freeinsert((xfs_dir2_data_t *)hdr,
 				dup, &dummy);
 			offset += be16_to_cpu(dup->length);
 			continue;
@@ -1192,20 +1189,20 @@ xfs_dir2_sf_to_block(
 		/*
 		 * Copy a real entry.
 		 */
-		dep = (xfs_dir2_data_entry_t *)((char *)block + newoffset);
+		dep = (xfs_dir2_data_entry_t *)((char *)hdr + newoffset);
 		dep->inumber = cpu_to_be64(xfs_dir2_sfe_get_ino(sfp, sfep));
 		dep->namelen = sfep->namelen;
 		memcpy(dep->name, sfep->name, dep->namelen);
 		tagp = xfs_dir2_data_entry_tag_p(dep);
-		*tagp = cpu_to_be16((char *)dep - (char *)block);
+		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 		xfs_dir2_data_log_entry(tp, bp, dep);
 		name.name = sfep->name;
 		name.len = sfep->namelen;
 		blp[2 + i].hashval = cpu_to_be32(mp->m_dirnameops->
 							hashname(&name));
 		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
-						 (char *)dep - (char *)block));
-		offset = (int)((char *)(tagp + 1) - (char *)block);
+						 (char *)dep - (char *)hdr));
+		offset = (int)((char *)(tagp + 1) - (char *)hdr);
 		if (++i == sfp->count)
 			sfep = NULL;
 		else
Index: xfs/fs/xfs/xfs_dir2_data.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_data.c	2011-06-29 19:45:24.326965102 +0200
+++ xfs/fs/xfs/xfs_dir2_data.c	2011-06-30 09:38:36.586734196 +0200
@@ -72,7 +72,7 @@ xfs_dir2_data_check(
 	bf = d->hdr.bestfree;
 	p = (char *)d->u;
 	if (be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
-		btp = xfs_dir2_block_tail_p(mp, (xfs_dir2_block_t *)d);
+		btp = xfs_dir2_block_tail_p(mp, &d->hdr);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endp = (char *)lep;
 	} else
@@ -348,7 +348,7 @@ xfs_dir2_data_freescan(
 	 */
 	p = (char *)d->u;
 	if (be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
-		btp = xfs_dir2_block_tail_p(mp, (xfs_dir2_block_t *)d);
+		btp = xfs_dir2_block_tail_p(mp, &d->hdr);
 		endp = (char *)xfs_dir2_block_leaf_p(btp);
 	} else
 		endp = (char *)d + mp->m_dirblksize;
@@ -537,7 +537,7 @@ xfs_dir2_data_make_free(
 		xfs_dir2_block_tail_t	*btp;	/* block tail */
 
 		ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
-		btp = xfs_dir2_block_tail_p(mp, (xfs_dir2_block_t *)d);
+		btp = xfs_dir2_block_tail_p(mp, &d->hdr);
 		endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	}
 	/*
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-06-30 09:29:24.446740960 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-06-30 09:38:36.590067529 +0200
@@ -64,7 +64,7 @@ xfs_dir2_block_to_leaf(
 {
 	__be16			*bestsp;	/* leaf's bestsp entries */
 	xfs_dablk_t		blkno;		/* leaf block's bno */
-	xfs_dir2_block_t	*block;		/* block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block's leaf entries */
 	xfs_dir2_block_tail_t	*btp;		/* block's tail */
 	xfs_inode_t		*dp;		/* incore directory inode */
@@ -101,9 +101,9 @@ xfs_dir2_block_to_leaf(
 	}
 	ASSERT(lbp != NULL);
 	leaf = lbp->data;
-	block = dbp->data;
+	hdr = dbp->data;
 	xfs_dir2_data_check(dp, dbp);
-	btp = xfs_dir2_block_tail_p(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Set the counts in the leaf header.
@@ -123,23 +123,23 @@ xfs_dir2_block_to_leaf(
 	 * tail be free.
 	 */
 	xfs_dir2_data_make_free(tp, dbp,
-		(xfs_dir2_data_aoff_t)((char *)blp - (char *)block),
-		(xfs_dir2_data_aoff_t)((char *)block + mp->m_dirblksize -
+		(xfs_dir2_data_aoff_t)((char *)blp - (char *)hdr),
+		(xfs_dir2_data_aoff_t)((char *)hdr + mp->m_dirblksize -
 				       (char *)blp),
 		&needlog, &needscan);
 	/*
 	 * Fix up the block header, make it a data block.
 	 */
-	block->hdr.magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
+	hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 	if (needscan)
-		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)block, &needlog);
+		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)hdr, &needlog);
 	/*
 	 * Set up leaf tail and bests table.
 	 */
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	ltp->bestcount = cpu_to_be32(1);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	bestsp[0] =  block->hdr.bestfree[0].length;
+	bestsp[0] =  hdr->bestfree[0].length;
 	/*
 	 * Log the data header and leaf bests table.
 	 */
Index: xfs/fs/xfs/xfs_dir2_sf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2011-06-30 09:38:34.303400889 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.c	2011-06-30 09:38:36.590067529 +0200
@@ -141,7 +141,7 @@ xfs_dir2_sfe_put_ino(
 int						/* size for sf form */
 xfs_dir2_block_sfsize(
 	xfs_inode_t		*dp,		/* incore inode pointer */
-	xfs_dir2_block_t	*block,		/* block directory data */
+	xfs_dir2_data_hdr_t	*hdr,		/* block directory data */
 	xfs_dir2_sf_hdr_t	*sfhp)		/* output: header for sf form */
 {
 	xfs_dir2_dataptr_t	addr;		/* data entry address */
@@ -161,7 +161,7 @@ xfs_dir2_block_sfsize(
 	mp = dp->i_mount;
 
 	count = i8count = namelen = 0;
-	btp = xfs_dir2_block_tail_p(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 
 	/*
@@ -174,7 +174,7 @@ xfs_dir2_block_sfsize(
 		 * Calculate the pointer to the entry at hand.
 		 */
 		dep = (xfs_dir2_data_entry_t *)
-		      ((char *)block + xfs_dir2_dataptr_to_off(mp, addr));
+		      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, addr));
 		/*
 		 * Detect . and .., so we can special-case them.
 		 * . is not included in sf directories.
@@ -255,6 +255,7 @@ xfs_dir2_block_to_sf(
 		ASSERT(error != ENOSPC);
 		goto out;
 	}
+
 	/*
 	 * The buffer is now unconditionally gone, whether
 	 * xfs_dir2_shrink_inode worked or not.
@@ -276,7 +277,7 @@ xfs_dir2_block_to_sf(
 	/*
 	 * Set up to loop over the block's entries.
 	 */
-	btp = xfs_dir2_block_tail_p(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, &block->hdr);
 	ptr = (char *)block->u;
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	sfep = xfs_dir2_sf_firstentry(sfp);
Index: xfs/fs/xfs/xfs_dir2_sf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.h	2011-06-30 09:38:34.303400889 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.h	2011-06-30 09:38:36.593400862 +0200
@@ -32,7 +32,7 @@
 struct uio;
 struct xfs_dabuf;
 struct xfs_da_args;
-struct xfs_dir2_block;
+struct xfs_dir2_data_hdr;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
@@ -134,7 +134,7 @@ extern xfs_ino_t xfs_dir2_sf_get_parent_
 extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf_hdr *sfp,
 				      struct xfs_dir2_sf_entry *sfep);
 extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
-				 struct xfs_dir2_block *block,
+				 struct xfs_dir2_data_hdr *block,
 				 xfs_dir2_sf_hdr_t *sfhp);
 extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_dabuf *bp,
 				int size, xfs_dir2_sf_hdr_t *sfhp);
Index: xfs/fs/xfs/xfs_dir2_block.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.h	2011-06-29 19:45:24.376964832 +0200
+++ xfs/fs/xfs/xfs_dir2_block.h	2011-06-30 09:38:36.596734195 +0200
@@ -61,10 +61,9 @@ typedef struct xfs_dir2_block {
  * Pointer to the leaf header embedded in a data block (1-block format)
  */
 static inline xfs_dir2_block_tail_t *
-xfs_dir2_block_tail_p(struct xfs_mount *mp, xfs_dir2_block_t *block)
+xfs_dir2_block_tail_p(struct xfs_mount *mp, xfs_dir2_data_hdr_t *hdr)
 {
-	return (((xfs_dir2_block_tail_t *)
-		((char *)(block) + (mp)->m_dirblksize)) - 1);
+	return ((xfs_dir2_block_tail_t *)((char *)hdr + mp->m_dirblksize)) - 1;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
