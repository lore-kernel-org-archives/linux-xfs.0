Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B96C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjEZAnt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjEZAns (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:43:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5097D12E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:43:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0E1D63A6B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51488C433D2;
        Fri, 26 May 2023 00:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061826;
        bh=Eg5a5AoxMbHJq4hCkQ8GU5CGP2+b7xRlY8Bpnca4638=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=sznZSQolJ+QCTKTWJHR5/jZ04N/Zm6KKVxoSNT+RyzhZcj+r5uD5OtMsTkjuiJro/
         HfSoNk03yW9eqtBdkogwFtNW53kQFDqQ8C+BlJSrJ75ghL107CiE2yqnSrnQnrYs44
         il0JhU9/uhF9NPM+gkt1+K+Lg3uYtEQleq/H67q1Nf3SniyCFTcVDNG2qR361hCX7q
         0WalJnG81OYATgwJqIkTDaNQp6KO2OXp1ohNwBsg+Dc3t01iiTREznZruG2gnv3xEb
         I/bSBSaK5p0FO3LUZAvdks9k4sIPHlus/VbQnzpPfvV6rW7d5+DinYx0yCdhGqHFBZ
         QYTZF1r+FBQwA==
Date:   Thu, 25 May 2023 17:43:45 -0700
Subject: [PATCH 3/9] xfs: only invalidate blocks if we're going to free them
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055660.3728180.10913177215578833888.stgit@frogsfrogsfrogs>
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

When we're discarding old btree blocks after a repair, only invalidate
the buffers for the ones that we're freeing -- if the metadata was
crosslinked with another data structure, we don't want to touch it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c   |   96 +++++++++++++++++++++----------------------------
 fs/xfs/scrub/repair.h |    1 -
 2 files changed, 42 insertions(+), 55 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 774dd8a12b2a..b332b0e8e259 100644
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
index 601caa70f870..e01d63a4a93b 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -28,7 +28,6 @@ struct xbitmap;
 struct xagb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
-int xrep_invalidate_blocks(struct xfs_scrub *sc, struct xbitmap *btlist);
 
 struct xrep_find_ag_btree {
 	/* in: rmap owner of the btree we're looking for */

