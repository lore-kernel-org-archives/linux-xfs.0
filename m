Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979053988FF
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127145; cv=none; b=UprUibW2Mm35y5hpdzVrbmdJptoosRBEGfz/O7mltdCAuqZNGPEIh+NLlVlqFZBs8wuigy7HTXKZ/KAMoVGARSwcMsv0JQcfHG8XxXOs+3zYb1wwAHOmmR7mTJA50Rt2HTbGT3fzVXe41YESC8tR5i0EysKx8jYAIQhFZLhvzn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127145; c=relaxed/simple;
	bh=tB1w7LIG8QyiMYcvK27j3Aupypo2KAIhTPTpzyni+X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOHtDgFF7ALnpfTN2ge7f1qhY0G4rYC1UlJtJ4CgP5dndUoSCb48/Vo4cI8wl0pNExw9PXxhHpgNS/xE5Y+wiIjv6DHL+JjLIUby5blaMSZI05MQc5jJvIGXkEwgFf0ZDjhccNOHsWHMTRcydgaogUQXRT6wwImtoqB0GLbPhVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OI9JHrjA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OI9JHrjA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8xHyCGb8pwcxAKUetdRpXo1izLOpMv5U13hwy9WUu8o=; b=OI9JHrjANhFgrpDbrjlbnI5MLc
	IiQU1Ecr31BkQlHzPgMuiGQcOsjB/v0g196sOBxtF15YW0A3sT7vkAbJ74rpomIvlCupyeTl79WBp
	eJG2YwIkK9lTU6INpT8EpO+k6uc2H8tdJ10wzpLPC/edqnErrWF5kAbDRpg5Xm51LtdgIzzKLbkSs
	mXZJ8mHnDhPV8Uh3MBFm+bnfYWJSSAqarINEo/o+ebo+Va9PoizFPaSV/DXIaYQ7Rj8xGrM6OPR/w
	cW20kXw9DzVumw1Wrb7pgN/2IXFKQTQSrtRZzyCH92Fbb/zjfBK7oVEACfJwn9n/CnueCgmz9u/pL
	RPLYmWqQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0yF-0000000FDYO-43vf;
	Wed, 15 Jul 2026 14:52:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/12] xfs: move buffer locking out of xfs_find_get_buf
Date: Wed, 15 Jul 2026 16:51:04 +0200
Message-ID: <20260715145147.95654-12-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715145147.95654-1-hch@lst.de>
References: <20260715145147.95654-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

To prepare for buffer loookups that don't lock the buffer, move the
call to xfs_buf_find_lock from xfs_find_get_buf to its callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index be3b25ccbea6..f5701f74061f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -577,12 +577,6 @@ xfs_find_get_buf(
 			return error;
 	}
 
-	error = xfs_buf_find_lock(bp, flags);
-	if (error) {
-		xfs_buf_rele(bp);
-		return error;
-	}
-
 	*bpp = bp;
 	return 0;
 }
@@ -607,6 +601,12 @@ xfs_buf_get_map(
 	error = xfs_find_get_buf(btp, map, nmaps, flags, bpp);
 	if (error)
 		return error;
+
+	error = xfs_buf_find_lock(*bpp, flags);
+	if (error) {
+		xfs_buf_rele(*bpp);
+		return error;
+	}
 	XFS_STATS_INC(btp->bt_mount, xb_get);
 	trace_xfs_buf_get(*bpp, flags, _RET_IP_);
 	xfs_buf_ioerror(*bpp, 0);
@@ -647,6 +647,11 @@ xfs_buf_read_map(
 	error = xfs_find_get_buf(target, map, nmaps, flags, &bp);
 	if (error)
 		return error;
+	error = xfs_buf_find_lock(bp, flags);
+	if (error) {
+		xfs_buf_rele(bp);
+		return error;
+	}
 
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
 
@@ -749,20 +754,26 @@ xfs_buf_readahead_map(
 	if (xfs_buftarg_is_mem(target))
 		return;
 
-	if (xfs_find_get_buf(target, map, nmaps, flags | XBF_TRYLOCK, &bp))
+	if (xfs_find_get_buf(target, map, nmaps, flags, &bp))
 		return;
+	if (xfs_buf_find_lock(bp, XBF_TRYLOCK))
+		goto out_rele;
+
 	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
+	if (bp->b_flags & XBF_DONE)
+		goto out_unlock;
 
-	if (bp->b_flags & XBF_DONE) {
-		xfs_buf_relse(bp);
-		return;
-	}
 	XFS_STATS_INC(target->bt_mount, xb_get_read);
 	bp->b_ops = ops;
 	xfs_buf_clear_flags(bp, XBF_WRITE | XBF_DONE);
 	xfs_buf_set_flags(bp, flags);
 	percpu_counter_inc(&target->bt_readahead_count);
 	xfs_buf_submit(bp);
+	return;
+out_unlock:
+	xfs_buf_unlock(bp);
+out_rele:
+	xfs_buf_rele(bp);
 }
 
 /*
-- 
2.53.0

