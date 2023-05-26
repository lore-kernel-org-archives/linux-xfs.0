Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93700C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjEZBjq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZBjq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838DC195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:39:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 158BD61276
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76847C433EF;
        Fri, 26 May 2023 01:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065183;
        bh=bNpF8LWVe5R0+zjP3Yf8N50Sjl0HBkIxgcwJTTvGn+c=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=JteH8q8TIZvCogV+4XIbN8IzogoNj/iQgBlLw98Z3HDY2NawAKQE02rhH/0vUxm4U
         46+jwMAMIk0dc1gg3ZEzP40Ix46t5feon2NWxZdAtAhI/QA81T17mvN9aj+ISaYcJU
         v80WVFXJa0zinJgoGkqut1GlulJKeyHN1OL2kQP8A70mdnU3jMkchnTuL9fxwEqFRe
         7+HlMbkeL/cZ0YjIEKJH3P/TRMFDYcgb7GoSSRqI2X/F6IDqYrojxuxgffakCrcjyt
         0dly7YygkTpcC82KTIUc9pOfg1DIwURc5HXdGg6KpX2qmBJPG+F4anQou/6f4kncEk
         2Qox+5P31v+jw==
Date:   Thu, 25 May 2023 18:39:43 -0700
Subject: [PATCH 1/4] xfs: hoist data device FITRIM AG iteration to a separate
 function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506069733.3738451.1770343447309626224.stgit@frogsfrogsfrogs>
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

Hoist the AG iteration loop logic out of xfs_ioc_trim and into a
separate function.  No functional changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |   55 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 3d074d094bf4..e2272da46afd 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -21,7 +21,7 @@
 #include "xfs_health.h"
 
 STATIC int
-xfs_trim_extents(
+xfs_trim_ag_extents(
 	struct xfs_perag	*pag,
 	xfs_daddr_t		start,
 	xfs_daddr_t		end,
@@ -135,6 +135,37 @@ xfs_trim_extents(
 	return error;
 }
 
+static int
+xfs_trim_ddev_extents(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		start,
+	xfs_daddr_t		end,
+	xfs_daddr_t		minlen,
+	uint64_t		*blocks_trimmed)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	int			error, last_error = 0;
+
+	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
+		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
+
+	agno = xfs_daddr_to_agno(mp, start);
+	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, end), pag) {
+		error = xfs_trim_ag_extents(pag, start, end, minlen,
+				blocks_trimmed);
+		if (error) {
+			last_error = error;
+			if (error == -ERESTARTSYS) {
+				xfs_perag_rele(pag);
+				break;
+			}
+		}
+	}
+
+	return last_error;
+}
+
 /*
  * trim a range of the filesystem.
  *
@@ -149,12 +180,10 @@ xfs_ioc_trim(
 	struct xfs_mount		*mp,
 	struct fstrim_range __user	*urange)
 {
-	struct xfs_perag	*pag;
 	struct block_device	*bdev = xfs_buftarg_bdev(mp->m_ddev_targp);
 	unsigned int		granularity = bdev_discard_granularity(bdev);
 	struct fstrim_range	range;
 	xfs_daddr_t		start, end, minlen;
-	xfs_agnumber_t		agno;
 	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
 
@@ -190,21 +219,11 @@ xfs_ioc_trim(
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
 
-	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
-		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
-
-	agno = xfs_daddr_to_agno(mp, start);
-	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, end), pag) {
-		error = xfs_trim_extents(pag, start, end, minlen,
-					  &blocks_trimmed);
-		if (error) {
-			last_error = error;
-			if (error == -ERESTARTSYS) {
-				xfs_perag_rele(pag);
-				break;
-			}
-		}
-	}
+	error = xfs_trim_ddev_extents(mp, start, end, minlen, &blocks_trimmed);
+	if (error == -ERESTARTSYS)
+		return error;
+	if (error)
+		last_error = error;
 
 	if (last_error)
 		return last_error;

