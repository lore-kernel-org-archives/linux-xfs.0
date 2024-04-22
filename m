Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617A115381C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804025; cv=none; b=o+CC19cfhQbXp4PWcH/MlZsV/FqrzNRkYnyyMn78/+pclEwgCcCSRJk0hIzrdN/+RUCzMl9JcuklyKjySwn93leWmkUmqwe014RYXwapu9IHTLr928D2U98r6qru9WGwQLJdfcQQrcNhX3CsN2Al00A2Ph6qDB/wAQwjJ37y9JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804025; c=relaxed/simple;
	bh=lB+HOlwXXEe/nQVHNzD6NLpo9SAiN8nPQYgY+0G3wAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jT6vc0ApY5nq+BVp0Q9029y3NlYCr+CRjVJq51EEVcxhc2QxWOf4XjEP9UYArT6JhAWDKVP2ynjaQSt8j5XOOyJ/Woq3Iz0il/fHfAqF/Ghibsf91Kvzdk3u5UV5p/nvkj3g8+Q9BMQa+Zd7S9eNUADAhWMc4oIdDdO6syD7/0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lMh4Jv6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lMh4Jv6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F134C32781;
	Mon, 22 Apr 2024 16:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804025;
	bh=lB+HOlwXXEe/nQVHNzD6NLpo9SAiN8nPQYgY+0G3wAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMh4Jv6FyhFZ3I8dmJx2mBReisv6Ipvkdc96Vp7kftA9OB1Tg8NAcWfnCgVaOsZ1P
	 yAU1ne/ZxJQApgxl5w6uWMV5VcMbHlldWTQf3Vwt33w+ylaCbK5GJdZ2jP/U8t/wYp
	 mzpSjeQ7yvzUhXMsRGXULUXgMCrwuaJv04fZL6BcBLrOtm+oGsf+qyebovNZ2R9Yje
	 sk4XfKwy4Xcl0jMfRHK6ZSSPp2colRIvGbmf/xZ+JCbuCk1WMKaHJ5BRsCLqnkolmK
	 VIgofQ0AJ/aT1E/BlJLclb1AWmnZQYuMY6LT9gGk5StGzIp/MjL/EMya1NKKqjX5S/
	 mDwWagpWLjNRg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 51/67] xfs: split xfs_rtmodify_summary_int
Date: Mon, 22 Apr 2024 18:26:13 +0200
Message-ID: <20240422163832.858420-53-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b271b314119eca1fb98a2c4e15304ce562802f0c

Inline the logic of xfs_rtmodify_summary_int into xfs_rtmodify_summary
and xfs_rtget_summary instead of having a somewhat awkward helper to
share a little bit of code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 76 ++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 51 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index adeaffed7..bbf955be8 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -450,71 +450,38 @@ xfs_trans_log_rtsummary(
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
@@ -528,7 +495,14 @@ xfs_rtget_summary(
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
2.44.0

