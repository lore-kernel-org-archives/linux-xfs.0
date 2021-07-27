Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC86C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 07:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8565F61163
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 07:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbhG0HKW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 03:10:22 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53763 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235727AbhG0HKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 03:10:20 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CAF4E10452A3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 17:10:17 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00BI3l-QT
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00E5as-IX
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/11] xfs: fix ordering violation between cache flushes and tail updates
Date:   Tue, 27 Jul 2021 17:10:05 +1000
Message-Id: <20210727071012.3358033-5-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727071012.3358033-1-david@fromorbit.com>
References: <20210727071012.3358033-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=2n2eWKAyR893Ayt8RwEA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There is a race between the new CIL async data device metadata IO
completion cache flush and the log tail in the iclog the flush
covers being updated. This can be seen by repeating generic/482 in a
loop and eventually log recovery fails with a failures such as this:

XFS (dm-3): Starting recovery (logdev: internal)
XFS (dm-3): bad inode magic/vsn daddr 228352 #0 (magic=0)
XFS (dm-3): Metadata corruption detected at xfs_inode_buf_verify+0x180/0x190, xfs_inode block 0x37c00 xfs_inode_buf_verify
XFS (dm-3): Unmount and run xfs_repair
XFS (dm-3): First 128 bytes of corrupted metadata buffer:
00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
XFS (dm-3): metadata I/O error in "xlog_recover_items_pass2+0x55/0xc0" at daddr 0x37c00 len 32 error 117

Analysis of the logwrite replay shows that there were no writes to
the data device between the FUA @ write 124 and the FUA at write @
125, but log recovery @ 125 failed. The difference was the one log
write @ 125 moved the tail of the log forwards from (1,8) to (1,32)
and so the inode create intent in (1,8) was not replayed and so the
inode cluster was zero on disk when replay of the first inode item
in (1,32) was attempted.

What this meant was that the journal write that occurred at @ 125
did not ensure that metadata completed before the iclog was written
was correctly on stable storage. The tail of the log moved forward,
so IO must have been completed between the two iclog writes. This
means that there is a race condition between the unconditional async
cache flush in the CIL push work and the tail LSN that is written to
the iclog. This happens like so:

CIL push work				AIL push work
-------------				-------------
Add to committing list
start async data dev cache flush
.....
<flush completes>
<all writes to old tail lsn are stable>
xlog_write
  ....					push inode create buffer
					<start IO>
					.....
xlog_write(commit record)
  ....					<IO completes>
  					log tail moves
  					  xlog_assign_tail_lsn()
start_lsn == commit_lsn
  <no iclog preflush!>
xlog_state_release_iclog
  __xlog_state_release_iclog()
    <writes *new* tail_lsn into iclog>
  xlog_sync()
    ....
    submit_bio()
<tail in log moves forward without flushing written metadata>

Essentially, this can only occur if the commit iclog is issued
without a cache flush. If the iclog bio is submitted with
REQ_PREFLUSH, then it will guarantee that all the completed IO is
one stable storage before the iclog bio with the new tail LSN in it
is written to the log.

IOWs, the tail lsn that is written to the iclog needs to be sampled
*before* we issue the cache flush that guarantees all IO up to that
LSN has been completed.

