Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A6D6A29E2C
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:52:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25050AC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:52:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1sS8IrR5agOG4T48 for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:52:32 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpANf-00030C-Qi
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANf-00006L-ML
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 35/60] xfs: start repopulating xfs_inode.[ch] with kernel code
Date: Wed, 19 Jun 2013 14:50:43 +1000
Message-Id: <1371617468-32559-36-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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

Now that xfs_inode.[ch] is no long shared with userspace, we can
start repopulating them with core kernel inode code such as locking
functions and the kernel struct xfs_inode definitions. From this
point onwards, xfs_inode.[ch] is purely for in-kernel inode specific
infrastructure. High level kernel only operations will slowly
migrate and merge with xfs_iops.c, so xfs_inode.[ch] really only
should gather core functions that are shared by other kernel-only
code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c     |  434 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_inode.h     |  134 ++++++++++++++-
 fs/xfs/xfs_inode_ops.c |  415 ---------------------------------------------
 fs/xfs/xfs_inode_ops.h |   64 -------
 4 files changed, 545 insertions(+), 502 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c032da6..25706c7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -15,36 +15,434 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#include <linux/log2.h>
-
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
-#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_attr_sf.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
-#include "xfs_buf_item.h"
-#include "xfs_inode_item.h"
-#include "xfs_btree.h"
-#include "xfs_alloc.h"
-#include "xfs_ialloc.h"
-#include "xfs_bmap.h"
-#include "xfs_error.h"
-#include "xfs_quota.h"
-#include "xfs_filestream.h"
-#include "xfs_cksum.h"
 #include "xfs_trace.h"
