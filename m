Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751438AbeAPTpj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Jan 2018 14:45:39 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: cancel tx on xfs_defer_finish() error during xattr set/remove
Date: Tue, 16 Jan 2018 14:45:37 -0500
Message-Id: <20180116194537.34451-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Chris Dunlop <chris@onthe.net.au>

Chris Dunlop reports a problem where an xattr operation fails,
reports the following error to syslog and hangs during unmount:

 ================================================
 [ BUG: lock held when returning to user space! ]
 ...
 ------------------------------------------------
 <PID> is leaving the kernel with locks still held!
 1 lock held by <PID>:
  #0:  (sb_internal){......}, at: [<ffffffffa07692a3>] xfs_trans_alloc+0xe3/0x130 [xfs]

The failure/shutdown occurs during deferred ops processing which
leads to an error return from xfs_defer_finish() via
xfs_attr_leaf_addname(). While the root cause of the failure is
unknown corruption, the cause of the subsequent BUG above and
unmount hang is failure to cancel the transaction before returning
to userspace.

The transaction is not cancelled because the out_defer_cancel error
handling paths in the xfs_attr_[leaf|node]_[add|remove]name()
functions clear args.trans without releasing the transaction. The
callers therefore lose the reference to the transaction and fail to
cancel it.

Since xfs_attr_[set|remove]() always cancel args.trans when != NULL
and xfs_defer_finish()->...->xfs_trans_roll() should always return
with a valid transaction, update the leaf/node xattr functions to
not reset args.trans in the error path responsible for cancelling
deferred ops.

Reported-by: Chris Dunlop <chris@onthe.net.au>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a76914db72ef..ce4a34a2751d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -717,7 +717,6 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	return error;
 out_defer_cancel:
 	xfs_defer_cancel(args->dfops);
-	args->trans = NULL;
 	return error;
 }
 
@@ -770,7 +769,6 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	return 0;
 out_defer_cancel:
 	xfs_defer_cancel(args->dfops);
-	args->trans = NULL;
 	return error;
 }
 
@@ -1045,7 +1043,6 @@ xfs_attr_node_addname(xfs_da_args_t *args)
 	return retval;
 out_defer_cancel:
 	xfs_defer_cancel(args->dfops);
-	args->trans = NULL;
 	goto out;
 }
 
@@ -1186,7 +1183,6 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	return error;
 out_defer_cancel:
 	xfs_defer_cancel(args->dfops);
-	args->trans = NULL;
 	goto out;
 }
 
-- 
2.13.6

