Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF2623C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881667; cv=none; b=BhQ6ByupC7Ry9r4eHWWHXz+fxG0nZtutbm+l+C35/czpKzmksv7g2DGX5/pMs/2Cmik/ncgJrsrGiikhN//a7rjFxu2hxRQ+6u0mG2FiYqJr2f+lCeewCjETlh0r70B+liS9praaNZQqU9LJxMk7WHfnniVLv/7o48XbLS/H+uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881667; c=relaxed/simple;
	bh=qCWeTTpGaL/9U2TOXZXBfzLO47Ro8hvZwNJ4rmmkQPQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WyCh9T6gCVftHUuFPtSWXyS+oWPyewYr2Cwk1YA9JgkAtkhIjOdp7Xe6LLvgermWK1a5fQ0EyLkpWP1DngPYlhmw/9GXyID/2whrGEv/RLtRAeAM12tsamPNuNyEzthqM3RGE/xUCELYbADf+7VWldTktF37VFKZ5sWfaWUSdns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NAs3q9Jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NAs3q9Jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A42C4CEDD;
	Thu,  6 Feb 2025 22:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881666;
	bh=qCWeTTpGaL/9U2TOXZXBfzLO47Ro8hvZwNJ4rmmkQPQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NAs3q9Jkp3tnI4mvLARSG8+HqMz3KXi8DQzwSO7JSAAoiLdLF/6OJHpv8A59pFGDO
	 yST3rHp/5cogKkxD+SJlhZa59ZIFCkd/z/57Qys3cxxsCvwyo4hcfWZE07kdRRBsY3
	 Pxze2Y3sg0ZG1D8+GHToIRekfTBbHp1ePuUtlHqGO9wyq2/CY2X8+Z0CJoOGwXHsPK
	 1TQ+t2xoDunJhqln6z6g4udzZYKAkX9aN3Asb5GHC+eEPw/kur6G/WCGdTcfC6sCMI
	 nqH+HYI7yvluqCmDxCP4Fmh/xwhlsWcogQ/r0UvkuR4GxZToBo6akASek9dfuylU95
	 oo1SdmfsggF2w==
Date: Thu, 06 Feb 2025 14:41:06 -0800
Subject: [PATCH 23/56] xfs: wire up rmap map and unmap to the realtime rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087143.2739176.357371092291904445.stgit@frogsfrogsfrogs>
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

Source kernel commit: 609a592865c9e66a1c00eb7b8ee7436eea3c39a3

Connect the map and unmap reverse-mapping operations to the realtime
rmapbt via the deferred operation callbacks.  This enables us to
perform rmap operations against the correct btree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rmap.c    |   78 ++++++++++++++++++++++++++++++++++----------------
 libxfs/xfs_rtgroup.c |    9 ++++++
 libxfs/xfs_rtgroup.h |    5 +++
 3 files changed, 66 insertions(+), 26 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index a1a57cd0c62c10..551f158e5424f3 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -25,6 +25,7 @@
 #include "xfs_health.h"
 #include "defer_item.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -2618,6 +2619,47 @@ __xfs_rmap_finish_intent(
 	}
 }
 
