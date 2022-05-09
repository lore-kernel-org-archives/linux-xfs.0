Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0256C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 01:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbiEIBaW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 May 2022 21:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbiEIApf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 May 2022 20:45:35 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BF96BC03
        for <linux-xfs@vger.kernel.org>; Sun,  8 May 2022 17:41:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 37A8F10E63EE
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 10:41:41 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-009hcn-40
        for linux-xfs@vger.kernel.org; Mon, 09 May 2022 10:41:40 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-003CP0-2y
        for linux-xfs@vger.kernel.org;
        Mon, 09 May 2022 10:41:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/18] xfs: avoid empty xattr transaction when attrs are inline
Date:   Mon,  9 May 2022 10:41:21 +1000
Message-Id: <20220509004138.762556-2-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509004138.762556-1-david@fromorbit.com>
References: <20220509004138.762556-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62786345
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=z6sQ9X07RN1rA8HuyEwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

generic/642 triggered a reproducable assert failure in
xlog_cil_commit() that resulted from a xfs_attr_set() committing
an empty but dirty transaction. When the CIL is empty and this
occurs, xlog_cil_commit() tries a background push and this triggers
a "pushing an empty CIL" assert.

XFS: Assertion failed: !list_empty(&cil->xc_cil), file: fs/xfs/xfs_log_cil.c, line: 1274
Call Trace:
 <TASK>
 xlog_cil_commit+0xa5a/0xad0
 __xfs_trans_commit+0xb8/0x330
 xfs_trans_commit+0x10/0x20
 xfs_attr_set+0x3e2/0x4c0
 xfs_xattr_set+0x8d/0xe0
 __vfs_setxattr+0x6b/0x90
 __vfs_setxattr_noperm+0x76/0x220
 __vfs_setxattr_locked+0xdf/0x100
 vfs_setxattr+0x94/0x170
 setxattr+0x110/0x200
 path_setxattr+0xbf/0xe0
 __x64_sys_setxattr+0x2b/0x30
 do_syscall_64+0x35/0x80

The problem is related to the breakdown of attribute addition in
xfs_attr_set_iter() and how it is called from deferred operations.
When we have a pure leaf xattr insert, we add the xattr to the leaf
and set the next state to XFS_DAS_FOUND_LBLK and return -EAGAIN.
This requeues the xattr defered work, rolls the transaction and
runs xfs_attr_set_iter() again. This then checks the xattr for
being remote (it's not) and whether a replace op is being done (this
is a create op) and if neither are true it returns without having
done anything.

xfs_xattri_finish_update() then unconditionally sets the transaction
dirty, and the deferops finishes and returns to __xfs_trans_commit()
which sees the transaction dirty and tries to commit it by calling
xlog_cil_commit(). The transaction is empty, and then the assert
fires if this happens when the CIL is empty.

This patch addresses the structure of xfs_attr_set_iter() that
requires re-entry on leaf add even when nothing will be done. This
gets rid of the trailing empty transaction and so doesn't trigger
the XFS_TRANS_DIRTY assignment in xfs_xattri_finish_update()
incorrectly. Addressing that is for a different patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 48b7e7efbb30..b3d918195160 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -315,6 +315,7 @@ xfs_attr_leaf_addname(
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
 	struct xfs_inode	*dp = args->dp;
+	enum xfs_delattr_state	next_state = XFS_DAS_UNINIT;
 	int			error;
 
 	if (xfs_attr_is_leaf(dp)) {
@@ -335,37 +336,35 @@ xfs_attr_leaf_addname(
 			 * when we come back, we'll be a node, so we'll fall
 			 * down into the node handling code below
 			 */
-			trace_xfs_attr_set_iter_return(
-				attr->xattri_dela_state, args->dp);
-			return -EAGAIN;
+			error = -EAGAIN;
+			goto out;
 		}
-
-		if (error)
-			return error;
-
-		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+		next_state = XFS_DAS_FOUND_LBLK;
 	} else {
 		error = xfs_attr_node_addname_find_attr(attr);
 		if (error)
 			return error;
 
+		next_state = XFS_DAS_FOUND_NBLK;
 		error = xfs_attr_node_addname(attr);
-		if (error)
-			return error;
-
-		/*
-		 * If addname was successful, and we dont need to alloc or
-		 * remove anymore blks, we're done.
-		 */
-		if (!args->rmtblkno &&
-		    !(args->op_flags & XFS_DA_OP_RENAME))
-			return 0;
+	}
+	if (error)
+		return error;
 
-		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+	/*
+	 * We need to commit and roll if we need to allocate remote xattr blocks
+	 * or perform more xattr manipulations. Otherwise there is nothing more
+	 * to do and we can return success.
+	 */
+	if (args->rmtblkno ||
+	    (args->op_flags & XFS_DA_OP_RENAME)) {
+		attr->xattri_dela_state = next_state;
+		error = -EAGAIN;
 	}
 
+out:
 	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
-	return -EAGAIN;
+	return error;
 }
 
 /*
-- 
2.35.1

