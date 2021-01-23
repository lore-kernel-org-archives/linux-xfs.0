Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE859C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F62522B2D
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbhAWSys (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbhAWSyp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:54:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E738B22D2B;
        Sat, 23 Jan 2021 18:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611428045;
        bh=L13pl1BODhCCWUatu29N8FzRiWLhfZLzAWzRRZG28es=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XroTXOxkt3AZXxu3LzwkRWczIMtubmkXm3foE54xUsCTm6fbyBVvhyXbt1m4Rx0ai
         cTUnCqPYtF6ODnF7zmWNQamsairWQDwSx2J1ZUIxqFDDlqNpIX5nJDq1/b8eAxrGfe
         g6OVH7IewPHutlfOWjPMisVHiJ8hpL5u3oGoTNqzT7XkAMX8RH1czZJJvG+s+MdsSG
         IOASLHVlxsNHymAfAe5sUSYO3v8fUi0kWXPGfNSFNKlz3vbIowE5FavIs6MwV/udlb
         zXS7mpnp7szEaEYpnTy9YgW5BzNmVz3NDR3ZzFHFUg0bYbPhrLcuHqDbfFtQXtGp+f
         htJMGJ+ly44RA==
Subject: [PATCH 8/9] xfs: rename block gc start and stop functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:54:06 -0800
Message-ID: <161142804648.2173480.12340267234630029170.stgit@magnolia>
In-Reply-To: <161142800187.2173480.17415824680111946713.stgit@magnolia>
References: <161142800187.2173480.17415824680111946713.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Shorten the names of the two functions that start and stop block
preallocation garbage collection and move them up to the other blockgc
functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c |    4 ++--
 fs/xfs/xfs_icache.c   |    4 ++--
 fs/xfs/xfs_icache.h   |    4 ++--
 fs/xfs/xfs_mount.c    |    2 +-
 fs/xfs/xfs_super.c    |    8 ++++----
 5 files changed, 11 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 8ea6d4aa3f55..53456f3de881 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -888,7 +888,7 @@ xchk_stop_reaping(
 	struct xfs_scrub	*sc)
 {
 	sc->flags |= XCHK_REAPING_DISABLED;
-	xfs_stop_block_reaping(sc->mp);
+	xfs_blockgc_stop(sc->mp);
 }
 
 /* Restart background reaping of resources. */
@@ -896,6 +896,6 @@ void
 xchk_start_reaping(
 	struct xfs_scrub	*sc)
 {
-	xfs_start_block_reaping(sc->mp);
+	xfs_blockgc_start(sc->mp);
 	sc->flags &= ~XCHK_REAPING_DISABLED;
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 61d06f34fdd7..34cee5fc2d95 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1557,7 +1557,7 @@ xfs_inode_clear_cowblocks_tag(
 
 /* Disable post-EOF and CoW block auto-reclamation. */
 void
-xfs_stop_block_reaping(
+xfs_blockgc_stop(
 	struct xfs_mount	*mp)
 {
 	cancel_delayed_work_sync(&mp->m_blockgc_work);
@@ -1565,7 +1565,7 @@ xfs_stop_block_reaping(
 
 /* Enable post-EOF and CoW block auto-reclamation. */
 void
-xfs_start_block_reaping(
+xfs_blockgc_start(
 	struct xfs_mount	*mp)
 {
 	xfs_blockgc_queue(mp);
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d781703af025..6ffb2fc5e458 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -74,7 +74,7 @@ int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
 
-void xfs_stop_block_reaping(struct xfs_mount *mp);
-void xfs_start_block_reaping(struct xfs_mount *mp);
+void xfs_blockgc_stop(struct xfs_mount *mp);
+void xfs_blockgc_start(struct xfs_mount *mp);
 
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 53b8ccab7235..be9ce114527f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1054,7 +1054,7 @@ xfs_unmountfs(
 	uint64_t		resblks;
 	int			error;
 
-	xfs_stop_block_reaping(mp);
+	xfs_blockgc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 143d54f61974..40bfb7074e50 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -891,7 +891,7 @@ xfs_fs_freeze(
 	 * set a GFP_NOFS context here to avoid recursion deadlocks.
 	 */
 	flags = memalloc_nofs_save();
-	xfs_stop_block_reaping(mp);
+	xfs_blockgc_stop(mp);
 	xfs_save_resvblks(mp);
 	ret = xfs_log_quiesce(mp);
 	memalloc_nofs_restore(flags);
@@ -906,7 +906,7 @@ xfs_fs_unfreeze(
 
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
-	xfs_start_block_reaping(mp);
+	xfs_blockgc_start(mp);
 	return 0;
 }
 
@@ -1690,7 +1690,7 @@ xfs_remount_rw(
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
 	}
-	xfs_start_block_reaping(mp);
+	xfs_blockgc_start(mp);
 
 	/* Create the per-AG metadata reservation pool .*/
 	error = xfs_fs_reserve_ag_blocks(mp);
@@ -1710,7 +1710,7 @@ xfs_remount_ro(
 	 * Cancel background eofb scanning so it cannot race with the final
 	 * log force+buftarg wait and deadlock the remount.
 	 */
-	xfs_stop_block_reaping(mp);
+	xfs_blockgc_stop(mp);
 
 	/* Get rid of any leftover CoW reservations... */
 	error = xfs_blockgc_free_space(mp, NULL);

