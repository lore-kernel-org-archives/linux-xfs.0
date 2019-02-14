Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46020 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438125AbfBNKBF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 05:01:05 -0500
Received: by mail-pg1-f194.google.com with SMTP id y4so2799307pgc.12
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 02:01:04 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 4/6] ext4: add support for setting btime
Date: Thu, 14 Feb 2019 02:00:11 -0800
Message-Id: <d78386ac6b970bcca531d1d87ae568bef92252be.1550136164.git.osandov@fb.com>
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

The ext4 inode format includes btime (under the name crtime) if the
inode is large enough (256 bytes).

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/ext4/inode.c | 15 +++++++++++++--
 fs/ext4/super.c |  2 +-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 34d7e0703cc6..7f4f83ef539d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5489,6 +5489,13 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
 	}
 }
 
+static bool ext4_inode_has_crtime(struct inode *inode)
+{
+	struct ext4_inode *raw_inode;
+
+	return EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), i_crtime);
+}
+
 /*
  * ext4_setattr()
  *
@@ -5520,6 +5527,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	int orphan = 0;
 	const unsigned int ia_valid = attr->ia_valid;
 
+	if ((ia_valid & ATTR_BTIME) && !ext4_inode_has_crtime(inode))
+		return -EOPNOTSUPP;
+
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
 		return -EIO;
 
@@ -5671,6 +5681,8 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if (!error) {
 		setattr_copy(inode, attr);
+		if (ia_valid & ATTR_BTIME)
+			EXT4_I(inode)->i_crtime = attr->ia_btime;
 		mark_inode_dirty(inode);
 	}
 
@@ -5695,11 +5707,10 @@ int ext4_getattr(const struct path *path, struct kstat *stat,
 		 u32 request_mask, unsigned int query_flags)
 {
 	struct inode *inode = d_inode(path->dentry);
-	struct ext4_inode *raw_inode;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int flags;
 
-	if (EXT4_FITS_IN_INODE(raw_inode, ei, i_crtime)) {
+	if (ext4_inode_has_crtime(inode)) {
 		stat->result_mask |= STATX_BTIME;
 		stat->btime.tv_sec = ei->i_crtime.tv_sec;
 		stat->btime.tv_nsec = ei->i_crtime.tv_nsec;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fb12d3c17c1b..cdd3975de130 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5976,7 +5976,7 @@ static struct file_system_type ext4_fs_type = {
 	.name		= "ext4",
 	.mount		= ext4_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_BTIME,
 };
 MODULE_ALIAS_FS("ext4");
 
-- 
2.20.1
