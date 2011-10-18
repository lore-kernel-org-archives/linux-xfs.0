Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9IKE81m125199 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 15:14:09 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68EA8D95EA6
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 13:22:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	RttLk8uNArUNBv6L for <xfs@oss.sgi.com>;
	Tue, 18 Oct 2011 13:22:02 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RGG33-0007Ew-DD
	for xfs@oss.sgi.com; Tue, 18 Oct 2011 20:14:05 +0000
Message-Id: <20111018201405.357001594@bombadil.infradead.org>
Date: Tue, 18 Oct 2011 16:13:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] xfs: replace i_flock with a sleeping bitlock
References: <20111018201304.279051318@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-i_flush
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We almost never block on i_flock, the exception is synchronous inode
flushing.  Instead of bloating the inode with a 16/24-byte completion
that we abuse as a semaphore just implement it as a bitlock that uses
a bit waitqueue for the rare sleeping path.  This primarily is a
tradeoff between a much smaller inode and a faster non-blocking
path vs a faster faster wakeups, and we are much better off with
the former.

A small downside is that we will lose lockdep checking for i_flock, but
given that it's always taken inside the ilock that should be acceptable.

Note that for example the inode writeback locking is implemented in a
very similar way.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2011-10-18 20:55:31.093352628 +0200
+++ xfs/fs/xfs/xfs_iget.c	2011-10-18 20:58:40.141854067 +0200
@@ -77,7 +77,7 @@ xfs_inode_alloc(
 
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
-	ASSERT(completion_done(&ip->i_flush));
+	ASSERT(!xfs_isiflocked(ip));
 	ASSERT(ip->i_ino == 0);
 
 	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
@@ -151,7 +151,7 @@ xfs_inode_free(
 	/* asserts to verify all state is correct here */
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!spin_is_locked(&ip->i_flags_lock));
-	ASSERT(completion_done(&ip->i_flush));
+	ASSERT(!xfs_isiflocked(ip));
 
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always
@@ -716,3 +716,19 @@ xfs_isilocked(
 	return 0;
 }
 #endif
+
+void
+__xfs_iflock(
+	struct xfs_inode	*ip)
+{
+	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IFLOCK);
+	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_IFLOCK);
+
+	do {
+		prepare_to_wait_exclusive(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+		if (xfs_isiflocked(ip))
+			schedule();
+	} while (!xfs_iflock_nowait(ip));
+
+	finish_wait(wq, &wait.wait);
+}
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-10-18 20:55:31.069353232 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-10-18 20:58:40.141854067 +0200
@@ -2510,7 +2510,7 @@ xfs_iflush(
 	XFS_STATS_INC(xs_iflush_count);
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-	ASSERT(!completion_done(&ip->i_flush));
+	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > ip->i_df.if_ext_max);
 
