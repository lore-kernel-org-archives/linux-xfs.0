Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18434C89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347457; cv=none; b=MqFdLYqfUQnwENB2dVAWbnDl0k2PkGwRMBuIyu0+mGIHtmZZiiRFu3deM6lB0I3+BbTMFivongTIlu5f8N6TkHFyNYBbKrY10Ygyix4vrXztDxPw/c3PyRU5lpFlcx0sZF4A4bq/p3cjfUalN4YyJI7RfwGvApaA8thcC9UxsKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347457; c=relaxed/simple;
	bh=ykI869aWevtCYXc2hewVAPtnYFMhPRFNaPGYR7c5xHU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aefm7e6NnzH6Jb+V6y8X7080CC5M2hjBtV9Xw7fHhAWKuggkbEvyUwFUArxK/TISWImCcGY/lHiAZboneIVATppOMN3urcFNLBzVLTLE1BlNKn5+pIuZB41m8QjdvdT0BFXICWlXXSH5NkPbziS4QxCWgJz8rYKpOAvOFtP14sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQWro9zS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQWro9zS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3524AC2BD11;
	Wed, 22 May 2024 03:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347457;
	bh=ykI869aWevtCYXc2hewVAPtnYFMhPRFNaPGYR7c5xHU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gQWro9zSObTIvkBwAqbounwTOfOA1AI6abzz5M4ZsadM1FeWVr+xXwBKpXUCCzR9h
	 hV9zCga1nq9XHb8MxTSMnjhvxuhOFMlIK8lPx/RHCLOyk0nYL5hD5cGoF20XbyJsvY
	 GfWp9dJOqJxTAkz9OXDIlvcYQVb5gtafNUqVFsz9FHC7Ebt7mqBxrF6keU4R658c5l
	 mCM663xDmGeg77vjXW7D7SMqf6Mi9zpEDbGgxgdC6H8uUEImNdiQxoSWFXMPlPDezc
	 WlIq+MT3AymYymu4jxZuqh2Nv8C3Yn3fVd1fuzwZ3GOQUyRfxfSHLl2u8vC4qQH4pS
	 zp/K38FnusI+g==
Date: Tue, 21 May 2024 20:10:56 -0700
Subject: [PATCH 085/111] xfs: remove xfs_btree_reada_bufl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532974.2478931.15872771883576964255.stgit@frogsfrogsfrogs>
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

Source kernel commit: 5eec8fa30dfa548d07332756101053f47f6ba26c

xfs_btree_reada_bufl just wraps xfs_btree_readahead and a fsblock
to daddr conversion.  Just open code it's two callsites in the only
caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   30 ++++++------------------------
 libxfs/xfs_btree.h |   11 -----------
 2 files changed, 6 insertions(+), 35 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 6b1839243..2bef2f3e2 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -886,25 +886,6 @@ xfs_btree_read_bufl(
 	return 0;
 }
 
-/*
- * Read-ahead the block, don't wait for it, don't return a buffer.
- * Long-form addressing.
- */
-/* ARGSUSED */
-void
-xfs_btree_reada_bufl(
-	struct xfs_mount	*mp,		/* file system mount point */
-	xfs_fsblock_t		fsbno,		/* file system block number */
-	xfs_extlen_t		count,		/* count of filesystem blocks */
-	const struct xfs_buf_ops *ops)
-{
-	xfs_daddr_t		d;
-
-	ASSERT(fsbno != NULLFSBLOCK);
-	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, ops);
-}
-
 /*
  * Read-ahead the block, don't wait for it, don't return a buffer.
  * Short-form addressing.
@@ -932,19 +913,20 @@ xfs_btree_readahead_fsblock(
 	int			lr,
 	struct xfs_btree_block	*block)
 {
-	int			rval = 0;
+	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_fsblock_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
 	xfs_fsblock_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
+	int			rval = 0;
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLFSBLOCK) {
-		xfs_btree_reada_bufl(cur->bc_mp, left, 1,
-				     cur->bc_ops->buf_ops);
+		xfs_buf_readahead(mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, left),
+				mp->m_bsize, cur->bc_ops->buf_ops);
 		rval++;
 	}
 
 	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLFSBLOCK) {
-		xfs_btree_reada_bufl(cur->bc_mp, right, 1,
-				     cur->bc_ops->buf_ops);
+		xfs_buf_readahead(mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, right),
+				mp->m_bsize, cur->bc_ops->buf_ops);
 		rval++;
 	}
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index b9b46a573..001ff9392 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -391,17 +391,6 @@ xfs_btree_read_bufl(
 	int			refval,	/* ref count value for buffer */
 	const struct xfs_buf_ops *ops);
 
-/*
- * Read-ahead the block, don't wait for it, don't return a buffer.
- * Long-form addressing.
- */
-void					/* error */
-xfs_btree_reada_bufl(
-	struct xfs_mount	*mp,	/* file system mount point */
-	xfs_fsblock_t		fsbno,	/* file system block number */
-	xfs_extlen_t		count,	/* count of filesystem blocks */
-	const struct xfs_buf_ops *ops);
-
 /*
  * Read-ahead the block, don't wait for it, don't return a buffer.
  * Short-form addressing.

