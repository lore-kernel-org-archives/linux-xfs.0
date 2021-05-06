Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670C9C43600
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CB3B613F5
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhEFHV7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 May 2021 03:21:59 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:43446 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233380AbhEFHV6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 03:21:58 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 139B880B54C
        for <linux-xfs@vger.kernel.org>; Thu,  6 May 2021 17:20:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-005lo8-8M
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-00197S-05
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/22] xfs: pass perags around in fsmap data dev functions
Date:   Thu,  6 May 2021 17:20:42 +1000
Message-Id: <20210506072054.271157-11-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210506072054.271157-1-david@fromorbit.com>
References: <20210506072054.271157-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=xf-acLbKzRIEiCuWx2AA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Needs a [from, to] ranged AG walk, and the perag to be stuffed into
the info structure for callouts to use.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.h | 14 ++++++--
 fs/xfs/xfs_fsmap.c     | 75 ++++++++++++++++++++++++++----------------
 2 files changed, 58 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 3fa88222dacd..bebbe1bfce27 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -116,14 +116,24 @@ void	xfs_perag_put(struct xfs_perag *pag);
 
 /*
  * Perag iteration APIs
+ *
+ * XXX: for_each_perag_range() usage really needs an iterator to clean up when
+ * we terminate at end_agno because we may have taken a reference to the perag
+ * beyond end_agno. RIght now callers have to be careful to catch and clean that
+ * up themselves. This is not necessary for the callers of for_each_perag() and
+ * for_each_perag_from() because they terminate at sb_agcount where there are
+ * no perag structures in tree beyond end_agno.
  */
-#define for_each_perag_from(mp, next_agno, pag) \
+#define for_each_perag_range(mp, next_agno, end_agno, pag) \
 	for ((pag) = xfs_perag_get((mp), (next_agno)); \
-		(pag) != NULL; \
+		(pag) != NULL && (next_agno) <= (end_agno); \
 		(next_agno) = (pag)->pag_agno + 1, \
 		xfs_perag_put(pag), \
 		(pag) = xfs_perag_get((mp), (next_agno)))
 
+#define for_each_perag_from(mp, next_agno, pag) \
+	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
+
 #define for_each_perag(mp, next_agno, pag) \
 	(next_agno) = 0; \
 	for_each_perag_from((mp), (next_agno), (pag))
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 34f2b971ce43..835dd6e3819b 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -24,6 +24,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_rtalloc.h"
+#include "xfs_ag.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 static void
@@ -157,10 +158,10 @@ struct xfs_getfsmap_info {
 	struct xfs_fsmap_head	*head;
 	struct fsmap		*fsmap_recs;	/* mapping records */
 	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
+	struct xfs_perag	*pag;		/* AG info, if applicable */
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	u64			missing_owner;	/* owner of holes */
 	u32			dev;		/* device id */
-	xfs_agnumber_t		agno;		/* AG number, if applicable */
 	struct xfs_rmap_irec	low;		/* low rmap key */
 	struct xfs_rmap_irec	high;		/* high rmap key */
 	bool			last;		/* last extent? */
@@ -203,14 +204,14 @@ xfs_getfsmap_is_shared(
 	*stat = false;
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return 0;
-	/* rt files will have agno set to NULLAGNUMBER */
-	if (info->agno == NULLAGNUMBER)
+	/* rt files will have no perag structure */
+	if (!info->pag)
 		return 0;
 
 	/* Are there any shared blocks here? */
 	flen = 0;
 	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
-			info->agno);
+			info->pag->pag_agno);
 
 	error = xfs_refcount_find_shared(cur, rec->rm_startblock,
 			rec->rm_blockcount, &fbno, &flen, false);
