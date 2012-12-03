Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NehWf067723 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:43 -0600
Message-Id: <20121203144311.013661714@sgi.com>
Date: Mon, 03 Dec 2012 17:42:32 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 24/36] xfs: use iolock on XFS_IOC_ALLOCSP calls
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=085
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

Upstream commit: bc4010ecb8f4d4316e1a63a879a2715e49d113ad

fsstress has a particular effective way of stopping debug XFS
kernels. We keep seeing assert failures due finding delayed
allocation extents where there should be none. This shows up when
extracting extent maps and we are holding all the locks we should be
to prevent races, so this really makes no sense to see these errors.

After checking that fsstress does not use mmap, it occurred to me
that fsstress uses something that no sane application uses - the
XFS_IOC_ALLOCSP ioctl interfaces for preallocation. These interfaces
do allocation of blocks beyond EOF without using preallocation, and
then call setattr to extend and zero the allocated blocks.

THe problem here is this is a buffered write, and hence the
allocation is a delayed allocation. Unlike the buffered IO path, the
allocation and zeroing are not serialised using the IOLOCK. Hence
the ALLOCSP operation can race with operations holding the iolock to
prevent buffered IO operations from occurring.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_vnodeops.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

Index: b/fs/xfs/xfs_vnodeops.c
===================================================================
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2781,17 +2781,32 @@ xfs_change_file_space(
 	case XFS_IOC_ALLOCSP64:
 	case XFS_IOC_FREESP:
 	case XFS_IOC_FREESP64:
+		/*
+		 * These operations actually do IO when extending the file, but
+		 * the allocation is done seperately to the zeroing that is
+		 * done. This set of operations need to be serialised against
+		 * other IO operations, such as truncate and buffered IO. We
+		 * need to take the IOLOCK here to serialise the allocation and
+		 * zeroing IO to prevent other IOLOCK holders (e.g. getbmap,
+		 * truncate, direct IO) from racing against the transient
+		 * allocated but not written state we can have here.
+		 */
+		xfs_ilock(ip, XFS_IOLOCK_EXCL);
 		if (startoffset > fsize) {
 			error = xfs_alloc_file_space(ip, fsize,
-					startoffset - fsize, 0, attr_flags);
-			if (error)
+					startoffset - fsize, 0,
+					attr_flags | XFS_ATTR_NOLOCK);
+			if (error) {
+				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 				break;
+			}
 		}
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = startoffset;
 
-		error = xfs_setattr(ip, &iattr, attr_flags);
+		error = xfs_setattr(ip, &iattr, attr_flags | XFS_ATTR_NOLOCK);
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
 		if (error)
 			return error;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
