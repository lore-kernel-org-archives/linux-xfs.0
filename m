Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52322 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdGMLda (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 07:33:30 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dVcMy-0001oc-0V
        for linux-xfs@vger.kernel.org; Thu, 13 Jul 2017 11:33:20 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] Revert "xfs: grab dquots without taking the ilock"
Date: Thu, 13 Jul 2017 13:33:04 +0200
Message-Id: <20170713113304.8079-5-hch@lst.de>
In-Reply-To: <20170713113304.8079-1-hch@lst.de>
References: <20170713113304.8079-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This reverts commit 50e0bdbe9f48f98bb02eac7030d682f4716884ae.

The new XFS_QMOPT_NOLOCK isn't used at all, and conditional locking based
on a flag is always the wrong thing to do - we should be having helpers
that can be called without the lock instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_quota_defs.h |  2 --
 fs/xfs/xfs_dquot.c             | 14 ++++----------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 2834574cb6e7..d69c772271cb 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -136,8 +136,6 @@ typedef uint16_t	xfs_qwarncnt_t;
  */
 #define XFS_QMOPT_INHERIT	0x1000000
 
-#define XFS_QMOPT_NOLOCK	0x2000000 /* don't ilock during dqget */
-
 /*
  * flags to xfs_trans_mod_dquot.
  */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f89f7b5241e6..fd2ef8c2c9a7 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -472,23 +472,18 @@ xfs_qm_dqtobp(
 	struct xfs_mount	*mp = dqp->q_mount;
 	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
 	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
-	uint			lock_mode = 0;
+	uint			lock_mode;
 
 	quotip = xfs_quota_inode(dqp->q_mount, dqp->dq_flags);
 	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
 
-	ASSERT(!(flags & XFS_QMOPT_NOLOCK) ||
-		xfs_isilocked(quotip, XFS_ILOCK_SHARED) ||
-		xfs_isilocked(quotip, XFS_ILOCK_EXCL));
-	if (!(flags & XFS_QMOPT_NOLOCK))
-		lock_mode = xfs_ilock_data_map_shared(quotip);
+	lock_mode = xfs_ilock_data_map_shared(quotip);
 	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
 		/*
 		 * Return if this type of quotas is turned off while we
 		 * didn't have the quota inode lock.
 		 */
-		if (lock_mode)
-			xfs_iunlock(quotip, lock_mode);
+		xfs_iunlock(quotip, lock_mode);
 		return -ESRCH;
 	}
 
@@ -498,8 +493,7 @@ xfs_qm_dqtobp(
 	error = xfs_bmapi_read(quotip, dqp->q_fileoffset,
 			       XFS_DQUOT_CLUSTER_SIZE_FSB, &map, &nmaps, 0);
 
-	if (lock_mode)
-		xfs_iunlock(quotip, lock_mode);
+	xfs_iunlock(quotip, lock_mode);
 	if (error)
 		return error;
 
-- 
2.11.0

