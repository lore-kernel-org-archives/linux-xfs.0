Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575D823C378
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881934; cv=none; b=l4GWsha5JRWvsAuonusGa1UVUoy3r9DW/XSjTA59py9hk4EAP2Svqdrb7JN64G+bigRI+Vp+yNowB/Q1DT6f/0UI4U0jMG5LwFXe/kdJQgLN3PHl9wS3PLj/0bf0rKLAdJP0ai3m6lwSKcT6qCD1xVN+ldVDE1Nrhy7bB2+zFbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881934; c=relaxed/simple;
	bh=NuJ9OFja91ICeHZJkfwjdwR7ou0Fvrahvba7cWPZwkM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QqCmMUuiUsjh4BVG5ScKSNIKKRvIdEu4bRVl/gCXiu3eua2P3hNxSlxIglgy8OE/XHeJk2qLuPiAuY3XL4/HGW7BliDxnKoXAxISypreBYSL7nEnwRpE6V9nTYLVRuBi8Jp/Z+CNi1GfIeqWVnOf2Arj55ellpLXE9ScloAIKyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ALbozP8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ALbozP8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355E4C4CEDD;
	Thu,  6 Feb 2025 22:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881934;
	bh=NuJ9OFja91ICeHZJkfwjdwR7ou0Fvrahvba7cWPZwkM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ALbozP8M5iwc+OTBh1jGPD5bHu+EE/S1Yb8sX4wiBVE2+ZKoa97volwicxGHUYibs
	 0ADILLqMlK8mgTbEc+evMRec0UNqWwfPnXDB3mYoeywiLW9S4C1eMjzizeMmw0yKGT
	 tpF3jrT15Y21Tl7MnBloQrG5KIKdh/F8DImyqr3u41/JtfLcpj+s+/RORHtCGirgUA
	 R8SaNNUED8sUCl2PhmLiZKXHJ2+II5Sm91u/Nt0DBFCk8gc0vNPvrTnM3UgcSXey9B
	 UidFl1dFarbb3qy1tWsn1pS03CKckwaqh1f1s7r+VSCiyHcTZ3QeqlMv1GrqLEVQ/M
	 1vfNsZNDq/LFQ==
Date: Thu, 06 Feb 2025 14:45:33 -0800
Subject: [PATCH 40/56] xfs: wire up realtime refcount btree cursors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087404.2739176.17196415377274490407.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: e5a171729baf61b703069b11fa0d2955890e9b6b

Wire up realtime refcount btree cursors wherever they're needed
throughout the code base.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree.h    |    2 -
 libxfs/xfs_refcount.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_rtgroup.c  |    9 ++++
 libxfs/xfs_rtgroup.h  |    5 ++
 4 files changed, 112 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index dbc047b2fb2cf5..355b304696e6c3 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -297,7 +297,7 @@ struct xfs_btree_cur
 		struct {
 			unsigned int	nr_ops;		/* # record updates */
 			unsigned int	shape_changes;	/* # of extent splits */
-		} bc_refc;	/* refcountbt */
+		} bc_refc;	/* refcountbt/rtrefcountbt */
 	};
 
 	/* Must be at the end of the struct! */
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index ef08c26c75b32c..738c3cd4ea5131 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -25,6 +25,7 @@
 #include "xfs_health.h"
 #include "defer_item.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrefcount_btree.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -1460,6 +1461,32 @@ xfs_refcount_finish_one(
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
@@ -1470,8 +1497,77 @@ xfs_rtrefcount_finish_one(
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
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index f7bacce8500c0c..e1f853dd2c5b3e 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -203,6 +203,9 @@ xfs_rtgroup_lock(
 
 	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
 		xfs_ilock(rtg_rmap(rtg), XFS_ILOCK_EXCL);
+
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg_refcount(rtg))
+		xfs_ilock(rtg_refcount(rtg), XFS_ILOCK_EXCL);
 }
 
 /* Unlock metadata inodes associated with this rt group. */
@@ -215,6 +218,9 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg_refcount(rtg))
+		xfs_iunlock(rtg_refcount(rtg), XFS_ILOCK_EXCL);
+
 	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
 		xfs_iunlock(rtg_rmap(rtg), XFS_ILOCK_EXCL);
 
@@ -246,6 +252,9 @@ xfs_rtgroup_trans_join(
 
 	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
 		xfs_trans_ijoin(tp, rtg_rmap(rtg), XFS_ILOCK_EXCL);
+
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg_refcount(rtg))
+		xfs_trans_ijoin(tp, rtg_refcount(rtg), XFS_ILOCK_EXCL);
 }
 
 /* Retrieve rt group geometry. */
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 2663f2d849e295..03f39d4e43fc7f 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
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

