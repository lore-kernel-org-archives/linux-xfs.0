Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58FI4k9010766 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 10:18:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62D511659A7A
	for <xfs@oss.sgi.com>; Thu, 29 Jul 2010 15:55:57 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	UIbea9OV0Cbt7236 for <xfs@oss.sgi.com>;
	Thu, 29 Jul 2010 15:55:57 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: unlock items before allowing the CIL to commit
Date: Fri, 30 Jul 2010 08:55:45 +1000
Message-Id: <1280444146-14540-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1280444146-14540-1-git-send-email-david@fromorbit.com>
References: <1280444146-14540-1-git-send-email-david@fromorbit.com>
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
Cc: npiggin@kernel.de

From: Dave Chinner <dchinner@redhat.com>

When we commit a transaction using delayed logging, we need to
unlock the items in the transaciton before we unlock the CIL context
and allow it to be checkpointed. If we unlock them after we release
the CIl context lock, the CIL can checkpoint and complete before
we free the log items. This breaks stale buffer item unlock and
unpin processing as there is an implicit assumption that the unlock
will occur before the unpin.

Also, some log items need to store the LSN of the transaction commit
in the item (inodes and EFIs) and so can race with other transaction
completions if we don't prevent the CIL from checkpointing before
the unlock occurs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c    |   14 ++++++++++++++
 fs/xfs/xfs_trans.c      |    5 +----
 fs/xfs/xfs_trans_priv.h |    3 ++-
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 31e4ea2..ef8e7d9 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -377,9 +377,23 @@ xfs_log_commit_cil(
 	xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
 	xfs_trans_unreserve_and_mod_sb(tp);
 
+	/*
+	 * Once all the items of the transaction have been copied to the CIL,
+	 * the items can be unlocked and freed.
+	 *
+	 * This needs to be done before we drop the CIL context lock because we
+	 * have to update state in the log items and unlock them before they go
+	 * to disk. If we don't, then the CIL checkpoint can race with us and
+	 * we can run checkpoint completion before we've updated and unlocked
+	 * the log items. This affects (at least) processing of stale buffers,
+	 * inodes and EFIs.
+	 */
+	xfs_trans_free_items(tp, *commit_lsn, 0);
+
 	/* check for background commit before unlock */
 	if (log->l_cilp->xc_ctx->space_used > XLOG_CIL_SPACE_LIMIT(log))
 		push = 1;
+
 	up_read(&log->l_cilp->xc_ctx_lock);
 
 	/*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index fdca741..1c47eda 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1167,7 +1167,7 @@ xfs_trans_del_item(
  * Unlock all of the items of a transaction and free all the descriptors
  * of that transaction.
  */
-STATIC void
+void
 xfs_trans_free_items(
 	struct xfs_trans	*tp,
 	xfs_lsn_t		commit_lsn,
@@ -1653,9 +1653,6 @@ xfs_trans_commit_cil(
 		return error;
 
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
-
-	/* xfs_trans_free_items() unlocks them first */
-	xfs_trans_free_items(tp, *commit_lsn, 0);
 	xfs_trans_free(tp);
 	return 0;
 }
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index e2d93d8..62da86c 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -25,7 +25,8 @@ struct xfs_trans;
 
 void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
-
+void	xfs_trans_free_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn,
+				int flags);
 void	xfs_trans_item_committed(struct xfs_log_item *lip,
 				xfs_lsn_t commit_lsn, int aborted);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
