Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6893D7A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301528; cv=none; b=ARdVuimPS/NtcD0B8+DeOfPFM130rxxH/IOI+0Fqqy0fESsA3vW1oIDPW9sUksXrX0e+OYs4XWds0FrmkCPECcvY7bNmOQVlIIrl/SHcyGGa5xMT60eQt2IeYT6+Sg+R0Pe5StnWd/Cwf0r4byNOIrUm6UlSfKLGf1PfD5fdNBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301528; c=relaxed/simple;
	bh=xZPY8Kh7pZjZ2J378H930uJQoyLgQtYGTmH+AoJ0NNQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ajKK/6qpIsdgpkr0/CdC+/pvjKNrHBnK1X4hcIPzmK8Hi/HsOp5//sACaF06yP2IGKTWzRZVrJv8+FX9D+DH/QRuH4m18tOa6+dJ//VlhdFOXbVWerqPm0NMAhmK5XB5RMQuY/QCZD5KvS1J/xxi7Ak/BfleeKbHNiNlHimeytk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDa+GE+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDa+GE+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36EFC4CEC2;
	Mon,  2 Sep 2024 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301528;
	bh=xZPY8Kh7pZjZ2J378H930uJQoyLgQtYGTmH+AoJ0NNQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lDa+GE+kZWFTXQWDzkxj7KtsRsyszhyd6ZqRt5bH20rnAe881Do+GDXwLdIMYP2nL
	 u78x8FbzY5LhoShXcDb6lexPHA/QCnisYcX/b953HI/gMAT8zo7TxeEi6x0UAmq2JL
	 /LZ0CxCU1XPxQ6/UdQwj8x0nryg2c5ndxMm0yBYyqn0RVY4TxGpr+WoL1ApirKGPXO
	 5JAT1L++wdLRhhGE5w5ZdqkTW1d2HWFpEyVLv0n0EAVJdQqsJpia0uj/1elbsG2btc
	 sYONA6z2wi9wTIALyZCWv0kdFmjOs4G05UltWxE734SFQjf2jat1x7w1oxBqinqD3+
	 8CSALNN+9B5hA==
Date: Mon, 02 Sep 2024 11:25:28 -0700
Subject: [PATCH 06/12] xfs: add bounds checking to
 xfs_rt{bitmap,summary}_read_buf
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530105814.3325146.16042341552598162859.stgit@frogsfrogsfrogs>
In-Reply-To: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
References: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
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
index 4de97c4e8ebd..02d6668d860f 100644
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
index 1e04f0954a0f..e87e2099cff5 100644
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

