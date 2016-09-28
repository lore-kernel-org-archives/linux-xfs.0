Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19764 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933939AbcI1C5w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:57:52 -0400
Subject: [PATCH 39/63] xfs: store in-progress CoW allocations in the
 refcount btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:57:47 -0700
Message-ID: <147503146741.30303.8841764231035913075.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Due to the way the CoW algorithm in XFS works, there's an interval
during which blocks allocated to handle a CoW can be lost -- if the FS
goes down after the blocks are allocated but before the block
remapping takes place.  This is exacerbated by the cowextsz hint --
allocated reservations can sit around for a while, waiting to get
used.

Since the refcount btree doesn't normally store records with refcount
of 1, we can use it to record these in-progress extents.  In-progress
blocks cannot be shared because they're not user-visible, so there
shouldn't be any conflicts with other programs.  This is a better
solution than holding EFIs during writeback because (a) EFIs can't be
relogged currently, (b) even if they could, EFIs are bound by
available log space, which puts an unnecessary upper bound on how much
CoW we can have in flight, and (c) we already have a mechanism to
track blocks.

At mount time, read the refcount records and free anything we find
with a refcount of 1 because those were in-progress when the FS went
down.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Use the deferred operations system to avoid deadlocks and blowing
out the transaction reservation.  This allows us to unmap a CoW
extent from the refcountbt and into a file atomically.
---
 fs/xfs/libxfs/xfs_bmap.c     |   11 +
 fs/xfs/libxfs/xfs_format.h   |    3 
 fs/xfs/libxfs/xfs_refcount.c |  336 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_refcount.h |   10 +
 fs/xfs/xfs_mount.c           |   12 ++
 fs/xfs/xfs_refcount_item.c   |   12 ++
 fs/xfs/xfs_reflink.c         |  148 +++++++++++++++++++
 fs/xfs/xfs_reflink.h         |    1 
 fs/xfs/xfs_super.c           |    9 +
 fs/xfs/xfs_trace.h           |    4 +
 10 files changed, 535 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 451f3e4..0ef7fb4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4629,6 +4629,17 @@ xfs_bmapi_write(
 				goto error0;
 			if (bma.blkno == NULLFSBLOCK)
 				break;
+
+			/*
+			 * If this is a CoW allocation, record the data in
+			 * the refcount btree for orphan recovery.
+			 */
+			if (whichfork == XFS_COW_FORK) {
+				error = xfs_refcount_alloc_cow_extent(mp, dfops,
+						bma.blkno, bma.length);
+				if (error)
+					goto error0;
+			}
 		}
 
 		/* Deal with the allocated space we found.  */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 812d55e..641c4fa 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1375,7 +1375,8 @@ struct xfs_owner_info {
 #define XFS_RMAP_OWN_INOBT	(-6ULL)	/* Inode btree blocks */
 #define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
 #define XFS_RMAP_OWN_REFC	(-8ULL) /* refcount tree */
-#define XFS_RMAP_OWN_MIN	(-9ULL) /* guard */
+#define XFS_RMAP_OWN_COW	(-9ULL) /* cow allocations */
+#define XFS_RMAP_OWN_MIN	(-10ULL) /* guard */
 
 #define XFS_RMAP_NON_INODE_OWNER(owner)	(!!((owner) & (1ULL << 63)))
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 58b7770..3b79356 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -36,13 +36,23 @@
 #include "xfs_trans.h"
 #include "xfs_bit.h"
 #include "xfs_refcount.h"
+#include "xfs_rmap.h"
 
 /* Allowable refcount adjustment amounts. */
 enum xfs_refc_adjust_op {
 	XFS_REFCOUNT_ADJUST_INCREASE	= 1,
 	XFS_REFCOUNT_ADJUST_DECREASE	= -1,
+	XFS_REFCOUNT_ADJUST_COW_ALLOC	= 0,
+	XFS_REFCOUNT_ADJUST_COW_FREE	= -1,
 };
 
+STATIC int __xfs_refcount_cow_alloc(struct xfs_btree_cur *rcur,
+		xfs_agblock_t agbno, xfs_extlen_t aglen,
+		struct xfs_defer_ops *dfops);
+STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
+		xfs_agblock_t agbno, xfs_extlen_t aglen,
+		struct xfs_defer_ops *dfops);
+
 /*
  * Look up the first record less than or equal to [bno, len] in the btree
  * given by cur.
@@ -77,6 +87,17 @@ xfs_refcount_lookup_ge(
 	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
 }
 
+/* Convert on-disk record to in-core format. */
+void
+xfs_refcount_btrec_to_irec(
+	union xfs_btree_rec		*rec,
+	struct xfs_refcount_irec	*irec)
+{
+	irec->rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
+	irec->rc_blockcount = be32_to_cpu(rec->refc.rc_blockcount);
+	irec->rc_refcount = be32_to_cpu(rec->refc.rc_refcount);
+}
+
 /*
  * Get the data from the pointed-to record.
  */
