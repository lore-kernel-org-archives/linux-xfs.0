Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6614BC43214
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4358460551
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbhHJFSy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:18:54 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:51016 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237174AbhHJFSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:18:53 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 6CC4E109B42
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:18:30 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDK9l-00GZZB-4J
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:18:29 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDK9k-000Ac6-Su
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:18:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 9/9] xfs: log head and tail aren't reliable during shutdown
Date:   Tue, 10 Aug 2021 15:18:25 +1000
Message-Id: <20210810051825.40715-10-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810051825.40715-1-david@fromorbit.com>
References: <20210810051825.40715-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=ncMNf5S8S4aAe9K18sIA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

I'm seeing assert failures from xlog_space_left() after a shutdown
has begun that look like:

XFS (dm-0): log I/O error -5
XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1338 of file fs/xfs/xfs_log.c. Return address = xlog_ioend_work+0x64/0xc0
XFS (dm-0): Log I/O Error Detected.
XFS (dm-0): Shutting down filesystem. Please unmount the filesystem and rectify the problem(s)
XFS (dm-0): xlog_space_left: head behind tail
XFS (dm-0):   tail_cycle = 6, tail_bytes = 2706944
XFS (dm-0):   GH   cycle = 6, GH   bytes = 1633867
XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 1310
------------[ cut here ]------------
Call Trace:
 xlog_space_left+0xc3/0x110
 xlog_grant_push_threshold+0x3f/0xf0
 xlog_grant_push_ail+0x12/0x40
 xfs_log_reserve+0xd2/0x270
 ? __might_sleep+0x4b/0x80
 xfs_trans_reserve+0x18b/0x260
.....

There are two things here. Firstly, after a shutdown, the log head
and tail can be out of whack as things abort and release (or don't
release) resources, so checking them for sanity doesn't make much
sense. Secondly, xfs_log_reserve() can race with shutdown and so it
can still fail like this even though it has already checked for a
log shutdown before calling xlog_grant_push_ail().

So, before ASSERT failing in xlog_space_left(), make sure we haven't
already shut down....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 51 +++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a4ec23b5c459..a26c7909cbe7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1307,16 +1307,18 @@ xlog_assign_tail_lsn(
  * wrap the tail, we should blow up.  Rather than catch this case here,
  * we depend on other ASSERTions in other parts of the code.   XXXmiken
  *
- * This code also handles the case where the reservation head is behind
- * the tail.  The details of this case are described below, but the end
- * result is that we return the size of the log as the amount of space left.
+ * If reservation head is behind the tail, we have a problem. Warn about it,
+ * but then treat it as if the log is empty.
+ *
+ * If the log is shut down, the head and tail may be invalid or out of whack, so
+ * shortcut invalidity asserts in this case so that we don't trigger them
+ * falsely.
  */
 STATIC int
 xlog_space_left(
 	struct xlog	*log,
 	atomic64_t	*head)
 {
-	int		free_bytes;
 	int		tail_bytes;
 	int		tail_cycle;
 	int		head_cycle;
@@ -1326,29 +1328,30 @@ xlog_space_left(
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
 	tail_bytes = BBTOB(tail_bytes);
 	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
-		free_bytes = log->l_logsize - (head_bytes - tail_bytes);
-	else if (tail_cycle + 1 < head_cycle)
+		return log->l_logsize - (head_bytes - tail_bytes);
+	if (tail_cycle + 1 < head_cycle)
 		return 0;
-	else if (tail_cycle < head_cycle) {
+
+	/* Ignore potential inconsistency when shutdown. */
+	if (xlog_is_shutdown(log))
+		return log->l_logsize;
+
+	if (tail_cycle < head_cycle) {
 		ASSERT(tail_cycle == (head_cycle - 1));
-		free_bytes = tail_bytes - head_bytes;
-	} else {
-		/*
-		 * The reservation head is behind the tail.
-		 * In this case we just want to return the size of the
-		 * log as the amount of space left.
-		 */
-		xfs_alert(log->l_mp, "xlog_space_left: head behind tail");
-		xfs_alert(log->l_mp,
-			  "  tail_cycle = %d, tail_bytes = %d",
-			  tail_cycle, tail_bytes);
-		xfs_alert(log->l_mp,
-			  "  GH   cycle = %d, GH   bytes = %d",
-			  head_cycle, head_bytes);
-		ASSERT(0);
-		free_bytes = log->l_logsize;
+		return tail_bytes - head_bytes;
 	}
-	return free_bytes;
+
+	/*
+	 * The reservation head is behind the tail. In this case we just want to
+	 * return the size of the log as the amount of space left.
+	 */
+	xfs_alert(log->l_mp, "xlog_space_left: head behind tail");
+	xfs_alert(log->l_mp, "  tail_cycle = %d, tail_bytes = %d",
+		  tail_cycle, tail_bytes);
+	xfs_alert(log->l_mp, "  GH   cycle = %d, GH   bytes = %d",
+		  head_cycle, head_bytes);
+	ASSERT(0);
+	return log->l_logsize;
 }
 
 
-- 
2.31.1

