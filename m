Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A1DC43381
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5344B2072C
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314281AbhAZXD1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:03:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729892AbhAZFHA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 00:07:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6368922B2C;
        Tue, 26 Jan 2021 05:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611637580;
        bh=seNEh6F77jRSrNt3D2a6TaTjv1CcLsuAH5qhIgzk3y0=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Ln5L1Tz8vliN5HKfNUJ/MJcASu2ZRaDvmAMNzu0YXZokHNKR0yR6hIKycZAPCX3v/
         hoEg42MHIIbZXCIhqa39fqIHU9k2Dm1gsewry48/7p8FTeh+Knplvs171/nO171Bvr
         sF2UdXXTl5lgsZg6raTWHX0YTXFQh2mqVntwNK6XdtkUFQPydC2X0/Kv9abkwj6DLo
         Hnmct4OMBWGQmaDzp9dLsL4NkXXAmowdP00vVGgxE5PHzdTEuVPACzT5eXNwZBzS2H
         u9PXC/X2VZ1JJTyN87fWXdlT1Cq7efgOVq7Ob99OrC/4m2Lf44BEu8bsQHNkbuBcj3
         MS5YjSnEMX3+g==
Date:   Mon, 25 Jan 2021 21:06:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: [PATCH 4/3] xfs: set WQ_SYSFS on all workqueues in debug mode
Message-ID: <20210126050619.GT7698@magnolia>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
 <161142799960.2173328.12558377173737512680.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142799960.2173328.12558377173737512680.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When CONFIG_XFS_DEBUG=y, set WQ_SYSFS on all workqueues that we create
so that we (developers) have a means to monitor cpu affinity and whatnot
for background workers.  In the next patchset we'll expose knobs for
some of the workqueues publicly and document it, but not now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c       |    5 +++--
 fs/xfs/xfs_mru_cache.c |    2 +-
 fs/xfs/xfs_super.c     |   23 ++++++++++++++---------
 fs/xfs/xfs_super.h     |    6 ++++++
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 58699881c100..0da019a4a7f9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1493,8 +1493,9 @@ xlog_alloc_log(
 	log->l_iclog->ic_prev = prev_iclog;	/* re-write 1st prev ptr */
 
 	log->l_ioend_workqueue = alloc_workqueue("xfs-log/%s",
-			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI, 0,
-			mp->m_super->s_id);
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM |
+				    WQ_HIGHPRI),
+			0, mp->m_super->s_id);
 	if (!log->l_ioend_workqueue)
 		goto out_free_iclog;
 
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index a06661dac5be..34c3b16f834f 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -294,7 +294,7 @@ int
 xfs_mru_cache_init(void)
 {
 	xfs_mru_reap_wq = alloc_workqueue("xfs_mru_cache",
-				WQ_MEM_RECLAIM|WQ_FREEZABLE, 1);
+			XFS_WQFLAGS(WQ_MEM_RECLAIM | WQ_FREEZABLE), 1);
 	if (!xfs_mru_reap_wq)
 		return -ENOMEM;
 	return 0;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index aed74a3fc787..8959561351ca 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -495,33 +495,37 @@ xfs_init_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	mp->m_buf_workqueue = alloc_workqueue("xfs-buf/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_super->s_id);
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
+			1, mp->m_super->s_id);
 	if (!mp->m_buf_workqueue)
 		goto out;
 
 	mp->m_unwritten_workqueue = alloc_workqueue("xfs-conv/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
+			0, mp->m_super->s_id);
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_buf;
 
 	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
-			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND,
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
 			0, mp->m_super->s_id);
 	if (!mp->m_cil_workqueue)
 		goto out_destroy_unwritten;
 
 	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
+			0, mp->m_super->s_id);
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
 	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
+			0, mp->m_super->s_id);
 	if (!mp->m_eofblocks_workqueue)
 		goto out_destroy_reclaim;
 
-	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s", WQ_FREEZABLE, 0,
-					       mp->m_super->s_id);
+	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s",
+			XFS_WQFLAGS(WQ_FREEZABLE), 0, mp->m_super->s_id);
 	if (!mp->m_sync_workqueue)
 		goto out_destroy_eofb;
 
@@ -2085,11 +2089,12 @@ xfs_init_workqueues(void)
 	 * max_active value for this workqueue.
 	 */
 	xfs_alloc_wq = alloc_workqueue("xfsalloc",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0);
+			XFS_WQFLAGS(WQ_MEM_RECLAIM | WQ_FREEZABLE), 0);
 	if (!xfs_alloc_wq)
 		return -ENOMEM;
 
-	xfs_discard_wq = alloc_workqueue("xfsdiscard", WQ_UNBOUND, 0);
+	xfs_discard_wq = alloc_workqueue("xfsdiscard", XFS_WQFLAGS(WQ_UNBOUND),
+			0);
 	if (!xfs_discard_wq)
 		goto out_free_alloc_wq;
 
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index b552cf6d3379..1ca484b8357f 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -75,6 +75,12 @@ extern void xfs_qm_exit(void);
 				XFS_ASSERT_FATAL_STRING \
 				XFS_DBG_STRING /* DBG must be last */
 
+#ifdef DEBUG
+# define XFS_WQFLAGS(wqflags)	(WQ_SYSFS | (wqflags))
+#else
+# define XFS_WQFLAGS(wqflags)	(wqflags)
+#endif
+
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_buftarg;
