Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE775AD21
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295221; cv=none; b=Ii2Xr31VFcoTEhnNU1369ay4iYvITl2WS3baTtKZ/y5v7kOG5fb+CVDC0nZEcmLH4NM8OPv1T2vDipNTP6WJKs4xz1xA9Jvj3V3Xj4BbTUotoAm7x2AZMcGCiciwBky2Q3WyNb/WpoBOaMA+IwlOpd6dcbUyJEp07dGlK+yk2mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295221; c=relaxed/simple;
	bh=dNmXvJkry4WBKk5FvOxqvSAEQmsrc2nOCNOhGfn9wos=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dgNu3RVrjoA/jlFzbHtSMwvlvuH0aKqb2LKg3ADFs/CbpqKXNJCnWMF97+pvxHnqxMY3s75YDxZfTZ6fAVy5Gl2XxxIkoS/tPSwLsMaoMtl5+K+wfiX4pHLy9RwKyyTTw5clvsqN3MAbsQJ1yvMyPVL0qA9faAVPyvaMoeZRnr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIWHdJ8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIWHdJ8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB44C433F1;
	Wed, 13 Mar 2024 02:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295220;
	bh=dNmXvJkry4WBKk5FvOxqvSAEQmsrc2nOCNOhGfn9wos=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HIWHdJ8XfdV9xCgRZsNKOK4cPbzaYVRj/AGOrO5PTnHr4fiy5jZY9gEmxDH/VWISS
	 8l8KdV5iWgeGHURhxANtTH/GpmJTlfOp5J9J9Y4BjPTEpHFxn01m3cFHRyP758ZJnu
	 1SpVrU6gxmE6zMOhxr8DJAd2v97vwCBRqmozmM+06tRXlNgClMrjaATKj9pkJ1Ldc3
	 +zzwU83NsRE66sIZ3R7QGsPcZJMZYpBBVM16J8dzrS83yjCOtyBZGTnw/DMinvwbMh
	 D65NQp4ew3W6BmWgFf97ybZJieuFWlFbkj4d0RxGolKPvXHs5ry5UJFf2Kz+zaFPcB
	 /B3rVPslpVUnw==
Date: Tue, 12 Mar 2024 19:00:20 -0700
Subject: [PATCH 28/67] xfs: pass the defer ops directly to xfs_defer_add
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431597.2061787.715743730657703356.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 603ce8ab12094a2d9483c79a7541335e258a5328

Pass a pointer to the xfs_defer_op_type structure to xfs_defer_add and
remove the indirection through the xfs_defer_ops_type enum and a global
table of all possible operations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_alloc.c    |    4 ++--
 libxfs/xfs_attr.c     |    2 +-
 libxfs/xfs_bmap.c     |    2 +-
 libxfs/xfs_defer.c    |   16 ++--------------
 libxfs/xfs_defer.h    |   18 ++----------------
 libxfs/xfs_refcount.c |    2 +-
 libxfs/xfs_rmap.c     |    2 +-
 7 files changed, 10 insertions(+), 36 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 463381be7863..aaa1596157e9 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2510,7 +2510,7 @@ xfs_defer_agfl_block(
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
 	xfs_extent_free_get_group(mp, xefi);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &xefi->xefi_list);
+	xfs_defer_add(tp, &xefi->xefi_list, &xfs_agfl_free_defer_type);
 	return 0;
 }
 
@@ -2574,7 +2574,7 @@ xfs_defer_extent_free(
 			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
 
 	xfs_extent_free_get_group(mp, xefi);
-	*dfpp = xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
+	*dfpp = xfs_defer_add(tp, &xefi->xefi_list, &xfs_extent_free_defer_type);
 	return 0;
 }
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 550ca6b2e263..cb6c8d081fd3 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -904,7 +904,7 @@ xfs_attr_defer_add(
 		ASSERT(0);
 	}
 
