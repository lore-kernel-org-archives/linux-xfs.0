Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q224DN7T241541 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 22:13:23 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	c9Lhwdd47zl3m7fd for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 20:13:22 -0800 (PST)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S3Jrt-0006Fv-0D
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 15:13:21 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S3JqT-0000Iu-GL
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 15:11:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/8] xfs: Fix open flag handling in open_by_handle code
Date: Fri,  2 Mar 2012 15:11:41 +1100
Message-Id: <1330661507-1121-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1330661507-1121-1-git-send-email-david@fromorbit.com>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Sparse identified some unsafe handling of open flags in the xfs open
by handle ioctl code. Update the code to use the correct access
macros to ensure that we handle the open flags correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 76f3ca5..86c86d8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -230,24 +230,19 @@ xfs_open_by_handle(
 
 	/* Put open permission in namei format. */
 	permflag = hreq->oflags;
-	if ((permflag+1) & O_ACCMODE)
-		permflag++;
-	if (permflag & O_TRUNC)
-		permflag |= 2;
-
 	if ((!(permflag & O_APPEND) || (permflag & O_TRUNC)) &&
-	    (permflag & FMODE_WRITE) && IS_APPEND(inode)) {
+	    (OPEN_FMODE(permflag) & FMODE_WRITE) && IS_APPEND(inode)) {
 		error = -XFS_ERROR(EPERM);
 		goto out_dput;
 	}
 
-	if ((permflag & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
+	if ((OPEN_FMODE(permflag) & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
 		error = -XFS_ERROR(EACCES);
 		goto out_dput;
 	}
 
 	/* Can't write directories. */
-	if (S_ISDIR(inode->i_mode) && (permflag & FMODE_WRITE)) {
+	if (S_ISDIR(inode->i_mode) && (OPEN_FMODE(permflag) & FMODE_WRITE)) {
 		error = -XFS_ERROR(EISDIR);
 		goto out_dput;
 	}
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
