Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706EDC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 250DA64DD6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhA1GGK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:06:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231292AbhA1GFJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:05:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8605764DD1;
        Thu, 28 Jan 2021 06:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813868;
        bh=MRaG2Ug2DUg770dkXoUz2VCZV42V87UxFZQICJwb6Mg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C3WxveYxZ89w2AdSGAZV+Syin0hqTdRPD+Czguv/IQfnX+3/QZarnlV042GeWVY8V
         G44UMP267I67VHXcqB5pF9D0bsE7v8yw6XM4X9dGpydc2ZuZRxsJBJILghjCyTnF31
         gX0+i6u1IElyAaHE/1qmMMignk+W4RLWfdu1hOk+0f9yVUyoSPR7fqE7UMHZVepWav
         73ity2T6U79QKgnYXc4lSBc6IjDSaeA/EJPpZb61z2m19/tcVJBIrOY58NFvFJIPbE
         RNP63VCyxNiSEvClVve+a6O1EIKWsW7gaG3ZvLrUXJOCGzW7HsZcOr+y372fH5jE19
         BHWZjmjoQroMA==
Subject: [PATCH 08/11] xfs: rename block gc start and stop functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:04:24 -0800
Message-ID: <161181386476.1525433.8339178086850291529.stgit@magnolia>
In-Reply-To: <161181381898.1525433.10723801103841220046.stgit@magnolia>
References: <161181381898.1525433.10723801103841220046.stgit@magnolia>
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
index b32400b8e1ee..675c9e17dac0 100644
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
index 471592e8dba6..ea942089d074 100644
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

