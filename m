Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UBxrY5192459 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 06:59:53 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	l5Vts5m6LFcbxZzC for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 05:00:44 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T73QE-0003ql-BX
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 22:00:30 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T73QE-0000l4-8C
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 22:00:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/13] xfs: move inode locking functions to xfs_inode.c
Date: Thu, 30 Aug 2012 22:00:16 +1000
Message-Id: <1346328017-2795-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-1-git-send-email-david@fromorbit.com>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
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

xfs_ilock() and friends really aren't related to the inode cache in
any way, so move them to xfs_inode.c with all the other inode
related functionality.

While doing this move, move the xfs_ilock() tracepoints to *before*
the lock is taken so that when a hang on a lock occurs we have
events to indicate which process and what inode we were trying to
lock when the hang occurred. This is much better than the current
silence we get on a hang...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iget.c  |  251 ----------------------------------------------------
 fs/xfs/xfs_inode.c |  250 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 250 insertions(+), 251 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 069c5ce..ea9a5fa 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -453,254 +453,3 @@ out_error_or_again:
 	return error;
 }
 
-/*
- * This is a wrapper routine around the xfs_ilock() routine
- * used to centralize some grungy code.  It is used in places
- * that wish to lock the inode solely for reading the extents.
- * The reason these places can't just call xfs_ilock(SHARED)
- * is that the inode lock also guards to bringing in of the
- * extents from disk for a file in b-tree format.  If the inode
- * is in b-tree format, then we need to lock the inode exclusively
- * until the extents are read in.  Locking it exclusively all
- * the time would limit our parallelism unnecessarily, though.
- * What we do instead is check to see if the extents have been
- * read in yet, and only lock the inode exclusively if they
- * have not.
- *
- * The function returns a value which should be given to the
- * corresponding xfs_iunlock_map_shared().  This value is
- * the mode in which the lock was actually taken.
- */
-uint
-xfs_ilock_map_shared(
-	xfs_inode_t	*ip)
-{
-	uint	lock_mode;
-
-	if ((ip->i_d.di_format == XFS_DINODE_FMT_BTREE) &&
-	    ((ip->i_df.if_flags & XFS_IFEXTENTS) == 0)) {
-		lock_mode = XFS_ILOCK_EXCL;
-	} else {
-		lock_mode = XFS_ILOCK_SHARED;
-	}
-
-	xfs_ilock(ip, lock_mode);
-
-	return lock_mode;
-}
-
-/*
- * This is simply the unlock routine to go with xfs_ilock_map_shared().
- * All it does is call xfs_iunlock() with the given lock_mode.
- */
-void
-xfs_iunlock_map_shared(
-	xfs_inode_t	*ip,
-	unsigned int	lock_mode)
-{
-	xfs_iunlock(ip, lock_mode);
-}
-
-/*
- * The xfs inode contains 2 locks: a multi-reader lock called the
- * i_iolock and a multi-reader lock called the i_lock.  This routine
- * allows either or both of the locks to be obtained.
- *
- * The 2 locks should always be ordered so that the IO lock is
- * obtained first in order to prevent deadlock.
- *
- * ip -- the inode being locked
- * lock_flags -- this parameter indicates the inode's locks
- *       to be locked.  It can be:
- *		XFS_IOLOCK_SHARED,
- *		XFS_IOLOCK_EXCL,
- *		XFS_ILOCK_SHARED,
- *		XFS_ILOCK_EXCL,
- *		XFS_IOLOCK_SHARED | XFS_ILOCK_SHARED,
- *		XFS_IOLOCK_SHARED | XFS_ILOCK_EXCL,
- *		XFS_IOLOCK_EXCL | XFS_ILOCK_SHARED,
- *		XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL
- */
-void
-xfs_ilock(
-	xfs_inode_t		*ip,
-	uint			lock_flags)
-{
-	/*
-	 * You can't set both SHARED and EXCL for the same lock,
-	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
-	 * and XFS_ILOCK_EXCL are valid values to set in lock_flags.
-	 */
-	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
-	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
-	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
-	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
-	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
-
-	if (lock_flags & XFS_IOLOCK_EXCL)
-		mrupdate_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
-	else if (lock_flags & XFS_IOLOCK_SHARED)
-		mraccess_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
-
-	if (lock_flags & XFS_ILOCK_EXCL)
-		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
-	else if (lock_flags & XFS_ILOCK_SHARED)
-		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
-
-	trace_xfs_ilock(ip, lock_flags, _RET_IP_);
-}
-
-/*
- * This is just like xfs_ilock(), except that the caller
- * is guaranteed not to sleep.  It returns 1 if it gets
- * the requested locks and 0 otherwise.  If the IO lock is
- * obtained but the inode lock cannot be, then the IO lock
- * is dropped before returning.
- *
- * ip -- the inode being locked
- * lock_flags -- this parameter indicates the inode's locks to be
- *       to be locked.  See the comment for xfs_ilock() for a list
- *	 of valid values.
- */
-int
-xfs_ilock_nowait(
-	xfs_inode_t		*ip,
-	uint			lock_flags)
-{
-	/*
-	 * You can't set both SHARED and EXCL for the same lock,
-	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
-	 * and XFS_ILOCK_EXCL are valid values to set in lock_flags.
-	 */
-	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
-	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
-	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
-	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
-	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
-
-	if (lock_flags & XFS_IOLOCK_EXCL) {
-		if (!mrtryupdate(&ip->i_iolock))
-			goto out;
-	} else if (lock_flags & XFS_IOLOCK_SHARED) {
-		if (!mrtryaccess(&ip->i_iolock))
-			goto out;
-	}
-	if (lock_flags & XFS_ILOCK_EXCL) {
-		if (!mrtryupdate(&ip->i_lock))
-			goto out_undo_iolock;
-	} else if (lock_flags & XFS_ILOCK_SHARED) {
-		if (!mrtryaccess(&ip->i_lock))
-			goto out_undo_iolock;
-	}
-	trace_xfs_ilock_nowait(ip, lock_flags, _RET_IP_);
-	return 1;
-
- out_undo_iolock:
-	if (lock_flags & XFS_IOLOCK_EXCL)
-		mrunlock_excl(&ip->i_iolock);
-	else if (lock_flags & XFS_IOLOCK_SHARED)
-		mrunlock_shared(&ip->i_iolock);
- out:
-	return 0;
-}
-
-/*
- * xfs_iunlock() is used to drop the inode locks acquired with
- * xfs_ilock() and xfs_ilock_nowait().  The caller must pass
- * in the flags given to xfs_ilock() or xfs_ilock_nowait() so
- * that we know which locks to drop.
- *
- * ip -- the inode being unlocked
- * lock_flags -- this parameter indicates the inode's locks to be
- *       to be unlocked.  See the comment for xfs_ilock() for a list
- *	 of valid values for this parameter.
- *
- */
-void
-xfs_iunlock(
-	xfs_inode_t		*ip,
-	uint			lock_flags)
-{
-	/*
-	 * You can't set both SHARED and EXCL for the same lock,
-	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
-	 * and XFS_ILOCK_EXCL are valid values to set in lock_flags.
-	 */
-	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
-	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
-	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
-	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
-	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
-	ASSERT(lock_flags != 0);
-
-	if (lock_flags & XFS_IOLOCK_EXCL)
-		mrunlock_excl(&ip->i_iolock);
-	else if (lock_flags & XFS_IOLOCK_SHARED)
-		mrunlock_shared(&ip->i_iolock);
-
-	if (lock_flags & XFS_ILOCK_EXCL)
-		mrunlock_excl(&ip->i_lock);
-	else if (lock_flags & XFS_ILOCK_SHARED)
-		mrunlock_shared(&ip->i_lock);
-
-	trace_xfs_iunlock(ip, lock_flags, _RET_IP_);
-}
-
-/*
- * give up write locks.  the i/o lock cannot be held nested
- * if it is being demoted.
- */
-void
-xfs_ilock_demote(
-	xfs_inode_t		*ip,
-	uint			lock_flags)
-{
-	ASSERT(lock_flags & (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL));
-	ASSERT((lock_flags & ~(XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
-
-	if (lock_flags & XFS_ILOCK_EXCL)
-		mrdemote(&ip->i_lock);
-	if (lock_flags & XFS_IOLOCK_EXCL)
-		mrdemote(&ip->i_iolock);
-
-	trace_xfs_ilock_demote(ip, lock_flags, _RET_IP_);
-}
-
-#ifdef DEBUG
-int
-xfs_isilocked(
-	xfs_inode_t		*ip,
-	uint			lock_flags)
-{
-	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
-		if (!(lock_flags & XFS_ILOCK_SHARED))
-			return !!ip->i_lock.mr_writer;
-		return rwsem_is_locked(&ip->i_lock.mr_lock);
-	}
-
-	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
-		if (!(lock_flags & XFS_IOLOCK_SHARED))
-			return !!ip->i_iolock.mr_writer;
-		return rwsem_is_locked(&ip->i_iolock.mr_lock);
-	}
-
-	ASSERT(0);
-	return 0;
-}
-#endif
-
-void
-__xfs_iflock(
-	struct xfs_inode	*ip)
-{
-	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IFLOCK_BIT);
-	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_IFLOCK_BIT);
-
-	do {
-		prepare_to_wait_exclusive(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
-		if (xfs_isiflocked(ip))
-			io_schedule();
-	} while (!xfs_iflock_nowait(ip));
-
-	finish_wait(wq, &wait.wait);
-}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2778258..ba404e4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -74,6 +74,256 @@ xfs_get_extsz_hint(
 	return 0;
 }
 
