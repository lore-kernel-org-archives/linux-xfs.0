Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86F4CCA487
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiF0ASq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiF0ASn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:18:43 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F9C02BFB
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:18:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BC2E65ECB42
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:18:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSZ-00BTVI-17
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:18:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSY-000uAr-VW
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:18:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/14] xfs: kill xfs_alloc_pagf_init()
Date:   Mon, 27 Jun 2022 10:18:22 +1000
Message-Id: <20220627001832.215779-5-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627001832.215779-1-david@fromorbit.com>
References: <20220627001832.215779-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62b8f75c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=bQPFrWnIYC81Y4yJAFYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Trivial wrapper around xfs_alloc_read_agf(), can be easily replaced
by passing a NULL agfbp to xfs_alloc_read_agf().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c      |  2 +-
 fs/xfs/libxfs/xfs_ag_resv.c |  2 +-
 fs/xfs/libxfs/xfs_alloc.c   | 37 ++++++++++++-------------------------
 fs/xfs/libxfs/xfs_alloc.h   | 10 ----------
 fs/xfs/libxfs/xfs_bmap.c    |  3 ++-
 fs/xfs/libxfs/xfs_ialloc.c  |  2 +-
 fs/xfs/xfs_filestream.c     |  4 ++--
 7 files changed, 19 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index a16c985940d3..2ed15839fb3e 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -124,7 +124,7 @@ xfs_initialize_perag_data(
 		 * all the information we need and populates the
 		 * per-ag structures for us.
 		 */
-		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
+		error = xfs_alloc_read_agf(mp, NULL, index, 0, NULL);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index fe94058d4e9e..ce28bf8f72dc 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -322,7 +322,7 @@ xfs_ag_resv_init(
 	 * address.
 	 */
 	if (has_resv) {
-		error2 = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, 0);
+		error2 = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, NULL);
 		if (error2)
 			return error2;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d3f2886fdc08..f7853ab7b962 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2867,25 +2867,6 @@ xfs_alloc_log_agf(
 	xfs_trans_log_buf(tp, bp, (uint)first, (uint)last);
 }
 
-/*
- * Interface for inode allocation to force the pag data to be initialized.
- */
-int					/* error */
-xfs_alloc_pagf_init(
-	xfs_mount_t		*mp,	/* file system mount structure */
-	xfs_trans_t		*tp,	/* transaction pointer */
-	xfs_agnumber_t		agno,	/* allocation group number */
-	int			flags)	/* XFS_ALLOC_FLAGS_... */
-{
-	struct xfs_buf		*bp;
-	int			error;
-
-	error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp);
-	if (!error)
-		xfs_trans_brelse(tp, bp);
-	return error;
-}
-
 /*
  * Put the block on the freelist for the allocation group.
  */
@@ -3095,7 +3076,9 @@ xfs_read_agf(
 }
 
 /*
- * Read in the allocation group header (free/alloc section).
+ * Read in the allocation group header (free/alloc section) and initialise the
+ * perag structure if necessary. If the caller provides @agfbpp, then return the
+ * locked buffer to the caller, otherwise free it.
  */
 int					/* error */
 xfs_alloc_read_agf(
@@ -3103,8 +3086,9 @@ xfs_alloc_read_agf(
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_agnumber_t		agno,	/* allocation group number */
 	int			flags,	/* XFS_ALLOC_FLAG_... */
-	struct xfs_buf		**bpp)	/* buffer for the ag freelist header */
+	struct xfs_buf		**agfbpp)
 {
+	struct xfs_buf		*agfbp;
 	struct xfs_agf		*agf;		/* ag freelist header */
 	struct xfs_perag	*pag;		/* per allocation group data */
 	int			error;
@@ -3118,13 +3102,12 @@ xfs_alloc_read_agf(
 	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_read_agf(mp, tp, agno,
 			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
-			bpp);
+			&agfbp);
 	if (error)
 		return error;
-	ASSERT(!(*bpp)->b_error);
 
-	agf = (*bpp)->b_addr;
-	pag = (*bpp)->b_pag;
+	agf = agfbp->b_addr;
+	pag = agfbp->b_pag;
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
@@ -3165,6 +3148,10 @@ xfs_alloc_read_agf(
 		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
 	}
 #endif
+	if (agfbpp)
+		*agfbpp = agfbp;
+	else
+		xfs_trans_brelse(tp, agfbp);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 84ca09b2223f..96d5301a5c8b 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -123,16 +123,6 @@ xfs_alloc_log_agf(
 	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
 	uint32_t	fields);/* mask of fields to be logged (XFS_AGF_...) */
 
-/*
- * Interface for inode allocation to force the pag data to be initialized.
- */
-int				/* error */
-xfs_alloc_pagf_init(
-	struct xfs_mount *mp,	/* file system mount structure */
-	struct xfs_trans *tp,	/* transaction pointer */
-	xfs_agnumber_t	agno,	/* allocation group number */
-	int		flags);	/* XFS_ALLOC_FLAGS_... */
-
 /*
  * Put the block on the freelist for the allocation group.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6833110d1bd4..a76d5894641b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3185,7 +3185,8 @@ xfs_bmap_longest_free_extent(
 
 	pag = xfs_perag_get(mp, ag);
 	if (!pag->pagf_init) {
-		error = xfs_alloc_pagf_init(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK);
+		error = xfs_alloc_read_agf(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK,
+				NULL);
 		if (error) {
 			/* Couldn't lock the AGF, so skip this AG. */
 			if (error == -EAGAIN) {
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a7259404377d..8e252207b131 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1621,7 +1621,7 @@ xfs_dialloc_good_ag(
 		return false;
 
 	if (!pag->pagf_init) {
-		error = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, flags);
+		error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, flags, NULL);
 		if (error)
 			return false;
 	}
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index be9bcf8a1f99..6b09a30f8d06 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -126,7 +126,7 @@ xfs_filestream_pick_ag(
 		pag = xfs_perag_get(mp, ag);
 
 		if (!pag->pagf_init) {
-			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
+			err = xfs_alloc_read_agf(mp, NULL, ag, trylock, NULL);
 			if (err) {
 				if (err != -EAGAIN) {
 					xfs_perag_put(pag);
@@ -181,7 +181,7 @@ xfs_filestream_pick_ag(
 		if (ag != startag)
 			continue;
 
-		/* Allow sleeping in xfs_alloc_pagf_init() on the 2nd pass. */
+		/* Allow sleeping in xfs_alloc_read_agf() on the 2nd pass. */
 		if (trylock != 0) {
 			trylock = 0;
 			continue;
-- 
2.36.1

