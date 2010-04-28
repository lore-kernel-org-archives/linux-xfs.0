Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SCSBuB232823 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:28:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 484C2154E9C5
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IKfGbR8IGRBX1zWP for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O76P9-0000oQ-KX
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 12:30:15 +0000
Message-Id: <20100428123015.526545338@bombadil.infradead.org>
Date: Wed, 28 Apr 2010 08:28:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/11] xfs: kill struct xfs_iomap
References: <20100428122850.075189557@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-cleanup-6
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

Now that struct xfs_iomap contains exactly the same units as
struct xfs_bmbt_irec we can just use the latter directly in the aops
code.  Replace the missing IOMAP_NEW flag with a new boolean output
parameter to xfs_iomap.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-04-27 17:39:20.699003542 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-04-27 18:12:14.223025612 +0200
@@ -309,23 +309,24 @@ xfs_map_blocks(
 	struct inode		*inode,
 	loff_t			offset,
 	ssize_t			count,
-	xfs_iomap_t		*mapp,
+	struct xfs_bmbt_irec	*imap,
 	int			flags)
 {
 	int			nmaps = 1;
+	int			new = 0;
 
-	return -xfs_iomap(XFS_I(inode), offset, count, flags, mapp, &nmaps);
+	return -xfs_iomap(XFS_I(inode), offset, count, flags, imap, &nmaps, &new);
 }
 
 STATIC int
 xfs_iomap_valid(
 	struct inode		*inode,
-	xfs_iomap_t		*iomapp,
+	struct xfs_bmbt_irec	*imap,
 	loff_t			offset)
 {
 	struct xfs_mount	*mp = XFS_I(inode)->i_mount;
-	xfs_off_t		iomap_offset = XFS_FSB_TO_B(mp, iomapp->iomap_offset);
-	xfs_off_t		iomap_bsize = XFS_FSB_TO_B(mp, iomapp->iomap_bsize);
+	xfs_off_t		iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
+	xfs_off_t		iomap_bsize = XFS_FSB_TO_B(mp, imap->br_blockcount);
 
 	return offset >= iomap_offset &&
 		offset < iomap_offset + iomap_bsize;
@@ -561,16 +562,16 @@ STATIC void
 xfs_map_buffer(
 	struct inode		*inode,
 	struct buffer_head	*bh,
-	xfs_iomap_t		*mp,
+	struct xfs_bmbt_irec	*imap,
 	xfs_off_t		offset)
 {
 	sector_t		bn;
 	struct xfs_mount	*m = XFS_I(inode)->i_mount;
-	xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, mp->iomap_offset);
-	xfs_daddr_t		iomap_bn = xfs_fsb_to_db(XFS_I(inode), mp->iomap_bn);
+	xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, imap->br_startoff);
+	xfs_daddr_t		iomap_bn = xfs_fsb_to_db(XFS_I(inode), imap->br_startblock);
 
-	ASSERT(mp->iomap_bn != HOLESTARTBLOCK);
-	ASSERT(mp->iomap_bn != DELAYSTARTBLOCK);
+	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
+	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
 
 	bn = (iomap_bn >> (inode->i_blkbits - BBSHIFT)) +
 	      ((offset - iomap_offset) >> inode->i_blkbits);
