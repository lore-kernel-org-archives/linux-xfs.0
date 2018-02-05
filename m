Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752925AbeBERqD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Feb 2018 12:46:03 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A7E2C036746
        for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2018 17:46:03 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B3EE60C4E
        for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2018 17:46:03 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/4] xfs: rename agfl perag res type to rmapbt
Date: Mon,  5 Feb 2018 12:46:00 -0500
Message-Id: <20180205174601.51574-4-bfoster@redhat.com>
In-Reply-To: <20180205174601.51574-1-bfoster@redhat.com>
References: <20180205174601.51574-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The AGFL perag reservation type accounts all allocations that feed
into (or are released from) the allocation group free list (agfl).
The purpose of the reservation is to support worst case conditions
for the reverse mapping btree (rmapbt). As such, the agfl
reservation usage accounting only considers rmapbt usage when the
in-core counters are initialized at mount time.

This implementation inconsistency leads to divergence of the in-core
and on-disk usage accounting over time. In preparation to resolve
this inconsistency and adjust the AGFL reservation into an rmapbt
specific reservation, rename the AGFL reservation type and
associated accounting fields to something more rmapbt-specific. Also
fix up a couple tracepoints that incorrectly use the AGFL
reservation type to pass the agfl state of the associated extent
where the raw reservation type is expected.

