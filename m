Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84738FBE5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrCpxu+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48728C433C7;
	Sun, 31 Dec 2023 21:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059747;
	bh=OF9Y9sz6jCbsEJbVW3ajEUNqdwgjjHH9LrDrMxgZB8U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lrCpxu+NTY/XPz2/ytd3p3Q+Z11FtJkry7mGW/8RJl7Za3cWR9r8Ir1tE42t232sr
	 h9fGP6kTJ+qqPVd+FDqyXbxhD+iSxh37u7zeHnhwPhzzF4gU9fbitc/ak3Wn7dwK7/
	 b/wYOk3draUs3jMb0pzCHmckCKPMrxabbEbeLW3fAO6RxUJBElVxjvyQhF8lA2Gqpn
	 N6fnbS77SxZIbo0jdL+kzSQlOiJPcz43Ap4XZLF6ya7Vab1oBKmTw9mGpFXwWG2yem
	 8ujjxp/ZGvJ4QKZRjSAaD3vdZxiV5jVAxOeiIHzH2rLdyMM3m2FdIotNo0qLVH8lHy
	 6CabbcdhRCEDg==
Date: Sun, 31 Dec 2023 13:55:46 -0800
Subject: [PATCH 43/44] xfs: fix CoW forks for realtime files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852271.1766284.5224402997263588022.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Port the copy on write fork repair to realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/cow_repair.c |  210 +++++++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/reap.c       |  222 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/reap.h       |    7 +
 fs/xfs/scrub/repair.h     |    1 
 fs/xfs/scrub/rtb_bitmap.h |   37 ++++++++
 fs/xfs/scrub/trace.h      |   72 +++++++++++++++
 6 files changed, 532 insertions(+), 17 deletions(-)
 create mode 100644 fs/xfs/scrub/rtb_bitmap.h


diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index e48d869986f34..4be05fd8d0490 100644
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
@@ -34,6 +37,7 @@
 #include "scrub/bitmap.h"
 #include "scrub/off_bitmap.h"
 #include "scrub/fsb_bitmap.h"
+#include "scrub/rtb_bitmap.h"
 #include "scrub/reap.h"
 
 /*
@@ -61,7 +65,10 @@ struct xrep_cow {
 	struct xoff_bitmap	bad_fileoffs;
 
 	/* Bitmap of fsblocks that were removed from the CoW fork. */
-	struct xfsb_bitmap	old_cowfork_fsblocks;
+	union {
+		struct xfsb_bitmap	old_cowfork_fsblocks;
+		struct xrtb_bitmap	old_cowfork_rtblocks;
+	};
 
 	/* CoW fork mappings used to scan for bad CoW staging extents. */
 	struct xfs_bmbt_irec	irec;
