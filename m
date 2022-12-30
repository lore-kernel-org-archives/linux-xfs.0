Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0E5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbiLaB6n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbiLaB6n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:58:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFF51C900
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:58:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEF4361C5B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4B8C433EF;
        Sat, 31 Dec 2022 01:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451920;
        bh=u108L5Hf7YJiJdLSMrc7QIzC9x6KpwVqwyBKYqlyrA8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=csFoMq+FLxxklGXPa6Lcetx7ujroi753qSG0UBPprW5uX/A5TYfR2JqYP2XSBmhND
         6dsorqFRMi4XSrprJ9g84uhNJ4P83Bd5vvPf5zo4hexTlxluQphqWAbhGl2ybetf6B
         zyD7Hma5QRujZ1iPKBw6qKMsO4nGNC4yLGP0M5FtbsZT0knnWYTBW9KwAZ/ERZYB3L
         /lBSb39CnXJhHwIYPa+SQzIO0r6OjjsKO5F30NipnIVgobVbsTr+kWjI0hBNnTN5gx
         34MB+R5IB1+QJqKGQ6/WRlG1RgQILWUpPeHGgNDtUC65NQUira+2gnNzUC7vJV5IOq
         jSSw5k/EDXvdw==
Subject: [PATCH 41/42] xfs: fix cow forks for realtime files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:34 -0800
Message-ID: <167243871478.717073.12651516252296016150.stgit@magnolia>
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

Port the CoW fork repair to realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bitmap.h     |   28 ++++++
 fs/xfs/scrub/cow_repair.c |  210 ++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/reap.c       |  219 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/reap.h       |    7 +
 fs/xfs/scrub/repair.h     |    1 
 fs/xfs/scrub/trace.h      |   72 +++++++++++++++
 6 files changed, 520 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 29faf2b63715..7541b5fd68f8 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -167,4 +167,32 @@ static inline int xfsb_bitmap_walk(struct xfsb_bitmap *bitmap,
 	return xbitmap_walk(&bitmap->fsbitmap, fn, priv);
 }
 
+/* Bitmaps, but for type-checked for xfs_rtblock_t */
+
+struct xrtb_bitmap {
+	struct xbitmap	rtbitmap;
+};
+
+static inline void xrtb_bitmap_init(struct xrtb_bitmap *bitmap)
+{
+	xbitmap_init(&bitmap->rtbitmap);
+}
+
+static inline void xrtb_bitmap_destroy(struct xrtb_bitmap *bitmap)
+{
+	xbitmap_destroy(&bitmap->rtbitmap);
+}
+
+static inline int xrtb_bitmap_set(struct xrtb_bitmap *bitmap,
+		xfs_rtblock_t start, xfs_filblks_t len)
+{
+	return xbitmap_set(&bitmap->rtbitmap, start, len);
+}
+
+static inline int xrtb_bitmap_walk(struct xrtb_bitmap *bitmap,
+		xbitmap_walk_fn fn, void *priv)
+{
+	return xbitmap_walk(&bitmap->rtbitmap, fn, priv);
+}
+
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index a0c1d97ab8b6..5605c4ecbdca 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -26,6 +26,9 @@
 #include "xfs_errortag.h"
 #include "xfs_icache.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -59,7 +62,10 @@ struct xrep_cow {
 	struct xbitmap		bad_fileoffs;
 
 	/* Bitmap of fsblocks that were removed from the CoW fork. */
-	struct xfsb_bitmap	old_cowfork_fsblocks;
+	union {
+		struct xfsb_bitmap	old_cowfork_fsblocks;
+		struct xrtb_bitmap	old_cowfork_rtblocks;
+	};
 
 	/* CoW fork mappings used to scan for bad CoW staging extents. */
 	struct xfs_bmbt_irec	irec;
@@ -137,8 +143,12 @@ xrep_cow_mark_shared_staging(
 
 	xrep_cow_trim_refcount(xc, &rrec, rec);
 
-	fsbno = XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno,
-			rrec.rc_startblock);
+	if (XFS_IS_REALTIME_INODE(xc->sc->ip))
+		fsbno = xfs_rgbno_to_rtb(xc->sc->mp, cur->bc_ino.rtg->rtg_rgno,
+				rrec.rc_startblock);
+	else
+		fsbno = XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno,
+				rrec.rc_startblock);
 	return xrep_cow_mark_file_range(xc, fsbno, rrec.rc_blockcount);
 }
 
