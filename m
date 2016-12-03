Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18753 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbcLCBfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:35:38 -0500
Subject: [PATCH 03/55] xfs: complain if we don't get nextents bmap records
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:35:33 -0800
Message-ID: <148072893359.12995.10240545634733611493.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

When reading into memory all extents of a btree-format inode fork,
complain if the number of extents we find is not the same as the number
of extents reported in the inode core.  This is needed to stop an IO
action from accessing the garbage areas of the in-core fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6f28814..9821161 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1375,6 +1375,8 @@ xfs_bmap_read_extents(
 			return error;
 		block = XFS_BUF_TO_BLOCK(bp);
 	}
+	if (i != XFS_IFORK_NEXTENTS(ip, whichfork))
+		return -EFSCORRUPTED;
 	ASSERT(i == xfs_iext_count(ifp));
 	ASSERT(i == XFS_IFORK_NEXTENTS(ip, whichfork));
 	XFS_BMAP_TRACE_EXLIST(ip, i, whichfork);

