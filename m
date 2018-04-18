Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58038 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRClp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:41:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2fUZ5010310
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:44 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2hdrxnrjt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:44 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2fhca012573
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:44 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2fh30031048
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:43 GMT
Subject: [PATCH 8/9] xfs: teach xfs_bmapi_remap to accept some bmapi flags
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:41:42 -0700
Message-ID: <152401930207.11792.15668086719721478722.stgit@magnolia>
In-Reply-To: <152401924595.11792.16954598133403059881.stgit@magnolia>
References: <152401924595.11792.16954598133403059881.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach xfs_bmapi_remap how to map in unwritten extent and to skip rmap
updates.  This enables us to rebuild real and unwritten extents from the
rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4365cec..1dd91c8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4535,7 +4535,9 @@ xfs_bmapi_remap(
 	ASSERT(len > 0);
 	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK)));
+	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
+			   XFS_BMAPI_NORMAP)));
+	ASSERT(!(flags & XFS_BMAPI_ATTRFORK) || !(flags & XFS_BMAPI_PREALLOC));
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -4573,7 +4575,10 @@ xfs_bmapi_remap(
 	got.br_startoff = bno;
 	got.br_startblock = startblock;
 	got.br_blockcount = len;
-	got.br_state = XFS_EXT_NORM;
+	if (flags & XFS_BMAPI_PREALLOC)
+		got.br_state = XFS_EXT_UNWRITTEN;
+	else
+		got.br_state = XFS_EXT_NORM;
 
 	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
 			&cur, &got, &firstblock, dfops, &logflags, flags);

