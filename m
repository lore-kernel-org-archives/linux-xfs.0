Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E8AE029E19
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 07:51:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7941304053
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 05:51:56 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id hsMZXJSbST7VcnBd (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 05:51:55 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z089A-0004gn-IJ
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 12:51:53 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] xfs: fix xfs_log_done interface
Date: Wed,  3 Jun 2015 14:49:56 +0200
Message-Id: <1433335796-23445-6-git-send-email-hch@lst.de>
In-Reply-To: <1433335796-23445-1-git-send-email-hch@lst.de>
References: <1433335796-23445-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Instead of the confusing flags argument pass a boolean flag to indicate if
we want to release or regrant a log reservation.

Also ensure that xfs_log_done always drop the reference on the log ticket,
to both simplify the code and make the logic in xfs_trans_roll easier
to understand.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c     | 11 ++++-------
 fs/xfs/xfs_log.h     | 11 +----------
 fs/xfs/xfs_log_cil.c |  8 ++------
 fs/xfs/xfs_trans.c   | 33 ++++-----------------------------
 4 files changed, 11 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bcc7cfa..c8d09ef 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -513,7 +513,7 @@ xfs_log_done(
 	struct xfs_mount	*mp,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	**iclog,
-	uint			flags)
+	bool			regrant)
 {
 	struct xlog		*log = mp->m_log;
 	xfs_lsn_t		lsn = 0;
@@ -526,14 +526,11 @@ xfs_log_done(
 	    (((ticket->t_flags & XLOG_TIC_INITED) == 0) &&
 	     (xlog_commit_record(log, ticket, iclog, &lsn)))) {
 		lsn = (xfs_lsn_t) -1;
-		if (ticket->t_flags & XLOG_TIC_PERM_RESERV) {
-			flags |= XFS_LOG_REL_PERM_RESERV;
-		}
+		regrant = false;
 	}
 
 
-	if ((ticket->t_flags & XLOG_TIC_PERM_RESERV) == 0 ||
-	    (flags & XFS_LOG_REL_PERM_RESERV)) {
+	if (!regrant) {
 		trace_xfs_log_done_nonperm(log, ticket);
 
 		/*
@@ -541,7 +538,6 @@ xfs_log_done(
 		 * request has been made to release a permanent reservation.
 		 */
 		xlog_ungrant_log_space(log, ticket);
-		xfs_log_ticket_put(ticket);
 	} else {
 		trace_xfs_log_done_perm(log, ticket);
 
@@ -553,6 +549,7 @@ xfs_log_done(
 		ticket->t_flags |= XLOG_TIC_INITED;
 	}
 
+	xfs_log_ticket_put(ticket);
 	return lsn;
 }
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 4040c47..fa27aae 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -111,15 +111,6 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
 #define	XFS_LSN_CMP(x,y) _lsn_cmp(x,y)
 
 /*
- * Macros, structures, prototypes for interface to the log manager.
- */
-
-/*
- * Flags to xfs_log_done()
- */
-#define XFS_LOG_REL_PERM_RESERV	0x1
-
-/*
  * Flags to xfs_log_force()
  *
  *	XFS_LOG_SYNC:	Synchronous force in-core log to disk
@@ -138,7 +129,7 @@ struct xfs_log_callback;
 xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
 		       struct xlog_ticket *ticket,
 		       struct xlog_in_core **iclog,
-		       uint		flags);
+		       bool regrant);
 int	  _xfs_log_force(struct xfs_mount *mp,
 			 uint		flags,
 			 int		*log_forced);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index d6f26d7..abc2ccb 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -624,7 +624,7 @@ restart:
 	spin_unlock(&cil->xc_push_lock);
 
 	/* xfs_log_done always frees the ticket on error. */
-	commit_lsn = xfs_log_done(log->l_mp, tic, &commit_iclog, 0);
+	commit_lsn = xfs_log_done(log->l_mp, tic, &commit_iclog, false);
 	if (commit_lsn == -1)
 		goto out_abort;
 
@@ -777,10 +777,6 @@ xfs_log_commit_cil(
 {
 	struct xlog		*log = mp->m_log;
 	struct xfs_cil		*cil = log->l_cilp;
-	int			log_flags = 0;
-
-	if (!regrant)
-		log_flags = XFS_LOG_REL_PERM_RESERV;
 
 	/* lock out background commit */
 	down_read(&cil->xc_ctx_lock);
@@ -795,7 +791,7 @@ xfs_log_commit_cil(
 	if (commit_lsn)
 		*commit_lsn = tp->t_commit_lsn;
 
-	xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
+	xfs_log_done(mp, tp->t_ticket, NULL, regrant);
 	xfs_trans_unreserve_and_mod_sb(tp);
 
 	/*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index fb1bd17..0582a27 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -251,14 +251,7 @@ xfs_trans_reserve(
 	 */
 undo_log:
 	if (resp->tr_logres > 0) {
-		int		log_flags;
-
-		if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES) {
-			log_flags = XFS_LOG_REL_PERM_RESERV;
-		} else {
-			log_flags = 0;
-		}
-		xfs_log_done(tp->t_mountp, tp->t_ticket, NULL, log_flags);
+		xfs_log_done(tp->t_mountp, tp->t_ticket, NULL, false);
 		tp->t_ticket = NULL;
 		tp->t_log_res = 0;
 		tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
@@ -954,13 +947,7 @@ out_unreserve:
 	 */
 	xfs_trans_unreserve_and_mod_dquots(tp);
 	if (tp->t_ticket) {
-		int			log_flags = 0;
-
-		if (regrant)
-			ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
-		else
-			log_flags = XFS_LOG_REL_PERM_RESERV;
-		commit_lsn = xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
+		commit_lsn = xfs_log_done(mp, tp->t_ticket, NULL, regrant);
 		if (commit_lsn == -1 && !error)
 			error = -EIO;
 	}
@@ -1014,13 +1001,8 @@ xfs_trans_cancel(
 	xfs_trans_unreserve_and_mod_sb(tp);
 	xfs_trans_unreserve_and_mod_dquots(tp);
 
-	if (tp->t_ticket) {
-		uint		log_flags = 0;
-
-		if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
-			log_flags = XFS_LOG_REL_PERM_RESERV;
-		xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
-	}
+	if (tp->t_ticket)
+		xfs_log_done(mp, tp->t_ticket, NULL, false);
 
 	/* mark this thread as no longer being in a transaction */
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
@@ -1073,13 +1055,6 @@ xfs_trans_roll(
 	trans = *tpp;
 
 	/*
-	 * transaction commit worked ok so we can drop the extra ticket
-	 * reference that we gained in xfs_trans_dup()
-	 */
-	xfs_log_ticket_put(trans->t_ticket);
-
-
-	/*
 	 * Reserve space in the log for th next transaction.
 	 * This also pushes items in the "AIL", the list of logged items,
 	 * out to disk if they are taking up space at the tail of the log
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
