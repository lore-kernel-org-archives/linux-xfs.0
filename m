Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B9DC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbiL3Ww1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiL3Ww0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:52:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436B01AA0F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:52:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8F07B81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94981C433EF;
        Fri, 30 Dec 2022 22:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440742;
        bh=iP9n19aRbZUU1tHEqr/eWuGOQIT5dN59cvVjSFV70/o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e5A9O/Gzj6LKQ1V5w2x8LXv+dk+RkOI9gpgv6MjoI85z118OxdWqQza3Cy1T3oIJE
         KNEEnXZp9OdOOA0F0MyEIEDnsWEJP8YsnxH0JGyLp7WduReYNsYO8vZcknDriJJq9Q
         utkQOvUL0HT/X2dq9N3Pxg/Qkl3w3fnVbEGnvvZ8/o/54t0Qs1cGgYuwciwZzg0ktM
         AW91dgB/0z2oiPA/6WIMmWvS1Rw4NirxhFlfA8eWv5sWHJXWeNgsyDb2xtypoqgmNS
         51Q8LtojCr3Jb0vgZOsC68VS33vxKErnbmj7daT2DDRZgNA5sjaa8yyliJBHJ1aeXX
         VNWPRdTSuFmVQ==
Subject: [PATCH 2/5] xfs: cross-reference rmap records with ag btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:54 -0800
Message-ID: <167243831403.687445.17583741832521258699.stgit@magnolia>
In-Reply-To: <167243831370.687445.933956691451974089.stgit@magnolia>
References: <167243831370.687445.933956691451974089.stgit@magnolia>
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
 fs/xfs/scrub/bitmap.h |   19 ++++++
 fs/xfs/scrub/rmap.c   |  159 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 200 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ea0725cfb6fb..0b8dfac6d9a3 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -147,6 +147,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   agheader.o \
 				   alloc.o \
 				   attr.o \
+				   bitmap.o \
 				   bmap.o \
 				   btree.o \
 				   common.o \
@@ -170,7 +171,6 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
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
index 7f538effc196..65a6c5a92c7a 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -38,6 +38,7 @@ int xbitmap_walk_bits(struct xbitmap *bitmap, xbitmap_walk_bits_fn fn,
 		void *priv);
 
 bool xbitmap_empty(struct xbitmap *bitmap);
+bool xbitmap_test(struct xbitmap *bitmap, uint64_t start, uint64_t *len);
 
 /* Bitmaps, but for type-checked for xfs_agblock_t */
 
@@ -65,6 +66,24 @@ static inline int xagb_bitmap_set(struct xagb_bitmap *bitmap,
 {
 	return xbitmap_set(&bitmap->agbitmap, start, len);
 }
+static inline bool xagb_bitmap_test(struct xagb_bitmap *bitmap,
+		xfs_agblock_t start, xfs_extlen_t *len)
+{
+	uint64_t	biglen = *len;
+	int		error;
+
+	error = xbitmap_test(&bitmap->agbitmap, start, &biglen);
+	if (error)
+		return error;
+
+	if (biglen >= UINT_MAX) {
+		ASSERT(0);
+		return -EOVERFLOW;
+	}
+
+	*len = biglen;
+	return 0;
+}
 
 static inline int xagb_bitmap_disunion(struct xagb_bitmap *bitmap,
 		struct xagb_bitmap *sub)
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 3cb92f7ac165..415d8e9918da 100644
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
+	struct xagb_bitmap	fs_owned;
+	struct xagb_bitmap	log_owned;
+
+	/* Did we complete the AG space metadata bitmaps? */
+	bool			bitmaps_complete;
 };
 
 /* Cross-reference a rmap against the refcount btree. */
@@ -249,6 +258,68 @@ xchk_rmapbt_check_mergeable(
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
+	struct xagb_bitmap		*bmp = NULL;
+	xfs_extlen_t			fsbcount = irec->rm_blockcount;
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
+	if (xagb_bitmap_test(bmp, irec->rm_startblock, &fsbcount)) {
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
+	return xagb_bitmap_clear(bmp, irec->rm_startblock, irec->rm_blockcount);
+}
+
 /* Scrub an rmapbt record. */
 STATIC int
 xchk_rmapbt_rec(
@@ -268,9 +339,80 @@ xchk_rmapbt_rec(
 	xchk_rmapbt_check_mergeable(bs, cr, &irec);
 	xchk_rmapbt_check_overlapping(bs, cr, &irec);
 	xchk_rmapbt_xref(bs->sc, &irec);
+
+	return xchk_rmapbt_mark_bitmap(bs, cr, &irec);
+}
+
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
+	error = xagb_bitmap_set(&cr->fs_owned, XFS_SB_BLOCK(mp),
+			XFS_AGFL_BLOCK(mp) - XFS_SB_BLOCK(mp) + 1);
+	if (error)
+		goto out;
+
+	/* OWN_LOG: Internal log */
+	if (xfs_ag_contains_log(mp, sc->sa.pag->pag_agno)) {
+		error = xagb_bitmap_set(&cr->log_owned,
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
 	return 0;
 }
 
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
+	if (xagb_bitmap_hweight(&cr->fs_owned) != 0)
+		xchk_btree_xref_set_corrupt(sc, cur, level);
+
+	if (xagb_bitmap_hweight(&cr->log_owned) != 0)
+		xchk_btree_xref_set_corrupt(sc, cur, level);
+}
+
 /* Scrub the rmap btree for some AG. */
 int
 xchk_rmapbt(
@@ -283,8 +425,23 @@ xchk_rmapbt(
 	if (!cr)
 		return -ENOMEM;
 
+	xagb_bitmap_init(&cr->fs_owned);
+	xagb_bitmap_init(&cr->log_owned);
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
+	xagb_bitmap_destroy(&cr->log_owned);
+	xagb_bitmap_destroy(&cr->fs_owned);
 	kfree(cr);
 	return error;
 }

