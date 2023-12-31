Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E170BBE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0C3xqsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE588C433C8;
	Sun, 31 Dec 2023 21:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059293;
	bh=ZD8N+nCWdNTvfc53yO/w2Dq1ZUe/JEGRyt4HQRPKm1M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g0C3xqsm0PMKZtE2c0O8GSJ20/aWomhfuixoDwsIMIezpgso23RD/rMNzkoW6HGRq
	 JztgQWvt+kVoecLqPPW4HODOEDPFWcAHCnpJswloi45ospobIB2B2aewgxUR+mxhxB
	 YM7V/BCF5gaRspR/EIe3IKzKjNAyFVPlEU8seMJLFLnQzRCX0G0RjKrpB1JOvoRnP8
	 KAx4TrR7SYJ8sR5H1eL1SYXMwBOpkpjQzFt1O++KcipMiUarMZ4eJV+Fb6jCs/KzUD
	 xdbfE4Fq04PvA+VqUWIQUvJsMmzYXghtzuhDxVSY2x0/65veDfbYtzoketmaBAsILD
	 sVsA9XuSrYOxA==
Date: Sun, 31 Dec 2023 13:48:13 -0800
Subject: [PATCH 14/44] xfs: wire up realtime refcount btree cursors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851809.1766284.6640915780614547754.stgit@frogsfrogsfrogs>
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

Wire up realtime refcount btree cursors wherever they're needed
throughout the code base.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |  101 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_rtgroup.c  |   10 ++++
 fs/xfs/libxfs/xfs_rtgroup.h  |    5 ++
 fs/xfs/xfs_fsmap.c           |   22 ++++++---
 fs/xfs/xfs_reflink.c         |   99 +++++++++++++++++++++++++++++++++--------
 5 files changed, 206 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 2ae126d3bd7ff..60e838adde0d8 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -27,6 +27,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtalloc.h"
+#include "xfs_rtrefcount_btree.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -1486,6 +1487,33 @@ xfs_refcount_finish_one(
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
+	struct xfs_rtgroup		*rtg = ri->ri_rtg;
+
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_rgbext(rtg, new_agbno,
+					ri->ri_blockcount))) {
+		xfs_btree_mark_sick(cur);
+		return -EFSCORRUPTED;
+	}
+
+	ri->ri_startblock = xfs_rgbno_to_rtb(mp, rtg->rtg_rgno, new_agbno);
+
+	ASSERT(xfs_verify_rtbext(mp, ri->ri_startblock, ri->ri_blockcount));
+	ASSERT(rtg->rtg_rgno == xfs_rtb_to_rgno(mp, ri->ri_startblock));
+	return 0;
+}
+
 /*
  * Process one of the deferred realtime refcount operations.  We pass back the
  * btree cursor to maintain our lock on the btree between calls.
@@ -1496,8 +1524,77 @@ xfs_rtrefcount_finish_one(
 	struct xfs_refcount_intent	*ri,
 	struct xfs_btree_cur		**pcur)
 {
-	ASSERT(0);
-	return -EFSCORRUPTED;
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*rcur = *pcur;
+	int				error = 0;
+	xfs_rgnumber_t			rgno;
+	xfs_rgblock_t			bno;
+	unsigned long			nr_ops = 0;
+	int				shape_changes = 0;
+
+	bno = xfs_rtb_to_rgbno(mp, ri->ri_startblock, &rgno);
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
+	if (rcur != NULL && rcur->bc_ino.rtg != ri->ri_rtg) {
+		nr_ops = xrefc_btree_state(rcur)->nr_ops;
+		shape_changes = xrefc_btree_state(rcur)->shape_changes;
+		xfs_btree_del_cursor(rcur, 0);
+		rcur = NULL;
+		*pcur = NULL;
+	}
+	if (rcur == NULL) {
+		xfs_rtgroup_lock(tp, ri->ri_rtg, XFS_RTGLOCK_REFCOUNT);
+		*pcur = rcur = xfs_rtrefcountbt_init_cursor(mp, tp, ri->ri_rtg,
+						ri->ri_rtg->rtg_refcountip);
+
+		xrefc_btree_state(rcur)->nr_ops = nr_ops;
+		xrefc_btree_state(rcur)->shape_changes = shape_changes;
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
index 8bc97c9aa4c9c..173c3887788f7 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -561,6 +561,13 @@ xfs_rtgroup_lock(
 		if (tp)
 			xfs_trans_ijoin(tp, rtg->rtg_rmapip, XFS_ILOCK_EXCL);
 	}
+
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg->rtg_refcountip) {
+		xfs_ilock(rtg->rtg_refcountip, XFS_ILOCK_EXCL);
+		if (tp)
+			xfs_trans_ijoin(tp, rtg->rtg_refcountip,
+					XFS_ILOCK_EXCL);
+	}
 }
 
 /* Unlock metadata inodes associated with this rt group. */
