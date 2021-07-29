Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC86C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D59CC60F4B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhG2Spf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231224AbhG2Spb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:45:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9522F60F4B;
        Thu, 29 Jul 2021 18:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584327;
        bh=qqFiKHqs2RWqBYheUlhJqnjE7jtAfv3TQDYcpD/9DYY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qChlY/H/szYxQSN1aJpGkjuGFkWWhzIlclIryRFd+gLhILFZx3lRwls2EiiW+9GP4
         IJ25+ZVmZA7nWJvIGQi4/szH9tcbpHtuaHRTv0bmIAChGJDH1huQ3SlQl5hqC8HFH7
         Cj5E0fnLlTzpSW035ewBxAD/XGt1dL9581bttHiptIOcHMVraWzWJnmA7pWA0tdpQ+
         QFI8v9MN3o+lUtbHb0nRLTVMGMptDIHjPHZWddz/yz5JHIgrSbGp+jZEJh/EmlbqqT
         HaULy2Lt667j0dWHqBMsORamc74AKwwRpsX9BaIY+kpyEpcGqR5uCATzb4PuNDmlqK
         UENoKSZm+2KwA==
Subject: [PATCH 17/20] xfs: don't run speculative preallocation gc when fs is
 frozen
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:45:27 -0700
Message-ID: <162758432726.332903.6678796777420892793.stgit@magnolia>
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
index 06b697f72f23..e86854171b0c 100644
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
index 513d380b8b55..9b1274f25ed0 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -455,11 +455,19 @@ static inline void
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
+		trace_xfs_blockgc_queue(pag, delay);
+		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_blockgc_work,
+				msecs_to_jiffies(delay));
+	}
 	rcu_read_unlock();
 }
 
@@ -1786,8 +1794,12 @@ xfs_blockgc_stop(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
-	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
+	if (!test_and_clear_bit(XFS_OPFLAG_BLOCKGC_RUNNING_BIT, &mp->m_opflags))
+		return;
+
+	for_each_perag(mp, agno, pag)
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
+	trace_xfs_blockgc_stop(mp, __return_address);
 }
 
 /* Enable post-EOF and CoW block auto-reclamation. */
@@ -1798,6 +1810,10 @@ xfs_blockgc_start(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
+	if (!test_and_set_bit(XFS_OPFLAG_BLOCKGC_RUNNING_BIT, &mp->m_opflags))
+		return;
+
+	trace_xfs_blockgc_start(mp, __return_address);
 	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
 		xfs_blockgc_queue(pag);
 }
@@ -1855,6 +1871,13 @@ xfs_blockgc_scan_inode(
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
@@ -1877,13 +1900,12 @@ xfs_blockgc_worker(
 	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
-	if (!sb_start_write_trylock(mp->m_super))
-		return;
+	trace_xfs_blockgc_worker(pag, __return_address);
+
 	error = xfs_icwalk_ag(pag, XFS_ICWALK_BLOCKGC, NULL);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
-	sb_end_write(mp->m_super);
 	xfs_blockgc_queue(pag);
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 811ce8e9310e..acb1ebacdf8f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -791,6 +791,7 @@ xfs_mountfs(
 
 	/* Enable background inode inactivation workers. */
 	xfs_inodegc_start(mp);
+	xfs_blockgc_start(mp);
 
 	/*
 	 * Get and sanity-check the root inode.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 74ca2a458b14..446c3a8f57c4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -278,6 +278,13 @@ enum xfs_opflag_bits {
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
index 2451f6d1690f..7e2df0170e51 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -881,14 +881,17 @@ xfs_fs_unfreeze(
 
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
index 26fc5cf08d5b..80dc15a14173 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -191,6 +191,8 @@ DEFINE_FS_EVENT(xfs_inodegc_start);
 DEFINE_FS_EVENT(xfs_inodegc_stop);
 DEFINE_FS_EVENT(xfs_fs_sync_fs);
 DEFINE_FS_EVENT(xfs_inodegc_delay_mempressure);
+DEFINE_FS_EVENT(xfs_blockgc_start);
+DEFINE_FS_EVENT(xfs_blockgc_stop);
 
 TRACE_EVENT(xfs_inodegc_requeue_mempressure,
 	TP_PROTO(struct xfs_perag *pag, unsigned long nr, void *caller_ip),
@@ -239,6 +241,7 @@ DEFINE_EVENT(xfs_perag_class, name,					\
 	TP_ARGS(pag, caller_ip))
 DEFINE_PERAG_EVENT(xfs_inodegc_throttled);
 DEFINE_PERAG_EVENT(xfs_inodegc_worker);
+DEFINE_PERAG_EVENT(xfs_blockgc_worker);
 
 TRACE_EVENT(xfs_gc_delay_dquot,
 	TP_PROTO(struct xfs_dquot *dqp, unsigned int tag, unsigned int shift),
@@ -368,6 +371,7 @@ DEFINE_EVENT(xfs_gc_queue_class, name,	\
 	TP_PROTO(struct xfs_perag *pag, unsigned int delay_ms),	\
 	TP_ARGS(pag, delay_ms))
 DEFINE_GC_QUEUE_EVENT(xfs_inodegc_queue);
+DEFINE_GC_QUEUE_EVENT(xfs_blockgc_queue);
 
 TRACE_EVENT(xfs_gc_requeue_now,
 	TP_PROTO(struct xfs_perag *pag, unsigned int tag),

