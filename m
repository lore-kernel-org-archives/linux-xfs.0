Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC168C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E26964FC8
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhCKDGE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhCKDGD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:06:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECB4A64FC4;
        Thu, 11 Mar 2021 03:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615431963;
        bh=rkFPfgneG8SPucad0U2iTgZHLihxGMnr4JNJfcvnXvw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Cg6KcOJPncqAt3eMCta5JZLnY8u6C99mIL4/n2bKdeBG47Mis1TqPJo3ScJkdM65f
         OLrtQw4af09slFH9oPtQYskBxAIfr7Vu8rlIU+BnsyUgRhNuPNZGY5r5rptel4IJnB
         q9G7TGgaMP0G30FR3UgBF282hDXpo/aUuOnIVUOOrUX/ZGVOmZvxE1n0tP2UxgSUzY
         LtA7CwilWnY7rO+5xt3/8hMj409DKyqJZDPSPeUkccSnMQybv+4Ktd9kY7Ey8Xnpi6
         qFp3Xnkcq49Ucr+1EuDLxLn5ZzLgRTuxHX8Rnri59H2R7eEQJAqPzktp9+1l/1OIF7
         /GJ5ArggBLIcA==
Subject: [PATCH 04/11] xfs: decide if inode needs inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Mar 2021 19:06:02 -0800
Message-ID: <161543196269.1947934.4125444770307830204.stgit@magnolia>
In-Reply-To: <161543194009.1947934.9910987247994410125.stgit@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a predicate function to decide if an inode needs (deferred)
inactivation.  Any file that has been unlinked or has speculative
preallocations either for post-EOF writes or for CoW qualifies.
This function will also be used by the upcoming deferred inactivation
patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h |    2 ++
 2 files changed, 65 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 12c79962f8c3..65897cb0cf2a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1665,6 +1665,69 @@ xfs_inactive_ifree(
 	return 0;
 }
 
+/*
+ * Returns true if we need to update the on-disk metadata before we can free
+ * the memory used by this inode.  Updates include freeing post-eof
+ * preallocations; freeing COW staging extents; and marking the inode free in
+ * the inobt if it is on the unlinked list.
+ */
+bool
+xfs_inode_needs_inactivation(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*cow_ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+
+	/*
+	 * If the inode is already free, then there can be nothing
+	 * to clean up here.
+	 */
+	if (VFS_I(ip)->i_mode == 0)
+		return false;
+
+	/* If this is a read-only mount, don't do this (would generate I/O) */
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return false;
+
+	/* Metadata inodes require explicit resource cleanup. */
+	if (xfs_is_metadata_inode(ip))
+		return false;
+
+	/* Try to clean out the cow blocks if there are any. */
+	if (cow_ifp && cow_ifp->if_bytes > 0)
+		return true;
+
+	if (VFS_I(ip)->i_nlink != 0) {
+		int	error;
+		bool	has;
+
+		/*
+		 * force is true because we are evicting an inode from the
+		 * cache. Post-eof blocks must be freed, lest we end up with
+		 * broken free space accounting.
+		 *
+		 * Note: don't bother with iolock here since lockdep complains
+		 * about acquiring it in reclaim context. We have the only
+		 * reference to the inode at this point anyways.
+		 *
+		 * If the predicate errors out, send the inode through
+		 * inactivation anyway, because that's what we did before.
+		 * The inactivation worker will ignore an inode that doesn't
+		 * actually need it.
+		 */
+		if (!xfs_can_free_eofblocks(ip, true))
+			return false;
+		error = xfs_has_eofblocks(ip, &has);
+		return error != 0 || has;
+	}
+
+	/*
+	 * Link count dropped to zero, which means we have to mark the inode
+	 * free on disk and remove it from the AGI unlinked list.
+	 */
+	return true;
+}
+
 /*
  * xfs_inactive
  *
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c2c26f8f4a81..3fe8c8afbc72 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -480,6 +480,8 @@ extern struct kmem_zone	*xfs_inode_zone;
 /* The default CoW extent size hint. */
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
+bool xfs_inode_needs_inactivation(struct xfs_inode *ip);
+
 int xfs_iunlink_init(struct xfs_perag *pag);
 void xfs_iunlink_destroy(struct xfs_perag *pag);
 

