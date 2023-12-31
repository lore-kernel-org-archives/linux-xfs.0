Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E11BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uP1hXj6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95752C433C8;
	Sun, 31 Dec 2023 20:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053645;
	bh=beM3iEJGvpQEZCfTv2mFtAEfpnTfAsQnrGr5T8Xe6UY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uP1hXj6jxY9w3LKjOKiHi64DpFbNCL0+5MvedMgHQQz+pRMQgvut10QFxLLaW4CFL
	 vEVmqfKle27vnOtjIAjyLcn+cy/Iopd8Lh9SfWL2cQbzHppZrq4iItib8vLcaA1N15
	 rx3TaAKs1eXnrGRkFYa47UuE/vk1lZ4AbHg82JC1ZB1Yd+NOk+nMs31Cjh3oSuG+Ze
	 jX4TEpyKexHWRVO8sskBpU/1aKN3vkR9EUaKciL6hSaWAe2xBeyWgPbM3dA2FzfwBr
	 P2PTCUJjztXe5B+qGxbfO8tS1SoggaYpfj4pCSrAjfTpKNL1KVhvweDqcDmY+yIw0z
	 cKdJfG8SkJeIQ==
Date: Sun, 31 Dec 2023 12:14:05 -0800
Subject: [PATCH 2/9] xfs: teach buftargs to maintain their own buffer
 hashtable
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170404829610.1748854.13085742974198564791.stgit@frogsfrogsfrogs>
In-Reply-To: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
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

Currently, cached buffers are indexed by per-AG hashtables.  This works
great for the data device, but won't work for in-memory btrees.  Make it
so that buftargs can index buffers too.

We accomplish this by hoisting the rhashtable and its lock into a
separate xfs_buf_cache structure and reworking various functions to use
it.  Next, we introduce to the buftarg a new XFS_BUFTARG_SELF_CACHED
flag to indicate that the buftarg's cache is active (vs. the per-ag
cache for the regular filesystem).

