Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24CwSEL165547 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 06:58:28 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A869B1AF2B97
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 05:01:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uBX1SDBOm5bHNRbb for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 05:01:19 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PvUdD-0004oV-9a
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 13:01:19 +0000
Message-Id: <20110304130119.267537965@bombadil.infradead.org>
Date: Fri, 04 Mar 2011 07:59:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: clean up the xfs_alloc_compute_aligned calling
	convention
References: <20110304125953.650347660@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_alloc_compute_aligned
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

Pass a xfs_alloc_arg structure to xfs_alloc_compute_aligned and derive
the alignment and minlen paramters from it.  This cleans up the existing
callers, and we'll need even more information from the xfs_alloc_arg
in subsequent patches.  Based on a patch from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-01-03 13:06:52.386254734 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2011-01-03 13:07:19.545002883 +0100
@@ -147,10 +147,9 @@ xfs_alloc_get_rec(
  */
 STATIC void
 xfs_alloc_compute_aligned(
+	xfs_alloc_arg_t	*args,		/* allocation argument structure */
 	xfs_agblock_t	foundbno,	/* starting block in found extent */
 	xfs_extlen_t	foundlen,	/* length in found extent */
-	xfs_extlen_t	alignment,	/* alignment for allocation */
-	xfs_extlen_t	minlen,		/* minimum length for allocation */
 	xfs_agblock_t	*resbno,	/* result block number */
 	xfs_extlen_t	*reslen)	/* result length */
 {
@@ -158,8 +157,8 @@ xfs_alloc_compute_aligned(
 	xfs_extlen_t	diff;
 	xfs_extlen_t	len;
 
-	if (alignment > 1 && foundlen >= minlen) {
-		bno = roundup(foundbno, alignment);
+	if (args->alignment > 1 && foundlen >= args->minlen) {
+		bno = roundup(foundbno, args->alignment);
 		diff = bno - foundbno;
 		len = diff >= foundlen ? 0 : foundlen - diff;
 	} else {
@@ -693,8 +692,7 @@ xfs_alloc_find_best_extent(
 		if (error)
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		xfs_alloc_compute_aligned(*sbno, *slen, args->alignment,
-					  args->minlen, &bno, slena);
+		xfs_alloc_compute_aligned(args, *sbno, *slen, &bno, slena);
 
 		/*
 		 * The good extent is closer than this one.
@@ -866,8 +864,8 @@ xfs_alloc_ag_vextent_near(
 			if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			xfs_alloc_compute_aligned(ltbno, ltlen, args->alignment,
-					args->minlen, &ltbnoa, &ltlena);
+			xfs_alloc_compute_aligned(args, ltbno, ltlen,
+						  &ltbnoa, &ltlena);
 			if (ltlena < args->minlen)
 				continue;
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
@@ -987,8 +985,8 @@ xfs_alloc_ag_vextent_near(
 			if ((error = xfs_alloc_get_rec(bno_cur_lt, &ltbno, &ltlen, &i)))
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			xfs_alloc_compute_aligned(ltbno, ltlen, args->alignment,
-					args->minlen, &ltbnoa, &ltlena);
+			xfs_alloc_compute_aligned(args, ltbno, ltlen,
+						  &ltbnoa, &ltlena);
 			if (ltlena >= args->minlen)
 				break;
 			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
@@ -1003,8 +1001,8 @@ xfs_alloc_ag_vextent_near(
 			if ((error = xfs_alloc_get_rec(bno_cur_gt, &gtbno, &gtlen, &i)))
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			xfs_alloc_compute_aligned(gtbno, gtlen, args->alignment,
-					args->minlen, &gtbnoa, &gtlena);
+			xfs_alloc_compute_aligned(args, gtbno, gtlen,
+						  &gtbnoa, &gtlena);
 			if (gtlena >= args->minlen)
 				break;
 			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
@@ -1183,8 +1181,7 @@ xfs_alloc_ag_vextent_size(
 	 * once aligned; if not, we search left for something better.
 	 * This can't happen in the second case above.
 	 */
-	xfs_alloc_compute_aligned(fbno, flen, args->alignment, args->minlen,
-		&rbno, &rlen);
+	xfs_alloc_compute_aligned(args, fbno, flen, &rbno, &rlen);
 	rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
 	XFS_WANT_CORRUPTED_GOTO(rlen == 0 ||
 			(rlen <= flen && rbno + rlen <= fbno + flen), error0);
@@ -1209,8 +1206,8 @@ xfs_alloc_ag_vextent_size(
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			if (flen < bestrlen)
 				break;
-			xfs_alloc_compute_aligned(fbno, flen, args->alignment,
-				args->minlen, &rbno, &rlen);
+			xfs_alloc_compute_aligned(args, fbno, flen,
+						  &rbno, &rlen);
 			rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
 			XFS_WANT_CORRUPTED_GOTO(rlen == 0 ||
 				(rlen <= flen && rbno + rlen <= fbno + flen),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
