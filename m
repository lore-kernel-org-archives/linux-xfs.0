Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1AB2CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548108; cv=none; b=qcUXgcbOJdR/2+pBRzjeOducABFss9x3UbR0WdQT5EorwuluELZtCoP4ejKf352qx2NdmuGLoRHvvAfHuUlou3VSl+6+mASdj1XtuwZFfL3Ywo6YhJbbmZvSUCstkYfGCgXqb5tK7lNky1/a8XqMYuw2oZg5+dCeggGWrS23S9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548108; c=relaxed/simple;
	bh=vAaI00AcFFFoGiGg4HfoHHSkdd7pZjID/WpJHDG1SI8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EHtNF1sxGa9KGcVIimT2ZwRyhCN6g412eg4EfTTi7S8jfqwkvxFKn/Y6CaShgHpBcvLVYbHKnx3CIgHqsZ95tqjdO7HyUdBS6tTMiOcTVoKK57M8HRg/lLyt3k9Ks40fRPX0Ilvnm/xnru3JOFkxoM3ZE9TJ9Iem2YfpSiUOGM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3F0+I6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3F0+I6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283EEC4CEC3;
	Mon, 21 Oct 2024 22:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548108;
	bh=vAaI00AcFFFoGiGg4HfoHHSkdd7pZjID/WpJHDG1SI8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O3F0+I6b+EZrvzVQ7BCCUnOIC7ClNIMwUXz29PJLf7gtT4GlHUlN/HGrdGyfSKxvO
	 8I2AmBcFUD+nFiJTWzK8qA/W9hib1IgVzfX5W8s5x23pq8oEO4SIkVsRTo6G1SeMnz
	 PkYive3dAm+oi7fZM/sBcTr8VpZPwogo4VO25KKUwGqnvo4yvjmEDrwpbKW2r+FWOR
	 b7QiGb9gmSp3It4gWzxhT247U93nrHGivI6gNVzqpbizFWqaJHe4xf7oCrtk1UoA7z
	 WkO0H/Zrm6ZMvrOzNidG3AKXDgIX8OrP7OKI5f0yGcvKRW2D/mHMHWLkmjnbdiy5df
	 3/x/EEk3M++Mg==
Date: Mon, 21 Oct 2024 15:01:47 -0700
Subject: [PATCH 11/37] xfs: add bounds checking to
 xfs_rt{bitmap,summary}_read_buf
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783638.34558.17263401819655377944.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
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

