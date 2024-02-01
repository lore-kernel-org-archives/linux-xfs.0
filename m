Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EABD43AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817350; cv=none; b=gjVPZWs33ik1xaIZNtuPmR/qVmlo8atUJ+zMSp0EIGyP0Oyy+l8tI6/h4NSB3J5zP3apekhZOemziiY1KQw+CknHsl9WSxH9aDAQcd+Fc5jHl/kiP26Tj4dX7LE3oWYcWiQFki44KV/L38AN30vGwNYAs1WQ+wHmsz/D02dMnig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817350; c=relaxed/simple;
	bh=VKSXYSvyRDS43aHANWqGsUAviE4RYrFfCGBc+Of2WlI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n7Ul2PhbPh9mkJg/s9cNFlLvpAkIarQ+fqusz4p1BXIu0agWlEAONDrfMv7XtD4XWCl22TzP58bHT9Lt1z7IYnA3ibvc9EBpxINlkAOGNoo4n9DugysDm7Ab+OMh8OQYchu7OBRTEJe8Q8PCtVUtSyqKQsl599iGAH4Kw84GTPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZV402YaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZV402YaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FB4C433F1;
	Thu,  1 Feb 2024 19:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817350;
	bh=VKSXYSvyRDS43aHANWqGsUAviE4RYrFfCGBc+Of2WlI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZV402YaJJO1a1R/dg39anM8P+B8Gp62uoV4l9lJTmRRgMiQGcYaxrKlG3Z6adpoTV
	 JhzIfcyAK9J0AGRCafre1gRjH9P/pEuST7/GE+rTucTjyJKMeOZnkmoo3kGtDiOqHP
	 A0LAmLex3mSu1Zt15YvJ5AcXbqQ+xYSdfYGblkrlOouNjQsYcd8WmzKjoEY9CmqErY
	 gSbFNKRNgGBNUKTOUaBGzx9YlMnGcHjUU4gZ+oxvKqAyjGMJTDQFSk4mv4bb5zCTaK
	 vOcCAcaWdSg566hF+77siHWSVvV/stMcikMj6UdLhnhPrAGJP6lSKySvupkpsUbytW
	 hpys7t16h1daQ==
Date: Thu, 01 Feb 2024 11:55:49 -0800
Subject: [PATCH 2/4] xfs: remove xfs_btree_reada_bufs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681336162.1608096.14665546318489493405.stgit@frogsfrogsfrogs>
In-Reply-To: <170681336120.1608096.10255376163152255295.stgit@frogsfrogsfrogs>
References: <170681336120.1608096.10255376163152255295.stgit@frogsfrogsfrogs>
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

xfs_btree_reada_bufl just wraps xfs_btree_readahead and a agblock
to daddr conversion.  Just open code it's three callsites in the
two callers (One of which isn't even btree related).

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   38 ++++++++++----------------------------
 fs/xfs/libxfs/xfs_btree.h |   12 ------------
 fs/xfs/xfs_iwalk.c        |    6 ++++--
 3 files changed, 14 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2689cad9b25ab..0f06ee026d9aa 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -889,27 +889,6 @@ xfs_btree_read_bufl(
 	return 0;
 }
 
-/*
- * Read-ahead the block, don't wait for it, don't return a buffer.
- * Short-form addressing.
- */
-/* ARGSUSED */
-void
-xfs_btree_reada_bufs(
-	struct xfs_mount	*mp,		/* file system mount point */
-	xfs_agnumber_t		agno,		/* allocation group number */
-	xfs_agblock_t		agbno,		/* allocation group block number */
-	xfs_extlen_t		count,		/* count of filesystem blocks */
-	const struct xfs_buf_ops *ops)
-{
-	xfs_daddr_t		d;
-
-	ASSERT(agno != NULLAGNUMBER);
-	ASSERT(agbno != NULLAGBLOCK);
-	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
-	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, ops);
-}
-
 STATIC int
 xfs_btree_readahead_fsblock(
 	struct xfs_btree_cur	*cur,
@@ -940,22 +919,25 @@ STATIC int
 xfs_btree_readahead_agblock(
 	struct xfs_btree_cur	*cur,
 	int			lr,
-	struct xfs_btree_block *block)
+	struct xfs_btree_block	*block)
 {
-	int			rval = 0;
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
 	xfs_agblock_t		left = be32_to_cpu(block->bb_u.s.bb_leftsib);
 	xfs_agblock_t		right = be32_to_cpu(block->bb_u.s.bb_rightsib);
-
+	int			rval = 0;
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
-		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-				     left, 1, cur->bc_ops->buf_ops);
+		xfs_buf_readahead(mp->m_ddev_targp,
+				XFS_AGB_TO_DADDR(mp, agno, left),
+				mp->m_bsize, cur->bc_ops->buf_ops);
 		rval++;
 	}
 
 	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLAGBLOCK) {
-		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-				     right, 1, cur->bc_ops->buf_ops);
+		xfs_buf_readahead(mp->m_ddev_targp,
+				XFS_AGB_TO_DADDR(mp, agno, right),
+				mp->m_bsize, cur->bc_ops->buf_ops);
 		rval++;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index d95f521a48a74..5100f84a760c1 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -391,18 +391,6 @@ xfs_btree_read_bufl(
 	int			refval,	/* ref count value for buffer */
 	const struct xfs_buf_ops *ops);
 
-/*
- * Read-ahead the block, don't wait for it, don't return a buffer.
- * Short-form addressing.
- */
-void					/* error */
-xfs_btree_reada_bufs(
-	struct xfs_mount	*mp,	/* file system mount point */
-	xfs_agnumber_t		agno,	/* allocation group number */
-	xfs_agblock_t		agbno,	/* allocation group block number */
-	xfs_extlen_t		count,	/* count of filesystem blocks */
-	const struct xfs_buf_ops *ops);
-
 /*
  * Initialise a new btree block header
  */
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index a36f01b4e23d7..53b643ff7a3fa 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -100,6 +100,7 @@ xfs_iwalk_ichunk_ra(
 	struct xfs_inobt_rec_incore	*irec)
 {
 	struct xfs_ino_geometry		*igeo = M_IGEO(mp);
+	xfs_agnumber_t			agno = pag->pag_agno;
 	xfs_agblock_t			agbno;
 	struct blk_plug			plug;
 	int				i;	/* inode chunk index */
@@ -112,8 +113,9 @@ xfs_iwalk_ichunk_ra(
 
 		imask = xfs_inobt_maskn(i, igeo->inodes_per_cluster);
 		if (imask & ~irec->ir_free) {
-			xfs_btree_reada_bufs(mp, pag->pag_agno, agbno,
-					igeo->blocks_per_cluster,
+			xfs_buf_readahead(mp->m_ddev_targp,
+					XFS_AGB_TO_DADDR(mp, agno, agbno),
+					igeo->blocks_per_cluster * mp->m_bsize,
 					&xfs_inode_buf_ops);
 		}
 		agbno += igeo->blocks_per_cluster;

