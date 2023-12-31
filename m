Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CE1BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cPeK7WfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C50C433C7;
	Sun, 31 Dec 2023 20:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054192;
	bh=XeyMq0kQn8oE/+0RZe/fQHOX/iicQzko0xTCHNi0xho=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cPeK7WfY02WN8iZecdHXwGKprnNvAiO2AVqmz6Ha3yCuHtuhyF2ogtHEaVUEIzDr2
	 9rEtKLIMj+v5Oyue/O5UisnYjjXVuCitvLpoO/7SyZl+uqNLotscWUhLS4nuBi+kfG
	 WaQ+iwjjR5VRb0DIFbZ53kFSRBPx9sIulFYOzu4RzzDztbwiyHu1nAcUqASv1SIAzc
	 sefULIO7lyw1QdjTLtWp9bIaMPPLdxCuTqoQzTxjdyaDcl1lRa2la+T6E2sOxwOaOR
	 HzoWRyFV45xSw7X3qCpwk+GE0+Z6a/H90BmN56yqVZaZBqoAkNMUoTJAycsOgONscQ
	 OghIdwqgCW3/A==
Date: Sun, 31 Dec 2023 12:23:12 -0800
Subject: [PATCH 1/2] xfs: support deferred bmap updates on the attr fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404832281.1750058.12497248988958085816.stgit@frogsfrogsfrogs>
In-Reply-To: <170404832261.1750058.14588057130952880290.stgit@frogsfrogsfrogs>
References: <170404832261.1750058.14588057130952880290.stgit@frogsfrogsfrogs>
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

The deferred bmap update log item has always supported the attr fork, so
plumb this in so that higher layers can access this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   47 +++++++++++++++++++---------------------------
 fs/xfs/libxfs/xfs_bmap.h |    4 ++--
 fs/xfs/xfs_bmap_util.c   |    8 ++++----
 fs/xfs/xfs_reflink.c     |    8 ++++----
 4 files changed, 29 insertions(+), 38 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bf20267cf6378..e7da6a72eb928 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6150,17 +6150,8 @@ xfs_bmap_split_extent(
 	return error;
 }
 
-/* Deferred mapping is only for real extents in the data fork. */
-static bool
-xfs_bmap_is_update_needed(
-	struct xfs_bmbt_irec	*bmap)
-{
-	return  bmap->br_startblock != HOLESTARTBLOCK &&
-		bmap->br_startblock != DELAYSTARTBLOCK;
-}
-
 /* Record a bmap intent. */
