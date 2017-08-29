Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27944 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751820AbdH2Xu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:50:57 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002br-Bp
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005VO-AN
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/42] mkfs: can't specify sector size of internal log
Date: Wed, 30 Aug 2017 09:50:11 +1000
Message-Id: <20170829235052.21050-2-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because it's fixed by the underlying device size.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7bb6408f9b77..e16e73f86cbc 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -428,6 +428,8 @@ struct opt_params lopts = {
 		{ .index = L_INTERNAL,
 		  .conflicts = { L_FILE,
 				 L_DEV,
+				 L_SECTLOG,
+				 L_SECTSIZE,
 				 LAST_CONFLICT },
 		  .minval = 0,
 		  .maxval = 1,
@@ -469,6 +471,7 @@ struct opt_params lopts = {
 		},
 		{ .index = L_SECTLOG,
 		  .conflicts = { L_SECTSIZE,
+				 L_INTERNAL,
 				 LAST_CONFLICT },
 		  .minval = XFS_MIN_SECTORSIZE_LOG,
 		  .maxval = XFS_MAX_SECTORSIZE_LOG,
@@ -476,6 +479,7 @@ struct opt_params lopts = {
 		},
 		{ .index = L_SECTSIZE,
 		  .conflicts = { L_SECTLOG,
+				 L_INTERNAL,
 				 LAST_CONFLICT },
 		  .convert = true,
 		  .is_power_2 = true,
-- 
2.13.3

