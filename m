Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22FAC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiKICGe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiKICGb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:06:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B752167F6F
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:06:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5400B6187F
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B038FC433C1;
        Wed,  9 Nov 2022 02:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959587;
        bh=OTc487UXuHdbnY9ShMdHrCRg80Ia9/wBidA55RlkOKU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NV/+0N4DrQZim9bgUbxgxIULi7Q13/AViUUzH4G/DjYCR8WK80wiv2itGW+T3hiRN
         vgeubg424E2LuZvJEa0yrl/2EvNeO6pH0fouTttnnzr6MGOU4CaIOt03Qq7cqlTUse
         KYJ5ary6hZL3xnw8ZhR0Uv8foHeIPR1buHwlMy9g1qVP5pcjenWywy7GzAGnYDC5QM
         LAKcN3hWieFFi2bCjSYqjQ8WNfOO7i3uCFHWx1qMbKMcH66/J3IOlPIG9Lk5HJ/jFk
         plfm8MYHocHrhhdx+s4A50WRrHANOztg1bArCbHuTcN9gsLUU5ypbyLxj0aesBWx4u
         KVaW7/1sYTilA==
Subject: [PATCH 08/24] xfs: increase rename inode reservation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:06:27 -0800
Message-ID: <166795958729.3761583.16534685915746168184.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: e07ee6fe21f47cfd72ae566395c67a80e7c66163

xfs_rename can update up to 5 inodes: src_dp, target_dp, src_ip, target_ip
and wip.  So we need to increase the inode reservation to match.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_trans_resv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 797176d7d3..04c444806f 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -421,7 +421,7 @@ xfs_calc_itruncate_reservation_minlogsize(
 
 /*
  * In renaming a files we can modify:
- *    the four inodes involved: 4 * inode size
+ *    the five inodes involved: 5 * inode size
  *    the two directory btrees: 2 * (max depth + v2) * dir block size
  *    the two directory bmap btrees: 2 * max depth * block size
  * And the bmap_finish transaction can free dir and bmap blocks (two sets
@@ -436,7 +436,7 @@ xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		max((xfs_calc_inode_res(mp, 4) +
+		max((xfs_calc_inode_res(mp, 5) +
 		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +

