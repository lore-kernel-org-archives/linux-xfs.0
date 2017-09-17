Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58105 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdIQVHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:13 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/47] xfs: fix spurious spin_is_locked() assert failures on non-smp kernels
Date: Sun, 17 Sep 2017 14:06:27 -0700
Message-Id: <20170917210712.10804-3-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit 95989c46d2a156365867b1d795fdefce71bce378 upstream.

The 0-day kernel test robot reports assertion failures on
!CONFIG_SMP kernels due to failed spin_is_locked() checks. As it
turns out, spin_is_locked() is hardcoded to return zero on
!CONFIG_SMP kernels and so this function cannot be relied on to
verify spinlock state in this configuration.

To avoid this problem, replace the associated asserts with lockdep
variants that do the right thing regardless of kernel configuration.
Drop the one assert that checks for an unlocked lock as there is no
suitable lockdep variant for that case. This moves the spinlock
checks from XFS debug code to lockdep, but generally provides the
same level of protection.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c    | 2 +-
 fs/xfs/xfs_icache.c | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 16269271ebd6..24940dd3baa8 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -116,7 +116,7 @@ static inline void
 __xfs_buf_ioacct_dec(
 	struct xfs_buf	*bp)
 {
-	ASSERT(spin_is_locked(&bp->b_lock));
+	lockdep_assert_held(&bp->b_lock);
 
 	if (bp->b_state & XFS_BSTATE_IN_FLIGHT) {
 		bp->b_state &= ~XFS_BSTATE_IN_FLIGHT;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 74304b6ce84b..e279882de427 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -66,7 +66,6 @@ xfs_inode_alloc(
 
 	XFS_STATS_INC(mp, vn_active);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!spin_is_locked(&ip->i_flags_lock));
 	ASSERT(!xfs_isiflocked(ip));
 	ASSERT(ip->i_ino == 0);
 
@@ -192,7 +191,7 @@ xfs_perag_set_reclaim_tag(
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
-	ASSERT(spin_is_locked(&pag->pag_ici_lock));
+	lockdep_assert_held(&pag->pag_ici_lock);
 	if (pag->pag_ici_reclaimable++)
 		return;
 
@@ -214,7 +213,7 @@ xfs_perag_clear_reclaim_tag(
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
-	ASSERT(spin_is_locked(&pag->pag_ici_lock));
+	lockdep_assert_held(&pag->pag_ici_lock);
 	if (--pag->pag_ici_reclaimable)
 		return;
 
-- 
2.14.1

