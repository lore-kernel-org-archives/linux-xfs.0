Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 16:34:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9TNYfRt031698
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 16:34:42 -0700
Date: Tue, 30 Oct 2007 10:34:42 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] Clean up sparse warnings
Message-ID: <20071029233442.GP995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: xfs-dev@sgi.com


Clean up most outstanding sparse warnings.

These are mostly locking annotations, marking things static,
casts where needed and declaring stuff in header files.

Signed-Off-By: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_globals.c |    3 ++-
 fs/xfs/linux-2.6/xfs_ioctl.c   |    2 +-
 fs/xfs/linux-2.6/xfs_ioctl32.c |    1 +
 fs/xfs/xfs_attr.c              |    2 +-
 fs/xfs/xfs_bmap.c              |    6 +++---
 fs/xfs/xfs_bmap.h              |    2 ++
 fs/xfs/xfs_btree.h             |    2 ++
 fs/xfs/xfs_buf_item.h          |    2 ++
 fs/xfs/xfs_da_btree.h          |    1 +
 fs/xfs/xfs_dir2.c              |    1 +
 fs/xfs/xfs_filestream.c        |    2 +-
 fs/xfs/xfs_log.c               |   24 ++++++++++++------------
 fs/xfs/xfs_log_recover.c       |   18 +++++-------------
 fs/xfs/xfs_mount.c             |    2 +-
 fs/xfs/xfs_mru_cache.c         |   18 ++++++++++++++----
 fs/xfs/xfs_rename.c            |    1 +
 fs/xfs/xfs_trans.h             |    2 ++
 fs/xfs/xfs_trans_item.c        |    1 +
 fs/xfs/xfs_vfsops.c            |   11 -----------
 19 files changed, 53 insertions(+), 48 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_globals.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_globals.c	2007-10-02 16:01:46.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_globals.c	2007-10-26 10:08:57.901694193 +1000
@@ -47,5 +47,6 @@ xfs_param_t xfs_params = {
 /*
  * Global system credential structure.
  */
-cred_t sys_cred_val, *sys_cred = &sys_cred_val;
+static cred_t sys_cred_val;
+cred_t *sys_cred = &sys_cred_val;
 
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-10-02 16:01:47.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl.c	2007-10-26 10:08:57.901694193 +1000
@@ -512,7 +512,7 @@ xfs_attrmulti_attr_get(
 	if (!kbuf)
 		return ENOMEM;
 
-	error = xfs_attr_get(XFS_I(inode), name, kbuf, len, flags, NULL);
+	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags, NULL);
 	if (error)
 		goto out_kfree;
 
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2007-10-15 09:58:18.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ioctl32.c	2007-10-26 10:08:57.905693678 +1000
@@ -44,6 +44,7 @@
 #include "xfs_error.h"
 #include "xfs_dfrag.h"
 #include "xfs_vnodeops.h"
+#include "xfs_ioctl32.h"
 
 #define  _NATIVE_IOC(cmd, type) \
 	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))
