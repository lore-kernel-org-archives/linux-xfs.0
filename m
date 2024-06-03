Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B5513C9A2
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442069; cv=none; b=L3e6I1GxLEipNCDjGVctCEFz0GTj9gr0dQyuF6LSQvdWt1kS6CauufQvruUDEvWkTbk4cc1feZ/G34XCbEkmKoPo6rgetO0r9peVIQGatzmI/NpWcEfoW7bZrByF3bswLLeDyzxlhl1bY1jpttWcyGaLTH4+qe4lA/qZXegVyzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442069; c=relaxed/simple;
	bh=YKoGg99q2b/ohnpG44flRVszOEyXZ88WqXnbYjq6/DQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pMkwdl/+/dRBMxmxdL2Y2Z0fqkYuP2dApZ0pr7c+9UjxDK3A3m50Y8E72gWYLwBRwWGgan8Ks7v9vgweKoyeUezAJ4Cbvez0V6Mc0kbpB9OZcZ45HEjWqNEAmOLC4LdaRhKCvixJtUpYMXa9klZ2wkxi+I8WCjqMpXSxnEwU2/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hM/FNfpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hM/FNfpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA29DC2BD10;
	Mon,  3 Jun 2024 19:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442068;
	bh=YKoGg99q2b/ohnpG44flRVszOEyXZ88WqXnbYjq6/DQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hM/FNfpZspiTy8C4aTJoYOtiVzaZuqQTIG4vmMej2yMutRBArOpM0vu8j0rVhtuCe
	 cIVQhEEqjnB0Je5XooNhx2iTH4yedPOgjMkh8HZ6/bDPr0VqFgoe2HPh2oF4nB79JR
	 JW9KBqzziiwKtX+psDsWIX/Z/o9yuw97lIBNexSwAFzWPGBVCdG4OpjcbTAwo0g6dl
	 ukrzw9Iv3rynRYr14jrALx1TVbZ8Py0MPs7G8gCCcd3w97DhqWJlG5L8hYdvTIDMvr
	 Y7WEhP9doBdsbSQAX9ULKs6azrMSLoWWc8R1Ez6XFQ/bbrxmFwdzGD08BqFA9av5SY
	 zoPvDzeU/LqNg==
Date: Mon, 03 Jun 2024 12:14:28 -0700
Subject: [PATCH 086/111] xfs: remove xfs_btree_reada_bufs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040657.1443973.2863911770127321307.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

