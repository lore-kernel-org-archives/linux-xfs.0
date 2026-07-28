Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592C13BE15F
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226324; cv=none; b=aYCvoFrA8YKkMuxu0jQ8MUdkcKaoxu6T0BIaZOrq9UOaG5UsWVxlCSO73Ohp7W38b7cJvHv18Gs0cm6YbR173lUPpNovTJpoXXYKf5S08+axrjwoeisUwCsCFe5iB8eAHbSOT8JdYav0g7q9EMoP3RvOq9xEQkfty4buqwh2TUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226324; c=relaxed/simple;
	bh=/2ofKgc2IcM05XCAhdBSeT7g7F40uBFu0X3re+KtvZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIccR2twYoESr/Qpks8yI9jU5xa7u5JlaZMJVy2FTpqmlSJB6AMQyQUnJGF70td+lGqX302FN05F4wUarVAK4ut6HhhGtX18IkbGv1OqOKea71dirJ4k6XdSJJyFXMW+f4D1B/MIvxPWaNU8C6U+z0ztfANLWc4oFj/pMYIF4fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IAkwjsHi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IAkwjsHi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aLIQCGKCcjTOZZ5Cv+wuJESHXYJXtwio97bKNwM7WTc=; b=IAkwjsHi+YDOCH699zqRXQsM7S
	hdbD91KX10BXkY/8w9CjGBDopyKmJymdxZGiMCseHF3Ruy7tuNIu0Q7Fxz0/76YrcxVQj/LeVDFDM
	b+/FdLoahIht8s95GNK03wt+5Fz+pHZxszl+HPX8c42rfd5tpOGetv1IFuloGI1Gg68MpsXFJ9yK3
	5ARsFeV4BX/c8cnpkz+x++ygDwcWr9CoEi53J4irGZLpGSCp7Xob8SBq3DoL5D9yDHNooi4Kf9rah
	wNwc439imoVI/0WbFiAyp0AqNxYy8UUpduUMGVOIjpNVNuEnEi//hCNjuh7Uo7mWv9iHDAfuuQpbr
	JF/of9JA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocuw-00000004gwr-24yE;
	Tue, 28 Jul 2026 08:12:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/12] xfs: consolidate buffer locking in xfs_buf_get_map
Date: Tue, 28 Jul 2026 10:11:10 +0200
Message-ID: <20260728081152.1778841-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728081152.1778841-1-hch@lst.de>
References: <20260728081152.1778841-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Consolidate the code to lock the buffer based on the passed in flags
into xfs_buf_get_map instead of having two different sites for buffer
lookup vs insertation.  This requires initializing b_lock to unlocked on
allocation and doing an atomic for locking it for newly allocated buffers,
but greatly simplifies the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c   | 73 +++++++++++++++++++++-------------------------
 fs/xfs/xfs_trace.h |  2 +-
 2 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 16b9f3e50551..d4ab69112d11 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -261,6 +261,19 @@ xfs_buf_alloc_backing_mem(
 	return xfs_buf_alloc_folio(bp, size, gfp_mask);
 }
 
