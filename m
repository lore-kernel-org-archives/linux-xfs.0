Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 917137CAF
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 13:37:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 645118F8033
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 11:37:37 -0700 (PDT)
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
	[88.96.1.126]) by cuda.sgi.com with ESMTP id 9AfKmmGJyGSHPM91
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jun 2016 11:37:34 -0700 (PDT)
Content-Disposition: inline
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 13 Jun 2016 19:36:37 +0100
Message-ID: <lsq.1465842997.985605441@decadent.org.uk>
Subject: [PATCH 3.16 091/114] xfs: introduce mmap/truncate lock
In-Reply-To: <lsq.1465842997.838358341@decadent.org.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, akpm@linux-foundation.org

3.16.36-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 653c60b633a9019a54a80d64b5ed33ecb214823c upstream.

Right now we cannot serialise mmap against truncate or hole punch
sanely. ->page_mkwrite is not able to take locks that the read IO
path normally takes (i.e. the inode iolock) because that could
result in lock inversions (read - iolock - page fault - page_mkwrite
- iolock) and so we cannot use an IO path lock to serialise page
write faults against truncate operations.

Instead, introduce a new lock that is used *only* in the
->page_mkwrite path that is the equivalent of the iolock. The lock
ordering in a page fault is i_mmaplock -> page lock -> i_ilock,
and so in truncate we can i_iolock -> i_mmaplock and so lock out
new write faults during the process of truncation.

Because i_mmap_lock is outside the page lock, we can hold it across
all the same operations we hold the i_iolock for. The only
difference is that we never hold the i_mmaplock in the normal IO
path and so do not ever have the possibility that we can page fault
inside it. Hence there are no recursion issues on the i_mmap_lock
and so we can use it to serialise page fault IO against inode
modification operations that affect the IO path.

This patch introduces the i_mmaplock infrastructure, lockdep
annotations and initialisation/destruction code. Use of the new lock
will be in subsequent patches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com
---
 fs/xfs/xfs_inode.c | 128 ++++++++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_inode.h |  29 +++++++++---
 fs/xfs/xfs_super.c |   2 +
 3 files changed, 121 insertions(+), 38 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -119,24 +119,34 @@ xfs_ilock_attr_map_shared(
 }
 
 /*
- * The xfs inode contains 2 locks: a multi-reader lock called the
- * i_iolock and a multi-reader lock called the i_lock.  This routine
- * allows either or both of the locks to be obtained.
+ * The xfs inode contains 3 multi-reader locks: the i_iolock the i_mmap_lock and
+ * the i_lock.  This routine allows various combinations of the locks to be
+ * obtained.
  *
- * The 2 locks should always be ordered so that the IO lock is
- * obtained first in order to prevent deadlock.
+ * The 3 locks should always be ordered so that the IO lock is obtained first,
+ * the mmap lock second and the ilock last in order to prevent deadlock.
  *
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
+ * Basic locking order:
+ *
+ * i_iolock -> i_mmap_lock -> page_lock -> i_ilock
+ *
+ * mmap_sem locking order:
+ *
+ * i_iolock -> page lock -> mmap_sem
+ * mmap_sem -> i_mmap_lock -> page_lock
+ *
+ * The difference in mmap_sem locking order mean that we cannot hold the
+ * i_mmap_lock over syscall based read(2)/write(2) based IO. These IO paths can
+ * fault in pages during copy in/out (for buffered IO) or require the mmap_sem
+ * in get_user_pages() to map the user pages into the kernel address space for
+ * direct IO. Similarly the i_iolock cannot be taken inside a page fault because
+ * page faults already hold the mmap_sem.
+ *
+ * Hence to serialise fully against both syscall and mmap based IO, we need to
+ * take both the i_iolock and the i_mmap_lock. These locks should *only* be both
+ * taken in places where we need to invalidate the page cache in a race
+ * free manner (e.g. truncate, hole punch and other extent manipulation
+ * functions).
  */
 void
 xfs_ilock(
@@ -152,6 +162,8 @@ xfs_ilock(
 	 */
 	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
 	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
+	ASSERT((lock_flags & (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL)) !=
+	       (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL));
 	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
 	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
@@ -161,6 +173,11 @@ xfs_ilock(
 	else if (lock_flags & XFS_IOLOCK_SHARED)
 		mraccess_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
 
+	if (lock_flags & XFS_MMAPLOCK_EXCL)
+		mrupdate_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
+	else if (lock_flags & XFS_MMAPLOCK_SHARED)
+		mraccess_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
+
 	if (lock_flags & XFS_ILOCK_EXCL)
 		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
 	else if (lock_flags & XFS_ILOCK_SHARED)
@@ -193,6 +210,8 @@ xfs_ilock_nowait(
 	 */
 	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
 	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
+	ASSERT((lock_flags & (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL)) !=
+	       (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL));
 	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
 	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
@@ -204,21 +223,35 @@ xfs_ilock_nowait(
 		if (!mrtryaccess(&ip->i_iolock))
 			goto out;
 	}
+
+	if (lock_flags & XFS_MMAPLOCK_EXCL) {
+		if (!mrtryupdate(&ip->i_mmaplock))
+			goto out_undo_iolock;
+	} else if (lock_flags & XFS_MMAPLOCK_SHARED) {
+		if (!mrtryaccess(&ip->i_mmaplock))
+			goto out_undo_iolock;
+	}
+
 	if (lock_flags & XFS_ILOCK_EXCL) {
 		if (!mrtryupdate(&ip->i_lock))
-			goto out_undo_iolock;
+			goto out_undo_mmaplock;
 	} else if (lock_flags & XFS_ILOCK_SHARED) {
 		if (!mrtryaccess(&ip->i_lock))
-			goto out_undo_iolock;
+			goto out_undo_mmaplock;
 	}
 	return 1;
 
- out_undo_iolock:
+out_undo_mmaplock:
+	if (lock_flags & XFS_MMAPLOCK_EXCL)
+		mrunlock_excl(&ip->i_mmaplock);
+	else if (lock_flags & XFS_MMAPLOCK_SHARED)
+		mrunlock_shared(&ip->i_mmaplock);
+out_undo_iolock:
 	if (lock_flags & XFS_IOLOCK_EXCL)
 		mrunlock_excl(&ip->i_iolock);
 	else if (lock_flags & XFS_IOLOCK_SHARED)
 		mrunlock_shared(&ip->i_iolock);
- out:
+out:
 	return 0;
 }
 
@@ -246,6 +279,8 @@ xfs_iunlock(
 	 */
 	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
 	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
+	ASSERT((lock_flags & (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL)) !=
+	       (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL));
 	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
 	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
@@ -256,6 +291,11 @@ xfs_iunlock(
 	else if (lock_flags & XFS_IOLOCK_SHARED)
 		mrunlock_shared(&ip->i_iolock);
 
+	if (lock_flags & XFS_MMAPLOCK_EXCL)
+		mrunlock_excl(&ip->i_mmaplock);
+	else if (lock_flags & XFS_MMAPLOCK_SHARED)
+		mrunlock_shared(&ip->i_mmaplock);
+
 	if (lock_flags & XFS_ILOCK_EXCL)
 		mrunlock_excl(&ip->i_lock);
 	else if (lock_flags & XFS_ILOCK_SHARED)
@@ -273,11 +313,14 @@ xfs_ilock_demote(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
 {
-	ASSERT(lock_flags & (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL));
-	ASSERT((lock_flags & ~(XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
+	ASSERT(lock_flags & (XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL|XFS_ILOCK_EXCL));
+	ASSERT((lock_flags &
+		~(XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
 
 	if (lock_flags & XFS_ILOCK_EXCL)
 		mrdemote(&ip->i_lock);
+	if (lock_flags & XFS_MMAPLOCK_EXCL)
+		mrdemote(&ip->i_mmaplock);
 	if (lock_flags & XFS_IOLOCK_EXCL)
 		mrdemote(&ip->i_iolock);
 
@@ -296,6 +339,12 @@ xfs_isilocked(
 		return rwsem_is_locked(&ip->i_lock.mr_lock);
 	}
 
+	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
+		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
+			return !!ip->i_mmaplock.mr_writer;
+		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
+	}
+
 	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
 		if (!(lock_flags & XFS_IOLOCK_SHARED))
 			return !!ip->i_iolock.mr_writer;
@@ -316,14 +365,27 @@ int xfs_lock_delays;
 #endif
 
 /*
- * Bump the subclass so xfs_lock_inodes() acquires each lock with
- * a different value
+ * Bump the subclass so xfs_lock_inodes() acquires each lock with a different
+ * value. This shouldn't be called for page fault locking, but we also need to
+ * ensure we don't overrun the number of lockdep subclasses for the iolock or
+ * mmaplock as that is limited to 12 by the mmap lock lockdep annotations.
  */
 static inline int
 xfs_lock_inumorder(int lock_mode, int subclass)
 {
-	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
+	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
+		ASSERT(subclass + XFS_LOCK_INUMORDER <
+			(1 << (XFS_MMAPLOCK_SHIFT - XFS_IOLOCK_SHIFT)));
 		lock_mode |= (subclass + XFS_LOCK_INUMORDER) << XFS_IOLOCK_SHIFT;
+	}
+
+	if (lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)) {
+		ASSERT(subclass + XFS_LOCK_INUMORDER <
+			(1 << (XFS_ILOCK_SHIFT - XFS_MMAPLOCK_SHIFT)));
+		lock_mode |= (subclass + XFS_LOCK_INUMORDER) <<
+							XFS_MMAPLOCK_SHIFT;
+	}
+
 	if (lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL))
 		lock_mode |= (subclass + XFS_LOCK_INUMORDER) << XFS_ILOCK_SHIFT;
 
@@ -442,10 +504,10 @@ again:
 }
 
 /*
- * xfs_lock_two_inodes() can only be used to lock one type of lock
- * at a time - the iolock or the ilock, but not both at once. If
- * we lock both at once, lockdep will report false positives saying
- * we have violated locking orders.
+ * xfs_lock_two_inodes() can only be used to lock one type of lock at a time -
+ * the iolock, the mmaplock or the ilock, but not more than one at a time. If we
+ * lock more than one at a time, lockdep will report false positives saying we
+ * have violated locking orders.
  */
 void
 xfs_lock_two_inodes(
@@ -457,8 +519,12 @@ xfs_lock_two_inodes(
 	int			attempts = 0;
 	xfs_log_item_t		*lp;
 
-	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
-		ASSERT((lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)) == 0);
+	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
+		ASSERT(!(lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)));
+		ASSERT(!(lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
+	} else if (lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL))
+		ASSERT(!(lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
+
 	ASSERT(ip0->i_ino != ip1->i_ino);
 
 	if (ip0->i_ino > ip1->i_ino) {
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -57,6 +57,7 @@ typedef struct xfs_inode {
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	mrlock_t		i_lock;		/* inode lock */
 	mrlock_t		i_iolock;	/* inode IO lock */
+	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
 	atomic_t		i_pincount;	/* inode pin count */
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
@@ -264,15 +265,20 @@ static inline int xfs_isiflocked(struct
 #define	XFS_IOLOCK_SHARED	(1<<1)
 #define	XFS_ILOCK_EXCL		(1<<2)
 #define	XFS_ILOCK_SHARED	(1<<3)
+#define	XFS_MMAPLOCK_EXCL	(1<<4)
+#define	XFS_MMAPLOCK_SHARED	(1<<5)
 
 #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
-				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)
+				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
+				| XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)
 
 #define XFS_LOCK_FLAGS \
 	{ XFS_IOLOCK_EXCL,	"IOLOCK_EXCL" }, \
 	{ XFS_IOLOCK_SHARED,	"IOLOCK_SHARED" }, \
 	{ XFS_ILOCK_EXCL,	"ILOCK_EXCL" }, \
-	{ XFS_ILOCK_SHARED,	"ILOCK_SHARED" }
+	{ XFS_ILOCK_SHARED,	"ILOCK_SHARED" }, \
+	{ XFS_MMAPLOCK_EXCL,	"MMAPLOCK_EXCL" }, \
+	{ XFS_MMAPLOCK_SHARED,	"MMAPLOCK_SHARED" }
 
 
 /*
@@ -303,17 +309,26 @@ static inline int xfs_isiflocked(struct
 #define XFS_IOLOCK_SHIFT	16
 #define	XFS_IOLOCK_PARENT	(XFS_LOCK_PARENT << XFS_IOLOCK_SHIFT)
 
+#define XFS_MMAPLOCK_SHIFT	20
+
 #define XFS_ILOCK_SHIFT		24
 #define	XFS_ILOCK_PARENT	(XFS_LOCK_PARENT << XFS_ILOCK_SHIFT)
 #define	XFS_ILOCK_RTBITMAP	(XFS_LOCK_RTBITMAP << XFS_ILOCK_SHIFT)
 #define	XFS_ILOCK_RTSUM		(XFS_LOCK_RTSUM << XFS_ILOCK_SHIFT)
 
-#define XFS_IOLOCK_DEP_MASK	0x00ff0000
+#define XFS_IOLOCK_DEP_MASK	0x000f0000
+#define XFS_MMAPLOCK_DEP_MASK	0x00f00000
 #define XFS_ILOCK_DEP_MASK	0xff000000
-#define XFS_LOCK_DEP_MASK	(XFS_IOLOCK_DEP_MASK | XFS_ILOCK_DEP_MASK)
-
-#define XFS_IOLOCK_DEP(flags)	(((flags) & XFS_IOLOCK_DEP_MASK) >> XFS_IOLOCK_SHIFT)
-#define XFS_ILOCK_DEP(flags)	(((flags) & XFS_ILOCK_DEP_MASK) >> XFS_ILOCK_SHIFT)
+#define XFS_LOCK_DEP_MASK	(XFS_IOLOCK_DEP_MASK | \
+				 XFS_MMAPLOCK_DEP_MASK | \
+				 XFS_ILOCK_DEP_MASK)
+
+#define XFS_IOLOCK_DEP(flags)	(((flags) & XFS_IOLOCK_DEP_MASK) \
+					>> XFS_IOLOCK_SHIFT)
+#define XFS_MMAPLOCK_DEP(flags)	(((flags) & XFS_MMAPLOCK_DEP_MASK) \
+					>> XFS_MMAPLOCK_SHIFT)
+#define XFS_ILOCK_DEP(flags)	(((flags) & XFS_ILOCK_DEP_MASK) \
+					>> XFS_ILOCK_SHIFT)
 
 /*
  * For multiple groups support: if S_ISGID bit is set in the parent
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -982,6 +982,8 @@ xfs_fs_inode_init_once(
 	atomic_set(&ip->i_pincount, 0);
 	spin_lock_init(&ip->i_flags_lock);
 
+	mrlock_init(&ip->i_mmaplock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
+		     "xfsino", ip->i_ino);
 	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
 		     "xfsino", ip->i_ino);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
