Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2621A4D599;
	Mon,  3 Feb 2025 08:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738570049; cv=none; b=mwyzUKxQn9itV2binwTFrAFnM0wyd4oskEhSeTCWziwgMsP1cdZAJvR1ZtRZxWDdy1btm8owukEtv21vQ+kASs9fmdIrZeuA3e5s0T1Ewl0hpUVSmyqtE9gwBdMo8QvrdAVbiY6vOyAjdYpza7QKgKEEuwCsVPn+WsODUfR05M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738570049; c=relaxed/simple;
	bh=XOp4H+WOcByLhmFDhTidKzAOiywwOz5OfjkvWFchcxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9KGzgaeJzo1k1nfnd1goYXTTTrtgiejTtIAnIliB3P6EDCOk8P0FDMzLdboz07No3/adcOoRtlAFnct/aepMoHnzIyk22DqczuaGEEAPm3jEFrEPgzinanFle8e/i/ieYmsPXhGp7nRledZiFj8w5wFaARoV/AeSnjSXnCafag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2024168AA6; Mon,  3 Feb 2025 09:07:21 +0100 (CET)
Date: Mon, 3 Feb 2025 09:07:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: syzbot <syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com>
Cc: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, hch@lst.de,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_buf_find_insert
Message-ID: <20250203080720.GA18459@lst.de>
References: <20250203073038.GA17805@lst.de> <67a07656.050a0220.d7c5a.0081.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67a07656.050a0220.d7c5a.0081.GAE@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

#syz test https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

From a9ab28b3d21aec6d0f56fe722953e20ce470237b Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 28 Jan 2025 06:22:58 +0100
Subject: xfs: remove xfs_buf_cache.bc_lock

xfs_buf_cache.bc_lock serializes adding buffers to and removing them from
the hashtable.  But as the rhashtable code already uses fine grained
internal locking for inserts and removals the extra protection isn't
actually required.

It also happens to fix a lock order inversion vs b_lock added by the
recent lookup race fix.

Fixes: ee10f6fcdb96 ("xfs: fix buffer lookup vs release race")
Reported-by: Lai, Yi <yi1.lai@linux.intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 fs/xfs/xfs_buf.c | 31 +++++++++++++++++--------------
 fs/xfs/xfs_buf.h |  1 -
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f1252ed8bd0a..ef207784876c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -41,8 +41,7 @@ struct kmem_cache *xfs_buf_cache;
  *
  * xfs_buf_rele:
  *	b_lock
- *	  pag_buf_lock
- *	    lru_lock
+ *	  lru_lock
  *
  * xfs_buftarg_drain_rele
  *	lru_lock
@@ -220,14 +219,21 @@ _xfs_buf_alloc(
 	 */
 	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
 
-	spin_lock_init(&bp->b_lock);
+	/*
+	 * A new buffer is held and locked by the owner.  This ensures that the
+	 * buffer is owned by the caller and racing RCU lookups right after
+	 * inserting into the hash table are safe (and will have to wait for
+	 * the unlock to do anything non-trivial).
+	 */
 	bp->b_hold = 1;
+	sema_init(&bp->b_sema, 0); /* held, no waiters */
+
+	spin_lock_init(&bp->b_lock);
 	atomic_set(&bp->b_lru_ref, 1);
 	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_lru);
 	INIT_LIST_HEAD(&bp->b_list);
 	INIT_LIST_HEAD(&bp->b_li_list);
-	sema_init(&bp->b_sema, 0); /* held, no waiters */
 	bp->b_target = target;
 	bp->b_mount = target->bt_mount;
 	bp->b_flags = flags;
@@ -497,7 +503,6 @@ int
 xfs_buf_cache_init(
 	struct xfs_buf_cache	*bch)
 {
-	spin_lock_init(&bch->bc_lock);
 	return rhashtable_init(&bch->bc_hash, &xfs_buf_hash_params);
 }
 
@@ -647,17 +652,20 @@ xfs_buf_find_insert(
 	if (error)
 		goto out_free_buf;
 
-	spin_lock(&bch->bc_lock);
+	/* The new buffer keeps the perag reference until it is freed. */
+	new_bp->b_pag = pag;
+
+	rcu_read_lock();
 	bp = rhashtable_lookup_get_insert_fast(&bch->bc_hash,
 			&new_bp->b_rhash_head, xfs_buf_hash_params);
 	if (IS_ERR(bp)) {
+		rcu_read_unlock();
 		error = PTR_ERR(bp);
-		spin_unlock(&bch->bc_lock);
 		goto out_free_buf;
 	}
 	if (bp && xfs_buf_try_hold(bp)) {
 		/* found an existing buffer */
-		spin_unlock(&bch->bc_lock);
+		rcu_read_unlock();
 		error = xfs_buf_find_lock(bp, flags);
 		if (error)
 			xfs_buf_rele(bp);
@@ -665,10 +673,8 @@ xfs_buf_find_insert(
 			*bpp = bp;
 		goto out_free_buf;
 	}
+	rcu_read_unlock();
 
-	/* The new buffer keeps the perag reference until it is freed. */
-	new_bp->b_pag = pag;
-	spin_unlock(&bch->bc_lock);
 	*bpp = new_bp;
 	return 0;
 
@@ -1085,7 +1091,6 @@ xfs_buf_rele_cached(
 	}
 
 	/* we are asked to drop the last reference */
-	spin_lock(&bch->bc_lock);
 	__xfs_buf_ioacct_dec(bp);
 	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
 		/*
@@ -1097,7 +1102,6 @@ xfs_buf_rele_cached(
 			bp->b_state &= ~XFS_BSTATE_DISPOSE;
 		else
 			bp->b_hold--;
-		spin_unlock(&bch->bc_lock);
 	} else {
 		bp->b_hold--;
 		/*
@@ -1115,7 +1119,6 @@ xfs_buf_rele_cached(
 		ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 		rhashtable_remove_fast(&bch->bc_hash, &bp->b_rhash_head,
 				xfs_buf_hash_params);
-		spin_unlock(&bch->bc_lock);
 		if (pag)
 			xfs_perag_put(pag);
 		freebuf = true;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 7e73663c5d4a..3b4ed42e11c0 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -80,7 +80,6 @@ typedef unsigned int xfs_buf_flags_t;
 #define XFS_BSTATE_IN_FLIGHT	 (1 << 1)	/* I/O in flight */
 
 struct xfs_buf_cache {
-	spinlock_t		bc_lock;
 	struct rhashtable	bc_hash;
 };
 
-- 
2.45.2

