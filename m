Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9237464
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607625; cv=none; b=ldUwjQ9g2MhV82W70fqwS3uLYU3LkE4gfLM8ZYOGebXS4+yzl88qS0cjQJRbnDFgkHeLd0+pHHDnQ11UW8qGWdpmJSfHxxWVyjIeoMvDvnPbm8aEz+rHlh2wfvn0RgDYfoW3nvbeAdg3EysrobWOiVHaSPdphBh1DJd6JHJ+qaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607625; c=relaxed/simple;
	bh=482FaR1D0/HbBWqnWqGw5b/KtQ4G30rxcuD+L8bsClE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=idnKccfDKpU1CjqH7sy+7kc6/T8Md/+w6uF+epHylLQszfnqQMnNuNiyh1J1AaNXoeLudGwelJUdHj7VdUx3C9/9JXYgzENoePRiPX9qBXJ5KP0HIlk6yjlEXc0YZpgjHlxdUGFh9i6WRHjew058LmKhvS/uE7jdBCOSYzcGHAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDkUnPzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDkUnPzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF60DC4CEC5;
	Fri, 11 Oct 2024 00:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607625;
	bh=482FaR1D0/HbBWqnWqGw5b/KtQ4G30rxcuD+L8bsClE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bDkUnPzK++8GF5qeS5bWIJPIOKQmIVgj1H3CObIK0FM0CpDeJNxgc2oYSpHk3XY9B
	 Ehklskumlw43NmzHckTisZp+0bX8m7iRp0gcXINUUm2crcBZquYG4SqO5lxLXqpdZo
	 AJMXPI/2ZMpf0+3Wcn0he6U6ezwf936SlEaqK5xQHlzGXfMAWvgxbd9RcNFZglMLVf
	 xIG5uVhJjNdVxA1xiEnSNhten1dbyqVppnxD/oq9EgUKXZyXlMWOTtCumbsCerNaoH
	 s1FbCTmymEpWShB+H/bO9X3d9zUw/W00KxhSD50tUBzEbaM6y7B5xDPULjgZyvlLSx
	 v+T9H45/1hc7Q==
Date: Thu, 10 Oct 2024 17:47:04 -0700
Subject: [PATCH 11/16] xfs: convert busy extent tracking to the generic group
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641452.4176300.4852338052220344991.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
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

Split busy extent tracking from struct xfs_perag into its own private
structure, which can be pointed to by the generic group structure.

