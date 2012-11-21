Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALMdO7w104104 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 16:39:24 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id RlmB7Lsip0WG6kG0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 14:41:34 -0800 (PST)
From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v4 26/31] xfs: add support for read_iter and write_iter
Date: Wed, 21 Nov 2012 16:41:06 -0600
Message-Id: <1353537671-26284-27-git-send-email-dave.kleikamp@oracle.com>
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>, "Maxim V. Patlasov" <mpatlasov@parallels.com>

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: xfs@oss.sgi.com
---
 fs/xfs/xfs_file.c | 51 ++++++++++++++++++++-------------------------------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index aa473fa..df9bc1a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -223,10 +223,9 @@ xfs_file_fsync(
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
@@ -247,9 +246,7 @@ xfs_file_aio_read(
 	if (file->f_mode & FMODE_NOCMTIME)
 		ioflags |= IO_INVIS;
 
-	ret = generic_segment_checks(iovp, &nr_segs, &size, VERIFY_WRITE);
-	if (ret < 0)
-		return ret;
+	size = iov_iter_count(iter);
 
 	if (unlikely(ioflags & IO_ISDIRECT)) {
 		xfs_buftarg_t	*target =
@@ -302,7 +299,7 @@ xfs_file_aio_read(
 
 	trace_xfs_file_read(ip, size, iocb->ki_pos, ioflags);
 
-	ret = generic_file_aio_read(iocb, iovp, nr_segs, iocb->ki_pos);
+	ret = generic_file_read_iter(iocb, iter, iocb->ki_pos);
 	if (ret > 0)
 		XFS_STATS_ADD(xs_read_bytes, ret);
 
@@ -618,10 +615,9 @@ restart:
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
@@ -629,7 +625,6 @@ xfs_file_dio_aio_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
-	size_t			count = ocount;
 	int			unaligned_io = 0;
 	int			iolock;
 	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
@@ -688,8 +683,8 @@ xfs_file_dio_aio_write(
 	}
 
 	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
-	ret = generic_file_direct_write(iocb, iovp,
-			&nr_segs, pos, &iocb->ki_pos, count, ocount);
+	ret = generic_file_direct_write_iter(iocb, iter,
+			pos, &iocb->ki_pos, count);
 
 out:
 	xfs_rw_iunlock(ip, iolock);
@@ -702,10 +697,9 @@ out:
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
@@ -714,7 +708,6 @@ xfs_file_buffered_aio_write(
 	ssize_t			ret;
 	int			enospc = 0;
 	int			iolock = XFS_IOLOCK_EXCL;
-	size_t			count = ocount;
 
 	xfs_rw_ilock(ip, iolock);
 
@@ -727,7 +720,7 @@ xfs_file_buffered_aio_write(
 
 write_retry:
 	trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, 0);
-	ret = generic_file_buffered_write(iocb, iovp, nr_segs,
+	ret = generic_file_buffered_write_iter(iocb, iter,
 			pos, &iocb->ki_pos, count, ret);
 	/*
 	 * if we just got an ENOSPC, flush the inode now we aren't holding any
@@ -747,10 +740,9 @@ out:
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
@@ -758,17 +750,15 @@ xfs_file_aio_write(
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
 
 	sb_start_write(inode->i_sb);
@@ -779,10 +769,9 @@ xfs_file_aio_write(
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
@@ -1412,8 +1401,8 @@ const struct file_operations xfs_file_operations = {
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
1.8.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
