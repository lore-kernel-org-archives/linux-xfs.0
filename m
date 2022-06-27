Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33379C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiF0ASo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiF0ASn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:18:43 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF5122BF6
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:18:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7C50C10E7799
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:18:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSY-00BTVC-Ui
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:18:34 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSY-000uAj-TK
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:18:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/14] xfs: kill xfs_ialloc_pagi_init()
Date:   Mon, 27 Jun 2022 10:18:20 +1000
Message-Id: <20220627001832.215779-3-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627001832.215779-1-david@fromorbit.com>
References: <20220627001832.215779-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b8f75c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=cJiDi9BFPcmgrDkwqu4A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is just a basic wrapper around xfs_ialloc_read_agi(), which can
be entirely handled by xfs_ialloc_read_agi() by passing a NULL
agibpp....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c     |  3 ++-
 fs/xfs/libxfs/xfs_ialloc.c | 39 ++++++++++++++------------------------
 fs/xfs/libxfs/xfs_ialloc.h | 10 ----------
 3 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 4bb316d89e57..c203dc883f5d 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -128,9 +128,10 @@ xfs_initialize_perag_data(
 		if (error)
 			return error;
 
-		error = xfs_ialloc_pagi_init(mp, NULL, index);
+		error = xfs_ialloc_read_agi(mp, NULL, index, NULL);
 		if (error)
 			return error;
+
 		pag = xfs_perag_get(mp, index);
 		ifree += pag->pagi_freecount;
 		ialloc += pag->pagi_count;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index bf2f4bc89193..cefac2a1ba0c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1610,7 +1610,7 @@ xfs_dialloc_good_ag(
 		return false;
 
 	if (!pag->pagi_init) {
-		error = xfs_ialloc_pagi_init(mp, tp, pag->pag_agno);
+		error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, NULL);
 		if (error)
 			return false;
 	}
@@ -2593,25 +2593,30 @@ xfs_read_agi(
 	return 0;
 }
 
+/*
+ * Read in the agi and initialise the per-ag data. If the caller supplies a
+ * @agibpp, return the locked AGI buffer to them, otherwise release it.
+ */
 int
 xfs_ialloc_read_agi(
 	struct xfs_mount	*mp,	/* file system mount structure */
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_agnumber_t		agno,	/* allocation group number */
-	struct xfs_buf		**bpp)	/* allocation group hdr buf */
+	struct xfs_buf		**agibpp)
 {
+	struct xfs_buf		*agibp;
 	struct xfs_agi		*agi;	/* allocation group header */
 	struct xfs_perag	*pag;	/* per allocation group data */
 	int			error;
 
 	trace_xfs_ialloc_read_agi(mp, agno);
 
-	error = xfs_read_agi(mp, tp, agno, bpp);
+	error = xfs_read_agi(mp, tp, agno, &agibp);
 	if (error)
 		return error;
 
-	agi = (*bpp)->b_addr;
-	pag = (*bpp)->b_pag;
+	agi = agibp->b_addr;
+	pag = agibp->b_pag;
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 		pag->pagi_count = be32_to_cpu(agi->agi_count);
@@ -2624,26 +2629,10 @@ xfs_ialloc_read_agi(
 	 */
 	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
 		xfs_is_shutdown(mp));
-	return 0;
-}
-
-/*
- * Read in the agi to initialise the per-ag data in the mount structure
- */
-int
-xfs_ialloc_pagi_init(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno)		/* allocation group number */
-{
-	struct xfs_buf	*bp = NULL;
-	int		error;
-
-	error = xfs_ialloc_read_agi(mp, tp, agno, &bp);
-	if (error)
-		return error;
-	if (bp)
-		xfs_trans_brelse(tp, bp);
+	if (agibpp)
+		*agibpp = agibp;
+	else
+		xfs_trans_brelse(tp, agibp);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index a7705b6a1fd3..1ff42bf1e4b3 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -72,16 +72,6 @@ xfs_ialloc_read_agi(
 	xfs_agnumber_t	agno,		/* allocation group number */
 	struct xfs_buf	**bpp);		/* allocation group hdr buf */
 
-/*
- * Read in the allocation group header to initialise the per-ag data
- * in the mount structure
- */
-int
-xfs_ialloc_pagi_init(
-	struct xfs_mount *mp,		/* file system mount structure */
-	struct xfs_trans *tp,		/* transaction pointer */
-        xfs_agnumber_t  agno);		/* allocation group number */
-
 /*
  * Lookup a record by ino in the btree given by cur.
  */
-- 
2.36.1

