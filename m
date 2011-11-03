Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA36777C239405 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 01:07:08 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8586FDF726
	for <xfs@oss.sgi.com>; Wed,  2 Nov 2011 23:07:05 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id e1lraA5qKhpdMJMO
	for <xfs@oss.sgi.com>; Wed, 02 Nov 2011 23:07:05 -0700 (PDT)
Received: by faai28 with SMTP id i28so1297626faa.26
	for <xfs@oss.sgi.com>; Wed, 02 Nov 2011 23:07:05 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 3 Nov 2011 11:37:03 +0530
Message-ID: <CADDb1s0WUfvt8N+hMATboKxbMUZdk2N-R2e=KFH2JvGUjbigBg@mail.gmail.com>
Subject: [Patch] xfs: serialise unaligned direct IOs
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

This is needed for long term kernel 2.6.35.14.
Please let me know for any changes/suggestions.

Thanks & Regards,
Amit Sahrawat

xfs: serialise unaligned direct IOs

This patch published in 2.6.38 kernel(Original reference
http://oss.sgi.com/archives/xfs/2011-01/msg00013.html), but
can not be applied to 2.6.35 kernel directly, because of the
absence of required function, its reimplmented to resolve
xfstest test 240 fail.

When two concurrent unaligned, non-overlapping direct IOs are issued
to the same block, the direct Io layer will race to zero the block.
The result is that one of the concurrent IOs will overwrite data
written by the other IO with zeros. This is demonstrated by the
xfsqa test 240.

To avoid this problem, serialise all unaligned direct IOs to an
inode with a big hammer. We need a big hammer approach as we need to
serialise AIO as well, so we can't just block writes on locks.
Hence, the big hammer is calling xfs_ioend_wait() while holding out
other unaligned direct IOs from starting.

We don't bother trying to serialised aligned vs unaligned IOs as
they are overlapping IO and the result of concurrent overlapping IOs
is undefined - the result of either IO is a valid result so we let
them race. Hence we only penalise unaligned IO, which already has a
major overhead compared to aligned IO so this isn't a major problem.

diff -Nurp linux-Orig/fs/xfs/linux-2.6/xfs_file.c
linux-Updated/fs/xfs/linux-2.6/xfs_file.c
--- linux-Orig/fs/xfs/linux-2.6/xfs_file.c	2011-10-28 12:10:52.000000000 +0530
+++ linux-Updated/fs/xfs/linux-2.6/xfs_file.c	2011-10-29
12:34:45.000000000 +0530
@@ -587,6 +587,7 @@ xfs_file_aio_write(
 	xfs_fsize_t		isize, new_size;
 	int			iolock;
 	size_t			ocount = 0, count;
+	int			unaligned_io = 0;
 	int			need_i_mutex;

 	XFS_STATS_INC(xs_write_calls);
@@ -641,7 +642,10 @@ start:
 			return XFS_ERROR(-EINVAL);
 		}

-		if (!need_i_mutex && (mapping->nrpages || pos > ip->i_size)) {
+		if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
+			unaligned_io = 1;
+
+		if (!need_i_mutex && ( unaligned_io || mapping->nrpages || pos >
ip->i_size)) {
 			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 			iolock = XFS_IOLOCK_EXCL;
 			need_i_mutex = 1;
@@ -700,11 +704,15 @@ start:
 		}

 		if (need_i_mutex) {
-			/* demote the lock now the cached pages are gone */
-			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
+			if (unaligned_io)
+	                       	xfs_ioend_wait(ip);
+	               /* demote the lock now the cached pages are gone if we can */
+        	        else {
+                 	        xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
+	                        iolock = XFS_IOLOCK_SHARED;
+        	        }
 			mutex_unlock(&inode->i_mutex);

-			iolock = XFS_IOLOCK_SHARED;
 			need_i_mutex = 0;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
