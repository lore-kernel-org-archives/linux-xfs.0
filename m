Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A4218A6D7
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995397; cv=none; b=AFq1ky8FACfjRJP12YF5DN21cl4qdxNj+xrEoCBdrgu71As4p1WY5BpKGBebTCExMno8LdjEF7sY2RNaUkmb2GT/07eCtrV2bXAAvnzbbE8onIo7ObNZ3jSdCvr+HyGVUMeMB6ltJlVMNXz5cLuVSs3qj7iaNfTqEffdB62tFKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995397; c=relaxed/simple;
	bh=zTVpRvT+rHb86D7FBiW0iCGoMbz3f1a+GOjr01N/j2Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MAFDfV8jjlJEozvdQEym7PFMoamLa7OrCdOpOLJuj1r35YVTZCrFz021VtuoerjZVA0cGZgV0QGeIb27U9HyNkb/LCn8lWTOaNljVsDmv9i1Ne9zlVBKxrrZmM7qwVICthUijDrItAvUaRqn3ngbnEWNzt2vF5bWybne6V0An3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVjy5njf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVjy5njf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DF2C4CED3;
	Mon, 23 Dec 2024 23:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995396;
	bh=zTVpRvT+rHb86D7FBiW0iCGoMbz3f1a+GOjr01N/j2Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YVjy5njfONISYJMCQSIfJ213zoHXELdE8KbBkUNEYKY8BDtzV/4QXoG2pTTnmNksk
	 4FWIrdWfBgXRB2O9qeBjnmq0TOYU0M9hu2Q84CBfIBM+PcB0sTq9Nj16MNogIX/koH
	 cwcEt36EkQSkrKmpY1V9ZgIHrIeJdy7VNskMm+0UHWkYm4wG41UGdvDoEfycO8hw0l
	 DkdsjSdr51Rhr3vufZg+7YcBTJnhjNexJcN/8m19JiLonR79iAXXS/jppEP7H3yz2U
	 0C4cR3U88BQxEn499mFxJ9M+yJSYaoPYiLddzkbq7j4HGvmruq7IoF6BzB8Q7whqCd
	 GOzwN96QxYsUA==
Date: Mon, 23 Dec 2024 15:09:56 -0800
Subject: [PATCH 14/43] xfs: wire up realtime refcount btree cursors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420179.2381378.126868872647130547.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Wire up realtime refcount btree cursors wherever they're needed
throughout the code base.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree.h    |    2 -
 fs/xfs/libxfs/xfs_refcount.c |  100 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_rtgroup.c  |    9 ++++
 fs/xfs/libxfs/xfs_rtgroup.h  |    5 ++
 fs/xfs/xfs_fsmap.c           |   25 +++++------
 fs/xfs/xfs_reflink.c         |   66 ++++++++++++++++++++++++++--
 6 files changed, 187 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index dbc047b2fb2cf5..355b304696e6c3 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -297,7 +297,7 @@ struct xfs_btree_cur
 		struct {
 			unsigned int	nr_ops;		/* # record updates */
 			unsigned int	shape_changes;	/* # of extent splits */
-		} bc_refc;	/* refcountbt */
+		} bc_refc;	/* refcountbt/rtrefcountbt */
 	};
 
 	/* Must be at the end of the struct! */
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 8007d15856252b..11bff098db2dbb 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -27,6 +27,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtalloc.h"
+#include "xfs_rtrefcount_btree.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -1462,6 +1463,32 @@ xfs_refcount_finish_one(
 	return error;
 }
 
