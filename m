Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 15:01:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41M0hmc001287
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 15:00:46 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B08E812ACEE3
	for <xfs@oss.sgi.com>; Thu,  1 May 2008 15:01:26 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id jOPpCDJCEtqdUoPJ for <xfs@oss.sgi.com>; Thu, 01 May 2008 15:01:26 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m41M1JF3002449
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 00:01:20 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m41M1J7x002447
	for xfs@oss.sgi.com; Fri, 2 May 2008 00:01:19 +0200
Date: Fri, 2 May 2008 00:01:19 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/10] kill xfs_mount_init
Message-ID: <20080501220119.GG2315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_mount_init is inlined into xfs_fs_fill_super and allocation switched
to kzalloc.  Plug a leak of the mount structure for most early mount
failures.  Move xfs_icsb_init_counters to as late as possible in the
mount path and make sure to undo it so that no stale hotplug cpu
notifiers are left around on mount failures.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 20:15:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 20:28:36.000000000 +0200
@@ -1273,10 +1273,11 @@ xfs_fs_put_super(
 	}
 
 	xfs_unmountfs(mp);
+	xfs_icsb_destroy_counters(mp);
 	xfs_close_devices(mp);
 	xfs_qmops_put(mp);
 	xfs_dmops_put(mp);
-	kmem_free(mp, sizeof(xfs_mount_t));
+	kfree(mp);
 }
 
 STATIC void
