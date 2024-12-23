Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B357462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994646; cv=none; b=IvVH/xXl/+0DQOGKSrJvqealC6aFiZ5KYWpEAGblvc7/tXgaDfAxrPqEprxu84MD0k5xmBFURkeRAmxwLzzCGngvgUh59j5sD1rVhwNxP1Q6Ke6Kdjsg2XpKXwY6S4ELZ1/nkHcYN1zZd1+SKd6fmV4XqiVcUGfLHyoN+/ADyJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994646; c=relaxed/simple;
	bh=a54774hxwwVDHOPBOfxc/oqai/Z5AXdZsFirAKLrOhA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XmRGDNhSH5ff1WmbsyIPXiLqakMsce+h8ZJ33CUpeaq/L3sycT51SsdKUgL1Hoe0Qv/xS15GMYfsSUXCpBdCq0mgmhhrhMCuwyHlE33Nr9mqskVWNdB+0GizXwd3Wn/rsy3Xzvc9L2cBYXmyqtL8ob8HwnkqV69UVhUo3uidJwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pz3N67g/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pz3N67g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BCFC4CED6;
	Mon, 23 Dec 2024 22:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994646;
	bh=a54774hxwwVDHOPBOfxc/oqai/Z5AXdZsFirAKLrOhA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Pz3N67g/19zffGH7d+ZBPDwzU/83kWHpNxAIUHEOjte8PlaIwe2HMMe8hOuHZm/35
	 INRVhEnF6qJ9+hNoGD2OhBJNPeM7tFUiNPfXCAi4B2+WNS2XGTXX1Xr09swvMoBJdp
	 zizH90txulrZ23sOWbIjS4SIpjCPQ2A5qxawj/+p0+grA8rO3m8OL3nmvrPD1kx0BU
	 qguh5kpqqOIpY5z9XmlXhpq7IUekEy1LYKiAUsvhBoMGco3rasEK4FaaCzwFEntfLc
	 JI7flx8z/EBwTKyKjDSpDiNajFJVSx9rLyGrDXQjmih3F9JJ19yZIy35Ppxev94YvG
	 rwtO+LQI2TK9A==
Date: Mon, 23 Dec 2024 14:57:26 -0800
Subject: [PATCH 03/37] xfs: simplify the xfs_rmap_{alloc,free}_extent calling
 conventions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499418764.2380130.11683275918567819432.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

