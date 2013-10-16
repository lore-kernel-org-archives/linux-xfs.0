Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0D5857F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 09:06:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A7462AC008
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 07:06:02 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 8MH0uE6Eu4nKIQ1n (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 07:06:01 -0700 (PDT)
From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V9 27/33] xfs: add support for read_iter and write_iter
Date: Wed, 16 Oct 2013 09:04:40 -0500
Message-Id: <1381932286-14978-28-git-send-email-dave.kleikamp@oracle.com>
In-Reply-To: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
References: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
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
To: linux-kernel@vger.kernel.org
Cc: Alex Elder <elder@kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Dave Kleikamp <dave.kleikamp@oracle.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>, "Maxim V. Patlasov" <mpatlasov@parallels.com>

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: xfs@oss.sgi.com
---
 fs/xfs/xfs_file.c | 51 ++++++++++++++++++++-------------------------------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4c749ab..818c623 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -227,10 +227,9 @@ xfs_file_fsync(
 }
 
 STATIC ssize_t
-xfs_file_aio_read(
+xfs_file_read_iter(
 	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned long		nr_segs,
+	struct iov_iter		*iter,
 	loff_t			pos)
 {
 	struct file		*file = iocb->ki_filp;
@@ -251,9 +250,7 @@ xfs_file_aio_read(
 	if (file->f_mode & FMODE_NOCMTIME)
 		ioflags |= IO_INVIS;
 
-	ret = generic_segment_checks(iovp, &nr_segs, &size, VERIFY_WRITE);
-	if (ret < 0)
-		return ret;
+	size = iov_iter_count(iter);
 
 	if (unlikely(ioflags & IO_ISDIRECT)) {
 		xfs_buftarg_t	*target =
@@ -306,7 +303,7 @@ xfs_file_aio_read(
 
 	trace_xfs_file_read(ip, size, pos, ioflags);
 
-	ret = generic_file_aio_read(iocb, iovp, nr_segs, pos);
+	ret = generic_file_read_iter(iocb, iter, pos);
 	if (ret > 0)
 		XFS_STATS_ADD(xs_read_bytes, ret);
 
@@ -622,10 +619,9 @@ restart:
 STATIC ssize_t
 xfs_file_dio_aio_write(
 	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned long		nr_segs,
+	struct iov_iter		*iter,
 	loff_t			pos,
-	size_t			ocount)
+	size_t			count)
 {
 	struct file		*file = iocb->ki_filp;
 	struct address_space	*mapping = file->f_mapping;
@@ -633,7 +629,6 @@ xfs_file_dio_aio_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
-	size_t			count = ocount;
 	int			unaligned_io = 0;
 	int			iolock;
 	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
@@ -693,8 +688,8 @@ xfs_file_dio_aio_write(
 	}
 
 	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
-	ret = generic_file_direct_write(iocb, iovp,
-			&nr_segs, pos, &iocb->ki_pos, count, ocount);
+	ret = generic_file_direct_write_iter(iocb, iter,
+			pos, &iocb->ki_pos, count);
 
 out:
 	xfs_rw_iunlock(ip, iolock);
@@ -707,10 +702,9 @@ out:
 STATIC ssize_t
 xfs_file_buffered_aio_write(
 	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned long		nr_segs,
+	struct iov_iter		*iter,
 	loff_t			pos,
-	size_t			ocount)
+	size_t			count)
 {
 	struct file		*file = iocb->ki_filp;
 	struct address_space	*mapping = file->f_mapping;
@@ -719,7 +713,6 @@ xfs_file_buffered_aio_write(
 	ssize_t			ret;
 	int			enospc = 0;
 	int			iolock = XFS_IOLOCK_EXCL;
-	size_t			count = ocount;
 
 	xfs_rw_ilock(ip, iolock);
 
@@ -732,7 +725,7 @@ xfs_file_buffered_aio_write(
 
 write_retry:
 	trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, 0);
-	ret = generic_file_buffered_write(iocb, iovp, nr_segs,
+	ret = generic_file_buffered_write_iter(iocb, iter,
 			pos, &iocb->ki_pos, count, 0);
 
 	/*
@@ -753,10 +746,9 @@ out:
 }
 
 STATIC ssize_t
-xfs_file_aio_write(
+xfs_file_write_iter(
 	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned long		nr_segs,
+	struct iov_iter		*iter,
 	loff_t			pos)
 {
 	struct file		*file = iocb->ki_filp;
@@ -764,17 +756,15 @@ xfs_file_aio_write(
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
-	size_t			ocount = 0;
+	size_t			count = 0;
 
 	XFS_STATS_INC(xs_write_calls);
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	ret = generic_segment_checks(iovp, &nr_segs, &ocount, VERIFY_READ);
-	if (ret)
-		return ret;
+	count = iov_iter_count(iter);
 
-	if (ocount == 0)
+	if (count == 0)
 		return 0;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
@@ -783,10 +773,9 @@ xfs_file_aio_write(
 	}
 
 	if (unlikely(file->f_flags & O_DIRECT))
-		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos, ocount);
+		ret = xfs_file_dio_aio_write(iocb, iter, pos, count);
 	else
-		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
-						  ocount);
+		ret = xfs_file_buffered_aio_write(iocb, iter, pos, count);
 
 	if (ret > 0) {
 		ssize_t err;
@@ -1411,8 +1400,8 @@ const struct file_operations xfs_file_operations = {
 	.llseek		= xfs_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= xfs_file_aio_read,
-	.aio_write	= xfs_file_aio_write,
+	.read_iter	= xfs_file_read_iter,
+	.write_iter	= xfs_file_write_iter,
 	.splice_read	= xfs_file_splice_read,
 	.splice_write	= xfs_file_splice_write,
 	.unlocked_ioctl	= xfs_file_ioctl,
-- 
1.8.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
