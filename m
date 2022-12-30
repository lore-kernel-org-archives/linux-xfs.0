Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B525C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbiLaBvp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236099AbiLaBvo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:51:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD191DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:51:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E0BAB81DFC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10046C433D2;
        Sat, 31 Dec 2022 01:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451500;
        bh=U4rDCvlqw8j5LqX4RctbnuqbHVf3uo5s2jb5vM/3mTo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J4PSdYVjNPWspHM/kTQCGYOoaPb3/1Osl66Lo1uvZOo7dkNUK7OM7/C/cyb0ouTsc
         YPBoiQGdAdWrnv9zFOkrtp39v+6JfRCwypK4IqF+98cFMOXhqNRxhzu7eD3lKmsE5I
         YNYNxpNprjkUfmIj8JFH1hwKXpRu9YniWJNbdva72U8UseaiaAOBEEs2jnCkW4AvjE
         0l8VjHcLn6eS3Qd3mPcYhrSXJGoUI3Wi5IReMoWxFve12TYOdqhRp9RETaBRjpbD90
         5TljgdlibJXAwCEA9bZwWh7rToi++LBhxV2QloJnc9k7r7kgiNxXhAFF5Ui4WBmCs7
         sBqz8fLW1Vopg==
Subject: [PATCH 14/42] xfs: wire up realtime refcount btree cursors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871097.717073.7853127836397868533.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Wire up realtime refcount btree cursors wherever they're needed
throughout the code base.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |    7 ++-
 fs/xfs/libxfs/xfs_rtgroup.c  |   10 ++++
 fs/xfs/libxfs/xfs_rtgroup.h  |    5 ++
 fs/xfs/xfs_fsmap.c           |   22 ++++++---
 fs/xfs/xfs_reflink.c         |   99 ++++++++++++++++++++++++++++++++++--------
 5 files changed, 111 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 999ba2c5c37d..c4ab749c78e4 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -26,6 +26,7 @@
 #include "xfs_health.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtalloc.h"
+#include "xfs_rtrefcount_btree.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -1485,9 +1486,9 @@ xfs_refcount_finish_one(
 	}
 	if (rcur == NULL) {
 		if (ri->ri_realtime) {
-			/* coming in a later patch */
-			ASSERT(0);
-			return -EFSCORRUPTED;
+			xfs_rtgroup_lock(tp, ri->ri_rtg, XFS_RTGLOCK_REFCOUNT);
+			rcur = xfs_rtrefcountbt_init_cursor(mp, tp, ri->ri_rtg,
+					ri->ri_rtg->rtg_refcountip);
 		} else {
 			error = xfs_alloc_read_agf(ri->ri_pag, tp,
 					XFS_ALLOC_FLAG_FREEING, &agbp);
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index bd878e65bc44..836b19e0406d 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -524,6 +524,13 @@ xfs_rtgroup_lock(
 		if (tp)
 			xfs_trans_ijoin(tp, rtg->rtg_rmapip, XFS_ILOCK_EXCL);
 	}
+
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg->rtg_refcountip) {
+		xfs_ilock(rtg->rtg_refcountip, XFS_ILOCK_EXCL);
+		if (tp)
+			xfs_trans_ijoin(tp, rtg->rtg_refcountip,
+					XFS_ILOCK_EXCL);
+	}
 }
 
 /* Unlock metadata inodes associated with this rt group. */
