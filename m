Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA066C4338F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 11:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 801ED60F35
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 11:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbhHDLtm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 07:49:42 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:51154 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237816AbhHDLtm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Aug 2021 07:49:42 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 9A9EF1B3028;
        Wed,  4 Aug 2021 21:49:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBFOq-00EP3t-0J; Wed, 04 Aug 2021 21:49:28 +1000
Date:   Wed, 4 Aug 2021 21:49:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: [PATCH, pre-03/20 #1] xfs: introduce CPU hotplug infrastructure
Message-ID: <20210804114927.GN2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
 <20210804032030.GT3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804032030.GT3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=Mj-D7b2SoFQ7hKLnWc8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We need to move to per-cpu state for both deferred inode
inactivation and CIL tracking, but to do that we
need to handle CPUs being removed from the system by the hot-plug
code. Introduce generic XFS infrastructure to handle CPU hotplug
events that is set up at module init time and torn down at module
exit time.

Initially, we only need CPU dead notifications, so we only set
up a callback for these notifications. The infrastructure can be
updated in future for other CPU hotplug state machine notifications
easily if ever needed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c         | 38 +++++++++++++++++++++++++++++++++++++-
 include/linux/cpuhotplug.h |  1 +
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8b7a9895b4a2..5232c808287b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2111,6 +2111,35 @@ xfs_destroy_workqueues(void)
 	destroy_workqueue(xfs_alloc_wq);
 }
 
+static int
+xfs_cpu_dead(
+	unsigned int		cpu)
+{
+	return 0;
+}
+
+static int __init
+xfs_cpu_hotplug_init(void)
+{
+	int	error;
+
+	error = cpuhp_setup_state_nocalls(CPUHP_XFS_DEAD,
+					"xfs:dead", NULL,
+					xfs_cpu_dead);
+	if (error < 0) {
+		xfs_alert(NULL,
+"Failed to initialise CPU hotplug, error %d. XFS is non-functional.",
+			error);
+	}
+	return error;
+}
+
+static void
+xfs_cpu_hotplug_destroy(void)
+{
+	cpuhp_remove_state_nocalls(CPUHP_XFS_DEAD);
+}
+
 STATIC int __init
 init_xfs_fs(void)
 {
@@ -2123,10 +2152,14 @@ init_xfs_fs(void)
 
 	xfs_dir_startup();
 
-	error = xfs_init_zones();
+	error = xfs_cpu_hotplug_init();
 	if (error)
 		goto out;
 
+	error = xfs_init_zones();
+	if (error)
+		goto out_destroy_hp;
+
 	error = xfs_init_workqueues();
 	if (error)
 		goto out_destroy_zones;
@@ -2206,6 +2239,8 @@ init_xfs_fs(void)
 	xfs_destroy_workqueues();
  out_destroy_zones:
 	xfs_destroy_zones();
+ out_destroy_hp:
+	xfs_cpu_hotplug_destroy();
  out:
 	return error;
 }
@@ -2228,6 +2263,7 @@ exit_xfs_fs(void)
 	xfs_destroy_workqueues();
 	xfs_destroy_zones();
 	xfs_uuid_table_free();
+	xfs_cpu_hotplug_destroy();
 }
 
 module_init(init_xfs_fs);
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index f39b34b13871..439adc05be4e 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -52,6 +52,7 @@ enum cpuhp_state {
 	CPUHP_FS_BUFF_DEAD,
 	CPUHP_PRINTK_DEAD,
 	CPUHP_MM_MEMCQ_DEAD,
+	CPUHP_XFS_DEAD,
 	CPUHP_PERCPU_CNT_DEAD,
 	CPUHP_RADIX_DEAD,
 	CPUHP_PAGE_ALLOC,
