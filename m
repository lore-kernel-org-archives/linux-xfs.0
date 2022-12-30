Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01EFDC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbiLaBxQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiLaBxP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:53:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866331DDD6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:53:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2348D61CD3
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851ECC433D2;
        Sat, 31 Dec 2022 01:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451593;
        bh=/DHm+0caYfymiolz4YDzY3knvfM1O7xCGUJ+4KAnYlI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SuX868hdM4FjvR2QWSrupd2e8uSTA8njrS2snG8UD7S8xRgh9MfmIWf+qbQUzgglZ
         TBrDn7Esg3wz502nPj+Lcx+V+eIH8Oq5q0Lqcm/kQhyTmCFLGDCuZOvrNGOagz4H1Q
         89BKGGh4iGmeGanPBKz9kDH4uBXgF+J9+0VuKKckNvnDQ+hnxBOVc5oNfTuJtQ3h3s
         MOc5+ThVoWYtF+XqCjIlvFna6Uzfzj3Uga0DrbV7xfa/PznQJw2KNv881w8JEyHXtt
         ujhKGI5dz3X1PuqpXJpk/SmdHm7JOROcJuBjBw1KB+BEFzjqr8YwpnISJx+qyjULd5
         QcmXH58HQ4Emg==
Subject: [PATCH 20/42] xfs: enable sharing of realtime file blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871180.717073.13325087628739180105.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the remapping routines to be able to handle realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3b5d144bef41..3cead39e4308 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -33,6 +33,7 @@
 #include "xfs_rtrefcount_btree.h"
 #include "xfs_rtalloc.h"
 #include "xfs_rtgroup.h"
+#include "xfs_imeta.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -1207,14 +1208,29 @@ xfs_reflink_update_dest(
 static int
 xfs_reflink_ag_has_free_space(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		fsb)
 {
 	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
 	int			error = 0;
 
 	if (!xfs_has_rmapbt(mp))
 		return 0;
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		struct xfs_rtgroup	*rtg;
+		xfs_rgnumber_t		rgno;
 
+		rgno = xfs_rtb_to_rgno(mp, fsb);
+		rtg = xfs_rtgroup_get(mp, rgno);
+		if (xfs_imeta_resv_critical(rtg->rtg_rmapip) ||
+		    xfs_imeta_resv_critical(rtg->rtg_refcountip))
+			error = -ENOSPC;
+		xfs_rtgroup_put(rtg);
+		return error;
+	}
+
+	agno = XFS_FSB_TO_AGNO(mp, fsb);
 	pag = xfs_perag_get(mp, agno);
 	if (xfs_ag_resv_critical(pag, XFS_AG_RESV_RMAPBT) ||
 	    xfs_ag_resv_critical(pag, XFS_AG_RESV_METADATA))
@@ -1328,8 +1344,8 @@ xfs_reflink_remap_extent(
 
 	/* No reflinking if the AG of the dest mapping is low on space. */
 	if (dmap_written) {
-		error = xfs_reflink_ag_has_free_space(mp,
-				XFS_FSB_TO_AGNO(mp, dmap->br_startblock));
+		error = xfs_reflink_ag_has_free_space(mp, ip,
+				dmap->br_startblock);
 		if (error)
 			goto out_cancel;
 	}
@@ -1589,8 +1605,8 @@ xfs_reflink_remap_prep(
 
 	/* Check file eligibility and prepare for block sharing. */
 	ret = -EINVAL;
-	/* Don't reflink realtime inodes */
-	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
+	/* Can't reflink between data and rt volumes */
+	if (XFS_IS_REALTIME_INODE(src) != XFS_IS_REALTIME_INODE(dest))
 		goto out_unlock;
 
 	/* Don't share DAX file data with non-DAX file. */

