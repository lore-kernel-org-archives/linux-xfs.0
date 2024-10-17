Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091D921D2A3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192128; cv=none; b=CWz5KG4pXTtnuaJCJB0x41JYM8B9w9outHz3JTvRGSLqLQdjEGX2Sm0HT5OmtbuqMJTm/L6EPdGCviIKtf4VPn+tMONFRlZQTmxs9OPXChVJ91uQd5Vk3O4SNSh8XJP447FOvmlA4zk0Hf/78v+q56JX0GVDBQgBWHmFoloXqCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192128; c=relaxed/simple;
	bh=EKQihhf7Eh6eAQJ+TjMakbfZK8gX7J/ZvmXPmhrZ7+0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=exD2YJMWKQAlgD/z8LRAtBFMvEqHLbQVQrosl0g8QZBCvEcGxf1xXafy3O1R7tkWAxXlJR/F3iZ5qK2khnGYf3PzIgd9T2DhSXFz/EUqj27F79omxo/CywQCgaQBj8JCrjlVaE8yd+b4PNizNJYIk2xM/p8oBCHKY7+leBUYONA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4hMRiCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4hMRiCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8752EC4CEC3;
	Thu, 17 Oct 2024 19:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192127;
	bh=EKQihhf7Eh6eAQJ+TjMakbfZK8gX7J/ZvmXPmhrZ7+0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f4hMRiCOZe+skcT/W0To7FuI18NN3vCPeCoEpNZs07BXI5jHS8OIGcq5MkjRph/ah
	 ZDD5ZIPqdsOIlaIwHQOELaQi/Bm9LNnd+FzpZnHQG623gq+A3jazrhqtnqrNlTxHAY
	 Y6xDyPYSoVkrx2HATZBbGGL3EOwf/Y+fGomp47yWz47Ablpwj9POnfL8un4yFHBrBn
	 7jCZc0j4TseBWfebOB3aaIQBULTusnNU0bs4C1iueZkaOGykpfPiOH7/w84GYAjzF0
	 b6TZ9MAZhJy1bHqhKeCH2BmNlPUnxCDi3DWYxn/yG75SODzNS4FWl/6fJy2Eb3Nx6E
	 hon7Umk+vMDtw==
Date: Thu, 17 Oct 2024 12:08:47 -0700
Subject: [PATCH 28/34] xfs: create helpers to deal with rounding xfs_filblks_t
 to rtx boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072152.3453179.3056710287992098812.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We're about to segment xfs_rtblock_t addresses, so we must create
type-specific helpers to do rt extent rounding of file mapping block
lengths because the rtb helpers soon will not do the right thing there.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    2 +-
 fs/xfs/libxfs/xfs_rtbitmap.h |   30 +++++++++++++++++++++---------
 fs/xfs/xfs_exchrange.c       |    2 +-
 3 files changed, 23 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 5abfd84852ce3b..30220bf8c3f430 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1123,7 +1123,7 @@ xfs_rtfree_blocks(
 
 	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
 
-	mod = xfs_rtb_to_rtxoff(mp, rtlen);
+	mod = xfs_blen_to_rtxoff(mp, rtlen);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index dc2b8beadfc331..e0fb36f181cc9e 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -101,6 +101,27 @@ xfs_blen_to_rtbxlen(
 	return div_u64(blen, mp->m_sb.sb_rextsize);
 }
 
+/* Return the offset of a file block length within an rt extent. */
+static inline xfs_extlen_t
+xfs_blen_to_rtxoff(
+	struct xfs_mount	*mp,
+	xfs_filblks_t		blen)
+{
+	if (likely(mp->m_rtxblklog >= 0))
+		return blen & mp->m_rtxblkmask;
+
+	return do_div(blen, mp->m_sb.sb_rextsize);
+}
+
+/* Round this block count up to the nearest rt extent size. */
+static inline xfs_filblks_t
+xfs_blen_roundup_rtx(
+	struct xfs_mount	*mp,
+	xfs_filblks_t		blen)
+{
+	return roundup_64(blen, mp->m_sb.sb_rextsize);
+}
+
 /* Convert an rt block number into an rt extent number. */
 static inline xfs_rtxnum_t
 xfs_rtb_to_rtx(
@@ -126,15 +147,6 @@ xfs_rtb_to_rtxoff(
 	return do_div(rtbno, mp->m_sb.sb_rextsize);
 }
 
-/* Round this rtblock up to the nearest rt extent size. */
-static inline xfs_rtblock_t
-xfs_rtb_roundup_rtx(
-	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtbno)
-{
-	return roundup_64(rtbno, mp->m_sb.sb_rextsize);
-}
-
 /* Round this file block offset up to the nearest rt extent size. */
 static inline xfs_rtblock_t
 xfs_fileoff_roundup_rtx(
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 75cb53f090d1f7..f644c4cc77fac1 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -217,7 +217,7 @@ xfs_exchrange_mappings(
 	 * length in @fxr are safe to round up.
 	 */
 	if (xfs_inode_has_bigrtalloc(ip2))
-		req.blockcount = xfs_rtb_roundup_rtx(mp, req.blockcount);
+		req.blockcount = xfs_blen_roundup_rtx(mp, req.blockcount);
 
 	error = xfs_exchrange_estimate(&req);
 	if (error)