+/*
+ * Set up a continuation a deferred rtrefcount operation by updating the
+ * intent.  Checks to make sure we're not going to run off the end of the
+ * rtgroup.
+ */
+static inline int
+xfs_rtrefcount_continue_op(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_intent	*ri,
+	xfs_agblock_t			new_agbno)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_rtgroup		*rtg = to_rtg(ri->ri_group);
+
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_rgbext(rtg, new_agbno,
+					ri->ri_blockcount))) {
+		xfs_btree_mark_sick(cur);
+		return -EFSCORRUPTED;
+	}
+
+	ri->ri_startblock = xfs_rgbno_to_rtb(rtg, new_agbno);
+
+	ASSERT(xfs_verify_rtbext(mp, ri->ri_startblock, ri->ri_blockcount));
+	return 0;
+}
+
 /*
  * Process one of the deferred realtime refcount operations.  We pass back the
  * btree cursor to maintain our lock on the btree between calls.
@@ -1472,8 +1499,77 @@ xfs_rtrefcount_finish_one(
 	struct xfs_refcount_intent	*ri,
 	struct xfs_btree_cur		**pcur)
 {
-	ASSERT(0);
-	return -EFSCORRUPTED;
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rtgroup		*rtg = to_rtg(ri->ri_group);
+	struct xfs_btree_cur		*rcur = *pcur;
+	int				error = 0;
+	xfs_rgblock_t			bno;
+	unsigned long			nr_ops = 0;
+	int				shape_changes = 0;
+
+	bno = xfs_rtb_to_rgbno(mp, ri->ri_startblock);
+
+	trace_xfs_refcount_deferred(mp, ri);
+
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
+		return -EIO;
+
+	/*
+	 * If we haven't gotten a cursor or the cursor AG doesn't match
+	 * the startblock, get one now.
+	 */
+	if (rcur != NULL && rcur->bc_group != ri->ri_group) {
+		nr_ops = rcur->bc_refc.nr_ops;
+		shape_changes = rcur->bc_refc.shape_changes;
+		xfs_btree_del_cursor(rcur, 0);
+		rcur = NULL;
+		*pcur = NULL;
+	}
+	if (rcur == NULL) {
+		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_REFCOUNT);
+		xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_REFCOUNT);
+		*pcur = rcur = xfs_rtrefcountbt_init_cursor(tp, rtg);
+
+		rcur->bc_refc.nr_ops = nr_ops;
+		rcur->bc_refc.shape_changes = shape_changes;
+	}
+
+	switch (ri->ri_type) {
+	case XFS_REFCOUNT_INCREASE:
+		error = xfs_refcount_adjust(rcur, &bno, &ri->ri_blockcount,
+				XFS_REFCOUNT_ADJUST_INCREASE);
+		if (error)
+			return error;
+		if (ri->ri_blockcount > 0)
+			error = xfs_rtrefcount_continue_op(rcur, ri, bno);
+		break;
+	case XFS_REFCOUNT_DECREASE:
+		error = xfs_refcount_adjust(rcur, &bno, &ri->ri_blockcount,
+				XFS_REFCOUNT_ADJUST_DECREASE);
+		if (error)
+			return error;
+		if (ri->ri_blockcount > 0)
+			error = xfs_rtrefcount_continue_op(rcur, ri, bno);
+		break;
+	case XFS_REFCOUNT_ALLOC_COW:
+		error = __xfs_refcount_cow_alloc(rcur, bno, ri->ri_blockcount);
+		if (error)
+			return error;
+		ri->ri_blockcount = 0;
+		break;
+	case XFS_REFCOUNT_FREE_COW:
+		error = __xfs_refcount_cow_free(rcur, bno, ri->ri_blockcount);
+		if (error)
+			return error;
+		ri->ri_blockcount = 0;
+		break;
+	default:
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+	if (!error && ri->ri_blockcount > 0)
+		trace_xfs_refcount_finish_one_leftover(mp, ri);
+	return error;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 6aebe9f484901f..d5ecc2f6c5c202 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -206,6 +206,9 @@ xfs_rtgroup_lock(
 
 	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
 		xfs_ilock(rtg_rmap(rtg), XFS_ILOCK_EXCL);
+
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg_refcount(rtg))
+		xfs_ilock(rtg_refcount(rtg), XFS_ILOCK_EXCL);
 }
 
 /* Unlock metadata inodes associated with this rt group. */
