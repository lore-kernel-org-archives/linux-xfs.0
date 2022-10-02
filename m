Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20941C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiJBSgQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiJBSgP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:36:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0065536840
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:36:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9125160EDB
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E46C433C1;
        Sun,  2 Oct 2022 18:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735774;
        bh=hXjGPUntruUWSd4qEdA5G44yk7Z4fejiRzDPSkwLjU0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=suuUhZxhfeI4S22NREmGLV7+3NtP6yjqa/HjhCSbWVh3KuVSsaxchMAXLUs7hdOni
         F0ehjTZlZIVsuT2qcM/Ga7jVIEWxaO7MlnWjBZZhVtrRenO5XVUwfMawrIU/mSx6kC
         p21PIDPiAfl0nKbZd3dSwFPaz9BuQqAkfYTa6a6IC6w/2cJFNMTGtQSssT93HT1Kmm
         qFwo/V60QxC7mdb+LRutRsKQYvr6kRrUc2mUXq+RLJe5o/lCYoUpdcVUCvY0oimXEz
         IIz4uA7Il+fvstgUp2DdamTBdmcSMa3tKyPGsu1zXRvRWugfkuUb6GvW+m9mwBxMrM
         /RE17VuzIPqZA==
Subject: [PATCH 5/6] xfs: check overlapping rmap btree records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:36 -0700
Message-ID: <166473483674.1084923.15327743282226942960.stgit@magnolia>
In-Reply-To: <166473483595.1084923.1946295148534639238.stgit@magnolia>
References: <166473483595.1084923.1946295148534639238.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The rmap btree scrubber doesn't contain sufficient checking for records
that cannot overlap but do anyway.  For the other btrees, this is
enforced by the inorder checks in xchk_btree_rec, but the rmap btree is
special because it allows overlapping records to handle shared data
extents.

Therefore, enhance the rmap btree record check function to compare each
record against the previous one so that we can detect overlapping rmap
records for space allocations that do not allow sharing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rmap.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index ba8d073b3954..efb13a21afbc 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -32,6 +32,15 @@ xchk_setup_ag_rmapbt(
 
 /* Reverse-mapping scrubber. */
 
+struct xchk_rmap {
+	/*
+	 * The furthest-reaching of the rmapbt records that we've already
+	 * processed.  This enables us to detect overlapping records for space
+	 * allocations that cannot be shared.
+	 */
+	struct xfs_rmap_irec	overlap_rec;
+};
+
 /* Cross-reference a rmap against the refcount btree. */
 STATIC void
 xchk_rmapbt_xref_refc(
@@ -87,6 +96,56 @@ xchk_rmapbt_xref(
 		xchk_rmapbt_xref_refc(sc, irec);
 }
 
+static inline bool
+xchk_rmapbt_is_shareable(
+	struct xfs_scrub		*sc,
+	const struct xfs_rmap_irec	*irec)
+{
+	if (!xfs_has_reflink(sc->mp))
+		return false;
+	if (XFS_RMAP_NON_INODE_OWNER(irec->rm_owner))
+		return false;
+	if (irec->rm_flags & (XFS_RMAP_BMBT_BLOCK | XFS_RMAP_ATTR_FORK |
+			      XFS_RMAP_UNWRITTEN))
+		return false;
+	return true;
+}
+
+/* Flag failures for records that overlap but cannot. */
+STATIC void
+xchk_rmapbt_check_overlapping(
+	struct xchk_btree		*bs,
+	struct xchk_rmap		*cr,
+	const struct xfs_rmap_irec	*irec)
+{
+	xfs_agblock_t			pnext, inext;
+
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	/* No previous record? */
+	if (cr->overlap_rec.rm_blockcount == 0)
+		goto set_prev;
+
+	/* Do overlap_rec and irec overlap? */
+	pnext = cr->overlap_rec.rm_startblock + cr->overlap_rec.rm_blockcount;
+	if (pnext <= irec->rm_startblock)
+		goto set_prev;
+
+	/* Overlap is only allowed if both records are data fork mappings. */
+	if (!xchk_rmapbt_is_shareable(bs->sc, &cr->overlap_rec) ||
+	    !xchk_rmapbt_is_shareable(bs->sc, irec))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	/* Save whichever rmap record extends furthest. */
+	inext = irec->rm_startblock + irec->rm_blockcount;
+	if (pnext > inext)
+		return;
+
+set_prev:
+	memcpy(&cr->overlap_rec, irec, sizeof(struct xfs_rmap_irec));
+}
+
 /* Scrub an rmapbt record. */
 STATIC int
 xchk_rmapbt_rec(
@@ -94,6 +153,7 @@ xchk_rmapbt_rec(
 	const union xfs_btree_rec *rec)
 {
 	struct xfs_mount	*mp = bs->cur->bc_mp;
+	struct xchk_rmap	*cr = bs->private;
 	struct xfs_rmap_irec	irec;
 	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
 	bool			non_inode;
@@ -158,6 +218,7 @@ xchk_rmapbt_rec(
 			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 	}
 
+	xchk_rmapbt_check_overlapping(bs, cr, &irec);
 	xchk_rmapbt_xref(bs->sc, &irec);
 out:
 	return error;
@@ -168,8 +229,17 @@ int
 xchk_rmapbt(
 	struct xfs_scrub	*sc)
 {
-	return xchk_btree(sc, sc->sa.rmap_cur, xchk_rmapbt_rec,
-			&XFS_RMAP_OINFO_AG, NULL);
+	struct xchk_rmap	*cr;
+	int			error;
+
+	cr = kzalloc(sizeof(struct xchk_rmap), XCHK_GFP_FLAGS);
+	if (!cr)
+		return -ENOMEM;
+
+	error = xchk_btree(sc, sc->sa.rmap_cur, xchk_rmapbt_rec,
+			&XFS_RMAP_OINFO_AG, cr);
+	kfree(cr);
+	return error;
 }
 
 /* xref check that the extent is owned only by a given owner */