+static int
+xfs_rmap_finish_init_cursor(
+	struct xfs_trans		*tp,
+	struct xfs_rmap_intent		*ri,
+	struct xfs_btree_cur		**pcur)
+{
+	struct xfs_perag		*pag = to_perag(ri->ri_group);
+	struct xfs_buf			*agbp = NULL;
+	int				error;
+
+	/*
+	 * Refresh the freelist before we start changing the rmapbt, because a
+	 * shape change could cause us to allocate blocks.
+	 */
+	error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
+	if (error) {
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGFL);
+		return error;
+	}
+	if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGFL);
+		return -EFSCORRUPTED;
+	}
+	*pcur = xfs_rmapbt_init_cursor(tp->t_mountp, tp, agbp, pag);
+	return 0;
+}
+
+static int
+xfs_rtrmap_finish_init_cursor(
+	struct xfs_trans		*tp,
+	struct xfs_rmap_intent		*ri,
+	struct xfs_btree_cur		**pcur)
+{
+	struct xfs_rtgroup		*rtg = to_rtg(ri->ri_group);
+
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
+	*pcur = xfs_rtrmapbt_init_cursor(tp, rtg);
+	return 0;
+}
+
 /*
  * Process one of the deferred rmap operations.  We pass back the
  * btree cursor to maintain our lock on the rmapbt between calls.
@@ -2633,8 +2675,6 @@ xfs_rmap_finish_one(
 {
 	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_btree_cur		*rcur = *pcur;
-	struct xfs_buf			*agbp = NULL;
 	xfs_agblock_t			bno;
 	bool				unwritten;
 	int				error = 0;
@@ -2648,38 +2688,26 @@ xfs_rmap_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	if (rcur != NULL && rcur->bc_group != ri->ri_group) {
-		xfs_btree_del_cursor(rcur, 0);
-		rcur = NULL;
+	if (*pcur != NULL && (*pcur)->bc_group != ri->ri_group) {
+		xfs_btree_del_cursor(*pcur, 0);
 		*pcur = NULL;
 	}
-	if (rcur == NULL) {
-		struct xfs_perag	*pag = to_perag(ri->ri_group);
-
-		/*
-		 * Refresh the freelist before we start changing the
-		 * rmapbt, because a shape change could cause us to
-		 * allocate blocks.
-		 */
-		error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
-		if (error) {
-			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGFL);
+	if (*pcur == NULL) {
+		if (ri->ri_group->xg_type == XG_TYPE_RTG)
+			error = xfs_rtrmap_finish_init_cursor(tp, ri, pcur);
+		else
+			error = xfs_rmap_finish_init_cursor(tp, ri, pcur);
+		if (error)
 			return error;
-		}
-		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
-			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGFL);
-			return -EFSCORRUPTED;
-		}
-
-		*pcur = rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
 	}
 
 	xfs_rmap_ino_owner(&oinfo, ri->ri_owner, ri->ri_whichfork,
 			ri->ri_bmap.br_startoff);
 	unwritten = ri->ri_bmap.br_state == XFS_EXT_UNWRITTEN;
-	bno = XFS_FSB_TO_AGBNO(rcur->bc_mp, ri->ri_bmap.br_startblock);
 
-	error = __xfs_rmap_finish_intent(rcur, ri->ri_type, bno,
+	bno = xfs_fsb_to_gbno(mp, ri->ri_bmap.br_startblock,
+			ri->ri_group->xg_type);
+	error = __xfs_rmap_finish_intent(*pcur, ri->ri_type, bno,
 			ri->ri_bmap.br_blockcount, &oinfo, unwritten);
 	if (error)
 		return error;
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index d46ce8e7fa6e85..f0c45e75e52c3e 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -199,6 +199,9 @@ xfs_rtgroup_lock(
 	} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
 		xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
 	}
+
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
+		xfs_ilock(rtg_rmap(rtg), XFS_ILOCK_EXCL);
 }
 
 /* Unlock metadata inodes associated with this rt group. */
@@ -211,6 +214,9 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
+		xfs_iunlock(rtg_rmap(rtg), XFS_ILOCK_EXCL);
+
 	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
 		xfs_iunlock(rtg_summary(rtg), XFS_ILOCK_EXCL);
 		xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
@@ -236,6 +242,9 @@ xfs_rtgroup_trans_join(
 		xfs_trans_ijoin(tp, rtg_bitmap(rtg), XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, rtg_summary(rtg), XFS_ILOCK_EXCL);
 	}
+
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
+		xfs_trans_ijoin(tp, rtg_rmap(rtg), XFS_ILOCK_EXCL);
 }
 
 /* Retrieve rt group geometry. */
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 09ec9f0e660160..6ff222a053674d 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -265,9 +265,12 @@ int xfs_update_last_rtgroup_size(struct xfs_mount *mp,
 #define XFS_RTGLOCK_BITMAP		(1U << 0)
 /* Lock the rt bitmap inode in shared mode */
 #define XFS_RTGLOCK_BITMAP_SHARED	(1U << 1)
+/* Lock the rt rmap inode in exclusive mode */
+#define XFS_RTGLOCK_RMAP		(1U << 2)
 
 #define XFS_RTGLOCK_ALL_FLAGS	(XFS_RTGLOCK_BITMAP | \
-				 XFS_RTGLOCK_BITMAP_SHARED)
+				 XFS_RTGLOCK_BITMAP_SHARED | \
+				 XFS_RTGLOCK_RMAP)
 
 void xfs_rtgroup_lock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);

