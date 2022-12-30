Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A05FCC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiL3Wff (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiL3Wfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:35:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F181A380
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:35:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2538261C17
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2DCC433D2;
        Fri, 30 Dec 2022 22:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439731;
        bh=I1EPQ4w66LtZzzb0Icl47NiJTQHo2fCy6rXJl+ZvRy8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EZ6Z0xZ448zierP6y6nJKZv5NNzGb/IJmWfUr/RukEuNOqHdgOQpA45T3NZCYCscj
         g6v4iWXeUC4eDCEgy0EnbI2wVJ1tPO18rG+QFiW4Kq2WvuQmtXOS8z7SYp5vQ6cnHx
         8Panva59p2Od5RIJT3EL8DkRVbcnsR3KqFkae08AsUHGqvXKIGj5kLc7KZjh8Q777L
         uNbmsC2tGQCmCWFjB9cxwUw2fo3RymXSdLSJqYFYA99NL9F7henVI1bJNV2qb8h6Nu
         OWqCji6HL9jT06PoKmxVT5BtlggY0r+TdrlKQCzeLIMZrEoeiDWdoGtIcyNQfMqoXt
         dG7vwWlEHsB4A==
Subject: [PATCH 2/5] xfs: pass per-ag references to xfs_free_extent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:01 -0800
Message-ID: <167243826104.683449.8792632119732010368.stgit@magnolia>
In-Reply-To: <167243826070.683449.502057797810903920.stgit@magnolia>
References: <167243826070.683449.502057797810903920.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Pass a reference to the per-AG structure to xfs_free_extent.  Most
callers already have one, so we can eliminate unnecessary lookups.  The
one exception to this is the EFI code, which the next patch will fix.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c             |    6 ++----
 fs/xfs/libxfs/xfs_alloc.c          |   15 +++++----------
 fs/xfs/libxfs/xfs_alloc.h          |    8 +++++---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    7 +++++--
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 +++--
 fs/xfs/scrub/repair.c              |    3 ++-
 fs/xfs/xfs_extfree_item.c          |    8 ++++++--
 7 files changed, 28 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index bb0c700afe3c..8de4143a5899 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -982,10 +982,8 @@ xfs_ag_extend_space(
 	if (error)
 		return error;
 
-	error = xfs_free_extent(tp, XFS_AGB_TO_FSB(pag->pag_mount, pag->pag_agno,
-					be32_to_cpu(agf->agf_length) - len),
-				len, &XFS_RMAP_OINFO_SKIP_UPDATE,
-				XFS_AG_RESV_NONE);
+	error = xfs_free_extent(tp, pag, be32_to_cpu(agf->agf_length) - len,
+			len, &XFS_RMAP_OINFO_SKIP_UPDATE, XFS_AG_RESV_NONE);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f8ff81c3de76..79790c9e7de4 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3381,7 +3381,8 @@ xfs_free_extent_fix_freelist(
 int
 __xfs_free_extent(
 	struct xfs_trans		*tp,
-	xfs_fsblock_t			bno,
+	struct xfs_perag		*pag,
+	xfs_agblock_t			agbno,
 	xfs_extlen_t			len,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type,
@@ -3389,12 +3390,9 @@ __xfs_free_extent(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_buf			*agbp;
-	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp, bno);
-	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp, bno);
 	struct xfs_agf			*agf;
 	int				error;
 	unsigned int			busy_flags = 0;
-	struct xfs_perag		*pag;
 
 	ASSERT(len != 0);
 	ASSERT(type != XFS_AG_RESV_AGFL);
@@ -3403,10 +3401,9 @@ __xfs_free_extent(
 			XFS_ERRTAG_FREE_EXTENT))
 		return -EIO;
 
-	pag = xfs_perag_get(mp, agno);
 	error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
 	if (error)
-		goto err;
+		return error;
 	agf = agbp->b_addr;
 
 	if (XFS_IS_CORRUPT(mp, agbno >= mp->m_sb.sb_agblocks)) {
@@ -3420,20 +3417,18 @@ __xfs_free_extent(
 		goto err_release;
 	}
 
-	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, oinfo, type);
+	error = xfs_free_ag_extent(tp, agbp, pag->pag_agno, agbno, len, oinfo,
+			type);
 	if (error)
 		goto err_release;
 
 	if (skip_discard)
 		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;
 	xfs_extent_busy_insert(tp, pag, agbno, len, busy_flags);
-	xfs_perag_put(pag);
 	return 0;
 
 err_release:
 	xfs_trans_brelse(tp, agbp);
-err:
-	xfs_perag_put(pag);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 2c3f762dfb58..5074aed6dfad 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -130,7 +130,8 @@ xfs_alloc_vextent(
 int				/* error */
 __xfs_free_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_fsblock_t		bno,	/* starting block number of extent */
+	struct xfs_perag	*pag,
+	xfs_agblock_t		agbno,
 	xfs_extlen_t		len,	/* length of extent */
 	const struct xfs_owner_info	*oinfo,	/* extent owner */
 	enum xfs_ag_resv_type	type,	/* block reservation type */
@@ -139,12 +140,13 @@ __xfs_free_extent(
 static inline int
 xfs_free_extent(
 	struct xfs_trans	*tp,
-	xfs_fsblock_t		bno,
+	struct xfs_perag	*pag,
+	xfs_agblock_t		agbno,
 	xfs_extlen_t		len,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type	type)
 {
-	return __xfs_free_extent(tp, bno, len, oinfo, type, false);
+	return __xfs_free_extent(tp, pag, agbno, len, oinfo, type, false);
 }
 
 int				/* error */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 8c83e265770c..2dbe553d87fb 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -156,9 +156,12 @@ __xfs_inobt_free_block(
 	struct xfs_buf		*bp,
 	enum xfs_ag_resv_type	resv)
 {
+	xfs_fsblock_t		fsbno;
+
 	xfs_inobt_mod_blockcount(cur, -1);
-	return xfs_free_extent(cur->bc_tp,
-			XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp)), 1,
+	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
+	return xfs_free_extent(cur->bc_tp, cur->bc_ag.pag,
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1,
 			&XFS_RMAP_OINFO_INOBT, resv);
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index e1f789866683..3d8e62da2ccc 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -112,8 +112,9 @@ xfs_refcountbt_free_block(
 			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
-	error = xfs_free_extent(cur->bc_tp, fsbno, 1, &XFS_RMAP_OINFO_REFC,
-			XFS_AG_RESV_METADATA);
+	error = xfs_free_extent(cur->bc_tp, cur->bc_ag.pag,
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1,
+			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 4b92f9253ccd..a0b85bdd4c5a 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -599,7 +599,8 @@ xrep_reap_block(
 	else if (resv == XFS_AG_RESV_AGFL)
 		error = xrep_put_freelist(sc, agbno);
 	else
-		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
+		error = xfs_free_extent(sc->tp, sc->sa.pag, agbno, 1, oinfo,
+				resv);
 	if (agf_bp != sc->sa.agf_bp)
 		xfs_trans_brelse(sc->tp, agf_bp);
 	if (error)
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 011b50469301..c1aae07467c9 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -350,6 +350,7 @@ xfs_trans_free_extent(
 	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent		*extp;
+	struct xfs_perag		*pag;
 	uint				next_extent;
 	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp,
 							xefi->xefi_startblock);
@@ -366,9 +367,12 @@ xfs_trans_free_extent(
 	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno,
 			xefi->xefi_blockcount);
 
-	error = __xfs_free_extent(tp, xefi->xefi_startblock,
-			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
+	pag = xfs_perag_get(mp, agno);
+	error = __xfs_free_extent(tp, pag, agbno, xefi->xefi_blockcount,
+			&oinfo, XFS_AG_RESV_NONE,
 			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	xfs_perag_put(pag);
+
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:

