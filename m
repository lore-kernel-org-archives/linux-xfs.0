Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43845 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbcJGXHh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 19:07:37 -0400
Subject: [PATCH 2/7] xfs: check inode reflink flag before calling reflink
 functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Oct 2016 16:07:32 -0700
Message-ID: <147588165195.12127.15898847119499370449.stgit@birch.djwong.org>
In-Reply-To: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

There are a couple of places where we don't check the inode's
reflink flag before calling into the reflink code.  Fix those,
and add some asserts so we don't make this mistake again.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_reflink.c |    4 ++--
 fs/xfs/xfs_super.c   |   12 +++++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 685c419..9c58b4a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -624,6 +624,7 @@ xfs_reflink_cancel_cow_range(
 	int			error;
 
 	trace_xfs_reflink_cancel_cow_range(ip, offset, count);
+	ASSERT(xfs_is_reflink_inode(ip));
 
 	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
 	if (count == NULLFILEOFF)
@@ -1510,8 +1511,7 @@ xfs_reflink_clear_inode_flag(
 	int			nmaps;
 	int			error = 0;
 
-	if (!(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK))
-		return 0;
+	ASSERT(xfs_is_reflink_inode(ip));
 
 	fbno = 0;
 	end = XFS_B_TO_FSB(mp, i_size_read(VFS_I(ip)));
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 72bde28..ade4691 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -947,11 +947,13 @@ xfs_fs_destroy_inode(
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
 
-	error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF);
-	if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount))
-		xfs_warn(ip->i_mount, "Error %d while evicting CoW blocks "
-				"for inode %llu.",
-				error, ip->i_ino);
+	if (xfs_is_reflink_inode(ip)) {
+		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF);
+		if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount))
+			xfs_warn(ip->i_mount,
+"Error %d while evicting CoW blocks for inode %llu.",
+					error, ip->i_ino);
+	}
 
 	xfs_inactive(ip);
 

