Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B7410F7
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052872; cv=none; b=pth/P0L2dQ+7PnC6Rleum5zGMlmvI7mgyRxZ52Ps0n4F2JU4IbfoZb8WqngNjEE+QvmoLSlyL9/lhB6VcaYvxqVlbDSndJ5+F+oEbSmOMvZV1wQFkgvU4tJTeh2DcFwZlWtl6u03sAnDjyc73LnUdZ9qwBauIuArhFrVPlBjjoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052872; c=relaxed/simple;
	bh=B2NB6EXKeJr7HHYR4KftbEcGaO8qE8/8hLE+r+rsPSk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZqNOKPepmNYGrbOlnGQShrEod7TxNnbH/9gAAtJ/ZgJ/x6nRywKaEcBpijrXeLohQtVq6bxaZggOjZhiz//QoZ/SHKypf81YNp/SYclhCalT1KuGI2bSSDAddfF8TdnVDU1IAYZQz1vZFyMMst/0KbK3DhSWN//fV1QVu1p0RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GdhWkOVA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GdhWkOVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42114C4CECE;
	Fri, 13 Dec 2024 01:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052872;
	bh=B2NB6EXKeJr7HHYR4KftbEcGaO8qE8/8hLE+r+rsPSk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GdhWkOVAuNyVKB6NMn3y6QNtZ/sl5H6/nE9WFPQ89hetvX487vDQLPuaRAApzSRB9
	 EFXyJepFtdqd7DH6oSSO1g4R8KHWs45ZizZgcDNQOdIRe22k5iJ8WgVNFtMikDfMrR
	 QfwY3LG6uAJm+iUZ6dt6DJRDK7Ok1iNTxyGSAqSJ5cwq29YBnPpY7qQcQxUloKzfKQ
	 XOmeOWzJN8FEX1CHBBgclUNHz+TC5JMFUsqcZl/TIU/aURBl4xBwoBwJN220guF/hp
	 t9IngzlSl3eaRu5+V+cGidmFIiBc3I8J6uhj1KXCcgKtK1RWqFswRB9Wy4DSjQT7mI
	 avihV90qHeimQ==
