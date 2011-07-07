Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6kct160005 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1741E176A7FE
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	clAX9F3R0VVQDLSI for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPr-0003wQ-AM
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:43 +0000
Message-Id: <20110707110643.282136589@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:05:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 14/28] xfs: kill struct xfs_dir2_sf
References: <20110707110535.205001532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_dir2_sf_t
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

The list field of it is never cactually used, so all uses can simply be
replaced with the xfs_dir2_sf_hdr_t type that it has as first member.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_dir2.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2.c	2011-07-06 15:29:43.765454583 +0200
+++ xfs/fs/xfs/xfs_dir2.c	2011-07-06 15:29:52.432120812 +0200
@@ -122,15 +122,15 @@ int
 xfs_dir_isempty(
 	xfs_inode_t	*dp)
 {
-	xfs_dir2_sf_t	*sfp;
+	xfs_dir2_sf_hdr_t	*sfp;
 
 	ASSERT((dp->i_d.di_mode & S_IFMT) == S_IFDIR);
 	if (dp->i_d.di_size == 0)	/* might happen during shutdown. */
 		return 1;
 	if (dp->i_d.di_size > XFS_IFORK_DSIZE(dp))
 		return 0;
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	return !sfp->hdr.count;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	return !sfp->count;
 }
 
 /*
Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2011-07-06 15:29:51.568787522 +0200
+++ xfs/fs/xfs/xfs_dir2_block.c	2011-07-06 15:29:52.435454145 +0200
@@ -1028,8 +1028,6 @@ xfs_dir2_sf_to_block(
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
 	xfs_dabuf_t		*bp;		/* block buffer */
 	xfs_dir2_block_tail_t	*btp;		/* block tail pointer */
-	char			*buf;		/* sf buffer */
-	int			buf_len;
 	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			dummy;		/* trash */
@@ -1043,7 +1041,8 @@ xfs_dir2_sf_to_block(
 	int			newoffset;	/* offset from current entry */
 	int			offset;		/* target block offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* sf entry pointer */
-	xfs_dir2_sf_t		*sfp;		/* shortform structure */
+	xfs_dir2_sf_hdr_t	*oldsfp;	/* old shortform header  */
+	xfs_dir2_sf_hdr_t	*sfp;		/* shortform header  */
 	__be16			*tagp;		/* end of data entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_name		name;
@@ -1061,32 +1060,30 @@ xfs_dir2_sf_to_block(
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		return XFS_ERROR(EIO);
 	}
+
+	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
+	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
+
 	/*
-	 * Copy the directory into the stack buffer.
+	 * Copy the directory into a temporary buffer.
 	 * Then pitch the incore inode data so we can make extents.
 	 */
+	sfp = kmem_alloc(dp->i_df.if_bytes, KM_SLEEP);
+	memcpy(sfp, oldsfp, dp->i_df.if_bytes);
 
-	buf_len = dp->i_df.if_bytes;
-	buf = kmem_alloc(buf_len, KM_SLEEP);
-
-	memcpy(buf, sfp, buf_len);
-	xfs_idata_realloc(dp, -buf_len, XFS_DATA_FORK);
+	xfs_idata_realloc(dp, -dp->i_df.if_bytes, XFS_DATA_FORK);
 	dp->i_d.di_size = 0;
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
-	/*
-	 * Reset pointer - old sfp is gone.
-	 */
-	sfp = (xfs_dir2_sf_t *)buf;
+
 	/*
 	 * Add block 0 to the inode.
 	 */
 	error = xfs_dir2_grow_inode(args, XFS_DIR2_DATA_SPACE, &blkno);
 	if (error) {
-		kmem_free(buf);
+		kmem_free(sfp);
 		return error;
 	}
 	/*
@@ -1094,7 +1091,7 @@ xfs_dir2_sf_to_block(
 	 */
 	error = xfs_dir2_data_init(args, blkno, &bp);
 	if (error) {
-		kmem_free(buf);
+		kmem_free(sfp);
 		return error;
 	}
 	block = bp->data;
@@ -1103,7 +1100,7 @@ xfs_dir2_sf_to_block(
 	 * Compute size of block "tail" area.
 	 */
 	i = (uint)sizeof(*btp) +
-	    (sfp->hdr.count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t);
+	    (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t);
 	/*
 	 * The whole thing is initialized to free by the init routine.
 	 * Say we're using the leaf and tail area.
@@ -1117,7 +1114,7 @@ xfs_dir2_sf_to_block(
 	 * Fill in the tail.
 	 */
 	btp = xfs_dir2_block_tail_p(mp, block);
-	btp->count = cpu_to_be32(sfp->hdr.count + 2);	/* ., .. */
+	btp->count = cpu_to_be32(sfp->count + 2);	/* ., .. */
 	btp->stale = 0;
 	blp = xfs_dir2_block_leaf_p(btp);
 	endoffset = (uint)((char *)blp - (char *)block);
@@ -1159,7 +1156,8 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Loop over existing entries, stuff them in.
 	 */
-	if ((i = 0) == sfp->hdr.count)
+	i = 0;
+	if (!sfp->count)
 		sfep = NULL;
 	else
 		sfep = xfs_dir2_sf_firstentry(sfp);
@@ -1208,13 +1206,13 @@ xfs_dir2_sf_to_block(
 		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 						 (char *)dep - (char *)block));
 		offset = (int)((char *)(tagp + 1) - (char *)block);
-		if (++i == sfp->hdr.count)
+		if (++i == sfp->count)
 			sfep = NULL;
 		else
 			sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 	}
 	/* Done with the temporary buffer */
