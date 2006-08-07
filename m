Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Aug 2006 21:50:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k774nQDW014797
	for <xfs@oss.sgi.com>; Sun, 6 Aug 2006 21:49:37 -0700
Received: from wobbly.melbourne.sgi.com (wobbly.melbourne.sgi.com [134.14.55.135]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id OAA12965 for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 14:48:48 +1000
Received: from wobbly.melbourne.sgi.com (localhost [127.0.0.1])
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k774mkgw2466518
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 14:48:47 +1000 (EST)
Received: (from nathans@localhost)
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id k774mjCU2500499
	for xfs@oss.sgi.com; Mon, 7 Aug 2006 14:48:45 +1000 (EST)
Date: Mon, 7 Aug 2006 14:48:45 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: fix xfs_free_extent related NULL dereference
Message-ID: <20060807144844.B2501392@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

Here is a fix for the NULL buffer pointer dereference after a call
to the xfs_free_extent routine.  I've not yet reproduced this, but
I have a plausible theory now, at least..

We recently fixed an out-of-space deadlock in XFS, and part of that
fix involved the addition of the XFS_ALLOC_FLAG_FREEING flag to some
of the space allocator calls to indicate they're freeing space, not
allocating it.  There was a missed xfs_alloc_fix_freelist condition
test that did not correctly test "flags".  The same test would also
test an uninitialised structure field (args->userdata) and depending
on its value either would or would not return early with a critical
buffer pointer set to NULL.

This fixes that up, adds asserts to several places to catch future
botches of this nature, and skips sections of xfs_alloc_fix_freelist
that are irrelevent for the space-freeing case.

cheers.

-- 
Nathan


Index: xfs-linux/xfs_alloc.c
===================================================================
--- xfs-linux.orig/xfs_alloc.c	2006-08-07 09:40:03.565509250 +1000
+++ xfs-linux/xfs_alloc.c	2006-08-07 10:22:39.750084250 +1000
@@ -1835,40 +1835,47 @@ xfs_alloc_fix_freelist(
 				&agbp)))
 			return error;
 		if (!pag->pagf_init) {
+			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
+			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
 			args->agbp = NULL;
 			return 0;
 		}
 	} else
 		agbp = NULL;
 
-	/* If this is a metadata preferred pag and we are user data
+	/*
+	 * If this is a metadata preferred pag and we are user data
 	 * then try somewhere else if we are not being asked to
 	 * try harder at this point
 	 */
