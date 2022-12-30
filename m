Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E39EC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbiLaBQ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236048AbiLaBQv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:16:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4D71AD9A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:16:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A18E261D77
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AC7C433EF;
        Sat, 31 Dec 2022 01:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449410;
        bh=iZpoeAyr09sNC8/LhzPvMHNNf3TtviNobi5y096JWh8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R3clVJfUNNUEBZs2C6cPmujsH84Y76gXvT3s7U9MI2nCDuTX4jGmsWL7na5TM9Lhv
         08VPqd8kJwqdn7kdkc2MnSOWBXrLbSchdKpDQo9dYk4ZDvtHcCQZvNWBH2/yYYUgUg
         2OMB5jPOo8+9LqoT7uWjEQkQPeUYz8OBvnQjBxiR246i51GRIBQtLqtT4smvmhoos3
         lA6TcO1pXHrI6+Jhy98mZZR4AmFH1v4kU2C79SnJ2eN0kVtn7tG4QvscujvCjHvXVQ
         9syp1uskMA8mBD15ry3F6T88g8Mcy0Oaf7IS7NKW8QOsItn9OuMVC50VgRJNQCtshh
         mEGOS/O/dw43w==
Subject: [PATCH 02/14] xfs: refactor the allocation and freeing of incore
 inode fork btree roots
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:31 -0800
Message-ID: <167243865136.708933.3250808354146954240.stgit@magnolia>
In-Reply-To: <167243865089.708933.5645420573863731083.stgit@magnolia>
References: <167243865089.708933.5645420573863731083.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refactor the code that allocates and freese the incore inode fork btree
roots.  This will help us disentangle some of the weird logic when we're
creating and tearing down inode-based btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   53 ++++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_inode_fork.h |    3 ++
 2 files changed, 40 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 9d53df7ce49d..0f220f100069 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -207,8 +207,7 @@ xfs_iformat_btree(
 		return -EFSCORRUPTED;
 	}
 
-	ifp->if_broot_bytes = size;
-	ifp->if_broot = kmem_alloc(size, KM_NOFS);
+	xfs_iroot_alloc(ip, whichfork, size);
 	ASSERT(ifp->if_broot != NULL);
 	/*
 	 * Copy and convert from the on-disk structure
@@ -344,6 +343,32 @@ xfs_iformat_attr_fork(
 	return error;
 }
 
+/* Allocate a new incore ifork btree root. */
+void
+xfs_iroot_alloc(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	size_t			bytes)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+
+	ifp->if_broot = kmem_alloc(bytes, KM_NOFS);
+	ifp->if_broot_bytes = bytes;
+}
+
+/* Free all the memory and state associated with an incore ifork btree root. */
+void
+xfs_iroot_free(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+
+	ifp->if_broot_bytes = 0;
+	kmem_free(ifp->if_broot);
+	ifp->if_broot = NULL;
+}
+
 /*
  * Reallocate the space for if_broot based on the number of records
  * being added or deleted as indicated in rec_diff.  Move the records
@@ -392,8 +417,7 @@ xfs_iroot_realloc(
 		 */
 		if (ifp->if_broot_bytes == 0) {
 			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
-			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
-			ifp->if_broot_bytes = (int)new_size;
+			xfs_iroot_alloc(ip, whichfork, new_size);
 			return;
 		}
 
@@ -432,17 +456,15 @@ xfs_iroot_realloc(
 		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 	else
 		new_size = 0;
-	if (new_size > 0) {
-		new_broot = kmem_alloc(new_size, KM_NOFS);
-		/*
-		 * First copy over the btree block header.
-		 */
-		memcpy(new_broot, ifp->if_broot,
-			xfs_bmbt_block_len(ip->i_mount));
-	} else {
-		new_broot = NULL;
+	if (new_size == 0) {
+		xfs_iroot_free(ip, whichfork);
+		return;
 	}
 
+	/* First copy over the btree block header. */
+	new_broot = kmem_alloc(new_size, KM_NOFS);
+	memcpy(new_broot, ifp->if_broot, xfs_bmbt_block_len(ip->i_mount));
+
 	/*
 	 * Only copy the records and pointers if there are any.
 	 */
@@ -466,9 +488,8 @@ xfs_iroot_realloc(
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
-	if (ifp->if_broot)
-		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
-			xfs_inode_fork_size(ip, whichfork));
+	ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
+		xfs_inode_fork_size(ip, whichfork));
 	return;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index c201d8ad5957..f4379e2df616 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -171,6 +171,9 @@ void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 void		xfs_idestroy_fork(struct xfs_ifork *ifp);
 void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
 				int whichfork);
+void		xfs_iroot_alloc(struct xfs_inode *ip, int whichfork,
+				size_t bytes);
+void		xfs_iroot_free(struct xfs_inode *ip, int whichfork);
 void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,

