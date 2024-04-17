Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ACB651B2
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389705; cv=none; b=EsvelqTVkPPprUOPiHDhgvf3c3xbx+65ZFgdicBFMcLnxcwKzHj7KGCZe6trOlHMlZVRW0Sy3bcMoTJgrL0znYs5H5b6U9XDpUahIeVMTh1HVHvx8Hu6GvhcMLlQpYikDQHawfsvJ3KdoFIbginG7j0wdpw2HcuN2c4ylfIXCAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389705; c=relaxed/simple;
	bh=4KaUkHvst5rzkxuswPYHuaLyZcrYkd+cWpu/AwLY0Pw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SALu24+tm2bUk/4UPXzjCLTTI/2+AeRMQl38gkMUayebpsM0nh8Y7rRM+e5tObxr00kr2e3vyEGU5KTz0BSvcO6iruHKtx4r5f1Zdz4lkOdEVz/DqqVUwAByOcyadHJz/AZ9NIgQn3beaXaM2WIm+t6NO7JmcudyInrPnBqO7g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VawM9qTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VawM9qTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC36C072AA;
	Wed, 17 Apr 2024 21:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389705;
	bh=4KaUkHvst5rzkxuswPYHuaLyZcrYkd+cWpu/AwLY0Pw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VawM9qTu3o+xQJ0NBorD7AC47vyjJyEhXB2LTQfoffbxykIMogEly7ckAi7bhW3XN
	 +TfyFwHnaXXlIM0x2R9XVoyZqBKpyciXqvzJ6z/2mXvpdWNNoN7silTqJlPLm4iWMu
	 L6gd5BjoQrgiXxJzvToxj+75JUQd1gVtsPPfwRkHUHVIRTKfkmUb3+ra0U4tzR4O58
	 pvfOoLFbKWM70JQpnQSADiQw1JdwTwKPSUbcJImqlQSxyqk6MzQCFbqz4CusVf4sMY
	 RyRTaaID/ujA61g03UAbQaZ8C2A64oXMuMWOxSJSJK2LIhYnBWDbcyzuVQ+lIZh6yU
	 e3yr87nyW4dFQ==
Date: Wed, 17 Apr 2024 14:35:04 -0700
Subject: [PATCH 51/67] xfs: split xfs_rtmodify_summary_int
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843105.1853449.7523929416312102407.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_rtbitmap.c |   90 +++++++++++++++++--------------------------------
 1 file changed, 32 insertions(+), 58 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index adeaffed7..bbf955be8 100644
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

