Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB97F9C3
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgyZFOw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1CFC433C7;
	Sun, 31 Dec 2023 21:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059700;
	bh=2Y+pKHnKVaUKglU8PLyDOKArqXAIV7IgaahFzp9X51c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VgyZFOw/JOWdQw6fUOdy7A7N6EwZm6LiY6F+c3lw7kj1w/0yXl1Uol+yhBVD/wLVz
	 23GOUqeRIiXklyRUCB75wccPiY2YF2RiYh661cIqZoaeGatklPTUfq8p2dof6fw4qP
	 RsOqvflHnb6UC//WKu10g+nxXE3Fs7/VDZenbczlzMwHqj+PPR1KstE60oWF8nvAvO
	 oKdzaYfh/3T6sYl4oYIfLNy7xPLwb4t3adN8FHDoi0yFx2mUqRQ6l3LZC4Ozd+zJFt
	 WtBEdafWHb+becF27nVvAkXdBrPh0HGz5x3GnWJqgoG0hJOKulBZs0HoCkAqvCalXx
	 VP8S7y++fR72A==
Date: Sun, 31 Dec 2023 13:54:59 -0800
Subject: [PATCH 40/44] xfs: online repair of the realtime refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852223.1766284.15728102213006370259.stgit@frogsfrogsfrogs>
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

Port the data device's refcount btree repair code to the realtime
refcount btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/scrub/bmap_repair.c       |    2 
 fs/xfs/scrub/repair.c            |   20 +
 fs/xfs/scrub/repair.h            |    7 
 fs/xfs/scrub/rtrefcount.c        |    9 
 fs/xfs/scrub/rtrefcount_repair.c |  781 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtrmap_repair.c     |    2 
 fs/xfs/scrub/scrub.c             |    2 
 fs/xfs/scrub/trace.h             |   31 ++
 9 files changed, 847 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/scrub/rtrefcount_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 4d4f340d904fc..a779030fd91db 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -237,6 +237,7 @@ xfs-y				+= $(addprefix scrub/, \
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rgsuper_repair.o \
 				   rtbitmap_repair.o \
+				   rtrefcount_repair.o \
 				   rtrmap_repair.o \
 				   rtsummary_repair.o \
 				   )
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 26dc04923944b..98618821ad975 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -397,7 +397,7 @@ xrep_bmap_check_rtfork_rmap(
 	/* Make sure this isn't free space. */
 	rtbno = xfs_rgbno_to_rtb(sc->mp, cur->bc_ino.rtg->rtg_rgno,
 			rec->rm_startblock);
-	return xrep_require_rtext_inuse(sc, rtbno, rec->rm_blockcount);
+	return xrep_require_rtext_inuse(sc, rtbno, rec->rm_blockcount, false);
 }
 
 /* Record realtime extents that belong to this inode's fork. */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index fdd12933fd47f..72aa1e522910b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1039,21 +1039,31 @@ xrep_rtgroup_init(
 	return 0;
 }
 