@@ -158,6 +168,7 @@ xrep_cow_mark_missing_staging(
 {
 	struct xrep_cow			*xc = priv;
 	struct xfs_refcount_irec	rrec;
+	xfs_fsblock_t			fsbno;
 	int				error;
 
 	if (!xfs_refcount_check_domain(rec) ||
@@ -169,9 +180,13 @@ xrep_cow_mark_missing_staging(
 	if (xc->next_bno >= rrec.rc_startblock)
 		goto next;
 
-	error = xrep_cow_mark_file_range(xc,
-			XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno,
-				       xc->next_bno),
+	if (XFS_IS_REALTIME_INODE(xc->sc->ip))
+		fsbno = xfs_rgbno_to_rtb(xc->sc->mp, cur->bc_ino.rtg->rtg_rgno,
+				xc->next_bno);
+	else
+		fsbno = XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno,
+				xc->next_bno);
+	error = xrep_cow_mark_file_range(xc, fsbno,
 			rrec.rc_startblock - xc->next_bno);
 	if (error)
 		return error;
@@ -214,7 +229,12 @@ xrep_cow_mark_missing_staging_rmap(
 		rec_len -= adj;
 	}
 
-	fsbno = XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno, rec_bno);
+	if (XFS_IS_REALTIME_INODE(xc->sc->ip))
+		fsbno = xfs_rgbno_to_rtb(xc->sc->mp, cur->bc_ino.rtg->rtg_rgno,
+				rec_bno);
+	else
+		fsbno = XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno,
+				rec_bno);
 	return xrep_cow_mark_file_range(xc, fsbno, rec_len);
 }
 
@@ -303,6 +323,99 @@ xrep_cow_find_bad(
 	return 0;
 }
 
