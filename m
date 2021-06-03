Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2441CC4709C
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B419613F0
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhFCFYw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 01:24:52 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:56268 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhFCFYv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 01:24:51 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 0F7C580B280
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jun 2021 15:22:51 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofog-008MqI-I1
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lofog-000ilZ-AH
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/39] xfs: Fix CIL throttle hang when CIL space used going backwards
Date:   Thu,  3 Jun 2021 15:22:09 +1000
Message-Id: <20210603052240.171998-9-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603052240.171998-1-david@fromorbit.com>
References: <20210603052240.171998-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
        a=jMqSS0pQBfBzRtNEyY0A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

A hang with tasks stuck on the CIL hard throttle was reported and
largely diagnosed by Donald Buczek, who discovered that it was a
result of the CIL context space usage decrementing in committed
transactions once the hard throttle limit had been hit and processes
were already blocked.  This resulted in the CIL push not waking up
those waiters because the CIL context was no longer over the hard
throttle limit.

The surprising aspect of this was the CIL space usage going
backwards regularly enough to trigger this situation. Assumptions
had been made in design that the relogging process would only
increase the size of the objects in the CIL, and so that space would
only increase.

This change and commit message fixes the issue and documents the
result of an audit of the triggers that can cause the CIL space to
go backwards, how large the backwards steps tend to be, the
frequency in which they occur, and what the impact on the CIL
accounting code is.

Even though the CIL ctx->space_used can go backwards, it will only
do so if the log item is already logged to the CIL and contains a
space reservation for it's entire logged state. This is tracked by
the shadow buffer state on the log item. If the item is not
previously logged in the CIL it has no shadow buffer nor log vector,
and hence the entire size of the logged item copied to the log
vector is accounted to the CIL space usage. i.e.  it will always go
up in this case.

If the item has a log vector (i.e. already in the CIL) and the size
decreases, then the existing log vector will be overwritten and the
space usage will go down. This is the only condition where the space
usage reduces, and it can only occur when an item is already tracked
in the CIL. Hence we are safe from CIL space usage underruns as a
result of log items decreasing in size when they are relogged.

Typically this reduction in CIL usage occurs from metadata blocks
being free, such as when a btree block merge occurs or a directory
enter/xattr entry is removed and the da-tree is reduced in size.
This generally results in a reduction in size of around a single
block in the CIL, but also tends to increase the number of log
vectors because the parent and sibling nodes in the tree needs to be
updated when a btree block is removed. If a multi-level merge
occurs, then we see reduction in size of 2+ blocks, but again the
log vector count goes up.

The other vector is inode fork size changes, which only log the
current size of the fork and ignore the previously logged size when
the fork is relogged. Hence if we are removing items from the inode
fork (dir/xattr removal in shortform, extent record removal in
extent form, etc) the relogged size of the inode for can decrease.

No other log items can decrease in size either because they are a
fixed size (e.g. dquots) or they cannot be relogged (e.g. relogging
an intent actually creates a new intent log item and doesn't relog
the old item at all.) Hence the only two vectors for CIL context
size reduction are relogging inode forks and marking buffers active
in the CIL as stale.

Long story short: the majority of the code does the right thing and
handles the reduction in log item size correctly, and only the CIL
hard throttle implementation is problematic and needs fixing. This
patch makes that fix, as well as adds comments in the log item code
that result in items shrinking in size when they are relogged as a
clear reminder that this can and does happen frequently.

The throttle fix is based upon the change Donald proposed, though it
goes further to ensure that once the throttle is activated, it
captures all tasks until the CIL push issues a wakeup, regardless of
whether the CIL space used has gone back under the throttle
threshold.

This ensures that we prevent tasks reducing the CIL slightly under
the throttle threshold and then making more changes that push it
well over the throttle limit. This is acheived by checking if the
throttle wait queue is already active as a condition of throttling.
Hence once we start throttling, we continue to apply the throttle
until the CIL context push wakes everything on the wait queue.

We can use waitqueue_active() for the waitqueue manipulations and
checks as they are all done under the ctx->xc_push_lock. Hence the
waitqueue has external serialisation and we can safely peek inside
the wait queue without holding the internal waitqueue locks.

