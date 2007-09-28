Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 01:00:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8S80J8r018845
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 01:00:22 -0700
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA05657 for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 18:00:18 +1000
Message-ID: <46FCB57C.1040204@sgi.com>
Date: Fri, 28 Sep 2007 18:04:12 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Ensure sync flushes all dirty data to disk
Content-Type: multipart/mixed;
 boundary="------------060608020509020208080001"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------060608020509020208080001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

In xfs_fs_sync_super() treat a sync the same as a filesystem freeze.
This is needed to force the log to disk for inodes which are not marked
dirty in the Linux inode (the inodes are marked dirty on completion of
the log I/O) and so sync_inodes() will not flush them.

In xfs_fs_write_inode() a synchronous flush will not get an EAGAIN
from xfs_inode_flush() and if an asynchronous flush returns EAGAIN
we should pass it on to the caller.  If we get an error while flushing
the inode then re-dirty it so we can try again later.

--------------060608020509020208080001
Content-Type: text/x-patch;
 name="sync.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sync.diff"

--- fs/xfs/linux-2.6/xfs_super.c_1.398	2007-09-28 12:37:17.000000000 +1000
+++ fs/xfs/linux-2.6/xfs_super.c	2007-09-28 17:22:24.000000000 +1000
@@ -409,13 +409,8 @@ xfs_fs_write_inode(
 		flags |= FLUSH_SYNC;
 	}
 	error = xfs_inode_flush(XFS_I(inode), flags);
-	if (error == EAGAIN) {
-		if (sync)
-			error = xfs_inode_flush(XFS_I(inode),
-						       flags | FLUSH_LOG);
-		else
-			error = 0;
-	}
+	if (error)
+		mark_inode_dirty_sync(inode);
 
 	return -error;
 }
@@ -620,7 +615,7 @@ xfs_fs_sync_super(
 	int			error;
 	int			flags;
 
-	if (unlikely(sb->s_frozen == SB_FREEZE_WRITE)) {
+	if (wait || unlikely(sb->s_frozen == SB_FREEZE_WRITE)) {
 		/*
 		 * First stage of freeze - no more writers will make progress
 		 * now we are here, so we flush delwri and delalloc buffers
@@ -631,7 +626,7 @@ xfs_fs_sync_super(
 		 */
 		flags = SYNC_DATA_QUIESCE;
 	} else
-		flags = SYNC_FSDATA | (wait ? SYNC_WAIT : 0);
+		flags = SYNC_FSDATA;
 
 	error = xfs_sync(mp, flags);
 	sb->s_dirt = 0;

--------------060608020509020208080001--