Index: 2.6.x-xfs-new/fs/xfs/xfs_attr.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_attr.c	2007-08-24 22:25:22.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_attr.c	2007-10-26 10:08:57.905693678 +1000
@@ -929,7 +929,7 @@ xfs_attr_shortform_addname(xfs_da_args_t
  * This leaf block cannot have a "remote" value, we only call this routine
  * if bmap_one_block() says there is only one block (ie: no remote blks).
  */
-int
+STATIC int
 xfs_attr_leaf_addname(xfs_da_args_t *args)
 {
 	xfs_inode_t *dp;
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap.c	2007-10-02 16:01:47.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap.c	2007-10-26 10:08:57.909693163 +1000
@@ -6393,7 +6393,7 @@ xfs_bmap_count_blocks(
  * Recursively walks each level of a btree
  * to count total fsblocks is use.
  */
-int                                     /* error */
+STATIC int                                     /* error */
 xfs_bmap_count_tree(
 	xfs_mount_t     *mp,            /* file system mount point */
 	xfs_trans_t     *tp,            /* transaction pointer */
@@ -6469,7 +6469,7 @@ xfs_bmap_count_tree(
 /*
  * Count leaf blocks given a range of extent records.
  */
-int
+STATIC int
 xfs_bmap_count_leaves(
 	xfs_ifork_t		*ifp,
 	xfs_extnum_t		idx,
@@ -6489,7 +6489,7 @@ xfs_bmap_count_leaves(
  * Count leaf blocks given a range of extent records originally
  * in btree format.
  */
-int
+STATIC int
 xfs_bmap_disk_count_leaves(
 	xfs_extnum_t		idx,
 	xfs_bmbt_block_t	*block,
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap.h	2007-08-24 22:25:22.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap.h	2007-10-26 10:08:57.909693163 +1000
@@ -25,6 +25,8 @@ struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
 
+extern kmem_zone_t	*xfs_bmap_free_item_zone;
+
 /*
  * DELTA: describe a change to the in-core extent list.
  *
Index: 2.6.x-xfs-new/fs/xfs/xfs_btree.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_btree.h	2007-06-20 15:54:59.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_btree.h	2007-10-26 10:08:57.913692649 +1000
@@ -24,6 +24,8 @@ struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
 
+extern kmem_zone_t	*xfs_btree_cur_zone;
+
 /*
  * This nonsense is to make -wlint happy.
  */
Index: 2.6.x-xfs-new/fs/xfs/xfs_buf_item.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_buf_item.h	2007-10-02 16:01:47.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_buf_item.h	2007-10-26 10:08:57.913692649 +1000
@@ -18,6 +18,8 @@
 #ifndef	__XFS_BUF_ITEM_H__
 #define	__XFS_BUF_ITEM_H__
 
+extern kmem_zone_t	*xfs_buf_item_zone;
+
 /*
  * This is the structure used to lay out a buf log item in the
  * log.  The data map describes which 128 byte chunks of the buffer
Index: 2.6.x-xfs-new/fs/xfs/xfs_da_btree.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_da_btree.h	2007-02-07 13:24:33.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_da_btree.h	2007-10-26 10:08:57.913692649 +1000
@@ -260,6 +260,7 @@ void xfs_da_binval(struct xfs_trans *tp,
 xfs_daddr_t xfs_da_blkno(xfs_dabuf_t *dabuf);
 
 extern struct kmem_zone *xfs_da_state_zone;
+extern struct kmem_zone *xfs_dabuf_zone;
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_DA_BTREE_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfs_dir2.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_dir2.c	2007-09-12 15:41:22.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_dir2.c	2007-10-26 10:08:57.913692649 +1000
@@ -42,6 +42,7 @@
 #include "xfs_dir2_node.h"
 #include "xfs_dir2_trace.h"
 #include "xfs_error.h"
+#include "xfs_vnodeops.h"
 
 
 void
Index: 2.6.x-xfs-new/fs/xfs/xfs_filestream.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_filestream.c	2007-10-02 16:01:22.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_filestream.c	2007-10-26 10:08:57.917692134 +1000
@@ -348,7 +348,7 @@ _xfs_filestream_update_ag(
 }
 
 /* xfs_fstrm_free_func(): callback for freeing cached stream items. */
-void
+STATIC void
 xfs_fstrm_free_func(
 	unsigned long	ino,
 	void		*data)
Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-10-02 16:01:48.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-10-26 10:08:57.917692134 +1000
@@ -907,7 +907,7 @@ xlog_assign_tail_lsn(xfs_mount_t *mp)
  * the tail.  The details of this case are described below, but the end
  * result is that we return the size of the log as the amount of space left.
  */
-int
+STATIC int
 xlog_space_left(xlog_t *log, int cycle, int bytes)
 {
 	int free_bytes;
@@ -1289,7 +1289,7 @@ xlog_commit_record(xfs_mount_t  *mp,
  * pushes on an lsn which is further along in the log once we reach the high
  * water mark.  In this manner, we would be creating a low water mark.
  */
-void
+STATIC void
 xlog_grant_push_ail(xfs_mount_t	*mp,
 		    int		need_bytes)
 {
@@ -1372,7 +1372,7 @@ xlog_grant_push_ail(xfs_mount_t	*mp,
  * is added immediately before calling bwrite().
  */
 
-int
+STATIC int
 xlog_sync(xlog_t		*log,
 	  xlog_in_core_t	*iclog)
 {
@@ -1516,7 +1516,7 @@ xlog_sync(xlog_t		*log,
 /*
  * Deallocate a log structure
  */
-void
+STATIC void
 xlog_dealloc_log(xlog_t *log)
 {
 	xlog_in_core_t	*iclog, *next_iclog;
@@ -1738,7 +1738,7 @@ xlog_print_tic_res(xfs_mount_t *mp, xlog
  *	we don't update ic_offset until the end when we know exactly how many
  *	bytes have been written out.
  */
-int
+STATIC int
 xlog_write(xfs_mount_t *	mp,
 	   xfs_log_iovec_t	reg[],
 	   int			nentries,
@@ -2280,7 +2280,7 @@ xlog_state_do_callback(
  * global state machine log lock.  Assume that the calls to cvsema won't
  * take a long time.  At least we know it won't sleep.
  */
-void
+STATIC void
 xlog_state_done_syncing(
 	xlog_in_core_t	*iclog,
 	int		aborted)
@@ -2340,7 +2340,7 @@ xlog_state_done_syncing(
  *		needs to be incremented, depending on the amount of data which
  *		is copied.
  */
-int
+STATIC int
 xlog_state_get_iclog_space(xlog_t	  *log,
 			   int		  len,
 			   xlog_in_core_t **iclogp,
@@ -2776,7 +2776,7 @@ xlog_ungrant_log_space(xlog_t	     *log,
 /*
  * Atomically put back used ticket.
  */
-void
+STATIC void
 xlog_state_put_ticket(xlog_t	    *log,
 		      xlog_ticket_t *tic)
 {
@@ -2794,7 +2794,7 @@ xlog_state_put_ticket(xlog_t	    *log,
  *
  *
  */
-int
+STATIC int
 xlog_state_release_iclog(xlog_t		*log,
 			 xlog_in_core_t	*iclog)
 {
@@ -3024,7 +3024,7 @@ no_sleep:
  * If filesystem activity goes to zero, the iclog will get flushed only by
  * bdflush().
  */
-int
+STATIC int
 xlog_state_sync(xlog_t	  *log,
 		xfs_lsn_t lsn,
 		uint	  flags,
@@ -3129,7 +3129,7 @@ try_again:
  * Called when we want to mark the current iclog as being ready to sync to
  * disk.
  */
-void
+STATIC void
 xlog_state_want_sync(xlog_t *log, xlog_in_core_t *iclog)
 {
 	spin_lock(&log->l_icloglock);
@@ -3241,7 +3241,7 @@ xlog_ticket_put(xlog_t		*log,
 /*
  * Grab ticket off freelist or allocation some more
  */
-xlog_ticket_t *
+STATIC xlog_ticket_t *
 xlog_ticket_get(xlog_t		*log,
 		int		unit_bytes,
 		int		cnt,
Index: 2.6.x-xfs-new/fs/xfs/xfs_log_recover.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log_recover.c	2007-10-15 09:58:18.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_log_recover.c	2007-10-26 10:08:57.921691620 +1000
@@ -293,7 +293,7 @@ xlog_recover_iodone(
  * Note that the algorithm can not be perfect because the disk will not
  * necessarily be perfect.
  */
-int
+STATIC int
 xlog_find_cycle_start(
 	xlog_t		*log,
 	xfs_buf_t	*bp,
@@ -986,7 +986,7 @@ exit:
  *	-1 => use *blk_no as the first block of the log
  *	>0 => error has occurred
  */
-int
+STATIC int
 xlog_find_zeroed(
 	xlog_t		*log,
 	xfs_daddr_t	*blk_no)
@@ -2733,21 +2733,13 @@ xlog_recover_do_efd_trans(
 				 * AIL lock.
 				 */
 				xfs_trans_delete_ail(mp, lip);
-				break;
+				xfs_efi_item_free(efip);
+				return;
 			}
 		}
 		lip = xfs_trans_next_ail(mp, lip, &gen, NULL);
 	}
-
-	/*
-	 * If we found it, then free it up.  If it wasn't there, it
-	 * must have been overwritten in the log.  Oh well.
-	 */
-	if (lip != NULL) {
-		xfs_efi_item_free(efip);
-	} else {
-		spin_unlock(&mp->m_ail_lock);
-	}
+	spin_unlock(&mp->m_ail_lock);
 }
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-10-16 08:52:58.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-10-26 10:08:57.925691105 +1000
@@ -2343,7 +2343,7 @@ out:
 		spin_unlock(&mp->m_sb_lock);
 }
 
-int
+STATIC int
 xfs_icsb_modify_counters(
 	xfs_mount_t	*mp,
 	xfs_sb_field_t	field,
Index: 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mru_cache.c	2007-10-02 16:01:48.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mru_cache.c	2007-10-26 10:08:57.925691105 +1000
@@ -225,10 +225,14 @@ _xfs_mru_cache_list_insert(
  * list need to be deleted.  For each element this involves removing it from the
  * data store, removing it from the reap list, calling the client's free
  * function and deleting the element from the element zone.
+ *
+ * We get called holding the mru->lock, which we drop and then reacquire.
+ * Sparse need special help with this to tell it we know what we are doing.
  */
 STATIC void
 _xfs_mru_cache_clear_reap_list(
-	xfs_mru_cache_t		*mru)
+	xfs_mru_cache_t		*mru) __releases(mru->lock) __acquires(mru->lock)
+
 {
 	xfs_mru_cache_elem_t	*elem, *next;
 	struct list_head	tmp;
@@ -528,6 +532,10 @@ xfs_mru_cache_delete(
  *
  * If the element isn't found, this function returns NULL and the spinlock is
  * released.  xfs_mru_cache_done() should NOT be called when this occurs.
+ *
+ * Because sparse isn't smart enough to know about conditional lock return
+ * status, we need to help it get it right by annotating the path that does
+ * not release the lock.
  */
 void *
 xfs_mru_cache_lookup(
@@ -545,8 +553,8 @@ xfs_mru_cache_lookup(
 	if (elem) {
 		list_del(&elem->list_node);
 		_xfs_mru_cache_list_insert(mru, elem);
-	}
-	else
+		__release(mru_lock); /* help sparse not be stupid */
+	} else
 		spin_unlock(&mru->lock);
 
 	return elem ? elem->value : NULL;
@@ -575,6 +583,8 @@ xfs_mru_cache_peek(
 	elem = radix_tree_lookup(&mru->store, key);
 	if (!elem)
 		spin_unlock(&mru->lock);
+	else
+		__release(mru_lock); /* help sparse not be stupid */
 
 	return elem ? elem->value : NULL;
 }
@@ -586,7 +596,7 @@ xfs_mru_cache_peek(
  */
 void
 xfs_mru_cache_done(
-	xfs_mru_cache_t	*mru)
+	xfs_mru_cache_t	*mru) __releases(mru->lock)
 {
 	spin_unlock(&mru->lock);
 }
Index: 2.6.x-xfs-new/fs/xfs/xfs_rename.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_rename.c	2007-09-12 15:41:22.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_rename.c	2007-10-26 10:08:57.925691105 +1000
@@ -39,6 +39,7 @@
 #include "xfs_refcache.h"
 #include "xfs_utils.h"
 #include "xfs_trans_space.h"
+#include "xfs_vnodeops.h"
 
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans.h	2007-10-02 16:01:23.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans.h	2007-10-26 10:08:57.929690591 +1000
@@ -1001,6 +1001,8 @@ xfs_log_busy_slot_t *xfs_trans_add_busy(
 					xfs_agnumber_t ag,
 					xfs_extlen_t idx);
 
+extern kmem_zone_t	*xfs_trans_zone;
+
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_TRANS_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_item.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_item.c	2007-01-16 10:54:19.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans_item.c	2007-10-26 10:08:57.929690591 +1000
@@ -21,6 +21,7 @@
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 
 STATIC int	xfs_trans_unlock_chunk(xfs_log_item_chunk_t *,
 					int, int, xfs_lsn_t);
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-10-25 10:34:08.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-10-26 10:08:57.929690591 +1000
@@ -61,11 +61,6 @@
 int
 xfs_init(void)
 {
-	extern kmem_zone_t	*xfs_bmap_free_item_zone;
-	extern kmem_zone_t	*xfs_btree_cur_zone;
-	extern kmem_zone_t	*xfs_trans_zone;
-	extern kmem_zone_t	*xfs_buf_item_zone;
-	extern kmem_zone_t	*xfs_dabuf_zone;
 #ifdef XFS_DABUF_DEBUG
 	extern spinlock_t        xfs_dabuf_global_lock;
 	spin_lock_init(&xfs_dabuf_global_lock);
@@ -155,15 +150,9 @@ xfs_init(void)
 void
 xfs_cleanup(void)
 {
-	extern kmem_zone_t	*xfs_bmap_free_item_zone;
-	extern kmem_zone_t	*xfs_btree_cur_zone;
 	extern kmem_zone_t	*xfs_inode_zone;
-	extern kmem_zone_t	*xfs_trans_zone;
-	extern kmem_zone_t	*xfs_da_state_zone;
-	extern kmem_zone_t	*xfs_dabuf_zone;
 	extern kmem_zone_t	*xfs_efd_zone;
 	extern kmem_zone_t	*xfs_efi_zone;
-	extern kmem_zone_t	*xfs_buf_item_zone;
 	extern kmem_zone_t	*xfs_icluster_zone;
 
 	xfs_cleanup_procfs();
