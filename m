Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751460AbdFZOZf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jun 2017 10:25:35 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v3 5/5] xfs: Switch to iomap for SEEK_HOLE / SEEK_DATA
Date: Mon, 26 Jun 2017 16:25:18 +0200
Message-Id: <1498487118-6564-6-git-send-email-agruenba@redhat.com>
In-Reply-To: <1498487118-6564-1-git-send-email-agruenba@redhat.com>
References: <1498487118-6564-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

Switch to the iomap_seek_hole_data vfs helper for implementing lseek
SEEK_HOLE / SEEK_DATA.  __xfs_seek_hole_data can go away once it's no
longer used by the quota code.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_file.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 962dafd..94fe89a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1131,29 +1131,18 @@ xfs_seek_hole_data(
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
+	offset = iomap_seek_hole_data(inode, start, whence, &xfs_iomap_ops);
 	xfs_iunlock(ip, lock);
 
-	if (error)
-		return error;
-	return offset;
+	if (offset < 0)
+		return offset;
+	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
 }
 
 STATIC loff_t
-- 
2.7.5