Date: Thu, 12 Dec 2024 17:21:11 -0800
Subject: [PATCH 42/43] xfs: fix CoW forks for realtime files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125286.1182620.1316346517848021106.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    2 
 fs/xfs/scrub/cow_repair.c      |  178 +++++++++++++++++++++++++++--
 fs/xfs/scrub/reap.c            |  242 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/reap.h            |    7 +
 fs/xfs/scrub/repair.h          |    1 
 fs/xfs/scrub/rtb_bitmap.h      |   37 ++++++
 fs/xfs/scrub/trace.h           |   36 ++++--
 fs/xfs/xfs_rtalloc.c           |    4 -
 fs/xfs/xfs_rtalloc.h           |    5 +
 9 files changed, 470 insertions(+), 42 deletions(-)
 create mode 100644 fs/xfs/scrub/rtb_bitmap.h


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index b45d2b32051a63..cd6f0223879f49 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -647,7 +647,7 @@ xrep_agfl_fill(
 	xfs_agblock_t		agbno = start;
 	int			error;
 
-	trace_xrep_agfl_insert(sc->sa.pag, agbno, len);
+	trace_xrep_agfl_insert(pag_group(sc->sa.pag), agbno, len);
 
 	while (agbno < start + len && af->fl_off < af->flcount)
 		af->agfl_bno[af->fl_off++] = cpu_to_be32(agbno++);
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index ba695dd21f8b96..38a246b8bf11c9 100644
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
@@ -145,8 +152,7 @@ xrep_cow_mark_shared_staging(
 	xrep_cow_trim_refcount(xc, &rrec, rec);
 
 	return xrep_cow_mark_file_range(xc,
-			xfs_agbno_to_fsb(to_perag(cur->bc_group),
-				rrec.rc_startblock),
+			xfs_gbno_to_fsb(cur->bc_group, rrec.rc_startblock),
 			rrec.rc_blockcount);
 }
 
@@ -177,9 +183,8 @@ xrep_cow_mark_missing_staging(
 	if (xc->next_bno >= rrec.rc_startblock)
 		goto next;
 
-
 	error = xrep_cow_mark_file_range(xc,
-			xfs_agbno_to_fsb(to_perag(cur->bc_group), xc->next_bno),
+			xfs_gbno_to_fsb(cur->bc_group, xc->next_bno),
 			rrec.rc_startblock - xc->next_bno);
 	if (error)
 		return error;
@@ -222,8 +227,7 @@ xrep_cow_mark_missing_staging_rmap(
 	}
 
 	return xrep_cow_mark_file_range(xc,
-			xfs_agbno_to_fsb(to_perag(cur->bc_group), rec_bno),
-			rec_len);
+			xfs_gbno_to_fsb(cur->bc_group, rec_bno), rec_len);
 }
 
 /*
@@ -310,6 +314,92 @@ xrep_cow_find_bad(
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
+	int				error = 0;
+
+	xc->irec_startbno = xfs_rtb_to_rgbno(sc->mp, xc->irec.br_startblock);
+
+	rtg = xfs_rtgroup_get(sc->mp,
+			xfs_rtb_to_rgno(sc->mp, xc->irec.br_startblock));
+	if (!rtg)
+		return -EFSCORRUPTED;
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
+				xfs_rgbno_to_rtb(rtg, xc->next_bno),
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
@@ -350,6 +440,32 @@ xrep_cow_alloc(
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
+	xfs_rtxlen_t		maxrtx = xfs_rtb_to_rtx(sc->mp, maxlen);
+	int			error;
+
+	error = xfs_trans_reserve_more(sc->tp, 0, maxrtx);
+	if (error)
+		return error;
+
+	error = xfs_rtallocate_rtgs(sc->tp, NULLRTBLOCK, 1, maxrtx, 1, false,
+			false, &repl->fsbno, &repl->len);
+	if (error)
+		return error;
+
+	xfs_refcount_alloc_cow_extent(sc->tp, true, repl->fsbno, repl->len);
+	return 0;
+}
+
 /*
  * Look up the current CoW fork mapping so that we only allocate enough to
  * replace a single mapping.  If we don't find a mapping that covers the start
@@ -467,7 +583,10 @@ xrep_cow_replace_range(
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
 
@@ -483,8 +602,12 @@ xrep_cow_replace_range(
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
 
@@ -540,8 +663,16 @@ xrep_bmap_cow(
 	if (!ifp)
 		return 0;
 
-	/* realtime files aren't supported yet */
-	if (XFS_IS_REALTIME_INODE(sc->ip))
+	/*
+	 * Realtime files with large extent sizes are not supported because
+	 * we could encounter an CoW mapping that has been partially written
+	 * out *and* requires replacement, and there's no solution to that.
+	 */
+	if (xfs_inode_has_bigrtalloc(sc->ip))
+		return -EOPNOTSUPP;
+
+	/* Metadata inodes aren't supposed to have data on the rt volume. */
+	if (xfs_is_metadir_inode(sc->ip) && XFS_IS_REALTIME_INODE(sc->ip))
 		return -EOPNOTSUPP;
 
 	/*
@@ -562,7 +693,10 @@ xrep_bmap_cow(
 
 	xc->sc = sc;
 	xoff_bitmap_init(&xc->bad_fileoffs);
-	xfsb_bitmap_init(&xc->old_cowfork_fsblocks);
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		xrtb_bitmap_init(&xc->old_cowfork_rtblocks);
+	else
+		xfsb_bitmap_init(&xc->old_cowfork_fsblocks);
 
 	for_each_xfs_iext(ifp, &icur, &xc->irec) {
 		if (xchk_should_terminate(sc, &error))
@@ -585,7 +719,10 @@ xrep_bmap_cow(
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
@@ -600,13 +737,20 @@ xrep_bmap_cow(
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
 	kfree(xc);
 	return error;
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 534c7696e9a1a7..b32fb233cf8476 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -34,6 +34,8 @@
 #include "xfs_attr_remote.h"
 #include "xfs_defer.h"
 #include "xfs_metafile.h"
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
@@ -311,7 +314,7 @@ xreap_agextent_binval(
 	}
 
 out:
-	trace_xreap_agextent_binval(sc->sa.pag, agbno, *aglenp);
+	trace_xreap_agextent_binval(pag_group(sc->sa.pag), agbno, *aglenp);
 }
 
 /*
@@ -370,7 +373,8 @@ xreap_agextent_select(
 
 out_found:
 	*aglenp = len;
-	trace_xreap_agextent_select(sc->sa.pag, agbno, len, *crosslinked);
+	trace_xreap_agextent_select(pag_group(sc->sa.pag), agbno, len,
+			*crosslinked);
 out_cur:
 	xfs_btree_del_cursor(cur, error);
 	return error;
@@ -409,7 +413,8 @@ xreap_agextent_iter(
 	 * to run xfs_repair.
 	 */
 	if (crosslinked) {
-		trace_xreap_dispose_unmap_extent(sc->sa.pag, agbno, *aglenp);
+		trace_xreap_dispose_unmap_extent(pag_group(sc->sa.pag), agbno,
+				*aglenp);
 
 		rs->force_roll = true;
 
@@ -428,7 +433,7 @@ xreap_agextent_iter(
 				*aglenp, rs->oinfo);
 	}
 
