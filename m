Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43912 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753440AbcJGXHw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 19:07:52 -0400
Subject: [PATCH 4/7] xfs: remove isize check from unshare operation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Oct 2016 16:07:44 -0700
Message-ID: <147588166426.12127.5691066835186430199.stgit@birch.djwong.org>
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

Now that fallocate has an explicit unshare flag again, let's try
to remove the inode reflink flag whenever the user unshares any
part of a file since checking is cheap compared to the CoW.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_reflink.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c4e35dc..220d263 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1570,8 +1570,7 @@ xfs_reflink_clear_inode_flag(
  */
 STATIC int
 xfs_reflink_try_clear_inode_flag(
-	struct xfs_inode	*ip,
-	xfs_off_t		old_isize)
+	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
@@ -1585,9 +1584,6 @@ xfs_reflink_try_clear_inode_flag(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	if (old_isize != i_size_read(VFS_I(ip)))
-		goto cancel;
-
 	error = xfs_reflink_clear_inode_flag(ip, &tp);
 	if (error)
 		goto cancel;
@@ -1630,7 +1626,7 @@ xfs_reflink_unshare(
 
 	/* Try to CoW the selected ranges */
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	fbno = XFS_B_TO_FSB(mp, offset);
+	fbno = XFS_B_TO_FSBT(mp, offset);
 	isize = i_size_read(VFS_I(ip));
 	end = XFS_B_TO_FSB(mp, offset + len);
 	error = xfs_reflink_dirty_extents(ip, fbno, end, isize);
@@ -1643,12 +1639,10 @@ xfs_reflink_unshare(
 	if (error)
 		goto out;
 
-	/* Turn off the reflink flag if we unshared the whole file */
-	if (offset == 0 && len == isize) {
-		error = xfs_reflink_try_clear_inode_flag(ip, isize);
-		if (error)
-			goto out;
-	}
+	/* Turn off the reflink flag if possible. */
+	error = xfs_reflink_try_clear_inode_flag(ip);
+	if (error)
+		goto out;
 
 	return 0;
 

