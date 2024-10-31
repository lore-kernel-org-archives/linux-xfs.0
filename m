Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A111CDFB4
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416294; cv=none; b=p3HnlmnFKCyNlgqZS6XJycGKQG36r3pw+g806lL2gABkWtyFsbvNr9s7pJZhtHQBZ7+PJI2Hp8uaTt5YOorcKarvOAQNjDJaeiwyx1pfX0LigCvyW1+0bvi44o0a9vjlMRbjq4uyZbWM4FDZsxarpu3b5kgt+TpGhtp07Binp7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416294; c=relaxed/simple;
	bh=vAaI00AcFFFoGiGg4HfoHHSkdd7pZjID/WpJHDG1SI8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZqGZnrbbYkyv7/5OxwZ7ec+GC4U77wow0rlvBmeHibf1UMT1Hbt2L4flolRx3JYDZLJ4ORtVImh0U2QjCsm2QYPj2vP6yZIJu810Si2JBvndQIPcPdwLsNx4Dh03FgcfEbe/sYO76vEQflGNFoooJArSPMYnKsITrFE7+cKZJrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SDkOvgp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDkOvgp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7B9C4CEC3;
	Thu, 31 Oct 2024 23:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416294;
	bh=vAaI00AcFFFoGiGg4HfoHHSkdd7pZjID/WpJHDG1SI8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SDkOvgp24qp6/UtOx8Uql9c1mGLoFtWHSpokUlYTMuqxoGBbfDmjDSauBfCDT8bdr
	 qeGdRd6HzksU69St1Nyh5ssENXVk+RvQ1B307gemGSZW9RN1VmEqkhEkiw4qKjByuL
	 IgvVJMLW6zSNyhkLQKENXYxXO5Y5zliORIDWZ8Wqw9YUynIa7UqX7lGtkZZvoeWZcR
	 18CRcU3ysDS5EYtAHN+R8PX27HuKFJkDkdi2YuToFbD2LJTKWwVH4QWsdDEEPEvMbZ
	 kw3B401TZjMVIRFF2ksO0QI25lSPPbvA34v7WeQfHqHzx2VP95eF3kgx0QOIOGIP9l
	 +zF8igbjYoufw==
Date: Thu, 31 Oct 2024 16:11:33 -0700
Subject: [PATCH 11/41] xfs: add bounds checking to
 xfs_rt{bitmap,summary}_read_buf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566088.962545.11332836383456959576.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b4781eea6872431840e53ffebb95a5614e6944b4

Add a corruption check for passing an invalid block number, which is a
lot easier to understand than the xfs_bmapi_read failure later on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.c |   31 ++++++++++++++++++++++++++++++-
 libxfs/xfs_rtbitmap.h |   22 ++--------------------
 2 files changed, 32 insertions(+), 21 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index f578b0d34b36d3..fc904547147e93 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -67,7 +67,7 @@ xfs_rtbuf_cache_relse(
  * Get a buffer for the bitmap or summary file block specified.
  * The buffer is returned read and locked.
  */
-int
+static int
 xfs_rtbuf_get(
 	struct xfs_rtalloc_args	*args,
 	xfs_fileoff_t		block,	/* block number in bitmap or summary */
@@ -136,6 +136,35 @@ xfs_rtbuf_get(
 	return 0;
 }
 
+int
+xfs_rtbitmap_read_buf(
+	struct xfs_rtalloc_args		*args,
+	xfs_fileoff_t			block)
+{
+	struct xfs_mount		*mp = args->mp;
+
+	if (XFS_IS_CORRUPT(mp, block >= mp->m_sb.sb_rbmblocks)) {
+		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
+		return -EFSCORRUPTED;
+	}
+
+	return xfs_rtbuf_get(args, block, 0);
+}
+
+int
+xfs_rtsummary_read_buf(
+	struct xfs_rtalloc_args		*args,
+	xfs_fileoff_t			block)
+{
+	struct xfs_mount		*mp = args->mp;
+
+	if (XFS_IS_CORRUPT(mp, block >= XFS_B_TO_FSB(mp, mp->m_rsumsize))) {
+		xfs_rt_mark_sick(args->mp, XFS_SICK_RT_SUMMARY);
+		return -EFSCORRUPTED;
+	}
+	return xfs_rtbuf_get(args, block, 1);
+}
+
 /*
  * Searching backward from start find the first block whose allocated/free state
  * is different from start's.
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 1e04f0954a0fa7..e87e2099cff5e0 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -293,26 +293,8 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 
 #ifdef CONFIG_XFS_RT
 void xfs_rtbuf_cache_relse(struct xfs_rtalloc_args *args);
-
-int xfs_rtbuf_get(struct xfs_rtalloc_args *args, xfs_fileoff_t block,
-		int issum);
-
-static inline int
-xfs_rtbitmap_read_buf(
-	struct xfs_rtalloc_args		*args,
-	xfs_fileoff_t			block)
-{
-	return xfs_rtbuf_get(args, block, 0);
-}
-
-static inline int
-xfs_rtsummary_read_buf(
-	struct xfs_rtalloc_args		*args,
-	xfs_fileoff_t			block)
-{
-	return xfs_rtbuf_get(args, block, 1);
-}
-
+int xfs_rtbitmap_read_buf(struct xfs_rtalloc_args *args, xfs_fileoff_t block);
+int xfs_rtsummary_read_buf(struct xfs_rtalloc_args *args, xfs_fileoff_t block);
 int xfs_rtcheck_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxlen_t len, int val, xfs_rtxnum_t *new, int *stat);
 int xfs_rtfind_back(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,

