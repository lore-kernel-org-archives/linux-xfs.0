Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17495 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933939AbcI1C5p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:57:45 -0400
Subject: [PATCH 38/63] xfs: cancel pending CoW reservations when destroying
 inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:57:41 -0700
Message-ID: <147503146128.30303.2317369406970493928.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

When destroying the inode, cancel all pending reservations in the CoW
fork so that all the reserved blocks go back to the free pile.  In
theory this sort of cleanup is only needed to clean up after write
errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 204b794..26b45b3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -49,6 +49,7 @@
 #include "xfs_rmap_item.h"
 #include "xfs_refcount_item.h"
 #include "xfs_bmap_item.h"
+#include "xfs_reflink.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -938,6 +939,7 @@ xfs_fs_destroy_inode(
 	struct inode		*inode)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
+	int			error;
 
 	trace_xfs_destroy_inode(ip);
 
@@ -945,6 +947,12 @@ xfs_fs_destroy_inode(
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
 
+	error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF);
+	if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount))
+		xfs_warn(ip->i_mount, "Error %d while evicting CoW blocks "
+				"for inode %llu.",
+				error, ip->i_ino);
+
 	xfs_inactive(ip);
 
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);

