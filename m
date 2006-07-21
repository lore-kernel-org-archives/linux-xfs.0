Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 22:29:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6L5SjDW024481
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 22:28:57 -0700
Date: Fri, 21 Jul 2006 15:28:07 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: fix remount vs barrier options
Message-ID: <20060721152807.D1998769@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: jeremy@sgi.com

Hi,

Jeremy has had me scratching my head for a few days trying to
figure out how the SCSI traces he's looking at can still show
signs of write barriers being issued to the device, despite a
"remount,nobarrier" having been done.

It finally clicked that we are not clearing the buffer flag
from a previously written log buffer, even though we'll no
longer set a new flag into a buffer (due to the mount flag
being cleared), so we _can_ still issue barrier writes when
remounted without barriers.

This was made more complicated by the way a freshly mounted
filesystem with 8 log buffers wouldn't show up the problem,
since we have to slowly cycle through the "clear" log buffers
before we see the bug.  This seems like the simplest fix...

(Hmmm, actually, I wonder if this will also resolve the quota
log I/O problem that was reported the other day too).

-- 
Nathan


Index: xfs-linux/xfs_log.c
===================================================================
--- xfs-linux.orig/xfs_log.c	2006-07-21 08:55:24.520992250 +1000
+++ xfs-linux/xfs_log.c	2006-07-21 09:47:08.429216000 +1000
@@ -1471,6 +1471,8 @@ xlog_sync(xlog_t		*log,
 	 */
 	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 		XFS_BUF_ORDERED(bp);
+	else
+		XFS_BUF_UNORDERED(bp);
 
 	ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
 	ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
@@ -1503,6 +1505,8 @@ xlog_sync(xlog_t		*log,
 		XFS_BUF_ASYNC(bp);
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 			XFS_BUF_ORDERED(bp);
+		else
+			XFS_BUF_UNORDERED(bp);
 		dptr = XFS_BUF_PTR(bp);
 		/*
 		 * Bump the cycle numbers at the start of each block
