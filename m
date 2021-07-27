Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA54C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E32BF60F6B
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhG0XoN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 19:44:13 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:41963 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232766AbhG0XoN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 19:44:13 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id E615A10158F
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 09:44:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8Wk6-00BYQl-4S
        for linux-xfs@vger.kernel.org; Wed, 28 Jul 2021 09:44:10 +1000
Date:   Wed, 28 Jul 2021 09:44:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/11 v2] xfs: limit iclog tail updates
Message-ID: <20210727234410.GY664593@dread.disaster.area>
References: <20210727071012.3358033-1-david@fromorbit.com>
 <20210727071012.3358033-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727071012.3358033-12-david@fromorbit.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8
        a=snT6dY1T7XhDDdcP36oA:9 a=CjuIK1q_8ugA:10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

From the department of "generic/482 keeps on giving", we bring you
another tail update race condition:

iclog:
	S1			C1
	+-----------------------+-----------------------+
				 S2			EOIC

Two checkpoints in a single iclog. One is complete, the other just
contains the start record and overruns into a new iclog.

Timeline:

Before S1:	Cache flush, log tail = X
At S1:		Metadata stable, write start record and checkpoint
At C1:		Write commit record, set NEED_FUA
		Single iclog checkpoint, so no need for NEED_FLUSH
		Log tail still = X, so no need for NEED_FLUSH

After C1,
Before S2:	Cache flush, log tail = X
At S2:		Metadata stable, write start record and checkpoint
After S2:	Log tail moves to X+1
At EOIC:	End of iclog, more journal data to write
		Releases iclog
		Not a commit iclog, so no need for NEED_FLUSH
		Writes log tail X+1 into iclog.

At this point, the iclog has tail X+1 and NEED_FUA set. There has
been no cache flush for the metadata between X and X+1, and the
iclog writes the new tail permanently to the log. THis is sufficient
to violate on disk metadata/journal ordering.

We have two options here. The first is to detect this case in some
manner and ensure that the partial checkpoint write sets NEED_FLUSH
when the iclog is already marked NEED_FUA and the log tail changes.
This seems somewhat fragile and quite complex to get right, and it
doesn't actually make it obvious what underlying problem it is
actually addressing from reading the code.

The second option seems much cleaner to me, because it is derived
directly from the requirements of the C1 commit record in the iclog.
That is, when we write this commit record to the iclog, we've
guaranteed that the metadata/data ordering is correct for tail
update purposes. Hence if we only write the log tail into the iclog
for the *first* commit record rather than the log tail at the last
release, we guarantee that the log tail does not move past where the
the first commit record in the log expects it to be.

IOWs, taking the first option means that replay of C1 becomes
dependent on future operations doing the right thing, not just the
C1 checkpoint itself doing the right thing. This makes log recovery
almost impossible to reason about because now we have to take into
account what might or might not have happened in the future when
looking at checkpoints in the log rather than just having to
reconstruct the past...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
Version 2:
- fix xlog_verify_tail_lsn() debug code to look at the iclog tail
  lsn rather than the current tail lsn that we might not have
  written into the iclog.

 fs/xfs/xfs_log.c | 50 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1c328efdca66..60ac5fd63f1e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -78,13 +78,12 @@ xlog_verify_iclog(
 STATIC void
 xlog_verify_tail_lsn(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	xfs_lsn_t		tail_lsn);
+	struct xlog_in_core	*iclog);
 #else
 #define xlog_verify_dest_ptr(a,b)
 #define xlog_verify_grant_tail(a)
 #define xlog_verify_iclog(a,b,c)
-#define xlog_verify_tail_lsn(a,b,c)
+#define xlog_verify_tail_lsn(a,b)
 #endif
 
 STATIC int
@@ -489,12 +488,31 @@ xfs_log_reserve(
 
 /*
  * Flush iclog to disk if this is the last reference to the given iclog and the
- * it is in the WANT_SYNC state.  If the caller passes in a non-zero
- * @old_tail_lsn and the current log tail does not match, there may be metadata
- * on disk that must be persisted before this iclog is written.  To satisfy that
- * requirement, set the XLOG_ICL_NEED_FLUSH flag as a condition for writing this
- * iclog with the new log tail value.
+ * it is in the WANT_SYNC state.
+ *
+ * If the caller passes in a non-zero @old_tail_lsn and the current log tail
+ * does not match, there may be metadata on disk that must be persisted before
+ * this iclog is written.  To satisfy that requirement, set the
+ * XLOG_ICL_NEED_FLUSH flag as a condition for writing this iclog with the new
+ * log tail value.
+ *
+ * If XLOG_ICL_NEED_FUA is already set on the iclog, we need to ensure that the
+ * log tail is updated correctly. NEED_FUA indicates that the iclog will be
+ * written to stable storage, and implies that a commit record is contained
+ * within the iclog. We need to ensure that the log tail does not move beyond
+ * the tail that the first commit record in the iclog ordered against, otherwise
+ * correct recovery of that checkpoint becomes dependent on future operations
+ * performed on this iclog.
+ *
+ * Hence if NEED_FUA is set and the current iclog tail lsn is empty, write the
+ * current tail into iclog. Once the iclog tail is set, future operations must
+ * not modify it, otherwise they potentially violate ordering constraints for
+ * the checkpoint commit that wrote the initial tail lsn value. The tail lsn in
+ * the iclog will get zeroed on activation of the iclog after sync, so we
+ * always capture the tail lsn on the iclog on the first NEED_FUA release
+ * regardless of the number of active reference counts on this iclog.
  */
+
 int
 xlog_state_release_iclog(
 	struct xlog		*log,
@@ -519,6 +537,10 @@ xlog_state_release_iclog(
 
 		if (old_tail_lsn && tail_lsn != old_tail_lsn)
 			iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
+
+		if ((iclog->ic_flags & XLOG_ICL_NEED_FUA) &&
+		    !iclog->ic_header.h_tail_lsn)
+			iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
 	}
 
 	if (!atomic_dec_and_test(&iclog->ic_refcnt))
@@ -530,8 +552,9 @@ xlog_state_release_iclog(
 	}
 
 	iclog->ic_state = XLOG_STATE_SYNCING;
-	iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
-	xlog_verify_tail_lsn(log, iclog, tail_lsn);
+	if (!iclog->ic_header.h_tail_lsn)
+		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
+	xlog_verify_tail_lsn(log, iclog);
 	trace_xlog_iclog_syncing(iclog, _RET_IP_);
 
 	spin_unlock(&log->l_icloglock);
@@ -2579,6 +2602,7 @@ xlog_state_activate_iclog(
 	memset(iclog->ic_header.h_cycle_data, 0,
 		sizeof(iclog->ic_header.h_cycle_data));
 	iclog->ic_header.h_lsn = 0;
+	iclog->ic_header.h_tail_lsn = 0;
 }
 
 /*
@@ -3614,10 +3638,10 @@ xlog_verify_grant_tail(
 STATIC void
 xlog_verify_tail_lsn(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	xfs_lsn_t		tail_lsn)
+	struct xlog_in_core	*iclog)
 {
-    int blocks;
+	xfs_lsn_t	tail_lsn = be64_to_cpu(iclog->ic_header.h_tail_lsn);
+	int		blocks;
 
     if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
 	blocks =
