Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02BB399D00
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 14:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127136; cv=none; b=sfmr/L3vVCBIux3h/ooh4d/UXUn1BLLu2V6ORr3TonvSmfSPuKWVpG27XKlZDf79umRsjcEX3eFqNrChZHe6q3wqjdGNOLjcGuppz1BF3l8LgNwjMWVBaB8M992C1eDV8aC+6DtwFpy2OnZYLhRbBL04fiTw16ngimJ3eXIsK0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127136; c=relaxed/simple;
	bh=ZXWYo7qEqa5pJw3ypy8GvDURupUsVf4whVRM6CDMNLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8+xr3ifWuJcOhaGozXGhn+x/joahHjDR6hieXBsTwI5XaH7lc3mob9LWJBLeFEXO8FjXIcXZAIJoXMYTpkDIzfqnYH/jizyI1t1JUj5vXmonPaqkLXQVxLYoFJZ0piA/ViPUa0ugAgB9dLRTJHgZUih621hHlzJiIUk2gMtMfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Mfrd8gOT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mfrd8gOT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ybF5xdKgZoXsUv8ZDxA3OLfxHo0ffo0HYrKGOoQGzRs=; b=Mfrd8gOTqxYFm+e3uhxb2aB8wc
	cP0DFSZEUmEF4UiF6QUunIh0DDH/jCC8wpY4k6cCQVWvVIXrQsh+jcYUX6lZ4wvYHwgnHrKuI5v+V
	FJUDHGl7XbAr/1e4sLXez+Rmzbnvm1W5I/V9ZaFovOunrDiucwsqs4SNgnXki/4be7Yv8pg9Fk7C+
	hmUyoopAkWaDpOTlEM42idQIpUES09mw/OAX0jEB0tnOoUSx7/4YHw0LgzOLWv6b2Ur5jZMivn9Oo
	PNeCFTvwppIQJwz/qPMw2Y8UHyb9nYQMraLQLagw2Fdc/nYuWabtw6im6vQWm9Q52bOarh6e3wpw3
	tFPQrrkQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0y7-0000000FDXZ-0tyo;
	Wed, 15 Jul 2026 14:52:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/12] xfs: don't reverify buffers in xfs_buf_readahead_map
Date: Wed, 15 Jul 2026 16:51:01 +0200
Message-ID: <20260715145147.95654-9-hch@lst.de>
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

xfs_buf_read_map calls xfs_buf_reverify to ensure the verifier has run
for a buffer before the data can be used when an earlier readahead read
the data before the buf_ops were assigned.

There is no point in doing this in xfs_buf_readahead_map for a buffer
already in memory as a later xfs_buf_read will do the same and can
actually propagate the error to the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2a0a19172847..4430da3259f1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -760,7 +760,6 @@ xfs_buf_readahead_map(
 	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
 
 	if (bp->b_flags & XBF_DONE) {
-		xfs_buf_reverify(bp, ops);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0

