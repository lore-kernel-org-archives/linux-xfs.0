Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F262F1AAE23
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636439; cv=none; b=GvhsP4++BGyzzaHj5p9p/N4VDqVuiSRtQ0Gvlcvr4QasetluOmJg7WuCx4aex6z9pl6C6Lk+ZdJJFL4OKilAVdFKT3nQ2i3SdLbMltGLhA11skRsEP82BqJABAAe8Gb/6g8oVYNPJJdR1rSJs0luICiwG0bMb8hJT1DFygdoOsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636439; c=relaxed/simple;
	bh=BDLNw5ojHVsF3QiBZVgY0lhQkBSLB+6mVUlXUtPYuWY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TA7+d3rItOqMPPfgSXVE+kKyC14Dn9mdgGKyzaKTIxkfiwdrm07aWVFgFj0mMo4L7frL+yWtUFCziSxFn2Lfht0IxB/6dcOtjQyq6xBcJO2DRyelFWoq1VEa3njAhAfIviy4XEpQpVy3QssFjaqN9rfTQVQPoZBy2XwQEhzcqGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JscXPDLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JscXPDLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E85C4CED0;
	Thu, 19 Dec 2024 19:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636438;
	bh=BDLNw5ojHVsF3QiBZVgY0lhQkBSLB+6mVUlXUtPYuWY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JscXPDLshTSTbYg7EmExLVbYD88pE+NPX0KN0e1Em/buO7iJnpiZUM9izkeT87MLZ
	 mk6274vyR1lJzbQ+b9ITijyAp2mIA0f35IWQbqNtn179Uw2HUihD0UKLwcFZ85V/V7
	 I6+mbV6TCkTzwxSbgN0FZmS9R4Se3Z4lwxPlXCNzecoWAwSsbd+kr/I+g1Fm0dtnRt
	 rrWFrAV8g7DTZ0lqLEt9ZGEC3xJD7D76fPd9jbiis/8fwS12BQa7CZ7kAuzAyDk0VE
	 DfiF/NkxtDQ7f98+SypIFPhUCeafe/Q+vcpzzimDSdCbFhZ54HHIlbpXyUutlXgR68
	 1ckUyUNL7SjBQ==
Date: Thu, 19 Dec 2024 11:27:18 -0800
Subject: [PATCH 15/37] xfs: wire up rmap map and unmap to the realtime rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580014.1571512.17023560466220597231.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Connect the map and unmap reverse-mapping operations to the realtime
rmapbt via the deferred operation callbacks.  This enables us to
perform rmap operations against the correct btree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rmap.c    |   78 +++++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_rtgroup.c |    9 +++++
 fs/xfs/libxfs/xfs_rtgroup.h |    5 ++-
 3 files changed, 66 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 8d3cea90c7cd04..2f0688a57991cc 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -26,6 +26,7 @@
 #include "xfs_health.h"
 #include "xfs_rmap_item.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -2619,6 +2620,47 @@ __xfs_rmap_finish_intent(
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
@@ -2634,8 +2676,6 @@ xfs_rmap_finish_one(
 {
 	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_btree_cur		*rcur = *pcur;
-	struct xfs_buf			*agbp = NULL;
 	xfs_agblock_t			bno;
 	bool				unwritten;
 	int				error = 0;
@@ -2649,38 +2689,26 @@ xfs_rmap_finish_one(
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
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 1b56c13b282788..af1716ec0691a4 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -202,6 +202,9 @@ xfs_rtgroup_lock(
 	} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
 		xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
 	}
+
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
+		xfs_ilock(rtg_rmap(rtg), XFS_ILOCK_EXCL);
 }
 
 /* Unlock metadata inodes associated with this rt group. */
@@ -214,6 +217,9 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
+		xfs_iunlock(rtg_rmap(rtg), XFS_ILOCK_EXCL);
+
 	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
 		xfs_iunlock(rtg_summary(rtg), XFS_ILOCK_EXCL);
 		xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
@@ -239,6 +245,9 @@ xfs_rtgroup_trans_join(
 		xfs_trans_ijoin(tp, rtg_bitmap(rtg), XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, rtg_summary(rtg), XFS_ILOCK_EXCL);
 	}
+
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
+		xfs_trans_ijoin(tp, rtg_rmap(rtg), XFS_ILOCK_EXCL);
 }
 
 /* Retrieve rt group geometry. */
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 5b61291d26691f..733da7417c9cd7 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
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

