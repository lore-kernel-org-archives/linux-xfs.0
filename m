Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC891134AD
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 07:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708672552; cv=none; b=KXYg9ozpLP6zXYLEaLioCDfh7rX5bVY04APzJ48fSFSd/MHEybwfTjaiAcuOv5wSVmDd1MPrPdfnSbc+eJpR741ikslLciV/h/L8ge7gJEj+6FsvLpZ83DLiGHrl1PVipjhNyR5At9xgNnxYFrdvo6/+FQygeoANW50naG/qZuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708672552; c=relaxed/simple;
	bh=h0rUA+UuRhC16dWBiobP9WTkHf2W6V7zH83II9PEClc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I3Om7cO5VuYBH9eUgAzVN+/ygyWy7X+T1qpQNrWIqDjbHAR/uHbmoYhVY3/oHwXD3b8+cs1remlE3HoGic87xNehwgw8dOQ+yAPgtXEaUzcTs5Z9yqrfYyw+HBuzfI0IZ2lT9intv5Fv+1icyAcI/+mZlGpkRCx2ztHCh950QGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ROBSEpEC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ROBSEpEC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bp+OmkUyKUx2VY/6iA9Eyit17Ke3/rDbWExyVg2AwpY=; b=ROBSEpECg7khdTUC3qqPSHdPa1
	gmDagILsUgzVymeHE4m7XZy/1BkBVDyYLTLSSJQMBD+hEbqcPO+dE1LVnyq1DonXEeMgP36lElZWC
	ecgqA/veOdwxGlOBY2v0UoqKlt+4EN5s1JHrZ7IPTmczebgQJS0iFChFzsHhxp8QxIhIjVIGVBOiV
	CuVvV+WA/KpOaLhfIouQPDFLlcYkcsqmOlxo89pXWv1aBGjll2w0NQxqzbFeOsCAWdgaAyYdjTnOK
	+GBTqiD66WOupAJ4isg3cdg5HiVr7AqXpthzak8ZMuLS0Q3woMJ1z8h91uTbG2Dh1k0kLdoYjZbbu
	wXrsZIZQ==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdPmf-00000008GtC-437v;
	Fri, 23 Feb 2024 07:15:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/10] xfs: block deltas in xfs_trans_unreserve_and_mod_sb must be positive
Date: Fri, 23 Feb 2024 08:14:59 +0100
Message-Id: <20240223071506.3968029-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240223071506.3968029-1-hch@lst.de>
References: <20240223071506.3968029-1-hch@lst.de>
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
---
 fs/xfs/xfs_trans.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 12d45e93f07d50..befb508638ca1f 100644
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

