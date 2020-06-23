Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FA0C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 09:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB3B20738
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 09:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732168AbgFWJu1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 05:50:27 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:58800 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732172AbgFWJu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 05:50:26 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 4CFD1D5AB3F
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2020 19:50:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnfZH-0004gj-Tq
        for linux-xfs@vger.kernel.org; Tue, 23 Jun 2020 19:50:15 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jnfZH-0087B5-KW
        for linux-xfs@vger.kernel.org; Tue, 23 Jun 2020 19:50:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: xfs_iflock is no longer a completion
Date:   Tue, 23 Jun 2020 19:50:12 +1000
Message-Id: <20200623095015.1934171-2-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200623095015.1934171-1-david@fromorbit.com>
References: <20200623095015.1934171-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=gBkaUiCbtYbGVvkf08wA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

With the recent rework of the inode cluster flushing, we no longer
ever wait on the the inode flush "lock". It was never a lock in the
first place, just a completion to allow callers to wait for inode IO
to complete. We now never wait for flush completion as all inode
flushing is non-blocking. Hence we can get rid of all the iflock
infrastructure and instead just set and check a state flag.

Rename the XFS_IFLOCK flag to XFS_IFLUSHING, convert all the
xfs_iflock_nowait() test-and-set operations on that flag, and
replace all the xfs_ifunlock() calls to clear operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c     | 19 ++++++------
 fs/xfs/xfs_inode.c      | 67 +++++++++++++++--------------------------
 fs/xfs/xfs_inode.h      | 33 +-------------------
 fs/xfs/xfs_inode_item.c |  6 ++--
 fs/xfs/xfs_inode_item.h |  4 +--
 5 files changed, 39 insertions(+), 90 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a973f180c6cd..0d73559f2d58 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -54,7 +54,6 @@ xfs_inode_alloc(
 
 	XFS_STATS_INC(mp, vn_active);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(!xfs_isiflocked(ip));
 	ASSERT(ip->i_ino == 0);
 
 	/* initialise the xfs inode */
@@ -125,7 +124,7 @@ void
 xfs_inode_free(
 	struct xfs_inode	*ip)
 {
-	ASSERT(!xfs_isiflocked(ip));
+	ASSERT(!xfs_iflags_test(ip, XFS_IFLUSHING));
 
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always
@@ -999,7 +998,7 @@ xfs_reclaim_inode_grab(
 	 * Do unlocked checks to see if the inode already is being flushed or in
 	 * reclaim to avoid lock traffic.
 	 */
-	if (__xfs_iflags_test(ip, XFS_IFLOCK | XFS_IRECLAIM))
+	if (__xfs_iflags_test(ip, XFS_IFLUSHING | XFS_IRECLAIM))
 		return 1;
 
 	/*
@@ -1045,23 +1044,23 @@ xfs_reclaim_inode(
 
 	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
 		goto out;
-	if (!xfs_iflock_nowait(ip))
+	if (xfs_iflags_test_and_set(ip, XFS_IFLUSHING))
 		goto out_iunlock;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
 		/* xfs_iflush_abort() drops the flush lock */
 		xfs_iflush_abort(ip);
+		ASSERT(!xfs_iflags_test(ip, XFS_IFLUSHING));
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
-		goto out_ifunlock;
+		goto out_clear_flush;
 	if (!xfs_inode_clean(ip))
-		goto out_ifunlock;
+		goto out_clear_flush;
 
-	xfs_ifunlock(ip);
+	xfs_iflags_clear(ip, XFS_IFLUSHING);
 reclaim:
-	ASSERT(!xfs_isiflocked(ip));
 
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always appears
@@ -1111,8 +1110,8 @@ xfs_reclaim_inode(
 	__xfs_inode_free(ip);
 	return true;
 
-out_ifunlock:
-	xfs_ifunlock(ip);
+out_clear_flush:
+	xfs_iflags_clear(ip, XFS_IFLUSHING);
 out_iunlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out:
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bae84b3eeb9a..ba86d27b5226 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -598,22 +598,6 @@ xfs_lock_two_inodes(
 	}
 }
 
-void
-__xfs_iflock(
-	struct xfs_inode	*ip)
-{
-	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IFLOCK_BIT);
-	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_IFLOCK_BIT);
-
-	do {
-		prepare_to_wait_exclusive(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
-		if (xfs_isiflocked(ip))
-			io_schedule();
-	} while (!xfs_iflock_nowait(ip));
-
-	finish_wait(wq, &wait.wq_entry);
-}
-
 STATIC uint
 _xfs_dic2xflags(
 	uint16_t		di_flags,
@@ -2547,11 +2531,8 @@ xfs_ifree_mark_inode_stale(
 	 * valid, the wrong inode or stale.
 	 */
 	spin_lock(&ip->i_flags_lock);
-	if (ip->i_ino != inum || __xfs_iflags_test(ip, XFS_ISTALE)) {
-		spin_unlock(&ip->i_flags_lock);
-		rcu_read_unlock();
-		return;
-	}
+	if (ip->i_ino != inum || __xfs_iflags_test(ip, XFS_ISTALE))
+		goto out_iflags_unlock;
 
 	/*
 	 * Don't try to lock/unlock the current inode, but we _cannot_ skip the
@@ -2568,16 +2549,14 @@ xfs_ifree_mark_inode_stale(
 		}
 	}
 	ip->i_flags |= XFS_ISTALE;
-	spin_unlock(&ip->i_flags_lock);
-	rcu_read_unlock();
 
 	/*
-	 * If we can't get the flush lock, the inode is already attached.  All
+	 * If the inode is flushing, it is already attached to the buffer.  All
 	 * we needed to do here is mark the inode stale so buffer IO completion
 	 * will remove it from the AIL.
 	 */
 	iip = ip->i_itemp;
-	if (!xfs_iflock_nowait(ip)) {
+	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
 		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
 		ASSERT(iip->ili_last_fields);
 		goto out_iunlock;
@@ -2589,10 +2568,12 @@ xfs_ifree_mark_inode_stale(
 	 * commit as the flock synchronises removal of the inode from the
 	 * cluster buffer against inode reclaim.
 	 */
-	if (!iip || list_empty(&iip->ili_item.li_bio_list)) {
-		xfs_ifunlock(ip);
+	if (!iip || list_empty(&iip->ili_item.li_bio_list))
 		goto out_iunlock;
-	}
+
+	__xfs_iflags_set(ip, XFS_IFLUSHING);
+	spin_unlock(&ip->i_flags_lock);
+	rcu_read_unlock();
 
 	/* we have a dirty inode in memory that has not yet been flushed. */
 	spin_lock(&iip->ili_lock);
@@ -2602,9 +2583,16 @@ xfs_ifree_mark_inode_stale(
 	spin_unlock(&iip->ili_lock);
 	ASSERT(iip->ili_last_fields);
 
+	if (ip != free_ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return;
+
 out_iunlock:
 	if (ip != free_ip)
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out_iflags_unlock:
+	spin_unlock(&ip->i_flags_lock);
+	rcu_read_unlock();
 }
 
 /*
@@ -3459,7 +3447,7 @@ xfs_iflush(
 	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-	ASSERT(xfs_isiflocked(ip));
+	ASSERT(xfs_iflags_test(ip, XFS_IFLUSHING));
 	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 	ASSERT(iip->ili_item.li_buf == bp);
@@ -3629,7 +3617,7 @@ xfs_iflush_cluster(
 		/*
 		 * Quick and dirty check to avoid locks if possible.
 		 */
-		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK))
+		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLUSHING))
 			continue;
 		if (xfs_ipincount(ip))
 			continue;
@@ -3643,7 +3631,7 @@ xfs_iflush_cluster(
 		 */
 		spin_lock(&ip->i_flags_lock);
 		ASSERT(!__xfs_iflags_test(ip, XFS_ISTALE));
-		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK)) {
+		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLUSHING)) {
 			spin_unlock(&ip->i_flags_lock);
 			continue;
 		}
@@ -3651,23 +3639,16 @@ xfs_iflush_cluster(
 		/*
 		 * ILOCK will pin the inode against reclaim and prevent
 		 * concurrent transactions modifying the inode while we are
-		 * flushing the inode.
+		 * flushing the inode. If we get the lock, set the flushing
+		 * state before we drop the i_flags_lock.
 		 */
 		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
 			spin_unlock(&ip->i_flags_lock);
 			continue;
 		}
+		__xfs_iflags_set(ip, XFS_IFLUSHING);
 		spin_unlock(&ip->i_flags_lock);
 
-		/*
-		 * Skip inodes that are already flush locked as they have
-		 * already been written to the buffer.
-		 */
-		if (!xfs_iflock_nowait(ip)) {
-			xfs_iunlock(ip, XFS_ILOCK_SHARED);
-			continue;
-		}
-
 		/*
 		 * Abort flushing this inode if we are shut down because the
 		 * inode may not currently be in the AIL. This can occur when
@@ -3686,7 +3667,7 @@ xfs_iflush_cluster(
 
 		/* don't block waiting on a log force to unpin dirty inodes */
 		if (xfs_ipincount(ip)) {
-			xfs_ifunlock(ip);
+			xfs_iflags_clear(ip, XFS_IFLUSHING);
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
 			continue;
 		}
@@ -3694,7 +3675,7 @@ xfs_iflush_cluster(
 		if (!xfs_inode_clean(ip))
 			error = xfs_iflush(ip, bp);
 		else
-			xfs_ifunlock(ip);
+			xfs_iflags_clear(ip, XFS_IFLUSHING);
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		if (error)
 			break;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7a8adb76c17f..991ef00370d5 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -211,8 +211,7 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
 #define XFS_INEW		(1 << __XFS_INEW_BIT)
 #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
 #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
-#define __XFS_IFLOCK_BIT	7	 /* inode is being flushed right now */
-#define XFS_IFLOCK		(1 << __XFS_IFLOCK_BIT)
+#define XFS_IFLUSHING		(1 << 7) /* inode is being flushed */
 #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
 #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
 #define XFS_IEOFBLOCKS		(1 << 9) /* has the preallocblocks tag set */
@@ -233,36 +232,6 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
 	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED)
 
-/*
- * Synchronize processes attempting to flush the in-core inode back to disk.
- */
-
-static inline int xfs_isiflocked(struct xfs_inode *ip)
-{
-	return xfs_iflags_test(ip, XFS_IFLOCK);
-}
-
-extern void __xfs_iflock(struct xfs_inode *ip);
-
-static inline int xfs_iflock_nowait(struct xfs_inode *ip)
-{
-	return !xfs_iflags_test_and_set(ip, XFS_IFLOCK);
-}
-
-static inline void xfs_iflock(struct xfs_inode *ip)
-{
-	if (!xfs_iflock_nowait(ip))
-		__xfs_iflock(ip);
-}
-
-static inline void xfs_ifunlock(struct xfs_inode *ip)
-{
-	ASSERT(xfs_isiflocked(ip));
-	xfs_iflags_clear(ip, XFS_IFLOCK);
-	smp_mb();
-	wake_up_bit(&ip->i_flags, __XFS_IFLOCK_BIT);
-}
-
 /*
  * Flags for inode locking.
  * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 3840117f8a5e..0494b907c63d 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -492,7 +492,7 @@ xfs_inode_item_push(
 		return XFS_ITEM_PINNED;
 
 	/* If the inode is already flush locked, we're already flushing. */
-	if (xfs_isiflocked(ip))
+	if (xfs_iflags_test(ip, XFS_IFLUSHING))
 		return XFS_ITEM_FLUSHING;
 
 	if (!xfs_buf_trylock(bp))
@@ -702,7 +702,7 @@ xfs_iflush_finish(
 		iip->ili_last_fields = 0;
 		iip->ili_flush_lsn = 0;
 		spin_unlock(&iip->ili_lock);
-		xfs_ifunlock(iip->ili_inode);
+		xfs_iflags_clear(iip->ili_inode, XFS_IFLUSHING);
 		if (drop_buffer)
 			xfs_buf_rele(bp);
 	}
@@ -789,7 +789,7 @@ xfs_iflush_abort(
 		list_del_init(&iip->ili_item.li_bio_list);
 		spin_unlock(&iip->ili_lock);
 	}
-	xfs_ifunlock(ip);
+	xfs_iflags_clear(ip, XFS_IFLUSHING);
 	if (bp)
 		xfs_buf_rele(bp);
 }
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 048b5e7dee90..23a7b4928727 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -25,8 +25,8 @@ struct xfs_inode_log_item {
 	 *
 	 * We need atomic changes between inode dirtying, inode flushing and
 	 * inode completion, but these all hold different combinations of
-	 * ILOCK and iflock and hence we need some other method of serialising
-	 * updates to the flush state.
+	 * ILOCK and IFLUSHING and hence we need some other method of
+	 * serialising updates to the flush state.
 	 */
 	spinlock_t		ili_lock;	   /* flush state lock */
 	unsigned int		ili_last_fields;   /* fields when flushed */
-- 
2.26.2.761.g0e0b3e54be

