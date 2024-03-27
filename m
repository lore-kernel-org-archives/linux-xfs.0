Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF542C6AF
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537424; cv=none; b=dUkWScvr42LqAkXfxGJ7RYFOuibLLw4Lr6FoVUjTQ7v6jfAnE6GZP1tzkmYeDAblWr+9mRmeh8VuM4Nxm85w/Vkmh4GJS4s1V1Bz7WNPTDNhA7B+YhzdIQN7FJTIwp1Ho1Onp7MM9sr1saARHNyB8ip0GHLKlZLN/fu+JqxCD2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537424; c=relaxed/simple;
	bh=QBOx3ExU3gPs+eq1P1aTPwZttXWakdonS5D+7TgUlzQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tNBG0mIdtMk5X24s7oPoF7H9iBS9Id4QkmK6APQu9cj/P1QN8xHIYvLKIVn2iiYh6TkpeYja74P7h86u9+zL5qWE/ihsuTtFkSsSlFRReGc8b1c1GlO2Kzoyv0T3gdpGibWUiPlv23NseACDB39AdTyBF5mzW/CcKIenHu4BuGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LBQkrIjN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LBQkrIjN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FUJZm+JSSMvrwUv33E7vtML6sEPMuvi0cRvfIcW++qk=; b=LBQkrIjNsxxwrlHKlf0aUZa2ch
	J+jWs+eD0Y1Ta5nFx80no3fjPOuRdT3DU3tiMvJSU1kRrXUTu0c3uqwIr4ZlFIyqWVcVynaD2n9aW
	srAcy9MpIrJEnNcOGzZdrrm81wtGvWPFeI2XBm9K06Lz6Q840NHnbKCxnuD1NF2hA2p5fmaQkUnZG
	WxiMByggpF6XhPIgw1DLw0HtNDu1YeJNT5Oiv/LvRmIhYOYw+2CyqId7tbvYHgFRDJ9jlGPsndw3d
	NRMVwxl3JlCQwkIngK6WwSy0HLACc0ZEEh6qLNdwO8QgXo2Z3jU4VP+Goh6z4UYwVnBcgmUsV4Tr3
	JXF05sEA==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR4G-00000008WcF-1U2Y;
	Wed, 27 Mar 2024 11:03:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/13] xfs: block deltas in xfs_trans_unreserve_and_mod_sb must be positive
Date: Wed, 27 Mar 2024 12:03:10 +0100
Message-Id: <20240327110318.2776850-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240327110318.2776850-1-hch@lst.de>
References: <20240327110318.2776850-1-hch@lst.de>
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

