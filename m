Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1B14688
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372095; cv=none; b=gunGmVBBAvLSxHjX37urBK5mPXxvUntVYRxE3iBAUNS+RuMt++ZhPQtsRoNxqcPgdEaSi49jl5/3WrF6hZWN+9rwo9MR6VlpNnYC7JaPa235MiSJBWV8JLMHIy2mjDimbK+TtI59obsy9yTJMTU0LPQVdWMv5lIr3mUnQ0KBEWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372095; c=relaxed/simple;
	bh=JbF7w8/OyCN4RPnonSFZraZk9qjmU9jy6fCnYPU9aMQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eIOAbLG+AeuCZDERGWmyHKdzyT3Ii3IZicyEj+D2sBlXOEKxI2GzkegrY77QMPyjMuJaoWxuwwJOSp7PPdlIOsfzO5oySPkcgC0uvYy3Lsxk6cR5rSOMtS4bLyNS4UzAPW/9iz+JRST/2oazE9fIkzYNU3ycFBtiyieBGsoOMvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tPUiZVsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tPUiZVsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764B9C32782;
	Fri, 23 Aug 2024 00:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372095;
	bh=JbF7w8/OyCN4RPnonSFZraZk9qjmU9jy6fCnYPU9aMQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tPUiZVsl3aPNkDMdUgTYlzjsI3JC/paq1D3RaksUutjCDWn2e2rBqZK3h6VztTtb+
	 yiiFulmePLliBqzsW1MCRLCB0m6ruvqkpVLpPQ2UqHPqhbpjVbhzJnJKESofLAI7e3
	 AIGjvvG1PMGAbq/Lm3V009hR0trhuOWlvDl3zy5vmOfsfKoaOkRKqAJhasGDjfpJ0t
	 W4bUVtEnsUYXqKyoLVD788jLNEVRgV8kKBGtdRX5Gxt1AD0f5Aa6RqS1+89r4lRZM6
	 7Se5M6nC6lMy8PGCtdi97vddSCqpunhQIObyGtnkvJqyKiESIJqL+CzGlYzPbgVUY7
	 d/Ga+2AKj6Ttg==
Date: Thu, 22 Aug 2024 17:14:55 -0700
Subject: [PATCH 01/24] xfs: clean up the ISVALID macro in xfs_bmap_adjacent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087261.59588.1337508214006211237.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
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
index 314fc7d55659a..3a8796f165d6d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3115,6 +3115,23 @@ xfs_bmap_extsize_align(
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
@@ -3122,36 +3139,25 @@ bool
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
@@ -3174,7 +3180,8 @@ xfs_bmap_adjacent(
 		    !isnullstartblock(ap->prev.br_startblock) &&
 		    (prevbno = ap->prev.br_startblock +
 			       ap->prev.br_blockcount) &&
-		    ISVALID(prevbno, ap->prev.br_startblock)) {
+		    xfs_bmap_adjacent_valid(ap, prevbno,
+				ap->prev.br_startblock)) {
 			/*
 			 * Calculate gap to end of previous block.
 			 */
@@ -3190,8 +3197,8 @@ xfs_bmap_adjacent(
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
@@ -3223,9 +3230,11 @@ xfs_bmap_adjacent(
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
@@ -3253,7 +3262,7 @@ xfs_bmap_adjacent(
 			return true;
 		}
 	}
-#undef ISVALID
+
 	return false;
 }
 

