Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37008 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438142AbfBNKBG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 05:01:06 -0500
Received: by mail-pg1-f196.google.com with SMTP id q206so2819609pgq.4
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 02:01:06 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 5/6] f2fs: add support for setting btime
Date: Thu, 14 Feb 2019 02:00:12 -0800
Message-Id: <a1e3edfb36b1cc732aa1f6159343ce2562d118d3.1550136164.git.osandov@fb.com>
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

The f2fs inode format includes btime (under the name crtime) if the
feature was enabled at mkfs time.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/f2fs/file.c  | 19 +++++++++++++++----
 fs/f2fs/super.c |  2 +-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index bba56b39dcc5..6064d3e42987 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -690,17 +690,23 @@ int f2fs_truncate(struct inode *inode)
 	return 0;
 }
 
+static bool f2fs_inode_has_crtime(struct inode *inode)
+{
+	struct f2fs_inode *ri;
+
+	return (f2fs_has_extra_attr(inode) &&
+		f2fs_sb_has_inode_crtime(F2FS_I_SB(inode)) &&
+		F2FS_FITS_IN_INODE(ri, F2FS_I(inode)->i_extra_isize, i_crtime));
+}
+
 int f2fs_getattr(const struct path *path, struct kstat *stat,
 		 u32 request_mask, unsigned int query_flags)
 {
 	struct inode *inode = d_inode(path->dentry);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
-	struct f2fs_inode *ri;
 	unsigned int flags;
 
-	if (f2fs_has_extra_attr(inode) &&
-			f2fs_sb_has_inode_crtime(F2FS_I_SB(inode)) &&
-			F2FS_FITS_IN_INODE(ri, fi->i_extra_isize, i_crtime)) {
+	if (f2fs_inode_has_crtime(inode)) {
 		stat->result_mask |= STATX_BTIME;
 		stat->btime.tv_sec = fi->i_crtime.tv_sec;
 		stat->btime.tv_nsec = fi->i_crtime.tv_nsec;
@@ -770,6 +776,9 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 	int err;
 	bool size_changed = false;
 
+	if ((attr->ia_valid & ATTR_BTIME) && !f2fs_inode_has_crtime(inode))
+		return -EOPNOTSUPP;
+
 	if (unlikely(f2fs_cp_error(F2FS_I_SB(inode))))
 		return -EIO;
 
@@ -848,6 +857,8 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	__setattr_copy(inode, attr);
+	if (attr->ia_valid & ATTR_BTIME)
+		F2FS_I(inode)->i_crtime = attr->ia_btime;
 
 	if (attr->ia_valid & ATTR_MODE) {
 		err = posix_acl_chmod(inode, f2fs_get_inode_mode(inode));
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index c46a1d4318d4..e32070c8cb27 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3485,7 +3485,7 @@ static struct file_system_type f2fs_fs_type = {
 	.name		= "f2fs",
 	.mount		= f2fs_mount,
 	.kill_sb	= kill_f2fs_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_BTIME,
 };
 MODULE_ALIAS_FS("f2fs");
 
-- 
2.20.1
