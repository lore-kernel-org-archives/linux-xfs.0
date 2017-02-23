Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227150206.gxqh23nfho5atl6s@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from userp1040.oracle.com ([156.151.31.81]:42508 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdBWR7k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Feb 2017 12:59:40 -0500
Date: Thu, 23 Feb 2017 09:59:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] vfs: hoist {XFS,EXT4,F2FS}_IOC_{GOING,SHUT}DOWN to the VFS
Message-ID: <20170223175914.GD5837@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>, f2fs <linux-f2fs-devel@lists.sourceforge.net>

ext4, f2fs, and XFS expose the same shutdown ioctl with the same
parameters, so let's hoist the whole mess into the vfs headers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: pull in f2fs as well
---
 fs/ext4/ext4.h          |   10 ----------
 fs/ext4/ioctl.c         |   12 ++++++------
 fs/f2fs/f2fs.h          |   10 ----------
 fs/f2fs/file.c          |   12 ++++++------
 fs/xfs/libxfs/xfs_fs.h  |    9 +--------
 fs/xfs/xfs_fsops.c      |    6 +++---
 fs/xfs/xfs_ioctl.c      |    2 +-
 fs/xfs/xfs_ioctl32.c    |    2 +-
 include/uapi/linux/fs.h |    9 +++++++++
 9 files changed, 27 insertions(+), 45 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cee23b6..b1b4f5b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -683,16 +683,6 @@ struct fsxattr {
 #define EXT4_IOC_FSGETXATTR		FS_IOC_FSGETXATTR
 #define EXT4_IOC_FSSETXATTR		FS_IOC_FSSETXATTR
 
-#define EXT4_IOC_SHUTDOWN _IOR ('X', 125, __u32)
-
-/*
- * Flags for going down operation
- */
-#define EXT4_GOING_FLAGS_DEFAULT		0x0	/* going down */
-#define EXT4_GOING_FLAGS_LOGFLUSH		0x1	/* flush log but not data */
-#define EXT4_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
-
-
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
  * ioctl commands in 32 bit emulation
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a4273dd..2a6f8a6 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -454,7 +454,7 @@ int ext4_shutdown(struct super_block *sb, unsigned long arg)
 	if (get_user(flags, (__u32 __user *)arg))
 		return -EFAULT;
 
-	if (flags > EXT4_GOING_FLAGS_NOLOGFLUSH)
+	if (flags > FS_SHUTDOWN_FLAGS_NOLOGFLUSH)
 		return -EINVAL;
 
 	if (ext4_forced_shutdown(sbi))
@@ -463,19 +463,19 @@ int ext4_shutdown(struct super_block *sb, unsigned long arg)
 	ext4_msg(sb, KERN_ALERT, "shut down requested (%d)", flags);
 
 	switch (flags) {
-	case EXT4_GOING_FLAGS_DEFAULT:
+	case FS_SHUTDOWN_FLAGS_DEFAULT:
 		freeze_bdev(sb->s_bdev);
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
 		thaw_bdev(sb->s_bdev, sb);
 		break;
-	case EXT4_GOING_FLAGS_LOGFLUSH:
+	case FS_SHUTDOWN_FLAGS_LOGFLUSH:
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
 		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal)) {
 			(void) ext4_force_commit(sb);
 			jbd2_journal_abort(sbi->s_journal, 0);
 		}
 		break;
-	case EXT4_GOING_FLAGS_NOLOGFLUSH:
+	case FS_SHUTDOWN_FLAGS_NOLOGFLUSH:
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
 		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal)) {
 			msleep(100);
@@ -940,7 +940,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 		return 0;
 	}
-	case EXT4_IOC_SHUTDOWN:
+	case FS_IOC_SHUTDOWN:
 		return ext4_shutdown(sb, arg);
 	default:
 		return -ENOTTY;
@@ -1008,7 +1008,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_SET_ENCRYPTION_POLICY:
 	case EXT4_IOC_GET_ENCRYPTION_PWSALT:
 	case EXT4_IOC_GET_ENCRYPTION_POLICY:
