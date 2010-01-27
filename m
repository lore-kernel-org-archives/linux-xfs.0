Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0RNDpdZ238967 for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 17:13:51 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BEA24F6460D
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 15:14:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4PKSB0vf1hkZcses for
	<xfs@oss.sgi.com>; Wed, 27 Jan 2010 15:14:56 -0800 (PST)
Received: from int-mx08.intmail.prod.int.phx2.redhat.com
	(int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0RNEuR5024326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 18:14:56 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0RNEsMG015084
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 18:14:55 -0500
Message-ID: <4B60C8EE.5080700@sandeen.net>
Date: Wed, 27 Jan 2010 17:14:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH, RFC] more reserved blocks fixups
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: xfs mailing list <xfs@oss.sgi.com>

This mangles the reserved blocks counts a little more.

1) add a helper function for the default reserved count
2) add helper functions to save/restore counts on ro/rw
3) save/restore reserved blocks on freeze/thaw
4) disallow changing reserved count while readonly

for 2) - maybe better names (save_and_clear?)
for 4) - maybe allow, but change the _ro field instead?

(TBH not tested yet but wondered if this seems sane)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 5bb523d..5f06150 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1430,6 +1430,9 @@ xfs_file_ioctl(
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
+			return -XFS_ERROR(EROFS);
+
 		if (copy_from_user(&inout, arg, sizeof(inout)))
 			return -XFS_ERROR(EFAULT);
 
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 7b15ed0..5f50372 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1237,6 +1237,29 @@ xfs_fs_statfs(
 	return 0;
 }
 
+STATIC void
+xfs_save_resvblks(struct xfs_mount *mp)
+{
+	__uint64_t resblks = 0;
+
+	mp->m_resblks_ro = mp->m_resblks;
+	xfs_reserve_blocks(mp, &resblks, NULL);
+}
+
+STATIC void
+xfs_restore_resvblks(struct xfs_mount *mp)
+{
+	__uint64_t resblks;
+
+	if (mp->m_resblks_ro) {
+		resblks = mp->m_resblks_ro;
+		mp->m_resblks_ro = 0;
+	} else
+		resblks = xfs_default_resblks(mp);
+
+	xfs_reserve_blocks(mp, &resblks, NULL);
+}
+
 STATIC int
 xfs_fs_remount(
 	struct super_block	*sb,
@@ -1299,8 +1322,6 @@ xfs_fs_remount(
 
 	/* ro -> rw */
 	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
-		__uint64_t resblks;
-
 		mp->m_flags &= ~XFS_MOUNT_RDONLY;
 		if (mp->m_flags & XFS_MOUNT_BARRIER)
 			xfs_mountfs_check_barriers(mp);
@@ -1323,15 +1344,7 @@ xfs_fs_remount(
 		 * Fill out the reserve pool if it is empty. Use the stashed
 		 * value if it is non-zero, otherwise go with the default.
 		 */
-		if (mp->m_resblks_ro) {
-			resblks = mp->m_resblks_ro;
-			mp->m_resblks_ro = 0;
-		} else {
-			resblks = mp->m_sb.sb_dblocks;
-			do_div(resblks, 20);
-			resblks = min_t(__uint64_t, resblks, 1024);
-		}
-		xfs_reserve_blocks(mp, &resblks, NULL);
+		xfs_restore_resvblks(mp);
 	}
 
 	/* rw -> ro */
@@ -1344,11 +1357,9 @@ xfs_fs_remount(
 		 * so that if we get remounted rw, we can return it to the same
 		 * size.
 		 */
-		__uint64_t resblks = 0;
 
 		xfs_quiesce_data(mp);
-		mp->m_resblks_ro = mp->m_resblks;
-		xfs_reserve_blocks(mp, &resblks, NULL);
+		xfs_save_resvblks(mp);
 		xfs_quiesce_attr(mp);
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 	}
@@ -1367,11 +1378,22 @@ xfs_fs_freeze(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
 	return -xfs_fs_log_dummy(mp);
 }
 
 STATIC int
+xfs_fs_unfreeze(
+	struct super_block	*sb)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	xfs_restore_resvblks(mp);
+	return 0;
+}
+
+STATIC int
 xfs_fs_show_options(
 	struct seq_file		*m,
 	struct vfsmount		*mnt)
@@ -1595,6 +1617,7 @@ static const struct super_operations xfs_super_operations = {
 	.put_super		= xfs_fs_put_super,
 	.sync_fs		= xfs_fs_sync_fs,
 	.freeze_fs		= xfs_fs_freeze,
+	.unfreeze_fs		= xfs_fs_unfreeze,
 	.statfs			= xfs_fs_statfs,
 	.remount_fs		= xfs_fs_remount,
 	.show_options		= xfs_fs_show_options,
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 8b6c9e8..0d1fbc1 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1006,6 +1006,22 @@ xfs_mount_reset_sbqflags(
 	return xfs_trans_commit(tp, 0);
 }
 
+__uint64_t
+xfs_default_resblks(xfs_mount_t *mp)
+{
+	__uint64_t resblks;
+
+	/*
+	 * We default to 5% or 1024 fsbs of space reserved, whichever is smaller.
+	 * This may drive us straight to ENOSPC on mount, but that implies
+	 * we were already there on the last unmount. Warn if this occurs.
+	 */
+	resblks = mp->m_sb.sb_dblocks;
+	do_div(resblks, 20);
+	resblks = min_t(__uint64_t, resblks, 1024);
+	return resblks;
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -1316,18 +1332,14 @@ xfs_mountfs(
 	 * when at ENOSPC. This is needed for operations like create with
 	 * attr, unwritten extent conversion at ENOSPC, etc. Data allocations
 	 * are not allowed to use this reserved space.
-	 *
-	 * We default to 5% or 1024 fsbs of space reserved, whichever is smaller.
-	 * This may drive us straight to ENOSPC on mount, but that implies
-	 * we were already there on the last unmount. Warn if this occurs.
 	 */
-	resblks = mp->m_sb.sb_dblocks;
-	do_div(resblks, 20);
-	resblks = min_t(__uint64_t, resblks, 1024);
-	error = xfs_reserve_blocks(mp, &resblks, NULL);
-	if (error)
-		cmn_err(CE_WARN, "XFS: Unable to allocate reserve blocks. "
-				"Continuing without a reserve pool.");
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		resblks = xfs_default_resblks(mp);
+		error = xfs_reserve_blocks(mp, &resblks, NULL);
+		if (error)
+			cmn_err(CE_WARN, "XFS: Unable to allocate reserve "
+				"blocks. Continuing without a reserve pool.");
+	}
 
 	return 0;
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1205844..4ab7f40 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -414,6 +414,7 @@ typedef struct xfs_mod_sb {
 } xfs_mod_sb_t;
 
 extern int	xfs_log_sbcount(xfs_mount_t *, uint);
+extern __uint64_t xfs_default_resblks(xfs_mount_t *mp);
 extern int	xfs_mountfs(xfs_mount_t *mp);
 
 extern void	xfs_unmountfs(xfs_mount_t *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
