Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751017AbeBUC10 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Feb 2018 21:27:26 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w1L2Nk59001814
        for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2018 21:27:25 -0500
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2g8y2p1tpt-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2018 21:27:25 -0500
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 20 Feb 2018 19:27:24 -0700
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V2 2/2] xfs: Fix "use after free" of intent items
Date: Wed, 21 Feb 2018 07:58:26 +0530
In-Reply-To: <20180221022826.7020-1-chandan@linux.vnet.ibm.com>
References: <20180221022826.7020-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180221022826.7020-2-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, hch@infradead.org, darrick.wong@oracle.com, bfoster@redhat.com

generic/388 can cause the following "use after free" error to occur,

 =============================================================================
 BUG xfs_efi_item (Not tainted): Poison overwritten
 -----------------------------------------------------------------------------

 Disabling lock debugging due to kernel taint
 INFO: 0x00000000292c4bd4-0x00000000292c4bd4. First byte 0x6a instead of 0x6b
 INFO: Allocated in .kmem_zone_alloc+0xcc/0x190 age=79 cpu=0 pid=12436
        .__slab_alloc+0x54/0x80
        .kmem_cache_alloc+0x124/0x350
        .kmem_zone_alloc+0xcc/0x190
        .xfs_efi_init+0x48/0xf0
        .xfs_extent_free_create_intent+0x40/0x130
        .xfs_defer_intake_work+0x74/0x1e0
        .xfs_defer_finish+0xac/0x5c0
        .xfs_itruncate_extents+0x170/0x590
        .xfs_inactive_truncate+0xcc/0x170
        .xfs_inactive+0x1d8/0x2f0
        .xfs_fs_destroy_inode+0xe4/0x3d0
        .destroy_inode+0x68/0xb0
        .do_unlinkat+0x1e8/0x390
        system_call+0x58/0x6c
 INFO: Freed in .xfs_efi_item_free+0x44/0x80 age=79 cpu=0 pid=12436
        .kmem_cache_free+0x120/0x2b0
        .xfs_efi_item_free+0x44/0x80
        .xfs_trans_free_items+0xd4/0x130
        .__xfs_trans_commit+0xd0/0x350
        .xfs_trans_roll+0x4c/0x90
        .xfs_defer_trans_roll+0xa4/0x2b0
        .xfs_defer_finish+0xb8/0x5c0
        .xfs_itruncate_extents+0x170/0x590
        .xfs_inactive_truncate+0xcc/0x170
        .xfs_inactive+0x1d8/0x2f0
        .xfs_fs_destroy_inode+0xe4/0x3d0
        .destroy_inode+0x68/0xb0
        .do_unlinkat+0x1e8/0x390
        system_call+0x58/0x6c

This happens due to the following interaction,
1. xfs_defer_finish() creates "extent free" intent item and adds it to the
   per-transction list of log items.
2. xfs_defer_trans_roll() invokes __xfs_trans_commit(). Here, if the
   XFS_MOUNT_FS_SHUTDOWN flag is set, we invoke io_unlock() operation
   for each of the log items in the per-transction list. For "extent
   free" log items xfs_efi_item_unlock() gets invoked which then frees
   the xfs_efi_log_item.
3. xfs_defer_trans_roll() then invokes xfs_defer_trans_abort(). Since the
   xfs_defer_pending->dfp_intent is still set to the "extent free" intent
   item, we invoke xfs_extent_free_abort_intent(). This accesses the
   previously freed xfs_efi_log_item to decrement the ref count.

This commit fixes the bug by invoking xfs_defer_trans_abort() only when
the log items in the per-transaction list have been committed to the
CIL. The log item "committed" status is being tracked by
xfs_defer_ops->dop_committed. This was the behaviour prior to commit
3ab78df2a59a485f479d26852a060acfd8c4ecd7 (xfs: rework xfs_bmap_free
callers to use xfs_defer_ops).

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/xfs/libxfs/xfs_defer.c | 6 +++---
 fs/xfs/xfs_bmap_util.c    | 2 +-
 fs/xfs/xfs_inode.c        | 2 +-
 fs/xfs/xfs_trans.c        | 8 +++++++-
 fs/xfs/xfs_trans.h        | 2 +-
 fs/xfs/xfs_trans_inode.c  | 2 +-
 6 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 087fea0..eb879a0 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -256,13 +256,13 @@ xfs_defer_trans_roll(
 	trace_xfs_defer_trans_roll((*tp)->t_mountp, dop);
 
 	/* Roll the transaction. */
-	error = xfs_trans_roll(tp);
+	error = xfs_trans_roll(tp, &dop->dop_committed);
 	if (error) {
 		trace_xfs_defer_trans_roll_error((*tp)->t_mountp, dop, error);
-		xfs_defer_trans_abort(*tp, dop, error);
+		if (dop->dop_committed == true)
+			xfs_defer_trans_abort(*tp, dop, error);
 		return error;
 	}
-	dop->dop_committed = true;
 
 	/* Rejoin the joined inodes. */
 	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dop->dop_inodes[i]; i++)
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c83f549..9d84d36 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1830,7 +1830,7 @@ xfs_swap_change_owner(
 		if (error != -EAGAIN)
 			break;
 
-		error = xfs_trans_roll(tpp);
+		error = xfs_trans_roll(tpp, NULL);
 		if (error)
 			break;
 		tp = *tpp;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 37d9426..9b74539 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1047,7 +1047,7 @@ xfs_dir_ialloc(
 			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
 		}
 
-		code = xfs_trans_roll(&tp);
+		code = xfs_trans_roll(&tp, NULL);
 
 		/*
 		 * Re-attach the quota info that we detached from prev trx.
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 86f92df..1bf2505 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1057,12 +1057,15 @@ xfs_trans_cancel(
  */
 int
 xfs_trans_roll(
-	struct xfs_trans	**tpp)
+	struct xfs_trans	**tpp,
+	bool 			*committed)
 {
 	struct xfs_trans	*trans = *tpp;
 	struct xfs_trans_res	tres;
 	int			error;
 
+	if (committed)
+		*committed = false;
 	/*
 	 * Copy the critical parameters from one trans to the next.
 	 */
@@ -1082,6 +1085,9 @@ xfs_trans_roll(
 	if (error)
 		return error;
 
+	if (committed)
+		*committed = true;
+
 	/*
 	 * Reserve space in the log for the next transaction.
 	 * This also pushes items in the "AIL", the list of logged items,
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9d542df..d4deb49 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -230,7 +230,7 @@ int		xfs_trans_free_extent(struct xfs_trans *,
 				      struct xfs_efd_log_item *, xfs_fsblock_t,
 				      xfs_extlen_t, struct xfs_owner_info *);
 int		xfs_trans_commit(struct xfs_trans *);
-int		xfs_trans_roll(struct xfs_trans **);
+int		xfs_trans_roll(struct xfs_trans **, bool *);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
 void		xfs_trans_cancel(xfs_trans_t *);
 int		xfs_trans_ail_init(struct xfs_mount *);
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 4a89da4..bedd5fd 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -147,7 +147,7 @@ xfs_trans_roll_inode(
 	int			error;
 
 	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
-	error = xfs_trans_roll(tpp);
+	error = xfs_trans_roll(tpp, NULL);
 	if (!error)
 		xfs_trans_ijoin(*tpp, ip, 0);
 	return error;
-- 
2.9.5

