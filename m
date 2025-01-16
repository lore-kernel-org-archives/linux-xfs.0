Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367044414
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 06:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737007421; cv=none; b=FyBCyIcx0ppwOL3g+rL/rsSwVGXN6hF5A7cZ4aH/4Jv451RF6VqnP2ru9qoX+kSwL7x7LXGMlGzbD46Fgp3ny3XgFFtWEbNvIP4ankEC9xj8htNDTkexRH8vTAGrZ9tyfjDYLmSqpDBnlh0OPdiGKCT9qxx8oPNbJt7bouCimcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737007421; c=relaxed/simple;
	bh=WZdb+0v/3vilt8JGveXXz97/coZ61+8GVKQuLtYgoe8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pfymy0XZ5XiRjVhaZQ4lW80A6NKDTesdTxHcDxXQwb5YWH0yISr0HEper7xhkWUg3QaaxRVBXsEsr+LGH625SPG96pOwparHPd24VCcqMnzqcTMzoyXzwllT6vX3oSwt3a8MItwwiD6uamkYnIyit+OznBuSbsn8TYrJXRP/Lvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zdGkrFy0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zdGkrFy0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=bpMR1pYG1TGtGW6f2qMRWpnJGAoyQu9k1P57/kOez/s=; b=zdGkrFy0HMtTl9XTI1SMh+ieyw
	DR8HOzliVMfome3petqEeKdfoAr1WACpKvdgzmngR/WV83l0rBKPfNVZh4s+0YRWApGpzmf66dMgn
	odOcF8EWOZittSGZgHMY3ry6Sgba/dT8s48JihD2/s2QfVZO5rg82Wp0kRpQHNNTNwpDC4c1eNMbT
	a0sISlRW2Mq6G/zJtvm5lIR5Jf5+6uJFf00zxBRTrmihCbRCXrKa4s/b4ujxKYZpEMqoxla4PIzOW
	svsssUMcwDrsuvBb8Yu/4zeqOz7bTKRUBHFbVvXTUDPv/+s3+UQEUOhoBH9ZMn/B5FL7Os49Rm770
	9R0h+XLQ==;
Received: from 2a02-8389-2341-5b80-1199-69ad-3684-6d55.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1199:69ad:3684:6d55] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tYIyg-0000000DvCM-4B9X;
	Thu, 16 Jan 2025 06:03:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove an out of data comment in _xfs_buf_alloc
Date: Thu, 16 Jan 2025 07:03:35 +0100
Message-ID: <20250116060335.87426-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There hasn't been anything like an io_length for a long time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index dc219678003c..af3945bf7d94 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -241,11 +241,6 @@ _xfs_buf_alloc(
 	bp->b_mount = target->bt_mount;
 	bp->b_flags = flags;
 
-	/*
-	 * Set length and io_length to the same value initially.
-	 * I/O routines should use io_length, which will be the same in
-	 * most cases but may be reset (e.g. XFS recovery).
-	 */
 	error = xfs_buf_get_maps(bp, nmaps);
 	if (error)  {
 		kmem_cache_free(xfs_buf_cache, bp);
-- 
2.45.2

