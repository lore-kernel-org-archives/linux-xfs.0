Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5182C433ED
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2BD361176
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhEFHV6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 May 2021 03:21:58 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:59484 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233360AbhEFHV5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 03:21:57 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 1566F67DEB
        for <linux-xfs@vger.kernel.org>; Thu,  6 May 2021 17:20:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-005lo5-6v
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1leYJb-00197P-VP
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/22] xfs: push perags through the ag reservation callouts
Date:   Thu,  6 May 2021 17:20:41 +1000
Message-Id: <20210506072054.271157-10-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210506072054.271157-1-david@fromorbit.com>
References: <20210506072054.271157-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=4ATdU0DdX-z0mX4Fz0gA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We currently pass an agno from the AG reservation functions to the
individual feature accounting functions, which then may have to do
perag lookups to access per-AG state. Plumb the perag through from
the highest AG reservation layer to the feature callouts so they
don't have to look it up again.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c        |  9 ++++-----
 fs/xfs/libxfs/xfs_ialloc_btree.c   | 17 +++++++++--------
 fs/xfs/libxfs/xfs_ialloc_btree.h   |  2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  7 +++----
 fs/xfs/libxfs/xfs_refcount_btree.h |  3 ++-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  6 +++---
 fs/xfs/libxfs/xfs_rmap_btree.h     |  2 +-
 7 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 2e3dcdfd4984..f7394a8ecf6b 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -250,7 +250,6 @@ xfs_ag_resv_init(
 	struct xfs_trans		*tp)
 {
 	struct xfs_mount		*mp = pag->pag_mount;
-	xfs_agnumber_t			agno = pag->pag_agno;
 	xfs_extlen_t			ask;
 	xfs_extlen_t			used;
 	int				error = 0, error2;
@@ -260,11 +259,11 @@ xfs_ag_resv_init(
 	if (pag->pag_meta_resv.ar_asked == 0) {
 		ask = used = 0;
 
-		error = xfs_refcountbt_calc_reserves(mp, tp, agno, &ask, &used);
+		error = xfs_refcountbt_calc_reserves(mp, tp, pag, &ask, &used);
 		if (error)
 			goto out;
 
-		error = xfs_finobt_calc_reserves(mp, tp, agno, &ask, &used);
+		error = xfs_finobt_calc_reserves(mp, tp, pag, &ask, &used);
 		if (error)
 			goto out;
 
@@ -282,7 +281,7 @@ xfs_ag_resv_init(
 
 			mp->m_finobt_nores = true;
 
-			error = xfs_refcountbt_calc_reserves(mp, tp, agno, &ask,
+			error = xfs_refcountbt_calc_reserves(mp, tp, pag, &ask,
 					&used);
 			if (error)
 				goto out;
@@ -300,7 +299,7 @@ xfs_ag_resv_init(
 	if (pag->pag_rmapbt_resv.ar_asked == 0) {
 		ask = used = 0;
 
-		error = xfs_rmapbt_calc_reserves(mp, tp, agno, &ask, &used);
+		error = xfs_rmapbt_calc_reserves(mp, tp, pag, &ask, &used);
 		if (error)
 			goto out;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 4c5831646bd9..4ec8ea1331a5 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -20,6 +20,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_rmap.h"
+#include "xfs_ag.h"
 
 STATIC int
 xfs_inobt_get_minrecs(
@@ -680,7 +681,7 @@ static int
 xfs_inobt_count_blocks(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum,
 	xfs_extlen_t		*tree_blocks)
 {
@@ -688,7 +689,7 @@ xfs_inobt_count_blocks(
 	struct xfs_btree_cur	*cur = NULL;
 	int			error;
 
-	error = xfs_inobt_cur(mp, tp, agno, btnum, &cur, &agbp);
+	error = xfs_inobt_cur(mp, tp, pag->pag_agno, btnum, &cur, &agbp);
 	if (error)
 		return error;
 
@@ -704,14 +705,14 @@ static int
 xfs_finobt_read_blocks(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_extlen_t		*tree_blocks)
 {
 	struct xfs_buf		*agbp;
 	struct xfs_agi		*agi;
 	int			error;
 
-	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, &agbp);
 	if (error)
 		return error;
 
@@ -728,7 +729,7 @@ int
 xfs_finobt_calc_reserves(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_extlen_t		*ask,
 	xfs_extlen_t		*used)
 {
@@ -739,14 +740,14 @@ xfs_finobt_calc_reserves(
 		return 0;
 
 	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
-		error = xfs_finobt_read_blocks(mp, tp, agno, &tree_len);
+		error = xfs_finobt_read_blocks(mp, tp, pag, &tree_len);
 	else
-		error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO,
+		error = xfs_inobt_count_blocks(mp, tp, pag, XFS_BTNUM_FINO,
 				&tree_len);
 	if (error)
 		return error;
 
-	*ask += xfs_inobt_max_size(mp, agno);
+	*ask += xfs_inobt_max_size(mp, pag->pag_agno);
 	*used += tree_len;
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 35bbd978c272..d5afe01fb2de 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -64,7 +64,7 @@ int xfs_inobt_rec_check_count(struct xfs_mount *,
 #endif	/* DEBUG */
 
 int xfs_finobt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
-		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
+		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
 extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index b281f0c674f5..c4ddf9ded00b 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -450,7 +450,7 @@ int
 xfs_refcountbt_calc_reserves(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_extlen_t		*ask,
 	xfs_extlen_t		*used)
 {
@@ -463,8 +463,7 @@ xfs_refcountbt_calc_reserves(
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return 0;
 
-
-	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
 	if (error)
 		return error;
 
@@ -479,7 +478,7 @@ xfs_refcountbt_calc_reserves(
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
 	if (mp->m_sb.sb_logstart &&
-	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == pag->pag_agno)
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	*ask += xfs_refcountbt_max_size(mp, agblocks);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index 69dc515db671..eab1b0c672c0 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -13,6 +13,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xfs_perag;
 struct xbtree_afakeroot;
 
 /*
@@ -58,7 +59,7 @@ extern xfs_extlen_t xfs_refcountbt_max_size(struct xfs_mount *mp,
 		xfs_agblock_t agblocks);
 
 extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
-		struct xfs_trans *tp, xfs_agnumber_t agno, xfs_extlen_t *ask,
+		struct xfs_trans *tp, struct xfs_perag *pag, xfs_extlen_t *ask,
 		xfs_extlen_t *used);
 
 void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 46a5295ecf35..ba2f7064451b 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -595,7 +595,7 @@ int
 xfs_rmapbt_calc_reserves(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_extlen_t		*ask,
 	xfs_extlen_t		*used)
 {
@@ -608,7 +608,7 @@ xfs_rmapbt_calc_reserves(
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
 	if (error)
 		return error;
 
@@ -623,7 +623,7 @@ xfs_rmapbt_calc_reserves(
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
 	if (mp->m_sb.sb_logstart &&
-	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == pag->pag_agno)
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	/* Reserve 1% of the AG or enough for 1 block per record. */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 115c3455a734..57fab72e26ad 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -57,6 +57,6 @@ extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp,
 		xfs_agblock_t agblocks);
 
 extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
-		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
+		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
 
 #endif	/* __XFS_RMAP_BTREE_H__ */
-- 
2.31.1

