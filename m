Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF56B23A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442350; cv=none; b=ROX1PON+uiZzUB/slBgf+yhLGbbNaj97u75h0mU1YEkffXwRn/DtQ2gvWIOzwjsuHa0pImGd56cIBT1PFuc9GP5yobddLd4H71JP+btP/qU+2qgUJYBzF8TRBIPTVxlpGu4gHAnL0ZkYgG9KlwHE35O0tzFfKlEqlPts3ukeGws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442350; c=relaxed/simple;
	bh=HSDSnJkBfcVdP/qLvkWnIkxfF6WcnMGDadIwKjvGA9Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HFYe+TZBGkxim1F/CakAXoaLyZAKmNTiSSIiUB9CpMAKvSybqNETDRKJAgdMlAT+R4H2zZVFz15OTcLE+hFJrD8V8YyqTjWMzshivW0CwIeAlnN+78RbAhCX5adrQRGwD830aiavXX3wnUoxKsu018WIEUkerezvkYFX4khsZ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4H1oeEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4H1oeEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543FBC2BD10;
	Mon,  3 Jun 2024 19:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442350;
	bh=HSDSnJkBfcVdP/qLvkWnIkxfF6WcnMGDadIwKjvGA9Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J4H1oeEKzd37ZlkxvpPCeB5H1sLNZgue17EFk3ai769iImSu70CPRhthTHdcCkC+C
	 2yxPK7raGj7P7hHutJG0P2Dp5gTozHeELy2gxZp5Pvk92sjPIF6mdfy+jEknKQ1iPB
	 d/vl4qIgVdrqEnkME6s8OZHJ5+jM4VgSE483sfygZpQuIypLic+CqVeVWx6gsBfEqO
	 Da5hfbRVARiHLOZGspEIkrfGesNx9NHLbe/qQpdc9brAGd2nqPmpA+XkQdSvdvT7I1
	 7Vir13ieIHTRrrDGSxzvyDI9cN+Gt3NTzVeetaRy6Rxqw+GBjtcEQcYSS9nx7xM+cv
	 bek1qCl8n6SDw==
Date: Mon, 03 Jun 2024 12:19:09 -0700
Subject: [PATCH 104/111] xfs: support deferred bmap updates on the attr fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040928.1443973.6116615704230347699.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 52f807067ba4a122e75bf1e0e0595c78e6a3d8b6

The deferred bmap update log item has always supported the attr fork, so
plumb this in so that higher layers can access this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

