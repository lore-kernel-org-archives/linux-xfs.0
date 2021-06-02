Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8069C47083
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92999613DE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhFBW0w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:26:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFBW0v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:26:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63EE1613AC;
        Wed,  2 Jun 2021 22:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672708;
        bh=oBl7LUbZXx5Ux7N6ocRUo7ZevhWYuIg1D11BT5Yegf8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fKe4J0eLK3C7AyVimApcDHGJ4q83u3xBfcnr//Tr/C7AC9HcHrcAVuKbH6jY8pUOd
         pgU/qPobMIESPiVmMaLBN6Sa6NS1Z24qIb/G9352SWeV1bS2UheYQyOgaXFR0fLUMN
         xeuxZpjVnX7wtAGCjhJqdIlGte4QUDzQ5PC5JlLzPoUL4Z6Povb2Kf7k0pfp3mKUp3
         ot0YcR0UT/f7oXwGNt+TdBYdcNOfqYk0AxFUYerDmURQqY8lcT/rUTsUzNjD8oOFg3
         LkVrOI6LXEUoH1boRIN3X/FC3oIVv4LrfiISGwv9DcjfbqsMhzAdKPCvjXGDRAQvS9
         EiTfhsjSAdBkw==
Subject: [PATCH 02/15] xfs: detach inode dquots at the end of inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:25:08 -0700
Message-ID: <162267270808.2375284.11171512285980946391.stgit@locust>
In-Reply-To: <162267269663.2375284.15885514656776142361.stgit@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Once we're done with inactivating an inode, we're finished updating
metadata for that inode.  This means that we can detach the dquots at
the end and not have to wait for reclaim to do it for us.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c |    2 +-
 fs/xfs/xfs_inode.c  |   22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e2edbcf7a528..dfa0ec7d02b8 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1093,7 +1093,7 @@ xfs_reclaim_inode(
 	 * unlocked after the lookup before we go ahead and free it.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_qm_dqdetach(ip);
+	ASSERT(!ip->i_udquot && !ip->i_gdquot && !ip->i_pdquot);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	ASSERT(xfs_inode_clean(ip));
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e4c2da4566f1..51972549e73c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1716,7 +1716,7 @@ xfs_inactive(
 	 */
 	if (VFS_I(ip)->i_mode == 0) {
 		ASSERT(ip->i_df.if_broot_bytes == 0);
-		return;
+		goto out;
 	}
 
 	mp = ip->i_mount;
@@ -1724,11 +1724,11 @@ xfs_inactive(
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
-		return;
+		goto out;
 
 	/* Metadata inodes require explicit resource cleanup. */
 	if (xfs_is_metadata_inode(ip))
-		return;
+		goto out;
 
 	/* Try to clean out the cow blocks if there are any. */
 	if (xfs_inode_has_cow_data(ip))
@@ -1747,7 +1747,7 @@ xfs_inactive(
 		if (xfs_can_free_eofblocks(ip, true))
 			xfs_free_eofblocks(ip);
 
-		return;
+		goto out;
 	}
 
 	if (S_ISREG(VFS_I(ip)->i_mode) &&
@@ -1757,14 +1757,14 @@ xfs_inactive(
 
 	error = xfs_qm_dqattach(ip);
 	if (error)
-		return;
+		goto out;
 
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
 	else if (truncate)
 		error = xfs_inactive_truncate(ip);
 	if (error)
-		return;
+		goto out;
 
 	/*
 	 * If there are attributes associated with the file then blow them away
@@ -1774,7 +1774,7 @@ xfs_inactive(
 	if (XFS_IFORK_Q(ip)) {
 		error = xfs_attr_inactive(ip);
 		if (error)
-			return;
+			goto out;
 	}
 
 	ASSERT(!ip->i_afp);
@@ -1783,12 +1783,12 @@ xfs_inactive(
 	/*
 	 * Free the inode.
 	 */
-	error = xfs_inactive_ifree(ip);
-	if (error)
-		return;
+	xfs_inactive_ifree(ip);
 
+out:
 	/*
-	 * Release the dquots held by inode, if any.
+	 * We're done making metadata updates for this inode, so we can release
+	 * the attached dquots.
 	 */
 	xfs_qm_dqdetach(ip);
 }

