Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075AAC4321E
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377758AbhLCAFC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:05:02 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58186 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377775AbhLCAFA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:05:00 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 8AD30606BBB
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:16 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00G1KZ-O8
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00BkhK-Ms
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/36] xfs: make is_log_ag() a first class helper
Date:   Fri,  3 Dec 2021 11:00:49 +1100
Message-Id: <20211203000111.2800982-15-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61a95e4c
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=mae3UHUuaFR5lmlHqFUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We check if an ag contains the log in many places, so make this
a first class XFS helper by lifting it to fs/xfs/libxfs/xfs_ag.h and
renaming it xfs_ag_contains_log(). The convert all the places that
check if the AG contains the log to use this helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c             | 12 +++---------
 fs/xfs/libxfs/xfs_ag.h             |  7 +++++++
 fs/xfs/libxfs/xfs_ialloc.c         |  3 +--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  3 +--
 fs/xfs/libxfs/xfs_refcount_btree.c |  3 +--
 fs/xfs/libxfs/xfs_rmap_btree.c     |  3 +--
 fs/xfs/scrub/health.c              |  2 ++
 fs/xfs/scrub/refcount.c            |  2 ++
 8 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 730170dc83a9..712d274012d0 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -391,12 +391,6 @@ xfs_get_aghdr_buf(
 	return 0;
 }
 
-static inline bool is_log_ag(struct xfs_mount *mp, struct aghdr_init_data *id)
-{
-	return mp->m_sb.sb_logstart > 0 &&
-	       id->agno == XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart);
-}
-
 /*
  * Generic btree root block init function
  */
@@ -422,7 +416,7 @@ xfs_freesp_init_recs(
 	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
 	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
 
-	if (is_log_ag(mp, id)) {
+	if (xfs_ag_contains_log(mp, id->agno)) {
 		struct xfs_alloc_rec	*nrec;
 		xfs_agblock_t		start = XFS_FSB_TO_AGBNO(mp,
 							mp->m_sb.sb_logstart);
@@ -549,7 +543,7 @@ xfs_rmaproot_init(
 	}
 
 	/* account for the log space */
-	if (is_log_ag(mp, id)) {
+	if (xfs_ag_contains_log(mp, id->agno)) {
 		rrec = XFS_RMAP_REC_ADDR(block,
 				be16_to_cpu(block->bb_numrecs) + 1);
 		rrec->rm_startblock = cpu_to_be32(
@@ -620,7 +614,7 @@ xfs_agfblock_init(
 		agf->agf_refcount_blocks = cpu_to_be32(1);
 	}
 
-	if (is_log_ag(mp, id)) {
+	if (xfs_ag_contains_log(mp, id->agno)) {
 		int64_t	logblocks = mp->m_sb.sb_logblocks;
 
 		be32_add_cpu(&agf->agf_freeblks, -logblocks);
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index bb9e91bd38e2..75f7c10c110a 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -165,6 +165,13 @@ xfs_verify_agino_or_null(struct xfs_perag *pag, xfs_agino_t agino)
 	return xfs_verify_agino(pag, agino);
 }
 
+static inline bool
+xfs_ag_contains_log(struct xfs_mount *mp, xfs_agnumber_t agno)
+{
+	return mp->m_sb.sb_logstart > 0 &&
+	       agno == XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart);
+}
+
 /*
  * Perag iteration APIs
  */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 459a352e1790..538e9dda1346 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2895,8 +2895,7 @@ xfs_ialloc_calc_rootino(
 	 * allocation group, or very odd geometries created by old mkfs
 	 * versions on very small filesystems.
 	 */
-	if (mp->m_sb.sb_logstart &&
-	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0)
+	if (xfs_ag_contains_log(mp, 0))
 		 first_bno += mp->m_sb.sb_logblocks;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 2e0ff99d9f0b..8c83e265770c 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -697,8 +697,7 @@ xfs_inobt_max_size(
 	 * never be available for the kinds of things that would require btree
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
-	if (mp->m_sb.sb_logstart &&
-	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == pag->pag_agno)
+	if (xfs_ag_contains_log(mp, pag->pag_agno))
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	return xfs_btree_calc_size(M_IGEO(mp)->inobt_mnr,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 1063234df34a..316c1ec0c3c2 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -507,8 +507,7 @@ xfs_refcountbt_calc_reserves(
 	 * never be available for the kinds of things that would require btree
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
-	if (mp->m_sb.sb_logstart &&
-	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == pag->pag_agno)
+	if (xfs_ag_contains_log(mp, pag->pag_agno))
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	*ask += xfs_refcountbt_max_size(mp, agblocks);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 1ae14d0c831c..7f83f62e51e0 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -666,8 +666,7 @@ xfs_rmapbt_calc_reserves(
 	 * never be available for the kinds of things that would require btree
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
-	if (mp->m_sb.sb_logstart &&
-	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == pag->pag_agno)
+	if (xfs_ag_contains_log(mp, pag->pag_agno))
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	/* Reserve 1% of the AG or enough for 1 block per record. */
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 2e61df3bca83..aa65ec88a0c0 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -8,6 +8,8 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_btree.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 3f82a1a1f390..c68b767dc08f 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -13,6 +13,8 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_ag.h"
 
 /*
-- 
2.33.0

