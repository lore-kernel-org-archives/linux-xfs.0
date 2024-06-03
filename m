Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BA113B5B7
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441803; cv=none; b=fiREz7hOLPq4UUE/00nQsad7sJ5KhRuANDcWMdfX9+YiYE8n6oMD9wb35TVIcISE/VHX1slPq3WjOdSAEo0uXxe9FhrBoE+TzUMITfgnDm6gXKuUc3Kkbhkh9Vyh1Fyf93ASHppDU2ShO3FiD4XqOgD1TXlALi5Kgd0tab4XeKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441803; c=relaxed/simple;
	bh=CYU8DRtg03/Z96rteunuawRv06fPL5N6uRIudG7wrpA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FHVrqxQ++3XYovTW899jH5NNna3GONTFua9iPdtEE9P6URnctW83Nd1Z6T28pidu9+a5eevwJTP+mQ+IK1jlEuNNX3SxZyL+jxMZAtE0NB1YpyUGVWSYoxc8NCeLvTNYzuksD9OJgkfpwWy+hx3j3ldge8eYc/qTivxRqmx43cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pRzH3iL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pRzH3iL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7CCC2BD10;
	Mon,  3 Jun 2024 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441803;
	bh=CYU8DRtg03/Z96rteunuawRv06fPL5N6uRIudG7wrpA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pRzH3iL0xz1GDzw6gy6CTGf9rHCKVlICioFSrEjqNamBqFBNg6To70jJCW0Y5J4On
	 GQoG027mDlhPhI/STTg0k4U2WKQKbG0FKvcAb/m2/IHsLwazLmSjmP3I3FYTQafHeZ
	 pgC5pTHLxrrtGqqSQzXR4CqRNN4/AW4e0M4fsu38zwQhHnPXf66oQRflykV4cljZuE
	 N+zh6x2RzOKvEFa8aDI+eErkbyFw1JP9lS1uDSTWI+yZ0leKKjiwQ5v14oYplnOuzQ
	 ibZqnsmdRA5M1nAuu2WFrQYhh3deAyLiIWs8jIOThJNa0TesElXo1vn+BCKunjoaOI
	 uPSFzNdqKP0JQ==
Date: Mon, 03 Jun 2024 12:10:02 -0700
Subject: [PATCH 069/111] xfs: remove xfs_inobt_cur
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040411.1443973.14896503273816942122.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3038fd8129384c64946c17198229ee61f6f2c8e1

This helper provides no real advantage over just open code the two
calls in it in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

