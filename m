Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Oct 2007 00:29:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l997Tcix012667
	for <xfs@oss.sgi.com>; Tue, 9 Oct 2007 00:29:40 -0700
Message-ID: <470B2EEC.5020906@sgi.com>
Date: Tue, 09 Oct 2007 17:34:04 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH V2] Ensure sync flushes all dirty data to disk]
Content-Type: multipart/mixed;
 boundary="------------010900060503050001080908"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------010900060503050001080908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

[V2 adds a comment for dgc]

In xfs_fs_sync_super() treat a sync the same as a filesystem freeze.
This is needed to force the log to disk for inodes which are not marked
dirty in the Linux inode (the inodes are marked dirty on completion of
the log I/O) and so sync_inodes() will not flush them.

In xfs_fs_write_inode() a synchronous flush will not get an EAGAIN
from xfs_inode_flush() and if an asynchronous flush returns EAGAIN
we should pass it on to the caller.  If we get an error while flushing
the inode then re-dirty it so we can try again later.

Lachlan

--------------010900060503050001080908
Content-Type: text/x-patch;
 name="sync.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sync.diff"

--- fs/xfs/linux-2.6/xfs_super.c_1.400	2007-10-03 17:17:21.000000000 +1000
+++ fs/xfs/linux-2.6/xfs_super.c	2007-10-09 17:31:36.000000000 +1000
@@ -410,13 +410,12 @@ xfs_fs_write_inode(
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
+	/*
+	 * if we failed to write out the inode then mark
+	 * it dirty again so we'll try again later.
+	 */
+	if (error)
+		mark_inode_dirty_sync(inode);
 
 	return -error;
 }
@@ -621,7 +620,19 @@ xfs_fs_sync_super(
 	int			error;
 	int			flags;
 
-	if (unlikely(sb->s_frozen == SB_FREEZE_WRITE)) {
+	/*
+	 * Treat a sync operation like a freeze.  This is to work
+	 * around a race in sync_inodes() which works in two phases
+	 * - an asynchronous flush, which can write out an inode
+	 * without waiting for file size updates to complete, and a
+	 * synchronous flush, which wont do anything because the
+	 * async flush removed the inode's dirty flag.  Also
+	 * sync_inodes() will not see any files that just have
+	 * outstanding transactions to be flushed because we don't
+	 * dirty the Linux inode until after the transaction I/O
+	 * completes.
+	 */
+	if (wait || unlikely(sb->s_frozen == SB_FREEZE_WRITE)) {
 		/*
 		 * First stage of freeze - no more writers will make progress
 		 * now we are here, so we flush delwri and delalloc buffers
@@ -632,7 +643,7 @@ xfs_fs_sync_super(
 		 */
 		flags = SYNC_DATA_QUIESCE;
 	} else
-		flags = SYNC_FSDATA | (wait ? SYNC_WAIT : 0);
+		flags = SYNC_FSDATA;
 
 	error = xfs_sync(mp, flags);
 	sb->s_dirt = 0;

--------------010900060503050001080908--
