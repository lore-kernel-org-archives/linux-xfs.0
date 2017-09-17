Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40213 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752094AbdIQVHW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:22 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/47] xfs: don't leak quotacheck dquots when cow recovery
Date: Sun, 17 Sep 2017 14:06:44 -0700
Message-Id: <20170917210712.10804-20-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 77aff8c76425c8f49b50d0b9009915066739e7d2 upstream.

If we fail a mount on account of cow recovery errors, it's possible that
a previous quotacheck left some dquots in memory.  The bailout clause of
xfs_mountfs forgets to purge these, and so we leak them.  Fix that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_mount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ab058c7dc598..d4ce8d277992 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1004,6 +1004,8 @@ xfs_mountfs(
 	IRELE(rip);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
+	/* Clean out dquots that might be in memory after quotacheck. */
+	xfs_qm_unmount(mp);
  out_log_dealloc:
 	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);
-- 
2.14.1

