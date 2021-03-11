Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96093C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 604DF64FC9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhCKDHI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:07:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229851AbhCKDGm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:06:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DFC064EDB;
        Thu, 11 Mar 2021 03:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615432002;
        bh=ZCVsRKI42Linf5t4n2+G5ehDI3HVpBgtEno5ueROlwA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=stB0B1dKcjZTXIH873R9aCeoTmdo+XmC7aUL8251UYFTqzzT7JEgS+mt7CsEOL6Tf
         7Z/XazSzdPhbSKr++yAzrMF4B2Cd0SdRoq5YrY0vdKkCg4VNJR/EtjJRLiUVj8XDdo
         mQvBX8SLVf+dmFVXSevOHNcLxVVonV14V8qQ/zWj74+klatp93oG4lE6TUtNU7BEdo
         7FcmPZKXTt2lFAwA9li0P/0BdVQzfJkcecPm69inKZ1tBcrmBxfBwY6QuetkmNz+3w
         QM7GDqqmh5b+p4qTQlo/KvWIky6ImPZcaYLsLGVupaYfil4hb0G2Hbyu/sNxH9ymKu
         YqOzSvLmlyTRw==
Subject: [PATCH 11/11] xfs: create a polled function to force inode
 inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Mar 2021 19:06:41 -0800
Message-ID: <161543200190.1947934.3117722394191799491.stgit@magnolia>
In-Reply-To: <161543194009.1947934.9910987247994410125.stgit@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
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
 fs/xfs/xfs_icache.c |   38 +++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h |    1 +
 fs/xfs/xfs_mount.c  |    2 +-
 fs/xfs/xfs_mount.h  |    5 +++++
 fs/xfs/xfs_super.c  |    3 ++-
 5 files changed, 46 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d5f580b92e48..9db2beb4e732 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -25,6 +25,7 @@
 #include "xfs_ialloc.h"
 
 #include <linux/iversion.h>
+#include <linux/nmi.h>
 
 /*
  * Allocate and initialise an xfs_inode.
@@ -2067,8 +2068,12 @@ xfs_inodegc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	return xfs_inode_walk(mp, XFS_INODE_WALK_INACTIVE,
+	int			error;
+
+	error = xfs_inode_walk(mp, XFS_INODE_WALK_INACTIVE,
 			xfs_inactive_inode, eofb, XFS_ICI_INACTIVE_TAG);
+	wake_up(&mp->m_inactive_wait);
+	return error;
 }
 
 /* Try to get inode inactivation moving. */
@@ -2138,6 +2143,37 @@ xfs_inodegc_force(
 	flush_workqueue(mp->m_gc_workqueue);
 }
 
+/*
+ * Force all inode inactivation work to run immediately, and poll until the
+ * work is complete.  Callers should only use this function if they must
+ * inactivate inodes while holding VFS locks, and must be prepared to prevent
+ * or to wait for inodes that are queued for inactivation while this runs.
+ */
+void
+xfs_inodegc_force_poll(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	bool			queued = false;
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_INACTIVE_TAG)
+		queued |= xfs_inodegc_force_pag(pag);
+	if (!queued)
+		return;
+
+	/*
+	 * Touch the softlockup watchdog every 1/10th of a second while there
+	 * are still inactivation-tagged inodes in the filesystem.
+	 */
+	while (!wait_event_timeout(mp->m_inactive_wait,
+				   !radix_tree_tagged(&mp->m_perag_tree,
+						      XFS_ICI_INACTIVE_TAG),
+				   HZ / 10)) {
+		touch_softlockup_watchdog();
+	}
+}
+
 /* Stop all queued inactivation work. */
 void
 xfs_inodegc_stop(
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 9d5a1f4c0369..80a79bace641 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -84,6 +84,7 @@ void xfs_blockgc_start(struct xfs_mount *mp);
 
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
index 835c07d00cd7..23d9888d2b82 100644
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

