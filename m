Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0900C28FD
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347473; cv=none; b=KvsGNMH6l9GDYF9BNVzkjdAdNQV2YZdRMnztD4EaW+ZJ1sN6ryiqivrf/BI6TnlRrvurkva9E23IPSqNV1HdkCtsF4F7WjrpbNO61JlU+D7s1X8+KZimvOAEuGCiVC161gNvX7Q1EaVkvGrtGtnrwe8qxXq2Fl02bYJnhxdbcnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347473; c=relaxed/simple;
	bh=lFXsi4qk05GXZOaN31A4WrF6ifS4TukzEr5Tv60m0pg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WnyZKV7X2ee95iAQF+25wQmIgHHUWrIByP8xmejU1mM2CoL/lItaWMp7LmjjPVTWSM7sGSb121gsia/kgTEQAe8PlOFIX5u68SQJ8vmZ34Mnbv9b+LIUoHoqOqsyjU0PBMf0hOJ4S0TafLRNsp+ZR46dlFUurswea0al3RYBSEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcyiNDm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcyiNDm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEA2C2BD11;
	Wed, 22 May 2024 03:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347472;
	bh=lFXsi4qk05GXZOaN31A4WrF6ifS4TukzEr5Tv60m0pg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FcyiNDm3ljsqSDTMwY8XKV9r+vlNjf50WHMOBXGiXy9uvwJs78GGMWQvUElJP60wm
	 eJ5oh9FapvXa5qU3l1fS4WQzZQzSbzKRvAH1aRre0MoTGQ4BMB2kpHWLY1sjEJR9jD
	 ZQjLEsQLp6IVzJqaK9LV8BLow6zfjEQ4VmUXgxh7gYo0napDomwLhW/HHq1E28O66Y
	 CFy6kgisNOjUEzeRPgMok/yZmk2AyKdkVzCEb/us+9ou62LxH/OxuEqIqvD/+j/rwl
	 a95GED0fZp32B5gwnqOMzRQbQEJv0pDyVar84JLjuspLWX5y2S00RIVkvRoT3SsKWv
	 SPvxo/sdpuYUA==
Date: Tue, 21 May 2024 20:11:12 -0700
Subject: [PATCH 086/111] xfs: remove xfs_btree_reada_bufs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532989.2478931.5414968158824964422.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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
index 2bef2f3e2..7168a5753 100644
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
index 001ff9392..c48b4fdeb 100644
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

