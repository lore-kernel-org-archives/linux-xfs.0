Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE8807CA1
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 17:27:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 73F158F8035
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:27:17 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 8Vhxnzfwm3TVqUhr (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:27:15 -0700 (PDT)
Received: from [67.51.76.21] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1aq6m8-0006B4-W9
	for xfs@oss.sgi.com; Tue, 12 Apr 2016 22:27:13 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] xfs: use iomap infrastructure for DAX zeroing
Date: Tue, 12 Apr 2016 15:26:49 -0700
Message-Id: <1460500013-28334-3-git-send-email-hch@lst.de>
In-Reply-To: <1460500013-28334-1-git-send-email-hch@lst.de>
References: <1460500013-28334-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 35 +----------------------------------
 fs/xfs/xfs_iops.c |  9 ++-------
 2 files changed, 3 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index bcedd80..bd07913 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -80,34 +80,6 @@ xfs_rw_ilock_demote(
 		inode_unlock(VFS_I(ip));
 }
 
-static int
-xfs_dax_zero_range(
-	struct inode		*inode,
-	loff_t			pos,
-	size_t			count)
-{
-	int			status = 0;
-
-	do {
-		unsigned offset, bytes;
-
-		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
-		bytes = PAGE_CACHE_SIZE - offset;
-		if (bytes > count)
-			bytes = count;
-
-		status = dax_zero_page_range(inode, pos, bytes,
-					     xfs_get_blocks_direct);
-		if (status)
-			break;
-
-		pos += bytes;
-		count -= bytes;
-	} while (count);
-
-	return status;
-}
-
 /*
  * Clear the specified ranges to zero through either the pagecache or DAX.
  * Holes and unwritten extents will be left as-is as they already are zeroed.
@@ -118,12 +90,7 @@ xfs_iozero(
 	loff_t			pos,
 	size_t			count)
 {
-	struct inode		*inode = VFS_I(ip);
-
-	if (IS_DAX(VFS_I(ip)))
-		return xfs_dax_zero_range(inode, pos, count);
-	else
-		return iomap_zero_range(inode, pos, count, NULL, &xfs_iomap_ops);
+	return iomap_zero_range(VFS_I(ip), pos, count, NULL, &xfs_iomap_ops);
 }
 
 int
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6e3614a..0c744fc 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -819,13 +819,8 @@ xfs_setattr_size(
 	if (newsize > oldsize) {
 		error = xfs_zero_eof(ip, newsize, oldsize, &did_zeroing);
 	} else {
-		if (IS_DAX(inode)) {
-			error = dax_truncate_page(inode, newsize,
-					xfs_get_blocks_direct);
-		} else {
-			error = iomap_truncate_page(inode, newsize,
-					&did_zeroing, &xfs_iomap_ops);
-		}
+		error = iomap_truncate_page(inode, newsize, &did_zeroing,
+				&xfs_iomap_ops);
 	}
 
 	if (error)
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
