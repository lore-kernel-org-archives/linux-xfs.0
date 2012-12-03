Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NegN8067698 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:43 -0600
Message-Id: <20121203144309.366183710@sgi.com>
Date: Mon, 03 Dec 2012 17:42:14 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 06/36] xfs: fallback to vmalloc for large buffers
	in xfs_attrmulti_attr_get
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=057
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: ad650f5b27bc9858360b42aaa0d9204d16115316

xfsdump uses for a large buffer for extended attributes, which has a
kmalloc'd shadow buffer in the kernel. This can fail after the
system has been running for some time as it is a high order
allocation. Add a fallback to vmalloc so that it doesn't require
contiguous memory and so won't randomly fail while xfsdump is
running.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_ioctl.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index acca2c5..ada7da9 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -450,9 +450,12 @@ xfs_attrmulti_attr_get(
 
 	if (*len > XATTR_SIZE_MAX)
 		return EINVAL;
-	kbuf = kmalloc(*len, GFP_KERNEL);
-	if (!kbuf)
-		return ENOMEM;
+	kbuf = kmem_zalloc(*len, KM_SLEEP | KM_MAYFAIL);
+	if (!kbuf) {
+		kbuf = kmem_zalloc_large(*len);
+		if (!kbuf)
+			return ENOMEM;
+	}
 
 	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
 	if (error)
@@ -462,7 +465,10 @@ xfs_attrmulti_attr_get(
 		error = EFAULT;
 
  out_kfree:
-	kfree(kbuf);
+	if (is_vmalloc_addr(kbuf))
+		kmem_free_large(kbuf);
+	else
+		kmem_free(kbuf);
 	return error;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
