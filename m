Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E9ED17E8D
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:27:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B33B30404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:27:17 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 9GnQd4P8hfHAjioc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:27:16 -0700 (PDT)
Subject: [PATCH 087/119] xfs: cancel pending CoW reservations when
	destroying inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:27:09 -0700
Message-ID: <146612682953.12839.449371855172899748.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

When destroying the inode, cancel all pending reservations in the CoW
fork so that all the reserved blocks go back to the free pile.  In
theory this sort of cleanup is only needed to clean up after write
errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 18f74b3..09f9af7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -50,6 +50,7 @@
 #include "xfs_rmap_item.h"
 #include "xfs_refcount_item.h"
 #include "xfs_bmap_item.h"
+#include "xfs_reflink.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -939,6 +940,7 @@ xfs_fs_destroy_inode(
 	struct inode		*inode)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
+	int			error;
 
 	trace_xfs_destroy_inode(ip);
 
@@ -946,6 +948,12 @@ xfs_fs_destroy_inode(
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
 
+	error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF);
+	if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount))
+		xfs_warn(ip->i_mount, "Error %d while evicting CoW blocks "
+				"for inode %llu.",
+				error, ip->i_ino);
+
 	xfs_inactive(ip);
 
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
