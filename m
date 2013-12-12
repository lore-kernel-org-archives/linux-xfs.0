Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E698F7F6B
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:19:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6F4D30406A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:19:00 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 6v9mbgUvlU2YmFRJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 10:18:56 -0800 (PST)
Message-Id: <20131212181845.014747851@bombadil.infradead.org>
Date: Thu, 12 Dec 2013 10:15:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/5] xfs: fix splice_write locking
References: <20131212181459.994196463@bombadil.infradead.org>
Content-Disposition: inline; filename=0004-xfs-fix-splice_write-locking.patch
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
To: Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Call splice_from_pipe directly from XFS so that we can do our normal
I/O path locking.  This fixes a rare to hit deadlock vs direct I/O
as reported by Dave Chinner long time ago.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 52c91e1..9d0da98 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -43,6 +43,7 @@
 #include <linux/dcache.h>
 #include <linux/falloc.h>
 #include <linux/pagevec.h>
+#include <linux/splice.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -348,14 +349,6 @@ xfs_file_splice_read(
 	return ret;
 }
 
-/*
- * xfs_file_splice_write() does not use xfs_rw_ilock() because
- * generic_file_splice_write() takes the i_mutex itself. This, in theory,
- * couuld cause lock inversions between the aio_write path and the splice path
- * if someone is doing concurrent splice(2) based writes and write(2) based
- * writes to the same inode. The only real way to fix this is to re-implement
- * the generic code here with correct locking orders.
- */
 STATIC ssize_t
 xfs_file_splice_write(
 	struct pipe_inode_info	*pipe,
@@ -377,15 +370,22 @@ xfs_file_splice_write(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-
+	xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
 	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
+	ret = splice_from_pipe(pipe, outfilp, ppos, count, flags, pipe_to_file);
+	xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
+
+	if (ret > 0) {
+		int err;
 
-	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
-	if (ret > 0)
 		XFS_STATS_ADD(xs_write_bytes, ret);
 
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+		err = generic_write_sync(outfilp, *ppos, ret);
+		if (err)
+			return err;
+		*ppos += ret;
+	}
+
 	return ret;
 }
 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
