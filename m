Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA482C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240004AbjDFTUh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240275AbjDFTUa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:20:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DAB7ED5
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA02E60C99
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AE0C433D2;
        Thu,  6 Apr 2023 19:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808825;
        bh=u+1LWY/KWyHVv6AjElb+LX1VjyMrpTUcWi0lD+1rnXE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=i1UCdKWn/uomldipQOX0jq3lGgHkNchlYRvkRF8NlTuj5CRUhnJ3jW3EFLj4ivoLs
         eUvpANySEta6cy450mHSeZTVXxToLskVsdcDNnbcYdeasPsr7w2v0Of/ObbrSi3By8
         zKXSd0oqKpk7ueQq2WozasUCPVQyds7GptgeCYsnaycR/MHlrm9fvOfpqjHTGk7Pa/
         bPsE2cv/daOR16hVWt+tnDxHKiFWUYPFtgHfYKav+9TX0Kgh4IlzEXpbhcgvhb8/FH
         0dDNAffliHYnXTQkqzrOfdbCzFQWBJfyGl5VNDKyElKeZnLamfLYbdRxQGfEde8qIb
         HNHAWn6kt13aA==
Date:   Thu, 06 Apr 2023 12:20:24 -0700
Subject: [PATCH 3/3] xfs: Hold inode locks in xfs_rename
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824305.615105.2972427731167831639.stgit@frogsfrogsfrogs>
In-Reply-To: <168080824260.615105.7346122486674782401.stgit@frogsfrogsfrogs>
References: <168080824260.615105.7346122486674782401.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/xfs_inode.c |   43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cb68e6661c96..a62e07ae9c80 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2541,6 +2541,21 @@ xfs_remove(
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
@@ -2839,18 +2854,16 @@ xfs_rename(
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
@@ -2864,10 +2877,12 @@ xfs_rename(
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
+		goto out_unlock;
+	}
 
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
@@ -2881,6 +2896,7 @@ xfs_rename(
 		if (error == -EDQUOT || error == -ENOSPC) {
 			if (!retried) {
 				xfs_trans_cancel(tp);
+				xfs_iunlock_rename(inodes, num_inodes);
 				xfs_blockgc_free_quota(target_dp, 0);
 				retried = true;
 				goto retry;
@@ -3092,12 +3108,13 @@ xfs_rename(
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
-	if (wip)
-		xfs_irele(wip);
-	return error;
+
+	goto out_unlock;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock_rename(inodes, num_inodes);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);

