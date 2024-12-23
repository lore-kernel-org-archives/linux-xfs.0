Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDAB1AB53A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991609; cv=none; b=VbFKj+TEdQ2F99HPGDcs91SaNnRbSUt6TVOiLkU5mF82gXARu6xgN39aPPAQAeFKcKdxbws4LbLpeIPNy1Q8FaLXgNGzNor9wMHJTaNHl9wLS6BEpNUm54BWP81U5Z/6YIOn/SQgSUJ5B9+qFeDtrJF8OQ/F6aq9rDzieXs2Nu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991609; c=relaxed/simple;
	bh=BoEuKslmlunmGK9XsqGgfqZZWmFCRaAYMJRoD9pOqNs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XpdZeO7ZvBCgw2zUIR2Rllw/RaVdUV54LgXJ7gnB5AW2yhP3ol6WtiIt13MDWIhf02rw3m20NIqdjOWfas5VdzK9t+HYx4LVUL+Qjc8jNLFDyByP0mHAXk1BoyvQUvTVGTqE9xUvvZXymWti7Sqzk60ahL6yP4qsRzo9OEFDA3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IJVY8g2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IJVY8g2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F38C4CED3;
	Mon, 23 Dec 2024 22:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991609;
	bh=BoEuKslmlunmGK9XsqGgfqZZWmFCRaAYMJRoD9pOqNs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IJVY8g2VNMAqcaYLeg7FW0UrfSP1e+DFFaS+RQ6dLw905nXL75zpx1UqslB64s9zK
	 ZWmiFKgW4u/OfneKbgY6oM6XH3zWSE7JyoIIO4v4ozQvwBJlVAZbxbykxzF+ay6BAQ
	 7ymwo7011LW1Qoe5PCZOzdy3rf2zJIK6RxBb4Vq1sAk7M/By9MZ8zJ+gAsPJK1y+Nh
	 I/3UJYFhktIVC8ixdHOgdujZNIQkNYDz4Y/uSKKZohqm+vZ6zUQwJkiX0wrJRrpo3M
	 XEVkll53rN8NUvFGQ+qMsWElbAJprJFzWiKrlj5Ud1+NkIXMAL26TVYO+CgRXEUcPC
	 Oxf3cR+ddmPKw==
Date: Mon, 23 Dec 2024 14:06:49 -0800
Subject: [PATCH 33/52] xfs: create helpers to deal with rounding xfs_filblks_t
 to rtx boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943001.2295836.2388416593373018362.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
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