@@ -311,7 +312,8 @@ xfs_getfsmap_helper(
 	if (info->head->fmh_entries >= info->head->fmh_count)
 		return -ECANCELED;
 
-	trace_xfs_fsmap_mapping(mp, info->dev, info->agno, rec);
+	trace_xfs_fsmap_mapping(mp, info->dev,
+			info->pag ? info->pag->pag_agno : NULLAGNUMBER, rec);
 
 	fmr.fmr_device = info->dev;
 	fmr.fmr_physical = rec_daddr;
@@ -429,8 +431,8 @@ xfs_getfsmap_logdev(
 	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
 	info->missing_owner = XFS_FMR_OWN_FREE;
 
-	trace_xfs_fsmap_low_key(mp, info->dev, info->agno, &info->low);
-	trace_xfs_fsmap_high_key(mp, info->dev, info->agno, &info->high);
+	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
+	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
 
 	if (keys[0].fmr_physical > 0)
 		return 0;
@@ -508,8 +510,8 @@ __xfs_getfsmap_rtdev(
 	info->high.rm_blockcount = 0;
 	xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
 
-	trace_xfs_fsmap_low_key(mp, info->dev, info->agno, &info->low);
-	trace_xfs_fsmap_high_key(mp, info->dev, info->agno, &info->high);
+	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
+	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
 
 	return query_fn(tp, info);
 }
@@ -572,6 +574,7 @@ __xfs_getfsmap_datadev(
 	void				*priv)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_perag		*pag;
 	struct xfs_btree_cur		*bt_cur = NULL;
 	xfs_fsblock_t			start_fsb;
 	xfs_fsblock_t			end_fsb;
@@ -610,20 +613,20 @@ __xfs_getfsmap_datadev(
 	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
 	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
 
-	/* Query each AG */
-	for (info->agno = start_ag; info->agno <= end_ag; info->agno++) {
+	for_each_perag_range(mp, start_ag, end_ag, pag) {
 		/*
 		 * Set the AG high key from the fsmap high key if this
 		 * is the last AG that we're querying.
 		 */
-		if (info->agno == end_ag) {
+		info->pag = pag;
+		if (pag->pag_agno == end_ag) {
 			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
 					end_fsb);
 			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
 					keys[1].fmr_offset);
 			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
 			if (error)
-				goto err;
+				break;
 			xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
 		}
 
@@ -634,38 +637,45 @@ __xfs_getfsmap_datadev(
 			info->agf_bp = NULL;
 		}
 
-		error = xfs_alloc_read_agf(mp, tp, info->agno, 0,
+		error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0,
 				&info->agf_bp);
 		if (error)
-			goto err;
+			break;
 
-		trace_xfs_fsmap_low_key(mp, info->dev, info->agno, &info->low);
-		trace_xfs_fsmap_high_key(mp, info->dev, info->agno,
+		trace_xfs_fsmap_low_key(mp, info->dev, pag->pag_agno,
+				&info->low);
+		trace_xfs_fsmap_high_key(mp, info->dev, pag->pag_agno,
 				&info->high);
 
 		error = query_fn(tp, info, &bt_cur, priv);
 		if (error)
-			goto err;
+			break;
 
 		/*
 		 * Set the AG low key to the start of the AG prior to
 		 * moving on to the next AG.
 		 */
-		if (info->agno == start_ag) {
+		if (pag->pag_agno == start_ag) {
 			info->low.rm_startblock = 0;
 			info->low.rm_owner = 0;
 			info->low.rm_offset = 0;
 			info->low.rm_flags = 0;
 		}
-	}
 
-	/* Report any gap at the end of the AG */
-	info->last = true;
-	error = query_fn(tp, info, &bt_cur, priv);
-	if (error)
-		goto err;
+		/*
+		 * If this is the last AG, report any gap at the end of it
+		 * before we drop the reference to the perag when the loop
+		 * terminates.
+		 */
+		if (pag->pag_agno == end_ag) {
+			info->last = true;
+			error = query_fn(tp, info, &bt_cur, priv);
+			if (error)
+				break;
+		}
+		info->pag = NULL;
+	}
 
-err:
 	if (bt_cur)
 		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
 							 XFS_BTREE_NOERROR);
@@ -673,6 +683,13 @@ __xfs_getfsmap_datadev(
 		xfs_trans_brelse(tp, info->agf_bp);
 		info->agf_bp = NULL;
 	}
+	if (info->pag) {
+		xfs_perag_put(info->pag);
+		info->pag = NULL;
+	} else if (pag) {
+		/* loop termination case */
+		xfs_perag_put(pag);
+	}
 
 	return error;
 }
@@ -691,7 +708,7 @@ xfs_getfsmap_datadev_rmapbt_query(
 
 	/* Allocate cursor for this AG and query_range it. */
 	*curpp = xfs_rmapbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
-			info->agno);
+			info->pag->pag_agno);
 	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
 			xfs_getfsmap_datadev_helper, info);
 }
@@ -724,7 +741,7 @@ xfs_getfsmap_datadev_bnobt_query(
 
 	/* Allocate cursor for this AG and query_range it. */
 	*curpp = xfs_allocbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
-			info->agno, XFS_BTNUM_BNO);
+			info->pag->pag_agno, XFS_BTNUM_BNO);
 	key->ar_startblock = info->low.rm_startblock;
 	key[1].ar_startblock = info->high.rm_startblock;
 	return xfs_alloc_query_range(*curpp, key, &key[1],
@@ -937,7 +954,7 @@ xfs_getfsmap(
 
 		info.dev = handlers[i].dev;
 		info.last = false;
-		info.agno = NULLAGNUMBER;
+		info.pag = NULL;
 		error = handlers[i].fn(tp, dkeys, &info);
 		if (error)
 			break;
-- 
2.31.1

