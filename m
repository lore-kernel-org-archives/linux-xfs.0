Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q48AmxYv124820 for <xfs@oss.sgi.com>; Tue, 8 May 2012 05:48:59 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	D4HC2wM5lYVVSs8Y for <xfs@oss.sgi.com>;
	Tue, 08 May 2012 03:48:56 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SRhyP-00038r-L0
	for xfs@oss.sgi.com; Tue, 08 May 2012 20:48:53 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SRhyP-0007Do-9G
	for xfs@oss.sgi.com; Tue, 08 May 2012 20:48:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix delalloc quota accounting on failure
Date: Tue,  8 May 2012 20:48:53 +1000
Message-Id: <1336474133-27732-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

xfstest 270 was causing quota reservations way beyond what was sane
(ten to hundreds of TB) for a 4GB filesystem. There's a sign problem
in the error handling path of xfs_bmapi_reserve_delalloc() because
xfs_trans_unreserve_quota_nblks() simple negates the value passed -
which doesn't work for an unsigned variable. This causes
reservations of close to 2^32 block instead of removing a
reservation of a handful of blocks.

Fix the same problem in the other xfs_trans_unreserve_quota_nblks()
callers where unsigned integer variables are used, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c     |    2 +-
 fs/xfs/xfs_iomap.c    |    2 +-
 fs/xfs/xfs_vnodeops.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 9006656..2115146 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4526,7 +4526,7 @@ out_unreserve_blocks:
 		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS, alen, 0);
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
-		xfs_trans_unreserve_quota_nblks(NULL, ip, alen, 0, rt ?
+		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0, rt ?
 				XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
 	return error;
 }
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 756f093..973dff6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -246,7 +246,7 @@ out_unlock:
 
 out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
-	xfs_trans_unreserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
+	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
 out_trans_cancel:
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
 	goto out_unlock;
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 57515e2..c22f4e0 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1916,7 +1916,7 @@ xfs_alloc_file_space(
 
 error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
 	xfs_bmap_cancel(&free_list);
-	xfs_trans_unreserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
+	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
 
 error1:	/* Just cancel transaction */
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
