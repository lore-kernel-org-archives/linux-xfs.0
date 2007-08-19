Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Aug 2007 12:39:46 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7JJdcbm016630
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 12:39:42 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7JJdhA5002236
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 21:39:43 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7JJdhTR002234
	for xfs@oss.sgi.com; Sun, 19 Aug 2007 21:39:43 +0200
Date: Sun, 19 Aug 2007 21:39:43 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] m_growlock should be a mutex
Message-ID: <20070819193943.GA2185@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

m_growlock only needs plain binary mutex semantics, so use a struct
mutex instead of a semaphore for it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fsops.c	2007-08-13 18:04:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_fsops.c	2007-08-13 18:04:26.000000000 +0200
@@ -433,10 +433,10 @@ xfs_growfs_data(
 	xfs_growfs_data_t	*in)
 {
 	int error;
-	if (!cpsema(&mp->m_growlock))
+	if (!mutex_trylock(&mp->m_growlock))
 		return XFS_ERROR(EWOULDBLOCK);
 	error = xfs_growfs_data_private(mp, in);
-	vsema(&mp->m_growlock);
+	mutex_unlock(&mp->m_growlock);
 	return error;
 }
 
@@ -446,10 +446,10 @@ xfs_growfs_log(
 	xfs_growfs_log_t	*in)
 {
 	int error;
-	if (!cpsema(&mp->m_growlock))
+	if (!mutex_trylock(&mp->m_growlock))
 		return XFS_ERROR(EWOULDBLOCK);
 	error = xfs_growfs_log_private(mp, in);
-	vsema(&mp->m_growlock);
+	mutex_unlock(&mp->m_growlock);
 	return error;
 }
 
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2007-08-13 18:04:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2007-08-13 18:04:26.000000000 +0200
@@ -139,7 +139,7 @@ xfs_mount_init(void)
 	AIL_LOCKINIT(&mp->m_ail_lock, "xfs_ail");
 	spinlock_init(&mp->m_sb_lock, "xfs_sb");
 	mutex_init(&mp->m_ilock);
-	initnsema(&mp->m_growlock, 1, "xfs_grow");
+	mutex_init(&mp->m_growlock);
 	/*
 	 * Initialize the AIL.
 	 */
@@ -180,7 +180,7 @@ xfs_mount_free(
 	AIL_LOCK_DESTROY(&mp->m_ail_lock);
 	spinlock_destroy(&mp->m_sb_lock);
 	mutex_destroy(&mp->m_ilock);
-	freesema(&mp->m_growlock);
+	mutex_destroy(&mp->m_growlock);
 	if (mp->m_quotainfo)
 		XFS_QM_DONE(mp);
 
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-08-13 18:04:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-08-13 18:04:26.000000000 +0200
@@ -377,7 +377,7 @@ typedef struct xfs_mount {
 	uint			m_in_maxlevels;	/* XFS_IN_MAXLEVELS */
 	struct xfs_perag	*m_perag;	/* per-ag accounting info */
 	struct rw_semaphore	m_peraglock;	/* lock for m_perag (pointer) */
-	sema_t			m_growlock;	/* growfs mutex */
+	struct mutex		m_growlock;	/* growfs mutex */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_dmevmask;	/* DMI events for this FS */
 	__uint64_t		m_flags;	/* global mount flags */
