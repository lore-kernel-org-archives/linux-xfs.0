Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40269 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbfCAOGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 09:06:07 -0500
From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 6/8] ext4: support project in ext4_getattr()
Date: Fri,  1 Mar 2019 23:05:39 +0900
Message-Id: <1551449141-7884-7-git-send-email-wshilong1991@gmail.com>
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
 fs/ext4/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b6c451407dcd..cd7b3f997c3b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5703,6 +5703,8 @@ int ext4_getattr(const struct path *path, struct kstat *stat,
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int flags;
 
+	stat->projid = ei->i_projid;
+
 	if (EXT4_FITS_IN_INODE(raw_inode, ei, i_crtime)) {
 		stat->result_mask |= STATX_BTIME;
 		stat->btime.tv_sec = ei->i_crtime.tv_sec;
@@ -5720,12 +5722,15 @@ int ext4_getattr(const struct path *path, struct kstat *stat,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (flags & EXT4_NODUMP_FL)
 		stat->attributes |= STATX_ATTR_NODUMP;
+	if (flags & EXT4_PROJINHERIT_FL)
+		stat->attributes |= STATX_ATTR_PROJINHERIT;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_ENCRYPTED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP);
+				  STATX_ATTR_NODUMP |
+				  STATX_ATTR_PROJINHERIT);
 
 	generic_fillattr(inode, stat);
 	return 0;
-- 
2.19.1