@@ -218,6 +221,9 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg_refcount(rtg))
+		xfs_iunlock(rtg_refcount(rtg), XFS_ILOCK_EXCL);
+
 	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
 		xfs_iunlock(rtg_rmap(rtg), XFS_ILOCK_EXCL);
 
@@ -249,6 +255,9 @@ xfs_rtgroup_trans_join(
 
 	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
 		xfs_trans_ijoin(tp, rtg_rmap(rtg), XFS_ILOCK_EXCL);
+
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg_refcount(rtg))
+		xfs_trans_ijoin(tp, rtg_refcount(rtg), XFS_ILOCK_EXCL);
 }
 
 /* Retrieve rt group geometry. */
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 385ea8e2f28b67..de4eeb381fc9fc 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -273,10 +273,13 @@ int xfs_update_last_rtgroup_size(struct xfs_mount *mp,
 #define XFS_RTGLOCK_BITMAP_SHARED	(1U << 1)
 /* Lock the rt rmap inode in exclusive mode */
 #define XFS_RTGLOCK_RMAP		(1U << 2)
+/* Lock the rt refcount inode in exclusive mode */
+#define XFS_RTGLOCK_REFCOUNT		(1U << 3)
 
 #define XFS_RTGLOCK_ALL_FLAGS	(XFS_RTGLOCK_BITMAP | \
 				 XFS_RTGLOCK_BITMAP_SHARED | \
-				 XFS_RTGLOCK_RMAP)
+				 XFS_RTGLOCK_RMAP | \
+				 XFS_RTGLOCK_REFCOUNT)
 
 void xfs_rtgroup_lock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 3e3ef16f65a335..1dbd2d75f7ae3e 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -27,6 +27,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 static void
@@ -212,21 +213,20 @@ xfs_getfsmap_is_shared(
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_btree_cur		*cur;
 	xfs_agblock_t			fbno;
-	xfs_extlen_t			flen;
+	xfs_extlen_t			flen = 0;
 	int				error;
 
 	*stat = false;
-	if (!xfs_has_reflink(mp))
-		return 0;
-	/* rt files will have no perag structure */
-	if (!info->group)
+	if (!xfs_has_reflink(mp) || !info->group)
 		return 0;
 
+	if (info->group->xg_type == XG_TYPE_RTG)
+		cur = xfs_rtrefcountbt_init_cursor(tp, to_rtg(info->group));
+	else
+		cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
+				to_perag(info->group));
+
 	/* Are there any shared blocks here? */
-	flen = 0;
-	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
-			to_perag(info->group));
-
 	error = xfs_refcount_find_shared(cur, frec->rec_key,
 			XFS_BB_TO_FSBT(mp, frec->len_daddr), &fbno, &flen,
 			false);
@@ -863,7 +863,7 @@ xfs_getfsmap_rtdev_rmapbt_query(
 	struct xfs_rtgroup		*rtg = to_rtg(info->group);
 
 	/* Query the rtrmapbt */
-	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP | XFS_RTGLOCK_REFCOUNT);
 	*curpp = xfs_rtrmapbt_init_cursor(tp, rtg);
 	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
 			xfs_getfsmap_rtdev_rmapbt_helper, info);
@@ -950,7 +950,8 @@ xfs_getfsmap_rtdev_rmapbt(
 
 		if (bt_cur) {
 			xfs_rtgroup_unlock(to_rtg(bt_cur->bc_group),
-					XFS_RTGLOCK_RMAP);
+					XFS_RTGLOCK_RMAP |
+					XFS_RTGLOCK_REFCOUNT);
 			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
 			bt_cur = NULL;
 		}
