Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE5B1F7092
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 06:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104210; cv=none; b=CP/b6B0nUKs+gIEi4brT/bkLwapmRhv8krbIE1brGr1yTImk0VhvMmL6UsLYgJMGeZ2PtwtUcIeaFcqMj8haPb9NW8+y6w6xRg+GY46InFLyEqVHYofaS9ls4UXj6MRJWLTnKnjK/dKpi3Bj3rIsnkcoa7Rwy+ZqKk/zUie3GJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104210; c=relaxed/simple;
	bh=STlDArKyLOsw03Uvp+GpqmhF5MzpZgrzX2ZcA7HbBZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVm3pp0AGnAwGn99RwSAgXN3dYJ8T82dYkrBVlPfiYHghoOrjX2JrQpVX1VAjjj1PUWEq55VWVeJKzarqy8bIeKIDc5aDAq/kE39fNEagGlq2EpjJSLccNOVC9V15DlZddfZVjeUxMTOBk1gSx9Zh4T5HNC8/WUB+G/hvZ38AMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IHHwcsh1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IHHwcsh1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cLnCZW+nUTBFBXGaRpDeXS6Ts8Qk8QCW+GbvyefWcr0=; b=IHHwcsh10iqfqHhUVcolw4kiQ6
	wOCwbzoF2stRd+uFUBpFhryEanFctciRMxrKLJNFc3gKgcWEuBDdIbkiseSq/IQgqhJvGtC4+Yz0Z
	c8mI4JAS/U0hz4KmfhJL+C3bJGDJAbwjflJZ4oTmNPhephOXBOmGtTkWquIuVJtnRtRiPCnvD90lS
	2neGVVd8EfNSiMr70+pSCsDz8gmtUiUJ3voup2mMBEu5clYdJ5S1vkfMcWK4O/lqyfnkh7wE78gs4
	mB5bN3KcJk/HdLyRAf6rp3c6x+eT0Gu3VvXPQae51QhV/csPI/auLVqbSmgrsoODv1PR0oqA1wHNh
	IO8y22vw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uN3uC-0000000Eq4l-1wuJ;
	Thu, 05 Jun 2025 06:16:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 2/4] xfs: remove NULL pointer checks in xfs_mru_cache_insert
Date: Thu,  5 Jun 2025 08:16:28 +0200
Message-ID: <20250605061638.993152-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250605061638.993152-1-hch@lst.de>
References: <20250605061638.993152-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Remove the check for a NULL mru or mru->list in xfs_mru_cache_insert
as this API misused lead to a direct NULL pointer dereference on first
use and is not user triggerable.  As a smatch run by Dan points out
with the recent cleanup it would otherwise try to free the object we
just determined to be NULL for this impossible to reach case.

Fixes: 70b95cb86513 ("xfs: free the item in xfs_mru_cache_insert on failure")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mru_cache.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 08443ceec329..c95401de8397 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -425,10 +425,6 @@ xfs_mru_cache_insert(
 {
 	int			error = -EINVAL;
 
-	ASSERT(mru && mru->lists);
-	if (!mru || !mru->lists)
-		goto out_free;
-
 	error = -ENOMEM;
 	if (radix_tree_preload(GFP_KERNEL))
 		goto out_free;
-- 
2.47.2

