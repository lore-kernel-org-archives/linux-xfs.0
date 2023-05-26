Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85123C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241922AbjEZBkB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbjEZBkA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:40:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189A7189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:40:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2F20646CD
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15000C4339B;
        Fri, 26 May 2023 01:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065199;
        bh=eF1iXcfJ4UMpx5yodVR+3gXICn3B6QBHd0G0M0DVDI0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=gU2d+/gWbgzCZVrinkCYy+0HtzTkcqUHegaSqpUf2HNV8IXWBuokBJHonc4PmG0Qd
         p4JoFGJtP666zJoa6RGtn9Eb9a3v3L82yzypC3Ulb4theup3H/wViY9fZHFI77ktnv
         iQKgINV1/YXPxD8C4+627FN1vmNwKxGb5PFA2jajSESTC/Au/4FsKAv8U8OnZNjZ1f
         qkTsvBlTKiJwJXaxenadM5AYqCP3z96VpCTVbJJOZPUFJjfVBuqeW1z4wCITfXjIPE
         KXryYayYlxQuGdNjtSOBVrQpp5HXP8y4YqYhAvPoPAUwqxVtz6ZB0rkE9ZFD6byNm4
         m2cDTobP/e6TQ==
Date:   Thu, 25 May 2023 18:39:58 -0700
Subject: [PATCH 2/4] xfs: separate the xfs_trim_perag looping code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506069747.3738451.9927373460079597290.stgit@frogsfrogsfrogs>
In-Reply-To: <168506069715.3738451.3754446921976634655.stgit@frogsfrogsfrogs>
References: <168506069715.3738451.3754446921976634655.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In preparation for the next patch, hoist the code that walks the cntbt
looking for space to trim into a separate function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |   49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index e2272da46afd..ce77451b00ef 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -20,9 +20,11 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 
-STATIC int
-xfs_trim_ag_extents(
+/* Trim the free space in this AG by length. */
+static inline int
+xfs_trim_ag_bylen(
 	struct xfs_perag	*pag,
+	struct xfs_buf		*agbp,
 	xfs_daddr_t		start,
 	xfs_daddr_t		end,
 	xfs_daddr_t		minlen,
@@ -31,23 +33,10 @@ xfs_trim_ag_extents(
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct block_device	*bdev = xfs_buftarg_bdev(mp->m_ddev_targp);
 	struct xfs_btree_cur	*cur;
-	struct xfs_buf		*agbp;
-	struct xfs_agf		*agf;
+	struct xfs_agf		*agf = agbp->b_addr;
 	int			error;
 	int			i;
 
-	/*
-	 * Force out the log.  This means any transactions that might have freed
-	 * space before we take the AGF buffer lock are now on disk, and the
-	 * volatile disk cache is flushed.
-	 */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
-	error = xfs_alloc_read_agf(pag, NULL, 0, &agbp);
-	if (error)
-		return error;
-	agf = agbp->b_addr;
-
 	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
 
 	/*
@@ -131,6 +120,34 @@ xfs_trim_ag_extents(
 
 out_del_cursor:
 	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+
+STATIC int
+xfs_trim_ag_extents(
+	struct xfs_perag	*pag,
+	xfs_daddr_t		start,
+	xfs_daddr_t		end,
+	xfs_daddr_t		minlen,
+	uint64_t		*blocks_trimmed)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_buf		*agbp;
+	int			error;
+
+	/*
+	 * Force out the log.  This means any transactions that might have freed
+	 * space before we take the AGF buffer lock are now on disk, and the
+	 * volatile disk cache is flushed.
+	 */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
+	error = xfs_alloc_read_agf(pag, NULL, 0, &agbp);
+	if (error)
+		return error;
+
+	error = xfs_trim_ag_bylen(pag, agbp, start, end, minlen,
+			blocks_trimmed);
 	xfs_buf_relse(agbp);
 	return error;
 }

