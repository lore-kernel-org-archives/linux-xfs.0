Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00920195
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371832; cv=none; b=naheitcc58LKZLDJKa1T62q58uyg/JZbG5SCvKtFREafGKKeq3gF2eTyUdu5/kQuusYIAOe0ZTLjkn3VJBzG1VS8M5r5kxy+78XF0TpYshl8gpVBv4sdefWGToCSvG4SWuJgr9CHg+17pyyNNfft1nXM4ZGAr8TRvMoNTlNyJnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371832; c=relaxed/simple;
	bh=aN5wP2FqSxOPm9N4SjlpFha67ROC2kBcgW3OI2knSNY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oz3zCVzxUhGJ7IO0M0EWIzQTyf7KKUzAMUzhK4jJFUXY33UDNWLMuIiAd+tLETfJgL3Bli/OgF2HldJ+krKozTXwTgrC0IzQXDLLDZi/qPFrc9l/u3IO/2TuNRItHwdGf+pfW0VVilHV1SPn3vxhxjTfMGTUCYa9L9uW+KBFdZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugzbZZZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugzbZZZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9BDC32782;
	Fri, 23 Aug 2024 00:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371830;
	bh=aN5wP2FqSxOPm9N4SjlpFha67ROC2kBcgW3OI2knSNY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ugzbZZZNn722J5XFS+q57khFJPSTYfv7nHGOffIuZ/zZavnIo3gT4qEGYQEkxbgoc
	 AGhexw87XON29Dp+tbLBbILgDDFS4dOgTPeDYOayd4+gyj3G26jSnNCCu6BQpZCNbb
	 SDmDUlKgmSO8CbpMnn0VpztjTtZzzR+t+8mCuIYZTus6G1sShWhAaI7Gg/tgLvW7nJ
	 HAAu4eAJypgj+kwW1pb+FMmHzMiRYhnMHsjXMzvs2E2AUknBGKxY4LbdRWjDVTH7Da
	 M8sbe1LQtNGvvkvnyVxpg9mtWIdcuExqkBgjerWPuppTdQx8VbGevWySzcK+pEhOr2
	 1UP4DxrH0khTg==
Date: Thu, 22 Aug 2024 17:10:29 -0700
Subject: [PATCH 06/12] xfs: add bounds checking to
 xfs_rt{bitmap,summary}_read_buf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086122.58604.5538134784944300406.stgit@frogsfrogsfrogs>
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

Add a corruption check for passing an invalid block number, which is a
lot easier to understand than the xfs_bmapi_read failure later on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   31 ++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_rtbitmap.h |   22 ++--------------------
 2 files changed, 32 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 4de97c4e8ebdd..02d6668d860fd 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -69,7 +69,7 @@ xfs_rtbuf_cache_relse(
  * Get a buffer for the bitmap or summary file block specified.
  * The buffer is returned read and locked.
  */
-int
+static int
 xfs_rtbuf_get(
 	struct xfs_rtalloc_args	*args,
 	xfs_fileoff_t		block,	/* block number in bitmap or summary */
@@ -138,6 +138,35 @@ xfs_rtbuf_get(
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 1e04f0954a0fa..e87e2099cff5e 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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

