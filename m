Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1136C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjEZCGc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjEZCGS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:06:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF7CA3
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:06:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF65B64C4F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCFBC433D2;
        Fri, 26 May 2023 02:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066776;
        bh=HQrr6+hYPlhCrX7jFLlmp18jgRZWza3/FWU7wMoKHRc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=eoq1My1EsXdB7kpz7HaxJtQDv4htppP8H15AgAZxhckTcytsxd5It0TqDWvIqsd7X
         SsJLOXq7GOLoeP+ZA6DfyTUgtc32a02ZuD785JYNT3F5jiND7/BdhPyQqLfZOp+Czr
         7h74DJFfapKAu7fn9NXGnr4d8t1EPgi1Ynz5GT+/2ewxQCLobPLPjN8ZEYOw/N0/xQ
         94p2GveWxvcdPRmvQQTaDEJk66low0Wqv+D5m1YfrKQ1RrIPmIVSm5KIB2rdMdq1d5
         E++R5fzl3+aWRCoujcDuOWrWnxv0u/yQpu1u3veBgmXUjsPHx8ER7m/RDuEuDzi9+L
         1+MkcAe0VyqdA==
Date:   Thu, 25 May 2023 19:06:15 -0700
Subject: [PATCH 5/7] xfs: Hold inode locks in xfs_rename
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506071836.3743141.6595120872089094450.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071753.3743141.6199971931108916142.stgit@frogsfrogsfrogs>
References: <168506071753.3743141.6199971931108916142.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_rename to hold all inode locks across a rename operation
We will need this later when we add parent pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e7a0857926c0..ba89b879e7d6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2707,6 +2707,21 @@ xfs_remove(
 	return error;
 }
 
+static inline void
+xfs_iunlock_rename(
+	struct xfs_inode	**i_tab,
+	int			num_inodes)
+{
+	int			i;
+
+	for (i = num_inodes - 1; i >= 0; i--) {
+		/* Skip duplicate inodes if src and target dps are the same */
+		if (!i_tab[i] || (i > 0 && i_tab[i] == i_tab[i - 1]))
+			continue;
+		xfs_iunlock(i_tab[i], XFS_ILOCK_EXCL);
+	}
+}
+
 /*
  * Enter all inodes for a rename transaction into a sorted array.
  */
@@ -3016,8 +3031,10 @@ xfs_rename(
 	 * Attach the dquots to the inodes
 	 */
 	error = xfs_qm_vop_rename_dqattach(inodes);
-	if (error)
-		goto out_trans_cancel;
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out_release_wip;
+	}
 
 	/*
 	 * Lock all the participating inodes. Depending upon whether
@@ -3028,18 +3045,16 @@ xfs_rename(
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
-	 * Join all the inodes to the transaction. From this point on,
-	 * we can rely on either trans_commit or trans_cancel to unlock
-	 * them.
+	 * Join all the inodes to the transaction.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -3053,10 +3068,13 @@ xfs_rename(
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
+		xfs_iunlock_rename(inodes, num_inodes);
+		return error;
+	}
 
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
@@ -3070,6 +3088,7 @@ xfs_rename(
 		if (error == -EDQUOT || error == -ENOSPC) {
 			if (!retried) {
 				xfs_trans_cancel(tp);
+				xfs_iunlock_rename(inodes, num_inodes);
 				xfs_blockgc_free_quota(target_dp, 0);
 				retried = true;
 				goto retry;
@@ -3296,12 +3315,14 @@ xfs_rename(
 		xfs_dir_update_hook(src_dp, wip, 1, src_name);
 
 	error = xfs_finish_rename(tp);
+	xfs_iunlock_rename(inodes, num_inodes);
 	if (wip)
 		xfs_irele(wip);
 	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock_rename(inodes, num_inodes);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);

