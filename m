Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 007D9C83F19
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241145AbjH2XHW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238268AbjH2XHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:07:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9B2139
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:07:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00F5960FEF
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7EDC433C7;
        Tue, 29 Aug 2023 23:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350424;
        bh=Hxow7ICe3TCQpDuVHWhh+AApiJ8VNPpVFYrlOTWlBxg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DB8TYVV/PY7zkhP2lB6Kyv2a82dkoUTMc1Fdu9/gWffA0srTeThcikpaQZLWkZJtc
         cFiwzgGFMn8blHwZF2OW5OcIejYUvmjQD+25qUyJSlYuWIo2bQVfmHx6jkp+SfjrPi
         wNGZuTEZuO3eGrkPUCuwFxr42jrWyxXFFl2CvPD42J8Gb07LknLrsJ/4XGWA62zkpT
         ZAMC848KNwinsuT/wAYR+ZsVG+1/xCbFKbrdazizqi3DKUwr7CW+Oa5qIrXwmbQ3mg
         HJZYKB87zJMB+LvA4e1p+MP1Hw2L+nCHDQdTEqVzQxaUWEEPZM8tBnYHUSGltKGT2S
         ZGfJSrTa2Qm1Q==
Subject: [PATCH 3/4] xfs: remove the all-mounts list
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@gmail.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        ritesh.list@gmail.com, sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:07:04 -0700
Message-ID: <169335042397.3522698.1361551040183091315.stgit@frogsfrogsfrogs>
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

Revert commit 0ed17f01c8540 ("xfs: introduce all-mounts list for cpu
hotplug notifications") because the cpu hotplug hooks are now pointless,
so we don't need this list anymore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.h |    1 -
 fs/xfs/xfs_super.c |   39 ---------------------------------------
 2 files changed, 40 deletions(-)


diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f4a8879ba0e9..6e2806654e94 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -97,7 +97,6 @@ typedef struct xfs_mount {
 	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
 	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
 	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
-	struct list_head	m_mount_list;	/* global mount list */
 	void __percpu		*m_inodegc;	/* percpu inodegc structures */
 
 	/*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6a4f8b2f6159..be87584c635b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -56,28 +56,6 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
 static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 #endif
 
-#ifdef CONFIG_HOTPLUG_CPU
-static LIST_HEAD(xfs_mount_list);
-static DEFINE_SPINLOCK(xfs_mount_list_lock);
-
-static inline void xfs_mount_list_add(struct xfs_mount *mp)
-{
-	spin_lock(&xfs_mount_list_lock);
-	list_add(&mp->m_mount_list, &xfs_mount_list);
-	spin_unlock(&xfs_mount_list_lock);
-}
-
-static inline void xfs_mount_list_del(struct xfs_mount *mp)
-{
-	spin_lock(&xfs_mount_list_lock);
-	list_del(&mp->m_mount_list);
-	spin_unlock(&xfs_mount_list_lock);
-}
-#else /* !CONFIG_HOTPLUG_CPU */
-static inline void xfs_mount_list_add(struct xfs_mount *mp) {}
-static inline void xfs_mount_list_del(struct xfs_mount *mp) {}
-#endif
-
 enum xfs_dax_mode {
 	XFS_DAX_INODE = 0,
 	XFS_DAX_ALWAYS = 1,
@@ -1146,7 +1124,6 @@ xfs_fs_put_super(
 	xfs_freesb(mp);
 	xchk_mount_stats_free(mp);
 	free_percpu(mp->m_stats.xs_stats);
-	xfs_mount_list_del(mp);
 	xfs_inodegc_free_percpu(mp);
 	xfs_destroy_percpu_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
@@ -1558,13 +1535,6 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_destroy_counters;
 
-	/*
-	 * All percpu data structures requiring cleanup when a cpu goes offline
-	 * must be allocated before adding this @mp to the cpu-dead handler's
-	 * mount list.
-	 */
-	xfs_mount_list_add(mp);
-
 	/* Allocate stats memory before we do operations that might use it */
 	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
 	if (!mp->m_stats.xs_stats) {
@@ -1762,7 +1732,6 @@ xfs_fs_fill_super(
  out_free_stats:
 	free_percpu(mp->m_stats.xs_stats);
  out_destroy_inodegc:
-	xfs_mount_list_del(mp);
 	xfs_inodegc_free_percpu(mp);
  out_destroy_counters:
 	xfs_destroy_percpu_counters(mp);
@@ -2306,14 +2275,6 @@ static int
 xfs_cpu_dead(
 	unsigned int		cpu)
 {
-	struct xfs_mount	*mp, *n;
-
-	spin_lock(&xfs_mount_list_lock);
-	list_for_each_entry_safe(mp, n, &xfs_mount_list, m_mount_list) {
-		spin_unlock(&xfs_mount_list_lock);
-		spin_lock(&xfs_mount_list_lock);
-	}
-	spin_unlock(&xfs_mount_list_lock);
 	return 0;
 }
 

