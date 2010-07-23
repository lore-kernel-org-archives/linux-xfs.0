Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NAcYUF195624 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 05:38:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19D9A1E33224
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 03:41:35 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	9bGi3MaooZ64dQEW for <xfs@oss.sgi.com>;
	Fri, 23 Jul 2010 03:41:35 -0700 (PDT)
Received: from dastard (unverified [121.44.18.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	32660699-1927428
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 20:11:34 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OcFgx-0007Qw-0y
	for xfs@oss.sgi.com; Fri, 23 Jul 2010 20:41:23 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OcFgv-0000RW-Me
	for xfs@oss.sgi.com; Fri, 23 Jul 2010 20:41:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: wait on IO completion inside an IO context
Date: Fri, 23 Jul 2010 20:41:18 +1000
Message-Id: <1279881678-1660-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1279881678-1660-1-git-send-email-david@fromorbit.com>
References: <1279881678-1660-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

To wait while IOs drain from the inode while inside an ioend context, we have
to wait until the inode io count drops to 1 - the reference we hold - rather
than zero. Add functionality to the ioend wait subsystem to do this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   50 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.h          |   13 ++++++-----
 2 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 5682490..ec499f2 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -64,6 +64,9 @@ xfs_ioend_init(void)
 		init_waitqueue_head(&xfs_ioend_wq[i]);
 }
 
+/*
+ * wait for all IO to drain from the inode
+ */
 void
 xfs_ioend_wait(
 	xfs_inode_t	*ip)
@@ -73,12 +76,55 @@ xfs_ioend_wait(
 	wait_event(*wq, (atomic_read(&ip->i_iocount) == 0));
 }
 
+/*
+ * If we have an active ioend in the caller context (e.g.
+ * xfs_get_blocks_direct) we need to wait for the count to drop to one before
+ * we are woken.
+ *
+ * For this to work in the context of concurrent callers (concurrent direct IO),
+ * this function must be called with the iolock held exclusively to prevent
+ * other IOs blocking here and preventing the count from ever dropping to 1.
+ */
+STATIC void
+xfs_ioend_wait_excl(
+	xfs_inode_t	*ip)
+{
+	wait_queue_head_t *wq = to_ioend_wq(ip);
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	xfs_iflags_set(ip, XFS_IIOEND_WAIT_EXCL);
+	wait_event(*wq, (atomic_read(&ip->i_iocount) == 1));
+	xfs_iflags_clear(ip, XFS_IIOEND_WAIT_EXCL);
+}
+
 STATIC void
 xfs_ioend_wake(
 	xfs_inode_t	*ip)
 {
-	if (atomic_dec_and_test(&ip->i_iocount))
+	if (atomic_dec_and_test(&ip->i_iocount)) {
+		wake_up(to_ioend_wq(ip));
+		return;
+	}
+
+	/*
+	 * do an unlocked check for an exclusive wait before trying to get
+	 * spinlocks to avoid hurting the normal path too much. We can do this
+	 * check unlocked because if the flag is not set here and this is the
+	 * last IO remaining (i.e. iocount == 1 after the above decrement),
+	 * then any code that enters xfs_ioend_wait_excl() will now see that
+	 * i_iocount == 1 and return immediately. Hence we don't need to issue
+	 * a wakeup in this case, and it keeps the common case overhead as low
+	 * as possible.
+	 */
+	smp_rmb();
+	if (!__xfs_iflags_test(ip, XFS_IIOEND_WAIT_EXCL))
+		return;
+
+	spin_lock(&ip->i_flags_lock);
+	if (atomic_read(&ip->i_iocount) == 1 &&
+	    __xfs_iflags_test(ip, XFS_IIOEND_WAIT_EXCL))
 		wake_up(to_ioend_wq(ip));
+	spin_unlock(&ip->i_flags_lock);
 }
 
 void
@@ -1334,7 +1380,7 @@ remap:
 	    (flags & GET_BLOCKS_UNALIGNED) && !iolock_changed) {
 		xfs_iunlock(XFS_I(inode), XFS_IOLOCK_SHARED);
 		xfs_ilock(XFS_I(inode), XFS_IOLOCK_EXCL);
-		xfs_ioend_wait(XFS_I(inode));
+		xfs_ioend_wait_excl(XFS_I(inode));
 		iolock_changed = 1;
 		goto remap;
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0898c54..40b5203 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -357,12 +357,13 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
 /*
  * In-core inode flags.
  */
-#define XFS_IRECLAIM    0x0001  /* we have started reclaiming this inode    */
-#define XFS_ISTALE	0x0002	/* inode has been staled */
-#define XFS_IRECLAIMABLE 0x0004 /* inode can be reclaimed */
-#define XFS_INEW	0x0008	/* inode has just been allocated */
-#define XFS_IFILESTREAM	0x0010	/* inode is in a filestream directory */
-#define XFS_ITRUNCATED	0x0020	/* truncated down so flush-on-close */
+#define XFS_IRECLAIM		0x0001  /* have started reclaiming this inode */
+#define XFS_ISTALE		0x0002	/* inode has been staled */
+#define XFS_IRECLAIMABLE	0x0004	/* inode can be reclaimed */
+#define XFS_INEW		0x0008	/* inode has just been allocated */
+#define XFS_IFILESTREAM		0x0010	/* inode is in a filestream directory */
+#define XFS_ITRUNCATED		0x0020	/* truncated down so flush-on-close */
+#define XFS_IIOEND_WAIT_EXCL	0x0040	/* io completion waiter in io context */
 
 /*
  * Flags for inode locking.
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
