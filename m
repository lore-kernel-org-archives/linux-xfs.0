Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E1267CD9
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 16:02:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62BCE30405F
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 14:02:59 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id GdSPszVlXjVkU46k (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Mar 2016 14:02:57 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1afZdf-0000Gf-NW
	for xfs@oss.sgi.com; Mon, 14 Mar 2016 21:02:56 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/7] xfs: reshuffle truncate
Date: Mon, 14 Mar 2016 22:02:48 +0100
Message-Id: <1457989370-6904-6-git-send-email-hch@lst.de>
In-Reply-To: <1457989370-6904-1-git-send-email-hch@lst.de>
References: <1457989370-6904-1-git-send-email-hch@lst.de>
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

---
 fs/xfs/xfs_iops.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index fb7dc61..1aab9f6 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -790,20 +790,35 @@ xfs_setattr_size(
 		return error;
 
 	/*
+	 * Wait for all direct I/O to complete.
+	 */
+	inode_dio_wait(inode);
+
+	/*
 	 * File data changes must be complete before we start the transaction to
 	 * modify the inode.  This needs to be done before joining the inode to
 	 * the transaction because the inode cannot be unlocked once it is a
 	 * part of the transaction.
 	 *
-	 * Start with zeroing any data block beyond EOF that we may expose on
-	 * file extension.
+	 * Start with zeroing any data beyond EOF that we may expose on file
+	 & extension, or zeroing out the rest of the block on a downward
+	 * truncate.
 	 */
 	if (newsize > oldsize) {
 		error = xfs_zero_eof(ip, newsize, oldsize, &did_zeroing);
-		if (error)
-			return error;
+	} else {
+		if (IS_DAX(inode)) {
+			error = dax_truncate_page(inode, newsize,
+					xfs_get_blocks_direct);
+		} else {
+			error = block_truncate_page(inode->i_mapping, newsize,
+					xfs_get_blocks);
+		}
 	}
 
+	if (error)
+		return error;
+
 	/*
 	 * We are going to log the inode size change in this transaction so
 	 * any previous writes that are beyond the on disk EOF and the new
@@ -820,9 +835,6 @@ xfs_setattr_size(
 			return error;
 	}
 
-	/* Now wait for all direct I/O to complete. */
-	inode_dio_wait(inode);
-
 	/*
 	 * We've already locked out new page faults, so now we can safely remove
 	 * pages from the page cache knowing they won't get refaulted until we
@@ -840,13 +852,6 @@ xfs_setattr_size(
 	 * to hope that the caller sees ENOMEM and retries the truncate
 	 * operation.
 	 */
-	if (IS_DAX(inode))
-		error = dax_truncate_page(inode, newsize, xfs_get_blocks_direct);
-	else
-		error = block_truncate_page(inode->i_mapping, newsize,
-					    xfs_get_blocks);
-	if (error)
-		return error;
 	truncate_setsize(inode, newsize);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
