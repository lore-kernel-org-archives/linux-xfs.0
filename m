Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41686 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438125AbfBNKBD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 05:01:03 -0500
Received: by mail-pl1-f196.google.com with SMTP id k15so2896965pls.8
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 02:01:02 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 3/6] Btrfs: add support for setting btime
Date: Thu, 14 Feb 2019 02:00:10 -0800
Message-Id: <60b83d5151d3c80bf73bb257b971aeb66120d4d5.1550136164.git.osandov@fb.com>
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

The Btrfs inode format has always included btime (under the name otime),
so setting it is trivial.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 2 ++
 fs/btrfs/super.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5c349667c761..49ad777d8057 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5153,6 +5153,8 @@ static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if (attr->ia_valid) {
 		setattr_copy(inode, attr);
+		if (attr->ia_valid & ATTR_BTIME)
+			BTRFS_I(inode)->i_otime = attr->ia_btime;
 		inode_inc_iversion(inode);
 		err = btrfs_dirty_inode(inode);
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0a3f122dd61f..2af368cad2aa 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2140,7 +2140,7 @@ static struct file_system_type btrfs_fs_type = {
 	.name		= "btrfs",
 	.mount		= btrfs_mount,
 	.kill_sb	= btrfs_kill_super,
-	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA,
+	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA | FS_HAS_BTIME,
 };
 
 static struct file_system_type btrfs_root_fs_type = {
@@ -2148,7 +2148,7 @@ static struct file_system_type btrfs_root_fs_type = {
 	.name		= "btrfs",
 	.mount		= btrfs_mount_root,
 	.kill_sb	= btrfs_kill_super,
-	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA,
+	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA | FS_HAS_BTIME,
 };
 
 MODULE_ALIAS_FS("btrfs");
-- 
2.20.1
