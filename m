Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Apr 2007 10:59:14 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3IHx3fB017854
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2007 10:59:05 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l3IHx0LD018425
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2007 19:59:00 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l3IHx0WA018423
	for xfs@oss.sgi.com; Wed, 18 Apr 2007 19:59:00 +0200
Date: Wed, 18 Apr 2007 19:59:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill macro noise in xfs_dir2*.h
Message-ID: <20070418175859.GB18315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Remove all the macros that just give inline functions uppercase names.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_dir2.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2.c	2007-04-13 14:02:24.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2.c	2007-04-13 14:07:18.000000000 +0200
@@ -55,9 +55,9 @@ xfs_dir_mount(
 	       XFS_MAX_BLOCKSIZE);
 	mp->m_dirblksize = 1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog);
 	mp->m_dirblkfsbs = 1 << mp->m_sb.sb_dirblklog;
-	mp->m_dirdatablk = XFS_DIR2_DB_TO_DA(mp, XFS_DIR2_DATA_FIRSTDB(mp));
-	mp->m_dirleafblk = XFS_DIR2_DB_TO_DA(mp, XFS_DIR2_LEAF_FIRSTDB(mp));
-	mp->m_dirfreeblk = XFS_DIR2_DB_TO_DA(mp, XFS_DIR2_FREE_FIRSTDB(mp));
+	mp->m_dirdatablk = xfs_dir2_db_to_da(mp, XFS_DIR2_DATA_FIRSTDB(mp));
+	mp->m_dirleafblk = xfs_dir2_db_to_da(mp, XFS_DIR2_LEAF_FIRSTDB(mp));
+	mp->m_dirfreeblk = xfs_dir2_db_to_da(mp, XFS_DIR2_FREE_FIRSTDB(mp));
 	mp->m_attr_node_ents =
 		(mp->m_sb.sb_blocksize - (uint)sizeof(xfs_da_node_hdr_t)) /
 		(uint)sizeof(xfs_da_node_entry_t);