+/*
+ * This is a wrapper routine around the xfs_ilock() routine used to centralize
+ * some grungy code.  It is used in places that wish to lock the inode solely
+ * for reading the extents.  The reason these places can't just call
+ * xfs_ilock(SHARED) is that the inode lock also guards to bringing in of the
+ * extents from disk for a file in b-tree format.  If the inode is in b-tree
+ * format, then we need to lock the inode exclusively until the extents are read
+ * in.  Locking it exclusively all the time would limit our parallelism
+ * unnecessarily, though.  What we do instead is check to see if the extents
+ * have been read in yet, and only lock the inode exclusively if they have not.
+ *
+ * The function returns a value which should be given to the corresponding
+ * xfs_iunlock_map_shared().  This value is the mode in which the lock was
+ * actually taken.
+ */
+uint
+xfs_ilock_map_shared(
+	xfs_inode_t	*ip)
+{
+	uint	lock_mode;
+
+	if ((ip->i_d.di_format == XFS_DINODE_FMT_BTREE) &&
+	    ((ip->i_df.if_flags & XFS_IFEXTENTS) == 0)) {
+		lock_mode = XFS_ILOCK_EXCL;
+	} else {
+		lock_mode = XFS_ILOCK_SHARED;
+	}
+
+	xfs_ilock(ip, lock_mode);
+
+	return lock_mode;
+}
+
+/*
+ * This is simply the unlock routine to go with xfs_ilock_map_shared().
+ * All it does is call xfs_iunlock() with the given lock_mode.
+ */
+void
+xfs_iunlock_map_shared(
+	xfs_inode_t	*ip,
+	unsigned int	lock_mode)
+{
+	xfs_iunlock(ip, lock_mode);
+}
+
+/*
+ * The xfs inode contains 2 locks: a multi-reader lock called the
+ * i_iolock and a multi-reader lock called the i_lock.  This routine
+ * allows either or both of the locks to be obtained.
+ *
+ * The 2 locks should always be ordered so that the IO lock is
+ * obtained first in order to prevent deadlock.
+ *
+ * ip -- the inode being locked
+ * lock_flags -- this parameter indicates the inode's locks
+ *       to be locked.  It can be:
+ *		XFS_IOLOCK_SHARED,
+ *		XFS_IOLOCK_EXCL,
+ *		XFS_ILOCK_SHARED,
+ *		XFS_ILOCK_EXCL,
+ *		XFS_IOLOCK_SHARED | XFS_ILOCK_SHARED,
+ *		XFS_IOLOCK_SHARED | XFS_ILOCK_EXCL,
+ *		XFS_IOLOCK_EXCL | XFS_ILOCK_SHARED,
+ *		XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL
+ */
+void
+xfs_ilock(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
+{
+	trace_xfs_ilock(ip, lock_flags, _RET_IP_);
+
+	/*
+	 * You can't set both SHARED and EXCL for the same lock,
+	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
+	 * and XFS_ILOCK_EXCL are valid values to set in lock_flags.
+	 */
+	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
+	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
+	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
+	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
+
+	if (lock_flags & XFS_IOLOCK_EXCL)
+		mrupdate_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
+	else if (lock_flags & XFS_IOLOCK_SHARED)
+		mraccess_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
+
+	if (lock_flags & XFS_ILOCK_EXCL)
+		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
+	else if (lock_flags & XFS_ILOCK_SHARED)
+		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
+}
+
+/*
+ * This is just like xfs_ilock(), except that the caller
+ * is guaranteed not to sleep.  It returns 1 if it gets
+ * the requested locks and 0 otherwise.  If the IO lock is
+ * obtained but the inode lock cannot be, then the IO lock
+ * is dropped before returning.
+ *
+ * ip -- the inode being locked
+ * lock_flags -- this parameter indicates the inode's locks to be
+ *       to be locked.  See the comment for xfs_ilock() for a list
+ *	 of valid values.
+ */
+int
+xfs_ilock_nowait(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
+{
+	trace_xfs_ilock_nowait(ip, lock_flags, _RET_IP_);
+
+	/*
+	 * You can't set both SHARED and EXCL for the same lock,
+	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
+	 * and XFS_ILOCK_EXCL are valid values to set in lock_flags.
+	 */
+	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
+	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
+	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
+	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
+
+	if (lock_flags & XFS_IOLOCK_EXCL) {
+		if (!mrtryupdate(&ip->i_iolock))
+			goto out;
+	} else if (lock_flags & XFS_IOLOCK_SHARED) {
+		if (!mrtryaccess(&ip->i_iolock))
+			goto out;
+	}
+	if (lock_flags & XFS_ILOCK_EXCL) {
+		if (!mrtryupdate(&ip->i_lock))
+			goto out_undo_iolock;
+	} else if (lock_flags & XFS_ILOCK_SHARED) {
+		if (!mrtryaccess(&ip->i_lock))
+			goto out_undo_iolock;
+	}
+	return 1;
+
+ out_undo_iolock:
+	if (lock_flags & XFS_IOLOCK_EXCL)
+		mrunlock_excl(&ip->i_iolock);
+	else if (lock_flags & XFS_IOLOCK_SHARED)
+		mrunlock_shared(&ip->i_iolock);
+ out:
+	return 0;
+}
+
+/*
+ * xfs_iunlock() is used to drop the inode locks acquired with
+ * xfs_ilock() and xfs_ilock_nowait().  The caller must pass
+ * in the flags given to xfs_ilock() or xfs_ilock_nowait() so
+ * that we know which locks to drop.
+ *
+ * ip -- the inode being unlocked
+ * lock_flags -- this parameter indicates the inode's locks to be
+ *       to be unlocked.  See the comment for xfs_ilock() for a list
+ *	 of valid values for this parameter.
+ *
+ */
+void
+xfs_iunlock(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
+{
+	/*
+	 * You can't set both SHARED and EXCL for the same lock,
+	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
+	 * and XFS_ILOCK_EXCL are valid values to set in lock_flags.
+	 */
+	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
+	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
+	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
+	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
+	ASSERT(lock_flags != 0);
+
+	if (lock_flags & XFS_IOLOCK_EXCL)
+		mrunlock_excl(&ip->i_iolock);
+	else if (lock_flags & XFS_IOLOCK_SHARED)
+		mrunlock_shared(&ip->i_iolock);
+
+	if (lock_flags & XFS_ILOCK_EXCL)
+		mrunlock_excl(&ip->i_lock);
+	else if (lock_flags & XFS_ILOCK_SHARED)
+		mrunlock_shared(&ip->i_lock);
+
+	trace_xfs_iunlock(ip, lock_flags, _RET_IP_);
+}
+
+/*
+ * give up write locks.  the i/o lock cannot be held nested
+ * if it is being demoted.
+ */
+void
+xfs_ilock_demote(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
+{
+	ASSERT(lock_flags & (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL));
+	ASSERT((lock_flags & ~(XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
+
+	if (lock_flags & XFS_ILOCK_EXCL)
+		mrdemote(&ip->i_lock);
+	if (lock_flags & XFS_IOLOCK_EXCL)
+		mrdemote(&ip->i_iolock);
+
+	trace_xfs_ilock_demote(ip, lock_flags, _RET_IP_);
+}
+
+#ifdef DEBUG
+int
+xfs_isilocked(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
+{
+	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
+		if (!(lock_flags & XFS_ILOCK_SHARED))
+			return !!ip->i_lock.mr_writer;
+		return rwsem_is_locked(&ip->i_lock.mr_lock);
+	}
+
+	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
+		if (!(lock_flags & XFS_IOLOCK_SHARED))
+			return !!ip->i_iolock.mr_writer;
+		return rwsem_is_locked(&ip->i_iolock.mr_lock);
+	}
+
+	ASSERT(0);
+	return 0;
+}
+#endif
+
+void
+__xfs_iflock(
+	struct xfs_inode	*ip)
+{
+	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IFLOCK_BIT);
+	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_IFLOCK_BIT);
+
+	do {
+		prepare_to_wait_exclusive(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+		if (xfs_isiflocked(ip))
+			io_schedule();
+	} while (!xfs_iflock_nowait(ip));
+
+	finish_wait(wq, &wait.wait);
+}
+
 #ifdef DEBUG
 /*
  * Make sure that the extents in the given memory buffer
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
