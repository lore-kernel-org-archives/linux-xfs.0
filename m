Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30961 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751276AbdKWGBk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Nov 2017 01:01:40 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAN61d43005609
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Nov 2017 06:01:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAN61dme020274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Nov 2017 06:01:39 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAN61cRe032068
        for <linux-xfs@vger.kernel.org>; Thu, 23 Nov 2017 06:01:39 GMT
Date: Wed, 22 Nov 2017 22:01:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20171123060137.GL2135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_ifree, we reset the data/attr forks to extents format without
bothering to free any inline data buffer that might still be around
after all the blocks have been truncated off the file.  Prior to commit
43518812d2 ("xfs: remove support for inlining data/extents into the
inode fork") nobody noticed because the leftover inline data after
truncation was small enough to fit inside the inline buffer inside the
fork itself.

However, now that we've removed the inline buffer, we /always/ have to
free the inline data buffer or else we leak them like crazy.  This test
was found by turning on kmemleak for generic/001 or generic/388.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 61d1cb7..8012741 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2401,6 +2401,24 @@ xfs_ifree_cluster(
 }
 
 /*
+ * Free any local-format buffers sitting around before we reset to
+ * extents format.
+ */
+static inline void
+xfs_ifree_local_data(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp;
+
+	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
+		return;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
+}
+
+/*
  * This is called to return an inode to the inode free list.
  * The inode should already be truncated to 0 length and have
  * no pages associated with it.  This routine also assumes that
@@ -2437,6 +2455,9 @@ xfs_ifree(
 	if (error)
 		return error;
 
+	xfs_ifree_local_data(ip, XFS_DATA_FORK);
+	xfs_ifree_local_data(ip, XFS_ATTR_FORK);
+
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
 	ip->i_d.di_flags = 0;
 	ip->i_d.di_dmevmask = 0;