@@ -573,6 +580,9 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg->rtg_refcountip)
+		xfs_iunlock(rtg->rtg_refcountip, XFS_ILOCK_EXCL);
+
 	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg->rtg_rmapip)
 		xfs_iunlock(rtg->rtg_rmapip, XFS_ILOCK_EXCL);
 
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index bd88a4d728135..659d0c15d2ade 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -248,10 +248,13 @@ int xfs_rtgroup_init_secondary_super(struct xfs_mount *mp, xfs_rgnumber_t rgno,
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
 
 void xfs_rtgroup_lock(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index b0eabc76eb28a..cc8175af986aa 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -27,6 +27,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 static void
@@ -216,14 +217,16 @@ xfs_getfsmap_is_shared(
 	*stat = false;
 	if (!xfs_has_reflink(mp))
 		return 0;
-	/* rt files will have no perag structure */
-	if (!info->pag)
-		return 0;
+
+	if (info->rtg)
+		cur = xfs_rtrefcountbt_init_cursor(mp, tp, info->rtg,
+				info->rtg->rtg_refcountip);
+	else
+		cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
+				info->pag);
 
 	/* Are there any shared blocks here? */
 	flen = 0;
-	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp, info->pag);
-
 	error = xfs_refcount_find_shared(cur, rec->rm_startblock,
 			rec->rm_blockcount, &fbno, &flen, false);
 
@@ -828,7 +831,8 @@ xfs_getfsmap_rtdev_rmapbt_query(
 				info);
 
 	/* Query the rtrmapbt */
-	xfs_rtgroup_lock(NULL, info->rtg, XFS_RTGLOCK_RMAP);
+	xfs_rtgroup_lock(NULL, info->rtg, XFS_RTGLOCK_RMAP |
+					  XFS_RTGLOCK_REFCOUNT);
 	*curpp = xfs_rtrmapbt_init_cursor(mp, tp, info->rtg,
 			info->rtg->rtg_rmapip);
 	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
@@ -917,7 +921,8 @@ xfs_getfsmap_rtdev_rmapbt(
 
 		if (bt_cur) {
 			xfs_rtgroup_unlock(bt_cur->bc_ino.rtg,
-					XFS_RTGLOCK_RMAP);
+					XFS_RTGLOCK_RMAP |
+					XFS_RTGLOCK_REFCOUNT);
 			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
 			bt_cur = NULL;
 		}
@@ -954,7 +959,8 @@ xfs_getfsmap_rtdev_rmapbt(
 	}
 
 	if (bt_cur) {
-		xfs_rtgroup_unlock(bt_cur->bc_ino.rtg, XFS_RTGLOCK_RMAP);
+		xfs_rtgroup_unlock(bt_cur->bc_ino.rtg, XFS_RTGLOCK_RMAP |
+						       XFS_RTGLOCK_REFCOUNT);
 		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
 							 XFS_BTREE_NOERROR);
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 591782ca7d284..a10d43a1a7da4 100644
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
@@ -155,6 +158,38 @@ xfs_reflink_find_shared(
 	return error;
 }
 
+/*
+ * Given an RT extent, find the lowest-numbered run of shared blocks
+ * within that range and return the range in fbno/flen.  If
+ * find_end_of_shared is true, return the longest contiguous extent of
+ * shared blocks.  If there are no shared extents, fbno and flen will
+ * be set to NULLRGBLOCK and 0, respectively.
+ */
+static int
+xfs_reflink_find_rtshared(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_trans	*tp,
+	xfs_agblock_t		rtbno,
+	xfs_extlen_t		rtlen,
+	xfs_agblock_t		*fbno,
+	xfs_extlen_t		*flen,
+	bool			find_end_of_shared)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	BUILD_BUG_ON(NULLRGBLOCK != NULLAGBLOCK);
+
+	xfs_rtgroup_lock(NULL, rtg, XFS_RTGLOCK_REFCOUNT);
+	cur = xfs_rtrefcountbt_init_cursor(mp, tp, rtg, rtg->rtg_refcountip);
+	error = xfs_refcount_find_shared(cur, rtbno, rtlen, fbno, flen,
+			find_end_of_shared);
+	xfs_btree_del_cursor(cur, error);
+	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_REFCOUNT);
+	return error;
+}
+
 /*
  * Trim the mapping to the next block where there's a change in the
  * shared/unshared status.  More specifically, this means that we
@@ -172,9 +207,7 @@ xfs_reflink_trim_around_shared(
 	bool			*shared)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_perag	*pag;
-	xfs_agblock_t		agbno;
-	xfs_extlen_t		aglen;
+	xfs_agblock_t		orig_bno;
 	xfs_agblock_t		fbno;
 	xfs_extlen_t		flen;
 	int			error = 0;
@@ -187,13 +220,25 @@ xfs_reflink_trim_around_shared(
 
 	trace_xfs_reflink_trim_around_shared(ip, irec);
 
-	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, irec->br_startblock));
-	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
-	aglen = irec->br_blockcount;
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		struct xfs_rtgroup	*rtg;
+		xfs_rgnumber_t		rgno;
 
-	error = xfs_reflink_find_shared(pag, NULL, agbno, aglen, &fbno, &flen,
-			true);
-	xfs_perag_put(pag);
+		orig_bno = xfs_rtb_to_rgbno(mp, irec->br_startblock, &rgno);
+		rtg = xfs_rtgroup_get(mp, rgno);
+		error = xfs_reflink_find_rtshared(rtg, NULL, orig_bno,
+				irec->br_blockcount, &fbno, &flen, true);
+		xfs_rtgroup_put(rtg);
+	} else {
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp,
+					irec->br_startblock));
+		orig_bno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
+		error = xfs_reflink_find_shared(pag, NULL, orig_bno,
+				irec->br_blockcount, &fbno, &flen, true);
+		xfs_perag_put(pag);
+	}
 	if (error)
 		return error;
 
@@ -203,7 +248,7 @@ xfs_reflink_trim_around_shared(
 		return 0;
 	}
 
-	if (fbno == agbno) {
+	if (fbno == orig_bno) {
 		/*
 		 * The start of this extent is shared.  Truncate the
 		 * mapping at the end of the shared region so that a
@@ -221,7 +266,7 @@ xfs_reflink_trim_around_shared(
 	 * extent so that a subsequent iteration starts at the
 	 * start of the shared region.
 	 */
