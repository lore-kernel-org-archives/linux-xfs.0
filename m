Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A93FC47080
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CEE3611CB
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhEaWmn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 18:42:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232268AbhEaWmm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 May 2021 18:42:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73543611CA;
        Mon, 31 May 2021 22:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622500862;
        bh=Qq/EaDuOT7OHdUg0Pj3P9kaOKblRYxo8LBcIkFQEKkc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bGnDmE9TdcBDgMDZ+xM3sXlFl1KjOkqk245OYtENbKvTFYsHzr8iXM/I6W0dLzjwi
         aFh1U3+KoiLC9Algu8mI/7+jHmyW5Uf0+pcpX4n45+rRbKGtq390vTQA356Ys9fxrI
         5mJXlGXvuypkGQqo+ZBlNlt5ySrnh4TzPBy373JiGSCFtoE+GcyC5aGBEEWs7cb6IY
         LREpXL9RrdFQ7o2axMyLY5EpH4b+3PnIh1zs+OnVWnyXJrA1rNxZLWsWVacZaXzSre
         k4TTPXo4FnqiCTen8mxUn0ZKQw3uBmRxdh+ZwuxFG9x7GZx/a6k2Bk+i+1nrTZn3Ly
         7UrVhTbpY6NHw==
Subject: [PATCH 2/5] xfs: detach inode dquots at the end of inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 31 May 2021 15:41:02 -0700
Message-ID: <162250086215.490412.4278433430856337071.stgit@locust>
In-Reply-To: <162250085103.490412.4291071116538386696.stgit@locust>
References: <162250085103.490412.4291071116538386696.stgit@locust>
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
---
 fs/xfs/xfs_icache.c |    2 +-
 fs/xfs/xfs_inode.c  |   22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 32c17e84efa0..34b8b5fbd60d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1080,7 +1080,7 @@ xfs_reclaim_inode(
 	 * unlocked after the lookup before we go ahead and free it.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_qm_dqdetach(ip);
+	ASSERT(!ip->i_udquot && !ip->i_gdquot && !ip->i_pdquot);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	ASSERT(xfs_inode_clean(ip));
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1e28997c6f78..718ab0c17b9d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1713,7 +1713,7 @@ xfs_inactive(
 	 */
 	if (VFS_I(ip)->i_mode == 0) {
 		ASSERT(ip->i_df.if_broot_bytes == 0);
-		return;
+		goto out;
 	}
 
 	mp = ip->i_mount;
@@ -1721,11 +1721,11 @@ xfs_inactive(
 
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
@@ -1744,7 +1744,7 @@ xfs_inactive(
 		if (xfs_can_free_eofblocks(ip, true))
 			xfs_free_eofblocks(ip);
 
-		return;
+		goto out;
 	}
 
 	if (S_ISREG(VFS_I(ip)->i_mode) &&
@@ -1754,14 +1754,14 @@ xfs_inactive(
 
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
@@ -1771,7 +1771,7 @@ xfs_inactive(
 	if (XFS_IFORK_Q(ip)) {
 		error = xfs_attr_inactive(ip);
 		if (error)
-			return;
+			goto out;
 	}
 
 	ASSERT(!ip->i_afp);
@@ -1780,12 +1780,12 @@ xfs_inactive(
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

