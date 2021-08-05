Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4934C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C583B610A8
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbhHECGm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 22:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238097AbhHECGm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 22:06:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8FD861078;
        Thu,  5 Aug 2021 02:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129188;
        bh=VLFpk4zylAMVmJNNSAI/xxu6QcCGmQ1DxdkE6UBjwaw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g2XKuLVgDCm+xD96P44NOyni8Whn6nz4EEDxg+OHgMFotbReJhpa1bCf69eKg4c7S
         CLRdpHfbscpRISmVsLhZLgtkpA44Kb61hQkGzbyysgmABGbOBUoK1uhICO9XsD2koq
         243K0kSdfTRZ0LtePmfAoAqOnUMbZPjGq9CvNu17/hH2qF2/4wLeFKCxyBo0Nl/B1r
         aLTeVdGYbQRysew+IGcNsOtavvLkiGEEuZiQNE8QhYT6S9QqcSjkCQT+1TWR6H6CI1
         0pj5wurT7F0nWxStJtUElv9fRK5Ebg1ZEdRzCRU3x9XvXd83AGuXLSe8OHWypPGS3b
         yvXfSgKrbORtQ==
Subject: [PATCH 01/14] xfs: introduce CPU hotplug infrastructure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Wed, 04 Aug 2021 19:06:28 -0700
Message-ID: <162812918845.2589546.15622040798744698014.stgit@magnolia>
In-Reply-To: <162812918259.2589546.16599271324044986858.stgit@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
[djwong: rearrange some macros, fix function prototypes]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c         |   42 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/cpuhotplug.h |    1 +
 2 files changed, 42 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 36fc81e52dc2..d47fac7c8afd 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2111,6 +2111,39 @@ xfs_destroy_workqueues(void)
 	destroy_workqueue(xfs_alloc_wq);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
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
+	error = cpuhp_setup_state_nocalls(CPUHP_XFS_DEAD, "xfs:dead", NULL,
+			xfs_cpu_dead);
+	if (error < 0)
+		xfs_alert(NULL,
+"Failed to initialise CPU hotplug, error %d. XFS is non-functional.",
+			error);
+	return error;
+}
+
+static void
+xfs_cpu_hotplug_destroy(void)
+{
+	cpuhp_remove_state_nocalls(CPUHP_XFS_DEAD);
+}
+
+#else /* !CONFIG_HOTPLUG_CPU */
+static inline int xfs_cpu_hotplug_init(void) { return 0; }
+static inline void xfs_cpu_hotplug_destroy(void) {}
+#endif
+
 STATIC int __init
 init_xfs_fs(void)
 {
@@ -2123,9 +2156,13 @@ init_xfs_fs(void)
 
 	xfs_dir_startup();
 
+	error = xfs_cpu_hotplug_init();
+	if (error)
+		goto out;
+
 	error = xfs_init_zones();
 	if (error)
-		goto out;
+		goto out_destroy_hp;
 
 	error = xfs_init_workqueues();
 	if (error)
@@ -2206,6 +2243,8 @@ init_xfs_fs(void)
 	xfs_destroy_workqueues();
  out_destroy_zones:
 	xfs_destroy_zones();
+ out_destroy_hp:
+	xfs_cpu_hotplug_destroy();
  out:
 	return error;
 }
@@ -2228,6 +2267,7 @@ exit_xfs_fs(void)
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

