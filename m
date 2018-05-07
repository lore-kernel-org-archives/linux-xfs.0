Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752085AbeEGSLk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 May 2018 14:11:40 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0593F821C7
        for <linux-xfs@vger.kernel.org>; Mon,  7 May 2018 18:11:40 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2E08601A5
        for <linux-xfs@vger.kernel.org>; Mon,  7 May 2018 18:11:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/4] xfs: skip online discard during eofblocks trims
Date: Mon,  7 May 2018 14:11:36 -0400
Message-Id: <20180507181138.43250-3-bfoster@redhat.com>
In-Reply-To: <20180507181138.43250-1-bfoster@redhat.com>
References: <20180507181138.43250-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We've had reports of online discard operations being sent from XFS
on write-only workloads. These discards occur as a result of
eofblocks trims that can occur after a large file copy completes.

These discards are slightly confusing for users who might be paying
close attention to online discards (i.e., vdo) due to performance
sensitivity. They also happen to be spurious because freed post-eof
blocks by definition have not been written to during the current
allocation cycle.

Update xfs_free_eofblocks() to skip discards that are purely
attributed to eofblocks trims. This cuts down the number of spurious
discards that may occur on write-only workloads due to normal
preallocation activity.

Note that discards of post-eof extents can still occur from other
codepaths that do not isolate handling of post-eof blocks from those
within eof. For example, file unlinks and truncates may still cause
discards for any file blocks affected by the operation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_attr_inactive.c |  3 ++-
 fs/xfs/xfs_bmap_util.c     |  2 +-
 fs/xfs/xfs_inode.c         | 11 ++++++++---
 fs/xfs/xfs_inode.h         |  2 +-
 fs/xfs/xfs_iops.c          |  3 ++-
 fs/xfs/xfs_qm_syscalls.c   |  2 +-
 6 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 52818ea2eb50..639311e60c5d 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -434,7 +434,8 @@ xfs_attr_inactive(
 		if (error)
 			goto out_cancel;
 
-		error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
+		error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0,
+					      false);
 		if (error)
 			goto out_cancel;
 	}
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8cd8c412f52d..7b95d8976488 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -872,7 +872,7 @@ xfs_free_eofblocks(
 		 * may be full of holes (ie NULL files bug).
 		 */
 		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK,
-					      XFS_ISIZE(ip));
+					      XFS_ISIZE(ip), true);
 		if (error) {
 			/*
 			 * If we get an error at this point we simply don't
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2b70c8b4cee2..03b2b7099f90 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1538,7 +1538,8 @@ xfs_itruncate_extents(
 	struct xfs_trans	**tpp,
 	struct xfs_inode	*ip,
 	int			whichfork,
-	xfs_fsize_t		new_size)
+	xfs_fsize_t		new_size,
+	bool			skip_discard)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
@@ -1549,6 +1550,7 @@ xfs_itruncate_extents(
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
 	int			done = 0;
+	int			flags = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
@@ -1561,6 +1563,9 @@ xfs_itruncate_extents(
 
 	trace_xfs_itruncate_extents_start(ip, new_size);
 
+	if (skip_discard)
+		flags |= XFS_BMAPI_NODISCARD;
+
 	/*
 	 * Since it is possible for space to become allocated beyond
 	 * the end of the file (in a crash where the space is allocated
@@ -1581,7 +1586,7 @@ xfs_itruncate_extents(
 		xfs_defer_init(&dfops, &first_block);
 		error = xfs_bunmapi(tp, ip,
 				    first_unmap_block, unmap_len,
-				    xfs_bmapi_aflag(whichfork),
+				    xfs_bmapi_aflag(whichfork) | flags,
 				    XFS_ITRUNC_MAX_EXTENTS,
 				    &first_block, &dfops,
 				    &done);
@@ -1743,7 +1748,7 @@ xfs_inactive_truncate(
 	ip->i_d.di_size = 0;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
+	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0, false);
 	if (error)
 		goto error_trans_cancel;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1eebc53df7d7..b7877692ce4b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -416,7 +416,7 @@ uint		xfs_ip2xflags(struct xfs_inode *);
 int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
 			   struct xfs_defer_ops *);
 int		xfs_itruncate_extents(struct xfs_trans **, struct xfs_inode *,
-				      int, xfs_fsize_t);
+				      int, xfs_fsize_t, bool);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 
 void		xfs_iunpin_wait(xfs_inode_t *);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a3ed3c811dfa..fee5fb4b45de 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -966,7 +966,8 @@ xfs_setattr_size(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (newsize <= oldsize) {
-		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, newsize);
+		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, newsize,
+					      false);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 9cb5c381b01c..de498691d84a 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -248,7 +248,7 @@ xfs_qm_scall_trunc_qfile(
 	ip->i_d.di_size = 0;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
+	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0, false);
 	if (error) {
 		xfs_trans_cancel(tp);
 		goto out_unlock;
-- 
2.14.3

