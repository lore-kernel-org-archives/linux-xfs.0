Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39422 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbfEQTqH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 15:46:07 -0400
Subject: [PATCH 9/3] libxfs: create current_time helper and sync
 xfs_trans_ichgtime
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <70781913-e46c-783e-789d-ce0e6af65549@sandeen.net>
Date: Fri, 17 May 2019 14:46:05 -0500
MIME-Version: 1.0
In-Reply-To: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Make xfs_trans_ichgtime() almost match kernelspace by creating a
new current_time() helper to match the kernel utility.

This reduces still more cosmetic change.  We may want to sync the
creation flag over to the kernel even though it's not used today.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 3e7e80ea..289d1774 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -16,6 +16,16 @@ struct xfs_mount;
 struct xfs_inode_log_item;
 struct xfs_dir_ops;
 
+/*
+ * These are not actually used, they are only for userspace build
+ * compatibility in code that looks at i_state
+ */
+#define I_DIRTY_TIME		0
+#define I_DIRTY_TIME_EXPIRED	0
+
+#define IS_I_VERSION(inode)			(0)
+#define inode_maybe_inc_iversion(inode,flags)	(0)
+
 /*
  * Inode interface. This fakes up a "VFS inode" to make the xfs_inode appear
  * similar to the kernel which now is used tohold certain parts of the on-disk
@@ -25,6 +35,7 @@ struct inode {
 	mode_t		i_mode;
 	uint32_t	i_nlink;
 	xfs_dev_t	i_rdev;		/* This actually holds xfs_dev_t */
+	unsigned long	i_state;	/* Not actually used in userspace */
 	uint32_t	i_generation;
 	uint64_t	i_version;
 	struct timespec	i_atime;
@@ -149,6 +160,9 @@ extern void	xfs_trans_ichgtime(struct xfs_trans *,
 				struct xfs_inode *, int);
 extern int	xfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
 
+#define timespec64 timespec
+extern struct timespec64 current_time(struct inode *inode);
+
 /* Inode Cache Interfaces */
 extern bool	xfs_inode_verify_forks(struct xfs_inode *ip);
 extern int	xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
diff --git a/libxfs/util.c b/libxfs/util.c
index aff91080..1734ae9a 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -136,11 +136,21 @@ xfs_log_calc_unit_res(
 	return unit_bytes;
 }
 
+struct timespec64
+current_time(struct inode *inode)
+{
+	struct timespec64	tv;
+	struct timeval		stv;
+
+	gettimeofday(&stv, (struct timezone *)0);
+	tv.tv_sec = stv.tv_sec;
+	tv.tv_nsec = stv.tv_usec * 1000;
+
+	return tv;
+}
+
 /*
  * Change the requested timestamp in the given inode.
- *
- * This was once shared with the kernel, but has diverged to the point
- * where it's no longer worth the hassle of maintaining common code.
  */
 void
 xfs_trans_ichgtime(
@@ -148,12 +158,14 @@ xfs_trans_ichgtime(
 	struct xfs_inode	*ip,
 	int			flags)
 {
-	struct timespec tv;
-	struct timeval	stv;
+	struct inode		*inode = VFS_I(ip);
+	struct timespec64	tv;
+
+	ASSERT(tp);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	tv = current_time(inode);
 
-	gettimeofday(&stv, (struct timezone *)0);
-	tv.tv_sec = stv.tv_sec;
-	tv.tv_nsec = stv.tv_usec * 1000;
 	if (flags & XFS_ICHGTIME_MOD)
 		VFS_I(ip)->i_mtime = tv;
 	if (flags & XFS_ICHGTIME_CHG)
