Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0ACFF7CB0
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 14:17:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2F4E304059
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 12:17:45 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id B86RuI3AX6eU3Kbc (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 12:17:43 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] xfs: fold xfs_vm_do_dio into xfs_vm_direct_IO
Date: Tue,  2 Feb 2016 21:17:37 +0100
Message-Id: <1454444257-9086-4-git-send-email-hch@lst.de>
In-Reply-To: <1454444257-9086-1-git-send-email-hch@lst.de>
References: <1454444257-9086-1-git-send-email-hch@lst.de>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: darrick.wong@oracle.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 39 ++++++++++++++-------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f6b08ea..e3cb7f8 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1599,41 +1599,30 @@ xfs_end_io_direct_write(
 	}
 }
 
-static inline ssize_t
-xfs_vm_do_dio(
-	struct inode		*inode,
+STATIC ssize_t
+xfs_vm_direct_IO(
 	struct kiocb		*iocb,
 	struct iov_iter		*iter,
-	loff_t			offset,
-	void			(*endio)(struct kiocb	*iocb,
-					 loff_t		offset,
-					 ssize_t	size,
-					 void		*private),
-	int			flags)
+	loff_t			offset)
 {
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	dio_iodone_t		*endio = NULL;
+	int			flags = 0;
 	struct block_device	*bdev;
 
-	if (IS_DAX(inode))
+	if (iov_iter_rw(iter) == WRITE) {
+		endio = xfs_end_io_direct_write;
+		flags = DIO_ASYNC_EXTEND;
+	}
+
+	if (IS_DAX(inode)) {
 		return dax_do_io(iocb, inode, iter, offset,
 				 xfs_get_blocks_direct, endio, 0);
+	}
 
 	bdev = xfs_find_bdev_for_inode(inode);
 	return  __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
-				     xfs_get_blocks_direct, endio, NULL, flags);
-}
-
-STATIC ssize_t
-xfs_vm_direct_IO(
-	struct kiocb		*iocb,
-	struct iov_iter		*iter,
-	loff_t			offset)
-{
-	struct inode		*inode = iocb->ki_filp->f_mapping->host;
-
-	if (iov_iter_rw(iter) == WRITE)
-		return xfs_vm_do_dio(inode, iocb, iter, offset,
-				     xfs_end_io_direct_write, DIO_ASYNC_EXTEND);
-	return xfs_vm_do_dio(inode, iocb, iter, offset, NULL, 0);
+			xfs_get_blocks_direct, endio, NULL, flags);
 }
 
 /*
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
