Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4316FC8
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wg5zFK42"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WJ90Eh3ssyjio25JhBjysEYJIaq+1Ny2wzeZqGbL5Yg=; b=Wg5zFK42QCQ/Xc4LP44HD7g1bn
	zxtoGBwGbxiwpKPNt6slTzp0hwjub9VsGFyYp2dedIzmksklnAg6mMXjH/eeHg7UjCkmv+hVaqeNo
	AZqBIg59sjC+FEy1aMpCSfKReLCYiVXTHFaiQ/nvBFPjC/VMLyRheahp2zk/DPeMqFR055UiUy7a9
	FIekM7EvxZ32+9vrPAG341db9pcLcVaaee1ognsgVL+VxRe+WefSHutdRdfMgePC9Sn3T0XBRt+J/
	yVjfcljtzOMLHCdxtHhKngv9cwGjJdBMqt6GZm3GwnLSVct5PqtpWW71U7DmVuyHqFNhR4ldpgBXt
	9YbIUwJA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5hl-0095Cp-2R;
	Mon, 18 Dec 2023 04:58:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/22] xfs: reflow the tail end of xfs_rtallocate_extent_block
Date: Mon, 18 Dec 2023 05:57:29 +0100
Message-Id: <20231218045738.711465-14-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231218045738.711465-1-hch@lst.de>
References: <20231218045738.711465-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Change polarity of a check so that the successful case of being able to
allocate an extent is in the main path of the function and error handling
is on a branch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 924665b66210ed..6fcc847b116273 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -289,36 +289,38 @@ xfs_rtallocate_extent_block(
 		if (error)
 			return error;
 	}
+
 	/*
 	 * Searched the whole thing & didn't find a maxlen free extent.
 	 */
-	if (minlen <= maxlen && besti != -1) {
-		xfs_rtxlen_t	p;	/* amount to trim length by */
-
+	if (minlen > maxlen || besti == -1) {
 		/*
-		 * If size should be a multiple of prod, make that so.
+		 * Allocation failed.  Set *nextp to the next block to try.
 		 */
-		if (prod > 1) {
-			div_u64_rem(bestlen, prod, &p);
-			if (p)
-				bestlen -= p;
-		}
+		*nextp = next;
+		return -ENOSPC;
+	}
 
-		/*
-		 * Allocate besti for bestlen & return that.
-		 */
-		error = xfs_rtallocate_range(args, besti, bestlen);
-		if (error)
-			return error;
-		*len = bestlen;
-		*rtx = besti;
-		return 0;
+	/*
+	 * If size should be a multiple of prod, make that so.
+	 */
+	if (prod > 1) {
+		xfs_rtxlen_t	p;	/* amount to trim length by */
+
+		div_u64_rem(bestlen, prod, &p);
+		if (p)
+			bestlen -= p;
 	}
+
 	/*
-	 * Allocation failed.  Set *nextp to the next block to try.
+	 * Allocate besti for bestlen & return that.
 	 */
-	*nextp = next;
-	return -ENOSPC;
+	error = xfs_rtallocate_range(args, besti, bestlen);
+	if (error)
+		return error;
+	*len = bestlen;
+	*rtx = besti;
+	return 0;
 }
 
 /*
-- 
2.39.2

