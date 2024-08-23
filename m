Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DA619E
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371861; cv=none; b=Wjq1UiSemOgJVJgGPZOs768V3D8OoCkFDQOQjIMl9IbeGj0D2mAoCH22WbtZ0UovHQb9Z6X5BCN1oMDIXwBkOJRBHPYgJefUS+91/kCPWkQ2C5T3i/1hl4F3Y205wRk228Cn+1LICaaZpRfAHeCI3Ear/xjuf4kWQ7yZbgFNmjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371861; c=relaxed/simple;
	bh=Jb6oyT0bHIIh5pcdl6ot7lwnPxbmcS0wdBQiFWX/SqA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aGXE8PHYpQwcw4NQFew5+5JSP8c2p21dJ/+tRLPZbwne1/Q5tYYBoaCz/zjzoY4dSU+d9u/GEGq7Ish/HSJpIQcxoVkfSfDJQjhdn2ZBBxOitDHcgkIamc2yOve8hINmypoYJ2pByPxQRTmfyZz9rlmoyj6h+CcsWwXvg1rWMo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPRn3W+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPRn3W+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F5DC32782;
	Fri, 23 Aug 2024 00:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371861;
	bh=Jb6oyT0bHIIh5pcdl6ot7lwnPxbmcS0wdBQiFWX/SqA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BPRn3W+NLHLHp9A2DVNzofJKOSMfkV0HDY3dDUk50h+61MyU5eCWHdugDIshZ6zqF
	 KNSW1cTc3jcsjXrkOLIw8gOVK2kWwnZ8opWf4opkoBdbWVHUoyYTdFTGTbQEI1st1j
	 B95398+9x/RTqyTQy8NPD1j+a0MdlDtZYR7TkcI09q70OqV37oyeXlDd43sXbsgsEi
	 1pV5WDshXLDj8kG9aHbBnyfAQRAtOgkjhJhfKNtFM1aDPbT5JEdd0uB6B6m1YfBIXA
	 7RHZ6nj09QEfKpH83GQZ+ffSFaAbOM/hrUFdViSobztUa7wOQR7q5HdO6Tobb0F38A
	 KkHSfmcDEPl3g==
Date: Thu, 22 Aug 2024 17:11:00 -0700
Subject: [PATCH 08/12] xfs: push the calls to xfs_rtallocate_range out to
 xfs_bmap_rtalloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086157.58604.7854626171219976171.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
References: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
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

Currently the various low-level RT allocator functions call into
xfs_rtallocate_range directly, which ties them into the locking protocol
for the RT bitmap.  As these helpers already return the allocated range,
lift the call to xfs_rtallocate_range into xfs_bmap_rtalloc so that it
happens as high as possible in the stack, which will simplify future
changes to the locking protocol.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8da59d941db3c..a98e22c76280b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -261,9 +261,9 @@ xfs_rtallocate_extent_block(
 			/*
 			 * i for maxlen is all free, allocate and return that.
 			 */
-			bestlen = maxlen;
-			besti = i;
-			goto allocate;
+			*len = maxlen;
+			*rtx = i;
+			return 0;
 		}
 
 		/*
@@ -314,12 +314,8 @@ xfs_rtallocate_extent_block(
 	}
 
 	/*
-	 * Allocate besti for bestlen & return that.
+	 * Pick besti for bestlen & return that.
 	 */
-allocate:
-	error = xfs_rtallocate_range(args, besti, bestlen);
-	if (error)
-		return error;
 	*len = bestlen;
 	*rtx = besti;
 	return 0;
@@ -373,12 +369,6 @@ xfs_rtallocate_extent_exact(
 		}
 	}
 
-	/*
-	 * Allocate what we can and return it.
-	 */
-	error = xfs_rtallocate_range(args, start, maxlen);
-	if (error)
-		return error;
 	*len = maxlen;
 	*rtx = start;
 	return 0;
@@ -431,7 +421,6 @@ xfs_rtallocate_extent_near(
 	if (error != -ENOSPC)
 		return error;
 
-
 	bbno = xfs_rtx_to_rbmblock(mp, start);
 	i = 0;
 	j = -1;
@@ -554,11 +543,11 @@ xfs_rtalloc_sumlevel(
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
 	xfs_fileoff_t		i;	/* bitmap block number */
+	int			error;
 
 	for (i = 0; i < args->mp->m_sb.sb_rbmblocks; i++) {
 		xfs_suminfo_t	sum;	/* summary information for extents */
 		xfs_rtxnum_t	n;	/* next rtext to be tried */
-		int		error;
 
 		error = xfs_rtget_summary(args, l, i, &sum);
 		if (error)
@@ -1473,9 +1462,12 @@ xfs_bmap_rtalloc(
 		error = xfs_rtallocate_extent_size(&args, raminlen,
 				ralen, &ralen, prod, &rtx);
 	}
-	xfs_rtbuf_cache_relse(&args);
 
-	if (error == -ENOSPC) {
+	if (error) {
+		xfs_rtbuf_cache_relse(&args);
+		if (error != -ENOSPC)
+			return error;
+
 		if (align > mp->m_sb.sb_rextsize) {
 			/*
 			 * We previously enlarged the request length to try to
@@ -1503,14 +1495,20 @@ xfs_bmap_rtalloc(
 		ap->length = 0;
 		return 0;
 	}
+
+	error = xfs_rtallocate_range(&args, rtx, ralen);
 	if (error)
-		return error;
+		goto out_release;
 
 	xfs_trans_mod_sb(ap->tp, ap->wasdel ?
 			XFS_TRANS_SB_RES_FREXTENTS : XFS_TRANS_SB_FREXTENTS,
 			-(long)ralen);
+
 	ap->blkno = xfs_rtx_to_rtb(mp, rtx);
 	ap->length = xfs_rtxlen_to_extlen(mp, ralen);
 	xfs_bmap_alloc_account(ap);
-	return 0;
+
+out_release:
+	xfs_rtbuf_cache_relse(&args);
+	return error;
 }

