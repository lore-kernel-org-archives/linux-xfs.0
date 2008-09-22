Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Sep 2008 23:56:11 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8M6u886022296
	for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 23:56:08 -0700
Message-ID: <48D743F0.1090101@sgi.com>
Date: Mon, 22 Sep 2008 17:06:24 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Fix race in xfs_write() between direct and buffered I/O with
 DMAPI
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

The iolock is dropped and re-acquired around the call to XFS_SEND_NAMESP().
While the iolock is released the file can become cached.  We then
'goto retry' and - if we are doing direct I/O - mapping->nrpages may now be
non zero but need_i_mutex will be zero and we will hit the WARN_ON().

Since we have dropped the I/O lock then the file size may have also changed
so what we need to do here is 'goto start' like we do for the XFS_SEND_DATA()
DMAPI event.

We also need to update the filesize before releasing the iolock so that
needs to be done before the XFS_SEND_NAMESP event.  If we drop the iolock
before setting the filesize we could race with a truncate.

--- a/fs/xfs/linux-2.6/xfs_lrw.c	2008-09-22 15:47:38.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_lrw.c	2008-09-22 15:50:56.000000000 +1000
@@ -707,7 +707,6 @@ start:
 		}
 	}
 
-retry:
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
 
@@ -763,6 +762,17 @@ retry:
 	if (ret == -EIOCBQUEUED && !(ioflags & IO_ISAIO))
 		ret = wait_on_sync_kiocb(iocb);
 
+	isize = i_size_read(inode);
+	if (unlikely(ret < 0 && ret != -EFAULT && *offset > isize))
+		*offset = isize;
+
+	if (*offset > xip->i_size) {
+		xfs_ilock(xip, XFS_ILOCK_EXCL);
+		if (*offset > xip->i_size)
+			xip->i_size = *offset;
+		xfs_iunlock(xip, XFS_ILOCK_EXCL);
+	}
+
 	if (ret == -ENOSPC &&
 	    DM_EVENT_ENABLED(xip, DM_EVENT_NOSPACE) && !(ioflags & IO_INVIS)) {
 		xfs_iunlock(xip, iolock);
@@ -776,20 +786,7 @@ retry:
 		xfs_ilock(xip, iolock);
 		if (error)
 			goto out_unlock_internal;
-		pos = xip->i_size;
-		ret = 0;
-		goto retry;
-	}
-
-	isize = i_size_read(inode);
-	if (unlikely(ret < 0 && ret != -EFAULT && *offset > isize))
-		*offset = isize;
-
-	if (*offset > xip->i_size) {
-		xfs_ilock(xip, XFS_ILOCK_EXCL);
-		if (*offset > xip->i_size)
-			xip->i_size = *offset;
-		xfs_iunlock(xip, XFS_ILOCK_EXCL);
+		goto start;
 	}
 
 	error = -ret;
