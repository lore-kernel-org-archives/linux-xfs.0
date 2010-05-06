Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o461i65F065055 for <xfs@oss.sgi.com>; Wed, 5 May 2010 20:44:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 432203139C0
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 18:46:15 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	Uv8a7wHSHAtYPdSV for <xfs@oss.sgi.com>;
	Wed, 05 May 2010 18:46:15 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	23180513-1927428
	for <xfs@oss.sgi.com>; Thu, 06 May 2010 11:16:14 +0930 (CST)
Received: from [192.168.1.9] (helo=disturbed) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1O9qAG-0005Do-QL
	for xfs@oss.sgi.com; Thu, 06 May 2010 11:46:12 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1O9qA5-0000cf-Tx
	for xfs@oss.sgi.com; Thu, 06 May 2010 11:46:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/11] xfs: enable background pushing of the CIL
Date: Thu,  6 May 2010 11:45:50 +1000
Message-Id: <1273110351-2333-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1273110351-2333-1-git-send-email-david@fromorbit.com>
References: <1273110351-2333-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

If we let the CIL grow without bound, it will grow large enough to violate
recovery constraints (must be at least one complete transaction in the log at
all times) or take forever to write out through the log buffers. Hence we need
a check during asynchronous transactions as to whether the CIL needs to be
pushed.

We track the amount of log space the CIL consumes, so it is relatively simple
to limit it on a pure size basis. Make the limit the minimum of just under half
the log size (recovery constraint) or 8MB of log space (which is an awful lot
of metadata).

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c  |   25 ++++++++++++++++++++++++-
 fs/xfs/xfs_log_priv.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 3cb1957..806cf6b 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -339,6 +339,7 @@ xfs_log_commit_cil(
 {
 	struct log		*log = mp->m_log;
 	int			log_flags = 0;
+	int			push = 0;
 
 	if (flags & XFS_TRANS_RELEASE_LOG_RES)
 		log_flags = XFS_LOG_REL_PERM_RESERV;
@@ -368,13 +369,26 @@ xfs_log_commit_cil(
 	xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
 	xfs_trans_unreserve_and_mod_sb(tp);
 
-	/* background commit is allowed again */
+	/* check for background commit */
+	if (log->l_cilp->xc_ctx->space_used > XLOG_CIL_SPACE_LIMIT(log))
+		push = 1;
+
 	up_read(&log->l_cilp->xc_ctx_lock);
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 
 	/* xfs_trans_free_items() unlocks them first */
 	xfs_trans_free_items(tp, *commit_lsn, 0);
 	xfs_trans_free(tp);
+
+	/*
+	 * We need to push CIL every so often so we don't cache more than we
+	 * can fit in the log. The limit really is that a checkpoint can't be
+	 * more than half the log (the current checkpoint is not allowed to
+	 * overwrite the previous checkpoint), but commit latency and memory
+	 * usage limit this to a smaller size in most cases.
+	 */
+	if (push)
+		xlog_cil_push(log, 0);
 	return 0;
 }
 
@@ -453,6 +467,15 @@ xlog_cil_push(
 		return 0;
 	}
 
+	/* check for spurious background flush */
+	if (!push_now &&
+	    log->l_cilp->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
+		up_write(&cil->xc_ctx_lock);
+		xfs_log_ticket_put(new_ctx->ticket);
+		kmem_free(new_ctx);
+		return 0;
+	}
+
 	/*
 	 * pull all the log vectors off the items in the CIL, and
 	 * remove the items from the CIL. We don't need the CIL lock
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index e9e8324..7490277 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -427,6 +427,51 @@ struct xfs_cil {
 };
 
 /*
+ * The amount of log space we should the CIL to aggregate is difficult to size.
+ * Whatever we chose we have to make we can get a reservation for the log space
+ * effectively, that it is large enough to capture sufficient relogging to
+ * reduce log buffer IO significantly, but it is not too large for the log or
+ * induces too much latency when writing out through the iclogs. We track both
+ * space consumed and the number of vectors in the checkpoint context, so we
+ * need to decide which to use for limiting.
+ *
+ * Every log buffer we write out during a push needs a header reserved, which
+ * is at least one sector and more for v2 logs. Hence we need a reservation of
+ * at least 512 bytes per 32k of log space just for the LR headers. That means
+ * 16KB of reservation per megabyte of delayed logging space we will consume,
+ * plus various headers.  The number of headers will vary based on the num of
+ * io vectors, so limiting on a specific number of vectors is going to result
+ * in transactions of varying size. IOWs, it is more consistent to track and
+ * limit space consumed in the log rather than by the number of objects being
+ * logged in order to prevent checkpoint ticket overruns.
+ *
+ * Further, use of static reservations through the log grant mechanism is
+ * problematic. It introduces a lot of complexity (e.g. reserve grant vs write
+ * grant) and a significant deadlock potential because regranting write space
+ * can block on log pushes. Hence if we have to regrant log space during a log
+ * push, we can deadlock.
+ *
+ * However, we can avoid this by use of a dynamic "reservation stealing"
+ * technique during transaction commit whereby unused reservation space in the
+ * transaction ticket is transferred to the CIL ctx commit ticket to cover the
+ * space needed by the checkpoint transaction. This means that we never need to
+ * specifically reserve space for the CIL checkpoint transaction, nor do we
+ * need to regrant space once the checkpoint completes. This also means the
+ * checkpoint transaction ticket is specific to the checkpoint context, rather
+ * than the CIL itself.
+ *
+ * With dynamic reservations, we can basically make up arbitrary limits for the
+ * checkpoint size so long as they don't violate any other size rules.  Hence
+ * the initial maximum size for the checkpoint transaction will be set to a
+ * quarter of the log or 8MB, which ever is smaller. 8MB is an arbitrary limit
+ * right now based on the latency of writing out a large amount of data through
+ * the circular iclog buffers.
+ */
+
+#define XLOG_CIL_SPACE_LIMIT(log)	\
+	(min((log->l_logsize >> 2), (8 * 1024 * 1024)))
+
+/*
  * The reservation head lsn is not made up of a cycle number and block number.
  * Instead, it uses a cycle number and byte number.  Logs don't expect to
  * overflow 31 bits worth of byte offset, so using a byte number will mean
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