Finally, make it so that each xfs_buf points to its cache if there is
one.  This is how we distinguish uncached buffers from now on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    6 +-
 fs/xfs/libxfs/xfs_ag.h |    4 -
 fs/xfs/xfs_buf.c       |  143 +++++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_buf.h       |   10 +++
 fs/xfs/xfs_mount.h     |    3 -
 5 files changed, 111 insertions(+), 55 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index ccad54d1dadaf..6a7bfc6797d23 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -264,7 +264,7 @@ xfs_free_perag(
 		xfs_defer_drain_free(&pag->pag_intents_drain);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
-		xfs_buf_hash_destroy(pag);
+		xfs_buf_cache_destroy(&pag->pag_bcache);
 
 		/* drop the mount's active reference */
 		xfs_perag_rele(pag);
@@ -394,7 +394,7 @@ xfs_initialize_perag(
 		pag->pagb_tree = RB_ROOT;
 #endif /* __KERNEL__ */
 
-		error = xfs_buf_hash_init(pag);
+		error = xfs_buf_cache_init(&pag->pag_bcache);
 		if (error)
 			goto out_remove_pag;
 
@@ -434,7 +434,7 @@ xfs_initialize_perag(
 		pag = radix_tree_delete(&mp->m_perag_tree, index);
 		if (!pag)
 			break;
-		xfs_buf_hash_destroy(pag);
+		xfs_buf_cache_destroy(&pag->pag_bcache);
 		xfs_defer_drain_free(&pag->pag_intents_drain);
 		kmem_free(pag);
 	}
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 67c3260ee789f..fe5852873b82d 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -104,9 +104,7 @@ struct xfs_perag {
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
-	/* buffer cache index */
-	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
-	struct rhashtable pag_buf_hash;
+	struct xfs_buf_cache	pag_bcache;
 
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ec4bd7a24d88c..0ae9a37cd1ddb 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -499,18 +499,18 @@ static const struct rhashtable_params xfs_buf_hash_params = {
 };
 
 int
-xfs_buf_hash_init(
-	struct xfs_perag	*pag)
+xfs_buf_cache_init(
+	struct xfs_buf_cache	*bch)
 {
-	spin_lock_init(&pag->pag_buf_lock);
-	return rhashtable_init(&pag->pag_buf_hash, &xfs_buf_hash_params);
+	spin_lock_init(&bch->bc_lock);
+	return rhashtable_init(&bch->bc_hash, &xfs_buf_hash_params);
 }
 
 void
-xfs_buf_hash_destroy(
-	struct xfs_perag	*pag)
+xfs_buf_cache_destroy(
+	struct xfs_buf_cache	*bch)
 {
-	rhashtable_destroy(&pag->pag_buf_hash);
+	rhashtable_destroy(&bch->bc_hash);
 }
 
 static int
@@ -573,7 +573,7 @@ xfs_buf_find_lock(
 
 static inline int
 xfs_buf_lookup(
-	struct xfs_perag	*pag,
+	struct xfs_buf_cache	*bch,
 	struct xfs_buf_map	*map,
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
@@ -582,7 +582,7 @@ xfs_buf_lookup(
 	int			error;
 
 	rcu_read_lock();
-	bp = rhashtable_lookup(&pag->pag_buf_hash, map, xfs_buf_hash_params);
+	bp = rhashtable_lookup(&bch->bc_hash, map, xfs_buf_hash_params);
 	if (!bp || !atomic_inc_not_zero(&bp->b_hold)) {
 		rcu_read_unlock();
 		return -ENOENT;
@@ -607,6 +607,7 @@ xfs_buf_lookup(
 static int
 xfs_buf_find_insert(
 	struct xfs_buftarg	*btp,
+	struct xfs_buf_cache	*bch,
 	struct xfs_perag	*pag,
 	struct xfs_buf_map	*cmap,
 	struct xfs_buf_map	*map,
@@ -635,18 +636,18 @@ xfs_buf_find_insert(
 			goto out_free_buf;
 	}
 
-	spin_lock(&pag->pag_buf_lock);
-	bp = rhashtable_lookup_get_insert_fast(&pag->pag_buf_hash,
+	spin_lock(&bch->bc_lock);
+	bp = rhashtable_lookup_get_insert_fast(&bch->bc_hash,
 			&new_bp->b_rhash_head, xfs_buf_hash_params);
 	if (IS_ERR(bp)) {
 		error = PTR_ERR(bp);
-		spin_unlock(&pag->pag_buf_lock);
+		spin_unlock(&bch->bc_lock);
 		goto out_free_buf;
 	}
 	if (bp) {
 		/* found an existing buffer */
 		atomic_inc(&bp->b_hold);
-		spin_unlock(&pag->pag_buf_lock);
+		spin_unlock(&bch->bc_lock);
 		error = xfs_buf_find_lock(bp, flags);
 		if (error)
 			xfs_buf_rele(bp);
@@ -657,17 +658,38 @@ xfs_buf_find_insert(
 
 	/* The new buffer keeps the perag reference until it is freed. */
 	new_bp->b_pag = pag;
-	spin_unlock(&pag->pag_buf_lock);
+	new_bp->b_cache = bch;
+	spin_unlock(&bch->bc_lock);
 	*bpp = new_bp;
 	return 0;
 
 out_free_buf:
 	xfs_buf_free(new_bp);
 out_drop_pag:
-	xfs_perag_put(pag);
+	if (pag)
+		xfs_perag_put(pag);
 	return error;
 }
 
+/* Find the buffer cache for a particular buftarg and map. */
+static inline struct xfs_buf_cache *
+xfs_buftarg_get_cache(
+	struct xfs_buftarg		*btp,
+	const struct xfs_buf_map	*map,
+	struct xfs_perag		**pagp)
+{
+	struct xfs_mount		*mp = btp->bt_mount;
+
+	if (btp->bt_cache) {
+		*pagp = NULL;
+		return btp->bt_cache;
+	}
+
+	*pagp = xfs_perag_get(mp, xfs_daddr_to_agno(mp, map->bm_bn));
+	ASSERT(*pagp != NULL);
+	return &(*pagp)->pag_bcache;
+}
+
 /*
  * Assembles a buffer covering the specified range. The code is optimised for
  * cache hits, as metadata intensive workloads will see 3 orders of magnitude
@@ -681,6 +703,7 @@ xfs_buf_get_map(
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
 {
+	struct xfs_buf_cache	*bch;
 	struct xfs_perag	*pag;
 	struct xfs_buf		*bp = NULL;
 	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
@@ -696,10 +719,9 @@ xfs_buf_get_map(
 	if (error)
 		return error;
 
-	pag = xfs_perag_get(btp->bt_mount,
-			    xfs_daddr_to_agno(btp->bt_mount, cmap.bm_bn));
+	bch = xfs_buftarg_get_cache(btp, &cmap, &pag);
 
-	error = xfs_buf_lookup(pag, &cmap, flags, &bp);
+	error = xfs_buf_lookup(bch, &cmap, flags, &bp);
 	if (error && error != -ENOENT)
 		goto out_put_perag;
 
@@ -711,13 +733,14 @@ xfs_buf_get_map(
 			goto out_put_perag;
 
 		/* xfs_buf_find_insert() consumes the perag reference. */
-		error = xfs_buf_find_insert(btp, pag, &cmap, map, nmaps,
+		error = xfs_buf_find_insert(btp, bch, pag, &cmap, map, nmaps,
 				flags, &bp);
 		if (error)
 			return error;
 	} else {
 		XFS_STATS_INC(btp->bt_mount, xb_get_locked);
-		xfs_perag_put(pag);
+		if (pag)
+			xfs_perag_put(pag);
 	}
 
 	/* We do not hold a perag reference anymore. */
@@ -745,7 +768,8 @@ xfs_buf_get_map(
 	return 0;
 
 out_put_perag:
-	xfs_perag_put(pag);
+	if (pag)
+		xfs_perag_put(pag);
 	return error;
 }
 
@@ -999,12 +1023,13 @@ xfs_buf_rele(
 	struct xfs_buf		*bp)
 {
 	struct xfs_perag	*pag = bp->b_pag;
+	struct xfs_buf_cache	*bch = bp->b_cache;
 	bool			release;
 	bool			freebuf = false;
 
 	trace_xfs_buf_rele(bp, _RET_IP_);
 
-	if (!pag) {
+	if (!bch) {
 		ASSERT(list_empty(&bp->b_lru));
 		if (atomic_dec_and_test(&bp->b_hold)) {
 			xfs_buf_ioacct_dec(bp);
@@ -1026,7 +1051,7 @@ xfs_buf_rele(
 	 * leading to a use-after-free scenario.
 	 */
 	spin_lock(&bp->b_lock);
-	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
+	release = atomic_dec_and_lock(&bp->b_hold, &bch->bc_lock);
 	if (!release) {
 		/*
 		 * Drop the in-flight state if the buffer is already on the LRU
@@ -1051,7 +1076,7 @@ xfs_buf_rele(
 			bp->b_state &= ~XFS_BSTATE_DISPOSE;
 			atomic_inc(&bp->b_hold);
 		}
-		spin_unlock(&pag->pag_buf_lock);
+		spin_unlock(&bch->bc_lock);
 	} else {
 		/*
 		 * most of the time buffers will already be removed from the
@@ -1066,10 +1091,13 @@ xfs_buf_rele(
 		}
 
 		ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
-		rhashtable_remove_fast(&pag->pag_buf_hash, &bp->b_rhash_head,
-				       xfs_buf_hash_params);
-		spin_unlock(&pag->pag_buf_lock);
-		xfs_perag_put(pag);
+		rhashtable_remove_fast(&bch->bc_hash, &bp->b_rhash_head,
+				xfs_buf_hash_params);
+		spin_unlock(&bch->bc_lock);
+		if (pag)
+			xfs_perag_put(pag);
+		bp->b_cache = NULL;
+		bp->b_pag = NULL;
 		freebuf = true;
 	}
 
@@ -1991,25 +2019,18 @@ xfs_setsize_buftarg_early(
 	return xfs_setsize_buftarg(btp, bdev_logical_block_size(btp->bt_bdev));
 }
 
-struct xfs_buftarg *
-xfs_alloc_buftarg(
+static struct xfs_buftarg *
+xfs_alloc_buftarg_common(
 	struct xfs_mount	*mp,
-	struct bdev_handle	*bdev_handle)
+	const char		*descr)
 {
-	xfs_buftarg_t		*btp;
-	const struct dax_holder_operations *ops = NULL;
+	struct xfs_buftarg	*btp;
 
-#if defined(CONFIG_FS_DAX) && defined(CONFIG_MEMORY_FAILURE)
-	ops = &xfs_dax_holder_operations;
-#endif
 	btp = kmem_zalloc(sizeof(*btp), KM_NOFS);
+	if (!btp)
+		return NULL;
 
 	btp->bt_mount = mp;
-	btp->bt_bdev_handle = bdev_handle;
-	btp->bt_dev = bdev_handle->bdev->bd_dev;
-	btp->bt_bdev = bdev_handle->bdev;
-	btp->bt_daxdev = fs_dax_get_by_bdev(btp->bt_bdev, &btp->bt_dax_part_off,
-					    mp, ops);
 
 	/*
 	 * Buffer IO error rate limiting. Limit it to no more than 10 messages
@@ -2018,17 +2039,14 @@ xfs_alloc_buftarg(
 	ratelimit_state_init(&btp->bt_ioerror_rl, 30 * HZ,
 			     DEFAULT_RATELIMIT_BURST);
 
-	if (xfs_setsize_buftarg_early(btp))
-		goto error_free;
-
 	if (list_lru_init(&btp->bt_lru))
 		goto error_free;
 
 	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
 		goto error_lru;
 
-	btp->bt_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE, "xfs-buf:%s",
-					  mp->m_super->s_id);
+	btp->bt_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE, "xfs-%s:%s",
+			descr, mp->m_super->s_id);
 	if (!btp->bt_shrinker)
 		goto error_pcpu;
 
@@ -2057,6 +2075,39 @@ xfs_buf_list_del(
 	wake_up_var(&bp->b_list);
 }
 
+/* Allocate a buffer cache target for a persistent block device. */
+struct xfs_buftarg *
+xfs_alloc_buftarg(
+	struct xfs_mount	*mp,
+	struct bdev_handle	*bdev_handle)
+{
+	struct xfs_buftarg	*btp;
+	const struct dax_holder_operations *ops = NULL;
+
+#if defined(CONFIG_FS_DAX) && defined(CONFIG_MEMORY_FAILURE)
+	ops = &xfs_dax_holder_operations;
+#endif
+
+	btp = xfs_alloc_buftarg_common(mp, "buf");
+	if (!btp)
+		return NULL;
+
+	btp->bt_bdev_handle = bdev_handle;
+	btp->bt_dev = bdev_handle->bdev->bd_dev;
+	btp->bt_bdev = bdev_handle->bdev;
+	btp->bt_daxdev = fs_dax_get_by_bdev(btp->bt_bdev, &btp->bt_dax_part_off,
+					    mp, ops);
+
+	if (xfs_setsize_buftarg_early(btp))
+		goto error_free;
+
+	return btp;
+
+error_free:
+	xfs_free_buftarg(btp);
+	return NULL;
+}
+
 /*
  * Cancel a delayed write list.
  *
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b470de08a46ca..d4b6b58b16009 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -83,6 +83,14 @@ typedef unsigned int xfs_buf_flags_t;
 #define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
 #define XFS_BSTATE_IN_FLIGHT	 (1 << 1)	/* I/O in flight */
 
+struct xfs_buf_cache {
+	spinlock_t		bc_lock;
+	struct rhashtable	bc_hash;
+};
+
+int xfs_buf_cache_init(struct xfs_buf_cache *bch);
+void xfs_buf_cache_destroy(struct xfs_buf_cache *bch);
+
 /*
  * The xfs_buftarg contains 2 notions of "sector size" -
  *
@@ -103,6 +111,7 @@ typedef struct xfs_buftarg {
 	struct dax_device	*bt_daxdev;
 	u64			bt_dax_part_off;
 	struct xfs_mount	*bt_mount;
+	struct xfs_buf_cache	*bt_cache;
 	unsigned int		bt_meta_sectorsize;
 	size_t			bt_meta_sectormask;
 	size_t			bt_logical_sectorsize;
@@ -212,6 +221,7 @@ struct xfs_buf {
 	int			b_last_error;
 
 	const struct xfs_buf_ops	*b_ops;
+	struct xfs_buf_cache	*b_cache;
 	struct rcu_head		b_rcu;
 };
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e86dfe67894fb..772c913bcd2bd 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -505,9 +505,6 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 	return (xfs_agblock_t) do_div(ld, mp->m_sb.sb_agblocks);
 }
 
-int xfs_buf_hash_init(struct xfs_perag *pag);
-void xfs_buf_hash_destroy(struct xfs_perag *pag);
-
 extern void	xfs_uuid_table_free(void);
 extern uint64_t xfs_default_resblks(xfs_mount_t *mp);
 extern int	xfs_mountfs(xfs_mount_t *mp);

