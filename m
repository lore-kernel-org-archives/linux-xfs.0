Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F2007F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 17:31:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 800E38F8068
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 15:31:19 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	4tBDiEHMwaOpLKvV for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 15:31:17 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: add DAX IO path support
Date: Wed,  4 Mar 2015 10:30:26 +1100
Message-Id: <1425425427-16283-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1425425427-16283-1-git-send-email-david@fromorbit.com>
References: <1425425427-16283-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

DAX does not do buffered IO (can't buffer direct access!) and hence
all read/write IO is vectored through the direct IO path.  Hence we
need to add the DAX IO path callouts to the direct IO
infrastructure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 22cb03a..28b79c5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1558,6 +1558,30 @@ xfs_end_io_direct_write(
 	}
 }
 
+static inline ssize_t
+xfs_vm_do_dio(
+	struct inode		*inode,
+	int			rw,
+	struct kiocb		*iocb,
+	struct iov_iter		*iter,
+	loff_t			offset,
+	void			(*endio)(struct kiocb	*iocb,
+					 loff_t		offset,
+					 ssize_t	size,
+					 void		*private),
+	int			flags)
+{
+	struct block_device	*bdev;
+
+	if (IS_DAX(inode))
+		return dax_do_io(rw, iocb, inode, iter, offset,
+				 xfs_get_blocks_direct, endio, 0);
+
+	bdev = xfs_find_bdev_for_inode(inode);
+	return  __blockdev_direct_IO(rw, iocb, inode, bdev, iter, offset,
+				     xfs_get_blocks_direct, endio, NULL, flags);
+}
+
 STATIC ssize_t
 xfs_vm_direct_IO(
 	int			rw,
@@ -1566,17 +1590,12 @@ xfs_vm_direct_IO(
 	loff_t			offset)
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
-	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
 
 	if (rw & WRITE) {
-		return __blockdev_direct_IO(rw, iocb, inode, bdev, iter,
-					    offset, xfs_get_blocks_direct,
-					    xfs_end_io_direct_write, NULL,
-					    DIO_ASYNC_EXTEND);
+		return xfs_vm_do_dio(inode, rw, iocb, iter, offset,
+				     xfs_end_io_direct_write, DIO_ASYNC_EXTEND);
 	}
-	return __blockdev_direct_IO(rw, iocb, inode, bdev, iter,
-				    offset, xfs_get_blocks_direct,
-				    NULL, NULL, 0);
+	return xfs_vm_do_dio(inode, rw, iocb, iter, offset, NULL, 0);
 }
 
 /*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
