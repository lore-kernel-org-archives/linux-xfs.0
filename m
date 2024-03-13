Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F791BA27
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295580; cv=none; b=DeO5oSbk7fhjTz292cN6rbbgw1zqACUBkhmBWHZFRIgGGbo4eU42clp1iYhCvriLq/cHKMhGld/oUfomL2iGYy5W40jQ/lfAjO7FjPRy4QGznXJlYHBkAZqIIdjToC66BRFETxGnXwtiD2RE6m5XMcQf4nTz1WciEtcFtDdAXXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295580; c=relaxed/simple;
	bh=edfwR++0CB/YoHE25GT+WFHJeCmxvltWaGUo6WFqPsw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ATCDxLg7NmLXlfHxZB69M4KGpiVvOPm96pnEChneihjBRJIo6vwAdqo+qmuSLg9HznsT0mqbNWfhT+ip7MacJEzwaVPWfGJCxUU2VuCP1ueYntFqU6OwD+GvrF7gELG4urkmlH0ztMSFs8Wz+0YXNOLEO6AGbcpCGjRNJG2W40s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CA8+PGy7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CA8+PGy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48072C433F1;
	Wed, 13 Mar 2024 02:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295580;
	bh=edfwR++0CB/YoHE25GT+WFHJeCmxvltWaGUo6WFqPsw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CA8+PGy7LIiDbOOlvj3jdlJJgmbemA/HwW9pWruzkkgkORdlHtMjHTm4cCdbMhxza
	 csjVqwCv9a8B2p6L3qyzQquLyU5RLQ3RX4pxIZ0fr6rNmRze+osb7zx6ty8EFbQTe7
	 /0vpctSu+tqWe7v7GxvOhmBdAo/TDGgq8Z0Gg6GjZ1J7rlqgslSL9hWMvIQTC2IIN7
	 MeTp67FLJjCbVQ0gaiCQ26KqRAyRbmYDOiRj31jJrmNqrXV2ZaQZQjvkJ+CC+RLmSU
	 PbVfV2Jp5n5RKfPVVQy50pWHOoiY/BwCKTQvDnq7H88Ac5uuTxw0r0pp6egpLc7q5P
	 xrUNPizlwqpNg==
Date: Tue, 12 Mar 2024 19:06:19 -0700
Subject: [PATCH 51/67] xfs: split xfs_rtmodify_summary_int
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431929.2061787.9927966550049035309.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b271b314119eca1fb98a2c4e15304ce562802f0c

Inline the logic of xfs_rtmodify_summary_int into xfs_rtmodify_summary
and xfs_rtget_summary instead of having a somewhat awkward helper to
share a little bit of code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_rtbitmap.c |   90 +++++++++++++++++--------------------------------
 1 file changed, 32 insertions(+), 58 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index adeaffed7764..bbf955be852a 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -450,63 +450,9 @@ xfs_trans_log_rtsummary(
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
-int
-xfs_rtmodify_summary_int(
-	struct xfs_rtalloc_args	*args,
-	int			log,	/* log2 of extent size */
-	xfs_fileoff_t		bbno,	/* bitmap block number */
-	int			delta,	/* change to make to summary info */
-	xfs_suminfo_t		*sum)	/* out: summary info for this block */
-{
-	struct xfs_mount	*mp = args->mp;
-	int			error;
-	xfs_fileoff_t		sb;	/* summary fsblock */
-	xfs_rtsumoff_t		so;	/* index into the summary file */
-	unsigned int		infoword;
-
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
-	if (error)
-		return error;
-
-	/*
-	 * Point to the summary information, modify/log it, and/or copy it out.
-	 */
-	infoword = xfs_rtsumoffs_to_infoword(mp, so);
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
-	}
-	return 0;
-}
-
 int
 xfs_rtmodify_summary(
 	struct xfs_rtalloc_args	*args,
@@ -514,7 +460,28 @@ xfs_rtmodify_summary(
 	xfs_fileoff_t		bbno,	/* bitmap block number */
 	int			delta)	/* in/out: summary block number */
 {
-	return xfs_rtmodify_summary_int(args, log, bbno, delta, NULL);
+	struct xfs_mount	*mp = args->mp;
+	xfs_rtsumoff_t		so = xfs_rtsumoffs(mp, log, bbno);
+	unsigned int		infoword;
+	xfs_suminfo_t		val;
+	int			error;
+
+	error = xfs_rtsummary_read_buf(args, xfs_rtsumoffs_to_block(mp, so));
+	if (error)
+		return error;
+
+	infoword = xfs_rtsumoffs_to_infoword(mp, so);
+	val = xfs_suminfo_add(args, infoword, delta);
+
+	if (mp->m_rsum_cache) {
+		if (val == 0 && log + 1 == mp->m_rsum_cache[bbno])
+			mp->m_rsum_cache[bbno] = log;
+		if (val != 0 && log >= mp->m_rsum_cache[bbno])
+			mp->m_rsum_cache[bbno] = log + 1;
+	}
+
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