-#include "xfs_icache.h"
+
+/* Kernel only core inode infrastructure */
 
 kmem_zone_t *xfs_inode_zone;
 
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
+#ifdef DEBUG
+int xfs_locked_n;
+int xfs_small_retries;
+int xfs_middle_retries;
+int xfs_lots_retries;
+int xfs_lock_delays;
+#endif
+
+/*
+ * Bump the subclass so xfs_lock_inodes() acquires each lock with
+ * a different value
+ */
+static inline int
+xfs_lock_inumorder(int lock_mode, int subclass)
+{
+	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
+		lock_mode |= (subclass + XFS_LOCK_INUMORDER) << XFS_IOLOCK_SHIFT;
+	if (lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL))
+		lock_mode |= (subclass + XFS_LOCK_INUMORDER) << XFS_ILOCK_SHIFT;
+
+	return lock_mode;
+}
+
+/*
+ * The following routine will lock n inodes in exclusive mode.
+ * We assume the caller calls us with the inodes in i_ino order.
+ *
+ * We need to detect deadlock where an inode that we lock
+ * is in the AIL and we start waiting for another inode that is locked
+ * by a thread in a long running transaction (such as truncate). This can
+ * result in deadlock since the long running trans might need to wait
+ * for the inode we just locked in order to push the tail and free space
+ * in the log.
+ */
+void
+xfs_lock_inodes(
+	xfs_inode_t	**ips,
+	int		inodes,
+	uint		lock_mode)
+{
+	int		attempts = 0, i, j, try_lock;
+	xfs_log_item_t	*lp;
+
+	ASSERT(ips && (inodes >= 2)); /* we need at least two */
+
+	try_lock = 0;
+	i = 0;
+
+again:
+	for (; i < inodes; i++) {
+		ASSERT(ips[i]);
+
+		if (i && (ips[i] == ips[i-1]))	/* Already locked */
+			continue;
+
+		/*
+		 * If try_lock is not set yet, make sure all locked inodes
+		 * are not in the AIL.
+		 * If any are, set try_lock to be used later.
+		 */
+
+		if (!try_lock) {
+			for (j = (i - 1); j >= 0 && !try_lock; j--) {
+				lp = (xfs_log_item_t *)ips[j]->i_itemp;
+				if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
+					try_lock++;
+				}
+			}
+		}
+
+		/*
+		 * If any of the previous locks we have locked is in the AIL,
+		 * we must TRY to get the second and subsequent locks. If
+		 * we can't get any, we must release all we have
+		 * and try again.
+		 */
+
+		if (try_lock) {
+			/* try_lock must be 0 if i is 0. */
+			/*
+			 * try_lock means we have an inode locked
+			 * that is in the AIL.
+			 */
+			ASSERT(i != 0);
+			if (!xfs_ilock_nowait(ips[i], xfs_lock_inumorder(lock_mode, i))) {
+				attempts++;
+
+				/*
+				 * Unlock all previous guys and try again.
+				 * xfs_iunlock will try to push the tail
+				 * if the inode is in the AIL.
+				 */
+
+				for(j = i - 1; j >= 0; j--) {
+
+					/*
+					 * Check to see if we've already
+					 * unlocked this one.
+					 * Not the first one going back,
+					 * and the inode ptr is the same.
+					 */
+					if ((j != (i - 1)) && ips[j] ==
+								ips[j+1])
+						continue;
+
+					xfs_iunlock(ips[j], lock_mode);
+				}
+
+				if ((attempts % 5) == 0) {
+					delay(1); /* Don't just spin the CPU */
+#ifdef DEBUG
+					xfs_lock_delays++;
+#endif
+				}
+				i = 0;
+				try_lock = 0;
+				goto again;
+			}
+		} else {
+			xfs_ilock(ips[i], xfs_lock_inumorder(lock_mode, i));
+		}
+	}
+
+#ifdef DEBUG
+	if (attempts) {
+		if (attempts < 5) xfs_small_retries++;
+		else if (attempts < 100) xfs_middle_retries++;
+		else xfs_lots_retries++;
+	} else {
+		xfs_locked_n++;
+	}
+#endif
+}
+
+/*
+ * xfs_lock_two_inodes() can only be used to lock one type of lock
+ * at a time - the iolock or the ilock, but not both at once. If
+ * we lock both at once, lockdep will report false positives saying
+ * we have violated locking orders.
+ */
+void
+xfs_lock_two_inodes(
+	xfs_inode_t		*ip0,
+	xfs_inode_t		*ip1,
+	uint			lock_mode)
+{
+	xfs_inode_t		*temp;
+	int			attempts = 0;
+	xfs_log_item_t		*lp;
+
+	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
+		ASSERT((lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)) == 0);
+	ASSERT(ip0->i_ino != ip1->i_ino);
+
+	if (ip0->i_ino > ip1->i_ino) {
+		temp = ip0;
+		ip0 = ip1;
+		ip1 = temp;
+	}
+
+ again:
+	xfs_ilock(ip0, xfs_lock_inumorder(lock_mode, 0));
+
+	/*
+	 * If the first lock we have locked is in the AIL, we must TRY to get
+	 * the second lock. If we can't get it, we must release the first one
+	 * and try again.
+	 */
+	lp = (xfs_log_item_t *)ip0->i_itemp;
+	if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
+		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(lock_mode, 1))) {
+			xfs_iunlock(ip0, lock_mode);
+			if ((++attempts % 5) == 0)
+				delay(1); /* Don't just spin the CPU */
+			goto again;
+		}
+	} else {
+		xfs_ilock(ip1, xfs_lock_inumorder(lock_mode, 1));
+	}
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 83a8ce3..6afcaa3 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -18,17 +18,141 @@
 #ifndef	__XFS_INODE_H__
 #define	__XFS_INODE_H__
 
-struct xfs_dinode;
-struct xfs_inode;
+//struct xfs_dinode;
+//struct xfs_inode;
 
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_inode_item_format.h"
 
-#ifdef __KERNEL__
+/* kernel only inode definitions */
 
-#include "xfs_inode_ops.h"
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
+	struct xfs_ifork	*i_afp;		/* attribute fork pointer */
+	struct xfs_ifork	i_df;		/* data fork */
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
+	struct xfs_icdinode	i_d;		/* most of ondisk inode */
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
 
