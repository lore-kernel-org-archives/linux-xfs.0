Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD2FC43381
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FBFB22D73
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbhALAZ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404093AbhAKXYW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:24:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A3EC22D2B;
        Mon, 11 Jan 2021 23:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407420;
        bh=+aBlpIbN9VZuRJav6bokPuOl6kYoGvq+OZ3dYo5Hbbw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QCF5LhCIGUOWWflnJEIw68V3mPXNDIjDSVTxQVB/ZZuEK0x0JSbepQlBoZLJTuqJe
         YyDcDvb7d45hMLC0vUepCn8Zv8oWbiZi4ow/CdUIY3HRG2Gid562zQaQPDbEogALAZ
         xFE0l8EF5wPYvA+VP02LjrLOvlAtD01NzaNGq3ULBz7HOiiYI7z89fM0x3rqRNWpM4
         WvR16PfRt2emOhCfFkZTVnrY8iwX5bwYj9bqzI2fz2ZMp9vJU/f6CwO/ZeB8xeb4P8
         UUhSKJaiwsy2h3fe6PL7wib2+K/+7Gl0lKH549BVdFtz1pn/QxIOUm/nkGry7aNPLD
         5SSFM7r4kygYw==
Subject: [PATCH 4/7] xfs: consolidate the eofblocks and cowblocks workers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:23:40 -0800
Message-ID: <161040742050.1582286.5743015618624198962.stgit@magnolia>
In-Reply-To: <161040739544.1582286.11068012972712089066.stgit@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove the separate cowblocks work items and knob so that we can control
and run everything from a single blockgc work queue.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_globals.c |    7 ++--
 fs/xfs/xfs_icache.c  |   80 ++++++++++++++------------------------------------
 fs/xfs/xfs_icache.h  |    5 +--
 fs/xfs/xfs_linux.h   |    3 +-
 fs/xfs/xfs_mount.h   |    6 +---
 fs/xfs/xfs_super.c   |   11 +++----
 fs/xfs/xfs_sysctl.c  |   15 ++-------
 fs/xfs/xfs_sysctl.h  |    3 +-
 8 files changed, 39 insertions(+), 91 deletions(-)


diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index fa55ab8b8d80..f62fa652c2fd 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -8,8 +8,8 @@
 /*
  * Tunable XFS parameters.  xfs_params is required even when CONFIG_SYSCTL=n,
  * other XFS code uses these values.  Times are measured in centisecs (i.e.
- * 100ths of a second) with the exception of eofb_timer and cowb_timer, which
- * are measured in seconds.
+ * 100ths of a second) with the exception of blockgc_timer, which is measured
+ * in seconds.
  */
 xfs_param_t xfs_params = {
 			  /*	MIN		DFLT		MAX	*/
@@ -28,8 +28,7 @@ xfs_param_t xfs_params = {
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
 	.fstrm_timer	= {	1,		30*100,		3600*100},
-	.eofb_timer	= {	1,		300,		3600*24},
-	.cowb_timer	= {	1,		1800,		3600*24},
+	.blockgc_timer	= {	1,		300,		3600*24},
 };
 
 struct xfs_globals xfs_globals = {
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index da833f6e1fd9..92fcec349054 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -935,18 +935,18 @@ xfs_inode_walk(
 }
 
 /*
- * Background scanning to trim post-EOF preallocated space. This is queued
- * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
+ * Background scanning to trim preallocated space. This is queued based on the
+ * 'speculative_prealloc_lifetime' tunable (5m by default).
  */
-void
-xfs_queue_eofblocks(
-	struct xfs_mount *mp)
+static void
+xfs_queue_blockgc(
+	struct xfs_mount	*mp)
 {
 	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCK_GC_TAG))
-		queue_delayed_work(mp->m_eofblocks_workqueue,
-				   &mp->m_eofblocks_work,
-				   msecs_to_jiffies(xfs_eofb_secs * 1000));
+		queue_delayed_work(mp->m_blockgc_workqueue,
+				   &mp->m_blockgc_work,
+				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
 	rcu_read_unlock();
 }
 
@@ -965,51 +965,22 @@ xfs_blockgc_scan(
 	return xfs_icache_free_cowblocks(mp, eofb);
 }
 
+/* Background worker that trims preallocated space. */
 void
-xfs_eofblocks_worker(
-	struct work_struct *work)
+xfs_blockgc_worker(
+	struct work_struct	*work)
 {
-	struct xfs_mount *mp = container_of(to_delayed_work(work),
-				struct xfs_mount, m_eofblocks_work);
+	struct xfs_mount	*mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_blockgc_work);
+	int			error;
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	xfs_icache_free_eofblocks(mp, NULL);
+	error = xfs_blockgc_scan(mp, NULL);
+	if (error)
+		xfs_info(mp, "preallocation gc worker failed, err=%d", error);
 	sb_end_write(mp->m_super);
-
-	xfs_queue_eofblocks(mp);
-}
-
-/*
- * Background scanning to trim preallocated CoW space. This is queued
- * based on the 'speculative_cow_prealloc_lifetime' tunable (5m by default).
- * (We'll just piggyback on the post-EOF prealloc space workqueue.)
- */
-void
-xfs_queue_cowblocks(
-	struct xfs_mount *mp)
-{
-	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCK_GC_TAG))
-		queue_delayed_work(mp->m_eofblocks_workqueue,
-				   &mp->m_cowblocks_work,
-				   msecs_to_jiffies(xfs_cowb_secs * 1000));
-	rcu_read_unlock();
-}
-
-void
-xfs_cowblocks_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(to_delayed_work(work),
-				struct xfs_mount, m_cowblocks_work);
-
-	if (!sb_start_write_trylock(mp->m_super))
-		return;
-	xfs_icache_free_cowblocks(mp, NULL);
-	sb_end_write(mp->m_super);
-
-	xfs_queue_cowblocks(mp);
+	xfs_queue_blockgc(mp);
 }
 
 /*
@@ -1512,7 +1483,6 @@ xfs_inode_free_blocks(
 static void
 __xfs_inode_set_blocks_tag(
 	struct xfs_inode	*ip,
-	void			(*execute)(struct xfs_mount *mp),
 	unsigned long		iflag)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1547,7 +1517,7 @@ __xfs_inode_set_blocks_tag(
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
 		/* kick off background trimming */
-		execute(ip->i_mount);
+		xfs_queue_blockgc(ip->i_mount);
 
 		trace_xfs_perag_set_blockgc(ip->i_mount, pag->pag_agno, -1,
 				_RET_IP_);
@@ -1562,8 +1532,7 @@ xfs_inode_set_eofblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_set_eofblocks_tag(ip);
-	return __xfs_inode_set_blocks_tag(ip, xfs_queue_eofblocks,
-			XFS_IEOFBLOCKS);
+	return __xfs_inode_set_blocks_tag(ip, XFS_IEOFBLOCKS);
 }
 
 static void
@@ -1721,8 +1690,7 @@ xfs_inode_set_cowblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_set_cowblocks_tag(ip);
-	return __xfs_inode_set_blocks_tag(ip, xfs_queue_cowblocks,
-			XFS_ICOWBLOCKS);
+	return __xfs_inode_set_blocks_tag(ip, XFS_ICOWBLOCKS);
 }
 
 void
@@ -1738,8 +1706,7 @@ void
 xfs_stop_block_reaping(
 	struct xfs_mount	*mp)
 {
-	cancel_delayed_work_sync(&mp->m_eofblocks_work);
-	cancel_delayed_work_sync(&mp->m_cowblocks_work);
+	cancel_delayed_work_sync(&mp->m_blockgc_work);
 }
 
 /* Enable post-EOF and CoW block auto-reclamation. */
@@ -1747,6 +1714,5 @@ void
 xfs_start_block_reaping(
 	struct xfs_mount	*mp)
 {
-	xfs_queue_eofblocks(mp);
-	xfs_queue_cowblocks(mp);
+	xfs_queue_blockgc(mp);
 }
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index fcee10dbfbe9..4ddb2c6de18b 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -55,14 +55,11 @@ int xfs_inode_free_blocks(struct xfs_mount *mp, bool sync);
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
-void xfs_eofblocks_worker(struct work_struct *);
-void xfs_queue_eofblocks(struct xfs_mount *);
+void xfs_blockgc_worker(struct work_struct *work);
 
 void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
