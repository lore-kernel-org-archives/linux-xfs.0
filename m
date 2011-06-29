Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TE3hqX104921 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 09:03:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27314409E5
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 07:03:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	hcr2HW9U4qBeGb9i for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 07:03:40 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QbvMi-0008Ji-8z
	for xfs@oss.sgi.com; Wed, 29 Jun 2011 14:03:40 +0000
Message-Id: <20110629140340.246204787@bombadil.infradead.org>
Date: Wed, 29 Jun 2011 10:01:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 19/27] xfs: avoid usage of struct xfs_dir2_data
References: <20110629140109.003209430@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-avoid-xfs_dir2_data_t
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
which is the first and most important member of struct xfs_dir2_data instead
of the full structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2011-06-27 10:47:35.889487280 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2011-06-27 10:51:33.638199284 +0200
@@ -2079,16 +2079,13 @@ xfs_da_do_buf(
 	 * For read_buf, check the magic number.
 	 */
 	if (caller == 1) {
-		xfs_dir2_data_t		*data;
-		xfs_dir2_free_t		*free;
-		xfs_da_blkinfo_t	*info;
+		xfs_dir2_data_hdr_t	*hdr = rbp->data;
+		xfs_dir2_free_t		*free = rbp->data;
+		xfs_da_blkinfo_t	*info = rbp->data;
 		uint			magic, magic1;
 
-		info = rbp->data;
-		data = rbp->data;
-		free = rbp->data;
 		magic = be16_to_cpu(info->magic);
-		magic1 = be32_to_cpu(data->hdr.magic);
+		magic1 = be32_to_cpu(hdr->magic);
 		if (unlikely(
 		    XFS_TEST_ERROR((magic != XFS_DA_NODE_MAGIC) &&
 				   (magic != XFS_ATTR_LEAF_MAGIC) &&
Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2011-06-27 10:49:37.012164015 +0200
+++ xfs/fs/xfs/xfs_dir2_block.c	2011-06-27 10:51:33.641532599 +0200
@@ -282,7 +282,7 @@ xfs_dir2_block_addname(
 		 * This needs to happen before the next call to use_free.
 		 */
 		if (needscan) {
-			xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)hdr, &needlog);
+			xfs_dir2_data_freescan(mp, hdr, &needlog);
 			needscan = 0;
 		}
 	}
@@ -331,8 +331,7 @@ xfs_dir2_block_addname(
 		 * This needs to happen before the next call to use_free.
 		 */
 		if (needscan) {
-			xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)hdr,
-				&needlog);
+			xfs_dir2_data_freescan(mp, hdr, &needlog);
 			needscan = 0;
 		}
 		/*
@@ -417,7 +416,7 @@ xfs_dir2_block_addname(
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)hdr, &needlog);
+		xfs_dir2_data_freescan(mp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, bp);
 	xfs_dir2_block_log_tail(tp, bp);
@@ -783,7 +782,7 @@ xfs_dir2_block_removename(
 	 * Fix up bestfree, log the header if necessary.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)hdr, &needlog);
+		xfs_dir2_data_freescan(mp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, bp);
 	xfs_dir2_data_check(dp, bp);
@@ -982,7 +981,7 @@ xfs_dir2_leaf_to_block(
 	 * Scan the bestfree if we need it and log the data block header.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)hdr, &needlog);
+		xfs_dir2_data_freescan(mp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
 	/*
@@ -1177,8 +1176,7 @@ xfs_dir2_sf_to_block(
 			*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16(
 				((char *)dup - (char *)hdr));
 			xfs_dir2_data_log_unused(tp, bp, dup);
-			(void)xfs_dir2_data_freeinsert((xfs_dir2_data_t *)hdr,
-				dup, &dummy);
+			(void)xfs_dir2_data_freeinsert(hdr, dup, &dummy);
 			offset += be16_to_cpu(dup->length);
 			continue;
 		}
Index: xfs/fs/xfs/xfs_dir2_data.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_data.c	2011-06-27 10:47:35.909487170 +0200
+++ xfs/fs/xfs/xfs_dir2_data.c	2011-06-27 10:51:33.644865914 +0200
@@ -35,6 +35,9 @@
 #include "xfs_dir2_block.h"
 #include "xfs_error.h"
 
+STATIC xfs_dir2_data_free_t *
+xfs_dir2_data_freefind(xfs_dir2_data_hdr_t *hdr, xfs_dir2_data_unused_t *dup);
+
 #ifdef DEBUG
 /*
  * Check the consistency of the data block.
@@ -51,6 +54,7 @@ xfs_dir2_data_check(
 	xfs_dir2_block_tail_t	*btp=NULL;	/* block tail */
 	int			count;		/* count of entries found */
 	xfs_dir2_data_t		*d;		/* data block pointer */
+	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_data_entry_t	*dep;		/* data entry */
 	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry */
@@ -67,16 +71,19 @@ xfs_dir2_data_check(
 
 	mp = dp->i_mount;
 	d = bp->data;
-	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
-	bf = d->hdr.bestfree;
+	hdr = &d->hdr;
+	bf = hdr->bestfree;
 	p = (char *)d->u;
-	if (be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
-		btp = xfs_dir2_block_tail_p(mp, &d->hdr);
+
+	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
+		btp = xfs_dir2_block_tail_p(mp, hdr);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endp = (char *)lep;
-	} else
-		endp = (char *)d + mp->m_dirblksize;
+	} else {
+		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC));
+		endp = (char *)hdr + mp->m_dirblksize;
+	}
+
 	count = lastfree = freeseen = 0;
 	/*
 	 * Account for zero bestfree entries.
@@ -108,8 +115,8 @@ xfs_dir2_data_check(
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			ASSERT(lastfree == 0);
 			ASSERT(be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) ==
-			       (char *)dup - (char *)d);
-			dfp = xfs_dir2_data_freefind(d, dup);
+			       (char *)dup - (char *)hdr);
+			dfp = xfs_dir2_data_freefind(hdr, dup);
 			if (dfp) {
 				i = (int)(dfp - bf);
 				ASSERT((freeseen & (1 << i)) == 0);
@@ -132,13 +139,13 @@ xfs_dir2_data_check(
 		ASSERT(dep->namelen != 0);
 		ASSERT(xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)) == 0);
 		ASSERT(be16_to_cpu(*xfs_dir2_data_entry_tag_p(dep)) ==
-		       (char *)dep - (char *)d);
+		       (char *)dep - (char *)hdr);
 		count++;
 		lastfree = 0;
-		if (be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
+		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
 			addr = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 				(xfs_dir2_data_aoff_t)
-				((char *)dep - (char *)d));
+				((char *)dep - (char *)hdr));
 			name.name = dep->name;
 			name.len = dep->namelen;
 			hash = mp->m_dirnameops->hashname(&name);
@@ -155,7 +162,7 @@ xfs_dir2_data_check(
 	 * Need to have seen all the entries and all the bestfree slots.
 	 */
 	ASSERT(freeseen == 7);