@@ -554,7 +554,7 @@ xfs_dir2_grow_inode(
 	 */
 	if (mapp != &map)
 		kmem_free(mapp, sizeof(*mapp) * count);
-	*dbp = XFS_DIR2_DA_TO_DB(mp, (xfs_dablk_t)bno);
+	*dbp = xfs_dir2_da_to_db(mp, (xfs_dablk_t)bno);
 	/*
 	 * Update file's size if this is the data space and it grew.
 	 */
@@ -706,7 +706,7 @@ xfs_dir2_shrink_inode(
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
-	da = XFS_DIR2_DB_TO_DA(mp, db);
+	da = xfs_dir2_db_to_da(mp, db);
 	/*
 	 * Unmap the fsblock(s).
 	 */
@@ -742,7 +742,7 @@ xfs_dir2_shrink_inode(
 	/*
 	 * If the block isn't the last one in the directory, we're done.
 	 */
-	if (dp->i_d.di_size > XFS_DIR2_DB_OFF_TO_BYTE(mp, db + 1, 0))
+	if (dp->i_d.di_size > xfs_dir2_db_off_to_byte(mp, db + 1, 0))
 		return 0;
 	bno = da;
 	if ((error = xfs_bmap_last_before(tp, dp, &bno, XFS_DATA_FORK))) {
Index: linux-2.6/fs/xfs/xfs_dir2_block.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_block.c	2007-04-13 13:47:00.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_block.c	2007-04-13 14:08:20.000000000 +0200
@@ -115,13 +115,13 @@ xfs_dir2_block_addname(
 		xfs_da_brelse(tp, bp);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
-	len = XFS_DIR2_DATA_ENTSIZE(args->namelen);
+	len = xfs_dir2_data_entsize(args->namelen);
 	/*
 	 * Set up pointers to parts of the block.
 	 */
 	bf = block->hdr.bestfree;
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
-	blp = XFS_DIR2_BLOCK_LEAF_P(btp);
+	btp = xfs_dir2_block_tail_p(mp, block);
+	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * No stale entries?  Need space for entry and new leaf.
 	 */
@@ -397,7 +397,7 @@ xfs_dir2_block_addname(
 	 * Fill in the leaf entry.
 	 */
 	blp[mid].hashval = cpu_to_be32(args->hashval);
-	blp[mid].address = cpu_to_be32(XFS_DIR2_BYTE_TO_DATAPTR(mp,
+	blp[mid].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 				(char *)dep - (char *)block));
 	xfs_dir2_block_log_leaf(tp, bp, lfloglow, lfloghigh);
 	/*
@@ -412,7 +412,7 @@ xfs_dir2_block_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, args->namelen);
-	tagp = XFS_DIR2_DATA_ENTRY_TAG_P(dep);
+	tagp = xfs_dir2_data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)block);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
@@ -457,7 +457,7 @@ xfs_dir2_block_getdents(
 	/*
 	 * If the block number in the offset is out of range, we're done.
 	 */
-	if (XFS_DIR2_DATAPTR_TO_DB(mp, uio->uio_offset) > mp->m_dirdatablk) {
+	if (xfs_dir2_dataptr_to_db(mp, uio->uio_offset) > mp->m_dirdatablk) {
 		*eofp = 1;
 		return 0;
 	}
@@ -473,15 +473,15 @@ xfs_dir2_block_getdents(
 	 * Extract the byte offset we start at from the seek pointer.
 	 * We'll skip entries before this.
 	 */
-	wantoff = XFS_DIR2_DATAPTR_TO_OFF(mp, uio->uio_offset);
+	wantoff = xfs_dir2_dataptr_to_off(mp, uio->uio_offset);
 	block = bp->data;
 	xfs_dir2_data_check(dp, bp);
 	/*
 	 * Set up values for the loop.
 	 */
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, block);
 	ptr = (char *)block->u;
-	endptr = (char *)XFS_DIR2_BLOCK_LEAF_P(btp);
+	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	p.dbp = dbp;
 	p.put = put;
 	p.uio = uio;
@@ -504,7 +504,7 @@ xfs_dir2_block_getdents(
 		/*
 		 * Bump pointer for the next iteration.
 		 */
-		ptr += XFS_DIR2_DATA_ENTSIZE(dep->namelen);
+		ptr += xfs_dir2_data_entsize(dep->namelen);
 		/*
 		 * The entry is before the desired starting point, skip it.
 		 */
@@ -515,7 +515,7 @@ xfs_dir2_block_getdents(
 		 */
 		p.namelen = dep->namelen;
 
-		p.cook = XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
+		p.cook = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 						    ptr - (char *)block);
 		p.ino = be64_to_cpu(dep->inumber);
 #if XFS_BIG_INUMS
@@ -533,7 +533,7 @@ xfs_dir2_block_getdents(
 		 */
 		if (!p.done) {
 			uio->uio_offset =
-				XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
+				xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 					(char *)dep - (char *)block);
 			xfs_da_brelse(tp, bp);
 			return error;
@@ -547,7 +547,7 @@ xfs_dir2_block_getdents(
 	*eofp = 1;
 
 	uio->uio_offset =
-		XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk + 1, 0);
+		xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
 
 	xfs_da_brelse(tp, bp);
 
@@ -571,8 +571,8 @@ xfs_dir2_block_log_leaf(
 
 	mp = tp->t_mountp;
 	block = bp->data;
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
-	blp = XFS_DIR2_BLOCK_LEAF_P(btp);
+	btp = xfs_dir2_block_tail_p(mp, block);
+	blp = xfs_dir2_block_leaf_p(btp);
 	xfs_da_log_buf(tp, bp, (uint)((char *)&blp[first] - (char *)block),
 		(uint)((char *)&blp[last + 1] - (char *)block - 1));
 }
@@ -591,7 +591,7 @@ xfs_dir2_block_log_tail(
 
 	mp = tp->t_mountp;
 	block = bp->data;
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, block);
 	xfs_da_log_buf(tp, bp, (uint)((char *)btp - (char *)block),
 		(uint)((char *)(btp + 1) - (char *)block - 1));
 }
@@ -625,13 +625,13 @@ xfs_dir2_block_lookup(
 	mp = dp->i_mount;
 	block = bp->data;
 	xfs_dir2_data_check(dp, bp);
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
-	blp = XFS_DIR2_BLOCK_LEAF_P(btp);
+	btp = xfs_dir2_block_tail_p(mp, block);
+	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Get the offset from the leaf entry, to point to the data.
 	 */
 	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)block + XFS_DIR2_DATAPTR_TO_OFF(mp, be32_to_cpu(blp[ent].address)));
+	      ((char *)block + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
 	/*
 	 * Fill in inode number, release the block.
 	 */
@@ -677,8 +677,8 @@ xfs_dir2_block_lookup_int(
 	ASSERT(bp != NULL);
 	block = bp->data;
 	xfs_dir2_data_check(dp, bp);
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
-	blp = XFS_DIR2_BLOCK_LEAF_P(btp);
+	btp = xfs_dir2_block_tail_p(mp, block);
+	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Loop doing a binary search for our hash value.
 	 * Find our entry, ENOENT if it's not there.
@@ -715,7 +715,7 @@ xfs_dir2_block_lookup_int(
 		 * Get pointer to the entry from the leaf.
 		 */
 		dep = (xfs_dir2_data_entry_t *)
-			((char *)block + XFS_DIR2_DATAPTR_TO_OFF(mp, addr));
+			((char *)block + xfs_dir2_dataptr_to_off(mp, addr));
 		/*
 		 * Compare, if it's right give back buffer & entry number.
 		 */
@@ -770,20 +770,20 @@ xfs_dir2_block_removename(
 	tp = args->trans;
 	mp = dp->i_mount;
 	block = bp->data;
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
-	blp = XFS_DIR2_BLOCK_LEAF_P(btp);
+	btp = xfs_dir2_block_tail_p(mp, block);
+	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
 	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)block + XFS_DIR2_DATAPTR_TO_OFF(mp, be32_to_cpu(blp[ent].address)));
+	      ((char *)block + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
 	/*
 	 * Mark the data entry's space free.
 	 */
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(tp, bp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)block),
-		XFS_DIR2_DATA_ENTSIZE(dep->namelen), &needlog, &needscan);
+		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
 	/*
 	 * Fix up the block tail.
 	 */
@@ -846,13 +846,13 @@ xfs_dir2_block_replace(
 	dp = args->dp;
 	mp = dp->i_mount;
 	block = bp->data;
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
-	blp = XFS_DIR2_BLOCK_LEAF_P(btp);
+	btp = xfs_dir2_block_tail_p(mp, block);
+	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Point to the data entry we need to change.
 	 */
 	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)block + XFS_DIR2_DATAPTR_TO_OFF(mp, be32_to_cpu(blp[ent].address)));
+	      ((char *)block + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
@@ -915,7 +915,7 @@ xfs_dir2_leaf_to_block(
 	mp = dp->i_mount;
 	leaf = lbp->data;
 	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC);
-	ltp = XFS_DIR2_LEAF_TAIL_P(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	/*
 	 * If there are data blocks other than the first one, take this
 	 * opportunity to remove trailing empty data blocks that may have
@@ -923,7 +923,7 @@ xfs_dir2_leaf_to_block(
 	 * These will show up in the leaf bests table.
 	 */
 	while (dp->i_d.di_size > mp->m_dirblksize) {
-		bestsp = XFS_DIR2_LEAF_BESTS_P(ltp);
+		bestsp = xfs_dir2_leaf_bests_p(ltp);
 		if (be16_to_cpu(bestsp[be32_to_cpu(ltp->bestcount) - 1]) ==
 		    mp->m_dirblksize - (uint)sizeof(block->hdr)) {
 			if ((error =
@@ -977,14 +977,14 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Initialize the block tail.
 	 */
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, block);
 	btp->count = cpu_to_be32(be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale));
 	btp->stale = 0;
 	xfs_dir2_block_log_tail(tp, dbp);
 	/*
 	 * Initialize the block leaf area.  We compact out stale entries.
 	 */
-	lep = XFS_DIR2_BLOCK_LEAF_P(btp);
+	lep = xfs_dir2_block_leaf_p(btp);
 	for (from = to = 0; from < be16_to_cpu(leaf->hdr.count); from++) {
 		if (be32_to_cpu(leaf->ents[from].address) == XFS_DIR2_NULL_DATAPTR)
 			continue;
@@ -1071,7 +1071,7 @@ xfs_dir2_sf_to_block(
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	ASSERT(dp->i_d.di_size >= XFS_DIR2_SF_HDR_SIZE(sfp->hdr.i8count));
+	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
 	/*
 	 * Copy the directory into the stack buffer.
 	 * Then pitch the incore inode data so we can make extents.
@@ -1123,10 +1123,10 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Fill in the tail.
 	 */
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, block);
 	btp->count = cpu_to_be32(sfp->hdr.count + 2);	/* ., .. */
 	btp->stale = 0;
-	blp = XFS_DIR2_BLOCK_LEAF_P(btp);
+	blp = xfs_dir2_block_leaf_p(btp);
 	endoffset = (uint)((char *)blp - (char *)block);
 	/*
 	 * Remove the freespace, we'll manage it.
@@ -1142,25 +1142,25 @@ xfs_dir2_sf_to_block(
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
-	tagp = XFS_DIR2_DATA_ENTRY_TAG_P(dep);
+	tagp = xfs_dir2_data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)block);
 	xfs_dir2_data_log_entry(tp, bp, dep);
 	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
-	blp[0].address = cpu_to_be32(XFS_DIR2_BYTE_TO_DATAPTR(mp,
+	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 				(char *)dep - (char *)block));
 	/*
 	 * Create entry for ..
 	 */
 	dep = (xfs_dir2_data_entry_t *)
 		((char *)block + XFS_DIR2_DATA_DOTDOT_OFFSET);
-	dep->inumber = cpu_to_be64(XFS_DIR2_SF_GET_INUMBER(sfp, &sfp->hdr.parent));
+	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
-	tagp = XFS_DIR2_DATA_ENTRY_TAG_P(dep);
+	tagp = xfs_dir2_data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)block);
 	xfs_dir2_data_log_entry(tp, bp, dep);
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
-	blp[1].address = cpu_to_be32(XFS_DIR2_BYTE_TO_DATAPTR(mp,
+	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 				(char *)dep - (char *)block));
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
 	/*
@@ -1169,7 +1169,7 @@ xfs_dir2_sf_to_block(
 	if ((i = 0) == sfp->hdr.count)
 		sfep = NULL;
 	else
-		sfep = XFS_DIR2_SF_FIRSTENTRY(sfp);
+		sfep = xfs_dir2_sf_firstentry(sfp);
 	/*
 	 * Need to preserve the existing offset values in the sf directory.
 	 * Insert holes (unused entries) where necessary.
@@ -1181,7 +1181,7 @@ xfs_dir2_sf_to_block(
 		if (sfep == NULL)
 			newoffset = endoffset;
 		else
-			newoffset = XFS_DIR2_SF_GET_OFFSET(sfep);
+			newoffset = xfs_dir2_sf_get_offset(sfep);
 		/*
 		 * There should be a hole here, make one.
 		 */
@@ -1190,7 +1190,7 @@ xfs_dir2_sf_to_block(
 			      ((char *)block + offset);
 			dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 			dup->length = cpu_to_be16(newoffset - offset);
-			*XFS_DIR2_DATA_UNUSED_TAG_P(dup) = cpu_to_be16(
+			*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16(
 				((char *)dup - (char *)block));
 			xfs_dir2_data_log_unused(tp, bp, dup);
 			(void)xfs_dir2_data_freeinsert((xfs_dir2_data_t *)block,
@@ -1202,22 +1202,22 @@ xfs_dir2_sf_to_block(
 		 * Copy a real entry.
 		 */
 		dep = (xfs_dir2_data_entry_t *)((char *)block + newoffset);
-		dep->inumber = cpu_to_be64(XFS_DIR2_SF_GET_INUMBER(sfp,
-				XFS_DIR2_SF_INUMBERP(sfep)));
+		dep->inumber = cpu_to_be64(xfs_dir2_sf_get_inumber(sfp,
+				xfs_dir2_sf_inumberp(sfep)));
 		dep->namelen = sfep->namelen;
 		memcpy(dep->name, sfep->name, dep->namelen);
-		tagp = XFS_DIR2_DATA_ENTRY_TAG_P(dep);
+		tagp = xfs_dir2_data_entry_tag_p(dep);
 		*tagp = cpu_to_be16((char *)dep - (char *)block);
 		xfs_dir2_data_log_entry(tp, bp, dep);
 		blp[2 + i].hashval = cpu_to_be32(xfs_da_hashname(
 					(char *)sfep->name, sfep->namelen));
-		blp[2 + i].address = cpu_to_be32(XFS_DIR2_BYTE_TO_DATAPTR(mp,
+		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 						 (char *)dep - (char *)block));
 		offset = (int)((char *)(tagp + 1) - (char *)block);
 		if (++i == sfp->hdr.count)
 			sfep = NULL;
 		else
-			sfep = XFS_DIR2_SF_NEXTENTRY(sfp, sfep);
+			sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 	}
 	/* Done with the temporary buffer */
 	kmem_free(buf, buf_len);
Index: linux-2.6/fs/xfs/xfs_dir2_block.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_block.h	2007-04-13 13:48:21.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_block.h	2007-04-13 13:48:29.000000000 +0200
@@ -60,7 +60,6 @@ typedef struct xfs_dir2_block {
 /*
  * Pointer to the leaf header embedded in a data block (1-block format)
  */
-#define	XFS_DIR2_BLOCK_TAIL_P(mp,block)	xfs_dir2_block_tail_p(mp,block)
 static inline xfs_dir2_block_tail_t *
 xfs_dir2_block_tail_p(struct xfs_mount *mp, xfs_dir2_block_t *block)
 {
@@ -71,7 +70,6 @@ xfs_dir2_block_tail_p(struct xfs_mount *
 /*
  * Pointer to the leaf entries embedded in a data block (1-block format)
  */
-#define	XFS_DIR2_BLOCK_LEAF_P(btp)	xfs_dir2_block_leaf_p(btp)
 static inline struct xfs_dir2_leaf_entry *
 xfs_dir2_block_leaf_p(xfs_dir2_block_tail_t *btp)
 {
Index: linux-2.6/fs/xfs/xfs_dir2_data.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_data.c	2007-04-13 13:47:12.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_data.c	2007-04-13 14:08:11.000000000 +0200
@@ -72,8 +72,8 @@ xfs_dir2_data_check(
 	bf = d->hdr.bestfree;
 	p = (char *)d->u;
 	if (be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
-		btp = XFS_DIR2_BLOCK_TAIL_P(mp, (xfs_dir2_block_t *)d);
-		lep = XFS_DIR2_BLOCK_LEAF_P(btp);
+		btp = xfs_dir2_block_tail_p(mp, (xfs_dir2_block_t *)d);
+		lep = xfs_dir2_block_leaf_p(btp);
 		endp = (char *)lep;
 	} else
 		endp = (char *)d + mp->m_dirblksize;
@@ -107,7 +107,7 @@ xfs_dir2_data_check(
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			ASSERT(lastfree == 0);
-			ASSERT(be16_to_cpu(*XFS_DIR2_DATA_UNUSED_TAG_P(dup)) ==
+			ASSERT(be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) ==
 			       (char *)dup - (char *)d);
 			dfp = xfs_dir2_data_freefind(d, dup);
 			if (dfp) {
@@ -131,12 +131,12 @@ xfs_dir2_data_check(
 		dep = (xfs_dir2_data_entry_t *)p;
 		ASSERT(dep->namelen != 0);
 		ASSERT(xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)) == 0);
-		ASSERT(be16_to_cpu(*XFS_DIR2_DATA_ENTRY_TAG_P(dep)) ==
+		ASSERT(be16_to_cpu(*xfs_dir2_data_entry_tag_p(dep)) ==
 		       (char *)dep - (char *)d);
 		count++;
 		lastfree = 0;
 		if (be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
-			addr = XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
+			addr = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)d));
 			hash = xfs_da_hashname((char *)dep->name, dep->namelen);
@@ -147,7 +147,7 @@ xfs_dir2_data_check(
 			}
 			ASSERT(i < be32_to_cpu(btp->count));
 		}
-		p += XFS_DIR2_DATA_ENTSIZE(dep->namelen);
+		p += xfs_dir2_data_entsize(dep->namelen);
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
@@ -349,8 +349,8 @@ xfs_dir2_data_freescan(
 	if (aendp)
 		endp = aendp;
 	else if (be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
-		btp = XFS_DIR2_BLOCK_TAIL_P(mp, (xfs_dir2_block_t *)d);
-		endp = (char *)XFS_DIR2_BLOCK_LEAF_P(btp);
+		btp = xfs_dir2_block_tail_p(mp, (xfs_dir2_block_t *)d);
+		endp = (char *)xfs_dir2_block_leaf_p(btp);
 	} else
 		endp = (char *)d + mp->m_dirblksize;
 	/*
@@ -363,7 +363,7 @@ xfs_dir2_data_freescan(
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			ASSERT((char *)dup - (char *)d ==
-			       be16_to_cpu(*XFS_DIR2_DATA_UNUSED_TAG_P(dup)));
+			       be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)));
 			xfs_dir2_data_freeinsert(d, dup, loghead);
 			p += be16_to_cpu(dup->length);
 		}
@@ -373,8 +373,8 @@ xfs_dir2_data_freescan(
 		else {
 			dep = (xfs_dir2_data_entry_t *)p;
 			ASSERT((char *)dep - (char *)d ==
-			       be16_to_cpu(*XFS_DIR2_DATA_ENTRY_TAG_P(dep)));
-			p += XFS_DIR2_DATA_ENTSIZE(dep->namelen);
+			       be16_to_cpu(*xfs_dir2_data_entry_tag_p(dep)));
+			p += xfs_dir2_data_entsize(dep->namelen);
 		}
 	}
 }
@@ -405,7 +405,7 @@ xfs_dir2_data_init(
 	/*
 	 * Get the buffer set up for the block.
 	 */
-	error = xfs_da_get_buf(tp, dp, XFS_DIR2_DB_TO_DA(mp, blkno), -1, &bp,
+	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, blkno), -1, &bp,
 		XFS_DATA_FORK);
 	if (error) {
 		return error;
@@ -430,7 +430,7 @@ xfs_dir2_data_init(
 	t=mp->m_dirblksize - (uint)sizeof(d->hdr);
 	d->hdr.bestfree[0].length = cpu_to_be16(t);
 	dup->length = cpu_to_be16(t);
-	*XFS_DIR2_DATA_UNUSED_TAG_P(dup) = cpu_to_be16((char *)dup - (char *)d);
+	*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16((char *)dup - (char *)d);
 	/*
 	 * Log it and return it.
 	 */
@@ -455,7 +455,7 @@ xfs_dir2_data_log_entry(
 	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
 	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
 	xfs_da_log_buf(tp, bp, (uint)((char *)dep - (char *)d),
-		(uint)((char *)(XFS_DIR2_DATA_ENTRY_TAG_P(dep) + 1) -
+		(uint)((char *)(xfs_dir2_data_entry_tag_p(dep) + 1) -
 		       (char *)d - 1));
 }
 
@@ -500,8 +500,8 @@ xfs_dir2_data_log_unused(
 	 * Log the end (tag) of the unused entry.
 	 */
 	xfs_da_log_buf(tp, bp,
-		(uint)((char *)XFS_DIR2_DATA_UNUSED_TAG_P(dup) - (char *)d),
-		(uint)((char *)XFS_DIR2_DATA_UNUSED_TAG_P(dup) - (char *)d +
+		(uint)((char *)xfs_dir2_data_unused_tag_p(dup) - (char *)d),
+		(uint)((char *)xfs_dir2_data_unused_tag_p(dup) - (char *)d +
 		       sizeof(xfs_dir2_data_off_t) - 1));
 }
 
@@ -538,8 +538,8 @@ xfs_dir2_data_make_free(
 		xfs_dir2_block_tail_t	*btp;	/* block tail */
 
 		ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
-		btp = XFS_DIR2_BLOCK_TAIL_P(mp, (xfs_dir2_block_t *)d);
-		endptr = (char *)XFS_DIR2_BLOCK_LEAF_P(btp);
+		btp = xfs_dir2_block_tail_p(mp, (xfs_dir2_block_t *)d);
+		endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	}
 	/*
 	 * If this isn't the start of the block, then back up to
@@ -590,7 +590,7 @@ xfs_dir2_data_make_free(
 		 * Fix up the new big freespace.
 		 */
 		be16_add(&prevdup->length, len + be16_to_cpu(postdup->length));
-		*XFS_DIR2_DATA_UNUSED_TAG_P(prevdup) =
+		*xfs_dir2_data_unused_tag_p(prevdup) =
 			cpu_to_be16((char *)prevdup - (char *)d);
 		xfs_dir2_data_log_unused(tp, bp, prevdup);
 		if (!needscan) {
@@ -624,7 +624,7 @@ xfs_dir2_data_make_free(
 	else if (prevdup) {
 		dfp = xfs_dir2_data_freefind(d, prevdup);
 		be16_add(&prevdup->length, len);
-		*XFS_DIR2_DATA_UNUSED_TAG_P(prevdup) =
+		*xfs_dir2_data_unused_tag_p(prevdup) =
 			cpu_to_be16((char *)prevdup - (char *)d);
 		xfs_dir2_data_log_unused(tp, bp, prevdup);
 		/*
@@ -652,7 +652,7 @@ xfs_dir2_data_make_free(
 		newdup = (xfs_dir2_data_unused_t *)((char *)d + offset);
 		newdup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 		newdup->length = cpu_to_be16(len + be16_to_cpu(postdup->length));
-		*XFS_DIR2_DATA_UNUSED_TAG_P(newdup) =
+		*xfs_dir2_data_unused_tag_p(newdup) =
 			cpu_to_be16((char *)newdup - (char *)d);
 		xfs_dir2_data_log_unused(tp, bp, newdup);
 		/*
@@ -679,7 +679,7 @@ xfs_dir2_data_make_free(
 		newdup = (xfs_dir2_data_unused_t *)((char *)d + offset);
 		newdup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 		newdup->length = cpu_to_be16(len);
-		*XFS_DIR2_DATA_UNUSED_TAG_P(newdup) =
+		*xfs_dir2_data_unused_tag_p(newdup) =
 			cpu_to_be16((char *)newdup - (char *)d);
 		xfs_dir2_data_log_unused(tp, bp, newdup);
 		(void)xfs_dir2_data_freeinsert(d, newdup, needlogp);
@@ -715,7 +715,7 @@ xfs_dir2_data_use_free(
 	ASSERT(be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG);
 	ASSERT(offset >= (char *)dup - (char *)d);
 	ASSERT(offset + len <= (char *)dup + be16_to_cpu(dup->length) - (char *)d);
-	ASSERT((char *)dup - (char *)d == be16_to_cpu(*XFS_DIR2_DATA_UNUSED_TAG_P(dup)));
+	ASSERT((char *)dup - (char *)d == be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)));
 	/*
 	 * Look up the entry in the bestfree table.
 	 */
@@ -748,7 +748,7 @@ xfs_dir2_data_use_free(
 		newdup = (xfs_dir2_data_unused_t *)((char *)d + offset + len);
 		newdup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 		newdup->length = cpu_to_be16(oldlen - len);
-		*XFS_DIR2_DATA_UNUSED_TAG_P(newdup) =
+		*xfs_dir2_data_unused_tag_p(newdup) =
 			cpu_to_be16((char *)newdup - (char *)d);
 		xfs_dir2_data_log_unused(tp, bp, newdup);
 		/*
@@ -775,7 +775,7 @@ xfs_dir2_data_use_free(
 	else if (matchback) {
 		newdup = dup;
 		newdup->length = cpu_to_be16(((char *)d + offset) - (char *)newdup);
-		*XFS_DIR2_DATA_UNUSED_TAG_P(newdup) =
+		*xfs_dir2_data_unused_tag_p(newdup) =
 			cpu_to_be16((char *)newdup - (char *)d);
 		xfs_dir2_data_log_unused(tp, bp, newdup);
 		/*
@@ -802,13 +802,13 @@ xfs_dir2_data_use_free(
 	else {
 		newdup = dup;
 		newdup->length = cpu_to_be16(((char *)d + offset) - (char *)newdup);
-		*XFS_DIR2_DATA_UNUSED_TAG_P(newdup) =
+		*xfs_dir2_data_unused_tag_p(newdup) =
 			cpu_to_be16((char *)newdup - (char *)d);
 		xfs_dir2_data_log_unused(tp, bp, newdup);
 		newdup2 = (xfs_dir2_data_unused_t *)((char *)d + offset + len);
 		newdup2->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 		newdup2->length = cpu_to_be16(oldlen - len - be16_to_cpu(newdup->length));
-		*XFS_DIR2_DATA_UNUSED_TAG_P(newdup2) =
+		*xfs_dir2_data_unused_tag_p(newdup2) =
 			cpu_to_be16((char *)newdup2 - (char *)d);
 		xfs_dir2_data_log_unused(tp, bp, newdup2);
 		/*
Index: linux-2.6/fs/xfs/xfs_dir2_data.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_data.h	2007-04-13 13:50:00.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_data.h	2007-04-13 14:04:36.000000000 +0200
@@ -44,7 +44,7 @@ struct xfs_trans;
 #define	XFS_DIR2_DATA_SPACE	0
 #define	XFS_DIR2_DATA_OFFSET	(XFS_DIR2_DATA_SPACE * XFS_DIR2_SPACE_SIZE)
 #define	XFS_DIR2_DATA_FIRSTDB(mp)	\
-	XFS_DIR2_BYTE_TO_DB(mp, XFS_DIR2_DATA_OFFSET)
+	xfs_dir2_byte_to_db(mp, XFS_DIR2_DATA_OFFSET)
 
 /*
  * Offsets of . and .. in data space (always block 0)
@@ -52,9 +52,9 @@ struct xfs_trans;
 #define	XFS_DIR2_DATA_DOT_OFFSET	\
 	((xfs_dir2_data_aoff_t)sizeof(xfs_dir2_data_hdr_t))
 #define	XFS_DIR2_DATA_DOTDOT_OFFSET	\
-	(XFS_DIR2_DATA_DOT_OFFSET + XFS_DIR2_DATA_ENTSIZE(1))
+	(XFS_DIR2_DATA_DOT_OFFSET + xfs_dir2_data_entsize(1))
 #define	XFS_DIR2_DATA_FIRST_OFFSET		\
-	(XFS_DIR2_DATA_DOTDOT_OFFSET + XFS_DIR2_DATA_ENTSIZE(2))
+	(XFS_DIR2_DATA_DOTDOT_OFFSET + xfs_dir2_data_entsize(2))
 
 /*
  * Structures.
@@ -123,7 +123,6 @@ typedef struct xfs_dir2_data {
 /*
  * Size of a data entry.
  */
-#define XFS_DIR2_DATA_ENTSIZE(n)	xfs_dir2_data_entsize(n)
 static inline int xfs_dir2_data_entsize(int n)
 {
 	return (int)roundup(offsetof(xfs_dir2_data_entry_t, name[0]) + (n) + \
@@ -133,19 +132,16 @@ static inline int xfs_dir2_data_entsize(
 /*
  * Pointer to an entry's tag word.
  */
-#define	XFS_DIR2_DATA_ENTRY_TAG_P(dep)	xfs_dir2_data_entry_tag_p(dep)
 static inline __be16 *
 xfs_dir2_data_entry_tag_p(xfs_dir2_data_entry_t *dep)
 {
 	return (__be16 *)((char *)dep +
-		XFS_DIR2_DATA_ENTSIZE(dep->namelen) - sizeof(__be16));
+		xfs_dir2_data_entsize(dep->namelen) - sizeof(__be16));
 }
 
 /*
  * Pointer to a freespace's tag word.
  */
-#define	XFS_DIR2_DATA_UNUSED_TAG_P(dup) \
-	xfs_dir2_data_unused_tag_p(dup)
 static inline __be16 *
 xfs_dir2_data_unused_tag_p(xfs_dir2_data_unused_t *dup)
 {
Index: linux-2.6/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_leaf.c	2007-04-13 13:47:18.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_leaf.c	2007-04-13 14:08:13.000000000 +0200
@@ -92,7 +92,7 @@ xfs_dir2_block_to_leaf(
 	if ((error = xfs_da_grow_inode(args, &blkno))) {
 		return error;
 	}
-	ldb = XFS_DIR2_DA_TO_DB(mp, blkno);
+	ldb = xfs_dir2_da_to_db(mp, blkno);
 	ASSERT(ldb == XFS_DIR2_LEAF_FIRSTDB(mp));
 	/*
 	 * Initialize the leaf block, get a buffer for it.
@@ -104,8 +104,8 @@ xfs_dir2_block_to_leaf(
 	leaf = lbp->data;
 	block = dbp->data;
 	xfs_dir2_data_check(dp, dbp);
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
-	blp = XFS_DIR2_BLOCK_LEAF_P(btp);
+	btp = xfs_dir2_block_tail_p(mp, block);
+	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Set the counts in the leaf header.
 	 */
@@ -138,9 +138,9 @@ xfs_dir2_block_to_leaf(
 	/*
 	 * Set up leaf tail and bests table.
 	 */
-	ltp = XFS_DIR2_LEAF_TAIL_P(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	ltp->bestcount = cpu_to_be32(1);
-	bestsp = XFS_DIR2_LEAF_BESTS_P(ltp);
+	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	bestsp[0] =  block->hdr.bestfree[0].length;
 	/*
 	 * Log the data header and leaf bests table.
@@ -210,9 +210,9 @@ xfs_dir2_leaf_addname(
 	 */
 	index = xfs_dir2_leaf_search_hash(args, lbp);
 	leaf = lbp->data;
-	ltp = XFS_DIR2_LEAF_TAIL_P(mp, leaf);
-	bestsp = XFS_DIR2_LEAF_BESTS_P(ltp);
-	length = XFS_DIR2_DATA_ENTSIZE(args->namelen);
+	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+	bestsp = xfs_dir2_leaf_bests_p(ltp);
+	length = xfs_dir2_data_entsize(args->namelen);
 	/*
 	 * See if there are any entries with the same hash value
 	 * and space in their block for the new entry.
@@ -224,7 +224,7 @@ xfs_dir2_leaf_addname(
 	     index++, lep++) {
 		if (be32_to_cpu(lep->address) == XFS_DIR2_NULL_DATAPTR)
 			continue;
-		i = XFS_DIR2_DATAPTR_TO_DB(mp, be32_to_cpu(lep->address));
+		i = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
 		ASSERT(i < be32_to_cpu(ltp->bestcount));
 		ASSERT(be16_to_cpu(bestsp[i]) != NULLDATAOFF);
 		if (be16_to_cpu(bestsp[i]) >= length) {
@@ -379,7 +379,7 @@ xfs_dir2_leaf_addname(
 	 */
 	else {
 		if ((error =
-		    xfs_da_read_buf(tp, dp, XFS_DIR2_DB_TO_DA(mp, use_block),
+		    xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, use_block),
 			    -1, &dbp, XFS_DATA_FORK))) {
 			xfs_da_brelse(tp, lbp);
 			return error;
@@ -408,7 +408,7 @@ xfs_dir2_leaf_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
-	tagp = XFS_DIR2_DATA_ENTRY_TAG_P(dep);
+	tagp = xfs_dir2_data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)data);
 	/*
 	 * Need to scan fix up the bestfree table.
@@ -530,7 +530,7 @@ xfs_dir2_leaf_addname(
 	 * Fill in the new leaf entry.
 	 */
 	lep->hashval = cpu_to_be32(args->hashval);
-	lep->address = cpu_to_be32(XFS_DIR2_DB_OFF_TO_DATAPTR(mp, use_block,
+	lep->address = cpu_to_be32(xfs_dir2_db_off_to_dataptr(mp, use_block,
 				be16_to_cpu(*tagp)));
 	/*
 	 * Log the leaf fields and give up the buffers.
@@ -568,13 +568,13 @@ xfs_dir2_leaf_check(
 	 * Should factor in the size of the bests table as well.
 	 * We can deduce a value for that from di_size.
 	 */
-	ASSERT(be16_to_cpu(leaf->hdr.count) <= XFS_DIR2_MAX_LEAF_ENTS(mp));
-	ltp = XFS_DIR2_LEAF_TAIL_P(mp, leaf);
+	ASSERT(be16_to_cpu(leaf->hdr.count) <= xfs_dir2_max_leaf_ents(mp));
+	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	/*
 	 * Leaves and bests don't overlap.
 	 */
 	ASSERT((char *)&leaf->ents[be16_to_cpu(leaf->hdr.count)] <=
-	       (char *)XFS_DIR2_LEAF_BESTS_P(ltp));
+	       (char *)xfs_dir2_leaf_bests_p(ltp));
 	/*
 	 * Check hash value order, count stale entries.
 	 */
@@ -816,12 +816,12 @@ xfs_dir2_leaf_getdents(
 	 * Inside the loop we keep the main offset value as a byte offset
 	 * in the directory file.
 	 */
-	curoff = XFS_DIR2_DATAPTR_TO_BYTE(mp, uio->uio_offset);
+	curoff = xfs_dir2_dataptr_to_byte(mp, uio->uio_offset);
 	/*
 	 * Force this conversion through db so we truncate the offset
 	 * down to get the start of the data block.
 	 */
-	map_off = XFS_DIR2_DB_TO_DA(mp, XFS_DIR2_BYTE_TO_DB(mp, curoff));
+	map_off = xfs_dir2_db_to_da(mp, xfs_dir2_byte_to_db(mp, curoff));
 	/*
 	 * Loop over directory entries until we reach the end offset.
 	 * Get more blocks and readahead as necessary.
@@ -871,7 +871,7 @@ xfs_dir2_leaf_getdents(
 			 */
 			if (1 + ra_want > map_blocks &&
 			    map_off <
-			    XFS_DIR2_BYTE_TO_DA(mp, XFS_DIR2_LEAF_OFFSET)) {
+			    xfs_dir2_byte_to_da(mp, XFS_DIR2_LEAF_OFFSET)) {
 				/*
 				 * Get more bmaps, fill in after the ones
 				 * we already have in the table.
@@ -879,7 +879,7 @@ xfs_dir2_leaf_getdents(
 				nmap = map_size - map_valid;
 				error = xfs_bmapi(tp, dp,
 					map_off,
-					XFS_DIR2_BYTE_TO_DA(mp,
+					xfs_dir2_byte_to_da(mp,
 						XFS_DIR2_LEAF_OFFSET) - map_off,
 					XFS_BMAPI_METADATA, NULL, 0,
 					&map[map_valid], &nmap, NULL, NULL);
@@ -904,7 +904,7 @@ xfs_dir2_leaf_getdents(
 					map[map_valid + nmap - 1].br_blockcount;
 				else
 					map_off =
-						XFS_DIR2_BYTE_TO_DA(mp,
+						xfs_dir2_byte_to_da(mp,
 							XFS_DIR2_LEAF_OFFSET);
 				/*
 				 * Look for holes in the mapping, and
@@ -932,14 +932,14 @@ xfs_dir2_leaf_getdents(
 			 * No valid mappings, so no more data blocks.
 			 */
 			if (!map_valid) {
-				curoff = XFS_DIR2_DA_TO_BYTE(mp, map_off);
+				curoff = xfs_dir2_da_to_byte(mp, map_off);
 				break;
 			}
 			/*
 			 * Read the directory block starting at the first
 			 * mapping.
 			 */
-			curdb = XFS_DIR2_DA_TO_DB(mp, map->br_startoff);
+			curdb = xfs_dir2_da_to_db(mp, map->br_startoff);
 			error = xfs_da_read_buf(tp, dp, map->br_startoff,
 				map->br_blockcount >= mp->m_dirblkfsbs ?
 				    XFS_FSB_TO_DADDR(mp, map->br_startblock) :
@@ -1015,7 +1015,7 @@ xfs_dir2_leaf_getdents(
 			/*
 			 * Having done a read, we need to set a new offset.
 			 */
-			newoff = XFS_DIR2_DB_OFF_TO_BYTE(mp, curdb, 0);
+			newoff = xfs_dir2_db_off_to_byte(mp, curdb, 0);
 			/*
 			 * Start of the current block.
 			 */
@@ -1025,7 +1025,7 @@ xfs_dir2_leaf_getdents(
 			 * Make sure we're in the right block.
 			 */
 			else if (curoff > newoff)
-				ASSERT(XFS_DIR2_BYTE_TO_DB(mp, curoff) ==
+				ASSERT(xfs_dir2_byte_to_db(mp, curoff) ==
 				       curdb);
 			data = bp->data;
 			xfs_dir2_data_check(dp, bp);
@@ -1033,7 +1033,7 @@ xfs_dir2_leaf_getdents(
 			 * Find our position in the block.
 			 */
 			ptr = (char *)&data->u;
-			byteoff = XFS_DIR2_BYTE_TO_OFF(mp, curoff);
+			byteoff = xfs_dir2_byte_to_off(mp, curoff);
 			/*
 			 * Skip past the header.
 			 */
@@ -1055,15 +1055,15 @@ xfs_dir2_leaf_getdents(
 					}
 					dep = (xfs_dir2_data_entry_t *)ptr;
 					length =
-					   XFS_DIR2_DATA_ENTSIZE(dep->namelen);
+					   xfs_dir2_data_entsize(dep->namelen);
 					ptr += length;
 				}
 				/*
 				 * Now set our real offset.
 				 */
 				curoff =
-					XFS_DIR2_DB_OFF_TO_BYTE(mp,
-					    XFS_DIR2_BYTE_TO_DB(mp, curoff),
+					xfs_dir2_db_off_to_byte(mp,
+					    xfs_dir2_byte_to_db(mp, curoff),
 					    (char *)ptr - (char *)data);
 				if (ptr >= (char *)data + mp->m_dirblksize) {
 					continue;
@@ -1092,9 +1092,9 @@ xfs_dir2_leaf_getdents(
 
 		p->namelen = dep->namelen;
 
-		length = XFS_DIR2_DATA_ENTSIZE(p->namelen);
+		length = xfs_dir2_data_entsize(p->namelen);
 
-		p->cook = XFS_DIR2_BYTE_TO_DATAPTR(mp, curoff + length);
+		p->cook = xfs_dir2_byte_to_dataptr(mp, curoff + length);
 
 		p->ino = be64_to_cpu(dep->inumber);
 #if XFS_BIG_INUMS
@@ -1122,10 +1122,10 @@ xfs_dir2_leaf_getdents(
 	 * All done.  Set output offset value to current offset.
 	 */
 	*eofp = eof;
-	if (curoff > XFS_DIR2_DATAPTR_TO_BYTE(mp, XFS_DIR2_MAX_DATAPTR))
+	if (curoff > xfs_dir2_dataptr_to_byte(mp, XFS_DIR2_MAX_DATAPTR))
 		uio->uio_offset = XFS_DIR2_MAX_DATAPTR;
 	else
-		uio->uio_offset = XFS_DIR2_BYTE_TO_DATAPTR(mp, curoff);
+		uio->uio_offset = xfs_dir2_byte_to_dataptr(mp, curoff);
 	kmem_free(map, map_size * sizeof(*map));
 	kmem_free(p, sizeof(*p));
 	if (bp)
@@ -1160,7 +1160,7 @@ xfs_dir2_leaf_init(
 	/*
 	 * Get the buffer for the block.
 	 */
-	error = xfs_da_get_buf(tp, dp, XFS_DIR2_DB_TO_DA(mp, bno), -1, &bp,
+	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, bno), -1, &bp,
 		XFS_DATA_FORK);
 	if (error) {
 		return error;
@@ -1182,7 +1182,7 @@ xfs_dir2_leaf_init(
 	 * the block.
 	 */
 	if (magic == XFS_DIR2_LEAF1_MAGIC) {
-		ltp = XFS_DIR2_LEAF_TAIL_P(mp, leaf);
+		ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 		ltp->bestcount = 0;
 		xfs_dir2_leaf_log_tail(tp, bp);
 	}
@@ -1207,9 +1207,9 @@ xfs_dir2_leaf_log_bests(
 
 	leaf = bp->data;
 	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC);
-	ltp = XFS_DIR2_LEAF_TAIL_P(tp->t_mountp, leaf);
-	firstb = XFS_DIR2_LEAF_BESTS_P(ltp) + first;
-	lastb = XFS_DIR2_LEAF_BESTS_P(ltp) + last;
+	ltp = xfs_dir2_leaf_tail_p(tp->t_mountp, leaf);
+	firstb = xfs_dir2_leaf_bests_p(ltp) + first;
+	lastb = xfs_dir2_leaf_bests_p(ltp) + last;
 	xfs_da_log_buf(tp, bp, (uint)((char *)firstb - (char *)leaf),
 		(uint)((char *)lastb - (char *)leaf + sizeof(*lastb) - 1));
 }
@@ -1269,7 +1269,7 @@ xfs_dir2_leaf_log_tail(
 	mp = tp->t_mountp;
 	leaf = bp->data;
 	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAF1_MAGIC);
-	ltp = XFS_DIR2_LEAF_TAIL_P(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	xfs_da_log_buf(tp, bp, (uint)((char *)ltp - (char *)leaf),
 		(uint)(mp->m_dirblksize - 1));
 }
@@ -1313,7 +1313,7 @@ xfs_dir2_leaf_lookup(
 	 */
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->data +
-	       XFS_DIR2_DATAPTR_TO_OFF(dp->i_mount, be32_to_cpu(lep->address)));
+	       xfs_dir2_dataptr_to_off(dp->i_mount, be32_to_cpu(lep->address)));
 	/*
 	 * Return the found inode number.
 	 */
@@ -1382,7 +1382,7 @@ xfs_dir2_leaf_lookup_int(
 		/*
 		 * Get the new data block number.
 		 */
-		newdb = XFS_DIR2_DATAPTR_TO_DB(mp, be32_to_cpu(lep->address));
+		newdb = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
 		/*
 		 * If it's not the same as the old data block number,
 		 * need to pitch the old one and read the new one.
@@ -1392,7 +1392,7 @@ xfs_dir2_leaf_lookup_int(
 				xfs_da_brelse(tp, dbp);
 			if ((error =
 			    xfs_da_read_buf(tp, dp,
-				    XFS_DIR2_DB_TO_DA(mp, newdb), -1, &dbp,
+				    xfs_dir2_db_to_da(mp, newdb), -1, &dbp,
 				    XFS_DATA_FORK))) {
 				xfs_da_brelse(tp, lbp);
 				return error;
@@ -1405,7 +1405,7 @@ xfs_dir2_leaf_lookup_int(
 		 */
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)dbp->data +
-		       XFS_DIR2_DATAPTR_TO_OFF(mp, be32_to_cpu(lep->address)));
+		       xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
 		/*
 		 * If it matches then return it.
 		 */
@@ -1470,20 +1470,20 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &leaf->ents[index];
-	db = XFS_DIR2_DATAPTR_TO_DB(mp, be32_to_cpu(lep->address));
+	db = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
 	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)data + XFS_DIR2_DATAPTR_TO_OFF(mp, be32_to_cpu(lep->address)));
+	      ((char *)data + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(data->hdr.bestfree[0].length);
-	ltp = XFS_DIR2_LEAF_TAIL_P(mp, leaf);
-	bestsp = XFS_DIR2_LEAF_BESTS_P(ltp);
+	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	ASSERT(be16_to_cpu(bestsp[db]) == oldbest);
 	/*
 	 * Mark the former data entry unused.
 	 */
 	xfs_dir2_data_make_free(tp, dbp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)data),
-		XFS_DIR2_DATA_ENTSIZE(dep->namelen), &needlog, &needscan);
+		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
 	/*
 	 * We just mark the leaf entry stale by putting a null in it.
 	 */
@@ -1603,7 +1603,7 @@ xfs_dir2_leaf_replace(
 	 */
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->data +
-	       XFS_DIR2_DATAPTR_TO_OFF(dp->i_mount, be32_to_cpu(lep->address)));
+	       xfs_dir2_dataptr_to_off(dp->i_mount, be32_to_cpu(lep->address)));
 	ASSERT(args->inumber != be64_to_cpu(dep->inumber));
 	/*
 	 * Put the new inode number in, log it.
@@ -1699,7 +1699,7 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Read the offending data block.  We need its buffer.
 	 */
-	if ((error = xfs_da_read_buf(tp, dp, XFS_DIR2_DB_TO_DA(mp, db), -1, &dbp,
+	if ((error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, db), -1, &dbp,
 			XFS_DATA_FORK))) {
 		return error;
 	}
@@ -1713,7 +1713,7 @@ xfs_dir2_leaf_trim_data(
 	 */
 
 	leaf = lbp->data;
-	ltp = XFS_DIR2_LEAF_TAIL_P(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	ASSERT(be16_to_cpu(data->hdr.bestfree[0].length) ==
 	       mp->m_dirblksize - (uint)sizeof(data->hdr));
 	ASSERT(db == be32_to_cpu(ltp->bestcount) - 1);
@@ -1728,7 +1728,7 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Eliminate the last bests entry from the table.
 	 */
-	bestsp = XFS_DIR2_LEAF_BESTS_P(ltp);
+	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	be32_add(&ltp->bestcount, -1);
 	memmove(&bestsp[1], &bestsp[0], be32_to_cpu(ltp->bestcount) * sizeof(*bestsp));
 	xfs_dir2_leaf_log_tail(tp, lbp);
@@ -1839,12 +1839,12 @@ xfs_dir2_node_to_leaf(
 	/*
 	 * Set up the leaf tail from the freespace block.
 	 */
-	ltp = XFS_DIR2_LEAF_TAIL_P(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	ltp->bestcount = free->hdr.nvalid;
 	/*
 	 * Set up the leaf bests table.
 	 */
-	memcpy(XFS_DIR2_LEAF_BESTS_P(ltp), free->bests,
+	memcpy(xfs_dir2_leaf_bests_p(ltp), free->bests,
 		be32_to_cpu(ltp->bestcount) * sizeof(leaf->bests[0]));
 	xfs_dir2_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
 	xfs_dir2_leaf_log_tail(tp, lbp);
Index: linux-2.6/fs/xfs/xfs_dir2_leaf.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_leaf.h	2007-04-13 13:54:13.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_leaf.h	2007-04-13 14:10:43.000000000 +0200
@@ -32,7 +32,7 @@ struct xfs_trans;
 #define	XFS_DIR2_LEAF_SPACE	1
 #define	XFS_DIR2_LEAF_OFFSET	(XFS_DIR2_LEAF_SPACE * XFS_DIR2_SPACE_SIZE)
 #define	XFS_DIR2_LEAF_FIRSTDB(mp)	\
-	XFS_DIR2_BYTE_TO_DB(mp, XFS_DIR2_LEAF_OFFSET)
+	xfs_dir2_byte_to_db(mp, XFS_DIR2_LEAF_OFFSET)
 
 /*
  * Offset in data space of a data entry.
@@ -82,7 +82,6 @@ typedef struct xfs_dir2_leaf {
  * DB blocks here are logical directory block numbers, not filesystem blocks.
  */
 
-#define	XFS_DIR2_MAX_LEAF_ENTS(mp)	xfs_dir2_max_leaf_ents(mp)
 static inline int xfs_dir2_max_leaf_ents(struct xfs_mount *mp)
 {
 	return (int)(((mp)->m_dirblksize - (uint)sizeof(xfs_dir2_leaf_hdr_t)) /
@@ -92,7 +91,6 @@ static inline int xfs_dir2_max_leaf_ents
 /*
  * Get address of the bestcount field in the single-leaf block.
  */
-#define	XFS_DIR2_LEAF_TAIL_P(mp,lp)	xfs_dir2_leaf_tail_p(mp, lp)
 static inline xfs_dir2_leaf_tail_t *
 xfs_dir2_leaf_tail_p(struct xfs_mount *mp, xfs_dir2_leaf_t *lp)
 {
@@ -104,7 +102,6 @@ xfs_dir2_leaf_tail_p(struct xfs_mount *m
 /*
  * Get address of the bests array in the single-leaf block.
  */
-#define	XFS_DIR2_LEAF_BESTS_P(ltp)	xfs_dir2_leaf_bests_p(ltp)
 static inline __be16 *
 xfs_dir2_leaf_bests_p(xfs_dir2_leaf_tail_t *ltp)
 {
@@ -114,7 +111,6 @@ xfs_dir2_leaf_bests_p(xfs_dir2_leaf_tail
 /*
  * Convert dataptr to byte in file space
  */
-#define	XFS_DIR2_DATAPTR_TO_BYTE(mp,dp)	xfs_dir2_dataptr_to_byte(mp, dp)
 static inline xfs_dir2_off_t
 xfs_dir2_dataptr_to_byte(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
 {
@@ -124,7 +120,6 @@ xfs_dir2_dataptr_to_byte(struct xfs_moun
 /*
  * Convert byte in file space to dataptr.  It had better be aligned.
  */
-#define	XFS_DIR2_BYTE_TO_DATAPTR(mp,by)	xfs_dir2_byte_to_dataptr(mp,by)
 static inline xfs_dir2_dataptr_t
 xfs_dir2_byte_to_dataptr(struct xfs_mount *mp, xfs_dir2_off_t by)
 {
@@ -134,7 +129,6 @@ xfs_dir2_byte_to_dataptr(struct xfs_moun
 /*
  * Convert byte in space to (DB) block
  */
-#define	XFS_DIR2_BYTE_TO_DB(mp,by)	xfs_dir2_byte_to_db(mp, by)
 static inline xfs_dir2_db_t
 xfs_dir2_byte_to_db(struct xfs_mount *mp, xfs_dir2_off_t by)
 {
@@ -145,17 +139,15 @@ xfs_dir2_byte_to_db(struct xfs_mount *mp
 /*
  * Convert dataptr to a block number
  */
-#define	XFS_DIR2_DATAPTR_TO_DB(mp,dp)	xfs_dir2_dataptr_to_db(mp, dp)
 static inline xfs_dir2_db_t
 xfs_dir2_dataptr_to_db(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
 {
-	return XFS_DIR2_BYTE_TO_DB(mp, XFS_DIR2_DATAPTR_TO_BYTE(mp, dp));
+	return xfs_dir2_byte_to_db(mp, xfs_dir2_dataptr_to_byte(mp, dp));
 }
 
 /*
  * Convert byte in space to offset in a block
  */
-#define	XFS_DIR2_BYTE_TO_OFF(mp,by)	xfs_dir2_byte_to_off(mp, by)
 static inline xfs_dir2_data_aoff_t
 xfs_dir2_byte_to_off(struct xfs_mount *mp, xfs_dir2_off_t by)
 {
@@ -166,18 +158,15 @@ xfs_dir2_byte_to_off(struct xfs_mount *m
 /*
  * Convert dataptr to a byte offset in a block
  */
-#define	XFS_DIR2_DATAPTR_TO_OFF(mp,dp)	xfs_dir2_dataptr_to_off(mp, dp)
 static inline xfs_dir2_data_aoff_t
 xfs_dir2_dataptr_to_off(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
 {
-	return XFS_DIR2_BYTE_TO_OFF(mp, XFS_DIR2_DATAPTR_TO_BYTE(mp, dp));
+	return xfs_dir2_byte_to_off(mp, xfs_dir2_dataptr_to_byte(mp, dp));
 }
 
 /*
  * Convert block and offset to byte in space
  */
-#define	XFS_DIR2_DB_OFF_TO_BYTE(mp,db,o)	\
-	xfs_dir2_db_off_to_byte(mp, db, o)
 static inline xfs_dir2_off_t
 xfs_dir2_db_off_to_byte(struct xfs_mount *mp, xfs_dir2_db_t db,
 			xfs_dir2_data_aoff_t o)
@@ -189,7 +178,6 @@ xfs_dir2_db_off_to_byte(struct xfs_mount
 /*
  * Convert block (DB) to block (dablk)
  */
-#define	XFS_DIR2_DB_TO_DA(mp,db)	xfs_dir2_db_to_da(mp, db)
 static inline xfs_dablk_t
 xfs_dir2_db_to_da(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
@@ -199,29 +187,25 @@ xfs_dir2_db_to_da(struct xfs_mount *mp, 
 /*
  * Convert byte in space to (DA) block
  */
-#define	XFS_DIR2_BYTE_TO_DA(mp,by)	xfs_dir2_byte_to_da(mp, by)
 static inline xfs_dablk_t
 xfs_dir2_byte_to_da(struct xfs_mount *mp, xfs_dir2_off_t by)
 {
-	return XFS_DIR2_DB_TO_DA(mp, XFS_DIR2_BYTE_TO_DB(mp, by));
+	return xfs_dir2_db_to_da(mp, xfs_dir2_byte_to_db(mp, by));
 }
 
 /*
  * Convert block and offset to dataptr
  */
-#define	XFS_DIR2_DB_OFF_TO_DATAPTR(mp,db,o)	\
-	xfs_dir2_db_off_to_dataptr(mp, db, o)
 static inline xfs_dir2_dataptr_t
 xfs_dir2_db_off_to_dataptr(struct xfs_mount *mp, xfs_dir2_db_t db,
 			   xfs_dir2_data_aoff_t o)
 {
-	return XFS_DIR2_BYTE_TO_DATAPTR(mp, XFS_DIR2_DB_OFF_TO_BYTE(mp, db, o));
+	return xfs_dir2_byte_to_dataptr(mp, xfs_dir2_db_off_to_byte(mp, db, o));
 }
 
 /*
  * Convert block (dablk) to block (DB)
  */
-#define	XFS_DIR2_DA_TO_DB(mp,da)	xfs_dir2_da_to_db(mp, da)
 static inline xfs_dir2_db_t
 xfs_dir2_da_to_db(struct xfs_mount *mp, xfs_dablk_t da)
 {
@@ -231,11 +215,10 @@ xfs_dir2_da_to_db(struct xfs_mount *mp, 
 /*
  * Convert block (dablk) to byte offset in space
  */
-#define XFS_DIR2_DA_TO_BYTE(mp,da)	xfs_dir2_da_to_byte(mp, da)
 static inline xfs_dir2_off_t
 xfs_dir2_da_to_byte(struct xfs_mount *mp, xfs_dablk_t da)
 {
-	return XFS_DIR2_DB_OFF_TO_BYTE(mp, XFS_DIR2_DA_TO_DB(mp, da), 0);
+	return xfs_dir2_db_off_to_byte(mp, xfs_dir2_da_to_db(mp, da), 0);
 }
 
 /*
Index: linux-2.6/fs/xfs/xfs_dir2_node.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_node.c	2007-04-13 13:49:23.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_node.c	2007-04-13 14:08:15.000000000 +0200
@@ -136,14 +136,14 @@ xfs_dir2_leaf_to_node(
 	/*
 	 * Get the buffer for the new freespace block.
 	 */
-	if ((error = xfs_da_get_buf(tp, dp, XFS_DIR2_DB_TO_DA(mp, fdb), -1, &fbp,
+	if ((error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, fdb), -1, &fbp,
 			XFS_DATA_FORK))) {
 		return error;
 	}
 	ASSERT(fbp != NULL);
 	free = fbp->data;
 	leaf = lbp->data;
-	ltp = XFS_DIR2_LEAF_TAIL_P(mp, leaf);
+	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	/*
 	 * Initialize the freespace block header.
 	 */
@@ -155,7 +155,7 @@ xfs_dir2_leaf_to_node(
 	 * Copy freespace entries from the leaf block to the new block.
 	 * Count active entries.
 	 */
-	for (i = n = 0, from = XFS_DIR2_LEAF_BESTS_P(ltp), to = free->bests;
+	for (i = n = 0, from = xfs_dir2_leaf_bests_p(ltp), to = free->bests;
 	     i < be32_to_cpu(ltp->bestcount); i++, from++, to++) {
 		if ((off = be16_to_cpu(*from)) != NULLDATAOFF)
 			n++;
@@ -215,7 +215,7 @@ xfs_dir2_leafn_add(
 	 * a compact.
 	 */
 
-	if (be16_to_cpu(leaf->hdr.count) == XFS_DIR2_MAX_LEAF_ENTS(mp)) {
+	if (be16_to_cpu(leaf->hdr.count) == xfs_dir2_max_leaf_ents(mp)) {
 		if (!leaf->hdr.stale)
 			return XFS_ERROR(ENOSPC);
 		compact = be16_to_cpu(leaf->hdr.stale) > 1;
@@ -327,7 +327,7 @@ xfs_dir2_leafn_add(
 	 * Insert the new entry, log everything.
 	 */
 	lep->hashval = cpu_to_be32(args->hashval);
-	lep->address = cpu_to_be32(XFS_DIR2_DB_OFF_TO_DATAPTR(mp,
+	lep->address = cpu_to_be32(xfs_dir2_db_off_to_dataptr(mp,
 				args->blkno, args->index));
 	xfs_dir2_leaf_log_header(tp, bp);
 	xfs_dir2_leaf_log_ents(tp, bp, lfloglow, lfloghigh);
@@ -352,7 +352,7 @@ xfs_dir2_leafn_check(
 	leaf = bp->data;
 	mp = dp->i_mount;
 	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
-	ASSERT(be16_to_cpu(leaf->hdr.count) <= XFS_DIR2_MAX_LEAF_ENTS(mp));
+	ASSERT(be16_to_cpu(leaf->hdr.count) <= xfs_dir2_max_leaf_ents(mp));
 	for (i = stale = 0; i < be16_to_cpu(leaf->hdr.count); i++) {
 		if (i + 1 < be16_to_cpu(leaf->hdr.count)) {
 			ASSERT(be32_to_cpu(leaf->ents[i].hashval) <=
@@ -440,7 +440,7 @@ xfs_dir2_leafn_lookup_int(
 	if (args->addname) {
 		curfdb = curbp ? state->extrablk.blkno : -1;
 		curdb = -1;
-		length = XFS_DIR2_DATA_ENTSIZE(args->namelen);
+		length = xfs_dir2_data_entsize(args->namelen);
 		if ((free = (curbp ? curbp->data : NULL)))
 			ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
 	}
@@ -465,7 +465,7 @@ xfs_dir2_leafn_lookup_int(
 		/*
 		 * Pull the data block number from the entry.
 		 */
-		newdb = XFS_DIR2_DATAPTR_TO_DB(mp, be32_to_cpu(lep->address));
+		newdb = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
 		/*
 		 * For addname, we're looking for a place to put the new entry.
 		 * We want to use a data block with an entry of equal
@@ -482,7 +482,7 @@ xfs_dir2_leafn_lookup_int(
 				 * Convert the data block to the free block
 				 * holding its freespace information.
 				 */
-				newfdb = XFS_DIR2_DB_TO_FDB(mp, newdb);
+				newfdb = xfs_dir2_db_to_fdb(mp, newdb);
 				/*
 				 * If it's not the one we have in hand,
 				 * read it in.
@@ -497,7 +497,7 @@ xfs_dir2_leafn_lookup_int(
 					 * Read the free block.
 					 */
 					if ((error = xfs_da_read_buf(tp, dp,
-							XFS_DIR2_DB_TO_DA(mp,
+							xfs_dir2_db_to_da(mp,
 								newfdb),
 							-1, &curbp,
 							XFS_DATA_FORK))) {
@@ -517,7 +517,7 @@ xfs_dir2_leafn_lookup_int(
 				/*
 				 * Get the index for our entry.
 				 */
-				fi = XFS_DIR2_DB_TO_FDINDEX(mp, curdb);
+				fi = xfs_dir2_db_to_fdindex(mp, curdb);
 				/*
 				 * If it has room, return it.
 				 */
@@ -561,7 +561,7 @@ xfs_dir2_leafn_lookup_int(
 				 */
 				if ((error =
 				    xfs_da_read_buf(tp, dp,
-					    XFS_DIR2_DB_TO_DA(mp, newdb), -1,
+					    xfs_dir2_db_to_da(mp, newdb), -1,
 					    &curbp, XFS_DATA_FORK))) {
 					return error;
 				}
@@ -573,7 +573,7 @@ xfs_dir2_leafn_lookup_int(
 			 */
 			dep = (xfs_dir2_data_entry_t *)
 			      ((char *)curbp->data +
-			       XFS_DIR2_DATAPTR_TO_OFF(mp, be32_to_cpu(lep->address)));
+			       xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
 			/*
 			 * Compare the entry, return it if it matches.
 			 */
@@ -876,9 +876,9 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = XFS_DIR2_DATAPTR_TO_DB(mp, be32_to_cpu(lep->address));
+	db = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
 	ASSERT(dblk->blkno == db);
-	off = XFS_DIR2_DATAPTR_TO_OFF(mp, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address));
 	ASSERT(dblk->index == off);
 	/*
 	 * Kill the leaf entry by marking it stale.
@@ -898,7 +898,7 @@ xfs_dir2_leafn_remove(
 	longest = be16_to_cpu(data->hdr.bestfree[0].length);
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(tp, dbp, off,
-		XFS_DIR2_DATA_ENTSIZE(dep->namelen), &needlog, &needscan);
+		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
 	/*
 	 * Rescan the data block freespaces for bestfree.
 	 * Log the data block header if needed.
@@ -924,8 +924,8 @@ xfs_dir2_leafn_remove(
 		 * Convert the data block number to a free block,
 		 * read in the free block.
 		 */
-		fdb = XFS_DIR2_DB_TO_FDB(mp, db);
-		if ((error = xfs_da_read_buf(tp, dp, XFS_DIR2_DB_TO_DA(mp, fdb),
+		fdb = xfs_dir2_db_to_fdb(mp, db);
+		if ((error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, fdb),
 				-1, &fbp, XFS_DATA_FORK))) {
 			return error;
 		}
@@ -937,7 +937,7 @@ xfs_dir2_leafn_remove(
 		/*
 		 * Calculate which entry we need to fix.
 		 */
-		findex = XFS_DIR2_DB_TO_FDINDEX(mp, db);
+		findex = xfs_dir2_db_to_fdindex(mp, db);
 		longest = be16_to_cpu(data->hdr.bestfree[0].length);
 		/*
 		 * If the data block is now empty we can get rid of it
@@ -1073,7 +1073,7 @@ xfs_dir2_leafn_split(
 	/*
 	 * Initialize the new leaf block.
 	 */
-	error = xfs_dir2_leaf_init(args, XFS_DIR2_DA_TO_DB(mp, blkno),
+	error = xfs_dir2_leaf_init(args, xfs_dir2_da_to_db(mp, blkno),
 		&newblk->bp, XFS_DIR2_LEAFN_MAGIC);
 	if (error) {
 		return error;
@@ -1385,7 +1385,7 @@ xfs_dir2_node_addname_int(
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
-	length = XFS_DIR2_DATA_ENTSIZE(args->namelen);
+	length = xfs_dir2_data_entsize(args->namelen);
 	/*
 	 * If we came in with a freespace block that means that lookup
 	 * found an entry with our hash value.  This is the freespace
@@ -1438,7 +1438,7 @@ xfs_dir2_node_addname_int(
 
 		if ((error = xfs_bmap_last_offset(tp, dp, &fo, XFS_DATA_FORK)))
 			return error;
-		lastfbno = XFS_DIR2_DA_TO_DB(mp, (xfs_dablk_t)fo);
+		lastfbno = xfs_dir2_da_to_db(mp, (xfs_dablk_t)fo);
 		fbno = ifbno;
 	}
 	/*
@@ -1474,7 +1474,7 @@ xfs_dir2_node_addname_int(
 			 * to avoid it.
 			 */
 			if ((error = xfs_da_read_buf(tp, dp,
-					XFS_DIR2_DB_TO_DA(mp, fbno), -2, &fbp,
+					xfs_dir2_db_to_da(mp, fbno), -2, &fbp,
 					XFS_DATA_FORK))) {
 				return error;
 			}
@@ -1550,9 +1550,9 @@ xfs_dir2_node_addname_int(
 		 * Get the freespace block corresponding to the data block
 		 * that was just allocated.
 		 */
-		fbno = XFS_DIR2_DB_TO_FDB(mp, dbno);
+		fbno = xfs_dir2_db_to_fdb(mp, dbno);
 		if (unlikely(error = xfs_da_read_buf(tp, dp,
-				XFS_DIR2_DB_TO_DA(mp, fbno), -2, &fbp,
+				xfs_dir2_db_to_da(mp, fbno), -2, &fbp,
 				XFS_DATA_FORK))) {
 			xfs_da_buf_done(dbp);
 			return error;
@@ -1567,14 +1567,14 @@ xfs_dir2_node_addname_int(
 				return error;
 			}
 
-			if (unlikely(XFS_DIR2_DB_TO_FDB(mp, dbno) != fbno)) {
+			if (unlikely(xfs_dir2_db_to_fdb(mp, dbno) != fbno)) {
 				cmn_err(CE_ALERT,
 					"xfs_dir2_node_addname_int: dir ino "
 					"%llu needed freesp block %lld for\n"
 					"  data block %lld, got %lld\n"
 					"  ifbno %llu lastfbno %d\n",
 					(unsigned long long)dp->i_ino,
-					(long long)XFS_DIR2_DB_TO_FDB(mp, dbno),
+					(long long)xfs_dir2_db_to_fdb(mp, dbno),
 					(long long)dbno, (long long)fbno,
 					(unsigned long long)ifbno, lastfbno);
 				if (fblk) {
@@ -1598,7 +1598,7 @@ xfs_dir2_node_addname_int(
 			 * Get a buffer for the new block.
 			 */
 			if ((error = xfs_da_get_buf(tp, dp,
-						   XFS_DIR2_DB_TO_DA(mp, fbno),
+						   xfs_dir2_db_to_da(mp, fbno),
 						   -1, &fbp, XFS_DATA_FORK))) {
 				return error;
 			}
@@ -1623,7 +1623,7 @@ xfs_dir2_node_addname_int(
 		/*
 		 * Set the freespace block index from the data block number.
 		 */
-		findex = XFS_DIR2_DB_TO_FDINDEX(mp, dbno);
+		findex = xfs_dir2_db_to_fdindex(mp, dbno);
 		/*
 		 * If it's after the end of the current entries in the
 		 * freespace block, extend that table.
@@ -1669,7 +1669,7 @@ xfs_dir2_node_addname_int(
 		 * Read the data block in.
 		 */
 		if (unlikely(
-		    error = xfs_da_read_buf(tp, dp, XFS_DIR2_DB_TO_DA(mp, dbno),
+		    error = xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp, dbno),
 				-1, &dbp, XFS_DATA_FORK))) {
 			if ((fblk == NULL || fblk->bp == NULL) && fbp != NULL)
 				xfs_da_buf_done(fbp);
@@ -1698,7 +1698,7 @@ xfs_dir2_node_addname_int(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
-	tagp = XFS_DIR2_DATA_ENTRY_TAG_P(dep);
+	tagp = xfs_dir2_data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)data);
 	xfs_dir2_data_log_entry(tp, dbp, dep);
 	/*
@@ -1904,7 +1904,7 @@ xfs_dir2_node_replace(
 		ASSERT(be32_to_cpu(data->hdr.magic) == XFS_DIR2_DATA_MAGIC);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)data +
-		       XFS_DIR2_DATAPTR_TO_OFF(state->mp, be32_to_cpu(lep->address)));
+		       xfs_dir2_dataptr_to_off(state->mp, be32_to_cpu(lep->address)));
 		ASSERT(inum != be64_to_cpu(dep->inumber));
 		/*
 		 * Fill in the new inode number and log the entry.
@@ -1980,7 +1980,7 @@ xfs_dir2_node_trim_free(
 	 * Blow the block away.
 	 */
 	if ((error =
-	    xfs_dir2_shrink_inode(args, XFS_DIR2_DA_TO_DB(mp, (xfs_dablk_t)fo),
+	    xfs_dir2_shrink_inode(args, xfs_dir2_da_to_db(mp, (xfs_dablk_t)fo),
 		    bp))) {
 		/*
 		 * Can't fail with ENOSPC since that only happens with no
Index: linux-2.6/fs/xfs/xfs_dir2_node.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_node.h	2007-04-13 13:55:47.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_node.h	2007-04-13 14:04:32.000000000 +0200
@@ -36,7 +36,7 @@ struct xfs_trans;
 #define	XFS_DIR2_FREE_SPACE	2
 #define	XFS_DIR2_FREE_OFFSET	(XFS_DIR2_FREE_SPACE * XFS_DIR2_SPACE_SIZE)
 #define	XFS_DIR2_FREE_FIRSTDB(mp)	\
-	XFS_DIR2_BYTE_TO_DB(mp, XFS_DIR2_FREE_OFFSET)
+	xfs_dir2_byte_to_db(mp, XFS_DIR2_FREE_OFFSET)
 
 #define	XFS_DIR2_FREE_MAGIC	0x58443246	/* XD2F */
 
@@ -60,7 +60,6 @@ typedef struct xfs_dir2_free {
 /*
  * Convert data space db to the corresponding free db.
  */
-#define	XFS_DIR2_DB_TO_FDB(mp,db)	xfs_dir2_db_to_fdb(mp, db)
 static inline xfs_dir2_db_t
 xfs_dir2_db_to_fdb(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
@@ -70,7 +69,6 @@ xfs_dir2_db_to_fdb(struct xfs_mount *mp,
 /*
  * Convert data space db to the corresponding index in a free db.
  */
-#define	XFS_DIR2_DB_TO_FDINDEX(mp,db)	xfs_dir2_db_to_fdindex(mp, db)
 static inline int
 xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
 {
Index: linux-2.6/fs/xfs/xfs_dir2_sf.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_sf.c	2007-04-13 13:47:23.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_sf.c	2007-04-13 14:08:17.000000000 +0200
@@ -89,8 +89,8 @@ xfs_dir2_block_sfsize(
 	mp = dp->i_mount;
 
 	count = i8count = namelen = 0;
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
-	blp = XFS_DIR2_BLOCK_LEAF_P(btp);
+	btp = xfs_dir2_block_tail_p(mp, block);
+	blp = xfs_dir2_block_leaf_p(btp);
 
 	/*
 	 * Iterate over the block's data entries by using the leaf pointers.
@@ -102,7 +102,7 @@ xfs_dir2_block_sfsize(
 		 * Calculate the pointer to the entry at hand.
 		 */
 		dep = (xfs_dir2_data_entry_t *)
-		      ((char *)block + XFS_DIR2_DATAPTR_TO_OFF(mp, addr));
+		      ((char *)block + xfs_dir2_dataptr_to_off(mp, addr));
 		/*
 		 * Detect . and .., so we can special-case them.
 		 * . is not included in sf directories.
@@ -124,7 +124,7 @@ xfs_dir2_block_sfsize(
 		/*
 		 * Calculate the new size, see if we should give up yet.
 		 */
-		size = XFS_DIR2_SF_HDR_SIZE(i8count) +		/* header */
+		size = xfs_dir2_sf_hdr_size(i8count) +		/* header */
 		       count +					/* namelen */
 		       count * (uint)sizeof(xfs_dir2_sf_off_t) + /* offset */
 		       namelen +				/* name */
@@ -139,7 +139,7 @@ xfs_dir2_block_sfsize(
 	 */
 	sfhp->count = count;
 	sfhp->i8count = i8count;
-	XFS_DIR2_SF_PUT_INUMBER((xfs_dir2_sf_t *)sfhp, &parent, &sfhp->parent);
+	xfs_dir2_sf_put_inumber((xfs_dir2_sf_t *)sfhp, &parent, &sfhp->parent);
 	return size;
 }
 
@@ -199,15 +199,15 @@ xfs_dir2_block_to_sf(
 	 * Copy the header into the newly allocate local space.
 	 */
 	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	memcpy(sfp, sfhp, XFS_DIR2_SF_HDR_SIZE(sfhp->i8count));
+	memcpy(sfp, sfhp, xfs_dir2_sf_hdr_size(sfhp->i8count));
 	dp->i_d.di_size = size;
 	/*
 	 * Set up to loop over the block's entries.
 	 */
-	btp = XFS_DIR2_BLOCK_TAIL_P(mp, block);
+	btp = xfs_dir2_block_tail_p(mp, block);
 	ptr = (char *)block->u;
-	endptr = (char *)XFS_DIR2_BLOCK_LEAF_P(btp);
-	sfep = XFS_DIR2_SF_FIRSTENTRY(sfp);
+	endptr = (char *)xfs_dir2_block_leaf_p(btp);
+	sfep = xfs_dir2_sf_firstentry(sfp);
 	/*
 	 * Loop over the active and unused entries.
 	 * Stop when we reach the leaf/tail portion of the block.
@@ -233,22 +233,22 @@ xfs_dir2_block_to_sf(
 		else if (dep->namelen == 2 &&
 			 dep->name[0] == '.' && dep->name[1] == '.')
 			ASSERT(be64_to_cpu(dep->inumber) ==
-			       XFS_DIR2_SF_GET_INUMBER(sfp, &sfp->hdr.parent));
+			       xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent));
 		/*
 		 * Normal entry, copy it into shortform.
 		 */
 		else {
 			sfep->namelen = dep->namelen;
-			XFS_DIR2_SF_PUT_OFFSET(sfep,
+			xfs_dir2_sf_put_offset(sfep,
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)block));
 			memcpy(sfep->name, dep->name, dep->namelen);
 			temp = be64_to_cpu(dep->inumber);
-			XFS_DIR2_SF_PUT_INUMBER(sfp, &temp,
-				XFS_DIR2_SF_INUMBERP(sfep));
-			sfep = XFS_DIR2_SF_NEXTENTRY(sfp, sfep);
+			xfs_dir2_sf_put_inumber(sfp, &temp,
+				xfs_dir2_sf_inumberp(sfep));
+			sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 		}
-		ptr += XFS_DIR2_DATA_ENTSIZE(dep->namelen);
+		ptr += xfs_dir2_data_entsize(dep->namelen);
 	}
 	ASSERT((char *)sfep - (char *)sfp == size);
 	xfs_dir2_sf_check(args);
@@ -294,11 +294,11 @@ xfs_dir2_sf_addname(
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	ASSERT(dp->i_d.di_size >= XFS_DIR2_SF_HDR_SIZE(sfp->hdr.i8count));
+	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
 	/*
 	 * Compute entry (and change in) size.
 	 */
-	add_entsize = XFS_DIR2_SF_ENTSIZE_BYNAME(sfp, args->namelen);
+	add_entsize = xfs_dir2_sf_entsize_byname(sfp, args->namelen);
 	incr_isize = add_entsize;
 	objchange = 0;
 #if XFS_BIG_INUMS
@@ -392,7 +392,7 @@ xfs_dir2_sf_addname_easy(
 	/*
 	 * Grow the in-inode space.
 	 */
-	xfs_idata_realloc(dp, XFS_DIR2_SF_ENTSIZE_BYNAME(sfp, args->namelen),
+	xfs_idata_realloc(dp, xfs_dir2_sf_entsize_byname(sfp, args->namelen),
 		XFS_DATA_FORK);
 	/*
 	 * Need to set up again due to realloc of the inode data.
@@ -403,10 +403,10 @@ xfs_dir2_sf_addname_easy(
 	 * Fill in the new entry.
 	 */
 	sfep->namelen = args->namelen;
-	XFS_DIR2_SF_PUT_OFFSET(sfep, offset);
+	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
-	XFS_DIR2_SF_PUT_INUMBER(sfp, &args->inumber,
-		XFS_DIR2_SF_INUMBERP(sfep));
+	xfs_dir2_sf_put_inumber(sfp, &args->inumber,
+		xfs_dir2_sf_inumberp(sfep));
 	/*
 	 * Update the header and inode.
 	 */
@@ -463,14 +463,14 @@ xfs_dir2_sf_addname_hard(
 	 * If it's going to end up at the end then oldsfep will point there.
 	 */
 	for (offset = XFS_DIR2_DATA_FIRST_OFFSET,
-	      oldsfep = XFS_DIR2_SF_FIRSTENTRY(oldsfp),
-	      add_datasize = XFS_DIR2_DATA_ENTSIZE(args->namelen),
+	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
+	      add_datasize = xfs_dir2_data_entsize(args->namelen),
 	      eof = (char *)oldsfep == &buf[old_isize];
 	     !eof;
-	     offset = new_offset + XFS_DIR2_DATA_ENTSIZE(oldsfep->namelen),
-	      oldsfep = XFS_DIR2_SF_NEXTENTRY(oldsfp, oldsfep),
+	     offset = new_offset + xfs_dir2_data_entsize(oldsfep->namelen),
+	      oldsfep = xfs_dir2_sf_nextentry(oldsfp, oldsfep),
 	      eof = (char *)oldsfep == &buf[old_isize]) {
-		new_offset = XFS_DIR2_SF_GET_OFFSET(oldsfep);
+		new_offset = xfs_dir2_sf_get_offset(oldsfep);
 		if (offset + add_datasize <= new_offset)
 			break;
 	}
@@ -495,10 +495,10 @@ xfs_dir2_sf_addname_hard(
 	 * Fill in the new entry, and update the header counts.
 	 */
 	sfep->namelen = args->namelen;
-	XFS_DIR2_SF_PUT_OFFSET(sfep, offset);
+	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
-	XFS_DIR2_SF_PUT_INUMBER(sfp, &args->inumber,
-		XFS_DIR2_SF_INUMBERP(sfep));
+	xfs_dir2_sf_put_inumber(sfp, &args->inumber,
+		xfs_dir2_sf_inumberp(sfep));
 	sfp->hdr.count++;
 #if XFS_BIG_INUMS
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
@@ -508,7 +508,7 @@ xfs_dir2_sf_addname_hard(
 	 * If there's more left to copy, do that.
 	 */
 	if (!eof) {
-		sfep = XFS_DIR2_SF_NEXTENTRY(sfp, sfep);
+		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 		memcpy(sfep, oldsfep, old_isize - nbytes);
 	}
 	kmem_free(buf, old_isize);
@@ -544,9 +544,9 @@ xfs_dir2_sf_addname_pick(
 	mp = dp->i_mount;
 
 	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	size = XFS_DIR2_DATA_ENTSIZE(args->namelen);
+	size = xfs_dir2_data_entsize(args->namelen);
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
-	sfep = XFS_DIR2_SF_FIRSTENTRY(sfp);
+	sfep = xfs_dir2_sf_firstentry(sfp);
 	holefit = 0;
 	/*
 	 * Loop over sf entries.
@@ -555,10 +555,10 @@ xfs_dir2_sf_addname_pick(
 	 */
 	for (i = 0; i < sfp->hdr.count; i++) {
 		if (!holefit)
-			holefit = offset + size <= XFS_DIR2_SF_GET_OFFSET(sfep);
-		offset = XFS_DIR2_SF_GET_OFFSET(sfep) +
-			 XFS_DIR2_DATA_ENTSIZE(sfep->namelen);
-		sfep = XFS_DIR2_SF_NEXTENTRY(sfp, sfep);
+			holefit = offset + size <= xfs_dir2_sf_get_offset(sfep);
+		offset = xfs_dir2_sf_get_offset(sfep) +
+			 xfs_dir2_data_entsize(sfep->namelen);
+		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 	}
 	/*
 	 * Calculate data bytes used excluding the new entry, if this
@@ -617,18 +617,18 @@ xfs_dir2_sf_check(
 
 	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
-	ino = XFS_DIR2_SF_GET_INUMBER(sfp, &sfp->hdr.parent);
+	ino = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
-	for (i = 0, sfep = XFS_DIR2_SF_FIRSTENTRY(sfp);
+	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->hdr.count;
-	     i++, sfep = XFS_DIR2_SF_NEXTENTRY(sfp, sfep)) {
-		ASSERT(XFS_DIR2_SF_GET_OFFSET(sfep) >= offset);
-		ino = XFS_DIR2_SF_GET_INUMBER(sfp, XFS_DIR2_SF_INUMBERP(sfep));
+	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
+		ASSERT(xfs_dir2_sf_get_offset(sfep) >= offset);
+		ino = xfs_dir2_sf_get_inumber(sfp, xfs_dir2_sf_inumberp(sfep));
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
 		offset =
-			XFS_DIR2_SF_GET_OFFSET(sfep) +
-			XFS_DIR2_DATA_ENTSIZE(sfep->namelen);
+			xfs_dir2_sf_get_offset(sfep) +
+			xfs_dir2_data_entsize(sfep->namelen);
 	}
 	ASSERT(i8count == sfp->hdr.i8count);
 	ASSERT(XFS_BIG_INUMS || i8count == 0);
@@ -671,7 +671,7 @@ xfs_dir2_sf_create(
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
 	ASSERT(dp->i_df.if_bytes == 0);
 	i8count = pino > XFS_DIR2_MAX_SHORT_INUM;
-	size = XFS_DIR2_SF_HDR_SIZE(i8count);
+	size = xfs_dir2_sf_hdr_size(i8count);
 	/*
 	 * Make a buffer for the data.
 	 */
@@ -684,7 +684,7 @@ xfs_dir2_sf_create(
 	/*
 	 * Now can put in the inode number, since i8count is set.
 	 */
-	XFS_DIR2_SF_PUT_INUMBER(sfp, &pino, &sfp->hdr.parent);
+	xfs_dir2_sf_put_inumber(sfp, &pino, &sfp->hdr.parent);
 	sfp->hdr.count = 0;
 	dp->i_d.di_size = size;
 	xfs_dir2_sf_check(args);
@@ -727,12 +727,12 @@ xfs_dir2_sf_getdents(
 
 	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
 
-	ASSERT(dp->i_d.di_size >= XFS_DIR2_SF_HDR_SIZE(sfp->hdr.i8count));
+	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
 
 	/*
 	 * If the block number in the offset is out of range, we're done.
 	 */
-	if (XFS_DIR2_DATAPTR_TO_DB(mp, dir_offset) > mp->m_dirdatablk) {
+	if (xfs_dir2_dataptr_to_db(mp, dir_offset) > mp->m_dirdatablk) {
 		*eofp = 1;
 		return 0;
 	}
@@ -747,9 +747,9 @@ xfs_dir2_sf_getdents(
 	 * Put . entry unless we're starting past it.
 	 */
 	if (dir_offset <=
-		    XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
+		    xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 					       XFS_DIR2_DATA_DOT_OFFSET)) {
-		p.cook = XFS_DIR2_DB_OFF_TO_DATAPTR(mp, 0,
+		p.cook = xfs_dir2_db_off_to_dataptr(mp, 0,
 						XFS_DIR2_DATA_DOTDOT_OFFSET);
 		p.ino = dp->i_ino;
 #if XFS_BIG_INUMS
@@ -762,7 +762,7 @@ xfs_dir2_sf_getdents(
 
 		if (!p.done) {
 			uio->uio_offset =
-				XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
+				xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 						XFS_DIR2_DATA_DOT_OFFSET);
 			return error;
 		}
@@ -772,11 +772,11 @@ xfs_dir2_sf_getdents(
 	 * Put .. entry unless we're starting past it.
 	 */
 	if (dir_offset <=
-		    XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
+		    xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 					       XFS_DIR2_DATA_DOTDOT_OFFSET)) {
-		p.cook = XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
+		p.cook = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 						XFS_DIR2_DATA_FIRST_OFFSET);
-		p.ino = XFS_DIR2_SF_GET_INUMBER(sfp, &sfp->hdr.parent);
+		p.ino = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
 #if XFS_BIG_INUMS
 		p.ino += mp->m_inoadd;
 #endif
@@ -787,7 +787,7 @@ xfs_dir2_sf_getdents(
 
 		if (!p.done) {
 			uio->uio_offset =
-				XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
+				xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 					XFS_DIR2_DATA_DOTDOT_OFFSET);
 			return error;
 		}
@@ -796,23 +796,23 @@ xfs_dir2_sf_getdents(
 	/*
 	 * Loop while there are more entries and put'ing works.
 	 */
-	for (i = 0, sfep = XFS_DIR2_SF_FIRSTENTRY(sfp);
+	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 		     i < sfp->hdr.count;
-			     i++, sfep = XFS_DIR2_SF_NEXTENTRY(sfp, sfep)) {
+			     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
 
-		off = XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
-				XFS_DIR2_SF_GET_OFFSET(sfep));
+		off = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
+				xfs_dir2_sf_get_offset(sfep));
 
 		if (dir_offset > off)
 			continue;
 
 		p.namelen = sfep->namelen;
 
-		p.cook = XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
-			XFS_DIR2_SF_GET_OFFSET(sfep) +
-			XFS_DIR2_DATA_ENTSIZE(p.namelen));
+		p.cook = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
+			xfs_dir2_sf_get_offset(sfep) +
+			xfs_dir2_data_entsize(p.namelen));
 
-		p.ino = XFS_DIR2_SF_GET_INUMBER(sfp, XFS_DIR2_SF_INUMBERP(sfep));
+		p.ino = xfs_dir2_sf_get_inumber(sfp, xfs_dir2_sf_inumberp(sfep));
 #if XFS_BIG_INUMS
 		p.ino += mp->m_inoadd;
 #endif
@@ -832,7 +832,7 @@ xfs_dir2_sf_getdents(
 	*eofp = 1;
 
 	uio->uio_offset =
-		XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk + 1, 0);
+		xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
 
 	return 0;
 }
@@ -865,7 +865,7 @@ xfs_dir2_sf_lookup(
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	ASSERT(dp->i_d.di_size >= XFS_DIR2_SF_HDR_SIZE(sfp->hdr.i8count));
+	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
 	/*
 	 * Special case for .
 	 */
@@ -878,21 +878,21 @@ xfs_dir2_sf_lookup(
 	 */
 	if (args->namelen == 2 &&
 	    args->name[0] == '.' && args->name[1] == '.') {
-		args->inumber = XFS_DIR2_SF_GET_INUMBER(sfp, &sfp->hdr.parent);
+		args->inumber = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
 		return XFS_ERROR(EEXIST);
 	}
 	/*
 	 * Loop over all the entries trying to match ours.
 	 */
-	for (i = 0, sfep = XFS_DIR2_SF_FIRSTENTRY(sfp);
+	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->hdr.count;
-	     i++, sfep = XFS_DIR2_SF_NEXTENTRY(sfp, sfep)) {
+	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
 		if (sfep->namelen == args->namelen &&
 		    sfep->name[0] == args->name[0] &&
 		    memcmp(args->name, sfep->name, args->namelen) == 0) {
 			args->inumber =
-				XFS_DIR2_SF_GET_INUMBER(sfp,
-					XFS_DIR2_SF_INUMBERP(sfep));
+				xfs_dir2_sf_get_inumber(sfp,
+					xfs_dir2_sf_inumberp(sfep));
 			return XFS_ERROR(EEXIST);
 		}
 	}
@@ -934,19 +934,19 @@ xfs_dir2_sf_removename(
 	ASSERT(dp->i_df.if_bytes == oldsize);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	ASSERT(oldsize >= XFS_DIR2_SF_HDR_SIZE(sfp->hdr.i8count));
+	ASSERT(oldsize >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
 	/*
 	 * Loop over the old directory entries.
 	 * Find the one we're deleting.
 	 */
-	for (i = 0, sfep = XFS_DIR2_SF_FIRSTENTRY(sfp);
+	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->hdr.count;
-	     i++, sfep = XFS_DIR2_SF_NEXTENTRY(sfp, sfep)) {
+	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
 		if (sfep->namelen == args->namelen &&
 		    sfep->name[0] == args->name[0] &&
 		    memcmp(sfep->name, args->name, args->namelen) == 0) {
-			ASSERT(XFS_DIR2_SF_GET_INUMBER(sfp,
-					XFS_DIR2_SF_INUMBERP(sfep)) ==
+			ASSERT(xfs_dir2_sf_get_inumber(sfp,
+					xfs_dir2_sf_inumberp(sfep)) ==
 				args->inumber);
 			break;
 		}
@@ -961,7 +961,7 @@ xfs_dir2_sf_removename(
 	 * Calculate sizes.
 	 */
 	byteoff = (int)((char *)sfep - (char *)sfp);
-	entsize = XFS_DIR2_SF_ENTSIZE_BYNAME(sfp, args->namelen);
+	entsize = xfs_dir2_sf_entsize_byname(sfp, args->namelen);
 	newsize = oldsize - entsize;
 	/*
 	 * Copy the part if any after the removed entry, sliding it down.
@@ -1027,7 +1027,7 @@ xfs_dir2_sf_replace(
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	ASSERT(dp->i_d.di_size >= XFS_DIR2_SF_HDR_SIZE(sfp->hdr.i8count));
+	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
 #if XFS_BIG_INUMS
 	/*
 	 * New inode number is large, and need to convert to 8-byte inodes.
@@ -1067,28 +1067,28 @@ xfs_dir2_sf_replace(
 	if (args->namelen == 2 &&
 	    args->name[0] == '.' && args->name[1] == '.') {
 #if XFS_BIG_INUMS || defined(DEBUG)
-		ino = XFS_DIR2_SF_GET_INUMBER(sfp, &sfp->hdr.parent);
+		ino = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
 		ASSERT(args->inumber != ino);
 #endif
-		XFS_DIR2_SF_PUT_INUMBER(sfp, &args->inumber, &sfp->hdr.parent);
+		xfs_dir2_sf_put_inumber(sfp, &args->inumber, &sfp->hdr.parent);
 	}
 	/*
 	 * Normal entry, look for the name.
 	 */
 	else {
-		for (i = 0, sfep = XFS_DIR2_SF_FIRSTENTRY(sfp);
+		for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 		     i < sfp->hdr.count;
-		     i++, sfep = XFS_DIR2_SF_NEXTENTRY(sfp, sfep)) {
+		     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
 			if (sfep->namelen == args->namelen &&
 			    sfep->name[0] == args->name[0] &&
 			    memcmp(args->name, sfep->name, args->namelen) == 0) {
 #if XFS_BIG_INUMS || defined(DEBUG)
-				ino = XFS_DIR2_SF_GET_INUMBER(sfp,
-					XFS_DIR2_SF_INUMBERP(sfep));
+				ino = xfs_dir2_sf_get_inumber(sfp,
+					xfs_dir2_sf_inumberp(sfep));
 				ASSERT(args->inumber != ino);
 #endif
-				XFS_DIR2_SF_PUT_INUMBER(sfp, &args->inumber,
-					XFS_DIR2_SF_INUMBERP(sfep));
+				xfs_dir2_sf_put_inumber(sfp, &args->inumber,
+					xfs_dir2_sf_inumberp(sfep));
 				break;
 			}
 		}
@@ -1189,22 +1189,22 @@ xfs_dir2_sf_toino4(
 	 */
 	sfp->hdr.count = oldsfp->hdr.count;
 	sfp->hdr.i8count = 0;
-	ino = XFS_DIR2_SF_GET_INUMBER(oldsfp, &oldsfp->hdr.parent);
-	XFS_DIR2_SF_PUT_INUMBER(sfp, &ino, &sfp->hdr.parent);
+	ino = xfs_dir2_sf_get_inumber(oldsfp, &oldsfp->hdr.parent);
+	xfs_dir2_sf_put_inumber(sfp, &ino, &sfp->hdr.parent);
 	/*
 	 * Copy the entries field by field.
 	 */
-	for (i = 0, sfep = XFS_DIR2_SF_FIRSTENTRY(sfp),
-		    oldsfep = XFS_DIR2_SF_FIRSTENTRY(oldsfp);
+	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
+		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
 	     i < sfp->hdr.count;
-	     i++, sfep = XFS_DIR2_SF_NEXTENTRY(sfp, sfep),
-		  oldsfep = XFS_DIR2_SF_NEXTENTRY(oldsfp, oldsfep)) {
+	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep),
+		  oldsfep = xfs_dir2_sf_nextentry(oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
 		sfep->offset = oldsfep->offset;
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		ino = XFS_DIR2_SF_GET_INUMBER(oldsfp,
-			XFS_DIR2_SF_INUMBERP(oldsfep));
-		XFS_DIR2_SF_PUT_INUMBER(sfp, &ino, XFS_DIR2_SF_INUMBERP(sfep));
+		ino = xfs_dir2_sf_get_inumber(oldsfp,
+			xfs_dir2_sf_inumberp(oldsfep));
+		xfs_dir2_sf_put_inumber(sfp, &ino, xfs_dir2_sf_inumberp(sfep));
 	}
 	/*
 	 * Clean up the inode.
@@ -1266,22 +1266,22 @@ xfs_dir2_sf_toino8(
 	 */
 	sfp->hdr.count = oldsfp->hdr.count;
 	sfp->hdr.i8count = 1;
-	ino = XFS_DIR2_SF_GET_INUMBER(oldsfp, &oldsfp->hdr.parent);
-	XFS_DIR2_SF_PUT_INUMBER(sfp, &ino, &sfp->hdr.parent);
+	ino = xfs_dir2_sf_get_inumber(oldsfp, &oldsfp->hdr.parent);
+	xfs_dir2_sf_put_inumber(sfp, &ino, &sfp->hdr.parent);
 	/*
 	 * Copy the entries field by field.
 	 */
-	for (i = 0, sfep = XFS_DIR2_SF_FIRSTENTRY(sfp),
-		    oldsfep = XFS_DIR2_SF_FIRSTENTRY(oldsfp);
+	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
+		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
 	     i < sfp->hdr.count;
-	     i++, sfep = XFS_DIR2_SF_NEXTENTRY(sfp, sfep),
-		  oldsfep = XFS_DIR2_SF_NEXTENTRY(oldsfp, oldsfep)) {
+	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep),
+		  oldsfep = xfs_dir2_sf_nextentry(oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
 		sfep->offset = oldsfep->offset;
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		ino = XFS_DIR2_SF_GET_INUMBER(oldsfp,
-			XFS_DIR2_SF_INUMBERP(oldsfep));
-		XFS_DIR2_SF_PUT_INUMBER(sfp, &ino, XFS_DIR2_SF_INUMBERP(sfep));
+		ino = xfs_dir2_sf_get_inumber(oldsfp,
+			xfs_dir2_sf_inumberp(oldsfep));
+		xfs_dir2_sf_put_inumber(sfp, &ino, xfs_dir2_sf_inumberp(sfep));
 	}
 	/*
 	 * Clean up the inode.
Index: linux-2.6/fs/xfs/xfs_dir2_sf.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_sf.h	2007-04-13 13:57:01.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_sf.h	2007-04-13 14:01:37.000000000 +0200
@@ -90,7 +90,6 @@ typedef struct xfs_dir2_sf {
 	xfs_dir2_sf_entry_t	list[1];	/* shortform entries */
 } xfs_dir2_sf_t;
 
-#define	XFS_DIR2_SF_HDR_SIZE(i8count)	xfs_dir2_sf_hdr_size(i8count)
 static inline int xfs_dir2_sf_hdr_size(int i8count)
 {
 	return ((uint)sizeof(xfs_dir2_sf_hdr_t) - \
@@ -98,14 +97,11 @@ static inline int xfs_dir2_sf_hdr_size(i
 		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
 }
 
-#define	XFS_DIR2_SF_INUMBERP(sfep)	xfs_dir2_sf_inumberp(sfep)
 static inline xfs_dir2_inou_t *xfs_dir2_sf_inumberp(xfs_dir2_sf_entry_t *sfep)
 {
 	return (xfs_dir2_inou_t *)&(sfep)->name[(sfep)->namelen];
 }
 
-#define	XFS_DIR2_SF_GET_INUMBER(sfp, from) \
-	xfs_dir2_sf_get_inumber(sfp, from)
 static inline xfs_intino_t
 xfs_dir2_sf_get_inumber(xfs_dir2_sf_t *sfp, xfs_dir2_inou_t *from)
 {
@@ -114,8 +110,6 @@ xfs_dir2_sf_get_inumber(xfs_dir2_sf_t *s
 		(xfs_intino_t)XFS_GET_DIR_INO8((from)->i8));
 }
 
-#define	XFS_DIR2_SF_PUT_INUMBER(sfp,from,to) \
-	xfs_dir2_sf_put_inumber(sfp,from,to)
 static inline void xfs_dir2_sf_put_inumber(xfs_dir2_sf_t *sfp, xfs_ino_t *from,
 						xfs_dir2_inou_t *to)
 {
@@ -125,24 +119,18 @@ static inline void xfs_dir2_sf_put_inumb
 		XFS_PUT_DIR_INO8(*(from), (to)->i8);
 }
 
-#define	XFS_DIR2_SF_GET_OFFSET(sfep)	\
-	xfs_dir2_sf_get_offset(sfep)
 static inline xfs_dir2_data_aoff_t
 xfs_dir2_sf_get_offset(xfs_dir2_sf_entry_t *sfep)
 {
 	return INT_GET_UNALIGNED_16_BE(&(sfep)->offset.i);
 }
 
-#define	XFS_DIR2_SF_PUT_OFFSET(sfep,off) \
-	xfs_dir2_sf_put_offset(sfep,off)
 static inline void
 xfs_dir2_sf_put_offset(xfs_dir2_sf_entry_t *sfep, xfs_dir2_data_aoff_t off)
 {
 	INT_SET_UNALIGNED_16_BE(&(sfep)->offset.i, off);
 }
 
-#define XFS_DIR2_SF_ENTSIZE_BYNAME(sfp,len)	\
-	xfs_dir2_sf_entsize_byname(sfp,len)
 static inline int xfs_dir2_sf_entsize_byname(xfs_dir2_sf_t *sfp, int len)
 {
 	return ((uint)sizeof(xfs_dir2_sf_entry_t) - 1 + (len) - \
@@ -150,8 +138,6 @@ static inline int xfs_dir2_sf_entsize_by
 		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
 }
 
-#define XFS_DIR2_SF_ENTSIZE_BYENTRY(sfp,sfep)	\
-	xfs_dir2_sf_entsize_byentry(sfp,sfep)
 static inline int
 xfs_dir2_sf_entsize_byentry(xfs_dir2_sf_t *sfp, xfs_dir2_sf_entry_t *sfep)
 {
@@ -160,19 +146,17 @@ xfs_dir2_sf_entsize_byentry(xfs_dir2_sf_
 		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
 }
 
-#define XFS_DIR2_SF_FIRSTENTRY(sfp)	xfs_dir2_sf_firstentry(sfp)
 static inline xfs_dir2_sf_entry_t *xfs_dir2_sf_firstentry(xfs_dir2_sf_t *sfp)
 {
 	return ((xfs_dir2_sf_entry_t *) \
-		((char *)(sfp) + XFS_DIR2_SF_HDR_SIZE(sfp->hdr.i8count)));
+		((char *)(sfp) + xfs_dir2_sf_hdr_size(sfp->hdr.i8count)));
 }
 
-#define XFS_DIR2_SF_NEXTENTRY(sfp,sfep)	xfs_dir2_sf_nextentry(sfp,sfep)
 static inline xfs_dir2_sf_entry_t *
 xfs_dir2_sf_nextentry(xfs_dir2_sf_t *sfp, xfs_dir2_sf_entry_t *sfep)
 {
 	return ((xfs_dir2_sf_entry_t *) \
-		((char *)(sfep) + XFS_DIR2_SF_ENTSIZE_BYENTRY(sfp,sfep)));
+		((char *)(sfep) + xfs_dir2_sf_entsize_byentry(sfp,sfep)));
 }
 
 /*
