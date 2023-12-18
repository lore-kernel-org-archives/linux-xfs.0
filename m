Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222BA63A3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JYZrYfiu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=d/iz8UrouWUVJgLlFRV/zH71GphMl8aSkuqyTXgur2Y=; b=JYZrYfiu94aq3TWTbc3aa5jTbC
	+C1B3/4mmwQ9UUMBJUOnYcwhE/KzOYLPyx4MCbOU3dcOe93IQlC8/reP4pCXlHP5weE0yejAEe70p
	LDqSQ6u0pRyU34TDsayYmPdgP4JRBQ1caaLzPUt5o/3nfVT2vvG228GMwilnreFsuutrCW2SpnMaV
	QTo7fuX5htuTyBdpPu0nshivAgWwrbVGY8Tw6mnWPRHdAMgM3MXY69ITO4drNC99MetDKwOoBFaWw
	rLqDvBynPYayYQ2otr6bN4pVTw/NSBfppP9bvFS9ldf/gnAMUqcwetSBiak8aY3ze4uHQjEWrtldc
	FY3djvRQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5ho-0095Do-17;
	Mon, 18 Dec 2023 04:58:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 14/22] xfs: merge the calls to xfs_rtallocate_range in xfs_rtallocate_block
Date: Mon, 18 Dec 2023 05:57:30 +0100
Message-Id: <20231218045738.711465-15-hch@lst.de>
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

Use a goto to use a common tail for the case of being able to allocate
an extent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6fcc847b116273..9604acd7aa6cec 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -252,19 +252,15 @@ xfs_rtallocate_extent_block(
 		error = xfs_rtcheck_range(args, i, maxlen, 1, &next, &stat);
 		if (error)
 			return error;
-
 		if (stat) {
 			/*
 			 * i for maxlen is all free, allocate and return that.
 			 */
-			error = xfs_rtallocate_range(args, i, maxlen);
-			if (error)
-				return error;
-
-			*len = maxlen;
-			*rtx = i;
-			return 0;
+			bestlen = maxlen;
+			besti = i;
+			goto allocate;
 		}
+
 		/*
 		 * In the case where we have a variable-sized allocation
 		 * request, figure out how big this free piece is,
@@ -315,6 +311,7 @@ xfs_rtallocate_extent_block(
 	/*
 	 * Allocate besti for bestlen & return that.
 	 */
+allocate:
 	error = xfs_rtallocate_range(args, besti, bestlen);
 	if (error)
 		return error;
-- 
2.39.2