-	if (pag->pagf_metadata && args->userdata && flags) {
+	if (pag->pagf_metadata && args->userdata &&
+	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
+		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
 		args->agbp = NULL;
 		return 0;
 	}
 
-	need = XFS_MIN_FREELIST_PAG(pag, mp);
-	delta = need > pag->pagf_flcount ? need - pag->pagf_flcount : 0;
-	/*
-	 * If it looks like there isn't a long enough extent, or enough
-	 * total blocks, reject it.
-	 */
-	longest = (pag->pagf_longest > delta) ?
-		(pag->pagf_longest - delta) :
-		(pag->pagf_flcount > 0 || pag->pagf_longest > 0);
-	if (args->minlen + args->alignment + args->minalignslop - 1 > longest ||
-	    (!(flags & XFS_ALLOC_FLAG_FREEING) &&
-	     (int)(pag->pagf_freeblks + pag->pagf_flcount -
-		   need - args->total) <
-	     (int)args->minleft)) {
-		if (agbp)
-			xfs_trans_brelse(tp, agbp);
-		args->agbp = NULL;
-		return 0;
+	if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
+		need = XFS_MIN_FREELIST_PAG(pag, mp);
+		delta = need > pag->pagf_flcount ? need - pag->pagf_flcount : 0;
+		/*
+		 * If it looks like there isn't a long enough extent, or enough
+		 * total blocks, reject it.
+		 */
+		longest = (pag->pagf_longest > delta) ?
+			(pag->pagf_longest - delta) :
+			(pag->pagf_flcount > 0 || pag->pagf_longest > 0);
+		if ((args->minlen + args->alignment + args->minalignslop - 1) >
+				longest ||
+		    ((int)(pag->pagf_freeblks + pag->pagf_flcount -
+			   need - args->total) < (int)args->minleft)) {
+			if (agbp)
+				xfs_trans_brelse(tp, agbp);
+			args->agbp = NULL;
+			return 0;
+		}
 	}
+
 	/*
 	 * Get the a.g. freespace buffer.
 	 * Can fail if we're not blocking on locks, and it's held.
@@ -1878,6 +1885,8 @@ xfs_alloc_fix_freelist(
 				&agbp)))
 			return error;
 		if (agbp == NULL) {
+			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
+			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
 			args->agbp = NULL;
 			return 0;
 		}
@@ -1887,22 +1896,24 @@ xfs_alloc_fix_freelist(
 	 */
 	agf = XFS_BUF_TO_AGF(agbp);
 	need = XFS_MIN_FREELIST(agf, mp);
-	delta = need > be32_to_cpu(agf->agf_flcount) ?
-		(need - be32_to_cpu(agf->agf_flcount)) : 0;
 	/*
 	 * If there isn't enough total or single-extent, reject it.
 	 */
-	longest = be32_to_cpu(agf->agf_longest);
-	longest = (longest > delta) ? (longest - delta) :
-		(be32_to_cpu(agf->agf_flcount) > 0 || longest > 0);
-	if (args->minlen + args->alignment + args->minalignslop - 1 > longest ||
-	     (!(flags & XFS_ALLOC_FLAG_FREEING) &&
-		(int)(be32_to_cpu(agf->agf_freeblks) +
-		   be32_to_cpu(agf->agf_flcount) - need - args->total) <
-	     (int)args->minleft)) {
-		xfs_trans_brelse(tp, agbp);
-		args->agbp = NULL;
-		return 0;
+	if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
+		delta = need > be32_to_cpu(agf->agf_flcount) ?
+			(need - be32_to_cpu(agf->agf_flcount)) : 0;
+		longest = be32_to_cpu(agf->agf_longest);
+		longest = (longest > delta) ? (longest - delta) :
+			(be32_to_cpu(agf->agf_flcount) > 0 || longest > 0);
+		if ((args->minlen + args->alignment + args->minalignslop - 1) >
+				longest ||
+		    ((int)(be32_to_cpu(agf->agf_freeblks) +
+		     be32_to_cpu(agf->agf_flcount) - need - args->total) <
+				(int)args->minleft)) {
+			xfs_trans_brelse(tp, agbp);
+			args->agbp = NULL;
+			return 0;
+		}
 	}
 	/*
 	 * Make the freelist shorter if it's too long.
@@ -1950,12 +1961,11 @@ xfs_alloc_fix_freelist(
 		 * on a completely full ag.
 		 */
 		if (targs.agbno == NULLAGBLOCK) {
-			if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
-				xfs_trans_brelse(tp, agflbp);
-				args->agbp = NULL;
-				return 0;
-			}
-			break;
+			if (flags & XFS_ALLOC_FLAG_FREEING)
+				break;
+			xfs_trans_brelse(tp, agflbp);
+			args->agbp = NULL;
+			return 0;
 		}
 		/*
 		 * Put each allocated block on the list.
@@ -2442,10 +2452,7 @@ xfs_free_extent(
 	xfs_fsblock_t	bno,	/* starting block number of extent */
 	xfs_extlen_t	len)	/* length of extent */
 {
-#ifdef DEBUG
-	xfs_agf_t	*agf;	/* a.g. freespace header */
-#endif
-	xfs_alloc_arg_t	args;	/* allocation argument structure */
+	xfs_alloc_arg_t	args = { 0 };
 	int		error;
 
 	ASSERT(len != 0);
@@ -2454,19 +2461,16 @@ xfs_free_extent(
 	args.agno = XFS_FSB_TO_AGNO(args.mp, bno);
 	ASSERT(args.agno < args.mp->m_sb.sb_agcount);
 	args.agbno = XFS_FSB_TO_AGBNO(args.mp, bno);
-	args.alignment = 1;
-	args.minlen = args.minleft = args.minalignslop = 0;
 	down_read(&args.mp->m_peraglock);
 	args.pag = &args.mp->m_perag[args.agno];
 	if ((error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING)))
 		goto error0;
 #ifdef DEBUG
 	ASSERT(args.agbp != NULL);
-	agf = XFS_BUF_TO_AGF(args.agbp);
-	ASSERT(args.agbno + len <= be32_to_cpu(agf->agf_length));
+	ASSERT((args.agbno + len) <=
+		be32_to_cpu(XFS_BUF_TO_AGF(args.agbp)->agf_length));
 #endif
-	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno,
-		len, 0);
+	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
 error0:
 	up_read(&args.mp->m_peraglock);
 	return error;
