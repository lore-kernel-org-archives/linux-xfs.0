Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570B738B
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buHsx0nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214A7C433C7;
	Mon,  1 Jan 2024 00:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067847;
	bh=cai1PsoNxrA36JFDUy4QNm23dPvx9PZeAgiUmXUYPtc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=buHsx0nv6/0WgeLxTobIOYBrUiS23n3EkUh3IukK1nd5f4JDgQ+0SUk1zhmwURKje
	 EEJV3vSodZK0QeYJZMb0KoFMC3ao7WCAplt7ITBycn5GjRRcLIAeyJPtpAhDzSMg5X
	 xig99OzC/j98/qZfsOOIOafsV2u1mFNF/nRn7OiWI3p5oHqyE+/jm69uZYoJ0fR/sq
	 9UigkItY54pMCNFIC0IDI7jqpyOYgN3MOQ0vhfAHkHCzRMdDDxgexgJz4POclH7LGb
	 AS7lTmN33H46scs/p9RXt7379sb+vXQeCiwCLb/5Xez6NjHzzTmRxkjaIRVru8xcq+
	 +keHVdWKop1vw==
Date: Sun, 31 Dec 2023 16:10:46 +9900
Subject: [PATCH 01/47] xfs: simplify the xfs_rmap_{alloc,free}_extent calling
 conventions
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015325.1815505.2097209138079661055.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount.c |    6 ++----
 libxfs/xfs_rmap.c     |   12 +++++-------
 libxfs/xfs_rmap.h     |    8 ++++----
 repair/rmap.c         |    8 ++++----
 4 files changed, 15 insertions(+), 19 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 6c6634675c2..9f933d953b9 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1886,8 +1886,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1903,8 +1902,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 24daf0ffb66..3e95599ab8a 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -526,7 +526,7 @@ xfs_rmap_free_check_owner(
 	struct xfs_btree_cur	*cur,
 	uint64_t		ltoff,
 	struct xfs_rmap_irec	*rec,
-	xfs_filblks_t		len,
+	xfs_extlen_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags)
@@ -2717,8 +2717,7 @@ xfs_rmap_convert_extent(
 void
 xfs_rmap_alloc_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		fsbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
 {
@@ -2727,7 +2726,7 @@ xfs_rmap_alloc_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
@@ -2739,8 +2738,7 @@ xfs_rmap_alloc_extent(
 void
 xfs_rmap_free_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		fsbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
 {
@@ -2749,7 +2747,7 @@ xfs_rmap_free_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index e6240efd6fe..0ccfd7d88e5 100644
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
diff --git a/repair/rmap.c b/repair/rmap.c
index 37fcf923644..265199d2117 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1278,7 +1278,6 @@ rmap_diffkeys(
 {
 	__u64			oa;
 	__u64			ob;
-	int64_t			d;
 	struct xfs_rmap_irec	tmp;
 
 	tmp = *kp1;
@@ -1288,9 +1287,10 @@ rmap_diffkeys(
 	tmp.rm_flags &= ~XFS_RMAP_REC_FLAGS;
 	ob = libxfs_rmap_irec_offset_pack(&tmp);
 
-	d = (int64_t)kp1->rm_startblock - kp2->rm_startblock;
-	if (d)
-		return d;
+	if (kp1->rm_startblock > kp2->rm_startblock)
+		return 1;
+	else if (kp2->rm_startblock > kp1->rm_startblock)
+		return -1;
 
 	if (kp1->rm_owner > kp2->rm_owner)
 		return 1;

