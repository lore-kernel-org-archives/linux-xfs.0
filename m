Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ADF4A01
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371799; cv=none; b=uNS96V58cdaqp/Pa+UOKVVvoWdX78dfPQVnpvnmAHe6xbmpI9xlAJUpkxOcvQLEZ4C5ph3mpxFR1mmz9EmVqoR5D5iN78Nyr1PKHZ9SHckJ6xh1+2OJajSpQ0TP0qrJ7EiTlqLBDJ0rVG3io15kC1waB+AehPEX54VkNv68bxmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371799; c=relaxed/simple;
	bh=KptZAa270lf6dYovWTgAvK/MlMurlUNAsVYt/DEsu10=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h0uGxBpEDfKC5Pn6wxBmakOEhNshM68DmLdw9vpKT/p6omVen5Y+IA+pQC+eIii3Lte5PaWGPixjp2cD0Fkf2SlnpdyqP9SyvtE9laxYskgybBs+qU/dsaXQ68f7mxXE8z4q8wJtirJ6nZ8bT1kghiktpl2O2riYxLN5uoAsok0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pNtVbBjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pNtVbBjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01D2C32782;
	Fri, 23 Aug 2024 00:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371798;
	bh=KptZAa270lf6dYovWTgAvK/MlMurlUNAsVYt/DEsu10=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pNtVbBjZT7d9e4FnDBGHjzFvzMAMdISgfQTYbqxxz2RXylbOwZhG+Qxa3tUA7O9Lk
	 Hr+/9X9lTCvE9IhqXIXbmDfJ23ih9eFyiSa9ovHmP1xDCFGsKvGYrq6NMG+i3Vl743
	 8TkAV3pPaZtCgIdwXmEGllTQygBnCzsXYQ20hNLV0uCvoTs6dMxweiw1I/4o8y93OG
	 zkdkaCxPHUSkUyNKiHUagqn8T8SlXhthiwzvlsROAaSm1u9Wz9lr6iWAwaX6jpdIz9
	 FJtTefu43qU+2caZaY34xnQ7zWAzTUsnlguFwmsyliStiL30xK7RtNOWfAqLgNaPdv
	 ZOKzJ2M2Li2qg==
Date: Thu, 22 Aug 2024 17:09:58 -0700
Subject: [PATCH 04/12] xfs: remove the limit argument to xfs_rtfind_back
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086087.58604.8991781061508700414.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
References: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
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

All callers pass a 0 limit to xfs_rtfind_back, so remove the argument
and hard code it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    9 ++++-----
 fs/xfs/libxfs/xfs_rtbitmap.h |    2 +-
 fs/xfs/xfs_rtalloc.c         |    2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 386b672c50589..9feeefe539488 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -139,14 +139,13 @@ xfs_rtbuf_get(
 }
 
 /*
- * Searching backward from start to limit, find the first block whose
- * allocated/free state is different from start's.
+ * Searching backward from start find the first block whose allocated/free state
+ * is different from start's.
  */
 int
 xfs_rtfind_back(
 	struct xfs_rtalloc_args	*args,
 	xfs_rtxnum_t		start,	/* starting rtext to look at */
-	xfs_rtxnum_t		limit,	/* last rtext to look at */
 	xfs_rtxnum_t		*rtx)	/* out: start rtext found */
 {
 	struct xfs_mount	*mp = args->mp;
@@ -175,7 +174,7 @@ xfs_rtfind_back(
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
 	bit = (int)(start & (XFS_NBWORD - 1));
-	len = start - limit + 1;
+	len = start + 1;
 	/*
 	 * Compute match value, based on the bit at start: if 1 (free)
 	 * then all-ones, else all-zeroes.
@@ -698,7 +697,7 @@ xfs_rtfree_range(
 	 * We need to find the beginning and end of the extent so we can
 	 * properly update the summary.
 	 */
-	error = xfs_rtfind_back(args, start, 0, &preblock);
+	error = xfs_rtfind_back(args, start, &preblock);
 	if (error) {
 		return error;
 	}
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 6186585f2c376..1e04f0954a0fa 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -316,7 +316,7 @@ xfs_rtsummary_read_buf(
 int xfs_rtcheck_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxlen_t len, int val, xfs_rtxnum_t *new, int *stat);
 int xfs_rtfind_back(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
-		xfs_rtxnum_t limit, xfs_rtxnum_t *rtblock);
+		xfs_rtxnum_t *rtblock);
 int xfs_rtfind_forw(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxnum_t limit, xfs_rtxnum_t *rtblock);
 int xfs_rtmodify_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f5a39cfd9bcb8..aaa969433ba8a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -144,7 +144,7 @@ xfs_rtallocate_range(
 	 * We need to find the beginning and end of the extent so we can
 	 * properly update the summary.
 	 */
-	error = xfs_rtfind_back(args, start, 0, &preblock);
+	error = xfs_rtfind_back(args, start, &preblock);
 	if (error)
 		return error;
 