-	if (be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
+	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
 		for (i = stale = 0; i < be32_to_cpu(btp->count); i++) {
 			if (be32_to_cpu(lep[i].address) == XFS_DIR2_NULL_DATAPTR)
 				stale++;
@@ -172,9 +179,9 @@ xfs_dir2_data_check(
  * Given a data block and an unused entry from that block,
  * return the bestfree entry if any that corresponds to it.
  */
-xfs_dir2_data_free_t *
+STATIC xfs_dir2_data_free_t *
 xfs_dir2_data_freefind(
-	xfs_dir2_data_t		*d,		/* data block */
+	xfs_dir2_data_hdr_t	*hdr,		/* data block */
 	xfs_dir2_data_unused_t	*dup)		/* data unused entry */
 {
 	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
@@ -184,17 +191,17 @@ xfs_dir2_data_freefind(
 	int			seenzero;	/* saw a 0 bestfree entry */
 #endif
 
-	off = (xfs_dir2_data_aoff_t)((char *)dup - (char *)d);
+	off = (xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr);
 #if defined(DEBUG) && defined(__KERNEL__)
 	/*
 	 * Validate some consistency in the bestfree table.
 	 * Check order, non-overlapping entries, and if we find the
 	 * one we're looking for it has to be exact.
 	 */
-	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
-	for (dfp = &d->hdr.bestfree[0], seenzero = matched = 0;
-	     dfp < &d->hdr.bestfree[XFS_DIR2_DATA_FD_COUNT];
+	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
+	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
+	for (dfp = &hdr->bestfree[0], seenzero = matched = 0;
+	     dfp < &hdr->bestfree[XFS_DIR2_DATA_FD_COUNT];
 	     dfp++) {
 		if (!dfp->offset) {
 			ASSERT(!dfp->length);
@@ -210,7 +217,7 @@ xfs_dir2_data_freefind(
 		else
 			ASSERT(be16_to_cpu(dfp->offset) + be16_to_cpu(dfp->length) <= off);
 		ASSERT(matched || be16_to_cpu(dfp->length) >= be16_to_cpu(dup->length));
-		if (dfp > &d->hdr.bestfree[0])
+		if (dfp > &hdr->bestfree[0])
 			ASSERT(be16_to_cpu(dfp[-1].length) >= be16_to_cpu(dfp[0].length));
 	}
 #endif
@@ -219,13 +226,13 @@ xfs_dir2_data_freefind(
 	 * it can't be there since they're sorted.
 	 */
 	if (be16_to_cpu(dup->length) <
-	    be16_to_cpu(d->hdr.bestfree[XFS_DIR2_DATA_FD_COUNT - 1].length))
+	    be16_to_cpu(hdr->bestfree[XFS_DIR2_DATA_FD_COUNT - 1].length))
 		return NULL;
 	/*
 	 * Look at the three bestfree entries for our guy.
 	 */
-	for (dfp = &d->hdr.bestfree[0];
-	     dfp < &d->hdr.bestfree[XFS_DIR2_DATA_FD_COUNT];
+	for (dfp = &hdr->bestfree[0];
+	     dfp < &hdr->bestfree[XFS_DIR2_DATA_FD_COUNT];
 	     dfp++) {
 		if (!dfp->offset)
 			return NULL;
@@ -243,7 +250,7 @@ xfs_dir2_data_freefind(
  */
 xfs_dir2_data_free_t *				/* entry inserted */
 xfs_dir2_data_freeinsert(
-	xfs_dir2_data_t		*d,		/* data block pointer */
+	xfs_dir2_data_hdr_t	*hdr,		/* data block pointer */
 	xfs_dir2_data_unused_t	*dup,		/* unused space */
 	int			*loghead)	/* log the data header (out) */
 {
@@ -251,12 +258,13 @@ xfs_dir2_data_freeinsert(
 	xfs_dir2_data_free_t	new;		/* new bestfree entry */
 
 #ifdef __KERNEL__
-	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
+	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
 #endif
-	dfp = d->hdr.bestfree;
+	dfp = hdr->bestfree;
 	new.length = dup->length;
-	new.offset = cpu_to_be16((char *)dup - (char *)d);
+	new.offset = cpu_to_be16((char *)dup - (char *)hdr);
+
 	/*
 	 * Insert at position 0, 1, or 2; or not at all.
 	 */
@@ -286,36 +294,36 @@ xfs_dir2_data_freeinsert(
  */
 STATIC void
 xfs_dir2_data_freeremove(
-	xfs_dir2_data_t		*d,		/* data block pointer */
+	xfs_dir2_data_hdr_t	*hdr,		/* data block header */
 	xfs_dir2_data_free_t	*dfp,		/* bestfree entry pointer */
 	int			*loghead)	/* out: log data header */
 {
 #ifdef __KERNEL__
-	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
+	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
 #endif
 	/*
 	 * It's the first entry, slide the next 2 up.
 	 */
-	if (dfp == &d->hdr.bestfree[0]) {
-		d->hdr.bestfree[0] = d->hdr.bestfree[1];
-		d->hdr.bestfree[1] = d->hdr.bestfree[2];
+	if (dfp == &hdr->bestfree[0]) {
+		hdr->bestfree[0] = hdr->bestfree[1];
+		hdr->bestfree[1] = hdr->bestfree[2];
 	}
 	/*
 	 * It's the second entry, slide the 3rd entry up.
 	 */
-	else if (dfp == &d->hdr.bestfree[1])
-		d->hdr.bestfree[1] = d->hdr.bestfree[2];
+	else if (dfp == &hdr->bestfree[1])
+		hdr->bestfree[1] = hdr->bestfree[2];
 	/*
 	 * Must be the last entry.
 	 */
 	else
-		ASSERT(dfp == &d->hdr.bestfree[2]);
+		ASSERT(dfp == &hdr->bestfree[2]);
 	/*
 	 * Clear the 3rd entry, must be zero now.
 	 */
-	d->hdr.bestfree[2].length = 0;
-	d->hdr.bestfree[2].offset = 0;
+	hdr->bestfree[2].length = 0;
+	hdr->bestfree[2].offset = 0;
 	*loghead = 1;
 }
 
@@ -325,9 +333,10 @@ xfs_dir2_data_freeremove(
 void
 xfs_dir2_data_freescan(
 	xfs_mount_t		*mp,		/* filesystem mount point */
-	xfs_dir2_data_t		*d,		/* data block pointer */
+	xfs_dir2_data_hdr_t	*hdr,		/* data block header */
 	int			*loghead)	/* out: log data header */
 {
+	xfs_dir2_data_t		*d = (xfs_dir2_data_t *)hdr;
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* active data entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused data entry */
@@ -335,23 +344,23 @@ xfs_dir2_data_freescan(
 	char			*p;		/* current entry pointer */
 
 #ifdef __KERNEL__
-	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 #endif
 	/*
 	 * Start by clearing the table.
 	 */
-	memset(d->hdr.bestfree, 0, sizeof(d->hdr.bestfree));
+	memset(hdr->bestfree, 0, sizeof(hdr->bestfree));
 	*loghead = 1;
 	/*
 	 * Set up pointers.
 	 */
 	p = (char *)d->u;
-	if (be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
-		btp = xfs_dir2_block_tail_p(mp, &d->hdr);
+	if (be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC) {
+		btp = xfs_dir2_block_tail_p(mp, hdr);
 		endp = (char *)xfs_dir2_block_leaf_p(btp);
 	} else
-		endp = (char *)d + mp->m_dirblksize;
+		endp = (char *)hdr + mp->m_dirblksize;
 	/*
 	 * Loop over the block's entries.
 	 */
@@ -361,9 +370,9 @@ xfs_dir2_data_freescan(
 		 * If it's a free entry, insert it.
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			ASSERT((char *)dup - (char *)d ==
+			ASSERT((char *)dup - (char *)hdr ==
 			       be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)));
-			xfs_dir2_data_freeinsert(d, dup, loghead);
+			xfs_dir2_data_freeinsert(hdr, dup, loghead);
 			p += be16_to_cpu(dup->length);
 		}
 		/*
@@ -371,7 +380,7 @@ xfs_dir2_data_freescan(
 		 */
 		else {
 			dep = (xfs_dir2_data_entry_t *)p;
-			ASSERT((char *)dep - (char *)d ==
+			ASSERT((char *)dep - (char *)hdr ==
 			       be16_to_cpu(*xfs_dir2_data_entry_tag_p(dep)));
 			p += xfs_dir2_data_entsize(dep->namelen);
 		}
@@ -390,6 +399,7 @@ xfs_dir2_data_init(
 {
 	xfs_dabuf_t		*bp;		/* block buffer */
 	xfs_dir2_data_t		*d;		/* pointer to block */
+	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry pointer */
 	int			error;		/* error return value */
@@ -410,26 +420,29 @@ xfs_dir2_data_init(
 		return error;
 	}
 	ASSERT(bp != NULL);
+
 	/*
 	 * Initialize the header.
 	 */
 	d = bp->data;
-	d->hdr.magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
-	d->hdr.bestfree[0].offset = cpu_to_be16(sizeof(d->hdr));
+	hdr = &d->hdr;
+	hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
+	hdr->bestfree[0].offset = cpu_to_be16(sizeof(*hdr));
 	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
-		d->hdr.bestfree[i].length = 0;
-		d->hdr.bestfree[i].offset = 0;
+		hdr->bestfree[i].length = 0;
+		hdr->bestfree[i].offset = 0;
 	}
+
 	/*
 	 * Set up an unused entry for the block's body.
 	 */
 	dup = &d->u[0].unused;
 	dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 
-	t=mp->m_dirblksize - (uint)sizeof(d->hdr);
-	d->hdr.bestfree[0].length = cpu_to_be16(t);
+	t = mp->m_dirblksize - (uint)sizeof(*hdr);
+	hdr->bestfree[0].length = cpu_to_be16(t);
 	dup->length = cpu_to_be16(t);
-	*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16((char *)dup - (char *)d);
+	*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16((char *)dup - (char *)hdr);
 	/*
 	 * Log it and return it.
 	 */
@@ -448,14 +461,14 @@ xfs_dir2_data_log_entry(
 	xfs_dabuf_t		*bp,		/* block buffer */
 	xfs_dir2_data_entry_t	*dep)		/* data entry pointer */
 {
-	xfs_dir2_data_t		*d;		/* data block pointer */
+	xfs_dir2_data_hdr_t	*hdr = bp->data;
 
-	d = bp->data;
-	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
-	xfs_da_log_buf(tp, bp, (uint)((char *)dep - (char *)d),
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
+
+	xfs_da_log_buf(tp, bp, (uint)((char *)dep - (char *)hdr),
 		(uint)((char *)(xfs_dir2_data_entry_tag_p(dep) + 1) -
-		       (char *)d - 1));
+		       (char *)hdr - 1));
 }
 
 /*
@@ -466,13 +479,12 @@ xfs_dir2_data_log_header(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_dabuf_t		*bp)		/* block buffer */
 {
-	xfs_dir2_data_t		*d;		/* data block pointer */
+	xfs_dir2_data_hdr_t	*hdr = bp->data;
 
-	d = bp->data;
-	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
-	xfs_da_log_buf(tp, bp, (uint)((char *)&d->hdr - (char *)d),
-		(uint)(sizeof(d->hdr) - 1));
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
+
+	xfs_da_log_buf(tp, bp, 0, sizeof(*hdr) - 1);
 }
 
 /*
@@ -484,23 +496,23 @@ xfs_dir2_data_log_unused(
 	xfs_dabuf_t		*bp,		/* block buffer */
 	xfs_dir2_data_unused_t	*dup)		/* data unused pointer */
 {
-	xfs_dir2_data_t		*d;		/* data block pointer */
+	xfs_dir2_data_hdr_t	*hdr = bp->data;
+
+	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
+	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
 
-	d = bp->data;
-	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
 	/*
 	 * Log the first part of the unused entry.
 	 */
-	xfs_da_log_buf(tp, bp, (uint)((char *)dup - (char *)d),
+	xfs_da_log_buf(tp, bp, (uint)((char *)dup - (char *)hdr),
 		(uint)((char *)&dup->length + sizeof(dup->length) -
-		       1 - (char *)d));
+		       1 - (char *)hdr));
 	/*
 	 * Log the end (tag) of the unused entry.
 	 */
 	xfs_da_log_buf(tp, bp,
-		(uint)((char *)xfs_dir2_data_unused_tag_p(dup) - (char *)d),
-		(uint)((char *)xfs_dir2_data_unused_tag_p(dup) - (char *)d +
+		(uint)((char *)xfs_dir2_data_unused_tag_p(dup) - (char *)hdr),
+		(uint)((char *)xfs_dir2_data_unused_tag_p(dup) - (char *)hdr +
 		       sizeof(xfs_dir2_data_off_t) - 1));
 }
 
@@ -517,7 +529,7 @@ xfs_dir2_data_make_free(
 	int			*needlogp,	/* out: log header */
 	int			*needscanp)	/* out: regen bestfree */
 {
-	xfs_dir2_data_t		*d;		/* data block pointer */
+	xfs_dir2_data_hdr_t	*hdr;		/* data block pointer */
 	xfs_dir2_data_free_t	*dfp;		/* bestfree pointer */
 	char			*endptr;	/* end of data area */
 	xfs_mount_t		*mp;		/* filesystem mount point */
@@ -527,28 +539,29 @@ xfs_dir2_data_make_free(
 	xfs_dir2_data_unused_t	*prevdup;	/* unused entry before us */
 
 	mp = tp->t_mountp;
-	d = bp->data;
+	hdr = bp->data;
+
 	/*
 	 * Figure out where the end of the data area is.
 	 */
-	if (be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC)
-		endptr = (char *)d + mp->m_dirblksize;
+	if (hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC))
+		endptr = (char *)hdr + mp->m_dirblksize;
 	else {
 		xfs_dir2_block_tail_t	*btp;	/* block tail */
 
-		ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
-		btp = xfs_dir2_block_tail_p(mp, &d->hdr);
+		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC));
+		btp = xfs_dir2_block_tail_p(mp, hdr);
 		endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	}
 	/*
 	 * If this isn't the start of the block, then back up to
 	 * the previous entry and see if it's free.
 	 */
-	if (offset > sizeof(d->hdr)) {
+	if (offset > sizeof(*hdr)) {
 		__be16			*tagp;	/* tag just before us */
 
-		tagp = (__be16 *)((char *)d + offset) - 1;
-		prevdup = (xfs_dir2_data_unused_t *)((char *)d + be16_to_cpu(*tagp));
+		tagp = (__be16 *)((char *)hdr + offset) - 1;
+		prevdup = (xfs_dir2_data_unused_t *)((char *)hdr + be16_to_cpu(*tagp));
 		if (be16_to_cpu(prevdup->freetag) != XFS_DIR2_DATA_FREE_TAG)
 			prevdup = NULL;
 	} else
@@ -557,9 +570,9 @@ xfs_dir2_data_make_free(
 	 * If this isn't the end of the block, see if the entry after
 	 * us is free.
 	 */
-	if ((char *)d + offset + len < endptr) {
+	if ((char *)hdr + offset + len < endptr) {
 		postdup =
-			(xfs_dir2_data_unused_t *)((char *)d + offset + len);
+			(xfs_dir2_data_unused_t *)((char *)hdr + offset + len);
 		if (be16_to_cpu(postdup->freetag) != XFS_DIR2_DATA_FREE_TAG)
 			postdup = NULL;
 	} else
@@ -576,21 +589,21 @@ xfs_dir2_data_make_free(
 		/*
 		 * See if prevdup and/or postdup are in bestfree table.
 		 */
-		dfp = xfs_dir2_data_freefind(d, prevdup);
-		dfp2 = xfs_dir2_data_freefind(d, postdup);
+		dfp = xfs_dir2_data_freefind(hdr, prevdup);
+		dfp2 = xfs_dir2_data_freefind(hdr, postdup);
 		/*
 		 * We need a rescan unless there are exactly 2 free entries
 		 * namely our two.  Then we know what's happening, otherwise
 		 * since the third bestfree is there, there might be more
 		 * entries.
 		 */
-		needscan = (d->hdr.bestfree[2].length != 0);
+		needscan = (hdr->bestfree[2].length != 0);
 		/*
 		 * Fix up the new big freespace.
 		 */
 		be16_add_cpu(&prevdup->length, len + be16_to_cpu(postdup->length));
 		*xfs_dir2_data_unused_tag_p(prevdup) =
-			cpu_to_be16((char *)prevdup - (char *)d);
+			cpu_to_be16((char *)prevdup - (char *)hdr);
 		xfs_dir2_data_log_unused(tp, bp, prevdup);
 		if (!needscan) {
 			/*
@@ -600,18 +613,18 @@ xfs_dir2_data_make_free(
 			 * Remove entry 1 first then entry 0.
 			 */
 			ASSERT(dfp && dfp2);
-			if (dfp == &d->hdr.bestfree[1]) {
-				dfp = &d->hdr.bestfree[0];
+			if (dfp == &hdr->bestfree[1]) {
+				dfp = &hdr->bestfree[0];
 				ASSERT(dfp2 == dfp);
-				dfp2 = &d->hdr.bestfree[1];
+				dfp2 = &hdr->bestfree[1];
 			}
-			xfs_dir2_data_freeremove(d, dfp2, needlogp);
-			xfs_dir2_data_freeremove(d, dfp, needlogp);
+			xfs_dir2_data_freeremove(hdr, dfp2, needlogp);
+			xfs_dir2_data_freeremove(hdr, dfp, needlogp);
 			/*
 			 * Now insert the new entry.
 			 */
-			dfp = xfs_dir2_data_freeinsert(d, prevdup, needlogp);
-			ASSERT(dfp == &d->hdr.bestfree[0]);
+			dfp = xfs_dir2_data_freeinsert(hdr, prevdup, needlogp);
+			ASSERT(dfp == &hdr->bestfree[0]);
 			ASSERT(dfp->length == prevdup->length);
 			ASSERT(!dfp[1].length);
 			ASSERT(!dfp[2].length);
@@ -621,10 +634,10 @@ xfs_dir2_data_make_free(
 	 * The entry before us is free, merge with it.
 	 */
 	else if (prevdup) {
-		dfp = xfs_dir2_data_freefind(d, prevdup);
+		dfp = xfs_dir2_data_freefind(hdr, prevdup);
 		be16_add_cpu(&prevdup->length, len);
 		*xfs_dir2_data_unused_tag_p(prevdup) =
-			cpu_to_be16((char *)prevdup - (char *)d);
+			cpu_to_be16((char *)prevdup - (char *)hdr);
 		xfs_dir2_data_log_unused(tp, bp, prevdup);
 		/*
 		 * If the previous entry was in the table, the new entry
@@ -632,27 +645,27 @@ xfs_dir2_data_make_free(
 		 * the old one and add the new one.
 		 */
 		if (dfp) {
-			xfs_dir2_data_freeremove(d, dfp, needlogp);
-			(void)xfs_dir2_data_freeinsert(d, prevdup, needlogp);
+			xfs_dir2_data_freeremove(hdr, dfp, needlogp);
+			(void)xfs_dir2_data_freeinsert(hdr, prevdup, needlogp);
 		}
 		/*
 		 * Otherwise we need a scan if the new entry is big enough.
 		 */
 		else {
 			needscan = be16_to_cpu(prevdup->length) >
-				   be16_to_cpu(d->hdr.bestfree[2].length);
+				   be16_to_cpu(hdr->bestfree[2].length);
 		}
 	}
 	/*
 	 * The following entry is free, merge with it.
 	 */
 	else if (postdup) {
-		dfp = xfs_dir2_data_freefind(d, postdup);
-		newdup = (xfs_dir2_data_unused_t *)((char *)d + offset);
+		dfp = xfs_dir2_data_freefind(hdr, postdup);
+		newdup = (xfs_dir2_data_unused_t *)((char *)hdr + offset);
 		newdup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 		newdup->length = cpu_to_be16(len + be16_to_cpu(postdup->length));
 		*xfs_dir2_data_unused_tag_p(newdup) =
-			cpu_to_be16((char *)newdup - (char *)d);
+			cpu_to_be16((char *)newdup - (char *)hdr);
 		xfs_dir2_data_log_unused(tp, bp, newdup);
 		/*
 		 * If the following entry was in the table, the new entry
@@ -660,28 +673,28 @@ xfs_dir2_data_make_free(
 		 * the old one and add the new one.
 		 */
 		if (dfp) {
-			xfs_dir2_data_freeremove(d, dfp, needlogp);
-			(void)xfs_dir2_data_freeinsert(d, newdup, needlogp);
+			xfs_dir2_data_freeremove(hdr, dfp, needlogp);
+			(void)xfs_dir2_data_freeinsert(hdr, newdup, needlogp);
 		}
 		/*
 		 * Otherwise we need a scan if the new entry is big enough.
 		 */
 		else {
 			needscan = be16_to_cpu(newdup->length) >
-				   be16_to_cpu(d->hdr.bestfree[2].length);
+				   be16_to_cpu(hdr->bestfree[2].length);
 		}
 	}
 	/*
 	 * Neither neighbor is free.  Make a new entry.
 	 */
 	else {
-		newdup = (xfs_dir2_data_unused_t *)((char *)d + offset);
+		newdup = (xfs_dir2_data_unused_t *)((char *)hdr + offset);
 		newdup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 		newdup->length = cpu_to_be16(len);
 		*xfs_dir2_data_unused_tag_p(newdup) =
-			cpu_to_be16((char *)newdup - (char *)d);
+			cpu_to_be16((char *)newdup - (char *)hdr);
 		xfs_dir2_data_log_unused(tp, bp, newdup);
-		(void)xfs_dir2_data_freeinsert(d, newdup, needlogp);
+		(void)xfs_dir2_data_freeinsert(hdr, newdup, needlogp);
 	}
 	*needscanp = needscan;
 }
@@ -699,7 +712,7 @@ xfs_dir2_data_use_free(
 	int			*needlogp,	/* out: need to log header */
 	int			*needscanp)	/* out: need regen bestfree */
 {
-	xfs_dir2_data_t		*d;		/* data block */
+	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_data_free_t	*dfp;		/* bestfree pointer */
 	int			matchback;	/* matches end of freespace */
 	int			matchfront;	/* matches start of freespace */
@@ -708,24 +721,24 @@ xfs_dir2_data_use_free(
 	xfs_dir2_data_unused_t	*newdup2;	/* another new unused entry */
 	int			oldlen;		/* old unused entry's length */
 
-	d = bp->data;
-	ASSERT(be32_to_cpu(d->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
-	       be32_to_cpu(d->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
+	hdr = bp->data;
+	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC ||
+	       be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC);
 	ASSERT(be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG);
-	ASSERT(offset >= (char *)dup - (char *)d);
-	ASSERT(offset + len <= (char *)dup + be16_to_cpu(dup->length) - (char *)d);
-	ASSERT((char *)dup - (char *)d == be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)));
+	ASSERT(offset >= (char *)dup - (char *)hdr);
+	ASSERT(offset + len <= (char *)dup + be16_to_cpu(dup->length) - (char *)hdr);
+	ASSERT((char *)dup - (char *)hdr == be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)));
 	/*
 	 * Look up the entry in the bestfree table.
 	 */
-	dfp = xfs_dir2_data_freefind(d, dup);
+	dfp = xfs_dir2_data_freefind(hdr, dup);
 	oldlen = be16_to_cpu(dup->length);
-	ASSERT(dfp || oldlen <= be16_to_cpu(d->hdr.bestfree[2].length));
+	ASSERT(dfp || oldlen <= be16_to_cpu(hdr->bestfree[2].length));
 	/*
 	 * Check for alignment with front and back of the entry.
 	 */
-	matchfront = (char *)dup - (char *)d == offset;
-	matchback = (char *)dup + oldlen - (char *)d == offset + len;
+	matchfront = (char *)dup - (char *)hdr == offset;
+	matchback = (char *)dup + oldlen - (char *)hdr == offset + len;
 	ASSERT(*needscanp == 0);
 	needscan = 0;
 	/*
@@ -734,9 +747,9 @@ xfs_dir2_data_use_free(
 	 */
 	if (matchfront && matchback) {
 		if (dfp) {
-			needscan = (d->hdr.bestfree[2].offset != 0);
+			needscan = (hdr->bestfree[2].offset != 0);
 			if (!needscan)
-				xfs_dir2_data_freeremove(d, dfp, needlogp);
+				xfs_dir2_data_freeremove(hdr, dfp, needlogp);
 		}
 	}
 	/*
@@ -744,27 +757,27 @@ xfs_dir2_data_use_free(
 	 * Make a new entry with the remaining freespace.
 	 */
 	else if (matchfront) {
-		newdup = (xfs_dir2_data_unused_t *)((char *)d + offset + len);
+		newdup = (xfs_dir2_data_unused_t *)((char *)hdr + offset + len);
 		newdup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 		newdup->length = cpu_to_be16(oldlen - len);
 		*xfs_dir2_data_unused_tag_p(newdup) =
-			cpu_to_be16((char *)newdup - (char *)d);
+			cpu_to_be16((char *)newdup - (char *)hdr);
 		xfs_dir2_data_log_unused(tp, bp, newdup);
 		/*
 		 * If it was in the table, remove it and add the new one.
 		 */
 		if (dfp) {
-			xfs_dir2_data_freeremove(d, dfp, needlogp);
-			dfp = xfs_dir2_data_freeinsert(d, newdup, needlogp);
+			xfs_dir2_data_freeremove(hdr, dfp, needlogp);
+			dfp = xfs_dir2_data_freeinsert(hdr, newdup, needlogp);
 			ASSERT(dfp != NULL);
 			ASSERT(dfp->length == newdup->length);
-			ASSERT(be16_to_cpu(dfp->offset) == (char *)newdup - (char *)d);
+			ASSERT(be16_to_cpu(dfp->offset) == (char *)newdup - (char *)hdr);
 			/*
 			 * If we got inserted at the last slot,
 			 * that means we don't know if there was a better
 			 * choice for the last slot, or not.  Rescan.
 			 */
-			needscan = dfp == &d->hdr.bestfree[2];
+			needscan = dfp == &hdr->bestfree[2];
 		}
 	}
 	/*
@@ -773,25 +786,25 @@ xfs_dir2_data_use_free(
 	 */
 	else if (matchback) {
 		newdup = dup;
-		newdup->length = cpu_to_be16(((char *)d + offset) - (char *)newdup);
+		newdup->length = cpu_to_be16(((char *)hdr + offset) - (char *)newdup);
 		*xfs_dir2_data_unused_tag_p(newdup) =
-			cpu_to_be16((char *)newdup - (char *)d);
+			cpu_to_be16((char *)newdup - (char *)hdr);
 		xfs_dir2_data_log_unused(tp, bp, newdup);
 		/*
 		 * If it was in the table, remove it and add the new one.
 		 */
 		if (dfp) {
-			xfs_dir2_data_freeremove(d, dfp, needlogp);
-			dfp = xfs_dir2_data_freeinsert(d, newdup, needlogp);
+			xfs_dir2_data_freeremove(hdr, dfp, needlogp);
+			dfp = xfs_dir2_data_freeinsert(hdr, newdup, needlogp);
 			ASSERT(dfp != NULL);
 			ASSERT(dfp->length == newdup->length);
-			ASSERT(be16_to_cpu(dfp->offset) == (char *)newdup - (char *)d);
+			ASSERT(be16_to_cpu(dfp->offset) == (char *)newdup - (char *)hdr);
 			/*
 			 * If we got inserted at the last slot,
 			 * that means we don't know if there was a better
 			 * choice for the last slot, or not.  Rescan.
 			 */
-			needscan = dfp == &d->hdr.bestfree[2];
+			needscan = dfp == &hdr->bestfree[2];
 		}
 	}
 	/*
@@ -800,15 +813,15 @@ xfs_dir2_data_use_free(
 	 */
 	else {
 		newdup = dup;
-		newdup->length = cpu_to_be16(((char *)d + offset) - (char *)newdup);
+		newdup->length = cpu_to_be16(((char *)hdr + offset) - (char *)newdup);
 		*xfs_dir2_data_unused_tag_p(newdup) =
-			cpu_to_be16((char *)newdup - (char *)d);
+			cpu_to_be16((char *)newdup - (char *)hdr);
 		xfs_dir2_data_log_unused(tp, bp, newdup);
-		newdup2 = (xfs_dir2_data_unused_t *)((char *)d + offset + len);
+		newdup2 = (xfs_dir2_data_unused_t *)((char *)hdr + offset + len);
 		newdup2->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 		newdup2->length = cpu_to_be16(oldlen - len - be16_to_cpu(newdup->length));
 		*xfs_dir2_data_unused_tag_p(newdup2) =
-			cpu_to_be16((char *)newdup2 - (char *)d);
+			cpu_to_be16((char *)newdup2 - (char *)hdr);
 		xfs_dir2_data_log_unused(tp, bp, newdup2);
 		/*
 		 * If the old entry was in the table, we need to scan
@@ -819,12 +832,12 @@ xfs_dir2_data_use_free(
 		 * the 2 new will work.
 		 */
 		if (dfp) {
-			needscan = (d->hdr.bestfree[2].length != 0);
+			needscan = (hdr->bestfree[2].length != 0);
 			if (!needscan) {
-				xfs_dir2_data_freeremove(d, dfp, needlogp);
-				(void)xfs_dir2_data_freeinsert(d, newdup,
+				xfs_dir2_data_freeremove(hdr, dfp, needlogp);
+				(void)xfs_dir2_data_freeinsert(hdr, newdup,
 					needlogp);
-				(void)xfs_dir2_data_freeinsert(d, newdup2,
+				(void)xfs_dir2_data_freeinsert(hdr, newdup2,
 					needlogp);
 			}
 		}
Index: xfs/fs/xfs/xfs_dir2_data.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_data.h	2011-06-27 10:47:35.919487117 +0200
+++ xfs/fs/xfs/xfs_dir2_data.h	2011-06-27 10:51:33.644865914 +0200
@@ -157,12 +157,10 @@ extern void xfs_dir2_data_check(struct x
 #else
 #define	xfs_dir2_data_check(dp,bp)
 #endif
-extern xfs_dir2_data_free_t *xfs_dir2_data_freefind(xfs_dir2_data_t *d,
-				xfs_dir2_data_unused_t *dup);
-extern xfs_dir2_data_free_t *xfs_dir2_data_freeinsert(xfs_dir2_data_t *d,
+extern xfs_dir2_data_free_t *xfs_dir2_data_freeinsert(xfs_dir2_data_hdr_t *hdr,
 				xfs_dir2_data_unused_t *dup, int *loghead);
-extern void xfs_dir2_data_freescan(struct xfs_mount *mp, xfs_dir2_data_t *d,
-				int *loghead);
+extern void xfs_dir2_data_freescan(struct xfs_mount *mp,
+				xfs_dir2_data_hdr_t *hdr, int *loghead);
 extern int xfs_dir2_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
 				struct xfs_dabuf **bpp);
 extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_dabuf *bp,
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-06-27 10:47:35.932820377 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-06-27 10:51:33.648199229 +0200
@@ -132,7 +132,7 @@ xfs_dir2_block_to_leaf(
 	 */
 	hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 	if (needscan)
-		xfs_dir2_data_freescan(mp, (xfs_dir2_data_t *)hdr, &needlog);
+		xfs_dir2_data_freescan(mp, hdr, &needlog);
 	/*
 	 * Set up leaf tail and bests table.
 	 */
@@ -273,7 +273,7 @@ xfs_dir2_leaf_addname(
 {
 	__be16			*bestsp;	/* freespace table in leaf */
 	int			compact;	/* need to compact leaves */
-	xfs_dir2_data_t		*data;		/* data block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dabuf_t		*dbp;		/* data block buffer */
 	xfs_dir2_data_entry_t	*dep;		/* data block entry */
 	xfs_inode_t		*dp;		/* incore directory inode */
@@ -481,8 +481,8 @@ xfs_dir2_leaf_addname(
 		 */
 		else
 			xfs_dir2_leaf_log_bests(tp, lbp, use_block, use_block);
-		data = dbp->data;
-		bestsp[use_block] = data->hdr.bestfree[0].length;
+		hdr = dbp->data;
+		bestsp[use_block] = hdr->bestfree[0].length;
 		grown = 1;
 	}
 	/*
@@ -496,7 +496,7 @@ xfs_dir2_leaf_addname(
 			xfs_da_brelse(tp, lbp);
 			return error;
 		}
-		data = dbp->data;
+		hdr = dbp->data;
 		grown = 0;
 	}
 	xfs_dir2_data_check(dp, dbp);
@@ -504,14 +504,14 @@ xfs_dir2_leaf_addname(
 	 * Point to the biggest freespace in our data block.
 	 */
 	dup = (xfs_dir2_data_unused_t *)
-	      ((char *)data + be16_to_cpu(data->hdr.bestfree[0].offset));
+	      ((char *)hdr + be16_to_cpu(hdr->bestfree[0].offset));
 	ASSERT(be16_to_cpu(dup->length) >= length);
 	needscan = needlog = 0;
 	/*
 	 * Mark the initial part of our freespace in use for the new entry.
 	 */
 	xfs_dir2_data_use_free(tp, dbp, dup,
-		(xfs_dir2_data_aoff_t)((char *)dup - (char *)data), length,
+		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr), length,
 		&needlog, &needscan);
 	/*
 	 * Initialize our new entry (at last).
@@ -521,12 +521,12 @@ xfs_dir2_leaf_addname(
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
 	tagp = xfs_dir2_data_entry_tag_p(dep);
-	*tagp = cpu_to_be16((char *)dep - (char *)data);
+	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, data, &needlog);
+		xfs_dir2_data_freescan(mp, hdr, &needlog);
 	/*
 	 * Need to log the data block's header.
 	 */
@@ -537,8 +537,8 @@ xfs_dir2_leaf_addname(
 	 * If the bests table needs to be changed, do it.
 	 * Log the change unless we've already done that.
 	 */
-	if (be16_to_cpu(bestsp[use_block]) != be16_to_cpu(data->hdr.bestfree[0].length)) {
-		bestsp[use_block] = data->hdr.bestfree[0].length;
+	if (be16_to_cpu(bestsp[use_block]) != be16_to_cpu(hdr->bestfree[0].length)) {
+		bestsp[use_block] = hdr->bestfree[0].length;
 		if (!grown)
 			xfs_dir2_leaf_log_bests(tp, lbp, use_block, use_block);
 	}
@@ -782,6 +782,7 @@ xfs_dir2_leaf_getdents(
 	xfs_dir2_db_t		curdb;		/* db for current block */
 	xfs_dir2_off_t		curoff;		/* current overall offset */
 	xfs_dir2_data_t		*data;		/* data block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_data_entry_t	*dep;		/* data entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry */
 	int			error = 0;	/* error return value */
@@ -1040,6 +1041,7 @@ xfs_dir2_leaf_getdents(
 				ASSERT(xfs_dir2_byte_to_db(mp, curoff) ==
 				       curdb);
 			data = bp->data;
+			hdr = &data->hdr;
 			xfs_dir2_data_check(dp, bp);
 			/*
 			 * Find our position in the block.
@@ -1050,12 +1052,12 @@ xfs_dir2_leaf_getdents(
 			 * Skip past the header.
 			 */
 			if (byteoff == 0)
-				curoff += (uint)sizeof(data->hdr);
+				curoff += (uint)sizeof(*hdr);
 			/*
 			 * Skip past entries until we reach our offset.
 			 */
 			else {
-				while ((char *)ptr - (char *)data < byteoff) {
+				while ((char *)ptr - (char *)hdr < byteoff) {
 					dup = (xfs_dir2_data_unused_t *)ptr;
 
 					if (be16_to_cpu(dup->freetag)
@@ -1076,8 +1078,8 @@ xfs_dir2_leaf_getdents(
 				curoff =
 					xfs_dir2_db_off_to_byte(mp,
 					    xfs_dir2_byte_to_db(mp, curoff),
-					    (char *)ptr - (char *)data);
-				if (ptr >= (char *)data + mp->m_dirblksize) {
+					    (char *)ptr - (char *)hdr);
+				if (ptr >= (char *)hdr + mp->m_dirblksize) {
 					continue;
 				}
 			}
@@ -1458,7 +1460,7 @@ xfs_dir2_leaf_removename(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
 	__be16			*bestsp;	/* leaf block best freespace */
-	xfs_dir2_data_t		*data;		/* data block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_db_t		db;		/* data block number */
 	xfs_dabuf_t		*dbp;		/* data block buffer */
 	xfs_dir2_data_entry_t	*dep;		/* data entry structure */
@@ -1488,7 +1490,7 @@ xfs_dir2_leaf_removename(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = lbp->data;
-	data = dbp->data;
+	hdr = dbp->data;
 	xfs_dir2_data_check(dp, dbp);
 	/*
 	 * Point to the leaf entry, use that to point to the data entry.
@@ -1496,9 +1498,9 @@ xfs_dir2_leaf_removename(
 	lep = &leaf->ents[index];
 	db = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
 	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)data + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
+	      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
 	needscan = needlog = 0;
-	oldbest = be16_to_cpu(data->hdr.bestfree[0].length);
+	oldbest = be16_to_cpu(hdr->bestfree[0].length);
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	ASSERT(be16_to_cpu(bestsp[db]) == oldbest);
@@ -1506,7 +1508,7 @@ xfs_dir2_leaf_removename(
 	 * Mark the former data entry unused.
 	 */
 	xfs_dir2_data_make_free(tp, dbp,
-		(xfs_dir2_data_aoff_t)((char *)dep - (char *)data),
+		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
 		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
 	/*
 	 * We just mark the leaf entry stale by putting a null in it.
@@ -1520,23 +1522,23 @@ xfs_dir2_leaf_removename(
 	 * log the data block header if necessary.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, data, &needlog);
+		xfs_dir2_data_freescan(mp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
 	/*
 	 * If the longest freespace in the data block has changed,
 	 * put the new value in the bests table and log that.
 	 */
-	if (be16_to_cpu(data->hdr.bestfree[0].length) != oldbest) {
-		bestsp[db] = data->hdr.bestfree[0].length;
+	if (be16_to_cpu(hdr->bestfree[0].length) != oldbest) {
+		bestsp[db] = hdr->bestfree[0].length;
 		xfs_dir2_leaf_log_bests(tp, lbp, db, db);
 	}
 	xfs_dir2_data_check(dp, dbp);
 	/*
 	 * If the data block is now empty then get rid of the data block.
 	 */
-	if (be16_to_cpu(data->hdr.bestfree[0].length) ==
-	    mp->m_dirblksize - (uint)sizeof(data->hdr)) {
+	if (be16_to_cpu(hdr->bestfree[0].length) ==
+	    mp->m_dirblksize - (uint)sizeof(*hdr)) {
 		ASSERT(db != mp->m_dirdatablk);
 		if ((error = xfs_dir2_shrink_inode(args, db, dbp))) {
 			/*
@@ -1707,9 +1709,6 @@ xfs_dir2_leaf_trim_data(
 	xfs_dir2_db_t		db)		/* data block number */
 {
 	__be16			*bestsp;	/* leaf bests table */
-#ifdef DEBUG
-	xfs_dir2_data_t		*data;		/* data block structure */
-#endif
 	xfs_dabuf_t		*dbp;		/* data block buffer */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return value */
@@ -1728,20 +1727,21 @@ xfs_dir2_leaf_trim_data(
 			XFS_DATA_FORK))) {
 		return error;
 	}
-#ifdef DEBUG
-	data = dbp->data;
-	ASSERT(be32_to_cpu(data->hdr.magic) == XFS_DIR2_DATA_MAGIC);
-#endif
-	/* this seems to be an error
-	 * data is only valid if DEBUG is defined?
-	 * RMC 09/08/1999
-	 */
 
 	leaf = lbp->data;
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
-	ASSERT(be16_to_cpu(data->hdr.bestfree[0].length) ==
-	       mp->m_dirblksize - (uint)sizeof(data->hdr));
+
+#ifdef DEBUG
+{
+	struct xfs_dir2_data_hdr *hdr = dbp->data;
+
+	ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC);
+	ASSERT(be16_to_cpu(hdr->bestfree[0].length) ==
+	       mp->m_dirblksize - (uint)sizeof(*hdr));
 	ASSERT(db == be32_to_cpu(ltp->bestcount) - 1);
+}
+#endif
+
 	/*
 	 * Get rid of the data block.
 	 */
Index: xfs/fs/xfs/xfs_dir2_node.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_node.c	2011-06-27 10:47:35.946153639 +0200
+++ xfs/fs/xfs/xfs_dir2_node.c	2011-06-27 10:51:33.648199229 +0200
@@ -843,7 +843,7 @@ xfs_dir2_leafn_remove(
 	xfs_da_state_blk_t	*dblk,		/* data block */
 	int			*rval)		/* resulting block needs join */
 {
-	xfs_dir2_data_t		*data;		/* data block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_db_t		db;		/* data block number */
 	xfs_dabuf_t		*dbp;		/* data block buffer */
 	xfs_dir2_data_entry_t	*dep;		/* data block entry */
@@ -888,9 +888,9 @@ xfs_dir2_leafn_remove(
 	 * in the data block in case it changes.
 	 */
 	dbp = dblk->bp;
-	data = dbp->data;
-	dep = (xfs_dir2_data_entry_t *)((char *)data + off);
-	longest = be16_to_cpu(data->hdr.bestfree[0].length);
+	hdr = dbp->data;
+	dep = (xfs_dir2_data_entry_t *)((char *)hdr + off);
+	longest = be16_to_cpu(hdr->bestfree[0].length);
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(tp, dbp, off,
 		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
@@ -899,7 +899,7 @@ xfs_dir2_leafn_remove(
 	 * Log the data block header if needed.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, data, &needlog);
+		xfs_dir2_data_freescan(mp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
 	xfs_dir2_data_check(dp, dbp);
@@ -907,7 +907,7 @@ xfs_dir2_leafn_remove(
 	 * If the longest data block freespace changes, need to update
 	 * the corresponding freeblock entry.
 	 */
-	if (longest < be16_to_cpu(data->hdr.bestfree[0].length)) {
+	if (longest < be16_to_cpu(hdr->bestfree[0].length)) {
 		int		error;		/* error return value */
 		xfs_dabuf_t	*fbp;		/* freeblock buffer */
 		xfs_dir2_db_t	fdb;		/* freeblock block number */
@@ -933,19 +933,19 @@ xfs_dir2_leafn_remove(
 		 * Calculate which entry we need to fix.
 		 */
 		findex = xfs_dir2_db_to_fdindex(mp, db);
-		longest = be16_to_cpu(data->hdr.bestfree[0].length);
+		longest = be16_to_cpu(hdr->bestfree[0].length);
 		/*
 		 * If the data block is now empty we can get rid of it
 		 * (usually).
 		 */
-		if (longest == mp->m_dirblksize - (uint)sizeof(data->hdr)) {
+		if (longest == mp->m_dirblksize - (uint)sizeof(*hdr)) {
 			/*
 			 * Try to punch out the data block.
 			 */
 			error = xfs_dir2_shrink_inode(args, db, dbp);
 			if (error == 0) {
 				dblk->bp = NULL;
-				data = NULL;
+				hdr = NULL;
 			}
 			/*
 			 * We can get ENOSPC if there's no space reservation.
@@ -961,7 +961,7 @@ xfs_dir2_leafn_remove(
 		 * If we got rid of the data block, we can eliminate that entry
 		 * in the free block.
 		 */
-		if (data == NULL) {
+		if (hdr == NULL) {
 			/*
 			 * One less used entry in the free table.
 			 */
@@ -1357,7 +1357,7 @@ xfs_dir2_node_addname_int(
 	xfs_da_args_t		*args,		/* operation arguments */
 	xfs_da_state_blk_t	*fblk)		/* optional freespace block */
 {
-	xfs_dir2_data_t		*data;		/* data block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_db_t		dbno;		/* data block number */
 	xfs_dabuf_t		*dbp;		/* data block buffer */
 	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
@@ -1642,8 +1642,8 @@ xfs_dir2_node_addname_int(
 		 * We haven't allocated the data entry yet so this will
 		 * change again.
 		 */
-		data = dbp->data;
-		free->bests[findex] = data->hdr.bestfree[0].length;
+		hdr = dbp->data;
+		free->bests[findex] = hdr->bestfree[0].length;
 		logfree = 1;
 	}
 	/*
@@ -1668,21 +1668,21 @@ xfs_dir2_node_addname_int(
 				xfs_da_buf_done(fbp);
 			return error;
 		}
-		data = dbp->data;
+		hdr = dbp->data;
 		logfree = 0;
 	}
-	ASSERT(be16_to_cpu(data->hdr.bestfree[0].length) >= length);
+	ASSERT(be16_to_cpu(hdr->bestfree[0].length) >= length);
 	/*
 	 * Point to the existing unused space.
 	 */
 	dup = (xfs_dir2_data_unused_t *)
-	      ((char *)data + be16_to_cpu(data->hdr.bestfree[0].offset));
+	      ((char *)hdr + be16_to_cpu(hdr->bestfree[0].offset));
 	needscan = needlog = 0;
 	/*
 	 * Mark the first part of the unused space, inuse for us.
 	 */
 	xfs_dir2_data_use_free(tp, dbp, dup,
-		(xfs_dir2_data_aoff_t)((char *)dup - (char *)data), length,
+		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr), length,
 		&needlog, &needscan);
 	/*
 	 * Fill in the new entry and log it.
@@ -1692,13 +1692,13 @@ xfs_dir2_node_addname_int(
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
 	tagp = xfs_dir2_data_entry_tag_p(dep);
-	*tagp = cpu_to_be16((char *)dep - (char *)data);
+	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, dbp, dep);
 	/*
 	 * Rescan the block for bestfree if needed.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, data, &needlog);
+		xfs_dir2_data_freescan(mp, hdr, &needlog);
 	/*
 	 * Log the data block header if needed.
 	 */
@@ -1707,8 +1707,8 @@ xfs_dir2_node_addname_int(
 	/*
 	 * If the freespace entry is now wrong, update it.
 	 */
-	if (be16_to_cpu(free->bests[findex]) != be16_to_cpu(data->hdr.bestfree[0].length)) {
-		free->bests[findex] = data->hdr.bestfree[0].length;
+	if (be16_to_cpu(free->bests[findex]) != be16_to_cpu(hdr->bestfree[0].length)) {
+		free->bests[findex] = hdr->bestfree[0].length;
 		logfree = 1;
 	}
 	/*
@@ -1858,7 +1858,7 @@ xfs_dir2_node_replace(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
 	xfs_da_state_blk_t	*blk;		/* leaf block */
-	xfs_dir2_data_t		*data;		/* data block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_data_entry_t	*dep;		/* data entry changed */
 	int			error;		/* error return value */
 	int			i;		/* btree level */
@@ -1902,10 +1902,10 @@ xfs_dir2_node_replace(
 		/*
 		 * Point to the data entry.
 		 */
-		data = state->extrablk.bp->data;
-		ASSERT(be32_to_cpu(data->hdr.magic) == XFS_DIR2_DATA_MAGIC);
+		hdr = state->extrablk.bp->data;
+		ASSERT(be32_to_cpu(hdr->magic) == XFS_DIR2_DATA_MAGIC);
 		dep = (xfs_dir2_data_entry_t *)
-		      ((char *)data +
+		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(state->mp, be32_to_cpu(lep->address)));
 		ASSERT(inum != be64_to_cpu(dep->inumber));
 		/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
