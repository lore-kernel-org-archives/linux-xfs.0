Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F94C4743D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 00:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C12C613C8
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 00:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhFGAUC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 20:20:02 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:37909 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229884AbhFGAUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Jun 2021 20:20:02 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 1BEC110A30A;
        Mon,  7 Jun 2021 10:18:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lq2y2-009oPe-I3; Mon, 07 Jun 2021 10:18:10 +1000
Date:   Mon, 7 Jun 2021 10:18:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: introduce per-cpu CIL tracking structure
Message-ID: <20210607001810.GZ664593@dread.disaster.area>
References: <20210604032928.GU664593@dread.disaster.area>
 <20210605020354.GG26380@locust>
 <20210605021533.GH26380@locust>
 <20210606221119.GW664593@dread.disaster.area>
 <20210607000040.GX664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607000040.GX664593@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=9MaauiQBOaKaXzZtPfwA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
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
 fs/xfs/xfs_log_cil.c  | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_log_priv.h | 22 +++++++++++++
 fs/xfs/xfs_super.c    |  1 +
 3 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 738dc4248113..3cdfa17e4a1b 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1369,6 +1369,88 @@ xfs_log_item_in_current_chkpt(
 	return lip->li_seq == cil->xc_ctx->sequence;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static LIST_HEAD(xlog_cil_pcp_list);
+static DEFINE_SPINLOCK(xlog_cil_pcp_lock);
+
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
+	unsigned int		cpu)
+{
+	struct xfs_cil		*cil, *n;
+
+	spin_lock(&xlog_cil_pcp_lock);
+	list_for_each_entry_safe(cil, n, &xlog_cil_pcp_list, xc_pcp_list) {
+		spin_unlock(&xlog_cil_pcp_lock);
+		down_write(&cil->xc_ctx_lock);
+		/* move stuff on dead CPU to context */
+		up_write(&cil->xc_ctx_lock);
+		spin_lock(&xlog_cil_pcp_lock);
+	}
+	spin_unlock(&xlog_cil_pcp_lock);
+}
+
+static int
+xlog_cil_pcp_hpadd(
+	struct xfs_cil		*cil)
+{
+	INIT_LIST_HEAD(&cil->xc_pcp_list);
+	spin_lock(&xlog_cil_pcp_lock);
+	list_add(&cil->xc_pcp_list, &xlog_cil_pcp_list);
+	spin_unlock(&xlog_cil_pcp_lock);
+	return 0;
+}
+
+static void
+xlog_cil_pcp_hpremove(
+	struct xfs_cil		*cil)
+{
+	spin_lock(&xlog_cil_pcp_lock);
+	list_del(&cil->xc_pcp_list);
+	spin_unlock(&xlog_cil_pcp_lock);
+}
+
+#else /* !CONFIG_HOTPLUG_CPU */
+static inline int xlog_cil_pcp_hpadd(struct xfs_cil *cil) { return 0; }
+static inline void xlog_cil_pcp_hpremove(struct xfs_cil *cil) {}
+#endif
+
+static void __percpu *
+xlog_cil_pcp_alloc(
+	struct xfs_cil		*cil)
+{
+	void __percpu		*pcp;
+
+	pcp = alloc_percpu(struct xlog_cil_pcp);
+	if (!pcp)
+		return NULL;
+
+	if (xlog_cil_pcp_hpadd(cil) < 0) {
+		free_percpu(pcp);
+		return NULL;
+	}
+	return pcp;
+}
+
+static void
+xlog_cil_pcp_free(
+	struct xfs_cil		*cil,
+	void __percpu		*pcp)
+{
+	if (!pcp)
+		return;
+	xlog_cil_pcp_hpremove(cil);
+	free_percpu(pcp);
+}
+
 /*
  * Perform initial CIL structure initialisation.
  */
@@ -1383,6 +1465,13 @@ xlog_cil_init(
 	if (!cil)
 		return -ENOMEM;
 
+	cil->xc_log = log;
+	cil->xc_pcp = xlog_cil_pcp_alloc(cil);
+	if (!cil->xc_pcp) {
+		kmem_free(cil);
+		return -ENOMEM;
+	}
+
 	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
@@ -1390,7 +1479,6 @@ xlog_cil_init(
 	init_waitqueue_head(&cil->xc_push_wait);
 	init_rwsem(&cil->xc_ctx_lock);
 	init_waitqueue_head(&cil->xc_commit_wait);
-	cil->xc_log = log;
 	log->l_cilp = cil;
 
 	ctx = xlog_cil_ctx_alloc();
@@ -1413,6 +1501,7 @@ xlog_cil_destroy(
 
 	ASSERT(list_empty(&cil->xc_cil));
 	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
+	xlog_cil_pcp_free(cil, cil->xc_pcp);
 	kmem_free(cil);
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 85a85ab569fe..5b6a24b8b3c5 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -227,6 +227,14 @@ struct xfs_cil_ctx {
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
@@ -260,6 +268,11 @@ struct xfs_cil {
 	wait_queue_head_t	xc_commit_wait;
 	xfs_csn_t		xc_current_sequence;
 	wait_queue_head_t	xc_push_wait;	/* background push throttle */
+
+	void __percpu		*xc_pcp;	/* percpu CIL structures */
+#ifdef CONFIG_HOTPLUG_CPU
+	struct list_head	xc_pcp_list;
+#endif
 } ____cacheline_aligned_in_smp;
 
 /* xc_flags bit values */
@@ -625,4 +638,13 @@ xlog_valid_lsn(
 	return valid;
 }
 
+/*
+ * CIL CPU dead notifier
+ */
+#ifdef CONFIG_HOTPLUG_CPU
+void xlog_cil_pcp_dead(unsigned int cpu);
+#else
+static inline void xlog_cil_pcp_dead(unsigned int cpu) {}
+#endif /* CONFIG_HOTPLUG_CPU */
+
 #endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0146d3c89da9..6afa69a430bb 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2127,6 +2127,7 @@ static int
 xfs_cpu_dead(
 	unsigned int		cpu)
 {
+	xlog_cil_pcp_dead(cpu);
 	return 0;
 }
 