-	trace_xreap_dispose_free_extent(sc->sa.pag, agbno, *aglenp);
+	trace_xreap_dispose_free_extent(pag_group(sc->sa.pag), agbno, *aglenp);
 
 	/*
 	 * Invalidate as many buffers as we can, starting at agbno.  If this
@@ -679,6 +684,225 @@ xrep_reap_fsblocks(
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
+	cur = xfs_rtrmapbt_init_cursor(sc->tp, sc->sr.rtg);
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
+	trace_xreap_agextent_select(rtg_group(sc->sr.rtg), rgbno, len,
+			*crosslinked);
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
+	rtbno = xfs_rgbno_to_rtb(sc->sr.rtg, rgbno);
+
+	/*
+	 * If there are other rmappings, this block is cross linked and must
+	 * not be freed.  Remove the forward and reverse mapping and move on.
+	 */
+	if (crosslinked) {
+		trace_xreap_dispose_unmap_extent(rtg_group(sc->sr.rtg), rgbno,
+				*rglenp);
+
+		xfs_refcount_free_cow_extent(sc->tp, true, rtbno, *rglenp);
+		rs->deferred++;
+		return 0;
+	}
+
+	trace_xreap_dispose_free_extent(rtg_group(sc->sr.rtg), rgbno, *rglenp);
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
+	xfs_rgblock_t		rgbno = xfs_rtb_to_rgbno(sc->mp, rtbno);
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
+	sc->sr.rtg = xfs_rtgroup_get(sc->mp, xfs_rtb_to_rgno(sc->mp, rtbno));
+	if (!sc->sr.rtg)
+		return -EFSCORRUPTED;
+
+	xfs_rtgroup_lock(sc->sr.rtg, XREAP_RTGLOCK_ALL);
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
@@ -771,7 +995,8 @@ xreap_bmapi_select(
 	}
 
 	imap->br_blockcount = len;
-	trace_xreap_bmapi_select(sc->sa.pag, agbno, len, *crosslinked);
+	trace_xreap_bmapi_select(pag_group(sc->sa.pag), agbno, len,
+			*crosslinked);
 out_cur:
 	xfs_btree_del_cursor(cur, error);
 	return error;
@@ -910,7 +1135,8 @@ xreap_bmapi_binval(
 	}
 
 out:
-	trace_xreap_bmapi_binval(sc->sa.pag, agbno, imap->br_blockcount);
+	trace_xreap_bmapi_binval(pag_group(sc->sa.pag), agbno,
+			imap->br_blockcount);
 	return 0;
 }
 
