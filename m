Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8E263CD
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cfASxrS3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8rYOXuwmw+1N8MHjyW34qpxIjP4zMSKu14/95O0IZN4=; b=cfASxrS3qCZcSbINe03evdiuyM
	o5IXuT9/uePX6TQGw6/1P1grP7mx7RYE8r+EtSEMOFSm71572klCH0wEjw+cuoQ9VrC2uPqCYbZWY
	YRC4DD66lXsNP/clgNet6qhMF7rCIsPOgwiqsoqIDMNRHtNi04KWQAH5NQ1WWo/pL8hoRtsxMxdcr
	kff9gGUIhV/N+0y5qltbu7wFHJV/8pRFq0UUfPNZbjne0K6BwPmvx8odpfz8BTugGxOR3QF8SFG/J
	no+/fm2IJcbKVArqEpZHKNx5DtMwy+AcgqNAWzuBvT11WQDGVhXbv3/uCKKorIYcpMm6YGNT1y520
	tGlKySOA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5hr-0095ED-0D;
	Mon, 18 Dec 2023 04:58:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 15/22] xfs: tidy up xfs_rtallocate_extent_exact
Date: Mon, 18 Dec 2023 05:57:31 +0100
Message-Id: <20231218045738.711465-16-hch@lst.de>
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

Use common code for both xfs_rtallocate_range calls by moving
the !isfree logic into the non-default branch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 9604acd7aa6cec..85d683550048a0 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -350,32 +350,24 @@ xfs_rtallocate_extent_exact(
 	if (error)
 		return error;
 
-	if (isfree) {
+	if (!isfree) {
 		/*
-		 * If it is, allocate it and return success.
+		 * If not, allocate what there is, if it's at least minlen.
 		 */
-		error = xfs_rtallocate_range(args, start, maxlen);
-		if (error)
-			return error;
-		*len = maxlen;
-		*rtx = start;
-		return 0;
-	}
-	/*
-	 * If not, allocate what there is, if it's at least minlen.
-	 */
-	maxlen = next - start;
-	if (maxlen < minlen)
-		return -ENOSPC;
-
-	/*
-	 * Trim off tail of extent, if prod is specified.
-	 */
-	if (prod > 1 && (i = maxlen % prod)) {
-		maxlen -= i;
+		maxlen = next - start;
 		if (maxlen < minlen)
 			return -ENOSPC;
+
+		/*
+		 * Trim off tail of extent, if prod is specified.
+		 */
+		if (prod > 1 && (i = maxlen % prod)) {
+			maxlen -= i;
+			if (maxlen < minlen)
+				return -ENOSPC;
+		}
 	}
+
 	/*
 	 * Allocate what we can and return it.
 	 */
-- 
2.39.2

