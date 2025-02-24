Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4360120B814
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 23:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740440947; cv=none; b=O5OisajZZFhIZsL6FHgszn1Yl6K5weJSWJj+9sLEVxMAGchxEnTT6+nOhJnWqza/aFdXLM9myF2/aBi+rZkf5sCbyMU2khXwn/neh6TaxVoazVczcZCFAuJaL5L7gz+ExjhyKVX9T3MqFR6R5H9lZCjGNoMPRbxAAQkOSHZtruE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740440947; c=relaxed/simple;
	bh=7wX9aQY6gxkyseFgly7+2cMmnhqGkBpG6JmuWWXC4sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuLYErzKe9FqekBCwzU7XirmTe3swczo81w1UpAVDZL8dcNWkESFQ89Pyr6cB9mkrQ6L2jSK0u83EhaakpG32ZrbyLUfVJYfbv7DXTRUDTqcGKMky6AEC5cfQBCMSbGyHta4JYbRQyQlH/FDkCSjvVB99bA6fQLuBnpKIWrf5To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OUDMD00d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OUDMD00d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=52UzXpF/7S62OjFUHqgLhPVXCuXLYXFbjgvfKnz3k9M=; b=OUDMD00d3Nu1DEIylE3WkxIAqx
	RrfJDIUhn0VAi2jUA7PHOMxNKOd53R3grJf7O2+HiQeqe1j+vekr4N6ZAKdjJPJ28Yue8E/YAn+47
	brzV0ckPa6Y10oO4dAo15saEoWvGbY/c4lJ31BZK2/I7k6b9fqq0iDtDneQ31YsXIWg0HmHuyhuJL
	GY8IqSVtoZHlJmey9aFuE4aUYvqhcdVizRO6vfi6t8KaPzHfmzo1s7zhGaMHTSiZPxflL6nVnXj4h
	rrLehuIJCbU/xYFpdtguaXNl2YrxTKHGj9Tcql827/kp0ZtqiKIXpaHq9QrC1vcqkJS5C+dNBLlNq
	sSpFC9Rw==;
Received: from [208.223.66.147] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tmiC9-0000000FXJr-3d3T;
	Mon, 24 Feb 2025 23:49:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 4/4] xfs: remove the XBF_STALE check from xfs_buf_rele_cached
Date: Mon, 24 Feb 2025 15:48:55 -0800
Message-ID: <20250224234903.402657-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250224234903.402657-1-hch@lst.de>
References: <20250224234903.402657-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buf_stale already set b_lru_ref to 0, and thus prevents the buffer
from moving to the LRU.  Remove the duplicate check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e161f3ab4108..5d560e9073f4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -99,12 +99,6 @@ xfs_buf_stale(
 	 */
 	bp->b_flags &= ~_XBF_DELWRI_Q;
 
-	/*
-	 * Once the buffer is marked stale and unlocked, a subsequent lookup
-	 * could reset b_flags. There is no guarantee that the buffer is
-	 * unaccounted (released to LRU) before that occurs. Drop in-flight
-	 * status now to preserve accounting consistency.
-	 */
 	spin_lock(&bp->b_lock);
 	atomic_set(&bp->b_lru_ref, 0);
 	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
@@ -1033,7 +1027,7 @@ xfs_buf_rele_cached(
 	}
 
 	/* we are asked to drop the last reference */
-	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
+	if (atomic_read(&bp->b_lru_ref)) {
 		/*
 		 * If the buffer is added to the LRU, keep the reference to the
 		 * buffer for the LRU and clear the (now stale) dispose list
-- 
2.45.2

