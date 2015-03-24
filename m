Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 56AEC7F5F
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:51:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44DF38F8071
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 03:51:25 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Ejih3K39RPvNswlq for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 03:51:23 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfs: add DAX IO path support
Date: Tue, 24 Mar 2015 21:51:05 +1100
Message-Id: <1427194266-2885-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194266-2885-1-git-send-email-david@fromorbit.com>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
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
index 3fc5052..97979e9 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1559,6 +1559,30 @@ xfs_end_io_direct_write(
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
@@ -1567,17 +1591,12 @@ xfs_vm_direct_IO(
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
