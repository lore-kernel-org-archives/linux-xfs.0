Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DDD28E7
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831864; cv=none; b=cQavUsSvDllH+Fch+8bUkIQErkmrlM3EpXWaZMpcIwcUvJ/xs2ZV9ryBRthWwJEMSRW9qQ++FJG5ExZpXcXzPPuMwT5JS/XW0THl9MfVD9jRl4bT4lsoiGXo51MJobiLp6JsskV7WtNH4gqX0sIK8t8vtiZMneupPweyvYzE/5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831864; c=relaxed/simple;
	bh=94iodd3azOwJJQbDchNPFpypOJ9A0VgF67o1SSh/5Gw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BfQL5v4KCl1IpEh/+V9OIhP/XCsONtG2X30fpsExuPCKoHEkXS97smG2DGNUHBydgRrZgy4VPH9iV9llW3KcKzL39Ck2h3Ol1GJgK4UQJFEnz8LkFRJpoeVBvZu+jBxtgjGxKdg1YapAiKDCe5rW7hL/G4RLrYEMf5OWxTc0JpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pySlrTJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pySlrTJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2500FC4CECD;
	Wed,  2 Oct 2024 01:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831864;
	bh=94iodd3azOwJJQbDchNPFpypOJ9A0VgF67o1SSh/5Gw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pySlrTJ/TICy2YqDJaXm0P1b0U9n0s1z5S3zX1GzvWsbtDNJuQMsNOQu8qsE0Tivj
	 DiX7Z5bIrwKJa080Hks7MSd9SxC50K9VWWT7+b1ZkGc0nOwf/XAYXEeGQieX9E14OL
	 byZeszeaUMa1Fhz+iVopkSDGv0TxlzwXGLgUesrBNxFXOcekuFdXsGNzSlDSLqU0c9
	 71HD+viO7mVX7mmn0qAT4/+BWJ25LlY1cNwVXQsRyaLISKG56hnMnhLTl53Imwx9uD
	 IWBlrT4/DYAJEMazt6LQh7lcT+jiiNWrd+MMxeoFhBGcKW05pC5JxVp2L9cg9UCPJu
	 HfWKl5KX6dpSQ==
Date: Tue, 01 Oct 2024 18:17:43 -0700
Subject: [PATCH 38/64] xfs: remove duplicate asserts in xfs_defer_extent_free
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102354.4036371.3586058958358231090.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 851a6781895a0f6e0ba75168dc7aecc132d13e6a

The bno/len verification is already done by the calls to
xfs_verify_rtbext / xfs_verify_fsbext, and reporting a corruption error
seem like the better handling than tripping an assert anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c |   13 -------------
 1 file changed, 13 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 6f792d280..93e628e8c 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2563,23 +2563,10 @@ xfs_defer_extent_free(
 {
 	struct xfs_extent_free_item	*xefi;
 	struct xfs_mount		*mp = tp->t_mountp;
-#ifdef DEBUG
-	xfs_agnumber_t			agno;
-	xfs_agblock_t			agbno;
 
-	ASSERT(bno != NULLFSBLOCK);
-	ASSERT(len > 0);
 	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(!isnullstartblock(bno));
-	agno = XFS_FSB_TO_AGNO(mp, bno);
-	agbno = XFS_FSB_TO_AGBNO(mp, bno);
-	ASSERT(agno < mp->m_sb.sb_agcount);
-	ASSERT(agbno < mp->m_sb.sb_agblocks);
-	ASSERT(len < mp->m_sb.sb_agblocks);
-	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
-#endif
 	ASSERT(!(free_flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
-	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(type != XFS_AG_RESV_AGFL);
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))

