Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225DF1375
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lYlXf/bD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD091C433C7;
	Mon,  1 Jan 2024 00:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069019;
	bh=cbPabbEcezgK6l8m/KFrVILKl6kDIWNQLE1IOHXulmc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lYlXf/bD0mUJEeFhS72fboAb43+9LnnPo/LHKz1sr5m17CKDtOKLn8ET+hFmAs3EV
	 TMrxMTDB7SvIRy3BW/ubQY8xK7EZ+x9aoxOme6MyOK6+KVlP4I3OTxt74K9fx/VdxP
	 rRkhhyH47lARBvFMZYNECWP4Wwj/KO7zuSWebdFBcbJ0bO+WGXqLlRt/+p3VjJMBvj
	 Ah8EyaK9j8Jwv7s2UDbA6aTsjZ4KINJnfiVaN0cXNBuR42c928dyDcbrgAAjGTf1l7
	 FCke0mRJYxqb5+I74jXmRA+QoNHqiSC+su9VukDDvzlzJQyir/EeE0jWUvHfWNpkQr
	 egq1ST/YVNvjQ==
Date: Sun, 31 Dec 2023 16:30:19 +9900
Subject: [PATCH 16/42] xfs: refcover CoW leftovers in the realtime volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017339.1817107.3217896289264332630.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Scan the realtime refcount tree at mount time to get rid of leftover
CoW staging extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount.c |   64 ++++++++++++++++++++++++++++++++++++++-----------
 libxfs/xfs_refcount.h |    4 ++-
 2 files changed, 53 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 3f0f0f41a69..e094acbe663 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -2075,14 +2075,15 @@ xfs_refcount_recover_extent(
 }
 
 /* Find and remove leftover CoW reservations. */
-int
-xfs_refcount_recover_cow_leftovers(
+static int
+xfs_refcount_recover_group_cow_leftovers(
 	struct xfs_mount		*mp,
-	struct xfs_perag		*pag)
+	struct xfs_perag		*pag,
+	struct xfs_rtgroup		*rtg)
 {
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*cur;
-	struct xfs_buf			*agbp;
+	struct xfs_buf			*agbp = NULL;
 	struct xfs_refcount_recovery	*rr, *n;
 	struct list_head		debris;
 	union xfs_btree_irec		low = {
@@ -2097,7 +2098,12 @@ xfs_refcount_recover_cow_leftovers(
 
 	/* reflink filesystems mustn't have AGs larger than 2^31-1 blocks */
 	BUILD_BUG_ON(XFS_MAX_CRC_AG_BLOCKS >= XFS_REFC_COWFLAG);
-	if (mp->m_sb.sb_agblocks > XFS_MAX_CRC_AG_BLOCKS)
+	if (pag && mp->m_sb.sb_agblocks > XFS_MAX_CRC_AG_BLOCKS)
+		return -EOPNOTSUPP;
+
+	/* rtreflink filesystems can't have rtgroups larger than 2^31-1 blocks */
+	BUILD_BUG_ON(XFS_MAX_RGBLOCKS >= XFS_REFC_COWFLAG);
+	if (rtg && mp->m_sb.sb_rgblocks >= XFS_MAX_RGBLOCKS)
 		return -EOPNOTSUPP;
 
 	INIT_LIST_HEAD(&debris);
@@ -2116,16 +2122,25 @@ xfs_refcount_recover_cow_leftovers(
 	if (error)
 		return error;
 
-	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
-	if (error)
-		goto out_trans;
-	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
+	if (rtg) {
+		xfs_rtgroup_lock(NULL, rtg, XFS_RTGLOCK_REFCOUNT);
+		cur = xfs_rtrefcountbt_init_cursor(mp, tp, rtg,
+				rtg->rtg_refcountip);
+	} else {
+		error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
+		if (error)
+			goto out_trans;
+		cur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
+	}
 
 	/* Find all the leftover CoW staging extents. */
 	error = xfs_btree_query_range(cur, &low, &high,
 			xfs_refcount_recover_extent, &debris);
 	xfs_btree_del_cursor(cur, error);
-	xfs_trans_brelse(tp, agbp);
+	if (agbp)
+		xfs_trans_brelse(tp, agbp);
+	else
+		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_REFCOUNT);
 	xfs_trans_cancel(tp);
 	if (error)
 		goto out_free;
@@ -2138,15 +2153,20 @@ xfs_refcount_recover_cow_leftovers(
 			goto out_free;
 
 		/* Free the orphan record */
-		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
-				rr->rr_rrec.rc_startblock);
-		xfs_refcount_free_cow_extent(tp, false, fsb,
+		if (rtg)
+			fsb = xfs_rgbno_to_rtb(mp, rtg->rtg_rgno,
+					rr->rr_rrec.rc_startblock);
+		else
+			fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
+					rr->rr_rrec.rc_startblock);
+		xfs_refcount_free_cow_extent(tp, rtg != NULL, fsb,
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
 		error = xfs_free_extent_later(tp, fsb,
 				rr->rr_rrec.rc_blockcount, NULL,
-				XFS_AG_RESV_NONE, 0);
+				XFS_AG_RESV_NONE,
+				rtg != NULL ? XFS_FREE_EXTENT_REALTIME : 0);
 		if (error)
 			goto out_trans;
 
@@ -2170,6 +2190,22 @@ xfs_refcount_recover_cow_leftovers(
 	return error;
 }
 
+int
+xfs_refcount_recover_cow_leftovers(
+	struct xfs_mount		*mp,
+	struct xfs_perag		*pag)
+{
+	return xfs_refcount_recover_group_cow_leftovers(mp, pag, NULL);
+}
+
+int
+xfs_refcount_recover_rtcow_leftovers(
+	struct xfs_mount		*mp,
+	struct xfs_rtgroup		*rtg)
+{
+	return xfs_refcount_recover_group_cow_leftovers(mp, NULL, rtg);
+}
+
 /*
  * Scan part of the keyspace of the refcount records and tell us if the area
  * has no records, is fully mapped by records, or is partially filled.
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 56e5834feb6..18e0479d3d1 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -97,8 +97,10 @@ void xfs_refcount_alloc_cow_extent(struct xfs_trans *tp, bool isrt,
 		xfs_fsblock_t fsb, xfs_extlen_t len);
 void xfs_refcount_free_cow_extent(struct xfs_trans *tp, bool isrt,
 		xfs_fsblock_t fsb, xfs_extlen_t len);
-extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
+int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
 		struct xfs_perag *pag);
+int xfs_refcount_recover_rtcow_leftovers(struct xfs_mount *mp,
+		struct xfs_rtgroup *rtg);
 
 /*
  * While we're adjusting the refcounts records of an extent, we have

