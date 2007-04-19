Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 00:32:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3J7WPfB008491
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 00:32:27 -0700
Date: Thu, 19 Apr 2007 17:32:16 +1000
From: David Chinner <dgc@sgi.com>
Subject: review: allocate alloc args
Message-ID: <20070419073216.GT48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


Save some stack space in the critical allocator paths
by allocating the xfs_alloc_arg_t structures (104 bytes
on 64bit, 88 bytes on 32bit systems) rather than placing
them on the stack.

There can be more than one of these structures on the stack
through the critical allocation path (e.g. xfs_bmap_btalloc()
and xfs_alloc_fix_freelist()) so there are significant
savings to be had here...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/xfs_alloc.c        |   81 +++++++------
 fs/xfs/xfs_bmap.c         |  276 ++++++++++++++++++++++++----------------------
 fs/xfs/xfs_bmap_btree.c   |  131 +++++++++++----------
 fs/xfs/xfs_ialloc.c       |  163 ++++++++++++++-------------
 fs/xfs/xfs_ialloc_btree.c |  120 ++++++++++----------
 5 files changed, 412 insertions(+), 359 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc.c	2007-03-30 11:31:24.239345301 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc.c	2007-03-30 11:32:07.613682556 +1000
@@ -1826,7 +1826,7 @@ xfs_alloc_fix_freelist(
 	xfs_mount_t	*mp;	/* file system mount point structure */
 	xfs_extlen_t	need;	/* total blocks needed in freelist */
 	xfs_perag_t	*pag;	/* per-ag information structure */
-	xfs_alloc_arg_t	targs;	/* local allocation arguments */
+	xfs_alloc_arg_t	*targs;	/* local allocation arguments */
 	xfs_trans_t	*tp;	/* transaction pointer */
 
 	mp = args->mp;
@@ -1934,54 +1934,60 @@ xfs_alloc_fix_freelist(
 	/*
 	 * Initialize the args structure.
 	 */
-	targs.tp = tp;
-	targs.mp = mp;
-	targs.agbp = agbp;
-	targs.agno = args->agno;
-	targs.mod = targs.minleft = targs.wasdel = targs.userdata =
-		targs.minalignslop = 0;
-	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
-	targs.type = XFS_ALLOCTYPE_THIS_AG;
-	targs.pag = pag;
-	if ((error = xfs_alloc_read_agfl(mp, tp, targs.agno, &agflbp)))
-		return error;
+	targs = kmem_zalloc(sizeof(xfs_alloc_arg_t), KM_SLEEP);
+	if (!targs)
+		return XFS_ERROR(ENOMEM);
+	targs->tp = tp;
+	targs->mp = mp;
+	targs->agbp = agbp;
+	targs->agno = args->agno;
+	targs->mod = targs->minleft = targs->wasdel = targs->userdata =
+		targs->minalignslop = 0;
+	targs->alignment = targs->minlen = targs->prod = targs->isfl = 1;
+	targs->type = XFS_ALLOCTYPE_THIS_AG;
+	targs->pag = pag;
+	if ((error = xfs_alloc_read_agfl(mp, tp, targs->agno, &agflbp)))
+		goto out_error;
 	/*
 	 * Make the freelist longer if it's too short.
 	 */
 	while (be32_to_cpu(agf->agf_flcount) < need) {
-		targs.agbno = 0;
-		targs.maxlen = need - be32_to_cpu(agf->agf_flcount);
+		targs->agbno = 0;
+		targs->maxlen = need - be32_to_cpu(agf->agf_flcount);
 		/*
 		 * Allocate as many blocks as possible at once.
 		 */
-		if ((error = xfs_alloc_ag_vextent(&targs))) {
+		if ((error = xfs_alloc_ag_vextent(targs))) {
 			xfs_trans_brelse(tp, agflbp);
-			return error;
+			goto out_error;
 		}
 		/*
 		 * Stop if we run out.  Won't happen if callers are obeying
 		 * the restrictions correctly.  Can happen for free calls
 		 * on a completely full ag.
 		 */
-		if (targs.agbno == NULLAGBLOCK) {
+		if (targs->agbno == NULLAGBLOCK) {
 			if (flags & XFS_ALLOC_FLAG_FREEING)
 				break;
 			xfs_trans_brelse(tp, agflbp);
 			args->agbp = NULL;
-			return 0;
+			error = 0;
+			goto out_error;
 		}
 		/*
 		 * Put each allocated block on the list.
 		 */
-		for (bno = targs.agbno; bno < targs.agbno + targs.len; bno++) {
+		for (bno = targs->agbno; bno < targs->agbno + targs->len; bno++) {
 			if ((error = xfs_alloc_put_freelist(tp, agbp, agflbp,
 					bno, 0)))
-				return error;
+				goto out_error;
 		}
 	}
 	xfs_trans_brelse(tp, agflbp);
 	args->agbp = agbp;
-	return 0;
+out_error:
+	kmem_free(targs, sizeof(xfs_alloc_arg_t));
+	return error;
 }
 
 /*
@@ -2480,28 +2486,31 @@ xfs_free_extent(
 	xfs_fsblock_t	bno,	/* starting block number of extent */
 	xfs_extlen_t	len)	/* length of extent */
 {
-	xfs_alloc_arg_t	args;
+	xfs_alloc_arg_t	*args;
 	int		error;
 
 	ASSERT(len != 0);
-	memset(&args, 0, sizeof(xfs_alloc_arg_t));
-	args.tp = tp;
-	args.mp = tp->t_mountp;
-	args.agno = XFS_FSB_TO_AGNO(args.mp, bno);
-	ASSERT(args.agno < args.mp->m_sb.sb_agcount);
-	args.agbno = XFS_FSB_TO_AGBNO(args.mp, bno);
-	down_read(&args.mp->m_peraglock);
-	args.pag = &args.mp->m_perag[args.agno];
-	if ((error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING)))
+	args = kmem_zalloc(sizeof(xfs_alloc_arg_t), KM_SLEEP);
+	if (!args)
+		return XFS_ERROR(ENOMEM);
+	args->tp = tp;
+	args->mp = tp->t_mountp;
+	args->agno = XFS_FSB_TO_AGNO(args->mp, bno);
+	ASSERT(args->agno < args->mp->m_sb.sb_agcount);
+	args->agbno = XFS_FSB_TO_AGBNO(args->mp, bno);
+	down_read(&args->mp->m_peraglock);
+	args->pag = &args->mp->m_perag[args->agno];
+	if ((error = xfs_alloc_fix_freelist(args, XFS_ALLOC_FLAG_FREEING)))
 		goto error0;
 #ifdef DEBUG
-	ASSERT(args.agbp != NULL);
-	ASSERT((args.agbno + len) <=
-		be32_to_cpu(XFS_BUF_TO_AGF(args.agbp)->agf_length));
+	ASSERT(args->agbp != NULL);
+	ASSERT((args->agbno + len) <=
+		be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 #endif
-	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
+	error = xfs_free_ag_extent(tp, args->agbp, args->agno, args->agbno, len, 0);
 error0:
-	up_read(&args.mp->m_peraglock);
+	up_read(&args->mp->m_peraglock);
+	kmem_free(args, sizeof(xfs_alloc_arg_t));
 	return error;
 }
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap.c	2007-03-30 11:31:24.239345301 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap.c	2007-03-30 11:33:25.711487339 +1000
@@ -2701,7 +2701,7 @@ xfs_bmap_btalloc(
 	xfs_agnumber_t	ag;
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
 	xfs_agnumber_t	startag;
-	xfs_alloc_arg_t	args;
+	xfs_alloc_arg_t	*args;
 	xfs_extlen_t	blen;
 	xfs_extlen_t	delta;
 	xfs_extlen_t	longest;
@@ -2712,8 +2712,11 @@ xfs_bmap_btalloc(
 	int		isaligned;
 	int		notinit;
 	int		tryagain;
-	int		error;
+	int		error = 0;
 
+	args = kmem_zalloc(sizeof(xfs_alloc_arg_t), KM_SLEEP);
+	if (!args)
+		return XFS_ERROR(ENOMEM);
 	mp = ap->ip->i_mount;
 	align = (ap->userdata && ap->ip->i_d.di_extsize &&
 		(ap->ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)) ?
@@ -2746,29 +2749,29 @@ xfs_bmap_btalloc(
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
 	tryagain = isaligned = 0;
-	args.tp = ap->tp;
-	args.mp = mp;
-	args.fsbno = ap->rval;
-	args.maxlen = MIN(ap->alen, mp->m_sb.sb_agblocks);
-	args.firstblock = ap->firstblock;
+	args->tp = ap->tp;
+	args->mp = mp;
+	args->fsbno = ap->rval;
+	args->maxlen = MIN(ap->alen, mp->m_sb.sb_agblocks);
+	args->firstblock = ap->firstblock;
 	blen = 0;
 	if (nullfb) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.total = ap->total;
+		args->type = XFS_ALLOCTYPE_START_BNO;
+		args->total = ap->total;
 		/*
 		 * Find the longest available space.
 		 * We're going to try for the whole allocation at once.
 		 */
-		startag = ag = XFS_FSB_TO_AGNO(mp, args.fsbno);
+		startag = ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
 		notinit = 0;
 		down_read(&mp->m_peraglock);
 		while (blen < ap->alen) {
 			pag = &mp->m_perag[ag];
 			if (!pag->pagf_init &&
-			    (error = xfs_alloc_pagf_init(mp, args.tp,
+			    (error = xfs_alloc_pagf_init(mp, args->tp,
 				    ag, XFS_ALLOC_FLAG_TRYLOCK))) {
 				up_read(&mp->m_peraglock);
-				return error;
+				goto out_error;
 			}
 			/*
 			 * See xfs_alloc_fix_freelist...
@@ -2796,39 +2799,39 @@ xfs_bmap_btalloc(
 		 * possible that there is space for this request.
 		 */
 		if (notinit || blen < ap->minlen)
-			args.minlen = ap->minlen;
+			args->minlen = ap->minlen;
 		/*
 		 * If the best seen length is less than the request
 		 * length, use the best as the minimum.
 		 */
 		else if (blen < ap->alen)
-			args.minlen = blen;
+			args->minlen = blen;
 		/*
 		 * Otherwise we've seen an extent as big as alen,
 		 * use that as the minimum.
 		 */
 		else
-			args.minlen = ap->alen;
+			args->minlen = ap->alen;
 	} else if (ap->low) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.total = args.minlen = ap->minlen;
+		args->type = XFS_ALLOCTYPE_START_BNO;
+		args->total = args->minlen = ap->minlen;
 	} else {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.total = ap->total;
-		args.minlen = ap->minlen;
+		args->type = XFS_ALLOCTYPE_NEAR_BNO;
+		args->total = ap->total;
+		args->minlen = ap->minlen;
 	}
 	if (unlikely(ap->userdata && ap->ip->i_d.di_extsize &&
 		    (ap->ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE))) {
-		args.prod = ap->ip->i_d.di_extsize;
-		if ((args.mod = (xfs_extlen_t)do_mod(ap->off, args.prod)))
-			args.mod = (xfs_extlen_t)(args.prod - args.mod);
+		args->prod = ap->ip->i_d.di_extsize;
+		if ((args->mod = (xfs_extlen_t)do_mod(ap->off, args->prod)))
+			args->mod = (xfs_extlen_t)(args->prod - args->mod);
 	} else if (mp->m_sb.sb_blocksize >= NBPP) {
-		args.prod = 1;
-		args.mod = 0;
+		args->prod = 1;
+		args->mod = 0;
 	} else {
-		args.prod = NBPP >> mp->m_sb.sb_blocklog;
-		if ((args.mod = (xfs_extlen_t)(do_mod(ap->off, args.prod))))
-			args.mod = (xfs_extlen_t)(args.prod - args.mod);
+		args->prod = NBPP >> mp->m_sb.sb_blocklog;
+		if ((args->mod = (xfs_extlen_t)(do_mod(ap->off, args->prod))))
+			args->mod = (xfs_extlen_t)(args->prod - args->mod);
 	}
 	/*
 	 * If we are not low on available data blocks, and the
@@ -2841,25 +2844,25 @@ xfs_bmap_btalloc(
 	 */
 	if (!ap->low && ap->aeof) {
 		if (!ap->off) {
-			args.alignment = mp->m_dalign;
-			atype = args.type;
+			args->alignment = mp->m_dalign;
+			atype = args->type;
 			isaligned = 1;
 			/*
 			 * Adjust for alignment
 			 */
-			if (blen > args.alignment && blen <= ap->alen)
-				args.minlen = blen - args.alignment;
-			args.minalignslop = 0;
+			if (blen > args->alignment && blen <= ap->alen)
+				args->minlen = blen - args->alignment;
+			args->minalignslop = 0;
 		} else {
 			/*
 			 * First try an exact bno allocation.
 			 * If it fails then do a near or start bno
 			 * allocation with alignment turned on.
 			 */
-			atype = args.type;
+			atype = args->type;
 			tryagain = 1;
-			args.type = XFS_ALLOCTYPE_THIS_BNO;
-			args.alignment = 1;
+			args->type = XFS_ALLOCTYPE_THIS_BNO;
+			args->alignment = 1;
 			/*
 			 * Compute the minlen+alignment for the
 			 * next case.  Set slop so that the value
@@ -2869,75 +2872,75 @@ xfs_bmap_btalloc(
 			if (blen > mp->m_dalign && blen <= ap->alen)
 				nextminlen = blen - mp->m_dalign;
 			else
-				nextminlen = args.minlen;
-			if (nextminlen + mp->m_dalign > args.minlen + 1)
-				args.minalignslop =
+				nextminlen = args->minlen;
+			if (nextminlen + mp->m_dalign > args->minlen + 1)
+				args->minalignslop =
 					nextminlen + mp->m_dalign -
-					args.minlen - 1;
+					args->minlen - 1;
 			else
-				args.minalignslop = 0;
+				args->minalignslop = 0;
 		}
 	} else {
-		args.alignment = 1;
-		args.minalignslop = 0;
+		args->alignment = 1;
+		args->minalignslop = 0;
 	}
-	args.minleft = ap->minleft;
-	args.wasdel = ap->wasdel;
-	args.isfl = 0;
-	args.userdata = ap->userdata;
-	if ((error = xfs_alloc_vextent(&args)))
-		return error;
-	if (tryagain && args.fsbno == NULLFSBLOCK) {
+	args->minleft = ap->minleft;
+	args->wasdel = ap->wasdel;
+	args->isfl = 0;
+	args->userdata = ap->userdata;
+	if ((error = xfs_alloc_vextent(args)))
+		goto out_error;
+	if (tryagain && args->fsbno == NULLFSBLOCK) {
 		/*
 		 * Exact allocation failed. Now try with alignment
 		 * turned on.
 		 */
-		args.type = atype;
-		args.fsbno = ap->rval;
-		args.alignment = mp->m_dalign;
-		args.minlen = nextminlen;
-		args.minalignslop = 0;
+		args->type = atype;
+		args->fsbno = ap->rval;
+		args->alignment = mp->m_dalign;
+		args->minlen = nextminlen;
+		args->minalignslop = 0;
 		isaligned = 1;
-		if ((error = xfs_alloc_vextent(&args)))
+		if ((error = xfs_alloc_vextent(args)))
 			return error;
 	}
-	if (isaligned && args.fsbno == NULLFSBLOCK) {
+	if (isaligned && args->fsbno == NULLFSBLOCK) {
 		/*
 		 * allocation failed, so turn off alignment and
 		 * try again.
 		 */
-		args.type = atype;
-		args.fsbno = ap->rval;
-		args.alignment = 0;
-		if ((error = xfs_alloc_vextent(&args)))
-			return error;
-	}
-	if (args.fsbno == NULLFSBLOCK && nullfb &&
-	    args.minlen > ap->minlen) {
-		args.minlen = ap->minlen;
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = ap->rval;
-		if ((error = xfs_alloc_vextent(&args)))
-			return error;
-	}
-	if (args.fsbno == NULLFSBLOCK && nullfb) {
-		args.fsbno = 0;
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
-		args.total = ap->minlen;
-		args.minleft = 0;
-		if ((error = xfs_alloc_vextent(&args)))
-			return error;
+		args->type = atype;
+		args->fsbno = ap->rval;
+		args->alignment = 0;
+		if ((error = xfs_alloc_vextent(args)))
+			goto out_error;
+	}
+	if (args->fsbno == NULLFSBLOCK && nullfb &&
+	    args->minlen > ap->minlen) {
+		args->minlen = ap->minlen;
+		args->type = XFS_ALLOCTYPE_START_BNO;
+		args->fsbno = ap->rval;
+		if ((error = xfs_alloc_vextent(args)))
+			goto out_error;
+	}
+	if (args->fsbno == NULLFSBLOCK && nullfb) {
+		args->fsbno = 0;
+		args->type = XFS_ALLOCTYPE_FIRST_AG;
+		args->total = ap->minlen;
+		args->minleft = 0;
+		if ((error = xfs_alloc_vextent(args)))
+			goto out_error;
 		ap->low = 1;
 	}
-	if (args.fsbno != NULLFSBLOCK) {
-		ap->firstblock = ap->rval = args.fsbno;
-		ASSERT(nullfb || fb_agno == args.agno ||
-		       (ap->low && fb_agno < args.agno));
-		ap->alen = args.len;
-		ap->ip->i_d.di_nblocks += args.len;
+	if (args->fsbno != NULLFSBLOCK) {
+		ap->firstblock = ap->rval = args->fsbno;
+		ASSERT(nullfb || fb_agno == args->agno ||
+		       (ap->low && fb_agno < args->agno));
+		ap->alen = args->len;
+		ap->ip->i_d.di_nblocks += args->len;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 		if (ap->wasdel)
-			ap->ip->i_delayed_blks -= args.len;
+			ap->ip->i_delayed_blks -= args->len;
 		/*
 		 * Adjust the disk quota also. This was reserved
 		 * earlier.
@@ -2945,12 +2948,14 @@ xfs_bmap_btalloc(
 		XFS_TRANS_MOD_DQUOT_BYINO(mp, ap->tp, ap->ip,
 			ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
 					XFS_TRANS_DQ_BCOUNT,
-			(long) args.len);
+			(long) args->len);
 	} else {
 		ap->rval = NULLFSBLOCK;
 		ap->alen = 0;
 	}
-	return 0;
+out_error:
+	kmem_free(args, sizeof(xfs_alloc_arg_t));
+	return error;
 }
 
 /*
@@ -3395,7 +3400,7 @@ xfs_bmap_extents_to_btree(
 {
 	xfs_bmbt_block_t	*ablock;	/* allocated (child) bt block */
 	xfs_buf_t		*abp;		/* buffer for ablock */
-	xfs_alloc_arg_t		args;		/* allocation arguments */
+	xfs_alloc_arg_t		*args;		/* allocation arguments */
 	xfs_bmbt_rec_t		*arp;		/* child record pointer */
 	xfs_bmbt_block_t	*block;		/* btree root block */
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
@@ -3408,6 +3413,9 @@ xfs_bmap_extents_to_btree(
 	xfs_extnum_t		nextents;	/* number of file extents */
 	xfs_bmbt_ptr_t		*pp;		/* root block address pointer */
 
+	args = kmem_zalloc(sizeof(xfs_alloc_arg_t), KM_SLEEP);
+	if (!args)
+		return XFS_ERROR(ENOMEM);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS);
 	ASSERT(ifp->if_ext_max ==
@@ -3439,42 +3447,42 @@ xfs_bmap_extents_to_btree(
 	 * Convert to a btree with two levels, one record in root.
 	 */
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_BTREE);
-	args.tp = tp;
-	args.mp = mp;
-	args.firstblock = *firstblock;
+	args->tp = tp;
+	args->mp = mp;
+	args->firstblock = *firstblock;
 	if (*firstblock == NULLFSBLOCK) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
+		args->type = XFS_ALLOCTYPE_START_BNO;
+		args->fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
 	} else if (flist->xbf_low) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = *firstblock;
+		args->type = XFS_ALLOCTYPE_START_BNO;
+		args->fsbno = *firstblock;
 	} else {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.fsbno = *firstblock;
+		args->type = XFS_ALLOCTYPE_NEAR_BNO;
+		args->fsbno = *firstblock;
 	}
-	args.minlen = args.maxlen = args.prod = 1;
-	args.total = args.minleft = args.alignment = args.mod = args.isfl =
-		args.minalignslop = 0;
-	args.wasdel = wasdel;
+	args->minlen = args->maxlen = args->prod = 1;
+	args->total = args->minleft = args->alignment = args->mod = args->isfl =
+		args->minalignslop = 0;
+	args->wasdel = wasdel;
 	*logflagsp = 0;
-	if ((error = xfs_alloc_vextent(&args))) {
+	if ((error = xfs_alloc_vextent(args))) {
 		xfs_iroot_realloc(ip, -1, whichfork);
 		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-		return error;
+		goto out_error;
 	}
 	/*
 	 * Allocation can't fail, the space was reserved.
 	 */
-	ASSERT(args.fsbno != NULLFSBLOCK);
+	ASSERT(args->fsbno != NULLFSBLOCK);
 	ASSERT(*firstblock == NULLFSBLOCK ||
-	       args.agno == XFS_FSB_TO_AGNO(mp, *firstblock) ||
+	       args->agno == XFS_FSB_TO_AGNO(mp, *firstblock) ||
 	       (flist->xbf_low &&
-		args.agno > XFS_FSB_TO_AGNO(mp, *firstblock)));
-	*firstblock = cur->bc_private.b.firstblock = args.fsbno;
+		args->agno > XFS_FSB_TO_AGNO(mp, *firstblock)));
+	*firstblock = cur->bc_private.b.firstblock = args->fsbno;
 	cur->bc_private.b.allocated++;
 	ip->i_d.di_nblocks++;
 	XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
-	abp = xfs_btree_get_bufl(mp, tp, args.fsbno, 0);
+	abp = xfs_btree_get_bufl(mp, tp, args->fsbno, 0);
 	/*
 	 * Fill in the child block.
 	 */
@@ -3502,7 +3510,7 @@ xfs_bmap_extents_to_btree(
 	arp = XFS_BMAP_REC_IADDR(ablock, 1, cur);
 	kp->br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(arp));
 	pp = XFS_BMAP_PTR_IADDR(block, 1, cur);
-	*pp = cpu_to_be64(args.fsbno);
+	*pp = cpu_to_be64(args->fsbno);
 	/*
 	 * Do all this logging at the end so that
 	 * the root is at the right level.
@@ -3512,7 +3520,9 @@ xfs_bmap_extents_to_btree(
 	ASSERT(*curp == NULL);
 	*curp = cur;
 	*logflagsp = XFS_ILOG_CORE | XFS_ILOG_FBROOT(whichfork);
-	return 0;
+out_error:
+	kmem_free(args, sizeof(xfs_alloc_arg_t));
+	return error;
 }
 
 /*
@@ -3572,13 +3582,16 @@ xfs_bmap_local_to_extents(
 	flags = 0;
 	error = 0;
 	if (ifp->if_bytes) {
-		xfs_alloc_arg_t	args;	/* allocation arguments */
+		xfs_alloc_arg_t	*args;	/* allocation arguments */
 		xfs_buf_t	*bp;	/* buffer for extent block */
 		xfs_bmbt_rec_t	*ep;	/* extent record pointer */
 
-		args.tp = tp;
-		args.mp = ip->i_mount;
-		args.firstblock = *firstblock;
+		args = kmem_zalloc(sizeof(xfs_alloc_arg_t), KM_SLEEP);
+		if (!args)
+			return XFS_ERROR(ENOMEM);
+		args->tp = tp;
+		args->mp = ip->i_mount;
+		args->firstblock = *firstblock;
 		ASSERT((ifp->if_flags &
 			(XFS_IFINLINE|XFS_IFEXTENTS|XFS_IFEXTIREC)) == XFS_IFINLINE);
 		/*
@@ -3586,39 +3599,42 @@ xfs_bmap_local_to_extents(
 		 * file currently fits in an inode.
 		 */
 		if (*firstblock == NULLFSBLOCK) {
-			args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
-			args.type = XFS_ALLOCTYPE_START_BNO;
+			args->fsbno = XFS_INO_TO_FSB(args->mp, ip->i_ino);
+			args->type = XFS_ALLOCTYPE_START_BNO;
 		} else {
-			args.fsbno = *firstblock;
-			args.type = XFS_ALLOCTYPE_NEAR_BNO;
+			args->fsbno = *firstblock;
+			args->type = XFS_ALLOCTYPE_NEAR_BNO;
 		}
-		args.total = total;
-		args.mod = args.minleft = args.alignment = args.wasdel =
-			args.isfl = args.minalignslop = 0;
-		args.minlen = args.maxlen = args.prod = 1;
-		if ((error = xfs_alloc_vextent(&args)))
+		args->total = total;
+		args->mod = args->minleft = args->alignment = args->wasdel =
+			args->isfl = args->minalignslop = 0;
+		args->minlen = args->maxlen = args->prod = 1;
+		if ((error = xfs_alloc_vextent(args))) {
+			kmem_free(args, sizeof(xfs_alloc_arg_t));
 			goto done;
+		}
 		/*
 		 * Can't fail, the space was reserved.
 		 */
-		ASSERT(args.fsbno != NULLFSBLOCK);
-		ASSERT(args.len == 1);
-		*firstblock = args.fsbno;
-		bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
+		ASSERT(args->fsbno != NULLFSBLOCK);
+		ASSERT(args->len == 1);
+		*firstblock = args->fsbno;
+		bp = xfs_btree_get_bufl(args->mp, tp, args->fsbno, 0);
 		memcpy((char *)XFS_BUF_PTR(bp), ifp->if_u1.if_data,
 			ifp->if_bytes);
 		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
-		xfs_bmap_forkoff_reset(args.mp, ip, whichfork);
+		xfs_bmap_forkoff_reset(args->mp, ip, whichfork);
 		xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
 		xfs_iext_add(ifp, 0, 1);
 		ep = xfs_iext_get_ext(ifp, 0);
-		xfs_bmbt_set_allf(ep, 0, args.fsbno, 1, XFS_EXT_NORM);
+		xfs_bmbt_set_allf(ep, 0, args->fsbno, 1, XFS_EXT_NORM);
 		xfs_bmap_trace_post_update(fname, "new", ip, 0, whichfork);
 		XFS_IFORK_NEXT_SET(ip, whichfork, 1);
 		ip->i_d.di_nblocks = 1;
-		XFS_TRANS_MOD_DQUOT_BYINO(args.mp, tp, ip,
+		XFS_TRANS_MOD_DQUOT_BYINO(args->mp, tp, ip,
 			XFS_TRANS_DQ_BCOUNT, 1L);
 		flags |= XFS_ILOG_FEXT(whichfork);
+		kmem_free(args, sizeof(xfs_alloc_arg_t));
 	} else {
 		ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) == 0);
 		xfs_bmap_forkoff_reset(ip->i_mount, ip, whichfork);
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap_btree.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap_btree.c	2007-03-30 11:31:24.239345301 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap_btree.c	2007-03-30 11:32:42.257159915 +1000
@@ -1490,7 +1490,7 @@ xfs_bmbt_split(
 	xfs_btree_cur_t		**curp,
 	int			*stat)		/* success/failure */
 {
-	xfs_alloc_arg_t		args;		/* block allocation args */
+	xfs_alloc_arg_t		*args;		/* block allocation args */
 	int			error;		/* error return value */
 #ifdef XFS_BMBT_TRACE
 	static char		fname[] = "xfs_bmbt_split";
@@ -1510,50 +1510,54 @@ xfs_bmbt_split(
 	xfs_buf_t		*rrbp;		/* right-right buffer pointer */
 	xfs_bmbt_rec_t		*rrp;		/* right record pointer */
 
+	args = kmem_zalloc(sizeof(xfs_alloc_arg_t), KM_SLEEP);
+	if (!args)
+		return XFS_ERROR(ENOMEM);
 	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
 	XFS_BMBT_TRACE_ARGIFK(cur, level, *bnop, *startoff);
-	args.tp = cur->bc_tp;
-	args.mp = cur->bc_mp;
+	args->tp = cur->bc_tp;
+	args->mp = cur->bc_mp;
 	lbp = cur->bc_bufs[level];
-	lbno = XFS_DADDR_TO_FSB(args.mp, XFS_BUF_ADDR(lbp));
+	lbno = XFS_DADDR_TO_FSB(args->mp, XFS_BUF_ADDR(lbp));
 	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
-	args.fsbno = cur->bc_private.b.firstblock;
-	args.firstblock = args.fsbno;
-	if (args.fsbno == NULLFSBLOCK) {
-		args.fsbno = lbno;
-		args.type = XFS_ALLOCTYPE_START_BNO;
+	args->fsbno = cur->bc_private.b.firstblock;
+	args->firstblock = args->fsbno;
+	if (args->fsbno == NULLFSBLOCK) {
+		args->fsbno = lbno;
+		args->type = XFS_ALLOCTYPE_START_BNO;
 	} else
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	args.mod = args.minleft = args.alignment = args.total = args.isfl =
-		args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
-	if (!args.wasdel && xfs_trans_get_block_res(args.tp) == 0) {
+		args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	args->mod = args->minleft = args->alignment = args->total = args->isfl =
+		args->userdata = args->minalignslop = 0;
+	args->minlen = args->maxlen = args->prod = 1;
+	args->wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
+	if (!args->wasdel && xfs_trans_get_block_res(args->tp) == 0) {
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
+		kmem_free(args, sizeof(xfs_alloc_arg_t));
 		return XFS_ERROR(ENOSPC);
 	}
-	if ((error = xfs_alloc_vextent(&args))) {
+	if ((error = xfs_alloc_vextent(args))) {
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
+		goto out_error;
 	}
-	if (args.fsbno == NULLFSBLOCK) {
+	if (args->fsbno == NULLFSBLOCK) {
 		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
 		*stat = 0;
-		return 0;
+		goto out_error;
 	}
-	ASSERT(args.len == 1);
-	cur->bc_private.b.firstblock = args.fsbno;
+	ASSERT(args->len == 1);
+	cur->bc_private.b.firstblock = args->fsbno;
 	cur->bc_private.b.allocated++;
 	cur->bc_private.b.ip->i_d.di_nblocks++;
-	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
-	XFS_TRANS_MOD_DQUOT_BYINO(args.mp, args.tp, cur->bc_private.b.ip,
+	xfs_trans_log_inode(args->tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
+	XFS_TRANS_MOD_DQUOT_BYINO(args->mp, args->tp, cur->bc_private.b.ip,
 			XFS_TRANS_DQ_BCOUNT, 1L);
-	rbp = xfs_btree_get_bufl(args.mp, args.tp, args.fsbno, 0);
+	rbp = xfs_btree_get_bufl(args->mp, args->tp, args->fsbno, 0);
 	right = XFS_BUF_TO_BMBT_BLOCK(rbp);
 #ifdef DEBUG
 	if ((error = xfs_btree_check_lblock(cur, left, level, rbp))) {
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
+		goto out_error;
 	}
 #endif
 	right->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
@@ -1572,7 +1576,7 @@ xfs_bmbt_split(
 		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
 			if ((error = xfs_btree_check_lptr_disk(cur, lpp[i], level))) {
 				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
+				goto out_error;
 			}
 		}
 #endif
@@ -1590,23 +1594,23 @@ xfs_bmbt_split(
 	}
 	be16_add(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
 	right->bb_rightsib = left->bb_rightsib;
-	left->bb_rightsib = cpu_to_be64(args.fsbno);
+	left->bb_rightsib = cpu_to_be64(args->fsbno);
 	right->bb_leftsib = cpu_to_be64(lbno);
 	xfs_bmbt_log_block(cur, rbp, XFS_BB_ALL_BITS);
 	xfs_bmbt_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
 	if (be64_to_cpu(right->bb_rightsib) != NULLDFSBNO) {
-		if ((error = xfs_btree_read_bufl(args.mp, args.tp,
+		if ((error = xfs_btree_read_bufl(args->mp, args->tp,
 				be64_to_cpu(right->bb_rightsib), 0, &rrbp,
 				XFS_BMAP_BTREE_REF))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
+			goto out_error;
 		}
 		rrblock = XFS_BUF_TO_BMBT_BLOCK(rrbp);
 		if ((error = xfs_btree_check_lblock(cur, rrblock, level, rrbp))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
+			goto out_error;
 		}
-		rrblock->bb_leftsib = cpu_to_be64(args.fsbno);
+		rrblock->bb_leftsib = cpu_to_be64(args->fsbno);
 		xfs_bmbt_log_block(cur, rrbp, XFS_BB_LEFTSIB);
 	}
 	if (cur->bc_ptrs[level] > be16_to_cpu(left->bb_numrecs) + 1) {
@@ -1616,14 +1620,16 @@ xfs_bmbt_split(
 	if (level + 1 < cur->bc_nlevels) {
 		if ((error = xfs_btree_dup_cursor(cur, curp))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
+			goto out_error;
 		}
 		(*curp)->bc_ptrs[level + 1]++;
 	}
-	*bnop = args.fsbno;
+	*bnop = args->fsbno;
 	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
 	*stat = 1;
-	return 0;
+out_error:
+	kmem_free(args, sizeof(xfs_alloc_arg_t));
+	return error;
 }
 
 
@@ -2238,7 +2244,7 @@ xfs_bmbt_newroot(
 	int			*logflags,	/* logging flags for inode */
 	int			*stat)		/* return status - 0 fail */
 {
-	xfs_alloc_arg_t		args;		/* allocation arguments */
+	xfs_alloc_arg_t		*args;		/* allocation arguments */
 	xfs_bmbt_block_t	*block;		/* bmap btree block */
 	xfs_buf_t		*bp;		/* buffer for block */
 	xfs_bmbt_block_t	*cblock;	/* child btree block */
@@ -2255,48 +2261,51 @@ xfs_bmbt_newroot(
 	int			level;		/* btree level */
 	xfs_bmbt_ptr_t		*pp;		/* pointer to bmap block addr */
 
+	args = kmem_zalloc(sizeof(xfs_alloc_arg_t), KM_SLEEP);
+	if (!args)
+		return XFS_ERROR(ENOMEM);
 	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
 	level = cur->bc_nlevels - 1;
 	block = xfs_bmbt_get_block(cur, level, &bp);
 	/*
 	 * Copy the root into a real block.
 	 */
-	args.mp = cur->bc_mp;
+	args->mp = cur->bc_mp;
 	pp = XFS_BMAP_PTR_IADDR(block, 1, cur);
-	args.tp = cur->bc_tp;
-	args.fsbno = cur->bc_private.b.firstblock;
-	args.mod = args.minleft = args.alignment = args.total = args.isfl =
-		args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
-	args.firstblock = args.fsbno;
-	if (args.fsbno == NULLFSBLOCK) {
+	args->tp = cur->bc_tp;
+	args->fsbno = cur->bc_private.b.firstblock;
+	args->mod = args->minleft = args->alignment = args->total = args->isfl =
+		args->userdata = args->minalignslop = 0;
+	args->minlen = args->maxlen = args->prod = 1;
+	args->wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
+	args->firstblock = args->fsbno;
+	if (args->fsbno == NULLFSBLOCK) {
 #ifdef DEBUG
 		if ((error = xfs_btree_check_lptr_disk(cur, *pp, level))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
+			goto out_error;
 		}
 #endif
-		args.fsbno = be64_to_cpu(*pp);
-		args.type = XFS_ALLOCTYPE_START_BNO;
+		args->fsbno = be64_to_cpu(*pp);
+		args->type = XFS_ALLOCTYPE_START_BNO;
 	} else
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	if ((error = xfs_alloc_vextent(&args))) {
+		args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	if ((error = xfs_alloc_vextent(args))) {
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
+		goto out_error;
 	}
-	if (args.fsbno == NULLFSBLOCK) {
+	if (args->fsbno == NULLFSBLOCK) {
 		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
 		*stat = 0;
-		return 0;
+		goto out_error;
 	}
-	ASSERT(args.len == 1);
-	cur->bc_private.b.firstblock = args.fsbno;
+	ASSERT(args->len == 1);
+	cur->bc_private.b.firstblock = args->fsbno;
 	cur->bc_private.b.allocated++;
 	cur->bc_private.b.ip->i_d.di_nblocks++;
-	XFS_TRANS_MOD_DQUOT_BYINO(args.mp, args.tp, cur->bc_private.b.ip,
+	XFS_TRANS_MOD_DQUOT_BYINO(args->mp, args->tp, cur->bc_private.b.ip,
 			  XFS_TRANS_DQ_BCOUNT, 1L);
-	bp = xfs_btree_get_bufl(args.mp, cur->bc_tp, args.fsbno, 0);
+	bp = xfs_btree_get_bufl(args->mp, cur->bc_tp, args->fsbno, 0);
 	cblock = XFS_BUF_TO_BMBT_BLOCK(bp);
 	*cblock = *block;
 	be16_add(&block->bb_level, 1);
@@ -2311,18 +2320,18 @@ xfs_bmbt_newroot(
 	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
 		if ((error = xfs_btree_check_lptr_disk(cur, pp[i], level))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
+			goto out_error;
 		}
 	}
 #endif
 	memcpy(cpp, pp, be16_to_cpu(cblock->bb_numrecs) * sizeof(*pp));
 #ifdef DEBUG
-	if ((error = xfs_btree_check_lptr(cur, args.fsbno, level))) {
+	if ((error = xfs_btree_check_lptr(cur, args->fsbno, level))) {
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
+		goto out_error;
 	}
 #endif
-	*pp = cpu_to_be64(args.fsbno);
+	*pp = cpu_to_be64(args->fsbno);
 	xfs_iroot_realloc(cur->bc_private.b.ip, 1 - be16_to_cpu(cblock->bb_numrecs),
 		cur->bc_private.b.whichfork);
 	xfs_btree_setbuf(cur, level, bp);
@@ -2337,6 +2346,8 @@ xfs_bmbt_newroot(
 	*logflags |=
 		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork);
 	*stat = 1;
+out_error:
+	kmem_free(args, sizeof(xfs_alloc_arg_t));
 	return 0;
 }
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.c	2007-03-30 11:31:24.239345301 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c	2007-03-30 11:32:50.168127184 +1000
@@ -119,7 +119,7 @@ xfs_ialloc_ag_alloc(
 	int		*alloc)
 {
 	xfs_agi_t	*agi;		/* allocation group header */
-	xfs_alloc_arg_t	args;		/* allocation argument structure */
+	xfs_alloc_arg_t	*args;		/* allocation argument structure */
 	int		blks_per_cluster;  /* fs blocks per inode cluster */
 	xfs_btree_cur_t	*cur;		/* inode btree cursor */
 	xfs_daddr_t	d;		/* disk addr of buffer */
@@ -138,18 +138,23 @@ xfs_ialloc_ag_alloc(
 	int		isaligned = 0;	/* inode allocation at stripe unit */
 					/* boundary */
 
-	args.tp = tp;
-	args.mp = tp->t_mountp;
+	args = kmem_zalloc(sizeof(xfs_alloc_arg_t), KM_SLEEP);
+	if (!args)
+		return XFS_ERROR(ENOMEM);
+	args->tp = tp;
+	args->mp = tp->t_mountp;
 
 	/*
 	 * Locking will ensure that we don't have two callers in here
 	 * at one time.
 	 */
-	newlen = XFS_IALLOC_INODES(args.mp);
-	if (args.mp->m_maxicount &&
-	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
+	newlen = XFS_IALLOC_INODES(args->mp);
+	if (args->mp->m_maxicount &&
+	    args->mp->m_sb.sb_icount + newlen > args->mp->m_maxicount) {
+		kmem_free(args, sizeof(xfs_alloc_arg_t));
 		return XFS_ERROR(ENOSPC);
-	args.minlen = args.maxlen = XFS_IALLOC_BLOCKS(args.mp);
+	}
+	args->minlen = args->maxlen = XFS_IALLOC_BLOCKS(args->mp);
 	/*
 	 * First try to allocate inodes contiguous with the last-allocated
 	 * chunk of inodes.  If the filesystem is striped, this will fill
@@ -157,27 +162,27 @@ xfs_ialloc_ag_alloc(
  	 */
 	agi = XFS_BUF_TO_AGI(agbp);
 	newino = be32_to_cpu(agi->agi_newino);
-	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
-			XFS_IALLOC_BLOCKS(args.mp);
+	args->agbno = XFS_AGINO_TO_AGBNO(args->mp, newino) +
+			XFS_IALLOC_BLOCKS(args->mp);
 	if (likely(newino != NULLAGINO &&
-		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
-		args.fsbno = XFS_AGB_TO_FSB(args.mp,
-				be32_to_cpu(agi->agi_seqno), args.agbno);
-		args.type = XFS_ALLOCTYPE_THIS_BNO;
-		args.mod = args.total = args.wasdel = args.isfl =
-			args.userdata = args.minalignslop = 0;
-		args.prod = 1;
-		args.alignment = 1;
+		  (args->agbno < be32_to_cpu(agi->agi_length)))) {
+		args->fsbno = XFS_AGB_TO_FSB(args->mp,
+				be32_to_cpu(agi->agi_seqno), args->agbno);
+		args->type = XFS_ALLOCTYPE_THIS_BNO;
+		args->mod = args->total = args->wasdel = args->isfl =
+			args->userdata = args->minalignslop = 0;
+		args->prod = 1;
+		args->alignment = 1;
 		/*
 		 * Allow space for the inode btree to split.
 		 */
-		args.minleft = XFS_IN_MAXLEVELS(args.mp) - 1;
-		if ((error = xfs_alloc_vextent(&args)))
-			return error;
+		args->minleft = XFS_IN_MAXLEVELS(args->mp) - 1;
+		if ((error = xfs_alloc_vextent(args)))
+			goto out_error;
 	} else
-		args.fsbno = NULLFSBLOCK;
+		args->fsbno = NULLFSBLOCK;
 
-	if (unlikely(args.fsbno == NULLFSBLOCK)) {
+	if (unlikely(args->fsbno == NULLFSBLOCK)) {
 		/*
 		 * Set the alignment for the allocation.
 		 * If stripe alignment is turned on then align at stripe unit
@@ -187,82 +192,82 @@ xfs_ialloc_ag_alloc(
 		 * pieces, so don't need alignment anyway.
 		 */
 		isaligned = 0;
-		if (args.mp->m_sinoalign) {
-			ASSERT(!(args.mp->m_flags & XFS_MOUNT_NOALIGN));
-			args.alignment = args.mp->m_dalign;
+		if (args->mp->m_sinoalign) {
+			ASSERT(!(args->mp->m_flags & XFS_MOUNT_NOALIGN));
+			args->alignment = args->mp->m_dalign;
 			isaligned = 1;
-		} else if (XFS_SB_VERSION_HASALIGN(&args.mp->m_sb) &&
-			   args.mp->m_sb.sb_inoalignmt >=
-			   XFS_B_TO_FSBT(args.mp,
-			  	XFS_INODE_CLUSTER_SIZE(args.mp)))
-				args.alignment = args.mp->m_sb.sb_inoalignmt;
+		} else if (XFS_SB_VERSION_HASALIGN(&args->mp->m_sb) &&
+			   args->mp->m_sb.sb_inoalignmt >=
+			   XFS_B_TO_FSBT(args->mp,
+			  	XFS_INODE_CLUSTER_SIZE(args->mp)))
+				args->alignment = args->mp->m_sb.sb_inoalignmt;
 		else
-			args.alignment = 1;
+			args->alignment = 1;
 		/*
 		 * Need to figure out where to allocate the inode blocks.
 		 * Ideally they should be spaced out through the a.g.
 		 * For now, just allocate blocks up front.
 		 */
-		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp,
-				be32_to_cpu(agi->agi_seqno), args.agbno);
+		args->agbno = be32_to_cpu(agi->agi_root);
+		args->fsbno = XFS_AGB_TO_FSB(args->mp,
+				be32_to_cpu(agi->agi_seqno), args->agbno);
 		/*
 		 * Allocate a fixed-size extent of inodes.
 		 */
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.mod = args.total = args.wasdel = args.isfl =
-			args.userdata = args.minalignslop = 0;
-		args.prod = 1;
+		args->type = XFS_ALLOCTYPE_NEAR_BNO;
+		args->mod = args->total = args->wasdel = args->isfl =
+			args->userdata = args->minalignslop = 0;
+		args->prod = 1;
 		/*
 		 * Allow space for the inode btree to split.
 		 */
-		args.minleft = XFS_IN_MAXLEVELS(args.mp) - 1;
-		if ((error = xfs_alloc_vextent(&args)))
-			return error;
+		args->minleft = XFS_IN_MAXLEVELS(args->mp) - 1;
+		if ((error = xfs_alloc_vextent(args)))
+			goto out_error;
 	}
 
 	/*
 	 * If stripe alignment is turned on, then try again with cluster
 	 * alignment.
 	 */
-	if (isaligned && args.fsbno == NULLFSBLOCK) {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp,
-				be32_to_cpu(agi->agi_seqno), args.agbno);
-		if (XFS_SB_VERSION_HASALIGN(&args.mp->m_sb) &&
-			args.mp->m_sb.sb_inoalignmt >=
-			XFS_B_TO_FSBT(args.mp, XFS_INODE_CLUSTER_SIZE(args.mp)))
-				args.alignment = args.mp->m_sb.sb_inoalignmt;
+	if (isaligned && args->fsbno == NULLFSBLOCK) {
+		args->type = XFS_ALLOCTYPE_NEAR_BNO;
+		args->agbno = be32_to_cpu(agi->agi_root);
+		args->fsbno = XFS_AGB_TO_FSB(args->mp,
+				be32_to_cpu(agi->agi_seqno), args->agbno);
+		if (XFS_SB_VERSION_HASALIGN(&args->mp->m_sb) &&
+			args->mp->m_sb.sb_inoalignmt >=
+			XFS_B_TO_FSBT(args->mp, XFS_INODE_CLUSTER_SIZE(args->mp)))
+				args->alignment = args->mp->m_sb.sb_inoalignmt;
 		else
-			args.alignment = 1;
-		if ((error = xfs_alloc_vextent(&args)))
-			return error;
+			args->alignment = 1;
+		if ((error = xfs_alloc_vextent(args)))
+			goto out_error;
 	}
 
-	if (args.fsbno == NULLFSBLOCK) {
+	if (args->fsbno == NULLFSBLOCK) {
 		*alloc = 0;
-		return 0;
+		goto out_error;
 	}
-	ASSERT(args.len == args.minlen);
+	ASSERT(args->len == args->minlen);
 	/*
 	 * Convert the results.
 	 */
-	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
+	newino = XFS_OFFBNO_TO_AGINO(args->mp, args->agbno, 0);
 	/*
 	 * Loop over the new block(s), filling in the inodes.
 	 * For small block sizes, manipulate the inodes in buffers
 	 * which are multiples of the blocks size.
 	 */
-	if (args.mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(args.mp)) {
+	if (args->mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(args->mp)) {
 		blks_per_cluster = 1;
-		nbufs = (int)args.len;
-		ninodes = args.mp->m_sb.sb_inopblock;
+		nbufs = (int)args->len;
+		ninodes = args->mp->m_sb.sb_inopblock;
 	} else {
-		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(args.mp) /
-				   args.mp->m_sb.sb_blocksize;
-		nbufs = (int)args.len / blks_per_cluster;
-		ninodes = blks_per_cluster * args.mp->m_sb.sb_inopblock;
+		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(args->mp) /
+				   args->mp->m_sb.sb_blocksize;
+		nbufs = (int)args->len / blks_per_cluster;
+		ninodes = blks_per_cluster * args->mp->m_sb.sb_inopblock;
 	}
 	/*
 	 * Figure out what version number to use in the inodes we create.
@@ -271,7 +276,7 @@ xfs_ialloc_ag_alloc(
 	 * use the old version so that old kernels will continue to be
 	 * able to use the file system.
 	 */
-	if (XFS_SB_VERSION_HASNLINK(&args.mp->m_sb))
+	if (XFS_SB_VERSION_HASNLINK(&args->mp->m_sb))
 		version = XFS_DINODE_VERSION_2;
 	else
 		version = XFS_DINODE_VERSION_1;
@@ -280,19 +285,19 @@ xfs_ialloc_ag_alloc(
 		/*
 		 * Get the block.
 		 */
-		d = XFS_AGB_TO_DADDR(args.mp, be32_to_cpu(agi->agi_seqno),
-				     args.agbno + (j * blks_per_cluster));
-		fbuf = xfs_trans_get_buf(tp, args.mp->m_ddev_targp, d,
-					 args.mp->m_bsize * blks_per_cluster,
+		d = XFS_AGB_TO_DADDR(args->mp, be32_to_cpu(agi->agi_seqno),
+				     args->agbno + (j * blks_per_cluster));
+		fbuf = xfs_trans_get_buf(tp, args->mp->m_ddev_targp, d,
+					 args->mp->m_bsize * blks_per_cluster,
 					 XFS_BUF_LOCK);
 		ASSERT(fbuf);
 		ASSERT(!XFS_BUF_GETERROR(fbuf));
 		/*
 		 * Set initial values for the inodes in this buffer.
 		 */
-		xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
+		xfs_biozero(fbuf, 0, ninodes << args->mp->m_sb.sb_inodelog);
 		for (i = 0; i < ninodes; i++) {
-			free = XFS_MAKE_IPTR(args.mp, fbuf, i);
+			free = XFS_MAKE_IPTR(args->mp, fbuf, i);
 			INT_SET(free->di_core.di_magic, ARCH_CONVERT, XFS_DINODE_MAGIC);
 			INT_SET(free->di_core.di_version, ARCH_CONVERT, version);
 			INT_SET(free->di_next_unlinked, ARCH_CONVERT, NULLAGINO);
@@ -304,14 +309,14 @@ xfs_ialloc_ag_alloc(
 	be32_add(&agi->agi_count, newlen);
 	be32_add(&agi->agi_freecount, newlen);
 	agno = be32_to_cpu(agi->agi_seqno);
-	down_read(&args.mp->m_peraglock);
-	args.mp->m_perag[agno].pagi_freecount += newlen;
-	up_read(&args.mp->m_peraglock);
+	down_read(&args->mp->m_peraglock);
+	args->mp->m_perag[agno].pagi_freecount += newlen;
+	up_read(&args->mp->m_peraglock);
 	agi->agi_newino = cpu_to_be32(newino);
 	/*
 	 * Insert records describing the new inode chunk into the btree.
 	 */
-	cur = xfs_btree_init_cursor(args.mp, tp, agbp, agno,
+	cur = xfs_btree_init_cursor(args->mp, tp, agbp, agno,
 			XFS_BTNUM_INO, (xfs_inode_t *)0, 0);
 	for (thisino = newino;
 	     thisino < newino + newlen;
@@ -319,12 +324,12 @@ xfs_ialloc_ag_alloc(
 		if ((error = xfs_inobt_lookup_eq(cur, thisino,
 				XFS_INODES_PER_CHUNK, XFS_INOBT_ALL_FREE, &i))) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-			return error;
+			goto out_error;
 		}
 		ASSERT(i == 0);
 		if ((error = xfs_inobt_insert(cur, &i))) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-			return error;
+			goto out_error;
 		}
 		ASSERT(i == 1);
 	}
@@ -340,7 +345,9 @@ xfs_ialloc_ag_alloc(
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, (long)newlen);
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, (long)newlen);
 	*alloc = 1;
-	return 0;
+out_error:
+	kmem_free(args, sizeof(xfs_alloc_arg_t));
+	return error;
 }
 
 STATIC_INLINE xfs_agnumber_t
Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc_btree.c	2007-03-30 11:31:24.239345301 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc_btree.c	2007-03-30 11:32:30.678671441 +1000
@@ -1185,7 +1185,7 @@ xfs_inobt_newroot(
 	int			*stat)	/* success/failure */
 {
 	xfs_agi_t		*agi;	/* a.g. inode header */
-	xfs_alloc_arg_t		args;	/* allocation argument structure */
+	xfs_alloc_arg_t		*args;	/* allocation argument structure */
 	xfs_inobt_block_t	*block;	/* one half of the old root block */
 	xfs_buf_t		*bp;	/* buffer containing block */
 	int			error;	/* error return value */
@@ -1207,33 +1207,36 @@ xfs_inobt_newroot(
 	/*
 	 * Get a block & a buffer.
 	 */
+	args = kmem_zalloc(sizeof(xfs_alloc_arg_t), KM_SLEEP);
+	if (!args)
+		return XFS_ERROR(ENOMEM);
 	agi = XFS_BUF_TO_AGI(cur->bc_private.i.agbp);
-	args.tp = cur->bc_tp;
-	args.mp = cur->bc_mp;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.i.agno,
+	args->tp = cur->bc_tp;
+	args->mp = cur->bc_mp;
+	args->fsbno = XFS_AGB_TO_FSB(args->mp, cur->bc_private.i.agno,
 		be32_to_cpu(agi->agi_root));
-	args.mod = args.minleft = args.alignment = args.total = args.wasdel =
-		args.isfl = args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	if ((error = xfs_alloc_vextent(&args)))
-		return error;
+	args->mod = args->minleft = args->alignment = args->total = args->wasdel =
+		args->isfl = args->userdata = args->minalignslop = 0;
+	args->minlen = args->maxlen = args->prod = 1;
+	args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	if ((error = xfs_alloc_vextent(args)))
+		goto out_error;
 	/*
 	 * None available, we fail.
 	 */
-	if (args.fsbno == NULLFSBLOCK) {
+	if (args->fsbno == NULLFSBLOCK) {
 		*stat = 0;
-		return 0;
+		goto out_error;
 	}
-	ASSERT(args.len == 1);
-	nbp = xfs_btree_get_bufs(args.mp, args.tp, args.agno, args.agbno, 0);
+	ASSERT(args->len == 1);
+	nbp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, args->agbno, 0);
 	new = XFS_BUF_TO_INOBT_BLOCK(nbp);
 	/*
 	 * Set the root data in the a.g. inode structure.
 	 */
-	agi->agi_root = cpu_to_be32(args.agbno);
+	agi->agi_root = cpu_to_be32(args->agbno);
 	be32_add(&agi->agi_level, 1);
-	xfs_ialloc_log_agi(args.tp, cur->bc_private.i.agbp,
+	xfs_ialloc_log_agi(args->tp, cur->bc_private.i.agbp,
 		XFS_AGI_ROOT | XFS_AGI_LEVEL);
 	/*
 	 * At the previous root level there are now two blocks: the old
@@ -1245,41 +1248,41 @@ xfs_inobt_newroot(
 	block = XFS_BUF_TO_INOBT_BLOCK(bp);
 #ifdef DEBUG
 	if ((error = xfs_btree_check_sblock(cur, block, cur->bc_nlevels - 1, bp)))
-		return error;
+		goto out_error;
 #endif
 	if (be32_to_cpu(block->bb_rightsib) != NULLAGBLOCK) {
 		/*
 		 * Our block is left, pick up the right block.
 		 */
 		lbp = bp;
-		lbno = XFS_DADDR_TO_AGBNO(args.mp, XFS_BUF_ADDR(lbp));
+		lbno = XFS_DADDR_TO_AGBNO(args->mp, XFS_BUF_ADDR(lbp));
 		left = block;
 		rbno = be32_to_cpu(left->bb_rightsib);
-		if ((error = xfs_btree_read_bufs(args.mp, args.tp, args.agno,
+		if ((error = xfs_btree_read_bufs(args->mp, args->tp, args->agno,
 				rbno, 0, &rbp, XFS_INO_BTREE_REF)))
-			return error;
+			goto out_error;
 		bp = rbp;
 		right = XFS_BUF_TO_INOBT_BLOCK(rbp);
 		if ((error = xfs_btree_check_sblock(cur, right,
 				cur->bc_nlevels - 1, rbp)))
-			return error;
+			goto out_error;
 		nptr = 1;
 	} else {
 		/*
 		 * Our block is right, pick up the left block.
 		 */
 		rbp = bp;
-		rbno = XFS_DADDR_TO_AGBNO(args.mp, XFS_BUF_ADDR(rbp));
+		rbno = XFS_DADDR_TO_AGBNO(args->mp, XFS_BUF_ADDR(rbp));
 		right = block;
 		lbno = be32_to_cpu(right->bb_leftsib);
-		if ((error = xfs_btree_read_bufs(args.mp, args.tp, args.agno,
+		if ((error = xfs_btree_read_bufs(args->mp, args->tp, args->agno,
 				lbno, 0, &lbp, XFS_INO_BTREE_REF)))
-			return error;
+			goto out_error;
 		bp = lbp;
 		left = XFS_BUF_TO_INOBT_BLOCK(lbp);
 		if ((error = xfs_btree_check_sblock(cur, left,
 				cur->bc_nlevels - 1, lbp)))
-			return error;
+			goto out_error;
 		nptr = 2;
 	}
 	/*
@@ -1290,7 +1293,7 @@ xfs_inobt_newroot(
 	new->bb_numrecs = cpu_to_be16(2);
 	new->bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 	new->bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-	xfs_inobt_log_block(args.tp, nbp, XFS_BB_ALL_BITS);
+	xfs_inobt_log_block(args->tp, nbp, XFS_BB_ALL_BITS);
 	ASSERT(lbno != NULLAGBLOCK && rbno != NULLAGBLOCK);
 	/*
 	 * Fill in the key data in the new root.
@@ -1320,7 +1323,9 @@ xfs_inobt_newroot(
 	cur->bc_ptrs[cur->bc_nlevels] = nptr;
 	cur->bc_nlevels++;
 	*stat = 1;
-	return 0;
+out_error:
+	kmem_free(args, sizeof(xfs_alloc_arg_t));
+	return error;
 }
 
 /*
@@ -1466,7 +1471,7 @@ xfs_inobt_split(
 	xfs_btree_cur_t		**curp,	/* output: new cursor */
 	int			*stat)	/* success/failure */
 {
-	xfs_alloc_arg_t		args;	/* allocation argument structure */
+	xfs_alloc_arg_t		*args;	/* allocation argument structure */
 	int			error;	/* error return value */
 	int			i;	/* loop index/record number */
 	xfs_agblock_t		lbno;	/* left (current) block number */
@@ -1481,30 +1486,33 @@ xfs_inobt_split(
 	xfs_inobt_ptr_t		*rpp;	/* right btree address pointer */
 	xfs_inobt_rec_t		*rrp;	/* right btree record pointer */
 
+	args = kmem_zalloc(sizeof(xfs_alloc_arg_t), KM_SLEEP);
+	if (!args)
+		return XFS_ERROR(ENOMEM);
 	/*
 	 * Set up left block (current one).
 	 */
 	lbp = cur->bc_bufs[level];
-	args.tp = cur->bc_tp;
-	args.mp = cur->bc_mp;
-	lbno = XFS_DADDR_TO_AGBNO(args.mp, XFS_BUF_ADDR(lbp));
+	args->tp = cur->bc_tp;
+	args->mp = cur->bc_mp;
+	lbno = XFS_DADDR_TO_AGBNO(args->mp, XFS_BUF_ADDR(lbp));
 	/*
 	 * Allocate the new block.
 	 * If we can't do it, we're toast.  Give up.
 	 */
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.i.agno, lbno);
-	args.mod = args.minleft = args.alignment = args.total = args.wasdel =
-		args.isfl = args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	if ((error = xfs_alloc_vextent(&args)))
-		return error;
-	if (args.fsbno == NULLFSBLOCK) {
+	args->fsbno = XFS_AGB_TO_FSB(args->mp, cur->bc_private.i.agno, lbno);
+	args->mod = args->minleft = args->alignment = args->total = args->wasdel =
+		args->isfl = args->userdata = args->minalignslop = 0;
+	args->minlen = args->maxlen = args->prod = 1;
+	args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	if ((error = xfs_alloc_vextent(args)))
+		goto out_error;
+	if (args->fsbno == NULLFSBLOCK) {
 		*stat = 0;
-		return 0;
+		goto out_error;
 	}
-	ASSERT(args.len == 1);
-	rbp = xfs_btree_get_bufs(args.mp, args.tp, args.agno, args.agbno, 0);
+	ASSERT(args->len == 1);
+	rbp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, args->agbno, 0);
 	/*
 	 * Set up the new block as "right".
 	 */
@@ -1515,7 +1523,7 @@ xfs_inobt_split(
 	left = XFS_BUF_TO_INOBT_BLOCK(lbp);
 #ifdef DEBUG
 	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-		return error;
+		goto out_error;
 #endif
 	/*
 	 * Fill in the btree header for the new block.
@@ -1542,7 +1550,7 @@ xfs_inobt_split(
 #ifdef DEBUG
 		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
 			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(lpp[i]), level)))
-				return error;
+				goto out_error;
 		}
 #endif
 		memcpy(rkp, lkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
@@ -1567,10 +1575,10 @@ xfs_inobt_split(
 	 */
 	be16_add(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
 	right->bb_rightsib = left->bb_rightsib;
-	left->bb_rightsib = cpu_to_be32(args.agbno);
+	left->bb_rightsib = cpu_to_be32(args->agbno);
 	right->bb_leftsib = cpu_to_be32(lbno);
-	xfs_inobt_log_block(args.tp, rbp, XFS_BB_ALL_BITS);
-	xfs_inobt_log_block(args.tp, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
+	xfs_inobt_log_block(args->tp, rbp, XFS_BB_ALL_BITS);
+	xfs_inobt_log_block(args->tp, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
 	/*
 	 * If there's a block to the new block's right, make that block
 	 * point back to right instead of to left.
@@ -1579,15 +1587,15 @@ xfs_inobt_split(
 		xfs_inobt_block_t	*rrblock;	/* rr btree block */
 		xfs_buf_t		*rrbp;		/* buffer for rrblock */
 
-		if ((error = xfs_btree_read_bufs(args.mp, args.tp, args.agno,
+		if ((error = xfs_btree_read_bufs(args->mp, args->tp, args->agno,
 				be32_to_cpu(right->bb_rightsib), 0, &rrbp,
 				XFS_INO_BTREE_REF)))
-			return error;
+			goto out_error;
 		rrblock = XFS_BUF_TO_INOBT_BLOCK(rrbp);
 		if ((error = xfs_btree_check_sblock(cur, rrblock, level, rrbp)))
-			return error;
-		rrblock->bb_leftsib = cpu_to_be32(args.agbno);
-		xfs_inobt_log_block(args.tp, rrbp, XFS_BB_LEFTSIB);
+			goto out_error;
+		rrblock->bb_leftsib = cpu_to_be32(args->agbno);
+		xfs_inobt_log_block(args->tp, rrbp, XFS_BB_LEFTSIB);
 	}
 	/*
 	 * If the cursor is really in the right block, move it there.
@@ -1604,12 +1612,14 @@ xfs_inobt_split(
 	 */
 	if (level + 1 < cur->bc_nlevels) {
 		if ((error = xfs_btree_dup_cursor(cur, curp)))
-			return error;
+			goto out_error;
 		(*curp)->bc_ptrs[level + 1]++;
 	}
-	*bnop = args.agbno;
+	*bnop = args->agbno;
 	*stat = 1;
-	return 0;
+out_error:
+	kmem_free(args, sizeof(xfs_alloc_arg_t));
+	return error;
 }
 
 /*
