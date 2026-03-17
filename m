Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8402C0F78
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 13:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773754895; cv=none; b=i5ewe+9uH5xrivkrNvql7KSLlLxJ4AoA0m4EofC7SJoina0L1TVCecyQujuBXelmuCPnJSTUTvvVrQs3cWBA8t+OJWNaU4lGDv9RMWaMMalLq44/+3lpalSijcIHdlgCgSUAxbA42b54a5wWL1zClRnVwQ/RxrJOzIINduaP8EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773754895; c=relaxed/simple;
	bh=uRRAVvHCyineMqAz2z6r2mCBKgnBlnhrcS+wWqNW7HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAVUt03rYWRwKz57MnziCP/Mm5g8s8rsmZxRMa1V8my5AVq6eYRMH3N5tfyZslj3jvMAhKag3hC+jkltvuk950nmhRZZVzYTKc5I4SIL1XoprWeBkMpiZmJyKn59bNGXSp5QgWrn8FE62Ob1jGFn8Vo1Y4KScIpTVsrhyrpWsNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=26PaCywi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="26PaCywi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/j/jMdCgErZw2oO8u46//25xWQCk+mcZ3T8nGdJxrpY=; b=26PaCywiYf3KR9J3YjwVlCjdNZ
	qW5XNw/xx+k3KPA/a0R1wbX49clEVQQvimKVBySvWsuBAn3AsMKZkVDsAn1y40ZnJVBnN+CdPIhg9
	wZ5rNSRSbu2qmTd+IGCn4YMqFSpgPLg+bqiq4ZF0kLTegktzkB5VX2oQi/Xf6lHW8T/jUEOXhWN9n
	LiWY+9EasOYnnUlHFpz+optUcAeYzg62+bXy6DmJzsro81Vy3HIeuOyUDxiuQePnM/3Umwc8ApSFF
	2WCPRPJt0MNVMt4rUrzISE5KL1ApVGpXiVRk1kSmOwwYyN6USL8hBzgwTbEcjU0NvD0Qnf4h54WED
	BTzqcOjA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2Uft-00000006T2k-2Yrj;
	Tue, 17 Mar 2026 13:41:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 4/4] xfs: don't decrement the buffer LRU count for in-use buffers
Date: Tue, 17 Mar 2026 14:40:55 +0100
Message-ID: <20260317134110.1691097-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260317134110.1691097-1-hch@lst.de>
References: <20260317134110.1691097-1-hch@lst.de>
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

