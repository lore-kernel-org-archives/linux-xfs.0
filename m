Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6B53E48B
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 19:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705952375; cv=none; b=TOc77ltFhGkN1hDXpW+ErZNFv4P3RUGdcSMGShvI8QoV0CqaO0uM9On1GJbJvGx5Q3Ke6jrSjUFmYstWUB57VgGEuT3IPTkTfGVzCYhM7OrfinUzJSwXmPd79eM8H4Aysr/KXJNykxGPtPCrRs0FMZIdxIKiHB5jcsX1q+Ux8qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705952375; c=relaxed/simple;
	bh=8+XG+Qm/ulK1UypdEqYzXg4MswcXUB/mr/ItUoTQ+ck=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZMbGXeImzW9JukigVvEXhhiipiZmuI83qtuYmAgZwL1KC1n9ZvzRSFM9Q9NVZOG5ht1miNsxHIfoLImXvxTYKS3i/JhVJhCVEf2MF+1IZp9DcI3ibePYSS3vW2MKOddnfOVmgrHcCClslUySJCOKMSGSuyeNTkqO0wkxORj4UVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BI9GKL6G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BI9GKL6G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+NazrYzVm/Gab9LRMFeUugJHXipgTrgBMtzilwzmD+E=; b=BI9GKL6GFInpD4ejfGxUqJ4Yek
	eUUtGaqYi3/dXPlq+pXtdZYNln1l5yT6LDYRsKyVWCi2rA/of+9zEIlPtOP4ZKH6ffI2oLkMteHhA
	YX382+oFThO1owrJpGDeGaF8C/9AEowwO2iTgG5qO3QcMJjg1PZoTWKKyJmxJqbqAExtULRJ2G6Il
	Q3OgZZJKBNXYoWN9mwWaRswHhRt9RLZCM7lg1yuzscBad9gHwRjAfczN4bsAz465qFJvkgSeOsMjc
	s8Mjh8xXK3dG+5VFRQ4Pcf7uQNxOedZfdbZCtklgsEpKq+xFfGVSSYyUDXw1yoVX8lksb7BFA0RFh
	NCiGBoVg==;
Received: from [2001:4bb8:198:a22c:146a:86ef:5806:b115] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rS08q-00DkUd-1O;
	Mon, 22 Jan 2024 19:39:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: map buffers in xfs_buf_alloc_pages
Date: Mon, 22 Jan 2024 20:39:14 +0100
Message-Id: <20240122193916.1803448-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122193916.1803448-1-hch@lst.de>
References: <20240122193916.1803448-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

With the concept of unmapped buffer gone, there is no reason to not
vmap the buffer pages directly in xfs_buf_alloc_pages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 37 ++++++-------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 792759afdc73be..1bfd89dbb78d79 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -406,18 +406,7 @@ xfs_buf_alloc_pages(
 		XFS_STATS_INC(bp->b_mount, xb_page_retries);
 		memalloc_retry_wait(gfp_mask);
 	}
-	return 0;
-}
 
-/*
- *	Map buffer into kernel address-space if necessary.
- */
-STATIC int
-_xfs_buf_map_pages(
-	struct xfs_buf		*bp,
-	xfs_buf_flags_t		flags)
-{
-	ASSERT(bp->b_flags & _XBF_PAGES);
 	if (bp->b_page_count == 1) {
 		/* A single page buffer is always mappable */
 		bp->b_addr = page_address(bp->b_pages[0]);
@@ -443,8 +432,13 @@ _xfs_buf_map_pages(
 		} while (retried++ <= 1);
 		memalloc_nofs_restore(nofs_flag);
 
-		if (!bp->b_addr)
+		if (!bp->b_addr) {
+			xfs_warn_ratelimited(bp->b_target->bt_mount,
+				"%s: failed to map %u pages", __func__,
+				bp->b_page_count);
+			xfs_buf_free_pages(bp);
 			return -ENOMEM;
+		}
 	}
 
 	return 0;
@@ -718,18 +712,6 @@ xfs_buf_get_map(
 		xfs_perag_put(pag);
 	}
 
-	/* We do not hold a perag reference anymore. */
-	if (!bp->b_addr) {
-		error = _xfs_buf_map_pages(bp, flags);
-		if (unlikely(error)) {
-			xfs_warn_ratelimited(btp->bt_mount,
-				"%s: failed to map %u pages", __func__,
-				bp->b_page_count);
-			xfs_buf_relse(bp);
-			return error;
-		}
-	}
-
 	/*
 	 * Clear b_error if this is a lookup from a caller that doesn't expect
 	 * valid data to be found in the buffer.
@@ -959,13 +941,6 @@ xfs_buf_get_uncached(
 	if (error)
 		goto fail_free_buf;
 
-	error = _xfs_buf_map_pages(bp, 0);
-	if (unlikely(error)) {
-		xfs_warn(target->bt_mount,
-			"%s: failed to map pages", __func__);
-		goto fail_free_buf;
-	}
-
 	trace_xfs_buf_get_uncached(bp, _RET_IP_);
 	*bpp = bp;
 	return 0;
-- 
2.39.2

