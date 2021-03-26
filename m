Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 153D1C433E3
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA58261A4C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhCZAWp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhCZAW2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:22:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 326F6619D3;
        Fri, 26 Mar 2021 00:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718148;
        bh=cTmcElSbM1n4NrPDdajMFI17UpT7Dkeqs1VMuWXPN74=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WI6v+PGFL7K7V4NouBGd9E6ts93sn521zGKIO0hpOeau+nQPi0HVIQRYityuBBK3Z
         lFl5WXFvsSKcBsfDEXH3dQwPzvba7bW85qmcELrauHngcqtiINZ47EqdseYsIvtuIx
         upV9RF54iodOgvzyFLJts7ekh8bsNtsZUfmlA0ETMlsXcTHquP6irNSUHV/Vkqxqol
         e/1CrvDzQ/WdJvFgEO8Fmh5/P0M+tXRi6ZFcJj89uIKBqAGBNIFBzrWgRNR0jIK4v9
         OZXsGlK7xZg3wfMDpIWFqhxlqMnUPDmNI+QUsAHk5DB/v9NjPlJn8RpRfXMAlApExf
         d7ckRwyr/Z52A==
Subject: [PATCH 7/9] xfs: create a polled function to force inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:22:27 -0700
Message-ID: <161671814786.622901.3638495557270241904.stgit@magnolia>
In-Reply-To: <161671810866.622901.16520335819131743716.stgit@magnolia>
References: <161671810866.622901.16520335819131743716.stgit@magnolia>
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
 fs/xfs/xfs_icache.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h |    1 +
 fs/xfs/xfs_linux.h  |    1 +
 fs/xfs/xfs_mount.c  |    2 +-
 fs/xfs/xfs_mount.h  |    5 +++++
 fs/xfs/xfs_super.c  |    3 ++-
 6 files changed, 55 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 00d614730b2c..23b04cfa38f3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1894,9 +1894,13 @@ xfs_inodegc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
+	int			error;
+
 	trace_xfs_inodegc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, XFS_ICI_INODEGC_TAG, eofb);
+	error = xfs_inode_walk(mp, XFS_ICI_INODEGC_TAG, eofb);
+	wake_up(&mp->m_inactive_wait);
+	return error;
 }
 
 /* Background inode inactivation worker. */
@@ -1938,6 +1942,46 @@ xfs_inodegc_flush(
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
+				   !radix_tree_tagged(&mp->m_perag_tree,
+						      XFS_ICI_INODEGC_TAG),
+				   HZ / 10)) {
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
index f43a3dad5652..a1230ebcea3e 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -76,6 +76,7 @@ void xfs_inew_wait(struct xfs_inode *ip);
 
 void xfs_inodegc_worker(struct work_struct *work);
 void xfs_inodegc_flush(struct xfs_mount *mp);
+void xfs_inodegc_flush_poll(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
 int xfs_inodegc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
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
index c6af1e848171..5db2a65b3729 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1115,7 +1115,7 @@ xfs_unmountfs(
 	 * Flush all the queued inode inactivation work to disk before tearing
 	 * down rt metadata and quotas.
 	 */
-	xfs_inodegc_flush(mp);
+	xfs_inodegc_flush_poll(mp);
 
 	xfs_blockgc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 416f308aee52..e910e5734026 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -216,6 +216,11 @@ typedef struct xfs_mount {
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
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 605af79a3e88..de44e9843558 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1798,7 +1798,7 @@ xfs_remount_ro(
 	 * Since this can involve finobt updates, do it now before we lose the
 	 * per-AG space reservations to guarantee that we won't fail there.
 	 */
-	xfs_inodegc_flush(mp);
+	xfs_inodegc_flush_poll(mp);
 
 	/* Free the per-AG metadata reservation pool. */
 	error = xfs_fs_unreserve_ag_blocks(mp);
@@ -1924,6 +1924,7 @@ static int xfs_init_fs_context(
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
+	init_waitqueue_head(&mp->m_inactive_wait);
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
 	 * recovery, so we must set this to true so that an ifree transaction