+/*
+ * Find any part of the CoW fork mapping that isn't a single-owner CoW staging
+ * extent and mark the corresponding part of the file range in the bitmap.
+ */
+STATIC int
+xrep_cow_find_bad_rt(
+	struct xrep_cow			*xc)
+{
+	struct xfs_refcount_irec	rc_low = { 0 };
+	struct xfs_refcount_irec	rc_high = { 0 };
+	struct xfs_rmap_irec		rm_low = { 0 };
+	struct xfs_rmap_irec		rm_high = { 0 };
+	struct xfs_scrub		*sc = xc->sc;
+	struct xfs_rtgroup		*rtg;
+	xfs_rgnumber_t			rgno;
+	int				error = 0;
+
+	xc->irec_startbno = xfs_rtb_to_rgbno(sc->mp, xc->irec.br_startblock,
+						&rgno);
+
+	rtg = xfs_rtgroup_get(sc->mp, rgno);
+	if (!rtg)
+		return -EFSCORRUPTED;
+
+	if (xrep_is_rtmeta_ino(sc, rtg, sc->ip->i_ino)) {
+		xfs_rtgroup_put(rtg);
+		goto out_rtg;
+	}
+
+	error = xrep_rtgroup_init(sc, rtg, &sc->sr,
+			XFS_RTGLOCK_RMAP | XFS_RTGLOCK_REFCOUNT);
+	if (error)
+		goto out_rtg;
+
+	/* Mark any CoW fork extents that are shared. */
+	rc_low.rc_startblock = xc->irec_startbno;
+	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_SHARED;
+	error = xfs_refcount_query_range(sc->sr.refc_cur, &rc_low, &rc_high,
+			xrep_cow_mark_shared_staging, xc);
+	if (error)
+		goto out_sr;
+
+	/* Make sure there are CoW staging extents for the whole mapping. */
+	rc_low.rc_startblock = xc->irec_startbno;
+	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_COW;
+	xc->next_bno = xc->irec_startbno;
+	error = xfs_refcount_query_range(sc->sr.refc_cur, &rc_low, &rc_high,
+			xrep_cow_mark_missing_staging, xc);
+	if (error)
+		goto out_sr;
+
+	if (xc->next_bno < xc->irec_startbno + xc->irec.br_blockcount) {
+		error = xrep_cow_mark_file_range(xc,
+				xfs_rgbno_to_rtb(sc->mp, rtg->rtg_rgno,
+						 xc->next_bno),
+				xc->irec_startbno + xc->irec.br_blockcount -
+				xc->next_bno);
+		if (error)
+			goto out_sr;
+	}
+
+	/* Mark any area has an rmap that isn't a COW staging extent. */
+	rm_low.rm_startblock = xc->irec_startbno;
+	memset(&rm_high, 0xFF, sizeof(rm_high));
+	rm_high.rm_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	error = xfs_rmap_query_range(sc->sr.rmap_cur, &rm_low, &rm_high,
+			xrep_cow_mark_missing_staging_rmap, xc);
+	if (error)
+		goto out_sr;
+
+	/*
+	 * If userspace is forcing us to rebuild the CoW fork or someone
+	 * turned on the debugging knob, replace everything in the
+	 * CoW fork and then scan for staging extents in the refcountbt.
+	 */
+	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
+	    XFS_TEST_ERROR(false, sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
+		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
+				xc->irec.br_blockcount);
+		if (error)
+			goto out_rtg;
+	}
+
+out_sr:
+	xchk_rtgroup_btcur_free(&sc->sr);
+	xchk_rtgroup_free(sc, &sc->sr);
+out_rtg:
+	xfs_rtgroup_put(rtg);
+	return error;
+}
+
 /*
  * Allocate a replacement CoW staging extent of up to the given number of
  * blocks, and fill out the mapping.  The caller must set irec->br_blockcount.
@@ -343,6 +456,45 @@ xrep_cow_alloc(
 	return 0;
 }
 
+/*
+ * Allocate a replacement rt CoW staging extent of up to the given number of
+ * blocks, and fill out the mapping.  The caller must set irec->br_blockcount.
+ */
+STATIC int
+xrep_cow_alloc_rt(
+	struct xfs_scrub	*sc,
+	struct xfs_bmbt_irec	*irec)
+{
+	xfs_rtxnum_t		rtx = NULLRTEXTNO;
+	xfs_rtxlen_t		rtxlen = 0;
+	xfs_rtblock_t		rtbno;
+	xfs_extlen_t		len;
+	int			error;
+
+	ASSERT(sc->mp->m_sb.sb_rextsize == 1);
+
+	error = xfs_trans_reserve_more(sc->tp, 0, irec->br_blockcount);
+	if (error)
+		return error;
+
+	xfs_rtbitmap_lock(sc->tp, sc->mp);
+
+	error = xfs_rtallocate_extent(sc->tp, 0, 1, irec->br_blockcount,
+			&rtxlen, 0, 1, &rtx);
+	if (error)
+		return error;
+	if (rtx == NULLRTEXTNO)
+		return -ENOSPC;
+
+	rtbno = xfs_rtx_to_rtb(sc->mp, rtx);
+	len = xfs_rtxlen_to_extlen(sc->mp, rtxlen);
+	xfs_refcount_alloc_cow_extent(sc->tp, true, rtbno, len);
+
+	irec->br_startblock = rtbno;
+	irec->br_blockcount = len;
+	return 0;
+}
+
 /*
  * Look up the current CoW fork mapping so that we only allocate enough to
  * replace a single mapping.  If we don't find a mapping that covers the start
@@ -514,7 +666,10 @@ xrep_cow_replace_one(
 	 * Allocate a replacement extent.  If we don't fill all the blocks,
 	 * shorten the quantity that will be deleted in this step.
 	 */
-	error = xrep_cow_alloc(sc, &rep);
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		error = xrep_cow_alloc_rt(sc, &rep);
+	else
+		error = xrep_cow_alloc(sc, &rep);
 	if (error)
 		return error;
 
