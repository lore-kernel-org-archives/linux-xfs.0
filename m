Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D815F46B
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 20:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817647; cv=none; b=A80xnsn34rrylKc6A8xfgcP3sWx1F03wQH24tTDlQZ6JwPP0YST5Da/se1ssGxxcq9CEtiymPSUlvFNP3dSbrYEYuWI+hSA0sQHekP8fEBArit8szWMnQQiKveWuB36egxHPBaSaYyVVRVf/hnVTCOLERItXyllpbsjrAiTwg9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817647; c=relaxed/simple;
	bh=Vkt8J6wunctICYuxSAxq2Gj3qOcvhZzkT+lkXJpgmNQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kk2yBquyAuuXbpmeUgeWKzIshpFdA9Op8gGz0KQJ6boM8oempgj60U0N0l15BT+Wwp9jkWlruFbHnCl/C3rW/wXncGviHDlNy8HgaNMFa++BtiGNcKHzwZiGRy4vtpkwHSopZj6RM2hTK8otmtvKDcpCdaVfsOBzILL8k5uc9VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRpEdiQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRpEdiQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66CDC433C7;
	Thu,  1 Feb 2024 20:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817646;
	bh=Vkt8J6wunctICYuxSAxq2Gj3qOcvhZzkT+lkXJpgmNQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XRpEdiQlLnIhor7nY6JeKDcL7R6s9iQs1PDDaNo1IL7zlzyEn/0vaAMyxo83lzZ4f
	 vTijpxwgndJ9mcWExo90qWqz2X9eOIR5fJGF19Ryi64u1K4bY3WqgVBgDokQaK0+Ez
	 ft5/Y9qGGc9KDL8r2l+/ifIjebxOqxy8TIm4XewOzQYkPYtgdgAsfNniNUXXftPU+9
	 VyuuqGC3rTjX2EBPvDkxeCAVXLFvESPYNHMAT6PZO3Ix7L5lfFvKDPQ7tZHBAHNRcq
	 Eb+Au8KRDhry9oLd9ZMA1t8fxDTPHBh3JD+QZZ8qhnbEFm95pQKnhNIfVF0hnfV6bj
	 M4oZI1KwKfrXw==
Date: Thu, 01 Feb 2024 12:00:46 -0800
Subject: [PATCH 3/3] xfs: port refcount repair to the new refcount bag
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681337921.1608752.15139847768666002180.stgit@frogsfrogsfrogs>
In-Reply-To: <170681337865.1608752.14424093781022631293.stgit@frogsfrogsfrogs>
References: <170681337865.1608752.14424093781022631293.stgit@frogsfrogsfrogs>
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

Port the refcount record generating code to use the new refcount bag
data structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/refcount.c        |   12 +++
 fs/xfs/scrub/refcount_repair.c |  164 ++++++++++++++--------------------------
 fs/xfs/scrub/repair.h          |    2 
 fs/xfs/xfs_super.c             |   10 ++
 4 files changed, 81 insertions(+), 107 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index bf22f245bbfa8..d0c7d4a29c0fe 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -7,8 +7,10 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_trans.h"
 #include "xfs_ag.h"
 #include "xfs_btree.h"
 #include "xfs_rmap.h"
@@ -17,6 +19,7 @@
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /*
  * Set us up to scrub reference count btrees.
@@ -27,6 +30,15 @@ xchk_setup_ag_refcountbt(
 {
 	if (xchk_need_intent_drain(sc))
 		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
+
+	if (xchk_could_repair(sc)) {
+		int		error;
+
+		error = xrep_setup_ag_refcountbt(sc);
+		if (error)
+			return error;
+	}
+
 	return xchk_setup_ag_btree(sc, false);
 }
 
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index 8240c993061b2..a00d7ce7ae5b8 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -38,6 +38,7 @@
 #include "scrub/xfarray.h"
 #include "scrub/newbt.h"
 #include "scrub/reap.h"
+#include "scrub/rcbag.h"
 
 /*
  * Rebuilding the Reference Count Btree
@@ -98,12 +99,6 @@
  * insert all the records.
  */
 