-void xfs_cowblocks_worker(struct work_struct *);
-void xfs_queue_cowblocks(struct xfs_mount *);
 
 int xfs_inode_walk(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, void *args),
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 5b7a1e201559..af6be9b9ccdf 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -98,8 +98,7 @@ typedef __u32			xfs_nlink_t;
 #define xfs_rotorstep		xfs_params.rotorstep.val
 #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
 #define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
-#define xfs_eofb_secs		xfs_params.eofb_timer.val
-#define xfs_cowb_secs		xfs_params.cowb_timer.val
+#define xfs_blockgc_secs	xfs_params.blockgc_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_set_flags_nested(sp, f)		\
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 70f6c68c795f..d9f32102514e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -93,7 +93,7 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
-	struct workqueue_struct *m_eofblocks_workqueue;
+	struct workqueue_struct *m_blockgc_workqueue;
 	struct workqueue_struct	*m_sync_workqueue;
 
 	int			m_bsize;	/* fs logical block size */
@@ -177,9 +177,7 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct delayed_work	m_eofblocks_work; /* background eof blocks
-						     trimming */
-	struct delayed_work	m_cowblocks_work; /* background cow blocks
+	struct delayed_work	m_blockgc_work; /* background prealloc blocks
 						     trimming */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 813be879a5e5..7fb024f96964 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -515,9 +515,9 @@ xfs_init_mount_workqueues(
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
-	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
+	mp->m_blockgc_workqueue = alloc_workqueue("xfs-blockgc/%s",
 			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
-	if (!mp->m_eofblocks_workqueue)
+	if (!mp->m_blockgc_workqueue)
 		goto out_destroy_reclaim;
 
 	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s", WQ_FREEZABLE, 0,
@@ -528,7 +528,7 @@ xfs_init_mount_workqueues(
 	return 0;
 
 out_destroy_eofb:
-	destroy_workqueue(mp->m_eofblocks_workqueue);
+	destroy_workqueue(mp->m_blockgc_workqueue);
 out_destroy_reclaim:
 	destroy_workqueue(mp->m_reclaim_workqueue);
 out_destroy_cil:
@@ -546,7 +546,7 @@ xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	destroy_workqueue(mp->m_sync_workqueue);
-	destroy_workqueue(mp->m_eofblocks_workqueue);
+	destroy_workqueue(mp->m_blockgc_workqueue);
 	destroy_workqueue(mp->m_reclaim_workqueue);
 	destroy_workqueue(mp->m_cil_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
@@ -1872,8 +1872,7 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
-	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
+	INIT_DELAYED_WORK(&mp->m_blockgc_work, xfs_blockgc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index fac9de7ee6d0..145e06c47744 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -194,21 +194,12 @@ static struct ctl_table xfs_table[] = {
 	},
 	{
 		.procname	= "speculative_prealloc_lifetime",
-		.data		= &xfs_params.eofb_timer.val,
+		.data		= &xfs_params.blockgc_timer.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.eofb_timer.min,
-		.extra2		= &xfs_params.eofb_timer.max,
-	},
-	{
-		.procname	= "speculative_cow_prealloc_lifetime",
-		.data		= &xfs_params.cowb_timer.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.cowb_timer.min,
-		.extra2		= &xfs_params.cowb_timer.max,
+		.extra1		= &xfs_params.blockgc_timer.min,
+		.extra2		= &xfs_params.blockgc_timer.max,
 	},
 	/* please keep this the last entry */
 #ifdef CONFIG_PROC_FS
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 8abf4640f1d5..7692e76ead33 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -35,8 +35,7 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t rotorstep;	/* inode32 AG rotoring control knob */
 	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
 	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
-	xfs_sysctl_val_t eofb_timer;	/* Interval between eofb scan wakeups */
-	xfs_sysctl_val_t cowb_timer;	/* Interval between cowb scan wakeups */
+	xfs_sysctl_val_t blockgc_timer;	/* Interval between blockgc scans */
 } xfs_param_t;
 
 /*

