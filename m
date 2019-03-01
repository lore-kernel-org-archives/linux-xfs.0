Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40105 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbfCAOGA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 09:06:00 -0500
From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 3/8] f2fs: support project ID in f2fs_setattr()
Date: Fri,  1 Mar 2019 23:05:36 +0900
Message-Id: <1551449141-7884-4-git-send-email-wshilong1991@gmail.com>
In-Reply-To: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc: lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>

From: Wang Shilong <wshilong@ddn.com>

From: Wang Shilong <wshilong@ddn.com>

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/f2fs/file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index bba56b39dcc5..8eaca056e857 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -789,7 +789,9 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 	if ((attr->ia_valid & ATTR_UID &&
 		!uid_eq(attr->ia_uid, inode->i_uid)) ||
 		(attr->ia_valid & ATTR_GID &&
-		!gid_eq(attr->ia_gid, inode->i_gid))) {
+		!gid_eq(attr->ia_gid, inode->i_gid)) ||
+		(attr->ia_valid & ATTR_PROJID &&
+		!projid_eq(attr->ia_projid, F2FS_I(inode)->i_projid))) {
 		f2fs_lock_op(F2FS_I_SB(inode));
 		err = dquot_transfer(inode, attr);
 		if (err) {
@@ -806,6 +808,8 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 			inode->i_uid = attr->ia_uid;
 		if (attr->ia_valid & ATTR_GID)
 			inode->i_gid = attr->ia_gid;
+		if (attr->ia_valid & ATTR_PROJID)
+			F2FS_I(inode)->i_projid = attr->ia_projid;
 		f2fs_mark_inode_dirty_sync(inode, true);
 		f2fs_unlock_op(F2FS_I_SB(inode));
 	}
-- 
2.19.1
