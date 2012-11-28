Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS2B7ZC122957 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 20:11:07 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jFJfEg7t0M8c2XZm for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 18:13:22 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: fix splice/direct-IO deadlock
Date: Wed, 28 Nov 2012 13:12:48 +1100
Message-Id: <1354068768-4316-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1354068768-4316-1-git-send-email-david@fromorbit.com>
References: <1354068768-4316-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

lockdep reports splice vs direct-io write lock inversions due to
generic_file_splice_write() taking the inode->i_mutex inside
XFS_IOLOCK_EXCL context. These lock contexts are inverted, hence can
deadlock.  Remove the XFS_IOLOCK_EXCL locking context from the outer
function and drive it inwards to the actor function that only locks
the inode when the lock is really needed,

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c |   40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 2e79c54..21b6f0b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -39,6 +39,7 @@
 #include <linux/dcache.h>
 #include <linux/falloc.h>
 #include <linux/pagevec.h>
+#include <linux/splice.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -344,13 +345,33 @@ xfs_file_splice_read(
 	return ret;
 }
 
+static ssize_t
+xfs_file_splice_write_actor(
+	struct pipe_inode_info	*pipe,
+	struct splice_desc	*sd)
+{
+	struct file		*out = sd->u.file;
+	struct xfs_inode	*ip = XFS_I(out->f_mapping->host);
+	ssize_t ret;
+
+	xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
+	ret = file_remove_suid(out);
+	if (!ret) {
+		ret = file_update_time(out);
+		if (!ret)
+			ret = splice_from_pipe_feed(pipe, sd, pipe_to_file);
+	}
+	xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
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
@@ -373,15 +394,12 @@ xfs_file_splice_write(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-
 	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
 
-	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
+	ret = splice_write_to_file(pipe, outfilp, ppos, count, flags,
+					xfs_file_splice_write_actor);
 	if (ret > 0)
 		XFS_STATS_ADD(xs_write_bytes, ret);
-
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	return ret;
 }
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
