Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 15:00:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41M0DFp001235
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 15:00:21 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7051012ACED5
	for <xfs@oss.sgi.com>; Thu,  1 May 2008 15:00:55 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 71ht3YnBFUUz08CE for <xfs@oss.sgi.com>; Thu, 01 May 2008 15:00:55 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m41M0mF3002349
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 00:00:49 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m41M0mV3002347
	for xfs@oss.sgi.com; Fri, 2 May 2008 00:00:48 +0200
Date: Fri, 2 May 2008 00:00:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/10] merge xfs_unmount into xfs_fs_put_super / xfs_fs_fill_super
Message-ID: <20080501220048.GA2315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_unmount is small and already pretty Linux specific, so merge it into
the callers.  The real unmount path is simplified a little by doing a
WARN_ON on the xfs_unmount_flush retval directly instead of propagating
the error back to the caller, and the mout failure case in simplified
significantly by removing the forced shudown case and all the dmapi
events that shouldn't be sent because the dmapi mount event hasn't been
sent by that time either.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-04-25 20:48:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-04-25 20:50:16.000000000 +0200
@@ -1087,14 +1087,61 @@ xfs_fs_put_super(
 	struct super_block	*sb)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
+	struct xfs_inode	*rip = mp->m_rootip;
+	int			unmount_event_flags = 0;
 	int			error;
 
 	kthread_stop(mp->m_sync_task);
 
 	xfs_sync(mp, SYNC_ATTR | SYNC_DELWRI);
-	error = xfs_unmount(mp, 0, NULL);
-	if (error)
-		printk("XFS: unmount got error=%d\n", error);
+
+#ifdef HAVE_DMAPI
+	if (mp->m_flags & XFS_MOUNT_DMAPI) {
+		unmount_event_flags =
+			(mp->m_dmevmask & (1 << DM_EVENT_UNMOUNT)) ?
+				0 : DM_FLAGS_UNWANTED;
+		/*
+		 * Ignore error from dmapi here, first unmount is not allowed
+		 * to fail anyway, and second we wouldn't want to fail a
+		 * unmount because of dmapi.
+		 */
+		XFS_SEND_PREUNMOUNT(mp, rip, DM_RIGHT_NULL, rip, DM_RIGHT_NULL,
+				NULL, NULL, 0, 0, unmount_event_flags);
+	}
+#endif
+
+	/*
+	 * Blow away any referenced inode in the filestreams cache.
+	 * This can and will cause log traffic as inodes go inactive
+	 * here.
+	 */
+	xfs_filestream_unmount(mp);
+
+	XFS_bflush(mp->m_ddev_targp);
+	error = xfs_unmount_flush(mp, 0);
+	WARN_ON(error);
+
+	IRELE(rip);
+
+	/*
+	 * If we're forcing a shutdown, typically because of a media error,
+	 * we want to make sure we invalidate dirty pages that belong to
+	 * referenced vnodes as well.
+	 */
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		error = xfs_sync(mp, SYNC_WAIT | SYNC_CLOSE);
+		ASSERT(error != EFSCORRUPTED);
+	}
+
+	if (mp->m_flags & XFS_MOUNT_DMAPI) {
+		XFS_SEND_UNMOUNT(mp, rip, DM_RIGHT_NULL, 0, 0,
+				unmount_event_flags);
+	}
+
+	xfs_unmountfs(mp, NULL);
+	xfs_qmops_put(mp);
+	xfs_dmops_put(mp);
+	kmem_free(mp, sizeof(xfs_mount_t));
 }
 
 STATIC void
@@ -1400,7 +1447,23 @@ fail_vnrele:
 	}
 
 fail_unmount:
-	xfs_unmount(mp, 0, NULL);
+	/*
+	 * Blow away any referenced inode in the filestreams cache.
+	 * This can and will cause log traffic as inodes go inactive
+	 * here.
+	 */
+	xfs_filestream_unmount(mp);
+
+	XFS_bflush(mp->m_ddev_targp);
+	error = xfs_unmount_flush(mp, 0);
+	WARN_ON(error);
+
+	IRELE(mp->m_rootip);
+
+	xfs_unmountfs(mp, NULL);
+	xfs_qmops_put(mp);
+	xfs_dmops_put(mp);
+	kmem_free(mp, sizeof(xfs_mount_t));
 
 fail_vfsop:
 	kmem_free(args, sizeof(*args));
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2008-04-25 20:48:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2008-04-25 20:48:32.000000000 +0200
@@ -550,93 +550,6 @@ error0:
 	return error;
 }
 
