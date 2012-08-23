Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N558Kj136054 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:08 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6ZB3Q953j4EGTMoU for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:53 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pbf-0003Jq-0n
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbU-0003iM-Tf
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 085/102] xfs: use iolock on XFS_IOC_ALLOCSP calls
Date: Thu, 23 Aug 2012 15:02:43 +1000
Message-Id: <1345698180-13612-86-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 3988584..6ade3c6 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2789,17 +2789,32 @@ xfs_change_file_space(
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
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