@@ -988,7 +989,7 @@ xfs_getfsmap_rtdev_rmapbt(
 
 	if (bt_cur) {
 		xfs_rtgroup_unlock(to_rtg(bt_cur->bc_group),
-				XFS_RTGLOCK_RMAP);
+				XFS_RTGLOCK_RMAP | XFS_RTGLOCK_REFCOUNT);
 		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
 							 XFS_BTREE_NOERROR);
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 71b4743ffb7741..66ce29101462cd 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -30,6 +30,9 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_health.h"
+#include "xfs_rtrefcount_btree.h"
+#include "xfs_rtalloc.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -163,6 +166,53 @@ xfs_reflink_find_shared(
 	return error;
 }
 
+/*
+ * Given a file mapping for the rt device, find the lowest-numbered run of
+ * shared blocks within that mapping and return it in shared_offset/shared_len.
+ * The offset is relative to the start of irec.
+ *
+ * If find_end_of_shared is true, return the longest contiguous extent of shared
+ * blocks.  If there are no shared extents, shared_offset and shared_len will be
+ * set to 0;
+ */
+static int
+xfs_reflink_find_rtshared(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	const struct xfs_bmbt_irec *irec,
+	xfs_extlen_t		*shared_offset,
+	xfs_extlen_t		*shared_len,
+	bool			find_end_of_shared)
+{
+	struct xfs_rtgroup	*rtg;
+	struct xfs_btree_cur	*cur;
+	xfs_rgblock_t		orig_bno;
+	xfs_agblock_t		found_bno;
+	int			error;
+
+	BUILD_BUG_ON(NULLRGBLOCK != NULLAGBLOCK);
+
+	/*
+	 * Note: this uses the not quite correct xfs_agblock_t type because
+	 * xfs_refcount_find_shared is shared between the RT and data device
+	 * refcount code.
+	 */
+	orig_bno = xfs_rtb_to_rgbno(mp, irec->br_startblock);
+	rtg = xfs_rtgroup_get(mp, xfs_rtb_to_rgno(mp, irec->br_startblock));
+
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_REFCOUNT);
+	cur = xfs_rtrefcountbt_init_cursor(tp, rtg);
+	error = xfs_refcount_find_shared(cur, orig_bno, irec->br_blockcount,
+			&found_bno, shared_len, find_end_of_shared);
+	xfs_btree_del_cursor(cur, error);
+	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_REFCOUNT);
+	xfs_rtgroup_put(rtg);
+
+	if (!error && *shared_len)
+		*shared_offset = found_bno - orig_bno;
+	return error;
+}
+
 /*
  * Trim the mapping to the next block where there's a change in the
  * shared/unshared status.  More specifically, this means that we
@@ -191,8 +241,12 @@ xfs_reflink_trim_around_shared(
 
 	trace_xfs_reflink_trim_around_shared(ip, irec);
 
-	error = xfs_reflink_find_shared(mp, NULL, irec, &shared_offset,
-			&shared_len, true);
+	if (XFS_IS_REALTIME_INODE(ip))
+		error = xfs_reflink_find_rtshared(mp, NULL, irec,
+				&shared_offset, &shared_len, true);
+	else
+		error = xfs_reflink_find_shared(mp, NULL, irec,
+				&shared_offset, &shared_len, true);
 	if (error)
 		return error;
 
@@ -1554,8 +1608,12 @@ xfs_reflink_inode_has_shared_extents(
 		    got.br_state != XFS_EXT_NORM)
 			goto next;
 
-		error = xfs_reflink_find_shared(mp, tp, &got, &shared_offset,
-				&shared_len, false);
+		if (XFS_IS_REALTIME_INODE(ip))
+			error = xfs_reflink_find_rtshared(mp, tp, &got,
+					&shared_offset, &shared_len, false);
+		else
+			error = xfs_reflink_find_shared(mp, tp, &got,
+					&shared_offset, &shared_len, false);
 		if (error)
 			return error;
 

