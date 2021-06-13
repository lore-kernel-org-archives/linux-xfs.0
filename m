Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C788C48BDF
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E62E061078
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhFMRWQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 13:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhFMRWP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:22:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD7B761107;
        Sun, 13 Jun 2021 17:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604813;
        bh=5ltstnOjOSXrVfpaxHSZ8nTRKPJFB1bmc7ZhGKceso0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dVDhCzhkUPA4wLR34Bb0zCdCCA311HUHXjiNBVg9763cfDHAbn6c6lF1C4yGkMA5e
         ShxaaOg5qIgLSrGWRdy2BRJr6FuefxQeKbaraH78vxh2OELmNJ6Ng4D318UBCsKXqd
         c3dleC0GCP1VrNya8MMcnFO4EgK5mf+4lnRvqBvWVHkxbos8k7YJ8XeD/Caj4KSEyH
         y0SuIGcYULg6V0cJhOzHtRc17yGdOl6PvbJ9643ojl1uOAoD9jqmunEUApt3W3a1Qz
         ss6/R3Klp1v2dzqqijy8dAazSOReN1ZZjmNCuxg1g9l1XYty8IcSzkJizznTLyMpD7
         61Eyjo2KJX3xg==
Subject: [PATCH 03/16] xfs: detach dquots from inode if we don't need to
 inactivate it
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:20:13 -0700
Message-ID: <162360481340.1530792.16718628800672012784.stgit@locust>
In-Reply-To: <162360479631.1530792.17147217854887531696.stgit@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we don't need to inactivate an inode, we can detach the dquots and
move on to reclamation.  This isn't strictly required here; it's a
preparation patch for deferred inactivation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    8 +++++++-
 fs/xfs/xfs_inode.c  |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h  |    2 ++
 3 files changed, 62 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a2d81331867b..7939eced3a47 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -338,8 +338,14 @@ xfs_inode_mark_reclaimable(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	bool			need_inactive = xfs_inode_needs_inactive(ip);
 
-	xfs_inactive(ip);
+	if (!need_inactive) {
+		/* Going straight to reclaim, so drop the dquots. */
+		xfs_qm_dqdetach(ip);
+	} else {
+		xfs_inactive(ip);
+	}
 
 	if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
 		xfs_check_delalloc(ip, XFS_DATA_FORK);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3bee1cd20072..85b2b11b5217 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1654,6 +1654,59 @@ xfs_inactive_ifree(
 	return 0;
 }
 
+/*
+ * Returns true if we need to update the on-disk metadata before we can free
+ * the memory used by this inode.  Updates include freeing post-eof
+ * preallocations; freeing COW staging extents; and marking the inode free in
+ * the inobt if it is on the unlinked list.
+ */
+bool
+xfs_inode_needs_inactive(
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
+	/* If the log isn't running, push inodes straight to reclaim. */
+	if (XFS_FORCED_SHUTDOWN(mp) || (mp->m_flags & XFS_MOUNT_NORECOVERY))
+		return false;
+
+	/* Metadata inodes require explicit resource cleanup. */
+	if (xfs_is_metadata_inode(ip))
+		return false;
+
+	/* Want to clean out the cow blocks if there are any. */
+	if (cow_ifp && cow_ifp->if_bytes > 0)
+		return true;
+
+	/* Unlinked files must be freed. */
+	if (VFS_I(ip)->i_nlink == 0)
+		return true;
+
+	/*
+	 * This file isn't being freed, so check if there are post-eof blocks
+	 * to free.  @force is true because we are evicting an inode from the
+	 * cache.  Post-eof blocks must be freed, lest we end up with broken
+	 * free space accounting.
+	 *
+	 * Note: don't bother with iolock here since lockdep complains about
+	 * acquiring it in reclaim context. We have the only reference to the
+	 * inode at this point anyways.
+	 */
+	return xfs_can_free_eofblocks(ip, true);
+}
+
 /*
  * xfs_inactive
  *
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 4b6703dbffb8..e3137bbc7b14 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -493,6 +493,8 @@ extern struct kmem_zone	*xfs_inode_zone;
 /* The default CoW extent size hint. */
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
+bool xfs_inode_needs_inactive(struct xfs_inode *ip);
+
 int xfs_iunlink_init(struct xfs_perag *pag);
 void xfs_iunlink_destroy(struct xfs_perag *pag);
 

