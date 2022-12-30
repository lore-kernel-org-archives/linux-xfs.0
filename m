Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCB4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236004AbiLaBxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiLaBxs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:53:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6F41DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:53:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D16FCB81E07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955CEC433EF;
        Sat, 31 Dec 2022 01:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451624;
        bh=T66MDmflSIvYa/B7ALYYEzgRG4aKnzn/x+yTSG43sMg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Cn3UZOmgOReNLircsE8pmROL6heSUhqnDZbvILLBOdpI5S8Do8S5VY4H4bxL3oKQP
         WqlBJwyu+CnK3/GqjVu/3rvQhyUI0QZ6d1qiv76aBQyFumqR3+Hu1ZOqVERUKH0xok
         aY/kY1KFsUGDz1eRYelwMAM23Vklicz4VGZMvjz0eW9CxN3ru19I89rsf1rx7yuMaX
         U+m2zHbruo84MpJHQi0M6XnMEkciMQOqEycQLcUNuoVSi9xDZXXLGGE7/aSAm2KBOc
         HOMqNKoe6Rx4lLVXjCwBBrSgb5jfDxCsH/HpULYNexPyVBXRLMGDXe/pmky4NzW7gp
         tRuJYEct1GvwA==
Subject: [PATCH 22/42] xfs: refcover CoW leftovers in the realtime volume
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:32 -0800
Message-ID: <167243871209.717073.14280502191537429879.stgit@magnolia>
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

Scan the realtime refcount tree at mount time to get rid of leftover
CoW staging extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   63 +++++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_refcount.h |    5 +++
 fs/xfs/xfs_reflink.c         |   14 ++++++++-
 3 files changed, 65 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index c4ab749c78e4..8b878a7a5a3e 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -2037,14 +2037,15 @@ xfs_refcount_recover_extent(
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
 	union xfs_btree_irec		low;
@@ -2054,7 +2055,12 @@ xfs_refcount_recover_cow_leftovers(
 
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
@@ -2073,10 +2079,16 @@ xfs_refcount_recover_cow_leftovers(
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
 	memset(&low, 0, sizeof(low));
@@ -2086,7 +2098,10 @@ xfs_refcount_recover_cow_leftovers(
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
@@ -2099,14 +2114,18 @@ xfs_refcount_recover_cow_leftovers(
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
 		xfs_free_extent_later(tp, fsb, rr->rr_rrec.rc_blockcount, NULL,
-				0);
+				rtg != NULL ? XFS_FREE_EXTENT_REALTIME : 0);
 
 		error = xfs_trans_commit(tp);
 		if (error)
@@ -2128,6 +2147,22 @@ xfs_refcount_recover_cow_leftovers(
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
index 4e725d723e88..c7907119d10c 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -12,6 +12,7 @@ struct xfs_perag;
 struct xfs_btree_cur;
 struct xfs_bmbt_irec;
 struct xfs_refcount_irec;
+struct xfs_rtgroup;
 
 extern int xfs_refcount_lookup_le(struct xfs_btree_cur *cur,
 		enum xfs_refc_domain domain, xfs_agblock_t bno, int *stat);
@@ -99,8 +100,10 @@ void xfs_refcount_alloc_cow_extent(struct xfs_trans *tp, bool isrt,
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
index 3cead39e4308..13a613c077df 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1002,7 +1002,9 @@ xfs_reflink_recover_cow(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	int			error = 0;
 
 	if (!xfs_has_reflink(mp))
@@ -1012,11 +1014,19 @@ xfs_reflink_recover_cow(
 		error = xfs_refcount_recover_cow_leftovers(mp, pag);
 		if (error) {
 			xfs_perag_put(pag);
-			break;
+			return error;
 		}
 	}
 
-	return error;
+	for_each_rtgroup(mp, rgno, rtg) {
+		error = xfs_refcount_recover_rtcow_leftovers(mp, rtg);
+		if (error) {
+			xfs_rtgroup_put(rtg);
+			return error;
+		}
+	}
+
+	return 0;
 }
 
 /*