+/*
+ * Allocate a new buffer.
+ *
+ * The creator of a new buffer holds a lockref to that buffer.  This ensures
+ * that the buffer is owned by the caller and racing RCU lookups right after
+ * inserting into the hash table are safe against freeing.
+ *
+ * Racing threads trying to look up the buffer will have to wait for b_sema to
+ * do anything non-trivial.
+ *
+ * Note that b_sema is not locked at creation time, but only when a caller
+ * wants to access the buffer.
+ */
 static int
 xfs_buf_alloc(
 	struct xfs_buftarg	*target,
@@ -282,15 +295,8 @@ xfs_buf_alloc(
 	 * specifically set by later operations on the buffer.
 	 */
 	flags &= ~(XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
-
-	/*
-	 * A new buffer is held and locked by the owner.  This ensures that the
-	 * buffer is owned by the caller and racing RCU lookups right after
-	 * inserting into the hash table are safe (and will have to wait for
-	 * the unlock to do anything non-trivial).
-	 */
 	lockref_init(&bp->b_lockref);
-	sema_init(&bp->b_sema, 0); /* held, no waiters */
+	sema_init(&bp->b_sema, 1); /* unlocked */
 	atomic_set(&bp->b_lru_ref, 1);
 	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_lru);
@@ -433,33 +439,25 @@ xfs_buf_find_lock(
 	return 0;
 }
 
-static inline int
+static inline struct xfs_buf *
 xfs_buf_lookup(
 	struct xfs_buftarg	*btp,
-	struct xfs_buf_map	*map,
-	xfs_buf_flags_t		flags,
-	struct xfs_buf		**bpp)
+	struct xfs_buf_map	*map)
 {
 	struct xfs_buf          *bp;
-	int			error;
 
 	rcu_read_lock();
 	bp = rhashtable_lookup(&btp->bt_hash, map, xfs_buf_hash_params);
 	if (!bp || !lockref_get_not_dead(&bp->b_lockref)) {
 		rcu_read_unlock();
-		return -ENOENT;
+		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
+		return NULL;
 	}
 	rcu_read_unlock();
 
-	error = xfs_buf_find_lock(bp, flags);
-	if (error) {
-		xfs_buf_rele(bp);
-		return error;
-	}
-
-	trace_xfs_buf_find(bp, flags, _RET_IP_);
-	*bpp = bp;
-	return 0;
+	trace_xfs_buf_find(bp, _RET_IP_);
+	XFS_STATS_INC(btp->bt_mount, xb_get_locked);
+	return bp;
 }
 
 /*
@@ -512,11 +510,7 @@ xfs_buf_find_insert(
 			goto retry;
 		}
 		rcu_read_unlock();
-		error = xfs_buf_find_lock(bp, flags);
-		if (error)
-			xfs_buf_rele(bp);
-		else
-			*bpp = bp;
+		*bpp = bp;
 		goto out_free_buf;
 	}
 	rcu_read_unlock();
@@ -558,21 +552,20 @@ xfs_buf_get_map(
 	if (error)
 		return error;
 
-	error = xfs_buf_lookup(btp, &cmap, flags, &bp);
-	if (error && error != -ENOENT)
-		return error;
-
 	/* cache hits always outnumber misses by at least 10:1 */
+	bp = xfs_buf_lookup(btp, &cmap);
 	if (unlikely(!bp)) {
-		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
-
 		if (flags & XBF_INCORE)
 			return -ENOENT;
 		error = xfs_buf_find_insert(btp, &cmap, map, nmaps, flags, &bp);
 		if (error)
 			return error;
-	} else {
-		XFS_STATS_INC(btp->bt_mount, xb_get_locked);
+	}
+
+	error = xfs_buf_find_lock(bp, flags);
+	if (error) {
+		xfs_buf_rele(bp);
+		return error;
 	}
 
 	/*
@@ -797,9 +790,11 @@ xfs_buf_get_uncached(
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
 
 	error = xfs_buf_alloc(target, &map, 1, 0, bpp);
-	if (!error)
-		trace_xfs_buf_get_uncached(*bpp, _RET_IP_);
-	return error;
+	if (error)
+		return error;
+	xfs_buf_lock(*bpp);
+	trace_xfs_buf_get_uncached(*bpp, _RET_IP_);
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index aeb89ac53bf1..f333c938fbd9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -792,6 +792,7 @@ DEFINE_BUF_EVENT(xfs_buf_backing_folio);
 DEFINE_BUF_EVENT(xfs_buf_backing_kmem);
 DEFINE_BUF_EVENT(xfs_buf_backing_vmalloc);
 DEFINE_BUF_EVENT(xfs_buf_backing_fallback);
+DEFINE_BUF_EVENT(xfs_buf_find);
 
 /* not really buffer traces, but the buf provides useful information */
 DEFINE_BUF_EVENT(xfs_btree_corrupt);
@@ -837,7 +838,6 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 DEFINE_EVENT(xfs_buf_flags_class, name, \
 	TP_PROTO(struct xfs_buf *bp, unsigned flags, unsigned long caller_ip), \
 	TP_ARGS(bp, flags, caller_ip))
-DEFINE_BUF_FLAGS_EVENT(xfs_buf_find);
 DEFINE_BUF_FLAGS_EVENT(xfs_buf_get);
 DEFINE_BUF_FLAGS_EVENT(xfs_buf_read);
 DEFINE_BUF_FLAGS_EVENT(xfs_buf_readahead);
-- 
2.53.0

