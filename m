Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:52:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q9qrO2023994
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:52:53 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A30BEA58E0
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:54:04 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id ChgxlqBE1K30KsGm for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:54:04 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6Q9rsNg031684
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 11:53:54 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6Q9rsSH031682
	for xfs@oss.sgi.com; Sat, 26 Jul 2008 11:53:54 +0200
Date: Sat, 26 Jul 2008 11:53:54 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] refactor xfs_mount_free
Message-ID: <20080726095354.GB31253@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_mount_free mostly frees the perag data, which is something that
is duplicated in the mount error path.

Move the XFS_QM_DONE call to the caller and remove the useless
mutex_destroy/spinlock_destroy calls so that we can re-use it for
the mount error path.  Also rename it to xfs_free_perag to reflect what
it does.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-07-26 09:27:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-07-26 09:27:47.000000000 +0200
@@ -128,7 +128,7 @@ static const struct {
  * initialized.
  */
 STATIC void
-xfs_mount_free(
+xfs_free_perag(
 	xfs_mount_t	*mp)
 {
 	if (mp->m_perag) {
@@ -139,13 +139,6 @@ xfs_mount_free(
 				kmem_free(mp->m_perag[agno].pagb_list);
 		kmem_free(mp->m_perag);
 	}
-
-	spinlock_destroy(&mp->m_ail_lock);
-	spinlock_destroy(&mp->m_sb_lock);
-	mutex_destroy(&mp->m_ilock);
-	mutex_destroy(&mp->m_growlock);
-	if (mp->m_quotainfo)
-		XFS_QM_DONE(mp);
 }
 
 /*
@@ -922,7 +915,6 @@ xfs_mountfs(
 	__uint64_t	resblks;
 	__int64_t	update_flags = 0LL;
 	uint		quotamount, quotaflags;
-	int		agno;
 	int		uuid_mounted = 0;
 	int		error = 0;
 
@@ -1216,12 +1208,7 @@ xfs_mountfs(
  error3:
 	xfs_log_unmount_dealloc(mp);
  error2:
-	for (agno = 0; agno < sbp->sb_agcount; agno++)
-		if (mp->m_perag[agno].pagb_list)
-			kmem_free(mp->m_perag[agno].pagb_list);
-	kmem_free(mp->m_perag);
-	mp->m_perag = NULL;
-	/* FALLTHROUGH */
+	xfs_free_perag(mp);
  error1:
 	if (uuid_mounted)
 		uuid_table_remove(&mp->m_sb.sb_uuid);
@@ -1307,7 +1294,9 @@ xfs_unmountfs(
 #if defined(DEBUG)
 	xfs_errortag_clearall(mp, 0);
 #endif
-	xfs_mount_free(mp);
+	xfs_free_perag(mp);
+	if (mp->m_quotainfo)
+		XFS_QM_DONE(mp);
 }
 
 STATIC void
