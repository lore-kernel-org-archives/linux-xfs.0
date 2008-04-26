Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Apr 2008 13:03:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3QK36VV025021
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 13:03:13 -0700
Date: Sat, 26 Apr 2008 16:03:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Message-ID: <20080426200347.GA21021@infradead.org>
References: <200804261651.02078.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804261651.02078.vda.linux@googlemail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 04:51:02PM +0200, Denys Vlasenko wrote:
> Hi David,
> 
> This patch reduces xfs_bmap_btalloc() stack usage by 50 bytes
> by moving part of its body into a helper function.
> 
> This results in some variables not taking stack space in
> xfs_bmap_btalloc() anymore.
> 
> The helper itself does not call anything stack-deep.
> Stack-deep call to xfs_alloc_vextent() happen
> in xfs_bmap_btalloc(), as before.
> 
> Compile tested only.

I think this is a good idea, although I'd rather split the function at
a local boundary.  The patch below (which passes xfsqa) does that
by splitting out the handling of the most complicated nullfb case
out.  It probably won't help reducing stack useage as much as yours,
but it helps beeing able to read the code a little better.

Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-04-26 17:43:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-04-26 18:03:08.000000000 +0200
@@ -2646,6 +2646,144 @@ xfs_bmap_rtalloc(
 	return 0;
 }
 
