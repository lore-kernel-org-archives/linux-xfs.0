Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755368AbdIRPxE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 11:53:04 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/7] xfs: Implement fallocate query support mode
Date: Mon, 18 Sep 2017 17:52:24 +0200
Message-Id: <1505749947-26360-5-git-send-email-lczerner@redhat.com>
In-Reply-To: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Lukas Czerner <lczerner@redhat.com>, linux-xfs@vger.kernel.org

Return all fallcoate modes supported by xfs file system.

Cc: linux-xfs@vger.kernel.org
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/xfs/xfs_file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ebdd0bd..85e06c6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -746,7 +746,8 @@ xfs_file_write_iter(
 #define	XFS_FALLOC_FL_SUPPORTED						\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
-		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE |	\
+		 FALLOC_FL_QUERY_SUPPORT | FALLOC_FL_PREALLOC_RANGE)
 
 STATIC long
 xfs_file_fallocate(
@@ -768,6 +769,9 @@ xfs_file_fallocate(
 	if (mode & ~XFS_FALLOC_FL_SUPPORTED)
 		return -EOPNOTSUPP;
 
+	if (mode & FALLOC_FL_QUERY_SUPPORT)
+		return XFS_FALLOC_FL_SUPPORTED;
+
 	xfs_ilock(ip, iolock);
 	error = xfs_break_layouts(inode, &iolock);
 	if (error)
-- 
2.7.5

