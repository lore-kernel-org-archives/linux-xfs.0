Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B81AC7CA4
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:53:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8C61E8F8050
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:53:45 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id EHpSbEhtFz8RSiqC (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:53:42 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/8] xfs: reorder zeroing and flushing sequence in truncate
Date: Tue, 12 Apr 2016 13:52:58 -0700
Message-Id: <1460494382-14547-5-git-send-email-hch@lst.de>
In-Reply-To: <1460494382-14547-1-git-send-email-hch@lst.de>
References: <1460494382-14547-1-git-send-email-hch@lst.de>
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
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org

Currently zeroing out blocks and waiting for writeout is a bit of a mess in
truncate.  This patch gives it a clear order in preparation for the iomap
path:

 (1) we first wait for any direct I/O to complete to prevent any races for it
 (2) we then perform the actual zeroing, and only use the truncate_page helpers
     for truncating down.  The truncate up case already is handled by the
     separate call to xfs_zero_eof.
 (3) only then we write back dirty data, as zeroing block may cause dirty pages
     when using either xfs_zero_eof or the new iomap infrastructure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c5d4eba..1e2086d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -801,20 +801,35 @@ xfs_setattr_size(
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
@@ -831,9 +846,6 @@ xfs_setattr_size(
 			return error;
 	}
 
-	/* Now wait for all direct I/O to complete. */
-	inode_dio_wait(inode);
-
 	/*
 	 * We've already locked out new page faults, so now we can safely remove
 	 * pages from the page cache knowing they won't get refaulted until we
@@ -851,13 +863,6 @@ xfs_setattr_size(
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
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
