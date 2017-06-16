Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754401AbdFPOvt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 10:51:49 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6/7] xfs: Switch to iomap for lseek SEEK_HOLE / SEEK_DATA
Date: Fri, 16 Jun 2017 16:51:19 +0200
Message-Id: <1497624680-16685-7-git-send-email-agruenba@redhat.com>
In-Reply-To: <1497624680-16685-1-git-send-email-agruenba@redhat.com>
References: <1497624680-16685-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Bob Peterson <rpeterso@redhat.com>, linux-xfs@vger.kernel.org, cluster-devel@redhat.com

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_file.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5fb5a09..b36dcd7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1283,28 +1283,15 @@ xfs_seek_hole_data(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	uint			lock;
-	loff_t			offset, end;
-	int			error = 0;
+	loff_t			offset;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
 	lock = xfs_ilock_data_map_shared(ip);
-
-	end = i_size_read(inode);
-	offset = __xfs_seek_hole_data(inode, start, end, whence);
-	if (offset < 0) {
-		error = offset;
-		goto out_unlock;
-	}
-
-	offset = vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
-
-out_unlock:
+	offset = iomap_seek_hole_data(file, start, whence, &xfs_iomap_ops);
 	xfs_iunlock(ip, lock);
 
-	if (error)
-		return error;
 	return offset;
 }
 
-- 
2.7.5

