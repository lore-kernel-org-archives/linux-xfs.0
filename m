Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754204AbcJQPC6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 11:02:58 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8F35680B22
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2016 15:02:58 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix unbalanced inode reclaim flush locking
Date: Mon, 17 Oct 2016 11:02:56 -0400
Message-Id: <1476716576-14427-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: zlang@redhat.com

Filesystem shutdown testing on an older distro kernel has uncovered an
imbalanced locking pattern for the inode flush lock in
xfs_reclaim_inode(). Specifically, there is a double unlock sequence
between the call to xfs_iflush_abort() and xfs_reclaim_inode() at the
"reclaim:" label.

This actually does not cause obvious problems on current kernels due to
the current flush lock implementation. Older kernels use a counting
based flush lock mechanism, however, which effectively breaks the lock
indefinitely when an already unlocked flush lock is repeatedly unlocked.
Though this only currently occurs on filesystem shutdown, it has
reproduced the effect of elevating an fs shutdown to a system-wide crash
or hang.

Because this problem exists on filesystem shutdown and thus only after
unrelated catastrophic failure, issue the simple fix to reacquire the
flush lock in xfs_reclaim_inode() before jumping to the reclaim code.
Add an assert to xfs_ifunlock() to help prevent future occurrences of
the same problem. Finally, update xfs_reclaim_inode() to bitwise-OR the
reclaim flag to avoid smashing the flush lock in the process (which is
based on an inode flag in current kernels). This avoids a (spurious)
failure of the newly introduced xfs_ifunlock() assertion.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reported-by: Zorro Lang <zlang@redhat.com>
---
 fs/xfs/xfs_icache.c |  3 ++-
 fs/xfs/xfs_inode.h  | 11 ++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 14796b7..7375313 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -982,6 +982,7 @@ restart:
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
 		xfs_iflush_abort(ip, false);
+		xfs_iflock(ip);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip)) {
@@ -1044,7 +1045,7 @@ reclaim:
 	 * skip.
 	 */
 	spin_lock(&ip->i_flags_lock);
-	ip->i_flags = XFS_IRECLAIM;
+	ip->i_flags |= XFS_IRECLAIM;
 	ip->i_ino = 0;
 	spin_unlock(&ip->i_flags_lock);
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index f14c1de..71e8a81 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -246,6 +246,11 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
  * Synchronize processes attempting to flush the in-core inode back to disk.
  */
 
+static inline int xfs_isiflocked(struct xfs_inode *ip)
+{
+	return xfs_iflags_test(ip, XFS_IFLOCK);
+}
+
 extern void __xfs_iflock(struct xfs_inode *ip);
 
 static inline int xfs_iflock_nowait(struct xfs_inode *ip)
@@ -261,16 +266,12 @@ static inline void xfs_iflock(struct xfs_inode *ip)
 
 static inline void xfs_ifunlock(struct xfs_inode *ip)
 {
+	ASSERT(xfs_isiflocked(ip));
 	xfs_iflags_clear(ip, XFS_IFLOCK);
 	smp_mb();
 	wake_up_bit(&ip->i_flags, __XFS_IFLOCK_BIT);
 }
 
-static inline int xfs_isiflocked(struct xfs_inode *ip)
-{
-	return xfs_iflags_test(ip, XFS_IFLOCK);
-}
-
 /*
  * Flags for inode locking.
  * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
-- 
2.7.4

