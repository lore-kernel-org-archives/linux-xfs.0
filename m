Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EE5C77F67
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:23:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 77006304051
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:23:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7HzzDWYH8CpguPLk for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:23:44 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiDD-000173-L8
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:31 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiD3-00066P-HX
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 18/27] xfs: split out xfs inode operations into separate file
Date: Wed, 12 Jun 2013 20:22:38 +1000
Message-Id: <1371032567-21772-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1371032567-21772-1-git-send-email-david@fromorbit.com>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The core xfs inode operations such as locking, allocation, reading
and writing are not shared with userspace. However, much of the
remaining internal inode code such as the incore extent tracking and
formatting is. Split the XFS inode operations out into a new
xfs_inode_iops.c file to minimise the differences between the files
shred with userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile        |    1 +
 fs/xfs/xfs_inode.c     | 2295 ++++++------------------------------------------
 fs/xfs/xfs_inode.h     |  341 +------
 fs/xfs/xfs_inode_ops.c | 1772 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode_ops.h |  353 ++++++++
 5 files changed, 2418 insertions(+), 2344 deletions(-)
 create mode 100644 fs/xfs/xfs_inode_ops.c
 create mode 100644 fs/xfs/xfs_inode_ops.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6f33414..f372ed9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -42,6 +42,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_fsops.o \
 				   xfs_globals.o \
 				   xfs_icache.o \
+				   xfs_inode_ops.o \
 				   xfs_ioctl.o \
 				   xfs_iomap.o \
 				   xfs_iops.o \
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9ecfe1e..07fb510 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -51,281 +51,10 @@
 kmem_zone_t *xfs_ifork_zone;
 kmem_zone_t *xfs_inode_zone;
 
-/*
- * Used in xfs_itruncate_extents().  This is the maximum number of extents
- * freed from a file in a single transaction.
- */
-#define	XFS_ITRUNC_MAX_EXTENTS	2
-
-STATIC int xfs_iflush_int(xfs_inode_t *, xfs_buf_t *);
 STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
 STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
 STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
 
-/*
- * helper function to extract extent size hint from inode
- */
-xfs_extlen_t
-xfs_get_extsz_hint(
-	struct xfs_inode	*ip)
-{
-	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
-		return ip->i_d.di_extsize;
-	if (XFS_IS_REALTIME_INODE(ip))
-		return ip->i_mount->m_sb.sb_rextsize;
-	return 0;
-}
-
-/*
- * This is a wrapper routine around the xfs_ilock() routine used to centralize
- * some grungy code.  It is used in places that wish to lock the inode solely
- * for reading the extents.  The reason these places can't just call
- * xfs_ilock(SHARED) is that the inode lock also guards to bringing in of the
- * extents from disk for a file in b-tree format.  If the inode is in b-tree
- * format, then we need to lock the inode exclusively until the extents are read
- * in.  Locking it exclusively all the time would limit our parallelism
- * unnecessarily, though.  What we do instead is check to see if the extents
- * have been read in yet, and only lock the inode exclusively if they have not.
- *
- * The function returns a value which should be given to the corresponding
- * xfs_iunlock_map_shared().  This value is the mode in which the lock was
- * actually taken.
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
-	trace_xfs_ilock(ip, lock_flags, _RET_IP_);
-
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
-	trace_xfs_ilock_nowait(ip, lock_flags, _RET_IP_);
-
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
-#if defined(DEBUG) || defined(XFS_WARN)
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
-
 #ifdef DEBUG
 /*
  * Make sure that the extents in the given memory buffer
@@ -927,64 +656,6 @@ xfs_dinode_to_disk(
 	}
 }
 
-STATIC uint
-_xfs_dic2xflags(
-	__uint16_t		di_flags)
-{
-	uint			flags = 0;
-
-	if (di_flags & XFS_DIFLAG_ANY) {
-		if (di_flags & XFS_DIFLAG_REALTIME)
-			flags |= XFS_XFLAG_REALTIME;
-		if (di_flags & XFS_DIFLAG_PREALLOC)
-			flags |= XFS_XFLAG_PREALLOC;
-		if (di_flags & XFS_DIFLAG_IMMUTABLE)
-			flags |= XFS_XFLAG_IMMUTABLE;
-		if (di_flags & XFS_DIFLAG_APPEND)
-			flags |= XFS_XFLAG_APPEND;
-		if (di_flags & XFS_DIFLAG_SYNC)
-			flags |= XFS_XFLAG_SYNC;
-		if (di_flags & XFS_DIFLAG_NOATIME)
-			flags |= XFS_XFLAG_NOATIME;
-		if (di_flags & XFS_DIFLAG_NODUMP)
-			flags |= XFS_XFLAG_NODUMP;
-		if (di_flags & XFS_DIFLAG_RTINHERIT)
-			flags |= XFS_XFLAG_RTINHERIT;
-		if (di_flags & XFS_DIFLAG_PROJINHERIT)
-			flags |= XFS_XFLAG_PROJINHERIT;
-		if (di_flags & XFS_DIFLAG_NOSYMLINKS)
-			flags |= XFS_XFLAG_NOSYMLINKS;
-		if (di_flags & XFS_DIFLAG_EXTSIZE)
-			flags |= XFS_XFLAG_EXTSIZE;
-		if (di_flags & XFS_DIFLAG_EXTSZINHERIT)
-			flags |= XFS_XFLAG_EXTSZINHERIT;
-		if (di_flags & XFS_DIFLAG_NODEFRAG)
-			flags |= XFS_XFLAG_NODEFRAG;
-		if (di_flags & XFS_DIFLAG_FILESTREAM)
-			flags |= XFS_XFLAG_FILESTREAM;
-	}
-
-	return flags;
-}
-
-uint
-xfs_ip2xflags(
-	xfs_inode_t		*ip)
-{
-	xfs_icdinode_t		*dic = &ip->i_d;
-
-	return _xfs_dic2xflags(dic->di_flags) |
-				(XFS_IFORK_Q(ip) ? XFS_XFLAG_HASATTR : 0);
-}
-
-uint
-xfs_dic2xflags(
-	xfs_dinode_t		*dip)
-{
-	return _xfs_dic2xflags(be16_to_cpu(dip->di_flags)) |
-				(XFS_DFORK_Q(dip) ? XFS_XFLAG_HASATTR : 0);
-}
-
 static bool
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
@@ -1209,1018 +880,140 @@ xfs_iread_extents(
 }
 
 /*
- * Allocate an inode on disk and return a copy of its in-core version.
- * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
- * appropriately within the inode.  The uid and gid for the inode are
- * set according to the contents of the given cred structure.
- *
- * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
- * has a free inode available, call xfs_iget() to obtain the in-core
- * version of the allocated inode.  Finally, fill in the inode and
- * log its initial contents.  In this case, ialloc_context would be
- * set to NULL.
- *
- * If xfs_dialloc() does not have an available inode, it will replenish
- * its supply by doing an allocation. Since we can only do one
- * allocation within a transaction without deadlocks, we must commit
- * the current transaction before returning the inode itself.
- * In this case, therefore, we will set ialloc_context and return.
- * The caller should then commit the current transaction, start a new
- * transaction, and call xfs_ialloc() again to actually get the inode.
+ * Reallocate the space for if_broot based on the number of records
+ * being added or deleted as indicated in rec_diff.  Move the records
+ * and pointers in if_broot to fit the new size.  When shrinking this
+ * will eliminate holes between the records and pointers created by
+ * the caller.  When growing this will create holes to be filled in
+ * by the caller.
  *
- * To ensure that some other process does not grab the inode that
- * was allocated during the first call to xfs_ialloc(), this routine
- * also returns the [locked] bp pointing to the head of the freelist
- * as ialloc_context.  The caller should hold this buffer across
- * the commit and pass it back into this routine on the second call.
+ * The caller must not request to add more records than would fit in
+ * the on-disk inode root.  If the if_broot is currently NULL, then
+ * if we adding records one will be allocated.  The caller must also
+ * not request that the number of records go below zero, although
+ * it can go to zero.
  *
- * If we are allocating quota inodes, we do not have a parent inode
- * to attach to or associate with (i.e. pip == NULL) because they
- * are not linked into the directory structure - they are attached
- * directly to the superblock - and so have no parent.
+ * ip -- the inode whose if_broot area is changing
+ * ext_diff -- the change in the number of records, positive or negative,
+ *	 requested for the if_broot array.
  */
-int
-xfs_ialloc(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*pip,
-	umode_t		mode,
-	xfs_nlink_t	nlink,
-	xfs_dev_t	rdev,
-	prid_t		prid,
-	int		okalloc,
-	xfs_buf_t	**ialloc_context,
-	xfs_inode_t	**ipp)
+void
+xfs_iroot_realloc(
+	xfs_inode_t		*ip,
+	int			rec_diff,
+	int			whichfork)
 {
-	struct xfs_mount *mp = tp->t_mountp;
-	xfs_ino_t	ino;
-	xfs_inode_t	*ip;
-	uint		flags;
-	int		error;
-	timespec_t	tv;
-	int		filestreams = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			cur_max;
+	xfs_ifork_t		*ifp;
+	struct xfs_btree_block	*new_broot;
+	int			new_max;
+	size_t			new_size;
+	char			*np;
+	char			*op;
 
 	/*
-	 * Call the space management code to pick
-	 * the on-disk inode to be allocated.
+	 * Handle the degenerate case quietly.
 	 */
-	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode, okalloc,
-			    ialloc_context, &ino);
-	if (error)
-		return error;
-	if (*ialloc_context || ino == NULLFSINO) {
-		*ipp = NULL;
-		return 0;
+	if (rec_diff == 0) {
+		return;
 	}
-	ASSERT(*ialloc_context == NULL);
-
-	/*
-	 * Get the in-core inode with the lock held exclusively.
-	 * This is because we're setting fields here we need
-	 * to prevent others from looking at until we're done.
-	 */
-	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE,
-			 XFS_ILOCK_EXCL, &ip);
-	if (error)
-		return error;
-	ASSERT(ip != NULL);
 
-	ip->i_d.di_mode = mode;
-	ip->i_d.di_onlink = 0;
-	ip->i_d.di_nlink = nlink;
-	ASSERT(ip->i_d.di_nlink == nlink);
-	ip->i_d.di_uid = current_fsuid();
-	ip->i_d.di_gid = current_fsgid();
-	xfs_set_projid(ip, prid);
-	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
-
-	/*
-	 * If the superblock version is up to where we support new format
-	 * inodes and this is currently an old format inode, then change
-	 * the inode version number now.  This way we only do the conversion
-	 * here rather than here and in the flush/logging code.
-	 */
-	if (xfs_sb_version_hasnlink(&mp->m_sb) &&
-	    ip->i_d.di_version == 1) {
-		ip->i_d.di_version = 2;
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if (rec_diff > 0) {
 		/*
-		 * We've already zeroed the old link count, the projid field,
-		 * and the pad field.
+		 * If there wasn't any memory allocated before, just
+		 * allocate it now and get out.
 		 */
-	}
-
-	/*
-	 * Project ids won't be stored on disk if we are using a version 1 inode.
-	 */
-	if ((prid != 0) && (ip->i_d.di_version == 1))
-		xfs_bump_ino_vers2(tp, ip);
-
-	if (pip && XFS_INHERIT_GID(pip)) {
-		ip->i_d.di_gid = pip->i_d.di_gid;
-		if ((pip->i_d.di_mode & S_ISGID) && S_ISDIR(mode)) {
-			ip->i_d.di_mode |= S_ISGID;
+		if (ifp->if_broot_bytes == 0) {
+			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
+			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
+			ifp->if_broot_bytes = (int)new_size;
+			return;
 		}
-	}
 
-	/*
-	 * If the group ID of the new file does not match the effective group
-	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
-	 * (and only if the irix_sgid_inherit compatibility variable is set).
-	 */
-	if ((irix_sgid_inherit) &&
-	    (ip->i_d.di_mode & S_ISGID) &&
-	    (!in_group_p((gid_t)ip->i_d.di_gid))) {
-		ip->i_d.di_mode &= ~S_ISGID;
+		/*
+		 * If there is already an existing if_broot, then we need
+		 * to realloc() it and shift the pointers to their new
+		 * location.  The records don't change location because
+		 * they are kept butted up against the btree block header.
+		 */
+		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+		new_max = cur_max + rec_diff;
+		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
+		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
+				XFS_BMAP_BROOT_SPACE_CALC(mp, cur_max),
+				KM_SLEEP | KM_NOFS);
+		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
+						     ifp->if_broot_bytes);
+		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
+						     (int)new_size);
+		ifp->if_broot_bytes = (int)new_size;
+		ASSERT(ifp->if_broot_bytes <=
+			XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ(ip));
+		memmove(np, op, cur_max * (uint)sizeof(xfs_dfsbno_t));
+		return;
 	}
 
-	ip->i_d.di_size = 0;
-	ip->i_d.di_nextents = 0;
-	ASSERT(ip->i_d.di_nblocks == 0);
-
-	nanotime(&tv);
-	ip->i_d.di_mtime.t_sec = (__int32_t)tv.tv_sec;
-	ip->i_d.di_mtime.t_nsec = (__int32_t)tv.tv_nsec;
-	ip->i_d.di_atime = ip->i_d.di_mtime;
-	ip->i_d.di_ctime = ip->i_d.di_mtime;
-
 	/*
-	 * di_gen will have been taken care of in xfs_iread.
+	 * rec_diff is less than 0.  In this case, we are shrinking the
+	 * if_broot buffer.  It must already exist.  If we go to zero
+	 * records, just get rid of the root and clear the status bit.
 	 */
-	ip->i_d.di_extsize = 0;
-	ip->i_d.di_dmevmask = 0;
-	ip->i_d.di_dmstate = 0;
-	ip->i_d.di_flags = 0;
-
-	if (ip->i_d.di_version == 3) {
-		ASSERT(ip->i_d.di_ino == ino);
-		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid));
-		ip->i_d.di_crc = 0;
-		ip->i_d.di_changecount = 1;
-		ip->i_d.di_lsn = 0;
-		ip->i_d.di_flags2 = 0;
-		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
-		ip->i_d.di_crtime = ip->i_d.di_mtime;
-	}
-
-
-	flags = XFS_ILOG_CORE;
-	switch (mode & S_IFMT) {
-	case S_IFIFO:
-	case S_IFCHR:
-	case S_IFBLK:
-	case S_IFSOCK:
-		ip->i_d.di_format = XFS_DINODE_FMT_DEV;
-		ip->i_df.if_u2.if_rdev = rdev;
-		ip->i_df.if_flags = 0;
-		flags |= XFS_ILOG_DEV;
-		break;
-	case S_IFREG:
+	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
+	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+	new_max = cur_max + rec_diff;
+	ASSERT(new_max >= 0);
+	if (new_max > 0)
+		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
+	else
+		new_size = 0;
+	if (new_size > 0) {
+		new_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
 		/*
-		 * we can't set up filestreams until after the VFS inode
-		 * is set up properly.
+		 * First copy over the btree block header.
 		 */
-		if (pip && xfs_inode_is_filestream(pip))
-			filestreams = 1;
-		/* fall through */
-	case S_IFDIR:
-		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
-			uint	di_flags = 0;
-
-			if (S_ISDIR(mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
-					di_flags |= XFS_DIFLAG_RTINHERIT;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
-					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
-				}
-			} else if (S_ISREG(mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
-					di_flags |= XFS_DIFLAG_REALTIME;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
-					di_flags |= XFS_DIFLAG_EXTSIZE;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
-				}
-			}
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
-			    xfs_inherit_noatime)
-				di_flags |= XFS_DIFLAG_NOATIME;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NODUMP) &&
-			    xfs_inherit_nodump)
-				di_flags |= XFS_DIFLAG_NODUMP;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_SYNC) &&
-			    xfs_inherit_sync)
-				di_flags |= XFS_DIFLAG_SYNC;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) &&
-			    xfs_inherit_nosymlinks)
-				di_flags |= XFS_DIFLAG_NOSYMLINKS;
-			if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-				di_flags |= XFS_DIFLAG_PROJINHERIT;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
-			    xfs_inherit_nodefrag)
-				di_flags |= XFS_DIFLAG_NODEFRAG;
-			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
-				di_flags |= XFS_DIFLAG_FILESTREAM;
-			ip->i_d.di_flags |= di_flags;
-		}
-		/* FALLTHROUGH */
-	case S_IFLNK:
-		ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
-		ip->i_df.if_flags = XFS_IFEXTENTS;
-		ip->i_df.if_bytes = ip->i_df.if_real_bytes = 0;
-		ip->i_df.if_u1.if_extents = NULL;
-		break;
-	default:
-		ASSERT(0);
+		memcpy(new_broot, ifp->if_broot,
+			XFS_BMBT_BLOCK_LEN(ip->i_mount));
+	} else {
+		new_broot = NULL;
+		ifp->if_flags &= ~XFS_IFBROOT;
 	}
-	/*
-	 * Attribute fork settings for new inode.
-	 */
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
-	ip->i_d.di_anextents = 0;
 
 	/*
-	 * Log the new values stuffed into the inode.
+	 * Only copy the records and pointers if there are any.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, flags);
-
-	/* now that we have an i_mode we can setup inode ops and unlock */
-	xfs_setup_inode(ip);
+	if (new_max > 0) {
+		/*
+		 * First copy the records.
+		 */
+		op = (char *)XFS_BMBT_REC_ADDR(mp, ifp->if_broot, 1);
+		np = (char *)XFS_BMBT_REC_ADDR(mp, new_broot, 1);
+		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_rec_t));
 
-	/* now we have set up the vfs inode we can associate the filestream */
-	if (filestreams) {
-		error = xfs_filestream_associate(pip, ip);
-		if (error < 0)
-			return -error;
-		if (!error)
-			xfs_iflags_set(ip, XFS_IFILESTREAM);
+		/*
+		 * Then copy the pointers.
+		 */
+		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
+						     ifp->if_broot_bytes);
+		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, new_broot, 1,
+						     (int)new_size);
+		memcpy(np, op, new_max * (uint)sizeof(xfs_dfsbno_t));
 	}
-
-	*ipp = ip;
-	return 0;
+	kmem_free(ifp->if_broot);
+	ifp->if_broot = new_broot;
+	ifp->if_broot_bytes = (int)new_size;
+	ASSERT(ifp->if_broot_bytes <=
+		XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ(ip));
+	return;
 }
 
