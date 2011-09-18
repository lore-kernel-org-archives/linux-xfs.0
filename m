Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfkXs200936 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E755416A92F1
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:46:53 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2YhCuEvGiy5jUaTl for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:46:53 -0700 (PDT)
Message-Id: <20110918204144.372052427@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/27] xfs: factor extent allocation out of xfs_bmapi
References: <20110918204040.266805129@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi-factor-allocate
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
Cc: Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

To further improve the readability of xfs_bmapi(), factor the extent
allocation out into a separate function. This removes a large block
of logic from the xfs_bmapi() code loop and makes it easier to see
the operational logic flow for xfs_bmapi().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 08:43:11.503123201 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 08:43:13.169789855 -0400
@@ -4605,6 +4605,147 @@ xfs_bmapi_delay(
 }
 
 
+STATIC int
+xfs_bmapi_allocate(
+	struct xfs_bmalloca	*bma,
+	xfs_extnum_t		*lastx,
+	struct xfs_btree_cur	**cur,
+	xfs_fsblock_t		*firstblock,
+	struct xfs_bmap_free	*flist,
+	int			flags,
+	int			*nallocs,
+	int			*logflags)
+{
+	struct xfs_mount	*mp = bma->ip->i_mount;
+	int			whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
+						XFS_ATTR_FORK : XFS_DATA_FORK;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
+	xfs_fsblock_t		abno;
+	xfs_extlen_t		alen;
+	xfs_fileoff_t		aoff;
+	int			error;
+	int			rt;
+
+	rt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(bma->ip);
+
+	/*
+	 * For the wasdelay case, we could also just allocate the stuff asked
+	 * for in this bmap call but that wouldn't be as good.
+	 */
+	if (bma->wasdel) {
+		alen = (xfs_extlen_t)bma->gotp->br_blockcount;
+		aoff = bma->gotp->br_startoff;
+		if (*lastx != NULLEXTNUM && *lastx) {
+			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx - 1),
+					 bma->prevp);
+		}
+	} else {
+		alen = (xfs_extlen_t)XFS_FILBLKS_MIN(bma->alen, MAXEXTLEN);
+		if (!bma->eof)
+			alen = (xfs_extlen_t)XFS_FILBLKS_MIN(alen,
+					bma->gotp->br_startoff - bma->off);
+		aoff = bma->off;
+	}
+
+	/*
+	 * Indicate if this is the first user data in the file, or just any
+	 * user data.
+	 */
+	if (!(flags & XFS_BMAPI_METADATA)) {
+		bma->userdata = (aoff == 0) ?
+			XFS_ALLOC_INITIAL_USER_DATA : XFS_ALLOC_USERDATA;
+	}
+
+	/*
+	 * Fill in changeable bma fields.
+	 */
+	bma->alen = alen;
+	bma->off = aoff;
+	bma->firstblock = *firstblock;
+	bma->minlen = (flags & XFS_BMAPI_CONTIG) ? alen : 1;
+	bma->low = flist->xbf_low;
+	bma->aeof = 0;
+
+	/*
+	 * Only want to do the alignment at the eof if it is userdata and
+	 * allocation length is larger than a stripe unit.
+	 */
+	if (mp->m_dalign && alen >= mp->m_dalign &&
+	    !(flags & XFS_BMAPI_METADATA) && whichfork == XFS_DATA_FORK) {
+		error = xfs_bmap_isaeof(bma->ip, aoff, whichfork, &bma->aeof);
+		if (error)
+			return error;
+	}
+
+	error = xfs_bmap_alloc(bma);
+	if (error)
+		return error;
+
+	/*
+	 * Copy out result fields.
+	 */
+	abno = bma->rval;
+	flist->xbf_low = bma->low;
+	alen = bma->alen;
+	aoff = bma->off;
+	ASSERT(*firstblock == NULLFSBLOCK ||
+	       XFS_FSB_TO_AGNO(mp, *firstblock) ==
+	       XFS_FSB_TO_AGNO(mp, bma->firstblock) ||
+	       (flist->xbf_low &&
+		XFS_FSB_TO_AGNO(mp, *firstblock) <
+			XFS_FSB_TO_AGNO(mp, bma->firstblock)));
+	*firstblock = bma->firstblock;
+	if (*cur)
+		(*cur)->bc_private.b.firstblock = *firstblock;
+	if (abno == NULLFSBLOCK)
+		return 0;
+	if ((ifp->if_flags & XFS_IFBROOT) && !*cur) {
+		(*cur) = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
+		(*cur)->bc_private.b.firstblock = *firstblock;
+		(*cur)->bc_private.b.flist = flist;
+	}
+	/*
+	 * Bump the number of extents we've allocated
+	 * in this call.
+	 */
+	(*nallocs)++;
+
+	if (*cur)
+		(*cur)->bc_private.b.flags =
+			bma->wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
+
+	bma->gotp->br_startoff = aoff;
+	bma->gotp->br_startblock = abno;
+	bma->gotp->br_blockcount = alen;
+	bma->gotp->br_state = XFS_EXT_NORM;
+
+	/*
+	 * A wasdelay extent has been initialized, so shouldn't be flagged
+	 * as unwritten.
+	 */
+	if (!bma->wasdel && (flags & XFS_BMAPI_PREALLOC) &&
+	    xfs_sb_version_hasextflgbit(&mp->m_sb))
+		bma->gotp->br_state = XFS_EXT_UNWRITTEN;
+
+	error = xfs_bmap_add_extent(bma->tp, bma->ip, lastx, cur, bma->gotp,
+				    firstblock, flist, logflags, whichfork);
+	if (error)
+		return error;
+
+	/*
+	 * Update our extent pointer, given that xfs_bmap_add_extent  might
+	 * have merged it into one of the neighbouring ones.
+	 */
+	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), bma->gotp);
+
+	ASSERT(bma->gotp->br_startoff <= aoff);
+	ASSERT(bma->gotp->br_startoff + bma->gotp->br_blockcount >=
+		aoff + alen);
+	ASSERT(bma->gotp->br_state == XFS_EXT_NORM ||
+	       bma->gotp->br_state == XFS_EXT_UNWRITTEN);
+	return 0;
+}
+
 /*
  * Map file blocks to filesystem blocks.
  * File range is given by the bno/len pair.
@@ -4632,9 +4773,6 @@ xfs_bmapi(
 	int		*nmap,		/* i/o: mval size/count */
 	xfs_bmap_free_t	*flist)		/* i/o: list extents to free */
 {
-	xfs_fsblock_t	abno;		/* allocated block number */
-	xfs_extlen_t	alen;		/* allocated extent length */
-	xfs_fileoff_t	aoff;		/* allocated file offset */
 	xfs_bmalloca_t	bma = { 0 };	/* args for xfs_bmap_alloc */
 	xfs_btree_cur_t	*cur;		/* bmap btree cursor */
 	xfs_fileoff_t	end;		/* end of mapped file region */
@@ -4646,7 +4784,6 @@ xfs_bmapi(
 	xfs_extnum_t	lastx;		/* last useful extent number */
 	int		logflags;	/* flags for transaction logging */
 	xfs_extlen_t	minleft;	/* min blocks left after allocation */
-	xfs_extlen_t	minlen;		/* min allocation size */
 	xfs_mount_t	*mp;		/* xfs mount structure */
 	int		n;		/* current extent index */
 	int		nallocs;	/* number of extents alloc'd */
@@ -4737,7 +4874,13 @@ xfs_bmapi(
 	n = 0;
 	end = bno + len;
 	obno = bno;
-	bma.ip = NULL;
+
+	bma.tp = tp;
+	bma.ip = ip;
+	bma.prevp = &prev;
+	bma.gotp = &got;
+	bma.total = total;
+	bma.userdata = 0;
 
 	while (bno < end && n < *nmap) {
 		/*
@@ -4753,144 +4896,23 @@ xfs_bmapi(
 		 * that we found, if any.
 		 */
 		if (wr && (inhole || wasdelay)) {
-			/*
-			 * For the wasdelay case, we could also just
-			 * allocate the stuff asked for in this bmap call
-			 * but that wouldn't be as good.
-			 */
-			if (wasdelay) {
-				alen = (xfs_extlen_t)got.br_blockcount;
-				aoff = got.br_startoff;
-				if (lastx != NULLEXTNUM && lastx) {
-					ep = xfs_iext_get_ext(ifp, lastx - 1);
-					xfs_bmbt_get_all(ep, &prev);
-				}
-			} else {
-				alen = (xfs_extlen_t)
-					XFS_FILBLKS_MIN(len, MAXEXTLEN);
-				if (!eof)
-					alen = (xfs_extlen_t)
-						XFS_FILBLKS_MIN(alen,
-							got.br_startoff - bno);
-				aoff = bno;
-			}
-			minlen = (flags & XFS_BMAPI_CONTIG) ? alen : 1;
-			{
-				/*
-				 * If first time, allocate and fill in
-				 * once-only bma fields.
-				 */
-				if (bma.ip == NULL) {
-					bma.tp = tp;
-					bma.ip = ip;
-					bma.prevp = &prev;
-					bma.gotp = &got;
-					bma.total = total;
-					bma.userdata = 0;
-				}
-				/* Indicate if this is the first user data
-				 * in the file, or just any user data.
-				 */
-				if (!(flags & XFS_BMAPI_METADATA)) {
-					bma.userdata = (aoff == 0) ?
-						XFS_ALLOC_INITIAL_USER_DATA :
-						XFS_ALLOC_USERDATA;
-				}
-				/*
-				 * Fill in changeable bma fields.
-				 */
-				bma.eof = eof;
-				bma.firstblock = *firstblock;
-				bma.alen = alen;
-				bma.off = aoff;
-				bma.conv = !!(flags & XFS_BMAPI_CONVERT);
-				bma.wasdel = wasdelay;
-				bma.minlen = minlen;
-				bma.low = flist->xbf_low;
-				bma.minleft = minleft;
-				/*
-				 * Only want to do the alignment at the
-				 * eof if it is userdata and allocation length
-				 * is larger than a stripe unit.
-				 */
-				if (mp->m_dalign && alen >= mp->m_dalign &&
-				    (!(flags & XFS_BMAPI_METADATA)) &&
-				    (whichfork == XFS_DATA_FORK)) {
-					if ((error = xfs_bmap_isaeof(ip, aoff,
-							whichfork, &bma.aeof)))
-						goto error0;
-				} else
-					bma.aeof = 0;
-				/*
-				 * Call allocator.
-				 */
-				if ((error = xfs_bmap_alloc(&bma)))
-					goto error0;
-				/*
-				 * Copy out result fields.
-				 */
-				abno = bma.rval;
-				if ((flist->xbf_low = bma.low))
-					minleft = 0;
-				alen = bma.alen;
-				aoff = bma.off;
-				ASSERT(*firstblock == NULLFSBLOCK ||
-				       XFS_FSB_TO_AGNO(mp, *firstblock) ==
-				       XFS_FSB_TO_AGNO(mp, bma.firstblock) ||
-				       (flist->xbf_low &&
-					XFS_FSB_TO_AGNO(mp, *firstblock) <
-					XFS_FSB_TO_AGNO(mp, bma.firstblock)));
-				*firstblock = bma.firstblock;
-				if (cur)
-					cur->bc_private.b.firstblock =
-						*firstblock;
-				if (abno == NULLFSBLOCK)
-					break;
-				if ((ifp->if_flags & XFS_IFBROOT) && !cur) {
-					cur = xfs_bmbt_init_cursor(mp, tp,
-						ip, whichfork);
-					cur->bc_private.b.firstblock =
-						*firstblock;
-					cur->bc_private.b.flist = flist;
-				}
-				/*
-				 * Bump the number of extents we've allocated
-				 * in this call.
-				 */
-				nallocs++;
-			}
-			if (cur)
-				cur->bc_private.b.flags =
-					wasdelay ? XFS_BTCUR_BPRV_WASDEL : 0;
-			got.br_startoff = aoff;
-			got.br_startblock = abno;
-			got.br_blockcount = alen;
-			got.br_state = XFS_EXT_NORM;	/* assume normal */
-			/*
-			 * Determine state of extent, and the filesystem.
-			 * A wasdelay extent has been initialized, so
-			 * shouldn't be flagged as unwritten.
-			 */
-			if (wr && xfs_sb_version_hasextflgbit(&mp->m_sb)) {
-				if (!wasdelay && (flags & XFS_BMAPI_PREALLOC))
-					got.br_state = XFS_EXT_UNWRITTEN;
-			}
-			error = xfs_bmap_add_extent(tp, ip, &lastx, &cur, &got,
-				firstblock, flist, &tmp_logflags,
-				whichfork);
+			bma.eof = eof;
+			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
+			bma.wasdel = wasdelay;
+			bma.alen = len;
+			bma.off = bno;
+			bma.minleft = minleft;
+
+			error = xfs_bmapi_allocate(&bma, &lastx, &cur,
+					firstblock, flist, flags, &nallocs,
+					&tmp_logflags);
 			logflags |= tmp_logflags;
 			if (error)
 				goto error0;
-			ep = xfs_iext_get_ext(ifp, lastx);
-			xfs_bmbt_get_all(ep, &got);
-			ASSERT(got.br_startoff <= aoff);
-			ASSERT(got.br_startoff + got.br_blockcount >=
-				aoff + alen);
-			ASSERT(got.br_state == XFS_EXT_NORM ||
-			       got.br_state == XFS_EXT_UNWRITTEN);
-			/*
-			 * Fall down into the found allocated space case.
-			 */
+			if (flist && flist->xbf_low)
+				minleft = 0;
+			if (bma.rval == NULLFSBLOCK)
+				break;
 		} else if (inhole) {
 			/*
 			 * Reading in a hole.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
