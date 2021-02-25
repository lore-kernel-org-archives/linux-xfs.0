Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554C4C43381
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 03:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D7C364EDC
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 03:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbhBYDiN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 22:38:13 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58522 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232984AbhBYDiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 22:38:09 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 1EF081AD7FA
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 14:37:27 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-0038Aj-Cw
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-00EvjH-5S
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/12] xfs: introduce per-cpu CIL tracking sructure
Date:   Thu, 25 Feb 2021 14:37:17 +1100
Message-Id: <20210225033725.3558450-5-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210225033725.3558450-1-david@fromorbit.com>
References: <20210225033725.3558450-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=Eqg3tRyrYyYRg9lh8iMA:9
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
---
 fs/xfs/xfs_log_cil.c       | 94 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_priv.h      | 15 ++++++
 include/linux/cpuhotplug.h |  1 +
 3 files changed, 110 insertions(+)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index ecd2f085e572..06aca398f560 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1360,6 +1360,93 @@ xfs_log_item_in_current_chkpt(
 	return true;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static LIST_HEAD(xlog_cil_pcp_list);
+static DEFINE_SPINLOCK(xlog_cil_pcp_lock);
+static bool xlog_cil_pcp_init;
+
+static int
+xlog_cil_pcp_dead(
+	unsigned int		cpu)
+{
+	struct xfs_cil		*cil;
+
+        spin_lock(&xlog_cil_pcp_lock);
+        list_for_each_entry(cil, &xlog_cil_pcp_list, xc_pcp_list) {
+		/* move stuff on dead CPU to context */
+	}
+	spin_unlock(&xlog_cil_pcp_lock);
+	return 0;
+}
+
+static int
+xlog_cil_pcp_hpadd(
+	struct xfs_cil		*cil)
+{
+	if (!xlog_cil_pcp_init) {
+		int	ret;
+		ret = cpuhp_setup_state_nocalls(CPUHP_XFS_CIL_DEAD,
+						"xfs/cil_pcp:dead", NULL,
+						xlog_cil_pcp_dead);
+		if (ret < 0) {
+			xfs_warn(cil->xc_log->l_mp,
+	"Failed to initialise CIL hotplug, error %d. XFS is non-functional.",
+				ret);
+			ASSERT(0);
+			return -ENOMEM;
+		}
+		xlog_cil_pcp_init = true;
+	}
+
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
+static inline void xlog_cil_pcp_hpadd(struct xfs_cil *cil) {}
+static inline void xlog_cil_pcp_hpremove(struct xfs_cil *cil) {}
+#endif
+
+static void __percpu *
+xlog_cil_pcp_alloc(
+	struct xfs_cil		*cil)
+{
+	struct xlog_cil_pcp	*cilpcp;
+
+	cilpcp = alloc_percpu(struct xlog_cil_pcp);
+	if (!cilpcp)
+		return NULL;
+
+	if (xlog_cil_pcp_hpadd(cil) < 0) {
+		free_percpu(cilpcp);
+		return NULL;
+	}
+	return cilpcp;
+}
+
+static void
+xlog_cil_pcp_free(
+	struct xfs_cil		*cil,
+	struct xlog_cil_pcp	*cilpcp)
+{
+	if (!cilpcp)
+		return;
+	xlog_cil_pcp_hpremove(cil);
+	free_percpu(cilpcp);
+}
+
 /*
  * Perform initial CIL structure initialisation.
  */
@@ -1374,6 +1461,12 @@ xlog_cil_init(
 	if (!cil)
 		return -ENOMEM;
 
+	cil->xc_pcp = xlog_cil_pcp_alloc(cil);
+	if (!cil->xc_pcp) {
+		kmem_free(cil);
+		return -ENOMEM;
+	}
+
 	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
@@ -1404,6 +1497,7 @@ xlog_cil_destroy(
 
 	ASSERT(list_empty(&cil->xc_cil));
 	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
+	xlog_cil_pcp_free(cil, cil->xc_pcp);
 	kmem_free(cil);
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 7852a60e8f86..fbf2a665c62a 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -231,6 +231,16 @@ struct xfs_cil_ctx {
 	struct work_struct	push_work;
 };
 
+/*
+ * Per-cpu CIL tracking items
+ */
+struct xlog_cil_pcp {
+	uint32_t		space_used;
+	uint32_t		curr_res;
+	struct list_head	busy_extents;
+	struct list_head	log_items;
+};
+
 /*
  * Committed Item List structure
  *
@@ -264,6 +274,11 @@ struct xfs_cil {
 	wait_queue_head_t	xc_commit_wait;
 	uint64_t		xc_current_sequence;
 	wait_queue_head_t	xc_push_wait;	/* background push throttle */
+
+	struct xlog_cil_pcp __percpu *xc_pcp;
+#ifdef CONFIG_HOTPLUG_CPU
+	struct list_head	xc_pcp_list;
+#endif
 } ____cacheline_aligned_in_smp;
 
 /* xc_flags bit values */
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 0042ef362511..22813626787f 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -52,6 +52,7 @@ enum cpuhp_state {
 	CPUHP_FS_BUFF_DEAD,
 	CPUHP_PRINTK_DEAD,
 	CPUHP_MM_MEMCQ_DEAD,
+	CPUHP_XFS_CIL_DEAD,
 	CPUHP_PERCPU_CNT_DEAD,
 	CPUHP_RADIX_DEAD,
 	CPUHP_PAGE_ALLOC_DEAD,
-- 
2.28.0

