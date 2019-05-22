Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbfEVSFu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 May 2019 14:05:50 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 11A74307EA8E
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:50 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C23FE5C296
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:49 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 07/11] xfs: refactor exact extent allocation mode
Date: Wed, 22 May 2019 14:05:42 -0400
Message-Id: <20190522180546.17063-8-bfoster@redhat.com>
In-Reply-To: <20190522180546.17063-1-bfoster@redhat.com>
References: <20190522180546.17063-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Exact allocation mode attemps to allocate at a specific block and
otherwise fails. The implementation is straightforward and mostly
contained in a single function. It uses the bnobt to look up the
requested block and succeeds or fails.

An exact allocation is essentially just a near allocation with
slightly more strict requirements. Most of the boilerplate code
associated with an exact allocation is already implemented in the
generic infrastructure. The additional logic that is required is
oneshot behavior for cursor allocation and lookup and the record
examination requirements specific to allocation mode.

Update the generic allocation code to support exact mode allocations
and replace the existing implementation. This essentially provides
the same behavior with improved code reuse and less duplicated code.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 181 +++++++++++---------------------------
 fs/xfs/xfs_trace.h        |   1 -
 2 files changed, 49 insertions(+), 133 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 149309e17095..d180d1940039 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -38,7 +38,6 @@ struct workqueue_struct *xfs_alloc_wq;
 #define	XFSA_FIXUP_BNO_OK	1
 #define	XFSA_FIXUP_CNT_OK	2
 
