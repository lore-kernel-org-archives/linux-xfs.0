Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D09C43470
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFAB66139A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbhESBW0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 May 2021 21:22:26 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:39566 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231853AbhESBWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 21:22:24 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id D9C0767585
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 11:21:03 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtT-002bO4-Bo
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtT-001tJz-4L
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/23] xfs: convert raw ag walks to use for_each_perag
Date:   Wed, 19 May 2021 11:20:44 +1000
Message-Id: <20210519012102.450926-6-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519012102.450926-1-david@fromorbit.com>
References: <20210519012102.450926-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=m3KLVTsULsLW6ioXb_AA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Convert the raw walks to an iterator, pulling the current AG out of
pag->pag_agno instead of the loop iterator variable.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_types.c |  4 ++-
 fs/xfs/scrub/bmap.c       | 13 +++++----
 fs/xfs/xfs_log_recover.c  | 55 ++++++++++++++++++---------------------
 fs/xfs/xfs_reflink.c      |  9 ++++---
 4 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 04801362e1a7..e8f4abee7892 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -11,6 +11,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_ag.h"
 
 /* Find the size of the AG, in blocks. */
 inline xfs_agblock_t
@@ -222,12 +223,13 @@ xfs_icount_range(
 	unsigned long long	*max)
 {
 	unsigned long long	nr_inos = 0;
+	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
 	/* root, rtbitmap, rtsum all live in the first chunk */
 	*min = XFS_INODES_PER_CHUNK;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+	for_each_perag(mp, agno, pag) {
 		xfs_agino_t	first, last;
 
 		xfs_agino_range(mp, agno, &first, &last);
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index b5ebf1d1b4db..e457c086887f 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -22,6 +22,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
+#include "xfs_ag.h"
 
 /* Set us up with an inode's bmap. */
 int
@@ -575,6 +576,7 @@ xchk_bmap_check_rmaps(
 	int			whichfork)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(sc->ip, whichfork);
+	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 	bool			zero_size;
 	int			error;
@@ -607,15 +609,16 @@ xchk_bmap_check_rmaps(
 	    (zero_size || ifp->if_nextents > 0))
 		return 0;
 
-	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
-		error = xchk_bmap_check_ag_rmaps(sc, whichfork, agno);
+	for_each_perag(sc->mp, agno, pag) {
+		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag->pag_agno);
 		if (error)
-			return error;
+			break;
 		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 			break;
 	}
-
-	return 0;
+	if (pag)
+		xfs_perag_put(pag);
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fee2a4e80241..1227503d2246 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2742,21 +2742,17 @@ STATIC void
 xlog_recover_process_iunlinks(
 	struct xlog	*log)
 {
-	xfs_mount_t	*mp;
-	xfs_agnumber_t	agno;
-	xfs_agi_t	*agi;
-	struct xfs_buf	*agibp;
-	xfs_agino_t	agino;
-	int		bucket;
-	int		error;
-
-	mp = log->l_mp;
+	struct xfs_mount	*mp = log->l_mp;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	struct xfs_agi		*agi;
+	struct xfs_buf		*agibp;
+	xfs_agino_t		agino;
+	int			bucket;
+	int			error;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		/*
-		 * Find the agi for this ag.
-		 */
-		error = xfs_read_agi(mp, NULL, agno, &agibp);
+	for_each_perag(mp, agno, pag) {
+		error = xfs_read_agi(mp, NULL, pag->pag_agno, &agibp);
 		if (error) {
 			/*
 			 * AGI is b0rked. Don't process it.
@@ -2782,7 +2778,7 @@ xlog_recover_process_iunlinks(
 			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 			while (agino != NULLAGINO) {
 				agino = xlog_recover_process_one_iunlink(mp,
-							agno, agino, bucket);
+						pag->pag_agno, agino, bucket);
 				cond_resched();
 			}
 		}
@@ -3494,27 +3490,28 @@ xlog_recover_cancel(
  */
 STATIC void
 xlog_recover_check_summary(
-	struct xlog	*log)
+	struct xlog		*log)
 {
-	xfs_mount_t	*mp;
-	struct xfs_buf	*agfbp;
-	struct xfs_buf	*agibp;
-	xfs_agnumber_t	agno;
-	uint64_t	freeblks;
-	uint64_t	itotal;
-	uint64_t	ifree;
-	int		error;
+	struct xfs_mount	*mp = log->l_mp;
+	struct xfs_perag	*pag;
+	struct xfs_buf		*agfbp;
+	struct xfs_buf		*agibp;
+	xfs_agnumber_t		agno;
+	uint64_t		freeblks;
+	uint64_t		itotal;
+	uint64_t		ifree;
+	int			error;
 
 	mp = log->l_mp;
 
 	freeblks = 0LL;
 	itotal = 0LL;
 	ifree = 0LL;
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		error = xfs_read_agf(mp, NULL, agno, 0, &agfbp);
+	for_each_perag(mp, agno, pag) {
+		error = xfs_read_agf(mp, NULL, pag->pag_agno, 0, &agfbp);
 		if (error) {
 			xfs_alert(mp, "%s agf read failed agno %d error %d",
-						__func__, agno, error);
+						__func__, pag->pag_agno, error);
 		} else {
 			struct xfs_agf	*agfp = agfbp->b_addr;
 
@@ -3523,10 +3520,10 @@ xlog_recover_check_summary(
 			xfs_buf_relse(agfbp);
 		}
 
-		error = xfs_read_agi(mp, NULL, agno, &agibp);
+		error = xfs_read_agi(mp, NULL, pag->pag_agno, &agibp);
 		if (error) {
 			xfs_alert(mp, "%s agi read failed agno %d error %d",
-						__func__, agno, error);
+						__func__, pag->pag_agno, error);
 		} else {
 			struct xfs_agi	*agi = agibp->b_addr;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index f297d68a931b..0e430b0c1b16 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -755,16 +755,19 @@ int
 xfs_reflink_recover_cow(
 	struct xfs_mount	*mp)
 {
+	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 	int			error = 0;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return 0;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		error = xfs_refcount_recover_cow_leftovers(mp, agno);
-		if (error)
+	for_each_perag(mp, agno, pag) {
+		error = xfs_refcount_recover_cow_leftovers(mp, pag->pag_agno);
+		if (error) {
+			xfs_perag_put(pag);
 			break;
+		}
 	}
 
 	return error;
-- 
2.31.1

