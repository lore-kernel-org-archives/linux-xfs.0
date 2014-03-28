Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9872B7F6B
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 08:16:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 68FF68F804C
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 06:16:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BBfdmUctMBVNIiaS for
	<xfs@oss.sgi.com>; Fri, 28 Mar 2014 06:16:05 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2SDG5mp029660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 09:16:05 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s2SDG5pn003797
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 09:16:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/5] xfs: run an eofblocks scan on ENOSPC/EDQUOT
Date: Fri, 28 Mar 2014 09:16:02 -0400
Message-Id: <1396012563-60973-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1396012563-60973-1-git-send-email-bfoster@redhat.com>
References: <1396012563-60973-1-git-send-email-bfoster@redhat.com>
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
retry sequence to invoke an eofblocks scan. The eofblocks scan is
attempted prior to the inode flush as it is lighter weight and the
former is a last resort to free space. In the smaller filesystem
scenario, the eofblocks scan resets the usage of preallocation such that
when the 5% free space threshold is met, throttling effectively takes
over to provide fair and efficient preallocation until legitimate
ENOSPC.

The eofblocks scan is selective based on the nature of the failure. For
example, an EDQUOT failure in a particular quota will use a filtered
scan for that quota. Because we don't know which quota might have caused
an allocation failure at any given time, we run a scan against each
applicable quota determined to be under low free space conditions.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot.h  | 15 ++++++++++++++
 fs/xfs/xfs_file.c   | 32 ++++++++++++++++++++++++++---
 fs/xfs/xfs_icache.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.h |  1 +
 4 files changed, 104 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index d22ed00..899b99f 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -141,6 +141,21 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
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
index 2e7989e..1ca16ce 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -38,6 +38,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_dinode.h"
+#include "xfs_icache.h"
 
 #include <linux/aio.h>
 #include <linux/dcache.h>
@@ -723,6 +724,7 @@ xfs_file_buffered_aio_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
 	int			enospc = 0;
+	int			scanned = 0;
 	int			iolock = XFS_IOLOCK_EXCL;
 	size_t			count = ocount;
 
@@ -741,10 +743,34 @@ write_retry:
 			pos, &iocb->ki_pos, count, 0);
 
 	/*
-	 * If we just got an ENOSPC, try to write back all dirty inodes to
-	 * convert delalloc space to free up some of the excess reserved
-	 * metadata space.
+	 * If we hit ENOSPC or a quota limit, use the selective nature of the
+	 * eofblocks scan to try and free up some lingering speculative
+	 * preallocation delalloc blocks.
+	 *
+	 * If we hit a quota limit, only scan for files covered by the quota. We
+	 * also consider ENOSPC here because project quota failure can return
+	 * ENOSPC instead of EDQUOT. The quota scanning only sets 'scanned' if
+	 * the inode is covered by a quota with low free space. This should
+	 * minimize interference with global ENOSPC handling.
+	 *
+	 * If a scan does not free enough space, resort to the inode flush big
+	 * hammer to convert delalloc space to free up some of the excess
+	 * reserved metadata space.
 	 */
+	if ((ret == -EDQUOT || ret == -ENOSPC) && !scanned) {
+		scanned = xfs_inode_free_quota_eofblocks(ip);
+		if (scanned)
+			goto write_retry;
+	}
+	if (ret == -ENOSPC && !scanned) {
+		struct xfs_eofblocks eofb = {0,};
+
+		eofb.eof_scan_owner = ip->i_ino; /* for locking */
+		eofb.eof_flags = XFS_EOF_FLAGS_SYNC | XFS_EOF_FLAGS_FLUSH;
+		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+		scanned = 1;
+		goto write_retry;
+	}
 	if (ret == -ENOSPC && !enospc) {
 		enospc = 1;
 		xfs_flush_inodes(ip->i_mount);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index bd0ab7d..471ccfa 100644
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
@@ -1277,6 +1280,62 @@ xfs_icache_free_eofblocks(
 					 eofb, XFS_ICI_EOFBLOCKS_TAG);
 }
 
+/*
+ * Run eofblocks scans on the quotas applicable to the inode. For inodes with
+ * multiple quotas, we don't know exactly which quota caused an allocation
+ * failure. We make a best effort by running scans for each quota considered
+ * to be under low free space conditions (less than 1% available free space).
+ */
+int
+xfs_inode_free_quota_eofblocks(
+	struct xfs_inode *ip)
+{
+	int scanned = 0;
+	struct xfs_eofblocks eofb = {0,};
+	struct xfs_dquot *dq;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+
+	/* set the scan owner to avoid potential livelock */
+	eofb.eof_scan_owner = ip->i_ino;
+
+	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQ_USER);
+		if (dq && xfs_dquot_lowsp(dq)) {
+			eofb.eof_uid = VFS_I(ip)->i_uid;
+			eofb.eof_flags = XFS_EOF_FLAGS_SYNC|
+					 XFS_EOF_FLAGS_UID;
+			xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+			scanned = 1;
+		}
+	}
+
+	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQ_GROUP);
+		if (dq && xfs_dquot_lowsp(dq)) {
+			eofb.eof_gid = VFS_I(ip)->i_gid;
+			eofb.eof_flags = XFS_EOF_FLAGS_SYNC|
+					 XFS_EOF_FLAGS_GID;
+			xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+			scanned = 1;
+		}
+	}
+
+	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQ_PROJ);
+		if (dq && xfs_dquot_lowsp(dq)) {
+			eofb.eof_prid = xfs_get_projid(ip);
+			eofb.eof_flags = XFS_EOF_FLAGS_SYNC|
+					 XFS_EOF_FLAGS_PRID|
+					 XFS_EOF_FLAGS_FLUSH;
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
index 4387b1d..23aa163 100644
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
