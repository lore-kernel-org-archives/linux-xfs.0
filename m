Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DA63D7A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301795; cv=none; b=DlPui11EoEOLz/MF3t9N8smBJ6QuElTp9hrhxBcjc6/aaGvc/Chv8smTxZw5YYLE6kCfsccGBlnnWAQYZIdvamTPj2ruMCSE1sJVaWoxYEojx5p3xnCXDiogtcGq1VfmwLQjkoXPCSW1/oHG1k88bD36Qf6G8EXEHPoSKoc8IFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301795; c=relaxed/simple;
	bh=6uJO1MkRj8qVzQaLs2DBsb6oKmHaUCi0NI2/K0VHn1Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xso4j9Pkt0dr1eWt0Mcv7+rTzrZWN5xqnuCUiGJIAWGeozSy5iDntICzlNjrn37WRhOAJR9J/EmCJkpOI0JBpUsOyui0Q7XEee/XZr0jCDSimsDWXUY0GmOhQ7xliAwzwZ8tQd23HF4DQmt9nHJob+T2GMrRRpivdWi0RFP/53c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tWUHFNDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tWUHFNDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C0FC4CEC2;
	Mon,  2 Sep 2024 18:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301794;
	bh=6uJO1MkRj8qVzQaLs2DBsb6oKmHaUCi0NI2/K0VHn1Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tWUHFNDMeXZxkTjvHzVDQ7EJaR2vi8iOcn3KzFQ7yYXaSS/98x6SBrPIaPAVXUuFZ
	 ht+gPpu6YOh7IGqlxctn2lDAgl94v/ZjvUdsaqwKl7+5ABbbxuGH+sYrWatsMQAprC
	 QwTzGzpKhRHP0QTxSd+ZNt7RSD8NgZMona0YuP/O94z++KFp2Rtg7kYg5YAGb3L3Xr
	 fXPrT3NxhsWOZFtsgk4sa670j8hJqQ2SJiXAEUEjfOKJ1u7WXX0n2GnNiO7YmLhGm4
	 xAK2oTlF7XxpRU4GcUnXRhmcvaB21e7PqupMzZKEDHlAE58w8RJLu4IdJArSSCh+0y
	 EDRo1Ihyg2hpQ==
Date: Mon, 02 Sep 2024 11:29:54 -0700
Subject: [PATCH 01/10] xfs: clean up the ISVALID macro in xfs_bmap_adjacent
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106785.3326080.12914405736026411956.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
References: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
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

Turn the  ISVALID macro defined and used inside in xfs_bmap_adjacent
that relies on implict context into a proper inline function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   55 +++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 112c7ee2d493..434433ed29dc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3112,6 +3112,23 @@ xfs_bmap_extsize_align(
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
@@ -3119,36 +3136,25 @@ bool
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
@@ -3171,7 +3177,8 @@ xfs_bmap_adjacent(
 		    !isnullstartblock(ap->prev.br_startblock) &&
 		    (prevbno = ap->prev.br_startblock +
 			       ap->prev.br_blockcount) &&
-		    ISVALID(prevbno, ap->prev.br_startblock)) {
+		    xfs_bmap_adjacent_valid(ap, prevbno,
+				ap->prev.br_startblock)) {
 			/*
 			 * Calculate gap to end of previous block.
 			 */
@@ -3187,8 +3194,8 @@ xfs_bmap_adjacent(
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
@@ -3220,9 +3227,11 @@ xfs_bmap_adjacent(
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
@@ -3250,7 +3259,7 @@ xfs_bmap_adjacent(
 			return true;
 		}
 	}
-#undef ISVALID
+
 	return false;
 }
 