-/* Ensure that all rt blocks in the given range are not marked free. */
+/*
+ * Ensure that all rt blocks in the given range are not marked free.  If
+ * @must_align is true, then both ends must be aligned to a rt extent.
+ */
 int
 xrep_require_rtext_inuse(
 	struct xfs_scrub	*sc,
 	xfs_rtblock_t		rtbno,
-	xfs_filblks_t		len)
+	xfs_filblks_t		len,
+	bool			must_align)
 {
 	struct xfs_mount	*mp = sc->mp;
 	xfs_rtxnum_t		startrtx;
 	xfs_rtxnum_t		endrtx;
+	xfs_extlen_t		mod;
 	bool			is_free = false;
 	int			error;
 
-	startrtx = xfs_rtb_to_rtx(mp, rtbno);
-	endrtx = xfs_rtb_to_rtx(mp, rtbno + len - 1);
+	startrtx = xfs_rtb_to_rtxrem(mp, rtbno, &mod);
+	if (must_align && mod != 0)
+		return -EFSCORRUPTED;
+
+	endrtx = xfs_rtb_to_rtxrem(mp, rtbno + len - 1, &mod);
+	if (must_align && mod != mp->m_sb.sb_rextsize - 1)
+		return -EFSCORRUPTED;
 
 	error = xfs_rtalloc_extent_is_free(mp, sc->tp, startrtx,
 			endrtx - startrtx + 1, &is_free);
@@ -1341,6 +1351,8 @@ xrep_is_rtmeta_ino(
 	/* Newer rt metadata files are not guaranteed to exist */
 	if (rtg->rtg_rmapip && ino == rtg->rtg_rmapip->i_ino)
 		return true;
+	if (rtg->rtg_refcountip && ino == rtg->rtg_refcountip->i_ino)
+		return true;
 
 	return false;
 }
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 61c6bc31a266b..969317d429db6 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -98,6 +98,7 @@ int xrep_setup_nlinks(struct xfs_scrub *sc);
 int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *resblks);
 int xrep_setup_dirtree(struct xfs_scrub *sc);
 int xrep_setup_rtrmapbt(struct xfs_scrub *sc);
+int xrep_setup_rtrefcountbt(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -113,7 +114,7 @@ int xrep_rtgroup_init(struct xfs_scrub *sc, struct xfs_rtgroup *rtg,
 		struct xchk_rt *sr, unsigned int rtglock_flags);
 void xrep_rtgroup_btcur_init(struct xfs_scrub *sc, struct xchk_rt *sr);
 int xrep_require_rtext_inuse(struct xfs_scrub *sc, xfs_rtblock_t rtbno,
-		xfs_filblks_t len);
+		xfs_filblks_t len, bool must_align);
 xfs_extlen_t xrep_calc_rtgroup_resblks(struct xfs_scrub *sc);
 #else
 # define xrep_rtgroup_init(sc, rtg, sr, lockflags)	(-ENOSYS)
@@ -160,12 +161,14 @@ int xrep_rtsummary(struct xfs_scrub *sc);
 int xrep_rgsuperblock(struct xfs_scrub *sc);
 int xrep_rgbitmap(struct xfs_scrub *sc);
 int xrep_rtrmapbt(struct xfs_scrub *sc);
+int xrep_rtrefcountbt(struct xfs_scrub *sc);
 #else
 # define xrep_rtbitmap			xrep_notsupported
 # define xrep_rtsummary			xrep_notsupported
 # define xrep_rgsuperblock		xrep_notsupported
 # define xrep_rgbitmap			xrep_notsupported
 # define xrep_rtrmapbt			xrep_notsupported
+# define xrep_rtrefcountbt		xrep_notsupported
 #endif /* CONFIG_XFS_RT */
 
 #ifdef CONFIG_XFS_QUOTA
