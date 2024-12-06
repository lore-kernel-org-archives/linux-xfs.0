Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFD71DBB2E
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529598; cv=none; b=n3+SGmiH9WE3dfZWEq3TxZCKD0gucNAE/j8K6e8Dq6KdNoj+LGMfidMcs/iTROmLaKgj14y+AW6bCZ+guPKoZNDB5se0GlRgDjkDTap5lTpq1BgZqJ+ignyycGi3pST2JdNCq8OEZGlFqrD/mV7ivgkWBqqsVTOYsZ+DxH0CHxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529598; c=relaxed/simple;
	bh=BoEuKslmlunmGK9XsqGgfqZZWmFCRaAYMJRoD9pOqNs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OZigmgyKtX4/XPpdvcxxvTb3fkK1Mmscq+HZdcI/0G27cYqTyDihUIG5p3FuNqSDp+bfFa7gZtdK4Nid3JI6cGoNJsQvMVcfq0RrDetvfIXuh+UGR9XHpzi64ByAbZ6vXPHSUFlxzo8fwfgu1d0AnZ395Gjdjah6uc2DdbcfwLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyQ3eKJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyQ3eKJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FDEC4CED2;
	Fri,  6 Dec 2024 23:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529597;
	bh=BoEuKslmlunmGK9XsqGgfqZZWmFCRaAYMJRoD9pOqNs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fyQ3eKJVar7u3qS9txQeRhSm4dnA5/Auv2mNtY/WKSnAe/ARGNGzSlCEq6MzV1xNh
	 2/YvvvYrd+lg03tHN8nz4dQj8gcEGRnKK5pFWLNfyMhvtqjzKxrPGczq5KrV4gQ0A6
	 dpEuHkBVIbLYfr5hsGHsrIeGVmsEzG1Ma8925jeG73UjUHZwf5vp8pQzSIjr4iTv9Y
	 TWBRC4hPubsSRZvygRRS72PR7sEY13E1J5Xhbp9c8hFvmyMPvgqDP1H1LIfONRHeqk
	 2ChHNk+ue+HTQs3YEU9LOKK+heBTiseR9RNrNCmXi+i4vhVlxd2FXeAKEh48Fdld68
	 2gv9LZwaYN/0g==
Date: Fri, 06 Dec 2024 15:59:57 -0800
Subject: [PATCH 33/46] xfs: create helpers to deal with rounding xfs_filblks_t
 to rtx boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750500.124560.16611607999549230755.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 3f0205ebe71f92c1b98ca580de8df6eea631cfd2

We're about to segment xfs_rtblock_t addresses, so we must create
type-specific helpers to do rt extent rounding of file mapping block
lengths because the rtb helpers soon will not do the right thing there.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtbitmap.c |    2 +-
 libxfs/xfs_rtbitmap.h |   30 +++++++++++++++++++++---------
 2 files changed, 22 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 44c801f31d5dc3..e304f07189d3c9 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1119,7 +1119,7 @@ xfs_rtfree_blocks(
 
 	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
 
-	mod = xfs_rtb_to_rtxoff(mp, rtlen);
+	mod = xfs_blen_to_rtxoff(mp, rtlen);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index dc2b8beadfc331..e0fb36f181cc9e 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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

