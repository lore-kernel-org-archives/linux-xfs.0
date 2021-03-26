Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A00BC433E4
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19A5D61A41
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhCZAWq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhCZAWj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F12C619F3;
        Fri, 26 Mar 2021 00:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718159;
        bh=zgl34HvqTAtCGjsQ3Jux5nEoazBUgs+3KVhXjw2Yqrk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nSxl449nN/T8kGwpvKvMLwkwX2hCPLkHNWzTHkf1VbnoWkRj9LEo4w3r2SQc2MPF3
         rd4NnsFbWuPsLxDJSYYUa3+sqQgrNtA+XcNW/YQVekVJgiyY1BkD2GDqaCN2l06sSr
         J2LA5nAZgIhjo3rAaGcZmT0bds7HDeiEFI2cGQbtpNUZstxnQ6dZMrDozvCVBwM/zg
         KuqfRGfJw0Pni39+bF+cNjR4bVSxyfFpV4aCJE5Z6Jc5+JYc7DtlL6sxy8LnNonK/M
         RDbhvLoR+oaV+H81DxxrZtgJXoK6AxJfeM5qH10WsZsZbr+pt3heVnEyLJS5qtXdd7
         Ug1WFsvJcSlEg==
Subject: [PATCH 9/9] xfs: don't run speculative preallocation gc when fs is
 frozen
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:22:39 -0700
Message-ID: <161671815908.622901.11201307813479002034.stgit@magnolia>
In-Reply-To: <161671810866.622901.16520335819131743716.stgit@magnolia>
References: <161671810866.622901.16520335819131743716.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the infrastructure to switch background workers on and
off at will, fix the block gc worker code so that we don't actually run
the worker when the filesystem is frozen, same as we do for deferred
inactivation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   28 +++++++++++++++++++++++-----
 fs/xfs/xfs_mount.c  |    1 +
 fs/xfs/xfs_mount.h  |    3 +++
 fs/xfs/xfs_super.c  |    5 +++--
 4 files changed, 30 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e8a2e1cf7577..75a4df687d5d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1416,6 +1416,12 @@ xfs_inode_free_eofblocks(
 	return 0;
 }
 
+static inline bool
+xfs_blockgc_running(struct xfs_mount *mp)
+{
+	return test_bit(XFS_OPFLAG_BLOCKGC_RUNNING_BIT, &mp->m_opflags);
+}
+
 /*
  * Background scanning to trim preallocated space. This is queued based on the
  * 'speculative_prealloc_lifetime' tunable (5m by default).
@@ -1424,6 +1430,9 @@ static inline void
 xfs_blockgc_queue(
 	struct xfs_perag	*pag)
 {
+	if (!xfs_blockgc_running(pag->pag_mount))
+		return;
+
 	rcu_read_lock();
 	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG))
 		queue_delayed_work(pag->pag_mount->m_gc_workqueue,
@@ -1628,11 +1637,15 @@ void
 xfs_blockgc_stop(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
-	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
+	clear_bit(XFS_OPFLAG_BLOCKGC_RUNNING_BIT, &mp->m_opflags);
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		struct xfs_perag	*pag = xfs_perag_get(mp, agno);
+
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
+		xfs_perag_put(pag);
+	}
 }
 
 /* Enable post-EOF and CoW block auto-reclamation. */
@@ -1643,6 +1656,7 @@ xfs_blockgc_start(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
+	set_bit(XFS_OPFLAG_BLOCKGC_RUNNING_BIT, &mp->m_opflags);
 	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
 		xfs_blockgc_queue(pag);
 }
@@ -1656,6 +1670,13 @@ xfs_blockgc_scan_inode(
 	unsigned int		lockflags = 0;
 	int			error;
 
+	/*
+	 * Speculative preallocation gc isn't supposed to run when the fs is
+	 * frozen because we don't want kernel threads to block on transaction
+	 * allocation.
+	 */
+	ASSERT(ip->i_mount->m_super->s_writers.frozen < SB_FREEZE_FS);
+
 	error = xfs_inode_free_eofblocks(ip, eofb, &lockflags);
 	if (error)
 		goto unlock;
@@ -1677,13 +1698,10 @@ xfs_blockgc_worker(
 	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
-	if (!sb_start_write_trylock(mp->m_super))
-		return;
 	error = xfs_inode_walk_ag(pag, XFS_ICI_BLOCKGC_TAG, NULL);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
-	sb_end_write(mp->m_super);
 	xfs_blockgc_queue(pag);
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5db2a65b3729..d454d2492f3b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -908,6 +908,7 @@ xfs_mountfs(
 
 	/* Enable background workers. */
 	xfs_inodegc_start(mp);
+	xfs_blockgc_start(mp);
 
 	/*
 	 * Get and sanity-check the root inode.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e910e5734026..629d971c8787 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -263,6 +263,9 @@ typedef struct xfs_mount {
 						   inode inactivation worker? */
 #define XFS_OPFLAG_INACTIVATE_NOW_BIT	(1)	/* force foreground inactivation
 						   of unlinked inodes */
+#define XFS_OPFLAG_BLOCKGC_RUNNING_BIT	(0)	/* are we allowed to start the
+						   speculative preallocation gc
+						   worker? */
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index de44e9843558..75f08d00815b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -813,8 +813,10 @@ xfs_fs_sync_fs(
 	 * s_umount, which means we can't lock out a concurrent thaw request
 	 * without adding another layer of locks to the freeze process.
 	 */
-	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT)
+	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
 		xfs_inodegc_stop(mp);
+		xfs_blockgc_stop(mp);
+	}
 
 	return 0;
 }
@@ -931,7 +933,6 @@ xfs_fs_freeze(
 	 * set a GFP_NOFS context here to avoid recursion deadlocks.
 	 */
 	flags = memalloc_nofs_save();
-	xfs_blockgc_stop(mp);
 	xfs_save_resvblks(mp);
 	ret = xfs_log_quiesce(mp);
 	memalloc_nofs_restore(flags);

