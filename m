Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB46X1IF029514 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 00:33:02 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay3.corp.sgi.com (Postfix) with SMTP id 27342AC016
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 22:32:59 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id RAA20821 for <xfs@oss.sgi.com>;
	Thu, 4 Dec 2008 17:32:58 +1100
Message-ID: <493779B1.3010703@sgi.com>
Date: Thu, 04 Dec 2008 17:33:21 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [Fwd: [PATCH] Fix race in xfs_write() between direct and buffered
	I/O with DMAPI]
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

ping.

(forwarding message since my mailer eats the patch when replying).

-------- Original Message --------
Subject: [PATCH] Fix race in xfs_write() between direct and buffered I/O with DMAPI
Date: Mon, 22 Sep 2008 17:06:24 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
