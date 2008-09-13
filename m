Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:09:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DE958g016906
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:09:12 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28A1A1ADE153
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:10:33 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id fByObaCht04MfZGc for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:10:33 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] XFS: Combine the XFS and Linux inodes V2
Date: Sun, 14 Sep 2008 00:10:27 +1000
Message-Id: <1221315027-29951-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1221315027-29951-1-git-send-email-david@fromorbit.com>
References: <1221315027-29951-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

To avoid issues with different lifecycles of XFS and Linux inodes,
embedd the linux inode inside the XFS inode. This means that the
linux inode has the same lifecycle as the XFS inode, even when it
has been released by the OS. XFS inodes don't live much longer than
this (a short stint in reclaim at most), so there isn't significant
memory usage penalties here.

Version 2
o remove unused commented out code from xfs_iget().
o kill useless cast in VFS_I()

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_iops.c  |   17 +++-
 fs/xfs/linux-2.6/xfs_super.c |   48 +++++-------
 fs/xfs/linux-2.6/xfs_vnode.c |    6 +-
 fs/xfs/xfs_iget.c            |  167 +++++++++---------------------------------
 fs/xfs/xfs_inode.c           |   43 ++++++++---
 fs/xfs/xfs_inode.h           |    9 ++-
 fs/xfs/xfs_vnodeops.c        |   13 +---
 7 files changed, 109 insertions(+), 194 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 3bfb3c0..37bb101 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -64,14 +64,14 @@ xfs_synchronize_atime(
 {
 	struct inode	*inode = VFS_I(ip);
 
-	if (inode) {
+	if (!(inode->i_state & I_CLEAR)) {
 		ip->i_d.di_atime.t_sec = (__int32_t)inode->i_atime.tv_sec;
 		ip->i_d.di_atime.t_nsec = (__int32_t)inode->i_atime.tv_nsec;
 	}
 }
 
 /*
- * If the linux inode exists, mark it dirty.
+ * If the linux inode is valid, mark it dirty.
  * Used when commiting a dirty inode into a transaction so that
  * the inode will get written back by the linux code
  */
@@ -81,7 +81,7 @@ xfs_mark_inode_dirty_sync(
 {
 	struct inode	*inode = VFS_I(ip);
 
-	if (inode)
+	if (!(inode->i_state & (I_WILL_FREE|I_FREEING|I_CLEAR)))
 		mark_inode_dirty_sync(inode);
 }
 
@@ -766,12 +766,21 @@ xfs_diflags_to_iflags(
  * When reading existing inodes from disk this is called directly
  * from xfs_iget, when creating a new inode it is called from
  * xfs_ialloc after setting up the inode.
+ *
+ * We are always called with an uninitialised linux inode here.
+ * We need to initialise the necessary fields and take a reference
+ * on it.
  */
 void
 xfs_setup_inode(
 	struct xfs_inode	*ip)
 {
-	struct inode		*inode = ip->i_vnode;
+	struct inode		*inode = &ip->i_vnode;
+
+	inode->i_ino = ip->i_ino;
+	inode->i_state = I_NEW|I_LOCK;
+	inode_add_to_lists(ip->i_mount->m_super, inode);
+	ASSERT(atomic_read(&inode->i_count) == 1);
 
 	inode->i_mode	= ip->i_d.di_mode;
 	inode->i_nlink	= ip->i_d.di_nlink;
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 8db6806..796734c 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -71,7 +71,6 @@
 
 static struct quotactl_ops xfs_quotactl_operations;
 static struct super_operations xfs_super_operations;
-static kmem_zone_t *xfs_vnode_zone;
 static kmem_zone_t *xfs_ioend_zone;
 mempool_t *xfs_ioend_pool;
 
@@ -866,29 +865,25 @@ xfsaild_stop(
 }
 
 
-
+/* Catch misguided souls that try to use this interface on XFS */
 STATIC struct inode *
 xfs_fs_alloc_inode(
 	struct super_block	*sb)
 {
-	return kmem_zone_alloc(xfs_vnode_zone, KM_SLEEP);
+	BUG();
 }
 
+/*
+ * we need to provide an empty inode free function to prevent
+ * the generic code from trying to free ouuur combined inode.
+ */
 STATIC void
 xfs_fs_destroy_inode(
-	struct inode		*inode)
-{
-	kmem_zone_free(xfs_vnode_zone, inode);
-}
-
-STATIC void
-xfs_fs_inode_init_once(
-	void			*vnode)
+	struct inode	*inode)
 {
-	inode_init_once((struct inode *)vnode);
+	return;
 }
 
-
 /*
  * Slab object creation initialisation for the XFS inode.
  * This covers only the idempotent fields in the XFS inode;
@@ -897,13 +892,18 @@ xfs_fs_inode_init_once(
  * fields in the xfs inode that left in the initialise state
  * when freeing the inode.
  */
-void
-xfs_inode_init_once(
+STATIC void
+xfs_fs_inode_init_once(
 	void			*inode)
 {
 	struct xfs_inode	*ip = inode;
 
 	memset(ip, 0, sizeof(struct xfs_inode));
+
+	/* vfs inode */
+	inode_init_once(VFS_I(ip));
+
+	/* xfs inode */
 	atomic_set(&ip->i_iocount, 0);
 	atomic_set(&ip->i_pincount, 0);
 	spin_lock_init(&ip->i_flags_lock);
@@ -976,8 +976,6 @@ xfs_fs_clear_inode(
 		if (xfs_reclaim(ip))
 			panic("%s: cannot reclaim 0x%p\n", __func__, inode);
 	}
-
-	ASSERT(XFS_I(inode) == NULL);
 }
 
 STATIC void
@@ -1804,16 +1802,10 @@ xfs_free_trace_bufs(void)
 STATIC int __init
 xfs_init_zones(void)
 {
-	xfs_vnode_zone = kmem_zone_init_flags(sizeof(struct inode), "xfs_vnode",
-					KM_ZONE_HWALIGN | KM_ZONE_RECLAIM |
-					KM_ZONE_SPREAD,
-					xfs_fs_inode_init_once);
-	if (!xfs_vnode_zone)
-		goto out;
 
 	xfs_ioend_zone = kmem_zone_init(sizeof(xfs_ioend_t), "xfs_ioend");
 	if (!xfs_ioend_zone)
-		goto out_destroy_vnode_zone;
+		goto out;
 
 	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
 						  xfs_ioend_zone);
@@ -1829,6 +1821,7 @@ xfs_init_zones(void)
 						"xfs_bmap_free_item");
 	if (!xfs_bmap_free_item_zone)
 		goto out_destroy_log_ticket_zone;
+
 	xfs_btree_cur_zone = kmem_zone_init(sizeof(xfs_btree_cur_t),
 						"xfs_btree_cur");
 	if (!xfs_btree_cur_zone)
@@ -1876,8 +1869,8 @@ xfs_init_zones(void)
 
 	xfs_inode_zone =
 		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
-					KM_ZONE_HWALIGN | KM_ZONE_RECLAIM |
-					KM_ZONE_SPREAD, xfs_inode_init_once);
+			KM_ZONE_HWALIGN | KM_ZONE_RECLAIM | KM_ZONE_SPREAD,
+			xfs_fs_inode_init_once);
 	if (!xfs_inode_zone)
 		goto out_destroy_efi_zone;
 
@@ -1925,8 +1918,6 @@ xfs_init_zones(void)
 	mempool_destroy(xfs_ioend_pool);
  out_destroy_ioend_zone:
 	kmem_zone_destroy(xfs_ioend_zone);
- out_destroy_vnode_zone:
-	kmem_zone_destroy(xfs_vnode_zone);
  out:
 	return -ENOMEM;
 }
@@ -1951,7 +1942,6 @@ xfs_destroy_zones(void)
 	kmem_zone_destroy(xfs_log_ticket_zone);
 	mempool_destroy(xfs_ioend_pool);
 	kmem_zone_destroy(xfs_ioend_zone);
-	kmem_zone_destroy(xfs_vnode_zone);
 
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_vnode.c b/fs/xfs/linux-2.6/xfs_vnode.c
index dceb6db..e5ec36e 100644
--- a/fs/xfs/linux-2.6/xfs_vnode.c
+++ b/fs/xfs/linux-2.6/xfs_vnode.c
@@ -90,11 +90,7 @@ vn_ioerror(
  */
 static inline int xfs_icount(struct xfs_inode *ip)
 {
-	struct inode *inode = VFS_I(ip);
-
-	if (!inode)
-		return atomic_read(&inode->i_count);
-	return -1;
+	return atomic_read(&VFS_I(ip)->i_count);
 }
 
 #define KTRACE_ENTER(ip, vk, s, line, ra)			\
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 12fe37e..533a375 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -44,77 +44,65 @@
  */
 static int
 xfs_iget_cache_hit(
-	struct inode		*inode,
 	struct xfs_perag	*pag,
 	struct xfs_inode	*ip,
 	int			flags,
 	int			lock_flags) __releases(pag->pag_ici_lock)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct inode		*old_inode;
 	int			error = 0;
 
 	/*
 	 * If INEW is set this inode is being set up
+	 * If IRECLAIM is set this inode is being torn down
 	 * Pause and try again.
 	 */
-	if (xfs_iflags_test(ip, XFS_INEW)) {
+	if (xfs_iflags_test(ip, (XFS_INEW|XFS_IRECLAIM))) {
 		error = EAGAIN;
 		XFS_STATS_INC(xs_ig_frecycle);
 		goto out_error;
 	}
 
-	old_inode = ip->i_vnode;
-	if (old_inode == NULL) {
+	/* If IRECLAIMABLE is set, we've torn down the vfs inode part */
+	if (xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
+
 		/*
-		 * If IRECLAIM is set this inode is
-		 * on its way out of the system,
-		 * we need to pause and try again.
+		 * If lookup is racing with unlink, then we should return an
+		 * error immediately so we don't remove it from the reclaim
+		 * list and potentially leak the inode.
 		 */
-		if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
-			error = EAGAIN;
-			XFS_STATS_INC(xs_ig_frecycle);
+
+		if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
+			error = ENOENT;
 			goto out_error;
 		}
-		ASSERT(xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+
+		xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 
 		/*
-		 * If lookup is racing with unlink, then we
-		 * should return an error immediately so we
-		 * don't remove it from the reclaim list and
-		 * potentially leak the inode.
+		 * We need to re-initialise the VFS inode as it has been
+		 * 'freed' by the VFS. Do this here so we can deal with
+		 * errors cleanly, then tag it so it can be set up correctly
+		 * later.
 		 */
-		if ((ip->i_d.di_mode == 0) &&
-		    !(flags & XFS_IGET_CREATE)) {
-			error = ENOENT;
+		if (!inode_init_always(mp->m_super, VFS_I(ip))) {
+			error = ENOMEM;
 			goto out_error;
 		}
-		xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
-
+		xfs_iflags_set(ip, XFS_INEW);
 		xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
 		read_unlock(&pag->pag_ici_lock);
 
 		XFS_MOUNT_ILOCK(mp);
 		list_del_init(&ip->i_reclaim);
 		XFS_MOUNT_IUNLOCK(mp);
-
-	} else if (inode != old_inode) {
-		/* The inode is being torn down, pause and
-		 * try again.
-		 */
-		if (old_inode->i_state & (I_FREEING | I_CLEAR)) {
-			error = EAGAIN;
-			XFS_STATS_INC(xs_ig_frecycle);
-			goto out_error;
-		}
-/* Chances are the other vnode (the one in the inode) is being torn
-* down right now, and we landed on top of it. Question is, what do
-* we do? Unhook the old inode and hook up the new one?
-*/
-		cmn_err(CE_PANIC,
-	"xfs_iget_core: ambiguous vns: vp/0x%p, invp/0x%p",
-				old_inode, inode);
+	} else if (!igrab(VFS_I(ip))) {
+		/* If the VFS inode is being torn down, pause and try again. */
+		error = EAGAIN;
+		XFS_STATS_INC(xs_ig_frecycle);
+		goto out_error;
 	} else {
+		/* we've got a live one */
 		read_unlock(&pag->pag_ici_lock);
 	}
 
@@ -214,11 +202,11 @@ out_destroy:
 /*
  * Look up an inode by number in the given file system.
  * The inode is looked up in the cache held in each AG.
- * If the inode is found in the cache, attach it to the provided
- * vnode.
+ * If the inode is found in the cache, initialise the vfs inode
+ * if necessary.
  *
  * If it is not in core, read it in from the file system's device,
- * add it to the cache and attach the provided vnode.
+ * add it to the cache and initialise the vfs inode.
  *
  * The inode is locked according to the value of the lock_flags parameter.
  * This flag parameter indicates how and if the inode's IO lock and inode lock
@@ -235,9 +223,8 @@ out_destroy:
  * bno -- the block number starting the buffer containing the inode,
  *	  if known (as by bulkstat), else 0.
  */
-STATIC int
-xfs_iget_core(
-	struct inode	*inode,
+int
+xfs_iget(
 	xfs_mount_t	*mp,
 	xfs_trans_t	*tp,
 	xfs_ino_t	ino,
@@ -268,7 +255,7 @@ again:
 	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
 
 	if (ip) {
-		error = xfs_iget_cache_hit(inode, pag, ip, flags, lock_flags);
+		error = xfs_iget_cache_hit(pag, ip, flags, lock_flags);
 		if (error)
 			goto out_error_or_again;
 	} else {
@@ -282,23 +269,16 @@ again:
 	}
 	xfs_put_perag(mp, pag);
 
-	ASSERT(ip->i_df.if_ext_max ==
-	       XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t));
-
 	xfs_iflags_set(ip, XFS_IMODIFIED);
 	*ipp = ip;
 
-	/*
-	 * Set up the Linux with the Linux inode.
-	 */
-	ip->i_vnode = inode;
-	inode->i_private = ip;
-
+	ASSERT(ip->i_df.if_ext_max ==
+	       XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t));
 	/*
 	 * If we have a real type for an on-disk inode, we can set ops(&unlock)
 	 * now.	 If it's a new inode being created, xfs_ialloc will handle it.
 	 */
-	if (ip->i_d.di_mode != 0)
+	if (xfs_iflags_test(ip, XFS_INEW) && ip->i_d.di_mode != 0)
 		xfs_setup_inode(ip);
 	return 0;
 
@@ -313,75 +293,6 @@ out_error_or_again:
 
 
 /*
- * The 'normal' internal xfs_iget, if needed it will
- * 'allocate', or 'get', the vnode.
- */
-int
-xfs_iget(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_ino_t	ino,
-	uint		flags,
-	uint		lock_flags,
-	xfs_inode_t	**ipp,
-	xfs_daddr_t	bno)
-{
-	struct inode	*inode;
-	xfs_inode_t	*ip;
-	int		error;
-
-	XFS_STATS_INC(xs_ig_attempts);
-
-retry:
-	inode = iget_locked(mp->m_super, ino);
-	if (!inode)
-		/* If we got no inode we are out of memory */
-		return ENOMEM;
-
-	if (inode->i_state & I_NEW) {
-		XFS_STATS_INC(vn_active);
-		XFS_STATS_INC(vn_alloc);
-
-		error = xfs_iget_core(inode, mp, tp, ino, flags,
-				lock_flags, ipp, bno);
-		if (error) {
-			make_bad_inode(inode);
-			if (inode->i_state & I_NEW)
-				unlock_new_inode(inode);
-			iput(inode);
-		}
-		return error;
-	}
-
-	/*
-	 * If the inode is not fully constructed due to
-	 * filehandle mismatches wait for the inode to go
-	 * away and try again.
-	 *
-	 * iget_locked will call __wait_on_freeing_inode
-	 * to wait for the inode to go away.
-	 */
-	if (is_bad_inode(inode)) {
-		iput(inode);
-		delay(1);
-		goto retry;
-	}
-
-	ip = XFS_I(inode);
-	if (!ip) {
-		iput(inode);
-		delay(1);
-		goto retry;
-	}
-
-	if (lock_flags != 0)
-		xfs_ilock(ip, lock_flags);
-	XFS_STATS_INC(xs_ig_found);
-	*ipp = ip;
-	return 0;
-}
-
-/*
  * Look for the inode corresponding to the given ino in the hash table.
  * If it is there and its i_transp pointer matches tp, return it.
  * Otherwise, return NULL.
@@ -481,14 +392,6 @@ xfs_ireclaim(xfs_inode_t *ip)
 	XFS_QM_DQDETACH(ip->i_mount, ip);
 
 	/*
-	 * Pull our behavior descriptor from the vnode chain.
-	 */
-	if (ip->i_vnode) {
-		ip->i_vnode->i_private = NULL;
-		ip->i_vnode = NULL;
-	}
-
-	/*
 	 * Free all memory associated with the inode.
 	 */
 	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7c9d0a7..568bc8e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -812,6 +812,16 @@ xfs_inode_alloc(
 	ASSERT(list_empty(&ip->i_reclaim));
 	ASSERT(completion_done(&ip->i_flush));
 
+	/*
+	 * initialise the VFS inode here to get failures
+	 * out of the way early.
+	 */
+	if (!inode_init_always(mp->m_super, VFS_I(ip))) {
+		kmem_zone_free(xfs_inode_zone, ip);
+		return NULL;
+	}
+
+	/* initialise the xfs inode */
 	ip->i_ino = ino;
 	ip->i_mount = mp;
 	ip->i_blkno = 0;
@@ -1086,6 +1096,7 @@ xfs_ialloc(
 	uint		flags;
 	int		error;
 	timespec_t	tv;
+	int		filestreams = 0;
 
 	/*
 	 * Call the space management code to pick
@@ -1093,9 +1104,8 @@ xfs_ialloc(
 	 */
 	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode, okalloc,
 			    ialloc_context, call_again, &ino);
-	if (error != 0) {
+	if (error)
 		return error;
-	}
 	if (*call_again || ino == NULLFSINO) {
 		*ipp = NULL;
 		return 0;
@@ -1109,9 +1119,8 @@ xfs_ialloc(
 	 */
 	error = xfs_trans_iget(tp->t_mountp, tp, ino,
 				XFS_IGET_CREATE, XFS_ILOCK_EXCL, &ip);
-	if (error != 0) {
+	if (error)
 		return error;
-	}
 	ASSERT(ip != NULL);
 
 	ip->i_d.di_mode = (__uint16_t)mode;
@@ -1192,13 +1201,12 @@ xfs_ialloc(
 		flags |= XFS_ILOG_DEV;
 		break;
 	case S_IFREG:
-		if (pip && xfs_inode_is_filestream(pip)) {
-			error = xfs_filestream_associate(pip, ip);
-			if (error < 0)
-				return -error;
-			if (!error)
-				xfs_iflags_set(ip, XFS_IFILESTREAM);
-		}
+		/*
+		 * we can't set up filestreams until after the VFS inode
+		 * is set up properly.
+		 */
+		if (pip && xfs_inode_is_filestream(pip))
+			filestreams = 1;
 		/* fall through */
 	case S_IFDIR:
 		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
@@ -1264,6 +1272,15 @@ xfs_ialloc(
 	/* now that we have an i_mode we can setup inode ops and unlock */
 	xfs_setup_inode(ip);
 
+	/* now we have set up the vfs inode we can associate the filestream */
+	if (filestreams) {
+		error = xfs_filestream_associate(pip, ip);
+		if (error < 0)
+			return -error;
+		if (!error)
+			xfs_iflags_set(ip, XFS_IFILESTREAM);
+	}
+
 	*ipp = ip;
 	return 0;
 }
@@ -2654,6 +2671,10 @@ xfs_idestroy_fork(
  * It must free the inode itself and any buffers allocated for
  * if_extents/if_data and if_broot.  It must also free the lock
  * associated with the inode.
+ *
+ * Note: because we don't initialise everything on reallocation out
+ * of the zone, we must ensure we nullify everything correctly before
+ * freeing the structure.
  */
 void
 xfs_idestroy(
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 813c9b0..9c788ab 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -195,7 +195,6 @@ typedef struct xfs_inode {
 	/* Inode linking and identification information. */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	struct list_head	i_reclaim;	/* reclaim list */
-	struct inode		*i_vnode;	/* vnode backpointer */
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
 
@@ -229,6 +228,10 @@ typedef struct xfs_inode {
 	xfs_fsize_t		i_size;		/* in-memory size */
 	xfs_fsize_t		i_new_size;	/* size when write completes */
 	atomic_t		i_iocount;	/* outstanding I/O count */
+
+	/* VFS inode */
+	struct inode		i_vnode;	/* embedded VFS inode */
+
 	/* Trace buffers per inode. */
 #ifdef XFS_INODE_TRACE
 	struct ktrace		*i_trace;	/* general inode trace */
@@ -256,13 +259,13 @@ typedef struct xfs_inode {
 /* Convert from vfs inode to xfs inode */
 static inline struct xfs_inode *XFS_I(struct inode *inode)
 {
-	return (struct xfs_inode *)inode->i_private;
+	return container_of(inode, struct xfs_inode, i_vnode);
 }
 
 /* convert from xfs inode to vfs inode */
 static inline struct inode *VFS_I(struct xfs_inode *ip)
 {
-	return (struct inode *)ip->i_vnode;
+	return &ip->i_vnode;
 }
 
 /*
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 6bce4ad..8898985 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2800,6 +2800,7 @@ xfs_reclaim(
 	if (!ip->i_update_core && (ip->i_itemp == NULL)) {
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_iflock(ip);
+		xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 		return xfs_finish_reclaim(ip, 1, XFS_IFLUSH_DELWRI_ELSE_SYNC);
 	} else {
 		xfs_mount_t	*mp = ip->i_mount;
@@ -2808,8 +2809,6 @@ xfs_reclaim(
 		XFS_MOUNT_ILOCK(mp);
 		spin_lock(&ip->i_flags_lock);
 		__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-		VFS_I(ip)->i_private = NULL;
-		ip->i_vnode = NULL;
 		spin_unlock(&ip->i_flags_lock);
 		list_add_tail(&ip->i_reclaim, &mp->m_del_inodes);
 		XFS_MOUNT_IUNLOCK(mp);
@@ -2824,10 +2823,6 @@ xfs_finish_reclaim(
 	int		sync_mode)
 {
 	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
-	struct inode	*vp = VFS_I(ip);
-
-	if (vp && VN_BAD(vp))
-		goto reclaim;
 
 	/* The hash lock here protects a thread in xfs_iget_core from
 	 * racing with us on linking the inode back with a vnode.
@@ -2837,7 +2832,7 @@ xfs_finish_reclaim(
 	write_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 	if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
-	    (!__xfs_iflags_test(ip, XFS_IRECLAIMABLE) && vp == NULL)) {
+	    !__xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
 		spin_unlock(&ip->i_flags_lock);
 		write_unlock(&pag->pag_ici_lock);
 		if (locked) {
@@ -2871,15 +2866,13 @@ xfs_finish_reclaim(
 	 * In the case of a forced shutdown we rely on xfs_iflush() to
 	 * wait for the inode to be unpinned before returning an error.
 	 */
-	if (xfs_iflush(ip, sync_mode) == 0) {
+	if (!VN_BAD(VFS_I(ip)) && xfs_iflush(ip, sync_mode) == 0) {
 		/* synchronize with xfs_iflush_done */
 		xfs_iflock(ip);
 		xfs_ifunlock(ip);
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
- reclaim:
 	xfs_ireclaim(ip);
 	return 0;
 }
-- 
1.5.6
