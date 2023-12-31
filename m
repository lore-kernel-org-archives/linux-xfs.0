Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0ACBE5F
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1jIaoBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849B3C433C8;
	Sun, 31 Dec 2023 22:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061545;
	bh=oJs4B7OAj2c3mCbrrMJycPC4mZcyVuBa/4EqBW7fiec=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M1jIaoBfBj3ClIHvvqjAVYXOq+OwyMO8uSywmNLByqkxKC1bzbkBjLRa5kvzeEAnf
	 Jjm/kyHsLD/E5Jmc0z19GqKFdZp2GCZOE5n8BATMMgDzDZXKW25qviSECLfJWQZT+1
	 h6ruDwIqcjjiK1gtKPGzRu2nax+Q8cwFi4v0gZRGOaqSUU1tg04X0go1wOwkkMgkVn
	 lHA/agahE1pUP6wqphPVEzI4sPOR8Ab4k5BYwGxIFq3dWYMihS09gUC9nUaObX3mj3
	 Fq9PgLZK5QlUPnF8ZKTxTue1bKiunvwCSgo/qJRdMDPck2J96+j22Ah6N3B9W7Wwkb
	 pR4nCI8A7jzuA==
Date: Sun, 31 Dec 2023 14:25:45 -0800
Subject: [PATCH 1/2] xfs: support deferred bmap updates on the attr fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404995551.1795876.17266804169890830992.stgit@frogsfrogsfrogs>
In-Reply-To: <170404995537.1795876.9859168140445827889.stgit@frogsfrogsfrogs>
References: <170404995537.1795876.9859168140445827889.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_bmap.c |   47 +++++++++++++++++++----------------------------
 libxfs/xfs_bmap.h |    4 ++--
 2 files changed, 21 insertions(+), 30 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index b0747e57e90..b7a9f541d30 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6144,17 +6144,8 @@ xfs_bmap_split_extent(
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
@@ -6164,6 +6155,11 @@ __xfs_bmap_add(
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
@@ -6172,7 +6168,6 @@ __xfs_bmap_add(
 	bi->bi_bmap = *bmap;
 
 	xfs_bmap_defer_add(tp, bi);
-	return 0;
 }
 
 /* Map an extent into a file. */
@@ -6180,12 +6175,10 @@ void
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
@@ -6193,12 +6186,10 @@ void
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
@@ -6212,29 +6203,29 @@ xfs_bmap_finish_one(
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
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index a5e37ef7b75..1eee606f392 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
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

