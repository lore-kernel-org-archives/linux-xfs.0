Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7E0C64EC4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 17:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjCCRL0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjCCRL0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 12:11:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831651EFD5
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 09:11:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 240D46182C
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 17:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80536C433A1;
        Fri,  3 Mar 2023 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677863484;
        bh=5PCIZT1EQB1EqvLBdFvGVjEZHWpOPtUxuybz0t+9ojI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aZmLuGuMGBMLiApXy+MVW9zpLtU2Us+R6f9D12TnL1cv6O8mBDKypet2zLQXj4MaU
         haV42SOBjrjL1wI5Zpqzl1iDvnd86q0XEeRW2Entcov3xJ/UNHnk+65BjSWPz9XChH
         W76ZkuV4wUxZqgN+74h/mIT/8IHcQ+RdhwPGQBLIA9ScJG2p0EhWCqIsf+YK7O70nr
         njMgmQdam0VKS+pNqGc+dnqoBqlYjvzP1EjSuKZJOtJ6xOKMcV8Lv+BYR4HJR5mxdS
         NzqdGdIJnhYhYzqMETg0quIqj3zxd0FyA5wzSxAbdpqsjYZ/a5k051ix9n434/98fT
         ACneW1Aen0+bg==
Subject: [PATCH 01/13] xfs: make xfs_attr_set require XFS_DA_OP_REMOVE
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Date:   Fri, 03 Mar 2023 09:11:24 -0800
Message-ID: <167786348406.1543331.16739128076405218565.stgit@magnolia>
In-Reply-To: <167786347827.1543331.2803518928321606576.stgit@magnolia>
References: <167786347827.1543331.2803518928321606576.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the next patch we're going to add the ability to look up local/sf
xattrs based on the attr name and value matching.  As a result, we need
callers of xfs_attr_set to declare explicitly that they want to remove
an xattr.  Passing in NULL value will no longer suffice.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c   |    9 +++++----
 fs/xfs/libxfs/xfs_parent.c |    1 +
 fs/xfs/xfs_xattr.c         |    5 +++++
 3 files changed, 11 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3065dd622102..756d93526075 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -977,6 +977,7 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
+	bool			is_remove = args->op_flags & XFS_DA_OP_REMOVE;
 	bool			rsvd;
 	int			error, local;
 	int			rmt_blks = 0;
@@ -1004,7 +1005,7 @@ xfs_attr_set(
 	args->op_flags = XFS_DA_OP_OKNOENT |
 					(args->op_flags & XFS_DA_OP_LOGGED);
 
-	if (args->value) {
+	if (!is_remove) {
 		XFS_STATS_INC(mp, xs_attr_set);
 		args->total = xfs_attr_calc_size(args, &local);
 
@@ -1038,7 +1039,7 @@ xfs_attr_set(
 	if (error)
 		return error;
 
-	if (args->value || xfs_inode_hasattr(dp)) {
+	if (!is_remove || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error == -EFBIG)
@@ -1052,7 +1053,7 @@ xfs_attr_set(
 	switch (error) {
 	case -EEXIST:
 		/* if no value, we are performing a remove operation */
-		if (!args->value) {
+		if (is_remove) {
 			error = xfs_attr_defer_remove(args);
 			break;
 		}
@@ -1064,7 +1065,7 @@ xfs_attr_set(
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
-		if (!args->value)
+		if (is_remove)
 			goto out_trans_cancel;
 
 		/* Pure replace fails if no existing attr to replace. */
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index f7fecee93894..387f3c65287f 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -460,6 +460,7 @@ xfs_parent_unset(
 	scr->args.geo		= ip->i_mount->m_attr_geo;
 	scr->args.name		= (const unsigned char *)&scr->rec;
 	scr->args.namelen	= reclen;
+	scr->args.op_flags	= XFS_DA_OP_REMOVE;
 	scr->args.whichfork	= XFS_ATTR_FORK;
 
 	return xfs_attr_set(&scr->args);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 85edd7e05fde..8f8aa13bf7eb 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -103,6 +103,11 @@ xfs_attr_change(
 		use_logging = true;
 	}
 
+	if (args->value)
+		args->op_flags &= ~XFS_DA_OP_REMOVE;
+	else
+		args->op_flags |= XFS_DA_OP_REMOVE;
+
 	error = xfs_attr_set(args);
 
 	if (use_logging)

