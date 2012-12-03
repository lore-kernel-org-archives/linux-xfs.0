Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NeeCA067601 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:40 -0600
Message-Id: <20121203144309.644469343@sgi.com>
Date: Mon, 03 Dec 2012 17:42:17 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 09/36] xfs: Fix open flag handling in
	open_by_handle code
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=060
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

Upstream commit: 1a1d772433d42aaff7315b3468fef5951604f5c6

Sparse identified some unsafe handling of open flags in the xfs open
by handle ioctl code. Update the code to use the correct access
macros to ensure that we handle the open flags correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_ioctl.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index ada7da9..b27fb6d 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -209,6 +209,7 @@ xfs_open_by_handle(
 	struct file		*filp;
 	struct inode		*inode;
 	struct dentry		*dentry;
+	fmode_t			fmode;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -XFS_ERROR(EPERM);
@@ -228,26 +229,21 @@ xfs_open_by_handle(
 	hreq->oflags |= O_LARGEFILE;
 #endif
 
-	/* Put open permission in namei format. */
 	permflag = hreq->oflags;
-	if ((permflag+1) & O_ACCMODE)
-		permflag++;
-	if (permflag & O_TRUNC)
-		permflag |= 2;
-
+	fmode = OPEN_FMODE(permflag);
 	if ((!(permflag & O_APPEND) || (permflag & O_TRUNC)) &&
-	    (permflag & FMODE_WRITE) && IS_APPEND(inode)) {
+	    (fmode & FMODE_WRITE) && IS_APPEND(inode)) {
 		error = -XFS_ERROR(EPERM);
 		goto out_dput;
 	}
 
-	if ((permflag & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
+	if ((fmode & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
 		error = -XFS_ERROR(EACCES);
 		goto out_dput;
 	}
 
 	/* Can't write directories. */
-	if (S_ISDIR(inode->i_mode) && (permflag & FMODE_WRITE)) {
+	if (S_ISDIR(inode->i_mode) && (fmode & FMODE_WRITE)) {
 		error = -XFS_ERROR(EISDIR);
 		goto out_dput;
 	}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
