Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C361DC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiL3XUX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XUV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C57FCCB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE26BB81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84816C433D2;
        Fri, 30 Dec 2022 23:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442417;
        bh=EixEoQNtS+2eWdgPZmELMXOUirVZvBcEiIXitelbSIo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Z66xw6e+TdqH4eo2SgNn+ho1tIfQhfkHAexZQNho2fTDLNmc7rqyMFfrX6CX7i0No
         9rufBEYtOkI1IwDIYglwTJ5ggywa2uyNQa01VWKsTu9Ne+kGiw3Kv97BZxcim8Y5Uu
         bJvRhFUjDqd4YofEpT9W/w25XL5K7lVN2+K/DJVWjewgEUhyZdnkzVGStmtFrDRORM
         lSHt9j5u0hxykRSsCSIBbusPeuB2zrAydGRGENea/gWG3WOdjQldHbrMHbuj0bBDYS
         fakEHWjzAJkL/C/heJdkX/HQhaPgH19Cgm2k9cgImeAx2tvwok1hObj69Xrk8bJHI+
         Y/942nTgT+wqw==
Subject: [PATCH 1/9] xfs: cull repair code that will never get used
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:27 -0800
Message-ID: <167243834697.691918.2999269102972229960.stgit@magnolia>
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

These two functions date from the era when I thought that we could
rebuild btrees by creating an alternate root and adding records one by
one.  In other words, they predate the btree bulk loader.  They're not
necessary now, so remove them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |   84 -------------------------------------------------
 fs/xfs/scrub/repair.h |    6 ----
 fs/xfs/scrub/trace.h  |   22 -------------
 3 files changed, 112 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 074c6f5974d1..c1037536ca45 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -297,90 +297,6 @@ xrep_calc_ag_resblks(
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
-	args.oinfo = *oinfo;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.pag->pag_agno, 0);
-	args.minlen = 1;
-	args.maxlen = 1;
-	args.prod = 1;
-	args.type = XFS_ALLOCTYPE_THIS_AG;
-	args.resv = resv;
-
-	error = xfs_alloc_vextent(&args);
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
index 150157ac2489..a764838e969d 100644
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
index cd9cfe98f14f..030ea76f1c90 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -828,28 +828,6 @@ TRACE_EVENT(xrep_refcount_extent_fn,
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

