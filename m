Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C27C47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2097D61040
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFGW1a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhFGW1a (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 18:27:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45C7261059;
        Mon,  7 Jun 2021 22:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623104738;
        bh=KJcbnibZDmu4IqbPS3X0vAresvjSLBsWp0DD66VhjpU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CNZlUFc5btKPIsdviZ+QMs3T9027E6WKBpZzfjrGPZ73Jwhs606mv19s1X7cWm6ZT
         zW+4lfz6/ZJlT1RYWLY2xzEGzcqONRz27Az+WDkyUUPA5J7iDXZJl9IrOM2vOxpqV/
         0lP5lUpJOEPAkxy0oAe+dnTsuQ+gPsRaQxtff1wVsW66jdoQNwHegB+MxfsV7i1H/A
         nr0kcDAo2HC6jdSwmRI+i/lAKkJNB9vRmclovOpfNIiwp2Q24T/MOCtkzANTCk2yv2
         /7tteIkwj5YQ0ZLHac0oeZ7c9wv+MB8AJLZ1zHTp/jEROyvbwXVmUOnRq5Ukqg04k6
         6316K0xcmrBBg==
Subject: [PATCH 8/9] xfs: don't run speculative preallocation gc when fs is
 frozen
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Mon, 07 Jun 2021 15:25:38 -0700
Message-ID: <162310473797.3465262.16041946316966485442.stgit@locust>
In-Reply-To: <162310469340.3465262.504398465311182657.stgit@locust>
References: <162310469340.3465262.504398465311182657.stgit@locust>
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
 fs/xfs/xfs_icache.c |   29 ++++++++++++++++++++++++++---
 fs/xfs/xfs_mount.c  |    1 +
 fs/xfs/xfs_mount.h  |    3 +++
 fs/xfs/xfs_super.c  |    5 +++--
 4 files changed, 33 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 22090b318e58..5d5a0c137f32 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -215,6 +215,12 @@ xfs_reclaim_work_queue(
 	rcu_read_unlock();
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
@@ -223,6 +229,9 @@ static inline void
 xfs_blockgc_queue(
 	struct xfs_perag	*pag)
 {
+	if (!xfs_blockgc_running(pag->pag_mount))
+		return;
+
 	rcu_read_lock();
 	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG))
 		queue_delayed_work(pag->pag_mount->m_gc_workqueue,
@@ -1557,7 +1566,8 @@ xfs_blockgc_stop(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
-	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
+	clear_bit(XFS_OPFLAG_BLOCKGC_RUNNING_BIT, &mp->m_opflags);
+	for_each_perag(mp, agno, pag)
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 }
 
@@ -1569,6 +1579,7 @@ xfs_blockgc_start(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
+	set_bit(XFS_OPFLAG_BLOCKGC_RUNNING_BIT, &mp->m_opflags);
 	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
 		xfs_blockgc_queue(pag);
 }
@@ -1626,6 +1637,13 @@ xfs_blockgc_scan_inode(
 	unsigned int		lockflags = 0;
 	int			error;
 
+	/*
+	 * Speculative preallocation gc isn't supposed to run when the fs is
+	 * frozen because we don't want kernel threads to block on transaction
+	 * allocation.
+	 */
+	ASSERT(ip->i_mount->m_super->s_writers.frozen < SB_FREEZE_FS);
+
 	error = xfs_inode_free_eofblocks(ip, icw, &lockflags);
 	if (error)
 		goto unlock;
@@ -1648,13 +1666,18 @@ xfs_blockgc_worker(
 	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
-	if (!sb_start_write_trylock(mp->m_super))
+	/*
+	 * Queueing of this blockgc worker can race with xfs_blockgc_stop,
+	 * which means that we can be running after the opflag clears.  Double
+	 * check the flag state so that we don't trip asserts.
+	 */
+	if (!xfs_blockgc_running(mp))
 		return;
+
 	error = xfs_icwalk_ag(pag, XFS_ICWALK_BLOCKGC, NULL);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
-	sb_end_write(mp->m_super);
 	xfs_blockgc_queue(pag);
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 24dc3b7026b7..d95432e4ac39 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -797,6 +797,7 @@ xfs_mountfs(
 
 	/* Enable background workers. */
 	xfs_inodegc_start(mp);
+	xfs_blockgc_start(mp);
 
 	/*
 	 * Get and sanity-check the root inode.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 4323aaa3e7b4..2da5bd55dd81 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -270,6 +270,9 @@ typedef struct xfs_mount {
 						   inode inactivation worker? */
 #define XFS_OPFLAG_INACTIVATE_NOW_BIT	(1)	/* force foreground inactivation
 						   of unlinked inodes */
+#define XFS_OPFLAG_BLOCKGC_RUNNING_BIT	(2)	/* are we allowed to start the
+						   speculative preallocation gc
+						   worker? */
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 968176b35d13..730f8e960d98 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -852,8 +852,10 @@ xfs_fs_sync_fs(
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
@@ -970,7 +972,6 @@ xfs_fs_freeze(
 	 * set a GFP_NOFS context here to avoid recursion deadlocks.
 	 */
 	flags = memalloc_nofs_save();
-	xfs_blockgc_stop(mp);
 	xfs_save_resvblks(mp);
 	ret = xfs_log_quiesce(mp);
 	memalloc_nofs_restore(flags);

