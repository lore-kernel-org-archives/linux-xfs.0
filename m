Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D8E19F430
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416388; cv=none; b=ez+VAoh6A48LXIyEFn8fi6getJHt23Hgaaw0i5g1aDB0W+VK8bZciEdLWygpQGGx5sRD0KHcJXGy2YiEnc5xKEcrY1kvVA3MR/Kf9B5YQCLSrl/cxSZPhxejH9sWY+JY27mHRnCqYwbUBiHAy1tJSK2iqDntlbn7rJ0O4gKAs6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416388; c=relaxed/simple;
	bh=RqVGnlsjdzM4k+hiPQ00Hj7eqU6yxfXEbY7XmeDmQcI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cquEfgHEweuZ58ZqaetX8yTP+rQavwkMWRQW3iDolG94db7/0N4JRWhDg/RTO3lh+SRAUrYYQXWH89kNIeosYNs/HiL65Ggj2N0hSxGlxc9tRBqRt1X/y1ZvFnHiKtl7q77NyUgbi6jTbURJbVb6p6UtpiVYILHUy4iGZPdZ38U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0fKCB+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0fKCB+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E33C4CEC3;
	Thu, 31 Oct 2024 23:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416388;
	bh=RqVGnlsjdzM4k+hiPQ00Hj7eqU6yxfXEbY7XmeDmQcI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E0fKCB+9ZKWM701bYHUmtTan7JuLiKTdegIkj6OeAdW9sCyEJBsK6YlMeJ17ACGii
	 Tqy1I1589+pCUBWjWskKij6t3vKwiyPFvz/DUGymmGbdTas1w+Kg1ODnXxFocuWIul
	 Q1eHvGy2BK0FZPtgjTjKRUPUTBjm21CPqqQmam7qkEx/Ka8y6YQbvuS8qAs9m2aiGS
	 3mR+f+if3FG6lmWUuObmO5q2+P3zYQZzSDhRUadoB8nYn7FGvkrSh+TBmvx+06d//+
	 PLSU3PLfLbaHpVKO2TkNA5bY8tB8hyUyVOZ6M9Bj1giVzez717LOx4BXk7Ehh6g2It
	 b5Hsl2D2O1PNA==
Date: Thu, 31 Oct 2024 16:13:07 -0700
Subject: [PATCH 17/41] xfs: clean up the ISVALID macro in xfs_bmap_adjacent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566177.962545.15497863708448833258.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 1e21d1897f935815618d419c94e88452070ec8e5

Turn the  ISVALID macro defined and used inside in xfs_bmap_adjacent
that relies on implict context into a proper inline function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |   55 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 23 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1f63dc775ea393..e2267aa1a11d4e 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3106,6 +3106,23 @@ xfs_bmap_extsize_align(
 	return 0;
 }
 
+static inline bool
+xfs_bmap_adjacent_valid(
+	struct xfs_bmalloca	*ap,
+	xfs_fsblock_t		x,
+	xfs_fsblock_t		y)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+
+	if (XFS_IS_REALTIME_INODE(ap->ip) &&
+	    (ap->datatype & XFS_ALLOC_USERDATA))
+		return x < mp->m_sb.sb_rblocks;
+
+	return XFS_FSB_TO_AGNO(mp, x) == XFS_FSB_TO_AGNO(mp, y) &&
+		XFS_FSB_TO_AGNO(mp, x) < mp->m_sb.sb_agcount &&
+		XFS_FSB_TO_AGBNO(mp, x) < mp->m_sb.sb_agblocks;
+}
+
 #define XFS_ALLOC_GAP_UNITS	4
 
 /* returns true if ap->blkno was modified */
@@ -3113,36 +3130,25 @@ bool
 xfs_bmap_adjacent(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
-	xfs_fsblock_t	adjust;		/* adjustment to block numbers */
-	xfs_mount_t	*mp;		/* mount point structure */
-	int		rt;		/* true if inode is realtime */
+	xfs_fsblock_t		adjust;		/* adjustment to block numbers */
 
-#define	ISVALID(x,y)	\
-	(rt ? \
-		(x) < mp->m_sb.sb_rblocks : \
-		XFS_FSB_TO_AGNO(mp, x) == XFS_FSB_TO_AGNO(mp, y) && \
-		XFS_FSB_TO_AGNO(mp, x) < mp->m_sb.sb_agcount && \
-		XFS_FSB_TO_AGBNO(mp, x) < mp->m_sb.sb_agblocks)
-
-	mp = ap->ip->i_mount;
-	rt = XFS_IS_REALTIME_INODE(ap->ip) &&
-		(ap->datatype & XFS_ALLOC_USERDATA);
 	/*
 	 * If allocating at eof, and there's a previous real block,
 	 * try to use its last block as our starting point.
 	 */
 	if (ap->eof && ap->prev.br_startoff != NULLFILEOFF &&
 	    !isnullstartblock(ap->prev.br_startblock) &&
-	    ISVALID(ap->prev.br_startblock + ap->prev.br_blockcount,
-		    ap->prev.br_startblock)) {
+	    xfs_bmap_adjacent_valid(ap,
+			ap->prev.br_startblock + ap->prev.br_blockcount,
+			ap->prev.br_startblock)) {
 		ap->blkno = ap->prev.br_startblock + ap->prev.br_blockcount;
 		/*
 		 * Adjust for the gap between prevp and us.
 		 */
 		adjust = ap->offset -
 			(ap->prev.br_startoff + ap->prev.br_blockcount);
-		if (adjust &&
-		    ISVALID(ap->blkno + adjust, ap->prev.br_startblock))
+		if (adjust && xfs_bmap_adjacent_valid(ap, ap->blkno + adjust,
+				ap->prev.br_startblock))
 			ap->blkno += adjust;
 		return true;
 	}
@@ -3165,7 +3171,8 @@ xfs_bmap_adjacent(
 		    !isnullstartblock(ap->prev.br_startblock) &&
 		    (prevbno = ap->prev.br_startblock +
 			       ap->prev.br_blockcount) &&
-		    ISVALID(prevbno, ap->prev.br_startblock)) {
+		    xfs_bmap_adjacent_valid(ap, prevbno,
+				ap->prev.br_startblock)) {
 			/*
 			 * Calculate gap to end of previous block.
 			 */
@@ -3181,8 +3188,8 @@ xfs_bmap_adjacent(
 			 * number, then just use the end of the previous block.
 			 */
 			if (prevdiff <= XFS_ALLOC_GAP_UNITS * ap->length &&
-			    ISVALID(prevbno + prevdiff,
-				    ap->prev.br_startblock))
+			    xfs_bmap_adjacent_valid(ap, prevbno + prevdiff,
+					ap->prev.br_startblock))
 				prevbno += adjust;
 			else
 				prevdiff += adjust;
@@ -3214,9 +3221,11 @@ xfs_bmap_adjacent(
 			 * offset by our length.
 			 */
 			if (gotdiff <= XFS_ALLOC_GAP_UNITS * ap->length &&
-			    ISVALID(gotbno - gotdiff, gotbno))
+			    xfs_bmap_adjacent_valid(ap, gotbno - gotdiff,
+					gotbno))
 				gotbno -= adjust;
-			else if (ISVALID(gotbno - ap->length, gotbno)) {
+			else if (xfs_bmap_adjacent_valid(ap, gotbno - ap->length,
+					gotbno)) {
 				gotbno -= ap->length;
 				gotdiff += adjust - ap->length;
 			} else
@@ -3244,7 +3253,7 @@ xfs_bmap_adjacent(
 			return true;
 		}
 	}
-#undef ISVALID
+
 	return false;
 }
 

