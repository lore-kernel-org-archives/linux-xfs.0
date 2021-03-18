Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E75C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC0664EBD
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhCRWfB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:35:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232613AbhCRWec (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:34:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8733264E0C;
        Thu, 18 Mar 2021 22:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616106872;
        bh=JggwjUwzt7xCuyKCsAymn3y9v+Q8R+uJPDxwOVZPVzI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eiB81Hyc2K2HoD7/4PhwgSCgVedgBTp4vyCl3fN2sNB+wzoWwP3YCcP+Zgzu/1U8i
         FBZapeiP7UrHCnqrw7wxADsbAuaTZ0DCjcAGFo+frAnS0xFHFAZqHhUfw6gO4NjMJC
         XQT+zv6aJyA+rsbn8Gn/4VpaK8FHh9vySNOyDUqpv3maK74zGZelypvcBrIJPMyA39
         uNo3GcxdiDOc/LOhGv46KOiHLisiJ+o27pRdU4up4sQOsEpDdn1plTIb8JCnsW9b7V
         P689MukLLle0/4nxDJtTbZ30Fv84XblAVIvMEvHbJwqrdV5Qry+vIQqd/A/9q3x0JI
         M3xoNBerRDr8Q==
Subject: [PATCH 6/7] xfs: create a polled function to force inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 18 Mar 2021 15:34:32 -0700
Message-ID: <161610687219.1887744.12622367871348304784.stgit@magnolia>
In-Reply-To: <161610683869.1887744.8863884017621115954.stgit@magnolia>
References: <161610683869.1887744.8863884017621115954.stgit@magnolia>
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
 fs/xfs/xfs_icache.c |   40 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h |    1 +
 fs/xfs/xfs_mount.c  |    2 +-
 fs/xfs/xfs_mount.h  |    5 +++++
 fs/xfs/xfs_super.c  |    3 ++-
 5 files changed, 48 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 29d99e5edbdf..53104c463d0b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -25,6 +25,7 @@
 #include "xfs_ialloc.h"
 
 #include <linux/iversion.h>
+#include <linux/nmi.h>
 
 /* Forward declarations to reduce indirect calls in xfs_inode_walk_ag */
 static int xfs_blockgc_scan_inode(struct xfs_inode *ip, void *args);
@@ -2064,9 +2065,13 @@ xfs_inodegc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
+	int			error;
+
 	trace_xfs_inodegc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, xfs_inodegc_inactivate, eofb);
+	error = xfs_inode_walk(mp, xfs_inodegc_inactivate, eofb);
+	wake_up(&mp->m_inactive_wait);
+	return error;
 }
 
 /* Background inode inactivation worker. */
@@ -2136,6 +2141,39 @@ xfs_inodegc_force(
 	flush_workqueue(mp->m_gc_workqueue);
 }
 
+/*
+ * Force all inode inactivation work to run immediately, and poll until the
+ * work is complete.  Callers should only use this function if they must
+ * inactivate inodes while holding VFS locks, and must ensure that no new
+ * inodes will be queued for inactivation.
+ */
+void
+xfs_inodegc_force_poll(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	bool			queued = false;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG) {
+		xfs_inodegc_force_pag(pag);
+		queued = true;
+	}
+	if (!queued)
+		return;
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
+}
+
 /* Stop all queued inactivation work. */
 void
 xfs_inodegc_stop(
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d4171998deef..371453028dc8 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -78,6 +78,7 @@ void xfs_blockgc_start(struct xfs_mount *mp);
 
 void xfs_inodegc_worker(struct work_struct *work);
 void xfs_inodegc_force(struct xfs_mount *mp);
+void xfs_inodegc_force_poll(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
 int xfs_inodegc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a5963061485c..1012b1b361ba 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1109,7 +1109,7 @@ xfs_unmountfs(
 	 * Since this can involve finobt updates, do it now before we lose the
 	 * per-AG space reservations.
 	 */
-	xfs_inodegc_force(mp);
+	xfs_inodegc_force_poll(mp);
 
 	xfs_blockgc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index ff765c73a542..61dad1ba4dcf 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -213,6 +213,11 @@ typedef struct xfs_mount {
 	unsigned int		*m_errortag;
 	struct xfs_kobj		m_errortag_kobj;
 #endif
+	/*
+	 * Use this to wait for the inode inactivation workqueue to finish
+	 * inactivating all the inodes.
+	 */
+	struct wait_queue_head	m_inactive_wait;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 566e5657c1b0..8329a3efced7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1754,7 +1754,7 @@ xfs_remount_ro(
 	 * Since this can involve finobt updates, do it now before we lose the
 	 * per-AG space reservations.
 	 */
-	xfs_inodegc_force(mp);
+	xfs_inodegc_force_poll(mp);
 
 	/* Free the per-AG metadata reservation pool. */
 	error = xfs_fs_unreserve_ag_blocks(mp);
@@ -1880,6 +1880,7 @@ static int xfs_init_fs_context(
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
+	init_waitqueue_head(&mp->m_inactive_wait);
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
 	 * recovery, so we must set this to true so that an ifree transaction

