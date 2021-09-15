Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B65C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE519600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhIOXLt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhIOXLt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE8A1610A6;
        Wed, 15 Sep 2021 23:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747430;
        bh=mZ0FBZxi+YHAOiPeWbsOko/JX9cqG8agqoyklp17qYU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rjp0jwyMin/GsN1WqFUWSel13WmtEO2bQvCr7yiWAuqwCTLS4W30xFOSOHgFEI3K5
         EZ5AHhGKbQPF5Q/BvmslWeyb488SC+hpthiu85noGm1Qku2a1Wc/Ardj89OlP5Aua0
         maHU0L6Tx2XuTREvK29sZCYIwFw2Wp24VfGTO6E9hdHMyK2E0TQrumUycHqKGYlZwo
         HaWd5qQfYVv7F9WiFjsVmQX2TLeAhZgjsSkS8DCYppInVcqQMZgf8R7CyYvrIQDfII
         umMovDnvKna0ACEj5WKmt4Lf/Ga/lnt6z1l8Qr4H3baYFB5tYgoPEDpPzeLcsEv7AC
         UZo/EixOqP5Gw==
Subject: [PATCH 43/61] xfs: remove xfs_perag_t
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:10:29 -0700
Message-ID: <163174742963.350433.11960764460744496227.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 509201163fca3d4d906bd50a5320115d42818748

Almost unused, gets rid of another typedef.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.c    |   24 ++++++++++++------------
 libxfs/xfs_ag.h    |    4 ++--
 libxfs/xfs_alloc.c |   42 +++++++++++++++++++++---------------------
 3 files changed, 35 insertions(+), 35 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 1db6a65b..403d9a20 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -102,19 +102,19 @@ xfs_perag_put(
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
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index fa58a45f..70b97851 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
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
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 5ecf6706..369bb0ba 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2690,21 +2690,21 @@ xfs_alloc_fix_freelist(
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
@@ -2814,20 +2814,20 @@ xfs_alloc_pagf_init(
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
 

