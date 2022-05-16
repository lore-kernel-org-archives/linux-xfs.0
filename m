Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E58C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239662AbiEPDcD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbiEPDcA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:32:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514F21FCC7
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:31:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D661060ECC
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43362C385B8;
        Mon, 16 May 2022 03:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652671918;
        bh=4vI1ILqU9B3zi1i0JbBzjAtvBpOYE9mEo2tctI5mRqI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uiKlDCAacWtitnUUNWKpDzEtidQK73ZdG2/yGUu8wCfjgvN2Qnuiv89odFvvhXUgJ
         E0CN9hkeLsTobY3X/NDXdcawgCpnEb/l4QBVSVFroLB9+zE33NlNf0VZrS4kDetHKS
         fQlnAvjzxW6aJOhjXEBeddAOFm453lCui/raUjgNUmHS7FzG/6rdxpfRlpHf5+YxpI
         FqYo7rDLbwBSqMFuDUomBdHv3ARpI1D7/6L1SYvYCGgp8VoriN4uaEv2j6q/NkVTBr
         9nQk1wKCgQpYMZzSJFSMtGzRczUw06Qm2Wc/Lor1UlQ09rYcmOe+0Fhx+e+/VyDtRJ
         x48FA39i7dI0g==
Subject: [PATCH 1/4] xfs: don't leak da state when freeing the attr intent
 item
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 15 May 2022 20:31:57 -0700
Message-ID: <165267191771.625255.3595054157709968327.stgit@magnolia>
In-Reply-To: <165267191199.625255.12173648515376165187.stgit@magnolia>
References: <165267191199.625255.12173648515376165187.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

kmemleak reported that we lost an xfs_da_state while removing xattrs in
generic/020:

unreferenced object 0xffff88801c0e4b40 (size 480):
  comm "attr", pid 30515, jiffies 4294931061 (age 5.960s)
  hex dump (first 32 bytes):
    78 bc 65 07 00 c9 ff ff 00 30 60 1c 80 88 ff ff  x.e......0`.....
    02 00 00 00 00 00 00 00 80 18 83 4e 80 88 ff ff  ...........N....
  backtrace:
    [<ffffffffa023ef4a>] xfs_da_state_alloc+0x1a/0x30 [xfs]
    [<ffffffffa021b6f3>] xfs_attr_node_hasname+0x23/0x90 [xfs]
    [<ffffffffa021c6f1>] xfs_attr_set_iter+0x441/0xa30 [xfs]
    [<ffffffffa02b5104>] xfs_xattri_finish_update+0x44/0x80 [xfs]
    [<ffffffffa02b515e>] xfs_attr_finish_item+0x1e/0x40 [xfs]
    [<ffffffffa0244744>] xfs_defer_finish_noroll+0x184/0x740 [xfs]
    [<ffffffffa02a6473>] __xfs_trans_commit+0x153/0x3e0 [xfs]
    [<ffffffffa021d149>] xfs_attr_set+0x469/0x7e0 [xfs]
    [<ffffffffa02a78d9>] xfs_xattr_set+0x89/0xd0 [xfs]
    [<ffffffff812e6512>] __vfs_removexattr+0x52/0x70
    [<ffffffff812e6a08>] __vfs_removexattr_locked+0xb8/0x150
    [<ffffffff812e6af6>] vfs_removexattr+0x56/0x100
    [<ffffffff812e6bf8>] removexattr+0x58/0x90
    [<ffffffff812e6cce>] path_removexattr+0x9e/0xc0
    [<ffffffff812e6d44>] __x64_sys_lremovexattr+0x14/0x20
    [<ffffffff81786b35>] do_syscall_64+0x35/0x80

I think this is a consequence of xfs_attr_node_removename_setup
attaching a new da(btree) state to xfs_attr_item and never freeing it.
I /think/ it's the case that the remove paths could detach the da state
earlier in the remove state machine since nothing else accesses the
state.  However, let's future-proof the new xattr code by adding a
catch-all when we free the xfs_attr_item to make sure we never leak the
da state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |   22 ++++++++++++++--------
 fs/xfs/xfs_attr_item.c   |   15 ++++++++++++---
 2 files changed, 26 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 14ae0826bc15..2da24954b2d7 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -604,26 +604,29 @@ int xfs_attr_node_removename_setup(
 	struct xfs_attr_item		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
-	struct xfs_da_state		**state = &attr->xattri_da_state;
+	struct xfs_da_state		*state;
 	int				error;
 
-	error = xfs_attr_node_hasname(args, state);
+	error = xfs_attr_node_hasname(args, &attr->xattri_da_state);
 	if (error != -EEXIST)
 		goto out;
 	error = 0;
 
-	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
-	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
+	state = attr->xattri_da_state;
+	ASSERT(state->path.blk[state->path.active - 1].bp != NULL);
+	ASSERT(state->path.blk[state->path.active - 1].magic ==
 		XFS_ATTR_LEAF_MAGIC);
 
-	error = xfs_attr_leaf_mark_incomplete(args, *state);
+	error = xfs_attr_leaf_mark_incomplete(args, state);
 	if (error)
 		goto out;
 	if (args->rmtblkno > 0)
 		error = xfs_attr_rmtval_invalidate(args);
 out:
-	if (error)
-		xfs_da_state_free(*state);
+	if (error) {
+		xfs_da_state_free(state);
+		attr->xattri_da_state = NULL;
+	}
 
 	return error;
 }
@@ -1456,8 +1459,10 @@ xfs_attr_node_addname_find_attr(
 
 	return 0;
 error:
-	if (attr->xattri_da_state)
+	if (attr->xattri_da_state) {
 		xfs_da_state_free(attr->xattri_da_state);
+		attr->xattri_da_state = NULL;
+	}
 	return error;
 }
 
@@ -1511,6 +1516,7 @@ xfs_attr_node_try_addname(
 
 out:
 	xfs_da_state_free(state);
+	attr->xattri_da_state = NULL;
 	return error;
 }
 
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index e8ac88d9fd14..687cf517841a 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -396,6 +396,15 @@ xfs_attr_create_intent(
 	return &attrip->attri_item;
 }
 
+static inline void
+xfs_attr_free_item(
+	struct xfs_attr_item		*attr)
+{
+	if (attr->xattri_da_state)
+		xfs_da_state_free(attr->xattri_da_state);
+	kmem_free(attr);
+}
+
 /* Process an attr. */
 STATIC int
 xfs_attr_finish_item(
@@ -420,7 +429,7 @@ xfs_attr_finish_item(
 
 	error = xfs_xattri_finish_update(attr, done_item);
 	if (error != -EAGAIN)
-		kmem_free(attr);
+		xfs_attr_free_item(attr);
 
 	return error;
 }
@@ -441,7 +450,7 @@ xfs_attr_cancel_item(
 	struct xfs_attr_item		*attr;
 
 	attr = container_of(item, struct xfs_attr_item, xattri_list);
-	kmem_free(attr);
+	xfs_attr_free_item(attr);
 }
 
 STATIC xfs_lsn_t
@@ -613,7 +622,7 @@ xfs_attri_item_recover(
 	xfs_irele(ip);
 out:
 	if (ret != -EAGAIN)
-		kmem_free(attr);
+		xfs_attr_free_item(attr);
 	return error;
 }
 

