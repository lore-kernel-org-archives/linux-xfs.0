Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35030 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbfAQHxZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 02:53:25 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fs: move generic stat response attr handling to vfs_getattr_nosec
Date: Thu, 17 Jan 2019 08:53:20 +0100
Message-Id: <20190117075320.8327-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, dhowells@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

generic_fillattr is an optional helper that isn't used by all
file systems, move handling purely based on inode flags to
vfs_getattr_nosec, which is common code.

This fixes setting this flag for file systems not using generic_fillattr
like xfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/stat.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index adbfcd86c81b..9600ff1ea8df 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -45,11 +45,6 @@ void generic_fillattr(struct inode *inode, struct kstat *stat)
 	stat->ctime = inode->i_ctime;
 	stat->blksize = i_blocksize(inode);
 	stat->blocks = inode->i_blocks;
-
-	if (IS_NOATIME(inode))
-		stat->result_mask &= ~STATX_ATIME;
-	if (IS_AUTOMOUNT(inode))
-		stat->attributes |= STATX_ATTR_AUTOMOUNT;
 }
 EXPORT_SYMBOL(generic_fillattr);
 
@@ -75,11 +70,19 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 	stat->result_mask |= STATX_BASIC_STATS;
 	request_mask &= STATX_ALL;
 	query_flags &= KSTAT_QUERY_FLAGS;
-	if (inode->i_op->getattr)
-		return inode->i_op->getattr(path, stat, request_mask,
-					    query_flags);
+	if (inode->i_op->getattr) {
+		int ret = inode->i_op->getattr(path, stat, request_mask,
+				query_flags);
+		if (ret)
+			return ret;
+	} else {
+		generic_fillattr(inode, stat);
+	}
 
-	generic_fillattr(inode, stat);
+	if (IS_NOATIME(inode))
+		stat->result_mask &= ~STATX_ATIME;
+	if (IS_AUTOMOUNT(inode))
+		stat->attributes |= STATX_ATTR_AUTOMOUNT;
 	return 0;
 }
 EXPORT_SYMBOL(vfs_getattr_nosec);
-- 
2.20.1
