Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3736CC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiL3XrL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235783AbiL3XrE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:47:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A5F1E3C8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:47:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 015D761B98
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61058C433D2;
        Fri, 30 Dec 2022 23:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444022;
        bh=bpT+nh/rAgtto2D/iUviAK2HmSUwTvWtqbGGRtNz3K4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=plfgT1+Y8i5L/G5q/inq8VxTYe7fDcUylSPInrkoOuDF1rLEednfkJrsju7vIABc1
         jHEZc2HsYbfhyLbu+V2LulL6YgXgttbjEOaNtUrpTpXO30qXzgv3VGoRfa/H5FsJLW
         iz97fpO+KtX7FSP2Q+qaZNNo14SKiRNHgTm/n0kjY0AHgSAShPYeiQ07SlCk+CFLH4
         W+I5PYm70hwdDESa5iYNIx30zXTtWv5wJtyYU4uqlvh8ynMG5VycP2x+f3f2tmEJ3F
         SXwyAfEdINmB6wz0+pS1IN53n/PaYp8z2LyjZ9udrMe38etvgvYzc/yy8hM2mLqhuC
         JZuwgMUxK0fKw==
Subject: [PATCH 3/3] xfs: port refcount repair to the new refcount bag
 structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:38 -0800
Message-ID: <167243841832.698694.14087233028103345029.stgit@magnolia>
In-Reply-To: <167243841785.698694.3079531228988224092.stgit@magnolia>
References: <167243841785.698694.3079531228988224092.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Port the refcount record generating code to use the new refcount bag
data structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/refcount.c        |   16 +++-
 fs/xfs/scrub/refcount_repair.c |  155 +++++++++++++---------------------------
 fs/xfs/scrub/repair.h          |    2 +
 fs/xfs/xfs_super.c             |   10 ++-
 4 files changed, 76 insertions(+), 107 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 9d957d2df3e1..413885eca333 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -7,8 +7,11 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_trans.h"
+#include "xfs_ag.h"
 #include "xfs_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
@@ -16,9 +19,7 @@
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_ag.h"
+#include "scrub/repair.h"
 
 /*
  * Set us up to scrub reference count btrees.
@@ -29,6 +30,15 @@ xchk_setup_ag_refcountbt(
 {
 	if (xchk_need_fshook_drain(sc))
 		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
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
index 4bf48fbe5285..539548cdc65a 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -37,6 +37,7 @@
 #include "scrub/xfarray.h"
 #include "scrub/newbt.h"
 #include "scrub/reap.h"
+#include "scrub/rcbag.h"
 
 /*
  * Rebuilding the Reference Count Btree
@@ -97,12 +98,6 @@
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
@@ -122,6 +117,14 @@ struct xrep_refc {
 	xfs_extlen_t		btblocks;
 };
 
+/* Set us up to repair refcount btrees. */
+int
+xrep_setup_ag_refcountbt(
+	struct xfs_scrub	*sc)
+{
+	return xrep_setup_buftarg(sc, "refcount bag");
+}
+
 /* Check for any obvious conflicts with this shared/CoW staging extent. */
 STATIC int
 xrep_refc_check_ext(
@@ -223,10 +226,9 @@ xrep_refc_rmap_shareable(
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
@@ -250,7 +252,7 @@ xrep_refc_walk_rmaps(
 		if (!have_gt)
 			return 0;
 
-		error = xfs_rmap_get_rec(cur, &rmap, &have_gt);
+		error = xfs_rmap_get_rec(cur, rmap, &have_gt);
 		if (error)
 			return error;
 		if (XFS_IS_CORRUPT(mp, !have_gt)) {
@@ -258,23 +260,22 @@ xrep_refc_walk_rmaps(
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
@@ -356,45 +357,6 @@ xrep_refc_sort_records(
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
@@ -404,22 +366,21 @@ xrep_refc_next_edge(
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
@@ -440,11 +401,9 @@ STATIC int
 xrep_refc_find_refcounts(
 	struct xrep_refc	*rr)
 {
-	struct xrep_refc_rmap	rrm;
 	struct xfs_scrub	*sc = rr->sc;
-	struct xfarray		*rmap_bag;
-	uint64_t		old_stack_sz;
-	uint64_t		stack_sz = 0;
+	struct rcbag		*rcstack;
+	uint64_t		old_stack_height;
 	xfs_agblock_t		sbno;
 	xfs_agblock_t		cbno;
 	xfs_agblock_t		nbno;
@@ -454,12 +413,11 @@ xrep_refc_find_refcounts(
 	xrep_ag_btcur_init(sc, &sc->sa);
 
 	/*
-	 * Set up a sparse array to store all the rmap records that we're
-	 * tracking to generate a reference count record.  If this exceeds
+	 * Set up a bag to store all the rmap records that we're tracking to
+	 * generate a reference count record.  If the size of the bag exceeds
 	 * MAXREFCOUNT, we clamp rc_refcount.
 	 */
-	error = xfarray_create(sc->mp, "rmap bag", 0,
-			sizeof(struct xrep_refc_rmap), &rmap_bag);
+	error = rcbag_init(sc->mp, sc->xfile_buftarg, &rcstack);
 	if (error)
 		goto out_cur;
 
@@ -470,62 +428,54 @@ xrep_refc_find_refcounts(
 
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
@@ -533,13 +483,13 @@ xrep_refc_find_refcounts(
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
@@ -548,14 +498,13 @@ xrep_refc_find_refcounts(
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
index 34c601aad642..3b25f2fa629e 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -79,6 +79,7 @@ int xrep_reset_perag_resv(struct xfs_scrub *sc);
 int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
 int xrep_metadata_inode_forks(struct xfs_scrub *sc);
 int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
+int xrep_setup_ag_refcountbt(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -176,6 +177,7 @@ xrep_setup_nothing(
 }
 #define xrep_setup_ag_allocbt		xrep_setup_nothing
 #define xrep_setup_ag_rmapbt		xrep_setup_nothing
+#define xrep_setup_ag_refcountbt	xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8841947bdce7..a16d4d1b35d0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -41,6 +41,7 @@
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
 #include "xfs_iunlink_item.h"
+#include "scrub/rcbag_btree.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -1995,10 +1996,14 @@ xfs_init_caches(void)
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
@@ -2155,6 +2160,8 @@ xfs_init_caches(void)
 	kmem_cache_destroy(xfs_da_state_cache);
  out_destroy_defer_item_cache:
 	xfs_defer_destroy_item_caches();
+ out_destroy_rcbagbt_cur_cache:
+	rcbagbt_destroy_cur_cache();
  out_destroy_btree_cur_cache:
 	xfs_btree_destroy_cur_caches();
  out_destroy_log_ticket_cache:
@@ -2192,6 +2199,7 @@ xfs_destroy_caches(void)
 	kmem_cache_destroy(xfs_ifork_cache);
 	kmem_cache_destroy(xfs_da_state_cache);
 	xfs_defer_destroy_item_caches();
+	rcbagbt_destroy_cur_cache();
 	xfs_btree_destroy_cur_caches();
 	kmem_cache_destroy(xfs_log_ticket_cache);
 	kmem_cache_destroy(xfs_buf_cache);

