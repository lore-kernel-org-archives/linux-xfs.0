Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452C13644BE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 07:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774252287; cv=none; b=lJd+Uzpqq7uTPD0bMD/trib+kmVJopQNiN67J5w2U/EesWi75s5QnAORufsxfkXNroxYuBIITNBCAeOfaW9YyxDltOPcF3nJXzDVp4Ffh4/K5lPNB+j0cgRlE5q4gJHPflZpeCT68I2o3OfNJMgDxn6DqRTFUrXue/JdmlTOUds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774252287; c=relaxed/simple;
	bh=aIyIG2p3hRFQw0T0wnNb70winzUGfPS8yFFsjBmN+6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NReGycpQAFbtVMZXtY8amDH005o4dEN2jNc6mR0jhBKkiFNbzkuZaP+YrmxGXppNdxvNpSnYTf7NopRY5FP1ZlxOL4Xbt31PoeRnFkQcwEu+brW7mxC7fcc8WbcnxQg6KtVYt21klhlCUXnp1smrL1i0TgoiLgnnf+V7+Ph/+uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pfnY0HRC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pfnY0HRC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h9R40repwovLMwPygpqo1ZgDc4AgWUS+aU8+TQQgYb0=; b=pfnY0HRCxH5OfMEWt34ml1lO56
	dx+QebT7eaPga57srtWAXbfRsP00crRZN4F/QJiFndUZCrFDADw615zue/he9JqkKVBkAVL1YnJkM
	fWOrME/oNHuB7nhSAjVmWHrHcoFDcxKlfcdaLyNg4tXFAsoJ93pZIlU+bnvNURwYjEqE+vyEAq8Bi
	hOTW3r28Pi1WSWPDqBgo+t+ZsCpXXWAAkO0W1BJ+eQtWfrTvAELlLMDW09mmh8VFwjnl0A6t3rF7M
	U4ntRNC4ES9WyGeABOpMfgXyenRubvzaXAZYIRdM4J96hZymIpc65RAwsLQnqTvDieJ/WcLquuj+/
	Sb1UIUag==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4a4L-0000000GEkG-0kcv;
	Mon, 23 Mar 2026 07:51:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 4/4] xfs: don't decrement the buffer LRU count for in-use buffers
Date: Mon, 23 Mar 2026 08:50:54 +0100
Message-ID: <20260323075102.2952705-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323075102.2952705-1-hch@lst.de>
References: <20260323075102.2952705-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

XFS buffers are added to the LRU when they are unused, but are only
removed from the LRU lazily when the LRU list scan finds a used buffer.
So far this only happen when the LRU counter hits 0, which is suboptimal
as buffers that were added to the LRU, but are in use again still consume
LRU scanning resources and are aged while actually in use.

Fix this by checking for in-use buffers and removing the from the LRU
before decrementing the LRU counter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e4b65d0c9ef0..ee8c3944015a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1524,23 +1524,25 @@ xfs_buftarg_isolate(
 		return LRU_SKIP;
 
 	/*
-	 * Decrement the b_lru_ref count unless the value is already
-	 * zero. If the value is already zero, we need to reclaim the
-	 * buffer, otherwise it gets another trip through the LRU.
+	 * If the buffer is in use, remove it from the LRU for now.  We can't
+	 * free it while someone is using it, and we should also not count
+	 * eviction passed for it, just as if it hadn't been added to the LRU
+	 * yet.
 	 */
-	if (atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
+	if (bp->b_lockref.count > 0) {
+		list_lru_isolate(lru, &bp->b_lru);
 		spin_unlock(&bp->b_lockref.lock);
-		return LRU_ROTATE;
+		return LRU_REMOVED;
 	}
 
 	/*
-	 * If the buffer is in use, remove it from the LRU for now as we can't
-	 * free it.  It will be freed when the last reference drops.
+	 * Decrement the b_lru_ref count unless the value is already
+	 * zero. If the value is already zero, we need to reclaim the
+	 * buffer, otherwise it gets another trip through the LRU.
 	 */
-	if (bp->b_lockref.count > 0) {
-		list_lru_isolate(lru, &bp->b_lru);
+	if (atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
 		spin_unlock(&bp->b_lockref.lock);
-		return LRU_REMOVED;
+		return LRU_ROTATE;
 	}
 
 	lockref_mark_dead(&bp->b_lockref);
-- 
2.47.3

