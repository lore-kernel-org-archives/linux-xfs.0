Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 467017CA1
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 12:10:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D2AE98F8040
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:10:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id LMT1MQsuTZ4E1YTX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:10:25 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH,
	RFC] xfs: remove i_iolock and use i_rwsem in the VFS inode instead
Date: Thu, 11 Aug 2016 10:10:23 -0700
Message-Id: <1470935423-12329-1-git-send-email-hch@lst.de>
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
To: xfs@oss.sgi.com, peterz@infradead.org

This patch drops the XFS-own i_iolock and uses the VFS i_rwsem which
recently replaced i_mutex instead.  This means we only have to take
one looks instead of two in many fast path operations, and we can
also shrink the xfs_inode structure.  Thanks to the xfs_ilock family
there is very little churn as well.

There is one major issue with this change though:  lockdep currently
doesn't have a facility to assert a rw_sempahore is held exclusively,
which means we lose the nice ability to assert locking context in
XFS.

Peter, I think you mentioned this would be fairly easy to add to
lockdep and the rw_semaphore code.  Any chance to come up with a proof
of concept?

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dir2_readdir.c |  2 -
 fs/xfs/xfs_file.c         | 95 ++++++++++++++++-------------------------------
 fs/xfs/xfs_icache.c       |  6 +--
 fs/xfs/xfs_inode.c        | 79 ++++++++++++++++-----------------------
 fs/xfs/xfs_inode.h        |  7 +---
 fs/xfs/xfs_ioctl.c        |  2 +-
 fs/xfs/xfs_iops.c         | 14 +++----
 fs/xfs/xfs_pnfs.c         |  7 +---
 fs/xfs/xfs_pnfs.h         |  4 +-
 fs/xfs/xfs_super.c        |  2 +-
 fs/xfs/xfs_symlink.c      |  7 ++--
 11 files changed, 83 insertions(+), 142 deletions(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index f44f799..7662140 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -676,7 +676,6 @@ xfs_readdir(
 	args.dp = dp;
 	args.geo = dp->i_mount->m_dir_geo;
 
-	xfs_ilock(dp, XFS_IOLOCK_SHARED);
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_getdents(&args, ctx);
 	else if ((rval = xfs_dir2_isblock(&args, &v)))
@@ -685,7 +684,6 @@ xfs_readdir(
 		rval = xfs_dir2_block_getdents(&args, ctx);
 	else
 		rval = xfs_dir2_leaf_getdents(&args, ctx, bufsize);
-	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 
 	return rval;
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ed95e5b..b604dc7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -47,40 +47,6 @@
 static const struct vm_operations_struct xfs_file_vm_ops;
 
 /*
- * Locking primitives for read and write IO paths to ensure we consistently use
- * and order the inode->i_mutex, ip->i_lock and ip->i_iolock.
- */
-static inline void
-xfs_rw_ilock(
-	struct xfs_inode	*ip,
-	int			type)
-{
-	if (type & XFS_IOLOCK_EXCL)
-		inode_lock(VFS_I(ip));
-	xfs_ilock(ip, type);
-}
-
-static inline void
-xfs_rw_iunlock(
-	struct xfs_inode	*ip,
-	int			type)
-{
-	xfs_iunlock(ip, type);
-	if (type & XFS_IOLOCK_EXCL)
-		inode_unlock(VFS_I(ip));
-}
-
-static inline void
-xfs_rw_ilock_demote(
-	struct xfs_inode	*ip,
-	int			type)
-{
-	xfs_ilock_demote(ip, type);
-	if (type & XFS_IOLOCK_EXCL)
-		inode_unlock(VFS_I(ip));
-}
-
-/*
  * Clear the specified ranges to zero through either the pagecache or DAX.
  * Holes and unwritten extents will be left as-is as they already are zeroed.
  */
@@ -279,10 +245,10 @@ xfs_file_dio_aio_read(
 	 * IO case of no page cache pages to proceeed concurrently without
 	 * serialisation.
 	 */
-	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	if (mapping->nrpages) {
-		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
-		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
+		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+		xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
 		/*
 		 * The generic dio code only flushes the range of the particular
@@ -298,7 +264,7 @@ xfs_file_dio_aio_read(
 		if (mapping->nrpages) {
 			ret = filemap_write_and_wait(mapping);
 			if (ret) {
-				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
+				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 				return ret;
 			}
 
@@ -311,7 +277,7 @@ xfs_file_dio_aio_read(
 			WARN_ON_ONCE(ret);
 			ret = 0;
 		}
-		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
+		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 	}
 
 	data = *to;
@@ -321,7 +287,7 @@ xfs_file_dio_aio_read(
 		iocb->ki_pos += ret;
 		iov_iter_advance(to, ret);
 	}
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	file_accessed(iocb->ki_filp);
 	return ret;
@@ -344,13 +310,13 @@ xfs_file_dax_read(
 	if (!count)
 		return 0; /* skip atime */
 
-	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	ret = dax_do_io(iocb, inode, &data, xfs_get_blocks_direct, NULL, 0);
 	if (ret > 0) {
 		iocb->ki_pos += ret;
 		iov_iter_advance(to, ret);
 	}
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	file_accessed(iocb->ki_filp);
 	return ret;
@@ -366,9 +332,9 @@ xfs_file_buffered_aio_read(
 
 	trace_xfs_file_buffered_read(ip, iov_iter_count(to), iocb->ki_pos);
 
-	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	ret = generic_file_read_iter(iocb, to);
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	return ret;
 }
@@ -429,9 +395,9 @@ xfs_file_splice_read(
 		goto out;
 	}
 
-	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 out:
 	if (ret > 0)
 		XFS_STATS_ADD(ip->i_mount, xs_read_bytes, ret);
@@ -488,15 +454,18 @@ restart:
 	if (error <= 0)
 		return error;
 
-	error = xfs_break_layouts(inode, iolock, true);
+	error = xfs_break_layouts(inode, iolock);
 	if (error)
 		return error;
 
-	/* For changing security info in file_remove_privs() we need i_mutex */
+	/*
+	 * For changing security info in file_remove_privs() we need i_rwsem
+	 * exclusively.
+	 */
 	if (*iolock == XFS_IOLOCK_SHARED && !IS_NOSEC(inode)) {
-		xfs_rw_iunlock(ip, *iolock);
+		xfs_iunlock(ip, *iolock);
 		*iolock = XFS_IOLOCK_EXCL;
-		xfs_rw_ilock(ip, *iolock);
+		xfs_ilock(ip, *iolock);
 		goto restart;
 	}
 	/*
@@ -521,9 +490,9 @@ restart:
 		spin_unlock(&ip->i_flags_lock);
 		if (!drained_dio) {
 			if (*iolock == XFS_IOLOCK_SHARED) {
-				xfs_rw_iunlock(ip, *iolock);
+				xfs_iunlock(ip, *iolock);
 				*iolock = XFS_IOLOCK_EXCL;
-				xfs_rw_ilock(ip, *iolock);
+				xfs_ilock(ip, *iolock);
 				iov_iter_reexpand(from, count);
 			}
 			/*
@@ -630,7 +599,7 @@ xfs_file_dio_aio_write(
 		iolock = XFS_IOLOCK_EXCL;
 	else
 		iolock = XFS_IOLOCK_SHARED;
-	xfs_rw_ilock(ip, iolock);
+	xfs_ilock(ip, iolock);
 
 	/*
 	 * Recheck if there are cached pages that need invalidate after we got
@@ -638,9 +607,9 @@ xfs_file_dio_aio_write(
 	 * we were waiting for the iolock.
 	 */
 	if (mapping->nrpages && iolock == XFS_IOLOCK_SHARED) {
-		xfs_rw_iunlock(ip, iolock);
+		xfs_iunlock(ip, iolock);
 		iolock = XFS_IOLOCK_EXCL;
-		xfs_rw_ilock(ip, iolock);
+		xfs_ilock(ip, iolock);
 	}
 
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
@@ -673,7 +642,7 @@ xfs_file_dio_aio_write(
 	if (unaligned_io)
 		inode_dio_wait(inode);
 	else if (iolock == XFS_IOLOCK_EXCL) {
-		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
+		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		iolock = XFS_IOLOCK_SHARED;
 	}
 
@@ -696,7 +665,7 @@ xfs_file_dio_aio_write(
 		iov_iter_advance(from, ret);
 	}
 out:
-	xfs_rw_iunlock(ip, iolock);
+	xfs_iunlock(ip, iolock);
 
 	/*
 	 * No fallback to buffered IO on errors for XFS, direct IO will either
@@ -730,7 +699,7 @@ xfs_file_dax_write(
 	} else {
 		iolock = XFS_IOLOCK_SHARED;
 	}
-	xfs_rw_ilock(ip, iolock);
+	xfs_ilock(ip, iolock);
 
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
@@ -748,7 +717,7 @@ xfs_file_dax_write(
 	}
 
 	if (iolock == XFS_IOLOCK_EXCL && !unaligned_io) {
-		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
+		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		iolock = XFS_IOLOCK_SHARED;
 	}
 
@@ -762,7 +731,7 @@ xfs_file_dax_write(
 		iov_iter_advance(from, ret);
 	}
 out:
-	xfs_rw_iunlock(ip, iolock);
+	xfs_iunlock(ip, iolock);
 	return ret;
 }
 
@@ -779,7 +748,7 @@ xfs_file_buffered_aio_write(
 	int			enospc = 0;
 	int			iolock = XFS_IOLOCK_EXCL;
 
-	xfs_rw_ilock(ip, iolock);
+	xfs_ilock(ip, iolock);
 
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
@@ -820,7 +789,7 @@ write_retry:
 
 	current->backing_dev_info = NULL;
 out:
-	xfs_rw_iunlock(ip, iolock);
+	xfs_iunlock(ip, iolock);
 	return ret;
 }
 
@@ -886,7 +855,7 @@ xfs_file_fallocate(
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, iolock);
-	error = xfs_break_layouts(inode, &iolock, false);
+	error = xfs_break_layouts(inode, &iolock);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index fb39a66..cc5e7b2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -69,8 +69,6 @@ xfs_inode_alloc(
 	ASSERT(!xfs_isiflocked(ip));
 	ASSERT(ip->i_ino == 0);
 
-	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
-
 	/* initialise the xfs inode */
 	ip->i_ino = ino;
 	ip->i_mount = mp;
@@ -387,8 +385,8 @@ xfs_iget_cache_hit(
 		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
 		inode->i_state = I_NEW;
 
-		ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
-		mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
+		ASSERT(!rwsem_is_locked(&inode->i_rwsem));
+		init_rwsem(&inode->i_rwsem);
 
 		spin_unlock(&ip->i_flags_lock);
 		spin_unlock(&pag->pag_ici_lock);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e08eaea..e2b94bf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -118,31 +118,31 @@ xfs_ilock_attr_map_shared(
 }
 
 /*
- * The xfs inode contains 3 multi-reader locks: the i_iolock the i_mmap_lock and
- * the i_lock.  This routine allows various combinations of the locks to be
- * obtained.
+ * In addition to i_rwsem in the VFS inode, the xfs inode contains 2
+ * multi-reader locks: i_mmap_lock and the i_lock.  This routine allows
+ * various combinations of the locks to be obtained.
  *
  * The 3 locks should always be ordered so that the IO lock is obtained first,
  * the mmap lock second and the ilock last in order to prevent deadlock.
  *
  * Basic locking order:
  *
- * i_iolock -> i_mmap_lock -> page_lock -> i_ilock
+ * i_rwsem -> i_mmap_lock -> page_lock -> i_ilock
  *
  * mmap_sem locking order:
  *
- * i_iolock -> page lock -> mmap_sem
+ * i_rwsem -> page lock -> mmap_sem
  * mmap_sem -> i_mmap_lock -> page_lock
  *
  * The difference in mmap_sem locking order mean that we cannot hold the
  * i_mmap_lock over syscall based read(2)/write(2) based IO. These IO paths can
  * fault in pages during copy in/out (for buffered IO) or require the mmap_sem
  * in get_user_pages() to map the user pages into the kernel address space for
- * direct IO. Similarly the i_iolock cannot be taken inside a page fault because
+ * direct IO. Similarly the i_rwsem cannot be taken inside a page fault because
  * page faults already hold the mmap_sem.
  *
  * Hence to serialise fully against both syscall and mmap based IO, we need to
- * take both the i_iolock and the i_mmap_lock. These locks should *only* be both
+ * take both the i_rwsem and the i_mmap_lock. These locks should *only* be both
  * taken in places where we need to invalidate the page cache in a race
  * free manner (e.g. truncate, hole punch and other extent manipulation
  * functions).
@@ -167,10 +167,13 @@ xfs_ilock(
 	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_SUBCLASS_MASK)) == 0);
 
-	if (lock_flags & XFS_IOLOCK_EXCL)
-		mrupdate_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
-	else if (lock_flags & XFS_IOLOCK_SHARED)
-		mraccess_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
+	if (lock_flags & XFS_IOLOCK_EXCL) {
+		down_write_nested(&VFS_I(ip)->i_rwsem,
+				  XFS_IOLOCK_DEP(lock_flags));
+	} else if (lock_flags & XFS_IOLOCK_SHARED) {
+		down_read_nested(&VFS_I(ip)->i_rwsem,
+				 XFS_IOLOCK_DEP(lock_flags));
+	}
 
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
 		mrupdate_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
@@ -216,10 +219,10 @@ xfs_ilock_nowait(
 	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_SUBCLASS_MASK)) == 0);
 
 	if (lock_flags & XFS_IOLOCK_EXCL) {
-		if (!mrtryupdate(&ip->i_iolock))
+		if (!down_write_trylock(&VFS_I(ip)->i_rwsem))
 			goto out;
 	} else if (lock_flags & XFS_IOLOCK_SHARED) {
-		if (!mrtryaccess(&ip->i_iolock))
+		if (!down_read_trylock(&VFS_I(ip)->i_rwsem))
 			goto out;
 	}
 
@@ -247,9 +250,9 @@ out_undo_mmaplock:
 		mrunlock_shared(&ip->i_mmaplock);
 out_undo_iolock:
 	if (lock_flags & XFS_IOLOCK_EXCL)
-		mrunlock_excl(&ip->i_iolock);
+		up_write(&VFS_I(ip)->i_rwsem);
 	else if (lock_flags & XFS_IOLOCK_SHARED)
-		mrunlock_shared(&ip->i_iolock);
+		up_read(&VFS_I(ip)->i_rwsem);
 out:
 	return 0;
 }
@@ -286,9 +289,9 @@ xfs_iunlock(
 	ASSERT(lock_flags != 0);
 
 	if (lock_flags & XFS_IOLOCK_EXCL)
-		mrunlock_excl(&ip->i_iolock);
+		up_write(&VFS_I(ip)->i_rwsem);
 	else if (lock_flags & XFS_IOLOCK_SHARED)
-		mrunlock_shared(&ip->i_iolock);
+		up_read(&VFS_I(ip)->i_rwsem);
 
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
 		mrunlock_excl(&ip->i_mmaplock);
@@ -321,7 +324,7 @@ xfs_ilock_demote(
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
 		mrdemote(&ip->i_mmaplock);
 	if (lock_flags & XFS_IOLOCK_EXCL)
-		mrdemote(&ip->i_iolock);
+		downgrade_write(&VFS_I(ip)->i_rwsem);
 
 	trace_xfs_ilock_demote(ip, lock_flags, _RET_IP_);
 }
@@ -345,9 +348,11 @@ xfs_isilocked(
 	}
 
 	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
-		if (!(lock_flags & XFS_IOLOCK_SHARED))
-			return !!ip->i_iolock.mr_writer;
-		return rwsem_is_locked(&ip->i_iolock.mr_lock);
+		/*
+		 * XXX: we'd need something like a rwsem_is_write_locked
+		 * helper for the XFS_IOLOCK_EXCL case..
+		 */
+		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
 	}
 
 	ASSERT(0);
@@ -397,11 +402,7 @@ xfs_lock_inumorder(int lock_mode, int subclass)
 
 	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
 		ASSERT(subclass <= XFS_IOLOCK_MAX_SUBCLASS);
-		ASSERT(xfs_lockdep_subclass_ok(subclass +
-						XFS_IOLOCK_PARENT_VAL));
 		class += subclass << XFS_IOLOCK_SHIFT;
-		if (lock_mode & XFS_IOLOCK_PARENT)
-			class += XFS_IOLOCK_PARENT_VAL << XFS_IOLOCK_SHIFT;
 	}
 
 	if (lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)) {
@@ -453,8 +454,6 @@ xfs_lock_inodes(
 			    XFS_ILOCK_EXCL));
 	ASSERT(!(lock_mode & (XFS_IOLOCK_SHARED | XFS_MMAPLOCK_SHARED |
 			      XFS_ILOCK_SHARED)));
-	ASSERT(!(lock_mode & XFS_IOLOCK_EXCL) ||
-		inodes <= XFS_IOLOCK_MAX_SUBCLASS + 1);
 	ASSERT(!(lock_mode & XFS_MMAPLOCK_EXCL) ||
 		inodes <= XFS_MMAPLOCK_MAX_SUBCLASS + 1);
 	ASSERT(!(lock_mode & XFS_ILOCK_EXCL) ||
@@ -689,7 +688,6 @@ xfs_lookup(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	xfs_ilock(dp, XFS_IOLOCK_SHARED);
 	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_name);
 	if (error)
 		goto out_unlock;
@@ -698,14 +696,12 @@ xfs_lookup(
 	if (error)
 		goto out_free_name;
 
-	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 	return 0;
 
 out_free_name:
 	if (ci_name)
 		kmem_free(ci_name->name);
 out_unlock:
-	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 	*ipp = NULL;
 	return error;
 }
@@ -1179,8 +1175,7 @@ xfs_create(
 	if (error)
 		goto out_release_inode;
 
-	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL |
-		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
+	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
 	xfs_defer_init(&dfops, &first_block);
@@ -1216,7 +1211,7 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
@@ -1289,7 +1284,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
-		xfs_iunlock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 }
 
@@ -1430,11 +1425,10 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	xfs_ilock(tdp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
 	xfs_lock_two_inodes(sip, tdp, XFS_ILOCK_EXCL);
 
 	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, tdp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -2528,10 +2522,9 @@ xfs_remove(
 		goto std_return;
 	}
 
-	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
 	xfs_lock_two_inodes(dp, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 	/*
@@ -2912,12 +2905,6 @@ xfs_rename(
 	 * whether the target directory is the same as the source
 	 * directory, we can lock from 2 to 4 inodes.
 	 */
-	if (!new_parent)
-		xfs_ilock(src_dp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
-	else
-		xfs_lock_two_inodes(src_dp, target_dp,
-				    XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
-
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
@@ -2925,9 +2912,9 @@ xfs_rename(
 	 * we can rely on either trans_commit or trans_cancel to unlock
 	 * them.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
 	if (target_ip)
 		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e1a411e..dc8806f 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -55,7 +55,6 @@ typedef struct xfs_inode {
 	/* Transaction and locking information. */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	mrlock_t		i_lock;		/* inode lock */
-	mrlock_t		i_iolock;	/* inode IO lock */
 	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
 	atomic_t		i_pincount;	/* inode pin count */
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
@@ -316,7 +315,7 @@ static inline int xfs_isiflocked(struct xfs_inode *ip)
  * IOLOCK values
  *
  * 0-3		subclass value
- * 4-7		PARENT subclass values
+ * 4-7		unused
  *
  * MMAPLOCK values
  *
@@ -331,10 +330,8 @@ static inline int xfs_isiflocked(struct xfs_inode *ip)
  * 
  */
 #define XFS_IOLOCK_SHIFT		16
-#define XFS_IOLOCK_PARENT_VAL		4
-#define XFS_IOLOCK_MAX_SUBCLASS		(XFS_IOLOCK_PARENT_VAL - 1)
+#define XFS_IOLOCK_MAX_SUBCLASS		3
 #define XFS_IOLOCK_DEP_MASK		0x000f0000
-#define	XFS_IOLOCK_PARENT		(XFS_IOLOCK_PARENT_VAL << XFS_IOLOCK_SHIFT)
 
 #define XFS_MMAPLOCK_SHIFT		20
 #define XFS_MMAPLOCK_NUMORDER		0
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 96a70fd..29e0471 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -639,7 +639,7 @@ xfs_ioc_space(
 		return error;
 
 	xfs_ilock(ip, iolock);
-	error = xfs_break_layouts(inode, &iolock, false);
+	error = xfs_break_layouts(inode, &iolock);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ab820f8..36ac28c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -953,15 +953,13 @@ xfs_vn_setattr(
 	if (iattr->ia_valid & ATTR_SIZE) {
 		uint		iolock = XFS_IOLOCK_EXCL;
 
-		xfs_ilock(ip, iolock);
-		error = xfs_break_layouts(d_inode(dentry), &iolock, true);
-		if (!error) {
-			xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
-			iolock |= XFS_MMAPLOCK_EXCL;
+		error = xfs_break_layouts(d_inode(dentry), &iolock);
+		if (error)
+			return error;
 
-			error = xfs_setattr_size(ip, iattr);
-		}
-		xfs_iunlock(ip, iolock);
+		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+		error = xfs_setattr_size(ip, iattr);
+		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 	} else {
 		error = xfs_setattr_nonsize(ip, iattr, 0);
 	}
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 0f14b2e..94c8faa 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -32,8 +32,7 @@
 int
 xfs_break_layouts(
 	struct inode		*inode,
-	uint			*iolock,
-	bool			with_imutex)
+	uint			*iolock)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
@@ -42,12 +41,8 @@ xfs_break_layouts(
 
 	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
 		xfs_iunlock(ip, *iolock);
-		if (with_imutex && (*iolock & XFS_IOLOCK_EXCL))
-			inode_unlock(inode);
 		error = break_layout(inode, true);
 		*iolock = XFS_IOLOCK_EXCL;
-		if (with_imutex)
-			inode_lock(inode);
 		xfs_ilock(ip, *iolock);
 	}
 
diff --git a/fs/xfs/xfs_pnfs.h b/fs/xfs/xfs_pnfs.h
index e8339f7..b587cb9 100644
--- a/fs/xfs/xfs_pnfs.h
+++ b/fs/xfs/xfs_pnfs.h
@@ -8,10 +8,10 @@ int xfs_fs_map_blocks(struct inode *inode, loff_t offset, u64 length,
 int xfs_fs_commit_blocks(struct inode *inode, struct iomap *maps, int nr_maps,
 		struct iattr *iattr);
 
-int xfs_break_layouts(struct inode *inode, uint *iolock, bool with_imutex);
+int xfs_break_layouts(struct inode *inode, uint *iolock);
 #else
 static inline int
-xfs_break_layouts(struct inode *inode, uint *iolock, bool with_imutex)
+xfs_break_layouts(struct inode *inode, uint *iolock)
 {
 	return 0;
 }
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 24ef83e..f32b95e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -939,7 +939,7 @@ xfs_fs_destroy_inode(
 
 	trace_xfs_destroy_inode(ip);
 
-	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
+	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 58142ae..f2cb45e 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -238,8 +238,7 @@ xfs_symlink(
 	if (error)
 		goto out_release_inode;
 
-	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL |
-		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
+	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
 	/*
@@ -287,7 +286,7 @@ xfs_symlink(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = false;
 
 	/*
@@ -412,7 +411,7 @@ out_release_inode:
 	xfs_qm_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
-		xfs_iunlock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
