Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A2379D2
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 05:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742190538; cv=none; b=kPAGMaVC4j2beXatYA/5Pj51mVba5vCDPY7l5t4iHy0VsrWKWNkVZjWTxJS7iuC9azKBaA6bGEi2c+3DVNbWMeeN0+iZyNI49oR5g1xkOaBhIQ90JkSKfkFo3cL86yxWx9UnDM+SrHjr0ZrjWS8/He1+AV+Or4EHLYfapuOmrbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742190538; c=relaxed/simple;
	bh=XGplgajrW/SCs2w7VsPa4e9FE24Kd59vwE4G0NzkEPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYFhpG8G3FFtCx8Az1pDfOXH9DdkE902enZwZ53Fp4wlGrc0LRJbEkNdWWeLMSZbSqirSePTCoHHTFVJFCY4mORuq3wnCFBP674ABGPKuJfk6Hh95W7NK9npS09xF95TTR+JblEhRSIXaU8hhjsv0g2ty7cnbV4pfCibuPjXuqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w6V0C1lw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w6V0C1lw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QQAW/mEgZikIpbo+X4T7ENxp99nVvGFkxe13f2Pzy3k=; b=w6V0C1lwVBxrg+J5GaRlCvVNi9
	Ag8+F973dWGQORnRBztIqGFmyCPdwwwkjDz/kd0QoiRdG/3XiQ9gqi0lTdKkvcOFGn5WRet6lUx3G
	yw9KYudBfHyWSGuw3iie3ZQkzJY4+0QLHthdoDLkmJ9UfqUW2Y72OGdLH5YYO82RxyoYcUkRfdRZr
	ZcGMOFbhGudD9ZFrvjuEbmTa7MRfytEpiz+3SHFHCwkNGKffZobUksy8kAZOnYk/pxnT2eLl0rus+
	cP+uydMJulqAs2ovVLZQvbPMB9CvxRmbHJW9IzEwFVdfZ76CcMdksGgSeTCMQ018OdkyRJQH9I2xE
	DB+PC5Uw==;
Received: from [2001:4bb8:2dd:4138:8d2f:1fda:8eb2:7cb7] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tu3LL-00000001Ini-41K5;
	Mon, 17 Mar 2025 05:48:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: call xfs_buf_alloc_backing_mem from _xfs_buf_alloc
Date: Mon, 17 Mar 2025 06:48:32 +0100
Message-ID: <20250317054850.1132557-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250317054850.1132557-1-hch@lst.de>
References: <20250317054850.1132557-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

We never allocate a buffer without backing memory.  Simplify the call
chain by calling xfs_buf_alloc_backing_mem from _xfs_buf_alloc.  To
avoid a forward declaration, move _xfs_buf_alloc down a bit in the
file.

Also drop the pointless _-prefix from _xfs_buf_alloc.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 165 +++++++++++++++++++++--------------------------
 1 file changed, 75 insertions(+), 90 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 106ee81fa56f..f42f6e47f783 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -118,71 +118,6 @@ xfs_buf_free_maps(
 	}
 }
 
