Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354FD85286
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817069; cv=none; b=nA3O8PqKgbqA8lfCRnCLiWap1PD4jRbrSR+HmtXuOYc5z9db6R0xm13K/Fouu7EfcowBzi/IdkutHEhsMTIizhs+OAbISeBxMHqDaGE2H1lB4ErhgdrTBU/r53kQ60hS8yfXBlb+9/TwPm8yAvn8PQTDt0f7974RZ4G55vDLy3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817069; c=relaxed/simple;
	bh=WSD64O3DZK7oHom95OhHMrzsrbbvnBOR1fmSHSfNNkM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wlcg8fnRczwWVt0YNtMIGGL4ed4CSjIKkKd96ewTTodsqJJNq9uHsCMLkkw1LtAyWv1FXPDTiRIhJ4tfHBeyZw3v94GH8jxIJASFw8niJ4AkeV8sn+zy5sNIP8ZJtVgAnmWB2VFU8E78YodNqprVFFJM81DOKg4NE1yu4eRFbYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OEpu3LXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OEpu3LXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36AFC433C7;
	Thu,  1 Feb 2024 19:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817068;
	bh=WSD64O3DZK7oHom95OhHMrzsrbbvnBOR1fmSHSfNNkM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OEpu3LXLck31XlrmADX7IPuLkRF+019C0IKlqIXLg7nu1Xt43tVH0a7Bb6G8EOszJ
	 BuRhxP7GFaNm+A1RIzhCrk6eY0QD6chXMp9Nflopb8WrvKeAbkUtSPQTXqmAkJdCh7
	 61GM/sSz0ZarXufSaQMaF4R7JW6Eh0L0VxKH0KiNG1cx3Vxr6un8qUqngZB+p4JlYB
	 4qNvCIfFBwtXfbn1jUWi0nfHd1YTAhzpe29zTlxbDbB6yvCyimR4CQRQvzDuCq9yhr
	 VDnlc1/TSYup9LvIPV0HejSmp82zZmvW4ved29Not9puqFtY6fqcomyHFg3ApjeQ4Y
	 wtYkR9OMH2sGg==
Date: Thu, 01 Feb 2024 11:51:08 -0800
Subject: [PATCH 21/27] xfs: remove xfs_inobt_cur
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335130.1605438.11513727847853353039.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

This helper provides no real advantage over just open code the two
calls in it in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c |   29 +++--------------------------
 fs/xfs/libxfs/xfs_ialloc_btree.h |    3 ---
 fs/xfs/xfs_iwalk.c               |    9 +++++----
 3 files changed, 8 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 1fe9d83c575ea..441c5a7be1e0f 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -710,30 +710,6 @@ xfs_inobt_max_size(
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
@@ -742,13 +718,14 @@ xfs_inobt_count_blocks(
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
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 40f0fc0e8da37..2f1552d656559 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -64,9 +64,6 @@ int xfs_finobt_calc_reserves(struct xfs_perag *perag, struct xfs_trans *tp,
 		xfs_extlen_t *ask, xfs_extlen_t *used);
 extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
-int xfs_inobt_cur(struct xfs_perag *pag, struct xfs_trans *tp,
-		xfs_btnum_t btnum, struct xfs_btree_cur **curpp,
-		struct xfs_buf **agi_bpp);
 
 void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 6f26a791f17f0..bab4825e259bf 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -266,9 +266,10 @@ xfs_iwalk_ag_start(
 
 	/* Set up a fresh cursor and empty the inobt cache. */
 	iwag->nr_recs = 0;
-	error = xfs_inobt_cur(pag, tp, XFS_BTNUM_INO, curpp, agi_bpp);
+	error = xfs_ialloc_read_agi(pag, tp, agi_bpp);
 	if (error)
 		return error;
+	*curpp = xfs_inobt_init_cursor(pag, tp, *agi_bpp, XFS_BTNUM_INO);
 
 	/* Starting at the beginning of the AG?  That's easy! */
 	if (agino == 0)
@@ -383,11 +384,11 @@ xfs_iwalk_run_callbacks(
 	}
 
 	/* ...and recreate the cursor just past where we left off. */
-	error = xfs_inobt_cur(iwag->pag, iwag->tp, XFS_BTNUM_INO, curpp,
-			agi_bpp);
+	error = xfs_ialloc_read_agi(iwag->pag, iwag->tp, agi_bpp);
 	if (error)
 		return error;
-
+	*curpp = xfs_inobt_init_cursor(iwag->pag, iwag->tp, *agi_bpp,
+			XFS_BTNUM_INO);
 	return xfs_inobt_lookup(*curpp, next_agino, XFS_LOOKUP_GE, has_more);
 }
 

