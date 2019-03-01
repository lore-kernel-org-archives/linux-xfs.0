Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42522 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbfCAOGJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 09:06:09 -0500
From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 7/8] f2fs: support project in f2fs_getattr()
Date: Fri,  1 Mar 2019 23:05:40 +0900
Message-Id: <1551449141-7884-8-git-send-email-wshilong1991@gmail.com>
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
index 8eaca056e857..2db5883cc1b0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -705,6 +705,7 @@ int f2fs_getattr(const struct path *path, struct kstat *stat,
 		stat->btime.tv_sec = fi->i_crtime.tv_sec;
 		stat->btime.tv_nsec = fi->i_crtime.tv_nsec;
 	}
+	stat->projid = fi->i_projid;
 
 	flags = fi->i_flags & F2FS_FL_USER_VISIBLE;
 	if (flags & F2FS_APPEND_FL)
@@ -717,12 +718,15 @@ int f2fs_getattr(const struct path *path, struct kstat *stat,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (flags & F2FS_NODUMP_FL)
 		stat->attributes |= STATX_ATTR_NODUMP;
+	if (flags & F2FS_PROJINHERIT_FL)
+		stat->attributes |= STATX_ATTR_PROJINHERIT;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_ENCRYPTED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP);
+				  STATX_ATTR_NODUMP |
+				  STATX_ATTR_PROJINHERIT);
 
 	generic_fillattr(inode, stat);
 
-- 
2.19.1
