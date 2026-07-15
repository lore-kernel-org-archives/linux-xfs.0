Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FE4399372
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 14:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127119; cv=none; b=kfVNZFZl9QMQDVt0Wa2NFcvUHPSxJGnGMwGBa0NOsRzh0UMgTDHXtISz8lnbTV2b+MJnxm6Xp2Z9HIqkE7j3gFYH8SVutEc+B9WEgxszmN46dnLeIWkfko2ViMXlIpvC05q1q4KfmAGUo6bqoGB56gymVz6Z/ZcQgYWZUMfwkRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127119; c=relaxed/simple;
	bh=z6f/JWBIJCLVh3wQXys6/xpFCYb3jp7LlDg8DfgwlyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqqXhGvhYbYoa83zko7XhskYx+fE0s0J2taBTh12GxcGkrajNsL9+EXKkKboCPhH+uWVjkooxdDhzmxHGq3tTsU2ULpyzS+5pjFqvJwHhIvAXA9X3E6rUFHsx8vhZYqoV7DNsuSkCpbLJt1qbO3md59ohhJclKkI0kVB0CspLaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LE0S5U06; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LE0S5U06"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H6gBkmLilg6ii8ss7GJwpbVWotAO51mgQCLwrkUVU+g=; b=LE0S5U066UwTwYDUKSv9fUwBrS
	qNGN3OPqXUa4a1HnqJJRRo5XPWPasjIAV9P5OGtFNXh7WjegVZVcElvRldoIdKIBbMdHWyqQJrLwq
	ppkZw0fpSQFJwEPPfEWkmPUduwfBqRLnw8i53J1CV7NafYN8NZf2E4w8Flnsa4lKaDCO4jnv43B10
	ClqOOQ9qo/GDsfhF+YdYyHb7Bn8ALd5d4N0PTqqZOTmgsa7+6WppYeanP/n+Llwxr/8n03jJr9ffc
	mSkMWel++mQBiRD0Xazsr2iOihqrWC0yCm2hXWq+3cR2kLPKKTaXLw9JNYvmBTEo2BGd7BhGIEN28
	+vs4ucbg==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0xo-0000000FDV6-1mjj;
	Wed, 15 Jul 2026 14:51:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/12] xfs: consolidate buffer locking in xfs_buf_get_map
Date: Wed, 15 Jul 2026 16:50:55 +0200
Message-ID: <20260715145147.95654-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715145147.95654-1-hch@lst.de>
References: <20260715145147.95654-1-hch@lst.de>
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
---
 fs/xfs/xfs_buf.c   | 62 ++++++++++++++++------------------------------
 fs/xfs/xfs_trace.h |  2 +-
 2 files changed, 23 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 54e091315d56..e56d4b8b0771 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -282,15 +282,8 @@ xfs_buf_alloc(
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
@@ -433,33 +426,25 @@ xfs_buf_find_lock(
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
@@ -509,11 +494,7 @@ xfs_buf_find_insert(
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
@@ -555,21 +536,20 @@ xfs_buf_get_map(
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
-			return 0;
+			return -ENOENT;
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
@@ -794,9 +774,11 @@ xfs_buf_get_uncached(
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

