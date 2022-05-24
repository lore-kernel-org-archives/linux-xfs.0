Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A760CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 06:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiEXGiK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 02:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiEXGiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 02:38:09 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8602595DDE
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 23:38:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BB7365345EA;
        Tue, 24 May 2022 16:38:06 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntOBA-00FjS5-Qj; Tue, 24 May 2022 16:38:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ntOBA-0088W8-Pj;
        Tue, 24 May 2022 16:38:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     chris@onthe.net.au
Subject: [PATCH 2/2] xfs: introduce xfs_inodegc_push()
Date:   Tue, 24 May 2022 16:38:02 +1000
Message-Id: <20220524063802.1938505-3-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524063802.1938505-1-david@fromorbit.com>
References: <20220524063802.1938505-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=628c7d4e
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=N8xf_ed3AAAA:8
        a=KfyTXh2ViG2rkT9xil4A:9 a=sE4t997d3Q9FUvws1cBB:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The current blocking mechanism for pushing the inodegc queue out to
disk can result in systems becoming unusable when there is a long
running inodegc operation. This is because the statfs()
implementation currently issues a blocking flush of the inodegc
queue and a significant number of common system utilities will call
statfs() to discover something about the underlying filesystem.

This can result in userspace operations getting stuck on inodegc
progress, and when trying to remove a heavily reflinked file on slow
storage with a full journal, this can result in delays measuring in
hours.

Avoid this problem by adding "push" function that expedites the
flushing of the inodegc queue, but doesn't wait for it to complete.

Convert xfs_fs_statfs() to use this mechanism so it doesn't block
but it does ensure that queued operations are expedited.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Reported-by: Chris Dunlop <chris@onthe.net.au>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 20 +++++++++++++++-----
 fs/xfs/xfs_icache.h |  1 +
 fs/xfs/xfs_super.c  |  7 +++++--
 fs/xfs/xfs_trace.h  |  1 +
 4 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 786702273621..2609825d53ee 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1862,19 +1862,29 @@ xfs_inodegc_worker(
 }
 
 /*
- * Force all currently queued inode inactivation work to run immediately and
- * wait for the work to finish.
+ * Expedite all pending inodegc work to run immediately. This does not wait for
+ * completion of the work.
  */
 void
-xfs_inodegc_flush(
+xfs_inodegc_push(
 	struct xfs_mount	*mp)
 {
 	if (!xfs_is_inodegc_enabled(mp))
 		return;
+	trace_xfs_inodegc_push(mp, __return_address);
+	xfs_inodegc_queue_all(mp);
+}
 
+/*
+ * Force all currently queued inode inactivation work to run immediately and
+ * wait for the work to finish.
+ */
+void
+xfs_inodegc_flush(
+	struct xfs_mount	*mp)
+{
+	xfs_inodegc_push(mp);
 	trace_xfs_inodegc_flush(mp, __return_address);
-
-	xfs_inodegc_queue_all(mp);
 	flush_workqueue(mp->m_inodegc_wq);
 }
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 2e4cfddf8b8e..6cd180721659 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -76,6 +76,7 @@ void xfs_blockgc_stop(struct xfs_mount *mp);
 void xfs_blockgc_start(struct xfs_mount *mp);
 
 void xfs_inodegc_worker(struct work_struct *work);
+void xfs_inodegc_push(struct xfs_mount *mp);
 void xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 62f6b97355a2..e14101813851 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -796,8 +796,11 @@ xfs_fs_statfs(
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
-	/* Wait for whatever inactivations are in progress. */
-	xfs_inodegc_flush(mp);
+	/*
+	 * Expedite background inodegc but don't wait. We do not want to block
+	 * here waiting hours for a billion extent file to be truncated.
+	 */
+	xfs_inodegc_push(mp);
 
 	statp->f_type = XFS_SUPER_MAGIC;
 	statp->f_namelen = MAXNAMELEN - 1;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d32026585c1b..0fa1b7a2918c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -240,6 +240,7 @@ DEFINE_EVENT(xfs_fs_class, name,					\
 	TP_PROTO(struct xfs_mount *mp, void *caller_ip), \
 	TP_ARGS(mp, caller_ip))
 DEFINE_FS_EVENT(xfs_inodegc_flush);
+DEFINE_FS_EVENT(xfs_inodegc_push);
 DEFINE_FS_EVENT(xfs_inodegc_start);
 DEFINE_FS_EVENT(xfs_inodegc_stop);
 DEFINE_FS_EVENT(xfs_inodegc_queue);
-- 
2.35.1