To fix this without giving up the performance advantage of the
flush/FUA optimisations (e.g. g/482 runtime halves with 5.14-rc1
compared to 5.13), we need to ensure that we always issue a cache
flush if the tail LSN changes between the initial async flush and
the commit record being written. THis requires sampling the tail_lsn
before we start the flush, and then passing the sampled tail LSN to
xlog_state_release_iclog() so it can determine if the the tail LSN
has changed while writing the checkpoint. If the tail LSN has
changed, then it needs to set the NEED_FLUSH flag on the iclog and
we'll issue another cache flush before writing the iclog.

Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 36 ++++++++++++++++++++++++++----------
 fs/xfs/xfs_log_cil.c  | 13 +++++++++++--
 fs/xfs/xfs_log_priv.h |  3 ++-
 3 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 82f5996d3889..e8c6c96d4f7c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -489,12 +489,17 @@ xfs_log_reserve(
 
 /*
  * Flush iclog to disk if this is the last reference to the given iclog and the
- * it is in the WANT_SYNC state.
+ * it is in the WANT_SYNC state.  If the caller passes in a non-zero
+ * @old_tail_lsn and the current log tail does not match, there may be metadata
+ * on disk that must be persisted before this iclog is written.  To satisfy that
+ * requirement, set the XLOG_ICL_NEED_FLUSH flag as a condition for writing this
+ * iclog with the new log tail value.
  */
 int
 xlog_state_release_iclog(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog)
+	struct xlog_in_core	*iclog,
+	xfs_lsn_t		old_tail_lsn)
 {
 	xfs_lsn_t		tail_lsn;
 	lockdep_assert_held(&log->l_icloglock);
@@ -503,6 +508,19 @@ xlog_state_release_iclog(
 	if (iclog->ic_state == XLOG_STATE_IOERROR)
 		return -EIO;
 
+	/*
+	 * Grabbing the current log tail needs to be atomic w.r.t. the writing
+	 * of the tail LSN into the iclog so we guarantee that the log tail does
+	 * not move between deciding if a cache flush is required and writing
+	 * the LSN into the iclog below.
+	 */
+	if (old_tail_lsn || iclog->ic_state == XLOG_STATE_WANT_SYNC) {
+		tail_lsn = xlog_assign_tail_lsn(log->l_mp);
+
+		if (old_tail_lsn && tail_lsn != old_tail_lsn)
+			iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
+	}
+
 	if (!atomic_dec_and_test(&iclog->ic_refcnt))
 		return 0;
 
@@ -511,8 +529,6 @@ xlog_state_release_iclog(
 		return 0;
 	}
 
-	/* update tail before writing to iclog */
-	tail_lsn = xlog_assign_tail_lsn(log->l_mp);
 	iclog->ic_state = XLOG_STATE_SYNCING;
 	iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
 	xlog_verify_tail_lsn(log, iclog, tail_lsn);
@@ -858,7 +874,7 @@ xlog_unmount_write(
 	 * iclog containing the unmount record is written.
 	 */
 	iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
-	error = xlog_state_release_iclog(log, iclog);
+	error = xlog_state_release_iclog(log, iclog, 0);
 	xlog_wait_on_iclog(iclog);
 
 	if (tic) {
@@ -2302,7 +2318,7 @@ xlog_write_copy_finish(
 	return 0;
 
 release_iclog:
-	error = xlog_state_release_iclog(log, iclog);
+	error = xlog_state_release_iclog(log, iclog, 0);
 	spin_unlock(&log->l_icloglock);
 	return error;
 }
@@ -2521,7 +2537,7 @@ xlog_write(
 		ASSERT(optype & XLOG_COMMIT_TRANS);
 		*commit_iclog = iclog;
 	} else {
-		error = xlog_state_release_iclog(log, iclog);
+		error = xlog_state_release_iclog(log, iclog, 0);
 	}
 	spin_unlock(&log->l_icloglock);
 
@@ -2959,7 +2975,7 @@ xlog_state_get_iclog_space(
 		 * reference to the iclog.
 		 */
 		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
-			error = xlog_state_release_iclog(log, iclog);
+			error = xlog_state_release_iclog(log, iclog, 0);
 		spin_unlock(&log->l_icloglock);
 		if (error)
 			return error;
@@ -3195,7 +3211,7 @@ xfs_log_force(
 			atomic_inc(&iclog->ic_refcnt);
 			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 			xlog_state_switch_iclogs(log, iclog, 0);
-			if (xlog_state_release_iclog(log, iclog))
+			if (xlog_state_release_iclog(log, iclog, 0))
 				goto out_error;
 
 			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
@@ -3275,7 +3291,7 @@ xlog_force_lsn(
 		}
 		atomic_inc(&iclog->ic_refcnt);
 		xlog_state_switch_iclogs(log, iclog, 0);
-		if (xlog_state_release_iclog(log, iclog))
+		if (xlog_state_release_iclog(log, iclog, 0))
 			goto out_error;
 		if (log_flushed)
 			*log_flushed = 1;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b128aaa9b870..4c44bc3786c0 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -654,8 +654,9 @@ xlog_cil_push_work(
 	struct xfs_trans_header thdr;
 	struct xfs_log_iovec	lhdr;
 	struct xfs_log_vec	lvhdr = { NULL };
+	xfs_lsn_t		preflush_tail_lsn;
 	xfs_lsn_t		commit_lsn;
-	xfs_lsn_t		push_seq;
+	xfs_csn_t		push_seq;
 	struct bio		bio;
 	DECLARE_COMPLETION_ONSTACK(bdev_flush);
 
@@ -730,7 +731,15 @@ xlog_cil_push_work(
 	 * because we hold the flush lock exclusively. Hence we can now issue
 	 * a cache flush to ensure all the completed metadata in the journal we
 	 * are about to overwrite is on stable storage.
+	 *
+	 * Because we are issuing this cache flush before we've written the
+	 * tail lsn to the iclog, we can have metadata IO completions move the
+	 * tail forwards between the completion of this flush and the iclog
+	 * being written. In this case, we need to re-issue the cache flush
+	 * before the iclog write. To detect whether the log tail moves, sample
+	 * the tail LSN *before* we issue the flush.
 	 */
+	preflush_tail_lsn = atomic64_read(&log->l_tail_lsn);
 	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
 				&bdev_flush);
 
@@ -941,7 +950,7 @@ xlog_cil_push_work(
 	 * storage.
 	 */
 	commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
-	xlog_state_release_iclog(log, commit_iclog);
+	xlog_state_release_iclog(log, commit_iclog, preflush_tail_lsn);
 	spin_unlock(&log->l_icloglock);
 	return;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 4c41bbfa33b0..7cbde0b4f990 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -497,7 +497,8 @@ int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
-int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog);
+int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog,
+		xfs_lsn_t log_tail_lsn);
 
 /*
  * When we crack an atomic LSN, we sample it first so that the value will not
-- 
2.31.1