Note that this patch does not change perag reservation behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c | 35 ++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_alloc.c   | 20 +++++++++-----------
 fs/xfs/xfs_mount.h          | 10 +++++-----
 fs/xfs/xfs_reflink.c        |  2 +-
 4 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 2291f4224e24..0ca2e680034a 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -95,13 +95,13 @@ xfs_ag_resv_critical(
 
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
-		avail = pag->pagf_freeblks - pag->pag_agfl_resv.ar_reserved;
+		avail = pag->pagf_freeblks - pag->pag_rmapbt_resv.ar_reserved;
 		orig = pag->pag_meta_resv.ar_asked;
 		break;
-	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_RMAPBT:
 		avail = pag->pagf_freeblks + pag->pagf_flcount -
 			pag->pag_meta_resv.ar_reserved;
-		orig = pag->pag_agfl_resv.ar_asked;
+		orig = pag->pag_rmapbt_resv.ar_asked;
 		break;
 	default:
 		ASSERT(0);
@@ -126,10 +126,10 @@ xfs_ag_resv_needed(
 {
 	xfs_extlen_t			len;
 
-	len = pag->pag_meta_resv.ar_reserved + pag->pag_agfl_resv.ar_reserved;
+	len = pag->pag_meta_resv.ar_reserved + pag->pag_rmapbt_resv.ar_reserved;
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
-	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_RMAPBT:
 		len -= xfs_perag_resv(pag, type)->ar_reserved;
 		break;
 	case XFS_AG_RESV_NONE:
@@ -160,10 +160,11 @@ __xfs_ag_resv_free(
 	if (pag->pag_agno == 0)
 		pag->pag_mount->m_ag_max_usable += resv->ar_asked;
 	/*
-	 * AGFL blocks are always considered "free", so whatever
-	 * was reserved at mount time must be given back at umount.
+	 * RMAPBT blocks come from the AGFL and AGFL blocks are always
+	 * considered "free", so whatever was reserved at mount time must be
+	 * given back at umount.
 	 */
-	if (type == XFS_AG_RESV_AGFL)
+	if (type == XFS_AG_RESV_RMAPBT)
 		oldresv = resv->ar_orig_reserved;
 	else
 		oldresv = resv->ar_reserved;
@@ -185,7 +186,7 @@ xfs_ag_resv_free(
 	int				error;
 	int				err2;
 
-	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_AGFL);
+	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
 	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
 	if (err2 && !error)
 		error = err2;
@@ -284,15 +285,15 @@ xfs_ag_resv_init(
 		}
 	}
 
-	/* Create the AGFL metadata reservation */
-	if (pag->pag_agfl_resv.ar_asked == 0) {
+	/* Create the RMAPBT metadata reservation */
+	if (pag->pag_rmapbt_resv.ar_asked == 0) {
 		ask = used = 0;
 
 		error = xfs_rmapbt_calc_reserves(mp, agno, &ask, &used);
 		if (error)
 			goto out;
 
-		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_AGFL, ask, used);
+		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_RMAPBT, ask, used);
 		if (error)
 			goto out;
 	}
@@ -304,7 +305,7 @@ xfs_ag_resv_init(
 		return error;
 
 	ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
-	       xfs_perag_resv(pag, XFS_AG_RESV_AGFL)->ar_reserved <=
+	       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
 	       pag->pagf_freeblks + pag->pagf_flcount);
 #endif
 out:
@@ -326,7 +327,7 @@ xfs_ag_resv_alloc_extent(
 
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
-	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_RMAPBT:
 		resv = xfs_perag_resv(pag, type);
 		break;
 	default:
@@ -341,7 +342,7 @@ xfs_ag_resv_alloc_extent(
 
 	len = min_t(xfs_extlen_t, args->len, resv->ar_reserved);
 	resv->ar_reserved -= len;
-	if (type == XFS_AG_RESV_AGFL)
+	if (type == XFS_AG_RESV_RMAPBT)
 		return;
 	/* Allocations of reserved blocks only need on-disk sb updates... */
 	xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_RES_FDBLOCKS, -(int64_t)len);
@@ -366,7 +367,7 @@ xfs_ag_resv_free_extent(
 
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
-	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_RMAPBT:
 		resv = xfs_perag_resv(pag, type);
 		break;
 	default:
@@ -379,7 +380,7 @@ xfs_ag_resv_free_extent(
 
 	leftover = min_t(xfs_extlen_t, len, resv->ar_asked - resv->ar_reserved);
 	resv->ar_reserved += leftover;
-	if (type == XFS_AG_RESV_AGFL)
+	if (type == XFS_AG_RESV_RMAPBT)
 		return;
 	/* Freeing into the reserved pool only requires on-disk update... */
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FDBLOCKS, len);
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c02781a4c091..e53d55453dc5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -711,7 +711,7 @@ xfs_alloc_ag_vextent(
 
 	ASSERT(args->len >= args->minlen);
 	ASSERT(args->len <= args->maxlen);
-	ASSERT(!args->wasfromfl || args->resv != XFS_AG_RESV_AGFL);
+	ASSERT(!args->wasfromfl || args->resv != XFS_AG_RESV_RMAPBT);
 	ASSERT(args->agbno % args->alignment == 0);
 
 	/* if not file data, insert new block into the reverse map btree */
@@ -1583,7 +1583,7 @@ xfs_alloc_ag_vextent_small(
 	 * freelist.
 	 */
 	else if (args->minlen == 1 && args->alignment == 1 &&
-		 args->resv != XFS_AG_RESV_AGFL &&
+		 args->resv != XFS_AG_RESV_RMAPBT &&
 		 (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount)
 		  > args->minleft)) {
 		error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
@@ -1617,7 +1617,7 @@ xfs_alloc_ag_vextent_small(
 			 * If we're feeding an AGFL block to something that
 			 * doesn't live in the free space, we need to clear
 			 * out the OWN_AG rmap and add the block back to
-			 * the AGFL per-AG reservation.
+			 * the RMAPBT per-AG reservation.
 			 */
 			xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
 			error = xfs_rmap_free(args->tp, args->agbp, args->agno,
@@ -1625,7 +1625,7 @@ xfs_alloc_ag_vextent_small(
 			if (error)
 				goto error0;
 			pag = xfs_perag_get(args->mp, args->agno);
-			xfs_ag_resv_free_extent(pag, XFS_AG_RESV_AGFL,
+			xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT,
 					args->tp, 1);
 			xfs_perag_put(pag);
 
@@ -1911,14 +1911,12 @@ xfs_free_ag_extent(
 	XFS_STATS_INC(mp, xs_freex);
 	XFS_STATS_ADD(mp, xs_freeb, len);
 
-	trace_xfs_free_extent(mp, agno, bno, len, type == XFS_AG_RESV_AGFL,
-			haveleft, haveright);
+	trace_xfs_free_extent(mp, agno, bno, len, type, haveleft, haveright);
 
 	return 0;
 
  error0:
-	trace_xfs_free_extent(mp, agno, bno, len, type == XFS_AG_RESV_AGFL,
-			-1, -1);
+	trace_xfs_free_extent(mp, agno, bno, len, type, -1, -1);
 	if (bno_cur)
 		xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
 	if (cnt_cur)
@@ -2155,7 +2153,7 @@ xfs_alloc_fix_freelist(
 		if (error)
 			goto out_agbp_relse;
 		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1,
-					   &targs.oinfo, XFS_AG_RESV_AGFL);
+					   &targs.oinfo, XFS_AG_RESV_RMAPBT);
 		if (error)
 			goto out_agbp_relse;
 		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
@@ -2181,7 +2179,7 @@ xfs_alloc_fix_freelist(
 	while (pag->pagf_flcount < need) {
 		targs.agbno = 0;
 		targs.maxlen = need - pag->pagf_flcount;
-		targs.resv = XFS_AG_RESV_AGFL;
+		targs.resv = XFS_AG_RESV_RMAPBT;
 
 		/* Allocate as many blocks as possible at once. */
 		error = xfs_alloc_ag_vextent(&targs);
@@ -2862,7 +2860,7 @@ xfs_free_extent(
 	int			error;
 
 	ASSERT(len != 0);
-	ASSERT(type != XFS_AG_RESV_AGFL);
+	ASSERT(type != XFS_AG_RESV_RMAPBT);
 
 	if (XFS_TEST_ERROR(false, mp,
 			XFS_ERRTAG_FREE_EXTENT))
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e0792d036be2..cf84288b65ca 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -327,7 +327,7 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 enum xfs_ag_resv_type {
 	XFS_AG_RESV_NONE = 0,
 	XFS_AG_RESV_METADATA,
-	XFS_AG_RESV_AGFL,
+	XFS_AG_RESV_RMAPBT,
 };
 
 struct xfs_ag_resv {
@@ -391,8 +391,8 @@ typedef struct xfs_perag {
 
 	/* Blocks reserved for all kinds of metadata. */
 	struct xfs_ag_resv	pag_meta_resv;
-	/* Blocks reserved for just AGFL-based metadata. */
-	struct xfs_ag_resv	pag_agfl_resv;
+	/* Blocks reserved for the reverse mapping btree. */
+	struct xfs_ag_resv	pag_rmapbt_resv;
 
 	/* reference count */
 	uint8_t			pagf_refcount_level;
@@ -406,8 +406,8 @@ xfs_perag_resv(
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
 		return &pag->pag_meta_resv;
-	case XFS_AG_RESV_AGFL:
-		return &pag->pag_agfl_resv;
+	case XFS_AG_RESV_RMAPBT:
+		return &pag->pag_rmapbt_resv;
 	default:
 		return NULL;
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 270246943a06..832df6f49ba1 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1061,7 +1061,7 @@ xfs_reflink_ag_has_free_space(
 		return 0;
 
 	pag = xfs_perag_get(mp, agno);
-	if (xfs_ag_resv_critical(pag, XFS_AG_RESV_AGFL) ||
+	if (xfs_ag_resv_critical(pag, XFS_AG_RESV_RMAPBT) ||
 	    xfs_ag_resv_critical(pag, XFS_AG_RESV_METADATA))
 		error = -ENOSPC;
 	xfs_perag_put(pag);
-- 
2.13.6