@@ -239,6 +242,7 @@ xrep_setup_nothing(
 #define xrep_setup_dirtree		xrep_setup_nothing
 #define xrep_setup_metapath		xrep_setup_nothing
 #define xrep_setup_rtrmapbt		xrep_setup_nothing
+#define xrep_setup_rtrefcountbt		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
@@ -278,6 +282,7 @@ static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_rgsuperblock		xrep_notsupported
 #define xrep_rgbitmap			xrep_notsupported
 #define xrep_rtrmapbt			xrep_notsupported
+#define xrep_rtrefcountbt		xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 058a0ea18e09b..8924ad8b680f0 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -7,8 +7,10 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
+#include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_trans.h"
 #include "xfs_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
@@ -21,6 +23,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
+#include "scrub/repair.h"
 
 /* Set us up with the realtime refcount metadata locked. */
 int
@@ -34,6 +37,12 @@ xchk_setup_rtrefcountbt(
 	if (xchk_need_intent_drain(sc))
 		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
 
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_rtrefcountbt(sc);
+		if (error)
+			return error;
+	}
+
 	rtg = xfs_rtgroup_get(mp, sc->sm->sm_agno);
 	if (!rtg)
 		return -ENOENT;
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
new file mode 100644
index 0000000000000..3034ca88be8b4
--- /dev/null
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -0,0 +1,781 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
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
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_rtrefcount_btree.h"
+#include "xfs_error.h"
+#include "xfs_health.h"
+#include "xfs_inode.h"
+#include "xfs_quota.h"
+#include "xfs_rtalloc.h"
+#include "xfs_ag.h"
+#include "xfs_rtgroup.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/fsb_bitmap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/newbt.h"
+#include "scrub/reap.h"
+#include "scrub/rcbag.h"
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
+ * rt refcount btree as follows:
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
+ * records we need, then reinitialize the rt refcount btree root and
+ * insert all the records.
+ */
+
+struct xrep_rtrefc {
+	/* refcount extents */
+	struct xfarray		*refcount_records;
+
+	/* new refcountbt information */
+	struct xrep_newbt	new_btree;
+
+	/* old refcountbt blocks */
+	struct xfsb_bitmap	old_rtrefcountbt_blocks;
+
+	struct xfs_scrub	*sc;
+
+	/* get_records()'s position in the rt refcount record array. */
+	xfarray_idx_t		array_cur;
+
+	/* # of refcountbt blocks */
+	xfs_filblks_t		btblocks;
+};
+
+/* Set us up to repair refcount btrees. */
+int
+xrep_setup_rtrefcountbt(
+	struct xfs_scrub	*sc)
+{
+	char			*descr;
+	int			error;
+
+	descr = xchk_xfile_ag_descr(sc, "rmap record bag");
+	error = xrep_setup_buftarg(sc, descr);
+	kfree(descr);
+	return error;
+}
+
+/* Check for any obvious conflicts with this shared/CoW staging extent. */
+STATIC int
+xrep_rtrefc_check_ext(
+	struct xfs_scrub		*sc,
+	const struct xfs_refcount_irec	*rec)
+{
+	xfs_rtblock_t			rtbno;
+
+	if (xfs_rtrefcount_check_irec(sc->sr.rtg, rec) != NULL)
+		return -EFSCORRUPTED;
+
+	/* Make sure this isn't free space or misaligned. */
+	rtbno = xfs_rgbno_to_rtb(sc->mp, sc->sr.rtg->rtg_rgno,
+			rec->rc_startblock);
+	return xrep_require_rtext_inuse(sc, rtbno, rec->rc_blockcount, true);
+}
+
+/* Record a reference count extent. */
+STATIC int
+xrep_rtrefc_stash(
+	struct xrep_rtrefc		*rr,
+	enum xfs_refc_domain		domain,
+	xfs_rgblock_t			bno,
+	xfs_extlen_t			len,
+	uint64_t			refcount)
+{
+	struct xfs_refcount_irec	irec = {
+		.rc_startblock		= bno,
+		.rc_blockcount		= len,
+		.rc_refcount		= refcount,
+		.rc_domain		= domain,
+	};
+	int				error = 0;
+
+	if (xchk_should_terminate(rr->sc, &error))
+		return error;
+
+	irec.rc_refcount = min_t(uint64_t, XFS_REFC_REFCOUNT_MAX, refcount);
+
+	error = xrep_rtrefc_check_ext(rr->sc, &irec);
+	if (error)
+		return error;
+
+	trace_xrep_rtrefc_found(rr->sc->sr.rtg, &irec);
+
+	return xfarray_append(rr->refcount_records, &irec);
+}
+
+/* Record a CoW staging extent. */
+STATIC int
+xrep_rtrefc_stash_cow(
+	struct xrep_rtrefc		*rr,
+	xfs_rgblock_t			bno,
+	xfs_extlen_t			len)
+{
+	return xrep_rtrefc_stash(rr, XFS_REFC_DOMAIN_COW, bno, len, 1);
+}
+
+/* Decide if an rmap could describe a shared extent. */
+static inline bool
+xrep_rtrefc_rmap_shareable(
+	const struct xfs_rmap_irec	*rmap)
+{
+	/* rt metadata are never sharable */
+	if (XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner))
+		return false;
+
+	/* Unwritten file blocks are not shareable. */
+	if (rmap->rm_flags & XFS_RMAP_UNWRITTEN)
+		return false;
+
+	return true;
+}
+
+/* Grab the next (abbreviated) rmap record from the rmapbt. */
+STATIC int
+xrep_rtrefc_walk_rmaps(
+	struct xrep_rtrefc	*rr,
+	struct xfs_rmap_irec	*rmap,
+	bool			*have_rec)
+{
+	struct xfs_btree_cur	*cur = rr->sc->sr.rmap_cur;
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
+		error = xfs_rmap_get_rec(cur, rmap, &have_gt);
+		if (error)
+			return error;
+		if (XFS_IS_CORRUPT(mp, !have_gt)) {
+			xfs_btree_mark_sick(cur);
+			return -EFSCORRUPTED;
+		}
+
+		if (rmap->rm_owner == XFS_RMAP_OWN_COW) {
+			error = xrep_rtrefc_stash_cow(rr, rmap->rm_startblock,
+					rmap->rm_blockcount);
+			if (error)
+				return error;
+		} else if (xfs_internal_inum(mp, rmap->rm_owner) ||
+			   (rmap->rm_flags & (XFS_RMAP_ATTR_FORK |
+					      XFS_RMAP_BMBT_BLOCK))) {
+			xfs_btree_mark_sick(cur);
+			return -EFSCORRUPTED;
+		}
+	} while (!xrep_rtrefc_rmap_shareable(rmap));
+
+	*have_rec = true;
+	return 0;
+}
+
+static inline uint32_t
+xrep_rtrefc_encode_startblock(
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
+/*
+ * Compare two refcount records.  We want to sort in order of increasing block
+ * number.
+ */
+static int
+xrep_rtrefc_extent_cmp(
+	const void			*a,
+	const void			*b)
+{
+	const struct xfs_refcount_irec	*ap = a;
+	const struct xfs_refcount_irec	*bp = b;
+	uint32_t			sa, sb;
+
+	sa = xrep_rtrefc_encode_startblock(ap);
+	sb = xrep_rtrefc_encode_startblock(bp);
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
+xrep_rtrefc_sort_records(
+	struct xrep_rtrefc		*rr)
+{
+	struct xfs_refcount_irec	irec;
+	xfarray_idx_t			cur;
+	enum xfs_refc_domain		dom = XFS_REFC_DOMAIN_SHARED;
+	xfs_rgblock_t			next_rgbno = 0;
+	int				error;
+
+	error = xfarray_sort(rr->refcount_records, xrep_rtrefc_extent_cmp,
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
+			next_rgbno = 0;
+		}
+
+		if (dom != irec.rc_domain)
+			return -EFSCORRUPTED;
+		if (irec.rc_startblock < next_rgbno)
+			return -EFSCORRUPTED;
+
+		next_rgbno = irec.rc_startblock + irec.rc_blockcount;
+	}
+
+	return error;
+}
+
+/* Record extents that belong to the realtime refcount inode. */
+STATIC int
+xrep_rtrefc_walk_rmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_rtrefc		*rr = priv;
+	struct xfs_mount		*mp = cur->bc_mp;
+	xfs_fsblock_t			fsbno;
+	int				error = 0;
+
+	if (xchk_should_terminate(rr->sc, &error))
+		return error;
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != rr->sc->ip->i_ino)
+		return 0;
+
+	error = xrep_check_ino_btree_mapping(rr->sc, rec);
+	if (error)
+		return error;
+
+	fsbno = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno,
+			rec->rm_startblock);
+
+	return xfsb_bitmap_set(&rr->old_rtrefcountbt_blocks, fsbno,
+			rec->rm_blockcount);
+}
+
+/*
+ * Walk forward through the rmap btree to collect all rmaps starting at
+ * @bno in @rmap_bag.  These represent the file(s) that share ownership of
+ * the current block.  Upon return, the rmap cursor points to the last record
+ * satisfying the startblock constraint.
+ */
+static int
+xrep_rtrefc_push_rmaps_at(
+	struct xrep_rtrefc	*rr,
+	struct rcbag		*rcstack,
+	xfs_rgblock_t		bno,
+	struct xfs_rmap_irec	*rmap,
+	bool			*have)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	int			have_gt;
+	int			error;
+
+	while (*have && rmap->rm_startblock == bno) {
+		error = rcbag_add(rcstack, rr->sc->tp, rmap);
+		if (error)
+			return error;
+
+		error = xrep_rtrefc_walk_rmaps(rr, rmap, have);
+		if (error)
+			return error;
+	}
+
+	error = xfs_btree_decrement(sc->sr.rmap_cur, 0, &have_gt);
+	if (error)
+		return error;
+	if (XFS_IS_CORRUPT(sc->mp, !have_gt)) {
+		xfs_btree_mark_sick(sc->sr.rmap_cur);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/* Scan one AG for reverse mappings for the realtime refcount btree. */
+STATIC int
+xrep_rtrefc_scan_ag(
+	struct xrep_rtrefc	*rr,
+	struct xfs_perag	*pag)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	int			error;
+
+	error = xrep_ag_init(sc, pag, &sc->sa);
+	if (error)
+		return error;
+
+	error = xfs_rmap_query_all(sc->sa.rmap_cur, xrep_rtrefc_walk_rmap, rr);
+	xchk_ag_free(sc, &sc->sa);
+	return error;
+}
+
+/* Iterate all the rmap records to generate reference count data. */
+STATIC int
+xrep_rtrefc_find_refcounts(
+	struct xrep_rtrefc	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct rcbag		*rcstack;
+	struct xfs_perag	*pag;
+	uint64_t		old_stack_height;
+	xfs_rgblock_t		sbno;
+	xfs_rgblock_t		cbno;
+	xfs_rgblock_t		nbno;
+	xfs_agnumber_t		agno;
+	bool			have;
+	int			error;
+
+	/* Scan for old rtrefc btree blocks. */
+	for_each_perag(sc->mp, agno, pag) {
+		error = xrep_rtrefc_scan_ag(rr, pag);
+		if (error) {
+			xfs_perag_rele(pag);
+			return error;
+		}
+	}
+
+	xrep_rtgroup_btcur_init(sc, &sc->sr);
+
+	/*
+	 * Set up a bag to store all the rmap records that we're tracking to
+	 * generate a reference count record.  If this exceeds
+	 * XFS_REFC_REFCOUNT_MAX, we clamp rc_refcount.
+	 */
+	error = rcbag_init(sc->mp, sc->xfile_buftarg, &rcstack);
+	if (error)
+		goto out_cur;
+
+	/* Start the rtrmapbt cursor to the left of all records. */
+	error = xfs_btree_goto_left_edge(sc->sr.rmap_cur);
+	if (error)
+		goto out_bag;
+
+	/* Process reverse mappings into refcount data. */
+	while (xfs_btree_has_more_records(sc->sr.rmap_cur)) {
+		struct xfs_rmap_irec	rmap;
+
+		/* Push all rmaps with pblk == sbno onto the stack */
+		error = xrep_rtrefc_walk_rmaps(rr, &rmap, &have);
+		if (error)
+			goto out_bag;
+		if (!have)
+			break;
+		sbno = cbno = rmap.rm_startblock;
+		error = xrep_rtrefc_push_rmaps_at(rr, rcstack, sbno, &rmap,
+				&have);
+		if (error)
+			goto out_bag;
+
+		/* Set nbno to the bno of the next refcount change */
+		error = rcbag_next_edge(rcstack, sc->tp, &rmap, have, &nbno);
+		if (error)
+			goto out_bag;
+
+		ASSERT(nbno > sbno);
+		old_stack_height = rcbag_count(rcstack);
+
+		/* While stack isn't empty... */
+		while (rcbag_count(rcstack) > 0) {
+			/* Pop all rmaps that end at nbno */
+			error = rcbag_remove_ending_at(rcstack, sc->tp, nbno);
+			if (error)
+				goto out_bag;
+
+			/* Push array items that start at nbno */
+			error = xrep_rtrefc_walk_rmaps(rr, &rmap, &have);
+			if (error)
+				goto out_bag;
+			if (have) {
+				error = xrep_rtrefc_push_rmaps_at(rr, rcstack,
+						nbno, &rmap, &have);
+				if (error)
+					goto out_bag;
+			}
+
+			/* Emit refcount if necessary */
+			ASSERT(nbno > cbno);
+			if (rcbag_count(rcstack) != old_stack_height) {
+				if (old_stack_height > 1) {
+					error = xrep_rtrefc_stash(rr,
+							XFS_REFC_DOMAIN_SHARED,
+							cbno, nbno - cbno,
+							old_stack_height);
+					if (error)
+						goto out_bag;
+				}
+				cbno = nbno;
+			}
+
+			/* Stack empty, go find the next rmap */
+			if (rcbag_count(rcstack) == 0)
+				break;
+			old_stack_height = rcbag_count(rcstack);
+			sbno = nbno;
+
+			/* Set nbno to the bno of the next refcount change */
+			error = rcbag_next_edge(rcstack, sc->tp, &rmap, have,
+					&nbno);
+			if (error)
+				goto out_bag;
+
+			ASSERT(nbno > sbno);
+		}
+	}
+
+	ASSERT(rcbag_count(rcstack) == 0);
+out_bag:
+	rcbag_free(&rcstack);
+out_cur:
+	xchk_rtgroup_btcur_free(&sc->sr);
+	return error;
+}
+
+/* Retrieve refcountbt data for bulk load. */
+STATIC int
+xrep_rtrefc_get_records(
+	struct xfs_btree_cur		*cur,
+	unsigned int			idx,
+	struct xfs_btree_block		*block,
+	unsigned int			nr_wanted,
+	void				*priv)
+{
+	struct xrep_rtrefc		*rr = priv;
+	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
+	int				error;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		error = xfarray_load(rr->refcount_records, rr->array_cur++,
+				&cur->bc_rec.rc);
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
+xrep_rtrefc_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_rtrefc	*rr = priv;
+
+	return xrep_newbt_claim_block(cur, &rr->new_btree, ptr);
+}
+
+/* Figure out how much space we need to create the incore btree root block. */
+STATIC size_t
+xrep_rtrefc_iroot_size(
+	struct xfs_btree_cur	*cur,
+	unsigned int		level,
+	unsigned int		nr_this_level,
+	void			*priv)
+{
+	return xfs_rtrefcount_broot_space_calc(cur->bc_mp, level,
+			nr_this_level);
+}
+
+/*
+ * Use the collected refcount information to stage a new rt refcount btree.  If
+ * this is successful we'll return with the new btree root information logged
+ * to the repair transaction but not yet committed.
+ */
+STATIC int
+xrep_rtrefc_build_new_tree(
+	struct xrep_rtrefc	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	struct xfs_btree_cur	*refc_cur;
+	int			error;
+
+	error = xrep_rtrefc_sort_records(rr);
+	if (error)
+		return error;
+
+	/*
+	 * Prepare to construct the new btree by reserving disk space for the
+	 * new btree and setting up all the accounting information we'll need
+	 * to root the new btree while it's under construction and before we
+	 * attach it to the realtime refcount inode.
+	 */
+	error = xrep_newbt_init_metadir_inode(&rr->new_btree, sc);
+	if (error)
+		return error;
+
+	rr->new_btree.bload.get_records = xrep_rtrefc_get_records;
+	rr->new_btree.bload.claim_block = xrep_rtrefc_claim_block;
+	rr->new_btree.bload.iroot_size = xrep_rtrefc_iroot_size;
+
+	/* Compute how many blocks we'll need. */
+	refc_cur = xfs_rtrefcountbt_stage_cursor(mp, rtg, rtg->rtg_refcountip,
+			&rr->new_btree.ifake);
+	error = xfs_btree_bload_compute_geometry(refc_cur, &rr->new_btree.bload,
+			xfarray_length(rr->refcount_records));
+	if (error)
+		goto err_cur;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto err_cur;
+
+	/*
+	 * Guess how many blocks we're going to need to rebuild an entire
+	 * rtrefcountbt from the number of extents we found, and pump up our
+	 * transaction to have sufficient block reservation.  We're allowed
+	 * to exceed quota to repair inconsistent metadata, though this is
+	 * unlikely.
+	 */
+	error = xfs_trans_reserve_more_inode(sc->tp, rtg->rtg_refcountip,
+			rr->new_btree.bload.nr_blocks, 0, true);
+	if (error)
+		goto err_cur;
+
+	/* Reserve the space we'll need for the new btree. */
+	error = xrep_newbt_alloc_blocks(&rr->new_btree,
+			rr->new_btree.bload.nr_blocks);
+	if (error)
+		goto err_cur;
+
+	/* Add all observed refcount records. */
+	rr->new_btree.ifake.if_fork->if_format = XFS_DINODE_FMT_REFCOUNT;
+	rr->array_cur = XFARRAY_CURSOR_INIT;
+	error = xfs_btree_bload(refc_cur, &rr->new_btree.bload, rr);
+	if (error)
+		goto err_cur;
+
+	/*
+	 * Install the new rtrefc btree in the inode.  After this point the old
+	 * btree is no longer accessible, the new tree is live, and we can
+	 * delete the cursor.
+	 */
+	xfs_rtrefcountbt_commit_staged_btree(refc_cur, sc->tp);
+	xrep_inode_set_nblocks(rr->sc, rr->new_btree.ifake.if_blocks);
+	xfs_btree_del_cursor(refc_cur, 0);
+
+	/* Dispose of any unused blocks and the accounting information. */
+	error = xrep_newbt_commit(&rr->new_btree);
+	if (error)
+		return error;
+
+	return xrep_roll_trans(sc);
+err_cur:
+	xfs_btree_del_cursor(refc_cur, error);
+	xrep_newbt_cancel(&rr->new_btree);
+	return error;
+}
+
+/*
+ * Now that we've logged the roots of the new btrees, invalidate all of the
+ * old blocks and free them.
+ */
+STATIC int
+xrep_rtrefc_remove_old_tree(
+	struct xrep_rtrefc	*rr)
+{
+	int			error;
+
+	/*
+	 * Free all the extents that were allocated to the former rtrefcountbt
+	 * and aren't cross-linked with something else.
+	 */
+	error = xrep_reap_metadir_fsblocks(rr->sc,
+			&rr->old_rtrefcountbt_blocks);
+	if (error)
+		return error;
+
+	/*
+	 * Ensure the proper reservation for the rtrefcount inode so that we
+	 * don't fail to expand the btree.
+	 */
+	return xrep_reset_imeta_reservation(rr->sc);
+}
+
+/* Rebuild the rt refcount btree. */
+int
+xrep_rtrefcountbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_rtrefc	*rr;
+	struct xfs_mount	*mp = sc->mp;
+	char			*descr;
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_has_rtrmapbt(mp))
+		return -EOPNOTSUPP;
+
+	/* Make sure any problems with the fork are fixed. */
+	error = xrep_metadata_inode_forks(sc);
+	if (error)
+		return error;
+
+	rr = kzalloc(sizeof(struct xrep_rtrefc), XCHK_GFP_FLAGS);
+	if (!rr)
+		return -ENOMEM;
+	rr->sc = sc;
+
+	/* Set up enough storage to handle one refcount record per rt extent. */
+	descr = xchk_xfile_ag_descr(sc, "reference count records");
+	error = xfarray_create(descr, mp->m_sb.sb_rextents,
+			sizeof(struct xfs_refcount_irec),
+			&rr->refcount_records);
+	kfree(descr);
+	if (error)
+		goto out_rr;
+
+	/* Collect all reference counts. */
+	xfsb_bitmap_init(&rr->old_rtrefcountbt_blocks);
+	error = xrep_rtrefc_find_refcounts(rr);
+	if (error)
+		goto out_bitmap;
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/* Rebuild the refcount information. */
+	error = xrep_rtrefc_build_new_tree(rr);
+	if (error)
+		goto out_bitmap;
+
+	/* Kill the old tree. */
+	error = xrep_rtrefc_remove_old_tree(rr);
+	if (error)
+		goto out_bitmap;
+
+out_bitmap:
+	xfsb_bitmap_destroy(&rr->old_rtrefcountbt_blocks);
+	xfarray_destroy(rr->refcount_records);
+out_rr:
+	kfree(rr);
+	return error;
+}
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index a40afa571b981..c29e398283018 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -137,7 +137,7 @@ xrep_rtrmap_check_mapping(
 	/* Make sure this isn't free space. */
 	rtbno = xfs_rgbno_to_rtb(sc->mp, sc->sr.rtg->rtg_rgno,
 			rec->rm_startblock);
-	return xrep_require_rtext_inuse(sc, rtbno, rec->rm_blockcount);
+	return xrep_require_rtext_inuse(sc, rtbno, rec->rm_blockcount, false);
 }
 
 /* Store a reverse-mapping record. */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 2611e0223489c..94a733975879a 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -486,7 +486,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_rtrefcountbt,
 		.scrub	= xchk_rtrefcountbt,
 		.has	= xfs_has_rtreflink,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_rtrefcountbt,
 	},
 };
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 2d373c9a53ad6..aa943433cbb02 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3995,6 +3995,37 @@ TRACE_EVENT(xrep_rtrmap_live_update,
 		  __entry->offset,
 		  __entry->flags)
 );
