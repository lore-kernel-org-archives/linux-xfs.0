Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41096 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965410AbeEJP3u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 11:29:50 -0400
Subject: [PATCH 06/14] xfs: remove unnecessary xfs_qm_dqattach parameter
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 10 May 2018 08:29:29 -0700
Message-ID: <152596616905.27525.11144913615606015465.stgit@magnolia>
In-Reply-To: <152596612549.27525.9876256551560849585.stgit@magnolia>
References: <152596612549.27525.9876256551560849585.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

The flags argument is always zero, get rid of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c |    4 ++--
 fs/xfs/xfs_bmap_util.c   |    6 +++---
 fs/xfs/xfs_inode.c       |   10 +++++-----
 fs/xfs/xfs_iomap.c       |    4 ++--
 fs/xfs/xfs_iops.c        |    2 +-
 fs/xfs/xfs_qm.c          |    7 +++----
 fs/xfs/xfs_quota.h       |    4 ++--
 fs/xfs/xfs_reflink.c     |    2 +-
 8 files changed, 19 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 35a124400d60..c3d02a66d39d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -236,7 +236,7 @@ xfs_attr_set(
 	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
 	args.total = xfs_attr_calc_size(&args, &local);
 
-	error = xfs_qm_dqattach(dp, 0);
+	error = xfs_qm_dqattach(dp);
 	if (error)
 		return error;
 
@@ -427,7 +427,7 @@ xfs_attr_remove(
 	 */
 	args.op_flags = XFS_DA_OP_OKNOENT;
 
-	error = xfs_qm_dqattach(dp, 0);
+	error = xfs_qm_dqattach(dp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 696c3b6bd2c9..518627c1b412 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -848,7 +848,7 @@ xfs_free_eofblocks(
 		/*
 		 * Attach the dquots to the inode up front.
 		 */
-		error = xfs_qm_dqattach(ip, 0);
+		error = xfs_qm_dqattach(ip);
 		if (error)
 			return error;
 
@@ -918,7 +918,7 @@ xfs_alloc_file_space(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	error = xfs_qm_dqattach(ip, 0);
+	error = xfs_qm_dqattach(ip);
 	if (error)
 		return error;
 
@@ -1169,7 +1169,7 @@ xfs_free_file_space(
 
 	trace_xfs_free_file_space(ip);
 
-	error = xfs_qm_dqattach(ip, 0);
+	error = xfs_qm_dqattach(ip);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5b2e08488107..74d5cbee8a71 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1424,11 +1424,11 @@ xfs_link(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	error = xfs_qm_dqattach(sip, 0);
+	error = xfs_qm_dqattach(sip);
 	if (error)
 		goto std_return;
 
-	error = xfs_qm_dqattach(tdp, 0);
+	error = xfs_qm_dqattach(tdp);
 	if (error)
 		goto std_return;
 
@@ -1929,7 +1929,7 @@ xfs_inactive(
 	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0))
 		truncate = 1;
 
-	error = xfs_qm_dqattach(ip, 0);
+	error = xfs_qm_dqattach(ip);
 	if (error)
 		return;
 
@@ -2592,11 +2592,11 @@ xfs_remove(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	error = xfs_qm_dqattach(dp, 0);
+	error = xfs_qm_dqattach(dp);
 	if (error)
 		goto std_return;
 
-	error = xfs_qm_dqattach(ip, 0);
+	error = xfs_qm_dqattach(ip);
 	if (error)
 		goto std_return;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d03e65f01c89..0880685a1143 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -224,7 +224,7 @@ xfs_iomap_write_direct(
 	 * necessary and move on to transaction setup.
 	 */
 	xfs_iunlock(ip, lockmode);
-	error = xfs_qm_dqattach(ip, 0);
+	error = xfs_qm_dqattach(ip);
 	if (error)
 		return error;
 
@@ -692,7 +692,7 @@ xfs_iomap_write_allocate(
 	/*
 	 * Make sure that the dquots are there.
 	 */
-	error = xfs_qm_dqattach(ip, 0);
+	error = xfs_qm_dqattach(ip);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a3ed3c811dfa..5afe3c2234b3 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -855,7 +855,7 @@ xfs_setattr_size(
 	/*
 	 * Make sure that the dquots are attached to the inode.
 	 */
-	error = xfs_qm_dqattach(ip, 0);
+	error = xfs_qm_dqattach(ip);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index eb106366dea1..3893f541f88d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -378,8 +378,7 @@ xfs_qm_dqattach_locked(
 
 int
 xfs_qm_dqattach(
-	struct xfs_inode	*ip,
-	uint			flags)
+	struct xfs_inode	*ip)
 {
 	int			error;
 
@@ -387,7 +386,7 @@ xfs_qm_dqattach(
 		return 0;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_qm_dqattach_locked(ip, flags);
+	error = xfs_qm_dqattach_locked(ip, 0);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	return error;
@@ -1926,7 +1925,7 @@ xfs_qm_vop_rename_dqattach(
 		 */
 		if (i == 0 || ip != i_tab[i-1]) {
 			if (XFS_NOT_DQATTACHED(mp, ip)) {
-				error = xfs_qm_dqattach(ip, 0);
+				error = xfs_qm_dqattach(ip);
 				if (error)
 					return error;
 			}
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index ce6506adab7b..a4d392240cf4 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -90,7 +90,7 @@ extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
 extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
 		struct xfs_dquot *, struct xfs_dquot *,
 		struct xfs_dquot *, uint);
-extern int xfs_qm_dqattach(struct xfs_inode *, uint);
+extern int xfs_qm_dqattach(struct xfs_inode *);
 extern int xfs_qm_dqattach_locked(struct xfs_inode *, uint);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
 extern void xfs_qm_dqrele(struct xfs_dquot *);
@@ -132,7 +132,7 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
 #define xfs_qm_vop_chown_reserve(tp, ip, u, g, p, fl)			(0)
-#define xfs_qm_dqattach(ip, fl)						(0)
+#define xfs_qm_dqattach(ip)						(0)
 #define xfs_qm_dqattach_locked(ip, fl)					(0)
 #define xfs_qm_dqdetach(ip)
 #define xfs_qm_dqrele(d)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 12d441a73b53..7e2b8078ade2 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1361,7 +1361,7 @@ xfs_reflink_remap_range(
 		goto out_unlock;
 
 	/* Attach dquots to dest inode before changing block map */
-	ret = xfs_qm_dqattach(dest, 0);
+	ret = xfs_qm_dqattach(dest);
 	if (ret)
 		goto out_unlock;
 

