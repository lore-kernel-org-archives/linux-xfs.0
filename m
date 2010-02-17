Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HK40Dv257241 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 14:04:00 -0600
Subject: [PATCH 2/2] xfs_export_operations.commit_metadata
From: Ben Myers <bpm@sgi.com>
Date: Wed, 17 Feb 2010 14:05:16 -0600
Message-ID: <20100217200516.13409.97524.stgit@case>
In-Reply-To: <20100217200426.13409.32688.stgit@case>
References: <20100217200426.13409.32688.stgit@case>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: bfields@fieldses.org
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

This is the commit_metadata export operation for XFS.

- Takes one inode to be committed.

- Forces the log up to the lsn of the inode.

- Doesn't force the log if the inode doesn't have a pincount.

Signed-off-by: Ben Myers <bpm@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_export.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
index 87b8cbd..8615d99 100644
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -29,6 +29,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
+#include "xfs_inode_item.h"
 
 /*
  * Note that we only accept fileids which are long enough rather than allow
@@ -215,9 +216,28 @@ xfs_fs_get_parent(
 	return d_obtain_alias(VFS_I(cip));
 }
 
+STATIC int
+xfs_fs_nfs_commit_metadata(
+	struct inode		*inode)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error = 0;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (xfs_ipincount(ip)) {
+		error = _xfs_log_force(mp, ip->i_itemp->ili_last_lsn,
+				XFS_LOG_FORCE | XFS_LOG_SYNC, NULL);
+	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	
+	return error;
+}
+
 const struct export_operations xfs_export_operations = {
 	.encode_fh		= xfs_fs_encode_fh,
 	.fh_to_dentry		= xfs_fs_fh_to_dentry,
 	.fh_to_parent		= xfs_fs_fh_to_parent,
 	.get_parent		= xfs_fs_get_parent,
+	.commit_metadata	= xfs_fs_nfs_commit_metadata,
 };

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
