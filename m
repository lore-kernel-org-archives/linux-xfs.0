Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7KjOiK251940 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 14:45:24 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vyHY4QTcYTM8wvz1 for
	<xfs@oss.sgi.com>; Fri, 07 Dec 2012 12:47:50 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qB7KlnKp014145
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 15:47:49 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id qB7KlnqA021348
	for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 15:47:49 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] xfs: run a filtered eofblocks scan on edquot/enospc
Date: Fri,  7 Dec 2012 15:49:56 -0500
Message-Id: <1354913396-42206-1-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

EDQUOT occurs in the buffered write path on user or group quota
allocation failures (project quotas currently use ENOSPC). For
inodes in multiple quotas, we do not know which quota might have
led to the failure. We also cannot technically discern project
quota ENOSPC from global ENOSPC. Therefore, we check the state of
each quota applicable to the inode and run an eofblocks scan on
each considered to be under limited free space conditions.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c   |   14 +++++++++++
 fs/xfs/xfs_icache.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.h |    1 +
 3 files changed, 81 insertions(+), 0 deletions(-)

Hi guys,

Here's an RFC that covers the recently discussed integration of eofblocks
scanning into EDQUOT/ENOSPC error handling. This is incomplete and only spot
tested against user quotas because I wanted to get some feedback on the approach
before I proceed.

My biggest question at this point is whether this is the best layer to include
this behavior (i.e., in xfs_file_buffered_aio_write() where we've lost
quota-related context on the error). An alternative approach I considered was to
bury a scan/retry down in xfs_trans_dquot.c (i.e., in or around
xfs_trans_reserve_quota_bydquots()), where the specific failure context is
available. That would result in the higher level buffered write code remaining the
same and only receiving an EDQUOT if we've already done the retry and failed. Any
thoughts on that are appreciated.

Brian

TODOs:
- I'm not a huge fan of the name of xfs_inode_free_quota_eofblocks(), but haven't
  thought of anything better yet. :)
- Turn the quota checking into a range check (i.e., reserved blocks within %1 of
  the limit) and bury it in a 'xfs_quota_is_full()' macro somewhere.
- Enhance eofblocks to support a flush operation and enable that in the project
  quota ENOSPC case.
- It just occurred to me when looking this over I might need to use the
  XFS_IS_*QUOTA_ENFORCED macros around the quota space checks.

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 67284ed..505b9fb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -35,6 +35,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 #include <linux/dcache.h>
 #include <linux/falloc.h>
@@ -716,6 +717,7 @@ xfs_file_buffered_aio_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
 	int			enospc = 0;
+	int			edquot = 0;
 	int			iolock = XFS_IOLOCK_EXCL;
 	size_t			count = ocount;
 
@@ -734,6 +736,18 @@ write_retry:
 			pos, &iocb->ki_pos, count, 0);
 
 	/*
+	 * A quota failure can be represented as EDQUOT or ENOSPC in the case
+	 * of project quotas. Check the quotas explicitly for low space
+	 * conditions, run a prealloc scan if warranted and retry. Otherwise,
+	 * proceed to general ENOSPC handling.
+	 */
+	if ((ret == -EDQUOT || ret == -ENOSPC) && !edquot) {
+		edquot = 1;
+		if (xfs_inode_free_quota_eofblocks(ip))
+			goto write_retry;
+	}
+
+	/*
 	 * If we just got an ENOSPC, try to write back all dirty inodes to
 	 * convert delalloc space to free up some of the excess reserved
 	 * metadata space.
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 96e344e..259d9a2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -37,6 +37,9 @@
 #include "xfs_trace.h"
 #include "xfs_fsops.h"
 #include "xfs_icache.h"
+#include "xfs_quota.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -1274,6 +1277,69 @@ xfs_icache_free_eofblocks(
 					 eofb, XFS_ICI_EOFBLOCKS_TAG);
 }
 
+/*
+ * Scan the quotas applicable to the inode that are under low space conditions.
+ */
+int
+xfs_inode_free_quota_eofblocks(
+	struct xfs_inode *ip)
+{
+	int scanned = 0;
+	struct xfs_eofblocks eofb = {0,};
+	xfs_dquot_t *dq;
+
+	/*
+	 * For an inode with multiple quotas, we technically don't know
+	 * which caused failure. We make a best effort by comparing each
+	 * quota's reserved count to its block limit.
+	 *
+	 * TODO: Perhaps a better heuristic (i.e., within a percentage
+	 * of the limit) and an associated wrapper function would clean
+	 * this up. In my 32 thread write test, the == comparison is
+	 * not as effective as blindly scanning each quota, but still
+	 * quite good.
+	 */
+
+	if (XFS_IS_UQUOTA_ON(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQ_USER);
+		if (dq && dq->q_res_bcount ==
+				be64_to_cpu(dq->q_core.d_blk_hardlimit)) {
+			eofb.eof_uid = ip->i_d.di_uid;
+			eofb.eof_flags = XFS_EOF_FLAGS_SYNC|
+					 XFS_EOF_FLAGS_UID;
+			xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+			scanned = 1;
+		}
+	}
+
+	if (XFS_IS_GQUOTA_ON(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQ_GROUP);
+		if (dq && dq->q_res_bcount ==
+				be64_to_cpu(dq->q_core.d_blk_hardlimit)) {
+			eofb.eof_gid = ip->i_d.di_gid;
+			eofb.eof_flags = XFS_EOF_FLAGS_SYNC|
+					 XFS_EOF_FLAGS_GID;
+			xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+			scanned = 1;
+		}
+	}
+
+	if (XFS_IS_PQUOTA_ON(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQ_PROJ);
+		if (dq && dq->q_res_bcount ==
+				be64_to_cpu(dq->q_core.d_blk_hardlimit)) {
+			/* TODO: This needs to support a flush. */
+			eofb.eof_prid = xfs_get_projid(ip);
+			eofb.eof_flags = XFS_EOF_FLAGS_SYNC|
+					 XFS_EOF_FLAGS_PRID;
+			xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+			scanned = 1;
+		}
+	}
+
+	return scanned;
+}
+
 void
 xfs_inode_set_eofblocks_tag(
 	xfs_inode_t	*ip)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index e0f138c..0488f0a 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -38,6 +38,7 @@ void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
+int xfs_inode_free_quota_eofblocks(struct xfs_inode *ip);
 void xfs_eofblocks_worker(struct work_struct *);
 
 int xfs_sync_inode_grab(struct xfs_inode *ip);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
