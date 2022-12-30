Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B76C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiL3XVH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XVG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:21:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6E710040
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:21:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AADC61C2C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B67EC433D2;
        Fri, 30 Dec 2022 23:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442464;
        bh=e50R8i/LhTKHFjenz9zZ6YwR2DAfsyRgM4Fqmq9DKGY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=etonmix9gSXkdKqMmHYP/nix6SAH0SuKT+fjDkTJFI+hrCyqWRRw1KqABlTiIcNvq
         I4iJNqBEqU7BpKWhSHN8TA1VpJyqFt0taPaTSMpvACOvze9ViN1L4PsRG2f+A9XLkT
         ilG6SSvvTzf2S8BAxT0urbuQKLFkKKaSuNW1mL65iWG9Rx87s8v3Co0oTSgEBYFf1e
         WGvkDLH1T91siFjlRCNUw0Es8QUrIEA79gj8Mb6rsf9bGRu6blq+RJO+Qzs5Z5r53L
         9siFORw3b3NFwQuei4lcr6bG7kciZgMkmGoFzNIBpdmVceanMp77ulx52+jIH5XB/f
         UFoBeR4T1VHCA==
Subject: [PATCH 4/9] xfs: only allow reaping of per-AG blocks in
 xrep_reap_extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:27 -0800
Message-ID: <167243834740.691918.1994751069336540270.stgit@magnolia>
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
index b75ec582e5b1..c57388c47dc4 100644
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

