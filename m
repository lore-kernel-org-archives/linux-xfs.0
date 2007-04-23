Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Apr 2007 17:31:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3N0VnfB028244
	for <xfs@oss.sgi.com>; Sun, 22 Apr 2007 17:31:51 -0700
Date: Mon, 23 Apr 2007 10:31:42 +1000
From: David Chinner <dgc@sgi.com>
Subject: review: don't block non-blocking setattr when frozen
Message-ID: <20070423003142.GZ32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


Prevent nfsds from blocking doing on setattr calls (i.e. truncates)
when the filesystem is frozen or being frozen.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_vnodeops.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-01-31 13:56:03.781573432 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-01-31 13:56:13.428316729 +1100
@@ -281,6 +281,12 @@ xfs_setattr(
 		return XFS_ERROR(EINVAL);
 	}
 
+	/*
+	 * Don't block if the filesystem is frozen.
+	 */
+	if ((flags & ATTR_NONBLOCK) && vfs_test_for_freeze(vp->v_vfsp))
+		return XFS_ERROR(EAGAIN);
+
 	ip = XFS_BHVTOI(bdp);
 	mp = ip->i_mount;
 
