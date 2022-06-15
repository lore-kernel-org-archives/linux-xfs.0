Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BD0CCA47F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 07:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244082AbiFOHxl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245355AbiFOHxh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 03:53:37 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73EDF4161F
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 00:53:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1014D5ECAAB
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 17:53:33 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-006rR8-KZ
        for linux-xfs@vger.kernel.org; Wed, 15 Jun 2022 17:53:32 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-00FJxk-JU
        for linux-xfs@vger.kernel.org;
        Wed, 15 Jun 2022 17:53:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/14] xfs: introduce per-cpu CIL tracking structure
Date:   Wed, 15 Jun 2022 17:53:20 +1000
Message-Id: <20220615075330.3651541-5-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615075330.3651541-1-david@fromorbit.com>
References: <20220615075330.3651541-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a98ffe
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=3WjegZqcOLNj38eB_csA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The CIL push lock is highly contended on larger machines, becoming a
hard bottleneck that about 700,000 transaction commits/s on >16p
machines. To address this, start moving the CIL tracking
infrastructure to utilise per-CPU structures.

We need to track the space used, the amount of log reservation space
reserved to write the CIL, the log items in the CIL and the busy
extents that need to be completed by the CIL commit.  This requires
a couple of per-cpu counters, an unordered per-cpu list and a
globally ordered per-cpu list.

Create a per-cpu structure to hold these and all the management
interfaces needed, as well as the hooks to handle hotplug CPUs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c  | 30 ++++++++++++++++++++++++++++--
 fs/xfs/xfs_log_priv.h | 18 ++++++++++++++++++
 fs/xfs/xfs_super.c    |  1 +
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 880ea9536f82..c6d6322aabaa 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1617,6 +1617,26 @@ xlog_cil_force_seq(
 	return 0;
 }
 
+/*
+ * Move dead percpu state to the relevant CIL context structures.
+ *
+ * We have to lock the CIL context here to ensure that nothing is modifying
+ * the percpu state, either addition or removal. Both of these are done under
+ * the CIL context lock, so grabbing that exclusively here will ensure we can
+ * safely drain the cilpcp for the CPU that is dying.
+ */
+void
+xlog_cil_pcp_dead(
+	struct xlog		*log,
+	unsigned int		cpu)
+{
+	struct xfs_cil		*cil = log->l_cilp;
+
+	down_write(&cil->xc_ctx_lock);
+	/* move stuff on dead CPU to context */
+	up_write(&cil->xc_ctx_lock);
+}
+
 /*
  * Perform initial CIL structure initialisation.
  */
@@ -1640,6 +1660,11 @@ xlog_cil_init(
 	if (!cil->xc_push_wq)
 		goto out_destroy_cil;
 
+	cil->xc_log = log;
+	cil->xc_pcp = alloc_percpu(struct xlog_cil_pcp);
+	if (!cil->xc_pcp)
+		goto out_destroy_wq;
+
 	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
@@ -1648,14 +1673,14 @@ xlog_cil_init(
 	init_rwsem(&cil->xc_ctx_lock);
 	init_waitqueue_head(&cil->xc_start_wait);
 	init_waitqueue_head(&cil->xc_commit_wait);
-	cil->xc_log = log;
 	log->l_cilp = cil;
 
 	ctx = xlog_cil_ctx_alloc();
 	xlog_cil_ctx_switch(cil, ctx);
-
 	return 0;
 
+out_destroy_wq:
+	destroy_workqueue(cil->xc_push_wq);
 out_destroy_cil:
 	kmem_free(cil);
 	return -ENOMEM;
@@ -1675,6 +1700,7 @@ xlog_cil_destroy(
 
 	ASSERT(list_empty(&cil->xc_cil));
 	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
+	free_percpu(cil->xc_pcp);
 	destroy_workqueue(cil->xc_push_wq);
 	kmem_free(cil);
 }
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 74436482c28d..70483c78953e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -231,6 +231,14 @@ struct xfs_cil_ctx {
 	struct work_struct	push_work;
 };
 
+/*
+ * Per-cpu CIL tracking items
+ */
+struct xlog_cil_pcp {
+	struct list_head	busy_extents;
+	struct list_head	log_items;
+};
+
 /*
  * Committed Item List structure
  *
@@ -266,6 +274,11 @@ struct xfs_cil {
 	wait_queue_head_t	xc_start_wait;
 	xfs_csn_t		xc_current_sequence;
 	wait_queue_head_t	xc_push_wait;	/* background push throttle */
+
+	void __percpu		*xc_pcp;	/* percpu CIL structures */
+#ifdef CONFIG_HOTPLUG_CPU
+	struct list_head	xc_pcp_list;
+#endif
 } ____cacheline_aligned_in_smp;
 
 /* xc_flags bit values */
@@ -688,4 +701,9 @@ xlog_kvmalloc(
 	return p;
 }
 
+/*
+ * CIL CPU dead notifier
+ */
+void xlog_cil_pcp_dead(struct xlog *log, unsigned int cpu);
+
 #endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ed18160e6181..14ba690a2fcb 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2210,6 +2210,7 @@ xfs_cpu_dead(
 	list_for_each_entry_safe(mp, n, &xfs_mount_list, m_mount_list) {
 		spin_unlock(&xfs_mount_list_lock);
 		xfs_inodegc_cpu_dead(mp, cpu);
+		xlog_cil_pcp_dead(mp->m_log, cpu);
 		spin_lock(&xfs_mount_list_lock);
 	}
 	spin_unlock(&xfs_mount_list_lock);
-- 
2.35.1

