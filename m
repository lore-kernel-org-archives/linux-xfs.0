Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 637C67F5E
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 01:05:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 280888F808E
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 23:05:19 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Fm3nFbZ1Pdv6VJVw for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 23:05:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Z01nQ-0001D9-IB
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Z01nQ-0002ur-HR
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/20] xfs: sanitise error handling in xfs_alloc_fix_freelist
Date: Wed,  3 Jun 2015 16:04:40 +1000
Message-Id: <1433311497-10245-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1433311497-10245-1-git-send-email-david@fromorbit.com>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The error handling is currently an inconsistent mess as every error
condition handles return values and releasing buffers individually.
Clean this up by using gotos and a sane error label stack.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 103 +++++++++++++++++++++-------------------------
 1 file changed, 47 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 2471cb5..352db46 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1909,80 +1909,65 @@ xfs_alloc_space_available(
  */
 STATIC int			/* error */
 xfs_alloc_fix_freelist(
-	xfs_alloc_arg_t	*args,	/* allocation argument structure */
-	int		flags)	/* XFS_ALLOC_FLAG_... */
+	struct xfs_alloc_arg	*args,	/* allocation argument structure */
+	int			flags)	/* XFS_ALLOC_FLAG_... */
 {
-	xfs_buf_t	*agbp;	/* agf buffer pointer */
-	xfs_buf_t	*agflbp;/* agfl buffer pointer */
-	xfs_agblock_t	bno;	/* freelist block */
-	int		error;	/* error result code */
-	xfs_mount_t	*mp;	/* file system mount point structure */
-	xfs_extlen_t	need;	/* total blocks needed in freelist */
-	xfs_perag_t	*pag;	/* per-ag information structure */
-	xfs_alloc_arg_t	targs;	/* local allocation arguments */
-	xfs_trans_t	*tp;	/* transaction pointer */
-
-	mp = args->mp;
+	struct xfs_mount	*mp = args->mp;
+	struct xfs_perag	*pag = args->pag;
+	struct xfs_trans	*tp = args->tp;
+	struct xfs_buf		*agbp = NULL;
+	struct xfs_buf		*agflbp = NULL;
+	struct xfs_alloc_arg	targs;	/* local allocation arguments */
+	xfs_agblock_t		bno;	/* freelist block */
+	xfs_extlen_t		need;	/* total blocks needed in freelist */
+	int			error;
 
-	pag = args->pag;
-	tp = args->tp;
 	if (!pag->pagf_init) {
-		if ((error = xfs_alloc_read_agf(mp, tp, args->agno, flags,
-				&agbp)))
-			return error;
+		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
+		if (error)
+			goto out_no_agbp;
 		if (!pag->pagf_init) {
 			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
 			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
-			args->agbp = NULL;
-			return 0;
+			goto out_agbp_relse;
 		}
-	} else
-		agbp = NULL;
+	}
 
 	/*
-	 * If this is a metadata preferred pag and we are user data
-	 * then try somewhere else if we are not being asked to
-	 * try harder at this point
+	 * If this is a metadata preferred pag and we are user data then try
+	 * somewhere else if we are not being asked to try harder at this
+	 * point
 	 */
 	if (pag->pagf_metadata && args->userdata &&
 	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
 		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
-		args->agbp = NULL;
-		return 0;
+		goto out_agbp_relse;
 	}
 
 	need = XFS_MIN_FREELIST_PAG(pag, mp);
-	if (!xfs_alloc_space_available(args, need, flags)) {
-		if (agbp)
-			xfs_trans_brelse(tp, agbp);
-		args->agbp = NULL;
-		return 0;
-	}
+	if (!xfs_alloc_space_available(args, need, flags))
+		goto out_agbp_relse;
 
 	/*
 	 * Get the a.g. freespace buffer.
 	 * Can fail if we're not blocking on locks, and it's held.
 	 */
-	if (agbp == NULL) {
-		if ((error = xfs_alloc_read_agf(mp, tp, args->agno, flags,
-				&agbp)))
-			return error;
-		if (agbp == NULL) {
+	if (!agbp) {
+		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
+		if (error)
+			goto out_no_agbp;
+		if (!agbp) {
 			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
 			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
-			args->agbp = NULL;
-			return 0;
+			goto out_no_agbp;
 		}
 	}
 
 
 	/* If there isn't enough total space or single-extent, reject it. */
 	need = XFS_MIN_FREELIST_PAG(pag, mp);
-	if (!xfs_alloc_space_available(args, need, flags)) {
-		xfs_trans_brelse(tp, agbp);
-		args->agbp = NULL;
-		return 0;
-	}
+	if (!xfs_alloc_space_available(args, need, flags))
+		goto out_agbp_relse;
 
 	/*
 	 * Make the freelist shorter if it's too long.
@@ -1997,10 +1982,10 @@ xfs_alloc_fix_freelist(
 
 		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
 		if (error)
-			return error;
+			goto out_agbp_relse;
 		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1);
 		if (error)
-			return error;
+			goto out_agbp_relse;
 		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
 		xfs_trans_binval(tp, bp);
 	}
@@ -2015,7 +2000,7 @@ xfs_alloc_fix_freelist(
 	targs.pag = pag;
 	error = xfs_alloc_read_agfl(mp, tp, targs.agno, &agflbp);
 	if (error)
-		return error;
+		goto out_agbp_relse;
 
 	/* Make the freelist longer if it's too short. */
 	while (pag->pagf_flcount < need) {
@@ -2024,10 +2009,9 @@ xfs_alloc_fix_freelist(
 
 		/* Allocate as many blocks as possible at once. */
 		error = xfs_alloc_ag_vextent(&targs);
-		if (error) {
-			xfs_trans_brelse(tp, agflbp);
-			return error;
-		}
+		if (error)
+			goto out_agflbp_relse;
+
 		/*
 		 * Stop if we run out.  Won't happen if callers are obeying
 		 * the restrictions correctly.  Can happen for free calls
@@ -2036,9 +2020,7 @@ xfs_alloc_fix_freelist(
 		if (targs.agbno == NULLAGBLOCK) {
 			if (flags & XFS_ALLOC_FLAG_FREEING)
 				break;
-			xfs_trans_brelse(tp, agflbp);
-			args->agbp = NULL;
-			return 0;
+			goto out_agflbp_relse;
 		}
 		/*
 		 * Put each allocated block on the list.
@@ -2047,12 +2029,21 @@ xfs_alloc_fix_freelist(
 			error = xfs_alloc_put_freelist(tp, agbp,
 							agflbp, bno, 0);
 			if (error)
-				return error;
+				goto out_agflbp_relse;
 		}
 	}
 	xfs_trans_brelse(tp, agflbp);
 	args->agbp = agbp;
 	return 0;
+
+out_agflbp_relse:
+	xfs_trans_brelse(tp, agflbp);
+out_agbp_relse:
+	if (agbp)
+		xfs_trans_brelse(tp, agbp);
+out_no_agbp:
+	args->agbp = NULL;
+	return error;
 }
 
 /*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
