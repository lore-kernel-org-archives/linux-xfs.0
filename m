Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4HNMWWL014449 for <xfs@oss.sgi.com>; Mon, 17 May 2010 18:22:32 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B05839C4D57
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 16:25:47 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	A9CDNsCa6iBkWRxy for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 16:25:47 -0700 (PDT)
Received: from dastard (unverified [121.44.136.97])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	24730566-1927428
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 08:54:47 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OE9fw-0005A0-IK
	for xfs@oss.sgi.com; Tue, 18 May 2010 09:24:44 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OE9fr-0000Rx-MI
	for xfs@oss.sgi.com; Tue, 18 May 2010 09:24:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/12] xfs: enable background pushing of the CIL
Date: Tue, 18 May 2010 09:24:27 +1000
Message-Id: <1274138668-1662-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1274138668-1662-1-git-send-email-david@fromorbit.com>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_cil.c  |   29 +++++++++++++++++++++++++----
 fs/xfs/xfs_log_priv.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index fc41bf2..97ed647 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -336,6 +336,7 @@ xfs_log_commit_cil(
 {
 	struct log		*log = mp->m_log;
 	int			log_flags = 0;
+	int			push = 0;
 
 	if (flags & XFS_TRANS_RELEASE_LOG_RES)
 		log_flags = XFS_LOG_REL_PERM_RESERV;
@@ -365,8 +366,20 @@ xfs_log_commit_cil(
 	xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
 	xfs_trans_unreserve_and_mod_sb(tp);
 
-	/* background commit is allowed again */
+	/* check for background commit before unlock */
+	if (log->l_cilp->xc_ctx->space_used > XLOG_CIL_SPACE_LIMIT(log))
+		push = 1;
 	up_read(&log->l_cilp->xc_ctx_lock);
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
 
@@ -429,18 +442,25 @@ xlog_cil_push(
 	if (!cil)
 		return 0;
 
-	/* XXX: don't sleep for background? */
 	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_SLEEP|KM_NOFS);
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
 
-	/* lock out transaction commit */
-	down_write(&cil->xc_ctx_lock);
+	/* lock out transaction commit, but don't block on background push */
+	if (!down_write_trylock(&cil->xc_ctx_lock)) {
+		if (!push_now)
+			goto out_free_ticket;
+		down_write(&cil->xc_ctx_lock);
+	}
 	ctx = cil->xc_ctx;
 
 	/* check if we've anything to push */
 	if (list_empty(&cil->xc_cil))
 		goto out_skip;
 
+	/* check for spurious background flush */
+	if (!push_now && cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
+		goto out_skip;
+
 	/*
 	 * pull all the log vectors off the items in the CIL, and
 	 * remove the items from the CIL. We don't need the CIL lock
@@ -584,6 +604,7 @@ restart:
 
 out_skip:
 	up_write(&cil->xc_ctx_lock);
+out_free_ticket:
 	xfs_log_ticket_put(new_ctx->ticket);
 	kmem_free(new_ctx);
 	return 0;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 48d9208..8c07261 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -425,6 +425,51 @@ struct xfs_cil {
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