Many thanks to Donald for his diagnostic and analysis work to
isolate the cause of this hang.

Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item.c   | 37 ++++++++++++++++++-------------------
 fs/xfs/xfs_inode_item.c | 14 ++++++++++++++
 fs/xfs/xfs_log_cil.c    | 22 +++++++++++++++++-----
 3 files changed, 49 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index fb69879e4b2b..14d1fefcbf4c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -74,14 +74,12 @@ xfs_buf_item_straddle(
 }
 
 /*
- * This returns the number of log iovecs needed to log the
- * given buf log item.
+ * Return the number of log iovecs and space needed to log the given buf log
+ * item segment.
  *
- * It calculates this as 1 iovec for the buf log format structure
- * and 1 for each stretch of non-contiguous chunks to be logged.
- * Contiguous chunks are logged in a single iovec.
- *
- * If the XFS_BLI_STALE flag has been set, then log nothing.
+ * It calculates this as 1 iovec for the buf log format structure and 1 for each
+ * stretch of non-contiguous chunks to be logged.  Contiguous chunks are logged
+ * in a single iovec.
  */
 STATIC void
 xfs_buf_item_size_segment(
@@ -168,11 +166,8 @@ xfs_buf_item_size_segment(
 }
 
 /*
- * This returns the number of log iovecs needed to log the given buf log item.
- *
- * It calculates this as 1 iovec for the buf log format structure and 1 for each
- * stretch of non-contiguous chunks to be logged.  Contiguous chunks are logged
- * in a single iovec.
+ * Return the number of log iovecs and space needed to log the given buf log
+ * item.
  *
  * Discontiguous buffers need a format structure per region that is being
  * logged. This makes the changes in the buffer appear to log recovery as though
@@ -182,7 +177,11 @@ xfs_buf_item_size_segment(
  * what ends up on disk.
  *
  * If the XFS_BLI_STALE flag has been set, then log nothing but the buf log
- * format structures.
+ * format structures. If the item has previously been logged and has dirty
+ * regions, we do not relog them in stale buffers. This has the effect of
+ * reducing the size of the relogged item by the amount of dirty data tracked
+ * by the log item. This can result in the committing transaction reducing the
+ * amount of space being consumed by the CIL.
  */
 STATIC void
 xfs_buf_item_size(
@@ -199,9 +198,9 @@ xfs_buf_item_size(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	if (bip->bli_flags & XFS_BLI_STALE) {
 		/*
-		 * The buffer is stale, so all we need to log
-		 * is the buf log format structure with the
-		 * cancel flag in it.
+		 * The buffer is stale, so all we need to log is the buf log
+		 * format structure with the cancel flag in it as we are never
+		 * going to replay the changes tracked in the log item.
 		 */
 		trace_xfs_buf_item_size_stale(bip);
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
@@ -216,9 +215,9 @@ xfs_buf_item_size(
 
 	if (bip->bli_flags & XFS_BLI_ORDERED) {
 		/*
-		 * The buffer has been logged just to order it.
-		 * It is not being included in the transaction
-		 * commit, so no vectors are used at all.
+		 * The buffer has been logged just to order it. It is not being
+		 * included in the transaction commit, so no vectors are used at
+		 * all.
 		 */
 		trace_xfs_buf_item_size_ordered(bip);
 		*nvecs = XFS_LOG_VEC_ORDERED;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6764d12342da..5a2dd33020e2 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -28,6 +28,20 @@ static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_inode_log_item, ili_item);
 }
 
+/*
+ * The logged size of an inode fork is always the current size of the inode
+ * fork. This means that when an inode fork is relogged, the size of the logged
+ * region is determined by the current state, not the combination of the
+ * previously logged state + the current state. This is different relogging
+ * behaviour to most other log items which will retain the size of the
+ * previously logged changes when smaller regions are relogged.
+ *
+ * Hence operations that remove data from the inode fork (e.g. shortform
+ * dir/attr remove, extent form extent removal, etc), the size of the relogged
+ * inode gets -smaller- rather than stays the same size as the previously logged
+ * size and this can result in the committing transaction reducing the amount of
+ * space being consumed by the CIL.
+ */
 STATIC void
 xfs_inode_item_data_fork_size(
 	struct xfs_inode_log_item *iip,
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 9d2fa8464289..903617e6d054 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -670,9 +670,14 @@ xlog_cil_push_work(
 	ASSERT(push_seq <= ctx->sequence);
 
 	/*
-	 * Wake up any background push waiters now this context is being pushed.
+	 * As we are about to switch to a new, empty CIL context, we no longer
+	 * need to throttle tasks on CIL space overruns. Wake any waiters that
+	 * the hard push throttle may have caught so they can start committing
+	 * to the new context. The ctx->xc_push_lock provides the serialisation
+	 * necessary for safely using the lockless waitqueue_active() check in
+	 * this context.
 	 */
-	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
+	if (waitqueue_active(&cil->xc_push_wait))
 		wake_up_all(&cil->xc_push_wait);
 
 	/*
@@ -944,7 +949,7 @@ xlog_cil_push_background(
 	ASSERT(!list_empty(&cil->xc_cil));
 
 	/*
-	 * don't do a background push if we haven't used up all the
+	 * Don't do a background push if we haven't used up all the
 	 * space available yet.
 	 */
 	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
@@ -968,9 +973,16 @@ xlog_cil_push_background(
 
 	/*
 	 * If we are well over the space limit, throttle the work that is being
-	 * done until the push work on this context has begun.
+	 * done until the push work on this context has begun. Enforce the hard
+	 * throttle on all transaction commits once it has been activated, even
+	 * if the committing transactions have resulted in the space usage
+	 * dipping back down under the hard limit.
+	 *
+	 * The ctx->xc_push_lock provides the serialisation necessary for safely
+	 * using the lockless waitqueue_active() check in this context.
 	 */
-	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
+	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log) ||
+	    waitqueue_active(&cil->xc_push_wait)) {
 		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
 		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
 		xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
-- 
2.31.1

