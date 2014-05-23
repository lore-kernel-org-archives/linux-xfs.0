Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 720E07F47
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 06:52:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C58AAC004
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 04:52:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3UB4kcROkDJQsdKR for
	<xfs@oss.sgi.com>; Fri, 23 May 2014 04:52:32 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4NBqWCN024568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 23 May 2014 07:52:32 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s4NBqVbA013455
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 07:52:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 3/3] xfs: squash prealloc while over quota free space as
	well
Date: Fri, 23 May 2014 07:52:30 -0400
Message-Id: <1400845950-41435-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
References: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
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

Commit 4d559a3b introduced heavy prealloc. squashing to catch the case
of requesting too large a prealloc on smaller filesystems, leading to
repeated flush and retry cycles that occur on ENOSPC. Now that we issue
eofblocks scans on EDQUOT/ENOSPC, squash the prealloc against the
minimum available free space across all applicable quotas as well to
avoid a similar problem of repeated eofblocks scans.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6c5eb4c..28629e9 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -397,7 +397,8 @@ xfs_quota_calc_throttle(
 	struct xfs_inode *ip,
 	int type,
 	xfs_fsblock_t *qblocks,
-	int *qshift)
+	int *qshift,
+	int64_t	*qfreesp)
 {
 	int64_t freesp;
 	int shift = 0;
@@ -406,6 +407,7 @@ xfs_quota_calc_throttle(
 	/* over hi wmark, squash the prealloc completely */
 	if (dq->q_res_bcount >= dq->q_prealloc_hi_wmark) {
 		*qblocks = 0;
+		*qfreesp = 0;
 		return;
 	}
 
@@ -418,6 +420,9 @@ xfs_quota_calc_throttle(
 			shift += 2;
 	}
 
+	if (freesp < *qfreesp)
+		*qfreesp = freesp;
+
 	/* only overwrite the throttle values if we are more aggressive */
 	if ((freesp >> shift) < (*qblocks >> *qshift)) {
 		*qblocks = freesp;
@@ -476,15 +481,18 @@ xfs_iomap_prealloc_size(
 	}
 
 	/*
-	 * Check each quota to cap the prealloc size and provide a shift
-	 * value to throttle with.
+	 * Check each quota to cap the prealloc size, provide a shift value to
+	 * throttle with and adjust amount of available space.
 	 */
 	if (xfs_quota_need_throttle(ip, XFS_DQ_USER, alloc_blocks))
-		xfs_quota_calc_throttle(ip, XFS_DQ_USER, &qblocks, &qshift);
+		xfs_quota_calc_throttle(ip, XFS_DQ_USER, &qblocks, &qshift,
+					&freesp);
 	if (xfs_quota_need_throttle(ip, XFS_DQ_GROUP, alloc_blocks))
-		xfs_quota_calc_throttle(ip, XFS_DQ_GROUP, &qblocks, &qshift);
+		xfs_quota_calc_throttle(ip, XFS_DQ_GROUP, &qblocks, &qshift,
+					&freesp);
 	if (xfs_quota_need_throttle(ip, XFS_DQ_PROJ, alloc_blocks))
-		xfs_quota_calc_throttle(ip, XFS_DQ_PROJ, &qblocks, &qshift);
+		xfs_quota_calc_throttle(ip, XFS_DQ_PROJ, &qblocks, &qshift,
+					&freesp);
 
 	/*
 	 * The final prealloc size is set to the minimum of free space available
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
