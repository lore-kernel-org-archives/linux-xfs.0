Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1233EC10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E62522072E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgCYBmJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 21:42:09 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55366 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727189AbgCYBmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 21:42:09 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CD20A3A3AE4
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 12:42:06 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-0006H9-ML
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-00035x-EH
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: don't allow log IO to be throttled
Date:   Wed, 25 Mar 2020 12:42:00 +1100
Message-Id: <20200325014205.11843-4-david@fromorbit.com>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200325014205.11843-1-david@fromorbit.com>
References: <20200325014205.11843-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=yPCof4ZbAAAA:8 a=5HahVxdoFHTWBnBQlCYA:9 a=DiKeHqHhRZ4A:10
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Running metadata intensive workloads, I've been seeing the AIL
pushing getting stuck on pinned buffers and triggering log forces.
The log force is taking a long time to run because the log IO is
getting throttled by wbt_wait() - the block layer writeback
throttle. It's being throttled because there is a huge amount of
metadata writeback going on which is filling the request queue.

IOWs, we have a priority inversion problem here.

Mark the log IO bios with REQ_IDLE so they don't get throttled
by the block layer writeback throttle. When we are forcing the CIL,
we are likely to need to to tens of log IOs, and they are issued as
fast as they can be build and IO completed. Hence REQ_IDLE is
appropriate - it's an indication that more IO will follow shortly.

And because we also set REQ_SYNC, the writeback throttle will now
treat log IO the same way it treats direct IO writes - it will not
throttle them at all. Hence we solve the priority inversion problem
caused by the writeback throttle being unable to distinguish between
high priority log IO and background metadata writeback.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f70be8151a59f..e16ad0b1aec84 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1687,7 +1687,15 @@ xlog_write_iclog(
 	iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart + bno;
 	iclog->ic_bio.bi_end_io = xlog_bio_end_io;
 	iclog->ic_bio.bi_private = iclog;
-	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_FUA;
+
+	/*
+	 * We use REQ_SYNC | REQ_IDLE here to tell the block layer the are more
+	 * IOs coming immediately after this one. This prevents the block layer
+	 * writeback throttle from throttling log writes behind background
+	 * metadata writeback and causing priority inversions.
+	 */
+	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC |
+				REQ_IDLE | REQ_FUA;
 	if (need_flush)
 		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
 
-- 
2.26.0.rc2

