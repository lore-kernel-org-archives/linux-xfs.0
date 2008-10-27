Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:49:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDmqBj027460
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:48:53 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31CCB54B908
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:48:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id hTJYiOQcgcBgh6B5 for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:48:51 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSSh-0001gR-I2
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:48:51 +0000
Date: Mon, 27 Oct 2008 09:48:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/10] remove leftovers of shared read-only support
Message-ID: <20081027134851.GE6440@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-kill-m_mk_sharedro
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

We never supported shared read-only filesystems, so remove the dead
code left over from IRIX for it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-10-25 13:00:27.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-10-25 13:18:54.000000000 +0200
@@ -1353,24 +1353,6 @@ xfs_log_sbcount(
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
@@ -1386,12 +1368,6 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 
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
@@ -1403,8 +1379,6 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 		if (error)
 			xfs_ioerror_alert("xfs_unmountfs_writesb",
 					  mp, sbp, XFS_BUF_ADDR(sbp));
-		if (error && mp->m_mk_sharedro)
-			xfs_fs_cmn_err(CE_ALERT, mp, "Superblock write error detected while unmounting.  Filesystem may not be marked shared readonly");
 		xfs_buf_relse(sbp);
 	}
 	return error;
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-10-25 13:18:51.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-10-25 13:18:54.000000000 +0200
@@ -302,7 +302,6 @@ typedef struct xfs_mount {
 	int			m_sinoalign;	/* stripe unit inode alignment */
 	int			m_attr_magicpct;/* 37% of the blocksize */
 	int			m_dir_magicpct;	/* 37% of the dir blocksize */
-	__uint8_t		m_mk_sharedro;	/* mark shared ro on unmount */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
 	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-10-25 13:18:51.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-10-25 13:18:54.000000000 +0200
@@ -6523,8 +6523,7 @@ xfsidbg_xmount(xfs_mount_t *mp)
 	kdb_printf("dalign %d swidth %d sinoalign %d attr_magicpct %d dir_magicpct %d\n",
 		mp->m_dalign, mp->m_swidth, mp->m_sinoalign,
 		mp->m_attr_magicpct, mp->m_dir_magicpct);
-	kdb_printf("mk_sharedro %d sectbb_log %d\n",
-		mp->m_mk_sharedro, mp->m_sectbb_log);
+	kdb_printf("sectbb_log %d\n", mp->m_sectbb_log);
 	kdb_printf("dirblkfsbs %d\n", mp->m_dirblkfsbs);
 	kdb_printf("dirblksize %d dirdatablk 0x%Lx dirleafblk 0x%Lx dirfreeblk 0x%Lx\n",
 		mp->m_dirblksize,
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-10-25 13:20:10.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-10-25 13:20:16.000000000 +0200
@@ -1384,35 +1384,6 @@ xfs_finish_flags(
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