-/* The only parts of the rmap that we care about for computing refcounts. */
-struct xrep_refc_rmap {
-	xfs_agblock_t		startblock;
-	xfs_extlen_t		blockcount;
-} __packed;
-
 struct xrep_refc {
 	/* refcount extents */
 	struct xfarray		*refcount_records;
@@ -123,6 +118,20 @@ struct xrep_refc {
 	xfs_extlen_t		btblocks;
 };
 
+/* Set us up to repair refcount btrees. */
+int
+xrep_setup_ag_refcountbt(
+	struct xfs_scrub	*sc)
+{
+	char			*descr;
+	int			error;
+
+	descr = xchk_xfile_ag_descr(sc, "rmap record bag");
+	error = xrep_setup_xfbtree(sc, descr);
+	kfree(descr);
+	return error;
+}
+
 /* Check for any obvious conflicts with this shared/CoW staging extent. */
 STATIC int
 xrep_refc_check_ext(
@@ -224,10 +233,9 @@ xrep_refc_rmap_shareable(
 STATIC int
 xrep_refc_walk_rmaps(
 	struct xrep_refc	*rr,
-	struct xrep_refc_rmap	*rrm,
+	struct xfs_rmap_irec	*rmap,
 	bool			*have_rec)
 {
-	struct xfs_rmap_irec	rmap;
 	struct xfs_btree_cur	*cur = rr->sc->sa.rmap_cur;
 	struct xfs_mount	*mp = cur->bc_mp;
 	int			have_gt;
@@ -251,7 +259,7 @@ xrep_refc_walk_rmaps(
 		if (!have_gt)
 			return 0;
 
-		error = xfs_rmap_get_rec(cur, &rmap, &have_gt);
+		error = xfs_rmap_get_rec(cur, rmap, &have_gt);
 		if (error)
 			return error;
 		if (XFS_IS_CORRUPT(mp, !have_gt)) {
@@ -259,23 +267,22 @@ xrep_refc_walk_rmaps(
 			return -EFSCORRUPTED;
 		}
 
-		if (rmap.rm_owner == XFS_RMAP_OWN_COW) {
-			error = xrep_refc_stash_cow(rr, rmap.rm_startblock,
-					rmap.rm_blockcount);
+		if (rmap->rm_owner == XFS_RMAP_OWN_COW) {
+			error = xrep_refc_stash_cow(rr, rmap->rm_startblock,
+					rmap->rm_blockcount);
 			if (error)
 				return error;
-		} else if (rmap.rm_owner == XFS_RMAP_OWN_REFC) {
+		} else if (rmap->rm_owner == XFS_RMAP_OWN_REFC) {
 			/* refcountbt block, dump it when we're done. */
-			rr->btblocks += rmap.rm_blockcount;
+			rr->btblocks += rmap->rm_blockcount;
 			error = xagb_bitmap_set(&rr->old_refcountbt_blocks,
-					rmap.rm_startblock, rmap.rm_blockcount);
+					rmap->rm_startblock,
+					rmap->rm_blockcount);
 			if (error)
 				return error;
 		}
-	} while (!xrep_refc_rmap_shareable(mp, &rmap));
+	} while (!xrep_refc_rmap_shareable(mp, rmap));
 
-	rrm->startblock = rmap.rm_startblock;
-	rrm->blockcount = rmap.rm_blockcount;
 	*have_rec = true;
 	return 0;
 }
@@ -357,45 +364,6 @@ xrep_refc_sort_records(
 	return error;
 }
 
-#define RRM_NEXT(r)	((r).startblock + (r).blockcount)
-/*
- * Find the next block where the refcount changes, given the next rmap we
- * looked at and the ones we're already tracking.
- */
-static inline int
-xrep_refc_next_edge(
-	struct xfarray		*rmap_bag,
-	struct xrep_refc_rmap	*next_rrm,
-	bool			next_valid,
-	xfs_agblock_t		*nbnop)
-{
-	struct xrep_refc_rmap	rrm;
-	xfarray_idx_t		array_cur = XFARRAY_CURSOR_INIT;
-	xfs_agblock_t		nbno = NULLAGBLOCK;
-	int			error;
-
-	if (next_valid)
-		nbno = next_rrm->startblock;
-
-	while ((error = xfarray_iter(rmap_bag, &array_cur, &rrm)) == 1)
-		nbno = min_t(xfs_agblock_t, nbno, RRM_NEXT(rrm));
-
-	if (error)
-		return error;
-
-	/*
-	 * We should have found /something/ because either next_rrm is the next
-	 * interesting rmap to look at after emitting this refcount extent, or
-	 * there are other rmaps in rmap_bag contributing to the current
-	 * sharing count.  But if something is seriously wrong, bail out.
-	 */
-	if (nbno == NULLAGBLOCK)
-		return -EFSCORRUPTED;
-
-	*nbnop = nbno;
-	return 0;
-}
-
 /*
  * Walk forward through the rmap btree to collect all rmaps starting at
  * @bno in @rmap_bag.  These represent the file(s) that share ownership of
@@ -405,22 +373,21 @@ xrep_refc_next_edge(
 static int
 xrep_refc_push_rmaps_at(
 	struct xrep_refc	*rr,
-	struct xfarray		*rmap_bag,
+	struct rcbag		*rcstack,
 	xfs_agblock_t		bno,
-	struct xrep_refc_rmap	*rrm,
-	bool			*have,
-	uint64_t		*stack_sz)
+	struct xfs_rmap_irec	*rmap,
+	bool			*have)
 {
 	struct xfs_scrub	*sc = rr->sc;
 	int			have_gt;
 	int			error;
 
-	while (*have && rrm->startblock == bno) {
-		error = xfarray_store_anywhere(rmap_bag, rrm);
+	while (*have && rmap->rm_startblock == bno) {
+		error = rcbag_add(rcstack, rr->sc->tp, rmap);
 		if (error)
 			return error;
-		(*stack_sz)++;
-		error = xrep_refc_walk_rmaps(rr, rrm, have);
+
+		error = xrep_refc_walk_rmaps(rr, rmap, have);
 		if (error)
 			return error;
 	}
@@ -441,12 +408,9 @@ STATIC int
 xrep_refc_find_refcounts(
 	struct xrep_refc	*rr)
 {
-	struct xrep_refc_rmap	rrm;
 	struct xfs_scrub	*sc = rr->sc;
-	struct xfarray		*rmap_bag;
-	char			*descr;
-	uint64_t		old_stack_sz;
-	uint64_t		stack_sz = 0;
+	struct rcbag		*rcstack;
+	uint64_t		old_stack_height;
 	xfs_agblock_t		sbno;
 	xfs_agblock_t		cbno;
 	xfs_agblock_t		nbno;
@@ -456,14 +420,11 @@ xrep_refc_find_refcounts(
 	xrep_ag_btcur_init(sc, &sc->sa);
 
 	/*
-	 * Set up a sparse array to store all the rmap records that we're
-	 * tracking to generate a reference count record.  If this exceeds
+	 * Set up a bag to store all the rmap records that we're tracking to
+	 * generate a reference count record.  If the size of the bag exceeds
 	 * MAXREFCOUNT, we clamp rc_refcount.
 	 */
-	descr = xchk_xfile_ag_descr(sc, "rmap record bag");
-	error = xfarray_create(descr, 0, sizeof(struct xrep_refc_rmap),
-			&rmap_bag);
-	kfree(descr);
+	error = rcbag_init(sc->mp, sc->xmbtp, &rcstack);
 	if (error)
 		goto out_cur;
 
@@ -474,62 +435,54 @@ xrep_refc_find_refcounts(
 
 	/* Process reverse mappings into refcount data. */
 	while (xfs_btree_has_more_records(sc->sa.rmap_cur)) {
+		struct xfs_rmap_irec	rmap;
+
 		/* Push all rmaps with pblk == sbno onto the stack */
-		error = xrep_refc_walk_rmaps(rr, &rrm, &have);
+		error = xrep_refc_walk_rmaps(rr, &rmap, &have);
 		if (error)
 			goto out_bag;
 		if (!have)
 			break;
-		sbno = cbno = rrm.startblock;
-		error = xrep_refc_push_rmaps_at(rr, rmap_bag, sbno,
-					&rrm, &have, &stack_sz);
+		sbno = cbno = rmap.rm_startblock;
+		error = xrep_refc_push_rmaps_at(rr, rcstack, sbno, &rmap,
+				&have);
 		if (error)
 			goto out_bag;
 
 		/* Set nbno to the bno of the next refcount change */
-		error = xrep_refc_next_edge(rmap_bag, &rrm, have, &nbno);
+		error = rcbag_next_edge(rcstack, sc->tp, &rmap, have, &nbno);
 		if (error)
 			goto out_bag;
 
 		ASSERT(nbno > sbno);
-		old_stack_sz = stack_sz;
+		old_stack_height = rcbag_count(rcstack);
 
 		/* While stack isn't empty... */
-		while (stack_sz) {
-			xfarray_idx_t	array_cur = XFARRAY_CURSOR_INIT;
-
+		while (rcbag_count(rcstack) > 0) {
 			/* Pop all rmaps that end at nbno */
-			while ((error = xfarray_iter(rmap_bag, &array_cur,
-								&rrm)) == 1) {
-				if (RRM_NEXT(rrm) != nbno)
-					continue;
-				error = xfarray_unset(rmap_bag, array_cur - 1);
-				if (error)
-					goto out_bag;
-				stack_sz--;
-			}
+			error = rcbag_remove_ending_at(rcstack, sc->tp, nbno);
 			if (error)
 				goto out_bag;
 
 			/* Push array items that start at nbno */
-			error = xrep_refc_walk_rmaps(rr, &rrm, &have);
+			error = xrep_refc_walk_rmaps(rr, &rmap, &have);
 			if (error)
 				goto out_bag;
 			if (have) {
-				error = xrep_refc_push_rmaps_at(rr, rmap_bag,
-						nbno, &rrm, &have, &stack_sz);
+				error = xrep_refc_push_rmaps_at(rr, rcstack,
+						nbno, &rmap, &have);
 				if (error)
 					goto out_bag;
 			}
 
 			/* Emit refcount if necessary */
 			ASSERT(nbno > cbno);
-			if (stack_sz != old_stack_sz) {
-				if (old_stack_sz > 1) {
+			if (rcbag_count(rcstack) != old_stack_height) {
+				if (old_stack_height > 1) {
 					error = xrep_refc_stash(rr,
 							XFS_REFC_DOMAIN_SHARED,
 							cbno, nbno - cbno,
-							old_stack_sz);
+							old_stack_height);
 					if (error)
 						goto out_bag;
 				}
@@ -537,13 +490,13 @@ xrep_refc_find_refcounts(
 			}
 
 			/* Stack empty, go find the next rmap */
-			if (stack_sz == 0)
+			if (rcbag_count(rcstack) == 0)
 				break;
-			old_stack_sz = stack_sz;
+			old_stack_height = rcbag_count(rcstack);
 			sbno = nbno;
 
 			/* Set nbno to the bno of the next refcount change */
-			error = xrep_refc_next_edge(rmap_bag, &rrm, have,
+			error = rcbag_next_edge(rcstack, sc->tp, &rmap, have,
 					&nbno);
 			if (error)
 				goto out_bag;
@@ -552,14 +505,13 @@ xrep_refc_find_refcounts(
 		}
 	}
 
-	ASSERT(stack_sz == 0);
+	ASSERT(rcbag_count(rcstack) == 0);
 out_bag:
-	xfarray_destroy(rmap_bag);
+	rcbag_free(&rcstack);
 out_cur:
 	xchk_ag_btcur_free(&sc->sa);
 	return error;
 }
-#undef RRM_NEXT
 
 /* Retrieve refcountbt data for bulk load. */
 STATIC int
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index dd1c89e8714ce..ce082d941459f 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -89,6 +89,7 @@ int xrep_reset_perag_resv(struct xfs_scrub *sc);
 int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
 int xrep_metadata_inode_forks(struct xfs_scrub *sc);
 int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
+int xrep_setup_ag_refcountbt(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -186,6 +187,7 @@ xrep_setup_nothing(
 }
 #define xrep_setup_ag_allocbt		xrep_setup_nothing
 #define xrep_setup_ag_rmapbt		xrep_setup_nothing
+#define xrep_setup_ag_refcountbt	xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 42f9a141e43b8..4b22c30ac97a4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -44,6 +44,7 @@
 #include "xfs_dahash_test.h"
 #include "xfs_rtbitmap.h"
 #include "scrub/stats.h"
+#include "scrub/rcbag_btree.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -2062,10 +2063,14 @@ xfs_init_caches(void)
 	if (error)
 		goto out_destroy_log_ticket_cache;
 
-	error = xfs_defer_init_item_caches();
+	error = rcbagbt_init_cur_cache();
 	if (error)
 		goto out_destroy_btree_cur_cache;
 
+	error = xfs_defer_init_item_caches();
+	if (error)
+		goto out_destroy_rcbagbt_cur_cache;
+
 	xfs_da_state_cache = kmem_cache_create("xfs_da_state",
 					      sizeof(struct xfs_da_state),
 					      0, 0, NULL);
@@ -2222,6 +2227,8 @@ xfs_init_caches(void)
 	kmem_cache_destroy(xfs_da_state_cache);
  out_destroy_defer_item_cache:
 	xfs_defer_destroy_item_caches();
+ out_destroy_rcbagbt_cur_cache:
+	rcbagbt_destroy_cur_cache();
  out_destroy_btree_cur_cache:
 	xfs_btree_destroy_cur_caches();
  out_destroy_log_ticket_cache:
@@ -2259,6 +2266,7 @@ xfs_destroy_caches(void)
 	kmem_cache_destroy(xfs_ifork_cache);
 	kmem_cache_destroy(xfs_da_state_cache);
 	xfs_defer_destroy_item_caches();
+	rcbagbt_destroy_cur_cache();
 	xfs_btree_destroy_cur_caches();
 	kmem_cache_destroy(xfs_log_ticket_cache);
 	kmem_cache_destroy(xfs_buf_cache);

