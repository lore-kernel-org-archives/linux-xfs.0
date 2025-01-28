Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F123C290F
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 05:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738041801; cv=none; b=tH3GopnWhYWtQWqf0wQQhXpLTFN5hSS5n13wlTMsnBTkj7TuIuGfG3NFs47tyKaYpFhu3HI0F0QQmViR6/QyU+50rG0cyYEcBQvIuLJd+COZ4NRDX7G+98aI/AsLAdqXcgdlxkUa0VAGOjyi9G+U+hEc0gS4EVDcPmM6LPsfhnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738041801; c=relaxed/simple;
	bh=B3cFh0RfTK0TQttUolMjD5SCR+MLGSN/EvNxJfwrYMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JEA0LE/A19JawvJ5WqxI/O6bMYaHx8m4/XE5uxyOiPMS/+S4uDhkBwk7KsCSSr460DRXVJVSVUr7O8+teR2dxV1tueivXxodtq6YRypU9mVrNd+qNHr0OuImDbP4zkNeDuIn9tut9Y28OapV2pIG3yHDbudNhauJDiZ9+UYnbbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ryap70Ou; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ryap70Ou"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=z7a9raFEoWJznCkKXTzC6Eu9KntJz0kRG2qaI7ezzAw=; b=ryap70OulI9gNv+bA2dgilOvG/
	h8PaUQwRAsFRIFhPFR9INkJ+VroxovdBTtkLfvuM6bKa1dzTUS1xXwreFVpRZkUYZQppTqTAr36Nz
	eIWig0AUou+ft15doE+D4AoY08GayKcNMiakL3FAf/tCjv6qnAX6VcrZsVpH3JkKkaI35Ivp5qBBA
	v16Sv/VyNTcHKCraOJgyVrmTBr3suwtSfFlA1On24XWDrSysWc00B98a1LEnJHZlfcypwXuogW+ab
	AyRWPrDhEJcklip/45/Ec3Awvl8w/GMM1EEeuKsL6lqcRCc7yLrQ5CFL9VYQy+PAPirBHAM711TQJ
	wNOqs6jQ==;
Received: from 2a02-8389-2341-5b80-d7c6-3fcb-a44b-90d7.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d7c6:3fcb:a44b:90d7] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tce4F-000000049Th-0Y15;
	Tue, 28 Jan 2025 05:23:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	dchinner@redhat.com,
	linux-xfs@vger.kernel.org,
	"Lai, Yi" <yi1.lai@linux.intel.com>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH v2] xfs: remove xfs_buf_cache.bc_lock
Date: Tue, 28 Jan 2025 06:22:58 +0100
Message-ID: <20250128052315.663868-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buf_cache.bc_lock serializes adding buffers to and removing them from
the hashtable.  But as the rhashtable code already uses fine grained
internal locking for inserts and removals the extra protection isn't
actually required.

It also happens to fix a lock order inversion vs b_lock added by the
recent lookup race fix.

Fixes: ee10f6fcdb96 ("xfs: fix buffer lookup vs release race")
Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Changes since v1:
 - document the initial buffer state vs lockless lookups

 fs/xfs/xfs_buf.c | 31 +++++++++++++++++--------------
 fs/xfs/xfs_buf.h |  1 -
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d1d4a0a22e13..5db1b9022865 100644
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
@@ -502,7 +508,6 @@ int
 xfs_buf_cache_init(
 	struct xfs_buf_cache	*bch)
 {
-	spin_lock_init(&bch->bc_lock);
 	return rhashtable_init(&bch->bc_hash, &xfs_buf_hash_params);
 }
 
@@ -652,17 +657,20 @@ xfs_buf_find_insert(
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
@@ -670,10 +678,8 @@ xfs_buf_find_insert(
 			*bpp = bp;
 		goto out_free_buf;
 	}
+	rcu_read_unlock();
 
-	/* The new buffer keeps the perag reference until it is freed. */
-	new_bp->b_pag = pag;
-	spin_unlock(&bch->bc_lock);
 	*bpp = new_bp;
 	return 0;
 
@@ -1090,7 +1096,6 @@ xfs_buf_rele_cached(
 	}
 
 	/* we are asked to drop the last reference */
-	spin_lock(&bch->bc_lock);
 	__xfs_buf_ioacct_dec(bp);
 	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
 		/*
@@ -1102,7 +1107,6 @@ xfs_buf_rele_cached(
 			bp->b_state &= ~XFS_BSTATE_DISPOSE;
 		else
 			bp->b_hold--;
-		spin_unlock(&bch->bc_lock);
 	} else {
 		bp->b_hold--;
 		/*
@@ -1120,7 +1124,6 @@ xfs_buf_rele_cached(
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

