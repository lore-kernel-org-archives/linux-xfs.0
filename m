Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751328AbdBOPks (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Feb 2017 10:40:48 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5/5] xfs: wait on new inodes during quotaoff dquot release
Date: Wed, 15 Feb 2017 10:40:47 -0500
Message-Id: <1487173247-5965-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
References: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>, Dave Chinner <david@fromorbit.com>

The quotaoff operation has a race with inode allocation that results
in a livelock. An inode allocation that occurs before the quota
status flags are updated acquires the appropriate dquots for the
inode via xfs_qm_vop_dqalloc(). It then inserts the XFS_INEW inode
into the perag radix tree, sometime later attaches the dquots to the
inode and finally clears the XFS_INEW flag. Quotaoff expects to
release the dquots from all inodes in the filesystem via
xfs_qm_dqrele_all_inodes(). This invokes the AG inode iterator,
which skips inodes in the XFS_INEW state because they are not fully
constructed. If the scan occurs after dquots have been attached to
an inode, but before XFS_INEW is cleared, the newly allocated inode
will continue to hold a reference to the applicable dquots. When
quotaoff invokes xfs_qm_dqpurge_all(), the reference count of those
dquot(s) remain elevated and the dqpurge scan spins indefinitely.

To address this problem, update the xfs_qm_dqrele_all_inodes() scan
to wait on inodes marked on the XFS_INEW state. We wait on the
inodes explicitly rather than skip and retry to avoid continuous
retry loops due to a parallel inode allocation workload. Since
quotaoff updates the quota state flags and uses a synchronous
transaction before the dqrele scan, and dquots are attached to
inodes after radix tree insertion iff quota is enabled, one INEW
waiting pass through the AG guarantees that the scan has processed
all inodes that could possibly hold dquot references.

Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_qm_syscalls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index dbb6802..40b7c3f 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -765,5 +765,6 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, NULL);
+	xfs_inode_ag_iterator_flags(mp, xfs_dqrele_inode, flags, NULL,
+				    XFS_AGITER_INEW_WAIT);
 }
-- 
2.7.4

