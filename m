Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10703C83F18
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbjH2XHY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241209AbjH2XHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:07:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF95E9
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:07:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A44AB61208
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD79C433CC;
        Tue, 29 Aug 2023 23:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350430;
        bh=C42SfX3Ar/+vINjD3VMRmcooN9DaLNRTFRNdA4UMX1M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R+h+0GfdR16xj8N/1hFQB982uL1uaLU1Vdm7P6AUPgTNnf2TsXN3ChP2UbKj3y/Jc
         GY6rF/8t9UAHpAFI8dxmfDRVuSTaVFOHode++98zegrJ4K01ye8krt1WfsY8feqDXA
         IpCGRND3nD4F1x0hvpmnvTmfsINdg3+uk9tKhbjNnGsCy1GsngDvhI8aNjpx2RD1W4
         zkCs8Sm711HhZPixLs4d/oUbKF3Zl6MSmjf3dc23dq04ZYY1xUxJQut2bor8Ik+qic
         TqSxq7suvt6uxw+/HmD79zMIzcr7tlRYibuuZ3ZrsgHtl93McxwAL+qx6VwygbVFBY
         ZoJWD2xwzMkWw==
Subject: [PATCH 4/4] xfs: remove CPU hotplug infrastructure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@gmail.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, ritesh.list@gmail.com, sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:07:09 -0700
Message-ID: <169335042956.3522698.8141336600262838509.stgit@frogsfrogsfrogs>
In-Reply-To: <169335040678.3522698.12786707653439539265.stgit@frogsfrogsfrogs>
References: <169335040678.3522698.12786707653439539265.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are no users of the cpu hotplug hooks in xfs now, so remove it.
This reverts f1653c2e2831e ("xfs: introduce CPU hotplug
infrastructure").

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_super.c         |   42 +-----------------------------------------
 include/linux/cpuhotplug.h |    1 -
 2 files changed, 1 insertion(+), 42 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index be87584c635b..abd99adece3a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2270,39 +2270,6 @@ xfs_destroy_workqueues(void)
 	destroy_workqueue(xfs_alloc_wq);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-static int
-xfs_cpu_dead(
-	unsigned int		cpu)
-{
-	return 0;
-}
-
-static int __init
-xfs_cpu_hotplug_init(void)
-{
-	int	error;
-
-	error = cpuhp_setup_state_nocalls(CPUHP_XFS_DEAD, "xfs:dead", NULL,
-			xfs_cpu_dead);
-	if (error < 0)
-		xfs_alert(NULL,
-"Failed to initialise CPU hotplug, error %d. XFS is non-functional.",
-			error);
-	return error;
-}
-
-static void
-xfs_cpu_hotplug_destroy(void)
-{
-	cpuhp_remove_state_nocalls(CPUHP_XFS_DEAD);
-}
-
-#else /* !CONFIG_HOTPLUG_CPU */
-static inline int xfs_cpu_hotplug_init(void) { return 0; }
-static inline void xfs_cpu_hotplug_destroy(void) {}
-#endif
-
 STATIC int __init
 init_xfs_fs(void)
 {
@@ -2319,13 +2286,9 @@ init_xfs_fs(void)
 
 	xfs_dir_startup();
 
-	error = xfs_cpu_hotplug_init();
-	if (error)
-		goto out;
-
 	error = xfs_init_caches();
 	if (error)
-		goto out_destroy_hp;
+		goto out;
 
 	error = xfs_init_workqueues();
 	if (error)
@@ -2409,8 +2372,6 @@ init_xfs_fs(void)
 	xfs_destroy_workqueues();
  out_destroy_caches:
 	xfs_destroy_caches();
- out_destroy_hp:
-	xfs_cpu_hotplug_destroy();
  out:
 	return error;
 }
@@ -2434,7 +2395,6 @@ exit_xfs_fs(void)
 	xfs_destroy_workqueues();
 	xfs_destroy_caches();
 	xfs_uuid_table_free();
-	xfs_cpu_hotplug_destroy();
 }
 
 module_init(init_xfs_fs);
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 25b6e6e6ba6b..a93e539efd85 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -90,7 +90,6 @@ enum cpuhp_state {
 	CPUHP_FS_BUFF_DEAD,
 	CPUHP_PRINTK_DEAD,
 	CPUHP_MM_MEMCQ_DEAD,
-	CPUHP_XFS_DEAD,
 	CPUHP_PERCPU_CNT_DEAD,
 	CPUHP_RADIX_DEAD,
 	CPUHP_PAGE_ALLOC,

