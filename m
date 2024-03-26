Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100B257314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422969; cv=none; b=FeZxW9SEJ8AQCR6rRWKuzZFqILX9Ixx646iluyJrd41wtyflUz+CrIc9U4A1cjHhkBL3lXCuLyGzV09iq/NAYkIOHJerzChEGAWfJFAEQN04sJny8dW6ybUr8MJxfNagYe6/laE0jN5VDkEdk4V2S2uitosMOB2vwHfIEohUjK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422969; c=relaxed/simple;
	bh=EjK6wkY3vnlQYYMyaeEYUXFPHuGiuQVBZPylANwmN9s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qT4zM+14xVIesO8qlZGscKaFS2Rm8Ps9msaeI7kNA6QTeSvseLssxSDE0WIrciWszX32jZ/eSPd5TWeXapaWteUxYKe51g46NKPdooIgDfe9iUGQVzIglXQYp+Vebz07lKzhLDHb0CliXkInD3N+Sq/gMQqHCKKFw3ytBEg7mZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6endu0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6endu0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA728C433F1;
	Tue, 26 Mar 2024 03:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422968;
	bh=EjK6wkY3vnlQYYMyaeEYUXFPHuGiuQVBZPylANwmN9s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H6endu0bi0bdD6vnLDY9DgkXxdCdKJ9uZjWGCOX8Pdsr+GxD+p1c87XEQLgISV+yE
	 1ak8c5lRtPvvVhe7fu2p6uvjDEhZshPXQJ8TYJ67+Y/yuf9ykA9BzAmzUFjuo3QqOX
	 iz75oWV5bvPVQcbMYvCZ5/B7zExRiGKFSlo0yfcM4eT2b5tJDrhhA8qE6QagTSQhuc
	 4Vd3jcrCPxN8UNdPv/oZUwj6cTQxREBZFR2rB1xXoXyz8VgjjNVee3dP173YrgyfHm
	 AqNO3vJ8he1XS5B3mN8x80BB5VOZtgXUFMgNJQDQNUKsjIf+bkWHEBqQl9nFqoygPU
	 p/Oo7y0IBqACw==
Date: Mon, 25 Mar 2024 20:16:08 -0700
Subject: [PATCH 51/67] xfs: split xfs_rtmodify_summary_int
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127691.2212320.9111987858951540051.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

