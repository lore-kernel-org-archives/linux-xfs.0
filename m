Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E0A85278
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817459; cv=none; b=WtsE2FCg5hU62rdDw2t0xT9dXU9MjIfUAq3cOeWL1S3nFadJNqQeN0G039mHk80SsE0RNmJJ446c3JIRH3JPPOIKWHvhjeGry9Lla5Kogtetie0dsEZjM+0F6TL2+D1T+DHKY+G5sIfK19oYwjV1Gi8vvoBBH4JjRvaxUdIY8ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817459; c=relaxed/simple;
	bh=rz0gAoLDxIyWZj0LITh4uoYefBYftUCMsDChkbYlcjM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bEwV/ERR8B8fphIObeqrIWbTxpS2+DdeiRnK7xnHmVFmoUlZxUOzTERr4NTc5qbJh3iR3tDwERg+6eWxlofzGv1+/lnNmcKQSxAnpFqLWvkUnXmCY6IYyJupxq38IJt+aSeETnk9cpyv1zd+z3V549gsO+Nrb5uUn3BKaGQ8BQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dYJXAWRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dYJXAWRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46348C433F1;
	Thu,  1 Feb 2024 19:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817459;
	bh=rz0gAoLDxIyWZj0LITh4uoYefBYftUCMsDChkbYlcjM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dYJXAWRptHtyqbeUQw5vzvAi4HdO4nSP2zCDW0p78K5m26NhQZLuH+rMVukv7p26i
	 GiDWyGZ6epu/jcEwIPD0UnI1PezWgpRtnWBG+RcWu5jt2G94DwqCT4ZxfVB/erwwve
	 rHGKV/XqK17Vi3VU02ZCRORCm+Du1uVUsxoHnUf5+9sZ8iwlHU8G7aq4yDbtWZGeSa
	 lpE3Xsu1LI4TL3IXdRbuIWszmU726SUHrbbG/S7h+2cmTZUJqg+X9njLzNLxgcr0vy
	 ySQfnv6rRk6rvuxVYhlvZjTP1GaRU6n+n1gmjn5ID38QSUI9k9J83wVoasIuWTDszG
	 y8pl5Sj5hEW+Q==
Date: Thu, 01 Feb 2024 11:57:38 -0800
Subject: [PATCH 1/5] xfs: teach buftargs to maintain their own buffer
 hashtable
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170681336975.1608400.15103821354987789245.stgit@frogsfrogsfrogs>
In-Reply-To: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
References: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
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
great for the data device, but won't work for in-memory btrees.  To
handle that use case, buftargs will need to be able to index buffers
independently of other data structures.

