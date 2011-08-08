Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p786jk86019840 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 01:45:46 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD8B8535A00
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2011 23:45:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	a0IsqajzHR2PWkp2 for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2011 23:45:44 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: fix splice/direct-IO deadlock
Date: Mon,  8 Aug 2011 16:45:27 +1000
Message-Id: <1312785927-10662-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1312785927-10662-1-git-send-email-david@fromorbit.com>
References: <1312785927-10662-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

lockdep reports splice vs direct-io write lock inversions due to
generic_file_splice_write() taking the inode->i_mutex inside
XFS_IOLOCK_EXCL context. These lock contexts are inverted, hence can
deadlock.  Use splice_write_to_file() with an actor that does not
take the i_mutex to avoid these problems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_file.c |   41 +++++++++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 62a5022..959d8b2 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -38,6 +38,7 @@
 
 #include <linux/dcache.h>
 #include <linux/falloc.h>
+#include <linux/splice.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -431,13 +432,29 @@ xfs_aio_write_newsize_update(
 	}
 }
 
+static ssize_t
+xfs_file_splice_write_actor(
+	struct pipe_inode_info	*pipe,
+	struct splice_desc	*sd)
+{
+	struct file		*out = sd->u.file;
+	ssize_t ret;
+
+	ret = file_remove_suid(out);
+	if (!ret) {
+		file_update_time(out);
+		ret = splice_from_pipe_feed(pipe, sd, pipe_to_file);
+	}
+
+	return ret;
+}
+
 /*
- * xfs_file_splice_write() does not use xfs_rw_ilock() because
- * generic_file_splice_write() takes the i_mutex itself. This, in theory,
- * couuld cause lock inversions between the aio_write path and the splice path
- * if someone is doing concurrent splice(2) based writes and write(2) based
- * writes to the same inode. The only real way to fix this is to re-implement
- * the generic code here with correct locking orders.
+ * xfs_file_splice_write() does not use the generic file splice write path
+ * because that takes the i_mutex, causing lock inversions with the IOLOCK.
+ * Instead, we call splice_write_to_file() directly with our own actor that does
+ * not take the i_mutex. This allows us to use the xfs_rw_ilock() functions like
+ * the rest of the code and hence avoid lock inversions and deadlocks.
  */
 STATIC ssize_t
 xfs_file_splice_write(
@@ -461,22 +478,22 @@ xfs_file_splice_write(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_rw_ilock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 
 	new_size = *ppos + count;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (new_size > ip->i_size)
 		ip->i_new_size = new_size;
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 
 	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
 
-	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
+	ret = splice_write_to_file(pipe, outfilp, ppos, count, flags,
+					xfs_file_splice_write_actor);
 
 	xfs_aio_write_isize_update(inode, ppos, ret);
 	xfs_aio_write_newsize_update(ip, new_size);
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
 	return ret;
 }
 
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
