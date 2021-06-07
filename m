Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0426BC47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E417661245
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhFGW1Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230383AbhFGW1Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 18:27:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF85961059;
        Mon,  7 Jun 2021 22:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623104732;
        bh=aa3VH5woyri41Zkru1djIQICDvFCXm5ISWecSmW0l8w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NnXwp53ZBsxjJExC918GR81H037cc479SDTFc6B+t9UaVkMvo50JMdvS7Zoj5rMCy
         8nQPNQjR3KS17P3uaLVFnHP0mY+p28HuhS8UnIieZ17kGmCh2wMcOHNFuhcO9GibS5
         CLmdI1D6FAn7iMULOfb68WCwMquLM56Izs8hAOcNpXpRzY9qLJFZkX3lrY2dgBY+as
         MU6ZvnieRuoiT9WhJhrZAI0gmSIxnISKxc7G9k/HIvq/8Z8cW8VdnMMkqOj5/39IKv
         TVSNwaVdnVmq+uk1qcConJqbX1WS6nrynEAiIQWpTWyFxheGg3PNgo/u8LJu+lV3/C
         HkDULUphwtp0g==
Subject: [PATCH 7/9] xfs: create a polled function to force inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Mon, 07 Jun 2021 15:25:32 -0700
Message-ID: <162310473246.3465262.7704328426297395302.stgit@locust>
In-Reply-To: <162310469340.3465262.504398465311182657.stgit@locust>
References: <162310469340.3465262.504398465311182657.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a polled version of xfs_inactive_force so that we can force
inactivation while holding a lock (usually the umount lock) without
tripping over the softlockup timer.  This is for callers that hold vfs
locks while calling inactivation, which is currently unmount, iunlink
processing during mount, and rw->ro remount.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h |    1 +
 fs/xfs/xfs_linux.h  |    1 +
 fs/xfs/xfs_mount.c  |    2 +-
 fs/xfs/xfs_mount.h  |    7 +++++++
 fs/xfs/xfs_super.c  |   10 +++++++++-
 6 files changed, 62 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8574edca6f52..22090b318e58 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1907,9 +1907,13 @@ xfs_inodegc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_icwalk	*icw)
 {
+	int			error;
+
 	trace_xfs_inodegc_free_space(mp, icw, _RET_IP_);
 
-	return xfs_icwalk(mp, XFS_ICWALK_INODEGC, icw);
+	error = xfs_icwalk(mp, XFS_ICWALK_INODEGC, icw);
+	wake_up(&mp->m_inactive_wait);
+	return error;
 }
 
 /* Background inode inactivation worker. */
@@ -1959,6 +1963,44 @@ xfs_inodegc_flush(
 	flush_workqueue(mp->m_gc_workqueue);
 }
 
+/*
+ * Force all queued inode inactivation work to run immediately, and poll
+ * until the work is complete.  Callers should only use this function if they
+ * must inactivate inodes while holding VFS mutexes.
+ */
+void
+xfs_inodegc_flush_poll(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	bool			queued = false;
+
+	/*
+	 * Force to the foreground any inode inactivations that may happen
+	 * while we're running our polling loop.
+	 */
+	set_bit(XFS_OPFLAG_INACTIVATE_NOW_BIT, &mp->m_opflags);
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG) {
+		mod_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work, 0);
+		queued = true;
+	}
+	if (!queued)
+		goto clear;
+
+	/*
+	 * Touch the softlockup watchdog every 1/10th of a second while there
+	 * are still inactivation-tagged inodes in the filesystem.
+	 */
+	while (!wait_event_timeout(mp->m_inactive_wait,
+				!xfs_has_inodegc_work(mp), HZ / 10)) {
+		touch_softlockup_watchdog();
+	}
+clear:
+	clear_bit(XFS_OPFLAG_INACTIVATE_NOW_BIT, &mp->m_opflags);
+}
+
 /* Stop all queued inactivation work. */
 void
 xfs_inodegc_stop(
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 1f693e7fe6c8..d0ba6778325e 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -82,6 +82,7 @@ void xfs_blockgc_start(struct xfs_mount *mp);
 
 void xfs_inodegc_worker(struct work_struct *work);
 void xfs_inodegc_flush(struct xfs_mount *mp);
+void xfs_inodegc_flush_poll(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
 int xfs_inodegc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icw);
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 3d6b0a407d52..9b6f519a9a43 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -61,6 +61,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/ratelimit.h>
 #include <linux/rhashtable.h>
 #include <linux/xattr.h>
+#include <linux/nmi.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fbbee8ac12f3..24dc3b7026b7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1004,7 +1004,7 @@ xfs_unmountfs(
 	 * Flush all the queued inode inactivation work to disk before tearing
 	 * down rt metadata and quotas.
 	 */
-	xfs_inodegc_flush(mp);
+	xfs_inodegc_flush_poll(mp);
 
 	xfs_blockgc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c2a8f0a550cd..4323aaa3e7b4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -223,6 +223,11 @@ typedef struct xfs_mount {
 	struct xfs_kobj		m_errortag_kobj;
 #endif
 	struct ratelimit_state	m_inodegc_ratelimit;
+	/*
+	 * Use this to wait for the inode inactivation workqueue to finish
+	 * inactivating all the inodes.
+	 */
+	struct wait_queue_head	m_inactive_wait;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
@@ -263,6 +268,8 @@ typedef struct xfs_mount {
 
 #define XFS_OPFLAG_INODEGC_RUNNING_BIT	(0)	/* are we allowed to start the
 						   inode inactivation worker? */
+#define XFS_OPFLAG_INACTIVATE_NOW_BIT	(1)	/* force foreground inactivation
+						   of unlinked inodes */
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 164626a4232f..968176b35d13 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -699,6 +699,13 @@ xfs_fs_destroy_inode(
 			xfs_check_delalloc(ip, XFS_COW_FORK);
 			ASSERT(0);
 		}
+	} else if (test_bit(XFS_OPFLAG_INACTIVATE_NOW_BIT, &mp->m_opflags)) {
+		/*
+		 * If we're doing foreground inactivation, take care of the
+		 * inode right now and push it straight to reclaim.
+		 */
+		xfs_inactive(ip);
+		need_inactive = false;
 	} else {
 		/*
 		 * Drop dquots for disabled quota types to avoid delaying
@@ -1830,7 +1837,7 @@ xfs_remount_ro(
 	 * Since this can involve finobt updates, do it now before we lose the
 	 * per-AG space reservations to guarantee that we won't fail there.
 	 */
-	xfs_inodegc_flush(mp);
+	xfs_inodegc_flush_poll(mp);
 
 	/* Free the per-AG metadata reservation pool. */
 	error = xfs_fs_unreserve_ag_blocks(mp);
@@ -1956,6 +1963,7 @@ static int xfs_init_fs_context(
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
+	init_waitqueue_head(&mp->m_inactive_wait);
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
 	 * recovery, so we must set this to true so that an ifree transaction

