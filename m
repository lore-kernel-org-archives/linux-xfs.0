Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Sep 2007 20:04:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8334n4p002820
	for <xfs@oss.sgi.com>; Sun, 2 Sep 2007 20:04:52 -0700
Message-ID: <46DB7A60.4050203@sgi.com>
Date: Mon, 03 Sep 2007 13:07:12 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] ensure file size is logged on synchronous writes
Content-Type: multipart/mixed;
 boundary="------------060907010105080008020904"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------060907010105080008020904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Synchronous writes currently log inode changes before syncing
pages to disk.  Since the file size is updated on I/O completion
we wont be writing out the updated file size and if we crash the
file will have the wrong size.  This change moves the logging
after the syncing of the pages to ensure we log the correct file
size.

Lachlan

--------------060907010105080008020904
Content-Type: text/x-patch;
 name="xfs_write.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_write.diff"

--- fs/xfs/linux-2.6/xfs_lrw.c_1.266	2007-08-30 17:38:53.000000000 +1000
+++ fs/xfs/linux-2.6/xfs_lrw.c	2007-08-31 15:38:49.000000000 +1000
@@ -895,20 +895,19 @@ retry:
 
 	/* Handle various SYNC-type writes */
 	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
-		error = xfs_write_sync_logforce(mp, xip);
-		if (error)
-			goto out_unlock_internal;
-
+		int error2;
 		xfs_rwunlock(xip, locktype);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
-
-		error = sync_page_range(inode, mapping, pos, ret);
+		error2 = sync_page_range(inode, mapping, pos, ret);
 		if (!error)
-			error = -ret;
+			error = error2;
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
 		xfs_rwlock(xip, locktype);
+		error2 = xfs_write_sync_logforce(mp, xip);
+		if (!error)
+			error = error2;
 	}
 
  out_unlock_internal:

--------------060907010105080008020904--
