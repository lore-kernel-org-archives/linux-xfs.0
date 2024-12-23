Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579521D5CDD
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990156; cv=none; b=NBtEPOimtJsfHjEvOEBX4cqYaO/HL0JCQL2ZNFITIwwjsp1jaJLn1cyWgZX1jg7mpbnO6eNla1s/lE0AP6VNkKc0PQA5LBoFt1ngWXxsZBFPMmI43gtYgWtyhtq4rLmN3VgejIoqPx1DigxfBrYCw2sIDVV0nn8EgY/ZWKIySgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990156; c=relaxed/simple;
	bh=RgtTZi18xC6mSKlU6yOa98SScplN78aBSxufGnJg7dI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhhqa22ZbCCO6Oae4YXbFjRdB3liDxFKEySqhfnhqUQxJ0CXqiy2FGUKwv1kFxn+CHs6r5VBciVL4eLRyxy3oAB2YP4bzBsivkaZh1PnkRWNwz6vpKoJVMY0NVkLr3p5P6xDnbDMAZVVT2zdq1bLal+7l0EcAi4+vdlLs620oFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gm6JuoIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gm6JuoIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D701C4CED3;
	Mon, 23 Dec 2024 21:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990156;
	bh=RgtTZi18xC6mSKlU6yOa98SScplN78aBSxufGnJg7dI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gm6JuoIiESoHTl+LsgWw/RaU3OACULU3U0UkfcoGHqe8SLff7DXIxYPDIp0wFr8D8
	 tKcVnhGszBxOtgD/BWfPk0zTN93KvyMrvXnWDdFtsnjE7JCe0mand/Lxjv3AJmlyqr
	 zfo0FOGKmDP2/qSfFJO5xmWImzk1G7ohakGlbV83TkWt2Jv6VwfZ+3UKrCt6kvV5U4
	 DIwT5wueYxf3paTEtJ1iFBLdFNGog76O7vBq1MivLTPQ62MDYf1eEb49orDkiy10Nu
	 nZ743tsxBskN+qAKVzawOElrRm9Lguxwd/POfZBjkdTrUP/feLOqAIWzx7O68H4kcm
	 +FXqJEMUCz28w==
Date: Mon, 23 Dec 2024 13:42:35 -0800
Subject: [PATCH 21/36] xfs: convert busy extent tracking to the generic group
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940266.2293042.18303256379670961526.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: adbc76aa0fedcb6da2d1ceb1ce786d1f963afee8

Split busy extent tracking from struct xfs_perag into its own private
structure, which can be pointed to by the generic group structure.

Note that this structure is now dynamically allocated instead of embedded
as the upcoming zone XFS code doesn't need it and will also have an
unusually high number of groups due to hardware constraints.  Dynamically
allocating the structure this is a big memory saver for this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h     |    6 +++---
 libxfs/xfs_ag.c          |    3 ---
 libxfs/xfs_ag.h          |    5 -----
 libxfs/xfs_alloc.c       |   29 +++++++++++++++++------------
 libxfs/xfs_alloc_btree.c |    4 ++--
 libxfs/xfs_group.c       |   15 +++++++++++++--
 libxfs/xfs_group.h       |    5 +++++
 libxfs/xfs_rmap_btree.c  |    4 ++--
 8 files changed, 42 insertions(+), 29 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 9505806131bc42..1b6bb961b7ac06 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -467,11 +467,11 @@ xfs_buf_readahead(
 
 #define xfs_extent_busy_reuse(...)			((void) 0)
 /* avoid unused variable warning */
-#define xfs_extent_busy_insert(tp,pag,bno,len,flags)({ 	\
-	struct xfs_perag *__foo = pag;			\
+#define xfs_extent_busy_insert(tp,xg,bno,len,flags)({ 	\
+	struct xfs_group *__foo = xg;			\
 	__foo = __foo; /* no set-but-unused warning */	\
 })