+
 /*
- * Free up the underlying blocks past new_size.  The new size must be smaller
- * than the current size.  This routine can be used both for the attribute and
- * data fork, and does not modify the inode size, which is left to the caller.
- *
- * The transaction passed to this routine must have made a permanent log
- * reservation of at least XFS_ITRUNCATE_LOG_RES.  This routine may commit the
- * given transaction and start new ones, so make sure everything involved in
- * the transaction is tidy before calling here.  Some transaction will be
- * returned to the caller to be committed.  The incoming transaction must
- * already include the inode, and both inode locks must be held exclusively.
- * The inode must also be "held" within the transaction.  On return the inode
- * will be "held" within the returned transaction.  This routine does NOT
- * require any disk space to be reserved for it within the transaction.
- *
- * If we get an error, we must return with the inode locked and linked into the
- * current transaction. This keeps things simple for the higher level code,
- * because it always knows that the inode is locked and held in the transaction
- * that returns to it whether errors occur or not.  We don't mark the inode
- * dirty on error so that transactions can be easily aborted if possible.
- */
-int
-xfs_itruncate_extents(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*ip,
-	int			whichfork,
-	xfs_fsize_t		new_size)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp = *tpp;
-	struct xfs_trans	*ntp;
-	xfs_bmap_free_t		free_list;
-	xfs_fsblock_t		first_block;
-	xfs_fileoff_t		first_unmap_block;
-	xfs_fileoff_t		last_block;
-	xfs_filblks_t		unmap_len;
-	int			committed;
-	int			error = 0;
-	int			done = 0;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
-	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
-	ASSERT(new_size <= XFS_ISIZE(ip));
-	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
-	ASSERT(ip->i_itemp != NULL);
-	ASSERT(ip->i_itemp->ili_lock_flags == 0);
-	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
-
-	trace_xfs_itruncate_extents_start(ip, new_size);
-
-	/*
-	 * Since it is possible for space to become allocated beyond
-	 * the end of the file (in a crash where the space is allocated
-	 * but the inode size is not yet updated), simply remove any
-	 * blocks which show up between the new EOF and the maximum
-	 * possible file size.  If the first block to be removed is
-	 * beyond the maximum file size (ie it is the same as last_block),
-	 * then there is nothing to do.
-	 */
-	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-	if (first_unmap_block == last_block)
-		return 0;
-
-	ASSERT(first_unmap_block < last_block);
-	unmap_len = last_block - first_unmap_block + 1;
-	while (!done) {
-		xfs_bmap_init(&free_list, &first_block);
-		error = xfs_bunmapi(tp, ip,
-				    first_unmap_block, unmap_len,
-				    xfs_bmapi_aflag(whichfork),
-				    XFS_ITRUNC_MAX_EXTENTS,
-				    &first_block, &free_list,
-				    &done);
-		if (error)
-			goto out_bmap_cancel;
-
-		/*
-		 * Duplicate the transaction that has the permanent
-		 * reservation and commit the old transaction.
-		 */
-		error = xfs_bmap_finish(&tp, &free_list, &committed);
-		if (committed)
-			xfs_trans_ijoin(tp, ip, 0);
-		if (error)
-			goto out_bmap_cancel;
-
-		if (committed) {
-			/*
-			 * Mark the inode dirty so it will be logged and
-			 * moved forward in the log as part of every commit.
-			 */
-			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		}
-
-		ntp = xfs_trans_dup(tp);
-		error = xfs_trans_commit(tp, 0);
-		tp = ntp;
-
-		xfs_trans_ijoin(tp, ip, 0);
-
-		if (error)
-			goto out;
-
-		/*
-		 * Transaction commit worked ok so we can drop the extra ticket
-		 * reference that we gained in xfs_trans_dup()
-		 */
-		xfs_log_ticket_put(tp->t_ticket);
-		error = xfs_trans_reserve(tp, 0,
-					XFS_ITRUNCATE_LOG_RES(mp), 0,
-					XFS_TRANS_PERM_LOG_RES,
-					XFS_ITRUNCATE_LOG_COUNT);
-		if (error)
-			goto out;
-	}
-
-	/*
-	 * Always re-log the inode so that our permanent transaction can keep
-	 * on rolling it forward in the log.
-	 */
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	trace_xfs_itruncate_extents_end(ip, new_size);
-
-out:
-	*tpp = tp;
-	return error;
-out_bmap_cancel:
-	/*
-	 * If the bunmapi call encounters an error, return to the caller where
-	 * the transaction can be properly aborted.  We just need to make sure
-	 * we're not holding any resources that we were not when we came in.
-	 */
-	xfs_bmap_cancel(&free_list);
-	goto out;
-}
-
-/*
- * This is called when the inode's link count goes to 0.
- * We place the on-disk inode on a list in the AGI.  It
- * will be pulled from this list when the inode is freed.
- */
-int
-xfs_iunlink(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip)
-{
-	xfs_mount_t	*mp;
-	xfs_agi_t	*agi;
-	xfs_dinode_t	*dip;
-	xfs_buf_t	*agibp;
-	xfs_buf_t	*ibp;
-	xfs_agino_t	agino;
-	short		bucket_index;
-	int		offset;
-	int		error;
-
-	ASSERT(ip->i_d.di_nlink == 0);
-	ASSERT(ip->i_d.di_mode != 0);
-
-	mp = tp->t_mountp;
-
-	/*
-	 * Get the agi buffer first.  It ensures lock ordering
-	 * on the list.
-	 */
-	error = xfs_read_agi(mp, tp, XFS_INO_TO_AGNO(mp, ip->i_ino), &agibp);
-	if (error)
-		return error;
-	agi = XFS_BUF_TO_AGI(agibp);
-
-	/*
-	 * Get the index into the agi hash table for the
-	 * list this inode will go on.
-	 */
-	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	ASSERT(agino != 0);
-	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	ASSERT(agi->agi_unlinked[bucket_index]);
-	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
-
-	if (agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO)) {
-		/*
-		 * There is already another inode in the bucket we need
-		 * to add ourselves to.  Add us at the front of the list.
-		 * Here we put the head pointer into our next pointer,
-		 * and then we fall through to point the head at us.
-		 */
-		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
-				       0, 0);
-		if (error)
-			return error;
-
-		ASSERT(dip->di_next_unlinked == cpu_to_be32(NULLAGINO));
-		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
-		offset = ip->i_imap.im_boffset +
-			offsetof(xfs_dinode_t, di_next_unlinked);
-
-		/* need to recalc the inode CRC if appropriate */
-		xfs_dinode_calc_crc(mp, dip);
-
-		xfs_trans_inode_buf(tp, ibp);
-		xfs_trans_log_buf(tp, ibp, offset,
-				  (offset + sizeof(xfs_agino_t) - 1));
-		xfs_inobp_check(mp, ibp);
-	}
-
-	/*
-	 * Point the bucket head pointer at the inode being inserted.
-	 */
-	ASSERT(agino != 0);
-	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
-	offset = offsetof(xfs_agi_t, agi_unlinked) +
-		(sizeof(xfs_agino_t) * bucket_index);
-	xfs_trans_log_buf(tp, agibp, offset,
-			  (offset + sizeof(xfs_agino_t) - 1));
-	return 0;
-}
-
-/*
- * Pull the on-disk inode from the AGI unlinked list.
- */
-STATIC int
-xfs_iunlink_remove(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip)
-{
-	xfs_ino_t	next_ino;
-	xfs_mount_t	*mp;
-	xfs_agi_t	*agi;
-	xfs_dinode_t	*dip;
-	xfs_buf_t	*agibp;
-	xfs_buf_t	*ibp;
-	xfs_agnumber_t	agno;
-	xfs_agino_t	agino;
-	xfs_agino_t	next_agino;
-	xfs_buf_t	*last_ibp;
-	xfs_dinode_t	*last_dip = NULL;
-	short		bucket_index;
-	int		offset, last_offset = 0;
-	int		error;
-
-	mp = tp->t_mountp;
-	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
-
-	/*
-	 * Get the agi buffer first.  It ensures lock ordering
-	 * on the list.
-	 */
-	error = xfs_read_agi(mp, tp, agno, &agibp);
-	if (error)
-		return error;
-
-	agi = XFS_BUF_TO_AGI(agibp);
-
-	/*
-	 * Get the index into the agi hash table for the
-	 * list this inode will go on.
-	 */
-	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	ASSERT(agino != 0);
-	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	ASSERT(agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO));
-	ASSERT(agi->agi_unlinked[bucket_index]);
-
-	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
-		/*
-		 * We're at the head of the list.  Get the inode's on-disk
-		 * buffer to see if there is anyone after us on the list.
-		 * Only modify our next pointer if it is not already NULLAGINO.
-		 * This saves us the overhead of dealing with the buffer when
-		 * there is no need to change it.
-		 */
-		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
-				       0, 0);
-		if (error) {
-			xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
-				__func__, error);
-			return error;
-		}
-		next_agino = be32_to_cpu(dip->di_next_unlinked);
-		ASSERT(next_agino != 0);
-		if (next_agino != NULLAGINO) {
-			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
-			offset = ip->i_imap.im_boffset +
-				offsetof(xfs_dinode_t, di_next_unlinked);
-
-			/* need to recalc the inode CRC if appropriate */
-			xfs_dinode_calc_crc(mp, dip);
-
-			xfs_trans_inode_buf(tp, ibp);
-			xfs_trans_log_buf(tp, ibp, offset,
-					  (offset + sizeof(xfs_agino_t) - 1));
-			xfs_inobp_check(mp, ibp);
-		} else {
-			xfs_trans_brelse(tp, ibp);
-		}
-		/*
-		 * Point the bucket head pointer at the next inode.
-		 */
-		ASSERT(next_agino != 0);
-		ASSERT(next_agino != agino);
-		agi->agi_unlinked[bucket_index] = cpu_to_be32(next_agino);
-		offset = offsetof(xfs_agi_t, agi_unlinked) +
-			(sizeof(xfs_agino_t) * bucket_index);
-		xfs_trans_log_buf(tp, agibp, offset,
-				  (offset + sizeof(xfs_agino_t) - 1));
-	} else {
-		/*
-		 * We need to search the list for the inode being freed.
-		 */
-		next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-		last_ibp = NULL;
-		while (next_agino != agino) {
-			struct xfs_imap	imap;
-
-			if (last_ibp)
-				xfs_trans_brelse(tp, last_ibp);
-
-			imap.im_blkno = 0;
-			next_ino = XFS_AGINO_TO_INO(mp, agno, next_agino);
-
-			error = xfs_imap(mp, tp, next_ino, &imap, 0);
-			if (error) {
-				xfs_warn(mp,
-	"%s: xfs_imap returned error %d.",
-					 __func__, error);
-				return error;
-			}
-
-			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
-					       &last_ibp, 0, 0);
-			if (error) {
-				xfs_warn(mp,
-	"%s: xfs_imap_to_bp returned error %d.",
-					__func__, error);
-				return error;
-			}
-
-			last_offset = imap.im_boffset;
-			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
-			ASSERT(next_agino != NULLAGINO);
-			ASSERT(next_agino != 0);
-		}
-
-		/*
-		 * Now last_ibp points to the buffer previous to us on the
-		 * unlinked list.  Pull us from the list.
-		 */
-		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
-				       0, 0);
-		if (error) {
-			xfs_warn(mp, "%s: xfs_imap_to_bp(2) returned error %d.",
-				__func__, error);
-			return error;
-		}
-		next_agino = be32_to_cpu(dip->di_next_unlinked);
-		ASSERT(next_agino != 0);
-		ASSERT(next_agino != agino);
-		if (next_agino != NULLAGINO) {
-			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
-			offset = ip->i_imap.im_boffset +
-				offsetof(xfs_dinode_t, di_next_unlinked);
-
-			/* need to recalc the inode CRC if appropriate */
-			xfs_dinode_calc_crc(mp, dip);
-
-			xfs_trans_inode_buf(tp, ibp);
-			xfs_trans_log_buf(tp, ibp, offset,
-					  (offset + sizeof(xfs_agino_t) - 1));
-			xfs_inobp_check(mp, ibp);
-		} else {
-			xfs_trans_brelse(tp, ibp);
-		}
-		/*
-		 * Point the previous inode on the list to the next inode.
-		 */
-		last_dip->di_next_unlinked = cpu_to_be32(next_agino);
-		ASSERT(next_agino != 0);
-		offset = last_offset + offsetof(xfs_dinode_t, di_next_unlinked);
-
-		/* need to recalc the inode CRC if appropriate */
-		xfs_dinode_calc_crc(mp, last_dip);
-
-		xfs_trans_inode_buf(tp, last_ibp);
-		xfs_trans_log_buf(tp, last_ibp, offset,
-				  (offset + sizeof(xfs_agino_t) - 1));
-		xfs_inobp_check(mp, last_ibp);
-	}
-	return 0;
-}
-
-/*
- * A big issue when freeing the inode cluster is is that we _cannot_ skip any
- * inodes that are in memory - they all must be marked stale and attached to
- * the cluster buffer.
- */
-STATIC int
-xfs_ifree_cluster(
-	xfs_inode_t	*free_ip,
-	xfs_trans_t	*tp,
-	xfs_ino_t	inum)
-{
-	xfs_mount_t		*mp = free_ip->i_mount;
-	int			blks_per_cluster;
-	int			nbufs;
-	int			ninodes;
-	int			i, j;
-	xfs_daddr_t		blkno;
-	xfs_buf_t		*bp;
-	xfs_inode_t		*ip;
-	xfs_inode_log_item_t	*iip;
-	xfs_log_item_t		*lip;
-	struct xfs_perag	*pag;
-
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
-	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
-		blks_per_cluster = 1;
-		ninodes = mp->m_sb.sb_inopblock;
-		nbufs = XFS_IALLOC_BLOCKS(mp);
-	} else {
-		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) /
-					mp->m_sb.sb_blocksize;
-		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
-		nbufs = XFS_IALLOC_BLOCKS(mp) / blks_per_cluster;
-	}
-
-	for (j = 0; j < nbufs; j++, inum += ninodes) {
-		blkno = XFS_AGB_TO_DADDR(mp, XFS_INO_TO_AGNO(mp, inum),
-					 XFS_INO_TO_AGBNO(mp, inum));
-
-		/*
-		 * We obtain and lock the backing buffer first in the process
-		 * here, as we have to ensure that any dirty inode that we
-		 * can't get the flush lock on is attached to the buffer.
-		 * If we scan the in-memory inodes first, then buffer IO can
-		 * complete before we get a lock on it, and hence we may fail
-		 * to mark all the active inodes on the buffer stale.
-		 */
-		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
-					mp->m_bsize * blks_per_cluster,
-					XBF_UNMAPPED);
-
-		if (!bp)
-			return ENOMEM;
-
-		/*
-		 * This buffer may not have been correctly initialised as we
-		 * didn't read it from disk. That's not important because we are
-		 * only using to mark the buffer as stale in the log, and to
-		 * attach stale cached inodes on it. That means it will never be
-		 * dispatched for IO. If it is, we want to know about it, and we
-		 * want it to fail. We can acheive this by adding a write
-		 * verifier to the buffer.
-		 */
-		 bp->b_ops = &xfs_inode_buf_ops;
-
-		/*
-		 * Walk the inodes already attached to the buffer and mark them
-		 * stale. These will all have the flush locks held, so an
-		 * in-memory inode walk can't lock them. By marking them all
-		 * stale first, we will not attempt to lock them in the loop
-		 * below as the XFS_ISTALE flag will be set.
-		 */
-		lip = bp->b_fspriv;
-		while (lip) {
-			if (lip->li_type == XFS_LI_INODE) {
-				iip = (xfs_inode_log_item_t *)lip;
-				ASSERT(iip->ili_logged == 1);
-				lip->li_cb = xfs_istale_done;
-				xfs_trans_ail_copy_lsn(mp->m_ail,
-							&iip->ili_flush_lsn,
-							&iip->ili_item.li_lsn);
-				xfs_iflags_set(iip->ili_inode, XFS_ISTALE);
-			}
-			lip = lip->li_bio_list;
-		}
-
-
-		/*
-		 * For each inode in memory attempt to add it to the inode
-		 * buffer and set it up for being staled on buffer IO
-		 * completion.  This is safe as we've locked out tail pushing
-		 * and flushing by locking the buffer.
-		 *
-		 * We have already marked every inode that was part of a
-		 * transaction stale above, which means there is no point in
-		 * even trying to lock them.
-		 */
-		for (i = 0; i < ninodes; i++) {
-retry:
-			rcu_read_lock();
-			ip = radix_tree_lookup(&pag->pag_ici_root,
-					XFS_INO_TO_AGINO(mp, (inum + i)));
-
-			/* Inode not in memory, nothing to do */
-			if (!ip) {
-				rcu_read_unlock();
-				continue;
-			}
-
-			/*
-			 * because this is an RCU protected lookup, we could
-			 * find a recently freed or even reallocated inode
-			 * during the lookup. We need to check under the
-			 * i_flags_lock for a valid inode here. Skip it if it
-			 * is not valid, the wrong inode or stale.
-			 */
-			spin_lock(&ip->i_flags_lock);
-			if (ip->i_ino != inum + i ||
-			    __xfs_iflags_test(ip, XFS_ISTALE)) {
-				spin_unlock(&ip->i_flags_lock);
-				rcu_read_unlock();
-				continue;
-			}
-			spin_unlock(&ip->i_flags_lock);
-
-			/*
-			 * Don't try to lock/unlock the current inode, but we
-			 * _cannot_ skip the other inodes that we did not find
-			 * in the list attached to the buffer and are not
-			 * already marked stale. If we can't lock it, back off
-			 * and retry.
-			 */
-			if (ip != free_ip &&
-			    !xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
-				rcu_read_unlock();
-				delay(1);
-				goto retry;
-			}
-			rcu_read_unlock();
-
-			xfs_iflock(ip);
-			xfs_iflags_set(ip, XFS_ISTALE);
-
-			/*
-			 * we don't need to attach clean inodes or those only
-			 * with unlogged changes (which we throw away, anyway).
-			 */
-			iip = ip->i_itemp;
-			if (!iip || xfs_inode_clean(ip)) {
-				ASSERT(ip != free_ip);
-				xfs_ifunlock(ip);
-				xfs_iunlock(ip, XFS_ILOCK_EXCL);
-				continue;
-			}
-
-			iip->ili_last_fields = iip->ili_fields;
-			iip->ili_fields = 0;
-			iip->ili_logged = 1;
-			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
-						&iip->ili_item.li_lsn);
-
-			xfs_buf_attach_iodone(bp, xfs_istale_done,
-						  &iip->ili_item);
-
-			if (ip != free_ip)
-				xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		}
-
-		xfs_trans_stale_inode_buf(tp, bp);
-		xfs_trans_binval(tp, bp);
-	}
-
-	xfs_perag_put(pag);
-	return 0;
-}
-
-/*
- * This is called to return an inode to the inode free list.
- * The inode should already be truncated to 0 length and have
- * no pages associated with it.  This routine also assumes that
- * the inode is already a part of the transaction.
- *
- * The on-disk copy of the inode will have been added to the list
- * of unlinked inodes in the AGI. We need to remove the inode from
- * that list atomically with respect to freeing it here.
- */
-int
-xfs_ifree(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	xfs_bmap_free_t	*flist)
-{
-	int			error;
-	int			delete;
-	xfs_ino_t		first_ino;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(ip->i_d.di_nlink == 0);
-	ASSERT(ip->i_d.di_nextents == 0);
-	ASSERT(ip->i_d.di_anextents == 0);
-	ASSERT(ip->i_d.di_size == 0 || !S_ISREG(ip->i_d.di_mode));
-	ASSERT(ip->i_d.di_nblocks == 0);
-
-	/*
-	 * Pull the on-disk inode from the AGI unlinked list.
-	 */
-	error = xfs_iunlink_remove(tp, ip);
-	if (error)
-		return error;
-
-	error = xfs_difree(tp, ip->i_ino, flist, &delete, &first_ino);
-	if (error)
-		return error;
-
-	ip->i_d.di_mode = 0;		/* mark incore inode as free */
-	ip->i_d.di_flags = 0;
-	ip->i_d.di_dmevmask = 0;
-	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
-	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
-	/*
-	 * Bump the generation count so no one will be confused
-	 * by reincarnations of this inode.
-	 */
-	ip->i_d.di_gen++;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	if (delete)
-		error = xfs_ifree_cluster(ip, tp, first_ino);
-
-	return error;
-}
-
-/*
- * Reallocate the space for if_broot based on the number of records
- * being added or deleted as indicated in rec_diff.  Move the records
- * and pointers in if_broot to fit the new size.  When shrinking this
- * will eliminate holes between the records and pointers created by
- * the caller.  When growing this will create holes to be filled in
- * by the caller.
- *
- * The caller must not request to add more records than would fit in
- * the on-disk inode root.  If the if_broot is currently NULL, then
- * if we adding records one will be allocated.  The caller must also
- * not request that the number of records go below zero, although
- * it can go to zero.
- *
- * ip -- the inode whose if_broot area is changing
- * ext_diff -- the change in the number of records, positive or negative,
- *	 requested for the if_broot array.
- */
-void
-xfs_iroot_realloc(
-	xfs_inode_t		*ip,
-	int			rec_diff,
-	int			whichfork)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	int			cur_max;
-	xfs_ifork_t		*ifp;
-	struct xfs_btree_block	*new_broot;
-	int			new_max;
-	size_t			new_size;
-	char			*np;
-	char			*op;
-
-	/*
-	 * Handle the degenerate case quietly.
-	 */
-	if (rec_diff == 0) {
-		return;
-	}
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (rec_diff > 0) {
-		/*
-		 * If there wasn't any memory allocated before, just
-		 * allocate it now and get out.
-		 */
-		if (ifp->if_broot_bytes == 0) {
-			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
-			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
-			ifp->if_broot_bytes = (int)new_size;
-			return;
-		}
-
-		/*
-		 * If there is already an existing if_broot, then we need
-		 * to realloc() it and shift the pointers to their new
-		 * location.  The records don't change location because
-		 * they are kept butted up against the btree block header.
-		 */
-		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
-		new_max = cur_max + rec_diff;
-		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
-		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
-				XFS_BMAP_BROOT_SPACE_CALC(mp, cur_max),
-				KM_SLEEP | KM_NOFS);
-		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
-						     ifp->if_broot_bytes);
-		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
-						     (int)new_size);
-		ifp->if_broot_bytes = (int)new_size;
-		ASSERT(ifp->if_broot_bytes <=
-			XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ(ip));
-		memmove(np, op, cur_max * (uint)sizeof(xfs_dfsbno_t));
-		return;
-	}
-
-	/*
-	 * rec_diff is less than 0.  In this case, we are shrinking the
-	 * if_broot buffer.  It must already exist.  If we go to zero
-	 * records, just get rid of the root and clear the status bit.
-	 */
-	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
-	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
-	new_max = cur_max + rec_diff;
-	ASSERT(new_max >= 0);
-	if (new_max > 0)
-		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
-	else
-		new_size = 0;
-	if (new_size > 0) {
-		new_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
-		/*
-		 * First copy over the btree block header.
-		 */
-		memcpy(new_broot, ifp->if_broot,
-			XFS_BMBT_BLOCK_LEN(ip->i_mount));
-	} else {
-		new_broot = NULL;
-		ifp->if_flags &= ~XFS_IFBROOT;
-	}
-
-	/*
-	 * Only copy the records and pointers if there are any.
-	 */
-	if (new_max > 0) {
-		/*
-		 * First copy the records.
-		 */
-		op = (char *)XFS_BMBT_REC_ADDR(mp, ifp->if_broot, 1);
-		np = (char *)XFS_BMBT_REC_ADDR(mp, new_broot, 1);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_rec_t));
-
-		/*
-		 * Then copy the pointers.
-		 */
-		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
-						     ifp->if_broot_bytes);
-		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, new_broot, 1,
-						     (int)new_size);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_dfsbno_t));
-	}
-	kmem_free(ifp->if_broot);
-	ifp->if_broot = new_broot;
-	ifp->if_broot_bytes = (int)new_size;
-	ASSERT(ifp->if_broot_bytes <=
-		XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ(ip));
-	return;
-}
-
-
-/*
- * This is called when the amount of space needed for if_data
- * is increased or decreased.  The change in size is indicated by
- * the number of bytes that need to be added or deleted in the
- * byte_diff parameter.
+ * This is called when the amount of space needed for if_data
+ * is increased or decreased.  The change in size is indicated by
+ * the number of bytes that need to be added or deleted in the
+ * byte_diff parameter.
  *
  * If the amount of space needed has decreased below the size of the
  * inline buffer, then switch to using the inline buffer.  Otherwise,
@@ -2339,59 +1132,16 @@ xfs_idestroy_fork(
 		   ((ifp->if_flags & XFS_IFEXTIREC) ||
 		    ((ifp->if_u1.if_extents != NULL) &&
 		     (ifp->if_u1.if_extents != ifp->if_u2.if_inline_ext)))) {
-		ASSERT(ifp->if_real_bytes != 0);
-		xfs_iext_destroy(ifp);
-	}
-	ASSERT(ifp->if_u1.if_extents == NULL ||
-	       ifp->if_u1.if_extents == ifp->if_u2.if_inline_ext);
-	ASSERT(ifp->if_real_bytes == 0);
-	if (whichfork == XFS_ATTR_FORK) {
-		kmem_zone_free(xfs_ifork_zone, ip->i_afp);
-		ip->i_afp = NULL;
-	}
-}
-
-/*
- * This is called to unpin an inode.  The caller must have the inode locked
- * in at least shared mode so that the buffer cannot be subsequently pinned
- * once someone is waiting for it to be unpinned.
- */
-static void
-xfs_iunpin(
-	struct xfs_inode	*ip)
-{
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-
-	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
-
-	/* Give the log a push to start the unpinning I/O */
-	xfs_log_force_lsn(ip->i_mount, ip->i_itemp->ili_last_lsn, 0);
-
-}
-
-static void
-__xfs_iunpin_wait(
-	struct xfs_inode	*ip)
-{
-	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IPINNED_BIT);
-	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_IPINNED_BIT);
-
-	xfs_iunpin(ip);
-
-	do {
-		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
-		if (xfs_ipincount(ip))
-			io_schedule();
-	} while (xfs_ipincount(ip));
-	finish_wait(wq, &wait.wait);
-}
-
-void
-xfs_iunpin_wait(
-	struct xfs_inode	*ip)
-{
-	if (xfs_ipincount(ip))
-		__xfs_iunpin_wait(ip);
+		ASSERT(ifp->if_real_bytes != 0);
+		xfs_iext_destroy(ifp);
+	}
+	ASSERT(ifp->if_u1.if_extents == NULL ||
+	       ifp->if_u1.if_extents == ifp->if_u2.if_inline_ext);
+	ASSERT(ifp->if_real_bytes == 0);
+	if (whichfork == XFS_ATTR_FORK) {
+		kmem_zone_free(xfs_ifork_zone, ip->i_afp);
+		ip->i_afp = NULL;
+	}
 }
 
 /*
@@ -2428,568 +1178,128 @@ xfs_iextents_copy(
 	/*
 	 * There are some delayed allocation extents in the
 	 * inode, so copy the extents one at a time and skip
-	 * the delayed ones.  There must be at least one
-	 * non-delayed extent.
-	 */
-	copied = 0;
-	for (i = 0; i < nrecs; i++) {
-		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
-		start_block = xfs_bmbt_get_startblock(ep);
-		if (isnullstartblock(start_block)) {
-			/*
-			 * It's a delayed allocation extent, so skip it.
-			 */
-			continue;
-		}
-
-		/* Translate to on disk format */
-		put_unaligned(cpu_to_be64(ep->l0), &dp->l0);
-		put_unaligned(cpu_to_be64(ep->l1), &dp->l1);
-		dp++;
-		copied++;
-	}
-	ASSERT(copied != 0);
-	xfs_validate_extents(ifp, copied, XFS_EXTFMT_INODE(ip));
-
-	return (copied * (uint)sizeof(xfs_bmbt_rec_t));
-}
-
-/*
- * Each of the following cases stores data into the same region
- * of the on-disk inode, so only one of them can be valid at
- * any given time. While it is possible to have conflicting formats
- * and log flags, e.g. having XFS_ILOG_?DATA set when the fork is
- * in EXTENTS format, this can only happen when the fork has
- * changed formats after being modified but before being flushed.
- * In these cases, the format always takes precedence, because the
- * format indicates the current state of the fork.
- */
-/*ARGSUSED*/
-STATIC void
-xfs_iflush_fork(
-	xfs_inode_t		*ip,
-	xfs_dinode_t		*dip,
-	xfs_inode_log_item_t	*iip,
-	int			whichfork,
-	xfs_buf_t		*bp)
-{
-	char			*cp;
-	xfs_ifork_t		*ifp;
-	xfs_mount_t		*mp;
-	static const short	brootflag[2] =
-		{ XFS_ILOG_DBROOT, XFS_ILOG_ABROOT };
-	static const short	dataflag[2] =
-		{ XFS_ILOG_DDATA, XFS_ILOG_ADATA };
-	static const short	extflag[2] =
-		{ XFS_ILOG_DEXT, XFS_ILOG_AEXT };
-
-	if (!iip)
-		return;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	/*
-	 * This can happen if we gave up in iformat in an error path,
-	 * for the attribute fork.
-	 */
-	if (!ifp) {
-		ASSERT(whichfork == XFS_ATTR_FORK);
-		return;
-	}
-	cp = XFS_DFORK_PTR(dip, whichfork);
-	mp = ip->i_mount;
-	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
-	case XFS_DINODE_FMT_LOCAL:
-		if ((iip->ili_fields & dataflag[whichfork]) &&
-		    (ifp->if_bytes > 0)) {
-			ASSERT(ifp->if_u1.if_data != NULL);
-			ASSERT(ifp->if_bytes <= XFS_IFORK_SIZE(ip, whichfork));
-			memcpy(cp, ifp->if_u1.if_data, ifp->if_bytes);
-		}
-		break;
-
-	case XFS_DINODE_FMT_EXTENTS:
-		ASSERT((ifp->if_flags & XFS_IFEXTENTS) ||
-		       !(iip->ili_fields & extflag[whichfork]));
-		if ((iip->ili_fields & extflag[whichfork]) &&
-		    (ifp->if_bytes > 0)) {
-			ASSERT(xfs_iext_get_ext(ifp, 0));
-			ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) > 0);
-			(void)xfs_iextents_copy(ip, (xfs_bmbt_rec_t *)cp,
-				whichfork);
-		}
-		break;
-
-	case XFS_DINODE_FMT_BTREE:
-		if ((iip->ili_fields & brootflag[whichfork]) &&
-		    (ifp->if_broot_bytes > 0)) {
-			ASSERT(ifp->if_broot != NULL);
-			ASSERT(ifp->if_broot_bytes <=
-			       (XFS_IFORK_SIZE(ip, whichfork) +
-				XFS_BROOT_SIZE_ADJ(ip)));
-			xfs_bmbt_to_bmdr(mp, ifp->if_broot, ifp->if_broot_bytes,
-				(xfs_bmdr_block_t *)cp,
-				XFS_DFORK_SIZE(dip, mp, whichfork));
-		}
-		break;
-
-	case XFS_DINODE_FMT_DEV:
-		if (iip->ili_fields & XFS_ILOG_DEV) {
-			ASSERT(whichfork == XFS_DATA_FORK);
-			xfs_dinode_put_rdev(dip, ip->i_df.if_u2.if_rdev);
-		}
-		break;
-
-	case XFS_DINODE_FMT_UUID:
-		if (iip->ili_fields & XFS_ILOG_UUID) {
-			ASSERT(whichfork == XFS_DATA_FORK);
-			memcpy(XFS_DFORK_DPTR(dip),
-			       &ip->i_df.if_u2.if_uuid,
-			       sizeof(uuid_t));
-		}
-		break;
-
-	default:
-		ASSERT(0);
-		break;
-	}
-}
-
-STATIC int
-xfs_iflush_cluster(
-	xfs_inode_t	*ip,
-	xfs_buf_t	*bp)
-{
-	xfs_mount_t		*mp = ip->i_mount;
-	struct xfs_perag	*pag;
-	unsigned long		first_index, mask;
-	unsigned long		inodes_per_cluster;
-	int			ilist_size;
-	xfs_inode_t		**ilist;
-	xfs_inode_t		*iq;
-	int			nr_found;
-	int			clcount = 0;
-	int			bufwasdelwri;
-	int			i;
-
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-
-	inodes_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog;
-	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
-	ilist = kmem_alloc(ilist_size, KM_MAYFAIL|KM_NOFS);
-	if (!ilist)
-		goto out_put;
-
-	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
-	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
-	rcu_read_lock();
-	/* really need a gang lookup range call here */
-	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)ilist,
-					first_index, inodes_per_cluster);
-	if (nr_found == 0)
-		goto out_free;
-
-	for (i = 0; i < nr_found; i++) {
-		iq = ilist[i];
-		if (iq == ip)
-			continue;
-
-		/*
-		 * because this is an RCU protected lookup, we could find a
-		 * recently freed or even reallocated inode during the lookup.
-		 * We need to check under the i_flags_lock for a valid inode
-		 * here. Skip it if it is not valid or the wrong inode.
-		 */
-		spin_lock(&ip->i_flags_lock);
-		if (!ip->i_ino ||
-		    (XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) != first_index) {
-			spin_unlock(&ip->i_flags_lock);
-			continue;
-		}
-		spin_unlock(&ip->i_flags_lock);
-
-		/*
-		 * Do an un-protected check to see if the inode is dirty and
-		 * is a candidate for flushing.  These checks will be repeated
-		 * later after the appropriate locks are acquired.
-		 */
-		if (xfs_inode_clean(iq) && xfs_ipincount(iq) == 0)
-			continue;
-
-		/*
-		 * Try to get locks.  If any are unavailable or it is pinned,
-		 * then this inode cannot be flushed and is skipped.
-		 */
-
-		if (!xfs_ilock_nowait(iq, XFS_ILOCK_SHARED))
-			continue;
-		if (!xfs_iflock_nowait(iq)) {
-			xfs_iunlock(iq, XFS_ILOCK_SHARED);
-			continue;
-		}
-		if (xfs_ipincount(iq)) {
-			xfs_ifunlock(iq);
-			xfs_iunlock(iq, XFS_ILOCK_SHARED);
-			continue;
-		}
-
-		/*
-		 * arriving here means that this inode can be flushed.  First
-		 * re-check that it's dirty before flushing.
-		 */
-		if (!xfs_inode_clean(iq)) {
-			int	error;
-			error = xfs_iflush_int(iq, bp);
-			if (error) {
-				xfs_iunlock(iq, XFS_ILOCK_SHARED);
-				goto cluster_corrupt_out;
-			}
-			clcount++;
-		} else {
-			xfs_ifunlock(iq);
-		}
-		xfs_iunlock(iq, XFS_ILOCK_SHARED);
-	}
-
-	if (clcount) {
-		XFS_STATS_INC(xs_icluster_flushcnt);
-		XFS_STATS_ADD(xs_icluster_flushinode, clcount);
-	}
-
-out_free:
-	rcu_read_unlock();
-	kmem_free(ilist);
-out_put:
-	xfs_perag_put(pag);
-	return 0;
-
-
-cluster_corrupt_out:
-	/*
-	 * Corruption detected in the clustering loop.  Invalidate the
-	 * inode buffer and shut down the filesystem.
-	 */
-	rcu_read_unlock();
-	/*
-	 * Clean up the buffer.  If it was delwri, just release it --
-	 * brelse can handle it with no problems.  If not, shut down the
-	 * filesystem before releasing the buffer.
-	 */
-	bufwasdelwri = (bp->b_flags & _XBF_DELWRI_Q);
-	if (bufwasdelwri)
-		xfs_buf_relse(bp);
-
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-
-	if (!bufwasdelwri) {
-		/*
-		 * Just like incore_relse: if we have b_iodone functions,
-		 * mark the buffer as an error and call them.  Otherwise
-		 * mark it as stale and brelse.
-		 */
-		if (bp->b_iodone) {
-			XFS_BUF_UNDONE(bp);
-			xfs_buf_stale(bp);
-			xfs_buf_ioerror(bp, EIO);
-			xfs_buf_ioend(bp, 0);
-		} else {
-			xfs_buf_stale(bp);
-			xfs_buf_relse(bp);
-		}
-	}
-
-	/*
-	 * Unlocks the flush lock
-	 */
-	xfs_iflush_abort(iq, false);
-	kmem_free(ilist);
-	xfs_perag_put(pag);
-	return XFS_ERROR(EFSCORRUPTED);
-}
-
-/*
- * Flush dirty inode metadata into the backing buffer.
- *
- * The caller must have the inode lock and the inode flush lock held.  The
- * inode lock will still be held upon return to the caller, and the inode
- * flush lock will be released after the inode has reached the disk.
- *
- * The caller must write out the buffer returned in *bpp and release it.
- */
-int
-xfs_iflush(
-	struct xfs_inode	*ip,
-	struct xfs_buf		**bpp)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_buf		*bp;
-	struct xfs_dinode	*dip;
-	int			error;
-
-	XFS_STATS_INC(xs_iflush_count);
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-	ASSERT(xfs_isiflocked(ip));
-	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
-	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
-
-	*bpp = NULL;
-
-	xfs_iunpin_wait(ip);
-
-	/*
-	 * For stale inodes we cannot rely on the backing buffer remaining
-	 * stale in cache for the remaining life of the stale inode and so
-	 * xfs_imap_to_bp() below may give us a buffer that no longer contains
-	 * inodes below. We have to check this after ensuring the inode is
-	 * unpinned so that it is safe to reclaim the stale inode after the
-	 * flush call.
-	 */
-	if (xfs_iflags_test(ip, XFS_ISTALE)) {
-		xfs_ifunlock(ip);
-		return 0;
-	}
-
-	/*
-	 * This may have been unpinned because the filesystem is shutting
-	 * down forcibly. If that's the case we must not write this inode
-	 * to disk, because the log record didn't make it to disk.
-	 *
-	 * We also have to remove the log item from the AIL in this case,
-	 * as we wait for an empty AIL as part of the unmount process.
-	 */
-	if (XFS_FORCED_SHUTDOWN(mp)) {
-		error = XFS_ERROR(EIO);
-		goto abort_out;
-	}
-
-	/*
-	 * Get the buffer containing the on-disk inode.
-	 */
-	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK,
-			       0);
-	if (error || !bp) {
-		xfs_ifunlock(ip);
-		return error;
-	}
-
-	/*
-	 * First flush out the inode that xfs_iflush was called with.
-	 */
-	error = xfs_iflush_int(ip, bp);
-	if (error)
-		goto corrupt_out;
-
-	/*
-	 * If the buffer is pinned then push on the log now so we won't
-	 * get stuck waiting in the write for too long.
-	 */
-	if (xfs_buf_ispinned(bp))
-		xfs_log_force(mp, 0);
-
-	/*
-	 * inode clustering:
-	 * see if other inodes can be gathered into this write
-	 */
-	error = xfs_iflush_cluster(ip, bp);
-	if (error)
-		goto cluster_corrupt_out;
-
-	*bpp = bp;
-	return 0;
-
-corrupt_out:
-	xfs_buf_relse(bp);
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-cluster_corrupt_out:
-	error = XFS_ERROR(EFSCORRUPTED);
-abort_out:
-	/*
-	 * Unlocks the flush lock
-	 */
-	xfs_iflush_abort(ip, false);
-	return error;
-}
-
-
-STATIC int
-xfs_iflush_int(
-	struct xfs_inode	*ip,
-	struct xfs_buf		*bp)
-{
-	struct xfs_inode_log_item *iip = ip->i_itemp;
-	struct xfs_dinode	*dip;
-	struct xfs_mount	*mp = ip->i_mount;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-	ASSERT(xfs_isiflocked(ip));
-	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
-	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
-	ASSERT(iip != NULL && iip->ili_fields != 0);
-
-	/* set *dip = inode's place in the buffer */
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
-
-	if (XFS_TEST_ERROR(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC),
-			       mp, XFS_ERRTAG_IFLUSH_1, XFS_RANDOM_IFLUSH_1)) {
-		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: Bad inode %Lu magic number 0x%x, ptr 0x%p",
-			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
-		goto corrupt_out;
-	}
-	if (XFS_TEST_ERROR(ip->i_d.di_magic != XFS_DINODE_MAGIC,
-				mp, XFS_ERRTAG_IFLUSH_2, XFS_RANDOM_IFLUSH_2)) {
-		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: Bad inode %Lu, ptr 0x%p, magic number 0x%x",
-			__func__, ip->i_ino, ip, ip->i_d.di_magic);
-		goto corrupt_out;
-	}
-	if (S_ISREG(ip->i_d.di_mode)) {
-		if (XFS_TEST_ERROR(
-		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
-		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
-		    mp, XFS_ERRTAG_IFLUSH_3, XFS_RANDOM_IFLUSH_3)) {
-			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-				"%s: Bad regular inode %Lu, ptr 0x%p",
-				__func__, ip->i_ino, ip);
-			goto corrupt_out;
-		}
-	} else if (S_ISDIR(ip->i_d.di_mode)) {
-		if (XFS_TEST_ERROR(
-		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
-		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
-		    (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL),
-		    mp, XFS_ERRTAG_IFLUSH_4, XFS_RANDOM_IFLUSH_4)) {
-			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-				"%s: Bad directory inode %Lu, ptr 0x%p",
-				__func__, ip->i_ino, ip);
-			goto corrupt_out;
-		}
-	}
-	if (XFS_TEST_ERROR(ip->i_d.di_nextents + ip->i_d.di_anextents >
-				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5,
-				XFS_RANDOM_IFLUSH_5)) {
-		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: detected corrupt incore inode %Lu, "
-			"total extents = %d, nblocks = %Ld, ptr 0x%p",
-			__func__, ip->i_ino,
-			ip->i_d.di_nextents + ip->i_d.di_anextents,
-			ip->i_d.di_nblocks, ip);
-		goto corrupt_out;
-	}
-	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
-				mp, XFS_ERRTAG_IFLUSH_6, XFS_RANDOM_IFLUSH_6)) {
-		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: bad inode %Lu, forkoff 0x%x, ptr 0x%p",
-			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
-		goto corrupt_out;
-	}
-	/*
-	 * bump the flush iteration count, used to detect flushes which
-	 * postdate a log record during recovery. This is redundant as we now
-	 * log every change and hence this can't happen. Still, it doesn't hurt.
-	 */
-	ip->i_d.di_flushiter++;
-
-	/*
-	 * Copy the dirty parts of the inode into the on-disk
-	 * inode.  We always copy out the core of the inode,
-	 * because if the inode is dirty at all the core must
-	 * be.
-	 */
-	xfs_dinode_to_disk(dip, &ip->i_d);
-
-	/* Wrap, we never let the log put out DI_MAX_FLUSH */
-	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
-		ip->i_d.di_flushiter = 0;
-
-	/*
-	 * If this is really an old format inode and the superblock version
-	 * has not been updated to support only new format inodes, then
-	 * convert back to the old inode format.  If the superblock version
-	 * has been updated, then make the conversion permanent.
+	 * the delayed ones.  There must be at least one
+	 * non-delayed extent.
 	 */