@@ -531,8 +686,12 @@ xrep_cow_replace_one(
 		return error;
 
 	/* Note the old CoW staging extents; we'll reap them all later. */
-	error = xfsb_bitmap_set(&xc->old_cowfork_fsblocks, old_startblock,
-			rep.br_blockcount);
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		error = xrtb_bitmap_set(&xc->old_cowfork_rtblocks,
+				old_startblock, rep.br_blockcount);
+	else
+		error = xfsb_bitmap_set(&xc->old_cowfork_fsblocks,
+				old_startblock, rep.br_blockcount);
 	if (error)
 		return error;
 
@@ -588,8 +747,12 @@ xrep_bmap_cow(
 	if (!ifp)
 		return 0;
 
-	/* realtime files aren't supported yet */
-	if (XFS_IS_REALTIME_INODE(sc->ip))
+	/*
+	 * Realtime files with large extent sizes are not supported because
+	 * we could encounter an CoW mapping that has been partially written
+	 * out *and* requires replacement, and there's no solution to that.
+	 */
+	if (XFS_IS_REALTIME_INODE(sc->ip) && sc->mp->m_sb.sb_rextsize != 1)
 		return -EOPNOTSUPP;
 
 	/*
@@ -610,7 +773,10 @@ xrep_bmap_cow(
 
 	xc->sc = sc;
 	xbitmap_init(&xc->bad_fileoffs);
-	xfsb_bitmap_init(&xc->old_cowfork_fsblocks);
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		xrtb_bitmap_init(&xc->old_cowfork_rtblocks);
+	else
+		xfsb_bitmap_init(&xc->old_cowfork_fsblocks);
 
 	for_each_xfs_iext(ifp, &icur, &xc->irec) {
 		if (xchk_should_terminate(sc, &error))
@@ -633,7 +799,10 @@ xrep_bmap_cow(
 		if (xfs_bmap_is_written_extent(&xc->irec))
 			continue;
 
-		error = xrep_cow_find_bad(xc);
+		if (XFS_IS_REALTIME_INODE(sc->ip))
+			error = xrep_cow_find_bad_rt(xc);
+		else
+			error = xrep_cow_find_bad(xc);
 		if (error)
 			goto out_bitmap;
 	}
@@ -648,13 +817,20 @@ xrep_bmap_cow(
 	 * by the refcount btree, not the inode, so it is correct to treat them
 	 * like inode metadata.
 	 */
-	error = xrep_reap_fsblocks(sc, &xc->old_cowfork_fsblocks,
-			&XFS_RMAP_OINFO_COW, XFS_AG_RESV_NONE);
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		error = xrep_reap_rtblocks(sc, &xc->old_cowfork_rtblocks,
+				&XFS_RMAP_OINFO_COW);
+	else
+		error = xrep_reap_fsblocks(sc, &xc->old_cowfork_fsblocks,
+				&XFS_RMAP_OINFO_COW, XFS_AG_RESV_NONE);
 	if (error)
 		goto out_bitmap;
 
 out_bitmap:
-	xfsb_bitmap_destroy(&xc->old_cowfork_fsblocks);
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		xrtb_bitmap_destroy(&xc->old_cowfork_rtblocks);
+	else
+		xfsb_bitmap_destroy(&xc->old_cowfork_fsblocks);
 	xbitmap_destroy(&xc->bad_fileoffs);
 	kmem_free(xc);
 	return error;
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 77354bdb0511..b5b5963f6d99 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -33,6 +33,8 @@
 #include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_defer.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -676,6 +678,223 @@ xrep_reap_fsblocks(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_RT
+/* Dispose of a single rtgroup extent. */
+STATIC int
+xreap_rgextent(
+	struct xreap_state	*rs,
+	xfs_rgblock_t		rgbno,
+	xfs_extlen_t		*rglenp,
+	bool			crosslinked)
+{
+	struct xfs_scrub	*sc = rs->sc;
+	xfs_rtblock_t		rtbno;
+
+	/*
+	 * The only caller so far is CoW fork repair, so we only know how to
+	 * unlink or free CoW staging extents.
+	 */
+	if (rs->oinfo != &XFS_RMAP_OINFO_COW) {
+		ASSERT(rs->oinfo == &XFS_RMAP_OINFO_COW);
+		return -EFSCORRUPTED;
+	}
+	ASSERT(rs->resv == XFS_AG_RESV_NONE);
+
+	rtbno = xfs_rgbno_to_rtb(sc->mp, sc->sr.rtg->rtg_rgno, rgbno);
+
+	/*
+	 * If there are other rmappings, this block is cross linked and must
+	 * not be freed.  Remove the forward and reverse mapping and move on.
+	 *
+	 * XXX: XFS doesn't support detecting the case where a single block
+	 * metadata structure is crosslinked with a multi-block structure
+	 * because the buffer cache doesn't detect aliasing problems, so we
+	 * can't fix 100% of crosslinking problems (yet).  The verifiers will
+	 * blow on writeout, the filesystem will shut down, and the admin gets
+	 * to run xfs_repair.
+	 */
+	if (crosslinked) {
+		trace_xreap_dispose_unmap_rtextent(sc->sr.rtg, rgbno, *rglenp);
+
+		xfs_refcount_free_cow_extent(sc->tp, true, rtbno, *rglenp);
+		rs->deferred++;
+		return 0;
+	}
+
+	trace_xreap_dispose_free_rtextent(sc->sr.rtg, rgbno, *rglenp);
+
+	/*
+	 * The CoW staging extent is not crosslinked.  Use deferred work items
+	 * to remove the refcountbt records (which removes the rmap records)
+	 * and free the extent.  We're not worried about the system going down
+	 * here because log recovery walks the refcount btree to clean out the
+	 * CoW staging extents.
+	 */
+	xfs_refcount_free_cow_extent(sc->tp, true, rtbno, *rglenp);
+	xfs_free_extent_later(sc->tp, rtbno, *rglenp, NULL,
+			XFS_FREE_EXTENT_REALTIME |
+			XFS_FREE_EXTENT_SKIP_DISCARD);
+	rs->deferred++;
+	return 0;
+}
+
+/*
+ * Figure out the longest run of blocks that we can dispose of with a single
+ * call.  Cross-linked blocks should have their reverse mappings removed, but
+ * single-owner extents can be freed.  Units are rt blocks, not rt extents.
+ */
+STATIC int
+xreap_rgextent_select(
+	struct xreap_state	*rs,
+	xfs_rgblock_t		rgbno,
+	xfs_rgblock_t		rgbno_next,
+	bool			*crosslinked,
+	xfs_extlen_t		*rglenp)
+{
+	struct xfs_scrub	*sc = rs->sc;
+	struct xfs_btree_cur	*cur;
+	xfs_rgblock_t		bno = rgbno + 1;
+	xfs_extlen_t		len = 1;
+	int			error;
+
+	/*
+	 * Determine if there are any other rmap records covering the first
+	 * block of this extent.  If so, the block is crosslinked.
+	 */
+	cur = xfs_rtrmapbt_init_cursor(sc->mp, sc->tp, sc->sr.rtg,
+			sc->sr.rtg->rtg_rmapip);
+	error = xfs_rmap_has_other_keys(cur, rgbno, 1, rs->oinfo,
+			crosslinked);
+	if (error)
+		goto out_cur;
+
+	/*
+	 * Figure out how many of the subsequent blocks have the same crosslink
+	 * status.
+	 */
+	while (bno < rgbno_next) {
+		bool		also_crosslinked;
+
+		error = xfs_rmap_has_other_keys(cur, bno, 1, rs->oinfo,
+				&also_crosslinked);
+		if (error)
+			goto out_cur;
+
+		if (*crosslinked != also_crosslinked)
+			break;
+
+		len++;
+		bno++;
+	}
+
+	*rglenp = len;
+	trace_xreap_rgextent_select(sc->sr.rtg, rgbno, len, *crosslinked);
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+
+#define XREAP_RTGLOCK_ALL	(XFS_RTGLOCK_BITMAP | \
+				 XFS_RTGLOCK_RMAP | \
+				 XFS_RTGLOCK_REFCOUNT)
+
+/*
+ * Break a rt file metadata extent into sub-extents by fate (crosslinked, not
+ * crosslinked), and dispose of each sub-extent separately.  The extent must
+ * be aligned to a realtime extent.
+ */
+STATIC int
+xreap_rtmeta_extent(
+	uint64_t		rtbno,
+	uint64_t		len,
+	void			*priv)
+{
+	struct xreap_state	*rs = priv;
+	struct xfs_scrub	*sc = rs->sc;
+	xfs_rgnumber_t		rgno;
+	xfs_rgblock_t		rgbno = xfs_rtb_to_rgbno(sc->mp, rtbno, &rgno);
+	xfs_rgblock_t		rgbno_next = rgbno + len;
+	int			error = 0;
+
+	ASSERT(sc->ip != NULL);
+	ASSERT(!sc->sr.rtg);
+
+	/*
+	 * We're reaping blocks after repairing file metadata, which means that
+	 * we have to init the xchk_ag structure ourselves.
+	 */
+	sc->sr.rtg = xfs_rtgroup_get(sc->mp, rgno);
+	if (!sc->sr.rtg)
+		return -EFSCORRUPTED;
+
+	xfs_rtgroup_lock(NULL, sc->sr.rtg, XREAP_RTGLOCK_ALL);
+
+	while (rgbno < rgbno_next) {
+		xfs_extlen_t	rglen;
+		bool		crosslinked;
+
+		error = xreap_rgextent_select(rs, rgbno, rgbno_next,
+				&crosslinked, &rglen);
+		if (error)
+			goto out_unlock;
+
+		error = xreap_rgextent(rs, rgbno, &rglen, crosslinked);
+		if (error)
+			goto out_unlock;
+
+		if (xreap_want_defer_finish(rs)) {
+			error = xfs_defer_finish(&sc->tp);
+			if (error)
+				goto out_unlock;
+			xreap_defer_finish_reset(rs);
+		} else if (xreap_want_roll(rs)) {
+			error = xfs_trans_roll_inode(&sc->tp, sc->ip);
+			if (error)
+				goto out_unlock;
+			xreap_reset(rs);
+		}
+
+		rgbno += rglen;
+	}
+
+out_unlock:
+	xfs_rtgroup_unlock(sc->sr.rtg, XREAP_RTGLOCK_ALL);
+	xfs_rtgroup_put(sc->sr.rtg);
+	sc->sr.rtg = NULL;
+	return error;
+}
+
+/*
+ * Dispose of every block of every rt metadata extent in the bitmap.
+ * Do not use this to dispose of the mappings in an ondisk inode fork.
+ */
+int
+xrep_reap_rtblocks(
+	struct xfs_scrub		*sc,
+	struct xrtb_bitmap		*bitmap,
+	const struct xfs_owner_info	*oinfo)
+{
+	struct xreap_state		rs = {
+		.sc			= sc,
+		.oinfo			= oinfo,
+		.resv			= XFS_AG_RESV_NONE,
+	};
+	int				error;
+
+	ASSERT(xfs_has_rmapbt(sc->mp));
+	ASSERT(sc->ip != NULL);
+
+	error = xrtb_bitmap_walk(bitmap, xreap_rtmeta_extent, &rs);
+	if (error)
+		return error;
+
+	if (xreap_dirty(&rs))
+		return xrep_defer_finish(sc);
+
+	return 0;
+}
+#endif /* CONFIG_XFS_RT */
+
 /*
  * Metadata files are not supposed to share blocks with anything else.
  * If blocks are shared, we remove the reverse mapping (thus reducing the
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
index cfaef544f659..bf025ec3501b 100644
--- a/fs/xfs/scrub/reap.h
+++ b/fs/xfs/scrub/reap.h
@@ -12,6 +12,13 @@ int xrep_reap_fsblocks(struct xfs_scrub *sc, struct xfsb_bitmap *bitmap,
 		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 int xrep_reap_ifork(struct xfs_scrub *sc, struct xfs_inode *ip, int whichfork);
 
+#ifdef CONFIG_XFS_RT
+int xrep_reap_rtblocks(struct xfs_scrub *sc, struct xrtb_bitmap *bitmap,
+		const struct xfs_owner_info *oinfo);
+#else
+# define xrep_reap_rtblocks(...)	(-EOPNOTSUPP)
+#endif /* CONFIG_XFS_RT */
+
 /* Buffer cache scan context. */
 struct xrep_bufscan {
 	/* Disk address for the buffers we want to scan. */
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index aa15aeffa724..e2b75c449046 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -41,6 +41,7 @@ struct xbitmap;
 struct xagb_bitmap;
 struct xrgb_bitmap;
 struct xfsb_bitmap;
+struct xrtb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, int alloc_flags);
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d74bba391854..4d8e4b77cbbe 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1414,6 +1414,41 @@ DEFINE_REPAIR_EXTENT_EVENT(xreap_agextent_binval);
 DEFINE_REPAIR_EXTENT_EVENT(xreap_bmapi_binval);
 DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
 
+#ifdef CONFIG_XFS_RT
+DECLARE_EVENT_CLASS(xrep_rtgroup_extent_class,
+	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rgblock_t rgbno,
+		 xfs_extlen_t len),
+	TP_ARGS(rtg, rgbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, rtdev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(xfs_rgblock_t, rgbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg->rtg_mount->m_super->s_dev;
+		__entry->rtdev = rtg->rtg_mount->m_rtdev_targp->bt_dev;
+		__entry->rgno = rtg->rtg_rgno;
+		__entry->rgbno = rgbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d rtdev %d:%d rgno 0x%x rgbno 0x%x fsbcount 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->rtdev), MINOR(__entry->rtdev),
+		  __entry->rgno,
+		  __entry->rgbno,
+		  __entry->len)
+);
+#define DEFINE_REPAIR_RTGROUP_EXTENT_EVENT(name) \
+DEFINE_EVENT(xrep_rtgroup_extent_class, name, \
+	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rgblock_t rgbno, \
+		 xfs_extlen_t len), \
+	TP_ARGS(rtg, rgbno, len))
+DEFINE_REPAIR_RTGROUP_EXTENT_EVENT(xreap_dispose_unmap_rtextent);
+DEFINE_REPAIR_RTGROUP_EXTENT_EVENT(xreap_dispose_free_rtextent);
+#endif /* CONFIG_XFS_RT */
+
 DECLARE_EVENT_CLASS(xrep_reap_find_class,
 	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len,
 		bool crosslinked),
