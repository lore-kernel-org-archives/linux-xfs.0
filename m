Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 19:26:28 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBH3QJbh016373
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 19:26:22 -0800
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id OAA29351 for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 14:26:31 +1100
Message-ID: <4765EC66.5020202@sgi.com>
Date: Mon, 17 Dec 2007 14:26:30 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: [review] Remove the xfs refcache
Content-Type: multipart/mixed;
 boundary="------------040608040207030606030106"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------040608040207030606030106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Remove the xfs_refcache, it was only needed while we were still building for
2.4 kernels.



--------------040608040207030606030106
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="remove_xfs_refcache.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="remove_xfs_refcache.patch"


--- a/fs/xfs/linux-2.6/xfs_ksyms.c	2007-12-17 11:55:09.000000000 +1100
+++ b/fs/xfs/linux-2.6/xfs_ksyms.c	2007-12-17 11:34:19.000000000 +1100
@@ -46,7 +46,6 @@
 #include "xfs_error.h"
 #include "xfs_itable.h"
 #include "xfs_rw.h"
-#include "xfs_refcache.h"
 #include "xfs_dir2_data.h"
 #include "xfs_dir2_leaf.h"
 #include "xfs_dir2_block.h"

--- a/fs/xfs/linux-2.6/xfs_linux.h	2007-12-17 11:55:09.000000000 +1100
+++ b/fs/xfs/linux-2.6/xfs_linux.h	2007-12-17 10:30:53.000000000 +1100
@@ -99,7 +99,6 @@
 /*
  * Feature macros (disable/enable)
  */
-#undef  HAVE_REFCACHE	/* reference cache not needed for NFS in 2.6 */
 #define HAVE_SPLICE	/* a splice(2) exists in 2.6, but not in 2.4 */
 #ifdef CONFIG_SMP
 #define HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */

