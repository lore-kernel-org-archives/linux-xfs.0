Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C2DC4743D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 00:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B01C4613C8
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 00:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhFGATT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 20:19:19 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:35824 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229884AbhFGATS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Jun 2021 20:19:18 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 8D80280BA33;
        Mon,  7 Jun 2021 10:17:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lq2x8-009oOq-9G; Mon, 07 Jun 2021 10:17:14 +1000
Date:   Mon, 7 Jun 2021 10:17:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: introduce CPU hotplug infrastructure
Message-ID: <20210607001714.GY664593@dread.disaster.area>
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
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8
        a=Mj-D7b2SoFQ7hKLnWc8A:9 a=CjuIK1q_8ugA:10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

We need to move to per-cpu state for CIL tracking, but to do that we
need to handle CPUs being removed from the system by the hot-plug
code. Introduce generic XFS infrastructure to handle CPU hotplug
events that is set up at module init time and torn down at module
exit time.

Initially, the CIL only needs CPU dead notifications, so we only set
up a callback for these notifications. The infrastructure can be
updated in future for CPU add notifications easily if every needed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_super.c         | 38 +++++++++++++++++++++++++++++++++++++-
 include/linux/cpuhotplug.h |  1 +
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 017ba9c24c2d..0146d3c89da9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2123,6 +2123,35 @@ xfs_destroy_workqueues(void)
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
@@ -2135,10 +2164,14 @@ init_xfs_fs(void)
 
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
@@ -2218,6 +2251,8 @@ init_xfs_fs(void)
 	xfs_destroy_workqueues();
  out_destroy_zones:
 	xfs_destroy_zones();
+ out_destroy_hp:
+	xfs_cpu_hotplug_destroy();
  out:
 	return error;
 }
@@ -2240,6 +2275,7 @@ exit_xfs_fs(void)
 	xfs_destroy_workqueues();
 	xfs_destroy_zones();
 	xfs_uuid_table_free();
+	xfs_cpu_hotplug_destroy();
 }
 
 module_init(init_xfs_fs);
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 4a62b3980642..bf8f29ad9bf8 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -52,6 +52,7 @@ enum cpuhp_state {
 	CPUHP_FS_BUFF_DEAD,
 	CPUHP_PRINTK_DEAD,
 	CPUHP_MM_MEMCQ_DEAD,
+	CPUHP_XFS_DEAD,
 	CPUHP_PERCPU_CNT_DEAD,
 	CPUHP_RADIX_DEAD,
 	CPUHP_PAGE_ALLOC_DEAD,
