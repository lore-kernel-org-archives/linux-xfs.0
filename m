Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2FFC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiL3XUz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XUy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:20:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D71510040
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:20:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 309BFB81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78F3C433EF;
        Fri, 30 Dec 2022 23:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442449;
        bh=ax6uOYsa/v12HvU79flOVHvBK6WHRE27NibPCj9fAVo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ubILSlw2exqFqmw0NOY+ZZRZiBjx7Dl1U2HWRJh20HyGxPJvkIXhEGaJh8VXW2npG
         0QPhNgnzp5KYVhkPOYNc9sFIBEDtaS9fT54d4YDGWbUji9BAyyoIjeG/iLTemRkWGb
         k8ceAiEjzzdZiw7ja2oRskqyAgDBkh2jfLV6v3sJH09tDV4/3jYnoAzDI9CqXMXrk4
         3Gao8L2VBG9gC4DKGOevdopaG4G8SsmB+GeEQD2vsyImxJK5WWFDo/YgItxTuk6h9F
         a9/wYFKSwHSRjNnInbDDE6b6rJtXAxVwF46ZT32l4GMh5ZCWl7PVdHql8BMuShE66s
         eJWRDzUHyrXyQ==
Subject: [PATCH 3/9] xfs: only invalidate blocks if we're going to free them
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:27 -0800
Message-ID: <167243834726.691918.3012539510709402324.stgit@magnolia>
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

When we're discarding old btree blocks after a repair, only invalidate
the buffers for the ones that we're freeing -- if the metadata was
crosslinked with another data structure, we don't want to touch it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c   |   96 +++++++++++++++++++++----------------------------
 fs/xfs/scrub/repair.h |    1 -
 2 files changed, 42 insertions(+), 55 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 613a8b897a25..b75ec582e5b1 100644
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
index 72ea48802848..fd2f3ada7ca3 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -28,7 +28,6 @@ struct xbitmap;
 struct xagb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
-int xrep_invalidate_blocks(struct xfs_scrub *sc, struct xbitmap *btlist);
 
 struct xrep_find_ag_btree {
 	/* in: rmap owner of the btree we're looking for */

