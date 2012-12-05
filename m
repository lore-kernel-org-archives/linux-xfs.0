Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB5GhQiM030140 for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 10:43:27 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uJBuEB1YSUyyKLBb for
	<xfs@oss.sgi.com>; Wed, 05 Dec 2012 08:45:50 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qB5GjmjZ022685
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 11:45:48 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id qB5Gjlrq014631
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 11:45:47 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/4] xfs: add quota-driven speculative preallocation throttling
Date: Wed,  5 Dec 2012 11:47:57 -0500
Message-Id: <1354726078-31793-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1354726078-31793-1-git-send-email-bfoster@redhat.com>
References: <1354726078-31793-1-git-send-email-bfoster@redhat.com>
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

Speculative preallocation currently occurs based on the size of a
file (8GB max) and is throttled only within 5% of ENOSPC. Enable
similar throttling as an inode approaches EDQUOT.

Preallocation is throttled to a quota hard limit and disabled if
the hard limit is surpassed (noenforce). If a soft limit is also
specified, it serves as a low watermark to enable throttling and is
used to adjust the percentage of free quota space a single
preallocation is allowed to consume (5% by default).

The algorithm determines the max percentage allowed for each quota
and calculates the associated raw values. The minimum raw value
across all quotas applicable to the inode represents the maximum
size allowed for a preallocation on that inode.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_iomap.h |    2 +
 2 files changed, 115 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d381326..bbeec02 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -42,6 +42,8 @@
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
@@ -311,10 +313,110 @@ xfs_iomap_eof_want_preallocate(
 }
 
 /*
+ * Return the maximum size preallocation allowed for a particular dquot. 
+ *
+ * Quota throttling is enabled when a hard limit is defined. By default, a
+ * preallocation is allowed to consume no more than 5% of available space in
+ * the quota.
+ *
+ * If a soft limit is also defined, quota throttling is not enabled until the
+ * requested preallocation surpasses the soft limit. The throttling percentage
+ * is also redefined to equal the difference between the soft and hard limits
+ * over the hard limit (i.e., (hard - soft) / hard).
+ *
+ * -1 is returned if no throttling is required. 0 is returned if preallocation
+ *  should be disabled.
+ */
+STATIC int64_t
+xfs_prealloc_dquot_max(
+	struct xfs_dquot	*dq,
+	xfs_fsblock_t		alloc_blocks)
+{
+	xfs_qcnt_t		hardlimit;
+	xfs_qcnt_t		softlimit;
+	int64_t			free;
+	int64_t			pct = XFS_DEFAULT_QTHROTTLE_PCT;
+
+	if (!dq)
+		return -1;
+
+	hardlimit = be64_to_cpu(dq->q_core.d_blk_hardlimit);
+	softlimit = be64_to_cpu(dq->q_core.d_blk_softlimit);
+
+	if (!hardlimit)
+		return -1;
+
+	/* disable preallocation if we're over the hard limit */
+	free = hardlimit - dq->q_res_bcount;
+	if (free < 0) 
+		return 0;
+
+	/* disable throttling if we're under the soft limit */
+	if (softlimit && (dq->q_res_bcount + alloc_blocks) < softlimit)
+		return -1;
+
+	/*
+	 * If specified, use the difference between the soft and hard limits
+	 * over the hard limit to determine the throttling percentage. The
+	 * throttling percentage determines how much of the quota free space a
+	 * single preallocation can consume.
+	 */
+	if (softlimit) {
+		pct = (hardlimit - softlimit) * 100;
+		do_div(pct, hardlimit);
+	}
+	ASSERT(pct >= 0 && pct <= 100);
+
+	do_div(free, 100);
+	free *= pct;
+
+	return free;
+}
+
+/*
+ * Apply the quota preallocation throttling algorithm to each enabled quota and
+ * return the most restrictive value. The return value is the maximum size
+ * preallocation allowed for the inode.
+ */
+STATIC int64_t
+xfs_prealloc_quota_max(
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		alloc_blocks)
+{
+	int64_t			free;
+	int64_t 		min_free = -1;
+	struct xfs_dquot	*dq;
+
+	if (XFS_IS_UQUOTA_ON(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQ_USER);
+		free = xfs_prealloc_dquot_max(dq, alloc_blocks);
+		if (free != -1 && (free < min_free || min_free == -1))
+			min_free = free;
+	}
+
+	if (XFS_IS_GQUOTA_ON(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQ_GROUP);
+		free = xfs_prealloc_dquot_max(dq, alloc_blocks);
+		if (free != -1 && (free < min_free || min_free == -1))
+			min_free = free;
+	}
+
+	if (XFS_IS_PQUOTA_ON(ip->i_mount)) {
+		dq = xfs_inode_dquot(ip, XFS_DQ_PROJ);
+		free = xfs_prealloc_dquot_max(dq, alloc_blocks);
+		if (free != -1 && (free < min_free || min_free == -1))
+			min_free = free;
+	}
+
+	return min_free;
+}
+
+/*
  * If we don't have a user specified preallocation size, dynamically increase
  * the preallocation size as the size of the file grows. Cap the maximum size
  * at a single extent or less if the filesystem is near full. The closer the
- * filesystem is to full, the smaller the maximum prealocation.
+ * filesystem is to full or a hard quota limit, the smaller the maximum
+ * preallocation.
  */
 STATIC xfs_fsblock_t
 xfs_iomap_prealloc_size(
@@ -324,6 +426,7 @@ xfs_iomap_prealloc_size(
 	xfs_fsblock_t		alloc_blocks = 0;
 	int			shift = 0;
 	int64_t			freesp;
+	int64_t                 max_quota_prealloc;
 
 	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
 		goto check_writeio;
@@ -348,6 +451,15 @@ xfs_iomap_prealloc_size(
 		if (freesp < mp->m_low_space[XFS_LOWSP_1_PCNT])
 			shift++;
 	}
+
+	/*
+	 * Throttle speculative allocation against the most restrictive quota
+	 * limit.
+	 */
+	max_quota_prealloc = xfs_prealloc_quota_max(ip, alloc_blocks);
+
+	if (max_quota_prealloc >= 0 && alloc_blocks >= max_quota_prealloc)
+		alloc_blocks = max_quota_prealloc;
 	if (shift)
 		alloc_blocks >>= shift;
 	if (alloc_blocks)
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 8061576..07d79ea 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -18,6 +18,8 @@
 #ifndef __XFS_IOMAP_H__
 #define __XFS_IOMAP_H__
 
+#define XFS_DEFAULT_QTHROTTLE_PCT 5	/* default quota throttling % */
+
 struct xfs_inode;
 struct xfs_bmbt_irec;
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
