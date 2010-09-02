Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o825HJDl186806 for <xfs@oss.sgi.com>; Thu, 2 Sep 2010 00:17:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CA9A1BF8535
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 22:17:58 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	ScAVBcHW8wKBxj07 for <xfs@oss.sgi.com>;
	Wed, 01 Sep 2010 22:17:58 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	37522624-1927428
	for <xfs@oss.sgi.com>; Thu, 02 Sep 2010 14:47:57 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Or2BE-0002dY-Px
	for xfs@oss.sgi.com; Thu, 02 Sep 2010 15:17:44 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1Or2BD-0007Jn-Di
	for xfs@oss.sgi.com; Thu, 02 Sep 2010 15:17:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: prevent 32bit overflow in space reservation
Date: Thu,  2 Sep 2010 15:17:43 +1000
Message-Id: <1283404663-28105-1-git-send-email-david@fromorbit.com>
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

If we attempt to preallocate more than 2^32 blocks of space in a
single syscall, the transaction block reservation will overflow
leading to a hangs in the superblock block accounting code. This
is trivially reproduced with xfs_io. Fix the problem by capping the
allocation reservation to the maximum number of blocks a single
xfs_bmapi() call can allocate (2^21 blocks).

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_vnodeops.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 66d585c..91dd9c8 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2299,15 +2299,21 @@ xfs_alloc_file_space(
 			e = allocatesize_fsb;
 		}
 
+		/*
+		 * we can't allocate more than @nimaps extents at a time,
+		 * so prevent a 32bit overflow on the transaction reserve
+		 * by trying to reserve > 16TB worth of blocks for the
+		 * preallocation.
+		 */
+		resblks = min_t(xfs_fileoff_t, (e - s), (MAXEXTLEN * nimaps));
 		if (unlikely(rt)) {
-			resrtextents = qblocks = (uint)(e - s);
+			resrtextents = qblocks = resblks;
 			resrtextents /= mp->m_sb.sb_rextsize;
 			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 			quota_flag = XFS_QMOPT_RES_RTBLKS;
 		} else {
 			resrtextents = 0;
-			resblks = qblocks = \
-				XFS_DIOSTRAT_SPACE_RES(mp, (uint)(e - s));
+			resblks = qblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);
 			quota_flag = XFS_QMOPT_RES_REGBLKS;
 		}
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
