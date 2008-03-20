Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Mar 2008 02:50:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2K9oNTS011747
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 02:50:25 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42D316C557B
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 02:50:52 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id ioi3zzDS3ue2lpjd for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 02:50:52 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m2K9dfF3029324
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 10:39:41 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m2K9dekh029322
	for xfs@oss.sgi.com; Thu, 20 Mar 2008 10:39:40 +0100
Date: Thu, 20 Mar 2008 10:39:40 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill mrlock_t
Message-ID: <20080320093940.GA28966@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

XFS inodes are locked via the xfs_ilock family of functions which
internally use a rw_semaphore wrapper into an abstraction called
mrlock_t.  The mrlock_t should be purely internal to xfs_ilock functions
but leaks through to the callers via various lock state asserts.

This patch:

 - adds new xfs_isilocked abstraction to make the lock state asserts
   fits into the xfs_ilock API family
 - opencodes the mrlock wrappers in the xfs_ilock family of functions
 - makes the state tracking debug-only and merged into a single state
   word
 - remove superflous flags to the xfs_ilock family of functions

This kills 8 bytes per inode for non-debug builds, which would e.g.
be the space for ACL caching on 32bit systems.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/mrlock.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/mrlock.h	2008-03-20 09:38:53.000000000 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,102 +0,0 @@
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_SUPPORT_MRLOCK_H__
-#define __XFS_SUPPORT_MRLOCK_H__
-
-#include <linux/rwsem.h>
-
-enum { MR_NONE, MR_ACCESS, MR_UPDATE };
-
-typedef struct {
-	struct rw_semaphore	mr_lock;
-	int			mr_writer;
-} mrlock_t;
-
-#define mrinit(mrp, name)	\
-	do { (mrp)->mr_writer = 0; init_rwsem(&(mrp)->mr_lock); } while (0)
-#define mrlock_init(mrp, t,n,s)	mrinit(mrp, n)
-#define mrfree(mrp)		do { } while (0)
-
-static inline void mraccess(mrlock_t *mrp)
-{
-	down_read(&mrp->mr_lock);
-}
-
-static inline void mrupdate(mrlock_t *mrp)
-{
-	down_write(&mrp->mr_lock);
-	mrp->mr_writer = 1;
-}
-
-static inline void mraccess_nested(mrlock_t *mrp, int subclass)
-{
-	down_read_nested(&mrp->mr_lock, subclass);
-}
-
-static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
-{
-	down_write_nested(&mrp->mr_lock, subclass);
-	mrp->mr_writer = 1;
-}
-
-
-static inline int mrtryaccess(mrlock_t *mrp)
-{
-	return down_read_trylock(&mrp->mr_lock);
-}
-
-static inline int mrtryupdate(mrlock_t *mrp)
-{
-	if (!down_write_trylock(&mrp->mr_lock))
-		return 0;
-	mrp->mr_writer = 1;
-	return 1;
-}
-
-static inline void mrunlock(mrlock_t *mrp)
-{
-	if (mrp->mr_writer) {
-		mrp->mr_writer = 0;
-		up_write(&mrp->mr_lock);
-	} else {
-		up_read(&mrp->mr_lock);
-	}
-}
-
-static inline void mrdemote(mrlock_t *mrp)
-{
-	mrp->mr_writer = 0;
-	downgrade_write(&mrp->mr_lock);
-}
-
-#ifdef DEBUG
-/*
- * Debug-only routine, without some platform-specific asm code, we can
- * now only answer requests regarding whether we hold the lock for write
- * (reader state is outside our visibility, we only track writer state).
- * Note: means !ismrlocked would give false positives, so don't do that.
- */
-static inline int ismrlocked(mrlock_t *mrp, int type)
-{
-	if (mrp && type == MR_UPDATE)
-		return mrp->mr_writer;
-	return 1;
-}
-#endif
-
-#endif /* __XFS_SUPPORT_MRLOCK_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2008-03-20 09:40:35.000000000 +0100
@@ -211,9 +211,8 @@ finish_inode:
 	xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 
 
-	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
-		     "xfsino", ip->i_ino);
-	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
+	init_rwsem(&ip->i_lock);
+	init_rwsem(&ip->i_iolock);
 	init_waitqueue_head(&ip->i_ipin_wait);
 	atomic_set(&ip->i_pincount, 0);
 	initnsema(&ip->i_flock, 1, "xfsfino");
