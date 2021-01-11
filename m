Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB1FC433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C949022DFA
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbhALAZ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404100AbhAKXYd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:24:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E509122D49;
        Mon, 11 Jan 2021 23:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407433;
        bh=/5fV5sYChufGBjTo3sip0G1ok6NTElT+pdnvRy7Dsxc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ECJ33UMpj0mZwLMY7Uzz1VZrt6Z61vCPF7Xjmb2xpioNF5AW305xiXxp4rIAWOTh0
         T1VWd9AraTeVm9KlHvm0l8lgWHuXNjIcpJpiLqQvzmgAY4kie+xt/yVnzjb+/12l6z
         Gb5ASETQykn4GHqQecqtxwF4Z2E19SVyKpZdq6y7h5Z3T6bmdt3SOl7Cqb8+osf0Wa
         o5hCrjmROx1t7W+lMW9L8CeCNvQLmSz38YM2XMn9cb4pLxZE/ef1fczr5D56jnCJF0
         4UOqdMVEJmSTHluil9ogZAybceViLW94SLVYLrWqoWSzfiGW/CSuA8had2e2KK+ope
         Edjpur7+nf7vA==
Subject: [PATCH 6/7] xfs: rename block gc start and stop functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:23:52 -0800
Message-ID: <161040743287.1582286.3961995540471736727.stgit@magnolia>
In-Reply-To: <161040739544.1582286.11068012972712089066.stgit@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
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
---
 fs/xfs/scrub/common.c |    4 ++--
 fs/xfs/xfs_icache.c   |   32 ++++++++++++++++----------------
 fs/xfs/xfs_icache.h   |    4 ++--
 fs/xfs/xfs_mount.c    |    2 +-
 fs/xfs/xfs_super.c    |    8 ++++----
 5 files changed, 25 insertions(+), 25 deletions(-)


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
index 4f68375cf873..d1179f3e9d1f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -996,6 +996,22 @@ xfs_blockgc_worker(
 	xfs_queue_blockgc(mp);
 }
 
+/* Disable post-EOF and CoW block auto-reclamation. */
+void
+xfs_blockgc_stop(
+	struct xfs_mount	*mp)
+{
+	cancel_delayed_work_sync(&mp->m_blockgc_work);
+}
+
+/* Enable post-EOF and CoW block auto-reclamation. */
+void
+xfs_blockgc_start(
+	struct xfs_mount	*mp)
+{
+	xfs_queue_blockgc(mp);
+}
+
 /*
  * Grab the inode for reclaim exclusively.
  *
@@ -1713,19 +1729,3 @@ xfs_inode_clear_cowblocks_tag(
 	trace_xfs_inode_clear_cowblocks_tag(ip);
 	return __xfs_inode_clear_blocks_tag(ip, XFS_ICOWBLOCKS);
 }
-
-/* Disable post-EOF and CoW block auto-reclamation. */
-void
-xfs_stop_block_reaping(
-	struct xfs_mount	*mp)
-{
-	cancel_delayed_work_sync(&mp->m_blockgc_work);
-}
-
-/* Enable post-EOF and CoW block auto-reclamation. */
-void
-xfs_start_block_reaping(
-	struct xfs_mount	*mp)
-{
-	xfs_queue_blockgc(mp);
-}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 4ddb2c6de18b..5bcea900bc30 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -68,7 +68,7 @@ int xfs_inode_walk(struct xfs_mount *mp,
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
 
-void xfs_stop_block_reaping(struct xfs_mount *mp);
-void xfs_start_block_reaping(struct xfs_mount *mp);
+void xfs_blockgc_stop(struct xfs_mount *mp);
+void xfs_blockgc_start(struct xfs_mount *mp);
 
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1e974106e58c..c3144cf5febe 100644
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
index 7fb024f96964..f72c1f473025 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -920,7 +920,7 @@ xfs_fs_freeze(
 	 * set a GFP_NOFS context here to avoid recursion deadlocks.
 	 */
 	flags = memalloc_nofs_save();
-	xfs_stop_block_reaping(mp);
+	xfs_blockgc_stop(mp);
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
 	ret = xfs_sync_sb(mp, true);
@@ -936,7 +936,7 @@ xfs_fs_unfreeze(
 
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
-	xfs_start_block_reaping(mp);
+	xfs_blockgc_start(mp);
 	return 0;
 }
 
@@ -1720,7 +1720,7 @@ xfs_remount_rw(
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
 	}
-	xfs_start_block_reaping(mp);
+	xfs_blockgc_start(mp);
 
 	/* Create the per-AG metadata reservation pool .*/
 	error = xfs_fs_reserve_ag_blocks(mp);
@@ -1740,7 +1740,7 @@ xfs_remount_ro(
 	 * Cancel background eofb scanning so it cannot race with the final
 	 * log force+buftarg wait and deadlock the remount.
 	 */
-	xfs_stop_block_reaping(mp);
+	xfs_blockgc_stop(mp);
 
 	/* Get rid of any leftover CoW reservations... */
 	error = xfs_icache_free_cowblocks(mp, NULL);