-int
-xfs_unmount(
-	xfs_mount_t	*mp,
-	int		flags,
-	cred_t		*credp)
-{
-	xfs_inode_t	*rip;
-	bhv_vnode_t	*rvp;
-	int		unmount_event_wanted = 0;
-	int		unmount_event_flags = 0;
-	int		xfs_unmountfs_needed = 0;
-	int		error;
-
-	rip = mp->m_rootip;
-	rvp = XFS_ITOV(rip);
-
-#ifdef HAVE_DMAPI
-	if (mp->m_flags & XFS_MOUNT_DMAPI) {
-		error = XFS_SEND_PREUNMOUNT(mp,
-				rip, DM_RIGHT_NULL, rip, DM_RIGHT_NULL,
-				NULL, NULL, 0, 0,
-				(mp->m_dmevmask & (1<<DM_EVENT_PREUNMOUNT))?
-					0:DM_FLAGS_UNWANTED);
-			if (error)
-				return XFS_ERROR(error);
-		unmount_event_wanted = 1;
-		unmount_event_flags = (mp->m_dmevmask & (1<<DM_EVENT_UNMOUNT))?
-					0 : DM_FLAGS_UNWANTED;
-	}
-#endif
-
-	/*
-	 * Blow away any referenced inode in the filestreams cache.
-	 * This can and will cause log traffic as inodes go inactive
-	 * here.
-	 */
-	xfs_filestream_unmount(mp);
-
-	XFS_bflush(mp->m_ddev_targp);
-	error = xfs_unmount_flush(mp, 0);
-	if (error)
-		goto out;
-
-	ASSERT(vn_count(rvp) == 1);
-
-	/*
-	 * Drop the reference count
-	 */
-	IRELE(rip);
-
-	/*
-	 * If we're forcing a shutdown, typically because of a media error,
-	 * we want to make sure we invalidate dirty pages that belong to
-	 * referenced vnodes as well.
-	 */
-	if (XFS_FORCED_SHUTDOWN(mp)) {
-		error = xfs_sync(mp, SYNC_WAIT | SYNC_CLOSE);
-		ASSERT(error != EFSCORRUPTED);
-	}
-	xfs_unmountfs_needed = 1;
-
-out:
-	/*	Send DMAPI event, if required.
-	 *	Then do xfs_unmountfs() if needed.
-	 *	Then return error (or zero).
-	 */
-	if (unmount_event_wanted) {
-		/* Note: mp structure must still exist for
-		 * XFS_SEND_UNMOUNT() call.
-		 */
-		XFS_SEND_UNMOUNT(mp, error == 0 ? rip : NULL,
-			DM_RIGHT_NULL, 0, error, unmount_event_flags);
-	}
-	if (xfs_unmountfs_needed) {
-		/*
-		 * Call common unmount function to flush to disk
-		 * and free the super block buffer & mount structures.
-		 */
-		xfs_unmountfs(mp, credp);
-		xfs_qmops_put(mp);
-		xfs_dmops_put(mp);
-		kmem_free(mp, sizeof(xfs_mount_t));
-	}
-
-	return XFS_ERROR(error);
-}
-
 STATIC void
 xfs_quiesce_fs(
 	xfs_mount_t		*mp)
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2008-04-25 20:48:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2008-04-25 20:48:32.000000000 +0200
@@ -10,7 +10,6 @@ struct xfs_mount_args;
 
 int xfs_mount(struct xfs_mount *mp, struct xfs_mount_args *args,
 		struct cred *credp);
-int xfs_unmount(struct xfs_mount *mp, int flags, struct cred *credp);
 int xfs_sync(struct xfs_mount *mp, int flags);
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
