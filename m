Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3E9EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjG0WWa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjG0WW3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:22:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22522D5E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:22:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B6C161F6A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E3CC433C8;
        Thu, 27 Jul 2023 22:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496547;
        bh=DjKvtcv1t6Hldv9itAGDM62bjgDMJg+I7bmheIURERM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hhmDte5KlwxdJIIXr+yBl5/dIEc9yNaUBb9jS2JS8M7GnFfLQj1ZiDjq2F/nGI6Pt
         Iqmja743N2OqqVID/31lJomTsDghqDAX0rEILBKiQ/GQ8isSnJQrDYHs5kShR0qak7
         DjogxheKEHsi7AyduyB/eb2b2NAsm8wTVFMDgUKYAHbfezP2eFgoZ9ZF6zIkr1MJKM
         RnmS8CgyPmE6QRT+8u7XtquHCBfH8jBz0W2qsK+GrvmJJ26lQcfAsYXXHY3JCVMkXU
         hcAYbBEDzdfz0zKQ7pvTq7/vfG4qc7yhs2GqhexkSqBSqT3UWpjYbL29rGYeyUltlu
         AzARpnhYRcv7Q==
Date:   Thu, 27 Jul 2023 15:22:27 -0700
Subject: [PATCH 4/9] xfs: only allow reaping of per-AG blocks in
 xrep_reap_extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049622786.921010.15243435568993927889.stgit@frogsfrogsfrogs>
In-Reply-To: <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
References: <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've refactored btree cursors to require the caller to pass in
a perag structure, there are numerous problems in xrep_reap_extents if
it's being called to reap extents for an inode metadata repair.  We
don't have any repair functions that can do that, so drop the support
for now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c |   45 +++++++++++++--------------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index b332b0e8e2594..bc180171d0cb7 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -162,40 +162,30 @@ xrep_reap_block(
 	struct xrep_reap_state		*rs = priv;
 	struct xfs_scrub		*sc = rs->sc;
 	struct xfs_btree_cur		*cur;
-	struct xfs_buf			*agf_bp = NULL;
+	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	bool				has_other_rmap;
 	int				error;
 
-	ASSERT(sc->ip != NULL ||
-	       XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.pag->pag_agno);
-	trace_xrep_dispose_btree_extent(sc->mp,
-			XFS_FSB_TO_AGNO(sc->mp, fsbno),
-			XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
-
+	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
 	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
-	ASSERT(XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.pag->pag_agno);
 
-	/*
-	 * If we are repairing per-inode metadata, we need to read in the AGF
-	 * buffer.  Otherwise, we're repairing a per-AG structure, so reuse
-	 * the AGF buffer that the setup functions already grabbed.
-	 */
-	if (sc->ip) {
-		error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
-		if (error)
-			return error;
-	} else {
-		agf_bp = sc->sa.agf_bp;
+	trace_xrep_dispose_btree_extent(sc->mp, agno, agbno, 1);
+
+	/* We don't support reaping file extents yet. */
+	if (sc->ip != NULL || sc->sa.pag->pag_agno != agno) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
 	}
-	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, sc->sa.pag);
+
+	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp, sc->sa.pag);
 
 	/* Can we find any other rmappings? */
 	error = xfs_rmap_has_other_keys(cur, agbno, 1, rs->oinfo,
 			&has_other_rmap);
 	xfs_btree_del_cursor(cur, error);
 	if (error)
-		goto out_free;
+		return error;
 
 	/*
 	 * If there are other rmappings, this block is cross linked and must
@@ -211,8 +201,8 @@ xrep_reap_block(
 	 * to run xfs_repair.
 	 */
 	if (has_other_rmap) {
-		error = xfs_rmap_free(sc->tp, agf_bp, sc->sa.pag, agbno, 1,
-				rs->oinfo);
+		error = xfs_rmap_free(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno,
+				1, rs->oinfo);
 	} else if (rs->resv == XFS_AG_RESV_AGFL) {
 		xrep_block_reap_binval(sc, fsbno);
 		error = xrep_put_freelist(sc, agbno);
@@ -221,19 +211,10 @@ xrep_reap_block(
 		error = xfs_free_extent(sc->tp, sc->sa.pag, agbno, 1, rs->oinfo,
 				rs->resv);
 	}
-	if (agf_bp != sc->sa.agf_bp)
-		xfs_trans_brelse(sc->tp, agf_bp);
 	if (error)
 		return error;
 
-	if (sc->ip)
-		return xfs_trans_roll_inode(&sc->tp, sc->ip);
 	return xrep_roll_ag_trans(sc);
-
-out_free:
-	if (agf_bp != sc->sa.agf_bp)
-		xfs_trans_brelse(sc->tp, agf_bp);
-	return error;
 }
 
 /* Dispose of every block of every extent in the bitmap. */

