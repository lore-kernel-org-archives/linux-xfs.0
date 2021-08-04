Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80CAC4338F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 11:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E9B060F6F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 11:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbhHDLvF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 07:51:05 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46024 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237838AbhHDLvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Aug 2021 07:51:05 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 928771047327;
        Wed,  4 Aug 2021 21:50:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBFQB-00EP4l-1M; Wed, 04 Aug 2021 21:50:51 +1000
Date:   Wed, 4 Aug 2021 21:50:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: [PATCH, pre-03/20 #2] xfs: introduce all-mounts list for cpu hotplug
 notifications
Message-ID: <20210804115051.GO2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
 <20210804032030.GT3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804032030.GT3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8
        a=xJxOfhYdeRJlWLVnhP0A:9 a=CjuIK1q_8ugA:10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

The inode inactivation and CIL tracking percpu structures are
per-xfs_mount structures. That means when we get a CPU dead
notification, we need to then iterate all the per-cpu structure
instances to process them. Rather than keeping linked lists of
per-cpu structures in each subsystem, add a list of all xfs_mounts
that the generic xfs_cpu_dead() function will iterate and call into
each subsystem appropriately.

This allows us to handle both per-mount and global XFS percpu state
from xfs_cpu_dead(), and avoids the need to link subsystem
structures that can be easily found from the xfs_mount into their
own global lists.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_super.c | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c78b63fe779a..ed7064596f94 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -82,6 +82,7 @@ typedef struct xfs_mount {
 	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
 	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
 	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
+	struct list_head	m_mount_list;	/* global mount list */
 	/*
 	 * Optional cache of rt summary level per bitmap block with the
 	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ffe1ecd048db..c27df85212d4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -49,6 +49,28 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
 static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 #endif
 
+#ifdef CONFIG_HOTPLUG_CPU
+static LIST_HEAD(xfs_mount_list);
+static DEFINE_SPINLOCK(xfs_mount_list_lock);
+
+static inline void xfs_mount_list_add(struct xfs_mount *mp)
+{
+	spin_lock(&xfs_mount_list_lock);
+	list_add(&mp->m_mount_list, &xfs_mount_list);
+	spin_unlock(&xfs_mount_list_lock);
+}
+
+static inline void xfs_mount_list_del(struct xfs_mount *mp)
+{
+	spin_lock(&xfs_mount_list_lock);
+	list_del(&mp->m_mount_list);
+	spin_unlock(&xfs_mount_list_lock);
+}
+#else /* !CONFIG_HOTPLUG_CPU */
+static inline void xfs_mount_list_add(struct xfs_mount *mp) {}
+static inline void xfs_mount_list_del(struct xfs_mount *mp) {}
+#endif
+
 enum xfs_dax_mode {
 	XFS_DAX_INODE = 0,
 	XFS_DAX_ALWAYS = 1,
@@ -988,6 +1010,7 @@ xfs_fs_put_super(
 
 	xfs_freesb(mp);
 	free_percpu(mp->m_stats.xs_stats);
+	xfs_mount_list_del(mp);
 	xfs_destroy_percpu_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
@@ -1359,6 +1382,8 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_destroy_workqueues;
 
+	xfs_mount_list_add(mp);
+
 	/* Allocate stats memory before we do operations that might use it */
 	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
 	if (!mp->m_stats.xs_stats) {
@@ -1567,6 +1592,7 @@ xfs_fs_fill_super(
  out_free_stats:
 	free_percpu(mp->m_stats.xs_stats);
  out_destroy_counters:
+	xfs_mount_list_del(mp);
 	xfs_destroy_percpu_counters(mp);
  out_destroy_workqueues:
 	xfs_destroy_mount_workqueues(mp);
@@ -2061,10 +2087,20 @@ xfs_destroy_workqueues(void)
 	destroy_workqueue(xfs_alloc_wq);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
 static int
 xfs_cpu_dead(
 	unsigned int		cpu)
 {
+	struct xfs_mount	*mp, *n;
+
+	spin_lock(&xfs_mount_list_lock);
+	list_for_each_entry_safe(mp, n, &xfs_mount_list, m_mount_list) {
+		spin_unlock(&xfs_mount_list_lock);
+		/* xfs_subsys_dead(mp, cpu); */
+		spin_lock(&xfs_mount_list_lock);
+	}
+	spin_unlock(&xfs_mount_list_lock);
 	return 0;
 }
 
@@ -2090,6 +2126,11 @@ xfs_cpu_hotplug_destroy(void)
 	cpuhp_remove_state_nocalls(CPUHP_XFS_DEAD);
 }
 
+#else /* !CONFIG_HOTPLUG_CPU */
+static inline int xfs_cpu_hotplug_init(struct xfs_cil *cil) { return 0; }
+static inline void xfs_cpu_hotplug_destroy(struct xfs_cil *cil) {}
+#endif
+
 STATIC int __init
 init_xfs_fs(void)
 {
