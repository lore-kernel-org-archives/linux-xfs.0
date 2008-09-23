Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 21:54:55 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8N4sqpT007441
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 21:54:53 -0700
Message-ID: <48D87908.80408@sgi.com>
Date: Tue, 23 Sep 2008 15:05:12 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Wait for all I/O on truncate to zero file size
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

It's possible to have outstanding xfs_ioend_t's queued when the file
size is zero.  This can happen in the direct I/O path when a direct
I/O write fails due to ENOSPC.  In this case the xfs_ioend_t will still
be queued (ie xfs_end_io_direct() does not know that the I/O failed so
can't force the xfs_ioend_t to be flushed synchronously).

When we truncate a file on unlink we don't know to wait for these
xfs_ioend_ts and we can have a use-after-free situation if the inode
is reclaimed before the xfs_ioend_t is finally processed.

As was suggested by Dave Chinner lets wait for all I/Os to complete
when truncating the file size to zero.

--- a/fs/xfs/xfs_inode.c	2008-09-23 14:18:27.000000000 +1000
+++ b/fs/xfs/xfs_inode.c	2008-09-23 13:53:16.000000000 +1000
@@ -1449,7 +1449,7 @@ xfs_itruncate_start(
 	mp = ip->i_mount;
 
 	/* wait for the completion of any pending DIOs */
-	if (new_size < ip->i_size)
+	if (new_size == 0 || new_size < ip->i_size)
 		vn_iowait(ip);
 
 	/*
