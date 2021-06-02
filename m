Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CB4C47080
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46A8A613C1
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhFBAy0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:54:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhFBAy0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:54:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2207613C3;
        Wed,  2 Jun 2021 00:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595164;
        bh=Oedf8MTwXam2mgPaMaYPWNdWoRdwzcYcWocDGEbJDU4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kE1OKuuOklw3ZncQerInMDOq7EbNE4fJdJZf8oojamE0NEnaKtjVjTqA9BVsLAcHu
         jWl60Y3iK4Yzgzgw3UYkUzrK2/k5PGOb2eCGPUq2oRgNBv624AAIvSl8ENSegE8Wsy
         IQrB7TI+d272Qgv6F5HhxCQa98E/IwVy/1ZWVFua/FneJSFqU1s0GrnxwhwQ3E4CMI
         lObVrvz3beI59+PwZGe500MesT1LsNBAi9JJ1Dd3dMZvjLBiCT6pqFOssaEuPMW4o5
         hBSZJGPwGA0ZJYpKHPno8Wb+er8sY2gizlD6gnEG/uQV1sXzN5JTfbmErOnfg3Gnxf
         3bdSiE3mxyRrQ==
Subject: [PATCH 02/14] xfs: detach inode dquots at the end of inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:52:43 -0700
Message-ID: <162259516368.662681.13563427839198579046.stgit@locust>
In-Reply-To: <162259515220.662681.6750744293005850812.stgit@locust>
References: <162259515220.662681.6750744293005850812.stgit@locust>
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
index 804d0b36afdc..1de5846b3c0a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1082,7 +1082,7 @@ xfs_reclaim_inode(
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

