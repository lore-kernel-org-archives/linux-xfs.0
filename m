Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39350 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965193AbeALWEc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 17:04:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0CLvQIu044747
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:32 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2ff5c082by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:32 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0CM4Vbr010643
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:31 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0CM4Vvc008431
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:31 GMT
Subject: [PATCH 5/5] xfs: btree format ifork loader should check for zero
 numrecs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 12 Jan 2018 14:04:30 -0800
Message-ID: <151579467015.8694.7629126647166170386.stgit@magnolia>
In-Reply-To: <151579463950.8694.320025813242574491.stgit@magnolia>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

A btree format inode fork with zero records makes no sense, so reject it
if we see it, or else we can miscalculate memory allocations.  Found by
zeroes fuzzing {a,u3}.bmbt.numrecs in xfs/{374,378,412} with KASAN.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 84eaf17..8c01dd5 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -307,6 +307,7 @@ xfs_iformat_btree(
 	 */
 	if (unlikely(XFS_IFORK_NEXTENTS(ip, whichfork) <=
 					XFS_IFORK_MAXEXT(ip, whichfork) ||
+		     nrecs == 0 ||
 		     XFS_BMDR_SPACE_CALC(nrecs) >
 					XFS_DFORK_SIZE(dip, mp, whichfork) ||
 		     XFS_IFORK_NEXTENTS(ip, whichfork) > ip->i_d.di_nblocks) ||

