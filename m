Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39792 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbeHKSKL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Aug 2018 14:10:11 -0400
Subject: [PATCH 6/6] xfs: don't crash the vfs on a garbage inline symlink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 11 Aug 2018 08:35:34 -0700
Message-ID: <153400173428.27471.504421086760762828.stgit@magnolia>
In-Reply-To: <153400169747.27471.4044680761841034489.stgit@magnolia>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, wen.xu@gatech.edu

From: Darrick J. Wong <darrick.wong@oracle.com>

The VFS routine that calls ->get_link blindly copies whatever's returned
into the user's buffer.  If we return a NULL pointer, the vfs will
crash on the null pointer.  Therefore, return -EFSCORRUPTED instead of
blowing up the kernel.

Reported-by: wen.xu@gatech.edu
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iops.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0ef5ad7fb851..26007a9db49d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -471,8 +471,16 @@ xfs_vn_get_link_inline(
 	struct inode		*inode,
 	struct delayed_call	*done)
 {
+	char			*ptr;
+
 	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
-	return XFS_I(inode)->i_df.if_u1.if_data;
+
+	/*
+	 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
+	 * if_data is junk.
+	 */
+	ptr = XFS_I(inode)->i_df.if_u1.if_data;
+	return ptr ? ptr : ERR_PTR(-EFSCORRUPTED);
 }
 
 STATIC int
