Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B4BEE49B2
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244032AbjHXXVs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244047AbjHXXVf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:21:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278A0A1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B896665314
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 23:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2A7C433CA;
        Thu, 24 Aug 2023 23:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692919292;
        bh=NunsRwNBvtOwveTZLVwp4JEX6aTnUcPmwM0/kW/V7g8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=idqWvC0sOnXCrJdNrauquYt6rig17hAvnqKlnp6VqxvWbtt6i9IDP4lR614VFK5El
         /1xxkNkkfArho9Cmj5wJAJ5/OyZmeUIjgvh4lUBBb9GRs+9akyT0+H+7u2qKgdqyj6
         BWsxNHPPHkINaR3BpE+uBLOxPANruUfYIsjZO1k3/eCO1i97P3T2m67kVjlHqt2xBC
         f0hhhhX+AQ8qfrD5rhChf+97chSZEHtqjnG21NL12wVc9jrpUCrLHdurGrYhXgTF+x
         DHubUg8m0X6RpwcQ+TljzFzVNRNgq/VvWq2eOKR0y/e7ABF7b5OyJhAsGDamT9oPIV
         RXSA8NmcdKBng==
Subject: [PATCH 3/3] xfs: remove cpu hotplug hooks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        ritesh.list@gmail.com, sandeen@sandeen.net
Date:   Thu, 24 Aug 2023 16:21:31 -0700
Message-ID: <169291929160.219974.11113805270455831702.stgit@frogsfrogsfrogs>
In-Reply-To: <169291927442.219974.9654062191833512358.stgit@frogsfrogsfrogs>
References: <169291927442.219974.9654062191833512358.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are no users of the cpu hotplug hooks in xfs now, so remove the
infrastructure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c         |   50 +-------------------------------------------
 include/linux/cpuhotplug.h |    1 -
 2 files changed, 1 insertion(+), 50 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6a4f8b2f6159..1403aace4fe3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2301,47 +2301,6 @@ xfs_destroy_workqueues(void)
 	destroy_workqueue(xfs_alloc_wq);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-static int
-xfs_cpu_dead(
-	unsigned int		cpu)
-{
-	struct xfs_mount	*mp, *n;
-
-	spin_lock(&xfs_mount_list_lock);
-	list_for_each_entry_safe(mp, n, &xfs_mount_list, m_mount_list) {
-		spin_unlock(&xfs_mount_list_lock);
-		spin_lock(&xfs_mount_list_lock);
-	}
-	spin_unlock(&xfs_mount_list_lock);
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
@@ -2358,13 +2317,9 @@ init_xfs_fs(void)
 
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
@@ -2448,8 +2403,6 @@ init_xfs_fs(void)
 	xfs_destroy_workqueues();
  out_destroy_caches:
 	xfs_destroy_caches();
- out_destroy_hp:
-	xfs_cpu_hotplug_destroy();
  out:
 	return error;
 }
@@ -2473,7 +2426,6 @@ exit_xfs_fs(void)
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

