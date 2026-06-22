Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368E3369981
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 07:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782113454; cv=none; b=ANC1PwYxqVG08iXel6ZczZFcy0WzX4yK2jzJdDCyCbn+9NfhFNdZ57cEwOhO4zUD/xeY78z2/qeEG82begKAMZJlYq+4MFTnUa08bnnxSmMQtV/Op8k0nibN/HQ1OI1P+nYob2dx1UpuiE/KLGCgmwc2B+A1r7k7yh9fakkZoAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782113454; c=relaxed/simple;
	bh=AWkAafBCkEDUec/qDWCRh8OO8eGZNwJODMyAQW8Bx4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/hog+MnqAf+ZDyPAg7CauuA0C3XIVzQhstvZi8X5hn1yRT61EJ6h9wHwOv+1Lbj7hBSJ8g5ZbqgXscHYwqNg1rVYQ8aV9ls3VySBJqQVJ4Y4F1RvwiXWVxafO4mtuF78IkpVWl3bC7FU+B+JeQQUjw7CfFrWemO9q/VAy9+h/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cOJpGOss; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cOJpGOss"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=87rKJAFa35G5iYX0lpXh8vKxfKovvp+r+DcIKjsqwjM=; b=cOJpGOssfb2rW/RGyPvh8ridVv
	h77RlbhITs46AsQt/RqmNaRsRd+Ec+GYEzCN/D0xMKT+f/HzLXenVXK62KtfzUa+xoawu263pnCkB
	NVnIVEiJIbpKBT4HMVo7pBmyI2oUx1W2V8THMHJqdKJ56QWYeL3KhN2XbsIiAqA12ae/I54DxLSSi
	Ls2O1FE8GTRcMZWukkgINumuXMZPyxdD1V4xFtbeBeAovOCKVAO6db/q3i3eoIbz0+uVBWv1tDVGo
	OaEE1f03agSh8sffSMVGJNYM80Dfry2h+bD6YS2iX+l32vj7P3S4NPYVWj2OQkECD/ouR2c1vEBho
	Eakv+Ctw==;
Received: from 85-127-105-127.dsl.dynamic.surfer.at ([85.127.105.127] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wbZ7M-00000004Xec-0FvY;
	Mon, 22 Jun 2026 07:30:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs: remove xfs_buf_ioend
Date: Mon, 22 Jun 2026 09:30:03 +0200
Message-ID: <20260622073035.1370904-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260622073035.1370904-1-hch@lst.de>
References: <20260622073035.1370904-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There are two callers of xfs_buf_ioend, one of which always has the
XBF_ASYNC flag set.  Open code the logic in both callers to prepare for a
bug fix.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ef2ea15a97bb..651add22deea 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1146,18 +1146,6 @@ __xfs_buf_ioend(
 	return true;
 }
 
-static void
-xfs_buf_ioend(
-	struct xfs_buf	*bp)
-{
-	if (!__xfs_buf_ioend(bp))
-		return;
-	if (bp->b_flags & XBF_ASYNC)
-		xfs_buf_relse(bp);
-	else
-		complete(&bp->b_iowait);
-}
-
 static void
 xfs_buf_ioend_work(
 	struct work_struct	*work)
@@ -1207,7 +1195,8 @@ xfs_buf_fail(
 	bp->b_flags &= ~XBF_DONE;
 	xfs_buf_stale(bp);
 	xfs_buf_ioerror(bp, -EIO);
-	xfs_buf_ioend(bp);
+	if (__xfs_buf_ioend(bp))
+		xfs_buf_relse(bp);
 }
 
 int
@@ -1414,7 +1403,12 @@ xfs_buf_submit(
 	bp->b_flags &= ~XBF_DONE;
 	xfs_buf_stale(bp);
 end_io:
-	xfs_buf_ioend(bp);
+	if (!__xfs_buf_ioend(bp))
+		return;
+	if (bp->b_flags & XBF_ASYNC)
+		xfs_buf_relse(bp);
+	else
+		complete(&bp->b_iowait);
 }
 
 /*
-- 
2.53.0

