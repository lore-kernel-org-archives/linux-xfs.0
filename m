Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4651EA91
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347207; cv=none; b=fLI0GeT6RtsC6ROVsJyuTuWuRkmdhkOWRHHIrVvqrN/8PglPr10enEeRDZ45fWHdDaou5iA0I9dLpe2k0DBDLp4/f7qnDP0za9rOlhZDDZyFs8eUs5h0FdQunHEFdrbfvCv0E1EEmv7rpKtmeSPks7qeJyr2Oa17F9/hZhTuo+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347207; c=relaxed/simple;
	bh=cByitpDh8WSS0IMstturNpew1k6KiuTmXbkM4TWI0V4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dRUlzvwJrHFhtuyqXbi0EAGpVkmvFuwoGk5o5NTPtHyiygJh3TlVQdosV12xjZDkubcJ6iF0YyanHUXyysogr5FY2fAYq7BhIhKo0pGUZ6kA+/NYWvb23ZrvoSME6JJbBHIzXsKERwRHBPl1ZL+e1zwP94FvDK+3IXQWbDtzMBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WAeDM0xT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WAeDM0xT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5A1C2BD11;
	Wed, 22 May 2024 03:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347206;
	bh=cByitpDh8WSS0IMstturNpew1k6KiuTmXbkM4TWI0V4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WAeDM0xTIA+kQdnLC32fz5x1WcsRJpgIsElKzbf/OQdt3w+vfpXsJnhWdlq6zXdtJ
	 1nzSzU142voVM/WbS6mw7N+6tSzj6PYFoD5pxD16KwGtdWsCYWQLHe/sd5Wbm8O562
	 NZFSWlsZJVw/5hFsVI2UGI+22QQ8KFpd16R+D+a+RqnyFuTOcyoo0qabJwWw1ZEI+o
	 xvVo4MmsTSwXKKmunC2luRd873030q3u/8Bk+hs0dd2+VE13eGYdOz01GqhznkAYaP
	 IBVhppmM2cVixsWZZixhPme1HNqPiFEed5bkckn4LILW/MluCu6hayZjZWnZpexQMd
	 LPrQjv632Q1NQ==
Date: Tue, 21 May 2024 20:06:46 -0700
Subject: [PATCH 069/111] xfs: remove xfs_inobt_cur
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532733.2478931.13291390171975336731.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3038fd8129384c64946c17198229ee61f6f2c8e1

This helper provides no real advantage over just open code the two
calls in it in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc_btree.c |   29 +++--------------------------
 libxfs/xfs_ialloc_btree.h |    3 ---
 2 files changed, 3 insertions(+), 29 deletions(-)


diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 08076ef12..cf59530ea 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -709,30 +709,6 @@ xfs_inobt_max_size(
 					XFS_INODES_PER_CHUNK);
 }
 
-/* Read AGI and create inobt cursor. */
-int
-xfs_inobt_cur(
-	struct xfs_perag	*pag,
-	struct xfs_trans	*tp,
-	xfs_btnum_t		which,
-	struct xfs_btree_cur	**curpp,
-	struct xfs_buf		**agi_bpp)
-{
-	struct xfs_btree_cur	*cur;
-	int			error;
-
-	ASSERT(*agi_bpp == NULL);
-	ASSERT(*curpp == NULL);
-
-	error = xfs_ialloc_read_agi(pag, tp, agi_bpp);
-	if (error)
-		return error;
-
-	cur = xfs_inobt_init_cursor(pag, tp, *agi_bpp, which);
-	*curpp = cur;
-	return 0;
-}
-
 static int
 xfs_inobt_count_blocks(
 	struct xfs_perag	*pag,
@@ -741,13 +717,14 @@ xfs_inobt_count_blocks(
 	xfs_extlen_t		*tree_blocks)
 {
 	struct xfs_buf		*agbp = NULL;
-	struct xfs_btree_cur	*cur = NULL;
+	struct xfs_btree_cur	*cur;
 	int			error;
 
-	error = xfs_inobt_cur(pag, tp, btnum, &cur, &agbp);
+	error = xfs_ialloc_read_agi(pag, tp, &agbp);
 	if (error)
 		return error;
 
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, btnum);
 	error = xfs_btree_count_blocks(cur, tree_blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index 40f0fc0e8..2f1552d65 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -64,9 +64,6 @@ int xfs_finobt_calc_reserves(struct xfs_perag *perag, struct xfs_trans *tp,
 		xfs_extlen_t *ask, xfs_extlen_t *used);
 extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
-int xfs_inobt_cur(struct xfs_perag *pag, struct xfs_trans *tp,
-		xfs_btnum_t btnum, struct xfs_btree_cur **curpp,
-		struct xfs_buf **agi_bpp);
 
 void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);

