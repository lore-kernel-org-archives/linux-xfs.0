Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757521AbcJRS0R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Oct 2016 14:26:17 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A5896804E3
        for <linux-xfs@vger.kernel.org>; Tue, 18 Oct 2016 18:26:16 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3] xfs: fix unbalanced inode reclaim flush locking
Date: Tue, 18 Oct 2016 14:26:15 -0400
Message-Id: <1476815175-25909-1-git-send-email-bfoster@redhat.com>
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

As it turns out, the flush lock is not actually required for the reclaim
logic in xfs_reclaim_inode() because by that time we have already cycled
the flush lock once while holding ILOCK_EXCL. Therefore, remove the
additional flush lock/unlock cycle around the 'reclaim:' label and
update branches into this label to release the flush lock where
appropriate. Add an assert to xfs_ifunlock() to help prevent future
occurences of the same problem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reported-by: Zorro Lang <zlang@redhat.com>
---

v3:
- Rework to drop flush lock around reclaim bits.
- Rebase against latest for-next.
v2:
- Add comment in xfs_reclaim_inode() wrt to flush lock.
- Fix XFS_IRECLAIM usage in xfs_inode_free().


 fs/xfs/xfs_icache.c | 27 ++++++++++++++-------------
 fs/xfs/xfs_inode.h  | 11 ++++++-----
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 14796b7..8b528f1 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -123,7 +123,6 @@ __xfs_inode_free(
 {
 	/* asserts to verify all state is correct here */
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!xfs_isiflocked(ip));
 	XFS_STATS_DEC(ip->i_mount, vn_active);
 
 	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
@@ -133,6 +132,8 @@ void
 xfs_inode_free(
 	struct xfs_inode	*ip)
 {
+	ASSERT(!xfs_isiflocked(ip));
+
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always
 	 * appears to be reclaimed with an invalid inode number when in the
@@ -981,6 +982,7 @@ xfs_reclaim_inode(
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
+		/* xfs_iflush_abort() drops the flush lock */
 		xfs_iflush_abort(ip, false);
 		goto reclaim;
 	}
@@ -989,10 +991,10 @@ xfs_reclaim_inode(
 			goto out_ifunlock;
 		xfs_iunpin_wait(ip);
 	}
-	if (xfs_iflags_test(ip, XFS_ISTALE))
-		goto reclaim;
-	if (xfs_inode_clean(ip))
+	if (xfs_iflags_test(ip, XFS_ISTALE) || xfs_inode_clean(ip)) {
+		xfs_ifunlock(ip);
 		goto reclaim;
+	}
 
 	/*
 	 * Never flush out dirty data during non-blocking reclaim, as it would
@@ -1030,25 +1032,24 @@ xfs_reclaim_inode(
 		xfs_buf_relse(bp);
 	}
 
-	xfs_iflock(ip);
 reclaim:
+	ASSERT(!xfs_isiflocked(ip));
+
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always appears
 	 * to be reclaimed with an invalid inode number when in the free state.
-	 * We do this as early as possible under the ILOCK and flush lock so
-	 * that xfs_iflush_cluster() can be guaranteed to detect races with us
-	 * here. By doing this, we guarantee that once xfs_iflush_cluster has
-	 * locked both the XFS_ILOCK and the flush lock that it will see either
-	 * a valid, flushable inode that will serialise correctly against the
-	 * locks below, or it will see a clean (and invalid) inode that it can
-	 * skip.
+	 * We do this as early as possible under the ILOCK so that
+	 * xfs_iflush_cluster() can be guaranteed to detect races with us here.
+	 * By doing this, we guarantee that once xfs_iflush_cluster has locked
+	 * XFS_ILOCK that it will see either a valid, flushable inode that will
+	 * serialise correctly, or it will see a clean (and invalid) inode that
+	 * it can skip.
 	 */
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags = XFS_IRECLAIM;
 	ip->i_ino = 0;
 	spin_unlock(&ip->i_flags_lock);
 
-	xfs_ifunlock(ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	XFS_STATS_INC(ip->i_mount, xs_ig_reclaims);
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