-	irec->br_blockcount = fbno - agbno;
+	irec->br_blockcount = fbno - orig_bno;
 	return 0;
 }
 
@@ -1582,9 +1627,6 @@ xfs_reflink_inode_has_shared_extents(
 	*has_shared = false;
 	found = xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got);
 	while (found) {
-		struct xfs_perag	*pag;
-		xfs_agblock_t		agbno;
-		xfs_extlen_t		aglen;
 		xfs_agblock_t		rbno;
 		xfs_extlen_t		rlen;
 
@@ -1592,12 +1634,29 @@ xfs_reflink_inode_has_shared_extents(
 		    got.br_state != XFS_EXT_NORM)
 			goto next;
 
-		pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, got.br_startblock));
-		agbno = XFS_FSB_TO_AGBNO(mp, got.br_startblock);
-		aglen = got.br_blockcount;
-		error = xfs_reflink_find_shared(pag, tp, agbno, aglen,
-				&rbno, &rlen, false);
-		xfs_perag_put(pag);
+		if (XFS_IS_REALTIME_INODE(ip)) {
+			struct xfs_rtgroup	*rtg;
+			xfs_rgnumber_t		rgno;
+			xfs_rgblock_t		rgbno;
+
+			rgbno = xfs_rtb_to_rgbno(mp, got.br_startblock, &rgno);
+			rtg = xfs_rtgroup_get(mp, rgno);
+			error = xfs_reflink_find_rtshared(rtg, tp, rgbno,
+					got.br_blockcount, &rbno, &rlen,
+					false);
+			xfs_rtgroup_put(rtg);
+		} else {
+			struct xfs_perag	*pag;
+			xfs_agblock_t		agbno;
+
+			pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp,
+						got.br_startblock));
+			agbno = XFS_FSB_TO_AGBNO(mp, got.br_startblock);
+			error = xfs_reflink_find_shared(pag, tp, agbno,
+					got.br_blockcount, &rbno, &rlen,
+					false);
+			xfs_perag_put(pag);
+		}
 		if (error)
 			return error;
 

