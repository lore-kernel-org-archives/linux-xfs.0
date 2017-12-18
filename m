Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56061 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750916AbdLRJMG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 04:12:06 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eQrSr-0002st-Ne
        for linux-xfs@vger.kernel.org; Mon, 18 Dec 2017 20:12:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1eQrSr-0003qO-MX
        for linux-xfs@vger.kernel.org; Mon, 18 Dec 2017 20:12:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/7] mkfs: protofile only needs to be set up once
Date: Mon, 18 Dec 2017 20:11:54 +1100
Message-Id: <20171218091158.14537-4-david@fromorbit.com>
In-Reply-To: <20171218091158.14537-1-david@fromorbit.com>
References: <20171218091158.14537-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4a9c457ce603..7cc5ee2ddb9d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4024,8 +4024,6 @@ main(
 	 */
 	calculate_log_size(&cfg, &cli, mp);
 
-	protostring = setup_proto(protofile);
-
 	if (!quiet || dry_run) {
 		print_mkfs_cfg(&cfg, dfile, logfile, rtfile);
 		if (dry_run)
-- 
2.15.0