+STATIC void
+xfs_bmap_btalloc_fix_blen(
+	xfs_mount_t		*mp,
+	xfs_perag_t		*pag,
+	xfs_extlen_t		*blen)
+{
+	xfs_extlen_t		need, delta, longest;
+
+	need = XFS_MIN_FREELIST_PAG(pag, mp);
+	if (need > pag->pagf_flcount)
+		delta = need - pag->pagf_flcount;
+	else
+		delta = 0;
+
+	if (pag->pagf_longest > delta)
+		longest = pag->pagf_longest - delta;
+	else
+		longest = (pag->pagf_flcount > 0 ||
+			   pag->pagf_longest > 0);
+
+	if (*blen < longest)
+		*blen = longest;
+}
+
+STATIC int
+xfs_bmap_btalloc_nullfb(
+	xfs_bmalloca_t		*ap,
+	xfs_alloc_arg_t		*args,
+	xfs_extlen_t		*blen)
+{
+	xfs_mount_t		*mp = ap->ip->i_mount;
+	xfs_agnumber_t		ag, startag;
+	int			notinit = 0, error;
+
+	if (ap->userdata && xfs_inode_is_filestream(ap->ip))
+		args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	else
+		args->type = XFS_ALLOCTYPE_START_BNO;
+	args->total = ap->total;
+
+	/*
+	 * Search for an allocation group with a single extent
+	 * large enough for the request.
+	 *
+	 * If one isn't found, then adjust the minimum allocation
+	 * size to the largest space found.
+	 */
+	startag = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	if (startag == NULLAGNUMBER)
+		startag = 0;
+
+	ag = startag;
+	down_read(&mp->m_peraglock);
+	while (*blen < ap->alen) {
+		xfs_perag_t	*pag = &mp->m_perag[ag];
+
+		if (!pag->pagf_init) {
+			error = xfs_alloc_pagf_init(mp, args->tp, ag,
+			    			    XFS_ALLOC_FLAG_TRYLOCK);
+			if (error)
+				goto out_unlock;
+		}
+
+		/*
+		 * See xfs_alloc_fix_freelist...
+		 */
+		if (pag->pagf_init)
+			xfs_bmap_btalloc_fix_blen(mp, pag, blen);
+		else
+			notinit = 1;
+
+		if (xfs_inode_is_filestream(ap->ip)) {
+			if (*blen >= ap->alen)
+				break;
+
+			if (ap->userdata) {
+				/*
+				 * If startag is an invalid AG, we've come
+				 * here once before and xfs_filestream_new_ag
+				 * picked the best currently available.
+				 *
+				 * Don't continue looping, since we could
+				 * loop forever.
+				 */
+				if (startag == NULLAGNUMBER)
+					break;
+
+				error = xfs_filestream_new_ag(ap, &ag);
+				if (error)
+					goto out_unlock;
+
+				/* loop again to set 'blen'*/
+				startag = NULLAGNUMBER;
+				continue;
+			}
+		}
+		if (++ag == mp->m_sb.sb_agcount)
+			ag = 0;
+		if (ag == startag)
+			break;
+	}
+	up_read(&mp->m_peraglock);
+
+	/*
+	 * Since the above loop did a BUF_TRYLOCK, it is
+	 * possible that there is space for this request.
+	 */
+	if (notinit || *blen < ap->minlen)
+		args->minlen = ap->minlen;
+
+	/*
+	 * If the best seen length is less than the request
+	 * length, use the best as the minimum.
+	 */
+	else if (*blen < ap->alen)
+		args->minlen = *blen;
+
+	/*
+	 * Otherwise we've seen an extent as big as alen,
+	 * use that as the minimum.
+	 */
+	else
+		args->minlen = ap->alen;
+
+	/*
+	 * Set the failure fallback case to look in the selected AG as
+	 * the stream may have moved.
+	 */
+	if (xfs_inode_is_filestream(ap->ip))
+		ap->rval = args->fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
+
+	return 0;
+
+ out_unlock:
+	up_read(&mp->m_peraglock);
+	return error;
+}
+
 STATIC int
 xfs_bmap_btalloc(
 	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
@@ -2653,19 +2791,12 @@ xfs_bmap_btalloc(
 	xfs_mount_t	*mp;		/* mount point structure */
 	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
 	xfs_extlen_t	align;		/* minimum allocation alignment */
-	xfs_agnumber_t	ag;
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
-	xfs_agnumber_t	startag;
 	xfs_alloc_arg_t	args;
 	xfs_extlen_t	blen;
-	xfs_extlen_t	delta;
-	xfs_extlen_t	longest;
-	xfs_extlen_t	need;
 	xfs_extlen_t	nextminlen = 0;
-	xfs_perag_t	*pag;
 	int		nullfb;		/* true if ap->firstblock isn't set */
 	int		isaligned;
-	int		notinit;
 	int		tryagain;
 	int		error;
 
@@ -2682,6 +2813,8 @@ xfs_bmap_btalloc(
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, ap->firstblock);
 	if (nullfb) {
 		if (ap->userdata && xfs_inode_is_filestream(ap->ip)) {
+			xfs_agnumber_t	ag;
+
 			ag = xfs_filestream_lookup_ag(ap->ip);
 			ag = (ag != NULLAGNUMBER) ? ag : 0;
 			ap->rval = XFS_AGB_TO_FSB(mp, ag, 0);
@@ -2712,107 +2845,9 @@ xfs_bmap_btalloc(
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
-		down_read(&mp->m_peraglock);
-		while (blen < ap->alen) {
-			pag = &mp->m_perag[ag];
-			if (!pag->pagf_init &&
-			    (error = xfs_alloc_pagf_init(mp, args.tp,
-				    ag, XFS_ALLOC_FLAG_TRYLOCK))) {
-				up_read(&mp->m_peraglock);
-				return error;
-			}
-			/*
-			 * See xfs_alloc_fix_freelist...
-			 */
-			if (pag->pagf_init) {
-				need = XFS_MIN_FREELIST_PAG(pag, mp);
-				delta = need > pag->pagf_flcount ?
-					need - pag->pagf_flcount : 0;
-				longest = (pag->pagf_longest > delta) ?
-					(pag->pagf_longest - delta) :
-					(pag->pagf_flcount > 0 ||
-					 pag->pagf_longest > 0);
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
-					if (error) {
-						up_read(&mp->m_peraglock);
-						return error;
-					}
-
-					/* loop again to set 'blen'*/
-					startag = NULLAGNUMBER;
-					continue;
-				}
-			}
-			if (++ag == mp->m_sb.sb_agcount)
-				ag = 0;
-			if (ag == startag)
-				break;
-		}
-		up_read(&mp->m_peraglock);
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
