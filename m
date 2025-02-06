Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CBB23C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881466; cv=none; b=b9Rks+VP50UuSFX8TTNAcx4HbwSdr5Ohl/Fk4d0WlXK+IbPhCXTZdh+gwhu9u0/QZiWyhfEAVYq4Ua04mlFFBny2zv7qC2fBpPiwVt0oaWspF/rSjMA2mrlF1KNgmAjGvCKhEyBbKMCcdr7UwATOsbTEnu5I6GzZXcNnA484Tog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881466; c=relaxed/simple;
	bh=W9K23TVFC7fTQGl+g6tj2T6hIpWb0UYPoK2zr8bdNqk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Im9UZa4oEWRTmPoyiuquzprn97qvjGNY7bF9fIiCxdrI6tlLoreHhsgOh2PUegfeNqMJRnht9qtnVZSz7O65AvqI1dqXtX0fNITNwUNz3wabEs35XaMNoFN7+mHnh244MhHnuB+S6mBs6YVejJSV1oLXfb+s2rHtn3zJ9v+T8Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Om3lYHUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Om3lYHUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1E6C4CEDD;
	Thu,  6 Feb 2025 22:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881463;
	bh=W9K23TVFC7fTQGl+g6tj2T6hIpWb0UYPoK2zr8bdNqk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Om3lYHUUOL4ZY7qUkdp5uLn0/qOdK+V43BYnoXJuyPdOeclS3gmcLo5RrsOdBQ9rZ
	 iuIWrth/HBQoTy4Z2YOEUtN8+Uxd1rm+NQ3BeMpF3csv+MCDbprt9y4FniwmjHNxI4
	 xQMHHnsuDMFUuOacGTM0h148I21eS/7LlSoCJU2h8N9NbSmnjPEgGMjuvp7VAeSiht
	 HzvATKi9CKTA3nHqt9FZLrOnEeY0Jm4vHeT4qyNPfk/JO2t7AUKWdBKFCjMLpbKrAM
	 B+D6OlrfqLumzYou1yR3Kql5ndc720uuD9/HflOB3l04sgAwd08ZRDoWmISbgrzDln
	 f3qyegJN8JTHA==
Date: Thu, 06 Feb 2025 14:37:43 -0800
Subject: [PATCH 10/56] xfs: simplify the xfs_rmap_{alloc,free}_extent calling
 conventions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086945.2739176.16527314553901088315.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 953f76bf7a3622351f335c77c56ed7efb793e3e7

Simplify the calling conventions by allowing callers to pass a fsbno
(xfs_fsblock_t) directly into these functions, since we're just going to
set it in a struct anyway.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_refcount.c |    6 ++----
 libxfs/xfs_rmap.c     |   12 +++++-------
 libxfs/xfs_rmap.h     |    8 ++++----
 3 files changed, 11 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 709e2a94176da5..11c0ca5ecdb3e4 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1830,8 +1830,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1847,8 +1846,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index dabc7003586ce4..e23972f934f9ef 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -524,7 +524,7 @@ xfs_rmap_free_check_owner(
 	struct xfs_btree_cur	*cur,
 	uint64_t		ltoff,
 	struct xfs_rmap_irec	*rec,
-	xfs_filblks_t		len,
+	xfs_extlen_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags)
@@ -2728,8 +2728,7 @@ xfs_rmap_convert_extent(
 void
 xfs_rmap_alloc_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		fsbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
 {
@@ -2738,7 +2737,7 @@ xfs_rmap_alloc_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
@@ -2750,8 +2749,7 @@ xfs_rmap_alloc_extent(
 void
 xfs_rmap_free_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		fsbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
 {
@@ -2760,7 +2758,7 @@ xfs_rmap_free_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 96b4321d831007..8e2657af038e9e 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
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

