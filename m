Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E4E84D12
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425037; cv=none; b=KC0hbE4NY4rblXgakHKMeCS0OX4wjMxEUgSaWir8QQVB0F0/ufuppK+4aom0acXcANklM1avrMtFKoccry/VoGBpYbtBwEKTMEyoW1e+Jsc2YX1gPW3cjqiL1KEgvvVlPzBah89dZQQpCiIKifOrAAE4GPTPyL8mcr8j2zJempw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425037; c=relaxed/simple;
	bh=GEWmJ6tUAwdgxmSHeJcFjeXxbYdgyL+xJ9k5jwP+8Jw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I3y9Tg9a9mWWXYcqmR4XGi+dySNdTHqfmdp1GfFydF4hMT8o4SweyhsnJMedCdvW2Jrn7GrXuT303PlV/aW+QU5ruXNzN/C2td1aWsPDyrOEn1zdQtgrwiKjbMy278upM84Q2WHQEJK71xUmEdYNvREY4Kv3CCcwTbe+RGFb5cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/1lTJmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/1lTJmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86346C433F1;
	Tue, 26 Mar 2024 03:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425036;
	bh=GEWmJ6tUAwdgxmSHeJcFjeXxbYdgyL+xJ9k5jwP+8Jw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j/1lTJmtIMmYfNEVzOETMI2IhXHu/HeMTCCpC1yAorKTdoccz0WHUKgo+JybpQkbZ
	 eQ4FpycJzx36ZzonDL6pcvqcRRSCxqDSlwlSRwc/5G/TYbdE7ffiakjSU0hNlJfTSK
	 D/OHuaMTjuJThgNNBv50lqY1+m3peUFnz4K6XLvGIiiYYnf4s+CTWDnAgf+dQea92M
	 o6ySo2NaOKQUG8ZQQInz0jAlc0bqJ9DNYKunvSaAZaGisQ9nEVWqzwLjEkNgi4wfyG
	 Oc8oIu9WOmKxOHo7rKNdihxsleOJVAiJPcHxKCc5U/W28gQi/H3bKYalS67jJQRQT9
	 cN13+m1CBEH7A==
Date: Mon, 25 Mar 2024 20:50:36 -0700
Subject: [PATCH 085/110] xfs: remove xfs_btree_reada_bufl
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132604.2215168.14463028958335489005.stgit@frogsfrogsfrogs>
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
index 6b18392438c2..2bef2f3e2bb0 100644
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
index b9b46a573e64..001ff9392804 100644
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

