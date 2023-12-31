Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B0BBE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hm/UXfuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7448C433C7;
	Sun, 31 Dec 2023 21:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059418;
	bh=VWMG0J6Oias3h+XfVej18h2xIfXCbz8i71qkZJWDo8w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hm/UXfuKbOFQyKL+C1z2p4HW26GXn+On4YoJeifbZnPnnxzuT7+2oUP/oO9udFZVk
	 CG4BWwTFulRHEQN1eGuwDwQo4fVG29a0GAsd077uhUKl8c79Cv4Tb3afeT+de5ecZi
	 CErFqfG9NaK/4duNtAikdHadjVNiHpla5OXNLRBfPjKYnYk0IojMcziqudH7kynd70
	 fjLELvZlYlmiu/42xQzqs2UQgWXIjh5FqctYXY3FRVv8AHb99kPvyr9nSH76UiuR6C
	 btpaY7ZTAuIAu13w0V1sY5/ysmbao6II4mheQW/9fE2RiuhPccanNinu9YZDrxiD3i
	 oe6g8rCHzqXNA==
Date: Sun, 31 Dec 2023 13:50:18 -0800
Subject: [PATCH 22/44] xfs: refcover CoW leftovers in the realtime volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851936.1766284.12778272460691965326.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_refcount.c |   64 +++++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_refcount.h |    4 ++-
 fs/xfs/xfs_reflink.c         |   14 ++++++++-
 3 files changed, 65 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 60e838adde0d8..b4ec6077270a7 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -2077,14 +2077,15 @@ xfs_refcount_recover_extent(
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
@@ -2099,7 +2100,12 @@ xfs_refcount_recover_cow_leftovers(
 
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
@@ -2118,16 +2124,25 @@ xfs_refcount_recover_cow_leftovers(
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
@@ -2140,15 +2155,20 @@ xfs_refcount_recover_cow_leftovers(
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
 
@@ -2172,6 +2192,22 @@ xfs_refcount_recover_cow_leftovers(
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
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 56e5834feb624..18e0479d3d1d0 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
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
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d05ab2c91bd98..b0f3170c11c8b 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1006,7 +1006,9 @@ xfs_reflink_recover_cow(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	int			error = 0;
 
 	if (!xfs_has_reflink(mp))
@@ -1016,11 +1018,19 @@ xfs_reflink_recover_cow(
 		error = xfs_refcount_recover_cow_leftovers(mp, pag);
 		if (error) {
 			xfs_perag_rele(pag);
-			break;
+			return error;
 		}
 	}
 
-	return error;
+	for_each_rtgroup(mp, rgno, rtg) {
+		error = xfs_refcount_recover_rtcow_leftovers(mp, rtg);
+		if (error) {
+			xfs_rtgroup_rele(rtg);
+			return error;
+		}
+	}
+
+	return 0;
 }
 
 /*

