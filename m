Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E4FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbiL3XW0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:22:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0501D1D0FE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:22:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85E4A61C32
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3040C433EF;
        Fri, 30 Dec 2022 23:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442542;
        bh=R1ZkTAPcBd4hUIMPFfi63DcPPERxZV8cjdWlQOHp3t4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ac/OA20sAlqHWhWuMxtpyJpVG2wHcZipQLPZ/6Px+Fm4VZaH/+hNpJ3nyAgK5mtLD
         CsFm3iv6iVfl7AufClMcvK4nf4cC6Xv6GudQ10TdV7w1u/7QLkm2SH7OqsiCM3ISi+
         xg1HNG4eh0d42bLi5qycKtsA8h6iik3XDX9cSbK6pAmyOupIiRAeovZoBe55kMDbj4
         ZaFiDHdmKIRLipq9izMUmkFhrLtZ0pPKnmQn7tj3/oPDhOh5f6WNDcrxYqnun9YAuc
         DDTZpYNY/uC9nS+wc3xBqYcuC/2LB4/t+Fe0kyxmFOLy/I1mp13TfxPW/CoEm3gAiA
         OSE6n2oCKjgug==
Subject: [PATCH 9/9] xfs: use per-AG bitmaps to reap unused AG metadata blocks
 during repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:28 -0800
Message-ID: <167243834809.691918.13208690725500482903.stgit@magnolia>
In-Reply-To: <167243834673.691918.7562784486565988430.stgit@magnolia>
References: <167243834673.691918.7562784486565988430.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The AGFL repair code uses a series of bitmaps to figure out where there
are OWN_AG blocks that are not claimed by the free space and rmap
btrees.  These blocks become the new AGFL, and any overflow is reaped.
The bitmaps current track xfs_fsblock_t even though we already know the
AG number.