-	ASSERT(ip->i_d.di_version == 1 || xfs_sb_version_hasnlink(&mp->m_sb));
-	if (ip->i_d.di_version == 1) {
-		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
-			/*
-			 * Convert it back.
-			 */
-			ASSERT(ip->i_d.di_nlink <= XFS_MAXLINK_1);
-			dip->di_onlink = cpu_to_be16(ip->i_d.di_nlink);
-		} else {
+	copied = 0;
+	for (i = 0; i < nrecs; i++) {
+		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
+		start_block = xfs_bmbt_get_startblock(ep);
+		if (isnullstartblock(start_block)) {
 			/*
-			 * The superblock version has already been bumped,
-			 * so just make the conversion to the new inode
-			 * format permanent.
+			 * It's a delayed allocation extent, so skip it.
 			 */
-			ip->i_d.di_version = 2;
-			dip->di_version = 2;
-			ip->i_d.di_onlink = 0;
-			dip->di_onlink = 0;
-			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
-			memset(&(dip->di_pad[0]), 0,
-			      sizeof(dip->di_pad));
-			ASSERT(xfs_get_projid(ip) == 0);
+			continue;
 		}
-	}
 
-	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK, bp);
-	if (XFS_IFORK_Q(ip))
-		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK, bp);
-	xfs_inobp_check(mp, bp);
+		/* Translate to on disk format */
+		put_unaligned(cpu_to_be64(ep->l0), &dp->l0);
+		put_unaligned(cpu_to_be64(ep->l1), &dp->l1);
+		dp++;
+		copied++;
+	}
+	ASSERT(copied != 0);
+	xfs_validate_extents(ifp, copied, XFS_EXTFMT_INODE(ip));
 
