Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 16:24:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1F0O7bP010206
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 16:24:10 -0800
Date: Fri, 15 Feb 2008 11:24:29 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Use atomics for iclog reference counting
Message-ID: <20080215002429.GT155259@sgi.com>
References: <20080121053021.GH155259@sgi.com> <4796CCF5.8010509@sgi.com> <20080214234758.GP155259@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080214234758.GP155259@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Feb 15, 2008 at 10:47:58AM +1100, David Chinner wrote:
> On Wed, Jan 23, 2008 at 04:13:25PM +1100, Timothy Shimmin wrote:
> > I'll have a look...
> 
> Tim, have you had a chance to look at this one yet? I'd like to
> push this too, but I understand you are kinda busy right now :/

FWIW, you might want to review this version ;)

----

Now that we update the log tail LSN less frequently on
transaction completion, we pass the contention straight to
the global log state lock (l_iclog_lock) during transaction
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

Version 2:
o remove spurious unlock in shutdown path in xlog_state_release_iclog()

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_log.c      |   36 ++++++++++++++++++++----------------
 fs/xfs/xfs_log_priv.h |    2 +-
 fs/xfs/xfsidbg.c      |    2 +-
 3 files changed, 22 insertions(+), 18 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2008-02-15 11:19:08.076544539 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2008-02-15 11:20:22.558911855 +1100
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
@@ -2312,7 +2312,7 @@ xlog_state_done_syncing(
 
 	ASSERT(iclog->ic_state == XLOG_STATE_SYNCING ||
 	       iclog->ic_state == XLOG_STATE_IOERROR);
-	ASSERT(iclog->ic_refcnt == 0);
+	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
 	ASSERT(iclog->ic_bwritecnt == 1 || iclog->ic_bwritecnt == 2);
 
 
@@ -2394,7 +2394,7 @@ restart:
 	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
 	head = &iclog->ic_header;
 
-	iclog->ic_refcnt++;			/* prevents sync */
+	atomic_inc(&iclog->ic_refcnt);	/* prevents sync */
 	log_offset = iclog->ic_offset;
 
 	/* On the 1st write to an iclog, figure out lsn.  This works
@@ -2426,12 +2426,12 @@ restart:
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
@@ -2822,18 +2822,21 @@ xlog_state_release_iclog(
 {
 	int		sync = 0;	/* do we sync? */
 
-	spin_lock(&log->l_icloglock);
+	if (iclog->ic_state & XLOG_STATE_IOERROR)
+		return XFS_ERROR(EIO);
+
+	ASSERT(atomic_read(&iclog->ic_refcnt) > 0);
+	if (!atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock))
+		return 0;
+
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		spin_unlock(&log->l_icloglock);
 		return XFS_ERROR(EIO);
 	}
-
-	ASSERT(iclog->ic_refcnt > 0);
 	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE ||
 	       iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
-	if (--iclog->ic_refcnt == 0 &&
-	    iclog->ic_state == XLOG_STATE_WANT_SYNC) {
+	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
 		/* update tail before writing to iclog */
 		xlog_assign_tail_lsn(log->l_mp);
 		sync++;
@@ -2953,7 +2956,8 @@ xlog_state_sync_all(xlog_t *log, uint fl
 		 * previous iclog and go to sleep.
 		 */
 		if (iclog->ic_state == XLOG_STATE_DIRTY ||
-		    (iclog->ic_refcnt == 0 && iclog->ic_offset == 0)) {
+		    (atomic_read(&iclog->ic_refcnt) == 0
+		     && iclog->ic_offset == 0)) {
 			iclog = iclog->ic_prev;
 			if (iclog->ic_state == XLOG_STATE_ACTIVE ||
 			    iclog->ic_state == XLOG_STATE_DIRTY)
@@ -2961,14 +2965,14 @@ xlog_state_sync_all(xlog_t *log, uint fl
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
@@ -3100,7 +3104,7 @@ try_again:
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
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log_priv.h	2008-02-15 11:19:08.080544022 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_log_priv.h	2008-02-15 11:19:14.403726218 +1100
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
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2008-02-15 11:19:08.096541953 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2008-02-15 11:19:14.407725701 +1100
@@ -5633,7 +5633,7 @@ xfsidbg_xiclog(xlog_in_core_t *iclog)
 #else
 		NULL,
 #endif
-		iclog->ic_refcnt, iclog->ic_bwritecnt);
+		atomic_read(&iclog->ic_refcnt), iclog->ic_bwritecnt);
 	if (iclog->ic_state & XLOG_STATE_ALL)
 		printflags(iclog->ic_state, ic_flags, " state:");
 	else

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