+
+TRACE_EVENT(xrep_rtrefc_found,
+	TP_PROTO(struct xfs_rtgroup *rtg, const struct xfs_refcount_irec *rec),
+	TP_ARGS(rtg, rec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, rtdev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(enum xfs_refc_domain, domain)
+		__field(xfs_rgblock_t, startblock)
+		__field(xfs_extlen_t, blockcount)
+		__field(xfs_nlink_t, refcount)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg->rtg_mount->m_super->s_dev;
+		__entry->rtdev = rtg->rtg_mount->m_rtdev_targp->bt_dev;
+		__entry->rgno = rtg->rtg_rgno;
+		__entry->domain = rec->rc_domain;
+		__entry->startblock = rec->rc_startblock;
+		__entry->blockcount = rec->rc_blockcount;
+		__entry->refcount = rec->rc_refcount;
+	),
+	TP_printk("dev %d:%d rtdev %d:%d rgno 0x%x dom %s rgbno 0x%x fsbcount 0x%x refcount %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->rtdev), MINOR(__entry->rtdev),
+		  __entry->rgno,
+		  __print_symbolic(__entry->domain, XFS_REFC_DOMAIN_STRINGS),
+		  __entry->startblock,
+		  __entry->blockcount,
+		  __entry->refcount)
+);
 #endif /* CONFIG_XFS_RT */
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */

