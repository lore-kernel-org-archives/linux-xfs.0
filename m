Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48934 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941864AbcJYPI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 11:08:27 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] xfs: remove i_iolock and use i_rwsem in the VFS inode instead
Date: Tue, 25 Oct 2016 17:08:14 +0200
Message-Id: <1477408098-10153-3-git-send-email-hch@lst.de>
In-Reply-To: <1477408098-10153-1-git-send-email-hch@lst.de>
References: <1477408098-10153-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: axboe@fb.com, kent.overstreet@gmail.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

This patch drops the XFS-own i_iolock and uses the VFS i_rwsem which
recently replaced i_mutex instead.  This means we only have to take
one looks instead of two in many fast path operations, and we can
also shrink the xfs_inode structure.  Thanks to the xfs_ilock family
there is very little churn, the only thing of note is that we need
to switch to use the lock_two_directory helper for taking the i_rwsem
on two inodes in a few places to make sure our lock order matches
the one used in the VFS.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c         |  7 ++--
 fs/xfs/xfs_bmap_util.c    | 12 +++----
 fs/xfs/xfs_dir2_readdir.c |  2 --
 fs/xfs/xfs_file.c         | 79 +++++++++++++--------------------------------
 fs/xfs/xfs_icache.c       |  6 ++--
 fs/xfs/xfs_inode.c        | 82 +++++++++++++++++++----------------------------
 fs/xfs/xfs_inode.h        |  7 ++--
 fs/xfs/xfs_ioctl.c        |  2 +-
 fs/xfs/xfs_iops.c         | 14 ++++----
 fs/xfs/xfs_pnfs.c         |  7 +---
 fs/xfs/xfs_pnfs.h         |  4 +--
 fs/xfs/xfs_reflink.c      | 14 +++-----
 fs/xfs/xfs_super.c        |  2 +-
 fs/xfs/xfs_symlink.c      |  7 ++--
 14 files changed, 86 insertions(+), 159 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3e57a56..d5a09b7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1583,7 +1583,6 @@ xfs_vm_bmap(
 	struct xfs_inode	*ip = XFS_I(inode);
 
 	trace_xfs_vm_bmap(XFS_I(inode));
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
 	/*
 	 * The swap code (ab-)uses ->bmap to get a block mapping and then
@@ -1591,12 +1590,10 @@ xfs_vm_bmap(
 	 * that on reflinks inodes, so we have to skip out here.  And yes,
 	 * 0 is the magic code for a bmap error..
 	 */
-	if (xfs_is_reflink_inode(ip)) {
-		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+	if (xfs_is_reflink_inode(ip))
 		return 0;
-	}
+
 	filemap_write_and_wait(mapping);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 	return generic_block_bmap(mapping, block, xfs_get_blocks);
 }
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 552465e..4f31756 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1938,8 +1938,8 @@ xfs_swap_extents(
 	 * page cache safely. Once we have done this we can take the ilocks and
 	 * do the rest of the checks.
 	 */
-	lock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
-	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
+	lock_two_nondirectories(VFS_I(ip), VFS_I(tip));
+	lock_flags = XFS_MMAPLOCK_EXCL;
 	xfs_lock_two_inodes(ip, tip, XFS_MMAPLOCK_EXCL);
 
 	/* Verify that both files have the same format */
@@ -2079,15 +2079,13 @@ xfs_swap_extents(
 	trace_xfs_swap_extent_after(ip, 0);
 	trace_xfs_swap_extent_after(tip, 1);
 
+out_unlock:
 	xfs_iunlock(ip, lock_flags);
 	xfs_iunlock(tip, lock_flags);
+	unlock_two_nondirectories(VFS_I(ip), VFS_I(tip));
 	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
-
-out_unlock:
-	xfs_iunlock(ip, lock_flags);
-	xfs_iunlock(tip, lock_flags);
-	return error;
+	goto out_unlock;
 }
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 2981698..003a99b 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -677,7 +677,6 @@ xfs_readdir(
 	args.dp = dp;
 	args.geo = dp->i_mount->m_dir_geo;
 
-	xfs_ilock(dp, XFS_IOLOCK_SHARED);
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_getdents(&args, ctx);
 	else if ((rval = xfs_dir2_isblock(&args, &v)))
@@ -686,7 +685,6 @@ xfs_readdir(
 		rval = xfs_dir2_block_getdents(&args, ctx);
 	else
 		rval = xfs_dir2_leaf_getdents(&args, ctx, bufsize);
-	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 
 	return rval;
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6e4f7f9..8830223 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -48,40 +48,6 @@
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
@@ -273,7 +239,7 @@ xfs_file_dio_aio_read(
 
 	file_accessed(iocb->ki_filp);
 
-	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	if (mapping->nrpages) {
 		ret = filemap_write_and_wait_range(mapping, iocb->ki_pos, end);
 		if (ret)
@@ -299,7 +265,7 @@ xfs_file_dio_aio_read(
 	}
 
 out_unlock:
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 	return ret;
 }
 
@@ -317,9 +283,9 @@ xfs_file_dax_read(
 	if (!count)
 		return 0; /* skip atime */
 
-	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	ret = iomap_dax_rw(iocb, to, &xfs_iomap_ops);
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	file_accessed(iocb->ki_filp);
 	return ret;
@@ -335,9 +301,9 @@ xfs_file_buffered_aio_read(
 
 	trace_xfs_file_buffered_read(ip, iov_iter_count(to), iocb->ki_pos);
 
-	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	ret = generic_file_read_iter(iocb, to);
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	return ret;
 }
@@ -418,15 +384,18 @@ xfs_file_aio_write_checks(
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
@@ -451,9 +420,9 @@ xfs_file_aio_write_checks(
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
@@ -559,7 +528,7 @@ xfs_file_dio_aio_write(
 		iolock = XFS_IOLOCK_SHARED;
 	}
 
-	xfs_rw_ilock(ip, iolock);
+	xfs_ilock(ip, iolock);
 
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
@@ -591,7 +560,7 @@ xfs_file_dio_aio_write(
 	if (unaligned_io)
 		inode_dio_wait(inode);
 	else if (iolock == XFS_IOLOCK_EXCL) {
-		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
+		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		iolock = XFS_IOLOCK_SHARED;
 	}
 
@@ -621,7 +590,7 @@ xfs_file_dio_aio_write(
 		iov_iter_advance(from, ret);
 	}
 out:
-	xfs_rw_iunlock(ip, iolock);
+	xfs_iunlock(ip, iolock);
 
 	/*
 	 * No fallback to buffered IO on errors for XFS, direct IO will either
@@ -643,7 +612,7 @@ xfs_file_dax_write(
 	size_t			count;
 	loff_t			pos;
 
-	xfs_rw_ilock(ip, iolock);
+	xfs_ilock(ip, iolock);
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
 		goto out;
@@ -652,15 +621,13 @@ xfs_file_dax_write(
 	count = iov_iter_count(from);
 
 	trace_xfs_file_dax_write(ip, count, pos);
-
 	ret = iomap_dax_rw(iocb, from, &xfs_iomap_ops);
 	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
 		i_size_write(inode, iocb->ki_pos);
 		error = xfs_setfilesize(ip, pos, ret);
 	}
-
 out:
-	xfs_rw_iunlock(ip, iolock);
+	xfs_iunlock(ip, iolock);
 	return error ? error : ret;
 }
 
@@ -677,7 +644,7 @@ xfs_file_buffered_aio_write(
 	int			enospc = 0;
 	int			iolock = XFS_IOLOCK_EXCL;
 
-	xfs_rw_ilock(ip, iolock);
+	xfs_ilock(ip, iolock);
 
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
@@ -721,7 +688,7 @@ xfs_file_buffered_aio_write(
 
 	current->backing_dev_info = NULL;
 out:
-	xfs_rw_iunlock(ip, iolock);
+	xfs_iunlock(ip, iolock);
 	return ret;
 }
 
@@ -797,7 +764,7 @@ xfs_file_fallocate(
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, iolock);
-	error = xfs_break_layouts(inode, &iolock, false);
+	error = xfs_break_layouts(inode, &iolock);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f295049..d02271b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -70,8 +70,6 @@ xfs_inode_alloc(
 	ASSERT(!xfs_isiflocked(ip));
 	ASSERT(ip->i_ino == 0);
 
-	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
-
 	/* initialise the xfs inode */
 	ip->i_ino = ino;
 	ip->i_mount = mp;
@@ -393,8 +391,8 @@ xfs_iget_cache_hit(
 		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
 		inode->i_state = I_NEW;
 
-		ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
-		mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
+		ASSERT(!rwsem_is_locked(&inode->i_rwsem));
+		init_rwsem(&inode->i_rwsem);
 
 		spin_unlock(&ip->i_flags_lock);
 		spin_unlock(&pag->pag_ici_lock);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4e560e6..e9ab42d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -142,31 +142,31 @@ xfs_ilock_attr_map_shared(
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
@@ -191,10 +191,13 @@ xfs_ilock(
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
@@ -240,10 +243,10 @@ xfs_ilock_nowait(
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
 
@@ -271,9 +274,9 @@ xfs_ilock_nowait(
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
@@ -310,9 +313,9 @@ xfs_iunlock(
 	ASSERT(lock_flags != 0);
 
 	if (lock_flags & XFS_IOLOCK_EXCL)
-		mrunlock_excl(&ip->i_iolock);
+		up_write(&VFS_I(ip)->i_rwsem);
 	else if (lock_flags & XFS_IOLOCK_SHARED)
-		mrunlock_shared(&ip->i_iolock);
+		up_read(&VFS_I(ip)->i_rwsem);
 
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
 		mrunlock_excl(&ip->i_mmaplock);
@@ -345,7 +348,7 @@ xfs_ilock_demote(
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
 		mrdemote(&ip->i_mmaplock);
 	if (lock_flags & XFS_IOLOCK_EXCL)
-		mrdemote(&ip->i_iolock);
+		downgrade_write(&VFS_I(ip)->i_rwsem);
 
 	trace_xfs_ilock_demote(ip, lock_flags, _RET_IP_);
 }
@@ -370,8 +373,9 @@ xfs_isilocked(
 
 	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
 		if (!(lock_flags & XFS_IOLOCK_SHARED))
-			return !!ip->i_iolock.mr_writer;
-		return rwsem_is_locked(&ip->i_iolock.mr_lock);
+			return !debug_locks ||
+				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
+		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
 	}
 
 	ASSERT(0);
@@ -421,11 +425,7 @@ xfs_lock_inumorder(int lock_mode, int subclass)
 
 	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
 		ASSERT(subclass <= XFS_IOLOCK_MAX_SUBCLASS);
-		ASSERT(xfs_lockdep_subclass_ok(subclass +
-						XFS_IOLOCK_PARENT_VAL));
 		class += subclass << XFS_IOLOCK_SHIFT;
-		if (lock_mode & XFS_IOLOCK_PARENT)
-			class += XFS_IOLOCK_PARENT_VAL << XFS_IOLOCK_SHIFT;
 	}
 
 	if (lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)) {
@@ -477,8 +477,6 @@ xfs_lock_inodes(
 			    XFS_ILOCK_EXCL));
 	ASSERT(!(lock_mode & (XFS_IOLOCK_SHARED | XFS_MMAPLOCK_SHARED |
 			      XFS_ILOCK_SHARED)));
-	ASSERT(!(lock_mode & XFS_IOLOCK_EXCL) ||
-		inodes <= XFS_IOLOCK_MAX_SUBCLASS + 1);
 	ASSERT(!(lock_mode & XFS_MMAPLOCK_EXCL) ||
 		inodes <= XFS_MMAPLOCK_MAX_SUBCLASS + 1);
 	ASSERT(!(lock_mode & XFS_ILOCK_EXCL) ||
@@ -581,10 +579,8 @@ xfs_lock_two_inodes(
 	int			attempts = 0;
 	xfs_log_item_t		*lp;
 
-	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
-		ASSERT(!(lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)));
-		ASSERT(!(lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
-	} else if (lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL))
+	ASSERT(!(lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)));
+	if (lock_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL))
 		ASSERT(!(lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)));
 
 	ASSERT(ip0->i_ino != ip1->i_ino);
@@ -715,7 +711,6 @@ xfs_lookup(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	xfs_ilock(dp, XFS_IOLOCK_SHARED);
 	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_name);
 	if (error)
 		goto out_unlock;
@@ -724,14 +719,12 @@ xfs_lookup(
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
@@ -1215,8 +1208,7 @@ xfs_create(
 	if (error)
 		goto out_release_inode;
 
-	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL |
-		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
+	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
 	xfs_defer_init(&dfops, &first_block);
@@ -1252,7 +1244,7 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
@@ -1325,7 +1317,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
-		xfs_iunlock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 }
 
@@ -1466,11 +1458,10 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	xfs_ilock(tdp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
 	xfs_lock_two_inodes(sip, tdp, XFS_ILOCK_EXCL);
 
 	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, tdp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -2579,10 +2570,9 @@ xfs_remove(
 		goto std_return;
 	}
 
-	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
 	xfs_lock_two_inodes(dp, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 	/*
@@ -2963,12 +2953,6 @@ xfs_rename(
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
@@ -2976,9 +2960,9 @@ xfs_rename(
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
index f14c1de..1e14a6cd 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -56,7 +56,6 @@ typedef struct xfs_inode {
 	/* Transaction and locking information. */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	mrlock_t		i_lock;		/* inode lock */
-	mrlock_t		i_iolock;	/* inode IO lock */
 	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
 	atomic_t		i_pincount;	/* inode pin count */
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
@@ -332,7 +331,7 @@ static inline int xfs_isiflocked(struct xfs_inode *ip)
  * IOLOCK values
  *
  * 0-3		subclass value
- * 4-7		PARENT subclass values
+ * 4-7		unused
  *
  * MMAPLOCK values
  *
@@ -347,10 +346,8 @@ static inline int xfs_isiflocked(struct xfs_inode *ip)
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
index c245bed..94a2448 100644
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
index 405a65c..c962999 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -983,15 +983,13 @@ xfs_vn_setattr(
 		struct xfs_inode	*ip = XFS_I(d_inode(dentry));
 		uint			iolock = XFS_IOLOCK_EXCL;
 
-		xfs_ilock(ip, iolock);
-		error = xfs_break_layouts(d_inode(dentry), &iolock, true);
-		if (!error) {
-			xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
-			iolock |= XFS_MMAPLOCK_EXCL;
+		error = xfs_break_layouts(d_inode(dentry), &iolock);
+		if (error)
+			return error;
 
-			error = xfs_vn_setattr_size(dentry, iattr);
-		}
-		xfs_iunlock(ip, iolock);
+		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+		error = xfs_setattr_size(ip, iattr);
+		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 	} else {
 		error = xfs_vn_setattr_nonsize(dentry, iattr);
 	}
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 93a7aaf..2f2dc3c 100644
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
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index a279b4e..846e0fa 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1302,13 +1302,11 @@ xfs_reflink_remap_range(
 		return -EIO;
 
 	/* Lock both files against IO */
-	if (same_inode) {
-		xfs_ilock(src, XFS_IOLOCK_EXCL);
+	lock_two_nondirectories(inode_in, inode_out);
+	if (same_inode)
 		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
-	} else {
-		xfs_lock_two_inodes(src, dest, XFS_IOLOCK_EXCL);
+	else
 		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
-	}
 
 	/* Don't touch certain kinds of inodes */
 	ret = -EPERM;
@@ -1447,11 +1445,9 @@ xfs_reflink_remap_range(
 
 out_unlock:
 	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
-	xfs_iunlock(src, XFS_IOLOCK_EXCL);
-	if (src->i_ino != dest->i_ino) {
+	if (!same_inode)
 		xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
-		xfs_iunlock(dest, XFS_IOLOCK_EXCL);
-	}
+	unlock_two_nondirectories(inode_in, inode_out);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return ret;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ade4691..563d1d1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -943,7 +943,7 @@ xfs_fs_destroy_inode(
 
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
@@ -412,7 +411,7 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
-		xfs_iunlock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.1.4

