Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B99B7E76D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995522; cv=none; b=ifiqevAdR9GTuXSAMmDo+YT9fuJcmjLirnfWECTAWav37EwK/uj2UQREbuITRHLtieJkx0R5iKao/+87PK0kSotO/joSjPYM7XhREG22eVLGCZI7LFOIpQrjqTZp70MkpJQOYcwq9VCQnpgr81SZbBYNPE36LZMlU0OlNCjbVIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995522; c=relaxed/simple;
	bh=xe/1Wajs9Areptv5v7cPr2zm2W3m2yAjUqpYbLoI+9k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k9ev6OL/EXVIovt2NXKj7VeZnKru5E/6uSRJbj8e4mqtUdy/1ZLCSfRCXWl4BAFNI4GCBmVbIAAP6LgCJo29AgiHw5NoOk+4i02YfsHxQLL4DRkVqM/56kYYqgfqrM7KDMPDr2a+dWXcIFvz+GZejJuVXWX6c8tWwuLJWTAwXTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hd05N22H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hd05N22H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B338DC4CED3;
	Mon, 23 Dec 2024 23:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995521;
	bh=xe/1Wajs9Areptv5v7cPr2zm2W3m2yAjUqpYbLoI+9k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Hd05N22HS4eQoXgzS5gj58osi0ZBphVEwHZ39smXG4GT7E1pJPFp2pm7IqICdv6zU
	 Xy1dIB1vvx7Vlnk49HuT11vHP8gwxfMww5Uba373OuskQcJDpF8ETG+EJuyVFn/H9d
	 RMywOyY9N9jgF2oPJIn+7+YHcZC+Gs4mIL7Mo5jCR/0I5r0Q9p1Qvls+fDRZ0f9/LR
	 ljHrypZvNjXiOEw2hgGTohGX2G7ufUobByli0l+XoPyFlT42jNWj8hLDldNiTNbvuy
	 wzfgoGnos2dTymeUIhOJuPz763Or6wMw46/PxwWSQ8QXNcvY1jsaipfIySFtaxOfHQ
	 D1oUQ1iz0ApQA==