-	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+	xfs_defer_add(args->trans, &new->xattri_list, &xfs_attr_defer_type);
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
 }
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 20ec22dfcaf4..6d23c5e3e652 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6085,7 +6085,7 @@ __xfs_bmap_add(
 	bi->bi_bmap = *bmap;
 
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_BMAP, &bi->bi_list);
+	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
 	return 0;
 }
 
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 033283017fae..077e99298074 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -229,16 +229,6 @@ static const struct xfs_defer_op_type xfs_barrier_defer_type = {
 	.cancel_item	= xfs_defer_barrier_cancel_item,
 };
 
-static const struct xfs_defer_op_type *defer_op_types[] = {
-	[XFS_DEFER_OPS_TYPE_BMAP]	= &xfs_bmap_update_defer_type,
-	[XFS_DEFER_OPS_TYPE_REFCOUNT]	= &xfs_refcount_update_defer_type,
-	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
-	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
-	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
-	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
-	[XFS_DEFER_OPS_TYPE_BARRIER]	= &xfs_barrier_defer_type,
-};
-
 /* Create a log intent done item for a log intent item. */
 static inline void
 xfs_defer_create_done(
@@ -841,14 +831,12 @@ xfs_defer_alloc(
 struct xfs_defer_pending *
 xfs_defer_add(
 	struct xfs_trans		*tp,
-	enum xfs_defer_ops_type		type,
-	struct list_head		*li)
+	struct list_head		*li,
+	const struct xfs_defer_op_type	*ops)
 {
 	struct xfs_defer_pending	*dfp = NULL;
-	const struct xfs_defer_op_type	*ops = defer_op_types[type];
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
-	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
 
 	dfp = xfs_defer_find_last(tp, ops);
 	if (!dfp || !xfs_defer_can_append(dfp, ops))
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 60de91b66392..18a9fb92dde8 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -10,20 +10,6 @@ struct xfs_btree_cur;
 struct xfs_defer_op_type;
 struct xfs_defer_capture;
 
-/*
- * Header for deferred operation list.
- */
-enum xfs_defer_ops_type {
-	XFS_DEFER_OPS_TYPE_BMAP,
-	XFS_DEFER_OPS_TYPE_REFCOUNT,
-	XFS_DEFER_OPS_TYPE_RMAP,
-	XFS_DEFER_OPS_TYPE_FREE,
-	XFS_DEFER_OPS_TYPE_AGFL_FREE,
-	XFS_DEFER_OPS_TYPE_ATTR,
-	XFS_DEFER_OPS_TYPE_BARRIER,
-	XFS_DEFER_OPS_TYPE_MAX,
-};
-
 /*
  * Save a log intent item and a list of extents, so that we can replay
  * whatever action had to happen to the extent list and file the log done
@@ -51,8 +37,8 @@ struct xfs_defer_pending {
 void xfs_defer_item_pause(struct xfs_trans *tp, struct xfs_defer_pending *dfp);
 void xfs_defer_item_unpause(struct xfs_trans *tp, struct xfs_defer_pending *dfp);
 
-struct xfs_defer_pending *xfs_defer_add(struct xfs_trans *tp,
-		enum xfs_defer_ops_type type, struct list_head *h);
+struct xfs_defer_pending *xfs_defer_add(struct xfs_trans *tp, struct list_head *h,
+		const struct xfs_defer_op_type *ops);
 int xfs_defer_finish_noroll(struct xfs_trans **tp);
 int xfs_defer_finish(struct xfs_trans **tp);
 int xfs_defer_finish_one(struct xfs_trans *tp, struct xfs_defer_pending *dfp);
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 2284b45fbb04..45f8134e4314 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1457,7 +1457,7 @@ __xfs_refcount_add(
 	ri->ri_blockcount = blockcount;
 
 	xfs_refcount_update_get_group(tp->t_mountp, ri);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_REFCOUNT, &ri->ri_list);
+	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
 }
 
 /*
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 5ff6d7a32f2f..4731e10d2101 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2566,7 +2566,7 @@ __xfs_rmap_add(
 	ri->ri_bmap = *bmap;
 
 	xfs_rmap_update_get_group(tp->t_mountp, ri);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
+	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
 }
 
 /* Map an extent into a file. */

