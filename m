Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0053F256C8B
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 15:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675751; cv=none; b=T7IodgEmkBxUUTo6VD7NcJQAHt36P9ZvlUw+1YmWKYr9UNOlfk3Ar9OLY68eFHPk3V2hsvT6H/CJKhXEv4t8nrbbiA3pLBLPTIP6xAq8XLqXTOl9OUlMXBDB51ueqG/3rcgWHKdCvPlVxSLdf6aDRYPqUzX0Cq+nMbhqgfD4khk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675751; c=relaxed/simple;
	bh=TBIMPunCpFAZQHnZ2lcnYbqT1Yc2wPa4YW4tNzE3bSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0CKSG+8re6GVYWmlTZpxmWEfNZizL36OoBSwePpKggzUdSbuAoQWqAX8BtJDP8g+BF2c9VFKeyv3PBKto6xBq8PiG1zS5Oszx7B2wm7gIc8qTkA/xaUTZXXIINHVlsJAagrqy5EQfvv11sVPy7rrayNGkbXW+gw9EKxveXfL2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MRBnx/ax; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MRBnx/ax"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=i4iowfRgGeHvtWBH/WXRGQeRlrQoJNiCbokQBVDLVls=; b=MRBnx/axww5jRbxEmqfWbuEPXg
	TO9BKMGTKHGIo6tOF7UoSNpSBZTa1tgps9RGiaeZcCqxvSqDMVGTNBHJbrhtRgufyb75Ak/cVpH2D
	/WXCZ7HYqhz7wh0bMsSkp4HEhw//LkkDtoi6LmtAQ7ZETH2v8lSiJfjrGw1Zqj6EcsjQwU7NGAZcu
	9yJuF0ga9YKtxcDNXTqMzKslfJJxmU1z1h9cVzVIitjDY+zRqWoimd3LWb1vjXQ56NbGEGG0Jy6dg
	vlHqEv9Qb7ZfwULUaMlF83RpFwUFarXuPANW2CaZ4bO+pTg/SolS8ggRIUb+eK0VGYXGUrKxFLgFk
	tsJvcsqg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2A5N-00000004MLB-1bp6;
	Mon, 16 Mar 2026 15:42:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: don't decrement the buffer LRU count for in-use buffers
Date: Mon, 16 Mar 2026 16:41:35 +0100
Message-ID: <20260316154216.1598410-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316154216.1598410-1-hch@lst.de>
References: <20260316154216.1598410-1-hch@lst.de>
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
---
 fs/xfs/xfs_buf.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index c0a4d0a37f57..8ba9b74339a7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1523,6 +1523,18 @@ xfs_buftarg_isolate(
 	if (!spin_trylock(&bp->b_lockref.lock))
 		return LRU_SKIP;
 
+	/*
+	 * If the buffer is in use, remove it from the LRU for now.  We can't
+	 * free it while someone is using it, and we should also not count
+	 * eviction passed for it, just as if it hadn't been added to the LRU
+	 * yet.
+	 */
+	if (bp->b_lockref.count > 0) {
+		list_lru_isolate(lru, &bp->b_lru);
+		spin_unlock(&bp->b_lockref.lock);
+		return LRU_REMOVED;
+	}
+
 	/*
 	 * Decrement the b_lru_ref count unless the value is already
 	 * zero. If the value is already zero, we need to reclaim the
@@ -1533,16 +1545,6 @@ xfs_buftarg_isolate(
 		return LRU_ROTATE;
 	}
 	
-	/*
-	 * If the buffer is in use, remove it from the LRU for now as we can't
-	 * free it.  It will be freed when the last reference drops.
-	 */
-	if (bp->b_lockref.count > 0) {
-		list_lru_isolate(lru, &bp->b_lru);
-		spin_unlock(&bp->b_lockref.lock);
-		return LRU_REMOVED;
-	}
-
 	lockref_mark_dead(&bp->b_lockref);
 	list_lru_isolate_move(lru, item, dispose);
 	spin_unlock(&bp->b_lockref.lock);
-- 
2.47.3

