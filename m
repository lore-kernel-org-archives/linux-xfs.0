Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCDF26059D
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 05:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781675902; cv=none; b=ltZxWZze8WC+TX8BM4Kk76YQNcrrEB7N1S1N2yp5QH2tt+7RyrFT26/y+lDQasUFOJ92Mp+b5jmzAihqMc8EhXeTZj531gnDLhUpqTEdTDgics4K430L4vTnz7dAfamKjXo4b3dSJe8VsKSktfe3RGO7d9S1kaEO14RWtLYBexM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781675902; c=relaxed/simple;
	bh=XGJDQ+x7BfiMAc5JKLHbMKQCub/E8UgL/fL7uK5e8yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNGceFcQWlDcwNo332TkN17CwkXLQr+Jb0L3fZbcofDt4tduQHc3qSrCTWz34siV+ktpkoIEp8ZO7IwJirjgiUy64UpQf3r6OCA0MSawFwj6In4QUQyq6RYmwSJE6u1ZAGVdeL0nsBwk8q0OhGxhlCsAS64kD068lrGLgXwVdSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D9dV0YE/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D9dV0YE/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YT6b7JOBf/ln8XZ7+jPehsB3BxHWH+1egitKZ00r0sw=; b=D9dV0YE/b4cNAkVspj/2H5AtCF
	mzKAFvUojweeFSqReBKE54wiLm8CjAj03pv4LJf4GD+NXcVsH72b19kwikICk8Z6/HSNivYA6rdKZ
	zIU3ta/JyJzllNAhmWQUi7c6evqzu8ZkxMb3V+hsrnaT8rJuUju8/QbPaHpiw12UzpT5P0bTXPFNw
	2PH51B37QaToAg4b9NTQZ/lkCFyEo0dqXhMmuOaxKHEoJsYA+b9x5HWfPDg6r+Er1XgfTVCGdvP+Y
	HFurdmBs883Rlk9tmvYYuMNcvGGIwt1MFHLZZ9scqeBCXf0A4Gi+farxhi77xO9qyVI186DKBuDXb
	NUMyQ4AQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZjI4-0000000GgAG-0lJL;
	Wed, 17 Jun 2026 05:58:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: split up xfs_buf_alloc_backing_mem
Date: Wed, 17 Jun 2026 07:58:02 +0200
Message-ID: <20260617055814.3842058-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260617055814.3842058-1-hch@lst.de>
References: <20260617055814.3842058-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split out helpers for folio and vmalloc allocations to prepare for a bug
fix.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 61 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0cea458f1353..d3d44e3ff001 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -120,6 +120,22 @@ xfs_buf_free(
 	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
 }
 
+static int
+xfs_buf_alloc_folio(
+	struct xfs_buf		*bp,
+	size_t			size,
+	gfp_t			gfp_mask)
+{
+	struct folio		*folio;
+
+	folio = folio_alloc(gfp_mask, get_order(size));
+	if (!folio)
+		return -ENOMEM;
+	bp->b_addr = folio_address(folio);
+	trace_xfs_buf_backing_folio(bp, _RET_IP_);
+	return 0;
+}
+
 static int
 xfs_buf_alloc_kmem(
 	struct xfs_buf		*bp,
@@ -148,6 +164,27 @@ xfs_buf_alloc_kmem(
 	return 0;
 }
 
+static int
+xfs_buf_alloc_vmalloc(
+	struct xfs_buf		*bp,
+	size_t			size,
+	gfp_t			gfp_mask,
+	xfs_buf_flags_t		flags)
+{
+	for (;;) {
+		bp->b_addr = __vmalloc(size, gfp_mask);
+		if (bp->b_addr)
+			break;
+		if (flags & XBF_READ_AHEAD)
+			return -ENOMEM;
+		XFS_STATS_INC(bp->b_mount, xb_page_retries);
+		memalloc_retry_wait(gfp_mask);
+	}
+
+	trace_xfs_buf_backing_vmalloc(bp, _RET_IP_);
+	return 0;
+}
+
 /*
  * Allocate backing memory for a buffer.
  *
@@ -175,7 +212,6 @@ xfs_buf_alloc_backing_mem(
 {
 	size_t		size = BBTOB(bp->b_length);
 	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
-	struct folio	*folio;
 
 	if (xfs_buftarg_is_mem(bp->b_target))
 		return xmbuf_map_backing_mem(bp);
@@ -216,33 +252,16 @@ xfs_buf_alloc_backing_mem(
 	 */
 	if (size > PAGE_SIZE) {
 		if (!is_power_of_2(size))
-			goto fallback;
+			return xfs_buf_alloc_vmalloc(bp, size, gfp_mask, flags);
 		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
 		gfp_mask |= __GFP_NORETRY;
 	}
-	folio = folio_alloc(gfp_mask, get_order(size));
-	if (!folio) {
+	if (xfs_buf_alloc_folio(bp, size, gfp_mask) < 0) {
 		if (size <= PAGE_SIZE)
 			return -ENOMEM;
 		trace_xfs_buf_backing_fallback(bp, _RET_IP_);
-		goto fallback;
-	}
-	bp->b_addr = folio_address(folio);
-	trace_xfs_buf_backing_folio(bp, _RET_IP_);
-	return 0;
-
-fallback:
-	for (;;) {
-		bp->b_addr = __vmalloc(size, gfp_mask);
-		if (bp->b_addr)
-			break;
-		if (flags & XBF_READ_AHEAD)
-			return -ENOMEM;
-		XFS_STATS_INC(bp->b_mount, xb_page_retries);
-		memalloc_retry_wait(gfp_mask);
+		return xfs_buf_alloc_vmalloc(bp, size, gfp_mask, flags);
 	}
-
-	trace_xfs_buf_backing_vmalloc(bp, _RET_IP_);
 	return 0;
 }
 
-- 
2.53.0

