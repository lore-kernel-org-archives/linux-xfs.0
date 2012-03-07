Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q274oknH020633 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 22:50:46 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GAEfWTWUG5XitHSc for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 20:50:44 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S58pc-0001nq-0t
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:32 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S58pb-0007Ul-Qn
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/10] xfs: Fix open flag handling in open_by_handle code
Date: Wed,  7 Mar 2012 15:50:20 +1100
Message-Id: <1331095828-28742-3-git-send-email-david@fromorbit.com>
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

Sparse identified some unsafe handling of open flags in the xfs open
by handle ioctl code. Update the code to use the correct access
macros to ensure that we handle the open flags correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 76f3ca5..8dc5fe1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
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
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
