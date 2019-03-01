Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f178.google.com ([209.85.210.178]:39327 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbfCAOGO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 09:06:14 -0500
From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 8/8] xfs: support project in xfs_getattr()
Date: Fri,  1 Mar 2019 23:05:41 +0900
Message-Id: <1551449141-7884-9-git-send-email-wshilong1991@gmail.com>
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
 fs/xfs/xfs_iops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c10466fe6ed4..a2f8c0f048cf 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -501,6 +501,7 @@ xfs_vn_getattr(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	stat->projid = xfs_projid_to_kprojid(xfs_get_projid(ip));
 	stat->size = XFS_ISIZE(ip);
 	stat->dev = inode->i_sb->s_dev;
 	stat->mode = inode->i_mode;
@@ -528,6 +529,8 @@ xfs_vn_getattr(
 		stat->attributes |= STATX_ATTR_APPEND;
 	if (ip->i_d.di_flags & XFS_DIFLAG_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
+	if (ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+		stat->attributes |= STATX_ATTR_PROJINHERIT;
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFBLK:
-- 
2.19.1