@@ -937,7 +1163,7 @@ xrep_reap_bmapi_iter(
 		 * anybody else who thinks they own the block, even though that
 		 * runs the risk of stale buffer warnings in the future.
 		 */
-		trace_xreap_dispose_unmap_extent(sc->sa.pag,
+		trace_xreap_dispose_unmap_extent(pag_group(sc->sa.pag),
 				XFS_FSB_TO_AGBNO(sc->mp, imap->br_startblock),
 				imap->br_blockcount);
 
@@ -960,7 +1186,7 @@ xrep_reap_bmapi_iter(
 	 * by a block starting before the first block of the extent but overlap
 	 * anyway.
 	 */
-	trace_xreap_dispose_free_extent(sc->sa.pag,
+	trace_xreap_dispose_free_extent(pag_group(sc->sa.pag),
 			XFS_FSB_TO_AGBNO(sc->mp, imap->br_startblock),
 			imap->br_blockcount);
 
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
index 70e5e6bbb8d38d..4c8f62701fb36b 100644
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
index 8f8f18b48a449d..823c00d1a50262 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -52,6 +52,7 @@ struct xbitmap;
 struct xagb_bitmap;
 struct xrgb_bitmap;
 struct xfsb_bitmap;
+struct xrtb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, int alloc_flags);
 
diff --git a/fs/xfs/scrub/rtb_bitmap.h b/fs/xfs/scrub/rtb_bitmap.h
new file mode 100644
index 00000000000000..1313ef605511ea
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
index 56811862aa8226..d7c4ced47c1567 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1964,32 +1964,36 @@ DEFINE_XCHK_METAPATH_EVENT(xchk_metapath_lookup);
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
 DECLARE_EVENT_CLASS(xrep_extent_class,
-	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
+	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
 		 xfs_extlen_t len),
-	TP_ARGS(pag, agbno, len),
+	TP_ARGS(xg, agbno, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
-		__entry->dev = pag_mount(pag)->m_super->s_dev;
-		__entry->agno = pag_agno(pag);
+		__entry->dev = xg->xg_mount->m_super->s_dev;
+		__entry->type = xg->xg_type;
+		__entry->agno = xg->xg_gno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
+	TP_printk("dev %d:%d %sno 0x%x %sbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agbno,
 		  __entry->len)
 );
 #define DEFINE_REPAIR_EXTENT_EVENT(name) \
 DEFINE_EVENT(xrep_extent_class, name, \
-	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno, \
+	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno, \
 		 xfs_extlen_t len), \
-	TP_ARGS(pag, agbno, len))
+	TP_ARGS(xg, agbno, len))
 DEFINE_REPAIR_EXTENT_EVENT(xreap_dispose_unmap_extent);
 DEFINE_REPAIR_EXTENT_EVENT(xreap_dispose_free_extent);
 DEFINE_REPAIR_EXTENT_EVENT(xreap_agextent_binval);
@@ -1997,35 +2001,39 @@ DEFINE_REPAIR_EXTENT_EVENT(xreap_bmapi_binval);
 DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
 
 DECLARE_EVENT_CLASS(xrep_reap_find_class,
-	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
+	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
 		 xfs_extlen_t len, bool crosslinked),
-	TP_ARGS(pag, agbno, len, crosslinked),
+	TP_ARGS(xg, agbno, len, crosslinked),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
 		__field(bool, crosslinked)
 	),
 	TP_fast_assign(
-		__entry->dev = pag_mount(pag)->m_super->s_dev;
-		__entry->agno = pag_agno(pag);
+		__entry->dev = xg->xg_mount->m_super->s_dev;
+		__entry->type = xg->xg_type;
+		__entry->agno = xg->xg_gno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->crosslinked = crosslinked;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x crosslinked %d",
+	TP_printk("dev %d:%d %sno 0x%x %sbno 0x%x fsbcount 0x%x crosslinked %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agbno,
 		  __entry->len,
 		  __entry->crosslinked ? 1 : 0)
 );
 #define DEFINE_REPAIR_REAP_FIND_EVENT(name) \
 DEFINE_EVENT(xrep_reap_find_class, name, \
-	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno, \
+	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno, \
 		 xfs_extlen_t len, bool crosslinked), \
-	TP_ARGS(pag, agbno, len, crosslinked))
+	TP_ARGS(xg, agbno, len, crosslinked))
 DEFINE_REPAIR_REAP_FIND_EVENT(xreap_agextent_select);
 DEFINE_REPAIR_REAP_FIND_EVENT(xreap_bmapi_select);
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a5de5405800a22..7135a6717a9e11 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -594,7 +594,7 @@ xfs_rtalloc_sumlevel(
  * specified.  If we don't get maxlen then use prod to trim
  * the length, if given.  The lengths are all in rtextents.
  */
-STATIC int
+static int
 xfs_rtallocate_extent_size(
 	struct xfs_rtalloc_args	*args,
 	xfs_rtxlen_t		minlen,	/* minimum length to allocate */
@@ -1958,7 +1958,7 @@ xfs_rtallocate_rtg(
 	goto out_release;
 }
 
-static int
+int
 xfs_rtallocate_rtgs(
 	struct xfs_trans	*tp,
 	xfs_fsblock_t		bno_hint,
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 9044f7226ab6fc..0d95b29092c9f3 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -77,4 +77,9 @@ xfs_growfs_check_rtgeom(const struct xfs_mount *mp,
 }
 #endif	/* CONFIG_XFS_RT */
 
+int xfs_rtallocate_rtgs(struct xfs_trans *tp, xfs_fsblock_t bno_hint,
+		xfs_rtxlen_t minlen, xfs_rtxlen_t maxlen, xfs_rtxlen_t prod,
+		bool wasdel, bool initial_user_data, xfs_rtblock_t *bno,
+		xfs_extlen_t *blen);
+
 #endif	/* __XFS_RTALLOC_H__ */

