Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Mar 2008 08:43:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2SFh0nU025429
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 08:43:00 -0700
Received: from mailrelay.pawisda.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 890CD701BD2
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 08:43:33 -0700 (PDT)
Received: from mailrelay.pawisda.de (mail.pawisda.de [213.157.4.156]) by cuda.sgi.com with ESMTP id JNCrdfNJ9ZRvkCxb for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 08:43:33 -0700 (PDT)
Received: from [192.168.1.3] (unknown [92.50.81.38])
	by mailrelay.pawisda.de (Postfix) with ESMTP id 4E8A3B8774
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 16:43:31 +0100 (CET)
Subject: [PATCH] do not test return value of xfs_bmap_*_count_leaves
From: Ruben Porras <ruben.porras@linworks.de>
Content-Type: multipart/mixed; boundary="=-dcXUWvoe0VdSPkitZZIl"
Date: Fri, 28 Mar 2008 16:43:31 +0100
Message-Id: <1206719011.8339.6.camel@marzo>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--=-dcXUWvoe0VdSPkitZZIl
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

These functions, xfs_bmap_count_leaves and xfs_bmap_disk_count_leaves,
return always 0. Therefore it is not necessary to test the return value.

Regards

--=-dcXUWvoe0VdSPkitZZIl
Content-Disposition: attachment; filename=xfs_bmap.patch
Content-Type: text/x-patch; name=xfs_bmap.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: fs/xfs/xfs_bmap.c
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_bmap.c,v
retrieving revision 1.383
diff -u -r1.383 xfs_bmap.c
--- fs/xfs/xfs_bmap.c	6 Feb 2008 05:18:18 -0000	1.383
+++ fs/xfs/xfs_bmap.c	28 Mar 2008 15:39:59 -0000
@@ -6361,13 +6361,9 @@
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if ( XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ) {
-		if (unlikely(xfs_bmap_count_leaves(ifp, 0,
+		xfs_bmap_count_leaves(ifp, 0,
 			ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t),
-			count) < 0)) {
-			XFS_ERROR_REPORT("xfs_bmap_count_blocks(1)",
-					 XFS_ERRLEVEL_LOW, mp);
-			return XFS_ERROR(EFSCORRUPTED);
-		}
+			count);
 		return 0;
 	}
 
@@ -6448,13 +6444,7 @@
 		for (;;) {
 			nextbno = be64_to_cpu(block->bb_rightsib);
 			numrecs = be16_to_cpu(block->bb_numrecs);
-			if (unlikely(xfs_bmap_disk_count_leaves(0,
-					block, numrecs, count) < 0)) {
-				xfs_trans_brelse(tp, bp);
-				XFS_ERROR_REPORT("xfs_bmap_count_tree(2)",
-						 XFS_ERRLEVEL_LOW, mp);
-				return XFS_ERROR(EFSCORRUPTED);
-			}
+			xfs_bmap_disk_count_leaves(0, block, numrecs, count);
 			xfs_trans_brelse(tp, bp);
 			if (nextbno == NULLFSBLOCK)
 				break;

--=-dcXUWvoe0VdSPkitZZIl--
