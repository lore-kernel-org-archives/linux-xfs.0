Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C31C7F47
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 09:49:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 235488F804B
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 07:49:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JQjxEXyvDbEDBRBs for
	<xfs@oss.sgi.com>; Tue, 03 Jun 2014 07:49:41 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s53EndkK017574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 10:49:39 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s53Endjm032669
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 10:49:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 3/4] xfs: run an eofblocks scan on ENOSPC/EDQUOT
Date: Tue,  3 Jun 2014 10:49:37 -0400
Message-Id: <1401806978-59205-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1401806978-59205-1-git-send-email-bfoster@redhat.com>
References: <1401806978-59205-1-git-send-email-bfoster@redhat.com>
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

Speculative preallocation and and the associated throttling metrics
assume we're working with large files on large filesystems. Users have
reported inefficiencies in these mechanisms when we happen to be dealing
with large files on smaller filesystems. This can occur because while
prealloc throttling is aggressive under low free space conditions, it is
not active until we reach 5% free space or less.

For example, a 40GB filesystem has enough space for several files large
enough to have multi-GB preallocations at any given time. If those files
are slow growing, they might reserve preallocation for long periods of
time as well as avoid the background scanner due to frequent
modification. If a new file is written under these conditions, said file
has no access to this already reserved space and premature ENOSPC is
imminent.

To handle this scenario, modify the buffered write ENOSPC handling and
retry sequence to invoke an eofblocks scan. In the smaller filesystem
scenario, the eofblocks scan resets the usage of preallocation such that
when the 5% free space threshold is met, throttling effectively takes
over to provide fair and efficient preallocation until legitimate
ENOSPC.

The eofblocks scan is selective based on the nature of the failure. For
example, an EDQUOT failure in a particular quota will use a filtered
scan for that quota. Because we don't know which quota might have caused
an allocation failure at any given time, we include each applicable
quota determined to be under low free space conditions in the scan.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot.h  | 15 +++++++++++++++
 fs/xfs/xfs_file.c   | 23 +++++++++++++++++++----
 fs/xfs/xfs_icache.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.h |  1 +
 4 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 68a68f7..c24c67e 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -139,6 +139,21 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
 	}
 }
 
+/*
+ * Check whether a dquot is under low free space conditions. We assume the quota
+ * is enabled and enforced.
+ */
+static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
+{
+	int64_t freesp;
+
+	freesp = be64_to_cpu(dqp->q_core.d_blk_hardlimit) - dqp->q_res_bcount;
+	if (freesp < dqp->q_low_space[XFS_QLOWSP_1_PCNT])
+		return true;
+
+	return false;
+}
+
 #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1b8160d..2e0e73b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -38,6 +38,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_dinode.h"
+#include "xfs_icache.h"
 
 #include <linux/aio.h>
 #include <linux/dcache.h>
@@ -741,14 +742,28 @@ write_retry:
 	ret = generic_perform_write(file, &from, pos);
 	if (likely(ret >= 0))
 		iocb->ki_pos = pos + ret;
+
 	/*
-	 * If we just got an ENOSPC, try to write back all dirty inodes to
-	 * convert delalloc space to free up some of the excess reserved
-	 * metadata space.
+	 * If we hit a space limit, try to free up some lingering preallocated
+	 * space before returning an error. In the case of ENOSPC, first try to
+	 * write back all dirty inodes to free up some of the excess reserved
+	 * metadata space. This reduces the chances that the eofblocks scan
+	 * waits on dirty mappings. Since xfs_flush_inodes() is serialized, this
+	 * also behaves as a filter to prevent too many eofblocks scans from
+	 * running at the same time.
 	 */
-	if (ret == -ENOSPC && !enospc) {
+	if (ret == -EDQUOT && !enospc) {
+		enospc = xfs_inode_free_quota_eofblocks(ip);
+		if (enospc)
+			goto write_retry;
+	} else if (ret == -ENOSPC && !enospc) {
+		struct xfs_eofblocks eofb = {0};
+
 		enospc = 1;
 		xfs_flush_inodes(ip->i_mount);
+		eofb.eof_scan_owner = ip->i_ino; /* for locking */
+		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
+		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
 		goto write_retry;
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6be93e7..35eb658 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -33,6 +33,9 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_bmap_util.h"
+#include "xfs_quota.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -1300,6 +1303,55 @@ xfs_icache_free_eofblocks(
 					 eofb, XFS_ICI_EOFBLOCKS_TAG);
 }
 
+/*
+ * Run eofblocks scans on the quotas applicable to the inode. For inodes with
+ * multiple quotas, we don't know exactly which quota caused an allocation
+ * failure. We make a best effort by including each quota under low free space
+ * conditions (less than 1% free space) in the scan.
+ */
+int
+xfs_inode_free_quota_eofblocks(
+	struct xfs_inode *ip)
+{
+	int scan = 0;
+	struct xfs_eofblocks eofb = {0};
+	struct xfs_dquot *dq;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+
+	/*
+	 * Set the scan owner to avoid a potential livelock. Otherwise, the scan
+	 * can repeatedly trylock on the inode we're currently processing. We
+	 * run a sync scan to increase effectiveness and use the union filter to
+	 * cover all applicable quotas in a single scan.
+	 */
+	eofb.eof_scan_owner = ip->i_ino;
+	eofb.eof_flags = XFS_EOF_FLAGS_UNION|XFS_EOF_FLAGS_SYNC;
+
+	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQ_USER);
+		if (dq && xfs_dquot_lowsp(dq)) {
+			eofb.eof_uid = VFS_I(ip)->i_uid;
+			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
+			scan = 1;
+		}
+	}
+
+	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQ_GROUP);
+		if (dq && xfs_dquot_lowsp(dq)) {
+			eofb.eof_gid = VFS_I(ip)->i_gid;
+			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
+			scan = 1;
+		}
+	}
+
+	if (scan)
+		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+
+	return scan;
+}
+
 void
 xfs_inode_set_eofblocks_tag(
 	xfs_inode_t	*ip)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 152757f..b432d83 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -58,6 +58,7 @@ void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
+int xfs_inode_free_quota_eofblocks(struct xfs_inode *ip);
 void xfs_eofblocks_worker(struct work_struct *);
 
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
