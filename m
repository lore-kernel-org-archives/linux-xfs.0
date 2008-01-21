Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 21:30:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L5U9ZW017213
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 21:30:13 -0800
Date: Mon, 21 Jan 2008 16:30:21 +1100
From: David Chinner <dgc@sgi.com>
Subject: [patch] Use atomics for iclog reference counting
Message-ID: <20080121053021.GH155259@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Now that we update the log tail LSN less frequently on
transaction completion, we pass the contention straight to
the global block stat lock (l_iclog_lock) during transaction
completion.

We currently have to take this lock to decrement the iclog
reference count. there is a reference count on each iclog,
so we need to take þhe global lock for all refcount changes.

When large numbers of processes are all doing small trnasctions,
the iclog reference counts will be quite high, and the state change
that absolutely requires the l_iclog_lock is the except rather than
the norm.

Change the reference counting on the iclogs to use atomic_inc/dec
so that we can use atomic_dec_and_lock during transaction completion
and avoid the need for grabbing the l_iclog_lock for every reference
count decrement except the one that matters - the last.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_log.c      |   36 +++++++++++++++++++++---------------
 fs/xfs/xfs_log_priv.h |    2 +-
 fs/xfs/xfsidbg.c      |    2 +-
 3 files changed, 23 insertions(+), 17 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2008-01-21 16:16:51.804146394 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2008-01-21 16:23:35.369691221 +1100
@@ -675,7 +675,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 
 		spin_lock(&log->l_icloglock);
 		iclog = log->l_iclog;
-		iclog->ic_refcnt++;
+		atomic_inc(&iclog->ic_refcnt);
 		spin_unlock(&log->l_icloglock);
 		xlog_state_want_sync(log, iclog);
 		(void) xlog_state_release_iclog(log, iclog);
@@ -713,7 +713,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		 */
 		spin_lock(&log->l_icloglock);
 		iclog = log->l_iclog;
-		iclog->ic_refcnt++;
+		atomic_inc(&iclog->ic_refcnt);
 		spin_unlock(&log->l_icloglock);
 
 		xlog_state_want_sync(log, iclog);
@@ -1405,7 +1405,7 @@ xlog_sync(xlog_t		*log,
 	int		v2 = XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb);
 
 	XFS_STATS_INC(xs_log_writes);
-	ASSERT(iclog->ic_refcnt == 0);
+	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
 
 	/* Add for LR header */
 	count_init = log->l_iclog_hsize + iclog->ic_offset;
@@ -2311,7 +2311,7 @@ xlog_state_done_syncing(
 
 	ASSERT(iclog->ic_state == XLOG_STATE_SYNCING ||
 	       iclog->ic_state == XLOG_STATE_IOERROR);
-	ASSERT(iclog->ic_refcnt == 0);
+	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
 	ASSERT(iclog->ic_bwritecnt == 1 || iclog->ic_bwritecnt == 2);
 
 
@@ -2393,7 +2393,7 @@ restart:
 	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
 	head = &iclog->ic_header;
 
-	iclog->ic_refcnt++;			/* prevents sync */
+	atomic_inc(&iclog->ic_refcnt);	/* prevents sync */
 	log_offset = iclog->ic_offset;
 
 	/* On the 1st write to an iclog, figure out lsn.  This works
@@ -2425,12 +2425,12 @@ restart:
 		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
 
 		/* If I'm the only one writing to this iclog, sync it to disk */
-		if (iclog->ic_refcnt == 1) {
+		if (atomic_read(&iclog->ic_refcnt) == 1) {
 			spin_unlock(&log->l_icloglock);
 			if ((error = xlog_state_release_iclog(log, iclog)))
 				return error;
 		} else {
-			iclog->ic_refcnt--;
+			atomic_dec(&iclog->ic_refcnt);
 			spin_unlock(&log->l_icloglock);
 		}
 		goto restart;
@@ -2821,18 +2821,23 @@ xlog_state_release_iclog(
 {
 	int		sync = 0;	/* do we sync? */
 
-	spin_lock(&log->l_icloglock);
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		spin_unlock(&log->l_icloglock);
 		return XFS_ERROR(EIO);
 	}
 
-	ASSERT(iclog->ic_refcnt > 0);
+	ASSERT(atomic_read(&iclog->ic_refcnt) > 0);
+	if (!atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock))
+		return 0;
+
+	if (iclog->ic_state & XLOG_STATE_IOERROR) {
+		spin_unlock(&log->l_icloglock);
+		return XFS_ERROR(EIO);
+	}
 	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE ||
 	       iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
-	if (--iclog->ic_refcnt == 0 &&
-	    iclog->ic_state == XLOG_STATE_WANT_SYNC) {
+	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
 		/* update tail before writing to iclog */
 		xlog_assign_tail_lsn(log->l_mp);
 		sync++;
@@ -2952,7 +2957,8 @@ xlog_state_sync_all(xlog_t *log, uint fl
 		 * previous iclog and go to sleep.
 		 */
 		if (iclog->ic_state == XLOG_STATE_DIRTY ||
-		    (iclog->ic_refcnt == 0 && iclog->ic_offset == 0)) {
+		    (atomic_read(&iclog->ic_refcnt) == 0
+		     && iclog->ic_offset == 0)) {
 			iclog = iclog->ic_prev;
 			if (iclog->ic_state == XLOG_STATE_ACTIVE ||
 			    iclog->ic_state == XLOG_STATE_DIRTY)
@@ -2960,14 +2966,14 @@ xlog_state_sync_all(xlog_t *log, uint fl
 			else
 				goto maybe_sleep;
 		} else {
-			if (iclog->ic_refcnt == 0) {
+			if (atomic_read(&iclog->ic_refcnt) == 0) {
 				/* We are the only one with access to this
 				 * iclog.  Flush it out now.  There should
 				 * be a roundoff of zero to show that someone
 				 * has already taken care of the roundoff from
 				 * the previous sync.
 				 */
-				iclog->ic_refcnt++;
+				atomic_inc(&iclog->ic_refcnt);
 				lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 				xlog_state_switch_iclogs(log, iclog, 0);
 				spin_unlock(&log->l_icloglock);
@@ -3099,7 +3105,7 @@ try_again:
 			already_slept = 1;
 			goto try_again;
 		} else {
-			iclog->ic_refcnt++;
+			atomic_inc(&iclog->ic_refcnt);
 			xlog_state_switch_iclogs(log, iclog, 0);
 			spin_unlock(&log->l_icloglock);
 			if (xlog_state_release_iclog(log, iclog))
Index: 2.6.x-xfs-new/fs/xfs/xfs_log_priv.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log_priv.h	2008-01-21 16:06:27.127557437 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_log_priv.h	2008-01-21 16:23:35.369691221 +1100
@@ -339,7 +339,7 @@ typedef struct xlog_iclog_fields {
 #endif
 	int			ic_size;
 	int			ic_offset;
-	int			ic_refcnt;
+	atomic_t		ic_refcnt;
 	int			ic_bwritecnt;
 	ushort_t		ic_state;
 	char			*ic_datap;	/* pointer to iclog data */
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2008-01-21 16:06:27.127557437 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2008-01-21 16:23:35.385689220 +1100
@@ -5633,7 +5633,7 @@ xfsidbg_xiclog(xlog_in_core_t *iclog)
 #else
 		NULL,
 #endif
-		iclog->ic_refcnt, iclog->ic_bwritecnt);
+		atomic_read(&iclog->ic_refcnt), iclog->ic_bwritecnt);
 	if (iclog->ic_state & XLOG_STATE_ALL)
 		printflags(iclog->ic_state, ic_flags, " state:");
 	else
