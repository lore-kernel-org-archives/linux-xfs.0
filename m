Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N542fo135498 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:02 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	TfPkOGfgzzRHXQWr for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:47 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Paz-0003Hw-P2
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pap-0003g9-Kl
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 060/102] xfs: Fix open flag handling in open_by_handle code
Date: Thu, 23 Aug 2012 15:02:18 +1000
Message-Id: <1345698180-13612-61-git-send-email-david@fromorbit.com>
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
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
