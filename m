Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7115C6FC3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fIf+Ao+u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=i9K64uLkmhhIDKyEIMPkE08NBePa3m6oOTtYN95nlDg=; b=fIf+Ao+u0ZWu46d6R4OOyjcSyh
	+7HA9evwQ3Sh5cVDdPsLDp71UawXOrjmMogfUGbaK5Fo12J3FzZxkMtOGIUdHN9q9IfxYLfbJ/PTp
	KJgVdKBDmijzgzFtlG+1w0LG6/EGG0JPx059gFj0Ip8htwBeo3GBp4dwpmmYnhj2+eLskapBzKmUc
	IkKohSFYWgwVPFTAVR1HKGq1O0xJ7G259J6ADtdXwtFensZEEa0+FE/LatDYhuNFT2fThfnW4cnDE
	60Te04sS84UkwLDAZF7NWgB0O3tDGGz9Baq102H2iqsZruBwQ6fTkmM6bZbFxyAW3PFKsN/wppMYb
	gf3A266A==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5hg-0095Aq-2A;
	Mon, 18 Dec 2023 04:58:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/22] xfs: split xfs_rtmodify_summary_int
Date: Mon, 18 Dec 2023 05:57:27 +0100
Message-Id: <20231218045738.711465-12-hch@lst.de>
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

Inline the logic of xfs_rtmodify_summary_int into xfs_rtmodify_summary
and xfs_rtget_summary instead of having a somewhat awkward helper to
share a little bit of code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 76 ++++++++++++------------------------
 1 file changed, 25 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index e67f6f763f7d0f..5773e4ea36c624 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -452,71 +452,38 @@ xfs_trans_log_rtsummary(
 }
 
 /*
- * Read and/or modify the summary information for a given extent size,
- * bitmap block combination.
- * Keeps track of a current summary block, so we don't keep reading
- * it from the buffer cache.
- *
- * Summary information is returned in *sum if specified.
- * If no delta is specified, returns summary only.
+ * Modify the summary information for a given extent size, bitmap block
+ * combination.
  */
 int
-xfs_rtmodify_summary_int(
+xfs_rtmodify_summary(
 	struct xfs_rtalloc_args	*args,
 	int			log,	/* log2 of extent size */
 	xfs_fileoff_t		bbno,	/* bitmap block number */
-	int			delta,	/* change to make to summary info */
-	xfs_suminfo_t		*sum)	/* out: summary info for this block */
+	int			delta)	/* in/out: summary block number */
 {
 	struct xfs_mount	*mp = args->mp;
-	int			error;
-	xfs_fileoff_t		sb;	/* summary fsblock */
-	xfs_rtsumoff_t		so;	/* index into the summary file */
+	xfs_rtsumoff_t		so = xfs_rtsumoffs(mp, log, bbno);
 	unsigned int		infoword;
+	xfs_suminfo_t		val;
+	int			error;
 
-	/*
-	 * Compute entry number in the summary file.
-	 */
-	so = xfs_rtsumoffs(mp, log, bbno);
-	/*
-	 * Compute the block number in the summary file.
-	 */
-	sb = xfs_rtsumoffs_to_block(mp, so);
-
-	error = xfs_rtsummary_read_buf(args, sb);
+	error = xfs_rtsummary_read_buf(args, xfs_rtsumoffs_to_block(mp, so));
 	if (error)
 		return error;
 
-	/*
-	 * Point to the summary information, modify/log it, and/or copy it out.
-	 */
 	infoword = xfs_rtsumoffs_to_infoword(mp, so);
-	if (delta) {
-		xfs_suminfo_t	val = xfs_suminfo_add(args, infoword, delta);
-
-		if (mp->m_rsum_cache) {
-			if (val == 0 && log + 1 == mp->m_rsum_cache[bbno])
-				mp->m_rsum_cache[bbno] = log;
-			if (val != 0 && log >= mp->m_rsum_cache[bbno])
-				mp->m_rsum_cache[bbno] = log + 1;
-		}
-		xfs_trans_log_rtsummary(args, infoword);
-		if (sum)
-			*sum = val;
-	} else if (sum) {
-		*sum = xfs_suminfo_get(args, infoword);
+	val = xfs_suminfo_add(args, infoword, delta);
+
+	if (mp->m_rsum_cache) {
+		if (val == 0 && log + 1 == mp->m_rsum_cache[bbno])
+			mp->m_rsum_cache[bbno] = log;
+		if (val != 0 && log >= mp->m_rsum_cache[bbno])
+			mp->m_rsum_cache[bbno] = log + 1;
 	}
-	return 0;
-}
 
-int
-xfs_rtmodify_summary(
-	struct xfs_rtalloc_args	*args,
-	int			log,	/* log2 of extent size */
-	xfs_fileoff_t		bbno,	/* bitmap block number */
-	int			delta)	/* in/out: summary block number */
-{
-	return xfs_rtmodify_summary_int(args, log, bbno, delta, NULL);
+	xfs_trans_log_rtsummary(args, infoword);
+	return 0;
 }
 
 /*
@@ -530,7 +497,14 @@ xfs_rtget_summary(
 	xfs_fileoff_t		bbno,	/* bitmap block number */
 	xfs_suminfo_t		*sum)	/* out: summary info for this block */
 {
-	return xfs_rtmodify_summary_int(args, log, bbno, 0, sum);
+	struct xfs_mount	*mp = args->mp;
+	xfs_rtsumoff_t		so = xfs_rtsumoffs(mp, log, bbno);
+	int			error;
+
+	error = xfs_rtsummary_read_buf(args, xfs_rtsumoffs_to_block(mp, so));
+	if (!error)
+		*sum = xfs_suminfo_get(args, xfs_rtsumoffs_to_infoword(mp, so));
+	return error;
 }
 
 /* Log rtbitmap block from the word @from to the byte before @next. */
-- 
2.39.2

