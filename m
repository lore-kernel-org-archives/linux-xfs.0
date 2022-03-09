Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F6BC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 19:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbiCITYH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237860AbiCITYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 14:24:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD512AF0
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 11:22:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EAAA6191F
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 19:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5092C340E8;
        Wed,  9 Mar 2022 19:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646853752;
        bh=eJB3bU/cm5dlNW6Kmor1M/9eWw6OHsVI3e+RAY+W5Qw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tKo32TL3ncvTmrMUH8LSDHoy5zR6Ux3YChhfD0/4+AH2e4ne/bfZUcPw5+sQxWGra
         LO3Mow8RUZs2VFhcur3Wh48d3beFxxR2MviDk0BeRYSXSa+jxB1pfOboAe0eS6xkly
         MHYSYfTSA2qTlOx7JKx64/S2ev0l/Q6JQYEYoP7Mmz8sdG6RXEb4TxLXuuEF1pzjun
         lVv5OnUBV8OmbRJoENAcjEQ32KUFnJBMVoX4Qy6SOr4b8wNtdkQSLVQ1H/6ygUvHub
         QBVesFwZ+HZsqGj26XlXk2sJGQqjNsSfDvG8HXXTLMndhEqA4msJURx0rZeaPKjsyh
         RhTqWhdin6tXg==
Subject: [PATCH 2/2] xfs: reserve quota for target dir expansion when renaming
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 09 Mar 2022 11:22:32 -0800
Message-ID: <164685375248.495923.9228795379646460264.stgit@magnolia>
In-Reply-To: <164685374120.495923.2523387358442198692.stgit@magnolia>
References: <164685374120.495923.2523387358442198692.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XFS does not reserve quota for directory expansion when renaming
children into a directory.  This means that we don't reject the
expansion with EDQUOT when we're at or near a hard limit, which means
that unprivileged userspace can use rename() to exceed quota.

Rename operations don't always expand the target directory, and we allow
a rename to proceed with no space reservation if we don't need to add a
block to the target directory to handle the addition.  Moreover, the
unlink operation on the source directory generally does not expand the
directory (you'd have to free a block and then cause a btree split) and
it's probably of little consequence to leave the corner case that
renaming a file out of a directory can increase its size.

As with link and unlink, there is a further bug in that we do not
trigger the blockgc workers to try to clear space when we're out of
quota.

Because rename is its own special tricky animal, we'll patch xfs_rename
directly to reserve quota to the rename transaction.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a131bbfe74e4..8ff67b7aad53 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3095,7 +3095,8 @@ xfs_rename(
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
 	int			spaceres;
-	int			error;
+	bool			retried = false;
+	int			error, space_error;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -3119,9 +3120,12 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
 
+retry:
+	space_error = 0;
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
+		space_error = error;
 		spaceres = 0;
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, 0, 0, 0,
 				&tp);
@@ -3175,6 +3179,31 @@ xfs_rename(
 					target_dp, target_name, target_ip,
 					spaceres);
 
+	/*
+	 * Try to reserve quota to handle an expansion of the target directory.
+	 * We'll allow the rename to continue in reservationless mode if we hit
+	 * a space usage constraint.  If we trigger reservationless mode, save
+	 * the errno if there isn't any free space in the target directory.
+	 */
+	if (spaceres != 0) {
+		error = xfs_trans_reserve_quota_nblks(tp, target_dp, spaceres,
+				0, false);
+		if (error == -EDQUOT || error == -ENOSPC) {
+			if (!retried) {
+				xfs_trans_cancel(tp);
+				xfs_blockgc_free_quota(target_dp, 0);
+				retried = true;
+				goto retry;
+			}
+
+			space_error = error;
+			spaceres = 0;
+			error = 0;
+		}
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
@@ -3215,6 +3244,8 @@ xfs_rename(
 		 */
 		if (!spaceres) {
 			error = xfs_dir_canenter(tp, target_dp, target_name);
+			if (error == -ENOSPC && space_error)
+				error = space_error;
 			if (error)
 				goto out_trans_cancel;
 		} else {
@@ -3299,6 +3330,8 @@ xfs_rename(
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
 					   src_ip->i_ino, spaceres);
+		if (error == -ENOSPC && space_error)
+			error = space_error;
 		if (error)
 			goto out_trans_cancel;
 
@@ -3320,6 +3353,8 @@ xfs_rename(
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, spaceres);
+		if (error == -ENOSPC && space_error)
+			error = space_error;
 		if (error)
 			goto out_trans_cancel;
 