@@ -145,8 +152,12 @@ xrep_cow_mark_shared_staging(
 
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
 
@@ -166,6 +177,7 @@ xrep_cow_mark_missing_staging(
 {
 	struct xrep_cow			*xc = priv;
 	struct xfs_refcount_irec	rrec;
+	xfs_fsblock_t			fsbno;
 	int				error;
 
 	if (!xfs_refcount_check_domain(rec) ||
@@ -177,9 +189,13 @@ xrep_cow_mark_missing_staging(
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
@@ -222,7 +238,12 @@ xrep_cow_mark_missing_staging_rmap(
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
 
@@ -311,6 +332,97 @@ xrep_cow_find_bad(
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
+	if (xrep_is_rtmeta_ino(sc, rtg, sc->ip->i_ino))
+		goto out_rtg;
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
  * blocks, and fill out the mapping.
@@ -351,6 +463,46 @@ xrep_cow_alloc(
 	return 0;
 }
 
+/*
+ * Allocate a replacement rt CoW staging extent of up to the given number of
+ * blocks, and fill out the mapping.
+ */
+STATIC int
+xrep_cow_alloc_rt(
+	struct xfs_scrub	*sc,
+	xfs_extlen_t		maxlen,
+	struct xrep_cow_extent	*repl)
+{
+	xfs_rtxnum_t		rtx = NULLRTEXTNO;
+	xfs_rtxlen_t		maxrtx;
+	xfs_rtxlen_t		rtxlen = 0;
+	xfs_rtblock_t		rtbno;
+	xfs_extlen_t		len;
+	int			error;
+
+	maxrtx = xfs_rtb_to_rtx(sc->mp, maxlen);
+	error = xfs_trans_reserve_more(sc->tp, 0, maxrtx);
+	if (error)
+		return error;
+
+	xfs_rtbitmap_lock(sc->tp, sc->mp);
+
+	error = xfs_rtallocate_extent(sc->tp, 0, 1, maxrtx, &rtxlen, 0, 1,
+			&rtx);
+	if (error)
+		return error;
+	if (rtx == NULLRTEXTNO)
+		return -ENOSPC;
+
+	rtbno = xfs_rtx_to_rtb(sc->mp, rtx);
+	len = xfs_rtxlen_to_extlen(sc->mp, rtxlen);
+	xfs_refcount_alloc_cow_extent(sc->tp, true, rtbno, len);
+
+	repl->fsbno = rtbno;
+	repl->len = len;
+	return 0;
+}
+
 /*
  * Look up the current CoW fork mapping so that we only allocate enough to
  * replace a single mapping.  If we don't find a mapping that covers the start
@@ -468,7 +620,10 @@ xrep_cow_replace_range(
 	 */
 	alloc_len = min_t(xfs_fileoff_t, XFS_MAX_BMBT_EXTLEN,
 			  nextoff - startoff);
-	error = xrep_cow_alloc(sc, alloc_len, &repl);
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		error = xrep_cow_alloc_rt(sc, alloc_len, &repl);
+	else
+		error = xrep_cow_alloc(sc, alloc_len, &repl);
 	if (error)
 		return error;
 
@@ -484,8 +639,12 @@ xrep_cow_replace_range(
 		return error;
 
 	/* Note the old CoW staging extents; we'll reap them all later. */
-	error = xfsb_bitmap_set(&xc->old_cowfork_fsblocks, got.br_startblock,
-			repl.len);
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		error = xrtb_bitmap_set(&xc->old_cowfork_rtblocks,
+				got.br_startblock, repl.len);
+	else
+		error = xfsb_bitmap_set(&xc->old_cowfork_fsblocks,
+				got.br_startblock, repl.len);
 	if (error)
 		return error;
 
@@ -541,8 +700,12 @@ xrep_bmap_cow(
 	if (!ifp)
 		return 0;
 
-	/* realtime files aren't supported yet */
-	if (XFS_IS_REALTIME_INODE(sc->ip))
+	/*
+	 * Realtime files with large extent sizes are not supported because
+	 * we could encounter an CoW mapping that has been partially written
+	 * out *and* requires replacement, and there's no solution to that.
+	 */
+	if (xfs_inode_has_bigallocunit(sc->ip))
 		return -EOPNOTSUPP;
 
 	/*
@@ -563,7 +726,10 @@ xrep_bmap_cow(
 
 	xc->sc = sc;
 	xoff_bitmap_init(&xc->bad_fileoffs);
-	xfsb_bitmap_init(&xc->old_cowfork_fsblocks);
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		xrtb_bitmap_init(&xc->old_cowfork_rtblocks);
+	else
+		xfsb_bitmap_init(&xc->old_cowfork_fsblocks);
 
 	for_each_xfs_iext(ifp, &icur, &xc->irec) {
 		if (xchk_should_terminate(sc, &error))
@@ -586,7 +752,10 @@ xrep_bmap_cow(
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
@@ -601,13 +770,20 @@ xrep_bmap_cow(
 	 * by the refcount btree, not the inode, so it is correct to treat them
 	 * like inode metadata.
 	 */
-	error = xrep_reap_fsblocks(sc, &xc->old_cowfork_fsblocks,
-			&XFS_RMAP_OINFO_COW);
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		error = xrep_reap_rtblocks(sc, &xc->old_cowfork_rtblocks,
+				&XFS_RMAP_OINFO_COW);
+	else
+		error = xrep_reap_fsblocks(sc, &xc->old_cowfork_fsblocks,
+				&XFS_RMAP_OINFO_COW);
 	if (error)
 		goto out_bitmap;
 
 out_bitmap:
-	xfsb_bitmap_destroy(&xc->old_cowfork_fsblocks);
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		xrtb_bitmap_destroy(&xc->old_cowfork_rtblocks);
+	else
+		xfsb_bitmap_destroy(&xc->old_cowfork_fsblocks);
 	xoff_bitmap_destroy(&xc->bad_fileoffs);
 	kmem_free(xc);
 	return error;
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index bb28c2d2b8780..b8166e19726a4 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -34,6 +34,8 @@
 #include "xfs_attr_remote.h"
 #include "xfs_defer.h"
 #include "xfs_imeta.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -41,6 +43,7 @@
 #include "scrub/bitmap.h"
 #include "scrub/agb_bitmap.h"
 #include "scrub/fsb_bitmap.h"
+#include "scrub/rtb_bitmap.h"
 #include "scrub/reap.h"
 
 /*
@@ -680,6 +683,225 @@ xrep_reap_fsblocks(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_RT
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
+/*
+ * Dispose of as much of the beginning of this rtgroup extent as possible.
+ * The number of blocks disposed of will be returned in @rglenp.
+ */
+STATIC int
+xreap_rgextent_iter(
+	struct xreap_state	*rs,
+	xfs_rgblock_t		rgbno,
+	xfs_extlen_t		*rglenp,
+	bool			crosslinked)
+{
+	struct xfs_scrub	*sc = rs->sc;
+	xfs_rtblock_t		rtbno;
+	int			error;
+
+	/*
+	 * The only caller so far is CoW fork repair, so we only know how to
+	 * unlink or free CoW staging extents.  Here we don't have to worry
+	 * about invalidating buffers!
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
+	error = xfs_free_extent_later(sc->tp, rtbno, *rglenp, NULL,
+			rs->resv,
+			XFS_FREE_EXTENT_REALTIME |
+			XFS_FREE_EXTENT_SKIP_DISCARD);
+	if (error)
+		return error;
+
+	rs->deferred++;
+	return 0;
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
+		error = xreap_rgextent_iter(rs, rgbno, &rglen, crosslinked);
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
  * Dispose of every block of an old metadata btree that used to be rooted in a
  * metadata directory file.
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
index 70e5e6bbb8d38..4c8f62701fb36 100644
--- a/fs/xfs/scrub/reap.h
+++ b/fs/xfs/scrub/reap.h
@@ -17,6 +17,13 @@ int xrep_reap_ifork(struct xfs_scrub *sc, struct xfs_inode *ip, int whichfork);
 int xrep_reap_metadir_fsblocks(struct xfs_scrub *sc,
 		struct xfsb_bitmap *bitmap);
 
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
index 969317d429db6..801a9013f37f1 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -51,6 +51,7 @@ struct xbitmap;
 struct xagb_bitmap;
 struct xrgb_bitmap;
 struct xfsb_bitmap;
+struct xrtb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, int alloc_flags);
 
diff --git a/fs/xfs/scrub/rtb_bitmap.h b/fs/xfs/scrub/rtb_bitmap.h
new file mode 100644
index 0000000000000..1313ef605511e
--- /dev/null
+++ b/fs/xfs/scrub/rtb_bitmap.h
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_RTB_BITMAP_H__
+#define __XFS_SCRUB_RTB_BITMAP_H__
+
+/* Bitmaps, but for type-checked for xfs_rtblock_t */
+
+struct xrtb_bitmap {
+	struct xbitmap64	rtbitmap;
+};
+
+static inline void xrtb_bitmap_init(struct xrtb_bitmap *bitmap)
+{
+	xbitmap64_init(&bitmap->rtbitmap);
+}
+
+static inline void xrtb_bitmap_destroy(struct xrtb_bitmap *bitmap)
+{
+	xbitmap64_destroy(&bitmap->rtbitmap);
+}
+
+static inline int xrtb_bitmap_set(struct xrtb_bitmap *bitmap,
+		xfs_rtblock_t start, xfs_filblks_t len)
+{
+	return xbitmap64_set(&bitmap->rtbitmap, start, len);
+}
+
+static inline int xrtb_bitmap_walk(struct xrtb_bitmap *bitmap,
+		xbitmap64_walk_fn fn, void *priv)
+{
+	return xbitmap64_walk(&bitmap->rtbitmap, fn, priv);
+}
+
+#endif	/* __XFS_SCRUB_RTB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index aa943433cbb02..2c6f7e3b7578d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2013,6 +2013,41 @@ DEFINE_REPAIR_EXTENT_EVENT(xreap_agextent_binval);
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
@@ -2046,6 +2081,43 @@ DEFINE_EVENT(xrep_reap_find_class, name, \
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

