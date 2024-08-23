Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD131879
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372064; cv=none; b=gF9I+rxRzrJOfSeQGRRREIGM6jlo6KzUB6+7TRhGcpXKWeaX6Jwgr9kgFkfOgqApUslbOXObARgf3FhnFUkxbaDLh/U6GT85Y6eismOFOEKhDFRxxzxs5ozccmm74gka/1ZZSKAgvBBBrs89xnhByhzyNKxb+z2zb8f4AvVEXrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372064; c=relaxed/simple;
	bh=PXUTngCIRTtOGjIlN6V2CGb4EaMDM5IAG5rhlhov/eE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P3o56ksrZJDpNgqzdVoN4IXugbbMWA5N9pC8qGh2LL+JBcG7NDr0Y00eoBo97L0i87a2MSgrZ1icEsuSTe7vFdEXHSvpey40G2yxP8UvWtaRekfANqCV2rTE3gfj2LViEf1Eg8+ttD3J0A1e9+UJ3lVBWjqirZNnyaKSMOsOyWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lezjBINs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lezjBINs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51808C32782;
	Fri, 23 Aug 2024 00:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372064;
	bh=PXUTngCIRTtOGjIlN6V2CGb4EaMDM5IAG5rhlhov/eE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lezjBINsN3Tsg6zLKYwqYsT9oqteIGW7BWWGweio9CJ32uztnFXsNw3dBNtr7qlsM
	 MBBFwp8QMhjtuEkir9lIC/z5drA0uTnyWFamM8sIdNT+QCf8yxofcUsVXB96QYcXDz
	 14gmOhOlhOsVQLDGmw5h6VaZ8xrglWlDqE+AM2gWDITOOSg059Pq7J6xGqPwxw3Gc7
	 XWhtVxq1kvDf0vOf/YD+2hO7+skA0GKdlKj+sZmiX3sta6ijcB27hr9mxl1h5kZdFI
	 KRTWdPaV2qoEa9unWWSyhmD4Mh8jW0TlQGo1Pge/hGAh4lac2qmaNO3z+BBVWLywi9
	 YWlqAd8AbjkYQ==
Date: Thu, 22 Aug 2024 17:14:23 -0700
Subject: [PATCH 09/10] xfs: remove xfs_rtb_to_rtxrem
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086771.59070.6691827026656065031.stgit@frogsfrogsfrogs>
In-Reply-To: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
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

Simplify the number of block number conversion helpers by removing
xfs_rtb_to_rtxrem.  Any recent compiler is smart enough to eliminate
the double divisions if using separate xfs_rtb_to_rtx and
xfs_rtb_to_rtxoff calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    9 ++++-----
 fs/xfs/libxfs/xfs_rtbitmap.h |   18 ------------------
 2 files changed, 4 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index d7c731aeee12d..431ef62939caa 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1022,25 +1022,24 @@ xfs_rtfree_blocks(
 	xfs_filblks_t		rtlen)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	xfs_rtxnum_t		start;
-	xfs_filblks_t		len;
 	xfs_extlen_t		mod;
 
 	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
 
-	len = xfs_rtb_to_rtxrem(mp, rtlen, &mod);
+	mod = xfs_rtb_to_rtxoff(mp, rtlen);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
 	}
 
-	start = xfs_rtb_to_rtxrem(mp, rtbno, &mod);
+	mod = xfs_rtb_to_rtxoff(mp, rtbno);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
 	}
 
-	return xfs_rtfree_extent(tp, start, len);
+	return xfs_rtfree_extent(tp, xfs_rtb_to_rtx(mp, rtbno),
+			xfs_rtb_to_rtx(mp, rtlen));
 }
 
 /* Find all the free records within a given range. */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 523d3d3c12c60..69ddacd4b01e6 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -86,24 +86,6 @@ xfs_rtb_to_rtxoff(
 	return do_div(rtbno, mp->m_sb.sb_rextsize);
 }
 
-/*
- * Crack an rt block number into an rt extent number and an offset within that
- * rt extent.  Returns the rt extent number directly and the offset in @off.
- */
-static inline xfs_rtxnum_t
-xfs_rtb_to_rtxrem(
-	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtbno,
-	xfs_extlen_t		*off)
-{
-	if (likely(mp->m_rtxblklog >= 0)) {
-		*off = rtbno & mp->m_rtxblkmask;
-		return rtbno >> mp->m_rtxblklog;
-	}
-
-	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, off);
-}
-
 /*
  * Convert an rt block number into an rt extent number, rounding up to the next
  * rt extent if the rt block is not aligned to an rt extent boundary.