@@ -536,6 +543,9 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg->rtg_refcountip)
+		xfs_iunlock(rtg->rtg_refcountip, XFS_ILOCK_EXCL);
+
 	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg->rtg_rmapip)
 		xfs_iunlock(rtg->rtg_rmapip, XFS_ILOCK_EXCL);
 
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 0f400f133d88..4f0358d63457 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -237,10 +237,13 @@ int xfs_rtgroup_init_secondary_super(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 #define XFS_RTGLOCK_BITMAP_SHARED	(1U << 1)
 /* Lock the rt rmap inode in exclusive mode */
 #define XFS_RTGLOCK_RMAP		(1U << 2)
+/* Lock the rt refcount inode in exclusive mode */
+#define XFS_RTGLOCK_REFCOUNT		(1U << 3)
 
 #define XFS_RTGLOCK_ALL_FLAGS	(XFS_RTGLOCK_BITMAP | \
 				 XFS_RTGLOCK_BITMAP_SHARED | \
-				 XFS_RTGLOCK_RMAP)
+				 XFS_RTGLOCK_RMAP | \
+				 XFS_RTGLOCK_REFCOUNT)
 
 void xfs_rtgroup_lock(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index efbcc4b1d850..5f7e7ea2fde3 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -27,6 +27,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 static void
@@ -209,14 +210,16 @@ xfs_getfsmap_is_shared(
 	*stat = false;
 	if (!xfs_has_reflink(mp))
 		return 0;
-	/* rt files will have no perag structure */
-	if (!info->pag)
-		return 0;
+
+	if (info->rtg)
+		cur = xfs_rtrefcountbt_init_cursor(mp, tp, info->rtg,
+				info->rtg->rtg_refcountip);
+	else
+		cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
+				info->pag);
 
 	/* Are there any shared blocks here? */
 	flen = 0;
-	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp, info->pag);
-
 	error = xfs_refcount_find_shared(cur, rec->rm_startblock,
 			rec->rm_blockcount, &fbno, &flen, false);
 
@@ -820,7 +823,8 @@ xfs_getfsmap_rtdev_rmapbt_query(
 		return xfs_getfsmap_rtdev_helper(*curpp, &info->high, info);
 
 	/* Query the rtrmapbt */
-	xfs_rtgroup_lock(NULL, info->rtg, XFS_RTGLOCK_RMAP);
+	xfs_rtgroup_lock(NULL, info->rtg, XFS_RTGLOCK_RMAP |
+					  XFS_RTGLOCK_REFCOUNT);
 	*curpp = xfs_rtrmapbt_init_cursor(mp, tp, info->rtg,
 			info->rtg->rtg_rmapip);
 	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
@@ -893,7 +897,8 @@ xfs_getfsmap_rtdev_rmapbt(
 
 		if (bt_cur) {
 			xfs_rtgroup_unlock(bt_cur->bc_ino.rtg,
-					XFS_RTGLOCK_RMAP);
+					XFS_RTGLOCK_RMAP |
+					XFS_RTGLOCK_REFCOUNT);
 			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
 			bt_cur = NULL;
 		}
@@ -934,7 +939,8 @@ xfs_getfsmap_rtdev_rmapbt(
 	}
 
 	if (bt_cur) {
-		xfs_rtgroup_unlock(bt_cur->bc_ino.rtg, XFS_RTGLOCK_RMAP);
+		xfs_rtgroup_unlock(bt_cur->bc_ino.rtg, XFS_RTGLOCK_RMAP |
+						       XFS_RTGLOCK_REFCOUNT);
 		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
 							 XFS_BTREE_NOERROR);
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 52e73aa2c38e..1a8a254c81f4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -30,6 +30,9 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_health.h"
+#include "xfs_rtrefcount_btree.h"
+#include "xfs_rtalloc.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -155,6 +158,38 @@ xfs_reflink_find_shared(
 	return error;
 }
 
