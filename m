Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2D8C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 23:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352570AbiCOXZI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 19:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346865AbiCOXZH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 19:25:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B6EB12
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 16:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EE79B818FB
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 23:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA42C340ED;
        Tue, 15 Mar 2022 23:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647386631;
        bh=cpLNCjOOE8QJvqaczFCns+Ik8GnNSer2Ut+eckAGqbw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oGgoAcINHpRUborKa0iHlmXF0qxOauhlttntzOg972afJnMLlQDZyXw+sB6+HyEdg
         j7Pf+nPhZEyf2hTrjtzbzjWJCAleWa9c5dHLTzD0+tHUPcXU43/naowW0Sr0aXIbJk
         62eEGmczNkCujh78UpLNSXRSLak5uBNBlKG1EGAfN25x//YnqZqWe//ns/VDXWVcmP
         dm+BcQhAGgKQCO2ATnJqjFzD0n462RldMkJYMWA+MNSYzHhbNXa48FysjxQPiPKIyI
         +UkOWrnzBUH8dIjH3rDrfq7X4/GIdHR5VLjACQagq85LVNL/priW6/Req1eo/DWB/C
         Py6jpqH6wJ5YA==
Subject: [PATCH 5/5] mkfs: simplify the default log size ratio computation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Tue, 15 Mar 2022 16:23:50 -0700
Message-ID: <164738663052.3191861.12606563467439945138.stgit@magnolia>
In-Reply-To: <164738660248.3191861.2400129607830047696.stgit@magnolia>
References: <164738660248.3191861.2400129607830047696.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that the minimum default log size is 64MB, we can simplify the ratio
computation because the alternate calculations no longer matter:

fssize	oldlogsize	newlogsize
16m	3m		3m
256m	5m		64m
512m	5m		64m
1g	10m		64m
4g	10m		64m
8g	10m		64m
16g	10m		64m
32g	16m		64m
64g	32m		64m
128g	64m		64m
220g	110m		110m
256g	128m		128m
512g	256m		256m
1t	512m		512m
10t	2038m		2038m

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 239d529c..15dcf48a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3432,28 +3432,14 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
 
 	/* internal log - if no size specified, calculate automatically */
 	if (!cfg->logblocks) {
-		if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
-			/* tiny filesystems get minimum sized logs. */
-			cfg->logblocks = min_logblocks;
-		} else if (cfg->dblocks < GIGABYTES(16, cfg->blocklog)) {
-
-			/*
-			 * For small filesystems, we want to use the
-			 * XFS_MIN_LOG_BYTES for filesystems smaller than 16G if
-			 * at all possible, ramping up to 128MB at 256GB.
-			 */
-			cfg->logblocks = min(XFS_MIN_LOG_BYTES >> cfg->blocklog,
-					min_logblocks * XFS_DFL_LOG_FACTOR);
-		} else {
-			/*
-			 * With a 2GB max log size, default to maximum size
-			 * at 4TB. This keeps the same ratio from the older
-			 * max log size of 128M at 256GB fs size. IOWs,
-			 * the ratio of fs size to log size is 2048:1.
-			 */
-			cfg->logblocks = (cfg->dblocks << cfg->blocklog) / 2048;
-			cfg->logblocks = cfg->logblocks >> cfg->blocklog;
-		}
+		/*
+		 * With a 2GB max log size, default to maximum size at 4TB.
+		 * This keeps the same ratio from the older max log size of
+		 * 128M at 256GB fs size. IOWs, the ratio of fs size to log
+		 * size is 2048:1.
+		 */
+		cfg->logblocks = (cfg->dblocks << cfg->blocklog) / 2048;
+		cfg->logblocks = cfg->logblocks >> cfg->blocklog;
 
 		calc_realistic_log_size(cfg);
 

