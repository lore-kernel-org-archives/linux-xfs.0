Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226851FDFA0
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548171; cv=none; b=juu+UYvY5y3XeNIupP8uZHBJdsiFiElVl4rSA8ZHet2kp1B+SdoAvy6d61+A1H+/b5KUe0CYy33HiwifxUfLFSvE11AgOqPBZKgNbWiGNwrT2hIMFvjEcGpMYZEMd+ZBWYL2nstVt2KCkBZy89kK9b0G5pr0mvz5M9XMxF9N5Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548171; c=relaxed/simple;
	bh=AuqRh3OrtuH/JvbRD6WrnZHL53jxm6CypTiWutKsO5U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NkUpRp1ikgVTbmGF+y80pJNggzT0Hve6z7mWtHwvS/LjKzM0nBr0er9uI2ZdeQouWcIzyF/I923ENVHlXAABpJe4AKu163ICkiprS0qrOjy5ztTKkm9bYEpIWmvq9Mmyzu0YwumWmSgf9sony2W4tixfpOkjhxTcJABva89q7Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngw5kZUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngw5kZUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F037AC4CEC3;
	Mon, 21 Oct 2024 22:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548171;
	bh=AuqRh3OrtuH/JvbRD6WrnZHL53jxm6CypTiWutKsO5U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ngw5kZUorJCOs1w54zP7KoaTD5hLvjDHp+PNXaRe9CGKeXKkCfR+/efUpTzdxY3Zz
	 wyPAg3yQrjNfEyD8ltxOX92jaB1ZifJrqjkQ7DTIKQE8ZVa4mwFDHf3hr8vDAI97jJ
	 NRxXbslNvX9hXz8m4q+x+e3HuzFlFs+vWqhJ4LPOBsanlwxwxcLYkA1/VQYQAf1cxt
	 tNBJtWVjGqUSnqYl0EX+IVm0Z1fUls5Rl+A5nCmIBytHFhI4CdnnzZ5YL7B9QMej9I
	 /8pJlXQYtFSsqCFzRTcnL4HLPxdsJhlaR9kdlVrvi1/f18g2M1jZ/05kjIkb7HVMP/
	 vhREw9h2nHbLA==
Date: Mon, 21 Oct 2024 15:02:50 -0700
Subject: [PATCH 15/37] xfs: remove xfs_rtb_to_rtxrem
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783698.34558.6399418785062063785.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: fa0fc38b255cc88aef31ff13b5593e27622204e1

Simplify the number of block number conversion helpers by removing
xfs_rtb_to_rtxrem.  Any recent compiler is smart enough to eliminate
the double divisions if using separate xfs_rtb_to_rtx and
xfs_rtb_to_rtxoff calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.c |    9 ++++-----
 libxfs/xfs_rtbitmap.h |   18 ------------------
 2 files changed, 4 insertions(+), 23 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index c86de2aa13cea9..74029d4431e1ca 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1020,25 +1020,24 @@ xfs_rtfree_blocks(
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
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 523d3d3c12c608..69ddacd4b01e6f 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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

