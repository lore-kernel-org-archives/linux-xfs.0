Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46D6C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 21:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbiCJVym (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 16:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbiCJVym (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 16:54:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A065014D244
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 13:53:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3644D61AC1
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 21:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD42C340E9;
        Thu, 10 Mar 2022 21:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646949219;
        bh=Abt/L0VmiTYd7xb4yaGSRPGdSXXy+qZar4o/Mr0GVU4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mBKZkde3VN0uR4F90R4BETo29vJbt2YwjY5j+U31WAHeTIcKHyRP4NF3dpgRy7+Cv
         lImz8/9VbPbz79AIczYPIHrowDOqB7w7kUxGZBXvRo/uyiGjX6cW1vA1afoCJmmIW3
         oW6nx4Jxh05YzuDwm28WJnElccyjno/odv6baqbzZNjqzmtwvgdnAfNTwwBFac0IbB
         fvyLa9IM5U/2jgXyudu7pmoLy2FoD4scZ+A4SnI9LOb4d4J9ZtnQR+T1/PttKluUJx
         PtS1umXPhDPVb5ra3LRUQRj2JOr6ZLk0FEZrT/n8FXNISWW8gxVeDrHZ1RaUipEx7a
         rOtu2kyA+oN/w==
Subject: [PATCH 2/2] xfs: reserve quota for target dir expansion when renaming
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 10 Mar 2022 13:53:39 -0800
Message-ID: <164694921916.1119636.2957657161513150271.stgit@magnolia>
In-Reply-To: <164694920783.1119636.13401244964062260779.stgit@magnolia>
References: <164694920783.1119636.13401244964062260779.stgit@magnolia>
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
directly to reserve quota to the rename transaction.  We'll leave
cleaning up the rest of xfs_rename for the metadata directory tree
patchset.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 766a621b970d..35a2489942e5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3097,7 +3097,8 @@ xfs_rename(
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
 	int			spaceres;
-	int			error;
+	bool			retried = false;
+	int			error, nospace_error = 0;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -3121,9 +3122,12 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
 
+retry:
+	nospace_error = 0;
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
+		nospace_error = error;
 		spaceres = 0;
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, 0, 0, 0,
 				&tp);
@@ -3177,6 +3181,31 @@ xfs_rename(
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
+			nospace_error = error;
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
@@ -3423,6 +3452,8 @@ xfs_rename(
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
+	if (error == -ENOSPC && nospace_error)
+		error = nospace_error;
 	return error;
 }
 