@@ -1733,14 +1734,20 @@ xfs_fs_fill_super(
 	struct inode		*root;
 	struct xfs_mount	*mp = NULL;
 	struct xfs_mount_args	*args;
-	int			flags = 0, error;
+	int			flags = 0, error = ENOMEM;
 
 	args = xfs_args_allocate(sb, silent);
 	if (!args)
 		return -ENOMEM;
 
-	mp = xfs_mount_init();
+	mp = kzalloc(sizeof(xfs_mount_t), GFP_KERNEL);
+	if (!mp)
+		goto out_free_args;
 
+	spin_lock_init(&mp->m_sb_lock);
+	mutex_init(&mp->m_ilock);
+	mutex_init(&mp->m_growlock);
+	atomic_set(&mp->m_active_trans, 0);
 	INIT_LIST_HEAD(&mp->m_sync_list);
 	spin_lock_init(&mp->m_sync_lock);
 	init_waitqueue_head(&mp->m_wait_single_sync_task);
@@ -1753,7 +1760,7 @@ xfs_fs_fill_super(
 
 	error = xfs_parseargs(mp, (char *)data, args, 0);
 	if (error)
-		goto fail_vfsop;
+		goto out_free_mp;
 
 	sb_min_blocksize(sb, BBSIZE);
 	sb->s_xattr = xfs_xattr_handlers;
@@ -1763,7 +1770,7 @@ xfs_fs_fill_super(
 
 	error = xfs_dmops_get(mp, args);
 	if (error)
-		goto fail_vfsop;
+		goto out_free_mp;
 	error = xfs_qmops_get(mp, args);
 	if (error)
 		goto out_put_dmops;
@@ -1775,6 +1782,9 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_put_qmops;
 
+	if (xfs_icsb_init_counters(mp))
+		mp->m_flags |= XFS_MOUNT_NO_PERCPU_SB;
+
 	/*
 	 * Setup flags based on mount(2) options and then the superblock
 	 */
@@ -1850,12 +1860,18 @@ xfs_fs_fill_super(
 		xfs_binval(mp->m_logdev_targp);
 	if (mp->m_rtdev_targp)
 		xfs_binval(mp->m_rtdev_targp);
+ out_destroy_counters:
+	xfs_icsb_destroy_counters(mp);
 	xfs_close_devices(mp);
  out_put_qmops:
 	xfs_qmops_put(mp);
  out_put_dmops:
 	xfs_dmops_put(mp);
-	goto fail_vfsop;
+ out_free_mp:
+	kfree(mp);
+ out_free_args:
+	kfree(args);
+	return -error;
 
  fail_vnrele:
 	if (sb->s_root) {
@@ -1880,14 +1896,7 @@ xfs_fs_fill_super(
 	IRELE(mp->m_rootip);
 
 	xfs_unmountfs(mp);
-	xfs_close_devices(mp);
-	xfs_qmops_put(mp);
-	xfs_dmops_put(mp);
-	kmem_free(mp, sizeof(xfs_mount_t));
-
- fail_vfsop:
-	kfree(args);
-	return -error;
+	goto out_destroy_counters;
 }
 
 STATIC int
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-05-01 20:14:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-05-01 20:23:30.000000000 +0200
@@ -125,33 +125,11 @@ static const struct {
 };
 
 /*
- * Return a pointer to an initialized xfs_mount structure.
- */
-xfs_mount_t *
-xfs_mount_init(void)
-{
-	xfs_mount_t *mp;
-
-	mp = kmem_zalloc(sizeof(xfs_mount_t), KM_SLEEP);
-
-	if (xfs_icsb_init_counters(mp)) {
-		mp->m_flags |= XFS_MOUNT_NO_PERCPU_SB;
-	}
-
-	spin_lock_init(&mp->m_sb_lock);
-	mutex_init(&mp->m_ilock);
-	mutex_init(&mp->m_growlock);
-	atomic_set(&mp->m_active_trans, 0);
-
-	return mp;
-}
-
-/*
  * Free up the resources associated with a mount structure.  Assume that
  * the structure was initially zeroed, so we can tell which fields got
  * initialized.
  */
-void
+STATIC void
 xfs_mount_free(
 	xfs_mount_t	*mp)
 {
@@ -180,8 +158,6 @@ xfs_mount_free(
 		kmem_free(mp->m_rtname, strlen(mp->m_rtname) + 1);
 	if (mp->m_logname != NULL)
 		kmem_free(mp->m_logname, strlen(mp->m_logname) + 1);
-
-	xfs_icsb_destroy_counters(mp);
 }
 
 /*
@@ -2097,7 +2073,7 @@ xfs_icsb_reinit_counters(
 	xfs_icsb_unlock(mp);
 }
 
-STATIC void
+void
 xfs_icsb_destroy_counters(
 	xfs_mount_t	*mp)
 {
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-05-01 20:14:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-05-01 20:23:01.000000000 +0200
@@ -210,6 +210,7 @@ typedef struct xfs_icsb_cnts {
 
 extern int	xfs_icsb_init_counters(struct xfs_mount *);
 extern void	xfs_icsb_reinit_counters(struct xfs_mount *);
+extern void	xfs_icsb_destroy_counters(struct xfs_mount *);
 extern void	xfs_icsb_sync_counters(struct xfs_mount *, int);
 extern void	xfs_icsb_sync_counters_locked(struct xfs_mount *, int);
 
@@ -511,10 +512,8 @@ typedef struct xfs_mod_sb {
 #define	XFS_MOUNT_ILOCK(mp)	mutex_lock(&((mp)->m_ilock))
 #define	XFS_MOUNT_IUNLOCK(mp)	mutex_unlock(&((mp)->m_ilock))
 
-extern xfs_mount_t *xfs_mount_init(void);
 extern void	xfs_mod_sb(xfs_trans_t *, __int64_t);
 extern int	xfs_log_sbcount(xfs_mount_t *, uint);
-extern void	xfs_mount_free(xfs_mount_t *mp);
 extern int	xfs_mountfs(xfs_mount_t *mp, int);
 extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-05-01 20:17:16.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-05-01 20:22:51.000000000 +0200
@@ -256,8 +256,6 @@ EXPORT_SYMBOL(xfs_log_force_umount);
 EXPORT_SYMBOL(xfs_log_unmount_dealloc);
 EXPORT_SYMBOL(xfs_log_unmount_write);
 EXPORT_SYMBOL(xfs_mod_sb);
-EXPORT_SYMBOL(xfs_mount_free);
-EXPORT_SYMBOL(xfs_mount_init);
 EXPORT_SYMBOL(xfs_mount_reset_sbqflags);
 EXPORT_SYMBOL(xfs_mountfs);
 EXPORT_SYMBOL(xfs_qm_dqcheck);
