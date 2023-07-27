Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B4BC41513
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbjG0Wbk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjG0Wbj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:31:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FB62D64
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BC1961F3E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5502C433C8;
        Thu, 27 Jul 2023 22:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497095;
        bh=WcGuBghMB782UkS9QWEvcYpkaBGzzy5eievYs868qk4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=LiA7imTNiZtUqPoS81hOwcrzyfxZ88PLIUpsPNEqFtFMfnUFMaK09wWH3KMOzk9VE
         UId33E6trLnuyImsyPELcTHPgKiKkAmgnWlY8pbKff3hUdTz408MakTyKGX0X3LZXR
         7GTk9wJ7MM43kitHQlQx5c8/LWSynvKfmy7K7yw6wxWtJePSDajLn0YSlPihjS94qP
         sclZDnX1eMpZm40tBteAMbcxMKHoKocfFDMnNoAw+d77k0JFNTszvuc65dg+nhxYgU
         j1XhNNzW3GcSems7cnXj0BwKcQgEnJQlR+ATrzsLfxp6D5nu1MAIIJ/Kziaq1iLbJj
         8Ju2vjzZCbpxw==
Date:   Thu, 27 Jul 2023 15:31:35 -0700
Subject: [PATCH 5/5] xfs: repair refcount btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049625783.922264.12200288004432287462.stgit@frogsfrogsfrogs>
In-Reply-To: <169049625702.922264.5146998399930069330.stgit@frogsfrogsfrogs>
References: <169049625702.922264.5146998399930069330.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Reconstruct the refcount data from the rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_ag.h             |    1 
 fs/xfs/libxfs/xfs_btree.c          |   26 +
 fs/xfs/libxfs/xfs_btree.h          |    2 
 fs/xfs/libxfs/xfs_refcount.c       |   18 +
 fs/xfs/libxfs/xfs_refcount.h       |    2 
 fs/xfs/libxfs/xfs_refcount_btree.c |   13 +
 fs/xfs/scrub/refcount_repair.c     |  796 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h              |    2 
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/trace.h               |   22 +
 11 files changed, 867 insertions(+), 18 deletions(-)
 create mode 100644 fs/xfs/scrub/refcount_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7fed0e706cfa0..a6f708dc56cc2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -185,6 +185,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   ialloc_repair.o \
 				   newbt.o \
 				   reap.o \
+				   refcount_repair.o \
 				   repair.o \
 				   )
 endif
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 686f4eadd5743..616812911a23f 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -87,6 +87,7 @@ struct xfs_perag {
 	 * verifiers while rebuilding the AG btrees.
 	 */
 	uint8_t		pagf_alt_levels[XFS_BTNUM_AGF];
+	uint8_t		pagf_alt_refcount_level;
 #endif
 
 	spinlock_t	pag_state_lock;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index c100e92140be1..ea8d3659df208 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5212,3 +5212,29 @@ xfs_btree_destroy_cur_caches(void)
 	xfs_rmapbt_destroy_cur_cache();
 	xfs_refcountbt_destroy_cur_cache();
 }