@@ -593,8 +592,9 @@ xfs_iunlock_map_shared(
  *		XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL
  */
 void
-xfs_ilock(xfs_inode_t	*ip,
-	  uint		lock_flags)
+xfs_ilock(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
 {
 	/*
 	 * You can't set both SHARED and EXCL for the same lock,
@@ -608,16 +608,19 @@ xfs_ilock(xfs_inode_t	*ip,
 	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
 
 	if (lock_flags & XFS_IOLOCK_EXCL) {
-		mrupdate_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
+		down_write_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
 	} else if (lock_flags & XFS_IOLOCK_SHARED) {
-		mraccess_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
+		down_read_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
 	}
 	if (lock_flags & XFS_ILOCK_EXCL) {
-		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
+		down_write_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
 	} else if (lock_flags & XFS_ILOCK_SHARED) {
-		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
+		down_read_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
 	}
 	xfs_ilock_trace(ip, 1, lock_flags, (inst_t *)__return_address);
+#ifdef DEBUG
+	ip->i_lock_state |= (lock_flags & (XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
+#endif
 }
 
 /*
@@ -634,11 +637,12 @@ xfs_ilock(xfs_inode_t	*ip,
  *
  */
 int
-xfs_ilock_nowait(xfs_inode_t	*ip,
-		 uint		lock_flags)
+xfs_ilock_nowait(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
 {
-	int	iolocked;
-	int	ilocked;
+	int			iolocked;
+	int			ilocked;
 
 	/*
 	 * You can't set both SHARED and EXCL for the same lock,
@@ -653,35 +657,36 @@ xfs_ilock_nowait(xfs_inode_t	*ip,
 
 	iolocked = 0;
 	if (lock_flags & XFS_IOLOCK_EXCL) {
-		iolocked = mrtryupdate(&ip->i_iolock);
-		if (!iolocked) {
+		iolocked = down_write_trylock(&ip->i_iolock);
+		if (!iolocked)
 			return 0;
-		}
 	} else if (lock_flags & XFS_IOLOCK_SHARED) {
-		iolocked = mrtryaccess(&ip->i_iolock);
-		if (!iolocked) {
+		iolocked = down_read_trylock(&ip->i_iolock);
+		if (!iolocked)
 			return 0;
-		}
 	}
+
 	if (lock_flags & XFS_ILOCK_EXCL) {
-		ilocked = mrtryupdate(&ip->i_lock);
-		if (!ilocked) {
-			if (iolocked) {
-				mrunlock(&ip->i_iolock);
-			}
-			return 0;
-		}
+		ilocked = down_write_trylock(&ip->i_lock);
+		if (!ilocked)
+			goto out_ilock_fail;
 	} else if (lock_flags & XFS_ILOCK_SHARED) {
-		ilocked = mrtryaccess(&ip->i_lock);
-		if (!ilocked) {
-			if (iolocked) {
-				mrunlock(&ip->i_iolock);
-			}
-			return 0;
-		}
+		ilocked = down_read_trylock(&ip->i_lock);
+		if (!ilocked)
+			goto out_ilock_fail;
 	}
 	xfs_ilock_trace(ip, 2, lock_flags, (inst_t *)__return_address);
+#ifdef DEBUG
+	ip->i_lock_state |= (lock_flags & (XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
+#endif
 	return 1;
+
+ out_ilock_fail:
+	if (lock_flags & XFS_IOLOCK_EXCL)
+		up_write(&ip->i_iolock);
+	else if (lock_flags & XFS_IOLOCK_SHARED)
+		up_read(&ip->i_iolock);
+	return 0;
 }
 
 /*
@@ -697,8 +702,9 @@ xfs_ilock_nowait(xfs_inode_t	*ip,
  *
  */
 void
-xfs_iunlock(xfs_inode_t	*ip,
-	    uint	lock_flags)
+xfs_iunlock(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
 {
 	/*
 	 * You can't set both SHARED and EXCL for the same lock,
@@ -711,35 +717,33 @@ xfs_iunlock(xfs_inode_t	*ip,
 	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_IUNLOCK_NONOTIFY |
 			XFS_LOCK_DEP_MASK)) == 0);
+	ASSERT(ip->i_lock_state & lock_flags);
 	ASSERT(lock_flags != 0);
 
-	if (lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) {
-		ASSERT(!(lock_flags & XFS_IOLOCK_SHARED) ||
-		       (ismrlocked(&ip->i_iolock, MR_ACCESS)));
-		ASSERT(!(lock_flags & XFS_IOLOCK_EXCL) ||
-		       (ismrlocked(&ip->i_iolock, MR_UPDATE)));
-		mrunlock(&ip->i_iolock);
-	}
-
-	if (lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) {
-		ASSERT(!(lock_flags & XFS_ILOCK_SHARED) ||
-		       (ismrlocked(&ip->i_lock, MR_ACCESS)));
-		ASSERT(!(lock_flags & XFS_ILOCK_EXCL) ||
-		       (ismrlocked(&ip->i_lock, MR_UPDATE)));
-		mrunlock(&ip->i_lock);
+	if (lock_flags & XFS_IOLOCK_EXCL)
+		up_write(&ip->i_iolock);
+	else if (lock_flags & XFS_IOLOCK_SHARED)
+		up_read(&ip->i_iolock);
+
+	if (lock_flags & XFS_ILOCK_EXCL)
+		up_write(&ip->i_lock);
+	else if (lock_flags & (XFS_ILOCK_SHARED))
+		up_read(&ip->i_lock);
 
+	if ((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) &&
+	    !(lock_flags & XFS_IUNLOCK_NONOTIFY) && ip->i_itemp) {
 		/*
 		 * Let the AIL know that this item has been unlocked in case
 		 * it is in the AIL and anyone is waiting on it.  Don't do
 		 * this if the caller has asked us not to.
 		 */
-		if (!(lock_flags & XFS_IUNLOCK_NONOTIFY) &&
-		     ip->i_itemp != NULL) {
-			xfs_trans_unlocked_item(ip->i_mount,
-						(xfs_log_item_t*)(ip->i_itemp));
-		}
+		xfs_trans_unlocked_item(ip->i_mount,
+					(xfs_log_item_t *)ip->i_itemp);
 	}
 	xfs_ilock_trace(ip, 3, lock_flags, (inst_t *)__return_address);
+#ifdef DEBUG
+	ip->i_lock_state &= ~(lock_flags & (XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
+#endif
 }
 
 /*
@@ -747,21 +751,42 @@ xfs_iunlock(xfs_inode_t	*ip,
  * if it is being demoted.
  */
 void
-xfs_ilock_demote(xfs_inode_t	*ip,
-		 uint		lock_flags)
+xfs_ilock_demote(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
 {
 	ASSERT(lock_flags & (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL));
 	ASSERT((lock_flags & ~(XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
+	ASSERT(ip->i_lock_state & lock_flags);
 
-	if (lock_flags & XFS_ILOCK_EXCL) {
-		ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
-		mrdemote(&ip->i_lock);
-	}
-	if (lock_flags & XFS_IOLOCK_EXCL) {
-		ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
-		mrdemote(&ip->i_iolock);
-	}
+	if (lock_flags & XFS_ILOCK_EXCL)
+		downgrade_write(&ip->i_lock);
+	if (lock_flags & XFS_IOLOCK_EXCL)
+		downgrade_write(&ip->i_iolock);
+
+#ifdef DEBUG
+	ip->i_lock_state &= ~lock_flags;
+#endif
+}
+
+#ifdef DEBUG
+/*
+ * Debug-only routine, without additional rw_semaphore APIs, we can
+ * now only answer requests regarding whether we hold the lock for write
+ * (reader state is outside our visibility, we only track writer state).
+ *
+ * Note: means !xfs_isilocked would give false positives, so don't do that.
+ */
+int
+xfs_isilocked(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
+{
+	if (lock_flags & (XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL))
+		return (ip->i_lock_state & lock_flags);
+	return 1;
 }
+#endif
 
 /*
  * The following three routines simply manage the i_flock
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-03-20 09:40:35.000000000 +0100
@@ -1291,7 +1291,7 @@ xfs_file_last_byte(
 	xfs_fileoff_t	size_last_block;
 	int		error;
 
-	ASSERT(ismrlocked(&(ip->i_iolock), MR_UPDATE | MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED));
 
 	mp = ip->i_mount;
 	/*
@@ -1402,7 +1402,7 @@ xfs_itruncate_start(
 	bhv_vnode_t	*vp;
 	int		error = 0;
 
-	ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE) != 0);
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT((new_size == 0) || (new_size <= ip->i_size));
 	ASSERT((flags == XFS_ITRUNC_DEFINITE) ||
 	       (flags == XFS_ITRUNC_MAYBE));
@@ -1529,8 +1529,7 @@ xfs_itruncate_finish(
 	xfs_bmap_free_t	free_list;
 	int		error;
 
-	ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE) != 0);
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE) != 0);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 	ASSERT((new_size == 0) || (new_size <= ip->i_size));
 	ASSERT(*tp != NULL);
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -1795,8 +1794,7 @@ xfs_igrow_start(
 	xfs_fsize_t	new_size,
 	cred_t		*credp)
 {
-	ASSERT(ismrlocked(&(ip->i_lock), MR_UPDATE) != 0);
-	ASSERT(ismrlocked(&(ip->i_iolock), MR_UPDATE) != 0);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 	ASSERT(new_size > ip->i_size);
 
 	/*
@@ -1824,8 +1822,7 @@ xfs_igrow_finish(
 	xfs_fsize_t	new_size,
 	int		change_flag)
 {
-	ASSERT(ismrlocked(&(ip->i_lock), MR_UPDATE) != 0);
-	ASSERT(ismrlocked(&(ip->i_iolock), MR_UPDATE) != 0);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 	ASSERT(ip->i_transp == tp);
 	ASSERT(new_size > ip->i_size);
 
@@ -2302,7 +2299,7 @@ xfs_ifree(
 	xfs_dinode_t    	*dip;
 	xfs_buf_t       	*ibp;
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_d.di_nlink == 0);
 	ASSERT(ip->i_d.di_nextents == 0);
@@ -2707,8 +2704,6 @@ xfs_idestroy(
 	}
 	if (ip->i_afp)
 		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
-	mrfree(&ip->i_lock);
-	mrfree(&ip->i_iolock);
 	freesema(&ip->i_flock);
 
 #ifdef XFS_INODE_TRACE
@@ -2761,7 +2756,7 @@ void
 xfs_ipin(
 	xfs_inode_t	*ip)
 {
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	atomic_inc(&ip->i_pincount);
 }
@@ -2794,7 +2789,7 @@ __xfs_iunpin_wait(
 {
 	xfs_inode_log_item_t	*iip = ip->i_itemp;
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE | MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	if (atomic_read(&ip->i_pincount) == 0)
 		return;
 
@@ -2844,7 +2839,7 @@ xfs_iextents_copy(
 	xfs_fsblock_t		start_block;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE|MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(ifp->if_bytes > 0);
 
 	nrecs = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
@@ -3149,7 +3144,7 @@ xfs_iflush(
 
 	XFS_STATS_INC(xs_iflush_count);
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE|MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(issemalocked(&(ip->i_flock)));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > ip->i_df.if_ext_max);
@@ -3314,7 +3309,7 @@ xfs_iflush_int(
 	int			first;
 #endif
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE|MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(issemalocked(&(ip->i_flock)));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > ip->i_df.if_ext_max);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2008-03-20 09:40:35.000000000 +0100
@@ -393,7 +393,7 @@ xfs_zero_last_block(
 	int		error = 0;
 	xfs_bmbt_irec_t	imap;
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE) != 0);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	zero_offset = XFS_B_FSB_OFFSET(mp, isize);
 	if (zero_offset == 0) {
@@ -424,14 +424,14 @@ xfs_zero_last_block(
 	 * out sync.  We need to drop the ilock while we do this so we
 	 * don't deadlock when the buffer cache calls back to us.
 	 */
-	xfs_iunlock(ip, XFS_ILOCK_EXCL| XFS_EXTSIZE_RD);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	zero_len = mp->m_sb.sb_blocksize - zero_offset;
 	if (isize + zero_len > offset)
 		zero_len = offset - isize;
 	error = xfs_iozero(ip, isize, zero_len);
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	ASSERT(error >= 0);
 	return error;
 }
@@ -464,8 +464,7 @@ xfs_zero_eof(
 	int		error = 0;
 	xfs_bmbt_irec_t	imap;
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
-	ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 	ASSERT(offset > isize);
 
 	/*
@@ -474,8 +473,7 @@ xfs_zero_eof(
 	 */
 	error = xfs_zero_last_block(ip, offset, isize);
 	if (error) {
-		ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
-		ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
+		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 		return error;
 	}
 
@@ -506,8 +504,7 @@ xfs_zero_eof(
 		error = xfs_bmapi(NULL, ip, start_zero_fsb, zero_count_fsb,
 				  0, NULL, 0, &imap, &nimaps, NULL, NULL);
 		if (error) {
-			ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
-			ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
+			ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 			return error;
 		}
 		ASSERT(nimaps > 0);
@@ -531,7 +528,7 @@ xfs_zero_eof(
 		 * Drop the inode lock while we're doing the I/O.
 		 * We'll still have the iolock to protect us.
 		 */
-		xfs_iunlock(ip, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 		zero_off = XFS_FSB_TO_B(mp, start_zero_fsb);
 		zero_len = XFS_FSB_TO_B(mp, imap.br_blockcount);
@@ -547,13 +544,13 @@ xfs_zero_eof(
 		start_zero_fsb = imap.br_startoff + imap.br_blockcount;
 		ASSERT(start_zero_fsb <= (end_zero_fsb + 1));
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 	}
 
 	return 0;
 
 out_lock:
-	xfs_ilock(ip, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	ASSERT(error >= 0);
 	return error;
 }
Index: linux-2.6-xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_dquot.c	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/quota/xfs_dquot.c	2008-03-20 09:40:35.000000000 +0100
@@ -933,7 +933,7 @@ xfs_qm_dqget(
 	       type == XFS_DQ_PROJ ||
 	       type == XFS_DQ_GROUP);
 	if (ip) {
-		ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 		if (type == XFS_DQ_USER)
 			ASSERT(ip->i_udquot == NULL);
 		else
@@ -1088,7 +1088,7 @@ xfs_qm_dqget(
 	xfs_qm_mplist_unlock(mp);
 	XFS_DQ_HASH_UNLOCK(h);
  dqret:
-	ASSERT((ip == NULL) || XFS_ISLOCKED_INODE_EXCL(ip));
+	ASSERT((ip == NULL) || xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	xfs_dqtrace_entry(dqp, "DQGET DONE");
 	*O_dqpp = dqp;
 	return (0);
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c	2008-03-20 09:40:35.000000000 +0100
@@ -670,7 +670,7 @@ xfs_qm_dqattach_one(
 	xfs_dquot_t	*dqp;
 	int		error;
 
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	error = 0;
 	/*
 	 * See if we already have it in the inode itself. IO_idqpp is
@@ -874,7 +874,7 @@ xfs_qm_dqattach(
 		return 0;
 
 	ASSERT((flags & XFS_QMOPT_ILOCKED) == 0 ||
-	       XFS_ISLOCKED_INODE_EXCL(ip));
+	       xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (! (flags & XFS_QMOPT_ILOCKED))
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -888,7 +888,8 @@ xfs_qm_dqattach(
 			goto done;
 		nquotas++;
 	}
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (XFS_IS_OQUOTA_ON(mp)) {
 		error = XFS_IS_GQUOTA_ON(mp) ?
 			xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
@@ -913,7 +914,7 @@ xfs_qm_dqattach(
 	 * This WON'T, in general, result in a thrash.
 	 */
 	if (nquotas == 2) {
-		ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 		ASSERT(ip->i_udquot);
 		ASSERT(ip->i_gdquot);
 
@@ -956,7 +957,7 @@ xfs_qm_dqattach(
 
 #ifdef QUOTADEBUG
 	else
-		ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 #endif
 	return error;
 }
@@ -1291,7 +1292,7 @@ xfs_qm_dqget_noattach(
 	xfs_mount_t	*mp;
 	xfs_dquot_t	*udqp, *gdqp;
 
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	mp = ip->i_mount;
 	udqp = NULL;
 	gdqp = NULL;
@@ -1392,7 +1393,7 @@ xfs_qm_qino_alloc(
 	 * Keep an extra reference to this quota inode. This inode is
 	 * locked exclusively and joined to the transaction already.
 	 */
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(*ip));
+	ASSERT(xfs_isilocked(*ip, XFS_ILOCK_EXCL));
 	VN_HOLD(XFS_ITOV((*ip)));
 
 	/*
@@ -2549,7 +2550,7 @@ xfs_qm_vop_chown(
 	uint		bfield = XFS_IS_REALTIME_INODE(ip) ?
 				 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
 
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(ip->i_mount));
 
 	/* old dquot */
@@ -2593,7 +2594,7 @@ xfs_qm_vop_chown_reserve(
 	uint		delblks, blkflags, prjflags = 0;
 	xfs_dquot_t	*unresudq, *unresgdq, *delblksudq, *delblksgdq;
 
-	ASSERT(XFS_ISLOCKED_INODE(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	mp = ip->i_mount;
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
@@ -2703,7 +2704,7 @@ xfs_qm_vop_dqattach_and_dqmod_newinode(
 	if (!XFS_IS_QUOTA_ON(tp->t_mountp))
 		return;
 
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(tp->t_mountp));
 
 	if (udqp) {
Index: linux-2.6-xfs/fs/xfs/quota/xfs_quota_priv.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_quota_priv.h	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/quota/xfs_quota_priv.h	2008-03-20 09:40:35.000000000 +0100
@@ -27,11 +27,6 @@
 /* Number of dquots that fit in to a dquot block */
 #define XFS_QM_DQPERBLK(mp)	((mp)->m_quotainfo->qi_dqperchunk)
 
-#define XFS_ISLOCKED_INODE(ip)		(ismrlocked(&(ip)->i_lock, \
-					    MR_UPDATE | MR_ACCESS) != 0)
-#define XFS_ISLOCKED_INODE_EXCL(ip)	(ismrlocked(&(ip)->i_lock, \
-					    MR_UPDATE) != 0)
-
 #define XFS_DQ_IS_ADDEDTO_TRX(t, d)	((d)->q_transp == (t))
 
 #define XFS_QI_MPLRECLAIMS(mp)	((mp)->m_quotainfo->qi_dqreclaims)
Index: linux-2.6-xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/quota/xfs_trans_dquot.c	2008-03-20 09:40:35.000000000 +0100
@@ -834,7 +834,7 @@ xfs_trans_reserve_quota_nblks(
 	ASSERT(ip->i_ino != mp->m_sb.sb_uquotino);
 	ASSERT(ip->i_ino != mp->m_sb.sb_gquotino);
 
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(ip->i_mount));
 	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
 				XFS_TRANS_DQ_RES_RTBLKS ||
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-03-20 09:40:35.000000000 +0100
@@ -4075,7 +4075,6 @@ xfs_bmap_add_attrfork(
 error2:
 	xfs_bmap_cancel(&flist);
 error1:
-	ASSERT(ismrlocked(&ip->i_lock,MR_UPDATE));
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 error0:
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-03-20 09:40:35.000000000 +0100
@@ -221,8 +221,11 @@ typedef struct xfs_inode {
 	/* Transaction and locking information. */
 	struct xfs_trans	*i_transp;	/* ptr to owning transaction*/
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
-	mrlock_t		i_lock;		/* inode lock */
-	mrlock_t		i_iolock;	/* inode IO lock */
+	struct rw_semaphore	i_lock;		/* inode lock */
+	struct rw_semaphore	i_iolock;	/* inode IO lock */
+#ifdef DEBUG
+	unsigned int		i_lock_state;	/* i_lock/i_iolock state */
+#endif
 	sema_t			i_flock;	/* inode flush lock */
 	atomic_t		i_pincount;	/* inode pin count */
 	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
@@ -386,20 +389,9 @@ xfs_iflags_test_and_clear(xfs_inode_t *i
 #define	XFS_ILOCK_EXCL		(1<<2)
 #define	XFS_ILOCK_SHARED	(1<<3)
 #define	XFS_IUNLOCK_NONOTIFY	(1<<4)
-/*	#define XFS_IOLOCK_NESTED	(1<<5)	*/
-#define XFS_EXTENT_TOKEN_RD	(1<<6)
-#define XFS_SIZE_TOKEN_RD	(1<<7)
-#define XFS_EXTSIZE_RD		(XFS_EXTENT_TOKEN_RD|XFS_SIZE_TOKEN_RD)
-#define XFS_WILLLEND		(1<<8)	/* Always acquire tokens for lending */
-#define XFS_EXTENT_TOKEN_WR	(XFS_EXTENT_TOKEN_RD | XFS_WILLLEND)
-#define XFS_SIZE_TOKEN_WR       (XFS_SIZE_TOKEN_RD | XFS_WILLLEND)
-#define XFS_EXTSIZE_WR		(XFS_EXTSIZE_RD | XFS_WILLLEND)
-/* TODO:XFS_SIZE_TOKEN_WANT	(1<<9) */
-
-#define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
-				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
-				| XFS_EXTENT_TOKEN_RD | XFS_SIZE_TOKEN_RD \
-				| XFS_WILLLEND)
+
+#define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED | \
+				 XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)
 
 /*
  * Flags for lockdep annotations.
@@ -483,6 +475,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
 void		xfs_ilock_demote(xfs_inode_t *, uint);
+int		xfs_isilocked(xfs_inode_t *, uint);
 void		xfs_iflock(xfs_inode_t *);
 int		xfs_iflock_nowait(xfs_inode_t *);
 uint		xfs_ilock_map_shared(xfs_inode_t *);
Index: linux-2.6-xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode_item.c	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_inode_item.c	2008-03-20 09:40:35.000000000 +0100
@@ -546,7 +546,7 @@ STATIC void
 xfs_inode_item_pin(
 	xfs_inode_log_item_t	*iip)
 {
-	ASSERT(ismrlocked(&(iip->ili_inode->i_lock), MR_UPDATE));
+	ASSERT(xfs_isilocked(iip->ili_inode, XFS_ILOCK_EXCL));
 	xfs_ipin(iip->ili_inode);
 }
 
@@ -663,13 +663,13 @@ xfs_inode_item_unlock(
 
 	ASSERT(iip != NULL);
 	ASSERT(iip->ili_inode->i_itemp != NULL);
-	ASSERT(ismrlocked(&(iip->ili_inode->i_lock), MR_UPDATE));
+	ASSERT(xfs_isilocked(iip->ili_inode, XFS_ILOCK_EXCL));
 	ASSERT((!(iip->ili_inode->i_itemp->ili_flags &
 		  XFS_ILI_IOLOCKED_EXCL)) ||
-	       ismrlocked(&(iip->ili_inode->i_iolock), MR_UPDATE));
+	       xfs_isilocked(iip->ili_inode, XFS_IOLOCK_EXCL));
 	ASSERT((!(iip->ili_inode->i_itemp->ili_flags &
 		  XFS_ILI_IOLOCKED_SHARED)) ||
-	       ismrlocked(&(iip->ili_inode->i_iolock), MR_ACCESS));
+	       xfs_isilocked(iip->ili_inode, XFS_IOLOCK_SHARED));
 	/*
 	 * Clear the transaction pointer in the inode.
 	 */
@@ -768,7 +768,7 @@ xfs_inode_item_pushbuf(
 
 	ip = iip->ili_inode;
 
-	ASSERT(ismrlocked(&(ip->i_lock), MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
 
 	/*
 	 * The ili_pushbuf_flag keeps others from
@@ -851,7 +851,7 @@ xfs_inode_item_push(
 
 	ip = iip->ili_inode;
 
-	ASSERT(ismrlocked(&(ip->i_lock), MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
 	ASSERT(issemalocked(&(ip->i_flock)));
 	/*
 	 * Since we were able to lock the inode's flush lock and
Index: linux-2.6-xfs/fs/xfs/xfs_iomap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.c	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_iomap.c	2008-03-20 09:40:35.000000000 +0100
@@ -196,14 +196,14 @@ xfs_iomap(
 		break;
 	case BMAPI_WRITE:
 		xfs_iomap_enter_trace(XFS_IOMAP_WRITE_ENTER, ip, offset, count);
-		lockmode = XFS_ILOCK_EXCL|XFS_EXTSIZE_WR;
+		lockmode = XFS_ILOCK_EXCL;
 		if (flags & BMAPI_IGNSTATE)
 			bmapi_flags |= XFS_BMAPI_IGSTATE|XFS_BMAPI_ENTIRE;
 		xfs_ilock(ip, lockmode);
 		break;
 	case BMAPI_ALLOCATE:
 		xfs_iomap_enter_trace(XFS_IOMAP_ALLOC_ENTER, ip, offset, count);
-		lockmode = XFS_ILOCK_SHARED|XFS_EXTSIZE_RD;
+		lockmode = XFS_ILOCK_SHARED;
 		bmapi_flags = XFS_BMAPI_ENTIRE;
 
 		/* Attempt non-blocking lock */
@@ -624,7 +624,7 @@ xfs_iomap_write_delay(
 	int		prealloc, fsynced = 0;
 	int		error;
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE) != 0);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	/*
 	 * Make sure that the dquots are there. This doesn't hold
Index: linux-2.6-xfs/fs/xfs/xfs_trans_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_trans_inode.c	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_trans_inode.c	2008-03-20 09:40:35.000000000 +0100
@@ -111,13 +111,13 @@ xfs_trans_iget(
 		 */
 		ASSERT(ip->i_itemp != NULL);
 		ASSERT(lock_flags & XFS_ILOCK_EXCL);
-		ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 		ASSERT((!(lock_flags & XFS_IOLOCK_EXCL)) ||
-		       ismrlocked(&ip->i_iolock, MR_UPDATE));
+		       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 		ASSERT((!(lock_flags & XFS_IOLOCK_EXCL)) ||
 		       (ip->i_itemp->ili_flags & XFS_ILI_IOLOCKED_EXCL));
 		ASSERT((!(lock_flags & XFS_IOLOCK_SHARED)) ||
-		       ismrlocked(&ip->i_iolock, (MR_UPDATE | MR_ACCESS)));
+		       xfs_isilocked(ip, XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED));
 		ASSERT((!(lock_flags & XFS_IOLOCK_SHARED)) ||
 		       (ip->i_itemp->ili_flags & XFS_ILI_IOLOCKED_ANY));
 
@@ -185,7 +185,7 @@ xfs_trans_ijoin(
 	xfs_inode_log_item_t	*iip;
 
 	ASSERT(ip->i_transp == NULL);
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(lock_flags & XFS_ILOCK_EXCL);
 	if (ip->i_itemp == NULL)
 		xfs_inode_item_init(ip, ip->i_mount);
@@ -232,7 +232,7 @@ xfs_trans_ihold(
 {
 	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	ip->i_itemp->ili_flags |= XFS_ILI_HOLD;
 }
@@ -257,7 +257,7 @@ xfs_trans_log_inode(
 
 	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)(ip->i_itemp));
 	ASSERT(lidp != NULL);
Index: linux-2.6-xfs/fs/xfs/xfs_utils.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.c	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_utils.c	2008-03-20 09:40:35.000000000 +0100
@@ -310,7 +310,7 @@ xfs_bump_ino_vers2(
 {
 	xfs_mount_t	*mp;
 
-	ASSERT(ismrlocked (&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(ip->i_d.di_version == XFS_DINODE_VERSION_1);
 
 	ip->i_d.di_version = XFS_DINODE_VERSION_2;
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-03-20 09:40:35.000000000 +0100
@@ -1443,7 +1443,7 @@ xfs_inactive_attrs(
 	int		error;
 	xfs_mount_t	*mp;
 
-	ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	tp = *tpp;
 	mp = ip->i_mount;
 	ASSERT(ip->i_d.di_forkoff != 0);
@@ -1900,7 +1900,7 @@ xfs_create(
 	 * It is locked (and joined to the transaction).
 	 */
 
-	ASSERT(ismrlocked (&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	/*
 	 * Now we join the directory inode to the transaction.  We do not do it
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2008-03-20 09:38:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h	2008-03-20 09:40:35.000000000 +0100
@@ -42,7 +42,6 @@
 #include <xfs_arch.h>
 
 #include <kmem.h>
-#include <mrlock.h>
 #include <sv.h>
 #include <mutex.h>
 #include <sema.h>