-	kmem_free(buf);
+	kmem_free(sfp);
 	/*
 	 * Sort the leaf entries by hash value.
 	 */
Index: xfs/fs/xfs/xfs_dir2_sf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2011-07-06 15:29:51.565454189 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.c	2011-07-06 15:36:36.195433702 +0200
@@ -67,10 +67,10 @@ static void xfs_dir2_sf_toino8(xfs_da_ar
  */
 static xfs_ino_t
 xfs_dir2_sf_get_ino(
-	struct xfs_dir2_sf	*sfp,
+	struct xfs_dir2_sf_hdr	*hdr,
 	xfs_dir2_inou_t		*from)
 {
-	if (sfp->hdr.i8count)
+	if (hdr->i8count)
 		return XFS_GET_DIR_INO8(from->i8);
 	else
 		return XFS_GET_DIR_INO4(from->i4);
@@ -78,11 +78,11 @@ xfs_dir2_sf_get_ino(
 
 static void
 xfs_dir2_sf_put_ino(
-	struct xfs_dir2_sf	*sfp,
+	struct xfs_dir2_sf_hdr	*hdr,
 	xfs_dir2_inou_t		*to,
 	xfs_ino_t		ino)
 {
-	if (sfp->hdr.i8count)
+	if (hdr->i8count)
 		XFS_PUT_DIR_INO8(ino, to->i8);
 	else
 		XFS_PUT_DIR_INO4(ino, to->i4);
@@ -90,17 +90,17 @@ xfs_dir2_sf_put_ino(
 
 xfs_ino_t
 xfs_dir2_sf_get_parent_ino(
-	struct xfs_dir2_sf	*sfp)
+	struct xfs_dir2_sf_hdr	*hdr)
 {
-	return xfs_dir2_sf_get_ino(sfp, &sfp->hdr.parent);
+	return xfs_dir2_sf_get_ino(hdr, &hdr->parent);
 }
 
 static void
 xfs_dir2_sf_put_parent_ino(
-	struct xfs_dir2_sf	*sfp,
+	struct xfs_dir2_sf_hdr	*hdr,
 	xfs_ino_t		ino)
 {
-	xfs_dir2_sf_put_ino(sfp, &sfp->hdr.parent, ino);
+	xfs_dir2_sf_put_ino(hdr, &hdr->parent, ino);
 }
 
 /*
@@ -117,19 +117,19 @@ xfs_dir2_sfe_inop(
 
 xfs_ino_t
 xfs_dir2_sfe_get_ino(
-	struct xfs_dir2_sf	*sfp,
+	struct xfs_dir2_sf_hdr	*hdr,
 	struct xfs_dir2_sf_entry *sfep)
 {
-	return xfs_dir2_sf_get_ino(sfp, xfs_dir2_sfe_inop(sfep));
+	return xfs_dir2_sf_get_ino(hdr, xfs_dir2_sfe_inop(sfep));
 }
 
 static void
 xfs_dir2_sfe_put_ino(
-	struct xfs_dir2_sf	*sfp,
+	struct xfs_dir2_sf_hdr	*hdr,
 	struct xfs_dir2_sf_entry *sfep,
 	xfs_ino_t		ino)
 {
-	xfs_dir2_sf_put_ino(sfp, xfs_dir2_sfe_inop(sfep), ino);
+	xfs_dir2_sf_put_ino(hdr, xfs_dir2_sfe_inop(sfep), ino);
 }
 
 /*
@@ -211,7 +211,7 @@ xfs_dir2_block_sfsize(
 	 */
 	sfhp->count = count;
 	sfhp->i8count = i8count;
-	xfs_dir2_sf_put_parent_ino((xfs_dir2_sf_t *)sfhp, parent);
+	xfs_dir2_sf_put_parent_ino(sfhp, parent);
 	return size;
 }
 
@@ -237,7 +237,7 @@ xfs_dir2_block_to_sf(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	char			*ptr;		/* current data pointer */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform entry */
-	xfs_dir2_sf_t		*sfp;		/* shortform structure */
+	xfs_dir2_sf_hdr_t	*sfp;		/* shortform directory header */
 
 	trace_xfs_dir2_block_to_sf(args);
 
@@ -270,7 +270,7 @@ xfs_dir2_block_to_sf(
 	/*
 	 * Copy the header into the newly allocate local space.
 	 */
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	memcpy(sfp, sfhp, xfs_dir2_sf_hdr_size(sfhp->i8count));
 	dp->i_d.di_size = size;
 	/*
@@ -349,7 +349,7 @@ xfs_dir2_sf_addname(
 	xfs_dir2_data_aoff_t	offset = 0;	/* offset for new entry */
 	int			old_isize;	/* di_size before adding name */
 	int			pick;		/* which algorithm to use */
-	xfs_dir2_sf_t		*sfp;		/* shortform structure */
+	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 	xfs_dir2_sf_entry_t	*sfep = NULL;	/* shortform entry */
 
 	trace_xfs_dir2_sf_addname(args);
@@ -366,8 +366,8 @@ xfs_dir2_sf_addname(
 	}
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 	/*
 	 * Compute entry (and change in) size.
 	 */
@@ -378,7 +378,7 @@ xfs_dir2_sf_addname(
 	/*
 	 * Do we have to change to 8 byte inodes?
 	 */
-	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->hdr.i8count == 0) {
+	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->i8count == 0) {
 		/*
 		 * Yes, adjust the entry size and the total size.
 		 */
@@ -386,7 +386,7 @@ xfs_dir2_sf_addname(
 			(uint)sizeof(xfs_dir2_ino8_t) -
 			(uint)sizeof(xfs_dir2_ino4_t);
 		incr_isize +=
-			(sfp->hdr.count + 2) *
+			(sfp->count + 2) *
 			((uint)sizeof(xfs_dir2_ino8_t) -
 			 (uint)sizeof(xfs_dir2_ino4_t));
 		objchange = 1;
@@ -456,11 +456,11 @@ xfs_dir2_sf_addname_easy(
 {
 	int			byteoff;	/* byte offset in sf dir */
 	xfs_inode_t		*dp;		/* incore directory inode */
-	xfs_dir2_sf_t		*sfp;		/* shortform structure */
+	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 
 	dp = args->dp;
 
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	byteoff = (int)((char *)sfep - (char *)sfp);
 	/*
 	 * Grow the in-inode space.
@@ -470,7 +470,7 @@ xfs_dir2_sf_addname_easy(
 	/*
 	 * Need to set up again due to realloc of the inode data.
 	 */
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	sfep = (xfs_dir2_sf_entry_t *)((char *)sfp + byteoff);
 	/*
 	 * Fill in the new entry.
@@ -482,10 +482,10 @@ xfs_dir2_sf_addname_easy(
 	/*
 	 * Update the header and inode.
 	 */
-	sfp->hdr.count++;
+	sfp->count++;
 #if XFS_BIG_INUMS
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM)
-		sfp->hdr.i8count++;
+		sfp->i8count++;
 #endif
 	dp->i_d.di_size = new_isize;
 	xfs_dir2_sf_check(args);
@@ -515,19 +515,19 @@ xfs_dir2_sf_addname_hard(
 	xfs_dir2_data_aoff_t	offset;		/* current offset value */
 	int			old_isize;	/* previous di_size */
 	xfs_dir2_sf_entry_t	*oldsfep;	/* entry in original dir */
-	xfs_dir2_sf_t		*oldsfp;	/* original shortform dir */
+	xfs_dir2_sf_hdr_t	*oldsfp;	/* original shortform dir */
 	xfs_dir2_sf_entry_t	*sfep;		/* entry in new dir */
-	xfs_dir2_sf_t		*sfp;		/* new shortform dir */
+	xfs_dir2_sf_hdr_t	*sfp;		/* new shortform dir */
 
 	/*
 	 * Copy the old directory to the stack buffer.
 	 */
 	dp = args->dp;
 
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	old_isize = (int)dp->i_d.di_size;
 	buf = kmem_alloc(old_isize, KM_SLEEP);
-	oldsfp = (xfs_dir2_sf_t *)buf;
+	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
 	memcpy(oldsfp, sfp, old_isize);
 	/*
 	 * Loop over the old directory finding the place we're going
@@ -556,7 +556,7 @@ xfs_dir2_sf_addname_hard(
 	/*
 	 * Reset the pointer since the buffer was reallocated.
 	 */
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	/*
 	 * Copy the first part of the directory, including the header.
 	 */
@@ -570,10 +570,10 @@ xfs_dir2_sf_addname_hard(
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sfe_put_ino(sfp, sfep, args->inumber);
-	sfp->hdr.count++;
+	sfp->count++;
 #if XFS_BIG_INUMS
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
-		sfp->hdr.i8count++;
+		sfp->i8count++;
 #endif
 	/*
 	 * If there's more left to copy, do that.
@@ -607,14 +607,14 @@ xfs_dir2_sf_addname_pick(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_dir2_data_aoff_t	offset;		/* data block offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform entry */
-	xfs_dir2_sf_t		*sfp;		/* shortform structure */
+	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 	int			size;		/* entry's data size */
 	int			used;		/* data bytes used */
 
 	dp = args->dp;
 	mp = dp->i_mount;
 
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	size = xfs_dir2_data_entsize(args->namelen);
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
 	sfep = xfs_dir2_sf_firstentry(sfp);
@@ -624,7 +624,7 @@ xfs_dir2_sf_addname_pick(
 	 * Keep track of data offset and whether we've seen a place
 	 * to insert the new entry.
 	 */
-	for (i = 0; i < sfp->hdr.count; i++) {
+	for (i = 0; i < sfp->count; i++) {
 		if (!holefit)
 			holefit = offset + size <= xfs_dir2_sf_get_offset(sfep);
 		offset = xfs_dir2_sf_get_offset(sfep) +
@@ -636,7 +636,7 @@ xfs_dir2_sf_addname_pick(
 	 * was a data block (block form directory).
 	 */
 	used = offset +
-	       (sfp->hdr.count + 3) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
+	       (sfp->count + 3) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
 	       (uint)sizeof(xfs_dir2_block_tail_t);
 	/*
 	 * If it won't fit in a block form then we can't insert it,
@@ -682,17 +682,17 @@ xfs_dir2_sf_check(
 	xfs_ino_t		ino;		/* entry inode number */
 	int			offset;		/* data offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform dir entry */
-	xfs_dir2_sf_t		*sfp;		/* shortform structure */
+	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 
 	dp = args->dp;
 
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
 	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
-	     i < sfp->hdr.count;
+	     i < sfp->count;
 	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
 		ASSERT(xfs_dir2_sf_get_offset(sfep) >= offset);
 		ino = xfs_dir2_sfe_get_ino(sfp, sfep);
@@ -701,11 +701,11 @@ xfs_dir2_sf_check(
 			xfs_dir2_sf_get_offset(sfep) +
 			xfs_dir2_data_entsize(sfep->namelen);
 	}
-	ASSERT(i8count == sfp->hdr.i8count);
+	ASSERT(i8count == sfp->i8count);
 	ASSERT(XFS_BIG_INUMS || i8count == 0);
 	ASSERT((char *)sfep - (char *)sfp == dp->i_d.di_size);
 	ASSERT(offset +
-	       (sfp->hdr.count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
+	       (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
 	       (uint)sizeof(xfs_dir2_block_tail_t) <=
 	       dp->i_mount->m_dirblksize);
 }
@@ -721,7 +721,7 @@ xfs_dir2_sf_create(
 {
 	xfs_inode_t	*dp;		/* incore directory inode */
 	int		i8count;	/* parent inode is an 8-byte number */
-	xfs_dir2_sf_t	*sfp;		/* shortform structure */
+	xfs_dir2_sf_hdr_t *sfp;		/* shortform structure */
 	int		size;		/* directory size */
 
 	trace_xfs_dir2_sf_create(args);
@@ -751,13 +751,13 @@ xfs_dir2_sf_create(
 	/*
 	 * Fill in the header,
 	 */
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	sfp->hdr.i8count = i8count;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	sfp->i8count = i8count;
 	/*
 	 * Now can put in the inode number, since i8count is set.
 	 */
 	xfs_dir2_sf_put_parent_ino(sfp, pino);
-	sfp->hdr.count = 0;
+	sfp->count = 0;
 	dp->i_d.di_size = size;
 	xfs_dir2_sf_check(args);
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
@@ -775,7 +775,7 @@ xfs_dir2_sf_getdents(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_dir2_dataptr_t	off;		/* current entry's offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
-	xfs_dir2_sf_t		*sfp;		/* shortform structure */
+	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 	xfs_dir2_dataptr_t	dot_offset;
 	xfs_dir2_dataptr_t	dotdot_offset;
 	xfs_ino_t		ino;
@@ -794,9 +794,9 @@ xfs_dir2_sf_getdents(
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 
-	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
+	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 
 	/*
 	 * If the block number in the offset is out of range, we're done.
@@ -840,7 +840,7 @@ xfs_dir2_sf_getdents(
 	 * Loop while there are more entries and put'ing works.
 	 */
 	sfep = xfs_dir2_sf_firstentry(sfp);
-	for (i = 0; i < sfp->hdr.count; i++) {
+	for (i = 0; i < sfp->count; i++) {
 		off = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 				xfs_dir2_sf_get_offset(sfep));
 
@@ -875,7 +875,7 @@ xfs_dir2_sf_lookup(
 	int			i;		/* entry index */
 	int			error;
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
-	xfs_dir2_sf_t		*sfp;		/* shortform structure */
+	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 	enum xfs_dacmp		cmp;		/* comparison result */
 	xfs_dir2_sf_entry_t	*ci_sfep;	/* case-insens. entry */
 
@@ -894,8 +894,8 @@ xfs_dir2_sf_lookup(
 	}
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 	/*
 	 * Special case for .
 	 */
@@ -917,7 +917,7 @@ xfs_dir2_sf_lookup(
 	 * Loop over all the entries trying to match ours.
 	 */
 	ci_sfep = NULL;
-	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->hdr.count;
+	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
 				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
 		/*
 		 * Compare name and if it's an exact match, return the inode
@@ -960,7 +960,7 @@ xfs_dir2_sf_removename(
 	int			newsize;	/* new inode size */
 	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
-	xfs_dir2_sf_t		*sfp;		/* shortform structure */
+	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 
 	trace_xfs_dir2_sf_removename(args);
 
@@ -977,13 +977,13 @@ xfs_dir2_sf_removename(
 	}
 	ASSERT(dp->i_df.if_bytes == oldsize);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	ASSERT(oldsize >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	ASSERT(oldsize >= xfs_dir2_sf_hdr_size(sfp->i8count));
 	/*
 	 * Loop over the old directory entries.
 	 * Find the one we're deleting.
 	 */
-	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->hdr.count;
+	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
 				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
 		if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
@@ -995,7 +995,7 @@ xfs_dir2_sf_removename(
 	/*
 	 * Didn't find it.
 	 */
-	if (i == sfp->hdr.count)
+	if (i == sfp->count)
 		return XFS_ERROR(ENOENT);
 	/*
 	 * Calculate sizes.
@@ -1012,22 +1012,22 @@ xfs_dir2_sf_removename(
 	/*
 	 * Fix up the header and file size.
 	 */
-	sfp->hdr.count--;
+	sfp->count--;
 	dp->i_d.di_size = newsize;
 	/*
 	 * Reallocate, making it smaller.
 	 */
 	xfs_idata_realloc(dp, newsize - oldsize, XFS_DATA_FORK);
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 #if XFS_BIG_INUMS
 	/*
 	 * Are we changing inode number size?
 	 */
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM) {
-		if (sfp->hdr.i8count == 1)
+		if (sfp->i8count == 1)
 			xfs_dir2_sf_toino4(args);
 		else
-			sfp->hdr.i8count--;
+			sfp->i8count--;
 	}
 #endif
 	xfs_dir2_sf_check(args);
@@ -1051,7 +1051,7 @@ xfs_dir2_sf_replace(
 	int			i8elevated;	/* sf_toino8 set i8count=1 */
 #endif
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
-	xfs_dir2_sf_t		*sfp;		/* shortform structure */
+	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 
 	trace_xfs_dir2_sf_replace(args);
 
@@ -1067,19 +1067,19 @@ xfs_dir2_sf_replace(
 	}
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->hdr.i8count));
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 #if XFS_BIG_INUMS
 	/*
 	 * New inode number is large, and need to convert to 8-byte inodes.
 	 */
-	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->hdr.i8count == 0) {
+	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->i8count == 0) {
 		int	error;			/* error return value */
 		int	newsize;		/* new inode size */
 
 		newsize =
 			dp->i_df.if_bytes +
-			(sfp->hdr.count + 1) *
+			(sfp->count + 1) *
 			((uint)sizeof(xfs_dir2_ino8_t) -
 			 (uint)sizeof(xfs_dir2_ino4_t));
 		/*
@@ -1097,7 +1097,7 @@ xfs_dir2_sf_replace(
 		 */
 		xfs_dir2_sf_toino8(args);
 		i8elevated = 1;
-		sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
+		sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	} else
 		i8elevated = 0;
 #endif
@@ -1118,7 +1118,7 @@ xfs_dir2_sf_replace(
 	 */
 	else {
 		for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
-				i < sfp->hdr.count;
+				i < sfp->count;
 				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
 			if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
@@ -1133,7 +1133,7 @@ xfs_dir2_sf_replace(
 		/*
 		 * Didn't find it.
 		 */
-		if (i == sfp->hdr.count) {
+		if (i == sfp->count) {
 			ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
 #if XFS_BIG_INUMS
 			if (i8elevated)
@@ -1151,10 +1151,10 @@ xfs_dir2_sf_replace(
 		/*
 		 * And the old count was one, so need to convert to small.
 		 */
-		if (sfp->hdr.i8count == 1)
+		if (sfp->i8count == 1)
 			xfs_dir2_sf_toino4(args);
 		else
-			sfp->hdr.i8count--;
+			sfp->i8count--;
 	}
 	/*
 	 * See if the old number was small, the new number is large.
@@ -1165,9 +1165,9 @@ xfs_dir2_sf_replace(
 		 * add to the i8count unless we just converted to 8-byte
 		 * inodes (which does an implied i8count = 1)
 		 */
-		ASSERT(sfp->hdr.i8count != 0);
+		ASSERT(sfp->i8count != 0);
 		if (!i8elevated)
-			sfp->hdr.i8count++;
+			sfp->i8count++;
 	}
 #endif
 	xfs_dir2_sf_check(args);
@@ -1189,10 +1189,10 @@ xfs_dir2_sf_toino4(
 	int			i;		/* entry index */
 	int			newsize;	/* new inode size */
 	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
-	xfs_dir2_sf_t		*oldsfp;	/* old sf directory */
+	xfs_dir2_sf_hdr_t	*oldsfp;	/* old sf directory */
 	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
-	xfs_dir2_sf_t		*sfp;		/* new sf directory */
+	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
 
 	trace_xfs_dir2_sf_toino4(args);
 
@@ -1205,35 +1205,35 @@ xfs_dir2_sf_toino4(
 	 */
 	oldsize = dp->i_df.if_bytes;
 	buf = kmem_alloc(oldsize, KM_SLEEP);
-	oldsfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	ASSERT(oldsfp->hdr.i8count == 1);
+	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	ASSERT(oldsfp->i8count == 1);
 	memcpy(buf, oldsfp, oldsize);
 	/*
 	 * Compute the new inode size.
 	 */
 	newsize =
 		oldsize -
-		(oldsfp->hdr.count + 1) *
+		(oldsfp->count + 1) *
 		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t));
 	xfs_idata_realloc(dp, -oldsize, XFS_DATA_FORK);
 	xfs_idata_realloc(dp, newsize, XFS_DATA_FORK);
 	/*
 	 * Reset our pointers, the data has moved.
 	 */
-	oldsfp = (xfs_dir2_sf_t *)buf;
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
+	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	/*
 	 * Fill in the new header.
 	 */
-	sfp->hdr.count = oldsfp->hdr.count;
-	sfp->hdr.i8count = 0;
+	sfp->count = oldsfp->count;
+	sfp->i8count = 0;
 	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
 	/*
 	 * Copy the entries field by field.
 	 */
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
 		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
-	     i < sfp->hdr.count;
+	     i < sfp->count;
 	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep),
 		  oldsfep = xfs_dir2_sf_nextentry(oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
@@ -1264,10 +1264,10 @@ xfs_dir2_sf_toino8(
 	int			i;		/* entry index */
 	int			newsize;	/* new inode size */
 	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
-	xfs_dir2_sf_t		*oldsfp;	/* old sf directory */
+	xfs_dir2_sf_hdr_t	*oldsfp;	/* old sf directory */
 	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
-	xfs_dir2_sf_t		*sfp;		/* new sf directory */
+	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
 
 	trace_xfs_dir2_sf_toino8(args);
 
@@ -1280,35 +1280,35 @@ xfs_dir2_sf_toino8(
 	 */
 	oldsize = dp->i_df.if_bytes;
 	buf = kmem_alloc(oldsize, KM_SLEEP);
-	oldsfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
-	ASSERT(oldsfp->hdr.i8count == 0);
+	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	ASSERT(oldsfp->i8count == 0);
 	memcpy(buf, oldsfp, oldsize);
 	/*
 	 * Compute the new inode size.
 	 */
 	newsize =
 		oldsize +
-		(oldsfp->hdr.count + 1) *
+		(oldsfp->count + 1) *
 		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t));
 	xfs_idata_realloc(dp, -oldsize, XFS_DATA_FORK);
 	xfs_idata_realloc(dp, newsize, XFS_DATA_FORK);
 	/*
 	 * Reset our pointers, the data has moved.
 	 */
-	oldsfp = (xfs_dir2_sf_t *)buf;
-	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
+	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
+	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	/*
 	 * Fill in the new header.
 	 */
-	sfp->hdr.count = oldsfp->hdr.count;
-	sfp->hdr.i8count = 1;
+	sfp->count = oldsfp->count;
+	sfp->i8count = 1;
 	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
 	/*
 	 * Copy the entries field by field.
 	 */
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
 		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
-	     i < sfp->hdr.count;
+	     i < sfp->count;
 	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep),
 		  oldsfep = xfs_dir2_sf_nextentry(oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
Index: xfs/fs/xfs/xfs_dir2_sf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.h	2011-07-06 15:29:51.565454189 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.h	2011-07-06 15:36:36.208767034 +0200
@@ -21,8 +21,12 @@
 /*
  * Directory layout when stored internal to an inode.
  *
- * Small directories are packed as tightly as possible so as to
- * fit into the literal area of the inode.
+ * Small directories are packed as tightly as possible so as to fit into the
+ * literal area of the inode.  They consist of a single xfs_dir2_sf_hdr header
+ * followed by zero or more xfs_dir2_sf_entry structures.  Due the different
+ * inode number storage size and the variable length name field in
+ * the xfs_dir2_sf_entry all these structure are variable length, and the
+ * accessors in this file should be used to iterate over them.
  */
 
 struct uio;
@@ -61,9 +65,9 @@ typedef struct { __uint8_t i[2]; } __arc
  * The parent directory has a dedicated field, and the self-pointer must
  * be calculated on the fly.
  *
- * Entries are packed toward the top as tightly as possible.  The header
- * and the elements must be memcpy'd out into a work area to get correct
- * alignment for the inode number fields.
+ * Entries are packed toward the top as tightly as possible, and thus may
+ * be misaligned.  Care needs to be taken to access them through special
+ * helpers or copy them into aligned variables first.
  */
 typedef struct xfs_dir2_sf_hdr {
 	__uint8_t		count;		/* count of entries */
@@ -78,11 +82,6 @@ typedef struct xfs_dir2_sf_entry {
 	xfs_dir2_inou_t		inumber;	/* inode number, var. offset */
 } __arch_pack xfs_dir2_sf_entry_t; 
 
-typedef struct xfs_dir2_sf {
-	xfs_dir2_sf_hdr_t	hdr;		/* shortform header */
-	xfs_dir2_sf_entry_t	list[1];	/* shortform entries */
-} xfs_dir2_sf_t;
-
 static inline int xfs_dir2_sf_hdr_size(int i8count)
 {
 	return ((uint)sizeof(xfs_dir2_sf_hdr_t) - \
@@ -102,39 +101,41 @@ xfs_dir2_sf_put_offset(xfs_dir2_sf_entry
 	INT_SET_UNALIGNED_16_BE(&(sfep)->offset.i, off);
 }
 
-static inline int xfs_dir2_sf_entsize_byname(xfs_dir2_sf_t *sfp, int len)
+static inline int xfs_dir2_sf_entsize_byname(xfs_dir2_sf_hdr_t *sfp, int len)
 {
 	return ((uint)sizeof(xfs_dir2_sf_entry_t) - 1 + (len) - \
-		((sfp)->hdr.i8count == 0) * \
+		((sfp)->i8count == 0) * \
 		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
 }
 
 static inline int
-xfs_dir2_sf_entsize_byentry(xfs_dir2_sf_t *sfp, xfs_dir2_sf_entry_t *sfep)
+xfs_dir2_sf_entsize_byentry(xfs_dir2_sf_hdr_t *sfp, xfs_dir2_sf_entry_t *sfep)
 {
 	return ((uint)sizeof(xfs_dir2_sf_entry_t) - 1 + (sfep)->namelen - \
-		((sfp)->hdr.i8count == 0) * \
+		((sfp)->i8count == 0) * \
 		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
 }
 
-static inline xfs_dir2_sf_entry_t *xfs_dir2_sf_firstentry(xfs_dir2_sf_t *sfp)
+static inline struct xfs_dir2_sf_entry *
+xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
 {
-	return ((xfs_dir2_sf_entry_t *) \
-		((char *)(sfp) + xfs_dir2_sf_hdr_size(sfp->hdr.i8count)));
+	return (struct xfs_dir2_sf_entry *)
+		((char *)hdr + xfs_dir2_sf_hdr_size(hdr->i8count));
 }
 
-static inline xfs_dir2_sf_entry_t *
-xfs_dir2_sf_nextentry(xfs_dir2_sf_t *sfp, xfs_dir2_sf_entry_t *sfep)
+static inline struct xfs_dir2_sf_entry *
+xfs_dir2_sf_nextentry(struct xfs_dir2_sf_hdr *hdr,
+		struct xfs_dir2_sf_entry *sfep)
 {
-	return ((xfs_dir2_sf_entry_t *) \
-		((char *)(sfep) + xfs_dir2_sf_entsize_byentry(sfp,sfep)));
+	return (struct xfs_dir2_sf_entry *)
+		((char *)sfep + xfs_dir2_sf_entsize_byentry(hdr, sfep));
 }
 
 /*
  * Functions.
  */
-extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf *sfp);
-extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf *sfp,
+extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
+extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf_hdr *sfp,
 				      struct xfs_dir2_sf_entry *sfep);
 extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
 				 struct xfs_dir2_block *block,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
