Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEECC6377D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21BF861279
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhGVG0X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhGVG0X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 02:26:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938E2C061575
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jul 2021 00:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Q5jNZFVMDsOpgpS07XfWPrtYHzcpMJdXqiU9KpNz4TY=; b=U4tFAiuRT5tKGdqyTad9FN5xHv
        zHViftikiqV86kQGbvSWNb1MbqwRtJdA4Me9wCCDyP3oS9VWihtf4mnHdS26lMT5OUeJ+gY5qXgfk
        xHVrR0UqwX5qIshhMrGEGpgpA8EEHBULH/fS/Iv3EL4zd0ssuyY2AyrmUhVM3H0Sih1rqTP+YtyZh
        OUH96QxbPgJKsvhEa7Frvpxyxl/+SYOXkPW1vsPutIgpeCMwYKIjLihYCXr98V++iVoRHWwHi9U2v
        ZaX/Bp7CrtkRX6JW/oOZ/Kr7Tm1Kyjp3r68n2z/3rKnXpo+xe0HX+wjZyLYDSBMJpk/QxfZCf84ie
        Vo4vqVUw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6Sn9-009yx0-DS; Thu, 22 Jul 2021 07:06:51 +0000
Date:   Thu, 22 Jul 2021 08:06:47 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: fix ordering violation between cache flushes
 and tail updates
Message-ID: <YPkZB7aY3foxa594@infradead.org>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JHbYgruiVcd/XEyt"
Content-Disposition: inline
In-Reply-To: <20210722015335.3063274-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--JHbYgruiVcd/XEyt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Due the combination of the code move and the actual change I had
a really hard time reviewing this.

> -		trace_xlog_iclog_syncing(iclog, _RET_IP_);

This tracepoint got lost.

Otherwise this looks good.

As I had to split the move from the technical changes to follow
the change I might as well share my split, attached below as two
patches:


--JHbYgruiVcd/XEyt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-xfs-fold-__xlog_state_release_iclog-into-xlog_state_.patch"

From 6f8ff7f10b25986518ff76e9a6ef61edb629a97f Mon Sep 17 00:00:00 2001
From: Dave Chinner <dchinner@redhat.com>
Date: Thu, 22 Jul 2021 08:58:49 +0200
Subject: xfs: fold __xlog_state_release_iclog into xlog_state_release_iclog

Fold __xlog_state_release_iclog intos it's only caller to prepare
make an upcomding fix easier.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 46 ++++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a3c4d48195d98a..d7ab9d0814c2c6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -487,29 +487,6 @@ xfs_log_reserve(
 	return error;
 }
 
-static bool
-__xlog_state_release_iclog(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog)
-{
-	lockdep_assert_held(&log->l_icloglock);
-
-	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
-		/* update tail before writing to iclog */
-		xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);
-
-		iclog->ic_state = XLOG_STATE_SYNCING;
-		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
-		xlog_verify_tail_lsn(log, iclog, tail_lsn);
-		/* cycle incremented when incrementing curr_block */
-		trace_xlog_iclog_syncing(iclog, _RET_IP_);
-		return true;
-	}
-
-	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
-	return false;
-}
-
 /*
  * Flush iclog to disk if this is the last reference to the given iclog and the
  * it is in the WANT_SYNC state.
@@ -519,19 +496,32 @@ xlog_state_release_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
 {
+	xfs_lsn_t		tail_lsn;
+
 	lockdep_assert_held(&log->l_icloglock);
 
 	trace_xlog_iclog_release(iclog, _RET_IP_);
 	if (iclog->ic_state == XLOG_STATE_IOERROR)
 		return -EIO;
 
-	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
-	    __xlog_state_release_iclog(log, iclog)) {
-		spin_unlock(&log->l_icloglock);
-		xlog_sync(log, iclog);
-		spin_lock(&log->l_icloglock);
+	if (!atomic_dec_and_test(&iclog->ic_refcnt))
+		return 0;
+
+	if (iclog->ic_state != XLOG_STATE_WANT_SYNC) {
+		ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
+		return 0;
 	}
 
+	/* update tail before writing to iclog */
+	tail_lsn = xlog_assign_tail_lsn(log->l_mp);
+	iclog->ic_state = XLOG_STATE_SYNCING;
+	iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
+	xlog_verify_tail_lsn(log, iclog, tail_lsn);
+	trace_xlog_iclog_syncing(iclog, _RET_IP_);
+
+	spin_unlock(&log->l_icloglock);
+	xlog_sync(log, iclog);
+	spin_lock(&log->l_icloglock);
 	return 0;
 }
 
-- 
2.30.2


--JHbYgruiVcd/XEyt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-xfs-fix-ordering-violation-between-cache-flushes-and.patch"

