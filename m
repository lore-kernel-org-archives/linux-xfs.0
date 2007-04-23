Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Apr 2007 17:26:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3N0QMfB026825
	for <xfs@oss.sgi.com>; Sun, 22 Apr 2007 17:26:24 -0700
Date: Mon, 23 Apr 2007 10:26:16 +1000
From: David Chinner <dgc@sgi.com>
Subject: review: don't block non-blocking writes when frozen
Message-ID: <20070423002616.GY32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


Prevent nfsds for blocking trying to write to a frozen filesystem
or a filesystem in the process of freezing.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_lrw.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-03-29 19:03:30.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_lrw.c	2007-03-29 19:08:06.262169809 +1000
@@ -684,6 +684,10 @@ xfs_write(
 	io = &xip->i_iocore;
 	mp = io->io_mount;
 
+	if (FILP_DELAY_FLAG(file) && vfs_test_for_freeze(vp->v_vfsp)) {
+		/* so nfsd can return EJUKEBOX to clients during a freeze */
+		return -EAGAIN;
+	}
 	vfs_wait_for_freeze(vp->v_vfsp, SB_FREEZE_WRITE);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
