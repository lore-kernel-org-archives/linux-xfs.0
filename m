Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1FNXPjT097901 for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 17:33:25 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C787F13ABC04
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 15:34:42 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id N7DmpjKAwjeGVRny for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2010 15:34:42 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NhASg-0007VZ-55
	for xfs@oss.sgi.com; Mon, 15 Feb 2010 23:34:42 +0000
Date: Mon, 15 Feb 2010 18:34:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: split xfs_bmap_btalloc
Message-ID: <20100215233442.GA28817@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Split out the nullfb case into a separate function to reduce the stack
footprint and make the code more readable.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2010-01-17 14:46:43.326254284 +0100
+++ xfs/fs/xfs/xfs_bmap.c	2010-01-17 15:04:47.016005768 +0100
@@ -2550,22 +2550,134 @@ xfs_bmap_rtalloc(
 }
 
 STATIC int
+xfs_bmap_btalloc_nullfb(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		*blen)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		ag, startag;
+	int			notinit = 0;
+	int			error;
+
+	if (ap->userdata && xfs_inode_is_filestream(ap->ip))
+		args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	else
+		args->type = XFS_ALLOCTYPE_START_BNO;
+	args->total = ap->total;
+
+	/*
+	 * Search for an allocation group with a single extent large enough
+	 * for the request.  If one isn't found, then adjust the minimum
+	 * allocation size to the largest space found.
+	 */
+	startag = ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	if (startag == NULLAGNUMBER)
+		startag = ag = 0;
+
+	pag = xfs_perag_get(mp, ag);
+	while (*blen < ap->alen) {
+		if (!pag->pagf_init) {
+			error = xfs_alloc_pagf_init(mp, args->tp, ag,
+						    XFS_ALLOC_FLAG_TRYLOCK);
+			if (error) {
+				xfs_perag_put(pag);
+				return error;
+			}
+		}
+
+		/*
+		 * See xfs_alloc_fix_freelist...
+		 */
+		if (pag->pagf_init) {
+			xfs_extlen_t	longest;
+			longest = xfs_alloc_longest_free_extent(mp, pag);
+			if (*blen < longest)
+				*blen = longest;
+		} else
+			notinit = 1;
+
+		if (xfs_inode_is_filestream(ap->ip)) {
+			if (*blen >= ap->alen)
+				break;
+
+			if (ap->userdata) {
+				/*
+				 * If startag is an invalid AG, we've
+				 * come here once before and
+				 * xfs_filestream_new_ag picked the
+				 * best currently available.
+				 *
+				 * Don't continue looping, since we
+				 * could loop forever.
+				 */
+				if (startag == NULLAGNUMBER)
+					break;
+
+				error = xfs_filestream_new_ag(ap, &ag);
+				xfs_perag_put(pag);
+				if (error)
+					return error;
+
+				/* loop again to set 'blen'*/
+				startag = NULLAGNUMBER;
+				pag = xfs_perag_get(mp, ag);
+				continue;
+			}
+		}
+		if (++ag == mp->m_sb.sb_agcount)
+			ag = 0;
+		if (ag == startag)
+			break;
+		xfs_perag_put(pag);
+		pag = xfs_perag_get(mp, ag);
+	}
+	xfs_perag_put(pag);
+
+	/*
+	 * Since the above loop did a BUF_TRYLOCK, it is
+	 * possible that there is space for this request.
+	 */
+	if (notinit || *blen < ap->minlen)
+		args->minlen = ap->minlen;
+	/*
+	 * If the best seen length is less than the request
+	 * length, use the best as the minimum.
+	 */
+	else if (*blen < ap->alen)
+		args->minlen = *blen;
+	/*
+	 * Otherwise we've seen an extent as big as alen,
+	 * use that as the minimum.
+	 */
+	else
+		args->minlen = ap->alen;
+
+	/*
+	 * set the failure fallback case to look in the selected
+	 * AG as the stream may have moved.
+	 */
+	if (xfs_inode_is_filestream(ap->ip))
+		ap->rval = args->fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
+
+	return 0;
+}
+
+STATIC int
 xfs_bmap_btalloc(
 	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
 {
 	xfs_mount_t	*mp;		/* mount point structure */
 	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
 	xfs_extlen_t	align;		/* minimum allocation alignment */
-	xfs_agnumber_t	ag;
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
-	xfs_agnumber_t	startag;
+	xfs_agnumber_t	ag;
 	xfs_alloc_arg_t	args;
 	xfs_extlen_t	blen;
 	xfs_extlen_t	nextminlen = 0;
-	xfs_perag_t	*pag;
 	int		nullfb;		/* true if ap->firstblock isn't set */
 	int		isaligned;
-	int		notinit;
 	int		tryagain;
 	int		error;
 
@@ -2612,103 +2724,9 @@ xfs_bmap_btalloc(
 	args.firstblock = ap->firstblock;
 	blen = 0;
 	if (nullfb) {
-		if (ap->userdata && xfs_inode_is_filestream(ap->ip))
-			args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		else
-			args.type = XFS_ALLOCTYPE_START_BNO;
-		args.total = ap->total;
-
-		/*
-		 * Search for an allocation group with a single extent
-		 * large enough for the request.
-		 *
-		 * If one isn't found, then adjust the minimum allocation
-		 * size to the largest space found.
-		 */
-		startag = ag = XFS_FSB_TO_AGNO(mp, args.fsbno);
-		if (startag == NULLAGNUMBER)
-			startag = ag = 0;
-		notinit = 0;
-		pag = xfs_perag_get(mp, ag);
-		while (blen < ap->alen) {
-			if (!pag->pagf_init &&
-			    (error = xfs_alloc_pagf_init(mp, args.tp,
-				    ag, XFS_ALLOC_FLAG_TRYLOCK))) {
-				xfs_perag_put(pag);
-				return error;
-			}
-			/*
-			 * See xfs_alloc_fix_freelist...
-			 */
-			if (pag->pagf_init) {
-				xfs_extlen_t	longest;
-				longest = xfs_alloc_longest_free_extent(mp, pag);
-				if (blen < longest)
-					blen = longest;
-			} else
-				notinit = 1;
-
-			if (xfs_inode_is_filestream(ap->ip)) {
-				if (blen >= ap->alen)
-					break;
-
-				if (ap->userdata) {
-					/*
-					 * If startag is an invalid AG, we've
-					 * come here once before and
-					 * xfs_filestream_new_ag picked the
-					 * best currently available.
-					 *
-					 * Don't continue looping, since we
-					 * could loop forever.
-					 */
-					if (startag == NULLAGNUMBER)
-						break;
-
-					error = xfs_filestream_new_ag(ap, &ag);
-					xfs_perag_put(pag);
-					if (error)
-						return error;
-
-					/* loop again to set 'blen'*/
-					startag = NULLAGNUMBER;
-					pag = xfs_perag_get(mp, ag);
-					continue;
-				}
-			}
-			if (++ag == mp->m_sb.sb_agcount)
-				ag = 0;
-			if (ag == startag)
-				break;
-			xfs_perag_put(pag);
-			pag = xfs_perag_get(mp, ag);
-		}
-		xfs_perag_put(pag);
-		/*
-		 * Since the above loop did a BUF_TRYLOCK, it is
-		 * possible that there is space for this request.
-		 */
-		if (notinit || blen < ap->minlen)
-			args.minlen = ap->minlen;
-		/*
-		 * If the best seen length is less than the request
-		 * length, use the best as the minimum.
-		 */
-		else if (blen < ap->alen)
-			args.minlen = blen;
-		/*
-		 * Otherwise we've seen an extent as big as alen,
-		 * use that as the minimum.
-		 */
-		else
-			args.minlen = ap->alen;
-
-		/*
-		 * set the failure fallback case to look in the selected
-		 * AG as the stream may have moved.
-		 */
-		if (xfs_inode_is_filestream(ap->ip))
-			ap->rval = args.fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
+		error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
+		if (error)
+			return error;
 	} else if (ap->low) {
 		if (xfs_inode_is_filestream(ap->ip))
 			args.type = XFS_ALLOCTYPE_FIRST_AG;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
