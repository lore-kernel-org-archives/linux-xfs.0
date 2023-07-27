Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BE9EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbjG0WWS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjG0WWR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:22:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B16187
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 980A661F50
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D2EC433C7;
        Thu, 27 Jul 2023 22:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496532;
        bh=PB/elfiq8eiu4VqnIUPvUyu7reLdWofmSR9+Di2ws10=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=B5B1dh/+uJ7eAAGZJzUIKb1rZ4jCjuWiUIEMDrYvyvNUEtFvcyu1TN2TqyOhhZL4e
         wvtUlEEL/iHvxyCA4IrqIKx1by4T/jrBMa6o1hroU6kzXRgdDw55aONCnQ+S5k7PtM
         VHmwEO23abKtZy+9JDYzyRlJiILaXVMGZt9bE73SvoSb4kP2dTMG3Od1wm3QNVOBTv
         iylWlWBSRUg5j5MjLcaRvqz2/zYDuErAAWnjkMWGQ6QG1LRUGa2BCyQh0lJWpqX1PY
         /WoQcgvnPACmBRYZZAa8gfyinyQsahc9PlG1onuR1rV16aXziP48/96+16N0vI4q2Z
         mMHX5WcZ+Q0Kg==
Date:   Thu, 27 Jul 2023 15:22:11 -0700
Subject: [PATCH 3/9] xfs: only invalidate blocks if we're going to free them
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049622772.921010.16279660343912714127.stgit@frogsfrogsfrogs>
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

When we're discarding old btree blocks after a repair, only invalidate
the buffers for the ones that we're freeing -- if the metadata was
crosslinked with another data structure, we don't want to touch it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c   |   96 +++++++++++++++++++++----------------------------
 fs/xfs/scrub/repair.h |    1 -
 2 files changed, 42 insertions(+), 55 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 774dd8a12b2a6..b332b0e8e2594 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -70,54 +70,10 @@
  *
  * The caller is responsible for locking the AG headers for the entire rebuild
  * operation so that nothing else can sneak in and change the AG state while
- * we're not looking.  We also assume that the caller already invalidated any
- * buffers associated with @bitmap.
+ * we're not looking.  We must also invalidate any buffers associated with
+ * @bitmap.
  */
 
-static int
-xrep_invalidate_block(
-	uint64_t		fsbno,
-	void			*priv)
-{
-	struct xfs_scrub	*sc = priv;
-	struct xfs_buf		*bp;
-	int			error;
-
-	/* Skip AG headers and post-EOFS blocks */
-	if (!xfs_verify_fsbno(sc->mp, fsbno))
-		return 0;
-
-	error = xfs_buf_incore(sc->mp->m_ddev_targp,
-			XFS_FSB_TO_DADDR(sc->mp, fsbno),
-			XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK, &bp);
-	if (error)
-		return 0;
-
-	xfs_trans_bjoin(sc->tp, bp);
-	xfs_trans_binval(sc->tp, bp);
-	return 0;
-}
-
-/*
- * Invalidate buffers for per-AG btree blocks we're dumping.  This function
- * is not intended for use with file data repairs; we have bunmapi for that.
- */
-int
-xrep_invalidate_blocks(
-	struct xfs_scrub	*sc,
-	struct xbitmap		*bitmap)
-{
-	/*
-	 * For each block in each extent, see if there's an incore buffer for
-	 * exactly that block; if so, invalidate it.  The buffer cache only
-	 * lets us look for one buffer at a time, so we have to look one block
-	 * at a time.  Avoid invalidating AG headers and post-EOFS blocks
-	 * because we never own those; and if we can't TRYLOCK the buffer we
-	 * assume it's owned by someone else.
-	 */
-	return xbitmap_walk_bits(bitmap, xrep_invalidate_block, sc);
-}
-
 /* Information about reaping extents after a repair. */
 struct xrep_reap_state {
 	struct xfs_scrub		*sc;
@@ -127,9 +83,7 @@ struct xrep_reap_state {
 	enum xfs_ag_resv_type		resv;
 };
 
-/*
- * Put a block back on the AGFL.
- */
+/* Put a block back on the AGFL. */
 STATIC int
 xrep_put_freelist(
 	struct xfs_scrub	*sc,
@@ -168,6 +122,37 @@ xrep_put_freelist(
 	return 0;
 }
 
+/* Try to invalidate the incore buffer for a block that we're about to free. */
+STATIC void
+xrep_block_reap_binval(
+	struct xfs_scrub	*sc,
+	xfs_fsblock_t		fsbno)
+{
+	struct xfs_buf		*bp = NULL;
+	int			error;
+
+	/*
+	 * If there's an incore buffer for exactly this block, invalidate it.
+	 * Avoid invalidating AG headers and post-EOFS blocks because we never
+	 * own those.
+	 */
+	if (!xfs_verify_fsbno(sc->mp, fsbno))
+		return;
+
+	/*
+	 * We assume that the lack of any other known owners means that the
+	 * buffer can be locked without risk of deadlocking.
+	 */
+	error = xfs_buf_incore(sc->mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(sc->mp, fsbno),
+			XFS_FSB_TO_BB(sc->mp, 1), 0, &bp);
+	if (error)
+		return;
+
+	xfs_trans_bjoin(sc->tp, bp);
+	xfs_trans_binval(sc->tp, bp);
+}
+
 /* Dispose of a single block. */
 STATIC int
 xrep_reap_block(
@@ -225,14 +210,17 @@ xrep_reap_block(
 	 * blow on writeout, the filesystem will shut down, and the admin gets
 	 * to run xfs_repair.
 	 */
-	if (has_other_rmap)
-		error = xfs_rmap_free(sc->tp, agf_bp, sc->sa.pag, agbno,
-					1, rs->oinfo);
-	else if (rs->resv == XFS_AG_RESV_AGFL)
+	if (has_other_rmap) {
+		error = xfs_rmap_free(sc->tp, agf_bp, sc->sa.pag, agbno, 1,
+				rs->oinfo);
+	} else if (rs->resv == XFS_AG_RESV_AGFL) {
+		xrep_block_reap_binval(sc, fsbno);
 		error = xrep_put_freelist(sc, agbno);
-	else
+	} else {
+		xrep_block_reap_binval(sc, fsbno);
 		error = xfs_free_extent(sc->tp, sc->sa.pag, agbno, 1, rs->oinfo,
 				rs->resv);
+	}
 	if (agf_bp != sc->sa.agf_bp)
 		xfs_trans_brelse(sc->tp, agf_bp);
 	if (error)
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 601caa70f8703..e01d63a4a93b4 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -28,7 +28,6 @@ struct xbitmap;
 struct xagb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
-int xrep_invalidate_blocks(struct xfs_scrub *sc, struct xbitmap *btlist);
 
 struct xrep_find_ag_btree {
 	/* in: rmap owner of the btree we're looking for */

