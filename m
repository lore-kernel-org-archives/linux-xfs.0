Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 18:43:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3O1gvfB030392
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 18:42:59 -0700
Date: Tue, 24 Apr 2007 11:42:49 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review - flush blockdev on close
Message-ID: <20070424014249.GF48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


As suggested by Christoph, we probably should flush the block
device as we complete the process of unmounting the filesystem.
Patch attached.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_buf.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-04-24 09:32:22.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c	2007-04-24 11:12:42.181361346 +1000
@@ -1464,6 +1464,7 @@ xfs_free_buftarg(
 	int			external)
 {
 	xfs_flush_buftarg(btp, 1);
+	xfs_blkdev_issue_flush(btp);
 	if (external)
 		xfs_blkdev_put(btp->bt_bdev);
 	xfs_free_bufhash(btp);
