Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA5D19CC3E
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585170; cv=none; b=RouvN4NzMuqDIRnCXgfPW2KbW/jW+zbXFmKYXcCFDsgL+PC41QvqNS8GW/y4CrDprenBeTxkKywDOF0GoIi1bXwsLLvXoYz10jt7C4cVrqRAkvIvuLosh8y7+CI9VlIYzNmYNeJDWUKE/Qv9twZp9ctjVQ5UL/1xfUUWjOdTCqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585170; c=relaxed/simple;
	bh=qmlSti8jQ4I9wUnAdAkS9Bs3UIxeuf71E/ZhVTWa7vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAhZ25bTKVj5/D4t1ZIc3mTVkcQwPV+ceDQ9Icd7rE1l9MlMJcltlNjQmapLTRbnHSyjLRiuOHATd5PX1wEOswNonsyTXuzQmS6VsMypAH8Ss6OEXL061exX3h8GmVM0cTxfn5YM+8XxFEKVFAB4ZTrx4xPAqupQ6wE0kXj0CNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=289w8kun; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="289w8kun"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=M3HslwyJKh6uiMQxO9HaUc+SFd/ozF1C/yXZBP12VCs=; b=289w8kun3x+qL2F7LxUNHCj1fr
	sQwLUO28b8gAoX7VlBbbHGstNmCdbe4S7h4NHnnlvwWUa/kuTZZo/Sfr7M8UlcRE2mOjevjZuneMU
	UUcegxQ7AYBl69yEkCkhw7idBb7lTcxsRHYy9WBrabXs/hbImgZH9+d1FRYrsg4p3mNmVAmc0ykmR
	ic6gEg4DEjI5+xFb6jnxR+DGMxaGvlSlc2+8xZb9BogBujWAauNX5nFcQZQglCVU5bsItHF3+7lOb
	sRQ9QOOCpRdgK86X2M8rWkQhExw1QeRGBQD7TC+NkAzWPMofXVEP9uKS8anPI81L0kL5QIILuHg6z
	/nD4OMNA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnJiI-00000004PLo-1ZS2;
	Wed, 26 Feb 2025 15:52:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/12] xfs: remove xfs_buf_is_vmapped
Date: Wed, 26 Feb 2025 07:51:32 -0800
Message-ID: <20250226155245.513494-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226155245.513494-1-hch@lst.de>
References: <20250226155245.513494-1-hch@lst.de>
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
---
 fs/xfs/xfs_buf.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ee678e13d9bd..af1389ebdd69 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -60,20 +60,6 @@ static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
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
@@ -270,7 +256,7 @@ xfs_buf_free_pages(
 
 	ASSERT(bp->b_flags & _XBF_PAGES);
 
-	if (xfs_buf_is_vmapped(bp))
+	if (is_vmalloc_addr(bp->b_addr))
 		vm_unmap_ram(bp->b_addr, bp->b_page_count);
 
 	for (i = 0; i < bp->b_page_count; i++) {
@@ -1361,7 +1347,7 @@ xfs_buf_ioend(
 	trace_xfs_buf_iodone(bp, _RET_IP_);
 
 	if (bp->b_flags & XBF_READ) {
-		if (!bp->b_error && xfs_buf_is_vmapped(bp))
+		if (!bp->b_error && bp->b_addr && is_vmalloc_addr(bp->b_addr))
 			invalidate_kernel_vmap_range(bp->b_addr,
 					xfs_buf_vmap_len(bp));
 		if (!bp->b_error && bp->b_ops)
@@ -1533,7 +1519,7 @@ xfs_buf_submit_bio(
 			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
 		bio->bi_iter.bi_size = size; /* limit to the actual size used */
 
-		if (xfs_buf_is_vmapped(bp))
+		if (bp->b_addr && is_vmalloc_addr(bp->b_addr))
 			flush_kernel_vmap_range(bp->b_addr,
 					xfs_buf_vmap_len(bp));
 	}
-- 
2.45.2