+/*
+ * Given an RT extent, find the lowest-numbered run of shared blocks
+ * within that range and return the range in fbno/flen.  If
+ * find_end_of_shared is true, return the longest contiguous extent of
+ * shared blocks.  If there are no shared extents, fbno and flen will
+ * be set to NULLRGBLOCK and 0, respectively.
+ */
+static int
+xfs_reflink_find_rtshared(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_trans	*tp,
+	xfs_agblock_t		rtbno,
+	xfs_extlen_t		rtlen,
+	xfs_agblock_t		*fbno,
+	xfs_extlen_t		*flen,
+	bool			find_end_of_shared)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	BUILD_BUG_ON(NULLRGBLOCK != NULLAGBLOCK);
+
+	xfs_rtgroup_lock(NULL, rtg, XFS_RTGLOCK_REFCOUNT);
+	cur = xfs_rtrefcountbt_init_cursor(mp, tp, rtg, rtg->rtg_refcountip);
+	error = xfs_refcount_find_shared(cur, rtbno, rtlen, fbno, flen,
+			find_end_of_shared);
+	xfs_btree_del_cursor(cur, error);
+	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_REFCOUNT);
+	return error;
+}
+
 /*
  * Trim the mapping to the next block where there's a change in the
  * shared/unshared status.  More specifically, this means that we
@@ -172,9 +207,7 @@ xfs_reflink_trim_around_shared(
 	bool			*shared)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_perag	*pag;
-	xfs_agblock_t		agbno;
-	xfs_extlen_t		aglen;
+	xfs_agblock_t		orig_bno;
 	xfs_agblock_t		fbno;
 	xfs_extlen_t		flen;
 	int			error = 0;
@@ -187,13 +220,25 @@ xfs_reflink_trim_around_shared(
 
 	trace_xfs_reflink_trim_around_shared(ip, irec);
 
-	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, irec->br_startblock));
-	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
-	aglen = irec->br_blockcount;
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		struct xfs_rtgroup	*rtg;
+		xfs_rgnumber_t		rgno;
 
-	error = xfs_reflink_find_shared(pag, NULL, agbno, aglen, &fbno, &flen,
-			true);
-	xfs_perag_put(pag);
+		orig_bno = xfs_rtb_to_rgbno(mp, irec->br_startblock, &rgno);
+		rtg = xfs_rtgroup_get(mp, rgno);
+		error = xfs_reflink_find_rtshared(rtg, NULL, orig_bno,
+				irec->br_blockcount, &fbno, &flen, true);
+		xfs_rtgroup_put(rtg);
+	} else {
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp,
+					irec->br_startblock));
+		orig_bno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
+		error = xfs_reflink_find_shared(pag, NULL, orig_bno,
+				irec->br_blockcount, &fbno, &flen, true);
+		xfs_perag_put(pag);
+	}
 	if (error)
 		return error;
 
@@ -203,7 +248,7 @@ xfs_reflink_trim_around_shared(
 		return 0;
 	}
 
-	if (fbno == agbno) {
+	if (fbno == orig_bno) {
 		/*
 		 * The start of this extent is shared.  Truncate the
 		 * mapping at the end of the shared region so that a
@@ -221,7 +266,7 @@ xfs_reflink_trim_around_shared(
 	 * extent so that a subsequent iteration starts at the
 	 * start of the shared region.
 	 */
-	irec->br_blockcount = fbno - agbno;
+	irec->br_blockcount = fbno - orig_bno;
 	return 0;
 }
 
@@ -1574,9 +1619,6 @@ xfs_reflink_inode_has_shared_extents(
 	*has_shared = false;
 	found = xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got);
 	while (found) {
-		struct xfs_perag	*pag;
-		xfs_agblock_t		agbno;
-		xfs_extlen_t		aglen;
 		xfs_agblock_t		rbno;
 		xfs_extlen_t		rlen;
 
@@ -1584,12 +1626,29 @@ xfs_reflink_inode_has_shared_extents(
 		    got.br_state != XFS_EXT_NORM)
 			goto next;
 
-		pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, got.br_startblock));
-		agbno = XFS_FSB_TO_AGBNO(mp, got.br_startblock);
-		aglen = got.br_blockcount;
-		error = xfs_reflink_find_shared(pag, tp, agbno, aglen,
-				&rbno, &rlen, false);
-		xfs_perag_put(pag);
+		if (XFS_IS_REALTIME_INODE(ip)) {
+			struct xfs_rtgroup	*rtg;
+			xfs_rgnumber_t		rgno;
+			xfs_rgblock_t		rgbno;
+
+			rgbno = xfs_rtb_to_rgbno(mp, got.br_startblock, &rgno);
+			rtg = xfs_rtgroup_get(mp, rgno);
+			error = xfs_reflink_find_rtshared(rtg, tp, rgbno,
+					got.br_blockcount, &rbno, &rlen,
+					false);
+			xfs_rtgroup_put(rtg);
+		} else {
+			struct xfs_perag	*pag;
+			xfs_agblock_t		agbno;
+
+			pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp,
+						got.br_startblock));
+			agbno = XFS_FSB_TO_AGBNO(mp, got.br_startblock);
+			error = xfs_reflink_find_shared(pag, tp, agbno,
+					got.br_blockcount, &rbno, &rlen,
+					false);
+			xfs_perag_put(pag);
+		}
 		if (error)
 			return error;
 

