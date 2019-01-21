Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58728 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730077AbfAUPXg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 10:23:36 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] fs: move generic stat response attr handling to vfs_getattr_nosec
Date: Mon, 21 Jan 2019 16:23:26 +0100
Message-Id: <20190121152326.9954-3-hch@lst.de>
In-Reply-To: <20190121152326.9954-1-hch@lst.de>
References: <20190121152326.9954-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, devel@lists.orangefs.org

generic_fillattr is an optional helper that isn't used by all file
systems, move handling purely based on inode flags to vfs_getattr_nosec,
which is common code.

This fixes setting this flag for file systems not using generic_fillattr
like xfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/stat.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index adbfcd86c81b..c38e4c2e1221 100644
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
 
@@ -75,6 +70,13 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 	stat->result_mask |= STATX_BASIC_STATS;
 	request_mask &= STATX_ALL;
 	query_flags &= KSTAT_QUERY_FLAGS;
+
+	/* allow the fs to override these if it really wants to */
+	if (IS_NOATIME(inode))
+		stat->result_mask &= ~STATX_ATIME;
+	if (IS_AUTOMOUNT(inode))
+		stat->attributes |= STATX_ATTR_AUTOMOUNT;
+
 	if (inode->i_op->getattr)
 		return inode->i_op->getattr(path, stat, request_mask,
 					    query_flags);
-- 
2.20.1