-static int
+static inline void
 __xfs_bmap_add(
 	struct xfs_trans		*tp,
 	enum xfs_bmap_intent_type	type,
@@ -6170,6 +6161,11 @@ __xfs_bmap_add(
 {
 	struct xfs_bmap_intent		*bi;
 
+	if ((whichfork != XFS_DATA_FORK && whichfork != XFS_ATTR_FORK) ||
+	    bmap->br_startblock == HOLESTARTBLOCK ||
+	    bmap->br_startblock == DELAYSTARTBLOCK)
+		return;
+
 	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
@@ -6178,7 +6174,6 @@ __xfs_bmap_add(
 	bi->bi_bmap = *bmap;
 
 	xfs_bmap_defer_add(tp, bi);
-	return 0;
 }
 
 /* Map an extent into a file. */
@@ -6186,12 +6181,10 @@ void
 xfs_bmap_map_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
+	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
-	if (!xfs_bmap_is_update_needed(PREV))
-		return;
-
-	__xfs_bmap_add(tp, XFS_BMAP_MAP, ip, XFS_DATA_FORK, PREV);
+	__xfs_bmap_add(tp, XFS_BMAP_MAP, ip, whichfork, PREV);
 }
 
 /* Unmap an extent out of a file. */
@@ -6199,12 +6192,10 @@ void
 xfs_bmap_unmap_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
+	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
-	if (!xfs_bmap_is_update_needed(PREV))
-		return;
-
-	__xfs_bmap_add(tp, XFS_BMAP_UNMAP, ip, XFS_DATA_FORK, PREV);
+	__xfs_bmap_add(tp, XFS_BMAP_UNMAP, ip, whichfork, PREV);
 }
 
 /*
@@ -6218,29 +6209,29 @@ xfs_bmap_finish_one(
 {
 	struct xfs_bmbt_irec		*bmap = &bi->bi_bmap;
 	int				error = 0;
+	int				flags = 0;
+
+	if (bi->bi_whichfork == XFS_ATTR_FORK)
+		flags |= XFS_BMAPI_ATTRFORK;
 
 	ASSERT(tp->t_highest_agno == NULLAGNUMBER);
 
 	trace_xfs_bmap_deferred(bi);
 
-	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK)) {
-		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
-		return -EFSCORRUPTED;
-	}
-
-	if (XFS_TEST_ERROR(false, tp->t_mountp,
-			XFS_ERRTAG_BMAP_FINISH_ONE))
+	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_BMAP_FINISH_ONE))
 		return -EIO;
 
 	switch (bi->bi_type) {
 	case XFS_BMAP_MAP:
 		error = xfs_bmapi_remap(tp, bi->bi_owner, bmap->br_startoff,
-				bmap->br_blockcount, bmap->br_startblock, 0);
+				bmap->br_blockcount, bmap->br_startblock,
+				flags);
 		bmap->br_blockcount = 0;
 		break;
 	case XFS_BMAP_UNMAP:
 		error = __xfs_bunmapi(tp, bi->bi_owner, bmap->br_startoff,
-				&bmap->br_blockcount, XFS_BMAPI_REMAP, 1);
+				&bmap->br_blockcount, flags | XFS_BMAPI_REMAP,
+				1);
 		break;
 	default:
 		ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index a5e37ef7b75d7..1eee606f3924d 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -245,9 +245,9 @@ struct xfs_bmap_intent {
 
 int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 void	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
-		struct xfs_bmbt_irec *imap);
+		int whichfork, struct xfs_bmbt_irec *imap);
 void	xfs_bmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
-		struct xfs_bmbt_irec *imap);
+		int whichfork, struct xfs_bmbt_irec *imap);
 
 static inline uint32_t xfs_bmap_fork_to_state(int whichfork)
 {
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 6b5a9ad18fcb3..892622530431a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1448,16 +1448,16 @@ xfs_swap_extent_rmap(
 			}
 
 			/* Remove the mapping from the donor file. */
-			xfs_bmap_unmap_extent(tp, tip, &uirec);
+			xfs_bmap_unmap_extent(tp, tip, XFS_DATA_FORK, &uirec);
 
 			/* Remove the mapping from the source file. */
-			xfs_bmap_unmap_extent(tp, ip, &irec);
+			xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &irec);
 
 			/* Map the donor file's blocks into the source file. */
-			xfs_bmap_map_extent(tp, ip, &uirec);
+			xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &uirec);
 
 			/* Map the source file's blocks into the donor file. */
-			xfs_bmap_map_extent(tp, tip, &irec);
+			xfs_bmap_map_extent(tp, tip, XFS_DATA_FORK, &irec);
 
 			error = xfs_defer_finish(tpp);
 			tp = *tpp;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ad1f235a3c492..69dfd7e430fe7 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -806,7 +806,7 @@ xfs_reflink_end_cow_extent(
 		 * If the extent we're remapping is backed by storage (written
 		 * or not), unmap the extent and drop its refcount.
 		 */
-		xfs_bmap_unmap_extent(tp, ip, &data);
+		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &data);
 		xfs_refcount_decrease_extent(tp, &data);
 		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
 				-data.br_blockcount);
@@ -830,7 +830,7 @@ xfs_reflink_end_cow_extent(
 	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
 
 	/* Map the new blocks into the data fork. */
-	xfs_bmap_map_extent(tp, ip, &del);
+	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &del);
 
 	/* Charge this new data fork mapping to the on-disk quota. */
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
@@ -1294,7 +1294,7 @@ xfs_reflink_remap_extent(
 		 * If the extent we're unmapping is backed by storage (written
 		 * or not), unmap the extent and drop its refcount.
 		 */
-		xfs_bmap_unmap_extent(tp, ip, &smap);
+		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &smap);
 		xfs_refcount_decrease_extent(tp, &smap);
 		qdelta -= smap.br_blockcount;
 	} else if (smap.br_startblock == DELAYSTARTBLOCK) {
@@ -1319,7 +1319,7 @@ xfs_reflink_remap_extent(
 	 */
 	if (dmap_written) {
 		xfs_refcount_increase_extent(tp, dmap);
-		xfs_bmap_map_extent(tp, ip, dmap);
+		xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, dmap);
 		qdelta += dmap->br_blockcount;
 	}
 

