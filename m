Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C582663D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300560; cv=none; b=VUTHrAhvMZioLuVMtenymxEH+O1oZ5lIWVJ9lBLxcVTkkGM1XnUwVKxFdR4hldse5VpiEqOTQM022SZpss1jFAF2Gxr4lYIPnjpkKW+k+yS6aVA/lB3QzC2Ho6AtfBMRi9syRQdPHLnckZ0s9menBVM4xNkldX3cC0vyT7iIwnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300560; c=relaxed/simple;
	bh=eaz1u6koW/5F9Q4MkPfEsKhV5jakgkGHehq4vmQvHEY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A7gmpVezbFHqu4HkZjCLWoal9XoIJfv0iDqu9VfiE+NCjBF0FB/8qA1yf4w/A+9W8LvONv9G/FJOBFHcJDex+rVZJyRnX1oTsSx+d7NwJ+415neVdXLNhHaRctb7EnvKSt/dLoe3kKFbk5vegjRRWYipKNQWZcWkjXSVTvnQjs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YlJh2Cnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YlJh2Cnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DA3C32786;
	Tue, 30 Jul 2024 00:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300560;
	bh=eaz1u6koW/5F9Q4MkPfEsKhV5jakgkGHehq4vmQvHEY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YlJh2Cnf1UCkFBOdSV07T8DoEb8p/+u3mjNq17m3rNQbQ1fwT2vGUxSf+C1G+pVQ0
	 uRaEkhYR9uFlptiaFnWTFkuAzCSmsIY8DBUNKKOUEmukySUz7LrPlUwjSIoWqUjAiS
	 hbQn4Zmbg4v7yUvlaMFKLgoZF5w8FMtmZV9o8Amm6CNcsmgDqmbHaFyXHaz20lr+nG
	 0vW/vJvzKK5ji0WESiVyLSLotiY49gmL4Yht2kO6EAAN5v6qoDVhPD92YQ7ZYmUJ3H
	 FWz/N8780CygByZKgRrANM5CsuDsTmJnEthZIlLF5sAM3vp+ayRU2Ah7wESUYFzQu5
	 uLuHywQ8PhmAg==
Date: Mon, 29 Jul 2024 17:49:20 -0700
Subject: [PATCH 098/115] xfs: pass the actual offset and len to allocate to
 xfs_bmapi_allocate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843840.1338752.2303408383793496548.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 2a9b99d45be0981536f6d3faf40ae3f58febdd49

xfs_bmapi_allocate currently overwrites offset and len when converting
delayed allocations, and duplicates the length cap done for non-delalloc
allocations.  Move all that logic into the callers to avoid duplication
and to make the calling conventions more obvious.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 87f0a2853..a498894fc 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4179,21 +4179,11 @@ xfs_bmapi_allocate(
 	int			error;
 
 	ASSERT(bma->length > 0);
+	ASSERT(bma->length <= XFS_MAX_BMBT_EXTLEN);
 
-	/*
-	 * For the wasdelay case, we could also just allocate the stuff asked
-	 * for in this bmap call but that wouldn't be as good.
-	 */
 	if (bma->wasdel) {
-		bma->length = (xfs_extlen_t)bma->got.br_blockcount;
-		bma->offset = bma->got.br_startoff;
 		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
 			bma->prev.br_startoff = NULLFILEOFF;
-	} else {
-		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_BMBT_EXTLEN);
-		if (!bma->eof)
-			bma->length = XFS_FILBLKS_MIN(bma->length,
-					bma->got.br_startoff - bma->offset);
 	}
 
 	if (bma->flags & XFS_BMAPI_CONTIG)
@@ -4527,6 +4517,15 @@ xfs_bmapi_write(
 			 */
 			bma.length = XFS_FILBLKS_MIN(len, XFS_MAX_BMBT_EXTLEN);
 
+			if (wasdelay) {
+				bma.offset = bma.got.br_startoff;
+				bma.length = bma.got.br_blockcount;
+			} else {
+				if (!eof)
+					bma.length = XFS_FILBLKS_MIN(bma.length,
+						bma.got.br_startoff - bno);
+			}
+
 			ASSERT(bma.length > 0);
 			error = xfs_bmapi_allocate(&bma);
 			if (error) {
@@ -4680,10 +4679,15 @@ xfs_bmapi_convert_one_delalloc(
 	bma.tp = tp;
 	bma.ip = ip;
 	bma.wasdel = true;
+	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
+
+	/*
+	 * Always allocate convert from the start of the delalloc extent even if
+	 * that is outside the passed in range to create large contiguous
+	 * extents on disk.
+	 */
 	bma.offset = bma.got.br_startoff;
-	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
-			XFS_MAX_BMBT_EXTLEN);
-	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
+	bma.length = bma.got.br_blockcount;
 
 	/*
 	 * When we're converting the delalloc reservations backing dirty pages

