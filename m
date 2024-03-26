Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4283821353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424786; cv=none; b=QsZuqMcBaeffdol5o6lN1cCmzbdCLZnWMyfxncLwlN91y0Voxg2n+TX0M90SNNAaGGG91aYrGZM/QC7a901sQKFUjBNH3Jgg6CbKk4JIh1R8+aeGcRRGk289Kc6dajy6zvErsHV5pcHu2nztLO6gjHeYa63ZvfGQkW4K0NmmUS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424786; c=relaxed/simple;
	bh=w4sNOCGr6wSvZJB885vXSvTtnGhBL62ea+S1NVUhInY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ot3fDRnhVH/KzT1pH66ZxPuR3FG4S9IRvg3i1PU++MnBancB56eUCIDLoy4l4CfOL1ZWdX4jkHrbzd5A5C3r8LqxtdOvloPkiPSWInz01asO3m96el58vn+VEXJLw40OOwguu+xEoyrCO3U+ybxdFDehTg8+eVk23t8ag7TnrGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVbE4gGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVbE4gGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14047C433F1;
	Tue, 26 Mar 2024 03:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424786;
	bh=w4sNOCGr6wSvZJB885vXSvTtnGhBL62ea+S1NVUhInY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fVbE4gGUtEy33q1Y22L6Sl5siS2b5ulM+BxrLOrFXgGqkiIA2KytmERT7tCL+e+2e
	 tPtQQIPEyiZKctwxMvpcT3gNkiz5nokHVYJ2AWN/Rn6X3yuDzfPwS0jIxPJtir2QE0
	 WXHR5aoV/rBA8lyvcL8qu4/9rj00Vl0RR1/iJXkb3Yv3O47mgNd22NGEWgF3Y83w4T
	 2aAGUNEg8zHMeMnItvBSRKbehT0coyOB/GDa12GeFHH07k9oXtqm7Ww0a+Ly3QGccD
	 V1THzIb/LwGyrDuSv08vjHUA4JZ+3zAGd9q+mn4+3s4oLn2NOr9GVCi7x3EJS4vD1z
	 cFUfNvU2s+6TA==
Date: Mon, 25 Mar 2024 20:46:25 -0700
Subject: [PATCH 069/110] xfs: remove xfs_inobt_cur
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132374.2215168.4172351467847004784.stgit@frogsfrogsfrogs>
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
index 08076ef12bbf..cf59530ea2d6 100644
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
index 40f0fc0e8da3..2f1552d65655 100644
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

