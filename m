Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C8B877F61
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 09:07:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 492D6AC006
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 07:07:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D5axVUy5TgYPPprR for
	<xfs@oss.sgi.com>; Wed, 20 Feb 2013 07:07:47 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1KF7k09014111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 10:07:46 -0500
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r1KF7krU007709
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 10:07:46 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 5/6] xfs: add quota-driven speculative preallocation
	throttling
Date: Wed, 20 Feb 2013 10:10:18 -0500
Message-Id: <1361373019-30891-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1361373019-30891-1-git-send-email-bfoster@redhat.com>
References: <1361373019-30891-1-git-send-email-bfoster@redhat.com>
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

Introduce the need_throttle() and calc_throttle() functions to
independently check whether throttling is required for a particular
dquot and if so, calculate the associated throttling metrics based
on the state of the quota. We use the same general algorithm to
calculate the throttle shift as for global free space with the
exception of using three stages rather than five.

Update xfs_iomap_prealloc_size() to use the smallest available
prealloc size based on each of the constraints and apply the
maximum shift to obtain the throttled preallocation size.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index daa08f6..34640a3f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -42,6 +42,8 @@
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
@@ -366,6 +368,61 @@ xfs_iomap_eof_prealloc_initial_size(
 	return XFS_B_TO_FSB(mp, offset);
 }
 
+STATIC bool
+xfs_quota_need_throttle(
+	struct xfs_inode *ip,
+	int type,
+	xfs_fsblock_t alloc_blocks)
+{
+	struct xfs_dquot *dq = xfs_inode_dquot(ip, type);
+
+	if (!dq || !xfs_this_quota_on(ip->i_mount, type))
+		return false;
+
+	/* no hi watermark, no throttle */
+	if (!dq->q_prealloc_hi_wmark)
+		return false;
+
+	/* under the lo watermark, no throttle */
+	if (dq->q_res_bcount + alloc_blocks < dq->q_prealloc_lo_wmark)
+		return false;
+
+	return true;
+}
+
+STATIC void
+xfs_quota_calc_throttle(
+	struct xfs_inode *ip,
+	int type,
+	xfs_fsblock_t *qblocks,
+	int *qshift)
+{
+	int64_t freesp;
+	int shift = 0;
+	struct xfs_dquot *dq = xfs_inode_dquot(ip, type);
+
+	/* over hi wmark, squash the prealloc completely */
+	if (dq->q_res_bcount >= dq->q_prealloc_hi_wmark) {
+		*qblocks = 0;
+		return;
+	}
+
+	freesp = dq->q_prealloc_hi_wmark - dq->q_res_bcount;
+	if (freesp < dq->q_low_space[XFS_QLOWSP_5_PCNT]) {
+		shift = 2;
+		if (freesp < dq->q_low_space[XFS_QLOWSP_3_PCNT])
+			shift += 2;
+		if (freesp < dq->q_low_space[XFS_QLOWSP_1_PCNT])
+			shift += 2;
+	}
+
+	/* only overwrite the throttle values if we are more aggressive */
+	if ((freesp >> shift) < (*qblocks >> *qshift)) {
+		*qblocks = freesp;
+		*qshift = shift;
+	}
+}
+
 /*
  * If we don't have a user specified preallocation size, dynamically increase
  * the preallocation size as the size of the file grows. Cap the maximum size
@@ -383,11 +440,14 @@ xfs_iomap_prealloc_size(
 	xfs_fsblock_t		alloc_blocks = 0;
 	int			shift = 0;
 	int64_t			freesp;
+	xfs_fsblock_t		qblocks;
+	int			qshift = 0;
 
 	alloc_blocks = xfs_iomap_eof_prealloc_initial_size(mp, ip, offset,
 							   imap, nimaps);
 	if (!alloc_blocks)
 		goto check_writeio;
+	qblocks = alloc_blocks;
 
 	/*
 	 * MAXEXTLEN is not a power of two value but we round the prealloc down
@@ -412,6 +472,28 @@ xfs_iomap_prealloc_size(
 		if (freesp < mp->m_low_space[XFS_LOWSP_1_PCNT])
 			shift++;
 	}
+
+	/*
+	 * Check each quota to cap the prealloc size and provide a shift
+	 * value to throttle with.
+	 */
+	if (xfs_quota_need_throttle(ip, XFS_DQ_USER, alloc_blocks))
+		xfs_quota_calc_throttle(ip, XFS_DQ_USER, &qblocks, &qshift);
+	if (xfs_quota_need_throttle(ip, XFS_DQ_GROUP, alloc_blocks))
+		xfs_quota_calc_throttle(ip, XFS_DQ_GROUP, &qblocks, &qshift);
+	if (xfs_quota_need_throttle(ip, XFS_DQ_PROJ, alloc_blocks))
+		xfs_quota_calc_throttle(ip, XFS_DQ_PROJ, &qblocks, &qshift);
+
+	/*
+	 * The final prealloc size is set to the minimum of free space available
+	 * in each of the quotas and the overall filesystem.
+	 *
+	 * The shift throttle value is set to the maximum value as determined by
+	 * the global low free space values and per-quota low free space values.
+	 */
+	alloc_blocks = MIN(alloc_blocks, qblocks);
+	shift = MAX(shift, qshift);
+
 	if (shift)
 		alloc_blocks >>= shift;
 	/*
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
