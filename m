Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387994AbeGWOFY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 10:05:24 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 612144059FF7
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:14 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C1DE111AF23
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:14 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 01/15] xfs: pull up dfops from xfs_itruncate_extents()
Date: Mon, 23 Jul 2018 09:04:00 -0400
Message-Id: <20180723130414.47980-2-bfoster@redhat.com>
In-Reply-To: <20180723130414.47980-1-bfoster@redhat.com>
References: <20180723130414.47980-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_itruncate_extents[_flags]() uses a local dfops with a
transaction provided by the caller. It uses hacky ->t_dfops
replacement logic to avoid stomping over an already populated
->t_dfops.

The latter never occurs for current callers and the logic itself is
not really appropriate. Clean this up by updating all callers to
initialize a dfops and to use that down in xfs_itruncate_extents().
This more closely resembles the upcoming logic where dfops will be
embedded within the transaction. We can also replace the
xfs_defer_init() in the xfs_itruncate_extents_flags() loop with an
assert. Both dfops and firstblock should be in a valid state
after xfs_defer_finish() and the inode joined to the dfops is fixed
throughout the loop.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_inactive.c | 3 +++
 fs/xfs/xfs_bmap_util.c     | 2 ++
 fs/xfs/xfs_inode.c         | 8 +++-----
 fs/xfs/xfs_iops.c          | 3 +++
 fs/xfs/xfs_qm_syscalls.c   | 3 +++
 5 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 7ce10055f275..d3055972d3a6 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -26,6 +26,7 @@
 #include "xfs_quota.h"
 #include "xfs_trace.h"
 #include "xfs_dir2.h"
+#include "xfs_defer.h"
 
 /*
  * Look at all the extents for this logical region,
@@ -381,6 +382,7 @@ xfs_attr_inactive(
 {
 	struct xfs_trans	*trans;
 	struct xfs_mount	*mp;
+	struct xfs_defer_ops	dfops;
 	int			lock_mode = XFS_ILOCK_SHARED;
 	int			error = 0;
 
@@ -397,6 +399,7 @@ xfs_attr_inactive(
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrinval, 0, 0, 0, &trans);
 	if (error)
 		goto out_destroy_fork;
+	xfs_defer_init(trans, &dfops);
 
 	lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(dp, lock_mode);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d3a314fd721f..ee9481b142f0 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -792,6 +792,7 @@ xfs_free_eofblocks(
 	int			nimaps;
 	struct xfs_bmbt_irec	imap;
 	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_defer_ops	dfops;
 
 	/*
 	 * Figure out if there are any blocks beyond the end
@@ -831,6 +832,7 @@ xfs_free_eofblocks(
 			ASSERT(XFS_FORCED_SHUTDOWN(mp));
 			return error;
 		}
+		xfs_defer_init(tp, &dfops);
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, 0);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7b2694d3901a..7d7d7e95fa17 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1541,8 +1541,6 @@ xfs_itruncate_extents_flags(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
-	struct xfs_defer_ops	*odfops = tp->t_dfops;
-	struct xfs_defer_ops	dfops;
 	xfs_fileoff_t		first_unmap_block;
 	xfs_fileoff_t		last_block;
 	xfs_filblks_t		unmap_len;
@@ -1579,7 +1577,7 @@ xfs_itruncate_extents_flags(
 	ASSERT(first_unmap_block < last_block);
 	unmap_len = last_block - first_unmap_block + 1;
 	while (!done) {
-		xfs_defer_init(tp, &dfops);
+		ASSERT(tp->t_firstblock == NULLFSBLOCK);
 		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
 				    XFS_ITRUNC_MAX_EXTENTS, &done);
 		if (error)
@@ -1618,8 +1616,6 @@ xfs_itruncate_extents_flags(
 	trace_xfs_itruncate_extents_end(ip, new_size);
 
 out:
-	/* ->t_dfops points to local stack, don't leak it! */
-	tp->t_dfops = odfops;
 	*tpp = tp;
 	return error;
 out_bmap_cancel:
@@ -1723,6 +1719,7 @@ xfs_inactive_truncate(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
+	struct xfs_defer_ops	dfops;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
@@ -1730,6 +1727,7 @@ xfs_inactive_truncate(
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		return error;
 	}
+	xfs_defer_init(tp, &dfops);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0fa29f39d658..704b57a8b99e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -26,6 +26,7 @@
 #include "xfs_dir2.h"
 #include "xfs_trans_space.h"
 #include "xfs_iomap.h"
+#include "xfs_defer.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -812,6 +813,7 @@ xfs_setattr_size(
 	struct inode		*inode = VFS_I(ip);
 	xfs_off_t		oldsize, newsize;
 	struct xfs_trans	*tp;
+	struct xfs_defer_ops	dfops;
 	int			error;
 	uint			lock_flags = 0;
 	bool			did_zeroing = false;
@@ -915,6 +917,7 @@ xfs_setattr_size(
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error)
 		return error;
+	xfs_defer_init(tp, &dfops);
 
 	lock_flags |= XFS_ILOCK_EXCL;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index abc8a21e3a82..df0783303887 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -22,6 +22,7 @@
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_defer.h"
 
 STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
 STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
@@ -213,6 +214,7 @@ xfs_qm_scall_trunc_qfile(
 {
 	struct xfs_inode	*ip;
 	struct xfs_trans	*tp;
+	struct xfs_defer_ops	dfops;
 	int			error;
 
 	if (ino == NULLFSINO)
@@ -229,6 +231,7 @@ xfs_qm_scall_trunc_qfile(
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 		goto out_put;
 	}
+	xfs_defer_init(tp, &dfops);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
-- 
2.17.1

