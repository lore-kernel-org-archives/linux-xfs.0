Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC7DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbiLaB6A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiLaB5z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:57:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78141C900
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:57:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4276D61C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFF3C433D2;
        Sat, 31 Dec 2022 01:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451873;
        bh=iXypW6LnMW1mE59fQwWyjPjmGl3EC+78XTk3T/SrAuE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PNRptMMyZUuNbOi2z1YKCzVCYSH9tPCeozxMnmmCtf+BTqF62iqO6vdKzGgBgSKt6
         DFRiQ/JU2ew3IRtf6TxLVrah2hQVDhnXa13TzfQy5c+RuCOCVogOv7GveSiNl2Znjz
         qPRZ1Ps1Tt9E8i2VzTREPFUTLXQUabylJ5q/zWPRX89GV/kbnctol57u4ChWagDF3D
         jGCSHYFLiE2EDjgAYP5Z1tDOFwWQIluveMphR/+onYOtj7NWjR1xrHhEy/NBtCuw/z
         caqI+1YKNjdOwwwMnyZ7WMtHhEG5/l6C0EaUiDl2I45nl1ymz2njlSqTd2ekkcDrZi
         IHFClQW1duP8w==
Subject: [PATCH 38/42] xfs: capture realtime CoW staging extents when
 rebuilding rt rmapbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:34 -0800
Message-ID: <167243871435.717073.14055309745166425902.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Walk the realtime refcount btree to find the CoW staging extents when
we're rebuilding the realtime rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bitmap.h        |   28 ++++++++++++
 fs/xfs/scrub/repair.h        |    1 
 fs/xfs/scrub/rtrmap_repair.c |  102 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+)


diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index d59d5e76782c..29faf2b63715 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -111,6 +111,34 @@ int xagb_bitmap_set_btblocks(struct xagb_bitmap *bitmap,
 int xagb_bitmap_set_btcur_path(struct xagb_bitmap *bitmap,
 		struct xfs_btree_cur *cur);
 
+/* Bitmaps, but for type-checked for xfs_rgblock_t */
+
+struct xrgb_bitmap {
+	struct xbitmap	rgbitmap;
+};
+
+static inline void xrgb_bitmap_init(struct xrgb_bitmap *bitmap)
+{
+	xbitmap_init(&bitmap->rgbitmap);
+}
+
+static inline void xrgb_bitmap_destroy(struct xrgb_bitmap *bitmap)
+{
+	xbitmap_destroy(&bitmap->rgbitmap);
+}
+
+static inline int xrgb_bitmap_set(struct xrgb_bitmap *bitmap,
+		xfs_rgblock_t start, xfs_extlen_t len)
+{
+	return xbitmap_set(&bitmap->rgbitmap, start, len);
+}
+
+static inline int xrgb_bitmap_walk(struct xrgb_bitmap *bitmap,
+		xbitmap_walk_fn fn, void *priv)
+{
+	return xbitmap_walk(&bitmap->rgbitmap, fn, priv);
+}
+
 /* Bitmaps, but for type-checked for xfs_fsblock_t */
 
 struct xfsb_bitmap {
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index ff8605849a72..4a0cedea3fe0 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -39,6 +39,7 @@ xrep_trans_commit(
 
 struct xbitmap;
 struct xagb_bitmap;
+struct xrgb_bitmap;
 struct xfsb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, int alloc_flags);
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index e26847784d21..36c03e48c3fb 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -29,6 +29,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_ag.h"
 #include "xfs_rtgroup.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -420,6 +421,100 @@ xrep_rtrmap_scan_ag(
 	return error;
 }
 
+struct xrep_rtrmap_stash_run {
+	struct xrep_rtrmap	*rr;
+	uint64_t		owner;
+};
+
+static int
+xrep_rtrmap_stash_run(
+	uint64_t			start,
+	uint64_t			len,
+	void				*priv)
+{
+	struct xrep_rtrmap_stash_run	*rsr = priv;
+	struct xrep_rtrmap		*rr = rsr->rr;
+	xfs_rgblock_t			rgbno = start;
+
+	return xrep_rtrmap_stash(rr, rgbno, len, rsr->owner, 0, 0);
+}
+
+/*
+ * Emit rmaps for every extent of bits set in the bitmap.  Caller must ensure
+ * that the ranges are in units of FS blocks.
+ */
+STATIC int
+xrep_rtrmap_stash_bitmap(
+	struct xrep_rtrmap		*rr,
+	struct xrgb_bitmap		*bitmap,
+	const struct xfs_owner_info	*oinfo)
+{
+	struct xrep_rtrmap_stash_run	rsr = {
+		.rr			= rr,
+		.owner			= oinfo->oi_owner,
+	};
+
+	return xrgb_bitmap_walk(bitmap, xrep_rtrmap_stash_run, &rsr);
+}
+
+/* Record a CoW staging extent. */
+STATIC int
+xrep_rtrmap_walk_cowblocks(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*irec,
+	void				*priv)
+{
+	struct xrgb_bitmap		*bitmap = priv;
+
+	if (!xfs_refcount_check_domain(irec) ||
+	    irec->rc_domain != XFS_REFC_DOMAIN_COW)
+		return -EFSCORRUPTED;
+
+	return xrgb_bitmap_set(bitmap, irec->rc_startblock,
+			irec->rc_blockcount);
+}
+
+/*
+ * Collect rmaps for the blocks containing the refcount btree, and all CoW
+ * staging extents.
+ */
+STATIC int
+xrep_rtrmap_find_refcount_rmaps(
+	struct xrep_rtrmap	*rr)
+{
+	struct xrgb_bitmap	cow_blocks;		/* COWBIT */
+	struct xfs_refcount_irec low = {
+		.rc_startblock	= 0,
+		.rc_domain	= XFS_REFC_DOMAIN_COW,
+	};
+	struct xfs_refcount_irec high = {
+		.rc_startblock	= -1U,
+		.rc_domain	= XFS_REFC_DOMAIN_COW,
+	};
+	struct xfs_scrub	*sc = rr->sc;
+	int			error;
+
+	if (!xfs_has_rtreflink(sc->mp))
+		return 0;
+
+	xrgb_bitmap_init(&cow_blocks);
+
+	/* Collect rmaps for CoW staging extents. */
+	error = xfs_refcount_query_range(sc->sr.refc_cur, &low, &high,
+			xrep_rtrmap_walk_cowblocks, &cow_blocks);
+	if (error)
+		goto out_bitmap;
+
+	/* Generate rmaps for everything. */
+	error = xrep_rtrmap_stash_bitmap(rr, &cow_blocks, &XFS_RMAP_OINFO_COW);
+	if (error)
+		goto out_bitmap;
+
+out_bitmap:
+	xrgb_bitmap_destroy(&cow_blocks);
+	return error;
+}
+
 /* Count and check all collected records. */
 STATIC int
 xrep_rtrmap_check_record(
@@ -467,6 +562,13 @@ xrep_rtrmap_find_rmaps(
 	if (error)
 		return error;
 
+	/* Find CoW staging extents. */
+	xrep_rtgroup_btcur_init(sc, &sc->sr);
+	error = xrep_rtrmap_find_refcount_rmaps(rr);
+	xchk_rtgroup_btcur_free(&sc->sr);
+	if (error)
+		return error;
+
 	/*
 	 * Set up for a potentially lengthy filesystem scan by reducing our
 	 * transaction resource usage for the duration.  Specifically:

