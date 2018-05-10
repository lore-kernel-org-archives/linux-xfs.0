Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54896 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbeEJTTP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 15:19:15 -0400
Subject: [PATCH 8/8] xfs: teach xfs_bmapi_remap to accept some bmapi flags
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 10 May 2018 12:18:56 -0700
Message-ID: <152597993604.25215.2923117604057991749.stgit@magnolia>
In-Reply-To: <152597988038.25215.9276761144353662866.stgit@magnolia>
References: <152597988038.25215.9276761144353662866.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach xfs_bmapi_remap how to map in unwritten extent and to skip rmap
updates.  This enables us to rebuild real and unwritten extents from the
rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b63e15a114f3..7660efb5beb0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4543,7 +4543,9 @@ xfs_bmapi_remap(
 	ASSERT(len > 0);
 	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK)));
+	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
+			   XFS_BMAPI_NORMAP)));
+	ASSERT(!(flags & XFS_BMAPI_ATTRFORK) || !(flags & XFS_BMAPI_PREALLOC));
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -4581,7 +4583,10 @@ xfs_bmapi_remap(
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