We accomplish this by hoisting the rhashtable and its lock into a
separate xfs_buf_cache structure, make the buftarg point to the
_buf_cache structure, and rework various functions to use it.  This
will enable the in-memory buftarg to come up with its own _buf_cache.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    6 ++-
 fs/xfs/libxfs/xfs_ag.h |    4 +-
 fs/xfs/xfs_buf.c       |   84 +++++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_buf.h       |    8 +++++
 fs/xfs/xfs_mount.h     |    3 --
 5 files changed, 67 insertions(+), 38 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 5c35babc30de7..279ba77236d66 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -264,7 +264,7 @@ xfs_free_perag(
 		xfs_defer_drain_free(&pag->pag_intents_drain);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
-		xfs_buf_hash_destroy(pag);
+		xfs_buf_cache_destroy(&pag->pag_bcache);
 
 		/* drop the mount's active reference */
 		xfs_perag_rele(pag);
@@ -352,7 +352,7 @@ xfs_free_unused_perag_range(
 		spin_unlock(&mp->m_perag_lock);
 		if (!pag)
 			break;
-		xfs_buf_hash_destroy(pag);
+		xfs_buf_cache_destroy(&pag->pag_bcache);
 		xfs_defer_drain_free(&pag->pag_intents_drain);
 		kmem_free(pag);
 	}
@@ -419,7 +419,7 @@ xfs_initialize_perag(
 		pag->pagb_tree = RB_ROOT;
 #endif /* __KERNEL__ */
 
-		error = xfs_buf_hash_init(pag);
+		error = xfs_buf_cache_init(&pag->pag_bcache);
 		if (error)
 			goto out_remove_pag;
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 19eddba098941..29bfa6273decb 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -106,9 +106,7 @@ struct xfs_perag {
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
-	/* buffer cache index */
-	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
-	struct rhashtable pag_buf_hash;
+	struct xfs_buf_cache	pag_bcache;
 
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6958729ee7e46..dff7f5e573999 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -504,18 +504,18 @@ static const struct rhashtable_params xfs_buf_hash_params = {
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
@@ -578,7 +578,7 @@ xfs_buf_find_lock(
 
 static inline int
 xfs_buf_lookup(
-	struct xfs_perag	*pag,
+	struct xfs_buf_cache	*bch,
 	struct xfs_buf_map	*map,
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
@@ -587,7 +587,7 @@ xfs_buf_lookup(
 	int			error;
 
 	rcu_read_lock();
-	bp = rhashtable_lookup(&pag->pag_buf_hash, map, xfs_buf_hash_params);
+	bp = rhashtable_lookup(&bch->bc_hash, map, xfs_buf_hash_params);
 	if (!bp || !atomic_inc_not_zero(&bp->b_hold)) {
 		rcu_read_unlock();
 		return -ENOENT;
@@ -612,6 +612,7 @@ xfs_buf_lookup(
 static int
 xfs_buf_find_insert(
 	struct xfs_buftarg	*btp,
+	struct xfs_buf_cache	*bch,
 	struct xfs_perag	*pag,
 	struct xfs_buf_map	*cmap,
 	struct xfs_buf_map	*map,
@@ -640,18 +641,18 @@ xfs_buf_find_insert(
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
@@ -662,17 +663,36 @@ xfs_buf_find_insert(
 
 	/* The new buffer keeps the perag reference until it is freed. */
 	new_bp->b_pag = pag;
-	spin_unlock(&pag->pag_buf_lock);
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
 
+static inline struct xfs_perag *
+xfs_buftarg_get_pag(
+	struct xfs_buftarg		*btp,
+	const struct xfs_buf_map	*map)
+{
+	struct xfs_mount		*mp = btp->bt_mount;
+
+	return xfs_perag_get(mp, xfs_daddr_to_agno(mp, map->bm_bn));
+}
+
+static inline struct xfs_buf_cache *
+xfs_buftarg_buf_cache(
+	struct xfs_buftarg		*btp,
+	struct xfs_perag		*pag)
+{
+	return &pag->pag_bcache;
+}
+
 /*
  * Assembles a buffer covering the specified range. The code is optimised for
  * cache hits, as metadata intensive workloads will see 3 orders of magnitude
@@ -686,6 +706,7 @@ xfs_buf_get_map(
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
 {
+	struct xfs_buf_cache	*bch;
 	struct xfs_perag	*pag;
 	struct xfs_buf		*bp = NULL;
 	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
@@ -701,10 +722,10 @@ xfs_buf_get_map(
 	if (error)
 		return error;
 
-	pag = xfs_perag_get(btp->bt_mount,
-			    xfs_daddr_to_agno(btp->bt_mount, cmap.bm_bn));
+	pag = xfs_buftarg_get_pag(btp, &cmap);
+	bch = xfs_buftarg_buf_cache(btp, pag);
 
-	error = xfs_buf_lookup(pag, &cmap, flags, &bp);
+	error = xfs_buf_lookup(bch, &cmap, flags, &bp);
 	if (error && error != -ENOENT)
 		goto out_put_perag;
 
@@ -716,13 +737,14 @@ xfs_buf_get_map(
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
@@ -750,7 +772,8 @@ xfs_buf_get_map(
 	return 0;
 
 out_put_perag:
-	xfs_perag_put(pag);
+	if (pag)
+		xfs_perag_put(pag);
 	return error;
 }
 
@@ -1010,7 +1033,9 @@ static void
 xfs_buf_rele_cached(
 	struct xfs_buf		*bp)
 {
+	struct xfs_buftarg	*btp = bp->b_target;
 	struct xfs_perag	*pag = bp->b_pag;
+	struct xfs_buf_cache	*bch = xfs_buftarg_buf_cache(btp, pag);
 	bool			release;
 	bool			freebuf = false;
 
@@ -1029,7 +1054,7 @@ xfs_buf_rele_cached(
 	 * leading to a use-after-free scenario.
 	 */
 	spin_lock(&bp->b_lock);
-	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
+	release = atomic_dec_and_lock(&bp->b_hold, &bch->bc_lock);
 	if (!release) {
 		/*
 		 * Drop the in-flight state if the buffer is already on the LRU
@@ -1050,11 +1075,11 @@ xfs_buf_rele_cached(
 		 * buffer for the LRU and clear the (now stale) dispose list
 		 * state flag
 		 */
-		if (list_lru_add_obj(&bp->b_target->bt_lru, &bp->b_lru)) {
+		if (list_lru_add_obj(&btp->bt_lru, &bp->b_lru)) {
 			bp->b_state &= ~XFS_BSTATE_DISPOSE;
 			atomic_inc(&bp->b_hold);
 		}
-		spin_unlock(&pag->pag_buf_lock);
+		spin_unlock(&bch->bc_lock);
 	} else {
 		/*
 		 * most of the time buffers will already be removed from the
@@ -1063,16 +1088,17 @@ xfs_buf_rele_cached(
 		 * was on was the disposal list
 		 */
 		if (!(bp->b_state & XFS_BSTATE_DISPOSE)) {
-			list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
+			list_lru_del_obj(&btp->bt_lru, &bp->b_lru);
 		} else {
 			ASSERT(list_empty(&bp->b_lru));
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
 		freebuf = true;
 	}
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b9216dee7810c..7b01df6dcd504 100644
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
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6c44e6db4d862..e880aa48de68b 100644
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

