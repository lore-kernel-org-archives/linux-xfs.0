Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB0DC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbiL3WsA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiL3WsA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:48:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9D917890
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:47:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCB8361C0D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39817C433EF;
        Fri, 30 Dec 2022 22:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440478;
        bh=i+URIf5sYDaVNukGGM4wK7No/WOW++dSZ0zoP253mHI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Drnj7s8aawwzr1asw4z/fa+MnKLAwUBwDUCqtgmHKLVjVS2y6uVl2pIZL/0Pt06Ra
         7HdKraJoAeSSNUYFLWLXrlUGWqu9xupx9D784jcJzE2yj5wkhgNNBIP4ratNSQJWq2
         5H1Jv4XRTzweLM3ndgjkocnDM1zRQCYIF7xKqDijElPYRN0gW2TjxvLaQFhdjVRnS4
         AFbEFOuBVxnSXuHPMOHOVo+zf/wduKzk9IvDqYYxuVMUE2VSB43DYEJ2Oi+MX/gOSL
         R7Rrr/2oXObRJyrftsrDeJL1Cz4WtwQBY4nIsmwpiJewXPWLwlV1D5NAh1LkFRVsvP
         H6yLTuHUtFKvw==
Subject: [PATCH 5/6] xfs: check overlapping rmap btree records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:42 -0800
Message-ID: <167243830294.686829.15718124308935184728.stgit@magnolia>
In-Reply-To: <167243830218.686829.12866790282629472160.stgit@magnolia>
References: <167243830218.686829.12866790282629472160.stgit@magnolia>
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
index 7b0ad8f846ab..270c4f1e76c9 100644
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
@@ -139,12 +148,63 @@ xchk_rmapbt_check_unwritten_in_keyflags(
 	}
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
 	struct xchk_btree	*bs,
 	const union xfs_btree_rec *rec)
 {
+	struct xchk_rmap	*cr = bs->private;
 	struct xfs_rmap_irec	irec;
 
 	if (xfs_rmap_btrec_to_irec(rec, &irec) != NULL ||
@@ -154,6 +214,7 @@ xchk_rmapbt_rec(
 	}
 
 	xchk_rmapbt_check_unwritten_in_keyflags(bs);
+	xchk_rmapbt_check_overlapping(bs, cr, &irec);
 	xchk_rmapbt_xref(bs->sc, &irec);
 	return 0;
 }
@@ -163,8 +224,17 @@ int
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

