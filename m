Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C98612BEB2
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998973; cv=none; b=ektbxU5oQcK320NeSqUfA6TvIgESnLedYVjXWSYRUnoTNb7q1ZDOe31UfN7B0JC7SvfJ1Z9IBGs4qEQTk5sfKKPqnbieQGfWYstBEapEILLBTwlJ/vyNb/Bk55+/mcUDKAp4p0wei8yaLOQwwL6cz01z6N+UMsAFId1Z82GAF28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998973; c=relaxed/simple;
	bh=0H7VqrmcTBcTq0KZc0Bp0rVhfWS4fIbvu8K87pnwH7g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wb6EBNPd6L1ypY08TDmFbByE2CWkHYC4jgD8mAUNBEkT8r58GgUIZNxCJwuzqnKM7bC2ijYGUnaLDTy27r/MBlPFHxHZMGyJ4IaYPabiM4l9dLsPCepZyT16DTwOLRlx+GbGPGXcjtIGnYPUwvJVNOSTjpra16BLNXAYTSUdusw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HI5BHLrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HI5BHLrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E89C433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998973;
	bh=0H7VqrmcTBcTq0KZc0Bp0rVhfWS4fIbvu8K87pnwH7g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HI5BHLrICcjeyfHZH0uKUGIJms4bdjEpigxfkCm8XBWuRi2I5f2JV/BbOQgYzUZMF
	 j2iaNLEC/o6bmeBi5qeTx68je3JVwvegpjGAgGFyWt8KNhiKXXIZ5PeEqkoMXFGcDU
	 tltft0U5vpFf79FkCKXkmvOonEBYbI18OAmMbZ5hIu+TS0p0TE0O+bdEZEEjHHn0aw
	 4P31oSrC/vxRHdiJLICzNexhjQFfwVPttlwilRgl73qXKQgxpIEaQ9RR4IgTbxR1DB
	 OAV1mak5EH5dKsL69lcMKSTnir5DlsLLPeLBE9tvAcNuVNpR1pGTKgoMPaDINXHNYT
	 3wwDsMZiRkO2w==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 17/35] xfs: convert the rtbitmap block and bit macros to static inline functions
Date: Thu, 15 Feb 2024 13:08:29 +0100
Message-ID: <20240215120907.1542854-18-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 90d98a6ada1da0f8797ff3f5adafd175dd8c0a81

Replace these macros with typechecked helper functions.  Eventually
we're going to add more logic to the helpers and it'll be easier if we
don't have to macro it up.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_format.h   |  5 -----
 libxfs/xfs_rtbitmap.c | 30 +++++++++++++++---------------
 libxfs/xfs_rtbitmap.h | 27 +++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 20acb8573..0e2ee8202 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1155,11 +1155,6 @@ static inline bool xfs_dinode_has_large_extent_counts(
 	((xfs_suminfo_t *)((bp)->b_addr + \
 		(((so) * (uint)sizeof(xfs_suminfo_t)) & XFS_BLOCKMASK(mp))))
 
-#define	XFS_BITTOBLOCK(mp,bi)	((bi) >> (mp)->m_blkbit_log)
-#define	XFS_BLOCKTOBIT(mp,bb)	((bb) << (mp)->m_blkbit_log)
-#define	XFS_BITTOWORD(mp,bi)	\
-	((int)(((bi) >> XFS_NBWORDLOG) & XFS_BLOCKWMASK(mp)))
-
 #define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
 #define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
 
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 48e709a28..540cb1481 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -109,12 +109,12 @@ xfs_rtfind_back(
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
-	int		word;		/* word number in the buffer */
+	unsigned int	word;		/* word number in the buffer */
 
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
 	if (error) {
 		return error;
@@ -123,7 +123,7 @@ xfs_rtfind_back(
 	/*
 	 * Get the first word's index & point to it.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = start - limit + 1;
@@ -284,12 +284,12 @@ xfs_rtfind_forw(
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
-	int		word;		/* word number in the buffer */
+	unsigned int	word;		/* word number in the buffer */
 
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
 	if (error) {
 		return error;
@@ -298,7 +298,7 @@ xfs_rtfind_forw(
 	/*
 	 * Get the first word's index & point to it.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = limit - start + 1;
@@ -545,12 +545,12 @@ xfs_rtmodify_range(
 	int		i;		/* current bit number rel. to start */
 	int		lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask o frelevant bits for value */
-	int		word;		/* word number in the buffer */
+	unsigned int	word;		/* word number in the buffer */
 
 	/*
 	 * Compute starting bitmap block number.
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	/*
 	 * Read the bitmap block, and point to its data.
 	 */
@@ -562,7 +562,7 @@ xfs_rtmodify_range(
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	first = b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
@@ -728,7 +728,7 @@ xfs_rtfree_range(
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(start - preblock),
-			XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
+			xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -740,7 +740,7 @@ xfs_rtfree_range(
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(postblock - end),
-			XFS_BITTOBLOCK(mp, end + 1), -1, rbpp, rsb);
+			xfs_rtx_to_rbmblock(mp, end + 1), -1, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -751,7 +751,7 @@ xfs_rtfree_range(
 	 */
 	error = xfs_rtmodify_summary(mp, tp,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
+		xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
 	return error;
 }
 
@@ -779,12 +779,12 @@ xfs_rtcheck_range(
 	xfs_rtxnum_t	lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
-	int		word;		/* word number in the buffer */
+	unsigned int	word;		/* word number in the buffer */
 
 	/*
 	 * Compute starting bitmap block number
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	/*
 	 * Read the bitmap block.
 	 */
@@ -796,7 +796,7 @@ xfs_rtcheck_range(
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 3686a53e0..5c4325702 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -131,6 +131,33 @@ xfs_rtb_rounddown_rtx(
 	return rounddown_64(rtbno, mp->m_sb.sb_rextsize);
 }
 
+/* Convert an rt extent number to a file block offset in the rt bitmap file. */
+static inline xfs_fileoff_t
+xfs_rtx_to_rbmblock(
+	struct xfs_mount	*mp,
+	xfs_rtxnum_t		rtx)
+{
+	return rtx >> mp->m_blkbit_log;
+}
+
+/* Convert an rt extent number to a word offset within an rt bitmap block. */
+static inline unsigned int
+xfs_rtx_to_rbmword(
+	struct xfs_mount	*mp,
+	xfs_rtxnum_t		rtx)
+{
+	return (rtx >> XFS_NBWORDLOG) & XFS_BLOCKWMASK(mp);
+}
+
+/* Convert a file block offset in the rt bitmap file to an rt extent number. */
+static inline xfs_rtxnum_t
+xfs_rbmblock_to_rtx(
+	struct xfs_mount	*mp,
+	xfs_fileoff_t		rbmoff)
+{
+	return rbmoff << mp->m_blkbit_log;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
-- 
2.43.0

