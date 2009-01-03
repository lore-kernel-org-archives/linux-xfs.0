Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n03KqSMC002479 for <xfs@oss.sgi.com>; Sat, 3 Jan 2009 14:52:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AF565CA86
	for <xfs@oss.sgi.com>; Sat,  3 Jan 2009 12:52:28 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UKRHZQL1ETVjOjb5 for
	<xfs@oss.sgi.com>; Sat, 03 Jan 2009 12:52:28 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LJDTv-0005Jj-T6
	for xfs@oss.sgi.com; Sat, 03 Jan 2009 20:52:27 +0000
Date: Sat, 3 Jan 2009 15:52:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] fix bad_features2 fixups for the root filesystem
Message-ID: <20090103205227.GA20346@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Currently the bad_features2 fixup and the alignment updates in the superblock
are skipped if we mount a filesystem read-only.  But for the root filesystem
the typical case is to mount read-only first and only later remount writeable
so we'll never perform this update at all.  It's not a big problem but means
the logs of people needing the fixup get spammed at every boot because they
never happen on disk.

Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2009-01-02 18:39:11.579671462 +0100
+++ xfs/fs/xfs/xfs_mount.c	2009-01-03 21:42:36.741548942 +0100
@@ -45,7 +45,6 @@
 #include "xfs_fsops.h"
 #include "xfs_utils.h"
 
-STATIC int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
 STATIC int	xfs_uuid_mount(xfs_mount_t *);
 STATIC void	xfs_unmountfs_wait(xfs_mount_t *);
 
@@ -682,7 +681,7 @@ xfs_initialize_perag_data(xfs_mount_t *m
  * Update alignment values based on mount options and sb values
  */
 STATIC int
-xfs_update_alignment(xfs_mount_t *mp, __uint64_t *update_flags)
+xfs_update_alignment(xfs_mount_t *mp)
 {
 	xfs_sb_t	*sbp = &(mp->m_sb);
 
@@ -736,11 +735,11 @@ xfs_update_alignment(xfs_mount_t *mp, __
 		if (xfs_sb_version_hasdalign(sbp)) {
 			if (sbp->sb_unit != mp->m_dalign) {
 				sbp->sb_unit = mp->m_dalign;
-				*update_flags |= XFS_SB_UNIT;
+				mp->m_update_flags |= XFS_SB_UNIT;
 			}
 			if (sbp->sb_width != mp->m_swidth) {
 				sbp->sb_width = mp->m_swidth;
-				*update_flags |= XFS_SB_WIDTH;
+				mp->m_update_flags |= XFS_SB_WIDTH;
 			}
 		}
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
@@ -905,7 +904,6 @@ xfs_mountfs(
 	xfs_sb_t	*sbp = &(mp->m_sb);
 	xfs_inode_t	*rip;
 	__uint64_t	resblks;
-	__int64_t	update_flags = 0LL;
 	uint		quotamount, quotaflags;
 	int		uuid_mounted = 0;
 	int		error = 0;
@@ -933,7 +931,7 @@ xfs_mountfs(
 			"XFS: correcting sb_features alignment problem");
 		sbp->sb_features2 |= sbp->sb_bad_features2;
 		sbp->sb_bad_features2 = sbp->sb_features2;
-		update_flags |= XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;
+		mp->m_update_flags |= XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;
 
 		/*
 		 * Re-check for ATTR2 in case it was found in bad_features2
@@ -947,11 +945,11 @@ xfs_mountfs(
 	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
 	   (mp->m_flags & XFS_MOUNT_NOATTR2)) {
 		xfs_sb_version_removeattr2(&mp->m_sb);
-		update_flags |= XFS_SB_FEATURES2;
+		mp->m_update_flags |= XFS_SB_FEATURES2;
 
 		/* update sb_versionnum for the clearing of the morebits */
 		if (!sbp->sb_features2)
-			update_flags |= XFS_SB_VERSIONNUM;
+			mp->m_update_flags |= XFS_SB_VERSIONNUM;
 	}
 
 	/*
@@ -960,7 +958,7 @@ xfs_mountfs(
 	 * allocator alignment is within an ag, therefore ag has
 	 * to be aligned at stripe boundary.
 	 */
-	error = xfs_update_alignment(mp, &update_flags);
+	error = xfs_update_alignment(mp);
 	if (error)
 		goto error1;
 
@@ -1137,10 +1135,12 @@ xfs_mountfs(
 	}
 
 	/*
-	 * If fs is not mounted readonly, then update the superblock changes.
+	 * If this is a read-only mount defer the superblock updates until
+	 * the next remount into writeable mode.  Otherwise we would never
+	 * perform the update e.g. for the root filesystem.
 	 */
-	if (update_flags && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		error = xfs_mount_log_sb(mp, update_flags);
+	if (mp->m_update_flags && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		error = xfs_mount_log_sb(mp, mp->m_update_flags);
 		if (error) {
 			cmn_err(CE_WARN, "XFS: failed to write sb changes");
 			goto error4;
@@ -1820,7 +1820,7 @@ xfs_uuid_mount(
  * be altered by the mount options, as well as any potential sb_features2
  * fixup. Only the first superblock is updated.
  */
-STATIC int
+int
 xfs_mount_log_sb(
 	xfs_mount_t	*mp,
 	__int64_t	fields)
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2009-01-01 11:53:17.541576193 +0100
+++ xfs/fs/xfs/xfs_mount.h	2009-01-03 21:38:22.555577508 +0100
@@ -327,6 +327,8 @@ typedef struct xfs_mount {
 	spinlock_t		m_sync_lock;	/* work item list lock */
 	int			m_sync_seq;	/* sync thread generation no. */
 	wait_queue_head_t	m_wait_single_sync_task;
+	__int64_t		m_update_flags;	/* sb flags we need to update
+						   on the next remount,rw */
 } xfs_mount_t;
 
 /*
@@ -514,6 +516,7 @@ extern int	xfs_mod_incore_sb_unlocked(xf
 			int64_t, int);
 extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
 			uint, int);
+extern int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-01-01 11:53:17.294547000 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-01-03 21:47:58.367578173 +0100
@@ -1197,6 +1197,7 @@ xfs_fs_remount(
 	struct xfs_mount	*mp = XFS_M(sb);
 	substring_t		args[MAX_OPT_ARGS];
 	char			*p;
+	int			error;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
@@ -1247,11 +1248,25 @@ xfs_fs_remount(
 		}
 	}
 
-	/* rw/ro -> rw */
+	/* ro -> rw */
 	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
 		mp->m_flags &= ~XFS_MOUNT_RDONLY;
 		if (mp->m_flags & XFS_MOUNT_BARRIER)
 			xfs_mountfs_check_barriers(mp);
+
+		/*
+		 * If this is the first remount to writeable state we
+		 * might have some superblock changes to update.
+		 */
+		if (mp->m_update_flags) {
+			error = xfs_mount_log_sb(mp, mp->m_update_flags);
+			if (error) {
+				cmn_err(CE_WARN,
+					"XFS: failed to write sb changes");
+				return error;
+			}
+			mp->m_update_flags = 0;
+		}
 	}
 
 	/* rw -> ro */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
