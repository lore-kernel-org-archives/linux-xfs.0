Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57627 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdFCNLl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:11:41 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/23] xfs: wait on new inodes during quotaoff dquot release
Date: Sat,  3 Jun 2017 15:10:51 +0200
Message-Id: <20170603131103.23712-12-hch@lst.de>
In-Reply-To: <20170603131103.23712-1-hch@lst.de>
References: <20170603131103.23712-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit e20c8a517f259cb4d258e10b0cd5d4b30d4167a0 upstream.

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
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm_syscalls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 475a3882a81f..9cb5c381b01c 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -759,5 +759,6 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, NULL);
+	xfs_inode_ag_iterator_flags(mp, xfs_dqrele_inode, flags, NULL,
+				    XFS_AGITER_INEW_WAIT);
 }
-- 
2.11.0