-#define xfs_extent_busy_trim(args,bno,len,busy_gen) 	({	\
+#define xfs_extent_busy_trim(group,minlen,maxlen,bno,len,busy_gen) 	({	\
 	unsigned __foo = *(busy_gen);				\
 	*(busy_gen) = __foo;					\
 	false;							\
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 1542fea06e305e..bd38ac175bbae3 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -228,11 +228,8 @@ xfs_perag_alloc(
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
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 042ee0913fb9b9..7290148fa6e6aa 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
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
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 39e1961078ae3a..1c50358a8be7ae 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -327,7 +327,8 @@ xfs_alloc_compute_aligned(
 	bool		busy;
 
 	/* Trim busy sections out of found extent */
-	busy = xfs_extent_busy_trim(args, &bno, &len, busy_gen);
+	busy = xfs_extent_busy_trim(pag_group(args->pag), args->minlen,
+			args->maxlen, &bno, &len, busy_gen);
 
 	/*
 	 * If we have a largish extent that happens to start before min_agbno,
@@ -1247,7 +1248,7 @@ xfs_alloc_ag_vextent_small(
 	if (fbno == NULLAGBLOCK)
 		goto out;
 
-	xfs_extent_busy_reuse(args->pag, fbno, 1,
+	xfs_extent_busy_reuse(pag_group(args->pag), fbno, 1,
 			      (args->datatype & XFS_ALLOC_NOBUSY));
 
 	if (args->datatype & XFS_ALLOC_USERDATA) {
@@ -1360,7 +1361,8 @@ xfs_alloc_ag_vextent_exact(
 	 */
 	tbno = fbno;
 	tlen = flen;
-	xfs_extent_busy_trim(args, &tbno, &tlen, &busy_gen);
+	xfs_extent_busy_trim(pag_group(args->pag), args->minlen, args->maxlen,
+			&tbno, &tlen, &busy_gen);
 
 	/*
 	 * Give up if the start of the extent is busy, or the freespace isn't
@@ -1753,8 +1755,9 @@ xfs_alloc_ag_vextent_near(
 			 * the allocation can be retried.
 			 */
 			trace_xfs_alloc_near_busy(args);
-			error = xfs_extent_busy_flush(args->tp, args->pag,
-					acur.busy_gen, alloc_flags);
+			error = xfs_extent_busy_flush(args->tp,
+					pag_group(args->pag), acur.busy_gen,
+					alloc_flags);
 			if (error)
 				goto out;
 
@@ -1869,8 +1872,9 @@ xfs_alloc_ag_vextent_size(
 			 * the allocation can be retried.
 			 */
 			trace_xfs_alloc_size_busy(args);
-			error = xfs_extent_busy_flush(args->tp, args->pag,
-					busy_gen, alloc_flags);
+			error = xfs_extent_busy_flush(args->tp,
+					pag_group(args->pag), busy_gen,
+					alloc_flags);
 			if (error)
 				goto error0;
 
@@ -1968,8 +1972,9 @@ xfs_alloc_ag_vextent_size(
 			 * the allocation can be retried.
 			 */
 			trace_xfs_alloc_size_busy(args);
-			error = xfs_extent_busy_flush(args->tp, args->pag,
-					busy_gen, alloc_flags);
+			error = xfs_extent_busy_flush(args->tp,
+					pag_group(args->pag), busy_gen,
+					alloc_flags);
 			if (error)
 				goto error0;
 
@@ -3609,8 +3614,8 @@ xfs_alloc_vextent_finish(
 		if (error)
 			goto out_drop_perag;
 
-		ASSERT(!xfs_extent_busy_search(args->pag, args->agbno,
-				args->len));
+		ASSERT(!xfs_extent_busy_search(pag_group(args->pag),
+				args->agbno, args->len));
 	}
 
 	xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
@@ -4008,7 +4013,7 @@ __xfs_free_extent(
 
 	if (skip_discard)
 		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;
-	xfs_extent_busy_insert(tp, pag, agbno, len, busy_flags);
+	xfs_extent_busy_insert(tp, pag_group(pag), agbno, len, busy_flags);
 	return 0;
 
 err_release:
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 667655a639fef1..bf906aeb2f8a9e 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -84,7 +84,7 @@ xfs_allocbt_alloc_block(
 	}
 
 	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_reuse(cur->bc_ag.pag, bno, 1, false);
+	xfs_extent_busy_reuse(pag_group(cur->bc_ag.pag), bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 
@@ -108,7 +108,7 @@ xfs_allocbt_free_block(
 		return error;
 
 	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_insert(cur->bc_tp, agbp->b_pag, bno, 1,
+	xfs_extent_busy_insert(cur->bc_tp, pag_group(agbp->b_pag), bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 	return 0;
 }
diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
index 58ace330a765cf..9c7fa99d00b802 100644
--- a/libxfs/xfs_group.c
+++ b/libxfs/xfs_group.c
@@ -160,6 +160,9 @@ xfs_group_free(
 	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_ref) != 0);
 
 	xfs_defer_drain_free(&xg->xg_intents_drain);
+#ifdef __KERNEL__
+	kfree(xg->xg_busy_extents);
+#endif
 
 	if (uninit)
 		uninit(xg);
@@ -184,6 +187,9 @@ xfs_group_insert(
 	xg->xg_type = type;
 
 #ifdef __KERNEL__
+	xg->xg_busy_extents = xfs_extent_busy_alloc();
+	if (!xg->xg_busy_extents)
+		return -ENOMEM;
 	spin_lock_init(&xg->xg_state_lock);
 	xfs_hooks_init(&xg->xg_rmap_update_hooks);
 #endif
@@ -195,9 +201,14 @@ xfs_group_insert(
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
diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
index a87b9b80ef7516..0ff6e1d5635cb1 100644
--- a/libxfs/xfs_group.h
+++ b/libxfs/xfs_group.h
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
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index ebb2519cf8baf3..5829e68790314a 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -101,7 +101,7 @@ xfs_rmapbt_alloc_block(
 		return 0;
 	}
 
-	xfs_extent_busy_reuse(pag, bno, 1, false);
+	xfs_extent_busy_reuse(pag_group(pag), bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);
@@ -135,7 +135,7 @@ xfs_rmapbt_free_block(
 	if (error)
 		return error;
 
-	xfs_extent_busy_insert(cur->bc_tp, pag, bno, 1,
+	xfs_extent_busy_insert(cur->bc_tp, pag_group(pag), bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 
 	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);

