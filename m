Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q2rmvE179890 for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 20:53:48 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8348414C08CF
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 18:53:05 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id tyvgtOoGeLhKThpg for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 18:53:05 -0800 (PST)
Message-ID: <497D258C.1000908@sandeen.net>
Date: Sun, 25 Jan 2009 20:53:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] don't reallocate sxp variable passed into xfs_swapext
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@linux-foundation.org>, pm@debian.org

fixes kernel.org bugzilla 12538, xfs_fsr fails on 2.6.29-rc kernels

Regression caused by 743bb4650da9e2595d6cedd01c680b5b9398c74a

This was an embarrasing mistake, reallocating the sxp pointer passed
in from the main ioctl switch.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net
Reported-by: Paul Martin <pm@debian.org>
Tested-by: Paul Martin <pm@debian.org>
---


Index: linux-2.6/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dfrag.c
+++ linux-2.6/fs/xfs/xfs_dfrag.c
@@ -55,17 +55,11 @@ xfs_swapext(
 	struct file	*file, *target_file;
 	int		error = 0;
 
-	sxp = kmem_alloc(sizeof(xfs_swapext_t), KM_MAYFAIL);
-	if (!sxp) {
-		error = XFS_ERROR(ENOMEM);
-		goto out;
-	}
-
 	/* Pull information for the target fd */
 	file = fget((int)sxp->sx_fdtarget);
 	if (!file) {
 		error = XFS_ERROR(EINVAL);
-		goto out_free_sxp;
+		goto out;
 	}
 
 	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND)) {
@@ -109,8 +103,6 @@ xfs_swapext(
 	fput(target_file);
  out_put_file:
 	fput(file);
- out_free_sxp:
-	kmem_free(sxp);
  out:
 	return error;
 }



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