-	/*
-	 * We've recorded everything logged in the inode, so we'd like to clear
-	 * the ili_fields bits so we don't log and flush things unnecessarily.
-	 * However, we can't stop logging all this information until the data
-	 * we've copied into the disk buffer is written to disk.  If we did we
-	 * might overwrite the copy of the inode in the log with all the data
-	 * after re-logging only part of it, and in the face of a crash we
-	 * wouldn't have all the data we need to recover.
-	 *
-	 * What we do is move the bits to the ili_last_fields field.  When
-	 * logging the inode, these bits are moved back to the ili_fields field.
-	 * In the xfs_iflush_done() routine we clear ili_last_fields, since we
-	 * know that the information those bits represent is permanently on
-	 * disk.  As long as the flush completes before the inode is logged
-	 * again, then both ili_fields and ili_last_fields will be cleared.
-	 *
-	 * We can play with the ili_fields bits here, because the inode lock
-	 * must be held exclusively in order to set bits there and the flush
-	 * lock protects the ili_last_fields bits.  Set ili_logged so the flush
-	 * done routine can tell whether or not to look in the AIL.  Also, store
-	 * the current LSN of the inode so that we can tell whether the item has
-	 * moved in the AIL from xfs_iflush_done().  In order to read the lsn we
-	 * need the AIL lock, because it is a 64 bit value that cannot be read
-	 * atomically.
-	 */
-	iip->ili_last_fields = iip->ili_fields;
-	iip->ili_fields = 0;
-	iip->ili_logged = 1;
+	return (copied * (uint)sizeof(xfs_bmbt_rec_t));
+}
 
-	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
-				&iip->ili_item.li_lsn);
+/*
+ * Each of the following cases stores data into the same region
+ * of the on-disk inode, so only one of them can be valid at
+ * any given time. While it is possible to have conflicting formats
+ * and log flags, e.g. having XFS_ILOG_?DATA set when the fork is
+ * in EXTENTS format, this can only happen when the fork has
+ * changed formats after being modified but before being flushed.
+ * In these cases, the format always takes precedence, because the
+ * format indicates the current state of the fork.
+ */
+void
+xfs_iflush_fork(
+	xfs_inode_t		*ip,
+	xfs_dinode_t		*dip,
+	xfs_inode_log_item_t	*iip,
+	int			whichfork,
+	xfs_buf_t		*bp)
+{
+	char			*cp;
+	xfs_ifork_t		*ifp;
+	xfs_mount_t		*mp;
+	static const short	brootflag[2] =
+		{ XFS_ILOG_DBROOT, XFS_ILOG_ABROOT };
+	static const short	dataflag[2] =
+		{ XFS_ILOG_DDATA, XFS_ILOG_ADATA };
+	static const short	extflag[2] =
+		{ XFS_ILOG_DEXT, XFS_ILOG_AEXT };
 
+	if (!iip)
+		return;
+	ifp = XFS_IFORK_PTR(ip, whichfork);
 	/*
-	 * Attach the function xfs_iflush_done to the inode's
-	 * buffer.  This will remove the inode from the AIL
-	 * and unlock the inode's flush lock when the inode is
-	 * completely written to disk.
+	 * This can happen if we gave up in iformat in an error path,
+	 * for the attribute fork.
 	 */
-	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
+	if (!ifp) {
+		ASSERT(whichfork == XFS_ATTR_FORK);
+		return;
+	}
+	cp = XFS_DFORK_PTR(dip, whichfork);
+	mp = ip->i_mount;
+	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
+	case XFS_DINODE_FMT_LOCAL:
+		if ((iip->ili_fields & dataflag[whichfork]) &&
+		    (ifp->if_bytes > 0)) {
+			ASSERT(ifp->if_u1.if_data != NULL);
+			ASSERT(ifp->if_bytes <= XFS_IFORK_SIZE(ip, whichfork));
+			memcpy(cp, ifp->if_u1.if_data, ifp->if_bytes);
+		}
+		break;
+
+	case XFS_DINODE_FMT_EXTENTS:
+		ASSERT((ifp->if_flags & XFS_IFEXTENTS) ||
+		       !(iip->ili_fields & extflag[whichfork]));
+		if ((iip->ili_fields & extflag[whichfork]) &&
+		    (ifp->if_bytes > 0)) {
+			ASSERT(xfs_iext_get_ext(ifp, 0));
+			ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) > 0);
+			(void)xfs_iextents_copy(ip, (xfs_bmbt_rec_t *)cp,
+				whichfork);
+		}
+		break;
 
-	/* update the lsn in the on disk inode if required */
-	if (ip->i_d.di_version == 3)
-		dip->di_lsn = cpu_to_be64(iip->ili_item.li_lsn);
+	case XFS_DINODE_FMT_BTREE:
+		if ((iip->ili_fields & brootflag[whichfork]) &&
+		    (ifp->if_broot_bytes > 0)) {
+			ASSERT(ifp->if_broot != NULL);
+			ASSERT(ifp->if_broot_bytes <=
+			       (XFS_IFORK_SIZE(ip, whichfork) +
+				XFS_BROOT_SIZE_ADJ(ip)));
+			xfs_bmbt_to_bmdr(mp, ifp->if_broot, ifp->if_broot_bytes,
+				(xfs_bmdr_block_t *)cp,
+				XFS_DFORK_SIZE(dip, mp, whichfork));
+		}
+		break;
 
-	/* generate the checksum. */
-	xfs_dinode_calc_crc(mp, dip);
+	case XFS_DINODE_FMT_DEV:
+		if (iip->ili_fields & XFS_ILOG_DEV) {
+			ASSERT(whichfork == XFS_DATA_FORK);
+			xfs_dinode_put_rdev(dip, ip->i_df.if_u2.if_rdev);
+		}
+		break;
 
-	ASSERT(bp->b_fspriv != NULL);
-	ASSERT(bp->b_iodone != NULL);
-	return 0;
+	case XFS_DINODE_FMT_UUID:
+		if (iip->ili_fields & XFS_ILOG_UUID) {
+			ASSERT(whichfork == XFS_DATA_FORK);
+			memcpy(XFS_DFORK_DPTR(dip),
+			       &ip->i_df.if_u2.if_uuid,
+			       sizeof(uuid_t));
+		}
+		break;
 
-corrupt_out:
-	return XFS_ERROR(EFSCORRUPTED);
+	default:
+		ASSERT(0);
+		break;
+	}
 }
 
 /*
@@ -3020,6 +1330,66 @@ xfs_iext_get_ext(
 }
 
 /*
+ * Create, destroy, or resize a linear (direct) block of extents.
+ */
+STATIC void
+xfs_iext_realloc_direct(
+	xfs_ifork_t	*ifp,		/* inode fork pointer */
+	int		new_size)	/* new size of extents */
+{
+	int		rnew_size;	/* real new size of extents */
+
+	rnew_size = new_size;
+
+	ASSERT(!(ifp->if_flags & XFS_IFEXTIREC) ||
+		((new_size >= 0) && (new_size <= XFS_IEXT_BUFSZ) &&
+		 (new_size != ifp->if_real_bytes)));
+
+	/* Free extent records */
+	if (new_size == 0) {
+		xfs_iext_destroy(ifp);
+	}
+	/* Resize direct extent list and zero any new bytes */
+	else if (ifp->if_real_bytes) {
+		/* Check if extents will fit inside the inode */
+		if (new_size <= XFS_INLINE_EXTS * sizeof(xfs_bmbt_rec_t)) {
+			xfs_iext_direct_to_inline(ifp, new_size /
+				(uint)sizeof(xfs_bmbt_rec_t));
+			ifp->if_bytes = new_size;
+			return;
+		}
+		if (!is_power_of_2(new_size)){
+			rnew_size = roundup_pow_of_two(new_size);
+		}
+		if (rnew_size != ifp->if_real_bytes) {
+			ifp->if_u1.if_extents =
+				kmem_realloc(ifp->if_u1.if_extents,
+						rnew_size,
+						ifp->if_real_bytes, KM_NOFS);
+		}
+		if (rnew_size > ifp->if_real_bytes) {
+			memset(&ifp->if_u1.if_extents[ifp->if_bytes /
+				(uint)sizeof(xfs_bmbt_rec_t)], 0,
+				rnew_size - ifp->if_real_bytes);
+		}
+	}
+	/*
+	 * Switch from the inline extent buffer to a direct
+	 * extent list. Be sure to include the inline extent
+	 * bytes in new_size.
+	 */
+	else {
+		new_size += ifp->if_bytes;
+		if (!is_power_of_2(new_size)) {
+			rnew_size = roundup_pow_of_two(new_size);
+		}
+		xfs_iext_inline_to_direct(ifp, rnew_size);
+	}
+	ifp->if_real_bytes = rnew_size;
+	ifp->if_bytes = new_size;
+}
+
+/*
  * Insert new item(s) into the extent records for incore inode
  * fork 'ifp'.  'count' new items are inserted at index 'idx'.
  */
@@ -3459,66 +1829,6 @@ xfs_iext_remove_indirect(
 }
 
 /*
- * Create, destroy, or resize a linear (direct) block of extents.
- */
-void
-xfs_iext_realloc_direct(
-	xfs_ifork_t	*ifp,		/* inode fork pointer */
-	int		new_size)	/* new size of extents */
-{
-	int		rnew_size;	/* real new size of extents */
-
-	rnew_size = new_size;
-
-	ASSERT(!(ifp->if_flags & XFS_IFEXTIREC) ||
-		((new_size >= 0) && (new_size <= XFS_IEXT_BUFSZ) &&
-		 (new_size != ifp->if_real_bytes)));
-
-	/* Free extent records */
-	if (new_size == 0) {
-		xfs_iext_destroy(ifp);
-	}
-	/* Resize direct extent list and zero any new bytes */
-	else if (ifp->if_real_bytes) {
-		/* Check if extents will fit inside the inode */
-		if (new_size <= XFS_INLINE_EXTS * sizeof(xfs_bmbt_rec_t)) {
-			xfs_iext_direct_to_inline(ifp, new_size /
-				(uint)sizeof(xfs_bmbt_rec_t));
-			ifp->if_bytes = new_size;
-			return;
-		}
-		if (!is_power_of_2(new_size)){
-			rnew_size = roundup_pow_of_two(new_size);
-		}
-		if (rnew_size != ifp->if_real_bytes) {
-			ifp->if_u1.if_extents =
-				kmem_realloc(ifp->if_u1.if_extents,
-						rnew_size,
-						ifp->if_real_bytes, KM_NOFS);
-		}
-		if (rnew_size > ifp->if_real_bytes) {
-			memset(&ifp->if_u1.if_extents[ifp->if_bytes /
-				(uint)sizeof(xfs_bmbt_rec_t)], 0,
-				rnew_size - ifp->if_real_bytes);
-		}
-	}
-	/*
-	 * Switch from the inline extent buffer to a direct
-	 * extent list. Be sure to include the inline extent
-	 * bytes in new_size.
-	 */
-	else {
-		new_size += ifp->if_bytes;
-		if (!is_power_of_2(new_size)) {
-			rnew_size = roundup_pow_of_two(new_size);
-		}
-		xfs_iext_inline_to_direct(ifp, rnew_size);
-	}
-	ifp->if_real_bytes = rnew_size;
-	ifp->if_bytes = new_size;
-}
-
-/*
  * Switch from linear (direct) extent records to inline buffer.
  */
 void
@@ -4023,40 +2333,3 @@ xfs_iext_irec_update_extoffs(
 		ifp->if_u1.if_ext_irec[i].er_extoff += ext_diff;
 	}
 }