@@ -585,14 +586,14 @@ STATIC void
 xfs_map_at_offset(
 	struct inode		*inode,
 	struct buffer_head	*bh,
-	xfs_iomap_t		*iomapp,
+	struct xfs_bmbt_irec	*imap,
 	xfs_off_t		offset)
 {
-	ASSERT(iomapp->iomap_bn != HOLESTARTBLOCK);
-	ASSERT(iomapp->iomap_bn != DELAYSTARTBLOCK);
+	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
+	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
 
 	lock_buffer(bh);
-	xfs_map_buffer(inode, bh, iomapp, offset);
+	xfs_map_buffer(inode, bh, imap, offset);
 	bh->b_bdev = xfs_find_bdev_for_inode(inode);
 	set_buffer_mapped(bh);
 	clear_buffer_delay(bh);
@@ -749,7 +750,7 @@ xfs_convert_page(
 	struct inode		*inode,
 	struct page		*page,
 	loff_t			tindex,
-	xfs_iomap_t		*mp,
+	struct xfs_bmbt_irec	*imap,
 	xfs_ioend_t		**ioendp,
 	struct writeback_control *wbc,
 	int			startio,
@@ -814,15 +815,15 @@ xfs_convert_page(
 			else
 				type = IOMAP_DELAY;
 
-			if (!xfs_iomap_valid(inode, mp, offset)) {
+			if (!xfs_iomap_valid(inode, imap, offset)) {
 				done = 1;
 				continue;
 			}
 
-			ASSERT(mp->iomap_bn != HOLESTARTBLOCK);
-			ASSERT(mp->iomap_bn != DELAYSTARTBLOCK);
+			ASSERT(imap->br_startblock != HOLESTARTBLOCK);
+			ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
 
-			xfs_map_at_offset(inode, bh, mp, offset);
+			xfs_map_at_offset(inode, bh, imap, offset);
 			if (startio) {
 				xfs_add_to_ioend(inode, bh, offset,
 						type, ioendp, done);
@@ -874,7 +875,7 @@ STATIC void
 xfs_cluster_write(
 	struct inode		*inode,
 	pgoff_t			tindex,
-	xfs_iomap_t		*iomapp,
+	struct xfs_bmbt_irec	*imap,
 	xfs_ioend_t		**ioendp,
 	struct writeback_control *wbc,
 	int			startio,
@@ -893,7 +894,7 @@ xfs_cluster_write(
 
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			done = xfs_convert_page(inode, pvec.pages[i], tindex++,
-					iomapp, ioendp, wbc, startio, all_bh);
+					imap, ioendp, wbc, startio, all_bh);
 			if (done)
 				break;
 		}
@@ -1050,7 +1051,7 @@ xfs_page_state_convert(
 	int		unmapped) /* also implies page uptodate */
 {
 	struct buffer_head	*bh, *head;
-	xfs_iomap_t		iomap;
+	struct xfs_bmbt_irec	imap;
 	xfs_ioend_t		*ioend = NULL, *iohead = NULL;
 	loff_t			offset;
 	unsigned long           p_offset = 0;
@@ -1124,7 +1125,7 @@ xfs_page_state_convert(
 		}
 
 		if (iomap_valid)
-			iomap_valid = xfs_iomap_valid(inode, &iomap, offset);
+			iomap_valid = xfs_iomap_valid(inode, &imap, offset);
 
 		/*
 		 * First case, map an unwritten extent and prepare for
@@ -1176,13 +1177,13 @@ xfs_page_state_convert(
 				}
 
 				err = xfs_map_blocks(inode, offset, size,
-						&iomap, flags);
+						&imap, flags);
 				if (err)
 					goto error;
-				iomap_valid = xfs_iomap_valid(inode, &iomap, offset);
+				iomap_valid = xfs_iomap_valid(inode, &imap, offset);
 			}
 			if (iomap_valid) {
-				xfs_map_at_offset(inode, bh, &iomap, offset);
+				xfs_map_at_offset(inode, bh, &imap, offset);
 				if (startio) {
 					xfs_add_to_ioend(inode, bh, offset,
 							type, &ioend,
@@ -1206,10 +1207,10 @@ xfs_page_state_convert(
 				size = xfs_probe_cluster(inode, page, bh,
 								head, 1);
 				err = xfs_map_blocks(inode, offset, size,
-						&iomap, flags);
+						&imap, flags);
 				if (err)
 					goto error;
-				iomap_valid = xfs_iomap_valid(inode, &iomap, offset);
+				iomap_valid = xfs_iomap_valid(inode, &imap, offset);
 			}
 
 			/*
@@ -1250,13 +1251,13 @@ xfs_page_state_convert(
 
 	if (ioend && iomap_valid) {
 		struct xfs_mount	*m = XFS_I(inode)->i_mount;
-		xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, iomap.iomap_offset);
-		xfs_off_t		iomap_bsize = XFS_FSB_TO_B(m, iomap.iomap_bsize);
+		xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, imap.br_startoff);
+		xfs_off_t		iomap_bsize = XFS_FSB_TO_B(m, imap.br_blockcount);
 
 		offset = (iomap_offset + iomap_bsize - 1) >>
 					PAGE_CACHE_SHIFT;
 		tlast = min_t(pgoff_t, offset, last_index);
-		xfs_cluster_write(inode, page->index + 1, &iomap, &ioend,
+		xfs_cluster_write(inode, page->index + 1, &imap, &ioend,
 					wbc, startio, all_bh, tlast);
 	}
 
@@ -1459,10 +1460,11 @@ __xfs_get_blocks(
 	int			direct,
 	bmapi_flags_t		flags)
 {
-	xfs_iomap_t		iomap;
+	struct xfs_bmbt_irec	imap;
 	xfs_off_t		offset;
 	ssize_t			size;
-	int			niomap = 1;
+	int			nimap = 1;
+	int			new = 0;
 	int			error;
 
 	offset = (xfs_off_t)iblock << inode->i_blkbits;
@@ -1473,21 +1475,21 @@ __xfs_get_blocks(
 		return 0;
 
 	error = xfs_iomap(XFS_I(inode), offset, size,
-			     create ? flags : BMAPI_READ, &iomap, &niomap);
+			     create ? flags : BMAPI_READ, &imap, &nimap, &new);
 	if (error)
 		return -error;
-	if (niomap == 0)
+	if (nimap == 0)
 		return 0;
 
-	if (iomap.iomap_bn != HOLESTARTBLOCK &&
-	    iomap.iomap_bn != DELAYSTARTBLOCK) {
+	if (imap.br_startblock != HOLESTARTBLOCK &&
+	    imap.br_startblock != DELAYSTARTBLOCK) {
 		/*
 		 * For unwritten extents do not report a disk address on
 		 * the read case (treat as if we're reading into a hole).
 		 */
-		if (create || !(iomap.iomap_flags & IOMAP_UNWRITTEN))
-			xfs_map_buffer(inode, bh_result, &iomap, offset);
-		if (create && (iomap.iomap_flags & IOMAP_UNWRITTEN)) {
+		if (create || !ISUNWRITTEN(&imap))
+			xfs_map_buffer(inode, bh_result, &imap, offset);
+		if (create && ISUNWRITTEN(&imap)) {
 			if (direct)
 				bh_result->b_private = inode;
 			set_buffer_unwritten(bh_result);
@@ -1512,10 +1514,10 @@ __xfs_get_blocks(
 	if (create &&
 	    ((!buffer_mapped(bh_result) && !buffer_uptodate(bh_result)) ||
 	     (offset >= i_size_read(inode)) ||
-	     (iomap.iomap_flags & (IOMAP_NEW|IOMAP_UNWRITTEN))))
+	     (new || ISUNWRITTEN(&imap))))
 		set_buffer_new(bh_result);
 
-	if (iomap.iomap_bn == DELAYSTARTBLOCK) {
+	if (imap.br_startblock == DELAYSTARTBLOCK) {
 		BUG_ON(direct);
 		if (create) {
 			set_buffer_uptodate(bh_result);
@@ -1526,9 +1528,9 @@ __xfs_get_blocks(
 
 	if (direct || size > (1 << inode->i_blkbits)) {
 		struct xfs_mount	*mp = XFS_I(inode)->i_mount;
-		xfs_off_t		iomap_offset = XFS_FSB_TO_B(mp, iomap.iomap_offset);
+		xfs_off_t		iomap_offset = XFS_FSB_TO_B(mp, imap.br_startoff);
 		xfs_off_t		iomap_delta = offset - iomap_offset;
-		xfs_off_t		iomap_bsize = XFS_FSB_TO_B(mp, iomap.iomap_bsize);
+		xfs_off_t		iomap_bsize = XFS_FSB_TO_B(mp, imap.br_blockcount);
 
 		ASSERT(iomap_bsize - iomap_delta > 0);
 		offset = min_t(xfs_off_t,
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-04-27 17:39:20.700004101 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-04-27 18:12:21.135027288 +0200
@@ -55,46 +55,25 @@
 #define XFS_STRAT_WRITE_IMAPS	2
 #define XFS_WRITE_IMAPS		XFS_BMAP_MAX_NMAP
 
-STATIC void
-xfs_imap_to_bmap(
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,
-	xfs_bmbt_irec_t *imap,
-	xfs_iomap_t	*iomapp,
-	int		imaps,			/* Number of imap entries */
-	int		flags)
-{
-	iomapp->iomap_offset = imap->br_startoff;
-	iomapp->iomap_bsize = imap->br_blockcount;
-	iomapp->iomap_flags = flags;
-	iomapp->iomap_bn = imap->br_startblock;
-
-	if (imap->br_startblock != HOLESTARTBLOCK &&
-	    imap->br_startblock != DELAYSTARTBLOCK &&
-	    ISUNWRITTEN(imap))
-		iomapp->iomap_flags |= IOMAP_UNWRITTEN;
-}
-
 int
 xfs_iomap(
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,
-	ssize_t		count,
-	int		flags,
-	xfs_iomap_t	*iomapp,
-	int		*niomaps)
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	ssize_t			count,
+	int			flags,
+	struct xfs_bmbt_irec	*imap,
+	int			*nimaps,
+	int			*new)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_fileoff_t	offset_fsb, end_fsb;
-	int		error = 0;
-	int		lockmode = 0;
-	xfs_bmbt_irec_t	imap;
-	int		nimaps = 1;
-	int		bmapi_flags = 0;
-	int		iomap_flags = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset_fsb, end_fsb;
+	int			error = 0;
+	int			lockmode = 0;
+	int			bmapi_flags = 0;
 
 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
-	ASSERT(niomaps && *niomaps == 1);
+
+	*new = 0;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -136,8 +115,8 @@ xfs_iomap(
 
 	error = xfs_bmapi(NULL, ip, offset_fsb,
 			(xfs_filblks_t)(end_fsb - offset_fsb),
-			bmapi_flags,  NULL, 0, &imap,
-			&nimaps, NULL, NULL);
+			bmapi_flags,  NULL, 0, imap,
+			nimaps, NULL, NULL);
 
 	if (error)
 		goto out;
@@ -145,45 +124,41 @@ xfs_iomap(
 	switch (flags & (BMAPI_WRITE|BMAPI_ALLOCATE)) {
 	case BMAPI_WRITE:
 		/* If we found an extent, return it */
-		if (nimaps &&
-		    (imap.br_startblock != HOLESTARTBLOCK) &&
-		    (imap.br_startblock != DELAYSTARTBLOCK)) {
-			trace_xfs_iomap_found(ip, offset, count, flags, &imap);
+		if (*nimaps &&
+		    (imap->br_startblock != HOLESTARTBLOCK) &&
+		    (imap->br_startblock != DELAYSTARTBLOCK)) {
+			trace_xfs_iomap_found(ip, offset, count, flags, imap);
 			break;
 		}
 
 		if (flags & (BMAPI_DIRECT|BMAPI_MMAP)) {
 			error = xfs_iomap_write_direct(ip, offset, count, flags,
-						       &imap, &nimaps, nimaps);
+						       imap, nimaps, *nimaps);
 		} else {
 			error = xfs_iomap_write_delay(ip, offset, count, flags,
-						      &imap, &nimaps);
+						      imap, nimaps);
 		}
 		if (!error) {
-			trace_xfs_iomap_alloc(ip, offset, count, flags, &imap);
+			trace_xfs_iomap_alloc(ip, offset, count, flags, imap);
 		}
-		iomap_flags = IOMAP_NEW;
+		*new = 1;
 		break;
 	case BMAPI_ALLOCATE:
 		/* If we found an extent, return it */
 		xfs_iunlock(ip, lockmode);
 		lockmode = 0;
 
-		if (nimaps && !isnullstartblock(imap.br_startblock)) {
-			trace_xfs_iomap_found(ip, offset, count, flags, &imap);
+		if (*nimaps && !isnullstartblock(imap->br_startblock)) {
+			trace_xfs_iomap_found(ip, offset, count, flags, imap);
 			break;
 		}
 
 		error = xfs_iomap_write_allocate(ip, offset, count,
-						 &imap, &nimaps);
+						 imap, nimaps);
 		break;
 	}
 
-	ASSERT(nimaps <= 1);
-
-	if (nimaps)
-		xfs_imap_to_bmap(ip, offset, &imap, iomapp, nimaps, iomap_flags);
-	*niomaps = nimaps;
+	ASSERT(*nimaps <= 1);
 
 out:
 	if (lockmode)
@@ -191,7 +166,6 @@ out:
 	return XFS_ERROR(error);
 }
 
-
 STATIC int
 xfs_iomap_eof_align_last_fsb(
 	xfs_mount_t	*mp,
Index: xfs/fs/xfs/xfs_iomap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.h	2010-04-27 17:39:27.783067167 +0200
+++ xfs/fs/xfs/xfs_iomap.h	2010-04-27 18:12:14.232003612 +0200
@@ -47,35 +47,11 @@ typedef enum {
 	{ BMAPI_MMAP,		"MMAP" }, \
 	{ BMAPI_TRYLOCK,	"TRYLOCK" }
 
-/*
- * xfs_iomap_t:  File system I/O map
- *
- * The iomap_bn field is expressed in 512-byte blocks, and is where the
- * mapping starts on disk.
- *
- * The iomap_offset, iomap_bsize and iomap_delta fields are in bytes.
- * iomap_offset is the offset of the mapping in the file itself.
- * iomap_bsize is the size of the mapping,  iomap_delta is the
- * desired data's offset into the mapping, given the offset supplied
- * to the file I/O map routine.
- *
- * When a request is made to read beyond the logical end of the object,
- * iomap_size may be set to 0, but iomap_offset and iomap_length should be set
- * to the actual amount of underlying storage that has been allocated, if any.
- */
-
-typedef struct xfs_iomap {
-	xfs_daddr_t		iomap_bn;	/* first 512B blk of mapping */
-	xfs_off_t		iomap_offset;	/* offset of mapping, bytes */
-	xfs_off_t		iomap_bsize;	/* size of mapping, bytes */
-	iomap_flags_t		iomap_flags;
-} xfs_iomap_t;
-
 struct xfs_inode;
 struct xfs_bmbt_irec;
 
 extern int xfs_iomap(struct xfs_inode *, xfs_off_t, ssize_t, int,
-		     struct xfs_iomap *, int *);
+		     struct xfs_bmbt_irec *, int *, int *);
 extern int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
 				  int, struct xfs_bmbt_irec *, int *, int);
 extern int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t, int,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
