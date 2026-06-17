Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B42926059D
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 05:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781675904; cv=none; b=D2OAkitHnCW9s7ZBaAem+C+N+qIH80+HGpIbp5tbJ0kdpd75IDkVvk4gRI8CDhCceMT+pFTCYmbYeIRjNOGyM/u/kJ9Dbuv0TIjzzsfX0SMXD4XJqQhJCDL2tjV5UPpmPz39qpErWhrcQhrkfaAy1FShA1XE3xaEcnXHtvnHXk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781675904; c=relaxed/simple;
	bh=P24jfdKsEoCrJufzNfycpBPL7GRRV9N9pjB+EmhIE2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qv/k6KALHeD9lceSosOMRKlNYrdsLy+QvysnfIXhJDUaf/6/bUrj0PAyWQ47rt+AG+xHRWkWt8WxqT+3QPwtP0I56A5/6LZnS7f6ifnusmPr1QUOSs+hfEZXGXJ912RPQRNLS4FVv3ykc+CaNLuKpXDDZ0VzIykKFgUAYHrb58I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t+PXddM/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t+PXddM/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dcFDAcDjD8xI9C28cklulVkI7fv7hLl77lyLlcldxFo=; b=t+PXddM/NU/nTwBToz9roCCTv2
	wJdRlKVaYNAoEgHe1TX5G+McF9aWIjBCLl1beaccfsfuXKotyVuWI9HmhGXq7eeTmky+eCSWeSxOz
	S6aSolkt4IFm44wocJdVa0r8q33uVQ7ddX9IgvydcyAYKsM5IGvU/9Yv4z3S6Ceem7Ghhxr7gB0b+
	Q1sfhuZzoNPWPi8zNeuzrASr16lcs0F1LuLfNi9TjDrIojX6DhPBsd3tk3SXR7HzkEtdxNBFZJl1b
	Tg7UVlb2COqIT908Xqwk6tKJtCiChzieg1Ika0JL5hb2+CGaj72VxwfGptb4t6mU33AOV7mcqMRPQ
	PRDiMHww==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZjI6-0000000GgAR-3Sxy;
	Wed, 17 Jun 2026 05:58:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: lift setting __GFP_NOFAIL from xfs_buf_alloc_kmem to the caller
Date: Wed, 17 Jun 2026 07:58:03 +0200
Message-ID: <20260617055814.3842058-3-hch@lst.de>
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

The current __GFP_NOFAIL setting is wrong in some cases.  Prepare
for fixing that by giving control to the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d3d44e3ff001..dce398337ad0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -145,7 +145,7 @@ xfs_buf_alloc_kmem(
 	ASSERT(is_power_of_2(size));
 	ASSERT(size < PAGE_SIZE);
 
-	bp->b_addr = kmalloc(size, gfp_mask | __GFP_NOFAIL);
+	bp->b_addr = kmalloc(size, gfp_mask);
 	if (!bp->b_addr)
 		return -ENOMEM;
 
@@ -230,7 +230,7 @@ xfs_buf_alloc_backing_mem(
 	 * smaller than PAGE_SIZE buffers used by XFS.
 	 */
 	if (size < PAGE_SIZE && is_power_of_2(size))
-		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
+		return xfs_buf_alloc_kmem(bp, size, gfp_mask | __GFP_NOFAIL);
 
 	/*
 	 * Don't bother with the retry loop for single PAGE allocations: vmalloc
-- 
2.53.0

