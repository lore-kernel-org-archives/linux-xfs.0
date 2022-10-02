Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D833FC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiJBSiQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiJBSiO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:38:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2CD3BC72
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66FCFB80D88
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22506C433D6;
        Sun,  2 Oct 2022 18:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735890;
        bh=rZETx0yeYekQpC84us4cVNNEyCqz2fHApIZbpTnYeho=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W9wdMaaRf0i8ZM+OnteKlW6SD0L8Zxac40e/WXL/NSxl63i/QqAm/hxOIp5WG9W6T
         kdQ0Y6Nidd9tm5Hr7WI0kOeyx/h6NhFnw2hZlQ3PNB0qobkXbSvWIfrCRHykdWii9K
         klhNVkNtr4lKkQT3DtH0KpBtxcKtHO8iSA4z9WLV0SmC6hLCbRz4Dze4FiJkbHfmAF
         PML+dK62xLPXNMGIWF2Mh7YOh7+TC5tJMrAUBJctISzWWSPq14TXPYJ1vvwGswfK/v
         eEZJNEHG0PTWPRGuaDRRhgcrAvum/6b8kjfxuIL/hwfsGQN79O0CwPYrkKjrTmJk6A
         Xdy0hn3EQf15Q==
Subject: [PATCH 1/3] xfs: remove the for_each_xbitmap_ helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:44 -0700
Message-ID: <166473484429.1085359.3441884501349252891.stgit@magnolia>
In-Reply-To: <166473484410.1085359.13141946672747602766.stgit@magnolia>
References: <166473484410.1085359.13141946672747602766.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove the for_each_xbitmap_ macros in favor of proper iterator
functions.  We'll soon be switching this data structure over to an
interval tree implementation, which means that we can't allow callers to
modify the bitmap during iteration without telling us.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |   89 ++++++++++++++++++++---------------
 fs/xfs/scrub/bitmap.c          |   59 +++++++++++++++++++++++
 fs/xfs/scrub/bitmap.h          |   22 ++++++---
 fs/xfs/scrub/repair.c          |  102 ++++++++++++++++++++++------------------
 4 files changed, 179 insertions(+), 93 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index d75d82151eeb..26bce2f12b09 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -486,10 +486,11 @@ xrep_agfl_walk_rmap(
 /* Strike out the blocks that are cross-linked according to the rmapbt. */
 STATIC int
 xrep_agfl_check_extent(
-	struct xrep_agfl	*ra,
 	uint64_t		start,
-	uint64_t		len)
+	uint64_t		len,
+	void			*priv)
 {
+	struct xrep_agfl	*ra = priv;
 	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(ra->sc->mp, start);
 	xfs_agblock_t		last_agbno = agbno + len - 1;
 	int			error;
@@ -537,7 +538,6 @@ xrep_agfl_collect_blocks(
 	struct xrep_agfl	ra;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_btree_cur	*cur;
-	struct xbitmap_range	*br, *n;
 	int			error;
 
 	ra.sc = sc;
@@ -578,11 +578,7 @@ xrep_agfl_collect_blocks(
 
 	/* Strike out the blocks that are cross-linked. */
 	ra.rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
-	for_each_xbitmap_extent(br, n, agfl_extents) {
-		error = xrep_agfl_check_extent(&ra, br->start, br->len);
-		if (error)
-			break;
-	}
+	error = xbitmap_walk(agfl_extents, xrep_agfl_check_extent, &ra);
 	xfs_btree_del_cursor(ra.rmap_cur, error);
 	if (error)
 		goto out_bmp;
@@ -628,6 +624,43 @@ xrep_agfl_update_agf(
 			XFS_AGF_FLFIRST | XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);
 }
 
+struct xrep_agfl_fill {
+	struct xbitmap		used_extents;
+	struct xfs_scrub	*sc;
+	__be32			*agfl_bno;
+	xfs_agblock_t		flcount;
+	unsigned int		fl_off;
+};
+
+/* Fill the AGFL with whatever blocks are in this extent. */
+static int
+xrep_agfl_fill(
+	uint64_t		start,
+	uint64_t		len,
+	void			*priv)
+{
+	struct xrep_agfl_fill	*af = priv;
+	struct xfs_scrub	*sc = af->sc;
+	xfs_fsblock_t		fsbno = start;
+	int			error;
+
+	while (fsbno < start + len && af->fl_off < af->flcount)
+		af->agfl_bno[af->fl_off++] =
+				cpu_to_be32(XFS_FSB_TO_AGBNO(sc->mp, fsbno++));
+
+	trace_xrep_agfl_insert(sc->mp, sc->sa.pag->pag_agno,
+			XFS_FSB_TO_AGBNO(sc->mp, start), len);
+
+	error = xbitmap_set(&af->used_extents, start, fsbno - 1);
+	if (error)
+		return error;
+
+	if (af->fl_off == af->flcount)
+		return -ECANCELED;
+
+	return 0;
+}
+
 /* Write out a totally new AGFL. */
 STATIC void
 xrep_agfl_init_header(
@@ -636,13 +669,12 @@ xrep_agfl_init_header(
 	struct xbitmap		*agfl_extents,
 	xfs_agblock_t		flcount)
 {
+	struct xrep_agfl_fill	af = {
+		.sc		= sc,
+		.flcount	= flcount,
+	};
 	struct xfs_mount	*mp = sc->mp;
-	__be32			*agfl_bno;
-	struct xbitmap_range	*br;
-	struct xbitmap_range	*n;
 	struct xfs_agfl		*agfl;
-	xfs_agblock_t		agbno;
-	unsigned int		fl_off;
 
 	ASSERT(flcount <= xfs_agfl_size(mp));
 
@@ -661,36 +693,15 @@ xrep_agfl_init_header(
 	 * blocks than fit in the AGFL, they will be freed in a subsequent
 	 * step.
 	 */
-	fl_off = 0;
-	agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
-	for_each_xbitmap_extent(br, n, agfl_extents) {
-		agbno = XFS_FSB_TO_AGBNO(mp, br->start);
-
-		trace_xrep_agfl_insert(mp, sc->sa.pag->pag_agno, agbno,
-				br->len);
-
-		while (br->len > 0 && fl_off < flcount) {
-			agfl_bno[fl_off] = cpu_to_be32(agbno);
-			fl_off++;
-			agbno++;
-
-			/*
-			 * We've now used br->start by putting it in the AGFL,
-			 * so bump br so that we don't reap the block later.
-			 */
-			br->start++;
-			br->len--;
-		}
-
-		if (br->len)
-			break;
-		list_del(&br->list);
-		kfree(br);
-	}
+	xbitmap_init(&af.used_extents);
+	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp),
+	xbitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	xbitmap_disunion(agfl_extents, &af.used_extents);
 
 	/* Write new AGFL to disk. */
 	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
 	xfs_trans_log_buf(sc->tp, agfl_bp, 0, BBTOB(agfl_bp->b_length) - 1);
+	xbitmap_destroy(&af.used_extents);
 }
 
 /* Repair the AGFL. */
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index a255f09e9f0a..d32ded56da90 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -13,6 +13,9 @@
 #include "scrub/scrub.h"
 #include "scrub/bitmap.h"
 
+#define for_each_xbitmap_extent(bex, n, bitmap) \
+	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list)
+
 /*
  * Set a range of this bitmap.  Caller must ensure the range is not set.
  *
@@ -313,3 +316,59 @@ xbitmap_hweight(
 
 	return ret;
 }
+
+/* Call a function for every run of set bits in this bitmap. */
+int
+xbitmap_walk(
+	struct xbitmap		*bitmap,
+	xbitmap_walk_fn	fn,
+	void			*priv)
+{
+	struct xbitmap_range	*bex, *n;
+	int			error = 0;
+
+	for_each_xbitmap_extent(bex, n, bitmap) {
+		error = fn(bex->start, bex->len, priv);
+		if (error)
+			break;
+	}
+
+	return error;
+}
+
+struct xbitmap_walk_bits {
+	xbitmap_walk_bits_fn	fn;
+	void			*priv;
+};
+
+/* Walk all the bits in a run. */
+static int
+xbitmap_walk_bits_in_run(
+	uint64_t			start,
+	uint64_t			len,
+	void				*priv)
+{
+	struct xbitmap_walk_bits	*wb = priv;
+	uint64_t			i;
+	int				error = 0;
+
+	for (i = start; i < start + len; i++) {
+		error = wb->fn(i, wb->priv);
+		if (error)
+			break;
+	}
+
+	return error;
+}
+
+/* Call a function for every set bit in this bitmap. */
+int
+xbitmap_walk_bits(
+	struct xbitmap			*bitmap,
+	xbitmap_walk_bits_fn		fn,
+	void				*priv)
+{
+	struct xbitmap_walk_bits	wb = {.fn = fn, .priv = priv};
+
+	return xbitmap_walk(bitmap, xbitmap_walk_bits_in_run, &wb);
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 900646b72de1..53601d281ffb 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -19,13 +19,6 @@ struct xbitmap {
 void xbitmap_init(struct xbitmap *bitmap);
 void xbitmap_destroy(struct xbitmap *bitmap);
 
-#define for_each_xbitmap_extent(bex, n, bitmap) \
-	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list)
-
-#define for_each_xbitmap_block(b, bex, n, bitmap) \
-	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list) \
-		for ((b) = (bex)->start; (b) < (bex)->start + (bex)->len; (b)++)
-
 int xbitmap_set(struct xbitmap *bitmap, uint64_t start, uint64_t len);
 int xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
 int xbitmap_set_btcur_path(struct xbitmap *bitmap,
@@ -34,4 +27,19 @@ int xbitmap_set_btblocks(struct xbitmap *bitmap,
 		struct xfs_btree_cur *cur);
 uint64_t xbitmap_hweight(struct xbitmap *bitmap);
 
+/*
+ * Return codes for the bitmap iterator functions are 0 to continue iterating,
+ * and non-zero to stop iterating.  Any non-zero value will be passed up to the
+ * iteration caller.  The special value -ECANCELED can be used to stop
+ * iteration, because neither bitmap iterator ever generates that error code on
+ * its own.  Callers must not modify the bitmap while walking it.
+ */
+typedef int (*xbitmap_walk_fn)(uint64_t start, uint64_t len, void *priv);
+int xbitmap_walk(struct xbitmap *bitmap, xbitmap_walk_fn fn,
+		void *priv);
+
+typedef int (*xbitmap_walk_bits_fn)(uint64_t bit, void *priv);
+int xbitmap_walk_bits(struct xbitmap *bitmap, xbitmap_walk_bits_fn fn,
+		void *priv);
+
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index be65357285e6..8107a5470b71 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -445,6 +445,30 @@ xrep_init_btblock(
  * buffers associated with @bitmap.
  */
 
+static int
+xrep_invalidate_block(
+	uint64_t		fsbno,
+	void			*priv)
+{
+	struct xfs_scrub	*sc = priv;
+	struct xfs_buf		*bp;
+	int			error;
+
+	/* Skip AG headers and post-EOFS blocks */
+	if (!xfs_verify_fsbno(sc->mp, fsbno))
+		return 0;
+
+	error = xfs_buf_incore(sc->mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(sc->mp, fsbno),
+			XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK, &bp);
+	if (error)
+		return 0;
+
+	xfs_trans_bjoin(sc->tp, bp);
+	xfs_trans_binval(sc->tp, bp);
+	return 0;
+}
+
 /*
  * Invalidate buffers for per-AG btree blocks we're dumping.  This function
  * is not intended for use with file data repairs; we have bunmapi for that.
@@ -454,11 +478,6 @@ xrep_invalidate_blocks(
 	struct xfs_scrub	*sc,
 	struct xbitmap		*bitmap)
 {
-	struct xbitmap_range	*bmr;
-	struct xbitmap_range	*n;
-	struct xfs_buf		*bp;
-	xfs_fsblock_t		fsbno;
-
 	/*
 	 * For each block in each extent, see if there's an incore buffer for
 	 * exactly that block; if so, invalidate it.  The buffer cache only
@@ -467,23 +486,7 @@ xrep_invalidate_blocks(
 	 * because we never own those; and if we can't TRYLOCK the buffer we
 	 * assume it's owned by someone else.
 	 */
-	for_each_xbitmap_block(fsbno, bmr, n, bitmap) {
-		int		error;
-
-		/* Skip AG headers and post-EOFS blocks */
-		if (!xfs_verify_fsbno(sc->mp, fsbno))
-			continue;
-		error = xfs_buf_incore(sc->mp->m_ddev_targp,
-				XFS_FSB_TO_DADDR(sc->mp, fsbno),
-				XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK, &bp);
-		if (error)
-			continue;
-
-		xfs_trans_bjoin(sc->tp, bp);
-		xfs_trans_binval(sc->tp, bp);
-	}
-
-	return 0;
+	return xbitmap_walk_bits(bitmap, xrep_invalidate_block, sc);
 }
 
 /* Ensure the freelist is the correct size. */
@@ -504,6 +507,15 @@ xrep_fix_freelist(
 			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
 }
 
+/* Information about reaping extents after a repair. */
+struct xrep_reap_state {
+	struct xfs_scrub		*sc;
+
+	/* Reverse mapping owner and metadata reservation type. */
+	const struct xfs_owner_info	*oinfo;
+	enum xfs_ag_resv_type		resv;
+};
+
 /*
  * Put a block back on the AGFL.
  */
@@ -548,17 +560,23 @@ xrep_put_freelist(
 /* Dispose of a single block. */
 STATIC int
 xrep_reap_block(
-	struct xfs_scrub		*sc,
-	xfs_fsblock_t			fsbno,
-	const struct xfs_owner_info	*oinfo,
-	enum xfs_ag_resv_type		resv)
+	uint64_t			fsbno,
+	void				*priv)
 {
+	struct xrep_reap_state		*rs = priv;
+	struct xfs_scrub		*sc = rs->sc;
 	struct xfs_btree_cur		*cur;
 	struct xfs_buf			*agf_bp = NULL;
 	xfs_agblock_t			agbno;
 	bool				has_other_rmap;
 	int				error;
 
+	ASSERT(sc->ip != NULL ||
+	       XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.pag->pag_agno);
+	trace_xrep_dispose_btree_extent(sc->mp,
+			XFS_FSB_TO_AGNO(sc->mp, fsbno),
+			XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
+
 	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
 	ASSERT(XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.pag->pag_agno);
 
@@ -577,7 +595,8 @@ xrep_reap_block(
 	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, sc->sa.pag);
 
 	/* Can we find any other rmappings? */
-	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
+	error = xfs_rmap_has_other_keys(cur, agbno, 1, rs->oinfo,
+			&has_other_rmap);
 	xfs_btree_del_cursor(cur, error);
 	if (error)
 		goto out_free;
@@ -597,11 +616,11 @@ xrep_reap_block(
 	 */
 	if (has_other_rmap)
 		error = xfs_rmap_free(sc->tp, agf_bp, sc->sa.pag, agbno,
-					1, oinfo);
-	else if (resv == XFS_AG_RESV_AGFL)
+					1, rs->oinfo);
+	else if (rs->resv == XFS_AG_RESV_AGFL)
 		error = xrep_put_freelist(sc, agbno);
 	else
-		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
+		error = xfs_free_extent(sc->tp, fsbno, 1, rs->oinfo, rs->resv);
 	if (agf_bp != sc->sa.agf_bp)
 		xfs_trans_brelse(sc->tp, agf_bp);
 	if (error)
@@ -625,26 +644,15 @@ xrep_reap_extents(
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type)
 {
-	struct xbitmap_range		*bmr;
-	struct xbitmap_range		*n;
-	xfs_fsblock_t			fsbno;
-	int				error = 0;
+	struct xrep_reap_state		rs = {
+		.sc			= sc,
+		.oinfo			= oinfo,
+		.resv			= type,
+	};
 
 	ASSERT(xfs_has_rmapbt(sc->mp));
 
-	for_each_xbitmap_block(fsbno, bmr, n, bitmap) {
-		ASSERT(sc->ip != NULL ||
-		       XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.pag->pag_agno);
-		trace_xrep_dispose_btree_extent(sc->mp,
-				XFS_FSB_TO_AGNO(sc->mp, fsbno),
-				XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
-
-		error = xrep_reap_block(sc, fsbno, oinfo, type);
-		if (error)
-			break;
-	}
-
-	return error;
+	return xbitmap_walk_bits(bitmap, xrep_reap_block, &rs);
 }
 
 /*

