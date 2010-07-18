Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6IKaRMe163624 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 15:36:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A169815EC746
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:39:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ui78uwYIoR00dqKn for
	<xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:39:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Oaady-0003tx-BM
	for xfs@oss.sgi.com; Sun, 18 Jul 2010 20:39:26 +0000
Message-Id: <20100718203926.229290039@bombadil.infradead.org>
Date: Sun, 18 Jul 2010 16:38:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/6] xfs: remove obsolete osyncisosync mount option
References: <20100718203848.927859114@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-osyncisosync
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

Since Linux 2.6.33 the kernel has support for real O_SYNC, which made
the osyncisosync option a no-op.  Warn the users about this and remove
the mount flag for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-07-18 15:10:45.560494680 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-07-18 15:14:30.563494681 +0200
@@ -90,7 +90,6 @@ mempool_t *xfs_ioend_pool;
 #define MNTOPT_BARRIER	"barrier"	/* use writer barriers for log write and
 					 * unwritten extent conversion */
 #define MNTOPT_NOBARRIER "nobarrier"	/* .. disable */
-#define MNTOPT_OSYNCISOSYNC "osyncisosync" /* o_sync is REALLY o_sync */
 #define MNTOPT_64BITINODE   "inode64"	/* inodes can be allocated anywhere */
 #define MNTOPT_IKEEP	"ikeep"		/* do not free empty inode clusters */
 #define MNTOPT_NOIKEEP	"noikeep"	/* free empty inode clusters */
@@ -274,8 +273,6 @@ xfs_parseargs(
 			mp->m_flags &= ~XFS_MOUNT_GRPID;
 		} else if (!strcmp(this_char, MNTOPT_WSYNC)) {
 			mp->m_flags |= XFS_MOUNT_WSYNC;
-		} else if (!strcmp(this_char, MNTOPT_OSYNCISOSYNC)) {
-			mp->m_flags |= XFS_MOUNT_OSYNCISOSYNC;
 		} else if (!strcmp(this_char, MNTOPT_NORECOVERY)) {
 			mp->m_flags |= XFS_MOUNT_NORECOVERY;
 		} else if (!strcmp(this_char, MNTOPT_NOALIGN)) {
@@ -366,9 +363,11 @@ xfs_parseargs(
 			cmn_err(CE_WARN,
 	"XFS: ihashsize no longer used, option is deprecated.");
 		} else if (!strcmp(this_char, "osyncisdsync")) {
-			/* no-op, this is now the default */
 			cmn_err(CE_WARN,
-	"XFS: osyncisdsync is now the default, option is deprecated.");
+	"XFS: the osyncisdsync option is deprecated as has no effect.");
+		} else if (!strcmp(this_char, "osyncisosync")) {
+			cmn_err(CE_WARN,
+	"XFS: the osyncisosync option is deprecated as has no effect.");
 		} else if (!strcmp(this_char, "irixsgid")) {
 			cmn_err(CE_WARN,
 	"XFS: irixsgid is now a sysctl(2) variable, option is deprecated.");
@@ -500,7 +499,6 @@ xfs_showargs(
 		{ XFS_MOUNT_SWALLOC,		"," MNTOPT_SWALLOC },
 		{ XFS_MOUNT_NOUUID,		"," MNTOPT_NOUUID },
 		{ XFS_MOUNT_NORECOVERY,		"," MNTOPT_NORECOVERY },
-		{ XFS_MOUNT_OSYNCISOSYNC,	"," MNTOPT_OSYNCISOSYNC },
 		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2010-07-18 15:10:45.574494680 +0200
+++ xfs/fs/xfs/xfs_mount.h	2010-07-18 15:11:29.884494680 +0200
@@ -220,8 +220,6 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_GRPID		(1ULL << 9)	/* group-ID assigned from directory */
 #define XFS_MOUNT_NORECOVERY	(1ULL << 10)	/* no recovery - dirty fs */
 #define XFS_MOUNT_DFLT_IOSIZE	(1ULL << 12)	/* set default i/o size */
-#define XFS_MOUNT_OSYNCISOSYNC	(1ULL << 13)	/* o_sync is REALLY o_sync */
-						/* osyncisdsync is now default*/
 #define XFS_MOUNT_32BITINODES	(1ULL << 14)	/* do not create inodes above
 						 * 32 bits in size */
 #define XFS_MOUNT_SMALL_INUMS	(1ULL << 15)	/* users wants 32bit inodes */
Index: xfs/Documentation/filesystems/xfs.txt
===================================================================
--- xfs.orig/Documentation/filesystems/xfs.txt	2010-07-18 15:10:45.586494680 +0200
+++ xfs/Documentation/filesystems/xfs.txt	2010-07-18 15:11:29.893494680 +0200
@@ -131,17 +131,6 @@ When mounting an XFS filesystem, the fol
 	Don't check for double mounted file systems using the file system uuid.
 	This is useful to mount LVM snapshot volumes.
 
-  osyncisosync
-	Make O_SYNC writes implement true O_SYNC.  WITHOUT this option,
-	Linux XFS behaves as if an "osyncisdsync" option is used,
-	which will make writes to files opened with the O_SYNC flag set
-	behave as if the O_DSYNC flag had been used instead.
-	This can result in better performance without compromising
-	data safety.
-	However if this option is not in effect, timestamp updates from
-	O_SYNC writes can be lost if the system crashes.
-	If timestamp updates are critical, use the osyncisosync option.
-
   uquota/usrquota/uqnoenforce/quota
 	User disk quota accounting enabled, and limits (optionally)
 	enforced.  Refer to xfs_quota(8) for further details.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
