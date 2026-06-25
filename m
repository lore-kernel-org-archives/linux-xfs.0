Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C67347BA9
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 13:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782395948; cv=none; b=l8QeuFXFLKnwMT8/eo1Kk88PLFtRA2qELBQms6+n/7SvM/BpUBYvTzInFvS9bonGfmiO0EQPNNtxG1VUw8GHoK8LX322WwYgCLHkSZfP6Dl0XqN2dDCNgq7ucn0oFROG0/ezkPaP0UpecpXapK1hVf/AuWaV1rA3alQQDIvTxzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782395948; c=relaxed/simple;
	bh=rDoxfeisNO09qW682ThV+UdniI6A7OkJl+rnf2dM+VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iivU1cVEh1bgoQ5a1HSWMvenrj1Npn6pfx8+Y2CaVWrmARPl83xO6RAKnAWYbyMdBstqsjyZxNWn/EbFhH3b1C1wNzRmrA34/w01vQbzsRuxc+D6HfRRIL6nXNbzKfOGOMgIAKEfQ4b4ew5qno5xmd2tyub61uTGg7LCYJTVs0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xdSmLas3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xdSmLas3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fYF6OmES3xax0eYK5BsBtT7DezHSGf6WYWkb5pRvo78=; b=xdSmLas35CGVS5eP5P3im5Br1W
	MY9+NGiwfHHSDWxpQbG5JioFXsu23MlXLwNGaeK2z5Muv8z+P/cV8i1DNc2C9sn1ZOX26RMDvFJPn
	kQshZFFXc97m5+8XMoIWRl8g8kLMpJsU/6U16YQc1611jwmnXcxdYKAE0VMwwws3rhlW/S5dqzf6T
	eQRW/NXNHCFmB4NKYNFbxeqmsOuyGjAgoXShlFHY2O6PL+k0dmOC+ASRCPCaso2/zCQHU6DMyPSzj
	aXdmsXsP3/Y3mmpcWmRByYb0hl0T5vr7LfKOmkay9TcBSAxKgfwzNx/vueo2APiIQNjLuvHUObwRp
	Wuh1s/OA==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wckbi-00000009GsY-1TYi;
	Thu, 25 Jun 2026 13:59:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 5/6] xfs: fix handling of synchronous errors in xfs_buf_submit
Date: Thu, 25 Jun 2026 15:58:35 +0200
Message-ID: <20260625135849.2494779-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260625135849.2494779-1-hch@lst.de>
References: <20260625135849.2494779-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Synchronous readers and writers already run __xfs_buf_ioend from
xfs_buf_iowait after being woken through bp->b_iowait, so we
should not call it here, which can lead to double completions.

Fixes: 4b90de5bc0f5 ("xfs: reduce context switches for synchronous buffered I/O")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3eea9d9ea829..83549573e2cc 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1403,12 +1403,12 @@ xfs_buf_submit(
 	bp->b_flags &= ~XBF_DONE;
 	xfs_buf_stale(bp);
 end_io:
-	if (!__xfs_buf_ioend(bp))
-		return;
-	if (bp->b_flags & XBF_ASYNC)
-		xfs_buf_relse(bp);
-	else
+	if (bp->b_flags & XBF_ASYNC) {
+		if (__xfs_buf_ioend(bp))
+			xfs_buf_relse(bp);
+	} else {
 		complete(&bp->b_iowait);
+	}
 }
 
 /*
-- 
2.53.0

