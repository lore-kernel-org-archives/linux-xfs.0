Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE431CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846232; cv=none; b=CVQgTqlslzPIjhwkO8HLkdvWepOV5/nJGdG1VC89cM2Rq3mVTTCwawErHhBPs2xyhnfQptAXmEa0YPXhFXLJgwV9OO34u51o/0Uqqy4GdzMdMrukAbYYv2Ob3jErhV4e1rrlGti2qLMqkckhYgSmPAFGExwavX07jcOVzDZsXqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846232; c=relaxed/simple;
	bh=EKQihhf7Eh6eAQJ+TjMakbfZK8gX7J/ZvmXPmhrZ7+0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V4YW0Xxb/vprmCRsyNf/KJwi/F8kxtGs/kG5OQzFNiWniEp5S+eaFoiXSEY17GgeiI8hdpkj6HjVvtRUAn6wUvMsaud4fmuiJKn/0RIhpURXlOvEFeXfqXRV9xPYH9PuHQWUvqXxPfNd1wPnnQbDTGi9WVyHGfVFiNQcvMnq6CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qkMf4k0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qkMf4k0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6536C4CECF;
	Tue,  5 Nov 2024 22:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846231;
	bh=EKQihhf7Eh6eAQJ+TjMakbfZK8gX7J/ZvmXPmhrZ7+0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qkMf4k0dGG7HdVDQAoan6Z1gngoSQoJAHC3H3AeHFKdRV1calX7daMQjbbY2z1VJ2
	 9UEV95CR94HxF6NzCLf2mZ23IZ3TTloqW5dWHiEyIBtizHVN8iFqW1Q0EpQ34QE3oy
	 3u1sAszNIWDLSwgR1oNPZGjyuacOaLJZ1yazWK4vcn68zsSw0BrHpsauMnTaKXKvk6
	 N+iIFMkXRqTnjJdMvLlswNlcF7tm5L4foBh3C6XwIJvDyQ9gj0EtK3Rb9fpFWvpm8+
	 7GuFejBic2UWwmuPsuqHYkfQBws+D0cFy5DCMwOhDtcvz/9nGqhaUPTeoEk1N5XSc7
	 WqdL2o1ViL85A==
Date: Tue, 05 Nov 2024 14:37:11 -0800
Subject: [PATCH 28/34] xfs: create helpers to deal with rounding xfs_filblks_t
 to rtx boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398662.1871887.3438969603618970618.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
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

