Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22301 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756246AbcLCBfu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:35:50 -0500
Subject: [PATCH 05/55] xfs: error out if trying to add attrs and anextents >
 0
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:35:46 -0800
Message-ID: <148072894673.12995.4984707319578582555.stgit@birch.djwong.org>
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

We shouldn't assert if somehow we end up trying to add an attr fork to
an inode that apparently already has attr extents because this is an
indication of on-disk corruption.  Instead, return an error code to
userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9821161..b29601d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1151,6 +1151,10 @@ xfs_bmap_add_attrfork(
 		goto trans_cancel;
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
+	if (ip->i_d.di_anextents != 0) {
+		error = -EFSCORRUPTED;
+		goto trans_cancel;
+	}
 	if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS) {
 		/*
 		 * For inodes coming from pre-6.2 filesystems.
@@ -1158,7 +1162,6 @@ xfs_bmap_add_attrfork(
 		ASSERT(ip->i_d.di_aformat == 0);
 		ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
-	ASSERT(ip->i_d.di_anextents == 0);
 
 	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);

