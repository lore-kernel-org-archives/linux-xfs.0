Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42868 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438143AbfBNKBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 05:01:08 -0500
Received: by mail-pf1-f194.google.com with SMTP id n74so2842585pfi.9
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 02:01:07 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 6/6] xfs: add support for setting btime
Date: Thu, 14 Feb 2019 02:00:13 -0800
Message-Id: <853e0dbdcd881e7dae13ada9dbb5924f6f5c4d9c.1550136164.git.osandov@fb.com>
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

The XFS inode format includes btime (under the name crtime) in inode
version 3. Also update the comments in libxfs to reflect that di_crtime
can now change.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/libxfs/xfs_format.h     |  2 +-
 fs/xfs/libxfs/xfs_log_format.h |  2 +-
 fs/xfs/xfs_iops.c              | 11 +++++++++--
 fs/xfs/xfs_super.c             |  2 +-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9bb3c48843ec..ff6cb860ae77 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -884,9 +884,9 @@ typedef struct xfs_dinode {
 	__be64		di_flags2;	/* more random flags */
 	__be32		di_cowextsize;	/* basic cow extent size for file */
 	__u8		di_pad2[12];	/* more padding for future expansion */
+	xfs_timestamp_t	di_crtime;	/* time created */
 
 	/* fields only written to during inode creation */
-	xfs_timestamp_t	di_crtime;	/* time created */
 	__be64		di_ino;		/* inode number */
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e5f97c69b320..5cb35b3db870 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -415,9 +415,9 @@ struct xfs_log_dinode {
 	uint64_t	di_flags2;	/* more random flags */
 	uint32_t	di_cowextsize;	/* basic cow extent size for file */
 	uint8_t		di_pad2[12];	/* more padding for future expansion */
+	xfs_ictimestamp_t di_crtime;	/* time created */
 
 	/* fields only written to during inode creation */
-	xfs_ictimestamp_t di_crtime;	/* time created */
 	xfs_ino_t	di_ino;		/* inode number */
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f48ffd7a8d3e..20570f61ffeb 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -582,6 +582,10 @@ xfs_setattr_time(
 		inode->i_ctime = iattr->ia_ctime;
 	if (iattr->ia_valid & ATTR_MTIME)
 		inode->i_mtime = iattr->ia_mtime;
+	if (iattr->ia_valid & ATTR_BTIME) {
+		ip->i_d.di_crtime.t_sec = iattr->ia_btime.tv_sec;
+		ip->i_d.di_crtime.t_nsec = iattr->ia_btime.tv_nsec;
+	}
 }
 
 static int
@@ -1025,11 +1029,14 @@ xfs_vn_setattr(
 	struct dentry		*dentry,
 	struct iattr		*iattr)
 {
+	struct inode		*inode = d_inode(dentry);
+	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
 
+	if ((iattr->ia_valid & ATTR_BTIME) && ip->i_d.di_version != 3)
+		return -EOPNOTSUPP;
+
 	if (iattr->ia_valid & ATTR_SIZE) {
-		struct inode		*inode = d_inode(dentry);
-		struct xfs_inode	*ip = XFS_I(inode);
 		uint			iolock;
 
 		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c9097cb0b955..54df86bc634b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1860,7 +1860,7 @@ static struct file_system_type xfs_fs_type = {
 	.name			= "xfs",
 	.mount			= xfs_fs_mount,
 	.kill_sb		= kill_block_super,
-	.fs_flags		= FS_REQUIRES_DEV,
+	.fs_flags		= FS_REQUIRES_DEV | FS_HAS_BTIME,
 };
 MODULE_ALIAS_FS("xfs");
 
-- 
2.20.1