-STATIC int xfs_alloc_ag_vextent_exact(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 
 /*
@@ -778,6 +777,15 @@ xfs_alloc_cur_setup(
 	if (error)
 		return error;
 
+	/*
+	 * Exact allocation mode requires only one bnobt cursor.
+	 */
+	if (args->type == XFS_ALLOCTYPE_THIS_BNO) {
+		ASSERT(args->alignment == 1);
+		acur->cnt->bc_private.a.priv.abt.active = false;
+		return 0;
+	}
+
 	if (!acur->bnogt)
 		acur->bnogt = xfs_allocbt_init_cursor(args->mp, args->tp,
 					args->agbp, args->agno, XFS_BTNUM_BNO);
@@ -840,6 +848,12 @@ xfs_alloc_cur_check(
 	if (olen)
 		*olen = len;
 
+	/* exact allocs only check one record, mark the cursor inactive */
+	if (args->type == XFS_ALLOCTYPE_THIS_BNO) {
+		ASSERT(isbnobt);
+		cur->bc_private.a.priv.abt.active = false;
+	}
+
 	/*
 	 * Check against minlen and then compute and check the aligned record.
 	 * If a cntbt record is out of size range (i.e., we're walking
@@ -871,22 +885,39 @@ xfs_alloc_cur_check(
 
 	/*
 	 * We have an aligned record that satisfies minlen and beats the current
-	 * candidate length. The remaining locality checks are specific to near
-	 * allocation mode.
+	 * candidate length. The remaining checks depend on allocation type.
+	 * Exact allocation checks one record and either succeeds or fails. Near
+	 * allocation computes and checks locality.  Near allocation computes
+	 * and checks locality.
 	 */
-	ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
-	diff = xfs_alloc_compute_diff(args->agbno, args->len,
-				      args->alignment, args->datatype,
-				      bnoa, lena, &bnew);
-	if (bnew == NULLAGBLOCK)
-		goto fail;
-	if (diff > acur->diff) {
-		/* deactivate bnobt cursor with worse locality */
-		deactivate = isbnobt;
-		goto fail;
+	if (args->type == XFS_ALLOCTYPE_THIS_BNO) {
+		if ((bnoa > args->agbno) ||
+		    (bnoa + lena < args->agbno + args->minlen)) {
+			trace_xfs_alloc_exact_notfound(args);
+			goto fail;
+		}
+
+		bnew = args->agbno;
+		args->len = XFS_AGBLOCK_MIN(bnoa + lena,
+					    args->agbno + args->maxlen) -
+			    args->agbno;
+		diff = 0;
+		trace_xfs_alloc_exact_done(args);
+	} else {
+		ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
+		diff = xfs_alloc_compute_diff(args->agbno, args->len,
+					      args->alignment, args->datatype,
+					      bnoa, lena, &bnew);
+		if (bnew == NULLAGBLOCK)
+			goto fail;
+		if (diff > acur->diff) {
+			/* deactivate bnobt cursor with worse locality */
+			deactivate = isbnobt;
+			goto fail;
+		}
+		if (args->len < acur->len)
+			goto fail;
 	}
-	if (args->len < acur->len)
-		goto fail;
 
 	/* found a new candidate extent */
 	acur->rec_bno = bno;
@@ -1086,6 +1117,8 @@ xfs_alloc_ag_vextent_cur(
 					    true, 1, &i);
 		if (error)
 			return error;
+		if (args->type == XFS_ALLOCTYPE_THIS_BNO)
+			break;
 		if (i) {
 			fbcur = acur->bnogt;
 			fbinc = true;
@@ -1347,10 +1380,8 @@ xfs_alloc_ag_vextent(
 		error = xfs_alloc_ag_vextent_size(args);
 		break;
 	case XFS_ALLOCTYPE_NEAR_BNO:
-		error = xfs_alloc_ag_vextent_type(args);
-		break;
 	case XFS_ALLOCTYPE_THIS_BNO:
-		error = xfs_alloc_ag_vextent_exact(args);
+		error = xfs_alloc_ag_vextent_type(args);
 		break;
 	default:
 		ASSERT(0);
@@ -1391,120 +1422,6 @@ xfs_alloc_ag_vextent(
 	return error;
 }
 
-/*
- * Allocate a variable extent at exactly agno/bno.
- * Extent's length (returned in *len) will be between minlen and maxlen,
- * and of the form k * prod + mod unless there's nothing that large.
- * Return the starting a.g. block (bno), or NULLAGBLOCK if we can't do it.
- */
-STATIC int			/* error */
-xfs_alloc_ag_vextent_exact(
-	xfs_alloc_arg_t	*args)	/* allocation argument structure */
-{
-	xfs_btree_cur_t	*bno_cur;/* by block-number btree cursor */
-	xfs_btree_cur_t	*cnt_cur;/* by count btree cursor */
-	int		error;
-	xfs_agblock_t	fbno;	/* start block of found extent */
-	xfs_extlen_t	flen;	/* length of found extent */
-	xfs_agblock_t	tbno;	/* start block of busy extent */
-	xfs_extlen_t	tlen;	/* length of busy extent */
-	xfs_agblock_t	tend;	/* end block of busy extent */
-	int		i;	/* success/failure of operation */
-	unsigned	busy_gen;
-
-	ASSERT(args->alignment == 1);
-
-	/*
-	 * Allocate/initialize a cursor for the by-number freespace btree.
-	 */
-	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-					  args->agno, XFS_BTNUM_BNO);
-
-	/*
-	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
-	 * Look for the closest free block <= bno, it must contain bno
-	 * if any free block does.
-	 */
-	error = xfs_alloc_lookup_le(bno_cur, args->agbno, args->minlen, &i);
-	if (error)
-		goto error0;
-	if (!i)
-		goto not_found;
-
-	/*
-	 * Grab the freespace record.
-	 */
-	error = xfs_alloc_get_rec(bno_cur, &fbno, &flen, &i);
-	if (error)
-		goto error0;
-	XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-	ASSERT(fbno <= args->agbno);
-
-	/*
-	 * Check for overlapping busy extents.
-	 */
-	tbno = fbno;
-	tlen = flen;
-	xfs_extent_busy_trim(args, &tbno, &tlen, &busy_gen);
-
-	/*
-	 * Give up if the start of the extent is busy, or the freespace isn't
-	 * long enough for the minimum request.
-	 */
-	if (tbno > args->agbno)
-		goto not_found;
-	if (tlen < args->minlen)
-		goto not_found;
-	tend = tbno + tlen;
-	if (tend < args->agbno + args->minlen)
-		goto not_found;
-
-	/*
-	 * End of extent will be smaller of the freespace end and the
-	 * maximal requested end.
-	 *
-	 * Fix the length according to mod and prod if given.
-	 */
-	args->len = XFS_AGBLOCK_MIN(tend, args->agbno + args->maxlen)
-						- args->agbno;
-	xfs_alloc_fix_len(args);
-	ASSERT(args->agbno + args->len <= tend);
-
-	/*
-	 * We are allocating agbno for args->len
-	 * Allocate/initialize a cursor for the by-size btree.
-	 */
-	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT);
-	ASSERT(args->agbno + args->len <=
-		be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
-	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
-				      args->len, XFSA_FIXUP_BNO_OK);
-	if (error) {
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
-		goto error0;
-	}
-
-	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-
-	args->wasfromfl = 0;
-	trace_xfs_alloc_exact_done(args);
-	return 0;
-
-not_found:
-	/* Didn't find it, return null. */
-	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-	args->agbno = NULLAGBLOCK;
-	trace_xfs_alloc_exact_notfound(args);
-	return 0;
-
-error0:
-	xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
-	trace_xfs_alloc_exact_error(args);
-	return error;
-}
-
 /*
  * Allocate a variable extent anywhere in the allocation group agno.
  * Extent's length (returned in len) will be between minlen and maxlen,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c49bbe0e06e3..a11aac4505ea 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1634,7 +1634,6 @@ DEFINE_EVENT(xfs_alloc_class, name, \
 	TP_ARGS(args))
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
 DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
-DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_ag_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_ag_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_ag_busy);
-- 
2.17.2
