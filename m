Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AD4C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiJBSiq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiJBSip (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:38:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B09F3C8D2
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09C63B80D82
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAC6C433D6;
        Sun,  2 Oct 2022 18:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735921;
        bh=StMDwb6dLhuFQ6CFy08d1Co9X14TVuunYWMjRPC8nuI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MSVirBG3Rwo+BZ8m9zs08G7shIvPwn1IEm1aJk2NSEMd8u8Q9sRhSdZEhgBJ6QTaG
         hRUL6E7y2FnUj5xTsbw0h/lNq5oymApPNIyafJ0loqtxRrHuOQDWP8gMokNoto+B/i
         UlECutUJJWuGDjAnQ/jYfGA5z+4ewH0a4O18FRxBweDTmuxn2qpx4wbIJq51u40eL0
         CKj9ou0ySEStF3lcpvN0NUKdCuPeKqwPEF+oCOhK+ghdx9YqoM5vo/CvsY1Z9MdJMv
         Q2kgns0yWbR+vqmnUQQjAcOI2oRDXd04nR9AAPYEOO6C8nrxX3DDdeSq+FEMhoYLlK
         +MCWhFMtuehQQ==
Subject: [PATCH 1/4] xfs: cross-reference rmap records with ag btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:47 -0700
Message-ID: <166473484765.1085478.3476578174251483790.stgit@magnolia>
In-Reply-To: <166473484745.1085478.8596810118667983511.stgit@magnolia>
References: <166473484745.1085478.8596810118667983511.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Strengthen the rmap btree record checker a little more by comparing
OWN_FS and OWN_LOG reverse mappings against the AG headers and internal
logs, respectively.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile       |    2 -
 fs/xfs/scrub/bitmap.c |   22 +++++++
 fs/xfs/scrub/bitmap.h |    1 
 fs/xfs/scrub/rmap.c   |  160 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 183 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 03135a1c31b6..7b54cdbe8c9c 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -145,6 +145,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   agheader.o \
 				   alloc.o \
 				   attr.o \
+				   bitmap.o \
 				   bmap.o \
 				   btree.o \
 				   common.o \
@@ -168,7 +169,6 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
-				   bitmap.o \
 				   repair.o \
 				   )
 endif
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 1b04d2ce020a..14caff0a28ce 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -396,3 +396,25 @@ xbitmap_empty(
 {
 	return bitmap->xb_root.rb_root.rb_node == NULL;
 }
+
+/* Is the start of the range set or clear?  And for how long? */
+bool
+xbitmap_test(
+	struct xbitmap		*bitmap,
+	uint64_t		start,
+	uint64_t		*len)
+{
+	struct xbitmap_node	*bn;
+	uint64_t		last = start + *len - 1;
+
+	bn = xbitmap_tree_iter_first(&bitmap->xb_root, start, last);
+	if (!bn)
+		return false;
+	if (bn->bn_start <= start) {
+		if (bn->bn_last < last)
+			*len = bn->bn_last - start + 1;
+		return true;
+	}
+	*len = bn->bn_start - start;
+	return false;
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 7afd64a318d1..2da3d6b87565 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -38,5 +38,6 @@ int xbitmap_walk_bits(struct xbitmap *bitmap, xbitmap_walk_bits_fn fn,
 		void *priv);
 
 bool xbitmap_empty(struct xbitmap *bitmap);
+bool xbitmap_test(struct xbitmap *bitmap, uint64_t start, uint64_t *len);
 
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 76ac2279e37d..8205086aac49 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -12,10 +12,12 @@
 #include "xfs_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
+#include "xfs_ag.h"
+#include "xfs_bit.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
-#include "xfs_ag.h"
+#include "scrub/bitmap.h"
 
 /*
  * Set us up to scrub reverse mapping btrees.
@@ -45,6 +47,13 @@ struct xchk_rmap {
 	 * that could be one.
 	 */
 	struct xfs_rmap_irec	prev_rec;
+
+	/* Bitmaps containing all blocks for each type of AG metadata. */
+	struct xbitmap		fs_owned;
+	struct xbitmap		log_owned;
+
+	/* Did we complete the AG space metadata bitmaps? */
+	bool			bitmaps_complete;
 };
 
 /* Cross-reference a rmap against the refcount btree. */
@@ -197,6 +206,68 @@ xchk_rmapbt_check_mergeable(
 	memcpy(&cr->prev_rec, irec, sizeof(struct xfs_rmap_irec));
 }
 
+/* Compare an rmap for AG metadata against the metadata walk. */
+STATIC int
+xchk_rmapbt_mark_bitmap(
+	struct xchk_btree		*bs,
+	struct xchk_rmap		*cr,
+	const struct xfs_rmap_irec	*irec)
+{
+	struct xfs_scrub		*sc = bs->sc;
+	struct xbitmap			*bmp = NULL;
+	uint64_t			fsbcount = irec->rm_blockcount;
+
+	/*
+	 * Skip corrupt records.  It is essential that we detect records in the
+	 * btree that cannot overlap but do, flag those as CORRUPT, and skip
+	 * the bitmap comparison to avoid generating false XCORRUPT reports.
+	 */
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return 0;
+
+	/*
+	 * If the AG metadata walk didn't complete, there's no point in
+	 * comparing against partial results.
+	 */
+	if (!cr->bitmaps_complete)
+		return 0;
+
+	switch (irec->rm_owner) {
+	case XFS_RMAP_OWN_FS:
+		bmp = &cr->fs_owned;
+		break;
+	case XFS_RMAP_OWN_LOG:
+		bmp = &cr->log_owned;
+		break;
+	}
+
+	if (!bmp)
+		return 0;
+
+	if (xbitmap_test(bmp, irec->rm_startblock, &fsbcount)) {
+		/*
+		 * The start of this reverse mapping corresponds to a set
+		 * region in the bitmap.  If the mapping covers more area than
+		 * the set region, then it covers space that wasn't found by
+		 * the AG metadata walk.
+		 */
+		if (fsbcount < irec->rm_blockcount)
+			xchk_btree_xref_set_corrupt(bs->sc,
+					bs->sc->sa.rmap_cur, 0);
+	} else {
+		/*
+		 * The start of this reverse mapping does not correspond to a
+		 * completely set region in the bitmap.  The region wasn't
+		 * fully set by walking the AG metadata, so this is a
+		 * cross-referencing corruption.
+		 */
+		xchk_btree_xref_set_corrupt(bs->sc, bs->sc->sa.rmap_cur, 0);
+	}
+
+	/* Unset the region so that we can detect missing rmap records. */
+	return xbitmap_clear(bmp, irec->rm_startblock, irec->rm_blockcount);
+}
+
 /* Scrub an rmapbt record. */
 STATIC int
 xchk_rmapbt_rec(
@@ -272,10 +343,82 @@ xchk_rmapbt_rec(
 	xchk_rmapbt_check_mergeable(bs, cr, &irec);
 	xchk_rmapbt_check_overlapping(bs, cr, &irec);
 	xchk_rmapbt_xref(bs->sc, &irec);
+
+	error = xchk_rmapbt_mark_bitmap(bs, cr, &irec);
 out:
 	return error;
 }
 
+/*
+ * Set up bitmaps mapping all the AG metadata to compare with the rmapbt
+ * records.
+ */
+STATIC int
+xchk_rmapbt_walk_ag_metadata(
+	struct xfs_scrub	*sc,
+	struct xchk_rmap	*cr)
+{
+	struct xfs_mount	*mp = sc->mp;
+	int			error;
+
+	/* OWN_FS: AG headers */
+	error = xbitmap_set(&cr->fs_owned, XFS_SB_BLOCK(mp),
+			XFS_AGFL_BLOCK(mp) - XFS_SB_BLOCK(mp) + 1);
+	if (error)
+		goto out;
+
+	/* OWN_LOG: Internal log */
+	if (xfs_ag_contains_log(mp, sc->sa.pag->pag_agno)) {
+		error = xbitmap_set(&cr->log_owned,
+				XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart),
+				mp->m_sb.sb_logblocks);
+		if (error)
+			goto out;
+	}
+
+out:
+	/*
+	 * If there's an error, set XFAIL and disable the bitmap
+	 * cross-referencing checks, but proceed with the scrub anyway.
+	 */
+	if (error)
+		xchk_btree_xref_process_error(sc, sc->sa.rmap_cur,
+				sc->sa.rmap_cur->bc_nlevels - 1, &error);
+	else
+		cr->bitmaps_complete = true;
+	return 0;
+}
+
+/*
+ * Check for set regions in the bitmaps; if there are any, the rmap records do
+ * not describe all the AG metadata.
+ */
+STATIC void
+xchk_rmapbt_check_bitmaps(
+	struct xfs_scrub	*sc,
+	struct xchk_rmap	*cr)
+{
+	struct xfs_btree_cur	*cur = sc->sa.rmap_cur;
+	unsigned int		level;
+
+	if (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				XFS_SCRUB_OFLAG_XFAIL))
+		return;
+	if (!cur)
+		return;
+	level = cur->bc_nlevels - 1;
+
+	/*
+	 * Any bitmap with bits still set indicates that the reverse mapping
+	 * doesn't cover the entire primary structure.
+	 */
+	if (xbitmap_hweight(&cr->fs_owned) != 0)
+		xchk_btree_xref_set_corrupt(sc, cur, level);
+
+	if (xbitmap_hweight(&cr->log_owned) != 0)
+		xchk_btree_xref_set_corrupt(sc, cur, level);
+}
+
 /* Scrub the rmap btree for some AG. */
 int
 xchk_rmapbt(
@@ -288,8 +431,23 @@ xchk_rmapbt(
 	if (!cr)
 		return -ENOMEM;
 
+	xbitmap_init(&cr->fs_owned);
+	xbitmap_init(&cr->log_owned);
+
+	error = xchk_rmapbt_walk_ag_metadata(sc, cr);
+	if (error)
+		goto out;
+
 	error = xchk_btree(sc, sc->sa.rmap_cur, xchk_rmapbt_rec,
 			&XFS_RMAP_OINFO_AG, cr);
+	if (error)
+		goto out;
+
+	xchk_rmapbt_check_bitmaps(sc, cr);
+
+out:
+	xbitmap_destroy(&cr->log_owned);
+	xbitmap_destroy(&cr->fs_owned);
 	kfree(cr);
 	return error;
 }

