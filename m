Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D77C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD9764FC4
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCKDGf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:06:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhCKDGI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:06:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7637664EDB;
        Thu, 11 Mar 2021 03:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615431968;
        bh=lanNz/6hwDHxua+Mn5t1kXpbwgyWxlVz18cNr+sqrE4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K5d+LmM6kAYXIhzGf5GkRMpz+K7rfqvTd/+3JjmvNYCgvi9KjSdlRtIHvqx09EjXQ
         wIbMX6BocI/ipK0VS7z2xn5BQzLlMa1WK/1ZajVc52PBoYnVMLPUcLeg5Cp4E1vDNM
         L0cquN9kNU99g0pK6iYtliT1EUpunTk6NHnAbPZ3dPVZiAluXjE6FnTpE0iTkkVFHx
         fVmt0AitvRcW9o6ewgHumX3lwl0vX05SSIQAJGaXwU1Z2UaCY51UoRsUG2QO1gArJT
         rCRAs0bev+PIw6/MtDJDnar/RsBK9fo3gWjlCqEjYoXloICl8OMdfwC5oERSNBEHet
         +Ltbltv2A9Lgg==
Subject: [PATCH 05/11] xfs: rename the blockgc workqueue
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Mar 2021 19:06:08 -0800
Message-ID: <161543196819.1947934.4325937657338405659.stgit@magnolia>
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

Since we're about to start using the blockgc workqueue to dispose of
inactivated inodes, strip the "block" prefix from the name; now it's
merely the general garbage collection (gc) workqueue.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Documentation/admin-guide/xfs.rst |    2 +-
 fs/xfs/xfs_icache.c               |    2 +-
 fs/xfs/xfs_mount.h                |    2 +-
 fs/xfs/xfs_super.c                |    8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index 5422407a96d7..8de008c0c5ad 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -522,7 +522,7 @@ and the short name of the data device.  They all can be found in:
 ================  ===========
   xfs_iwalk-$pid  Inode scans of the entire filesystem. Currently limited to
                   mount time quotacheck.
-  xfs-blockgc     Background garbage collection of disk space that have been
+  xfs-gc          Background garbage collection of disk space that have been
                   speculatively allocated beyond EOF or for staging copy on
                   write operations.
 ================  ===========
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1d7720a0c068..e6a62f765422 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1335,7 +1335,7 @@ xfs_blockgc_queue(
 {
 	rcu_read_lock();
 	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG))
-		queue_delayed_work(pag->pag_mount->m_blockgc_workqueue,
+		queue_delayed_work(pag->pag_mount->m_gc_workqueue,
 				   &pag->pag_blockgc_work,
 				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
 	rcu_read_unlock();
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 659ad95fe3e0..81829d19596e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -93,7 +93,7 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
-	struct workqueue_struct *m_blockgc_workqueue;
+	struct workqueue_struct *m_gc_workqueue;
 	struct workqueue_struct	*m_sync_workqueue;
 
 	int			m_bsize;	/* fs logical block size */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e5e0713bebcd..e774358383d6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -519,10 +519,10 @@ xfs_init_mount_workqueues(
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
-	mp->m_blockgc_workqueue = alloc_workqueue("xfs-blockgc/%s",
+	mp->m_gc_workqueue = alloc_workqueue("xfs-gc/%s",
 			WQ_SYSFS | WQ_UNBOUND | WQ_FREEZABLE | WQ_MEM_RECLAIM,
 			0, mp->m_super->s_id);
-	if (!mp->m_blockgc_workqueue)
+	if (!mp->m_gc_workqueue)
 		goto out_destroy_reclaim;
 
 	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s",
@@ -533,7 +533,7 @@ xfs_init_mount_workqueues(
 	return 0;
 
 out_destroy_eofb:
-	destroy_workqueue(mp->m_blockgc_workqueue);
+	destroy_workqueue(mp->m_gc_workqueue);
 out_destroy_reclaim:
 	destroy_workqueue(mp->m_reclaim_workqueue);
 out_destroy_cil:
@@ -551,7 +551,7 @@ xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	destroy_workqueue(mp->m_sync_workqueue);
-	destroy_workqueue(mp->m_blockgc_workqueue);
+	destroy_workqueue(mp->m_gc_workqueue);
 	destroy_workqueue(mp->m_reclaim_workqueue);
 	destroy_workqueue(mp->m_cil_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);