From 7a592dfeef83ca61ae001d612b8932027e0080cf Mon Sep 17 00:00:00 2001
From: Dave Chinner <dchinner@redhat.com>
Date: Thu, 22 Jul 2021 09:00:08 +0200
Subject: xfs: fix ordering violation between cache flushes and tail updates

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
the commit record being written. This requires sampling the tail_lsn
before we start the flush, and then passing the sampled tail LSN to
xlog_state_release_iclog() so it can determine if the the tail LSN
has changed while writing the checkpoint. If the tail LSN has
changed, then it needs to set the NEED_FLUSH flag on the iclog and
we'll issue another cache flush before writing the iclog.

Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 38 +++++++++++++++++++++++++++++---------
 fs/xfs/xfs_log_cil.c  | 13 +++++++++++--
 fs/xfs/xfs_log_priv.h |  3 ++-
 3 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d7ab9d0814c2c6..5767fd3ab90555 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -489,12 +489,20 @@ xfs_log_reserve(
 
 /*
  * Flush iclog to disk if this is the last reference to the given iclog and the
- * it is in the WANT_SYNC state.
+ * it is in the WANT_SYNC state. If the caller passes in a non-zero
+ * @old_tail_lsn, then we need to check if the log tail is different to the
+ * caller's value. If it is different, this indicates that the log tail has
+ * moved since the caller sampled the log tail and issued a cache flush and so
+ * there may be metadata on disk taht we need to flush before this iclog is
+ * written. In that case, set the XLOG_ICL_NEED_FLUSH flag so taht when the
+ * iclog is synced we correctly issue a cache flush before the iclog is
+ * submitted.
  */
 int
 xlog_state_release_iclog(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog)
+	struct xlog_in_core	*iclog,
+	xfs_lsn_t		old_tail_lsn)
 {
 	xfs_lsn_t		tail_lsn;
 
@@ -504,6 +512,19 @@ xlog_state_release_iclog(
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
 
@@ -513,7 +534,6 @@ xlog_state_release_iclog(
 	}
 
 	/* update tail before writing to iclog */
-	tail_lsn = xlog_assign_tail_lsn(log->l_mp);
 	iclog->ic_state = XLOG_STATE_SYNCING;
 	iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
 	xlog_verify_tail_lsn(log, iclog, tail_lsn);
@@ -859,7 +879,7 @@ xlog_unmount_write(
 	 * iclog containing the unmount record is written.
 	 */
 	iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
-	error = xlog_state_release_iclog(log, iclog);
+	error = xlog_state_release_iclog(log, iclog, 0);
 	xlog_wait_on_iclog(iclog);
 
 	if (tic) {
@@ -2303,7 +2323,7 @@ xlog_write_copy_finish(
 	return 0;
 
 release_iclog:
-	error = xlog_state_release_iclog(log, iclog);
+	error = xlog_state_release_iclog(log, iclog, 0);
 	spin_unlock(&log->l_icloglock);
 	return error;
 }
@@ -2522,7 +2542,7 @@ xlog_write(
 		ASSERT(optype & XLOG_COMMIT_TRANS);
 		*commit_iclog = iclog;
 	} else {
-		error = xlog_state_release_iclog(log, iclog);
+		error = xlog_state_release_iclog(log, iclog, 0);
 	}
 	spin_unlock(&log->l_icloglock);
 
@@ -2960,7 +2980,7 @@ xlog_state_get_iclog_space(
 		 * reference to the iclog.
 		 */
 		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
-			error = xlog_state_release_iclog(log, iclog);
+			error = xlog_state_release_iclog(log, iclog, 0);
 		spin_unlock(&log->l_icloglock);
 		if (error)
 			return error;
@@ -3196,7 +3216,7 @@ xfs_log_force(
 			atomic_inc(&iclog->ic_refcnt);
 			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 			xlog_state_switch_iclogs(log, iclog, 0);
-			if (xlog_state_release_iclog(log, iclog))
+			if (xlog_state_release_iclog(log, iclog, 0))
 				goto out_error;
 
 			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
@@ -3276,7 +3296,7 @@ xlog_force_lsn(
 		}
 		atomic_inc(&iclog->ic_refcnt);
 		xlog_state_switch_iclogs(log, iclog, 0);
-		if (xlog_state_release_iclog(log, iclog))
+		if (xlog_state_release_iclog(log, iclog, 0))
 			goto out_error;
 		if (log_flushed)
 			*log_flushed = 1;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b128aaa9b870d5..4c44bc3786c0f0 100644
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
index 4c41bbfa33b0df..7cbde0b4f9901d 100644
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
2.30.2


--JHbYgruiVcd/XEyt--
