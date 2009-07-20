Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6KFpaaG092816 for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 10:51:37 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAA0E372DDD
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 08:52:17 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 97ANfvUxtXl6OopB for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2009 08:52:17 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n6KFqHDQ017111
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 11:52:17 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6KFqGnJ009867
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 11:52:16 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n6KFqF1a018376
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 11:52:15 -0400
Message-ID: <4A6492AF.3030809@sandeen.net>
Date: Mon, 20 Jul 2009 10:52:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] use XFS_CORRUPTION_ERROR in xfs_btree_check_sblock
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

In Red Hat Bug 512552
 - Can't write to XFS mount during raid5 resync

a user ran into corruption while resyncing a raid, and we failed
a consistency test, but didn't get much more info; it'd be nice
to call XFS_CORRUPTION_ERROR here so we can see the buffer
contents.

Compile-tested only...

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index e9df995..2671738 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -120,8 +120,8 @@ xfs_btree_check_sblock(
 			XFS_RANDOM_BTREE_CHECK_SBLOCK))) {
 		if (bp)
 			xfs_buftrace("SBTREE ERROR", bp);
-		XFS_ERROR_REPORT("xfs_btree_check_sblock", XFS_ERRLEVEL_LOW,
-				 cur->bc_mp);
+		XFS_CORRUPTION_ERROR("xfs_btree_check_sblock",
+			XFS_ERRLEVEL_LOW, cur->bc_mp, block);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
