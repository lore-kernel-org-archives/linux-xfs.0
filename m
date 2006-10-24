Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 00:21:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9O7LhaG004610
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 00:21:45 -0700
Date: Tue, 24 Oct 2006 17:20:54 +1000
From: David Chinner <dgc@sgi.com>
Subject: [REVIEW 3 of 4] Fix recalim handling in xfs_iget_core
Message-ID: <20061024072054.GT11034@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: t-nagano@ah.jp.nec.com, xfs-dev@sgi.com


-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


Fix the xfs_iget_core() handling of the XFS_IRECLAIMABLE flag so it
doesn't violate the guarantee we need to provide to xfs_iunpin()
w.r.t. the existence of a linux inode.

---
 fs/xfs/xfs_iget.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2006-10-19 10:25:07.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2006-10-19 10:29:26.460972850 +1000
@@ -238,6 +238,34 @@ again:
 					goto again;
 				}
 
+				/*
+				 * If IRECLAIMABLE is set on this inode and lookup is
+				 * racing with unlink, then we should return an error
+				 * immediately so we don't remove it from the reclaim
+				 * list and potentially leak the inode.
+				 *
+				 * Also, there may be transactions sitting in the
+				 * incore log buffers or being flushed to disk at this
+				 * time.  We can't clear the XFS_IRECLAIMABLE flag
+				 * until these transactions have hit the disk,
+				 * otherwise we will void the guarantee the flag
+				 * provides xfs_iunpin()
+				 */
+				if (xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
+					if ((ip->i_d.di_mode == 0) &&
+					    !(flags & XFS_IGET_CREATE)) {
+						read_unlock(&ih->ih_lock);
+							return ENOENT;
+					}
+					if (xfs_ipincount(ip)) {
+						read_unlock(&ih->ih_lock);
+						xfs_log_force(mp, 0,
+							XFS_LOG_FORCE|XFS_LOG_SYNC);
+						XFS_STATS_INC(xs_ig_frecycle);
+						goto again;
+					}
+				}
+
 				vn_trace_exit(vp, "xfs_iget.alloc",
 					(inst_t *)__return_address);
 
