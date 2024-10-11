Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0888E567D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608939; cv=none; b=QzSyyTCY8HsonZvzwrXGtd3rxW5Z5tUqa0c9ESyFP5Nh/bEZ2J4zrtaH4UbKgrWw8OKmN4zKgPbvBGqn5od2KFMByrc9rilZyZep2FKfBkd7/76cStiTZpqiFrAIN+gYsDheU5B9g9jEwjsUL9qJx5EKSe1Tv03S5Kqocy+HrQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608939; c=relaxed/simple;
	bh=FdOQMItjBst0iJQArj2Avd6jFoJ6ztVBRk0yeOb4W/4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YLXvDI7cbC06ffi8nguNGcBTTtM9MRu6GBrNCeRq5Xqh+tT146wA+6p95uIKBEOp+1zjFbXGnSmQ/50uTo9LXa9SXaGXvm42BOzABTdzKi0fTNtylArtj01kMs811eILGKM4ilxoUToAXr0Sf/DQM+z9vnxoLOTkLKbyOfmuDjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IyPVRsEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IyPVRsEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1364C4CEC5;
	Fri, 11 Oct 2024 01:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608938;
	bh=FdOQMItjBst0iJQArj2Avd6jFoJ6ztVBRk0yeOb4W/4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IyPVRsEW2TIdlrj3l2KYsGJapVbzRWHIjmcG2yb8XYe1ykOGdHuKD+USz/Swrsnfe
	 pVITjb3GGayVQuvEaq0/76qrIJBkWC5c/n4FaCTzrjycs+4pQzhBOUtU0dlNL8iCtw
	 Jqk4IuLMeFYSA/2Fa5yNIqdtCDq96ApLMHGuPohq1EqZ15+B11MHKjjhho/YaW06t4
	 6ds5L6LTD59qW9Ojz7PnylbGBeijvTUrskVnhgxhl6hZfL9IKsY78eS3+eZbTLxmYT
	 HACicIbTZe000n81ltRl8oFPD0a4t8K9e3Nha+quMp5FGtr1Xo3zIh/VZN19GHIMhK
	 jaz59+s4wq+tA==
Date: Thu, 10 Oct 2024 18:08:58 -0700
Subject: [PATCH 28/36] xfs: create helpers to deal with rounding xfs_filblks_t
 to rtx boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644724.4178701.12176129713765329444.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

