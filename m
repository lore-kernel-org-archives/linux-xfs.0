Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40254 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbfCAOF6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 09:05:58 -0500
From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 2/8] ext4: support project ID in ext4_setattr()
Date: Fri,  1 Mar 2019 23:05:35 +0900
Message-Id: <1551449141-7884-3-git-send-email-wshilong1991@gmail.com>
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
 fs/ext4/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 34d7e0703cc6..b6c451407dcd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5537,10 +5537,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			return error;
 	}
 	if ((ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, inode->i_uid)) ||
-	    (ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid))) {
+	    (ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid)) ||
+	    (ia_valid & ATTR_PROJID && !projid_eq(attr->ia_projid,
+						  EXT4_I(inode)->i_projid))) {
 		handle_t *handle;
 
-		/* (user+group)*(old+new) structure, inode write (sb,
+		/* (user+group+project)*(old+new) structure, inode write (sb,
 		 * inode block, ? - but truncate inode update has it) */
 		handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 			(EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb) +
@@ -5567,6 +5569,8 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			inode->i_uid = attr->ia_uid;
 		if (attr->ia_valid & ATTR_GID)
 			inode->i_gid = attr->ia_gid;
+		if (attr->ia_valid & ATTR_PROJID)
+			EXT4_I(inode)->i_projid = attr->ia_projid;
 		error = ext4_mark_inode_dirty(handle, inode);
 		ext4_journal_stop(handle);
 	}
-- 
2.19.1