Note that this structure is now dynamically allocated instead of embedded
as the upcoming zone XFS code doesn't need it and will also have an
unusually high number of groups due to hardware constraints.  Dynamically
allocating the structure this is a big memory saver for this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c          |    3 -
 fs/xfs/libxfs/xfs_ag.h          |    5 -
 fs/xfs/libxfs/xfs_alloc.c       |   29 +++---
 fs/xfs/libxfs/xfs_alloc_btree.c |    4 -
 fs/xfs/libxfs/xfs_group.c       |   16 +++
 fs/xfs/libxfs/xfs_group.h       |    5 +
 fs/xfs/libxfs/xfs_rmap_btree.c  |    4 -
 fs/xfs/scrub/alloc_repair.c     |    9 +-
 fs/xfs/scrub/reap.c             |    2 
 fs/xfs/xfs_discard.c            |   10 +-
 fs/xfs/xfs_extent_busy.c        |  198 +++++++++++++++++++++++----------------
 fs/xfs/xfs_extent_busy.h        |   59 ++++--------
 12 files changed, 193 insertions(+), 151 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index d2ed559a700cee..a0b2b54309522f 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -209,11 +209,8 @@ xfs_perag_alloc(
 #ifdef __KERNEL__
 	/* Place kernel structure only init below this point. */
 	spin_lock_init(&pag->pag_ici_lock);
-	spin_lock_init(&pag->pagb_lock);
 	INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-	init_waitqueue_head(&pag->pagb_wait);
-	pag->pagb_tree = RB_ROOT;
 #endif /* __KERNEL__ */
 
 	error = xfs_buf_cache_init(&pag->pag_bcache);
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index a8c27906de98a2..242346872351c1 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -80,11 +80,6 @@ struct xfs_perag {
 	uint8_t		pagf_repair_rmap_level;
 #endif
 
-	spinlock_t	pagb_lock;	/* lock for pagb_tree */
-	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
-	unsigned int	pagb_gen;	/* generation count for pagb_tree */
-	wait_queue_head_t pagb_wait;	/* woken when pagb_gen changes */
-
 	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
 
 	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 66e38310a13129..820ffa6ea6bd75 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -331,7 +331,8 @@ xfs_alloc_compute_aligned(
 	bool		busy;
 
 	/* Trim busy sections out of found extent */
-	busy = xfs_extent_busy_trim(args, &bno, &len, busy_gen);
+	busy = xfs_extent_busy_trim(&args->pag->pag_group, args->minlen,
+			args->maxlen, &bno, &len, busy_gen);
 
 	/*
 	 * If we have a largish extent that happens to start before min_agbno,
@@ -1251,7 +1252,7 @@ xfs_alloc_ag_vextent_small(
 	if (fbno == NULLAGBLOCK)
 		goto out;
 
-	xfs_extent_busy_reuse(args->pag, fbno, 1,
+	xfs_extent_busy_reuse(&args->pag->pag_group, fbno, 1,
 			      (args->datatype & XFS_ALLOC_NOBUSY));
 
 	if (args->datatype & XFS_ALLOC_USERDATA) {
@@ -1364,7 +1365,8 @@ xfs_alloc_ag_vextent_exact(
 	 */
 	tbno = fbno;
 	tlen = flen;
-	xfs_extent_busy_trim(args, &tbno, &tlen, &busy_gen);
+	xfs_extent_busy_trim(&args->pag->pag_group, args->minlen, args->maxlen,
+			&tbno, &tlen, &busy_gen);
 
 	/*
 	 * Give up if the start of the extent is busy, or the freespace isn't
@@ -1757,8 +1759,9 @@ xfs_alloc_ag_vextent_near(
 			 * the allocation can be retried.
 			 */
 			trace_xfs_alloc_near_busy(args);
-			error = xfs_extent_busy_flush(args->tp, args->pag,
-					acur.busy_gen, alloc_flags);
+			error = xfs_extent_busy_flush(args->tp,
+					&args->pag->pag_group, acur.busy_gen,
+					alloc_flags);
 			if (error)
 				goto out;
 
@@ -1873,8 +1876,9 @@ xfs_alloc_ag_vextent_size(
 			 * the allocation can be retried.
 			 */
 			trace_xfs_alloc_size_busy(args);
-			error = xfs_extent_busy_flush(args->tp, args->pag,
-					busy_gen, alloc_flags);
+			error = xfs_extent_busy_flush(args->tp,
+					&args->pag->pag_group, busy_gen,
+					alloc_flags);
 			if (error)
 				goto error0;
 
@@ -1972,8 +1976,9 @@ xfs_alloc_ag_vextent_size(
 			 * the allocation can be retried.
 			 */
 			trace_xfs_alloc_size_busy(args);
-			error = xfs_extent_busy_flush(args->tp, args->pag,
-					busy_gen, alloc_flags);
+			error = xfs_extent_busy_flush(args->tp,
+					&args->pag->pag_group, busy_gen,
+					alloc_flags);
 			if (error)
 				goto error0;
 
@@ -3618,8 +3623,8 @@ xfs_alloc_vextent_finish(
 		if (error)
 			goto out_drop_perag;
 
-		ASSERT(!xfs_extent_busy_search(args->pag, args->agbno,
-				args->len));
+		ASSERT(!xfs_extent_busy_search(&args->pag->pag_group,
+				args->agbno, args->len));
 	}
 
 	xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
@@ -4017,7 +4022,7 @@ __xfs_free_extent(
 
 	if (skip_discard)
 		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;
-	xfs_extent_busy_insert(tp, pag, agbno, len, busy_flags);
+	xfs_extent_busy_insert(tp, &pag->pag_group, agbno, len, busy_flags);
 	return 0;
 
 err_release:
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 88e1545ed4c9dc..843174a5903658 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -86,7 +86,7 @@ xfs_allocbt_alloc_block(
 	}
 
 	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_reuse(cur->bc_ag.pag, bno, 1, false);
+	xfs_extent_busy_reuse(&cur->bc_ag.pag->pag_group, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 
@@ -110,7 +110,7 @@ xfs_allocbt_free_block(
 		return error;
 
 	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_insert(cur->bc_tp, agbp->b_pag, bno, 1,
+	xfs_extent_busy_insert(cur->bc_tp, &agbp->b_pag->pag_group, bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 50e35d07a915d7..8f0ddf0d7131a1 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -10,6 +10,7 @@
 #include "xfs_mount.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_extent_busy.h"
 #include "xfs_group.h"
 
 /*
@@ -161,6 +162,9 @@ xfs_group_free(
 	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_ref) != 0);
 
 	xfs_defer_drain_free(&xg->xg_intents_drain);
+#ifdef __KERNEL__
+	kfree(xg->xg_busy_extents);
+#endif
 
 	if (uninit)
 		uninit(xg);
@@ -185,6 +189,9 @@ xfs_group_insert(
 	xg->xg_type = type;
 
 #ifdef __KERNEL__
+	xg->xg_busy_extents = xfs_extent_busy_alloc();
+	if (!xg->xg_busy_extents)
+		return -ENOMEM;
 	spin_lock_init(&xg->xg_state_lock);
 	xfs_hooks_init(&xg->xg_rmap_update_hooks);
 #endif
@@ -196,9 +203,14 @@ xfs_group_insert(
 	error = xa_insert(&mp->m_groups[type].xa, index, xg, GFP_KERNEL);
 	if (error) {
 		WARN_ON_ONCE(error == -EBUSY);
-		xfs_defer_drain_free(&xg->xg_intents_drain);
-		return error;
+		goto out_drain;
 	}
 
 	return 0;
+out_drain:
+	xfs_defer_drain_free(&xg->xg_intents_drain);
+#ifdef __KERNEL__
+	kfree(xg->xg_busy_extents);
+#endif
+	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 485cc5ce99f03f..2f685b04e1d0c9 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -15,6 +15,11 @@ struct xfs_group {
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
 
+	/*
+	 * Track freed but not yet committed extents.
+	 */
+	struct xfs_extent_busy_tree *xg_busy_extents;
+
 	/*
 	 * Bitsets of per-ag metadata that have been checked and/or are sick.
 	 * Callers should hold xg_state_lock before accessing this field.
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 6fd460fc7c9c1d..dca5e29296400b 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -102,7 +102,7 @@ xfs_rmapbt_alloc_block(
 		return 0;
 	}
 
-	xfs_extent_busy_reuse(pag, bno, 1, false);
+	xfs_extent_busy_reuse(&pag->pag_group, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);
@@ -136,7 +136,7 @@ xfs_rmapbt_free_block(
 	if (error)
 		return error;
 
-	xfs_extent_busy_insert(cur->bc_tp, pag, bno, 1,
+	xfs_extent_busy_insert(cur->bc_tp, &pag->pag_group, bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 
 	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index f07cd93012c675..79a8adff21ffdd 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -132,13 +132,16 @@ int
 xrep_setup_ag_allocbt(
 	struct xfs_scrub	*sc)
 {
+	struct xfs_group	*xg = &sc->sa.pag->pag_group;
+	unsigned int		busy_gen;
+
 	/*
 	 * Make sure the busy extent list is clear because we can't put extents
 	 * on there twice.
 	 */
-	if (xfs_extent_busy_list_empty(sc->sa.pag, &busy_gen))
+	if (xfs_extent_busy_list_empty(xg, &busy_gen))
 		return 0;
-	return xfs_extent_busy_flush(sc->tp, sc->sa.pag, busy_gen, 0);
+	return xfs_extent_busy_flush(sc->tp, xg, busy_gen, 0);
 }
 
 /* Check for any obvious conflicts in the free extent. */
@@ -866,7 +869,7 @@ xrep_allocbt(
 	 * on there twice.  In theory we cleared this before we started, but
 	 * let's not risk the filesystem.
 	 */
-	if (!xfs_extent_busy_list_empty(sc->sa.pag, &busy_gen)) {
+	if (!xfs_extent_busy_list_empty(&sc->sa.pag->pag_group, &busy_gen)) {
 		error = -EDEADLOCK;
 		goto out_ra;
 	}
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index d65ad6aa856f4d..316cf70e3a8fd8 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -137,7 +137,7 @@ xreap_put_freelist(
 			agfl_bp, agbno, 0);
 	if (error)
 		return error;
-	xfs_extent_busy_insert(sc->tp, sc->sa.pag, agbno, 1,
+	xfs_extent_busy_insert(sc->tp, &sc->sa.pag->pag_group, agbno, 1,
 			XFS_EXTENT_BUSY_SKIP_DISCARD);
 
 	return 0;
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 739ec69c44281c..9c6d3b136826cc 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -117,10 +117,12 @@ xfs_discard_extents(
 
 	blk_start_plug(&plug);
 	list_for_each_entry(busyp, &extents->extent_list, list) {
-		trace_xfs_discard_extent(busyp->pag, busyp->bno, busyp->length);
+		struct xfs_perag	*pag = to_perag(busyp->group);
+
+		trace_xfs_discard_extent(pag, busyp->bno, busyp->length);
 
 		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
-				xfs_agbno_to_daddr(busyp->pag, busyp->bno),
+				xfs_agbno_to_daddr(pag, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
 				GFP_KERNEL, &bio);
 		if (error && error != -EOPNOTSUPP) {
@@ -271,12 +273,12 @@ xfs_trim_gather_extents(
 		 * If any blocks in the range are still busy, skip the
 		 * discard and try again the next time.
 		 */
-		if (xfs_extent_busy_search(pag, fbno, flen)) {
+		if (xfs_extent_busy_search(&pag->pag_group, fbno, flen)) {
 			trace_xfs_discard_busy(pag, fbno, flen);
 			goto next_extent;
 		}
 
-		xfs_extent_busy_insert_discard(pag, fbno, flen,
+		xfs_extent_busy_insert_discard(&pag->pag_group, fbno, flen,
 				&extents->extent_list);
 next_extent:
 		if (tcur->by_bno)
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index ff10307702f011..d63208a87f1d7e 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -19,14 +19,22 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 
+struct xfs_extent_busy_tree {
+	spinlock_t		eb_lock;
+	struct rb_root		eb_tree;
+	unsigned int		eb_gen;
+	wait_queue_head_t	eb_wait;
+};
+
 static void
 xfs_extent_busy_insert_list(
-	struct xfs_perag	*pag,
+	struct xfs_group	*xg,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
 	unsigned int		flags,
 	struct list_head	*busy_list)
 {
+	struct xfs_extent_busy_tree *eb = xg->xg_busy_extents;
 	struct xfs_extent_busy	*new;
 	struct xfs_extent_busy	*busyp;
 	struct rb_node		**rbp;
@@ -34,17 +42,17 @@ xfs_extent_busy_insert_list(
 
 	new = kzalloc(sizeof(struct xfs_extent_busy),
 			GFP_KERNEL | __GFP_NOFAIL);
-	new->pag = xfs_perag_hold(pag);
+	new->group = xfs_group_hold(xg);
 	new->bno = bno;
 	new->length = len;
 	INIT_LIST_HEAD(&new->list);
 	new->flags = flags;
 
 	/* trace before insert to be able to see failed inserts */
-	trace_xfs_extent_busy(&pag->pag_group, bno, len);
+	trace_xfs_extent_busy(xg, bno, len);
 
-	spin_lock(&pag->pagb_lock);
-	rbp = &pag->pagb_tree.rb_node;
+	spin_lock(&eb->eb_lock);
+	rbp = &eb->eb_tree.rb_node;
 	while (*rbp) {
 		parent = *rbp;
 		busyp = rb_entry(parent, struct xfs_extent_busy, rb_node);
@@ -61,32 +69,32 @@ xfs_extent_busy_insert_list(
 	}
 
 	rb_link_node(&new->rb_node, parent, rbp);
-	rb_insert_color(&new->rb_node, &pag->pagb_tree);
+	rb_insert_color(&new->rb_node, &eb->eb_tree);
 
 	/* always process discard lists in fifo order */
 	list_add_tail(&new->list, busy_list);
-	spin_unlock(&pag->pagb_lock);
+	spin_unlock(&eb->eb_lock);
 }
 
 void
 xfs_extent_busy_insert(
 	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
+	struct xfs_group	*xg,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
 	unsigned int		flags)
 {
-	xfs_extent_busy_insert_list(pag, bno, len, flags, &tp->t_busy);
+	xfs_extent_busy_insert_list(xg, bno, len, flags, &tp->t_busy);
 }
 
 void
 xfs_extent_busy_insert_discard(
-	struct xfs_perag	*pag,
+	struct xfs_group	*xg,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
 	struct list_head	*busy_list)
 {
-	xfs_extent_busy_insert_list(pag, bno, len, XFS_EXTENT_BUSY_DISCARDED,
+	xfs_extent_busy_insert_list(xg, bno, len, XFS_EXTENT_BUSY_DISCARDED,
 			busy_list);
 }
 
@@ -101,17 +109,18 @@ xfs_extent_busy_insert_discard(
  */
 int
 xfs_extent_busy_search(
-	struct xfs_perag	*pag,
+	struct xfs_group	*xg,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len)
 {
+	struct xfs_extent_busy_tree *eb = xg->xg_busy_extents;
 	struct rb_node		*rbp;
 	struct xfs_extent_busy	*busyp;
 	int			match = 0;
 
 	/* find closest start bno overlap */
-	spin_lock(&pag->pagb_lock);
-	rbp = pag->pagb_tree.rb_node;
+	spin_lock(&eb->eb_lock);
+	rbp = eb->eb_tree.rb_node;
 	while (rbp) {
 		busyp = rb_entry(rbp, struct xfs_extent_busy, rb_node);
 		if (bno < busyp->bno) {
@@ -130,7 +139,7 @@ xfs_extent_busy_search(
 			break;
 		}
 	}
-	spin_unlock(&pag->pagb_lock);
+	spin_unlock(&eb->eb_lock);
 	return match;
 }
 
@@ -147,13 +156,15 @@ xfs_extent_busy_search(
  */
 STATIC bool
 xfs_extent_busy_update_extent(
-	struct xfs_perag	*pag,
+	struct xfs_group	*xg,
 	struct xfs_extent_busy	*busyp,
 	xfs_agblock_t		fbno,
 	xfs_extlen_t		flen,
-	bool			userdata) __releases(&pag->pagb_lock)
-					  __acquires(&pag->pagb_lock)
+	bool			userdata)
+		__releases(&eb->eb_lock)
+		__acquires(&eb->eb_lock)
 {
+	struct xfs_extent_busy_tree *eb = xg->xg_busy_extents;
 	xfs_agblock_t		fend = fbno + flen;
 	xfs_agblock_t		bbno = busyp->bno;
 	xfs_agblock_t		bend = bbno + busyp->length;
@@ -164,9 +175,9 @@ xfs_extent_busy_update_extent(
 	 * and retry.
 	 */
 	if (busyp->flags & XFS_EXTENT_BUSY_DISCARDED) {
-		spin_unlock(&pag->pagb_lock);
+		spin_unlock(&eb->eb_lock);
 		delay(1);
-		spin_lock(&pag->pagb_lock);
+		spin_lock(&eb->eb_lock);
 		return false;
 	}
 
@@ -239,7 +250,7 @@ xfs_extent_busy_update_extent(
 		 * tree root, because erasing the node can rearrange the
 		 * tree topology.
 		 */
-		rb_erase(&busyp->rb_node, &pag->pagb_tree);
+		rb_erase(&busyp->rb_node, &eb->eb_tree);
 		busyp->length = 0;
 		return false;
 	} else if (fend < bend) {
@@ -278,14 +289,14 @@ xfs_extent_busy_update_extent(
 		ASSERT(0);
 	}
 
-	trace_xfs_extent_busy_reuse(&pag->pag_group, fbno, flen);
+	trace_xfs_extent_busy_reuse(xg, fbno, flen);
 	return true;
 
 out_force_log:
-	spin_unlock(&pag->pagb_lock);
-	xfs_log_force(pag_mount(pag), XFS_LOG_SYNC);
-	trace_xfs_extent_busy_force(&pag->pag_group, fbno, flen);
-	spin_lock(&pag->pagb_lock);
+	spin_unlock(&eb->eb_lock);
+	xfs_log_force(xg->xg_mount, XFS_LOG_SYNC);
+	trace_xfs_extent_busy_force(xg, fbno, flen);
+	spin_lock(&eb->eb_lock);
 	return false;
 }
 
@@ -294,17 +305,18 @@ xfs_extent_busy_update_extent(
  */
 void
 xfs_extent_busy_reuse(
-	struct xfs_perag	*pag,
+	struct xfs_group	*xg,
 	xfs_agblock_t		fbno,
 	xfs_extlen_t		flen,
 	bool			userdata)
 {
+	struct xfs_extent_busy_tree *eb = xg->xg_busy_extents;
 	struct rb_node		*rbp;
 
 	ASSERT(flen > 0);
-	spin_lock(&pag->pagb_lock);
+	spin_lock(&eb->eb_lock);
 restart:
-	rbp = pag->pagb_tree.rb_node;
+	rbp = eb->eb_tree.rb_node;
 	while (rbp) {
 		struct xfs_extent_busy *busyp =
 			rb_entry(rbp, struct xfs_extent_busy, rb_node);
@@ -319,11 +331,11 @@ xfs_extent_busy_reuse(
 			continue;
 		}
 
-		if (!xfs_extent_busy_update_extent(pag, busyp, fbno, flen,
+		if (!xfs_extent_busy_update_extent(xg, busyp, fbno, flen,
 						  userdata))
 			goto restart;
 	}
-	spin_unlock(&pag->pagb_lock);
+	spin_unlock(&eb->eb_lock);
 }
 
 /*
@@ -332,7 +344,7 @@ xfs_extent_busy_reuse(
  * args->minlen no suitable extent could be found, and the higher level
  * code needs to force out the log and retry the allocation.
  *
- * Return the current busy generation for the AG if the extent is busy. This
+ * Return the current busy generation for the group if the extent is busy. This
  * value can be used to wait for at least one of the currently busy extents
  * to be cleared. Note that the busy list is not guaranteed to be empty after
  * the gen is woken. The state of a specific extent must always be confirmed
@@ -340,11 +352,14 @@ xfs_extent_busy_reuse(
  */
 bool
 xfs_extent_busy_trim(
-	struct xfs_alloc_arg	*args,
+	struct xfs_group	*xg,
+	xfs_extlen_t		minlen,
+	xfs_extlen_t		maxlen,
 	xfs_agblock_t		*bno,
 	xfs_extlen_t		*len,
 	unsigned		*busy_gen)
 {
+	struct xfs_extent_busy_tree *eb = xg->xg_busy_extents;
 	xfs_agblock_t		fbno;
 	xfs_extlen_t		flen;
 	struct rb_node		*rbp;
@@ -352,11 +367,11 @@ xfs_extent_busy_trim(
 
 	ASSERT(*len > 0);
 
-	spin_lock(&args->pag->pagb_lock);
+	spin_lock(&eb->eb_lock);
 	fbno = *bno;
 	flen = *len;
-	rbp = args->pag->pagb_tree.rb_node;
-	while (rbp && flen >= args->minlen) {
+	rbp = eb->eb_tree.rb_node;
+	while (rbp && flen >= minlen) {
 		struct xfs_extent_busy *busyp =
 			rb_entry(rbp, struct xfs_extent_busy, rb_node);
 		xfs_agblock_t	fend = fbno + flen;
@@ -477,13 +492,13 @@ xfs_extent_busy_trim(
 			 * good chance subsequent allocations will be
 			 * contiguous.
 			 */
-			if (bbno - fbno >= args->maxlen) {
+			if (bbno - fbno >= maxlen) {
 				/* left candidate fits perfect */
 				fend = bbno;
-			} else if (fend - bend >= args->maxlen * 4) {
+			} else if (fend - bend >= maxlen * 4) {
 				/* right candidate has enough free space */
 				fbno = bend;
-			} else if (bbno - fbno >= args->minlen) {
+			} else if (bbno - fbno >= minlen) {
 				/* left candidate fits minimum requirement */
 				fend = bbno;
 			} else {
@@ -496,14 +511,13 @@ xfs_extent_busy_trim(
 out:
 
 	if (fbno != *bno || flen != *len) {
-		trace_xfs_extent_busy_trim(&args->pag->pag_group, *bno, *len,
-				fbno, flen);
+		trace_xfs_extent_busy_trim(xg, *bno, *len, fbno, flen);
 		*bno = fbno;
 		*len = flen;
-		*busy_gen = args->pag->pagb_gen;
+		*busy_gen = eb->eb_gen;
 		ret = true;
 	}
-	spin_unlock(&args->pag->pagb_lock);
+	spin_unlock(&eb->eb_lock);
 	return ret;
 fail:
 	/*
@@ -516,23 +530,24 @@ xfs_extent_busy_trim(
 
 static bool
 xfs_extent_busy_clear_one(
-	struct xfs_perag	*pag,
 	struct xfs_extent_busy	*busyp,
 	bool			do_discard)
 {
+	struct xfs_extent_busy_tree *eb = busyp->group->xg_busy_extents;
+
 	if (busyp->length) {
 		if (do_discard &&
 		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
 			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
 			return false;
 		}
-		trace_xfs_extent_busy_clear(&pag->pag_group, busyp->bno,
+		trace_xfs_extent_busy_clear(busyp->group, busyp->bno,
 				busyp->length);
-		rb_erase(&busyp->rb_node, &pag->pagb_tree);
+		rb_erase(&busyp->rb_node, &eb->eb_tree);
 	}
 
 	list_del_init(&busyp->list);
-	xfs_perag_put(busyp->pag);
+	xfs_group_put(busyp->group);
 	kfree(busyp);
 	return true;
 }
@@ -554,29 +569,30 @@ xfs_extent_busy_clear(
 		return;
 
 	do {
-		struct xfs_perag	*pag = xfs_perag_hold(busyp->pag);
+		struct xfs_group	*xg = xfs_group_hold(busyp->group);
+		struct xfs_extent_busy_tree *eb = xg->xg_busy_extents;
 		bool			wakeup = false;
 
-		spin_lock(&pag->pagb_lock);
+		spin_lock(&eb->eb_lock);
 		do {
 			next = list_next_entry(busyp, list);
-			if (xfs_extent_busy_clear_one(pag, busyp, do_discard))
+			if (xfs_extent_busy_clear_one(busyp, do_discard))
 				wakeup = true;
 			busyp = next;
 		} while (!list_entry_is_head(busyp, list, list) &&
-			 busyp->pag == pag);
+			 busyp->group == xg);
 
 		if (wakeup) {
-			pag->pagb_gen++;
-			wake_up_all(&pag->pagb_wait);
+			eb->eb_gen++;
+			wake_up_all(&eb->eb_wait);
 		}
-		spin_unlock(&pag->pagb_lock);
-		xfs_perag_put(pag);
+		spin_unlock(&eb->eb_lock);
+		xfs_group_put(xg);
 	} while (!list_entry_is_head(busyp, list, list));
 }
 
 /*
- * Flush out all busy extents for this AG.
+ * Flush out all busy extents for this group.
  *
  * If the current transaction is holding busy extents, the caller may not want
  * to wait for committed busy extents to resolve. If we are being told just to
@@ -592,10 +608,11 @@ xfs_extent_busy_clear(
 int
 xfs_extent_busy_flush(
 	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
+	struct xfs_group	*xg,
 	unsigned		busy_gen,
 	uint32_t		alloc_flags)
 {
+	struct xfs_extent_busy_tree *eb = xg->xg_busy_extents;
 	DEFINE_WAIT		(wait);
 	int			error;
 
@@ -608,7 +625,7 @@ xfs_extent_busy_flush(
 		if (alloc_flags & XFS_ALLOC_FLAG_TRYFLUSH)
 			return 0;
 
-		if (busy_gen != READ_ONCE(pag->pagb_gen))
+		if (busy_gen != READ_ONCE(eb->eb_gen))
 			return 0;
 
 		if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
@@ -617,36 +634,44 @@ xfs_extent_busy_flush(
 
 	/* Wait for committed busy extents to resolve. */
 	do {
-		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
-		if  (busy_gen != READ_ONCE(pag->pagb_gen))
+		prepare_to_wait(&eb->eb_wait, &wait, TASK_KILLABLE);
+		if  (busy_gen != READ_ONCE(eb->eb_gen))
 			break;
 		schedule();
 	} while (1);
 
-	finish_wait(&pag->pagb_wait, &wait);
+	finish_wait(&eb->eb_wait, &wait);
 	return 0;
 }
 
+static void
+xfs_extent_busy_wait_group(
+	struct xfs_group	*xg)
+{
+	DEFINE_WAIT		(wait);
+	struct xfs_extent_busy_tree *eb = xg->xg_busy_extents;
+
+	do {
+		prepare_to_wait(&eb->eb_wait, &wait, TASK_KILLABLE);
+		if  (RB_EMPTY_ROOT(&eb->eb_tree))
+			break;
+		schedule();
+	} while (1);
+	finish_wait(&eb->eb_wait, &wait);
+}
+
 void
 xfs_extent_busy_wait_all(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag = NULL;
-	DEFINE_WAIT		(wait);
 
-	while ((pag = xfs_perag_next(mp, pag))) {
-		do {
-			prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
-			if  (RB_EMPTY_ROOT(&pag->pagb_tree))
-				break;
-			schedule();
-		} while (1);
-		finish_wait(&pag->pagb_wait, &wait);
-	}
+	while ((pag = xfs_perag_next(mp, pag)))
+		xfs_extent_busy_wait_group(&pag->pag_group);
 }
 
 /*
- * Callback for list_sort to sort busy extents by the AG they reside in.
+ * Callback for list_sort to sort busy extents by the group they reside in.
  */
 int
 xfs_extent_busy_ag_cmp(
@@ -660,23 +685,38 @@ xfs_extent_busy_ag_cmp(
 		container_of(l2, struct xfs_extent_busy, list);
 	s32 diff;
 
-	diff = pag_agno(b1->pag) - pag_agno(b2->pag);
+	diff = b1->group->xg_index - b2->group->xg_index;
 	if (!diff)
 		diff = b1->bno - b2->bno;
 	return diff;
 }
 
-/* Are there any busy extents in this AG? */
+/* Are there any busy extents in this group? */
 bool
 xfs_extent_busy_list_empty(
-	struct xfs_perag	*pag,
+	struct xfs_group	*xg,
 	unsigned		*busy_gen)
 {
+	struct xfs_extent_busy_tree *eb = xg->xg_busy_extents;
 	bool			res;
 
-	spin_lock(&pag->pagb_lock);
-	res = RB_EMPTY_ROOT(&pag->pagb_tree);
-	*busy_gen = READ_ONCE(pag->pagb_gen);
-	spin_unlock(&pag->pagb_lock);
+	spin_lock(&eb->eb_lock);
+	res = RB_EMPTY_ROOT(&eb->eb_tree);
+	*busy_gen = READ_ONCE(eb->eb_gen);
+	spin_unlock(&eb->eb_lock);
 	return res;
 }
+
+struct xfs_extent_busy_tree *
+xfs_extent_busy_alloc(void)
+{
+	struct xfs_extent_busy_tree *eb;
+
+	eb = kzalloc(sizeof(*eb), GFP_KERNEL);
+	if (!eb)
+		return NULL;
+	spin_lock_init(&eb->eb_lock);
+	init_waitqueue_head(&eb->eb_wait);
+	eb->eb_tree = RB_ROOT;
+	return eb;
+}
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index c803dcd124a628..f069b04e8ea184 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -8,19 +8,18 @@
 #ifndef __XFS_EXTENT_BUSY_H__
 #define	__XFS_EXTENT_BUSY_H__
 
+struct xfs_group;
 struct xfs_mount;
-struct xfs_perag;
 struct xfs_trans;
-struct xfs_alloc_arg;
 
 /*
- * Busy block/extent entry.  Indexed by a rbtree in perag to mark blocks that
- * have been freed but whose transactions aren't committed to disk yet.
+ * Busy block/extent entry.  Indexed by a rbtree in the group to mark blocks
+ * that have been freed but whose transactions aren't committed to disk yet.
  */
 struct xfs_extent_busy {
-	struct rb_node	rb_node;	/* ag by-bno indexed search tree */
+	struct rb_node	rb_node;	/* group by-bno indexed search tree */
 	struct list_head list;		/* transaction busy extent list */
-	struct xfs_perag *pag;
+	struct xfs_group *group;
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
 	unsigned int	flags;
@@ -44,45 +43,29 @@ struct xfs_busy_extents {
 	void			*owner;
 };
 
-void
-xfs_extent_busy_insert(struct xfs_trans *tp, struct xfs_perag *pag,
-	xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
-
-void
-xfs_extent_busy_insert_discard(struct xfs_perag *pag, xfs_agblock_t bno,
-	xfs_extlen_t len, struct list_head *busy_list);
-
-void
-xfs_extent_busy_clear(struct list_head *list, bool do_discard);
-
-int
-xfs_extent_busy_search(struct xfs_perag *pag, xfs_agblock_t bno,
+void xfs_extent_busy_insert(struct xfs_trans *tp, struct xfs_group *xg,
+		xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
+void xfs_extent_busy_insert_discard(struct xfs_group *xg, xfs_agblock_t bno,
+		xfs_extlen_t len, struct list_head *busy_list);
+void xfs_extent_busy_clear(struct list_head *list, bool do_discard);
+int xfs_extent_busy_search(struct xfs_group *xg, xfs_agblock_t bno,
 		xfs_extlen_t len);
-
-void
-xfs_extent_busy_reuse(struct xfs_perag *pag, xfs_agblock_t fbno,
+void xfs_extent_busy_reuse(struct xfs_group *xg, xfs_agblock_t fbno,
 		xfs_extlen_t flen, bool userdata);
-
-bool
-xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
-		xfs_extlen_t *len, unsigned *busy_gen);
-
-int
-xfs_extent_busy_flush(struct xfs_trans *tp, struct xfs_perag *pag,
+bool xfs_extent_busy_trim(struct xfs_group *xg, xfs_extlen_t minlen,
+		xfs_extlen_t maxlen, xfs_agblock_t *bno, xfs_extlen_t *len,
+		unsigned *busy_gen);
+int xfs_extent_busy_flush(struct xfs_trans *tp, struct xfs_group *xg,
 		unsigned busy_gen, uint32_t alloc_flags);
+void xfs_extent_busy_wait_all(struct xfs_mount *mp);
+bool xfs_extent_busy_list_empty(struct xfs_group *xg, unsigned int *busy_gen);
+struct xfs_extent_busy_tree *xfs_extent_busy_alloc(void);
 
-void
-xfs_extent_busy_wait_all(struct xfs_mount *mp);
-
-int
-xfs_extent_busy_ag_cmp(void *priv, const struct list_head *a,
-	const struct list_head *b);
-
+int xfs_extent_busy_ag_cmp(void *priv, const struct list_head *a,
+		const struct list_head *b);
 static inline void xfs_extent_busy_sort(struct list_head *list)
 {
 	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
 }
 
-bool xfs_extent_busy_list_empty(struct xfs_perag *pag, unsigned int *busy_gen);
-
 #endif /* __XFS_EXTENT_BUSY_H__ */

