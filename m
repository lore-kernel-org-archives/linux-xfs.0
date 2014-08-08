Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB9707F6F
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 13:49:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4C31DAC002
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 11:49:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1t5QGxvbSbuBCxTy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Aug 2014 11:49:28 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s78InRe3015114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 8 Aug 2014 14:49:28 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s78InRtX029446
	for <xfs@oss.sgi.com>; Fri, 8 Aug 2014 14:49:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] xfs: hole the inode lock across a full file collapse
Date: Fri,  8 Aug 2014 14:49:26 -0400
Message-Id: <1407523766-62233-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1407523766-62233-1-git-send-email-bfoster@redhat.com>
References: <1407523766-62233-1-git-send-email-bfoster@redhat.com>
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

A file collapse stress test workload reproduces collapse failures
mid-operation due to changes in the inode fork extent count across
extent shift cycles. xfs_collapse_file_space() currently calls
xfs_bmap_shift_extents() to shift one extent at a time per transaction.
The extent index is used to track the next extent to shift after each
iteration.

A concurrent fsx and fsstress workload reproduces a scenario where the
extent count changes during this sequence, causing the 'current_ext'
index to become inaccurate and possibly skip shifting an extent. The
likely result of this behavior is the subsequent shift attempt will not
find a hole in the area of the skipped extent and fail, leaving the file
in a partially collapsed state.

This occurs because the ilock is released and acquired across each
transaction and each individual extent shift. Tracepoint output shows
that once the ilock is released after an extent shift, a pending
blocking writeback (e.g., sync) can acquire the lock and proceed before
the next extent is shifted down. If the writeback converts part of a
delayed allocation earlier in the file, for example, it can insert a new
extent into the map. Tracing confirms a call to
xfs_bmap_add_extent_delay_real() in this particular instance.

To prevent this scenario, hold the ilock across the entire extent shift
loop in xfs_collapse_file_space().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2f1e30d..96eb97b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1474,6 +1474,8 @@ xfs_collapse_file_space(
 	if (error)
 		return error;
 
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
 	while (!error && !done) {
 		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
 		/*
@@ -1489,7 +1491,6 @@ xfs_collapse_file_space(
 			break;
 		}
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
 				ip->i_gdquot, ip->i_pdquot,
 				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
@@ -1517,9 +1518,9 @@ xfs_collapse_file_space(
 			goto out;
 
 		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 
 out:
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
