Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBAF271j014086 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 09:02:07 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A72E01DD9E6
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 07:03:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nXXEmtB1TClcLKz9 for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 07:03:57 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PR4Vp-0005OZ-96
	for xfs@oss.sgi.com; Fri, 10 Dec 2010 15:03:57 +0000
Date: Fri, 10 Dec 2010 10:03:57 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: clean up xfs_alloc_ag_vextent_exact
Message-ID: <20101210150357.GA20726@infradead.org>
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

Use a goto label to consolidate all block not found cases, and add a
tracepoint for them.  Also clean up a few whitespace issues.

Based on an earlier patch from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_trace.h
+++ linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
@@ -1421,6 +1421,7 @@ DEFINE_EVENT(xfs_alloc_class, name, \
 	TP_PROTO(struct xfs_alloc_arg *args), \
 	TP_ARGS(args))
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
+DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
Index: linux-2.6/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_alloc.c
+++ linux-2.6/fs/xfs/xfs_alloc.c
@@ -577,61 +577,58 @@ xfs_alloc_ag_vextent_exact(
 	xfs_extlen_t	rlen;	/* length of returned extent */
 
 	ASSERT(args->alignment == 1);
+
 	/*
 	 * Allocate/initialize a cursor for the by-number freespace btree.
 	 */
 	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_BNO);
+					  args->agno, XFS_BTNUM_BNO);
+
 	/*
 	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
 	 * Look for the closest free block <= bno, it must contain bno
 	 * if any free block does.
 	 */
-	if ((error = xfs_alloc_lookup_le(bno_cur, args->agbno, args->minlen, &i)))
+	error = xfs_alloc_lookup_le(bno_cur, args->agbno, args->minlen, &i);
+	if (error)
 		goto error0;
-	if (!i) {
-		/*
-		 * Didn't find it, return null.
-		 */
-		xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-		args->agbno = NULLAGBLOCK;
-		return 0;
-	}
+	if (!i)
+		goto not_found;
+
 	/*
 	 * Grab the freespace record.
 	 */
-	if ((error = xfs_alloc_get_rec(bno_cur, &fbno, &flen, &i)))
+	error = xfs_alloc_get_rec(bno_cur, &fbno, &flen, &i);
+	if (error)
 		goto error0;
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	ASSERT(fbno <= args->agbno);
 	minend = args->agbno + args->minlen;
 	maxend = args->agbno + args->maxlen;
 	fend = fbno + flen;
+
 	/*
 	 * Give up if the freespace isn't long enough for the minimum request.
 	 */
-	if (fend < minend) {
-		xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-		args->agbno = NULLAGBLOCK;
-		return 0;
-	}
+	if (fend < minend)
+		goto not_found;
+
 	/*
 	 * End of extent will be smaller of the freespace end and the
 	 * maximal requested end.
-	 */
-	end = XFS_AGBLOCK_MIN(fend, maxend);
-	/*
+	 *
 	 * Fix the length according to mod and prod if given.
 	 */
+	end = XFS_AGBLOCK_MIN(fend, maxend);
 	args->len = end - args->agbno;
 	xfs_alloc_fix_len(args);
-	if (!xfs_alloc_fix_minleft(args)) {
-		xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-		return 0;
-	}
+	if (!xfs_alloc_fix_minleft(args))
+		goto not_found;
+
 	rlen = args->len;
 	ASSERT(args->agbno + rlen <= fend);
 	end = args->agbno + rlen;
+
 	/*
 	 * We are allocating agbno for rlen [agbno .. end]
 	 * Allocate/initialize a cursor for the by-size btree.
@@ -640,16 +637,25 @@ xfs_alloc_ag_vextent_exact(
 		args->agno, XFS_BTNUM_CNT);
 	ASSERT(args->agbno + args->len <=
 		be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
-	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
-			args->agbno, args->len, XFSA_FIXUP_BNO_OK))) {
+	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
+				      args->len, XFSA_FIXUP_BNO_OK);
+	if (error) {
 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
 		goto error0;
 	}
+
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 
-	trace_xfs_alloc_exact_done(args);
 	args->wasfromfl = 0;
+	trace_xfs_alloc_exact_done(args);
+	return 0;
+
+not_found:
+	/* Didn't find it, return null. */
+	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
+	args->agbno = NULLAGBLOCK;
+	trace_xfs_alloc_exact_notfound(args);
 	return 0;
 
 error0:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
