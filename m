Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B988F1372
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051682; cv=none; b=QEGwD4IfIVIoOfuJbPHWtA9qoTlL9Xh7nGnH9sybt/8dKQCR5NwjM8GV6BpB8g1/HIUkeK3oI8ERgJFaaBvWGOVhnAEiX5h+SAnuo1QpvfsuyipU3bg49lv55ASAUxJ5sqqhvlCmBWG4o23fcgbBnTRD46TUgcXqM5ldzMDf5mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051682; c=relaxed/simple;
	bh=Vqhkafs7GtBGtMJnM46QTAmE6CNjwNhW4kqxLd47GIs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XeAS9dEY05KjJE83M5OiEgQWaavmGjd3MabQ5HlRtFVW88XD/Z8dGu34nLJoPceKzEBPes1/puA+H5kXJjFVXJnnnMuY7p1SfReQZcmTJNPtB1h7KpKpPwCp5ebf4BKzQyRvTZWrTVTUukZdlHj5YLYvShLFhkDy9fORprg1Veg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwGx8xfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwGx8xfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F79C4CECE;
	Fri, 13 Dec 2024 01:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051682;
	bh=Vqhkafs7GtBGtMJnM46QTAmE6CNjwNhW4kqxLd47GIs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AwGx8xfOVLm1L3IIIfbAiKTNB3kQ7qSpEal13VT9BmM4Hl0QvyYG83WXkLBIjXVlM
	 Cjw6PzWQIMR06fGKs0VCdPe3Cw81wW6nRNW9+2bZ7BxHLGfDnO3NUPyRwN6YXHKDBH
	 0ckUpNCsJaVdIXxsbXnczck1J2D6ZcNtGzByjlF9wRfmsWjWTHXhr2+4N5zrbOSzS6
	 hmzmQZqw/7iN60Eju9FQG2NvZ77BrslZ+6WFu5fRoBnGvalVK6655WBtKCiWenngXR
	 UVMhR2XabUeCg76kiouX4lKleU8HmsooctJ+gmBbN4ZuCg5u4usqx1qfWwkO8VYvQm
	 optF9UYOF2JsA==
Date: Thu, 12 Dec 2024 17:01:22 -0800
Subject: [PATCH 03/37] xfs: simplify the xfs_rmap_{alloc,free}_extent calling
 conventions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123364.1181370.781600665689768961.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Simplify the calling conventions by allowing callers to pass a fsbno
(xfs_fsblock_t) directly into these functions, since we're just going to
set it in a struct anyway.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |    6 ++----
 fs/xfs/libxfs/xfs_rmap.c     |   12 +++++-------
 fs/xfs/libxfs/xfs_rmap.h     |    8 ++++----
 fs/xfs/scrub/alloc_repair.c  |    5 +++--
 4 files changed, 14 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 2dbab68b4fe69f..26d3d7956e069d 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1831,8 +1831,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1848,8 +1847,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index d0df68dc313185..57dbf99ce00453 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -525,7 +525,7 @@ xfs_rmap_free_check_owner(
 	struct xfs_btree_cur	*cur,
 	uint64_t		ltoff,
 	struct xfs_rmap_irec	*rec,
-	xfs_filblks_t		len,
+	xfs_extlen_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags)
@@ -2729,8 +2729,7 @@ xfs_rmap_convert_extent(
 void
 xfs_rmap_alloc_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		fsbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
 {
@@ -2739,7 +2738,7 @@ xfs_rmap_alloc_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
@@ -2751,8 +2750,7 @@ xfs_rmap_alloc_extent(
 void
 xfs_rmap_free_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		fsbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
 {
@@ -2761,7 +2759,7 @@ xfs_rmap_free_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 96b4321d831007..8e2657af038e9e 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -184,10 +184,10 @@ void xfs_rmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 void xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
-void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
-		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
-void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
-		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
+void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+		xfs_extlen_t len, uint64_t owner);
+void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+		xfs_extlen_t len, uint64_t owner);
 
 int xfs_rmap_finish_one(struct xfs_trans *tp, struct xfs_rmap_intent *ri,
 		struct xfs_btree_cur **pcur);
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 0433363a90b616..11e1e5404fc6dc 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -542,8 +542,9 @@ xrep_abt_dispose_one(
 
 	/* Add a deferred rmap for each extent we used. */
 	if (resv->used > 0)
-		xfs_rmap_alloc_extent(sc->tp, pag_agno(pag), resv->agbno,
-				resv->used, XFS_RMAP_OWN_AG);
+		xfs_rmap_alloc_extent(sc->tp,
+				xfs_agbno_to_fsb(pag, resv->agbno), resv->used,
+				XFS_RMAP_OWN_AG);
 
 	/*
 	 * For each reserved btree block we didn't use, add it to the free

