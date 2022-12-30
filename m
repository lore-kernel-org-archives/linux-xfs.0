Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52641C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbiLaBmC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236137AbiLaBlw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:41:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E82AE0FD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:41:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC3BCB81DE0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657BEC433EF;
        Sat, 31 Dec 2022 01:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450908;
        bh=USNvMBtjPTUllBRHkJoJbXQR4bl90nrrwl2FLoTIG8M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=h6y6YclHr5cmtpSpvZHXj77Su13aNBOhRWaRV8hbQuT2GKH5aFDdaF9AJ6AmCJ424
         D1cqxhBNbfQygzG/gvQv0Qfdc2unGJF3PcWTqY3HzeetsM+ngtDK6eNSK5TBqV0e5G
         Gs2ob6qK1aTKZ86saR1iud6VMbc0zfNLgqgmjGNzjtEfiB6C9qq7t7tB91mTePQGMc
         c/Op7TnZkrIjSdn+6V1Sd5KyYhuqQ8kD9qMgz6Tr2hRYZpBqNKkGn+Zap96RRloGPz
         dKsykf+hLHzSxN1MVsVl+WzlI6TjJB0iPmRZY7veHNkPrP/SS3TD3m+59S5apgkYFn
         jInSNCb1/SVIg==
Subject: [PATCH 19/38] xfs: wire up getfsmap to the realtime reverse mapping
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:18 -0800
Message-ID: <167243869870.715303.1767921115178790776.stgit@magnolia>
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

Connect the getfsmap ioctl to the realtime rmapbt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |  261 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 212 insertions(+), 49 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index dfd9e39ded6e..e330a7e55d1d 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -25,6 +25,8 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_ag.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 static void
@@ -158,6 +160,7 @@ struct xfs_getfsmap_info {
 	struct xfs_fsmap_head	*head;
 	struct fsmap		*fsmap_recs;	/* mapping records */
 	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
+	struct xfs_rtgroup	*rtg;		/* rt group info, if needed */
 	struct xfs_perag	*pag;		/* AG info, if applicable */
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	u64			missing_owner;	/* owner of holes */
@@ -311,8 +314,14 @@ xfs_getfsmap_helper(
 	if (info->head->fmh_entries >= info->head->fmh_count)
 		return -ECANCELED;
 
-	trace_xfs_fsmap_mapping(mp, info->dev,
-			info->pag ? info->pag->pag_agno : NULLAGNUMBER, rec);
+	if (info->pag)
+		trace_xfs_fsmap_mapping(mp, info->dev, info->pag->pag_agno,
+				rec);
+	else if (info->rtg)
+		trace_xfs_fsmap_mapping(mp, info->dev, info->rtg->rtg_rgno,
+				rec);
+	else
+		trace_xfs_fsmap_mapping(mp, info->dev, NULLAGNUMBER, rec);
 
 	fmr.fmr_device = info->dev;
 	fmr.fmr_physical = rec_daddr;
@@ -667,50 +676,6 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr);
 }
 
