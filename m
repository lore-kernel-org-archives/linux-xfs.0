Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 15:01:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41M0uE0001322
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 15:01:02 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20C311176EE
	for <xfs@oss.sgi.com>; Thu,  1 May 2008 15:01:17 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id BVYeS24BrLnAwJ7f for <xfs@oss.sgi.com>; Thu, 01 May 2008 15:01:17 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m41M1AF3002420
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 00:01:10 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m41M1Aht002418
	for xfs@oss.sgi.com; Fri, 2 May 2008 00:01:10 +0200
Date: Fri, 2 May 2008 00:01:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/10] add xfs_setup_devices helper
Message-ID: <20080501220110.GE2315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Split setting the block and sector size out of xfs_fs_fill_super into a
small helper to make xfs_fs_fill_super more readable.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 19:58:12.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 20:05:49.000000000 +0200
@@ -860,7 +860,41 @@ xfs_open_devices(
 	return error;
 }
 
+/*
+ * Setup xfs_mount buffer target pointers based on superblock
+ */
+STATIC int
+xfs_setup_devices(
+	struct xfs_mount	*mp)
+{
+	int			error;
 
+	error = xfs_setsize_buftarg(mp->m_ddev_targp, mp->m_sb.sb_blocksize,
+				    mp->m_sb.sb_sectsize);
+	if (error)
+		return error;
+
+	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
+		unsigned int	log_sector_size = BBSIZE;
+
+		if (xfs_sb_version_hassector(&mp->m_sb))
+			log_sector_size = mp->m_sb.sb_logsectsize;
+		error = xfs_setsize_buftarg(mp->m_logdev_targp,
+					    mp->m_sb.sb_blocksize,
+					    log_sector_size);
+		if (error)
+			return error;
+	}
+	if (mp->m_rtdev_targp) {
+		error = xfs_setsize_buftarg(mp->m_rtdev_targp,
+					    mp->m_sb.sb_blocksize,
+					    mp->m_sb.sb_sectsize);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
 
 /*
  * XFS AIL push thread support
@@ -1743,31 +1777,9 @@ xfs_fs_fill_super(
 	if (error)
 		goto error2;
 
-	/*
-	 * Setup xfs_mount buffer target pointers based on superblock
-	 */
-	error = xfs_setsize_buftarg(mp->m_ddev_targp, mp->m_sb.sb_blocksize,
-				    mp->m_sb.sb_sectsize);
+	error = xfs_setup_devices(mp);
 	if (error)
 		goto error2;
-	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
-		unsigned int	log_sector_size = BBSIZE;
-
-		if (xfs_sb_version_hassector(&mp->m_sb))
-			log_sector_size = mp->m_sb.sb_logsectsize;
-		error = xfs_setsize_buftarg(mp->m_logdev_targp,
-					    mp->m_sb.sb_blocksize,
-					    log_sector_size);
-		if (error)
-			goto error2;
-	}
-	if (mp->m_rtdev_targp) {
-		error = xfs_setsize_buftarg(mp->m_rtdev_targp,
-					    mp->m_sb.sb_blocksize,
-					    mp->m_sb.sb_sectsize);
-		if (error)
-			goto error2;
-	}
 
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_mountfs_check_barriers(mp);
