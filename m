Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9JIOMBg206089 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 13:24:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A567C1DBFD4
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 11:24:21 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	0dNC4CnZ0uNMM1Ws for <xfs@oss.sgi.com>;
	Wed, 19 Oct 2011 11:24:21 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RGaoP-0002ql-30
	for xfs@oss.sgi.com; Wed, 19 Oct 2011 18:24:21 +0000
Message-Id: <20111019182421.048260722@bombadil.infradead.org>
Date: Wed, 19 Oct 2011 14:23:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] xfs: replace i_pin_wait with a bit waitqueue
References: <20111019182343.762985925@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-i_ipin_wait
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

Replace i_pin_wait, which is only used during synchronous inode flushing
with a bit waitqueue.  This trades off a much smaller inode against
slightly slower wakeup performance, and saves 12 (32-bit) or 20 (64-bit)
bytes in the XFS inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-10-19 10:58:26.000000000 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-10-19 11:04:34.523257631 +0200
@@ -2151,7 +2151,7 @@ xfs_idestroy_fork(
  * once someone is waiting for it to be unpinned.
  */
 static void
-xfs_iunpin_nowait(
+xfs_iunpin(
 	struct xfs_inode	*ip)
 {
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
@@ -2163,14 +2163,29 @@ xfs_iunpin_nowait(
 
 }
 
+static void
+__xfs_iunpin_wait(
+	struct xfs_inode	*ip)
+{
+	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IPINNED_BIT);
+	DEFINE_WAIT_BIT(q, &ip->i_flags, __XFS_IPINNED_BIT);
+
+	xfs_iunpin(ip);
+
+	do {
+		prepare_to_wait(wq, &q.wait, TASK_UNINTERRUPTIBLE);
+		if (xfs_ipincount(ip))
+			io_schedule();
+	} while (xfs_ipincount(ip));
+	finish_wait(wq, &q.wait);
+}
+
 void
 xfs_iunpin_wait(
 	struct xfs_inode	*ip)
 {
-	if (xfs_ipincount(ip)) {
-		xfs_iunpin_nowait(ip);
-		wait_event(ip->i_ipin_wait, (xfs_ipincount(ip) == 0));
-	}
+	if (xfs_ipincount(ip))
+		__xfs_iunpin_wait(ip);
 }
 
 /*
@@ -2529,7 +2544,7 @@ xfs_iflush(
 	 * out for us if they occur after the log force completes.
 	 */
 	if (!(flags & SYNC_WAIT) && xfs_ipincount(ip)) {
-		xfs_iunpin_nowait(ip);
+		xfs_iunpin(ip);
 		xfs_ifunlock(ip);
 		return EAGAIN;
 	}
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-10-19 11:02:35.000000000 +0200
+++ xfs/fs/xfs/xfs_inode.h	2011-10-19 11:04:06.979195218 +0200
@@ -245,7 +245,6 @@ typedef struct xfs_inode {
 	mrlock_t		i_lock;		/* inode lock */
 	mrlock_t		i_iolock;	/* inode IO lock */
 	atomic_t		i_pincount;	/* inode pin count */
-	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
 	unsigned long		i_flags;	/* see defined flags below */
@@ -374,6 +373,8 @@ xfs_set_projid(struct xfs_inode *ip,
 #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
 #define __XFS_IFLOCK_BIT	7	 /* inode is beeing flushed right now */
 #define XFS_IFLOCK		(1 << __XFS_IFLOCK_BIT)
+#define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
+#define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
 
 /*
  * Per-lifetime flags need to be reset when re-using a reclaimable inode during
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2011-10-19 10:58:26.000000000 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2011-10-19 11:04:18.319693929 +0200
@@ -559,7 +559,7 @@ xfs_inode_item_unpin(
 	trace_xfs_inode_unpin(ip, _RET_IP_);
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
 	if (atomic_dec_and_test(&ip->i_pincount))
-		wake_up(&ip->i_ipin_wait);
+		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
 }
 
 /*
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-10-19 10:58:26.000000000 +0200
+++ xfs/fs/xfs/xfs_super.c	2011-10-19 11:03:16.683692911 +0200
@@ -837,7 +837,6 @@ xfs_fs_inode_init_once(
 	/* xfs inode */
 	atomic_set(&ip->i_pincount, 0);
 	spin_lock_init(&ip->i_flags_lock);
-	init_waitqueue_head(&ip->i_ipin_wait);
 
 	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
 		     "xfsino", ip->i_ino);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