-#endif /* __KERNEL__ */
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
+void		xfs_ilock(xfs_inode_t *, uint);
+int		xfs_ilock_nowait(xfs_inode_t *, uint);
+void		xfs_iunlock(xfs_inode_t *, uint);
+void		xfs_ilock_demote(xfs_inode_t *, uint);
+int		xfs_isilocked(xfs_inode_t *, uint);
+uint		xfs_ilock_map_shared(xfs_inode_t *);
+void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
+void		xfs_lock_inodes(xfs_inode_t **, int, uint);
+void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
+
+extern struct kmem_zone	*xfs_inode_zone;
+
+#include "xfs_inode_ops.h"
 
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_inode_ops.c b/fs/xfs/xfs_inode_ops.c
index 7a7f19d..b4d6948 100644
--- a/fs/xfs/xfs_inode_ops.c
+++ b/fs/xfs/xfs_inode_ops.c
@@ -72,421 +72,6 @@ xfs_get_extsz_hint(
 	return 0;
 }
 
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
-#ifdef DEBUG
-int xfs_locked_n;
-int xfs_small_retries;
-int xfs_middle_retries;
-int xfs_lots_retries;
-int xfs_lock_delays;
-#endif
-
-/*
- * Bump the subclass so xfs_lock_inodes() acquires each lock with
- * a different value
- */
-static inline int
-xfs_lock_inumorder(int lock_mode, int subclass)
-{
-	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
-		lock_mode |= (subclass + XFS_LOCK_INUMORDER) << XFS_IOLOCK_SHIFT;
-	if (lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL))
-		lock_mode |= (subclass + XFS_LOCK_INUMORDER) << XFS_ILOCK_SHIFT;
-
-	return lock_mode;
-}
-
-/*
- * The following routine will lock n inodes in exclusive mode.
- * We assume the caller calls us with the inodes in i_ino order.
- *
- * We need to detect deadlock where an inode that we lock
- * is in the AIL and we start waiting for another inode that is locked
- * by a thread in a long running transaction (such as truncate). This can
- * result in deadlock since the long running trans might need to wait
- * for the inode we just locked in order to push the tail and free space
- * in the log.
- */
-void
-xfs_lock_inodes(
-	xfs_inode_t	**ips,
-	int		inodes,
-	uint		lock_mode)
-{
-	int		attempts = 0, i, j, try_lock;
-	xfs_log_item_t	*lp;
-
-	ASSERT(ips && (inodes >= 2)); /* we need at least two */
-
-	try_lock = 0;
-	i = 0;
-
-again:
-	for (; i < inodes; i++) {
-		ASSERT(ips[i]);
-
-		if (i && (ips[i] == ips[i-1]))	/* Already locked */
-			continue;
-
-		/*
-		 * If try_lock is not set yet, make sure all locked inodes
-		 * are not in the AIL.
-		 * If any are, set try_lock to be used later.
-		 */
-
-		if (!try_lock) {
-			for (j = (i - 1); j >= 0 && !try_lock; j--) {
-				lp = (xfs_log_item_t *)ips[j]->i_itemp;
-				if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
-					try_lock++;
-				}
-			}
-		}
-
-		/*
-		 * If any of the previous locks we have locked is in the AIL,
-		 * we must TRY to get the second and subsequent locks. If
-		 * we can't get any, we must release all we have
-		 * and try again.
-		 */
-
-		if (try_lock) {
-			/* try_lock must be 0 if i is 0. */
-			/*
-			 * try_lock means we have an inode locked
-			 * that is in the AIL.
-			 */
-			ASSERT(i != 0);
-			if (!xfs_ilock_nowait(ips[i], xfs_lock_inumorder(lock_mode, i))) {
-				attempts++;
-
-				/*
-				 * Unlock all previous guys and try again.
-				 * xfs_iunlock will try to push the tail
-				 * if the inode is in the AIL.
-				 */
-
-				for(j = i - 1; j >= 0; j--) {
-
-					/*
-					 * Check to see if we've already
-					 * unlocked this one.
-					 * Not the first one going back,
-					 * and the inode ptr is the same.
-					 */
-					if ((j != (i - 1)) && ips[j] ==
-								ips[j+1])
-						continue;
-
-					xfs_iunlock(ips[j], lock_mode);
-				}
-
-				if ((attempts % 5) == 0) {
-					delay(1); /* Don't just spin the CPU */
-#ifdef DEBUG
-					xfs_lock_delays++;
-#endif
-				}
-				i = 0;
-				try_lock = 0;
-				goto again;
-			}
-		} else {
-			xfs_ilock(ips[i], xfs_lock_inumorder(lock_mode, i));
-		}
-	}
-
-#ifdef DEBUG
-	if (attempts) {
-		if (attempts < 5) xfs_small_retries++;
-		else if (attempts < 100) xfs_middle_retries++;
-		else xfs_lots_retries++;
-	} else {
-		xfs_locked_n++;
-	}
-#endif
-}
-
-/*
- * xfs_lock_two_inodes() can only be used to lock one type of lock
- * at a time - the iolock or the ilock, but not both at once. If
- * we lock both at once, lockdep will report false positives saying
- * we have violated locking orders.
- */
-void
-xfs_lock_two_inodes(
-	xfs_inode_t		*ip0,
-	xfs_inode_t		*ip1,
-	uint			lock_mode)
-{
-	xfs_inode_t		*temp;
-	int			attempts = 0;
-	xfs_log_item_t		*lp;
-
-	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
-		ASSERT((lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)) == 0);
-	ASSERT(ip0->i_ino != ip1->i_ino);
-
-	if (ip0->i_ino > ip1->i_ino) {
-		temp = ip0;
-		ip0 = ip1;
-		ip1 = temp;
-	}
-
- again:
-	xfs_ilock(ip0, xfs_lock_inumorder(lock_mode, 0));
-
-	/*
-	 * If the first lock we have locked is in the AIL, we must TRY to get
-	 * the second lock. If we can't get it, we must release the first one
-	 * and try again.
-	 */
-	lp = (xfs_log_item_t *)ip0->i_itemp;
-	if (lp && (lp->li_flags & XFS_LI_IN_AIL)) {
-		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(lock_mode, 1))) {
-			xfs_iunlock(ip0, lock_mode);
-			if ((++attempts % 5) == 0)
-				delay(1); /* Don't just spin the CPU */
-			goto again;
-		}
-	} else {
-		xfs_ilock(ip1, xfs_lock_inumorder(lock_mode, 1));
-	}
-}
-
 
 void
 __xfs_iflock(
diff --git a/fs/xfs/xfs_inode_ops.h b/fs/xfs/xfs_inode_ops.h
index ecaa019..b74e544 100644
--- a/fs/xfs/xfs_inode_ops.h
+++ b/fs/xfs/xfs_inode_ops.h
@@ -28,59 +28,6 @@ struct xfs_mount;
 struct xfs_trans;
 struct xfs_dquot;
 
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
 
 /*
  * If this I/O goes past the on-disk inode size update it unless it would
@@ -324,13 +271,6 @@ int		xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
 int		xfs_free_eofblocks(struct xfs_mount *, struct xfs_inode *, bool);
 bool		xfs_can_free_eofblocks(struct xfs_inode *, bool);
 
-void		xfs_ilock(xfs_inode_t *, uint);
-int		xfs_ilock_nowait(xfs_inode_t *, uint);
-void		xfs_iunlock(xfs_inode_t *, uint);
-void		xfs_ilock_demote(xfs_inode_t *, uint);
-int		xfs_isilocked(xfs_inode_t *, uint);
-uint		xfs_ilock_map_shared(xfs_inode_t *);
-void		xfs_iunlock_map_shared(xfs_inode_t *, uint);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, umode_t,
 			   xfs_nlink_t, xfs_dev_t, prid_t, int,
 			   struct xfs_buf **, xfs_inode_t **);
@@ -349,8 +289,6 @@ void		xfs_iunpin_wait(xfs_inode_t *);
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 
 int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
-void		xfs_lock_inodes(xfs_inode_t **, int, uint);
-void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
 xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
 
@@ -379,6 +317,4 @@ int xfs_droplink(struct xfs_trans *, struct xfs_inode *);
 int xfs_bumplink(struct xfs_trans *, struct xfs_inode *);
 void xfs_bump_ino_vers2(struct xfs_trans *, struct xfs_inode *);
 
-extern struct kmem_zone	*xfs_inode_zone;
-
 #endif /* __XFS_INODE_OPS_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
