Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F079E33F9
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347755; cv=none; b=G6RcSDvHLYDk23m3idB5zAtVZzXevCNRTUkJXZLG0f+KS7wDeAuXSx/oY8ZPLr6PByJoCICSc0HWHdl7BKOrMQZQZGvzbXukUmPjnsdxUhX4PSJ5dLJnDkjJPalVpLph8BwOJqVGBiyU1u1eYfVGdKTnF5ejC7EVGWPPFKi6GeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347755; c=relaxed/simple;
	bh=ONsxUBGrWlKr7/1SlFJaNlopDeCefVh8bzeaWNRmPyA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r8slIiket15M4ZxQCSDQs0wb7kjo/BXnl49BU6ocB2iWKIR8heQ7x/B/NvF3siunzMBv9gst9k3IR9gG3Db1IMiru4e0wbxzcQFM3b7hw6OsHokZBOxak31v0Ls4doDpeMohLcWh2QEMD/o0ganki1iqp0QG3PJouN72hHNv60I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hqF6nOmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hqF6nOmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B79C2BD11;
	Wed, 22 May 2024 03:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347754;
	bh=ONsxUBGrWlKr7/1SlFJaNlopDeCefVh8bzeaWNRmPyA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hqF6nOmub/I+d2Ji82jYIL68PGO1zgBydNKy9Ie/xfe2x4wx0cRP+/kDsEdzHhlpQ
	 koopGB1cIj3EBrvmYfvt0CQeOMz0EWVEEURucWGaCpkw/85i7KDI5MixzXCnHINzOj
	 91qvaCg/0PZNt9xg87nEP3hnZsk6a/QQ7hlzsU/c7luJIrycFu4oscqxaFEI6NYMSi
	 J5IY04SRUgohplXfr0IhAlPxWanLwHIgq++yE7KkrU4Zu2eNLiGucTIK0AcG8HL2s3
	 mC3rLUx6ZuCxV58bTBmFU2w/b3L2xNeFXr0uHYa3dkhsROymlXOFNycQG8G+8P4fv9
	 LYHJA1MnuEBXA==
Date: Tue, 21 May 2024 20:15:53 -0700
Subject: [PATCH 104/111] xfs: support deferred bmap updates on the attr fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533263.2478931.1430407302076126589.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 52f807067ba4a122e75bf1e0e0595c78e6a3d8b6

The deferred bmap update log item has always supported the attr fork, so
plumb this in so that higher layers can access this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c |   47 +++++++++++++++++++----------------------------
 libxfs/xfs_bmap.h |    4 ++--
 2 files changed, 21 insertions(+), 30 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 388550912..f09ec3dfe 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6166,17 +6166,8 @@ xfs_bmap_split_extent(
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
@@ -6186,6 +6177,11 @@ __xfs_bmap_add(
 {
 	struct xfs_bmap_intent		*bi;
 
+	if ((whichfork != XFS_DATA_FORK && whichfork != XFS_ATTR_FORK) ||
+	    bmap->br_startblock == HOLESTARTBLOCK ||
+	    bmap->br_startblock == DELAYSTARTBLOCK)
+		return;
+
 	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
@@ -6194,7 +6190,6 @@ __xfs_bmap_add(
 	bi->bi_bmap = *bmap;
 
 	xfs_bmap_defer_add(tp, bi);
-	return 0;
 }
 
 /* Map an extent into a file. */
@@ -6202,12 +6197,10 @@ void
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
@@ -6215,12 +6208,10 @@ void
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
@@ -6234,29 +6225,29 @@ xfs_bmap_finish_one(
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
index 325cc232a..f76625953 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -247,9 +247,9 @@ struct xfs_bmap_intent {
 
 int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 void	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
-		struct xfs_bmbt_irec *imap);
+		int whichfork, struct xfs_bmbt_irec *imap);
 void	xfs_bmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
-		struct xfs_bmbt_irec *imap);
+		int whichfork, struct xfs_bmbt_irec *imap);
 
 static inline uint32_t xfs_bmap_fork_to_state(int whichfork)
 {

