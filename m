Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2G6qd8031616 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:06:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3506B164F1B5
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:06:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HQ2E34FPn3P5VFXO for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:06:52 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xlz-0007UY-La
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:51 +0000
Message-Id: <20081202160651.583993000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 14/22] remove leftovers of shared read-only support
Content-Disposition: inline; filename=xfs-kill-m_mk_sharedro
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We never supported shared read-only filesystems, so remove the dead
code left over from IRIX for it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/xfs_mount.c
===================================================================
--- xfs-master.orig/fs/xfs/xfs_mount.c	2008-12-01 19:26:02.000000000 +0100
+++ xfs-master/fs/xfs/xfs_mount.c	2008-12-01 19:28:02.000000000 +0100
@@ -1352,24 +1352,6 @@ xfs_log_sbcount(
 	return error;
 }
 
-STATIC void
-xfs_mark_shared_ro(
-	xfs_mount_t	*mp,
-	xfs_buf_t	*bp)
-{
-	xfs_dsb_t	*sb = XFS_BUF_TO_SBP(bp);
-	__uint16_t	version;
-
-	if (!(sb->sb_flags & XFS_SBF_READONLY))
-		sb->sb_flags |= XFS_SBF_READONLY;
-
-	version = be16_to_cpu(sb->sb_versionnum);
-	if ((version & XFS_SB_VERSION_NUMBITS) != XFS_SB_VERSION_4 ||
-	    !(version & XFS_SB_VERSION_SHAREDBIT))
-		version |= XFS_SB_VERSION_SHAREDBIT;
-	sb->sb_versionnum = cpu_to_be16(version);
-}
-
 int
 xfs_unmountfs_writesb(xfs_mount_t *mp)
 {
@@ -1385,12 +1367,6 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 
 		sbp = xfs_getsb(mp, 0);
 
-		/*
-		 * mark shared-readonly if desired
-		 */
-		if (mp->m_mk_sharedro)
-			xfs_mark_shared_ro(mp, sbp);
-
 		XFS_BUF_UNDONE(sbp);
 		XFS_BUF_UNREAD(sbp);
 		XFS_BUF_UNDELAYWRITE(sbp);
@@ -1402,8 +1378,6 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 		if (error)
 			xfs_ioerror_alert("xfs_unmountfs_writesb",
 					  mp, sbp, XFS_BUF_ADDR(sbp));
-		if (error && mp->m_mk_sharedro)
-			xfs_fs_cmn_err(CE_ALERT, mp, "Superblock write error detected while unmounting.  Filesystem may not be marked shared readonly");
 		xfs_buf_relse(sbp);
 	}
 	return error;
Index: xfs-master/fs/xfs/xfs_mount.h
===================================================================
--- xfs-master.orig/fs/xfs/xfs_mount.h	2008-12-01 19:27:59.000000000 +0100
+++ xfs-master/fs/xfs/xfs_mount.h	2008-12-01 19:28:02.000000000 +0100
@@ -301,7 +301,6 @@ typedef struct xfs_mount {
 	int			m_sinoalign;	/* stripe unit inode alignment */
 	int			m_attr_magicpct;/* 37% of the blocksize */
 	int			m_dir_magicpct;	/* 37% of the dir blocksize */
-	__uint8_t		m_mk_sharedro;	/* mark shared ro on unmount */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
Index: xfs-master/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_super.c	2008-12-01 19:27:52.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_super.c	2008-12-01 19:28:02.000000000 +0100
@@ -1388,35 +1388,6 @@ xfs_finish_flags(
 		return XFS_ERROR(EROFS);
 	}
 
-#if 0 /* shared mounts were never supported on Linux */
-	/*
-	 * check for shared mount.
-	 */
-	if (ap->flags & XFSMNT_SHARED) {
-		if (!xfs_sb_version_hasshared(&mp->m_sb))
-			return XFS_ERROR(EINVAL);
-
-		/*
-		 * For IRIX 6.5, shared mounts must have the shared
-		 * version bit set, have the persistent readonly
-		 * field set, must be version 0 and can only be mounted
-		 * read-only.
-		 */
-		if (!ronly || !(mp->m_sb.sb_flags & XFS_SBF_READONLY) ||
-		     (mp->m_sb.sb_shared_vn != 0))
-			return XFS_ERROR(EINVAL);
-
-		mp->m_flags |= XFS_MOUNT_SHARED;
-
-		/*
-		 * Shared XFS V0 can't deal with DMI.  Return EINVAL.
-		 */
-		if (mp->m_sb.sb_shared_vn == 0 &&
-		    (mp->m_flags & XFS_MOUNT_DMAPI))
-			return XFS_ERROR(EINVAL);
-	}
-#endif
-
 	return 0;
 }
 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
