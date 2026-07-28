Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6CE224AF9
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226321; cv=none; b=DD9UkoTVPGtqgpjLYUh8+VpRl4YlOAmNuQTTJrDIR9rcWwGozaZOMTxcB4B7tPWwFu450kWopzGxNvZfXACUqPlN4mexwHy4FJb0RNhKma2qNw0YzDsIKkWNl9N95uJgSwVUx118v32nbhN7shkdnns6lG2C/BjAatmvoiSiRbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226321; c=relaxed/simple;
	bh=86HK95af5QjxVr/ZKah/9eGl7+jdg+0b/q2qT11cZPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyO7oja5FWsWYm5TXEpaaQ4jERNLGB6semBRwuwWoePURxILjqjujEs6BbTSRM9141Id03aXw3sobZ3fidNG3P6FrMKOpNqStNPgLRukZgzTplvaf0gCqu2pLrTDEZ4+x+GYNYCzXyqdTcnG1qchLBRPUzf33zF1Qt5mc7+GK3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HBBZpSZh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HBBZpSZh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wV20Xp3M8IVzmE5Y+GTTyHKOk60QvPEBDpEvs+KRLKs=; b=HBBZpSZhZBDiwutsGrtMLaEc21
	pZbQzAfsQ+pS//sxpe4wdZN1VXTs2LwH4wkOtipbvtejqeYHUyEaVa/GJqwp4mM2DCnie7A7RoUVT
	/jt6zUtGOIl7PuZ1L3CyvSSf9rCJkvBXuI5ccxmEH7xfgFwSE4V/E0ISrecpeh55LETZbaioL4mHL
	RdZSkFqMDLoGWBjcDoGXUZmsXJNdfqNevFZi4hFT85C67hCmL26meWGmh2LJJX96ZkaGDJPfp4O9u
	2ZkiqRIpr+wdiK63u1pw8reLtjLIGegpv59tpLpOSr0U0VgBXaJa6NPqP3pKPaYLSTWKKkGsD5NX0
	dxqgR1WQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocut-00000004gsp-1cTx;
	Tue, 28 Jul 2026 08:11:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/12] xfs: don't get a pag reference in xfs_buf_get_map
Date: Tue, 28 Jul 2026 10:11:09 +0200
Message-ID: <20260728081152.1778841-2-hch@lst.de>
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

As of commit 497560b9ef42 ("xfs: switch (back) to a per-buftarg buffer
hash"), buffer lookups don't require the perag structure.  Stop looking
it up in xfs_buf_get_map, and instead only find it when allocating a new
buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 51 ++++++++++++++----------------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 48d7dfd3e15f..16b9f3e50551 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -463,13 +463,15 @@ xfs_buf_lookup(
 }
 
 /*
- * Insert the new_bp into the hash table. This consumes the perag reference
- * taken for the lookup regardless of the result of the insert.
+ * Try to allocate and insert a new buffer for the range described by @map.
+ *
+ * If an existing buffer is found for this range, return the existing buffer
+ * instead.  The returned buffer is returned with a new referenced held by the
+ * caller.
  */
 static int
 xfs_buf_find_insert(
 	struct xfs_buftarg	*btp,
-	struct xfs_perag	*pag,
 	struct xfs_buf_map	*cmap,
 	struct xfs_buf_map	*map,
 	int			nmaps,
@@ -482,10 +484,13 @@ xfs_buf_find_insert(
 
 	error = xfs_buf_alloc(btp, map, nmaps, flags, &new_bp);
 	if (error)
-		goto out_drop_pag;
+		return error;
 
 	/* The new buffer keeps the perag reference until it is freed. */
-	new_bp->b_pag = pag;
+	if (!xfs_buftarg_is_mem(btp)) {
+		new_bp->b_pag = xfs_perag_get(btp->bt_mount,
+			xfs_daddr_to_agno(btp->bt_mount, cmap->bm_bn));
+	}
 
 retry:
 	rcu_read_lock();
@@ -520,25 +525,12 @@ xfs_buf_find_insert(
 	return 0;
 
 out_free_buf:
+	if (new_bp->b_pag)
+		xfs_perag_put(new_bp->b_pag);
 	xfs_buf_free(new_bp);
-out_drop_pag:
-	if (pag)
-		xfs_perag_put(pag);
 	return error;
 }
 
-static inline struct xfs_perag *
-xfs_buftarg_get_pag(
-	struct xfs_buftarg		*btp,
-	const struct xfs_buf_map	*map)
-{
-	struct xfs_mount		*mp = btp->bt_mount;
-
-	if (xfs_buftarg_is_mem(btp))
-		return NULL;
-	return xfs_perag_get(mp, xfs_daddr_to_agno(mp, map->bm_bn));
-}
-
 /*
  * Assembles a buffer covering the specified range. The code is optimised for
  * cache hits, as metadata intensive workloads will see 3 orders of magnitude
@@ -552,7 +544,6 @@ xfs_buf_get_map(
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
 {
-	struct xfs_perag	*pag;
 	struct xfs_buf		*bp = NULL;
 	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
 	int			error;
@@ -567,28 +558,21 @@ xfs_buf_get_map(
 	if (error)
 		return error;
 
-	pag = xfs_buftarg_get_pag(btp, &cmap);
-
 	error = xfs_buf_lookup(btp, &cmap, flags, &bp);
 	if (error && error != -ENOENT)
-		goto out_put_perag;
+		return error;
 
 	/* cache hits always outnumber misses by at least 10:1 */
 	if (unlikely(!bp)) {
 		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
 
 		if (flags & XBF_INCORE)
-			goto out_put_perag;
-
-		/* xfs_buf_find_insert() consumes the perag reference. */
-		error = xfs_buf_find_insert(btp, pag, &cmap, map, nmaps,
-				flags, &bp);
+			return -ENOENT;
+		error = xfs_buf_find_insert(btp, &cmap, map, nmaps, flags, &bp);
 		if (error)
 			return error;
 	} else {
 		XFS_STATS_INC(btp->bt_mount, xb_get_locked);
-		if (pag)
-			xfs_perag_put(pag);
 	}
 
 	/*
@@ -602,11 +586,6 @@ xfs_buf_get_map(
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
 	*bpp = bp;
 	return 0;
-
-out_put_perag:
-	if (pag)
-		xfs_perag_put(pag);
-	return error;
 }
 
 int
-- 
2.53.0

