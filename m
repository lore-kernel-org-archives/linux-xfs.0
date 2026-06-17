Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E93926059D
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 05:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781675907; cv=none; b=tPwIKoUS42YAnIhTEflou3zSEFLRuX9bU3asFLiVjsS7FmZ0tBCrPt7C7KCLzu2DUGcszA2pA9a/vALsmx6tmmM5tCPxM+mFAuhwlBIJQ3BH0JXuIMkqRDK/cu0VrlrVgNZByrcdoSNiivAQmXDoF2K5kE+iR7B0rKKthPqEMzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781675907; c=relaxed/simple;
	bh=gdko3yvxTOPOqs4N/87uqmVL7pZgv3hWOrIi8cn4Qsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtuDIEQMYOWUPxqtY7uGUnrJBPS04C8DReFiZ994ggnDS34JEx6iOOnDQgKk1pnPWBd5u5O8NuKrDaty4fX0GZxafujuIlvsP18tCALq7AiIQht7KqrO3GkKrLWkgTCwFdVl1St+Myg1mfcRxUcz7hXXnN9neQ0eULH/TZFokfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r3j0q28x; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r3j0q28x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7DebocdFAnt8Jhsgmm/ISgTc4eZvRnZ32mQxSbWvyw4=; b=r3j0q28xHyF7uVUPctfmJ8e+kk
	SzN11eCbvBawLvkhfg3+wZbaLM4JJwDcwZw9iJBqvmTaUYFd8eJ5/dHGYunyefd1JK+ZD7R1Dgweq
	WCkvNLc9W7WFqCbEaMY4RJ9y5Vk5RB0FZGFk1/ZWLqbSJUMwCzt9URsd6DE2Msw5rUpdRWVVusOdM
	5/tQ3dkg80M7XWPvX5m3CUj52iR5LY10JaxhuZ6Vbyx5/Oqc/6pGG9ABgcETXF6MQX0YpFcVZCiWm
	nKjQcCbS4xSn9tOoR1cQp0Bwv3EV0rCTuhXwuKRIXPTMM9tz+8LXzjPItmyS2lhWfrpcdh9kSpzMT
	LFSYgCuA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZjI9-0000000GgAb-2lzv;
	Wed, 17 Jun 2026 05:58:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: fix incorrect use of gfp flags in xfs_buf_alloc_backing_mem
Date: Wed, 17 Jun 2026 07:58:04 +0200
Message-ID: <20260617055814.3842058-4-hch@lst.de>
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

xfs_buf_alloc_backing_mem currently has two issues with how the GFP_
flags are set:

  - when aiming for a large folio allocation, the gfp mask is adjusted
    to try less hard, but these flags then persist for the vmalloc
    allocation, which is bogus.
  - the __GFP_NOFAIL for small allocations is also applied when readahead
    force __GFP_NORETRY which doesn't make any sense.

Fix this by only applying __GFP_NOFAIL when __GFP_NORETRY is not set,
and by reordering the code so that the large folio gfp adjustments
are performed locally just for that allocation.

Fixes: 94c78cfa3bd1 ("xfs: convert buffer cache to use high order folios")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 49 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index dce398337ad0..eea2a8757fe1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -223,22 +223,6 @@ xfs_buf_alloc_backing_mem(
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
 
-	/*
-	 * For buffers smaller than PAGE_SIZE use a kmalloc allocation if that
-	 * is properly aligned.  The slab allocator now guarantees an aligned
-	 * allocation for all power of two sizes, which matches most of the
-	 * smaller than PAGE_SIZE buffers used by XFS.
-	 */
-	if (size < PAGE_SIZE && is_power_of_2(size))
-		return xfs_buf_alloc_kmem(bp, size, gfp_mask | __GFP_NOFAIL);
-
-	/*
-	 * Don't bother with the retry loop for single PAGE allocations: vmalloc
-	 * won't do any better.
-	 */
-	if (size <= PAGE_SIZE)
-		gfp_mask |= __GFP_NOFAIL;
-
 	/*
 	 * Optimistically attempt a single high order folio allocation for
 	 * larger than PAGE_SIZE buffers.
@@ -251,18 +235,31 @@ xfs_buf_alloc_backing_mem(
 	 * path for them instead of wasting memory here.
 	 */
 	if (size > PAGE_SIZE) {
-		if (!is_power_of_2(size))
-			return xfs_buf_alloc_vmalloc(bp, size, gfp_mask, flags);
-		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
-		gfp_mask |= __GFP_NORETRY;
-	}
-	if (xfs_buf_alloc_folio(bp, size, gfp_mask) < 0) {
-		if (size <= PAGE_SIZE)
-			return -ENOMEM;
-		trace_xfs_buf_backing_fallback(bp, _RET_IP_);
+		if (is_power_of_2(size)) {
+			gfp_t folio_gfp = gfp_mask;
+
+			folio_gfp &= ~__GFP_DIRECT_RECLAIM;
+			folio_gfp |= __GFP_NORETRY;
+			if (xfs_buf_alloc_folio(bp, size, folio_gfp) == 0)
+				return 0;
+			trace_xfs_buf_backing_fallback(bp, _RET_IP_);
+		}
 		return xfs_buf_alloc_vmalloc(bp, size, gfp_mask, flags);
 	}
-	return 0;
+
+	/*
+	 * The slab allocator now guarantees aligned allocations for all power
+	 * of two sizes.  This covers most smaller XFS buffers, so just use
+	 * kmalloc in this case.
+	 *
+	 * Don't bother with the vmalloc fallback for allocations of page size
+	 * or less: vmalloc won't do any better.
+	 */
+	if (!(gfp_mask & __GFP_NORETRY))
+		gfp_mask |= __GFP_NOFAIL;
+	if (size < PAGE_SIZE && is_power_of_2(size))
+		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
+	return xfs_buf_alloc_folio(bp, size, gfp_mask);
 }
 
 static int
-- 
2.53.0

