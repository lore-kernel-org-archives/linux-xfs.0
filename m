Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AD9C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4174160F5E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhG2SoI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230046AbhG2SoI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:44:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2A4D60F4B;
        Thu, 29 Jul 2021 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584245;
        bh=MEz476hKWacgNEZs5rEHMsXGLIlgNS0Rg8tiO/mmNjs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eSIjAUVd9JS5wWDKNyyDCfysFkTG8Evf4iEpVIW1iNz+72usc/vsJQ07bNj3ySMDv
         D9df8bFjTT5UjgGGGwNb3TX4U9E2hNE0Z+LB/7gK40pZZnLW9m0+oj0SBLtHcwYtJD
         vtWAwiqHQZO6hzFuI+jw+EBXNWsXR4OXkdVvM8HkwVNHE5Ol+pa+yu0WXyVAekhvUK
         67qOvMuT3aIufKW6YQMb3VMarmKPj+3hVyCBxlyKcXpPSWCLmFDfuHQmMxlAEYYoiq
         /9JpJ6BKUC9p2OmzkjOx5ZX6EgwzIFaMnkQ1xSavWNv4u/jxNiuxBBrnVfnPCskmkO
         ge1N9npI/qE6A==
Subject: [PATCH 02/20] xfs: detach dquots from inode if we don't need to
 inactivate it
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:44:04 -0700
Message-ID: <162758424463.332903.16121207573614065368.stgit@magnolia>
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
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
preparation patch for deferred inactivation per reviewer request[1] to
move the creation of xfs_inode_needs_inactivation into a separate
change.  Eventually this !need_inactive chunk will turn into the code
path for inodes that skip xfs_inactive and go straight to memory
reclaim.

[1] https://lore.kernel.org/linux-xfs/20210609012838.GW2945738@locust/T/#mca6d958521cb88bbc1bfe1a30767203328d410b5
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    8 +++++++-
 fs/xfs/xfs_inode.c  |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h  |    2 ++
 3 files changed, 62 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7bc2690da87d..709507cc83ae 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -329,8 +329,14 @@ xfs_inode_mark_reclaimable(
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
index 990b72ae3635..3c6ce1f6f643 100644
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
 

