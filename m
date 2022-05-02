Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A756DC43217
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 08:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359310AbiEBIYN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 04:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383736AbiEBIXw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 04:23:52 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92778634D
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 01:20:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4AA595347AB
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 18:20:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nlRI4-0073Tk-OI
        for linux-xfs@vger.kernel.org; Mon, 02 May 2022 18:20:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nlRI4-004WMH-N3
        for linux-xfs@vger.kernel.org;
        Mon, 02 May 2022 18:20:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: set XFS_FEAT_NLINK correctly
Date:   Mon,  2 May 2022 18:20:17 +1000
Message-Id: <20220502082018.1076561-4-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502082018.1076561-1-david@fromorbit.com>
References: <20220502082018.1076561-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=626f9446
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=maWVqD0JCURTGyE90yAA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

While xfs_has_nlink() is not used in kernel, it is used in userspace
(e.g. by xfs_db) so we need to set the XFS_FEAT_NLINK flag correctly
in xfs_sb_version_to_features().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index cf9e5b9374c1..ec6eec5c0e02 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -70,6 +70,8 @@ xfs_sb_version_to_features(
 	/* optional V4 features */
 	if (sbp->sb_rblocks > 0)
 		features |= XFS_FEAT_REALTIME;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT)
+		features |= XFS_FEAT_NLINK;
 	if (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT)
 		features |= XFS_FEAT_ATTR;
 	if (sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT)
-- 
2.35.1

