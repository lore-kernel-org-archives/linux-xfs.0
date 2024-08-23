Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B03812
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372018; cv=none; b=q09NeozQ/TPIk17Unn/Que4vTf9UwxJnRJc5H0COJcTyRStGLuCwVYYp0Cw4SwGpIWtn3S7sdtr6VAT6GX7PjIQXqfn5JkomjJEOq3uVWdYH2IlUZbWbYHifX0cbjMIv1GI4rxXW8Xwr3ddzi1CQfJ9gIgOXCsVRl46DTWi2DHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372018; c=relaxed/simple;
	bh=BWeFzsCTGc6Yr05pHWZBS5axnuPXXYXuYOrkwQ5iRa8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oTxJFYjGzVdFHrh1I/lIOTu+AKZagVvHvFSKawsn0GhixMco/WytsC6FXU87RuwSrPLauJropgDWqqr3iDlhLFwGGkxP1efeydJW5Zp2hkm3wbgxGUaR2hoJvxMhAGhcpCCn6KP4p9OrdIo7gePhZz/eYkoic1KgbI1teFvUAfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HeKmVi1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HeKmVi1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818BEC32782;
	Fri, 23 Aug 2024 00:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372017;
	bh=BWeFzsCTGc6Yr05pHWZBS5axnuPXXYXuYOrkwQ5iRa8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HeKmVi1s/P123oHOFT3eZoYkC8KTlRSUaZ8B/bj6/L+8nnh5KZkYNpgZ2zAX8F4TD
	 v82h29f9piOlnnajtVCejy/B6qhCm4HzMZTWJI8dNM/VorqxV2w8A4gFSC/0ukqTLV
	 5tsseB1MG3THSHj7w4i1zaChczs/Fu6zV3k0F2a2DXLQdzKm4cLPDfJegRnV3rOvGh
	 sdnbAnKDawNVBlowZ/H5AU2O0uXqWAV0LYYKdShn4Ti9kB7XvDxtNH3tX4NISQJMhG
	 NOgdCMD1G+7b9jxHaBclmQzME80XuFp5TfJKMyEKPzQ/smnVfoe30EitkZ0wDXbMDO
	 vhS7cqt03OmTA==
Date: Thu, 22 Aug 2024 17:13:37 -0700
Subject: [PATCH 06/10] xfs: clean up xfs_rtallocate_extent_exact a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086720.59070.4961232634716192853.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Before we start doing more surgery on the rt allocator, let's clean up
the exact allocator so that it doesn't change its arguments and uses the
helper introduced in the previous patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 54f34d7d4c199..2fe3f6563cad3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -340,10 +340,10 @@ xfs_rtallocate_extent_exact(
 	xfs_rtxlen_t		prod,	/* extent product factor */
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
-	int			error;
-	xfs_rtxlen_t		i;	/* extent length trimmed due to prod */
-	int			isfree;	/* extent is free */
 	xfs_rtxnum_t		next;	/* next rtext to try (dummy) */
+	xfs_rtxlen_t		alloclen; /* candidate length */
+	int			isfree;	/* extent is free */
+	int			error;
 
 	ASSERT(minlen % prod == 0);
 	ASSERT(maxlen % prod == 0);
@@ -354,25 +354,26 @@ xfs_rtallocate_extent_exact(
 	if (error)
 		return error;
 
-	if (!isfree) {
-		/*
-		 * If not, allocate what there is, if it's at least minlen.
-		 */
-		maxlen = next - start;
-		if (maxlen < minlen)
-			return -ENOSPC;
-
-		/*
-		 * Trim off tail of extent, if prod is specified.
-		 */
-		if (prod > 1 && (i = maxlen % prod)) {
-			maxlen -= i;
-			if (maxlen < minlen)
-				return -ENOSPC;
-		}
+	if (isfree) {
+		/* start to maxlen is all free; allocate it. */
+		*len = maxlen;
+		*rtx = start;
+		return 0;
 	}
 
-	*len = maxlen;
+	/*
+	 * If not, allocate what there is, if it's at least minlen.
+	 */
+	alloclen = next - start;
+	if (alloclen < minlen)
+		return -ENOSPC;
+
+	/* Ensure alloclen is a multiple of prod. */
+	alloclen = xfs_rtalloc_align_len(alloclen, prod);
+	if (alloclen < minlen)
+		return -ENOSPC;
+
+	*len = alloclen;
 	*rtx = start;
 	return 0;
 }

