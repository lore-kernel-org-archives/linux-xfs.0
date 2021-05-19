Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3A7C43600
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A25613AA
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 01:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhESBWb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 May 2021 21:22:31 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:60341 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232277AbhESBW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 21:22:28 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 98AA11075C0
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 11:21:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtU-002bOx-6s
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtT-001tKr-Vd
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 23/23] xfs: remove xfs_perag_t
Date:   Wed, 19 May 2021 11:21:02 +1000
Message-Id: <20210519012102.450926-24-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519012102.450926-1-david@fromorbit.com>
References: <20210519012102.450926-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=pAOcoVMQ13P0UJU-h3QA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Almost unused, gets rid of another typedef.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c    | 24 +++++++++++-----------
 fs/xfs/libxfs/xfs_ag.h    |  4 ++--
 fs/xfs/libxfs/xfs_alloc.c | 42 +++++++++++++++++++--------------------
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 0e0819f6fb89..29c42698aa90 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -104,19 +104,19 @@ xfs_perag_put(
  */
 int
 xfs_initialize_perag_data(
-	struct xfs_mount *mp,
-	xfs_agnumber_t	agcount)
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agcount)
 {
-	xfs_agnumber_t	index;
-	xfs_perag_t	*pag;
-	xfs_sb_t	*sbp = &mp->m_sb;
-	uint64_t	ifree = 0;
-	uint64_t	ialloc = 0;
-	uint64_t	bfree = 0;
-	uint64_t	bfreelst = 0;
-	uint64_t	btree = 0;
-	uint64_t	fdblocks;
-	int		error = 0;
+	xfs_agnumber_t		index;
+	struct xfs_perag	*pag;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	uint64_t		ifree = 0;
+	uint64_t		ialloc = 0;
+	uint64_t		bfree = 0;
+	uint64_t		bfreelst = 0;
+	uint64_t		btree = 0;
+	uint64_t		fdblocks;
+	int			error = 0;
 
 	for (index = 0; index < agcount; index++) {
 		/*
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index bebbe1bfce27..39f6a0dc984a 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -29,7 +29,7 @@ struct xfs_ag_resv {
  * Per-ag incore structure, copies of information in agf and agi, to improve the
  * performance of allocation group selection.
  */
-typedef struct xfs_perag {
+struct xfs_perag {
 	struct xfs_mount *pag_mount;	/* owner filesystem */
 	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
 	atomic_t	pag_ref;	/* perag reference count */
@@ -102,7 +102,7 @@ typedef struct xfs_perag {
 	 * or have some other means to control concurrency.
 	 */
 	struct rhashtable	pagi_unlinked_hash;
-} xfs_perag_t;
+};
 
 int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
 			xfs_agnumber_t *maxagi);
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f7864f33c1f0..00bb34251829 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2694,21 +2694,21 @@ xfs_alloc_fix_freelist(
  * Get a block from the freelist.
  * Returns with the buffer for the block gotten.
  */
-int				/* error */
+int
 xfs_alloc_get_freelist(
-	xfs_trans_t	*tp,	/* transaction pointer */
-	struct xfs_buf	*agbp,	/* buffer containing the agf structure */
-	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
-	int		btreeblk) /* destination is a AGF btree */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agblock_t		*bnop,
+	int			btreeblk)
 {
-	struct xfs_agf	*agf = agbp->b_addr;
-	struct xfs_buf	*agflbp;/* buffer for a.g. freelist structure */
-	xfs_agblock_t	bno;	/* block number returned */
-	__be32		*agfl_bno;
-	int		error;
-	int		logflags;
-	xfs_mount_t	*mp = tp->t_mountp;
-	xfs_perag_t	*pag;	/* per allocation group data */
+	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_buf		*agflbp;
+	xfs_agblock_t		bno;
+	__be32			*agfl_bno;
+	int			error;
+	int			logflags;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_perag	*pag;
 
 	/*
 	 * Freelist is empty, give up.
@@ -2818,20 +2818,20 @@ xfs_alloc_pagf_init(
 /*
  * Put the block on the freelist for the allocation group.
  */
-int					/* error */
+int
 xfs_alloc_put_freelist(
-	xfs_trans_t		*tp,	/* transaction pointer */
-	struct xfs_buf		*agbp,	/* buffer for a.g. freelist header */
-	struct xfs_buf		*agflbp,/* buffer for a.g. free block array */
-	xfs_agblock_t		bno,	/* block being freed */
-	int			btreeblk) /* block came from a AGF btree */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	struct xfs_buf		*agflbp,
+	xfs_agblock_t		bno,
+	int			btreeblk)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	__be32			*blockp;/* pointer to array entry */
+	struct xfs_perag	*pag;
+	__be32			*blockp;
 	int			error;
 	int			logflags;
-	xfs_perag_t		*pag;	/* per allocation group data */
 	__be32			*agfl_bno;
 	int			startoff;
 
-- 
2.31.1

