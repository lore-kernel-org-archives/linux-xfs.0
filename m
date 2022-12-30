Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2FEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbiLaBdo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLaBdn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:33:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F90DEB7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:33:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A543561CC5
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AB0C433D2;
        Sat, 31 Dec 2022 01:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450422;
        bh=PmzCoIwKwqB4KB0RVXdk6efPlTYNAI3Ki05yB+D4zjM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DjY9stRlY+T3vqPJCJ5hrmUyJCq8Bc3W4Wf63bzphGPiwETP2pimtO1KrlRtstIIE
         LJ/atHWKwQaOK5ORWAJEErrrkTi7OtFavewfDkgJe1+XzTs9uzRACmXJar9oxlilTa
         hvvUKWhv4AJDlCA54c/r/Z42Cqf7HneBmU2b4DJFnUj5Ba5AcGtdjXM9RPo79OeJJN
         ueY1YWbyb44rqhXjsKcH/o08pVb7CzuAoXmOGbYcIMfTNj3yg0bjIrkHG49RjxGKwS
         sCnRlgxeeVEJi0f89nQthcB6tmiXDw2B0FDCSMSptpAx4+zurPiH1OfkUnZCEwd0d2
         l1bwnAKZHmoog==
Subject: [PATCH 2/3] xfs: convert xfs_trim_extents to use perag iteration
 macros
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:58 -0800
Message-ID: <167243867893.713699.267191642447274880.stgit@magnolia>
In-Reply-To: <167243867862.713699.17132272459502557791.stgit@magnolia>
References: <167243867862.713699.17132272459502557791.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the AG iteration loop to use the ranged perag iteration macro,
remove the perag_get/put calls from xfs_trim_extents, and rename the
function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 7459c5205a6b..6d3400771e21 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -21,24 +21,22 @@
 #include "xfs_health.h"
 
 STATIC int
-xfs_trim_extents(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
+xfs_trim_perag_extents(
+	struct xfs_perag	*pag,
 	xfs_daddr_t		start,
 	xfs_daddr_t		end,
 	xfs_daddr_t		minlen,
 	uint64_t		*blocks_trimmed)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	struct block_device	*bdev = xfs_buftarg_bdev(mp->m_ddev_targp);
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
 	struct xfs_agf		*agf;
-	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno = pag->pag_agno;
 	int			error;
 	int			i;
 
-	pag = xfs_perag_get(mp, agno);
-
 	/*
 	 * Force out the log.  This means any transactions that might have freed
 	 * space before we take the AGF buffer lock are now on disk, and the
@@ -48,7 +46,7 @@ xfs_trim_extents(
 
 	error = xfs_alloc_read_agf(pag, NULL, 0, &agbp);
 	if (error)
-		goto out_put_perag;
+		return error;
 	agf = agbp->b_addr;
 
 	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
@@ -135,8 +133,6 @@ xfs_trim_extents(
 out_del_cursor:
 	xfs_btree_del_cursor(cur, error);
 	xfs_buf_relse(agbp);
-out_put_perag:
-	xfs_perag_put(pag);
 	return error;
 }
 
@@ -148,7 +144,8 @@ xfs_trim_ddev_extents(
 	xfs_daddr_t		minlen,
 	uint64_t		*blocks_trimmed)
 {
-	xfs_agnumber_t		start_agno, end_agno, agno;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		start_agno, end_agno;
 	int			error, last_error = 0;
 
 	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
@@ -157,11 +154,13 @@ xfs_trim_ddev_extents(
 	start_agno = xfs_daddr_to_agno(mp, start);
 	end_agno = xfs_daddr_to_agno(mp, end);
 
-	for (agno = start_agno; agno <= end_agno; agno++) {
-		error = xfs_trim_extents(mp, agno, start, end, minlen,
+	for_each_perag_range(mp, start_agno, end_agno, pag) {
+		error = xfs_trim_perag_extents(pag, start, end, minlen,
 				blocks_trimmed);
-		if (error == -ERESTARTSYS)
+		if (error == -ERESTARTSYS) {
+			xfs_perag_put(pag);
 			return error;
+		}
 		if (error)
 			last_error = error;
 	}

