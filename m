Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B6A647F55
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 09:52:19 -0500 (CDT)
Received: from eagdhcp-232-174.americas.sgi.com
	(eagdhcp-232-174.americas.sgi.com [128.162.232.174])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D6478F8049
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 07:52:19 -0700 (PDT)
Received: from eagdhcp-232-174.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-174.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s62EqFer005637
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2014 09:52:15 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-174.americas.sgi.com)
Message-Id: <20140702144139.894251516@sgi.com>
Date: Wed, 02 Jul 2014 09:32:10 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 4/5] xfs: free inodes on log recovery error
References: <20140702143206.438456679@sgi.com>
Content-Disposition: inline; filename=xfs-reclaim-inodes-on-recovery-fail.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Recovery may free inodes that end up on the inode
reclaim RCU. If recovery fails, we leak these inodes.
The filesystem should be in forced shutdown at this
point, so a call to xfs_reclaim_inode is a fast path
to freeing the inodes and RCU entries.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log.c   |    2 ++
 fs/xfs/xfs_mount.c |    1 +
 2 files changed, 3 insertions(+)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -31,6 +31,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 #include "xfs_inode.h"
+#include "xfs_icache.h"
 #include "xfs_trace.h"
 #include "xfs_fsops.h"
 #include "xfs_cksum.h"
@@ -720,6 +721,7 @@ xfs_log_mount(
 	return 0;
 
 out_destroy_ail:
+	xfs_reclaim_inodes(mp, SYNC_WAIT);
 	xfs_trans_ail_destroy(mp);
 out_free_log:
 	xlog_dealloc_log(mp->m_log);
Index: b/fs/xfs/xfs_mount.c
===================================================================
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -980,6 +980,7 @@ xfs_mountfs(
  out_log_dealloc:
 	xfs_log_unmount(mp);
  out_fail_wait:
+	xfs_reclaim_inodes(mp, SYNC_WAIT);
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_wait_buftarg(mp->m_logdev_targp);
 	xfs_wait_buftarg(mp->m_ddev_targp);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
