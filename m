Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F8A19CC04
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301717; cv=none; b=auRKO8cCpjH+6m2Xzbp78G3UpagrM/x5fPXyGvJbjfJRMLdQUhLoZ7zovDLyjxVR05xL+tdFvxDE/rgmNfjfzGPByiGy5aOMu3p2+ecqrFHTwQHuOC/EQLsx1zts6+cVHwqi0rypl/XztKIzOd+3JbX78tudyqNf4jb7hwDpob8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301717; c=relaxed/simple;
	bh=t6tPc6p8TS2/3b/EvqtjVnEdumgRX+NfYyiWT2vFMOk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V3sg9ISjJrku1rBG/yfqWQ0H8OZPWwUvCR9y6UvypiSPVSdg7ab+L9fLyHKjZvJleFyuDe3DL0tF1Cxo3xK8HIl+K97W5zzH4yYLj4l05/YOiKMgp4u6vsUIcB5i3avftiORfR8eYKXyKYPIQ6E9ZID5EUsQQggNhUxcN0xq7iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PhwLH+Vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PhwLH+Vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9569AC4CEC2;
	Mon,  2 Sep 2024 18:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301716;
	bh=t6tPc6p8TS2/3b/EvqtjVnEdumgRX+NfYyiWT2vFMOk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PhwLH+VlVw4RYEIQUVJaghek8bIKVdJQsh44+RYfq4Riej5tSyZ17rRM3gR2YCdAy
	 rRcs+hX8SUmKzFxZ6BeZJyIuPlLXVoAE+VTetZsQftAz8Wvq8JpRbrt937jgPFlsqN
	 fIYXKaD5dKT4kGXp5jtBl2Ui+hNdkAJPcVZe2I1CPVK6lt+LcmhKrUyPcITywoR2xb
	 RyxUrXwm/UnNiCEmgW2KwGgVRDUpW0PX4C2OeMxhDDl8TO9ZzA5NGgQyCGSXj2s7ic
	 PxmnUWGgylx81kRUDHCBBLizV5+OF8o5zfrVRihSnOz92uvGxYufrzhDwj+bVkYnX8
	 W91o882UTa+NA==
Date: Mon, 02 Sep 2024 11:28:36 -0700
Subject: [PATCH 06/10] xfs: clean up xfs_rtallocate_extent_exact a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106357.3325667.17804735130300124284.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
References: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 11c58f12bcb2..af357704895d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -338,10 +338,10 @@ xfs_rtallocate_extent_exact(
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
@@ -352,25 +352,26 @@ xfs_rtallocate_extent_exact(
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

