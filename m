Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60790156649
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 02:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711333470; cv=none; b=WBwkkpM68HZ/vBUb/V7c8FnDyP09Bg0bGV1TxiSE7La5o6LmzsQjP5UtUejoBvt7/jrRR2zefp5gyyjjMfSzkt4Xq+iPLiMb7s+6114KjszkxGm61c4FZhGfZDEbRIEHjp3FtTtgC9vjWAA5WaCHKdzYs+aSkkSShdDGCQPU8Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711333470; c=relaxed/simple;
	bh=QBOx3ExU3gPs+eq1P1aTPwZttXWakdonS5D+7TgUlzQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KaPYjbxZsu7RDVX77upW00jbRD4/G5+HMOaRayPOqu14me+6GHVo4qFq4jkm3qjlo/z2KyQ9/8cBGBkIKAoeVytDjH8Lu9na2rCj1qLcj2WJDd7mQMnZv/jsYuG00CVnOs8V6LVtUYBzN0JmK1/sQy7aawhSNEfYYHi0a+Y9Q0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EkK23LMj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EkK23LMj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FUJZm+JSSMvrwUv33E7vtML6sEPMuvi0cRvfIcW++qk=; b=EkK23LMjYFO8qFIIJ55wHL55na
	031gBXLTOv7Own5noXPy6cOIQl7AlZphjNMQqu5XP5UE2hVYxXGifISEbzcRdjRnnfo03XyxapgwN
	sYhEb6UUHKt8xO+qQKuSE9sJPOwQQgpwya3XgIyM6dMdhjQUi6aA8z/WksxxgHMfDgJztvOvXfvz8
	UoXWMeU7WPSH2Ev0PBYO4Q5irA5kGL4LgljGUEWV333BzhVIgQ4rwVqSOC66lQPK+RDYgdGDumWHr
	mFIeWPMr2VWilMMRyIQnHjevy1TiGfHwGhlLdwn6zobqUWAvJ/XoqObLZjZ2kcyNnPn8vJCg+IYda
	zzGiX0sA==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roa0h-0000000EeQz-26h7;
	Mon, 25 Mar 2024 02:24:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/11] xfs: block deltas in xfs_trans_unreserve_and_mod_sb must be positive
Date: Mon, 25 Mar 2024 10:24:03 +0800
Message-Id: <20240325022411.2045794-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240325022411.2045794-1-hch@lst.de>
References: <20240325022411.2045794-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

And to make that more clear, rearrange the code a bit and add asserts
and a comment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7350640059cc60..924b460229e951 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -594,28 +594,38 @@ xfs_trans_unreserve_and_mod_sb(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
-	int64_t			blkdelta = 0;
-	int64_t			rtxdelta = 0;
+	int64_t			blkdelta = tp->t_blk_res;
+	int64_t			rtxdelta = tp->t_rtx_res;
 	int64_t			idelta = 0;
 	int64_t			ifreedelta = 0;
 	int			error;
 
-	/* calculate deltas */
-	if (tp->t_blk_res > 0)
-		blkdelta = tp->t_blk_res;
-	if ((tp->t_fdblocks_delta != 0) &&
-	    (xfs_has_lazysbcount(mp) ||
-	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
+	/*
+	 * Calculate the deltas.
+	 *
+	 * t_fdblocks_delta and t_frextents_delta can be positive or negative:
+	 *
+	 *  - positive values indicate blocks freed in the transaction.
+	 *  - negative values indicate blocks allocated in the transaction
+	 *
+	 * Negative values can only happen if the transaction has a block
+	 * reservation that covers the allocated block.  The end result is
+	 * that the calculated delta values must always be positive and we
+	 * can only put back previous allocated or reserved blocks here.
+	 */
+	ASSERT(tp->t_blk_res || tp->t_fdblocks_delta >= 0);
+	if (xfs_has_lazysbcount(mp) || (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
 	        blkdelta += tp->t_fdblocks_delta;
+		ASSERT(blkdelta >= 0);
+	}
 
-	if (tp->t_rtx_res > 0)
-		rtxdelta = tp->t_rtx_res;
-	if ((tp->t_frextents_delta != 0) &&
-	    (tp->t_flags & XFS_TRANS_SB_DIRTY))
+	ASSERT(tp->t_rtx_res || tp->t_frextents_delta >= 0);
+	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
 		rtxdelta += tp->t_frextents_delta;
+		ASSERT(rtxdelta >= 0);
+	}
 
-	if (xfs_has_lazysbcount(mp) ||
-	     (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
+	if (xfs_has_lazysbcount(mp) || (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
 		idelta = tp->t_icount_delta;
 		ifreedelta = tp->t_ifree_delta;
 	}
-- 
2.39.2