-/* Execute a getfsmap query against the realtime device. */
-STATIC int
-__xfs_getfsmap_rtdev(
-	struct xfs_trans		*tp,
-	const struct xfs_fsmap		*keys,
-	int				(*query_fn)(struct xfs_trans *,
-						    struct xfs_getfsmap_info *),
-	struct xfs_getfsmap_info	*info)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-	xfs_fsblock_t			start_fsb;
-	xfs_fsblock_t			end_fsb;
-	uint64_t			eofs;
-	int				error = 0;
-
-	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
-	if (keys[0].fmr_physical >= eofs)
-		return 0;
-	start_fsb = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
-	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
-
-	/* Set up search keys */
-	info->low.rm_startblock = start_fsb;
-	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
-	if (error)
-		return error;
-	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
-	info->low.rm_blockcount = 0;
-	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
-
-	info->high.rm_startblock = end_fsb;
-	error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
-	if (error)
-		return error;
-	info->high.rm_offset = XFS_BB_TO_FSBT(mp, keys[1].fmr_offset);
-	info->high.rm_blockcount = 0;
-	xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
-
-	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
-	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
-
-	return query_fn(tp, info);
-}
-
 /* Actually query the realtime bitmap. */
 STATIC int
 xfs_getfsmap_rtdev_rtbitmap_query(
@@ -760,9 +725,203 @@ xfs_getfsmap_rtdev_rtbitmap(
 	const struct xfs_fsmap		*keys,
 	struct xfs_getfsmap_info	*info)
 {
+	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_fsblock_t			start_fsb;
+	xfs_fsblock_t			end_fsb;
+	uint64_t			eofs;
+	int				error = 0;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (keys[0].fmr_physical >= eofs)
+		return 0;
+	start_fsb = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
+	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
+
 	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
-	return __xfs_getfsmap_rtdev(tp, keys, xfs_getfsmap_rtdev_rtbitmap_query,
-			info);
+
+	/* Set up search keys */
+	info->low.rm_startblock = start_fsb;
+	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
+	if (error)
+		return error;
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+
+	info->high.rm_startblock = end_fsb;
+	error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
+	if (error)
+		return error;
+	info->high.rm_offset = XFS_BB_TO_FSBT(mp, keys[1].fmr_offset);
+	info->high.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
+
+	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
+	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
+
+	return xfs_getfsmap_rtdev_rtbitmap_query(tp, info);
+}
+
+/* Transform a absolute-startblock rmap (rtdev, logdev) into a fsmap */
+STATIC int
+xfs_getfsmap_rtdev_helper(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_getfsmap_info	*info = priv;
+	xfs_rtblock_t			rtbno;
+	xfs_daddr_t			rec_daddr;
+
+	rtbno = xfs_rgbno_to_rtb(mp, cur->bc_ino.rtg->rtg_rgno,
+			rec->rm_startblock);
+	rec_daddr = xfs_rtb_to_daddr(mp, rtbno);
+
+	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
+}
+
+/* Actually query the rtrmap btree. */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt_query(
+	struct xfs_trans		*tp,
+	struct xfs_getfsmap_info	*info,
+	struct xfs_btree_cur		**curpp)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+
+	/* Report any gap at the end of the last rtgroup. */
+	if (info->last)
+		return xfs_getfsmap_rtdev_helper(*curpp, &info->high, info);
+
+	/* Query the rtrmapbt */
+	xfs_rtgroup_lock(NULL, info->rtg, XFS_RTGLOCK_RMAP);
+	*curpp = xfs_rtrmapbt_init_cursor(mp, tp, info->rtg,
+			info->rtg->rtg_rmapip);
+	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
+			xfs_getfsmap_rtdev_helper, info);
+}
+
+/* Execute a getfsmap query against the realtime device rmapbt. */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt(
+	struct xfs_trans		*tp,
+	const struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rtgroup		*rtg;
+	struct xfs_btree_cur		*bt_cur = NULL;
+	xfs_fsblock_t			start_fsb;
+	xfs_fsblock_t			end_fsb;
+	xfs_rgnumber_t			start_rg, end_rg;
+	uint64_t			eofs;
+	int				error = 0;
+
+	eofs = XFS_FSB_TO_BB(mp, xfs_rtx_to_rtb(mp, mp->m_sb.sb_rextents));
+	if (keys[0].fmr_physical >= eofs)
+		return 0;
+	start_fsb = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
+	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
+
+	info->missing_owner = XFS_FMR_OWN_FREE;
+
+	/*
+	 * Convert the fsmap low/high keys to rtgroup based keys.  Initialize
+	 * low to the fsmap low key and max out the high key to the end
+	 * of the rtgroup.
+	 */
+	info->low.rm_startblock = xfs_rtb_to_rgbno(mp, start_fsb, &start_rg);
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
+	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
+	if (error)
+		return error;
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+
+	info->high.rm_startblock = -1U;
+	info->high.rm_owner = ULLONG_MAX;
+	info->high.rm_offset = ULLONG_MAX;
+	info->high.rm_blockcount = 0;
+	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
+
+	end_rg = xfs_rtb_to_rgno(mp, end_fsb);
+
+	for_each_rtgroup_range(mp, start_rg, end_rg, rtg) {
+		/*
+		 * Set the rtgroup high key from the fsmap high key if this
+		 * is the last rtgroup that we're querying.
+		 */
+		info->rtg = rtg;
+		if (rtg->rtg_rgno == end_rg) {
+			xfs_rgnumber_t	junk;
+
+			info->high.rm_startblock = xfs_rtb_to_rgbno(mp,
+					end_fsb, &junk);
+			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
+					keys[1].fmr_offset);
+			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
+			if (error)
+				break;
+			xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
+		}
+
+		if (bt_cur) {
+			xfs_rtgroup_unlock(bt_cur->bc_ino.rtg,
+					XFS_RTGLOCK_RMAP);
+			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+			bt_cur = NULL;
+		}
+
+		trace_xfs_fsmap_low_key(mp, info->dev, rtg->rtg_rgno,
+				&info->low);
+		trace_xfs_fsmap_high_key(mp, info->dev, rtg->rtg_rgno,
+				&info->high);
+
+		error = xfs_getfsmap_rtdev_rmapbt_query(tp, info, &bt_cur);
+		if (error)
+			break;
+
+		/*
+		 * Set the rtgroup low key to the start of the rtgroup prior to
+		 * moving on to the next rtgroup.
+		 */
+		if (rtg->rtg_rgno == start_rg) {
+			info->low.rm_startblock = 0;
+			info->low.rm_owner = 0;
+			info->low.rm_offset = 0;
+			info->low.rm_flags = 0;
+		}
+
+		/*
+		 * If this is the last rtgroup, report any gap at the end of it
+		 * before we drop the reference to the perag when the loop
+		 * terminates.
+		 */
+		if (rtg->rtg_rgno == end_rg) {
+			info->last = true;
+			error = xfs_getfsmap_rtdev_rmapbt_query(tp, info,
+					&bt_cur);
+			if (error)
+				break;
+		}
+		info->rtg = NULL;
+	}
+
+	if (bt_cur) {
+		xfs_rtgroup_unlock(bt_cur->bc_ino.rtg, XFS_RTGLOCK_RMAP);
+		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
+							 XFS_BTREE_NOERROR);
+	}
+	if (info->rtg) {
+		xfs_rtgroup_put(info->rtg);
+		info->rtg = NULL;
+	} else if (rtg) {
+		/* loop termination case */
+		xfs_rtgroup_put(rtg);
+	}
+
+	return error;
 }
 #endif /* CONFIG_XFS_RT */
 
@@ -881,7 +1040,10 @@ xfs_getfsmap(
 #ifdef CONFIG_XFS_RT
 	if (mp->m_rtdev_targp) {
 		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
-		handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
+		if (use_rmap)
+			handlers[2].fn = xfs_getfsmap_rtdev_rmapbt;
+		else
+			handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
 	}
 #endif /* CONFIG_XFS_RT */
 
@@ -959,6 +1121,7 @@ xfs_getfsmap(
 		info.dev = handlers[i].dev;
 		info.last = false;
 		info.pag = NULL;
+		info.rtg = NULL;
 		error = handlers[i].fn(tp, dkeys, &info);
 		if (error)
 			break;