Date: Mon, 23 Dec 2024 15:12:01 -0800
Subject: [PATCH 22/43] xfs: recover CoW leftovers in the realtime volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420315.2381378.16295307942857155249.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Scan the realtime refcount tree at mount time to get rid of leftover
CoW staging extents.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_refcount.c |   47 +++++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_refcount.h |    3 +--
 fs/xfs/xfs_reflink.c         |   15 +++++++++++--
 3 files changed, 46 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 11bff098db2dbb..cebe83f7842a1c 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -2054,12 +2054,13 @@ xfs_refcount_recover_extent(
 /* Find and remove leftover CoW reservations. */
 int
 xfs_refcount_recover_cow_leftovers(
-	struct xfs_mount		*mp,
-	struct xfs_perag		*pag)
+	struct xfs_group		*xg)
 {
+	struct xfs_mount		*mp = xg->xg_mount;
+	bool				isrt = xg->xg_type == XG_TYPE_RTG;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*cur;
-	struct xfs_buf			*agbp;
+	struct xfs_buf			*agbp = NULL;
 	struct xfs_refcount_recovery	*rr, *n;
 	struct list_head		debris;
 	union xfs_btree_irec		low = {
@@ -2072,10 +2073,19 @@ xfs_refcount_recover_cow_leftovers(
 	xfs_fsblock_t			fsb;
 	int				error;
 
-	/* reflink filesystems mustn't have AGs larger than 2^31-1 blocks */
+	/* reflink filesystems must not have groups larger than 2^31-1 blocks */
+	BUILD_BUG_ON(XFS_MAX_RGBLOCKS >= XFS_REFC_COWFLAG);
 	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COWFLAG);
-	if (mp->m_sb.sb_agblocks > XFS_MAX_CRC_AG_BLOCKS)
-		return -EOPNOTSUPP;
+
+	if (isrt) {
+		if (!xfs_has_rtgroups(mp))
+			return 0;
+		if (xfs_group_max_blocks(xg) >= XFS_MAX_RGBLOCKS)
+			return -EOPNOTSUPP;
+	} else {
+		if (xfs_group_max_blocks(xg) > XFS_MAX_CRC_AG_BLOCKS)
+			return -EOPNOTSUPP;
+	}
 
 	INIT_LIST_HEAD(&debris);
 
@@ -2093,16 +2103,24 @@ xfs_refcount_recover_cow_leftovers(
 	if (error)
 		return error;
 
-	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
-	if (error)
-		goto out_trans;
-	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
+	if (isrt) {
+		xfs_rtgroup_lock(to_rtg(xg), XFS_RTGLOCK_REFCOUNT);
+		cur = xfs_rtrefcountbt_init_cursor(tp, to_rtg(xg));
+	} else {
+		error = xfs_alloc_read_agf(to_perag(xg), tp, 0, &agbp);
+		if (error)
+			goto out_trans;
+		cur = xfs_refcountbt_init_cursor(mp, tp, agbp, to_perag(xg));
+	}
 
 	/* Find all the leftover CoW staging extents. */
 	error = xfs_btree_query_range(cur, &low, &high,
 			xfs_refcount_recover_extent, &debris);
 	xfs_btree_del_cursor(cur, error);
-	xfs_trans_brelse(tp, agbp);
+	if (agbp)
+		xfs_trans_brelse(tp, agbp);
+	else
+		xfs_rtgroup_unlock(to_rtg(xg), XFS_RTGLOCK_REFCOUNT);
 	xfs_trans_cancel(tp);
 	if (error)
 		goto out_free;
@@ -2115,14 +2133,15 @@ xfs_refcount_recover_cow_leftovers(
 			goto out_free;
 
 		/* Free the orphan record */
-		fsb = xfs_agbno_to_fsb(pag, rr->rr_rrec.rc_startblock);
-		xfs_refcount_free_cow_extent(tp, false, fsb,
+		fsb = xfs_gbno_to_fsb(xg, rr->rr_rrec.rc_startblock);
+		xfs_refcount_free_cow_extent(tp, isrt, fsb,
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
 		error = xfs_free_extent_later(tp, fsb,
 				rr->rr_rrec.rc_blockcount, NULL,
-				XFS_AG_RESV_NONE, 0);
+				XFS_AG_RESV_NONE,
+				isrt ? XFS_FREE_EXTENT_REALTIME : 0);
 		if (error)
 			goto out_trans;
 
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index be11df25abcc5b..f2e299a716a4ee 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -94,8 +94,7 @@ void xfs_refcount_alloc_cow_extent(struct xfs_trans *tp, bool isrt,
 		xfs_fsblock_t fsb, xfs_extlen_t len);
 void xfs_refcount_free_cow_extent(struct xfs_trans *tp, bool isrt,
 		xfs_fsblock_t fsb, xfs_extlen_t len);
-extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
-		struct xfs_perag *pag);
+int xfs_refcount_recover_cow_leftovers(struct xfs_group *xg);
 
 /*
  * While we're adjusting the refcounts records of an extent, we have
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 78b47b2ac12453..d9b33e22c17669 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -983,20 +983,29 @@ xfs_reflink_recover_cow(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
 	int			error = 0;
 
 	if (!xfs_has_reflink(mp))
 		return 0;
 
 	while ((pag = xfs_perag_next(mp, pag))) {
-		error = xfs_refcount_recover_cow_leftovers(mp, pag);
+		error = xfs_refcount_recover_cow_leftovers(pag_group(pag));
 		if (error) {
 			xfs_perag_rele(pag);
-			break;
+			return error;
 		}
 	}
 
-	return error;
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		error = xfs_refcount_recover_cow_leftovers(rtg_group(rtg));
+		if (error) {
+			xfs_rtgroup_rele(rtg);
+			return error;
+		}
+	}
+
+	return 0;
 }
 
 /*