In the last patch, we introduced a new bitmap "type" for tracking
xfs_agblock_t extents.  Port the reaping code and the AGFL repair to use
this new type, which makes it very obvious what we're tracking.  This
also eliminates a bunch of unnecessary agblock <-> fsblock conversions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |   74 ++++++++++++++++++----------------------
 fs/xfs/scrub/bitmap.c          |   41 ++--------------------
 fs/xfs/scrub/bitmap.h          |    6 +--
 fs/xfs/scrub/reap.c            |   14 ++------
 fs/xfs/scrub/reap.h            |    5 +--
 5 files changed, 45 insertions(+), 95 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index bd4283d16891..df0dadcedd97 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -444,13 +444,13 @@ xrep_agf(
 
 struct xrep_agfl {
 	/* Bitmap of alleged AGFL blocks that we're not going to add. */
-	struct xbitmap		crossed;
+	struct xagb_bitmap	crossed;
 
 	/* Bitmap of other OWN_AG metadata blocks. */
-	struct xbitmap		agmetablocks;
+	struct xagb_bitmap	agmetablocks;
 
 	/* Bitmap of free space. */
-	struct xbitmap		*freesp;
+	struct xagb_bitmap	*freesp;
 
 	/* rmapbt cursor for finding crosslinked blocks */
 	struct xfs_btree_cur	*rmap_cur;
@@ -466,7 +466,6 @@ xrep_agfl_walk_rmap(
 	void			*priv)
 {
 	struct xrep_agfl	*ra = priv;
-	xfs_fsblock_t		fsb;
 	int			error = 0;
 
 	if (xchk_should_terminate(ra->sc, &error))
@@ -474,14 +473,13 @@ xrep_agfl_walk_rmap(
 
 	/* Record all the OWN_AG blocks. */
 	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
-		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-				rec->rm_startblock);
-		error = xbitmap_set(ra->freesp, fsb, rec->rm_blockcount);
+		error = xagb_bitmap_set(ra->freesp, rec->rm_startblock,
+				rec->rm_blockcount);
 		if (error)
 			return error;
 	}
 
-	return xbitmap_set_btcur_path(&ra->agmetablocks, cur);
+	return xagb_bitmap_set_btcur_path(&ra->agmetablocks, cur);
 }
 
 /* Strike out the blocks that are cross-linked according to the rmapbt. */
@@ -492,12 +490,10 @@ xrep_agfl_check_extent(
 	void			*priv)
 {
 	struct xrep_agfl	*ra = priv;
-	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(ra->sc->mp, start);
+	xfs_agblock_t		agbno = start;
 	xfs_agblock_t		last_agbno = agbno + len - 1;
 	int			error;
 
-	ASSERT(XFS_FSB_TO_AGNO(ra->sc->mp, start) == ra->sc->sa.pag->pag_agno);
-
 	while (agbno <= last_agbno) {
 		bool		other_owners;
 
@@ -507,7 +503,7 @@ xrep_agfl_check_extent(
 			return error;
 
 		if (other_owners) {
-			error = xbitmap_set(&ra->crossed, agbno, 1);
+			error = xagb_bitmap_set(&ra->crossed, agbno, 1);
 			if (error)
 				return error;
 		}
@@ -533,7 +529,7 @@ STATIC int
 xrep_agfl_collect_blocks(
 	struct xfs_scrub	*sc,
 	struct xfs_buf		*agf_bp,
-	struct xbitmap		*agfl_extents,
+	struct xagb_bitmap	*agfl_extents,
 	xfs_agblock_t		*flcount)
 {
 	struct xrep_agfl	ra;
@@ -543,8 +539,8 @@ xrep_agfl_collect_blocks(
 
 	ra.sc = sc;
 	ra.freesp = agfl_extents;
-	xbitmap_init(&ra.agmetablocks);
-	xbitmap_init(&ra.crossed);
+	xagb_bitmap_init(&ra.agmetablocks);
+	xagb_bitmap_init(&ra.crossed);
 
 	/* Find all space used by the free space btrees & rmapbt. */
 	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
@@ -556,7 +552,7 @@ xrep_agfl_collect_blocks(
 	/* Find all blocks currently being used by the bnobt. */
 	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
 			sc->sa.pag, XFS_BTNUM_BNO);
-	error = xbitmap_set_btblocks(&ra.agmetablocks, cur);
+	error = xagb_bitmap_set_btblocks(&ra.agmetablocks, cur);
 	xfs_btree_del_cursor(cur, error);
 	if (error)
 		goto out_bmp;
@@ -564,7 +560,7 @@ xrep_agfl_collect_blocks(
 	/* Find all blocks currently being used by the cntbt. */
 	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
 			sc->sa.pag, XFS_BTNUM_CNT);
-	error = xbitmap_set_btblocks(&ra.agmetablocks, cur);
+	error = xagb_bitmap_set_btblocks(&ra.agmetablocks, cur);
 	xfs_btree_del_cursor(cur, error);
 	if (error)
 		goto out_bmp;
@@ -573,17 +569,17 @@ xrep_agfl_collect_blocks(
 	 * Drop the freesp meta blocks that are in use by btrees.
 	 * The remaining blocks /should/ be AGFL blocks.
 	 */
-	error = xbitmap_disunion(agfl_extents, &ra.agmetablocks);
+	error = xagb_bitmap_disunion(agfl_extents, &ra.agmetablocks);
 	if (error)
 		goto out_bmp;
 
 	/* Strike out the blocks that are cross-linked. */
 	ra.rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
-	error = xbitmap_walk(agfl_extents, xrep_agfl_check_extent, &ra);
+	error = xagb_bitmap_walk(agfl_extents, xrep_agfl_check_extent, &ra);
 	xfs_btree_del_cursor(ra.rmap_cur, error);
 	if (error)
 		goto out_bmp;
-	error = xbitmap_disunion(agfl_extents, &ra.crossed);
+	error = xagb_bitmap_disunion(agfl_extents, &ra.crossed);
 	if (error)
 		goto out_bmp;
 
@@ -591,12 +587,12 @@ xrep_agfl_collect_blocks(
 	 * Calculate the new AGFL size.  If we found more blocks than fit in
 	 * the AGFL we'll free them later.
 	 */
-	*flcount = min_t(uint64_t, xbitmap_hweight(agfl_extents),
+	*flcount = min_t(uint64_t, xagb_bitmap_hweight(agfl_extents),
 			 xfs_agfl_size(mp));
 
 out_bmp:
-	xbitmap_destroy(&ra.crossed);
-	xbitmap_destroy(&ra.agmetablocks);
+	xagb_bitmap_destroy(&ra.crossed);
+	xagb_bitmap_destroy(&ra.agmetablocks);
 	return error;
 }
 
@@ -626,7 +622,7 @@ xrep_agfl_update_agf(
 }
 
 struct xrep_agfl_fill {
-	struct xbitmap		used_extents;
+	struct xagb_bitmap	used_extents;
 	struct xfs_scrub	*sc;
 	__be32			*agfl_bno;
 	xfs_agblock_t		flcount;
@@ -642,17 +638,15 @@ xrep_agfl_fill(
 {
 	struct xrep_agfl_fill	*af = priv;
 	struct xfs_scrub	*sc = af->sc;
-	xfs_fsblock_t		fsbno = start;
+	xfs_agblock_t		agbno = start;
 	int			error;
 
-	trace_xrep_agfl_insert(sc->sa.pag, XFS_FSB_TO_AGBNO(sc->mp, start),
-			len);
+	trace_xrep_agfl_insert(sc->sa.pag, agbno, len);
 
-	while (fsbno < start + len && af->fl_off < af->flcount)
-		af->agfl_bno[af->fl_off++] =
-				cpu_to_be32(XFS_FSB_TO_AGBNO(sc->mp, fsbno++));
+	while (agbno < start + len && af->fl_off < af->flcount)
+		af->agfl_bno[af->fl_off++] = cpu_to_be32(agbno++);
 
-	error = xbitmap_set(&af->used_extents, start, fsbno - 1);
+	error = xagb_bitmap_set(&af->used_extents, start, agbno - 1);
 	if (error)
 		return error;
 
@@ -667,7 +661,7 @@ STATIC int
 xrep_agfl_init_header(
 	struct xfs_scrub	*sc,
 	struct xfs_buf		*agfl_bp,
-	struct xbitmap		*agfl_extents,
+	struct xagb_bitmap	*agfl_extents,
 	xfs_agblock_t		flcount)
 {
 	struct xrep_agfl_fill	af = {
@@ -695,17 +689,17 @@ xrep_agfl_init_header(
 	 * blocks than fit in the AGFL, they will be freed in a subsequent
 	 * step.
 	 */
-	xbitmap_init(&af.used_extents);
+	xagb_bitmap_init(&af.used_extents);
 	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp),
-	xbitmap_walk(agfl_extents, xrep_agfl_fill, &af);
-	error = xbitmap_disunion(agfl_extents, &af.used_extents);
+	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
 		return error;
 
 	/* Write new AGFL to disk. */
 	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
 	xfs_trans_log_buf(sc->tp, agfl_bp, 0, BBTOB(agfl_bp->b_length) - 1);
-	xbitmap_destroy(&af.used_extents);
+	xagb_bitmap_destroy(&af.used_extents);
 	return 0;
 }
 
@@ -714,7 +708,7 @@ int
 xrep_agfl(
 	struct xfs_scrub	*sc)
 {
-	struct xbitmap		agfl_extents;
+	struct xagb_bitmap	agfl_extents;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_buf		*agf_bp;
 	struct xfs_buf		*agfl_bp;
@@ -725,7 +719,7 @@ xrep_agfl(
 	if (!xfs_has_rmapbt(mp))
 		return -EOPNOTSUPP;
 
-	xbitmap_init(&agfl_extents);
+	xagb_bitmap_init(&agfl_extents);
 
 	/*
 	 * Read the AGF so that we can query the rmapbt.  We hope that there's
@@ -774,10 +768,10 @@ xrep_agfl(
 		goto err;
 
 	/* Dump any AGFL overflow. */
-	error = xrep_reap_ag_metadata(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
+	error = xrep_reap_agblocks(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
 			XFS_AG_RESV_AGFL);
 err:
-	xbitmap_destroy(&agfl_extents);
+	xagb_bitmap_destroy(&agfl_extents);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index ebcb7a07d26f..f707434b1c86 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -301,21 +301,15 @@ xagb_bitmap_set_btblocks(
  * blocks going from the leaf towards the root.
  */
 int
-xbitmap_set_btcur_path(
-	struct xbitmap		*bitmap,
+xagb_bitmap_set_btcur_path(
+	struct xagb_bitmap	*bitmap,
 	struct xfs_btree_cur	*cur)
 {
-	struct xfs_buf		*bp;
-	xfs_fsblock_t		fsb;
 	int			i;
 	int			error;
 
 	for (i = 0; i < cur->bc_nlevels && cur->bc_levels[i].ptr == 1; i++) {
-		xfs_btree_get_block(cur, i, &bp);
-		if (!bp)
-			continue;
-		fsb = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
-		error = xbitmap_set(bitmap, fsb, 1);
+		error = xagb_bitmap_visit_btblock(cur, i, bitmap);
 		if (error)
 			return error;
 	}
@@ -323,35 +317,6 @@ xbitmap_set_btcur_path(
 	return 0;
 }
 
-/* Collect a btree's block in the bitmap. */
-STATIC int
-xbitmap_collect_btblock(
-	struct xfs_btree_cur	*cur,
-	int			level,
-	void			*priv)
-{
-	struct xbitmap		*bitmap = priv;
-	struct xfs_buf		*bp;
-	xfs_fsblock_t		fsbno;
-
-	xfs_btree_get_block(cur, level, &bp);
-	if (!bp)
-		return 0;
-
-	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
-	return xbitmap_set(bitmap, fsbno, 1);
-}
-
-/* Walk the btree and mark the bitmap wherever a btree block is found. */
-int
-xbitmap_set_btblocks(
-	struct xbitmap		*bitmap,
-	struct xfs_btree_cur	*cur)
-{
-	return xfs_btree_visit_blocks(cur, xbitmap_collect_btblock,
-			XFS_BTREE_VISIT_ALL, bitmap);
-}
-
 /* How many bits are set in this bitmap? */
 uint64_t
 xbitmap_hweight(
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 8c2711feea30..4265e53f45fa 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -16,10 +16,6 @@ void xbitmap_destroy(struct xbitmap *bitmap);
 int xbitmap_clear(struct xbitmap *bitmap, uint64_t start, uint64_t len);
 int xbitmap_set(struct xbitmap *bitmap, uint64_t start, uint64_t len);
 int xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
-int xbitmap_set_btcur_path(struct xbitmap *bitmap,
-		struct xfs_btree_cur *cur);
-int xbitmap_set_btblocks(struct xbitmap *bitmap,
-		struct xfs_btree_cur *cur);
 uint64_t xbitmap_hweight(struct xbitmap *bitmap);
 
 /*
@@ -104,5 +100,7 @@ static inline int xagb_bitmap_walk(struct xagb_bitmap *bitmap,
 
 int xagb_bitmap_set_btblocks(struct xagb_bitmap *bitmap,
 		struct xfs_btree_cur *cur);
+int xagb_bitmap_set_btcur_path(struct xagb_bitmap *bitmap,
+		struct xfs_btree_cur *cur);
 
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 7a6b68255781..797536e6eba8 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -422,19 +422,13 @@ xreap_agmeta_extent(
 {
 	struct xreap_state	*rs = priv;
 	struct xfs_scrub	*sc = rs->sc;
-	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
-	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
+	xfs_agblock_t		agbno = fsbno;
 	xfs_agblock_t		agbno_next = agbno + len;
 	int			error = 0;
 
 	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(sc->ip == NULL);
 
-	if (agno != sc->sa.pag->pag_agno) {
-		ASSERT(sc->sa.pag->pag_agno == agno);
-		return -EFSCORRUPTED;
-	}
-
 	while (agbno < agbno_next) {
 		xfs_extlen_t	aglen;
 		bool		crosslinked;
@@ -468,9 +462,9 @@ xreap_agmeta_extent(
 
 /* Dispose of every block of every AG metadata extent in the bitmap. */
 int
-xrep_reap_ag_metadata(
+xrep_reap_agblocks(
 	struct xfs_scrub		*sc,
-	struct xbitmap			*bitmap,
+	struct xagb_bitmap		*bitmap,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type)
 {
@@ -484,7 +478,7 @@ xrep_reap_ag_metadata(
 	ASSERT(xfs_has_rmapbt(sc->mp));
 	ASSERT(sc->ip == NULL);
 
-	error = xbitmap_walk(bitmap, xreap_agmeta_extent, &rs);
+	error = xagb_bitmap_walk(bitmap, xreap_agmeta_extent, &rs);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
index 143bd5ae5fe7..032d1eac91b2 100644
--- a/fs/xfs/scrub/reap.h
+++ b/fs/xfs/scrub/reap.h
@@ -6,8 +6,7 @@
 #ifndef __XFS_SCRUB_REAP_H__
 #define __XFS_SCRUB_REAP_H__
 
-int xrep_reap_ag_metadata(struct xfs_scrub *sc, struct xbitmap *bitmap,
-		const struct xfs_owner_info *oinfo,
-		enum xfs_ag_resv_type type);
+int xrep_reap_agblocks(struct xfs_scrub *sc, struct xagb_bitmap *bitmap,
+		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 
 #endif /* __XFS_SCRUB_REAP_H__ */