-	case EXT4_IOC_SHUTDOWN:
+	case FS_IOC_SHUTDOWN:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 069fc72..8d12352 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -256,16 +256,6 @@ static inline bool __has_cursum_space(struct f2fs_journal *journal,
 #define F2FS_IOC_GET_ENCRYPTION_POLICY	FS_IOC_GET_ENCRYPTION_POLICY
 #define F2FS_IOC_GET_ENCRYPTION_PWSALT	FS_IOC_GET_ENCRYPTION_PWSALT
 
-/*
- * should be same as XFS_IOC_GOINGDOWN.
- * Flags for going down operation used by FS_IOC_GOINGDOWN
- */
-#define F2FS_IOC_SHUTDOWN	_IOR('X', 125, __u32)	/* Shutdown */
-#define F2FS_GOING_DOWN_FULLSYNC	0x0	/* going down with full sync */
-#define F2FS_GOING_DOWN_METASYNC	0x1	/* going down with metadata */
-#define F2FS_GOING_DOWN_NOSYNC		0x2	/* going down */
-#define F2FS_GOING_DOWN_METAFLUSH	0x3	/* going down with meta flush */
-
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
  * ioctl commands in 32 bit emulation
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 49f10dc..2ff280a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1685,22 +1685,22 @@ static int f2fs_ioc_shutdown(struct file *filp, unsigned long arg)
 		return ret;
 
 	switch (in) {
-	case F2FS_GOING_DOWN_FULLSYNC:
+	case FS_SHUTDOWN_FLAGS_DEFAULT:
 		sb = freeze_bdev(sb->s_bdev);
 		if (sb && !IS_ERR(sb)) {
 			f2fs_stop_checkpoint(sbi, false);
 			thaw_bdev(sb->s_bdev, sb);
 		}
 		break;
-	case F2FS_GOING_DOWN_METASYNC:
+	case FS_SHUTDOWN_FLAGS_LOGFLUSH:
 		/* do checkpoint only */
 		f2fs_sync_fs(sb, 1);
 		f2fs_stop_checkpoint(sbi, false);
 		break;
-	case F2FS_GOING_DOWN_NOSYNC:
+	case FS_SHUTDOWN_FLAGS_NOLOGFLUSH:
 		f2fs_stop_checkpoint(sbi, false);
 		break;
-	case F2FS_GOING_DOWN_METAFLUSH:
+	case FS_SHUTDOWN_FLAGS_METAFLUSH:
 		sync_meta_pages(sbi, META, LONG_MAX);
 		f2fs_stop_checkpoint(sbi, false);
 		break;
@@ -2213,7 +2213,7 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return f2fs_ioc_release_volatile_write(filp);
 	case F2FS_IOC_ABORT_VOLATILE_WRITE:
 		return f2fs_ioc_abort_volatile_write(filp);
-	case F2FS_IOC_SHUTDOWN:
+	case FS_IOC_SHUTDOWN:
 		return f2fs_ioc_shutdown(filp, arg);
 	case FITRIM:
 		return f2fs_ioc_fitrim(filp, arg);
@@ -2286,7 +2286,7 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case F2FS_IOC_START_VOLATILE_WRITE:
 	case F2FS_IOC_RELEASE_VOLATILE_WRITE:
 	case F2FS_IOC_ABORT_VOLATILE_WRITE:
-	case F2FS_IOC_SHUTDOWN:
+	case FS_IOC_SHUTDOWN:
 	case F2FS_IOC_SET_ENCRYPTION_POLICY:
 	case F2FS_IOC_GET_ENCRYPTION_PWSALT:
 	case F2FS_IOC_GET_ENCRYPTION_POLICY:
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b72dc82..d7773b3 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -454,13 +454,6 @@ typedef struct xfs_swapext
 } xfs_swapext_t;
 
 /*
- * Flags for going down operation
- */
-#define XFS_FSOP_GOING_FLAGS_DEFAULT		0x0	/* going down */
-#define XFS_FSOP_GOING_FLAGS_LOGFLUSH		0x1	/* flush log but not data */
-#define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
-
-/*
  * ioctl limits
  */
 #ifdef XATTR_LIST_MAX
@@ -533,7 +526,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
-#define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+/*	XFS_IOC_GOINGDOWN ---------- hoisted 125	 */
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6ccaae9..3a0507e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -907,7 +907,7 @@ xfs_fs_goingdown(
 	__uint32_t	inflags)
 {
 	switch (inflags) {
-	case XFS_FSOP_GOING_FLAGS_DEFAULT: {
+	case FS_SHUTDOWN_FLAGS_DEFAULT: {
 		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
 
 		if (sb && !IS_ERR(sb)) {
@@ -917,10 +917,10 @@ xfs_fs_goingdown(
 
 		break;
 	}
-	case XFS_FSOP_GOING_FLAGS_LOGFLUSH:
+	case FS_SHUTDOWN_FLAGS_LOGFLUSH:
 		xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
 		break;
-	case XFS_FSOP_GOING_FLAGS_NOLOGFLUSH:
+	case FS_SHUTDOWN_FLAGS_NOLOGFLUSH:
 		xfs_force_shutdown(mp,
 				SHUTDOWN_FORCE_UMOUNT | SHUTDOWN_LOG_IO_ERROR);
 		break;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index cf1363db..859bdfe 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1931,7 +1931,7 @@ xfs_file_ioctl(
 		return error;
 	}
 
-	case XFS_IOC_GOINGDOWN: {
+	case FS_IOC_SHUTDOWN: {
 		__uint32_t in;
 
 		if (!capable(CAP_SYS_ADMIN))
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 7c49938..f2c1af6 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -551,7 +551,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_SET_RESBLKS:
 	case XFS_IOC_GET_RESBLKS:
 	case XFS_IOC_FSGROWFSLOG:
-	case XFS_IOC_GOINGDOWN:
+	case FS_IOC_SHUTDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
 		return xfs_file_ioctl(filp, cmd, p);
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 36da93f..3fda02b 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -347,4 +347,13 @@ struct fscrypt_policy {
 #define RWF_DSYNC			0x00000002 /* per-IO O_DSYNC */
 #define RWF_SYNC			0x00000004 /* per-IO O_SYNC */
 
+/*
+ * Flags for fs shutdown operation
+ */
+#define FS_SHUTDOWN_FLAGS_DEFAULT	0x0	/* flush everything */
+#define FS_SHUTDOWN_FLAGS_LOGFLUSH	0x1	/* flush log but not data */
+#define FS_SHUTDOWN_FLAGS_NOLOGFLUSH	0x2	/* don't flush log or data */
+#define FS_SHUTDOWN_FLAGS_METAFLUSH	0x3	/* flush metadata */
+#define FS_IOC_SHUTDOWN			_IOR ('X', 125, __u32)
+
 #endif /* _UAPI_LINUX_FS_H */
