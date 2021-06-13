Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B59CC48BDF
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4744861107
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhFMRXN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 13:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232014AbhFMRXK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:23:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF7061107;
        Sun, 13 Jun 2021 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604868;
        bh=j5uuBQ9l0QBe8KlRMgq54x5z325uRHbxMX0sXhEFwkE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G3eziSZtqF/mGoioG14Ls8KdDdCkSuzKxv/CMKARfzXAYLuBCByXW7r6z5Wby9MVA
         4xlvAdiLxTg1KBx8Ik3NSLtq6gNNHuHWvS/SBvcX6X+gpzzHZq1UbEOePrjlR9I5eS
         dLr2PXO5ZfDujVy1YYtK0V5FEOXxPSyR1YY0ROfiAciu8AEdzLWiUUONTZglhjvki8
         aKPmm4RapE4iiypHc7C5kp/9PVgpwngN7cQh+je4oKQW2cRdYLiVHp65N+AReDIHFg
         KzcfEqf7Rr/CySLmnRBsWeIJYGtJW6CknVFRUdukcuveY9G5X/i7b/XdQeA/10yB4a
         YnxtaIPvx2/fg==
Subject: [PATCH 13/16] xfs: don't run speculative preallocation gc when fs is
 frozen
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:21:08 -0700
Message-ID: <162360486839.1530792.12073922123665591653.stgit@locust>
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

Now that we have the infrastructure to switch background workers on and
off at will, fix the block gc worker code so that we don't actually run
the worker when the filesystem is frozen, same as we do for deferred
inactivation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |    9 +++++----
 fs/xfs/xfs_icache.c   |   38 ++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_mount.c    |    1 +
 fs/xfs/xfs_mount.h    |    7 +++++++
 fs/xfs/xfs_super.c    |    9 ++++++---
 fs/xfs/xfs_trace.h    |    4 ++++
 6 files changed, 53 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index b674bc6ed78d..2deda2c5189a 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -893,11 +893,12 @@ xchk_start_reaping(
 	struct xfs_scrub	*sc)
 {
 	/*
-	 * Readonly filesystems do not perform inactivation, so there's no
-	 * need to restart the worker.
+	 * Readonly filesystems do not perform inactivation or speculative
+	 * preallocation, so there's no need to restart the workers.
 	 */
-	if (!(sc->mp->m_flags & XFS_MOUNT_RDONLY))
+	if (!(sc->mp->m_flags & XFS_MOUNT_RDONLY)) {
 		xfs_inodegc_start(sc->mp);
-	xfs_blockgc_start(sc->mp);
+		xfs_blockgc_start(sc->mp);
+	}
 	sc->flags &= ~XCHK_REAPING_DISABLED;
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f58d0455e38f..780100756738 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -367,11 +367,19 @@ static inline void
 xfs_blockgc_queue(
 	struct xfs_perag	*pag)
 {
+	struct xfs_mount        *mp = pag->pag_mount;
+
+	if (!test_bit(XFS_OPFLAG_BLOCKGC_RUNNING_BIT, &mp->m_opflags))
+		return;
+
 	rcu_read_lock();
-	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG))
-		queue_delayed_work(pag->pag_mount->m_gc_workqueue,
-				   &pag->pag_blockgc_work,
-				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
+	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG)) {
+		unsigned int	delay = xfs_blockgc_secs * 1000;
+
+		trace_xfs_blockgc_queue(mp, pag->pag_agno, delay, _RET_IP_);
+		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_blockgc_work,
+				msecs_to_jiffies(delay));
+	}
 	rcu_read_unlock();
 }
 
@@ -1769,8 +1777,12 @@ xfs_blockgc_stop(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
-	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
+	if (!test_and_clear_bit(XFS_OPFLAG_BLOCKGC_RUNNING_BIT, &mp->m_opflags))
+		return;
+
+	for_each_perag(mp, agno, pag)
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
+	trace_xfs_blockgc_stop(mp, 0, _RET_IP_);
 }
 
 /* Enable post-EOF and CoW block auto-reclamation. */
@@ -1781,6 +1793,10 @@ xfs_blockgc_start(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
+	if (!test_and_set_bit(XFS_OPFLAG_BLOCKGC_RUNNING_BIT, &mp->m_opflags))
+		return;
+
+	trace_xfs_blockgc_start(mp, 0, _RET_IP_);
 	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
 		xfs_blockgc_queue(pag);
 }
@@ -1838,6 +1854,13 @@ xfs_blockgc_scan_inode(
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
@@ -1860,13 +1883,12 @@ xfs_blockgc_worker(
 	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
-	if (!sb_start_write_trylock(mp->m_super))
-		return;
+	trace_xfs_blockgc_worker(mp, pag->pag_agno, 0, _RET_IP_);
+
 	error = xfs_icwalk_ag(pag, XFS_ICWALK_BLOCKGC, NULL);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
-	sb_end_write(mp->m_super);
 	xfs_blockgc_queue(pag);
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index eff375f92005..558414e1460c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -789,6 +789,7 @@ xfs_mountfs(
 
 	/* Enable background inode inactivation workers. */
 	xfs_inodegc_start(mp);
+	xfs_blockgc_start(mp);
 
 	/*
 	 * Get and sanity-check the root inode.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 154aa95d968c..8d6565fdf56a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -277,6 +277,13 @@ enum xfs_opflag_bits {
 	 * waiting to be processed.
 	 */
 	XFS_OPFLAG_INODEGC_RUNNING_BIT	= 0,
+
+	/*
+	 * If set, background speculative prealloc gc worker threads will be
+	 * scheduled to process queued blockgc work.  If not, inodes retain
+	 * their preallocations until explicitly deleted.
+	 */
+	XFS_OPFLAG_BLOCKGC_RUNNING_BIT	= 1,
 };
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 66b61d38f401..4aae20d2761f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -893,14 +893,17 @@ xfs_fs_unfreeze(
 
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
-	xfs_blockgc_start(mp);
 
 	/*
 	 * Don't reactivate the inodegc worker on a readonly filesystem because
-	 * inodes are sent directly to reclaim.
+	 * inodes are sent directly to reclaim.  Don't reactivate the blockgc
+	 * worker because there are no speculative preallocations on a readonly
+	 * filesystem.
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY))
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		xfs_blockgc_start(mp);
 		xfs_inodegc_start(mp);
+	}
 
 	return 0;
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 404f2f32002f..0795427e8f38 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -157,6 +157,8 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_inodegc_queue);
 DEFINE_PERAG_REF_EVENT(xfs_inodegc_worker);
+DEFINE_PERAG_REF_EVENT(xfs_blockgc_worker);
+DEFINE_PERAG_REF_EVENT(xfs_blockgc_queue);
 
 DECLARE_EVENT_CLASS(xfs_fs_class,
 	TP_PROTO(struct xfs_mount *mp, int data, unsigned long caller_ip),
@@ -194,6 +196,8 @@ DEFINE_FS_EVENT(xfs_inodegc_flush);
 DEFINE_FS_EVENT(xfs_inodegc_start);
 DEFINE_FS_EVENT(xfs_inodegc_stop);
 DEFINE_FS_EVENT(xfs_fs_sync_fs);
+DEFINE_FS_EVENT(xfs_blockgc_start);
+DEFINE_FS_EVENT(xfs_blockgc_stop);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),