@@ -1447,6 +1482,43 @@ DEFINE_EVENT(xrep_reap_find_class, name, \
 DEFINE_REPAIR_REAP_FIND_EVENT(xreap_agextent_select);
 DEFINE_REPAIR_REAP_FIND_EVENT(xreap_bmapi_select);
 
+#ifdef CONFIG_XFS_RT
+DECLARE_EVENT_CLASS(xrep_rtgroup_reap_find_class,
+	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rgblock_t rgbno, xfs_extlen_t len,
+		 bool crosslinked),
+	TP_ARGS(rtg, rgbno, len, crosslinked),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, rtdev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(xfs_rgblock_t, rgbno)
+		__field(xfs_extlen_t, len)
+		__field(bool, crosslinked)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg->rtg_mount->m_super->s_dev;
+		__entry->rtdev = rtg->rtg_mount->m_rtdev_targp->bt_dev;
+		__entry->rgno = rtg->rtg_rgno;
+		__entry->rgbno = rgbno;
+		__entry->len = len;
+		__entry->crosslinked = crosslinked;
+	),
+	TP_printk("dev %d:%d rtdev %d:%d rgno 0x%x rgbno 0x%x fsbcount 0x%x crosslinked %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->rtdev), MINOR(__entry->rtdev),
+		  __entry->rgno,
+		  __entry->rgbno,
+		  __entry->len,
+		  __entry->crosslinked ? 1 : 0)
+);
+#define DEFINE_REPAIR_RTGROUP_REAP_FIND_EVENT(name) \
+DEFINE_EVENT(xrep_rtgroup_reap_find_class, name, \
+	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rgblock_t rgbno, \
+		 xfs_extlen_t len, bool crosslinked), \
+	TP_ARGS(rtg, rgbno, len, crosslinked))
+DEFINE_REPAIR_RTGROUP_REAP_FIND_EVENT(xreap_rgextent_select);
+#endif /* CONFIG_XFS_RT */
+
 DECLARE_EVENT_CLASS(xrep_rmap_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_extlen_t len,

