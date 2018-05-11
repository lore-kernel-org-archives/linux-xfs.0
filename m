Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39496 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbeEKXqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 19:46:38 -0400
Date: Fri, 11 May 2018 16:46:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 8/8] xfs: teach xfs_bmapi_remap to accept some bmapi flags
Message-ID: <20180511234616.GL11261@magnolia>
References: <152597988038.25215.9276761144353662866.stgit@magnolia>
 <152597993604.25215.2923117604057991749.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152597993604.25215.2923117604057991749.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach xfs_bmapi_remap how to map in unwritten extent and to skip rmap
updates.  This enables us to rebuild real and unwritten extents from the
rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: tidy up the assert checking for ATTR|PREALLOC
---
 fs/xfs/libxfs/xfs_bmap.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b63e15a114f3..7b0e2b551e23 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4543,7 +4543,10 @@ xfs_bmapi_remap(
 	ASSERT(len > 0);
 	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK)));
+	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
+			   XFS_BMAPI_NORMAP)));
+	ASSERT((flags & (XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC)) !=
+			(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC));
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -4581,7 +4584,10 @@ xfs_bmapi_remap(
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