+
+/* Move the btree cursor before the first record. */
+int
+xfs_btree_goto_left_edge(
+	struct xfs_btree_cur	*cur)
+{
+	int			stat = 0;
+	int			error;
+
+	memset(&cur->bc_rec, 0, sizeof(cur->bc_rec));
+	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, &stat);
+	if (error)
+		return error;
+	if (!stat)
+		return 0;
+
+	error = xfs_btree_decrement(cur, 0, &stat);
+	if (error)
+		return error;
+	if (stat != 0) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index e0875cec49392..d906324e25c86 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -738,4 +738,6 @@ xfs_btree_alloc_cursor(
 int __init xfs_btree_init_cur_caches(void);
 void xfs_btree_destroy_cur_caches(void);
 
+int xfs_btree_goto_left_edge(struct xfs_btree_cur *cur);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 646b3fa362ad0..8db7b6163e55f 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -120,14 +120,11 @@ xfs_refcount_btrec_to_irec(
 	irec->rc_refcount = be32_to_cpu(rec->refc.rc_refcount);
 }
 
-/* Simple checks for refcount records. */
-xfs_failaddr_t
-xfs_refcount_check_irec(
-	struct xfs_btree_cur		*cur,
+inline xfs_failaddr_t
+xfs_refcount_check_perag_irec(
+	struct xfs_perag		*pag,
 	const struct xfs_refcount_irec	*irec)
 {
-	struct xfs_perag		*pag = cur->bc_ag.pag;
-
 	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
 		return __this_address;
 
@@ -144,6 +141,15 @@ xfs_refcount_check_irec(
 	return NULL;
 }
 
+/* Simple checks for refcount records. */
+xfs_failaddr_t
+xfs_refcount_check_irec(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*irec)
+{
+	return xfs_refcount_check_perag_irec(cur->bc_ag.pag, irec);
+}
+
 static inline int
 xfs_refcount_complain_bad_rec(
 	struct xfs_btree_cur		*cur,
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 783cd89ca1951..2d6fecb258bb1 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -117,6 +117,8 @@ extern int xfs_refcount_has_records(struct xfs_btree_cur *cur,
 union xfs_btree_rec;
 extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
+xfs_failaddr_t xfs_refcount_check_perag_irec(struct xfs_perag *pag,
+		const struct xfs_refcount_irec *irec);
 xfs_failaddr_t xfs_refcount_check_irec(struct xfs_btree_cur *cur,
 		const struct xfs_refcount_irec *irec);
 extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 5c3987d8dc242..50fe789efc938 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -226,7 +226,18 @@ xfs_refcountbt_verify(
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && xfs_perag_initialised_agf(pag)) {
-		if (level >= pag->pagf_refcount_level)
+		unsigned int	maxlevel = pag->pagf_refcount_level;
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+		/*
+		 * Online repair could be rewriting the refcount btree, so
+		 * we'll validate against the larger of either tree while this
+		 * is going on.
+		 */
+		maxlevel = max_t(unsigned int, maxlevel,
+				pag->pagf_alt_refcount_level);
+#endif
+		if (level >= maxlevel)
 			return __this_address;
 	} else if (level >= mp->m_refc_maxlevels)
 		return __this_address;
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
new file mode 100644
index 0000000000000..23d0dacc1d15a
--- /dev/null
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -0,0 +1,796 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_btree_staging.h"
+#include "xfs_inode.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_error.h"
+#include "xfs_ag.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/newbt.h"
+#include "scrub/reap.h"
+
+/*
+ * Rebuilding the Reference Count Btree
+ * ====================================
+ *
+ * This algorithm is "borrowed" from xfs_repair.  Imagine the rmap
+ * entries as rectangles representing extents of physical blocks, and
+ * that the rectangles can be laid down to allow them to overlap each
+ * other; then we know that we must emit a refcnt btree entry wherever
+ * the amount of overlap changes, i.e. the emission stimulus is
+ * level-triggered:
+ *
+ *                 -    ---
+ *       --      ----- ----   ---        ------
+ * --   ----     ----------- ----     ---------
+ * -------------------------------- -----------
+ * ^ ^  ^^ ^^    ^ ^^ ^^^  ^^^^  ^ ^^ ^  ^     ^
+ * 2 1  23 21    3 43 234  2123  1 01 2  3     0
+ *
+ * For our purposes, a rmap is a tuple (startblock, len, fileoff, owner).
+ *
+ * Note that in the actual refcnt btree we don't store the refcount < 2
+ * cases because the bnobt tells us which blocks are free; single-use
+ * blocks aren't recorded in the bnobt or the refcntbt.  If the rmapbt
+ * supports storing multiple entries covering a given block we could
+ * theoretically dispense with the refcntbt and simply count rmaps, but
+ * that's inefficient in the (hot) write path, so we'll take the cost of
+ * the extra tree to save time.  Also there's no guarantee that rmap
+ * will be enabled.
+ *
+ * Given an array of rmaps sorted by physical block number, a starting
+ * physical block (sp), a bag to hold rmaps that cover sp, and the next
+ * physical block where the level changes (np), we can reconstruct the
+ * refcount btree as follows:
+ *
+ * While there are still unprocessed rmaps in the array,
+ *  - Set sp to the physical block (pblk) of the next unprocessed rmap.
+ *  - Add to the bag all rmaps in the array where startblock == sp.
+ *  - Set np to the physical block where the bag size will change.  This
+ *    is the minimum of (the pblk of the next unprocessed rmap) and
+ *    (startblock + len of each rmap in the bag).
+ *  - Record the bag size as old_bag_size.
+ *
+ *  - While the bag isn't empty,
+ *     - Remove from the bag all rmaps where startblock + len == np.
+ *     - Add to the bag all rmaps in the array where startblock == np.
+ *     - If the bag size isn't old_bag_size, store the refcount entry
+ *       (sp, np - sp, bag_size) in the refcnt btree.
+ *     - If the bag is empty, break out of the inner loop.
+ *     - Set old_bag_size to the bag size
+ *     - Set sp = np.
+ *     - Set np to the physical block where the bag size will change.
+ *       This is the minimum of (the pblk of the next unprocessed rmap)
+ *       and (startblock + len of each rmap in the bag).
+ *
+ * Like all the other repairers, we make a list of all the refcount
+ * records we need, then reinitialize the refcount btree root and
+ * insert all the records.
+ */
+
+/* The only parts of the rmap that we care about for computing refcounts. */
+struct xrep_refc_rmap {
+	xfs_agblock_t		startblock;
+	xfs_extlen_t		blockcount;
+} __packed;
+
+struct xrep_refc {
+	/* refcount extents */
+	struct xfarray		*refcount_records;
+
+	/* new refcountbt information */
+	struct xrep_newbt	new_btree;
+
+	/* old refcountbt blocks */
+	struct xagb_bitmap	old_refcountbt_blocks;
+
+	struct xfs_scrub	*sc;
+
+	/* get_records()'s position in the refcount record array. */
+	xfarray_idx_t		array_cur;
+
+	/* # of refcountbt blocks */
+	xfs_extlen_t		btblocks;
+};
+
+/* Check for any obvious conflicts with this shared/CoW staging extent. */
+STATIC int
+xrep_refc_check_ext(
+	struct xfs_scrub		*sc,
+	const struct xfs_refcount_irec	*rec)
+{
+	enum xbtree_recpacking		outcome;
+	int				error;
+
+	if (xfs_refcount_check_perag_irec(sc->sa.pag, rec) != NULL)
+		return -EFSCORRUPTED;
+
+	/* Make sure this isn't free space. */
+	error = xfs_alloc_has_records(sc->sa.bno_cur, rec->rc_startblock,
+			rec->rc_blockcount, &outcome);
+	if (error)
+		return error;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		return -EFSCORRUPTED;
+
+	/* Must not be an inode chunk. */
+	error = xfs_ialloc_has_inodes_at_extent(sc->sa.ino_cur,
+			rec->rc_startblock, rec->rc_blockcount, &outcome);
+	if (error)
+		return error;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/* Record a reference count extent. */
+STATIC int
+xrep_refc_stash(
+	struct xrep_refc		*rr,
+	enum xfs_refc_domain		domain,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len,
+	uint64_t			refcount)
+{
+	struct xfs_refcount_irec	irec = {
+		.rc_startblock		= agbno,
+		.rc_blockcount		= len,
+		.rc_domain		= domain,
+	};
+	struct xfs_scrub		*sc = rr->sc;
+	int				error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	irec.rc_refcount = min_t(uint64_t, MAXREFCOUNT, refcount);
+
+	error = xrep_refc_check_ext(rr->sc, &irec);
+	if (error)
+		return error;
+
+	trace_xrep_refc_found(sc->sa.pag, &irec);
+
+	return xfarray_append(rr->refcount_records, &irec);
+}
+
+/* Record a CoW staging extent. */
+STATIC int
+xrep_refc_stash_cow(
+	struct xrep_refc		*rr,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len)
+{
+	return xrep_refc_stash(rr, XFS_REFC_DOMAIN_COW, agbno, len, 1);
+}
+
+/* Decide if an rmap could describe a shared extent. */
+static inline bool
+xrep_refc_rmap_shareable(
+	struct xfs_mount		*mp,
+	const struct xfs_rmap_irec	*rmap)
+{
+	/* AG metadata are never sharable */
+	if (XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner))
+		return false;
+
+	/* Metadata in files are never shareable */
+	if (xfs_internal_inum(mp, rmap->rm_owner))
+		return false;
+
+	/* Metadata and unwritten file blocks are not shareable. */
+	if (rmap->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			      XFS_RMAP_UNWRITTEN))
+		return false;
+
+	return true;
+}
+
+/*
+ * Walk along the reverse mapping records until we find one that could describe
+ * a shared extent.
+ */
+STATIC int
+xrep_refc_walk_rmaps(
+	struct xrep_refc	*rr,
+	struct xrep_refc_rmap	*rrm,
+	bool			*have_rec)
+{
+	struct xfs_rmap_irec	rmap;
+	struct xfs_btree_cur	*cur = rr->sc->sa.rmap_cur;
+	struct xfs_mount	*mp = cur->bc_mp;
+	int			have_gt;
+	int			error = 0;
+
+	*have_rec = false;
+
+	/*
+	 * Loop through the remaining rmaps.  Remember CoW staging
+	 * extents and the refcountbt blocks from the old tree for later
+	 * disposal.  We can only share written data fork extents, so
+	 * keep looping until we find an rmap for one.
+	 */
+	do {
+		if (xchk_should_terminate(rr->sc, &error))
+			return error;
+
+		error = xfs_btree_increment(cur, 0, &have_gt);
+		if (error)
+			return error;
+		if (!have_gt)
+			return 0;
+
+		error = xfs_rmap_get_rec(cur, &rmap, &have_gt);
+		if (error)
+			return error;
+		if (XFS_IS_CORRUPT(mp, !have_gt))
+			return -EFSCORRUPTED;
+
+		if (rmap.rm_owner == XFS_RMAP_OWN_COW) {
+			error = xrep_refc_stash_cow(rr, rmap.rm_startblock,
+					rmap.rm_blockcount);
+			if (error)
+				return error;
+		} else if (rmap.rm_owner == XFS_RMAP_OWN_REFC) {
+			/* refcountbt block, dump it when we're done. */
+			rr->btblocks += rmap.rm_blockcount;
+			error = xagb_bitmap_set(&rr->old_refcountbt_blocks,
+					rmap.rm_startblock, rmap.rm_blockcount);
+			if (error)
+				return error;
+		}
+	} while (!xrep_refc_rmap_shareable(mp, &rmap));
+
+	rrm->startblock = rmap.rm_startblock;
+	rrm->blockcount = rmap.rm_blockcount;
+	*have_rec = true;
+	return 0;
+}
+
+static inline uint32_t
+xrep_refc_encode_startblock(
+	const struct xfs_refcount_irec	*irec)
+{
+	uint32_t			start;
+
+	start = irec->rc_startblock & ~XFS_REFC_COWFLAG;
+	if (irec->rc_domain == XFS_REFC_DOMAIN_COW)
+		start |= XFS_REFC_COWFLAG;
+
+	return start;
+}
+
+/* Sort in the same order as the ondisk records. */
+static int
+xrep_refc_extent_cmp(
+	const void			*a,
+	const void			*b)
+{
+	const struct xfs_refcount_irec	*ap = a;
+	const struct xfs_refcount_irec	*bp = b;
+	uint32_t			sa, sb;
+
+	sa = xrep_refc_encode_startblock(ap);
+	sb = xrep_refc_encode_startblock(bp);
+
+	if (sa > sb)
+		return 1;
+	if (sa < sb)
+		return -1;
+	return 0;
+}
+
+/*
+ * Sort the refcount extents by startblock or else the btree records will be in
+ * the wrong order.  Make sure the records do not overlap in physical space.
+ */
+STATIC int
+xrep_refc_sort_records(
+	struct xrep_refc		*rr)
+{
+	struct xfs_refcount_irec	irec;
+	xfarray_idx_t			cur;
+	enum xfs_refc_domain		dom = XFS_REFC_DOMAIN_SHARED;
+	xfs_agblock_t			next_agbno = 0;
+	int				error;
+
+	error = xfarray_sort(rr->refcount_records, xrep_refc_extent_cmp,
+			XFARRAY_SORT_KILLABLE);
+	if (error)
+		return error;
+
+	foreach_xfarray_idx(rr->refcount_records, cur) {
+		if (xchk_should_terminate(rr->sc, &error))
+			return error;
+
+		error = xfarray_load(rr->refcount_records, cur, &irec);
+		if (error)
+			return error;
+
+		if (dom == XFS_REFC_DOMAIN_SHARED &&
+		    irec.rc_domain == XFS_REFC_DOMAIN_COW) {
+			dom = irec.rc_domain;
+			next_agbno = 0;
+		}
+
+		if (dom != irec.rc_domain)
+			return -EFSCORRUPTED;
+		if (irec.rc_startblock < next_agbno)
+			return -EFSCORRUPTED;
+
+		next_agbno = irec.rc_startblock + irec.rc_blockcount;
+	}
+
+	return error;
+}
+
+#define RRM_NEXT(r)	((r).startblock + (r).blockcount)
+/*
+ * Find the next block where the refcount changes, given the next rmap we
+ * looked at and the ones we're already tracking.
+ */
+static inline int
+xrep_refc_next_edge(
+	struct xfarray		*rmap_bag,
+	struct xrep_refc_rmap	*next_rrm,
+	bool			next_valid,
+	xfs_agblock_t		*nbnop)
+{
+	struct xrep_refc_rmap	rrm;
+	xfarray_idx_t		array_cur = XFARRAY_CURSOR_INIT;
+	xfs_agblock_t		nbno = NULLAGBLOCK;
+	int			error;
+
+	if (next_valid)
+		nbno = next_rrm->startblock;
+
+	while ((error = xfarray_iter(rmap_bag, &array_cur, &rrm)) == 1)
+		nbno = min_t(xfs_agblock_t, nbno, RRM_NEXT(rrm));
+
+	if (error)
+		return error;
+
+	/*
+	 * We should have found /something/ because either next_rrm is the next
+	 * interesting rmap to look at after emitting this refcount extent, or
+	 * there are other rmaps in rmap_bag contributing to the current
+	 * sharing count.  But if something is seriously wrong, bail out.
+	 */
+	if (nbno == NULLAGBLOCK)
+		return -EFSCORRUPTED;
+
+	*nbnop = nbno;
+	return 0;
+}
+
+/*
+ * Walk forward through the rmap btree to collect all rmaps starting at
+ * @bno in @rmap_bag.  These represent the file(s) that share ownership of
+ * the current block.  Upon return, the rmap cursor points to the last record
+ * satisfying the startblock constraint.
+ */
+static int
+xrep_refc_push_rmaps_at(
+	struct xrep_refc	*rr,
+	struct xfarray		*rmap_bag,
+	xfs_agblock_t		bno,
+	struct xrep_refc_rmap	*rrm,
+	bool			*have,
+	uint64_t		*stack_sz)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	int			have_gt;
+	int			error;
+
+	while (*have && rrm->startblock == bno) {
+		error = xfarray_store_anywhere(rmap_bag, rrm);
+		if (error)
+			return error;
+		(*stack_sz)++;
+		error = xrep_refc_walk_rmaps(rr, rrm, have);
+		if (error)
+			return error;
+	}
+
+	error = xfs_btree_decrement(sc->sa.rmap_cur, 0, &have_gt);
+	if (error)
+		return error;
+	if (XFS_IS_CORRUPT(sc->mp, !have_gt))
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/* Iterate all the rmap records to generate reference count data. */
+STATIC int
+xrep_refc_find_refcounts(
+	struct xrep_refc	*rr)
+{
+	struct xrep_refc_rmap	rrm;
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfarray		*rmap_bag;
+	char			*descr;
+	uint64_t		old_stack_sz;
+	uint64_t		stack_sz = 0;
+	xfs_agblock_t		sbno;
+	xfs_agblock_t		cbno;
+	xfs_agblock_t		nbno;
+	bool			have;
+	int			error;
+
+	xrep_ag_btcur_init(sc, &sc->sa);
+
+	/*
+	 * Set up a sparse array to store all the rmap records that we're
+	 * tracking to generate a reference count record.  If this exceeds
+	 * MAXREFCOUNT, we clamp rc_refcount.
+	 */
+	descr = xchk_xfile_ag_descr(sc, "rmap record bag");
+	error = xfarray_create(descr, 0, sizeof(struct xrep_refc_rmap),
+			&rmap_bag);
+	kfree(descr);
+	if (error)
+		goto out_cur;
+
+	/* Start the rmapbt cursor to the left of all records. */
+	error = xfs_btree_goto_left_edge(sc->sa.rmap_cur);
+	if (error)
+		goto out_bag;
+
+	/* Process reverse mappings into refcount data. */
+	while (xfs_btree_has_more_records(sc->sa.rmap_cur)) {
+		/* Push all rmaps with pblk == sbno onto the stack */
+		error = xrep_refc_walk_rmaps(rr, &rrm, &have);
+		if (error)
+			goto out_bag;
+		if (!have)
+			break;
+		sbno = cbno = rrm.startblock;
+		error = xrep_refc_push_rmaps_at(rr, rmap_bag, sbno,
+					&rrm, &have, &stack_sz);
+		if (error)
+			goto out_bag;
+
+		/* Set nbno to the bno of the next refcount change */
+		error = xrep_refc_next_edge(rmap_bag, &rrm, have, &nbno);
+		if (error)
+			goto out_bag;
+
+		ASSERT(nbno > sbno);
+		old_stack_sz = stack_sz;
+
+		/* While stack isn't empty... */
+		while (stack_sz) {
+			xfarray_idx_t	array_cur = XFARRAY_CURSOR_INIT;
+
+			/* Pop all rmaps that end at nbno */
+			while ((error = xfarray_iter(rmap_bag, &array_cur,
+								&rrm)) == 1) {
+				if (RRM_NEXT(rrm) != nbno)
+					continue;
+				error = xfarray_unset(rmap_bag, array_cur - 1);
+				if (error)
+					goto out_bag;
+				stack_sz--;
+			}
+			if (error)
+				goto out_bag;
+
+			/* Push array items that start at nbno */
+			error = xrep_refc_walk_rmaps(rr, &rrm, &have);
+			if (error)
+				goto out_bag;
+			if (have) {
+				error = xrep_refc_push_rmaps_at(rr, rmap_bag,
+						nbno, &rrm, &have, &stack_sz);
+				if (error)
+					goto out_bag;
+			}
+
+			/* Emit refcount if necessary */
+			ASSERT(nbno > cbno);
+			if (stack_sz != old_stack_sz) {
+				if (old_stack_sz > 1) {
+					error = xrep_refc_stash(rr,
+							XFS_REFC_DOMAIN_SHARED,
+							cbno, nbno - cbno,
+							old_stack_sz);
+					if (error)
+						goto out_bag;
+				}
+				cbno = nbno;
+			}
+
+			/* Stack empty, go find the next rmap */
+			if (stack_sz == 0)
+				break;
+			old_stack_sz = stack_sz;
+			sbno = nbno;
+
+			/* Set nbno to the bno of the next refcount change */
+			error = xrep_refc_next_edge(rmap_bag, &rrm, have,
+					&nbno);
+			if (error)
+				goto out_bag;
+
+			ASSERT(nbno > sbno);
+		}
+	}
+
+	ASSERT(stack_sz == 0);
+out_bag:
+	xfarray_destroy(rmap_bag);
+out_cur:
+	xchk_ag_btcur_free(&sc->sa);
+	return error;
+}
+#undef RRM_NEXT
+
+/* Retrieve refcountbt data for bulk load. */
+STATIC int
+xrep_refc_get_records(
+	struct xfs_btree_cur		*cur,
+	unsigned int			idx,
+	struct xfs_btree_block		*block,
+	unsigned int			nr_wanted,
+	void				*priv)
+{
+	struct xfs_refcount_irec	*irec = &cur->bc_rec.rc;
+	struct xrep_refc		*rr = priv;
+	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
+	int				error;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		error = xfarray_load(rr->refcount_records, rr->array_cur++,
+				irec);
+		if (error)
+			return error;
+
+		block_rec = xfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+STATIC int
+xrep_refc_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_refc        *rr = priv;
+	int			error;
+
+	error = xrep_newbt_relog_autoreap(&rr->new_btree);
+	if (error)
+		return error;
+
+	return xrep_newbt_claim_block(cur, &rr->new_btree, ptr);
+}
+
+/* Update the AGF counters. */
+STATIC int
+xrep_refc_reset_counters(
+	struct xrep_refc	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_perag	*pag = sc->sa.pag;
+
+	/*
+	 * After we commit the new btree to disk, it is possible that the
+	 * process to reap the old btree blocks will race with the AIL trying
+	 * to checkpoint the old btree blocks into the filesystem.  If the new
+	 * tree is shorter than the old one, the refcountbt write verifier will
+	 * fail and the AIL will shut down the filesystem.
+	 *
+	 * To avoid this, save the old incore btree height values as the alt
+	 * height values before re-initializing the perag info from the updated
+	 * AGF to capture all the new values.
+	 */
+	pag->pagf_alt_refcount_level = pag->pagf_refcount_level;
+
+	/* Reinitialize with the values we just logged. */
+	return xrep_reinit_pagf(sc);
+}
+
+/*
+ * Use the collected refcount information to stage a new refcount btree.  If
+ * this is successful we'll return with the new btree root information logged
+ * to the repair transaction but not yet committed.
+ */
+STATIC int
+xrep_refc_build_new_tree(
+	struct xrep_refc	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_btree_cur	*refc_cur;
+	struct xfs_perag	*pag = sc->sa.pag;
+	xfs_fsblock_t		fsbno;
+	int			error;
+
+	error = xrep_refc_sort_records(rr);
+	if (error)
+		return error;
+
+	/*
+	 * Prepare to construct the new btree by reserving disk space for the
+	 * new btree and setting up all the accounting information we'll need
+	 * to root the new btree while it's under construction and before we
+	 * attach it to the AG header.
+	 */
+	fsbno = XFS_AGB_TO_FSB(sc->mp, pag->pag_agno, xfs_refc_block(sc->mp));
+	xrep_newbt_init_ag(&rr->new_btree, sc, &XFS_RMAP_OINFO_REFC, fsbno,
+			XFS_AG_RESV_METADATA);
+	rr->new_btree.bload.get_records = xrep_refc_get_records;
+	rr->new_btree.bload.claim_block = xrep_refc_claim_block;
+
+	/* Compute how many blocks we'll need. */
+	refc_cur = xfs_refcountbt_stage_cursor(sc->mp, &rr->new_btree.afake,
+			pag);
+	error = xfs_btree_bload_compute_geometry(refc_cur,
+			&rr->new_btree.bload,
+			xfarray_length(rr->refcount_records));
+	if (error)
+		goto err_cur;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto err_cur;
+
+	/* Reserve the space we'll need for the new btree. */
+	error = xrep_newbt_alloc_blocks(&rr->new_btree,
+			rr->new_btree.bload.nr_blocks);
+	if (error)
+		goto err_cur;
+
+	/*
+	 * Due to btree slack factors, it's possible for a new btree to be one
+	 * level taller than the old btree.  Update the incore btree height so
+	 * that we don't trip the verifiers when writing the new btree blocks
+	 * to disk.
+	 */
+	pag->pagf_alt_refcount_level = rr->new_btree.bload.btree_height;
+
+	/* Add all observed refcount records. */
+	rr->array_cur = XFARRAY_CURSOR_INIT;
+	error = xfs_btree_bload(refc_cur, &rr->new_btree.bload, rr);
+	if (error)
+		goto err_level;
+
+	/*
+	 * Install the new btree in the AG header.  After this point the old
+	 * btree is no longer accessible and the new tree is live.
+	 */
+	xfs_refcountbt_commit_staged_btree(refc_cur, sc->tp, sc->sa.agf_bp);
+	xfs_btree_del_cursor(refc_cur, 0);
+
+	/* Reset the AGF counters now that we've changed the btree shape. */
+	error = xrep_refc_reset_counters(rr);
+	if (error)
+		goto err_newbt;
+
+	/* Dispose of any unused blocks and the accounting information. */
+	error = xrep_newbt_commit(&rr->new_btree);
+	if (error)
+		return error;
+
+	return xrep_roll_ag_trans(sc);
+
+err_level:
+	pag->pagf_alt_refcount_level = 0;
+err_cur:
+	xfs_btree_del_cursor(refc_cur, error);
+err_newbt:
+	xrep_newbt_cancel(&rr->new_btree);
+	return error;
+}
+
+/*
+ * Now that we've logged the roots of the new btrees, invalidate all of the
+ * old blocks and free them.
+ */
+STATIC int
+xrep_refc_remove_old_tree(
+	struct xrep_refc	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_perag	*pag = sc->sa.pag;
+	int			error;
+
+	/* Free the old refcountbt blocks if they're not in use. */
+	error = xrep_reap_agblocks(sc, &rr->old_refcountbt_blocks,
+			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA);
+	if (error)
+		return error;
+
+	/*
+	 * Now that we've zapped all the old refcountbt blocks we can turn off
+	 * the alternate height mechanism and reset the per-AG space
+	 * reservations.
+	 */
+	pag->pagf_alt_refcount_level = 0;
+	sc->flags |= XREP_RESET_PERAG_RESV;
+	return 0;
+}
+
+/* Rebuild the refcount btree. */
+int
+xrep_refcountbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_refc	*rr;
+	struct xfs_mount	*mp = sc->mp;
+	char			*descr;
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_has_rmapbt(mp))
+		return -EOPNOTSUPP;
+
+	rr = kzalloc(sizeof(struct xrep_refc), XCHK_GFP_FLAGS);
+	if (!rr)
+		return -ENOMEM;
+	rr->sc = sc;
+
+	/* Set up enough storage to handle one refcount record per block. */
+	descr = xchk_xfile_ag_descr(sc, "reference count records");
+	error = xfarray_create(descr, mp->m_sb.sb_agblocks,
+			sizeof(struct xfs_refcount_irec),
+			&rr->refcount_records);
+	kfree(descr);
+	if (error)
+		goto out_rr;
+
+	/* Collect all reference counts. */
+	xagb_bitmap_init(&rr->old_refcountbt_blocks);
+	error = xrep_refc_find_refcounts(rr);
+	if (error)
+		goto out_bitmap;
+
+	/* Rebuild the refcount information. */
+	error = xrep_refc_build_new_tree(rr);
+	if (error)
+		goto out_bitmap;
+
+	/* Kill the old tree. */
+	error = xrep_refc_remove_old_tree(rr);
+
+out_bitmap:
+	xagb_bitmap_destroy(&rr->old_refcountbt_blocks);
+	xfarray_destroy(rr->refcount_records);
+out_rr:
+	kfree(rr);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 3ff5e37316685..42325305d29d9 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -73,6 +73,7 @@ int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
 int xrep_allocbt(struct xfs_scrub *sc);
 int xrep_iallocbt(struct xfs_scrub *sc);
+int xrep_refcountbt(struct xfs_scrub *sc);
 
 int xrep_reinit_pagf(struct xfs_scrub *sc);
 int xrep_reinit_pagi(struct xfs_scrub *sc);
@@ -126,6 +127,7 @@ xrep_setup_nothing(
 #define xrep_agi			xrep_notsupported
 #define xrep_allocbt			xrep_notsupported
 #define xrep_iallocbt			xrep_notsupported
+#define xrep_refcountbt			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 57f2db883792e..71aee7e3dd43a 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -276,7 +276,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_ag_refcountbt,
 		.scrub	= xchk_refcountbt,
 		.has	= xfs_has_reflink,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_refcountbt,
 	},
 	[XFS_SCRUB_TYPE_INODE] = {	/* inode record */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 79d1316b288ed..358c7ddbf14e2 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1205,27 +1205,29 @@ TRACE_EVENT(xrep_ibt_found,
 		  __entry->freemask)
 )
 
-TRACE_EVENT(xrep_refcount_extent_fn,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 struct xfs_refcount_irec *irec),
-	TP_ARGS(mp, agno, irec),
+TRACE_EVENT(xrep_refc_found,
+	TP_PROTO(struct xfs_perag *pag, const struct xfs_refcount_irec *rec),
+	TP_ARGS(pag, rec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_refc_domain, domain)
 		__field(xfs_agblock_t, startblock)
 		__field(xfs_extlen_t, blockcount)
 		__field(xfs_nlink_t, refcount)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->startblock = irec->rc_startblock;
-		__entry->blockcount = irec->rc_blockcount;
-		__entry->refcount = irec->rc_refcount;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->domain = rec->rc_domain;
+		__entry->startblock = rec->rc_startblock;
+		__entry->blockcount = rec->rc_blockcount;
+		__entry->refcount = rec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
+		  __print_symbolic(__entry->domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->startblock,
 		  __entry->blockcount,
 		  __entry->refcount)

