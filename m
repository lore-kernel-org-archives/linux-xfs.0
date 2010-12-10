Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBAF2MQ4014147 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 09:02:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 582381CB1B0E
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 07:04:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id n2w9BkPur0QVIXQi for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 07:04:12 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PR4W3-0005Oh-U4
	for xfs@oss.sgi.com; Fri, 10 Dec 2010 15:04:11 +0000
Date: Fri, 10 Dec 2010 10:04:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: factor duplicate code in xfs_alloc_ag_vextent_near into
	a helper
Message-ID: <20101210150411.GB20726@infradead.org>
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

Add a new xfs_alloc_find_best_extent that does a forward/backward search
in the allocation btree.  That code previously was existed two times in
xfs_alloc_ag_vextent_near, once for each search direction.

Based on an earlier patch from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2010-12-10 09:50:07.681023471 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2010-12-10 09:51:32.874005592 +0100
@@ -665,6 +665,95 @@ error0:
 }
 
 /*
+ * Search the btree in a given direction via the search cursor and compare
+ * the records found against the good extent we've already found.
+ */
+STATIC int
+xfs_alloc_find_best_extent(
+	struct xfs_alloc_arg	*args,	/* allocation argument structure */
+	struct xfs_btree_cur	**gcur,	/* good cursor */
+	struct xfs_btree_cur	**scur,	/* searching cursor */
+	xfs_agblock_t		gdiff,	/* difference for search comparison */
+	xfs_agblock_t		*sbno,	/* extent found by search */
+	xfs_extlen_t		*slen,
+	xfs_extlen_t		*slena,	/* aligned length */
+	int			dir)	/* 0 = search right, 1 = search left */
+{
+	xfs_agblock_t		bno;
+	xfs_agblock_t		new;
+	xfs_agblock_t		sdiff;
+	int			error;
+	int			i;
+
+	/* The good extent is perfect, no need to  search. */
+	if (!gdiff)
+		goto out_use_good;
+
+	/*
+	 * Look until we find a better one, run out of space or run off the end.
+	 */
+	do {
+		error = xfs_alloc_get_rec(*scur, sbno, slen, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		xfs_alloc_compute_aligned(*sbno, *slen, args->alignment,
+					  args->minlen, &bno, slena);
+
+		/*
+		 * The good extent is closer than this one.
+		 */
+		if (!dir) {
+			if (bno >= args->agbno + gdiff)
+				goto out_use_good;
+		} else {
+			if (bno <= args->agbno - gdiff)
+				goto out_use_good;
+		}
+
+		/*
+		 * Same distance, compare length and pick the best.
+		 */
+		if (*slena >= args->minlen) {
+			args->len = XFS_EXTLEN_MIN(*slena, args->maxlen);
+			xfs_alloc_fix_len(args);
+
+			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
+						       args->alignment, *sbno,
+						       *slen, &new);
+
+			/*
+			 * Choose closer size and invalidate other cursor.
+			 */
+			if (sdiff < gdiff)
+				goto out_use_search;
+			goto out_use_good;
+		}
+
+		if (!dir)
+			error = xfs_btree_increment(*scur, 0, &i);
+		else
+			error = xfs_btree_decrement(*scur, 0, &i);
+		if (error)
+			goto error0;
+	} while (i);
+
+out_use_good:
+	xfs_btree_del_cursor(*scur, XFS_BTREE_NOERROR);
+	*scur = NULL;
+	return 0;
+
+out_use_search:
+	xfs_btree_del_cursor(*gcur, XFS_BTREE_NOERROR);
+	*gcur = NULL;
+	return 0;
+
+error0:
+	/* caller invalidates cursors */
+	return error;
+}
+
+/*
  * Allocate a variable extent near bno in the allocation group agno.
  * Extent's length (returned in len) will be between minlen and maxlen,
  * and of the form k * prod + mod unless there's nothing that large.
@@ -931,203 +1020,45 @@ xfs_alloc_ag_vextent_near(
 			}
 		}
 	} while (bno_cur_lt || bno_cur_gt);
+
 	/*
 	 * Got both cursors still active, need to find better entry.
 	 */
 	if (bno_cur_lt && bno_cur_gt) {
-		/*
-		 * Left side is long enough, look for a right side entry.
-		 */
 		if (ltlena >= args->minlen) {
 			/*
-			 * Fix up the length.
+			 * Left side is good, look for a right side entry.
 			 */
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
-			rlen = args->len;
-			ltdiff = xfs_alloc_compute_diff(args->agbno, rlen,
+			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
 				args->alignment, ltbno, ltlen, &ltnew);
+
+			error = xfs_alloc_find_best_extent(args,
+						&bno_cur_lt, &bno_cur_gt,
+						ltdiff, &gtbno, &gtlen, &gtlena,
+						0 /* search right */);
+		} else {
+			ASSERT(gtlena >= args->minlen);
+
 			/*
-			 * Not perfect.
-			 */
-			if (ltdiff) {
-				/*
-				 * Look until we find a better one, run out of
-				 * space, or run off the end.
-				 */
-				while (bno_cur_lt && bno_cur_gt) {
-					if ((error = xfs_alloc_get_rec(
-							bno_cur_gt, &gtbno,
-							&gtlen, &i)))
-						goto error0;
-					XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-					xfs_alloc_compute_aligned(gtbno, gtlen,
-						args->alignment, args->minlen,
-						&gtbnoa, &gtlena);
-					/*
-					 * The left one is clearly better.
-					 */
-					if (gtbnoa >= args->agbno + ltdiff) {
-						xfs_btree_del_cursor(
-							bno_cur_gt,
-							XFS_BTREE_NOERROR);
-						bno_cur_gt = NULL;
-						break;
-					}
-					/*
-					 * If we reach a big enough entry,
-					 * compare the two and pick the best.
-					 */
-					if (gtlena >= args->minlen) {
-						args->len =
-							XFS_EXTLEN_MIN(gtlena,
-								args->maxlen);
-						xfs_alloc_fix_len(args);
-						rlen = args->len;
-						gtdiff = xfs_alloc_compute_diff(
-							args->agbno, rlen,
-							args->alignment,
-							gtbno, gtlen, &gtnew);
-						/*
-						 * Right side is better.
-						 */
-						if (gtdiff < ltdiff) {
-							xfs_btree_del_cursor(
-								bno_cur_lt,
-								XFS_BTREE_NOERROR);
-							bno_cur_lt = NULL;
-						}
-						/*
-						 * Left side is better.
-						 */
-						else {
-							xfs_btree_del_cursor(
-								bno_cur_gt,
-								XFS_BTREE_NOERROR);
-							bno_cur_gt = NULL;
-						}
-						break;
-					}
-					/*
-					 * Fell off the right end.
-					 */
-					if ((error = xfs_btree_increment(
-							bno_cur_gt, 0, &i)))
-						goto error0;
-					if (!i) {
-						xfs_btree_del_cursor(
-							bno_cur_gt,
-							XFS_BTREE_NOERROR);
-						bno_cur_gt = NULL;
-						break;
-					}
-				}
-			}
-			/*
-			 * The left side is perfect, trash the right side.
-			 */
-			else {
-				xfs_btree_del_cursor(bno_cur_gt,
-						     XFS_BTREE_NOERROR);
-				bno_cur_gt = NULL;
-			}
-		}
-		/*
-		 * It's the right side that was found first, look left.
-		 */
-		else {
-			/*
-			 * Fix up the length.
+			 * Right side is good, look for a left side entry.
 			 */
 			args->len = XFS_EXTLEN_MIN(gtlena, args->maxlen);
 			xfs_alloc_fix_len(args);
-			rlen = args->len;
-			gtdiff = xfs_alloc_compute_diff(args->agbno, rlen,
+			gtdiff = xfs_alloc_compute_diff(args->agbno, args->len,
 				args->alignment, gtbno, gtlen, &gtnew);
-			/*
-			 * Right side entry isn't perfect.
-			 */
-			if (gtdiff) {
-				/*
-				 * Look until we find a better one, run out of
-				 * space, or run off the end.
-				 */
-				while (bno_cur_lt && bno_cur_gt) {
-					if ((error = xfs_alloc_get_rec(
-							bno_cur_lt, &ltbno,
-							&ltlen, &i)))
-						goto error0;
-					XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-					xfs_alloc_compute_aligned(ltbno, ltlen,
-						args->alignment, args->minlen,
-						&ltbnoa, &ltlena);
-					/*
-					 * The right one is clearly better.
-					 */
-					if (ltbnoa <= args->agbno - gtdiff) {
-						xfs_btree_del_cursor(
-							bno_cur_lt,
-							XFS_BTREE_NOERROR);
-						bno_cur_lt = NULL;
-						break;
-					}
-					/*
-					 * If we reach a big enough entry,
-					 * compare the two and pick the best.
-					 */
-					if (ltlena >= args->minlen) {
-						args->len = XFS_EXTLEN_MIN(
-							ltlena, args->maxlen);
-						xfs_alloc_fix_len(args);
-						rlen = args->len;
-						ltdiff = xfs_alloc_compute_diff(
-							args->agbno, rlen,
-							args->alignment,
-							ltbno, ltlen, &ltnew);
-						/*
-						 * Left side is better.
-						 */
-						if (ltdiff < gtdiff) {
-							xfs_btree_del_cursor(
-								bno_cur_gt,
-								XFS_BTREE_NOERROR);
-							bno_cur_gt = NULL;
-						}
-						/*
-						 * Right side is better.
-						 */
-						else {
-							xfs_btree_del_cursor(
-								bno_cur_lt,
-								XFS_BTREE_NOERROR);
-							bno_cur_lt = NULL;
-						}
-						break;
-					}
-					/*
-					 * Fell off the left end.
-					 */
-					if ((error = xfs_btree_decrement(
-							bno_cur_lt, 0, &i)))
-						goto error0;
-					if (!i) {
-						xfs_btree_del_cursor(bno_cur_lt,
-							XFS_BTREE_NOERROR);
-						bno_cur_lt = NULL;
-						break;
-					}
-				}
-			}
-			/*
-			 * The right side is perfect, trash the left side.
-			 */
-			else {
-				xfs_btree_del_cursor(bno_cur_lt,
-					XFS_BTREE_NOERROR);
-				bno_cur_lt = NULL;
-			}
+
+			error = xfs_alloc_find_best_extent(args,
+						&bno_cur_gt, &bno_cur_lt,
+						gtdiff, &ltbno, &ltlen, &ltlena,
+						1 /* search left */);
 		}
+
+		if (error)
+			goto error0;
 	}
+
 	/*
 	 * If we couldn't get anything, give up.
 	 */
@@ -1136,6 +1067,7 @@ xfs_alloc_ag_vextent_near(
 		args->agbno = NULLAGBLOCK;
 		return 0;
 	}
+
 	/*
 	 * At this point we have selected a freespace entry, either to the
 	 * left or to the right.  If it's on the right, copy all the
@@ -1152,6 +1084,7 @@ xfs_alloc_ag_vextent_near(
 		j = 1;
 	} else
 		j = 0;
+
 	/*
 	 * Fix up the length and compute the useful address.
 	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
