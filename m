Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35219C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbiLaCpl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbiLaCpk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:45:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7F82DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:45:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4846B81E65
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C150C433D2;
        Sat, 31 Dec 2022 02:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454736;
        bh=XapBZysnm+wpCnKbIfNJM0/tbfxi2dCCLAe5qO0Yg/o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ubM317PAb7SuucCN9HT8Mj9oGTtKO6DQq6HVw49puULezZlpMhgsz2hNdcE1jkE5H
         DX1mn2ShBomdCfEZ0MCbwvP3ob/CsM7djQ+tskNqP0M85xw4/6nIiI+Cc/kKCxI7Zz
         8TKyR773YsNWP/uu7Me7/T2jAkZJGLmcguckH6qt+KasJlVJWB0g4PzLrm16LD8tE2
         ceRUhqrzcfptgJrL7SuwGbfXIgKM4FtlViMS/EmpdFqmTinQm53osCN9EomCLKuwPI
         ha3TuXzPMVp4X6lg1pZOqsiOpvq3/rndUYLiHqr5I/mWmW7PgxLgBN3NOXThS6BWry
         Btxnhxk0+Jcrw==
Subject: [PATCH 12/41] xfs: wire up rmap map and unmap to the realtime rmapbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:57 -0800
Message-ID: <167243879756.732820.17573582865007777493.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
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
 libxfs/xfs_rmap.c    |   80 +++++++++++++++++++++++++++++++-------------------
 libxfs/xfs_rtgroup.c |    9 ++++++
 libxfs/xfs_rtgroup.h |    5 +++
 3 files changed, 63 insertions(+), 31 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 3700d702631..74fb9197cbc 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -24,6 +24,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -2590,13 +2591,14 @@ xfs_rmap_finish_one_cleanup(
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
 
@@ -2632,6 +2634,17 @@ __xfs_rmap_finish_intent(
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
@@ -2645,24 +2658,24 @@ xfs_rmap_finish_one(
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
 
@@ -2671,35 +2684,42 @@ xfs_rmap_finish_one(
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
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 97643fdcc7c..8018cd02e70 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -512,6 +512,12 @@ xfs_rtgroup_lock(
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
@@ -524,6 +530,9 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg->rtg_rmapip)
+		xfs_iunlock(rtg->rtg_rmapip, XFS_ILOCK_EXCL);
+
 	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
 		xfs_rtbitmap_unlock(rtg->rtg_mount);
 	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 1792a9ab3bb..3230dd03d8f 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
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

