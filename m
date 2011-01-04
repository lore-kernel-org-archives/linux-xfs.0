Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p044kf7b175955 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 22:46:41 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A86B3153626C
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 20:48:45 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	4P3k0qh9AURfMOG9 for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 20:48:45 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	51671903-1927428
	for <xfs@oss.sgi.com>; Tue, 04 Jan 2011 15:18:44 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PZyp9-0000Sw-63
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:48:43 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PZyp7-0003ta-FI
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:48:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/8] xfs: factor common post-write isize handling code
Date: Tue,  4 Jan 2011 15:48:32 +1100
Message-Id: <1294116518-14908-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1294116518-14908-1-git-send-email-david@fromorbit.com>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_file.c |   52 +++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index de71a84..841529e 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -321,6 +321,30 @@ xfs_file_splice_read(
 	return ret;
 }
 
+STATIC void
+xfs_aio_write_isize_update(
+	struct inode	*inode,
+	loff_t		*ppos,
+	ssize_t		bytes_written)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	xfs_fsize_t		isize = i_size_read(inode);
+
+	if (bytes_written > 0)
+		XFS_STATS_ADD(xs_write_bytes, bytes_written);
+
+	if (unlikely(bytes_written < 0 && bytes_written != -EFAULT &&
+					*ppos > isize))
+		*ppos = isize;
+
+	if (*ppos > ip->i_size) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		if (*ppos > ip->i_size)
+			ip->i_size = *ppos;
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	}
+}
+
 STATIC ssize_t
 xfs_file_splice_write(
 	struct pipe_inode_info	*pipe,
@@ -331,7 +355,7 @@ xfs_file_splice_write(
 {
 	struct inode		*inode = outfilp->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	xfs_fsize_t		isize, new_size;
+	xfs_fsize_t		new_size;
 	int			ioflags = 0;
 	ssize_t			ret;
 
@@ -355,19 +379,8 @@ xfs_file_splice_write(
 	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
 
 	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
-	if (ret > 0)
-		XFS_STATS_ADD(xs_write_bytes, ret);
-
-	isize = i_size_read(inode);
-	if (unlikely(ret < 0 && ret != -EFAULT && *ppos > isize))
-		*ppos = isize;
 
-	if (*ppos > ip->i_size) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		if (*ppos > ip->i_size)
-			ip->i_size = *ppos;
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	}
+	xfs_aio_write_isize_update(inode, ppos, ret);
 
 	if (ip->i_new_size) {
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -576,7 +589,7 @@ xfs_file_aio_write(
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
 	int			ioflags = 0;
-	xfs_fsize_t		isize, new_size;
+	xfs_fsize_t		new_size;
 	int			iolock;
 	size_t			ocount = 0, count;
 	int			need_i_mutex;
@@ -742,16 +755,7 @@ write_retry:
 
 	current->backing_dev_info = NULL;
 
-	isize = i_size_read(inode);
-	if (unlikely(ret < 0 && ret != -EFAULT && iocb->ki_pos > isize))
-		iocb->ki_pos = isize;
-
-	if (iocb->ki_pos > ip->i_size) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		if (iocb->ki_pos > ip->i_size)
-			ip->i_size = iocb->ki_pos;
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	}
+	xfs_aio_write_isize_update(inode, &iocb->ki_pos, ret);
 
 	if (ret <= 0)
 		goto out_unlock_internal;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
