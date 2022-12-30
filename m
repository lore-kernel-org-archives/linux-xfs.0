Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F70C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbiLaBSK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236054AbiLaBSJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:18:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9251D0C6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C76761D7A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF367C433D2;
        Sat, 31 Dec 2022 01:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449487;
        bh=Y++h65fq+j2Hk0pGBesqI+ZJ6GIe5EVPUc2lqw0FTY8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d5CPQCmLrZITH8LlJxylCnP+AD1+YMtpaUtqm1nUBH9xkKQQs8GxLXYhp60std/4h
         EWkvPomGi1y/5dYY5+kykPK4ciG4nA0Db7APz3A2UStDAWobWQGOmoFVzjBGqYOmeS
         hRIdOChyxqq1Ytjn/WCCEmfg1nycGlCzkPASG+GcHt36dZfsG8/JT6gvzIVmQVs7U+
         dPAWsBMkeMrzz3fT8m3TIc48cOP2WZEbOinHZn94ECsXOiFzG4q86SNdzhhlohjewu
         7bR38iA75w0uqsuS26hcUC38wYfIYxmKz5GzDqf4M0RYhGctR5hNIx4raOg7d54Hmu
         89TJjHZGZYmvQ==
Subject: [PATCH 07/14] xfs: rearrange xfs_iroot_realloc a bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:32 -0800
Message-ID: <167243865207.708933.6009722653433688860.stgit@magnolia>
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

Rearrange the innards of xfs_iroot_realloc so that we can reduce
duplicated code prior to genericizing the function.  No functional
changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   49 ++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1bd8c1f9ce37..ceab02b19d26 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -433,44 +433,46 @@ xfs_ifork_move_broot(
  */
 void
 xfs_iroot_realloc(
-	xfs_inode_t		*ip,
+	struct xfs_inode	*ip,
 	int			rec_diff,
 	int			whichfork)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	int			cur_max;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_block	*new_broot;
-	int			new_max;
 	size_t			new_size;
 	size_t			old_size = ifp->if_broot_bytes;
+	int			cur_max;
+	int			new_max;
+
+	/* Handle degenerate cases. */
+	if (rec_diff == 0)
+		return;
 
 	/*
-	 * Handle the degenerate case quietly.
+	 * If there wasn't any memory allocated before, just allocate it now
+	 * and get out.
 	 */
-	if (rec_diff == 0) {
+	if (old_size == 0) {
+		ASSERT(rec_diff > 0);
+
+		new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
+		xfs_iroot_alloc(ip, whichfork, new_size);
 		return;
 	}
 
+	/* Compute the new and old record count and space requirements. */
+	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
+	new_max = cur_max + rec_diff;
+	ASSERT(new_max >= 0);
+	new_size = xfs_bmap_broot_space_calc(mp, new_max);
+
 	if (rec_diff > 0) {
-		/*
-		 * If there wasn't any memory allocated before, just
-		 * allocate it now and get out.
-		 */
-		if (old_size == 0) {
-			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
-			xfs_iroot_alloc(ip, whichfork, new_size);
-			return;
-		}
-
 		/*
 		 * If there is already an existing if_broot, then we need
 		 * to realloc() it and shift the pointers to their new
 		 * location.
 		 */
-		cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
-		new_max = cur_max + rec_diff;
-		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
 					 GFP_NOFS | __GFP_NOFAIL);
 		ifp->if_broot_bytes = new_size;
@@ -482,14 +484,8 @@ xfs_iroot_realloc(
 	/*
 	 * rec_diff is less than 0.  In this case, we are shrinking the
 	 * if_broot buffer.  It must already exist.  If we go to zero
-	 * records, just get rid of the root and clear the status bit.
+	 * bytes, just get rid of the root and clear the status bit.
 	 */
-	ASSERT((ifp->if_broot != NULL) && (old_size > 0));
-	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
-	new_max = cur_max + rec_diff;
-	ASSERT(new_max >= 0);
-
-	new_size = xfs_bmap_broot_space_calc(mp, new_max);
 	if (new_size == 0) {
 		xfs_iroot_free(ip, whichfork);
 		return;
@@ -502,8 +498,7 @@ xfs_iroot_realloc(
 
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
-	ifp->if_broot_bytes = (int)new_size;
-	return;
+	ifp->if_broot_bytes = new_size;
 }
 
 