-
-/*
- * Test whether it is appropriate to check an inode for and free post EOF
- * blocks. The 'force' parameter determines whether we should also consider
- * regular files that are marked preallocated or append-only.
- */
-bool
-xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
-{
-	/* prealloc/delalloc exists only on regular files */
-	if (!S_ISREG(ip->i_d.di_mode))
-		return false;
-
-	/*
-	 * Zero sized files with no cached pages and delalloc blocks will not
-	 * have speculative prealloc/delalloc blocks to remove.
-	 */
-	if (VFS_I(ip)->i_size == 0 &&
-	    VN_CACHED(VFS_I(ip)) == 0 &&
-	    ip->i_delayed_blks == 0)
-		return false;
-
-	/* If we haven't read in the extent list, then don't do it now. */
-	if (!(ip->i_df.if_flags & XFS_IFEXTENTS))
-		return false;
-
-	/*
-	 * Do not free real preallocated or append-only files unless the file
-	 * has delalloc blocks and we are forced to remove them.
-	 */
-	if (ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
-		if (!force || ip->i_delayed_blks == 0)
-			return false;
-
-	return true;
-}
-
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9112979..739a975 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -21,6 +21,7 @@
 struct posix_acl;
 struct xfs_dinode;
 struct xfs_inode;
+struct xfs_inode_log_item;
 
 /*
  * Fork identifiers.
@@ -237,335 +238,7 @@ static inline uint xfs_icdinode_size(int version)
 
 #ifdef __KERNEL__
 
-struct xfs_buf;
-struct xfs_bmap_free;
-struct xfs_bmbt_irec;
-struct xfs_inode_log_item;
-struct xfs_mount;
-struct xfs_trans;
-struct xfs_dquot;
-
-typedef struct xfs_inode {
-	/* Inode linking and identification information. */
-	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
-	struct xfs_dquot	*i_udquot;	/* user dquot */
-	struct xfs_dquot	*i_gdquot;	/* group dquot */
-
-	/* Inode location stuff */
-	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
-	struct xfs_imap		i_imap;		/* location for xfs_imap() */
-
-	/* Extent information. */
-	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
-	xfs_ifork_t		i_df;		/* data fork */
-
-	/* Transaction and locking information. */
-	struct xfs_inode_log_item *i_itemp;	/* logging information */
-	mrlock_t		i_lock;		/* inode lock */
-	mrlock_t		i_iolock;	/* inode IO lock */
-	atomic_t		i_pincount;	/* inode pin count */
-	spinlock_t		i_flags_lock;	/* inode i_flags lock */
-	/* Miscellaneous state. */
-	unsigned long		i_flags;	/* see defined flags below */
-	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
-
-	xfs_icdinode_t		i_d;		/* most of ondisk inode */
-
-	/* VFS inode */
-	struct inode		i_vnode;	/* embedded VFS inode */
-} xfs_inode_t;
-
-/* Convert from vfs inode to xfs inode */
-static inline struct xfs_inode *XFS_I(struct inode *inode)
-{
-	return container_of(inode, struct xfs_inode, i_vnode);
-}
-
-/* convert from xfs inode to vfs inode */
-static inline struct inode *VFS_I(struct xfs_inode *ip)
-{
-	return &ip->i_vnode;
-}
-
-/*
- * For regular files we only update the on-disk filesize when actually
- * writing data back to disk.  Until then only the copy in the VFS inode
- * is uptodate.
- */
-static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
-{
-	if (S_ISREG(ip->i_d.di_mode))
-		return i_size_read(VFS_I(ip));
-	return ip->i_d.di_size;
-}
-
-/*
- * If this I/O goes past the on-disk inode size update it unless it would
- * be past the current in-core inode size.
- */
-static inline xfs_fsize_t
-xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
-{
-	xfs_fsize_t i_size = i_size_read(VFS_I(ip));
-
-	if (new_size > i_size)
-		new_size = i_size;
-	return new_size > ip->i_d.di_size ? new_size : 0;
-}
-
-/*
- * i_flags helper functions
- */
-static inline void
-__xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
-{
-	ip->i_flags |= flags;
-}
-
-static inline void
-xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
-{
-	spin_lock(&ip->i_flags_lock);
-	__xfs_iflags_set(ip, flags);
-	spin_unlock(&ip->i_flags_lock);
-}
-
-static inline void
-xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
-{
-	spin_lock(&ip->i_flags_lock);
-	ip->i_flags &= ~flags;
-	spin_unlock(&ip->i_flags_lock);
-}
-
-static inline int
-__xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
-{
-	return (ip->i_flags & flags);
-}
-
-static inline int
-xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
-{
-	int ret;
-	spin_lock(&ip->i_flags_lock);
-	ret = __xfs_iflags_test(ip, flags);
-	spin_unlock(&ip->i_flags_lock);
-	return ret;
-}
-
-static inline int
-xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned short flags)
-{
-	int ret;
-
-	spin_lock(&ip->i_flags_lock);
-	ret = ip->i_flags & flags;
-	if (ret)
-		ip->i_flags &= ~flags;
-	spin_unlock(&ip->i_flags_lock);
-	return ret;
-}
-
-static inline int
-xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
-{
-	int ret;
-
-	spin_lock(&ip->i_flags_lock);
-	ret = ip->i_flags & flags;
-	if (!ret)
-		ip->i_flags |= flags;
-	spin_unlock(&ip->i_flags_lock);
-	return ret;
-}
-
-/*
- * Project quota id helpers (previously projid was 16bit only
- * and using two 16bit values to hold new 32bit projid was chosen
- * to retain compatibility with "old" filesystems).
- */
-static inline prid_t
-xfs_get_projid(struct xfs_inode *ip)
-{
-	return (prid_t)ip->i_d.di_projid_hi << 16 | ip->i_d.di_projid_lo;
-}
-
-static inline void
-xfs_set_projid(struct xfs_inode *ip,
-		prid_t projid)
-{
-	ip->i_d.di_projid_hi = (__uint16_t) (projid >> 16);
-	ip->i_d.di_projid_lo = (__uint16_t) (projid & 0xffff);
-}
-
-/*
- * In-core inode flags.
- */
-#define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
-#define XFS_ISTALE		(1 << 1) /* inode has been staled */
-#define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
-#define XFS_INEW		(1 << 3) /* inode has just been allocated */
-#define XFS_IFILESTREAM		(1 << 4) /* inode is in a filestream dir. */
-#define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
-#define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
-#define __XFS_IFLOCK_BIT	7	 /* inode is being flushed right now */
-#define XFS_IFLOCK		(1 << __XFS_IFLOCK_BIT)
-#define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
-#define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
-#define XFS_IDONTCACHE		(1 << 9) /* don't cache the inode long term */
-
-/*
- * Per-lifetime flags need to be reset when re-using a reclaimable inode during
- * inode lookup. This prevents unintended behaviour on the new inode from
- * ocurring.
- */
-#define XFS_IRECLAIM_RESET_FLAGS	\
-	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
-	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | \
-	 XFS_IFILESTREAM);
-
-/*
- * Synchronize processes attempting to flush the in-core inode back to disk.
- */
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
-	xfs_iflags_clear(ip, XFS_IFLOCK);
-	smp_mb();
-	wake_up_bit(&ip->i_flags, __XFS_IFLOCK_BIT);
-}
-
-static inline int xfs_isiflocked(struct xfs_inode *ip)
-{
-	return xfs_iflags_test(ip, XFS_IFLOCK);
-}
-
-/*
- * Flags for inode locking.
- * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
- *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
- */
-#define	XFS_IOLOCK_EXCL		(1<<0)
-#define	XFS_IOLOCK_SHARED	(1<<1)
-#define	XFS_ILOCK_EXCL		(1<<2)
-#define	XFS_ILOCK_SHARED	(1<<3)
-
-#define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
-				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)
-
-#define XFS_LOCK_FLAGS \
-	{ XFS_IOLOCK_EXCL,	"IOLOCK_EXCL" }, \
-	{ XFS_IOLOCK_SHARED,	"IOLOCK_SHARED" }, \
-	{ XFS_ILOCK_EXCL,	"ILOCK_EXCL" }, \
-	{ XFS_ILOCK_SHARED,	"ILOCK_SHARED" }
-
-
-/*
- * Flags for lockdep annotations.
- *
- * XFS_LOCK_PARENT - for directory operations that require locking a
- * parent directory inode and a child entry inode.  The parent gets locked
- * with this flag so it gets a lockdep subclass of 1 and the child entry
- * lock will have a lockdep subclass of 0.
- *
- * XFS_LOCK_RTBITMAP/XFS_LOCK_RTSUM - the realtime device bitmap and summary
- * inodes do not participate in the normal lock order, and thus have their
- * own subclasses.
- *
- * XFS_LOCK_INUMORDER - for locking several inodes at the some time
- * with xfs_lock_inodes().  This flag is used as the starting subclass
- * and each subsequent lock acquired will increment the subclass by one.
- * So the first lock acquired will have a lockdep subclass of 4, the
- * second lock will have a lockdep subclass of 5, and so on. It is
- * the responsibility of the class builder to shift this to the correct
- * portion of the lock_mode lockdep mask.
- */
-#define XFS_LOCK_PARENT		1
-#define XFS_LOCK_RTBITMAP	2
-#define XFS_LOCK_RTSUM		3
-#define XFS_LOCK_INUMORDER	4
-
-#define XFS_IOLOCK_SHIFT	16
-#define	XFS_IOLOCK_PARENT	(XFS_LOCK_PARENT << XFS_IOLOCK_SHIFT)
-
-#define XFS_ILOCK_SHIFT		24
-#define	XFS_ILOCK_PARENT	(XFS_LOCK_PARENT << XFS_ILOCK_SHIFT)
-#define	XFS_ILOCK_RTBITMAP	(XFS_LOCK_RTBITMAP << XFS_ILOCK_SHIFT)
-#define	XFS_ILOCK_RTSUM		(XFS_LOCK_RTSUM << XFS_ILOCK_SHIFT)
-
-#define XFS_IOLOCK_DEP_MASK	0x00ff0000
-#define XFS_ILOCK_DEP_MASK	0xff000000
-#define XFS_LOCK_DEP_MASK	(XFS_IOLOCK_DEP_MASK | XFS_ILOCK_DEP_MASK)
-
-#define XFS_IOLOCK_DEP(flags)	(((flags) & XFS_IOLOCK_DEP_MASK) >> XFS_IOLOCK_SHIFT)
-#define XFS_ILOCK_DEP(flags)	(((flags) & XFS_ILOCK_DEP_MASK) >> XFS_ILOCK_SHIFT)
-
-/*
- * For multiple groups support: if S_ISGID bit is set in the parent
- * directory, group of new file is set to that of the parent, and
- * new subdirectory gets S_ISGID bit from parent.
- */
-#define XFS_INHERIT_GID(pip)	\
-	(((pip)->i_mount->m_flags & XFS_MOUNT_GRPID) || \
-	 ((pip)->i_d.di_mode & S_ISGID))
-
-
-/*
- * xfs_inode.c prototypes.
- */
-void		xfs_ilock(xfs_inode_t *, uint);
-int		xfs_ilock_nowait(xfs_inode_t *, uint);
-void		xfs_iunlock(xfs_inode_t *, uint);
-void		xfs_ilock_demote(xfs_inode_t *, uint);
-int		xfs_isilocked(xfs_inode_t *, uint);
-uint		xfs_ilock_map_shared(xfs_inode_t *);
-void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
-int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, umode_t,
-			   xfs_nlink_t, xfs_dev_t, prid_t, int,
-			   struct xfs_buf **, xfs_inode_t **);
-
-uint		xfs_ip2xflags(struct xfs_inode *);
-uint		xfs_dic2xflags(struct xfs_dinode *);
-int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
-			   struct xfs_bmap_free *);
-int		xfs_itruncate_extents(struct xfs_trans **, struct xfs_inode *,
-				      int, xfs_fsize_t);
-int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
-
-void		xfs_iext_realloc(xfs_inode_t *, int, int);
-void		xfs_iunpin_wait(xfs_inode_t *);
-int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
-void		xfs_lock_inodes(xfs_inode_t **, int, uint);
-void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
-
-xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
-
-#define IHOLD(ip) \
-do { \
-	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
-	ihold(VFS_I(ip)); \
-	trace_xfs_ihold(ip, _THIS_IP_); \
-} while (0)
-
-#define IRELE(ip) \
-do { \
-	trace_xfs_irele(ip, _THIS_IP_); \
-	iput(VFS_I(ip)); \
-} while (0)
+#include "xfs_inode_ops.h"
 
 #endif /* __KERNEL__ */
 
@@ -584,6 +257,9 @@ int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
 void		xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
 void		xfs_dinode_to_disk(struct xfs_dinode *,
 				   struct xfs_icdinode *);
+void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
+				struct xfs_inode_log_item *, int,
+				struct xfs_buf *);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
 void		xfs_idata_realloc(struct xfs_inode *, int, int);
 void		xfs_iroot_realloc(struct xfs_inode *, int, int);
@@ -591,15 +267,14 @@ int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, xfs_bmbt_rec_t *, int);
 
 xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
