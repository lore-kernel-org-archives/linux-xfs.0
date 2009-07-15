Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6FJWkOv215694 for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 14:32:46 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 843C7138C395
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 12:33:24 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id fPKGxyIhD6jm5uIL for <xfs@oss.sgi.com>;
	Wed, 15 Jul 2009 12:33:24 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n6FJXOpA022740
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 15:33:24 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6FJXNaq010293
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 15:33:23 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n6FJXL3X016880
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 15:33:22 -0400
Message-ID: <4A5E2F01.7030107@sandeen.net>
Date: Wed, 15 Jul 2009 14:33:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] reduce bmv_count in xfs_vn_fiemap
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

commit 6321e3ed2acf3ee9643cdd403e1c88605d7944ba caused
the full bmv_count's worth of getbmapx structures to get
allocated; telling it to do MAXEXTNUM was a bit insane,
resulting in ENOMEM.

Chop it down to something reasonable, the caller can
loop over this if the file has > 64 extents.

(this is a regression, FWIW)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

iff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 58973bb..370e9a7 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -680,8 +680,12 @@ xfs_vn_fiemap(
 	else
 		bm.bmv_length = BTOBB(length);
 
-	/* our formatter will tell xfs_getbmap when to stop. */
-	bm.bmv_count = MAXEXTNUM;
+	/*
+	 * xfs_getbmap allocates based on that; pick a count that's
+	 * not too outragous.
+	 * Our formatter will tell xfs_getbmap when to stop.
+	 */
+	bm.bmv_count = 64;
 	bm.bmv_iflags = BMV_IF_PREALLOC;
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
 		bm.bmv_iflags |= BMV_IF_ATTRFORK;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
