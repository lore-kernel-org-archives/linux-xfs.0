Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D96384D12
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425052; cv=none; b=USFCnBNp2C7H+BUbYz1zSkTriakMNmspqaYhdYb5P1JPHjEddwiC5D4QcLwJB/U2tfZqz3CcMuWRgJR/CeckADyI4uO4pJg8aLTvKpd5zPDj297L8uxQAfpA5TimWO6P9+2D2UleFGOboUiRCuIdfCmdAXVS98avr3SmA+Fo4LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425052; c=relaxed/simple;
	bh=O6wFp1bs1w4ZiIYBL29uu8x/jA7qxsaZvJp1Se7pifU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oqWbzYi8uKgIS0RP0jnOqSppIv+5rhNO4fezPBHunwWq/o9s7/1XYIgOQbfAvEzpFuUTx1obEo9PFtXnbPy2NQAscrN4aiaY6BljYRCddgNrfaIFC+AUQq1Lfn9a1mNZW7I0Uq3J/rkq6CpnEH5FtmLQvMQ3pK0APxPvckyGCzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HDv3dlo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HDv3dlo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AD4C433F1;
	Tue, 26 Mar 2024 03:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425052;
	bh=O6wFp1bs1w4ZiIYBL29uu8x/jA7qxsaZvJp1Se7pifU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HDv3dlo7rUEEAzPI/yv695mSujc+12pVKkFLWFOghRXKcRpX3+Jd+fSxIYwc4Pfer
	 Pbs8fZxpKywz4CIKJmFT6DD3rOeQ21M5si/xzAptIhbvURb0+bLMJKurjMlk+UxsqG
	 M7/oQ/1JY2NF8Tz21O7vy/N8pL4tT6NmsUDPx7LFouNuy+7fEzO1godhsx7TR56flm
	 j8j0HfKwbAaMY+HmGf5vxUgp8HTvxhvPbATGzq5+6fBxGpCjTjx/PkEywEfiilRaVk
	 bUC35JYEP5iiLiopS/hzyveVHdrDb7R3T7KodfO5l3jP9KP62ltvuzS3QZscqXwHuK
	 iaTovK4uImCnw==
Date: Mon, 25 Mar 2024 20:50:51 -0700
Subject: [PATCH 086/110] xfs: remove xfs_btree_reada_bufs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132618.2215168.619055419488585873.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6324b00c9ecb8d11a157d2a4bc3e5a495534bdf1

xfs_btree_reada_bufl just wraps xfs_btree_readahead and a agblock
to daddr conversion.  Just open code it's three callsites in the
two callers (One of which isn't even btree related).

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   38 ++++++++++----------------------------
 libxfs/xfs_btree.h |   12 ------------
 2 files changed, 10 insertions(+), 40 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 2bef2f3e2bb0..7168a575359a 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -886,27 +886,6 @@ xfs_btree_read_bufl(
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
@@ -937,22 +916,25 @@ STATIC int
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
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 001ff9392804..c48b4fdebafa 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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

