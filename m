Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A65389
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WP0tgzzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61085C433C8;
	Mon,  1 Jan 2024 00:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068941;
	bh=r4tytUpQK0QjafBc3FZ4ez3eNGI5wcCI9sIjze0c6z4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WP0tgzzs8UWA1bh/iKQlDU8Eu+8Ho8rNsqWAOV42UEU12n+VeXefTWd5OB7DyawgL
	 t6+rMSyBlc3lILOmgp7wQRIhYNRZPBGeC9aV/qhbh4A0Fq0cFI8/rAKpmj89crFh9i
	 1z3VvwbpFB5vZOOhhPflqT2Nn5xxXg0RYhZS2aiQq7zsKPu9B1Ac6fx/Uu6znFDOee
	 wdfIFG++PRFV56QPFhL6BgjQg1kT7hWxpYLFfRPX/lM78L/u8617P2DbziCR8tuZo3
	 x/Z+w2c+venPcNac/chOXcAHmO+GAXy7LxLz3sqygYySJ8JIC0PCjWAJJLx65bKcaS
	 HzF51jM50oXMQ==
Date: Sun, 31 Dec 2023 16:29:00 +9900
Subject: [PATCH 11/42] xfs: wire up realtime refcount btree cursors
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017273.1817107.18222077447852897506.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_refcount.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_rtgroup.c  |   10 +++++
 libxfs/xfs_rtgroup.h  |    5 ++
 3 files changed, 113 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index d4ed0f44fa1..3f0f0f41a69 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -25,6 +25,7 @@
 #include "xfs_health.h"
 #include "defer_item.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrefcount_btree.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -1484,6 +1485,33 @@ xfs_refcount_finish_one(
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
@@ -1494,8 +1522,77 @@ xfs_rtrefcount_finish_one(
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
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 03eb776ef8b..8d13ba6e0ea 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -558,6 +558,13 @@ xfs_rtgroup_lock(
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
@@ -570,6 +577,9 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg->rtg_refcountip)
+		xfs_iunlock(rtg->rtg_refcountip, XFS_ILOCK_EXCL);
+
 	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg->rtg_rmapip)
 		xfs_iunlock(rtg->rtg_rmapip, XFS_ILOCK_EXCL);
 
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index bd88a4d7281..659d0c15d2a 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
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

