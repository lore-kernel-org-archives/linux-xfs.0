Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B097C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbiLaBlG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbiLaBlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:41:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184C726D2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:41:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A65CA61C63
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB10C433D2;
        Sat, 31 Dec 2022 01:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450861;
        bh=V7AXyfRlDQHqrRJI0UD4V5nbQlD6WPtgmNUtv1oV9ao=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uVdSiERwUtpOXpHtpy6dFklhk6/N9aGO3XiC07qrs7UL31Vz10v/9RROKKsTFbw6E
         CG8evLuKOwwIoCLHhBmZx6msHV8y/zJqs+GznUW5R/q/6AuX+b+s0R+I4bNVBVmZZr
         wxavb27u15jdq2irwETSd/UIdG6twVJfzkvBuVX4C6jdPqtrza4miq0/NQK7CnSz9s
         VFef1k1IM8gVvo+CM60gkwvZzxXztk5O7JwRRzXD11NiGrgUEq0tn2L5yS03knkAc3
         xsxAtfFlcYWJ1Jr1xuNggx6K3CEJ6ABap1PL/1MdVmjU12ztIow3dcOeJLOhquAWYj
         eEwbFr3DSx7fg==
Subject: [PATCH 16/38] xfs: wire up rmap map and unmap to the realtime rmapbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:18 -0800
Message-ID: <167243869827.715303.11017000588580522165.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Connect the map and unmap reverse-mapping operations to the realtime
rmapbt via the deferred operation callbacks.  This enables us to
perform rmap operations against the correct btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c    |   80 +++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_rtgroup.c |    9 +++++
 fs/xfs/libxfs/xfs_rtgroup.h |    5 ++-
 3 files changed, 63 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 1a3607082d12..e3bff42d003d 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -25,6 +25,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -2591,13 +2592,14 @@ xfs_rmap_finish_one_cleanup(
 	struct xfs_btree_cur	*rcur,
 	int			error)
 {
-	struct xfs_buf		*agbp;
+	struct xfs_buf		*agbp = NULL;
 
 	if (rcur == NULL)
 		return;
-	agbp = rcur->bc_ag.agbp;
+	if (rcur->bc_btnum == XFS_BTNUM_RMAP)
+		agbp = rcur->bc_ag.agbp;
 	xfs_btree_del_cursor(rcur, error);
-	if (error)
+	if (error && agbp)
 		xfs_trans_brelse(tp, agbp);
 }
 
@@ -2633,6 +2635,17 @@ __xfs_rmap_finish_intent(
 	}
 }
 
+/* Does this btree cursor match the given group object? */
+static inline bool
+xfs_rmap_is_wrong_cursor(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_intent	*ri)
+{
+	if (cur->bc_btnum == XFS_BTNUM_RTRMAP)
+		return cur->bc_ino.rtg != ri->ri_rtg;
+	return cur->bc_ag.pag != ri->ri_pag;
+}
+
 /*
  * Process one of the deferred rmap operations.  We pass back the
  * btree cursor to maintain our lock on the rmapbt between calls.
@@ -2646,24 +2659,24 @@ xfs_rmap_finish_one(
 	struct xfs_rmap_intent		*ri,
 	struct xfs_btree_cur		**pcur)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_btree_cur		*rcur;
 	struct xfs_buf			*agbp = NULL;
-	int				error = 0;
-	struct xfs_owner_info		oinfo;
 	xfs_agblock_t			bno;
 	bool				unwritten;
-
-	if (ri->ri_realtime) {
-		/* coming in a subsequent patch */
-		ASSERT(0);
-		return -EFSCORRUPTED;
-	}
-
-	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_bmap.br_startblock);
+	int				error = 0;
 
 	trace_xfs_rmap_deferred(mp, ri);
 
+	if (ri->ri_realtime) {
+		xfs_rgnumber_t		rgno;
+
+		bno = xfs_rtb_to_rgbno(mp, ri->ri_bmap.br_startblock, &rgno);
+	} else {
+		bno = XFS_FSB_TO_AGBNO(mp, ri->ri_bmap.br_startblock);
+	}
+
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE))
 		return -EIO;
 