-static int
-_xfs_buf_alloc(
-	struct xfs_buftarg	*target,
-	struct xfs_buf_map	*map,
-	int			nmaps,
-	xfs_buf_flags_t		flags,
-	struct xfs_buf		**bpp)
-{
-	struct xfs_buf		*bp;
-	int			error;
-	int			i;
-
-	*bpp = NULL;
-	bp = kmem_cache_zalloc(xfs_buf_cache,
-			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
-
-	/*
-	 * We don't want certain flags to appear in b_flags unless they are
-	 * specifically set by later operations on the buffer.
-	 */
-	flags &= ~(XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
-
-	/*
-	 * A new buffer is held and locked by the owner.  This ensures that the
-	 * buffer is owned by the caller and racing RCU lookups right after
-	 * inserting into the hash table are safe (and will have to wait for
-	 * the unlock to do anything non-trivial).
-	 */
-	bp->b_hold = 1;
-	sema_init(&bp->b_sema, 0); /* held, no waiters */
-
-	spin_lock_init(&bp->b_lock);
-	atomic_set(&bp->b_lru_ref, 1);
-	init_completion(&bp->b_iowait);
-	INIT_LIST_HEAD(&bp->b_lru);
-	INIT_LIST_HEAD(&bp->b_list);
-	INIT_LIST_HEAD(&bp->b_li_list);
-	bp->b_target = target;
-	bp->b_mount = target->bt_mount;
-	bp->b_flags = flags;
-
-	error = xfs_buf_get_maps(bp, nmaps);
-	if (error)  {
-		kmem_cache_free(xfs_buf_cache, bp);
-		return error;
-	}
-
-	bp->b_rhash_key = map[0].bm_bn;
-	bp->b_length = 0;
-	for (i = 0; i < nmaps; i++) {
-		bp->b_maps[i].bm_bn = map[i].bm_bn;
-		bp->b_maps[i].bm_len = map[i].bm_len;
-		bp->b_length += map[i].bm_len;
-	}
-
-	atomic_set(&bp->b_pin_count, 0);
-	init_waitqueue_head(&bp->b_waiters);
-
-	XFS_STATS_INC(bp->b_mount, xb_create);
-	trace_xfs_buf_init(bp, _RET_IP_);
-
-	*bpp = bp;
-	return 0;
-}
-
 static void
 xfs_buf_free_callback(
 	struct callback_head	*cb)
@@ -342,6 +277,77 @@ xfs_buf_alloc_backing_mem(
 	return 0;
 }
 
+static int
+xfs_buf_alloc(
+	struct xfs_buftarg	*target,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+	int			i;
+
+	*bpp = NULL;
+	bp = kmem_cache_zalloc(xfs_buf_cache,
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
+
+	/*
+	 * We don't want certain flags to appear in b_flags unless they are
+	 * specifically set by later operations on the buffer.
+	 */
+	flags &= ~(XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
+
+	/*
+	 * A new buffer is held and locked by the owner.  This ensures that the
+	 * buffer is owned by the caller and racing RCU lookups right after
+	 * inserting into the hash table are safe (and will have to wait for
+	 * the unlock to do anything non-trivial).
+	 */
+	bp->b_hold = 1;
+	sema_init(&bp->b_sema, 0); /* held, no waiters */
+
+	spin_lock_init(&bp->b_lock);
+	atomic_set(&bp->b_lru_ref, 1);
+	init_completion(&bp->b_iowait);
+	INIT_LIST_HEAD(&bp->b_lru);
+	INIT_LIST_HEAD(&bp->b_list);
+	INIT_LIST_HEAD(&bp->b_li_list);
+	bp->b_target = target;
+	bp->b_mount = target->bt_mount;
+	bp->b_flags = flags;
+
+	error = xfs_buf_get_maps(bp, nmaps);
+	if (error)  {
+		kmem_cache_free(xfs_buf_cache, bp);
+		return error;
+	}
+
+	bp->b_rhash_key = map[0].bm_bn;
+	bp->b_length = 0;
+	for (i = 0; i < nmaps; i++) {
+		bp->b_maps[i].bm_bn = map[i].bm_bn;
+		bp->b_maps[i].bm_len = map[i].bm_len;
+		bp->b_length += map[i].bm_len;
+	}
+
+	atomic_set(&bp->b_pin_count, 0);
+	init_waitqueue_head(&bp->b_waiters);
+
+	XFS_STATS_INC(bp->b_mount, xb_create);
+	trace_xfs_buf_init(bp, _RET_IP_);
+
+	error = xfs_buf_alloc_backing_mem(bp, flags);
+	if (error) {
+		xfs_buf_free(bp);
+		return error;
+	}
+
+	*bpp = bp;
+	return 0;
+}
+
 /*
  *	Finding and Reading Buffers
  */
@@ -525,14 +531,10 @@ xfs_buf_find_insert(
 	struct xfs_buf		*bp;
 	int			error;
 
-	error = _xfs_buf_alloc(btp, map, nmaps, flags, &new_bp);
+	error = xfs_buf_alloc(btp, map, nmaps, flags, &new_bp);
 	if (error)
 		goto out_drop_pag;
 
-	error = xfs_buf_alloc_backing_mem(new_bp, flags);
-	if (error)
-		goto out_free_buf;
-
 	/* The new buffer keeps the perag reference until it is freed. */
 	new_bp->b_pag = pag;
 
@@ -869,28 +871,11 @@ xfs_buf_get_uncached(
 	struct xfs_buf		**bpp)
 {
 	int			error;
-	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
 
-	/* there are currently no valid flags for xfs_buf_get_uncached */
-	ASSERT(flags == 0);
-
-	*bpp = NULL;
-
-	error = _xfs_buf_alloc(target, &map, 1, flags, &bp);
-	if (error)
-		return error;
-
-	error = xfs_buf_alloc_backing_mem(bp, flags);
-	if (error)
-		goto fail_free_buf;
-
-	trace_xfs_buf_get_uncached(bp, _RET_IP_);
-	*bpp = bp;
-	return 0;
-
-fail_free_buf:
-	xfs_buf_free(bp);
+	error = xfs_buf_alloc(target, &map, 1, flags, bpp);
+	if (!error)
+		trace_xfs_buf_get_uncached(*bpp, _RET_IP_);
 	return error;
 }
 
-- 
2.45.2

