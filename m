Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7934BC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348768AbiFKB1e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348886AbiFKB1U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:20 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F7C33A4CC5
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A8FD510E721D
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005AQT-Lq
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELOa-Kp
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 50/50] xfs: fix low space alloc deadlock
Date:   Sat, 11 Jun 2022 11:26:59 +1000
Message-Id: <20220611012659.3418072-51-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=AQxbOZYVekb0bz2bvA8A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is fixing a g/476 AGF ABBA deadlock that occurs reliably
with this patchset so far. Allocation is attempted in AG 2, which
has no space, then AG 3 which fails with "nominleft" search error.
THis then returns to the caller with AGF 3 still locked, and the
caller then does a retry with more restricted allocation criteria.
This then starts again at AG 2, which then deadlocks because it's
the wrong AGF locking order.

What I can't work out is how the existing TOT code isn't hitting
this every time g/476 is run. I can't see where it unlocks AGF 3,
nor can I see how it avoids the out of order locking on nospace
retries. So this looks like a pre-existing bug, but it takes this
allocator rework to expose it?

More work investigation needed here.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index abf78453d155..c0af59e5e935 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3332,8 +3332,27 @@ xfs_alloc_vextent_iterate_ags(
 		args->pag = NULL;
 		return error;
 	}
-	if (args->agbp)
+	if (args->agbp) {
+		/*
+		 * XXX: this looks like a pre-existing bug. alloc_size fails
+		 * because of nominleft, and we return here with the AGF locked
+		 * with args->agbno == NULLAGBLOCK If this happens with any AG
+		 * higher than the start_agno, if the caller then tries to allocate
+		 * again with more restricted parameters, we try locking from
+		 * start_agno again and we deadlock because we've already got a
+		 * higher AGF locked. Hence we need to drop the AGF lock if
+		 * we failed to allocate here. g/476 triggers this reliably.
+		 */
+		if (args->agbno == NULLAGBLOCK) {
+			/*
+			 * XXX: This is not a reliable workaround if the AGF was
+			 * modified!
+			 */
+			xfs_trans_brelse(args->tp, args->agbp);
+			args->agbp = NULL;
+		}
 		return 0;
+	}
 
 	/*
 	 * We didn't find an AG we can alloation from. If we were given
-- 
2.35.1

