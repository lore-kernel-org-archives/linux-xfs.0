Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664AAC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377777AbhLCAFA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:05:00 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58186 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349853AbhLCAE6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:58 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 3AFDA6068D0
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:17 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00G1K2-Al
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00BkgW-9h
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/36] xfs: kill xfs_alloc_pagf_init()
Date:   Fri,  3 Dec 2021 11:00:39 +1100
Message-Id: <20211203000111.2800982-5-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61a95e4d
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=bQPFrWnIYC81Y4yJAFYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Trivial wrapper around xfs_alloc_read_agf(), can be easily replaced
by passing a NULL agfbp to xfs_alloc_read_agf().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
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
index 2683ffcd0d29..a782b9e584e4 100644
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
index 353e53b892e6..faa8f7a1ecf8 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2849,25 +2849,6 @@ xfs_alloc_log_agf(
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
@@ -3077,7 +3058,9 @@ xfs_read_agf(
 }
 
 /*
- * Read in the allocation group header (free/alloc section).
+ * Read in the allocation group header (free/alloc section) and initialise the
+ * perag structure if necessary. If the caller provides @agfbpp, then return the
+ * locked buffer to the caller, otherwise free it.
  */
 int					/* error */
 xfs_alloc_read_agf(
@@ -3085,8 +3068,9 @@ xfs_alloc_read_agf(
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
@@ -3100,13 +3084,12 @@ xfs_alloc_read_agf(
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
@@ -3147,6 +3130,10 @@ xfs_alloc_read_agf(
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
index 1c14a0b1abea..76dd3b8b6971 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -124,16 +124,6 @@ xfs_alloc_log_agf(
 	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
 	int		fields);/* mask of fields to be logged (XFS_AGF_...) */
 
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
index 4dccd4d90622..8924b3749e6a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3187,7 +3187,8 @@ xfs_bmap_longest_free_extent(
 
 	pag = xfs_perag_get(mp, ag);
 	if (!pag->pagf_init) {
-		error = xfs_alloc_pagf_init(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK);
+		error = xfs_alloc_read_agf(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK,
+				NULL);
 		if (error) {
 			/* Couldn't lock the AGF, so skip this AG. */
 			if (error == -EAGAIN) {
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d53d9808fab8..22edd49cfe81 100644
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
index 6a3ce0f6dc9e..e82185aa13f8 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -126,7 +126,7 @@ xfs_filestream_pick_ag(
 		pag = xfs_perag_get(mp, ag);
 
 		if (!pag->pagf_init) {
-			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
+			err = xfs_alloc_read_agf(mp, NULL, ag, trylock, NULL);
 			if (err) {
 				xfs_perag_put(pag);
 				if (err != -EAGAIN)
@@ -180,7 +180,7 @@ xfs_filestream_pick_ag(
 		if (ag != startag)
 			continue;
 
-		/* Allow sleeping in xfs_alloc_pagf_init() on the 2nd pass. */
+		/* Allow sleeping in xfs_alloc_read_agf() on the 2nd pass. */
 		if (trylock != 0) {
 			trylock = 0;
 			continue;
-- 
2.33.0