--- a/fs/xfs/xfs_inode.h	2007-12-17 11:55:09.000000000 +1100
+++ b/fs/xfs/xfs_inode.h	2007-12-17 10:31:25.000000000 +1100
@@ -240,10 +240,6 @@ typedef struct xfs_inode {
 	atomic_t		i_pincount;	/* inode pin count */
 	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
-#ifdef HAVE_REFCACHE
-	struct xfs_inode	**i_refcache;	/* ptr to entry in ref cache */
-	struct xfs_inode	*i_release;	/* inode to unref */
-#endif
 	/* Miscellaneous state. */
 	unsigned short		i_flags;	/* see defined flags below */
 	unsigned char		i_update_core;	/* timestamps/size is dirty */

--- a/fs/xfs/xfs_rename.c	2007-12-17 11:55:09.000000000 +1100
+++ b/fs/xfs/xfs_rename.c	2007-12-17 10:33:32.000000000 +1100
@@ -36,7 +36,6 @@
 #include "xfs_bmap.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
-#include "xfs_refcache.h"
 #include "xfs_utils.h"
 #include "xfs_trans_space.h"
 #include "xfs_vnodeops.h"
@@ -580,10 +579,8 @@ xfs_rename(
 	 * the vnode references.
 	 */
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-	if (target_ip != NULL) {
-		xfs_refcache_purge_ip(target_ip);
+	if (target_ip != NULL)
 		IRELE(target_ip);
-	}
 	/*
 	 * Let interposed file systems know about removed links.
 	 */

--- a/fs/xfs/xfs_vfsops.c	2007-12-17 11:55:09.000000000 +1100
+++ b/fs/xfs/xfs_vfsops.c	2007-12-17 11:34:19.000000000 +1100
@@ -43,7 +43,6 @@
 #include "xfs_error.h"
 #include "xfs_bmap.h"
 #include "xfs_rw.h"
-#include "xfs_refcache.h"
 #include "xfs_buf_item.h"
 #include "xfs_log_priv.h"
 #include "xfs_dir2_trace.h"
@@ -157,7 +156,6 @@ xfs_cleanup(void)
 
 	xfs_cleanup_procfs();
 	xfs_sysctl_unregister();
-	xfs_refcache_destroy();
 	xfs_filestream_uninit();
 	xfs_mru_cache_uninit();
 	xfs_acl_zone_destroy(xfs_acl_zone);
@@ -585,11 +583,6 @@ xfs_unmount(
 					0 : DM_FLAGS_UNWANTED;
 	}
 #endif
-	/*
-	 * First blow any referenced inode from this file system
-	 * out of the reference cache, and delete the timer.
-	 */
-	xfs_refcache_purge_mp(mp);
 
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
@@ -653,7 +646,6 @@ xfs_quiesce_fs(
 {
 	int			count = 0, pincount;
 
-	xfs_refcache_purge_mp(mp);
 	xfs_flush_buftarg(mp->m_ddev_targp, 0);
 	xfs_finish_reclaim_all(mp, 0);
 
@@ -1344,18 +1336,6 @@ xfs_syncsub(
 	}
 
 	/*
-	 * If this is the periodic sync, then kick some entries out of
-	 * the reference cache.  This ensures that idle entries are
-	 * eventually kicked out of the cache.
-	 */
-	if (flags & SYNC_REFCACHE) {
-		if (flags & SYNC_WAIT)
-			xfs_refcache_purge_mp(mp);
-		else
-			xfs_refcache_purge_some(mp);
-	}
-
-	/*
 	 * If asked, update the disk superblock with incore counter values if we
 	 * are using non-persistent counters so that they don't get too far out
 	 * of sync if we crash or get a forced shutdown. We don't want to force

--- a/fs/xfs/xfs_vnodeops.c	2007-12-17 11:55:09.000000000 +1100
+++ b/fs/xfs/xfs_vnodeops.c	2007-12-17 11:34:20.000000000 +1100
@@ -48,7 +48,6 @@
 #include "xfs_quota.h"
 #include "xfs_utils.h"
 #include "xfs_rtalloc.h"
-#include "xfs_refcache.h"
 #include "xfs_trans_space.h"
 #include "xfs_log_priv.h"
 #include "xfs_filestream.h"
@@ -1541,12 +1540,6 @@ xfs_release(
 			xfs_flush_pages(ip, 0, -1, XFS_B_ASYNC, FI_NONE);
 	}
 
-#ifdef HAVE_REFCACHE
-	/* If we are in the NFS reference cache then don't do this now */
-	if (ip->i_refcache)
-		return 0;
-#endif
-
 	if (ip->i_d.di_nlink != 0) {
 		if ((((ip->i_d.di_mode & S_IFMT) == S_IFREG) &&
 		     ((ip->i_size > 0) || (VN_CACHED(vp) > 0 ||
@@ -2476,14 +2469,6 @@ xfs_remove(
 	}
 
 	/*
-	 * Before we drop our extra reference to the inode, purge it
-	 * from the refcache if it is there.  By waiting until afterwards
-	 * to do the IRELE, we ensure that we won't go inactive in the
-	 * xfs_refcache_purge_ip routine (although that would be OK).
-	 */
-	xfs_refcache_purge_ip(ip);
-
-	/*
 	 * If we are using filestreams, kill the stream association.
 	 * If the file is still open it may get a new one but that
 	 * will get killed on last close in xfs_close() so we don't
@@ -2522,14 +2507,6 @@ xfs_remove(
 	cancel_flags |= XFS_TRANS_ABORT;
 	xfs_trans_cancel(tp, cancel_flags);
 
-	/*
-	 * Before we drop our extra reference to the inode, purge it
-	 * from the refcache if it is there.  By waiting until afterwards
-	 * to do the IRELE, we ensure that we won't go inactive in the
-	 * xfs_refcache_purge_ip routine (although that would be OK).
-	 */
-	xfs_refcache_purge_ip(ip);
-
 	IRELE(ip);
 
 	goto std_return;
@@ -3487,16 +3464,7 @@ xfs_rwunlock(
 {
  	if (S_ISDIR(ip->i_d.di_mode))
   		return;
-	if (locktype == VRWLOCK_WRITE) {
-		/*
-		 * In the write case, we may have added a new entry to
-		 * the reference cache.  This might store a pointer to
-		 * an inode to be released in this inode.  If it is there,
-		 * clear the pointer and release the inode after unlocking
-		 * this one.
-		 */
-		xfs_refcache_iunlock(ip, XFS_IOLOCK_EXCL);
-	} else {
+	if (locktype != VRWLOCK_WRITE) {
 		ASSERT((locktype == VRWLOCK_READ) ||
 		       (locktype == VRWLOCK_WRITE_DIRECT));
 		xfs_iunlock(ip, XFS_IOLOCK_SHARED);

--- a/fs/xfs/xfs_refcache.h	2007-12-17 11:55:19.000000000 +1100
+++ b/fs/xfs/xfs_refcache.h	2006-06-16 23:54:00.000000000 +1000
@@ -1,52 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
-#ifndef __XFS_REFCACHE_H__
-#define __XFS_REFCACHE_H__
-
-#ifdef HAVE_REFCACHE
-/*
- * Maximum size (in inodes) for the NFS reference cache
- */
-#define XFS_REFCACHE_SIZE_MAX	512
-
-struct xfs_inode;
-struct xfs_mount;
-
-extern void xfs_refcache_insert(struct xfs_inode *);
-extern void xfs_refcache_purge_ip(struct xfs_inode *);
-extern void xfs_refcache_purge_mp(struct xfs_mount *);
-extern void xfs_refcache_purge_some(struct xfs_mount *);
-extern void xfs_refcache_resize(int);
-extern void xfs_refcache_destroy(void);
-
-extern void xfs_refcache_iunlock(struct xfs_inode *, uint);
-
-#else
-
-#define xfs_refcache_insert(ip)		do { } while (0)
-#define xfs_refcache_purge_ip(ip)	do { } while (0)
-#define xfs_refcache_purge_mp(mp)	do { } while (0)
-#define xfs_refcache_purge_some(mp)	do { } while (0)
-#define xfs_refcache_resize(size)	do { } while (0)
-#define xfs_refcache_destroy()		do { } while (0)
-
-#define xfs_refcache_iunlock(ip, flags)	xfs_iunlock(ip, flags)
-
-#endif
-
-#endif	/* __XFS_REFCACHE_H__ */

--------------040608040207030606030106--