@@ -86,14 +107,12 @@ xfs_refcount_get_rec(
 	struct xfs_refcount_irec	*irec,
 	int				*stat)
 {
-	union xfs_btree_rec	*rec;
-	int			error;
+	union xfs_btree_rec		*rec;
+	int				error;
 
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (!error && *stat == 1) {
-		irec->rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
-		irec->rc_blockcount = be32_to_cpu(rec->refc.rc_blockcount);
-		irec->rc_refcount = be32_to_cpu(rec->refc.rc_refcount);
+		xfs_refcount_btrec_to_irec(rec, irec);
 		trace_xfs_refcount_get(cur->bc_mp, cur->bc_private.a.agno,
 				irec);
 	}
@@ -468,6 +487,8 @@ xfs_refcount_merge_right_extent(
 	return error;
 }
 
+#define XFS_FIND_RCEXT_SHARED	1
+#define XFS_FIND_RCEXT_COW	2
 /*
  * Find the left extent and the one after it (cleft).  This function assumes
  * that we've already split any extent crossing agbno.
@@ -478,7 +499,8 @@ xfs_refcount_find_left_extents(
 	struct xfs_refcount_irec	*left,
 	struct xfs_refcount_irec	*cleft,
 	xfs_agblock_t			agbno,
-	xfs_extlen_t			aglen)
+	xfs_extlen_t			aglen,
+	int				flags)
 {
 	struct xfs_refcount_irec	tmp;
 	int				error;
@@ -498,6 +520,10 @@ xfs_refcount_find_left_extents(
 
 	if (RCNEXT(tmp) != agbno)
 		return 0;
+	if ((flags & XFS_FIND_RCEXT_SHARED) && tmp.rc_refcount < 2)
+		return 0;
+	if ((flags & XFS_FIND_RCEXT_COW) && tmp.rc_refcount > 1)
+		return 0;
 	/* We have a left extent; retrieve (or invent) the next right one */
 	*left = tmp;
 
@@ -554,7 +580,8 @@ xfs_refcount_find_right_extents(
 	struct xfs_refcount_irec	*right,
 	struct xfs_refcount_irec	*cright,
 	xfs_agblock_t			agbno,
-	xfs_extlen_t			aglen)
+	xfs_extlen_t			aglen,
+	int				flags)
 {
 	struct xfs_refcount_irec	tmp;
 	int				error;
@@ -574,6 +601,10 @@ xfs_refcount_find_right_extents(
 
 	if (tmp.rc_startblock != agbno + aglen)
 		return 0;
+	if ((flags & XFS_FIND_RCEXT_SHARED) && tmp.rc_refcount < 2)
+		return 0;
+	if ((flags & XFS_FIND_RCEXT_COW) && tmp.rc_refcount > 1)
+		return 0;
 	/* We have a right extent; retrieve (or invent) the next left one */
 	*right = tmp;
 
@@ -630,6 +661,7 @@ xfs_refcount_merge_extents(
 	xfs_agblock_t		*agbno,
 	xfs_extlen_t		*aglen,
 	enum xfs_refc_adjust_op adjust,
+	int			flags,
 	bool			*shape_changed)
 {
 	struct xfs_refcount_irec	left = {0}, cleft = {0};
@@ -645,11 +677,11 @@ xfs_refcount_merge_extents(
 	 * [right].
 	 */
 	error = xfs_refcount_find_left_extents(cur, &left, &cleft, *agbno,
-			*aglen);
+			*aglen, flags);
 	if (error)
 		return error;
 	error = xfs_refcount_find_right_extents(cur, &right, &cright, *agbno,
-			*aglen);
+			*aglen, flags);
 	if (error)
 		return error;
 
@@ -936,7 +968,7 @@ xfs_refcount_adjust(
 	 */
 	orig_aglen = aglen;
 	error = xfs_refcount_merge_extents(cur, &agbno, &aglen, adj,
-			&shape_changed);
+			XFS_FIND_RCEXT_SHARED, &shape_changed);
 	if (error)
 		goto out_error;
 	if (shape_changed)
@@ -1054,6 +1086,18 @@ xfs_refcount_finish_one(
 		error = xfs_refcount_adjust(rcur, bno, blockcount, adjusted,
 			XFS_REFCOUNT_ADJUST_DECREASE, dfops, NULL);
 		break;
+	case XFS_REFCOUNT_ALLOC_COW:
+		*adjusted = 0;
+		error = __xfs_refcount_cow_alloc(rcur, bno, blockcount, dfops);
+		if (!error)
+			*adjusted = blockcount;
+		break;
+	case XFS_REFCOUNT_FREE_COW:
+		*adjusted = 0;
+		error = __xfs_refcount_cow_free(rcur, bno, blockcount, dfops);
+		if (!error)
+			*adjusted = blockcount;
+		break;
 	default:
 		ASSERT(0);
 		error = -EFSCORRUPTED;
@@ -1228,3 +1272,275 @@ xfs_refcount_find_shared(
 				cur->bc_private.a.agno, error, _RET_IP_);
 	return error;
 }
+
+/*
+ * Recovering CoW Blocks After a Crash
+ *
+ * Due to the way that the copy on write mechanism works, there's a window of
+ * opportunity in which we can lose track of allocated blocks during a crash.
+ * Because CoW uses delayed allocation in the in-core CoW fork, writeback
+ * causes blocks to be allocated and stored in the CoW fork.  The blocks are
+ * no longer in the free space btree but are not otherwise recorded anywhere
+ * until the write completes and the blocks are mapped into the file.  A crash
+ * in between allocation and remapping results in the replacement blocks being
+ * lost.  This situation is exacerbated by the CoW extent size hint because
+ * allocations can hang around for long time.
+ *
+ * However, there is a place where we can record these allocations before they
+ * become mappings -- the reference count btree.  The btree does not record
+ * extents with refcount == 1, so we can record allocations with a refcount of
+ * 1.  Blocks being used for CoW writeout cannot be shared, so there should be
+ * no conflict with shared block records.  These mappings should be created
+ * when we allocate blocks to the CoW fork and deleted when they're removed
+ * from the CoW fork.
+ *
+ * Minor nit: records for in-progress CoW allocations and records for shared
+ * extents must never be merged, to preserve the property that (except for CoW
+ * allocations) there are no refcount btree entries with refcount == 1.  The
+ * only time this could potentially happen is when unsharing a block that's
+ * adjacent to CoW allocations, so we must be careful to avoid this.
+ *
+ * At mount time we recover lost CoW allocations by searching the refcount
+ * btree for these refcount == 1 mappings.  These represent CoW allocations
+ * that were in progress at the time the filesystem went down, so we can free
+ * them to get the space back.
+ *
+ * This mechanism is superior to creating EFIs for unmapped CoW extents for
+ * several reasons -- first, EFIs pin the tail of the log and would have to be
+ * periodically relogged to avoid filling up the log.  Second, CoW completions
+ * will have to file an EFD and create new EFIs for whatever remains in the
+ * CoW fork; this partially takes care of (1) but extent-size reservations
+ * will have to periodically relog even if there's no writeout in progress.
+ * This can happen if the CoW extent size hint is set, which you really want.
+ * Third, EFIs cannot currently be automatically relogged into newer
+ * transactions to advance the log tail.  Fourth, stuffing the log full of
+ * EFIs places an upper bound on the number of CoW allocations that can be
+ * held filesystem-wide at any given time.  Recording them in the refcount
+ * btree doesn't require us to maintain any state in memory and doesn't pin
+ * the log.
+ */
+/*
+ * Adjust the refcounts of CoW allocations.  These allocations are "magic"
+ * in that they're not referenced anywhere else in the filesystem, so we
+ * stash them in the refcount btree with a refcount of 1 until either file
+ * remapping (or CoW cancellation) happens.
+ */
+STATIC int
+xfs_refcount_adjust_cow_extents(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	enum xfs_refc_adjust_op	adj,
+	struct xfs_defer_ops	*dfops,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_refcount_irec	ext, tmp;
+	int				error;
+	int				found_rec, found_tmp;
+
+	if (aglen == 0)
+		return 0;
+
+	/* Find any overlapping refcount records */
+	error = xfs_refcount_lookup_ge(cur, agbno, &found_rec);
+	if (error)
+		goto out_error;
+	error = xfs_refcount_get_rec(cur, &ext, &found_rec);
+	if (error)
+		goto out_error;
+	if (!found_rec) {
+		ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
+		ext.rc_blockcount = 0;
+		ext.rc_refcount = 0;
+	}
+
+	switch (adj) {
+	case XFS_REFCOUNT_ADJUST_COW_ALLOC:
+		/* Adding a CoW reservation, there should be nothing here. */
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
+				ext.rc_startblock >= agbno + aglen, out_error);
+
+		tmp.rc_startblock = agbno;
+		tmp.rc_blockcount = aglen;
+		tmp.rc_refcount = 1;
+		trace_xfs_refcount_modify_extent(cur->bc_mp,
+				cur->bc_private.a.agno, &tmp);
+
+		error = xfs_refcount_insert(cur, &tmp,
+				&found_tmp);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
+				found_tmp == 1, out_error);
+		break;
+	case XFS_REFCOUNT_ADJUST_COW_FREE:
+		/* Removing a CoW reservation, there should be one extent. */
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
+			ext.rc_startblock == agbno, out_error);
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
+			ext.rc_blockcount == aglen, out_error);
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
+			ext.rc_refcount == 1, out_error);
+
+		ext.rc_refcount = 0;
+		trace_xfs_refcount_modify_extent(cur->bc_mp,
+				cur->bc_private.a.agno, &ext);
+		error = xfs_refcount_delete(cur, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
+				found_rec == 1, out_error);
+		break;
+	default:
+		ASSERT(0);
+	}
+
+	return error;
+out_error:
+	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Add or remove refcount btree entries for CoW reservations.
+ */
+STATIC int
+xfs_refcount_adjust_cow(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	enum xfs_refc_adjust_op	adj,
+	struct xfs_defer_ops	*dfops)
+{
+	bool			shape_changed;
+	int			error;
+
+	/*
+	 * Ensure that no rcextents cross the boundary of the adjustment range.
+	 */
+	error = xfs_refcount_split_extent(cur, agbno, &shape_changed);
+	if (error)
+		goto out_error;
+
+	error = xfs_refcount_split_extent(cur, agbno + aglen, &shape_changed);
+	if (error)
+		goto out_error;
+
+	/*
+	 * Try to merge with the left or right extents of the range.
+	 */
+	error = xfs_refcount_merge_extents(cur, &agbno, &aglen, adj,
+			XFS_FIND_RCEXT_COW, &shape_changed);
+	if (error)
+		goto out_error;
+
+	/* Now that we've taken care of the ends, adjust the middle extents */
+	error = xfs_refcount_adjust_cow_extents(cur, agbno, aglen, adj,
+			dfops, NULL);
+	if (error)
+		goto out_error;
+
+	return 0;
+
+out_error:
+	trace_xfs_refcount_adjust_cow_error(cur->bc_mp, cur->bc_private.a.agno,
+			error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Record a CoW allocation in the refcount btree.
+ */
+STATIC int
+__xfs_refcount_cow_alloc(
+	struct xfs_btree_cur	*rcur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	struct xfs_defer_ops	*dfops)
+{
+	int			error;
+
+	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_private.a.agno,
+			agbno, aglen);
+
+	/* Add refcount btree reservation */
+	error = xfs_refcount_adjust_cow(rcur, agbno, aglen,
+			XFS_REFCOUNT_ADJUST_COW_ALLOC, dfops);
+	if (error)
+		return error;
+
+	/* Add rmap entry */
+	if (xfs_sb_version_hasrmapbt(&rcur->bc_mp->m_sb)) {
+		error = xfs_rmap_alloc_extent(rcur->bc_mp, dfops,
+				rcur->bc_private.a.agno,
+				agbno, aglen, XFS_RMAP_OWN_COW);
+		if (error)
+			return error;
+	}
+
+	return error;
+}
+
+/*
+ * Remove a CoW allocation from the refcount btree.
+ */
+STATIC int
+__xfs_refcount_cow_free(
+	struct xfs_btree_cur	*rcur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	struct xfs_defer_ops	*dfops)
+{
+	int			error;
+
+	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_private.a.agno,
+			agbno, aglen);
+
+	/* Remove refcount btree reservation */
+	error = xfs_refcount_adjust_cow(rcur, agbno, aglen,
+			XFS_REFCOUNT_ADJUST_COW_FREE, dfops);
+	if (error)
+		return error;
+
+	/* Remove rmap entry */
+	if (xfs_sb_version_hasrmapbt(&rcur->bc_mp->m_sb)) {
+		error = xfs_rmap_free_extent(rcur->bc_mp, dfops,
+				rcur->bc_private.a.agno,
+				agbno, aglen, XFS_RMAP_OWN_COW);
+		if (error)
+			return error;
+	}
+
+	return error;
+}
+
+/* Record a CoW staging extent in the refcount btree. */
+int
+xfs_refcount_alloc_cow_extent(
+	struct xfs_mount		*mp,
+	struct xfs_defer_ops		*dfops,
+	xfs_fsblock_t			fsb,
+	xfs_extlen_t			len)
+{
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_ALLOC_COW,
+			fsb, len);
+}
+
+/* Forget a CoW staging event in the refcount btree. */
+int
+xfs_refcount_free_cow_extent(
+	struct xfs_mount		*mp,
+	struct xfs_defer_ops		*dfops,
+	xfs_fsblock_t			fsb,
+	xfs_extlen_t			len)
+{
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_FREE_COW,
+			fsb, len);
+}
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 48c576c..ddfcf65 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -24,6 +24,9 @@ extern int xfs_refcount_lookup_le(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_lookup_ge(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, int *stat);
+union xfs_btree_rec;
+extern void xfs_refcount_btrec_to_irec(union xfs_btree_rec *rec,
+		struct xfs_refcount_irec *irec);
 extern int xfs_refcount_get_rec(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 
@@ -58,4 +61,11 @@ extern int xfs_refcount_find_shared(struct xfs_btree_cur *cur,
 		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
 		xfs_extlen_t *flen, bool find_maximal);
 
+extern int xfs_refcount_alloc_cow_extent(struct xfs_mount *mp,
+		struct xfs_defer_ops *dfops, xfs_fsblock_t fsb,
+		xfs_extlen_t len);
+extern int xfs_refcount_free_cow_extent(struct xfs_mount *mp,
+		struct xfs_defer_ops *dfops, xfs_fsblock_t fsb,
+		xfs_extlen_t len);
+
 #endif	/* __XFS_REFCOUNT_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3f64615..caecbd2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -44,6 +44,7 @@
 #include "xfs_sysfs.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_reflink.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -976,10 +977,21 @@ xfs_mountfs(
 		if (error)
 			xfs_warn(mp,
 	"Unable to allocate reserve blocks. Continuing without reserve pool.");
+
+		/* Recover any CoW blocks that never got remapped. */
+		error = xfs_reflink_recover_cow(mp);
+		if (error) {
+			xfs_err(mp,
+	"Error %d recovering leftover CoW allocations.", error);
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			goto out_quota;
+		}
 	}
 
 	return 0;
 
+ out_quota:
+	xfs_qm_unmount_quotas(mp);
  out_rtunmount:
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 330fe62..1d8abd6 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -512,6 +512,18 @@ xfs_cui_recover(
 				error = xfs_refcount_decrease_extent(
 						tp->t_mountp, &dfops, &irec);
 				break;
+			case XFS_REFCOUNT_ALLOC_COW:
+				error = xfs_refcount_alloc_cow_extent(
+						tp->t_mountp, &dfops,
+						irec.br_startblock,
+						irec.br_blockcount);
+				break;
+			case XFS_REFCOUNT_FREE_COW:
+				error = xfs_refcount_free_cow_extent(
+						tp->t_mountp, &dfops,
+						irec.br_startblock,
+						irec.br_blockcount);
+				break;
 			default:
 				ASSERT(0);
 			}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c95cdc3..57796ea 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -40,6 +40,7 @@
 #include "xfs_log.h"
 #include "xfs_icache.h"
 #include "xfs_pnfs.h"
+#include "xfs_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_bmap_btree.h"
@@ -582,6 +583,13 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_trans_ijoin(*tpp, ip, 0);
 			xfs_defer_init(&dfops, &firstfsb);
 
+			/* Free the CoW orphan record. */
+			error = xfs_refcount_free_cow_extent(ip->i_mount,
+					&dfops, irec.br_startblock,
+					irec.br_blockcount);
+			if (error)
+				break;
+
 			xfs_bmap_add_free(ip->i_mount, &dfops,
 					irec.br_startblock, irec.br_blockcount,
 					NULL);
@@ -735,6 +743,13 @@ xfs_reflink_end_cow(
 			irec.br_blockcount = rlen;
 			trace_xfs_reflink_cow_remap_piece(ip, &uirec);
 
+			/* Free the CoW orphan record. */
+			error = xfs_refcount_free_cow_extent(tp->t_mountp,
+					&dfops, uirec.br_startblock,
+					uirec.br_blockcount);
+			if (error)
+				goto out_defer;
+
 			/* Map the new blocks into the data fork. */
 			error = xfs_bmap_map_extent(tp->t_mountp, &dfops,
 					ip, XFS_DATA_FORK, &uirec);
@@ -772,3 +787,136 @@ xfs_reflink_end_cow(
 	trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
 	return error;
 }
+
+struct xfs_reflink_recovery {
+	struct list_head		rr_list;
+	struct xfs_refcount_irec	rr_rrec;
+};
+
+/* Stuff an extent on the recovery list. */
+STATIC int
+xfs_reflink_recover_extent(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	struct list_head		*debris = priv;
+	struct xfs_reflink_recovery	*rr;
+
+	if (be32_to_cpu(rec->refc.rc_refcount) != 1)
+		return 0;
+
+	rr = kmem_alloc(sizeof(struct xfs_reflink_recovery), KM_SLEEP);
+	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
+	list_add_tail(&rr->rr_list, debris);
+
+	return 0;
+}
+
+/*
+ * Find and remove leftover CoW reservations.
+ */
+STATIC int
+xfs_reflink_recover_cow_ag(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno)
+{
+	struct xfs_trans		*tp;
+	struct xfs_btree_cur		*cur;
+	struct xfs_buf			*agbp;
+	struct xfs_reflink_recovery	*rr, *n;
+	struct list_head		debris;
+	union xfs_btree_irec		low = {0};
+	union xfs_btree_irec		high = {0};
+	struct xfs_defer_ops		dfops;
+	xfs_fsblock_t			fsb;
+	int				error;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
+
+	/* Find all the leftover CoW staging extents. */
+	INIT_LIST_HEAD(&debris);
+	low.rc.rc_startblock = 0;
+	high.rc.rc_startblock = -1U;
+	error = xfs_btree_query_range(cur, &low, &high,
+			xfs_reflink_recover_extent, &debris);
+	if (error)
+		goto out_error;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	xfs_buf_relse(agbp);
+
+	/* Now iterate the list to free the leftovers */
+	list_for_each_entry(rr, &debris, rr_list) {
+		/* Set up transaction. */
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
+		if (error)
+			goto out_free;
+
+		trace_xfs_reflink_recover_extent(mp, agno, &rr->rr_rrec);
+
+		/* Free the orphan record */
+		xfs_defer_init(&dfops, &fsb);
+		fsb = XFS_AGB_TO_FSB(mp, agno, rr->rr_rrec.rc_startblock);
+		error = xfs_refcount_free_cow_extent(mp, &dfops, fsb,
+				rr->rr_rrec.rc_blockcount);
+		if (error)
+			goto out_defer;
+
+		/* Free the block. */
+		xfs_bmap_add_free(mp, &dfops, fsb,
+				rr->rr_rrec.rc_blockcount, NULL);
+
+		error = xfs_defer_finish(&tp, &dfops, NULL);
+		if (error)
+			goto out_defer;
+
+		error = xfs_trans_commit(tp);
+		if (error)
+			goto out_cancel;
+	}
+	goto out_free;
+
+out_defer:
+	xfs_defer_cancel(&dfops);
+out_cancel:
+	xfs_trans_cancel(tp);
+
+out_free:
+	/* Free the leftover list */
+	list_for_each_entry_safe(rr, n, &debris, rr_list) {
+		list_del(&rr->rr_list);
+		kmem_free(rr);
+	}
+
+	return error;
+
+out_error:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	xfs_buf_relse(agbp);
+	return error;
+}
+
+/*
+ * Free leftover CoW reservations that didn't get cleaned out.
+ */
+int
+xfs_reflink_recover_cow(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		agno;
+	int			error = 0;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = xfs_reflink_recover_cow_ag(mp, agno);
+		if (error)
+			break;
+	}
+
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index c0c989a..1d2f180 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -42,5 +42,6 @@ extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
+extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
 
 #endif /* __XFS_REFLINK_H */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 26b45b3..e6aaa91 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1306,6 +1306,15 @@ xfs_fs_remount(
 		xfs_restore_resvblks(mp);
 		xfs_log_work_queue(mp);
 		xfs_queue_eofblocks(mp);
+
+		/* Recover any CoW blocks that never got remapped. */
+		error = xfs_reflink_recover_cow(mp);
+		if (error) {
+			xfs_err(mp,
+	"Error %d recovering leftover CoW allocations.", error);
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			return error;
+		}
 	}
 
 	/* rw -> ro */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cde89c6..7c826dc 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2916,14 +2916,18 @@ DEFINE_AG_ERROR_EVENT(xfs_refcount_update_error);
 /* refcount adjustment tracepoints */
 DEFINE_AG_EXTENT_EVENT(xfs_refcount_increase);
 DEFINE_AG_EXTENT_EVENT(xfs_refcount_decrease);
+DEFINE_AG_EXTENT_EVENT(xfs_refcount_cow_increase);
+DEFINE_AG_EXTENT_EVENT(xfs_refcount_cow_decrease);
 DEFINE_REFCOUNT_TRIPLE_EXTENT_EVENT(xfs_refcount_merge_center_extents);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_modify_extent);
+DEFINE_REFCOUNT_EXTENT_EVENT(xfs_reflink_recover_extent);
 DEFINE_REFCOUNT_EXTENT_AT_EVENT(xfs_refcount_split_extent);
 DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_left_extent);
 DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_right_extent);
 DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(xfs_refcount_find_left_extent);
 DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(xfs_refcount_find_right_extent);
 DEFINE_AG_ERROR_EVENT(xfs_refcount_adjust_error);
+DEFINE_AG_ERROR_EVENT(xfs_refcount_adjust_cow_error);
 DEFINE_AG_ERROR_EVENT(xfs_refcount_merge_center_extents_error);
 DEFINE_AG_ERROR_EVENT(xfs_refcount_modify_extent_error);
 DEFINE_AG_ERROR_EVENT(xfs_refcount_split_extent_error);

