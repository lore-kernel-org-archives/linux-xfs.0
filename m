Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C30918187
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:49:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44BE7AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:49:55 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id EYnZBK3KTTiG5LVL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:49:52 -0700 (PDT)
Subject: [PATCH 31/71] xfs: store in-progress CoW allocations in the
	refcount btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:49:47 -0700
Message-ID: <147216898752.4420.13353121659330076252.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

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

v2: Use the deferred operations system to avoid deadlocks and blowing
out the transaction reservation.  This allows us to unmap a CoW
extent from the refcountbt and into a file atomically.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trace.h   |    4 +
 libxfs/xfs_bmap.c     |   11 ++
 libxfs/xfs_format.h   |    3 
 libxfs/xfs_refcount.c |  317 ++++++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_refcount.h |    7 +
 5 files changed, 336 insertions(+), 6 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 506f23b..b7bf3d0 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -264,6 +264,10 @@
 #define trace_xfs_bmap_deferred(...)		((void) 0)
 #define trace_xfs_bmap_defer(...)		((void) 0)
 
+#define trace_xfs_refcount_adjust_cow_error(...)	((void) 0)
+#define trace_xfs_refcount_cow_increase(...)	((void) 0)
+#define trace_xfs_refcount_cow_decrease(...)	((void) 0)
+
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
 #define trace_xfs_perag_get_tag(a,b,c,d) ((c) = (c))
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cb30099..a94f855 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4698,6 +4698,17 @@ xfs_bmapi_write(
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
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index bbb9334..3991eaa 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1374,7 +1374,8 @@ struct xfs_owner_info {
 #define XFS_RMAP_OWN_INOBT	(-6ULL)	/* Inode btree blocks */
 #define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
 #define XFS_RMAP_OWN_REFC	(-8ULL) /* refcount tree */
-#define XFS_RMAP_OWN_MIN	(-9ULL) /* guard */
+#define XFS_RMAP_OWN_COW	(-9ULL) /* cow allocations */
+#define XFS_RMAP_OWN_MIN	(-10ULL) /* guard */
 
 #define XFS_RMAP_NON_INODE_OWNER(owner)	(!!((owner) & (1ULL << 63)))
 
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 20b4f68..7d3735f 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -35,13 +35,23 @@
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
@@ -467,6 +477,8 @@ out_error:
 	return error;
 }
 
+#define XFS_FIND_RCEXT_SHARED	1
+#define XFS_FIND_RCEXT_COW	2
 /*
  * Find the left extent and the one after it (cleft).  This function assumes
  * that we've already split any extent crossing agbno.
@@ -477,7 +489,8 @@ xfs_refcount_find_left_extents(
 	struct xfs_refcount_irec	*left,
 	struct xfs_refcount_irec	*cleft,
 	xfs_agblock_t			agbno,
-	xfs_extlen_t			aglen)
+	xfs_extlen_t			aglen,
+	int				flags)
 {
 	struct xfs_refcount_irec	tmp;
 	int				error;
@@ -497,6 +510,10 @@ xfs_refcount_find_left_extents(
 
 	if (RCNEXT(tmp) != agbno)
 		return 0;
+	if ((flags & XFS_FIND_RCEXT_SHARED) && tmp.rc_refcount < 2)
+		return 0;
+	if ((flags & XFS_FIND_RCEXT_COW) && tmp.rc_refcount > 1)
+		return 0;
 	/* We have a left extent; retrieve (or invent) the next right one */
 	*left = tmp;
 
@@ -553,7 +570,8 @@ xfs_refcount_find_right_extents(
 	struct xfs_refcount_irec	*right,
 	struct xfs_refcount_irec	*cright,
 	xfs_agblock_t			agbno,
-	xfs_extlen_t			aglen)
+	xfs_extlen_t			aglen,
+	int				flags)
 {
 	struct xfs_refcount_irec	tmp;
 	int				error;
@@ -573,6 +591,10 @@ xfs_refcount_find_right_extents(
 
 	if (tmp.rc_startblock != agbno + aglen)
 		return 0;
+	if ((flags & XFS_FIND_RCEXT_SHARED) && tmp.rc_refcount < 2)
+		return 0;
+	if ((flags & XFS_FIND_RCEXT_COW) && tmp.rc_refcount > 1)
+		return 0;
 	/* We have a right extent; retrieve (or invent) the next left one */
 	*right = tmp;
 
@@ -629,6 +651,7 @@ xfs_refcount_merge_extents(
 	xfs_agblock_t		*agbno,
 	xfs_extlen_t		*aglen,
 	enum xfs_refc_adjust_op adjust,
+	int			flags,
 	bool			*shape_changed)
 {
 	struct xfs_refcount_irec	left = {0}, cleft = {0};
@@ -644,11 +667,11 @@ xfs_refcount_merge_extents(
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
 
@@ -935,7 +958,7 @@ xfs_refcount_adjust(
 	 */
 	orig_aglen = aglen;
 	error = xfs_refcount_merge_extents(cur, &agbno, &aglen, adj,
-			&shape_changed);
+			XFS_FIND_RCEXT_SHARED, &shape_changed);
 	if (error)
 		goto out_error;
 	if (shape_changed)
@@ -1053,6 +1076,18 @@ xfs_refcount_finish_one(
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
@@ -1227,3 +1262,275 @@ out_error:
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
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 0ec9a28..105c246 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -57,4 +57,11 @@ extern int xfs_refcount_find_shared(struct xfs_btree_cur *cur,
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
