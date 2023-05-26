Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C66C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjEZAnW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjEZAnV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:43:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305FA194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:43:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB25A64BE8
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D0EC433EF;
        Fri, 26 May 2023 00:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061795;
        bh=sRXGazUoHSC5lasAnH8OXBxLKX7jRPxDysfvTo3npK8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=FLOpZs6Uz+AHzRMl5g7eGFEruXuwzmQ5yhkNPpQKsHhis7MVEF2kQrSR1tsFt3Qe6
         s73BrhUDftxrVAc+E7ABkB8BnbOvOGOCN/XHjXGc2avXWH/tdEAwIbtLuC0yy4OyWP
         cQIj1k1Jk/JH0dVZg7LhaU0aSImWCmxhQc/ifezZBmoW6v62sQ8Yl2B2ngs45iZT2O
         Sc8P6ywQ3LcoM5nv2lPQJh0O8rL4V3vFQ1Ss+dlD5txpx0OjXsHLIKeWyCC2VgYkzr
         3woBqhEwRWRsukfQTLyvVEy3zteUUq2eNHcRZiGIZXGR3IqbAZFfW3K9LzDfpYJ7MX
         QljfYZ72jlRtg==
Date:   Thu, 25 May 2023 17:43:14 -0700
Subject: [PATCH 1/9] xfs: cull repair code that will never get used
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055631.3728180.16921290558396159405.stgit@frogsfrogsfrogs>
In-Reply-To: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

These two functions date from the era when I thought that we could
rebuild btrees by creating an alternate root and adding records one by
one.  In other words, they predate the btree bulk loader.  They're not
necessary now, so remove them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |   83 -------------------------------------------------
 fs/xfs/scrub/repair.h |    6 ----
 fs/xfs/scrub/trace.h  |   22 -------------
 3 files changed, 111 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index ac6d8803e660..eedb3863b4ef 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -297,89 +297,6 @@ xrep_calc_ag_resblks(
 	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
 }
 
-/* Allocate a block in an AG. */
-int
-xrep_alloc_ag_block(
-	struct xfs_scrub		*sc,
-	const struct xfs_owner_info	*oinfo,
-	xfs_fsblock_t			*fsbno,
-	enum xfs_ag_resv_type		resv)
-{
-	struct xfs_alloc_arg		args = {0};
-	xfs_agblock_t			bno;
-	int				error;
-
-	switch (resv) {
-	case XFS_AG_RESV_AGFL:
-	case XFS_AG_RESV_RMAPBT:
-		error = xfs_alloc_get_freelist(sc->sa.pag, sc->tp,
-				sc->sa.agf_bp, &bno, 1);
-		if (error)
-			return error;
-		if (bno == NULLAGBLOCK)
-			return -ENOSPC;
-		xfs_extent_busy_reuse(sc->mp, sc->sa.pag, bno, 1, false);
-		*fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno, bno);
-		if (resv == XFS_AG_RESV_RMAPBT)
-			xfs_ag_resv_rmapbt_alloc(sc->mp, sc->sa.pag->pag_agno);
-		return 0;
-	default:
-		break;
-	}
-
-	args.tp = sc->tp;
-	args.mp = sc->mp;
-	args.pag = sc->sa.pag;
-	args.oinfo = *oinfo;
-	args.minlen = 1;
-	args.maxlen = 1;
-	args.prod = 1;
-	args.resv = resv;
-
-	error = xfs_alloc_vextent_this_ag(&args, sc->sa.pag->pag_agno);
-	if (error)
-		return error;
-	if (args.fsbno == NULLFSBLOCK)
-		return -ENOSPC;
-	ASSERT(args.len == 1);
-	*fsbno = args.fsbno;
-
-	return 0;
-}
-
-/* Initialize a new AG btree root block with zero entries. */
-int
-xrep_init_btblock(
-	struct xfs_scrub		*sc,
-	xfs_fsblock_t			fsb,
-	struct xfs_buf			**bpp,
-	xfs_btnum_t			btnum,
-	const struct xfs_buf_ops	*ops)
-{
-	struct xfs_trans		*tp = sc->tp;
-	struct xfs_mount		*mp = sc->mp;
-	struct xfs_buf			*bp;
-	int				error;
-
-	trace_xrep_init_btblock(mp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), btnum);
-
-	ASSERT(XFS_FSB_TO_AGNO(mp, fsb) == sc->sa.pag->pag_agno);
-	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
-			XFS_FSB_TO_DADDR(mp, fsb), XFS_FSB_TO_BB(mp, 1), 0,
-			&bp);
-	if (error)
-		return error;
-	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
-	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.pag->pag_agno);
-	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
-	xfs_trans_log_buf(tp, bp, 0, BBTOB(bp->b_length) - 1);
-	bp->b_ops = ops;
-	*bpp = bp;
-
-	return 0;
-}
-
 /*
  * Reconstructing per-AG Btrees
  *
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index dce791c679ee..fdccad54936f 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -23,12 +23,6 @@ int xrep_roll_ag_trans(struct xfs_scrub *sc);
 bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
 		enum xfs_ag_resv_type type);
 xfs_extlen_t xrep_calc_ag_resblks(struct xfs_scrub *sc);
-int xrep_alloc_ag_block(struct xfs_scrub *sc,
-		const struct xfs_owner_info *oinfo, xfs_fsblock_t *fsbno,
-		enum xfs_ag_resv_type resv);
-int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
-		struct xfs_buf **bpp, xfs_btnum_t btnum,
-		const struct xfs_buf_ops *ops);
 
 struct xbitmap;
 struct xagb_bitmap;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index b3894daeb86a..9c8c7dd0f262 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -827,28 +827,6 @@ TRACE_EVENT(xrep_refcount_extent_fn,
 		  __entry->refcount)
 )
 
-TRACE_EVENT(xrep_init_btblock,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
-		 xfs_btnum_t btnum),
-	TP_ARGS(mp, agno, agbno, btnum),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(uint32_t, btnum)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->agbno = agbno;
-		__entry->btnum = btnum;
-	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x btree %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno,
-		  __entry->agbno,
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS))
-)
 TRACE_EVENT(xrep_findroot_block,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
 		 uint32_t magic, uint16_t level),

