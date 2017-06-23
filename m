Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753820AbdFWNex (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jun 2017 09:34:53 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 2/6] xfs: Switch to iomap for SEEK_HOLE / SEEK_DATA
Date: Fri, 23 Jun 2017 15:34:40 +0200
Message-Id: <1498224884-346-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1498224884-346-1-git-send-email-agruenba@redhat.com>
References: <1498224884-346-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>

Switch to the iomap_seek_hole_data vfs helper for implementing lseek
SEEK_HOLE / SEEK_DATA.  __xfs_seek_hole_data can go away once it's no
longer used by the quota code.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_file.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index fff9aba..5e48201 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1104,29 +1104,18 @@ xfs_seek_hole_data(
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

