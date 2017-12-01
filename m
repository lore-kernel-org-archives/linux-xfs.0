Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37497 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdLAWlx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Dec 2017 17:41:53 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vB1MfqtK006763
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Dec 2017 22:41:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vB1Mfp5I015337
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Dec 2017 22:41:52 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB1Mfpa1027124
        for <linux-xfs@vger.kernel.org>; Fri, 1 Dec 2017 22:41:51 GMT
Date: Fri, 1 Dec 2017 14:41:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: scrub inode nsec fields
Message-ID: <20171201224149.GB21412@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Check that the nanosecond fields in each timestamp aren't larger
than a billion.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/inode.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 637b7a8..fc9bc59 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -380,6 +380,14 @@ xfs_scrub_dinode(
 		break;
 	}
 
+	/* di_[amc]time.nsec */
+	if (be32_to_cpu(dip->di_atime.t_nsec) >= NSEC_PER_SEC)
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	if (be32_to_cpu(dip->di_mtime.t_nsec) >= NSEC_PER_SEC)
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+	if (be32_to_cpu(dip->di_ctime.t_nsec) >= NSEC_PER_SEC)
+		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+
 	/*
 	 * di_size.  xfs_dinode_verify checks for things that screw up
 	 * the VFS such as the upper bit being set and zero-length
@@ -483,6 +491,8 @@ xfs_scrub_dinode(
 	}
 
 	if (dip->di_version >= 3) {
+		if (be32_to_cpu(dip->di_crtime.t_nsec) >= NSEC_PER_SEC)
+			xfs_scrub_ino_set_corrupt(sc, ino, bp);
 		xfs_scrub_inode_flags2(sc, bp, dip, ino, mode, flags, flags2);
 		xfs_scrub_inode_cowextsize(sc, bp, dip, ino, mode, flags,
 				flags2);
