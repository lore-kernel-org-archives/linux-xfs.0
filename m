Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q224DIWb241507 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 22:13:18 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IOv8GgMwqVEk4kqh for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 20:13:17 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S3Jrj-0006Fw-2T
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 15:13:11 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S3JqT-0000Ix-HC
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 15:11:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] xfs: handle kmalloc failure when reading attrs
Date: Fri,  2 Mar 2012 15:11:42 +1100
Message-Id: <1330661507-1121-4-git-send-email-david@fromorbit.com>
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

xfsdump uses for a large buffer for extended attributes, which has a
kmalloc'd shadow buffer in the kernel. This can fail after the
system has been running for some time as it is a high order
allocation. Add a fallback to vmalloc so that it doesn't require
contiguous memory and so won't randomly fail while xfsdump is
running.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 86c86d8..7721962 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -445,9 +445,12 @@ xfs_attrmulti_attr_get(
 
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
@@ -457,7 +460,7 @@ xfs_attrmulti_attr_get(
 		error = EFAULT;
 
  out_kfree:
-	kfree(kbuf);
+	kmem_free(kbuf);
 	return error;
 }
 
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
