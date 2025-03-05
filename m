Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF6D24C08F
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183536; cv=none; b=pyH95lanYFk/PDRP9475suZLmt+TKf02nzztdY2sQHJ9g1cIx/2qwvRTRbZniN0O8ixHAqPMWvqgrXpXxsTrHjYQiZ/9UlCpQe+A3YYdY8oI3VPCYF5dqJ95kNunHQBwYcTPttf7Q13hfFarKyiJjPWxHj0vBOxjv3GchT1zT5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183536; c=relaxed/simple;
	bh=EhKdZkiZBhvmgjWPfYNIG3/6hrHFRCMplS7UMEr9W9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCwsobv9nELU6Ko2qzOxe4QSLvD+3AVGyunJ4T+aT9LtIaFXkfZFLeIiF1VM1/Pvg91GyQfHg3WbtNGQeKQ+v7mhFNLC3syr5jOhV1CDMYxM0zir5OoQwx2aK/jbhKVNtdNZNuVVT3Qno0AjkUlW4jXAMp7Q3070mtGmKkAjt54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H0hKMWNS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H0hKMWNS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1NVTQ4GSzcrSGq61Q5vCNNQwvc2/fH/5VpRVM+qK8ko=; b=H0hKMWNS4M4B/2Ps/wQKB7GyQu
	NyLES0+U4t0Kqk9UTnquUoTGYY9E0QWvEXLHYLjwHpJyWsE0A5NAvdR/Xq9yXcMTlItczlvzox/6O
	/4AsbOh4sjsVfUGiiX3FOMRUntvaIXxaq7UHKF7DKxRfq5X8gWcRDfn6ouBYq6e4b7/qPCykTV75s
	Vwm8smyRfXhGsuIqoY31eXm8hZ/z9iNKDjFkOOlAES3nuXe7J0ma3TnzFm2eMUqTf2/U3WpepvfxW
	uEFzEc7XzBiI8H+eN7LSelFBraduaJNryeGX81FkwitlQlIkixakmBjqF7YkjyxRlE1ez92m0nSve
	xwK9yjJw==;
Received: from [199.117.230.82] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tppNO-00000008Hot-1RU2;
	Wed, 05 Mar 2025 14:05:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/12] xfs: remove xfs_buf_is_vmapped
Date: Wed,  5 Mar 2025 07:05:21 -0700
Message-ID: <20250305140532.158563-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250305140532.158563-1-hch@lst.de>
References: <20250305140532.158563-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

No need to look at the page count if we can simply call is_vmalloc_addr
on bp->b_addr.  This prepares for eventualy removing the b_page_count
field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 972ea34ecfd4..58eaf5a13c12 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -55,20 +55,6 @@ static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
 	return bp->b_rhash_key == XFS_BUF_DADDR_NULL;
 }
 
-static inline int
-xfs_buf_is_vmapped(
-	struct xfs_buf	*bp)
-{
-	/*
-	 * Return true if the buffer is vmapped.
-	 *
-	 * b_addr is null if the buffer is not mapped, but the code is clever
-	 * enough to know it doesn't have to map a single page, so the check has
-	 * to be both for b_addr and bp->b_page_count > 1.
-	 */
-	return bp->b_addr && bp->b_page_count > 1;
-}
-
 static inline int
 xfs_buf_vmap_len(
 	struct xfs_buf	*bp)
@@ -212,7 +198,7 @@ xfs_buf_free_pages(
 
 	ASSERT(bp->b_flags & _XBF_PAGES);
 
-	if (xfs_buf_is_vmapped(bp))
+	if (is_vmalloc_addr(bp->b_addr))
 		vm_unmap_ram(bp->b_addr, bp->b_page_count);
 
 	for (i = 0; i < bp->b_page_count; i++) {
@@ -1298,7 +1284,7 @@ __xfs_buf_ioend(
 	trace_xfs_buf_iodone(bp, _RET_IP_);
 
 	if (bp->b_flags & XBF_READ) {
-		if (!bp->b_error && xfs_buf_is_vmapped(bp))
+		if (!bp->b_error && bp->b_addr && is_vmalloc_addr(bp->b_addr))
 			invalidate_kernel_vmap_range(bp->b_addr,
 					xfs_buf_vmap_len(bp));
 		if (!bp->b_error && bp->b_ops)
@@ -1479,7 +1465,7 @@ xfs_buf_submit_bio(
 			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
 		bio->bi_iter.bi_size = size; /* limit to the actual size used */
 
-		if (xfs_buf_is_vmapped(bp))
+		if (bp->b_addr && is_vmalloc_addr(bp->b_addr))
 			flush_kernel_vmap_range(bp->b_addr,
 					xfs_buf_vmap_len(bp));
 	}
-- 
2.45.2