@@ -2672,35 +2685,42 @@ xfs_rmap_finish_one(
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
+	if (rcur != NULL && xfs_rmap_is_wrong_cursor(rcur, ri)) {
 		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
 	}
 	if (rcur == NULL) {
-		/*
-		 * Refresh the freelist before we start changing the
-		 * rmapbt, because a shape change could cause us to
-		 * allocate blocks.
-		 */
-		error = xfs_free_extent_fix_freelist(tp, ri->ri_pag, &agbp);
-		if (error) {
-			xfs_ag_mark_sick(ri->ri_pag, XFS_SICK_AG_AGFL);
-			return error;
-		}
-		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
-			xfs_ag_mark_sick(ri->ri_pag, XFS_SICK_AG_AGFL);
-			return -EFSCORRUPTED;
-		}
+		if (ri->ri_realtime) {
+			xfs_rtgroup_lock(tp, ri->ri_rtg, XFS_RTGLOCK_RMAP);
+			rcur = xfs_rtrmapbt_init_cursor(mp, tp, ri->ri_rtg,
+					ri->ri_rtg->rtg_rmapip);
+			rcur->bc_ino.flags = 0;
+		} else {
+			/*
+			 * Refresh the freelist before we start changing the
+			 * rmapbt, because a shape change could cause us to
+			 * allocate blocks.
+			 */
+			error = xfs_free_extent_fix_freelist(tp, ri->ri_pag,
+					&agbp);
+			if (error) {
+				xfs_ag_mark_sick(ri->ri_pag, XFS_SICK_AG_AGFL);
+				return error;
+			}
+			if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
+				xfs_ag_mark_sick(ri->ri_pag, XFS_SICK_AG_AGFL);
+				return -EFSCORRUPTED;
+			}
 
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
+			rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
+		}
 	}
 	*pcur = rcur;
 
 	xfs_rmap_ino_owner(&oinfo, ri->ri_owner, ri->ri_whichfork,
 			ri->ri_bmap.br_startoff);
 	unwritten = ri->ri_bmap.br_state == XFS_EXT_UNWRITTEN;
-	bno = XFS_FSB_TO_AGBNO(rcur->bc_mp, ri->ri_bmap.br_startblock);
 
 	error = __xfs_rmap_finish_intent(rcur, ri->ri_type, bno,
 			ri->ri_bmap.br_blockcount, &oinfo, unwritten);
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 4d9e2c0f2fd3..d6b790741265 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -515,6 +515,12 @@ xfs_rtgroup_lock(
 		xfs_rtbitmap_lock(tp, rtg->rtg_mount);
 	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
 		xfs_rtbitmap_lock_shared(rtg->rtg_mount, XFS_RBMLOCK_BITMAP);
+
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg->rtg_rmapip) {
+		xfs_ilock(rtg->rtg_rmapip, XFS_ILOCK_EXCL);
+		if (tp)
+			xfs_trans_ijoin(tp, rtg->rtg_rmapip, XFS_ILOCK_EXCL);
+	}
 }
 
 /* Unlock metadata inodes associated with this rt group. */
@@ -527,6 +533,9 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg->rtg_rmapip)
+		xfs_iunlock(rtg->rtg_rmapip, XFS_ILOCK_EXCL);
+
 	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
 		xfs_rtbitmap_unlock(rtg->rtg_mount);
 	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 1792a9ab3bbf..3230dd03d8f8 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -220,9 +220,12 @@ int xfs_rtgroup_init_secondary_super(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 #define XFS_RTGLOCK_BITMAP		(1U << 0)
 /* Lock the rt bitmap inode in shared mode */
 #define XFS_RTGLOCK_BITMAP_SHARED	(1U << 1)
+/* Lock the rt rmap inode in exclusive mode */
+#define XFS_RTGLOCK_RMAP		(1U << 2)
 
 #define XFS_RTGLOCK_ALL_FLAGS	(XFS_RTGLOCK_BITMAP | \
-				 XFS_RTGLOCK_BITMAP_SHARED)
+				 XFS_RTGLOCK_BITMAP_SHARED | \
+				 XFS_RTGLOCK_RMAP)
 
 void xfs_rtgroup_lock(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);

