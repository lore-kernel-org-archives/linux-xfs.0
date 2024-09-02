Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFE919CC0A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301560; cv=none; b=gxKIZ2XXWhjg20embjn0NjvgdwbQBQ8h+DWbPhcEQn44+zxNBPLP32JFNa0G6AGf2fbxVBxcexR6lqwbUhn7YMaodrYMbRNPQUddLkKmSxRp5nYXQwSgLU+Xi24MqsRmJ/MFtMLfhC4MqxTX3mtHLK7PMcCqtRbPsb4FUpvOahs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301560; c=relaxed/simple;
	bh=lgu2W3aursCk2hlJFtwLS2lDg2yJq4YTrKILmZdIY/Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EscI8UZmyvHDXxVoG9cR4DU3JWSyfzm8g6ORDjabExqloEF4aN0Pfs8xrVHNB1AXCvi4E6UemzMfHO9CCcBeAswaO+FwQfsCmlwqyQ/gMDGTdUhhDhJgl5xtvW/9959Ylet0XKoHvKkobycvtSU/1BwvpQthqwrukrIHDxYjvCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BaiMjylg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BaiMjylg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EEEC4CEC7;
	Mon,  2 Sep 2024 18:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301560;
	bh=lgu2W3aursCk2hlJFtwLS2lDg2yJq4YTrKILmZdIY/Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BaiMjylgCwkCwjpX4X4wof6NwTl28fMwoq56ILHbqbbU7U963tNAn5q7eP6Wfwf2d
	 bWmHrAV8qZCNa2d0kjMrw98+RA8Ecp9KP7C7FUKPQ7RSqtv/+oAjfjD/sdTZMBYomb
	 u01BHZujJkkyDoO2jkS39X1UNodYLY2FF3wpInAXH+evWSxEPkfJMjLmbXWhFgcYQz
	 EP2J6UtTFIAPb+LcMPJEuVOABz8LEBndRGhN3IC8AXU3i5aQQf23/UKg0hQYm1l9RS
	 6EtDJdKqkRhBBigHZxuMjLxB7Jm+S8+n2pAutSj0XCDqoUO7RNE2Rvb5ZLU0QVUW3l
	 G31hjvB7dT0AQ==
Date: Mon, 02 Sep 2024 11:25:59 -0700
Subject: [PATCH 08/12] xfs: push the calls to xfs_rtallocate_range out to
 xfs_bmap_rtalloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530105847.3325146.13409655825015257356.stgit@frogsfrogsfrogs>
In-Reply-To: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
References: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
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
index 64ba4bcf6e29..59e599af74f4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -259,9 +259,9 @@ xfs_rtallocate_extent_block(
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
@@ -312,12 +312,8 @@ xfs_rtallocate_extent_block(
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
@@ -371,12 +367,6 @@ xfs_rtallocate_extent_exact(
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
@@ -429,7 +419,6 @@ xfs_rtallocate_extent_near(
 	if (error != -ENOSPC)
 		return error;
 
-
 	bbno = xfs_rtx_to_rbmblock(mp, start);
 	i = 0;
 	j = -1;
@@ -552,11 +541,11 @@ xfs_rtalloc_sumlevel(
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
@@ -1467,9 +1456,12 @@ xfs_bmap_rtalloc(
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
@@ -1497,14 +1489,20 @@ xfs_bmap_rtalloc(
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

