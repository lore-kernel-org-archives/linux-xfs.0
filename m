Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 19:51:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5Q2pqYO025668
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 19:51:53 -0700
Message-ID: <4863056D.3080209@sgi.com>
Date: Thu, 26 Jun 2008 12:56:45 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Don't assert if trying to mount with blocksize > pagesize
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

If we don't do the blocksize/PAGESIZE check before
calling xfs_sb_validate_fsb_count() we can assert
if we try to mount with a blocksize > pagesize.
The assert is valid so leave it and just move the
blocksize/pagesize check earlier.

--- fs/xfs/xfs_mount.c_1.436	2008-06-26 12:44:06.000000000 +1000
+++ fs/xfs/xfs_mount.c	2008-06-26 12:48:15.000000000 +1000
@@ -258,6 +258,19 @@ xfs_mount_validate_sb(
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
+	/*
+	 * Until this is fixed only page-sized or smaller data blocks work.
+	 */
+	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
+		xfs_fs_mount_cmn_err(flags,
+			"file system with blocksize %d bytes",
+			sbp->sb_blocksize);
+		xfs_fs_mount_cmn_err(flags,
+			"only pagesize (%ld) or less will currently work.",
+			PAGE_SIZE);
+		return XFS_ERROR(ENOSYS);
+	}
+
 	if (xfs_sb_validate_fsb_count(sbp, sbp->sb_dblocks) ||
 	    xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
 		xfs_fs_mount_cmn_err(flags,
@@ -279,19 +292,6 @@ xfs_mount_validate_sb(
 		return XFS_ERROR(ENOSYS);
 	}
 
-	/*
-	 * Until this is fixed only page-sized or smaller data blocks work.
-	 */
-	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
-		xfs_fs_mount_cmn_err(flags,
-			"file system with blocksize %d bytes",
-			sbp->sb_blocksize);
-		xfs_fs_mount_cmn_err(flags,
-			"only pagesize (%ld) or less will currently work.",
-			PAGE_SIZE);
-		return XFS_ERROR(ENOSYS);
-	}
-
 	return 0;
 }