-void		xfs_iext_insert(xfs_inode_t *, xfs_extnum_t, xfs_extnum_t,
-				xfs_bmbt_irec_t *, int);
+void		xfs_iext_insert(struct xfs_inode *, xfs_extnum_t, xfs_extnum_t,
+				struct xfs_bmbt_irec *, int);
 void		xfs_iext_add(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_add_indirect_multi(xfs_ifork_t *, int, xfs_extnum_t, int);
-void		xfs_iext_remove(xfs_inode_t *, xfs_extnum_t, int, int);
+void		xfs_iext_remove(struct xfs_inode *, xfs_extnum_t, int, int);
 void		xfs_iext_remove_inline(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_remove_direct(xfs_ifork_t *, xfs_extnum_t, int);
 void		xfs_iext_remove_indirect(xfs_ifork_t *, xfs_extnum_t, int);
-void		xfs_iext_realloc_direct(xfs_ifork_t *, int);
 void		xfs_iext_direct_to_inline(xfs_ifork_t *, xfs_extnum_t);
 void		xfs_iext_inline_to_direct(xfs_ifork_t *, int);
 void		xfs_iext_destroy(xfs_ifork_t *);
diff --git a/fs/xfs/xfs_inode_ops.c b/fs/xfs/xfs_inode_ops.c
new file mode 100644
index 0000000..295a393
--- /dev/null
+++ b/fs/xfs/xfs_inode_ops.c
@@ -0,0 +1,1772 @@
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/log2.h>
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_buf_item.h"
+#include "xfs_inode_item.h"
+#include "xfs_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_bmap.h"
+#include "xfs_error.h"
+#include "xfs_utils.h"
+#include "xfs_quota.h"
+#include "xfs_filestream.h"
+#include "xfs_vnodeops.h"
+#include "xfs_cksum.h"
+#include "xfs_trace.h"
+#include "xfs_icache.h"
+
+/*
+ * Used in xfs_itruncate_extents().  This is the maximum number of extents
+ * freed from a file in a single transaction.
+ */
+#define	XFS_ITRUNC_MAX_EXTENTS	2
+
+/*
+ * helper function to extract extent size hint from inode
+ */
+xfs_extlen_t
+xfs_get_extsz_hint(
+	struct xfs_inode	*ip)
+{
+	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
+		return ip->i_d.di_extsize;
+	if (XFS_IS_REALTIME_INODE(ip))
+		return ip->i_mount->m_sb.sb_rextsize;
+	return 0;
+}
+
+/*
+ * Test whether it is appropriate to check an inode for and free post EOF
+ * blocks. The 'force' parameter determines whether we should also consider
+ * regular files that are marked preallocated or append-only.
+ */
+bool
+xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
+{
+	/* prealloc/delalloc exists only on regular files */
+	if (!S_ISREG(ip->i_d.di_mode))
+		return false;
+
+	/*
+	 * Zero sized files with no cached pages and delalloc blocks will not
+	 * have speculative prealloc/delalloc blocks to remove.
+	 */
+	if (VFS_I(ip)->i_size == 0 &&
+	    VN_CACHED(VFS_I(ip)) == 0 &&
+	    ip->i_delayed_blks == 0)
+		return false;
+
+	/* If we haven't read in the extent list, then don't do it now. */
+	if (!(ip->i_df.if_flags & XFS_IFEXTENTS))
+		return false;
+
+	/*
+	 * Do not free real preallocated or append-only files unless the file
+	 * has delalloc blocks and we are forced to remove them.
+	 */
+	if (ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
+		if (!force || ip->i_delayed_blks == 0)
+			return false;
+
+	return true;
+}
+
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
+#if defined(DEBUG) || defined(XFS_WARN)
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
+/*
+ * This is called to unpin an inode.  The caller must have the inode locked
+ * in at least shared mode so that the buffer cannot be subsequently pinned
+ * once someone is waiting for it to be unpinned.
+ */
+static void
+xfs_iunpin(
+	struct xfs_inode	*ip)
+{
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+
+	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
+
+	/* Give the log a push to start the unpinning I/O */
+	xfs_log_force_lsn(ip->i_mount, ip->i_itemp->ili_last_lsn, 0);
+
+}
+
+static void
+__xfs_iunpin_wait(
+	struct xfs_inode	*ip)
+{
+	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IPINNED_BIT);
+	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_IPINNED_BIT);
+
+	xfs_iunpin(ip);
+
+	do {
+		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+		if (xfs_ipincount(ip))
+			io_schedule();
+	} while (xfs_ipincount(ip));
+	finish_wait(wq, &wait.wait);
+}
+
+void
+xfs_iunpin_wait(
+	struct xfs_inode	*ip)
+{
+	if (xfs_ipincount(ip))
+		__xfs_iunpin_wait(ip);
+}
+
+STATIC uint
+_xfs_dic2xflags(
+	__uint16_t		di_flags)
+{
+	uint			flags = 0;
+
+	if (di_flags & XFS_DIFLAG_ANY) {
+		if (di_flags & XFS_DIFLAG_REALTIME)
+			flags |= XFS_XFLAG_REALTIME;
+		if (di_flags & XFS_DIFLAG_PREALLOC)
+			flags |= XFS_XFLAG_PREALLOC;
+		if (di_flags & XFS_DIFLAG_IMMUTABLE)
+			flags |= XFS_XFLAG_IMMUTABLE;
+		if (di_flags & XFS_DIFLAG_APPEND)
+			flags |= XFS_XFLAG_APPEND;
+		if (di_flags & XFS_DIFLAG_SYNC)
+			flags |= XFS_XFLAG_SYNC;
+		if (di_flags & XFS_DIFLAG_NOATIME)
+			flags |= XFS_XFLAG_NOATIME;
+		if (di_flags & XFS_DIFLAG_NODUMP)
+			flags |= XFS_XFLAG_NODUMP;
+		if (di_flags & XFS_DIFLAG_RTINHERIT)
+			flags |= XFS_XFLAG_RTINHERIT;
+		if (di_flags & XFS_DIFLAG_PROJINHERIT)
+			flags |= XFS_XFLAG_PROJINHERIT;
+		if (di_flags & XFS_DIFLAG_NOSYMLINKS)
+			flags |= XFS_XFLAG_NOSYMLINKS;
+		if (di_flags & XFS_DIFLAG_EXTSIZE)
+			flags |= XFS_XFLAG_EXTSIZE;
+		if (di_flags & XFS_DIFLAG_EXTSZINHERIT)
+			flags |= XFS_XFLAG_EXTSZINHERIT;
+		if (di_flags & XFS_DIFLAG_NODEFRAG)
+			flags |= XFS_XFLAG_NODEFRAG;
+		if (di_flags & XFS_DIFLAG_FILESTREAM)
+			flags |= XFS_XFLAG_FILESTREAM;
+	}
+
+	return flags;
+}
+
+uint
+xfs_ip2xflags(
+	xfs_inode_t		*ip)
+{
+	xfs_icdinode_t		*dic = &ip->i_d;
+
+	return _xfs_dic2xflags(dic->di_flags) |
+				(XFS_IFORK_Q(ip) ? XFS_XFLAG_HASATTR : 0);
+}
+
+uint
+xfs_dic2xflags(
+	xfs_dinode_t		*dip)
+{
+	return _xfs_dic2xflags(be16_to_cpu(dip->di_flags)) |
+				(XFS_DFORK_Q(dip) ? XFS_XFLAG_HASATTR : 0);
+}
+
+/*
+ * Allocate an inode on disk and return a copy of its in-core version.  The
+ * in-core inode is locked exclusively.  Set mode, nlink, and rdev appropriately
+ * within the inode.  The uid and gid for the inode are set according to the
+ * contents of the given cred structure.
+ *
+ * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc() has a free
+ * inode available, call xfs_iget() to obtain the in-core version of the
+ * allocated inode.  Finally, fill in the inode and log its initial contents.
+ * In this case, ialloc_context would be set to NULL.
+ *
+ * If xfs_dialloc() does not have an available inode, it will replenish its
+ * supply by doing an allocation. Since we can only do one allocation within a
+ * transaction without deadlocks, we must commit the current transaction before
+ * returning the inode itself.  In this case, therefore, we will set
+ * ialloc_context and return.  The caller should then commit the current
+ * transaction, start a new transaction, and call xfs_ialloc() again to actually
+ * get the inode.
+ *
+ * To ensure that some other process does not grab the inode that was allocated
+ * during the first call to xfs_ialloc(), this routine also returns the [locked]
+ * bp pointing to the head of the freelist as ialloc_context.  The caller should
+ * hold this buffer across the commit and pass it back into this routine on the
+ * second call.
+ *
+ * If we are allocating quota inodes, we do not have a parent inode to attach to
+ * or associate with (i.e. pip == NULL) because they are not linked into the
+ * directory structure - they are attached directly to the superblock - and so
+ * have no parent.
+ */
+int
+xfs_ialloc(
+	xfs_trans_t	*tp,
+	xfs_inode_t	*pip,
+	umode_t		mode,
+	xfs_nlink_t	nlink,
+	xfs_dev_t	rdev,
+	prid_t		prid,
+	int		okalloc,
+	xfs_buf_t	**ialloc_context,
+	xfs_inode_t	**ipp)
+{
+	struct xfs_mount *mp = tp->t_mountp;
+	xfs_ino_t	ino;
+	xfs_inode_t	*ip;
+	uint		flags;
+	int		error;
+	timespec_t	tv;
+	int		filestreams = 0;
+
+	/*
+	 * Call the space management code to pick
+	 * the on-disk inode to be allocated.
+	 */
+	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode, okalloc,
+			    ialloc_context, &ino);
+	if (error)
+		return error;
+	if (*ialloc_context || ino == NULLFSINO) {
+		*ipp = NULL;
+		return 0;
+	}
+	ASSERT(*ialloc_context == NULL);
+
+	/*
+	 * Get the in-core inode with the lock held exclusively.
+	 * This is because we're setting fields here we need
+	 * to prevent others from looking at until we're done.
+	 */
+	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE,
+			 XFS_ILOCK_EXCL, &ip);
+	if (error)
+		return error;
+	ASSERT(ip != NULL);
+
+	ip->i_d.di_mode = mode;
+	ip->i_d.di_onlink = 0;
+	ip->i_d.di_nlink = nlink;
+	ASSERT(ip->i_d.di_nlink == nlink);
+	ip->i_d.di_uid = current_fsuid();
+	ip->i_d.di_gid = current_fsgid();
+	xfs_set_projid(ip, prid);
+	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
+
+	/*
+	 * If the superblock version is up to where we support new format
+	 * inodes and this is currently an old format inode, then change
+	 * the inode version number now.  This way we only do the conversion
+	 * here rather than here and in the flush/logging code.
+	 */
+	if (xfs_sb_version_hasnlink(&mp->m_sb) &&
+	    ip->i_d.di_version == 1) {
+		ip->i_d.di_version = 2;
+		/*
+		 * We've already zeroed the old link count, the projid field,
+		 * and the pad field.
+		 */
+	}
+
+	/*
+	 * Project ids won't be stored on disk if we are using a version 1 inode.
+	 */
+	if ((prid != 0) && (ip->i_d.di_version == 1))
+		xfs_bump_ino_vers2(tp, ip);
+
+	if (pip && XFS_INHERIT_GID(pip)) {
+		ip->i_d.di_gid = pip->i_d.di_gid;
+		if ((pip->i_d.di_mode & S_ISGID) && S_ISDIR(mode)) {
+			ip->i_d.di_mode |= S_ISGID;
+		}
+	}
+
+	/*
+	 * If the group ID of the new file does not match the effective group
+	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
+	 * (and only if the irix_sgid_inherit compatibility variable is set).
+	 */
+	if ((irix_sgid_inherit) &&
+	    (ip->i_d.di_mode & S_ISGID) &&
+	    (!in_group_p((gid_t)ip->i_d.di_gid))) {
+		ip->i_d.di_mode &= ~S_ISGID;
+	}
+
+	ip->i_d.di_size = 0;
+	ip->i_d.di_nextents = 0;
+	ASSERT(ip->i_d.di_nblocks == 0);
+
+	nanotime(&tv);
+	ip->i_d.di_mtime.t_sec = (__int32_t)tv.tv_sec;
+	ip->i_d.di_mtime.t_nsec = (__int32_t)tv.tv_nsec;
+	ip->i_d.di_atime = ip->i_d.di_mtime;
+	ip->i_d.di_ctime = ip->i_d.di_mtime;
+
+	/*
+	 * di_gen will have been taken care of in xfs_iread.
+	 */
+	ip->i_d.di_extsize = 0;
+	ip->i_d.di_dmevmask = 0;
+	ip->i_d.di_dmstate = 0;
+	ip->i_d.di_flags = 0;
+
+	if (ip->i_d.di_version == 3) {
+		ASSERT(ip->i_d.di_ino == ino);
+		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid));
+		ip->i_d.di_crc = 0;
+		ip->i_d.di_changecount = 1;
+		ip->i_d.di_lsn = 0;
+		ip->i_d.di_flags2 = 0;
+		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
+		ip->i_d.di_crtime = ip->i_d.di_mtime;
+	}
+
+
+	flags = XFS_ILOG_CORE;
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		ip->i_d.di_format = XFS_DINODE_FMT_DEV;
+		ip->i_df.if_u2.if_rdev = rdev;
+		ip->i_df.if_flags = 0;
+		flags |= XFS_ILOG_DEV;
+		break;
+	case S_IFREG:
+		/*
+		 * we can't set up filestreams until after the VFS inode
+		 * is set up properly.
+		 */
+		if (pip && xfs_inode_is_filestream(pip))
+			filestreams = 1;
+		/* fall through */
+	case S_IFDIR:
+		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
+			uint	di_flags = 0;
+
+			if (S_ISDIR(mode)) {
+				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+					di_flags |= XFS_DIFLAG_RTINHERIT;
+				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+					ip->i_d.di_extsize = pip->i_d.di_extsize;
+				}
+			} else if (S_ISREG(mode)) {
+				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+					di_flags |= XFS_DIFLAG_REALTIME;
+				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+					di_flags |= XFS_DIFLAG_EXTSIZE;
+					ip->i_d.di_extsize = pip->i_d.di_extsize;
+				}
+			}
+			if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
+			    xfs_inherit_noatime)
+				di_flags |= XFS_DIFLAG_NOATIME;
+			if ((pip->i_d.di_flags & XFS_DIFLAG_NODUMP) &&
+			    xfs_inherit_nodump)
+				di_flags |= XFS_DIFLAG_NODUMP;
+			if ((pip->i_d.di_flags & XFS_DIFLAG_SYNC) &&
+			    xfs_inherit_sync)
+				di_flags |= XFS_DIFLAG_SYNC;
+			if ((pip->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) &&
+			    xfs_inherit_nosymlinks)
+				di_flags |= XFS_DIFLAG_NOSYMLINKS;
+			if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+				di_flags |= XFS_DIFLAG_PROJINHERIT;
+			if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
+			    xfs_inherit_nodefrag)
+				di_flags |= XFS_DIFLAG_NODEFRAG;
+			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
+				di_flags |= XFS_DIFLAG_FILESTREAM;
+			ip->i_d.di_flags |= di_flags;
+		}
+		/* FALLTHROUGH */
+	case S_IFLNK:
+		ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
+		ip->i_df.if_flags = XFS_IFEXTENTS;
+		ip->i_df.if_bytes = ip->i_df.if_real_bytes = 0;
+		ip->i_df.if_u1.if_extents = NULL;
+		break;
+	default:
+		ASSERT(0);
+	}
+	/*
+	 * Attribute fork settings for new inode.
+	 */
+	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+	ip->i_d.di_anextents = 0;
+
+	/*
+	 * Log the new values stuffed into the inode.
+	 */
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, flags);
+
+	/* now that we have an i_mode we can setup inode ops and unlock */
+	xfs_setup_inode(ip);
+
+	/* now we have set up the vfs inode we can associate the filestream */
+	if (filestreams) {
+		error = xfs_filestream_associate(pip, ip);
+		if (error < 0)
+			return -error;
+		if (!error)
+			xfs_iflags_set(ip, XFS_IFILESTREAM);
+	}
+
+	*ipp = ip;
+	return 0;
+}
+
+/*
+ * Free up the underlying blocks past new_size.  The new size must be smaller
+ * than the current size.  This routine can be used both for the attribute and
+ * data fork, and does not modify the inode size, which is left to the caller.
+ *
+ * The transaction passed to this routine must have made a permanent log
+ * reservation of at least XFS_ITRUNCATE_LOG_RES.  This routine may commit the
+ * given transaction and start new ones, so make sure everything involved in
+ * the transaction is tidy before calling here.  Some transaction will be
+ * returned to the caller to be committed.  The incoming transaction must
+ * already include the inode, and both inode locks must be held exclusively.
+ * The inode must also be "held" within the transaction.  On return the inode
+ * will be "held" within the returned transaction.  This routine does NOT
+ * require any disk space to be reserved for it within the transaction.
+ *
+ * If we get an error, we must return with the inode locked and linked into the
+ * current transaction. This keeps things simple for the higher level code,
+ * because it always knows that the inode is locked and held in the transaction
+ * that returns to it whether errors occur or not.  We don't mark the inode
+ * dirty on error so that transactions can be easily aborted if possible.
+ */
+int
+xfs_itruncate_extents(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	xfs_fsize_t		new_size)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp = *tpp;
+	struct xfs_trans	*ntp;
+	xfs_bmap_free_t		free_list;
+	xfs_fsblock_t		first_block;
+	xfs_fileoff_t		first_unmap_block;
+	xfs_fileoff_t		last_block;
+	xfs_filblks_t		unmap_len;
+	int			committed;
+	int			error = 0;
+	int			done = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
+	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	ASSERT(new_size <= XFS_ISIZE(ip));
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+	ASSERT(ip->i_itemp != NULL);
+	ASSERT(ip->i_itemp->ili_lock_flags == 0);
+	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+
+	trace_xfs_itruncate_extents_start(ip, new_size);
+
+	/*
+	 * Since it is possible for space to become allocated beyond
+	 * the end of the file (in a crash where the space is allocated
+	 * but the inode size is not yet updated), simply remove any
+	 * blocks which show up between the new EOF and the maximum
+	 * possible file size.  If the first block to be removed is
+	 * beyond the maximum file size (ie it is the same as last_block),
+	 * then there is nothing to do.
+	 */
+	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
+	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
+	if (first_unmap_block == last_block)
+		return 0;
+
+	ASSERT(first_unmap_block < last_block);
+	unmap_len = last_block - first_unmap_block + 1;
+	while (!done) {
+		xfs_bmap_init(&free_list, &first_block);
+		error = xfs_bunmapi(tp, ip,
+				    first_unmap_block, unmap_len,
+				    xfs_bmapi_aflag(whichfork),
+				    XFS_ITRUNC_MAX_EXTENTS,
+				    &first_block, &free_list,
+				    &done);
+		if (error)
+			goto out_bmap_cancel;
+
+		/*
+		 * Duplicate the transaction that has the permanent
+		 * reservation and commit the old transaction.
+		 */
+		error = xfs_bmap_finish(&tp, &free_list, &committed);
+		if (committed)
+			xfs_trans_ijoin(tp, ip, 0);
+		if (error)
+			goto out_bmap_cancel;
+
+		if (committed) {
+			/*
+			 * Mark the inode dirty so it will be logged and
+			 * moved forward in the log as part of every commit.
+			 */
+			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		}
+
+		ntp = xfs_trans_dup(tp);
+		error = xfs_trans_commit(tp, 0);
+		tp = ntp;
+
+		xfs_trans_ijoin(tp, ip, 0);
+
+		if (error)
+			goto out;
+
+		/*
+		 * Transaction commit worked ok so we can drop the extra ticket
+		 * reference that we gained in xfs_trans_dup()
+		 */
+		xfs_log_ticket_put(tp->t_ticket);
+		error = xfs_trans_reserve(tp, 0,
+					XFS_ITRUNCATE_LOG_RES(mp), 0,
+					XFS_TRANS_PERM_LOG_RES,
+					XFS_ITRUNCATE_LOG_COUNT);
+		if (error)
+			goto out;
+	}
+
+	/*
+	 * Always re-log the inode so that our permanent transaction can keep
+	 * on rolling it forward in the log.
+	 */
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	trace_xfs_itruncate_extents_end(ip, new_size);
+
+out:
+	*tpp = tp;
+	return error;
+out_bmap_cancel:
+	/*
+	 * If the bunmapi call encounters an error, return to the caller where
+	 * the transaction can be properly aborted.  We just need to make sure
+	 * we're not holding any resources that we were not when we came in.
+	 */
+	xfs_bmap_cancel(&free_list);
+	goto out;
+}
+
+/*
+ * This is called when the inode's link count goes to 0.
+ * We place the on-disk inode on a list in the AGI.  It
+ * will be pulled from this list when the inode is freed.
+ */
+int
+xfs_iunlink(
+	xfs_trans_t	*tp,
+	xfs_inode_t	*ip)
+{
+	xfs_mount_t	*mp;
+	xfs_agi_t	*agi;
+	xfs_dinode_t	*dip;
+	xfs_buf_t	*agibp;
+	xfs_buf_t	*ibp;
+	xfs_agino_t	agino;
+	short		bucket_index;
+	int		offset;
+	int		error;
+
+	ASSERT(ip->i_d.di_nlink == 0);
+	ASSERT(ip->i_d.di_mode != 0);
+
+	mp = tp->t_mountp;
+
+	/*
+	 * Get the agi buffer first.  It ensures lock ordering
+	 * on the list.
+	 */
+	error = xfs_read_agi(mp, tp, XFS_INO_TO_AGNO(mp, ip->i_ino), &agibp);
+	if (error)
+		return error;
+	agi = XFS_BUF_TO_AGI(agibp);
+
+	/*
+	 * Get the index into the agi hash table for the
+	 * list this inode will go on.
+	 */
+	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	ASSERT(agino != 0);
+	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	ASSERT(agi->agi_unlinked[bucket_index]);
+	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
+
+	if (agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO)) {
+		/*
+		 * There is already another inode in the bucket we need
+		 * to add ourselves to.  Add us at the front of the list.
+		 * Here we put the head pointer into our next pointer,
+		 * and then we fall through to point the head at us.
+		 */
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
+				       0, 0);
+		if (error)
+			return error;
+
+		ASSERT(dip->di_next_unlinked == cpu_to_be32(NULLAGINO));
+		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
+		offset = ip->i_imap.im_boffset +
+			offsetof(xfs_dinode_t, di_next_unlinked);
+
+		/* need to recalc the inode CRC if appropriate */
+		xfs_dinode_calc_crc(mp, dip);
+
+		xfs_trans_inode_buf(tp, ibp);
+		xfs_trans_log_buf(tp, ibp, offset,
+				  (offset + sizeof(xfs_agino_t) - 1));
+		xfs_inobp_check(mp, ibp);
+	}
+
+	/*
+	 * Point the bucket head pointer at the inode being inserted.
+	 */
+	ASSERT(agino != 0);
+	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
+	offset = offsetof(xfs_agi_t, agi_unlinked) +
+		(sizeof(xfs_agino_t) * bucket_index);
+	xfs_trans_log_buf(tp, agibp, offset,
+			  (offset + sizeof(xfs_agino_t) - 1));
+	return 0;
+}
+
+/*
+ * Pull the on-disk inode from the AGI unlinked list.
+ */
+STATIC int
+xfs_iunlink_remove(
+	xfs_trans_t	*tp,
+	xfs_inode_t	*ip)
+{
+	xfs_ino_t	next_ino;
+	xfs_mount_t	*mp;
+	xfs_agi_t	*agi;
+	xfs_dinode_t	*dip;
+	xfs_buf_t	*agibp;
+	xfs_buf_t	*ibp;
+	xfs_agnumber_t	agno;
+	xfs_agino_t	agino;
+	xfs_agino_t	next_agino;
+	xfs_buf_t	*last_ibp;
+	xfs_dinode_t	*last_dip = NULL;
+	short		bucket_index;
+	int		offset, last_offset = 0;
+	int		error;
+
+	mp = tp->t_mountp;
+	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+
+	/*
+	 * Get the agi buffer first.  It ensures lock ordering
+	 * on the list.
+	 */
+	error = xfs_read_agi(mp, tp, agno, &agibp);
+	if (error)
+		return error;
+
+	agi = XFS_BUF_TO_AGI(agibp);
+
+	/*
+	 * Get the index into the agi hash table for the
+	 * list this inode will go on.
+	 */
+	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	ASSERT(agino != 0);
+	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	ASSERT(agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO));
+	ASSERT(agi->agi_unlinked[bucket_index]);
+
+	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
+		/*
+		 * We're at the head of the list.  Get the inode's on-disk
+		 * buffer to see if there is anyone after us on the list.
+		 * Only modify our next pointer if it is not already NULLAGINO.
+		 * This saves us the overhead of dealing with the buffer when
+		 * there is no need to change it.
+		 */
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
+				       0, 0);
+		if (error) {
+			xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
+				__func__, error);
+			return error;
+		}
+		next_agino = be32_to_cpu(dip->di_next_unlinked);
+		ASSERT(next_agino != 0);
+		if (next_agino != NULLAGINO) {
+			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
+			offset = ip->i_imap.im_boffset +
+				offsetof(xfs_dinode_t, di_next_unlinked);
+
+			/* need to recalc the inode CRC if appropriate */
+			xfs_dinode_calc_crc(mp, dip);
+
+			xfs_trans_inode_buf(tp, ibp);
+			xfs_trans_log_buf(tp, ibp, offset,
+					  (offset + sizeof(xfs_agino_t) - 1));
+			xfs_inobp_check(mp, ibp);
+		} else {
+			xfs_trans_brelse(tp, ibp);
+		}
+		/*
+		 * Point the bucket head pointer at the next inode.
+		 */
+		ASSERT(next_agino != 0);
+		ASSERT(next_agino != agino);
+		agi->agi_unlinked[bucket_index] = cpu_to_be32(next_agino);
+		offset = offsetof(xfs_agi_t, agi_unlinked) +
+			(sizeof(xfs_agino_t) * bucket_index);
+		xfs_trans_log_buf(tp, agibp, offset,
+				  (offset + sizeof(xfs_agino_t) - 1));
+	} else {
+		/*
+		 * We need to search the list for the inode being freed.
+		 */
+		next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+		last_ibp = NULL;
+		while (next_agino != agino) {
+			struct xfs_imap	imap;
+
+			if (last_ibp)
+				xfs_trans_brelse(tp, last_ibp);
+
+			imap.im_blkno = 0;
+			next_ino = XFS_AGINO_TO_INO(mp, agno, next_agino);
+
+			error = xfs_imap(mp, tp, next_ino, &imap, 0);
+			if (error) {
+				xfs_warn(mp,
+	"%s: xfs_imap returned error %d.",
+					 __func__, error);
+				return error;
+			}
+
+			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
+					       &last_ibp, 0, 0);
+			if (error) {
+				xfs_warn(mp,
+	"%s: xfs_imap_to_bp returned error %d.",
+					__func__, error);
+				return error;
+			}
+
+			last_offset = imap.im_boffset;
+			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
+			ASSERT(next_agino != NULLAGINO);
+			ASSERT(next_agino != 0);
+		}
+
+		/*
+		 * Now last_ibp points to the buffer previous to us on the
+		 * unlinked list.  Pull us from the list.
+		 */
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
+				       0, 0);
+		if (error) {
+			xfs_warn(mp, "%s: xfs_imap_to_bp(2) returned error %d.",
+				__func__, error);
+			return error;
+		}
+		next_agino = be32_to_cpu(dip->di_next_unlinked);
+		ASSERT(next_agino != 0);
+		ASSERT(next_agino != agino);
+		if (next_agino != NULLAGINO) {
+			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
+			offset = ip->i_imap.im_boffset +
+				offsetof(xfs_dinode_t, di_next_unlinked);
+
+			/* need to recalc the inode CRC if appropriate */
+			xfs_dinode_calc_crc(mp, dip);
+
+			xfs_trans_inode_buf(tp, ibp);
+			xfs_trans_log_buf(tp, ibp, offset,
+					  (offset + sizeof(xfs_agino_t) - 1));
+			xfs_inobp_check(mp, ibp);
+		} else {
+			xfs_trans_brelse(tp, ibp);
+		}
+		/*
+		 * Point the previous inode on the list to the next inode.
+		 */
+		last_dip->di_next_unlinked = cpu_to_be32(next_agino);
+		ASSERT(next_agino != 0);
+		offset = last_offset + offsetof(xfs_dinode_t, di_next_unlinked);
+
+		/* need to recalc the inode CRC if appropriate */
+		xfs_dinode_calc_crc(mp, last_dip);
+
+		xfs_trans_inode_buf(tp, last_ibp);
+		xfs_trans_log_buf(tp, last_ibp, offset,
+				  (offset + sizeof(xfs_agino_t) - 1));
+		xfs_inobp_check(mp, last_ibp);
+	}
+	return 0;
+}
+
+/*
+ * A big issue when freeing the inode cluster is is that we _cannot_ skip any
+ * inodes that are in memory - they all must be marked stale and attached to
+ * the cluster buffer.
+ */
+STATIC int
+xfs_ifree_cluster(
+	xfs_inode_t	*free_ip,
+	xfs_trans_t	*tp,
+	xfs_ino_t	inum)
+{
+	xfs_mount_t		*mp = free_ip->i_mount;
+	int			blks_per_cluster;
+	int			nbufs;
+	int			ninodes;
+	int			i, j;
+	xfs_daddr_t		blkno;
+	xfs_buf_t		*bp;
+	xfs_inode_t		*ip;
+	xfs_inode_log_item_t	*iip;
+	xfs_log_item_t		*lip;
+	struct xfs_perag	*pag;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
+	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
+		blks_per_cluster = 1;
+		ninodes = mp->m_sb.sb_inopblock;
+		nbufs = XFS_IALLOC_BLOCKS(mp);
+	} else {
+		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) /
+					mp->m_sb.sb_blocksize;
+		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
+		nbufs = XFS_IALLOC_BLOCKS(mp) / blks_per_cluster;
+	}
+
+	for (j = 0; j < nbufs; j++, inum += ninodes) {
+		blkno = XFS_AGB_TO_DADDR(mp, XFS_INO_TO_AGNO(mp, inum),
+					 XFS_INO_TO_AGBNO(mp, inum));
+
+		/*
+		 * We obtain and lock the backing buffer first in the process
+		 * here, as we have to ensure that any dirty inode that we
+		 * can't get the flush lock on is attached to the buffer.
+		 * If we scan the in-memory inodes first, then buffer IO can
+		 * complete before we get a lock on it, and hence we may fail
+		 * to mark all the active inodes on the buffer stale.
+		 */
+		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
+					mp->m_bsize * blks_per_cluster,
+					XBF_UNMAPPED);
+
+		if (!bp)
+			return ENOMEM;
+
+		/*
+		 * This buffer may not have been correctly initialised as we
+		 * didn't read it from disk. That's not important because we are
+		 * only using to mark the buffer as stale in the log, and to
+		 * attach stale cached inodes on it. That means it will never be
+		 * dispatched for IO. If it is, we want to know about it, and we
+		 * want it to fail. We can acheive this by adding a write
+		 * verifier to the buffer.
+		 */
+		 bp->b_ops = &xfs_inode_buf_ops;
+
+		/*
+		 * Walk the inodes already attached to the buffer and mark them
+		 * stale. These will all have the flush locks held, so an
+		 * in-memory inode walk can't lock them. By marking them all
+		 * stale first, we will not attempt to lock them in the loop
+		 * below as the XFS_ISTALE flag will be set.
+		 */
+		lip = bp->b_fspriv;
+		while (lip) {
+			if (lip->li_type == XFS_LI_INODE) {
+				iip = (xfs_inode_log_item_t *)lip;
+				ASSERT(iip->ili_logged == 1);
+				lip->li_cb = xfs_istale_done;
+				xfs_trans_ail_copy_lsn(mp->m_ail,
+							&iip->ili_flush_lsn,
+							&iip->ili_item.li_lsn);
+				xfs_iflags_set(iip->ili_inode, XFS_ISTALE);
+			}
+			lip = lip->li_bio_list;
+		}
+
+
+		/*
+		 * For each inode in memory attempt to add it to the inode
+		 * buffer and set it up for being staled on buffer IO
+		 * completion.  This is safe as we've locked out tail pushing
+		 * and flushing by locking the buffer.
+		 *
+		 * We have already marked every inode that was part of a
+		 * transaction stale above, which means there is no point in
+		 * even trying to lock them.
+		 */
+		for (i = 0; i < ninodes; i++) {
+retry:
+			rcu_read_lock();
+			ip = radix_tree_lookup(&pag->pag_ici_root,
+					XFS_INO_TO_AGINO(mp, (inum + i)));
+
+			/* Inode not in memory, nothing to do */
+			if (!ip) {
+				rcu_read_unlock();
+				continue;
+			}
+
+			/*
+			 * because this is an RCU protected lookup, we could
+			 * find a recently freed or even reallocated inode
+			 * during the lookup. We need to check under the
+			 * i_flags_lock for a valid inode here. Skip it if it
+			 * is not valid, the wrong inode or stale.
+			 */
+			spin_lock(&ip->i_flags_lock);
+			if (ip->i_ino != inum + i ||
+			    __xfs_iflags_test(ip, XFS_ISTALE)) {
+				spin_unlock(&ip->i_flags_lock);
+				rcu_read_unlock();
+				continue;
+			}
+			spin_unlock(&ip->i_flags_lock);
+
+			/*
+			 * Don't try to lock/unlock the current inode, but we
+			 * _cannot_ skip the other inodes that we did not find
+			 * in the list attached to the buffer and are not
+			 * already marked stale. If we can't lock it, back off
+			 * and retry.
+			 */
+			if (ip != free_ip &&
+			    !xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
+				rcu_read_unlock();
+				delay(1);
+				goto retry;
+			}
+			rcu_read_unlock();
+
+			xfs_iflock(ip);
+			xfs_iflags_set(ip, XFS_ISTALE);
+
+			/*
+			 * we don't need to attach clean inodes or those only
+			 * with unlogged changes (which we throw away, anyway).
+			 */
+			iip = ip->i_itemp;
+			if (!iip || xfs_inode_clean(ip)) {
+				ASSERT(ip != free_ip);
+				xfs_ifunlock(ip);
+				xfs_iunlock(ip, XFS_ILOCK_EXCL);
+				continue;
+			}
+
+			iip->ili_last_fields = iip->ili_fields;
+			iip->ili_fields = 0;
+			iip->ili_logged = 1;
+			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
+						&iip->ili_item.li_lsn);
+
+			xfs_buf_attach_iodone(bp, xfs_istale_done,
+						  &iip->ili_item);
+
+			if (ip != free_ip)
+				xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		}
+
+		xfs_trans_stale_inode_buf(tp, bp);
+		xfs_trans_binval(tp, bp);
+	}
+
+	xfs_perag_put(pag);
+	return 0;
+}
+
+/*
+ * This is called to return an inode to the inode free list.
+ * The inode should already be truncated to 0 length and have
+ * no pages associated with it.  This routine also assumes that
+ * the inode is already a part of the transaction.
+ *
+ * The on-disk copy of the inode will have been added to the list
+ * of unlinked inodes in the AGI. We need to remove the inode from
+ * that list atomically with respect to freeing it here.
+ */
+int
+xfs_ifree(
+	xfs_trans_t	*tp,
+	xfs_inode_t	*ip,
+	xfs_bmap_free_t	*flist)
+{
+	int			error;
+	int			delete;
+	xfs_ino_t		first_ino;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(ip->i_d.di_nlink == 0);
+	ASSERT(ip->i_d.di_nextents == 0);
+	ASSERT(ip->i_d.di_anextents == 0);
+	ASSERT(ip->i_d.di_size == 0 || !S_ISREG(ip->i_d.di_mode));
+	ASSERT(ip->i_d.di_nblocks == 0);
+
+	/*
+	 * Pull the on-disk inode from the AGI unlinked list.
+	 */
+	error = xfs_iunlink_remove(tp, ip);
+	if (error)
+		return error;
+
+	error = xfs_difree(tp, ip->i_ino, flist, &delete, &first_ino);
+	if (error)
+		return error;
+
+	ip->i_d.di_mode = 0;		/* mark incore inode as free */
+	ip->i_d.di_flags = 0;
+	ip->i_d.di_dmevmask = 0;
+	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
+	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
+	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+	/*
+	 * Bump the generation count so no one will be confused
+	 * by reincarnations of this inode.
+	 */
+	ip->i_d.di_gen++;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	if (delete)
+		error = xfs_ifree_cluster(ip, tp, first_ino);
+
+	return error;
+}
+
+STATIC int
+xfs_iflush_int(
+	struct xfs_inode	*ip,
+	struct xfs_buf		*bp)
+{
+	struct xfs_inode_log_item *iip = ip->i_itemp;
+	struct xfs_dinode	*dip;
+	struct xfs_mount	*mp = ip->i_mount;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isiflocked(ip));
+	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
+	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
+	ASSERT(iip != NULL && iip->ili_fields != 0);
+
+	/* set *dip = inode's place in the buffer */
+	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
+
+	if (XFS_TEST_ERROR(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC),
+			       mp, XFS_ERRTAG_IFLUSH_1, XFS_RANDOM_IFLUSH_1)) {
+		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+			"%s: Bad inode %Lu magic number 0x%x, ptr 0x%p",
+			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
+		goto corrupt_out;
+	}
+	if (XFS_TEST_ERROR(ip->i_d.di_magic != XFS_DINODE_MAGIC,
+				mp, XFS_ERRTAG_IFLUSH_2, XFS_RANDOM_IFLUSH_2)) {
+		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+			"%s: Bad inode %Lu, ptr 0x%p, magic number 0x%x",
+			__func__, ip->i_ino, ip, ip->i_d.di_magic);
+		goto corrupt_out;
+	}
+	if (S_ISREG(ip->i_d.di_mode)) {
+		if (XFS_TEST_ERROR(
+		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
+		    mp, XFS_ERRTAG_IFLUSH_3, XFS_RANDOM_IFLUSH_3)) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad regular inode %Lu, ptr 0x%p",
+				__func__, ip->i_ino, ip);
+			goto corrupt_out;
+		}
+	} else if (S_ISDIR(ip->i_d.di_mode)) {
+		if (XFS_TEST_ERROR(
+		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
+		    (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL),
+		    mp, XFS_ERRTAG_IFLUSH_4, XFS_RANDOM_IFLUSH_4)) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad directory inode %Lu, ptr 0x%p",
+				__func__, ip->i_ino, ip);
+			goto corrupt_out;
+		}
+	}
+	if (XFS_TEST_ERROR(ip->i_d.di_nextents + ip->i_d.di_anextents >
+				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5,
+				XFS_RANDOM_IFLUSH_5)) {
+		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+			"%s: detected corrupt incore inode %Lu, "
+			"total extents = %d, nblocks = %Ld, ptr 0x%p",
+			__func__, ip->i_ino,
+			ip->i_d.di_nextents + ip->i_d.di_anextents,
+			ip->i_d.di_nblocks, ip);
+		goto corrupt_out;
+	}
+	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
+				mp, XFS_ERRTAG_IFLUSH_6, XFS_RANDOM_IFLUSH_6)) {
+		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+			"%s: bad inode %Lu, forkoff 0x%x, ptr 0x%p",
+			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
+		goto corrupt_out;
+	}
+	/*
+	 * bump the flush iteration count, used to detect flushes which
+	 * postdate a log record during recovery. This is redundant as we now
+	 * log every change and hence this can't happen. Still, it doesn't hurt.
+	 */
+	ip->i_d.di_flushiter++;
+
+	/*
+	 * Copy the dirty parts of the inode into the on-disk
+	 * inode.  We always copy out the core of the inode,
+	 * because if the inode is dirty at all the core must
+	 * be.
+	 */
+	xfs_dinode_to_disk(dip, &ip->i_d);
+
+	/* Wrap, we never let the log put out DI_MAX_FLUSH */
+	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
+		ip->i_d.di_flushiter = 0;
+
+	/*
+	 * If this is really an old format inode and the superblock version
+	 * has not been updated to support only new format inodes, then
+	 * convert back to the old inode format.  If the superblock version
+	 * has been updated, then make the conversion permanent.
+	 */
+	ASSERT(ip->i_d.di_version == 1 || xfs_sb_version_hasnlink(&mp->m_sb));
+	if (ip->i_d.di_version == 1) {
+		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
+			/*
+			 * Convert it back.
+			 */
+			ASSERT(ip->i_d.di_nlink <= XFS_MAXLINK_1);
+			dip->di_onlink = cpu_to_be16(ip->i_d.di_nlink);
+		} else {
+			/*
+			 * The superblock version has already been bumped,
+			 * so just make the conversion to the new inode
+			 * format permanent.
+			 */
+			ip->i_d.di_version = 2;
+			dip->di_version = 2;
+			ip->i_d.di_onlink = 0;
+			dip->di_onlink = 0;
+			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
+			memset(&(dip->di_pad[0]), 0,
+			      sizeof(dip->di_pad));
+			ASSERT(xfs_get_projid(ip) == 0);
+		}
+	}
+
+	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK, bp);
+	if (XFS_IFORK_Q(ip))
+		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK, bp);
+	xfs_inobp_check(mp, bp);
+
+	/*
+	 * We've recorded everything logged in the inode, so we'd like to clear
+	 * the ili_fields bits so we don't log and flush things unnecessarily.
+	 * However, we can't stop logging all this information until the data
+	 * we've copied into the disk buffer is written to disk.  If we did we
+	 * might overwrite the copy of the inode in the log with all the data
+	 * after re-logging only part of it, and in the face of a crash we
+	 * wouldn't have all the data we need to recover.
+	 *
+	 * What we do is move the bits to the ili_last_fields field.  When
+	 * logging the inode, these bits are moved back to the ili_fields field.
+	 * In the xfs_iflush_done() routine we clear ili_last_fields, since we
+	 * know that the information those bits represent is permanently on
+	 * disk.  As long as the flush completes before the inode is logged
+	 * again, then both ili_fields and ili_last_fields will be cleared.
+	 *
+	 * We can play with the ili_fields bits here, because the inode lock
+	 * must be held exclusively in order to set bits there and the flush
+	 * lock protects the ili_last_fields bits.  Set ili_logged so the flush
+	 * done routine can tell whether or not to look in the AIL.  Also, store
+	 * the current LSN of the inode so that we can tell whether the item has
+	 * moved in the AIL from xfs_iflush_done().  In order to read the lsn we
+	 * need the AIL lock, because it is a 64 bit value that cannot be read
+	 * atomically.
+	 */
+	iip->ili_last_fields = iip->ili_fields;
+	iip->ili_fields = 0;
+	iip->ili_logged = 1;
+
+	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
+				&iip->ili_item.li_lsn);
+
+	/*
+	 * Attach the function xfs_iflush_done to the inode's
+	 * buffer.  This will remove the inode from the AIL
+	 * and unlock the inode's flush lock when the inode is
+	 * completely written to disk.
+	 */
+	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
+
+	/* update the lsn in the on disk inode if required */
+	if (ip->i_d.di_version == 3)
+		dip->di_lsn = cpu_to_be64(iip->ili_item.li_lsn);
+
+	/* generate the checksum. */
+	xfs_dinode_calc_crc(mp, dip);
+
+	ASSERT(bp->b_fspriv != NULL);
+	ASSERT(bp->b_iodone != NULL);
+	return 0;
+
+corrupt_out:
+	return XFS_ERROR(EFSCORRUPTED);
+}
+
+STATIC int
+xfs_iflush_cluster(
+	xfs_inode_t	*ip,
+	xfs_buf_t	*bp)
+{
+	xfs_mount_t		*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	unsigned long		first_index, mask;
+	unsigned long		inodes_per_cluster;
+	int			ilist_size;
+	xfs_inode_t		**ilist;
+	xfs_inode_t		*iq;
+	int			nr_found;
+	int			clcount = 0;
+	int			bufwasdelwri;
+	int			i;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+
+	inodes_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog;
+	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
+	ilist = kmem_alloc(ilist_size, KM_MAYFAIL|KM_NOFS);
+	if (!ilist)
+		goto out_put;
+
+	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
+	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
+	rcu_read_lock();
+	/* really need a gang lookup range call here */
+	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)ilist,
+					first_index, inodes_per_cluster);
+	if (nr_found == 0)
+		goto out_free;
+
+	for (i = 0; i < nr_found; i++) {
+		iq = ilist[i];
+		if (iq == ip)
+			continue;
+
+		/*
+		 * because this is an RCU protected lookup, we could find a
+		 * recently freed or even reallocated inode during the lookup.
+		 * We need to check under the i_flags_lock for a valid inode
+		 * here. Skip it if it is not valid or the wrong inode.
+		 */
+		spin_lock(&ip->i_flags_lock);
+		if (!ip->i_ino ||
+		    (XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) != first_index) {
+			spin_unlock(&ip->i_flags_lock);
+			continue;
+		}
+		spin_unlock(&ip->i_flags_lock);
+
+		/*
+		 * Do an un-protected check to see if the inode is dirty and
+		 * is a candidate for flushing.  These checks will be repeated
+		 * later after the appropriate locks are acquired.
+		 */
+		if (xfs_inode_clean(iq) && xfs_ipincount(iq) == 0)
+			continue;
+
+		/*
+		 * Try to get locks.  If any are unavailable or it is pinned,
+		 * then this inode cannot be flushed and is skipped.
+		 */
+
+		if (!xfs_ilock_nowait(iq, XFS_ILOCK_SHARED))
+			continue;
+		if (!xfs_iflock_nowait(iq)) {
+			xfs_iunlock(iq, XFS_ILOCK_SHARED);
+			continue;
+		}
+		if (xfs_ipincount(iq)) {
+			xfs_ifunlock(iq);
+			xfs_iunlock(iq, XFS_ILOCK_SHARED);
+			continue;
+		}
+
+		/*
+		 * arriving here means that this inode can be flushed.  First
+		 * re-check that it's dirty before flushing.
+		 */
+		if (!xfs_inode_clean(iq)) {
+			int	error;
+			error = xfs_iflush_int(iq, bp);
+			if (error) {
+				xfs_iunlock(iq, XFS_ILOCK_SHARED);
+				goto cluster_corrupt_out;
+			}
+			clcount++;
+		} else {
+			xfs_ifunlock(iq);
+		}
+		xfs_iunlock(iq, XFS_ILOCK_SHARED);
+	}
+
+	if (clcount) {
+		XFS_STATS_INC(xs_icluster_flushcnt);
+		XFS_STATS_ADD(xs_icluster_flushinode, clcount);
+	}
+
+out_free:
+	rcu_read_unlock();
+	kmem_free(ilist);
+out_put:
+	xfs_perag_put(pag);
+	return 0;
+
+
+cluster_corrupt_out:
+	/*
+	 * Corruption detected in the clustering loop.  Invalidate the
+	 * inode buffer and shut down the filesystem.
+	 */
+	rcu_read_unlock();
+	/*
+	 * Clean up the buffer.  If it was delwri, just release it --
+	 * brelse can handle it with no problems.  If not, shut down the
+	 * filesystem before releasing the buffer.
+	 */
+	bufwasdelwri = (bp->b_flags & _XBF_DELWRI_Q);
+	if (bufwasdelwri)
+		xfs_buf_relse(bp);
+
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+
+	if (!bufwasdelwri) {
+		/*
+		 * Just like incore_relse: if we have b_iodone functions,
+		 * mark the buffer as an error and call them.  Otherwise
+		 * mark it as stale and brelse.
+		 */
+		if (bp->b_iodone) {
+			XFS_BUF_UNDONE(bp);
+			xfs_buf_stale(bp);
+			xfs_buf_ioerror(bp, EIO);
+			xfs_buf_ioend(bp, 0);
+		} else {
+			xfs_buf_stale(bp);
+			xfs_buf_relse(bp);
+		}
+	}
+
+	/*
+	 * Unlocks the flush lock
+	 */
+	xfs_iflush_abort(iq, false);
+	kmem_free(ilist);
+	xfs_perag_put(pag);
+	return XFS_ERROR(EFSCORRUPTED);
+}
+
+/*
+ * Flush dirty inode metadata into the backing buffer.
+ *
+ * The caller must have the inode lock and the inode flush lock held.  The
+ * inode lock will still be held upon return to the caller, and the inode
+ * flush lock will be released after the inode has reached the disk.
+ *
+ * The caller must write out the buffer returned in *bpp and release it.
+ */
+int
+xfs_iflush(
+	struct xfs_inode	*ip,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buf		*bp;
+	struct xfs_dinode	*dip;
+	int			error;
+
+	XFS_STATS_INC(xs_iflush_count);
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_isiflocked(ip));
+	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
+	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
+
+	*bpp = NULL;
+
+	xfs_iunpin_wait(ip);
+
+	/*
+	 * For stale inodes we cannot rely on the backing buffer remaining
+	 * stale in cache for the remaining life of the stale inode and so
+	 * xfs_imap_to_bp() below may give us a buffer that no longer contains
+	 * inodes below. We have to check this after ensuring the inode is
+	 * unpinned so that it is safe to reclaim the stale inode after the
+	 * flush call.
+	 */
+	if (xfs_iflags_test(ip, XFS_ISTALE)) {
+		xfs_ifunlock(ip);
+		return 0;
+	}
+
+	/*
+	 * This may have been unpinned because the filesystem is shutting
+	 * down forcibly. If that's the case we must not write this inode
+	 * to disk, because the log record didn't make it to disk.
+	 *
+	 * We also have to remove the log item from the AIL in this case,
+	 * as we wait for an empty AIL as part of the unmount process.
+	 */
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		error = XFS_ERROR(EIO);
+		goto abort_out;
+	}
+
+	/*
+	 * Get the buffer containing the on-disk inode.
+	 */
+	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK,
+			       0);
+	if (error || !bp) {
+		xfs_ifunlock(ip);
+		return error;
+	}
+
+	/*
+	 * First flush out the inode that xfs_iflush was called with.
+	 */
+	error = xfs_iflush_int(ip, bp);
+	if (error)
+		goto corrupt_out;
+
+	/*
+	 * If the buffer is pinned then push on the log now so we won't
+	 * get stuck waiting in the write for too long.
+	 */
+	if (xfs_buf_ispinned(bp))
+		xfs_log_force(mp, 0);
+
+	/*
+	 * inode clustering:
+	 * see if other inodes can be gathered into this write
+	 */
+	error = xfs_iflush_cluster(ip, bp);
+	if (error)
+		goto cluster_corrupt_out;
+
+	*bpp = bp;
+	return 0;
+
+corrupt_out:
+	xfs_buf_relse(bp);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+cluster_corrupt_out:
+	error = XFS_ERROR(EFSCORRUPTED);
+abort_out:
+	/*
+	 * Unlocks the flush lock
+	 */
+	xfs_iflush_abort(ip, false);
+	return error;
+}
+
diff --git a/fs/xfs/xfs_inode_ops.h b/fs/xfs/xfs_inode_ops.h
new file mode 100644
index 0000000..8556f5a
--- /dev/null
+++ b/fs/xfs/xfs_inode_ops.h
@@ -0,0 +1,353 @@
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef	__XFS_INODE_OPS_H__
+#define	__XFS_INODE_OPS_H__
+
+/* kernel only definitions */
+
+struct xfs_buf;
+struct xfs_bmap_free;
+struct xfs_bmbt_irec;
+struct xfs_inode_log_item;
+struct xfs_mount;
+struct xfs_trans;
+struct xfs_dquot;
+
+typedef struct xfs_inode {
+	/* Inode linking and identification information. */
+	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
+	struct xfs_dquot	*i_udquot;	/* user dquot */
+	struct xfs_dquot	*i_gdquot;	/* group dquot */
+
+	/* Inode location stuff */
+	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
+	struct xfs_imap		i_imap;		/* location for xfs_imap() */
+
+	/* Extent information. */
+	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
+	xfs_ifork_t		i_df;		/* data fork */
+
+	/* Transaction and locking information. */
+	struct xfs_inode_log_item *i_itemp;	/* logging information */
+	mrlock_t		i_lock;		/* inode lock */
+	mrlock_t		i_iolock;	/* inode IO lock */
+	atomic_t		i_pincount;	/* inode pin count */
+	spinlock_t		i_flags_lock;	/* inode i_flags lock */
+	/* Miscellaneous state. */
+	unsigned long		i_flags;	/* see defined flags below */
+	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
+
+	xfs_icdinode_t		i_d;		/* most of ondisk inode */
+
+	/* VFS inode */
+	struct inode		i_vnode;	/* embedded VFS inode */
+} xfs_inode_t;
+
+/* Convert from vfs inode to xfs inode */
+static inline struct xfs_inode *XFS_I(struct inode *inode)
+{
+	return container_of(inode, struct xfs_inode, i_vnode);
+}
+
+/* convert from xfs inode to vfs inode */
+static inline struct inode *VFS_I(struct xfs_inode *ip)
+{
+	return &ip->i_vnode;
+}
+
+/*
+ * For regular files we only update the on-disk filesize when actually
+ * writing data back to disk.  Until then only the copy in the VFS inode
+ * is uptodate.
+ */
+static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
+{
+	if (S_ISREG(ip->i_d.di_mode))
+		return i_size_read(VFS_I(ip));
+	return ip->i_d.di_size;
+}
+
+/*
+ * If this I/O goes past the on-disk inode size update it unless it would
+ * be past the current in-core inode size.
+ */
+static inline xfs_fsize_t
+xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
+{
+	xfs_fsize_t i_size = i_size_read(VFS_I(ip));
+
+	if (new_size > i_size)
+		new_size = i_size;
+	return new_size > ip->i_d.di_size ? new_size : 0;
+}
+
+/*
+ * i_flags helper functions
+ */
+static inline void
+__xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
+{
+	ip->i_flags |= flags;
+}
+
+static inline void
+xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
+{
+	spin_lock(&ip->i_flags_lock);
+	__xfs_iflags_set(ip, flags);
+	spin_unlock(&ip->i_flags_lock);
+}
+
+static inline void
+xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
+{
+	spin_lock(&ip->i_flags_lock);
+	ip->i_flags &= ~flags;
+	spin_unlock(&ip->i_flags_lock);
+}
+
+static inline int
+__xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
+{
+	return (ip->i_flags & flags);
+}
+
+static inline int
+xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
+{
+	int ret;
+	spin_lock(&ip->i_flags_lock);
+	ret = __xfs_iflags_test(ip, flags);
+	spin_unlock(&ip->i_flags_lock);
+	return ret;
+}
+
+static inline int
+xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned short flags)
+{
+	int ret;
+
+	spin_lock(&ip->i_flags_lock);
+	ret = ip->i_flags & flags;
+	if (ret)
+		ip->i_flags &= ~flags;
+	spin_unlock(&ip->i_flags_lock);
+	return ret;
+}
+
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
+/*
+ * Project quota id helpers (previously projid was 16bit only
+ * and using two 16bit values to hold new 32bit projid was chosen
+ * to retain compatibility with "old" filesystems).
+ */
+static inline prid_t
+xfs_get_projid(struct xfs_inode *ip)
+{
+	return (prid_t)ip->i_d.di_projid_hi << 16 | ip->i_d.di_projid_lo;
+}
+
+static inline void
+xfs_set_projid(struct xfs_inode *ip,
+		prid_t projid)
+{
+	ip->i_d.di_projid_hi = (__uint16_t) (projid >> 16);
+	ip->i_d.di_projid_lo = (__uint16_t) (projid & 0xffff);
+}
+
+/*
+ * In-core inode flags.
+ */
+#define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
+#define XFS_ISTALE		(1 << 1) /* inode has been staled */
+#define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
+#define XFS_INEW		(1 << 3) /* inode has just been allocated */
+#define XFS_IFILESTREAM		(1 << 4) /* inode is in a filestream dir. */
+#define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
+#define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
+#define __XFS_IFLOCK_BIT	7	 /* inode is being flushed right now */
+#define XFS_IFLOCK		(1 << __XFS_IFLOCK_BIT)
+#define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
+#define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
+#define XFS_IDONTCACHE		(1 << 9) /* don't cache the inode long term */
+
+/*
+ * Per-lifetime flags need to be reset when re-using a reclaimable inode during
+ * inode lookup. This prevents unintended behaviour on the new inode from
+ * ocurring.
+ */
+#define XFS_IRECLAIM_RESET_FLAGS	\
+	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
+	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | \
+	 XFS_IFILESTREAM);
+
+/*
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
+	smp_mb();
+	wake_up_bit(&ip->i_flags, __XFS_IFLOCK_BIT);
+}
+
+static inline int xfs_isiflocked(struct xfs_inode *ip)
+{
+	return xfs_iflags_test(ip, XFS_IFLOCK);
+}
+
+/*
+ * Flags for inode locking.
+ * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
+ *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
+ */
+#define	XFS_IOLOCK_EXCL		(1<<0)
+#define	XFS_IOLOCK_SHARED	(1<<1)
+#define	XFS_ILOCK_EXCL		(1<<2)
+#define	XFS_ILOCK_SHARED	(1<<3)
+
+#define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
+				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)
+
+#define XFS_LOCK_FLAGS \
+	{ XFS_IOLOCK_EXCL,	"IOLOCK_EXCL" }, \
+	{ XFS_IOLOCK_SHARED,	"IOLOCK_SHARED" }, \
+	{ XFS_ILOCK_EXCL,	"ILOCK_EXCL" }, \
+	{ XFS_ILOCK_SHARED,	"ILOCK_SHARED" }
+
+
+/*
+ * Flags for lockdep annotations.
+ *
+ * XFS_LOCK_PARENT - for directory operations that require locking a
+ * parent directory inode and a child entry inode.  The parent gets locked
+ * with this flag so it gets a lockdep subclass of 1 and the child entry
+ * lock will have a lockdep subclass of 0.
+ *
+ * XFS_LOCK_RTBITMAP/XFS_LOCK_RTSUM - the realtime device bitmap and summary
+ * inodes do not participate in the normal lock order, and thus have their
+ * own subclasses.
+ *
+ * XFS_LOCK_INUMORDER - for locking several inodes at the some time
+ * with xfs_lock_inodes().  This flag is used as the starting subclass
+ * and each subsequent lock acquired will increment the subclass by one.
+ * So the first lock acquired will have a lockdep subclass of 4, the
+ * second lock will have a lockdep subclass of 5, and so on. It is
+ * the responsibility of the class builder to shift this to the correct
+ * portion of the lock_mode lockdep mask.
+ */
+#define XFS_LOCK_PARENT		1
+#define XFS_LOCK_RTBITMAP	2
+#define XFS_LOCK_RTSUM		3
+#define XFS_LOCK_INUMORDER	4
+
+#define XFS_IOLOCK_SHIFT	16
+#define	XFS_IOLOCK_PARENT	(XFS_LOCK_PARENT << XFS_IOLOCK_SHIFT)
+
+#define XFS_ILOCK_SHIFT		24
+#define	XFS_ILOCK_PARENT	(XFS_LOCK_PARENT << XFS_ILOCK_SHIFT)
+#define	XFS_ILOCK_RTBITMAP	(XFS_LOCK_RTBITMAP << XFS_ILOCK_SHIFT)
+#define	XFS_ILOCK_RTSUM		(XFS_LOCK_RTSUM << XFS_ILOCK_SHIFT)
+
+#define XFS_IOLOCK_DEP_MASK	0x00ff0000
+#define XFS_ILOCK_DEP_MASK	0xff000000
+#define XFS_LOCK_DEP_MASK	(XFS_IOLOCK_DEP_MASK | XFS_ILOCK_DEP_MASK)
+
+#define XFS_IOLOCK_DEP(flags)	(((flags) & XFS_IOLOCK_DEP_MASK) >> XFS_IOLOCK_SHIFT)
+#define XFS_ILOCK_DEP(flags)	(((flags) & XFS_ILOCK_DEP_MASK) >> XFS_ILOCK_SHIFT)
+
+/*
+ * For multiple groups support: if S_ISGID bit is set in the parent
+ * directory, group of new file is set to that of the parent, and
+ * new subdirectory gets S_ISGID bit from parent.
+ */
+#define XFS_INHERIT_GID(pip)	\
+	(((pip)->i_mount->m_flags & XFS_MOUNT_GRPID) || \
+	 ((pip)->i_d.di_mode & S_ISGID))
+
+
+/*
+ * xfs_inode.c prototypes.
+ */
+void		xfs_ilock(xfs_inode_t *, uint);
+int		xfs_ilock_nowait(xfs_inode_t *, uint);
+void		xfs_iunlock(xfs_inode_t *, uint);
+void		xfs_ilock_demote(xfs_inode_t *, uint);
+int		xfs_isilocked(xfs_inode_t *, uint);
+uint		xfs_ilock_map_shared(xfs_inode_t *);
+void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
+int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, umode_t,
+			   xfs_nlink_t, xfs_dev_t, prid_t, int,
+			   struct xfs_buf **, xfs_inode_t **);
+
+uint		xfs_ip2xflags(struct xfs_inode *);
+uint		xfs_dic2xflags(struct xfs_dinode *);
+int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
+			   struct xfs_bmap_free *);
+int		xfs_itruncate_extents(struct xfs_trans **, struct xfs_inode *,
+				      int, xfs_fsize_t);
+int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
+
+void		xfs_iext_realloc(xfs_inode_t *, int, int);
+void		xfs_iunpin_wait(xfs_inode_t *);
+int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
+void		xfs_lock_inodes(xfs_inode_t **, int, uint);
+void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
+
+xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
+
+#define IHOLD(ip) \
+do { \
+	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
+	ihold(VFS_I(ip)); \
+	trace_xfs_ihold(ip, _THIS_IP_); \
+} while (0)
+
+#define IRELE(ip) \
+do { \
+	trace_xfs_irele(ip, _THIS_IP_); \
+	iput(VFS_I(ip)); \
+} while (0)
+
+#endif /* __XFS_INODE_OPS_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
