Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934332AbeAKMvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 07:51:23 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0BCnZYV027663
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2018 07:51:23 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fe7f02ekx-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2018 07:51:22 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 11 Jan 2018 05:51:22 -0700
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH] xfs: Fix "use after free" of intent items
Date: Thu, 11 Jan 2018 18:22:23 +0530
Message-Id: <20180111125223.10727-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, hch@infradead.org, darrick.wong@oracle.com

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
   list at xfs_trans->t_items.
2. xfs_defer_trans_roll() invokes __xfs_trans_commit(). Here, if the
   XFS_MOUNT_FS_SHUTDOWN flag is set, we invoke io_unlock() operation of the
   corresponding log item. For "extent free" log items xfs_efi_item_unlock()
   gets invoked which frees the xfs_efi_log_item.
3. xfs_defer_trans_roll() then invokes xfs_defer_trans_abort(). Since the
   xfs_defer_pending->dfp_intent is still set to the "extent free" intent
   item, we invoke xfs_extent_free_abort_intent(). This accesses the
   previously freed xfs_efi_log_item to decrement the ref count.

This commit fixes the bug by changing xfs_efi_item_unlock() to invoke
xfs_efi_release() instead of xfs_efi_item_free(). The xfs_efi_log_item gets
freed when xfs_extent_free_abort_intent() invokes xfs_efi_release() once again
i.e. its refcount becomes zero and hence xfs_efi_item_free() is invoked.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---

The above mentioned "use after free" occurs with other log items.
(e.g. xfs_rui_item). If the below fix is found to be correct, I will
apply it to other affected log items as well and post a new patch.

 fs/xfs/xfs_extfree_item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 64da906..2119441 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -151,7 +151,7 @@ xfs_efi_item_unlock(
 	struct xfs_log_item	*lip)
 {
 	if (lip->li_flags & XFS_LI_ABORTED)
-		xfs_efi_item_free(EFI_ITEM(lip));
+		xfs_efi_release(EFI_ITEM(lip));
 }
 
 /*
-- 
2.9.5

