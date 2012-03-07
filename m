Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q274od5N020591 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 22:50:39 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	BTs9dSeM1ssIEBYC for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 20:50:36 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S58pc-0001np-04
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:32 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S58pb-0007Uj-PG
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/10] xfs: clean up minor sparse warnings
Date: Wed,  7 Mar 2012 15:50:19 +1100
Message-Id: <1331095828-28742-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1331095828-28742-1-git-send-email-david@fromorbit.com>
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_dir2_block.c |    1 +
 fs/xfs/xfs_ioctl32.c    |    2 +-
 fs/xfs/xfs_iops.c       |   13 ++++++++-----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 9245e02..d3b63ae 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -29,6 +29,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
+#include "xfs_dir2.h"
 #include "xfs_dir2_format.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index f9ccb7b..a849a54 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -293,7 +293,7 @@ xfs_compat_ioc_bulkstat(
 		int res;
 
 		error = xfs_bulkstat_one_compat(mp, inlast, bulkreq.ubuffer,
-				sizeof(compat_xfs_bstat_t), 0, &res);
+				sizeof(compat_xfs_bstat_t), NULL, &res);
 	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
 		error = xfs_bulkstat(mp, &inlast, &count,
 			xfs_bulkstat_one_compat, sizeof(compat_xfs_bstat_t),
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ab30253..2601d6b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -103,12 +103,15 @@ xfs_mark_inode_dirty(
 }
 
 
-int xfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
-		   void *fs_info)
+static int
+xfs_initxattrs(
+	struct inode		*inode,
+	const struct xattr	*xattr_array,
+	void			*fs_info)
 {
-	const struct xattr *xattr;
-	struct xfs_inode *ip = XFS_I(inode);
-	int error = 0;
+	const struct xattr	*xattr;
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			error = 0;
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 		error = xfs_attr_set(ip, xattr->name, xattr->value,
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