@@ -2626,7 +2626,7 @@ xfs_iflush_int(
 #endif
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-	ASSERT(!completion_done(&ip->i_flush));
+	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > ip->i_df.if_ext_max);
 
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-10-18 20:58:39.376854255 +0200
+++ xfs/fs/xfs/xfs_inode.h	2011-10-18 20:58:40.145858771 +0200
@@ -244,7 +244,6 @@ typedef struct xfs_inode {
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	mrlock_t		i_lock;		/* inode lock */
 	mrlock_t		i_iolock;	/* inode IO lock */
-	struct completion	i_flush;	/* inode flush completion q */
 	atomic_t		i_pincount;	/* inode pin count */
 	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
@@ -331,6 +330,19 @@ xfs_iflags_test_and_clear(xfs_inode_t *i
 	return ret;
 }
 
+static inline int
+xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
+{
+	int ret;
+
+	spin_lock(&ip->i_flags_lock);
+	ret = ip->i_flags & flags;
+	if (!ret)
+		ip->i_flags |= flags;
+	spin_unlock(&ip->i_flags_lock);
+	return ret;
+}
+
 /*
  * Project quota id helpers (previously projid was 16bit only
  * and using two 16bit values to hold new 32bit projid was chosen
@@ -351,26 +363,6 @@ xfs_set_projid(struct xfs_inode *ip,
 }
 
 /*
- * Manage the i_flush queue embedded in the inode.  This completion
- * queue synchronizes processes attempting to flush the in-core
- * inode back to disk.
- */
-static inline void xfs_iflock(xfs_inode_t *ip)
-{
-	wait_for_completion(&ip->i_flush);
-}
-
-static inline int xfs_iflock_nowait(xfs_inode_t *ip)
-{
-	return try_wait_for_completion(&ip->i_flush);
-}
-
-static inline void xfs_ifunlock(xfs_inode_t *ip)
-{
-	complete(&ip->i_flush);
-}
-
-/*
  * In-core inode flags.
  */
 #define XFS_IRECLAIM		0x0001  /* started reclaiming this inode */
@@ -380,6 +372,8 @@ static inline void xfs_ifunlock(xfs_inod
 #define XFS_IFILESTREAM		0x0010	/* inode is in a filestream directory */
 #define XFS_ITRUNCATED		0x0020	/* truncated down so flush-on-close */
 #define XFS_IDIRTY_RELEASE	0x0040	/* dirty release already seen */
+#define __XFS_IFLOCK		8	/* inode is beeing flushed right now */
+#define XFS_IFLOCK		(1 << __XFS_IFLOCK)
 
 /*
  * Per-lifetime flags need to be reset when re-using a reclaimable inode during
@@ -392,6 +386,34 @@ static inline void xfs_ifunlock(xfs_inod
 	 XFS_IFILESTREAM);
 
 /*
+ * Synchronize processes attempting to flush the in-core inode back to disk.
+ */
+
+extern void __xfs_iflock(struct xfs_inode *ip);
+
+static inline int xfs_iflock_nowait(struct xfs_inode *ip)
+{
+	return !xfs_iflags_test_and_set(ip, XFS_IFLOCK);
+}
+
+static inline void xfs_iflock(struct xfs_inode *ip)
+{
+	if (!xfs_iflock_nowait(ip))
+		__xfs_iflock(ip);
+}
+
+static inline void xfs_ifunlock(struct xfs_inode *ip)
+{
+	xfs_iflags_clear(ip, XFS_IFLOCK);
+	wake_up_bit(&ip->i_flags, __XFS_IFLOCK);
+}
+
+static inline int xfs_isiflocked(struct xfs_inode *ip)
+{
+	return xfs_iflags_test(ip, XFS_IFLOCK);
+}
+
+/*
  * Flags for inode locking.
  * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
  *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2011-10-18 20:55:31.085351457 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2011-10-18 20:58:40.149853334 +0200
@@ -720,7 +720,7 @@ xfs_inode_item_pushbuf(
 	 * If a flush is not in progress anymore, chances are that the
 	 * inode was taken off the AIL. So, just get out.
 	 */
-	if (completion_done(&ip->i_flush) ||
+	if (!xfs_isiflocked(ip) ||
 	    !(lip->li_flags & XFS_LI_IN_AIL)) {
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		return;
@@ -750,7 +750,7 @@ xfs_inode_item_push(
 	struct xfs_inode	*ip = iip->ili_inode;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
-	ASSERT(!completion_done(&ip->i_flush));
+	ASSERT(xfs_isiflocked(ip));
 
 	/*
 	 * Since we were able to lock the inode's flush lock and
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-10-18 20:55:34.861353099 +0200
+++ xfs/fs/xfs/xfs_super.c	2011-10-18 20:58:40.149853334 +0200
@@ -838,13 +838,6 @@ xfs_fs_inode_init_once(
 	atomic_set(&ip->i_pincount, 0);
 	spin_lock_init(&ip->i_flags_lock);
 	init_waitqueue_head(&ip->i_ipin_wait);
-	/*
-	 * Because we want to use a counting completion, complete
-	 * the flush completion once to allow a single access to
-	 * the flush completion without blocking.
-	 */
-	init_completion(&ip->i_flush);
-	complete(&ip->i_flush);
 
 	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
 		     "xfsino", ip->i_ino);
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2011-10-18 19:41:11.124853014 +0200
+++ xfs/fs/xfs/xfs_sync.c	2011-10-18 20:58:40.157852915 +0200
@@ -675,14 +675,13 @@ xfs_reclaim_inode_grab(
 		return 1;
 
 	/*
-	 * do some unlocked checks first to avoid unnecessary lock traffic.
-	 * The first is a flush lock check, the second is a already in reclaim
-	 * check. Only do these checks if we are not going to block on locks.
+	 * If we are beeing asked for non-blocking operation, do unlocked
+	 * checks to see if the inode already is beeing flushed or in reclaim
+	 * to avoid lock traffic.
 	 */
 	if ((flags & SYNC_TRYLOCK) &&
-	    (!ip->i_flush.done || __xfs_iflags_test(ip, XFS_IRECLAIM))) {
+	    __xfs_iflags_test(ip, XFS_IFLOCK | XFS_IRECLAIM))
 		return 1;
-	}
 
 	/*
 	 * The radix tree lock here protects a thread in xfs_iget from racing

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
