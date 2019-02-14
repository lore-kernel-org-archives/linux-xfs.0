Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37616 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393498AbfBNKBA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 05:01:00 -0500
Received: by mail-pf1-f194.google.com with SMTP id s22so2855312pfh.4
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 02:01:00 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 1/6] fs: add btime to struct iattr
Date: Thu, 14 Feb 2019 02:00:08 -0800
Message-Id: <338b960e32ae2bebcf45c738af42a979af112e12.1550136164.git.osandov@fb.com>
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
References: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc: kernel-team@fb.com, linux-api@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Add btime as an attribute that can be updated through notify_change() if
the filesystem supports it, which is indicated by FS_HAS_BTIME in
file_system_type->fs_flags.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/attr.c          | 6 ++++++
 include/linux/fs.h | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/fs/attr.c b/fs/attr.c
index d22e8187477f..4831ef479951 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -233,6 +233,10 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 
 	WARN_ON_ONCE(!inode_is_locked(inode));
 
+	if ((ia_valid & ATTR_BTIME) &&
+	    !(inode->i_sb->s_type->fs_flags & FS_HAS_BTIME))
+		return -EOPNOTSUPP;
+
 	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_TIMES_SET)) {
 		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 			return -EPERM;
@@ -267,6 +271,8 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 		attr->ia_atime = now;
 	if (!(ia_valid & ATTR_MTIME_SET))
 		attr->ia_mtime = now;
+	if (!(ia_valid & ATTR_BTIME_SET))
+		attr->ia_btime = now;
 	if (ia_valid & ATTR_KILL_PRIV) {
 		error = security_inode_need_killpriv(dentry);
 		if (error < 0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 29d8e2cfed0e..d66040f7740b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -191,6 +191,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define ATTR_OPEN	(1 << 15) /* Truncating from open(O_TRUNC) */
 #define ATTR_TIMES_SET	(1 << 16)
 #define ATTR_TOUCH	(1 << 17)
+#define ATTR_BTIME	(1 << 18)
+#define ATTR_BTIME_SET	(1 << 19)
 
 /*
  * Whiteout is represented by a char device.  The following constants define the
@@ -217,6 +219,7 @@ struct iattr {
 	struct timespec64 ia_atime;
 	struct timespec64 ia_mtime;
 	struct timespec64 ia_ctime;
+	struct timespec64 ia_btime;
 
 	/*
 	 * Not an attribute, but an auxiliary info for filesystems wanting to
@@ -2172,6 +2175,7 @@ struct file_system_type {
 #define FS_BINARY_MOUNTDATA	2
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
+#define FS_HAS_BTIME		16	/* Supports getting/setting btime. */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
-- 
2.20.1
