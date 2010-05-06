Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o461i1Sp065022 for <xfs@oss.sgi.com>; Wed, 5 May 2010 20:44:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 712193139BA
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 18:46:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	0WQAsL6sRw9LigfH for <xfs@oss.sgi.com>;
	Wed, 05 May 2010 18:46:07 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	23226481-1927428
	for <xfs@oss.sgi.com>; Thu, 06 May 2010 11:16:05 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1O9qA6-0005Dj-Ln
	for xfs@oss.sgi.com; Thu, 06 May 2010 11:46:02 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1O9qA5-0000cZ-LX
	for xfs@oss.sgi.com; Thu, 06 May 2010 11:46:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/11] xfs: Introduce delayed logging core code
Date: Thu,  6 May 2010 11:45:48 +1000
Message-Id: <1273110351-2333-9-git-send-email-david@fromorbit.com>
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

The delayed logging code only changes in-memory structures and as
such can be enabled and disabled with a mount option. Add the mount
option and emit a warning that this is an experimental feature that
should not be used in production yet.

We also need infrastructure to track committed items that have not
yet been written to the log. This is what the Committed Item List
(CIL) is for.

The log item also needs to be extended to track the current log
vector, the associated memory buffer and it's location in the Commit
Item List. Extend the log item and log vector structures to enable
this tracking.

To maintain the current log format for transactions with delayed
logging, we need to introduce a checkpoint transaction and a context
for tracking each checkpoint from initiation to transaction
completion.  This includes adding a log ticket for tracking space
log required/used by the context checkpoint.

To track all the changes we need an io vector array per log item,
rather than a single array for the entire transaction. Using the new
log vector structure for this requires two passes - the first to
allocate the log vector structures and chain them together, and the
second to fill them out.  This log vector chain can then be passed
to the CIL for formatting, pinning and insertion into the CIL.

Formatting of the log vector chain is relatively simple - it's just
a loop over the iovecs on each log vector, but it is made slightly
more complex because we re-write the iovec after the copy to point
back at the memory buffer we just copied into.

This code also needs to pin log items. If the log item is not
already tracked in this checkpoint context, then it needs to be
pinned. Otherwise it is already pinned and we don't need to pin it
again.

The only other complexity is calculating the amount of new log space
the formatting has consumed. This needs to be accounted to the
transaction in progress, and the accounting is made more complex
becase we need also to steal space from it for log metadata in the
checkpoint transaction. Calculate all this at insert time and update
all the tickets, counters, etc correctly.

Once we've formatted all the log items in the transaction, attach
the busy extents to the checkpoint context so the busy extents live
until checkpoint completion and can be processed at that point in
time. Transactions can then be freed at this point in time.

Now we need to issue checkpoints - we are tracking the amount of log space
used by the items in the CIL, so we can trigger background checkpoints when the
space usage gets to a certain threshold. Otherwise, checkpoints need ot be
triggered when a log synchronisation point is reached - a log force event.

Because the log write code already handles chained log vectors, writing the
transaction is trivial, too. Construct a transaction header, add it
to the head of the chain and write it into the log, then issue a
commit record write. Then we can release the checkpoint log ticket
and attach the context to the log buffer so it can be called during
Io completion to complete the checkpoint.

We also need to allow for synchronising multiple in-flight
checkpoints. This is needed for two things - the first is to ensure
that checkpoint commit records appear in the log in the correct
sequence order (so they are replayed in the correct order). The
second is so that xfs_log_force_lsn() operates correctly and only
flushes and/or waits for the specific sequence it was provided with.

To do this we need a wait variable and a list tracking the
checkpoint commits in progress. We can walk this list and wait for
the checkpoints to change state or complete easily, an this provides
the necessary synchronisation for correct operation in both cases.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile              |    1 +
 fs/xfs/linux-2.6/xfs_super.c |   10 +
 fs/xfs/xfs_log.c             |   67 ++++-
 fs/xfs/xfs_log.h             |    9 +-
 fs/xfs/xfs_log_cil.c         |  666 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_priv.h        |   71 +++++-
 fs/xfs/xfs_mount.h           |    1 +
 fs/xfs/xfs_trans.c           |  144 +++++++++-
 fs/xfs/xfs_trans.h           |    8 +-
 fs/xfs/xfs_trans_item.c      |    5 +-
 fs/xfs/xfs_trans_priv.h      |   12 +-
 11 files changed, 963 insertions(+), 31 deletions(-)
 create mode 100644 fs/xfs/xfs_log_cil.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b4769e4..c8fb13f 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -77,6 +77,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_itable.o \
 				   xfs_dfrag.o \
 				   xfs_log.o \
+				   xfs_log_cil.o \
 				   xfs_log_recover.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 1e88c98..6a7c8c9 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -118,6 +118,8 @@ mempool_t *xfs_ioend_pool;
 #define MNTOPT_DMAPI	"dmapi"		/* DMI enabled (DMAPI / XDSM) */
 #define MNTOPT_XDSM	"xdsm"		/* DMI enabled (DMAPI / XDSM) */
 #define MNTOPT_DMI	"dmi"		/* DMI enabled (DMAPI / XDSM) */
+#define MNTOPT_DELAYLOG   "delaylog"	/* Delayed loging enabled */
+#define MNTOPT_NODELAYLOG "nodelaylog"	/* Delayed loging disabled */
 
 /*
  * Table driven mount option parser.
@@ -373,6 +375,13 @@ xfs_parseargs(
 			mp->m_flags |= XFS_MOUNT_DMAPI;
 		} else if (!strcmp(this_char, MNTOPT_DMI)) {
 			mp->m_flags |= XFS_MOUNT_DMAPI;
+		} else if (!strcmp(this_char, MNTOPT_DELAYLOG)) {
+			mp->m_flags |= XFS_MOUNT_DELAYLOG;
+			cmn_err(CE_WARN,
+				"Enabling EXPERIMENTAL delayed logging feature "
+				"- use at your own risk.\n");
+		} else if (!strcmp(this_char, MNTOPT_NODELAYLOG)) {
+			mp->m_flags &= ~XFS_MOUNT_DELAYLOG;
 		} else if (!strcmp(this_char, "ihashsize")) {
 			cmn_err(CE_WARN,
 	"XFS: ihashsize no longer used, option is deprecated.");
@@ -534,6 +543,7 @@ xfs_showargs(
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
 		{ XFS_MOUNT_DMAPI,		"," MNTOPT_DMAPI },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
+		{ XFS_MOUNT_DELAYLOG,		"," MNTOPT_DELAYLOG },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1efb303..88cdfac 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -54,9 +54,6 @@ STATIC xlog_t *  xlog_alloc_log(xfs_mount_t	*mp,
 STATIC int	 xlog_space_left(xlog_t *log, int cycle, int bytes);
 STATIC int	 xlog_sync(xlog_t *log, xlog_in_core_t *iclog);
 STATIC void	 xlog_dealloc_log(xlog_t *log);
-STATIC int	 xlog_write(struct log *log, struct xfs_log_vec *log_vector,
-			    struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
-			    xlog_in_core_t **commit_iclog, uint flags);
 
 /* local state machine functions */
 STATIC void xlog_state_done_syncing(xlog_in_core_t *iclog, int);
@@ -86,12 +83,6 @@ STATIC int xlog_regrant_write_log_space(xlog_t		*log,
 STATIC void xlog_ungrant_log_space(xlog_t	 *log,
 				   xlog_ticket_t *ticket);
 
-
-/* local ticket functions */
-STATIC xlog_ticket_t *xlog_ticket_alloc(xlog_t *log, int unit_bytes, int count,
-					char clientid, uint flags,
-					int alloc_flags);
-
 #if defined(DEBUG)
 STATIC void	xlog_verify_dest_ptr(xlog_t *log, char *ptr);
 STATIC void	xlog_verify_grant_head(xlog_t *log, int equals);
@@ -460,6 +451,16 @@ xfs_log_mount(
 	/* Normal transactions can now occur */
 	mp->m_log->l_flags &= ~XLOG_ACTIVE_RECOVERY;
 
+	/*
+	 * Now the log has been fully initialised and we know were our
+	 * space grant counters are, we can initialise the permanent ticket
+	 * needed for delayed logging to work.
+	 */
+	error = xlog_cil_init_post_recovery(mp->m_log);
+	if (error) {
+		ASSERT(0);
+		goto out_destroy_ail;
+	}
 	return 0;
 
 out_destroy_ail:
@@ -666,6 +667,10 @@ xfs_log_item_init(
 	item->li_ailp = mp->m_ail;
 	item->li_type = type;
 	item->li_ops = ops;
+	item->li_lv = NULL;
+
+	INIT_LIST_HEAD(&item->li_ail);
+	INIT_LIST_HEAD(&item->li_cil);
 }
 
 /*
@@ -1176,6 +1181,9 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	*iclogp = log->l_iclog;			/* complete ring */
 	log->l_iclog->ic_prev = prev_iclog;	/* re-write 1st prev ptr */
 
+	error = xlog_cil_init(log);
+	if (error)
+		goto out_free_iclog;
 	return log;
 
 out_free_iclog:
@@ -1502,6 +1510,8 @@ xlog_dealloc_log(xlog_t *log)
 	xlog_in_core_t	*iclog, *next_iclog;
 	int		i;
 
+	xlog_cil_destroy(log);
+
 	iclog = log->l_iclog;
 	for (i=0; i<log->l_iclog_bufs; i++) {
 		sv_destroy(&iclog->ic_force_wait);
@@ -1544,8 +1554,10 @@ xlog_state_finish_copy(xlog_t		*log,
  * print out info relating to regions written which consume
  * the reservation
  */
-STATIC void
-xlog_print_tic_res(xfs_mount_t *mp, xlog_ticket_t *ticket)
+void
+xlog_print_tic_res(
+	struct xfs_mount	*mp,
+	struct xlog_ticket	*ticket)
 {
 	uint i;
 	uint ophdr_spc = ticket->t_res_num_ophdrs * (uint)sizeof(xlog_op_header_t);
@@ -1877,7 +1889,7 @@ xlog_write_copy_finish(
  *	we don't update ic_offset until the end when we know exactly how many
  *	bytes have been written out.
  */
-STATIC int
+int
 xlog_write(
 	struct log		*log,
 	struct xfs_log_vec	*log_vector,
@@ -1901,9 +1913,26 @@ xlog_write(
 	*start_lsn = 0;
 
 	len = xlog_write_calc_vec_length(ticket, log_vector);
-	if (ticket->t_curr_res < len)
+	if (log->l_cilp) {
+		/*
+		 * Region headers and bytes are already accounted for.
+		 * We only need to take into account start records and
+		 * split regions in this function.
+		 */
+		if (ticket->t_flags & XLOG_TIC_INITED)
+			ticket->t_curr_res -= sizeof(xlog_op_header_t);
+
+		/*
+		 * Commit record headers need to be accounted for. These
+		 * come in as separate writes so are easy to detect.
+		 */
+		if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
+			ticket->t_curr_res -= sizeof(xlog_op_header_t);
+	} else
+		ticket->t_curr_res -= len;
+
+	if (ticket->t_curr_res < 0)
 		xlog_print_tic_res(log->l_mp, ticket);
-	ticket->t_curr_res -= len;
 
 	index = 0;
 	lv = log_vector;
@@ -2999,6 +3028,8 @@ _xfs_log_force(
 
 	XFS_STATS_INC(xs_log_force);
 
+	xlog_cil_push(log, 1);
+
 	spin_lock(&log->l_icloglock);
 
 	iclog = log->l_iclog;
@@ -3148,6 +3179,12 @@ _xfs_log_force_lsn(
 
 	XFS_STATS_INC(xs_log_force);
 
+	if (log->l_cilp) {
+		lsn = xlog_cil_push_lsn(log, lsn);
+		if (lsn == NULLCOMMITLSN)
+			return 0;
+	}
+
 try_again:
 	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
@@ -3315,7 +3352,7 @@ xfs_log_ticket_get(
 /*
  * Allocate and initialise a new log ticket.
  */
-STATIC xlog_ticket_t *
+xlog_ticket_t *
 xlog_ticket_alloc(
 	struct log	*log,
 	int		unit_bytes,
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 229d1f3..1764f11 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -114,6 +114,9 @@ struct xfs_log_vec {
 	struct xfs_log_vec	*lv_next;	/* next lv in build list */
 	int			lv_niovecs;	/* number of iovecs in lv */
 	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
+	struct xfs_log_item	*lv_item;	/* owner */
+	char			*lv_buf;	/* formatted buffer */
+	int			lv_buf_len;	/* size of formatted buffer */
 };
 
 /*
@@ -134,6 +137,7 @@ struct xlog_in_core;
 struct xlog_ticket;
 struct xfs_log_item;
 struct xfs_item_ops;
+struct xfs_trans;
 
 void	xfs_log_item_init(struct xfs_mount	*mp,
 			struct xfs_log_item	*item,
@@ -187,9 +191,12 @@ int	  xfs_log_need_covered(struct xfs_mount *mp);
 
 void	  xlog_iodone(struct xfs_buf *);
 
-struct xlog_ticket * xfs_log_ticket_get(struct xlog_ticket *ticket);
+struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
+int	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
+				struct xfs_log_vec *log_vector,
+				xfs_lsn_t *commit_lsn, int flags);
 #endif
 
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
new file mode 100644
index 0000000..3cb1957
--- /dev/null
+++ b/fs/xfs/xfs_log_cil.c
@@ -0,0 +1,666 @@
+/*
+ * Copyright (c) 2010 Redhat, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_log_priv.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_dmapi.h"
+#include "xfs_mount.h"
+#include "xfs_error.h"
+#include "xfs_alloc.h"
+
+/*
+ * Perform initial CIL structure initialisation. If the CIL is not
+ * enabled in this filesystem, ensure the log->l_cilp is null so
+ * we can check this conditional to determine if we are doing delayed
+ * logging or not.
+ */
+int
+xlog_cil_init(
+	struct log	*log)
+{
+	struct xfs_cil	*cil;
+	struct xfs_cil_ctx *ctx;
+
+	log->l_cilp = NULL;
+	if (!(log->l_mp->m_flags & XFS_MOUNT_DELAYLOG))
+		return 0;
+
+	cil = kmem_zalloc(sizeof(*cil), KM_SLEEP|KM_MAYFAIL);
+	if (!cil)
+		return ENOMEM;
+
+	ctx = kmem_zalloc(sizeof(*ctx), KM_SLEEP|KM_MAYFAIL);
+	if (!ctx) {
+		kmem_free(cil);
+		return ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&cil->xc_cil);
+	INIT_LIST_HEAD(&cil->xc_committing);
+	spin_lock_init(&cil->xc_cil_lock);
+	init_rwsem(&cil->xc_ctx_lock);
+	sv_init(&cil->xc_commit_wait, SV_DEFAULT, "cilwait");
+
+	INIT_LIST_HEAD(&ctx->committing);
+	INIT_LIST_HEAD(&ctx->busy_extents);
+	ctx->sequence = 1;
+	ctx->cil = cil;
+	cil->xc_ctx = ctx;
+
+	cil->xc_log = log;
+	log->l_cilp = cil;
+	return 0;
+}
+
+void
+xlog_cil_destroy(
+	struct log	*log)
+{
+	if (!log->l_cilp)
+		return;
+
+	if (log->l_cilp->xc_ctx) {
+		if (log->l_cilp->xc_ctx->ticket)
+			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
+		kmem_free(log->l_cilp->xc_ctx);
+	}
+
+	ASSERT(list_empty(&log->l_cilp->xc_cil));
+	kmem_free(log->l_cilp);
+}
+
+/*
+ * Allocate a new ticket. Failing to get a new ticket makes it really hard to
+ * recover, so we don't allow failure here. Also, we allocate in a context that
+ * we don't want to be issuing transactions from, so we need to tell the
+ * allocation code this as well.
+ *
+ * We don't reserve any space for the ticket - we are going to steal whatever
+ * space we require from transactions as they commit. To ensure we reserve all
+ * the space required, we need to set the current reservation of the ticket to
+ * zero so that we know to steal the initial transaction overhead from the
+ * first transaction commit.
+ */
+static struct xlog_ticket *
+xlog_cil_ticket_alloc(
+	struct log	*log)
+{
+	struct xlog_ticket *tic;
+
+	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0,
+				KM_SLEEP|KM_NOFS);
+	tic->t_trans_type = XFS_TRANS_CHECKPOINT;
+
+	/*
+	 * set the current reservation to zero so we know to steal the basic
+	 * transaction overhead reservation from the first transaction commit.
+	 */
+	tic->t_curr_res = 0;
+	return tic;
+}
+
+/*
+ * After the first stage of log recovery is done, we know where the head and
+ * tail of the log are. We need this log initialisation done before we can
+ * initialise the first CIL checkpoint context.
+ *
+ * Here we allocate a log ticket to track space usage during a CIL push.  This
+ * ticket is passed to xlog_write() directly so that we don't slowly leak log
+ * space by failing to account for space used by log headers and additional
+ * region headers for split regions.
+ */
+int
+xlog_cil_init_post_recovery(
+	struct log	*log)
+{
+	if (!log->l_cilp)
+		return 0;
+
+	log->l_cilp->xc_ctx->ticket = xlog_cil_ticket_alloc(log);
+	log->l_cilp->xc_ctx->sequence = 1;
+	log->l_cilp->xc_ctx->commit_lsn = xlog_assign_lsn(log->l_curr_cycle,
+								log->l_curr_block);
+	return 0;
+}
+
+/*
+ * Insert the log item into the CIL and calculate the difference in space
+ * consumed by the item. Add the space to the checkpoint ticket and calculate
+ * if the change requires additional log metadata. If it does, take that space
+ * as well. Remove the amount of space we addded to the checkpoint ticket from
+ * the current transaction ticket so that the accounting works out correctly.
+ *
+ * If this is the first time the item is being placed into the CIL in this
+ * context, pin it so it can't be written to disk until the CIL is flushed to
+ * the iclog and the iclog written to disk.
+ */
+static void
+xlog_cil_insert(
+	struct log		*log,
+	struct xlog_ticket	*ticket,
+	struct xfs_log_item	*item,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_cil		*cil = log->l_cilp;
+	struct xfs_log_vec *old = lv->lv_item->li_lv;
+	struct xfs_cil_ctx *ctx = cil->xc_ctx;
+	int		len;
+	int		diff_iovecs;
+	int		iclog_space;
+
+	if (old) {
+		/* existing lv on log item, space used is a delta */
+		ASSERT(!list_empty(&item->li_cil));
+		ASSERT(old->lv_buf && old->lv_buf_len && old->lv_niovecs);
+
+		len = lv->lv_buf_len - old->lv_buf_len;
+		diff_iovecs = lv->lv_niovecs - old->lv_niovecs;
+		kmem_free(old->lv_buf);
+		kmem_free(old);
+	} else {
+		/* new lv, must pin the log item */
+		ASSERT(!lv->lv_item->li_lv);
+		ASSERT(list_empty(&item->li_cil));
+
+		len = lv->lv_buf_len;
+		diff_iovecs = lv->lv_niovecs;
+		IOP_PIN(lv->lv_item);
+
+	}
+	len += diff_iovecs * sizeof(xlog_op_header_t);
+
+	/* attach new log vector to log item */
+	lv->lv_item->li_lv = lv;
+
+	spin_lock(&cil->xc_cil_lock);
+	list_move_tail(&item->li_cil, &cil->xc_cil);
+	ctx->nvecs += diff_iovecs;
+
+	/*
+	 * Now transfer enough transaction reservation to the context ticket
+	 * for the checkpoint. The context ticket is special - the unit
+	 * reservation has to grow as well as the current reservation as we
+	 * steal from tickets so we can correctly determine the space used
+	 * during the transaction commit.
+	 */
+	if (ctx->ticket->t_curr_res == 0) {
+		/* first commit in checkpoint, steal the header reservation */
+		ASSERT(ticket->t_curr_res >= ctx->ticket->t_unit_res + len);
+		ctx->ticket->t_curr_res = ctx->ticket->t_unit_res;
+		ticket->t_curr_res -= ctx->ticket->t_unit_res;
+	}
+
+	/* do we need space for more log record headers? */
+	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
+	if (len > 0 && (ctx->space_used / iclog_space !=
+				(ctx->space_used + len) / iclog_space)) {
+		int hdrs;
+
+		hdrs = (len + iclog_space - 1) / iclog_space;
+		/* need to take into account split region headers, too */
+		hdrs *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
+		ctx->ticket->t_unit_res += hdrs;
+		ctx->ticket->t_curr_res += hdrs;
+		ticket->t_curr_res -= hdrs;
+		ASSERT(ticket->t_curr_res >= len);
+	}
+	ticket->t_curr_res -= len;
+	ctx->space_used += len;
+
+	spin_unlock(&cil->xc_cil_lock);
+}
+
+/*
+ * Format log item into a flat buffers
+ *
+ * For delayed logging, we need to hold a formatted buffer containing
+ * all the changes on the log item. This enables us to relog the item
+ * in memory and write it out asynchronously without needing to relock
+ * the object that was modified at the time it gets written into the
+ * iclog.
+ *
+ * This function works out the length of the buffer needed for each
+ * log item, allocates them and formats the the log vector for the item
+ * into the buffer. The buffer is then attached to the log item and the
+ * vector is formatted into the buffer. The log item and formatted log vector
+ * are then inserted into the Committed Item List for tracking until the
+ * next checkpoint is written out.
+ */
+static void
+xlog_cil_format_items(
+	struct log		*log,
+	struct xfs_log_vec	*log_vector,
+	struct xlog_ticket	*ticket,
+	xfs_lsn_t		*start_lsn)
+{
+	struct xfs_log_vec *lv;
+
+	if (start_lsn)
+		*start_lsn = log->l_cilp->xc_ctx->sequence;
+
+	/*
+	 * we don't set up region headers here; we simply copy the regions into
+	 * the flat buffer. We can do this because we still have to do a
+	 * formatting step to write the regions into the iclog buffer.  Writing
+	 * the ophdrs during the iclog write means that we can support
+	 * splitting large regions across iclog boundares without needing a
+	 * change in the format of the item/region encapsulation.
+	 *
+	 * Hence what we need to do now is change the vector buffer pointer to
+	 * point to the copied region inside the buffer we just allocated. This
+	 * allows us to format the regions into the iclog as though they are
+	 * being formatted directly out of the objects themselves.
+	 */
+	ASSERT(log_vector);
+	for (lv = log_vector; lv; lv = lv->lv_next) {
+		void	*ptr;
+		int	index;
+		int	offset = 0;
+		int	len = 0;
+
+		for (index = 0; index < lv->lv_niovecs; index++)
+			len += lv->lv_iovecp[index].i_len;
+
+		lv->lv_buf_len = len;
+		lv->lv_buf = kmem_zalloc(lv->lv_buf_len, KM_SLEEP|KM_NOFS);
+		ptr = lv->lv_buf;
+
+		for (index = 0; index < lv->lv_niovecs; index++) {
+			struct xfs_log_iovec *vec = &lv->lv_iovecp[index];
+
+			memcpy(ptr, vec->i_addr, vec->i_len);
+			vec->i_addr = ptr;
+			xlog_write_adv_cnt(&ptr, &len, &offset, vec->i_len);
+		}
+		ASSERT(len == 0);
+
+		xlog_cil_insert(log, ticket, lv->lv_item, lv);
+	}
+}
+
+static void
+xlog_cil_free_logvec(
+	struct xfs_log_vec	*log_vector)
+{
+	struct xfs_log_vec	*lv;
+
+	for (lv = log_vector; lv; ) {
+		struct xfs_log_vec *next = lv->lv_next;
+		kmem_free(lv->lv_buf);
+		kmem_free(lv);
+		lv = next;
+	}
+}
+
+/*
+ * Commit a transaction with the given vector to the Committed Item List.
+ *
+ * To do this, we need to format the item, pin it in memory if required and
+ * account for the space used by the transaction. Once we have done that we
+ * need to release the unused reservation for the transaction, attach the
+ * transaction to the checkpoint context so we carry the busy extents through
+ * to checkpoint completion, and then unlock all the items in the transaction.
+ *
+ * For more specific information about the order of operations in
+ * xfs_log_commit_cil() please refer to the comments in
+ * xfs_trans_commit_iclog().
+ */
+int
+xfs_log_commit_cil(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_log_vec	*log_vector,
+	xfs_lsn_t		*commit_lsn,
+	int			flags)
+{
+	struct log		*log = mp->m_log;
+	int			log_flags = 0;
+
+	if (flags & XFS_TRANS_RELEASE_LOG_RES)
+		log_flags = XFS_LOG_REL_PERM_RESERV;
+
+	if (XLOG_FORCED_SHUTDOWN(log)) {
+		xlog_cil_free_logvec(log_vector);
+		return XFS_ERROR(EIO);
+	}
+
+	/* lock out background commit */
+	down_read(&log->l_cilp->xc_ctx_lock);
+	xlog_cil_format_items(log, log_vector, tp->t_ticket, commit_lsn);
+
+	/* check we didn't blow the reservation */
+	if (tp->t_ticket->t_curr_res < 0)
+		xlog_print_tic_res(log->l_mp, tp->t_ticket);
+
+	/* attach the transaction to the CIL if it has any busy extents */
+	if (!list_empty(&tp->t_busy)) {
+		spin_lock(&log->l_cilp->xc_cil_lock);
+		list_splice_init(&tp->t_busy,
+					&log->l_cilp->xc_ctx->busy_extents);
+		spin_unlock(&log->l_cilp->xc_cil_lock);
+	}
+
+	tp->t_commit_lsn = *commit_lsn;
+	xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
+	xfs_trans_unreserve_and_mod_sb(tp);
+
+	/* background commit is allowed again */
+	up_read(&log->l_cilp->xc_ctx_lock);
+	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
+
+	/* xfs_trans_free_items() unlocks them first */
+	xfs_trans_free_items(tp, *commit_lsn, 0);
+	xfs_trans_free(tp);
+	return 0;
+}
+
+/*
+ * Mark all items committed and clear busy extents. We free the log vector
+ * chains in a separate pass so that we unpin the log items as quickly as
+ * possible.
+ */
+static void
+xlog_cil_committed(
+	void	*args,
+	int	abort)
+{
+	struct xfs_cil_ctx	*ctx = args;
+	struct xfs_log_vec	*lv;
+	int			abortflag = abort ? XFS_LI_ABORTED : 0;
+	struct xfs_busy_extent	*busyp, *n;
+
+	/* unpin all the log items */
+	for (lv = ctx->lv_chain; lv; lv = lv->lv_next ) {
+		xfs_trans_item_committed(lv->lv_item, ctx->start_lsn,
+							abortflag);
+	}
+
+	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list)
+		xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, busyp);
+
+	spin_lock(&ctx->cil->xc_cil_lock);
+	list_del(&ctx->committing);
+	spin_unlock(&ctx->cil->xc_cil_lock);
+
+	xlog_cil_free_logvec(ctx->lv_chain);
+	kmem_free(ctx);
+}
+
+/*
+ * Push the Committed Item List to the log. If the push_now flag is not set,
+ * then it is a background flush and so we can chose to ignore it.
+ */
+int
+xlog_cil_push(
+	struct log	*log,
+	int		push_now)
+{
+	struct xfs_cil		*cil = log->l_cilp;
+	struct xfs_log_vec	*lv;
+	struct xfs_cil_ctx	*ctx;
+	struct xfs_cil_ctx	*new_ctx;
+	struct xlog_in_core	*commit_iclog;
+	struct xlog_ticket	*tic;
+	int			num_lv;
+	int			num_iovecs;
+	int			len;
+	int			error = 0;
+	struct xfs_trans_header thdr;
+	struct xfs_log_iovec	lhdr;
+	struct xfs_log_vec	lvhdr = { NULL };
+	xfs_lsn_t		commit_lsn;
+
+	if (!cil)
+		return 0;
+
+	/* XXX: don't sleep for background? */
+	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_SLEEP|KM_NOFS);
+	new_ctx->ticket = xlog_cil_ticket_alloc(log);
+
+	/* lock out transaction commit */
+	down_write(&cil->xc_ctx_lock);
+	ctx = cil->xc_ctx;
+
+	/* check if we've anything to push */
+	if (list_empty(&cil->xc_cil)) {
+		up_write(&cil->xc_ctx_lock);
+		xfs_log_ticket_put(new_ctx->ticket);
+		kmem_free(new_ctx);
+		return 0;
+	}
+
+	/*
+	 * pull all the log vectors off the items in the CIL, and
+	 * remove the items from the CIL. We don't need the CIL lock
+	 * here because it's only needed on the transaction commit
+	 * side which is currently locked out by the flush lock.
+	 */
+	lv = NULL;
+	num_lv = 0;
+	num_iovecs = 0;
+	len = 0;
+	while (!list_empty(&cil->xc_cil)) {
+		struct xfs_log_item	*item;
+		int			i;
+
+		item = list_first_entry(&cil->xc_cil,
+					struct xfs_log_item, li_cil);
+		list_del_init(&item->li_cil);
+		if (!ctx->lv_chain)
+			ctx->lv_chain = item->li_lv;
+		else
+			lv->lv_next = item->li_lv;
+		lv = item->li_lv;
+		item->li_lv = NULL;
+
+		num_lv++;
+		num_iovecs += lv->lv_niovecs;
+		for (i = 0; i < lv->lv_niovecs; i++)
+			len += lv->lv_iovecp[i].i_len;
+	}
+
+	/*
+	 * initialise the new context and attach it to the CIL. Then attach
+	 * the current context to the CIL committing lsit so it can be found
+	 * during log forces to extract the commit lsn of the sequence that
+	 * needs to be forced.
+	 */
+	INIT_LIST_HEAD(&new_ctx->committing);
+	INIT_LIST_HEAD(&new_ctx->busy_extents);
+	new_ctx->sequence = ctx->sequence + 1;
+	new_ctx->cil = cil;
+	cil->xc_ctx = new_ctx;
+
+	/*
+	 * The switch is now done, so we can drop the context lock and move out
+	 * of a shared context. We can't just go straight to the commit record,
+	 * though - we need to synchronise with previous and future commits so
+	 * that the commit records are correctly ordered in the log to ensure
+	 * that we process items during log IO completion in the correct order.
+	 *
+	 * For example, if we get an EFI in one checkpoint and the EFD in the
+	 * next (e.g. due to log forces), we do not want the checkpoint with
+	 * the EFD to be committed before the checkpoint with the EFI.  Hence
+	 * we must strictly order the commit records of the checkpoints so
+	 * that: a) the checkpoint callbacks are attached to the iclogs in the
+	 * correct order; and b) the checkpoints are replayed in correct order
+	 * in log recovery.
+	 *
+	 * Hence we need to add this context to the committing context list so
+	 * that higher sequences will wait for us to write out a commit record
+	 * before they do.
+	 */
+	spin_lock(&cil->xc_cil_lock);
+	list_add(&ctx->committing, &cil->xc_committing);
+	spin_unlock(&cil->xc_cil_lock);
+	up_write(&cil->xc_ctx_lock);
+
+	/*
+	 * Build a checkpoint transaction header and write it to the log to
+	 * begin the transaction. We need to account for the space used by the
+	 * transaction header here as it is not accounted for in xlog_write().
+	 *
+	 * The LSN we need to pass to the log items on transaction commit is
+	 * the LSN reported by the first log vector write. If we use the commit
+	 * record lsn then we can move the tail beyond the grant write head.
+	 */
+	tic = ctx->ticket;
+	thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
+	thdr.th_type = XFS_TRANS_CHECKPOINT;
+	thdr.th_tid = tic->t_tid;
+	thdr.th_num_items = num_iovecs;
+	lhdr.i_addr = (xfs_caddr_t)&thdr;
+	lhdr.i_len = sizeof(xfs_trans_header_t);
+	lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
+	tic->t_curr_res -= lhdr.i_len + sizeof(xlog_op_header_t);
+
+	lvhdr.lv_niovecs = 1;
+	lvhdr.lv_iovecp = &lhdr;
+	lvhdr.lv_next = ctx->lv_chain;
+
+	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0);
+	if (error)
+		goto out_abort;
+
+	/*
+	 * now that we've written the checkpoint into the log, strictly
+	 * order the commit records so replay will get them in the right order.
+	 */
+restart:
+	spin_lock(&cil->xc_cil_lock);
+	list_for_each_entry(new_ctx, &cil->xc_committing, committing) {
+		/*
+		 * Higher sequences will wait for this one so skip them.
+		 * Don't wait for own own sequence, either.
+		 */
+		if (new_ctx->sequence >= ctx->sequence)
+			continue;
+		if (!new_ctx->commit_lsn) {
+			/*
+			 * It is still being pushed! Wait for the push to
+			 * complete, then start again from the beginning.
+			 */
+			sv_wait(&cil->xc_commit_wait, 0, &cil->xc_cil_lock, 0);
+			goto restart;
+		}
+	}
+	spin_unlock(&cil->xc_cil_lock);
+
+	commit_lsn = xfs_log_done(log->l_mp, tic, &commit_iclog, 0);
+	if (error || commit_lsn == -1)
+		goto out_abort;
+
+	/* attach all the transactions w/ busy extents to iclog */
+	ctx->log_cb.cb_func = xlog_cil_committed;
+	ctx->log_cb.cb_arg = ctx;
+	error = xfs_log_notify(log->l_mp, commit_iclog, &ctx->log_cb);
+	if (error)
+		goto out_abort;
+
+	/*
+	 * now the checkpoint commit is complete and we've attached the
+	 * callbacks to the iclog we can assign the commit LSN to the context
+	 * and wake up anyone who is waiting for the commit to complete.
+	 */
+	spin_lock(&cil->xc_cil_lock);
+	ctx->commit_lsn = commit_lsn;
+	sv_broadcast(&cil->xc_commit_wait);
+	spin_unlock(&cil->xc_cil_lock);
+
+	/* release the hounds! */
+	return xfs_log_release_iclog(log->l_mp, commit_iclog);
+
+out_abort:
+	xlog_cil_committed(ctx, XFS_LI_ABORTED);
+	return XFS_ERROR(EIO);
+}
+
+/*
+ * Conditionally push the CIL based on the sequence passed in.
+ *
+ * We only need to push if we haven't already pushed the sequence
+ * number given. Hence the only time we will trigger a push here is
+ * if the push sequence is the same as the current context.
+ *
+ * We return the current commit lsn to allow the callers to determine if a
+ * iclog flush is necessary following this call.
+ *
+ * XXX: Initially, just push the CIL unconditionally and return whatever
+ * commit lsn is there. It'll be empty, so this is broken for now.
+ */
+xfs_lsn_t
+xlog_cil_push_lsn(
+	struct log	*log,
+	xfs_lsn_t	push_seq)
+{
+	struct xfs_cil		*cil = log->l_cilp;
+	struct xfs_cil_ctx	*ctx;
+	xfs_lsn_t		commit_lsn = NULLCOMMITLSN;
+
+restart:
+	down_write(&cil->xc_ctx_lock);
+	ASSERT(push_seq <= cil->xc_ctx->sequence);
+
+	/* check to see if we need to force out the current context */
+	if (push_seq == cil->xc_ctx->sequence) {
+		up_write(&cil->xc_ctx_lock);
+		xlog_cil_push(log, 1);
+		goto restart;
+	}
+
+	/*
+	 * See if we can find a previous sequence still committing.
+	 * We can drop the flush lock as soon as we have the cil lock
+	 * because we are now only comparing contexts protected by
+	 * the cil lock.
+	 *
+	 * We need to wait for all previous sequence commits to complete
+	 * before allowing the force of push_seq to go ahead. Hence block
+	 * on commits for those as well.
+	 */
+	spin_lock(&cil->xc_cil_lock);
+	up_write(&cil->xc_ctx_lock);
+	list_for_each_entry(ctx, &cil->xc_committing, committing) {
+		if (ctx->sequence > push_seq)
+			continue;
+		if (!ctx->commit_lsn) {
+			/*
+			 * It is still being pushed! Wait for the push to
+			 * complete, then start again from the beginning.
+			 */
+			sv_wait(&cil->xc_commit_wait, 0, &cil->xc_cil_lock, 0);
+			goto restart;
+		}
+		if (ctx->sequence != push_seq)
+			continue;
+		/* found it! */
+		commit_lsn = ctx->commit_lsn;
+	}
+	spin_unlock(&cil->xc_cil_lock);
+	return commit_lsn;
+}
+
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 9cf6951..e9e8324 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -379,6 +379,54 @@ typedef struct xlog_in_core {
 } xlog_in_core_t;
 
 /*
+ * The CIL context is used to aggregate per-transaction details as well be
+ * passed to the iclog for checkpoint post-commit processing.  After being
+ * passed to the iclog, another context needs to be allocated for tracking the
+ * next set of transactions to be aggregated into a checkpoint.
+ */
+struct xfs_cil;
+
+struct xfs_cil_ctx {
+	struct xfs_cil		*cil;
+	xfs_lsn_t		sequence;	/* chkpt sequence # */
+	xfs_lsn_t		start_lsn;	/* first LSN of chkpt commit */
+	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
+	struct xlog_ticket	*ticket;	/* chkpt ticket */
+	int			nvecs;		/* number of regions */
+	int			space_used;	/* aggregate size of regions */
+	struct list_head	busy_extents;	/* busy extents in chkpt */
+	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
+	xfs_log_callback_t	log_cb;		/* completion callback hook. */
+	struct list_head	committing;	/* ctx committing list */
+};
+
+/*
+ * Committed Item List structure
+ *
+ * This structure is used to track log items that have been committed but not
+ * yet written into the log. It is used only when the delayed logging mount
+ * option is enabled.
+ *
+ * This structure tracks the list of committing checkpoint contexts so
+ * we can avoid the problem of having to hold out new transactions during a
+ * flush until we have a the commit record LSN of the checkpoint. We can
+ * traverse the list of committing contexts in xlog_cil_push_lsn() to find a
+ * sequence match and extract the commit LSN directly from there. If the
+ * checkpoint is still in the process of committing, we can block waiting for
+ * the commit LSN to be determined as well. This should make synchronous
+ * operations almost as efficient as the old logging methods.
+ */
+struct xfs_cil {
+	struct log		*xc_log;
+	struct list_head	xc_cil;
+	spinlock_t		xc_cil_lock;
+	struct xfs_cil_ctx	*xc_ctx;
+	struct rw_semaphore	xc_ctx_lock;
+	struct list_head	xc_committing;
+	sv_t			xc_commit_wait;
+};
+
+/*
  * The reservation head lsn is not made up of a cycle number and block number.
  * Instead, it uses a cycle number and byte number.  Logs don't expect to
  * overflow 31 bits worth of byte offset, so using a byte number will mean
@@ -388,6 +436,7 @@ typedef struct log {
 	/* The following fields don't need locking */
 	struct xfs_mount	*l_mp;	        /* mount point */
 	struct xfs_ail		*l_ailp;	/* AIL log is working with */
+	struct xfs_cil		*l_cilp;	/* CIL log is working with */
 	struct xfs_buf		*l_xbuf;        /* extra buffer for log
 						 * wrapping */
 	struct xfs_buftarg	*l_targ;        /* buftarg of log */
@@ -438,14 +487,17 @@ typedef struct log {
 
 #define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
 
-
 /* common routines */
 extern xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
 extern int	 xlog_recover(xlog_t *log);
 extern int	 xlog_recover_finish(xlog_t *log);
 extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
 
-extern kmem_zone_t	*xfs_log_ticket_zone;
+extern kmem_zone_t *xfs_log_ticket_zone;
+struct xlog_ticket *xlog_ticket_alloc(struct log *log, int unit_bytes,
+				int count, char client, uint xflags,
+				int alloc_flags);
+
 
 static inline void
 xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
@@ -455,6 +507,21 @@ xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
 	*off += bytes;
 }
 
+void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
+int	xlog_write(struct log *log, struct xfs_log_vec *log_vector,
+				struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
+				xlog_in_core_t **commit_iclog, uint flags);
+
+/*
+ * Committed Item List interfaces
+ */
+int	xlog_cil_init(struct log *log);
+int	xlog_cil_init_post_recovery(struct log *log);
+void	xlog_cil_destroy(struct log *log);
+
+int	xlog_cil_push(struct log *log, int push_now);
+xfs_lsn_t xlog_cil_push_lsn(struct log *log, xfs_lsn_t push_sequence);
+
 /*
  * Unmount record type is used as a pseudo transaction type for the ticket.
  * It's value must be outside the range of XFS_TRANS_* values.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9ff48a1..1d2c7ee 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -268,6 +268,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
 						   must be synchronous except
 						   for space allocations */
+#define XFS_MOUNT_DELAYLOG	(1ULL << 1)	/* delayed logging is enabled */
 #define XFS_MOUNT_DMAPI		(1ULL << 2)	/* dmapi is enabled */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 40d9595..9bdb492 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -253,7 +253,7 @@ _xfs_trans_alloc(
  * Free the transaction structure.  If there is more clean up
  * to do when the structure is freed, add it here.
  */
-STATIC void
+void
 xfs_trans_free(
 	struct xfs_trans	*tp)
 {
@@ -655,7 +655,7 @@ xfs_trans_apply_sb_deltas(
  * XFS_TRANS_SB_DIRTY will not be set when the transaction is updated but we
  * still need to update the incore superblock with the changes.
  */
-STATIC void
+void
 xfs_trans_unreserve_and_mod_sb(
 	xfs_trans_t	*tp)
 {
@@ -883,7 +883,7 @@ xfs_trans_fill_vecs(
  * they could be immediately flushed and we'd have to race with the flusher
  * trying to pull the item from the AIL as we add it.
  */
-static void
+void
 xfs_trans_item_committed(
 	struct xfs_log_item	*lip,
 	xfs_lsn_t		commit_lsn,
@@ -994,7 +994,7 @@ xfs_trans_uncommit(
 	xfs_trans_unreserve_and_mod_sb(tp);
 	xfs_trans_unreserve_and_mod_dquots(tp);
 
-	xfs_trans_free_items(tp, flags);
+	xfs_trans_free_items(tp, NULLCOMMITLSN, flags);
 	xfs_trans_free(tp);
 }
 
@@ -1144,6 +1144,132 @@ xfs_trans_commit_iclog(
 	return xfs_log_release_iclog(mp, commit_iclog);
 }
 
+/*
+ * Walk the log items and allocate log vector structures for
+ * each item large enough to fit all the vectors they require.
+ * Note that this format differs from the old log vector format in
+ * that there is no transaction header in these log vectors.
+ */
+STATIC struct xfs_log_vec *
+xfs_trans_alloc_log_vecs(
+	xfs_trans_t	*tp)
+{
+	xfs_log_item_desc_t	*lidp;
+	struct xfs_log_vec	*lv = NULL;
+	struct xfs_log_vec	*ret_lv = NULL;
+
+	lidp = xfs_trans_first_item(tp);
+
+	/* Bail out if we didn't find a log item.  */
+	if (!lidp) {
+		ASSERT(0);
+		return NULL;
+	}
+
+	while (lidp != NULL) {
+		struct xfs_log_vec *new_lv;
+
+		/* Skip items which aren't dirty in this transaction. */
+		if (!(lidp->lid_flags & XFS_LID_DIRTY)) {
+			lidp = xfs_trans_next_item(tp, lidp);
+			continue;
+		}
+
+		/* Skip items that do not have any vectors for writing */
+		lidp->lid_size = IOP_SIZE(lidp->lid_item);
+		if (!lidp->lid_size) {
+			lidp = xfs_trans_next_item(tp, lidp);
+			continue;
+		}
+
+		new_lv = kmem_zalloc(sizeof(*new_lv) +
+				lidp->lid_size * sizeof(struct xfs_log_iovec),
+				KM_SLEEP);
+
+		/* The allocated iovec region lies beyond the log vector. */
+		new_lv->lv_iovecp = (struct xfs_log_iovec *)&new_lv[1];
+		if (!ret_lv)
+			ret_lv = new_lv;
+		else
+			lv->lv_next = new_lv;
+		lv = new_lv;
+		lidp = xfs_trans_next_item(tp, lidp);
+	}
+
+	return ret_lv;
+}
+
+/*
+ * Fill in the vector with pointers to data to be logged
+ * by this transaction.
+ * Each dirty item takes the
+ * number of vectors it indicated it needed in xfs_trans_alloc_log_vecs().
+ * There is no transaction header in this format.
+ *
+ * We do not pin the items here as they are formatted, we leave that to
+ * the CIL commit. This is done because the pinning of the item is
+ * conditional on whether the item is already pinned in the CIL. Hence
+ * the check and pin must be done under the protection of the flush lock.
+ */
+STATIC void
+xfs_trans_fill_log_vecs(
+	struct xfs_trans	*tp,
+	struct xfs_log_vec	*log_vector)
+{
+	xfs_log_item_desc_t	*lidp;
+	struct xfs_log_vec	*lv = log_vector;
+
+	lidp = xfs_trans_first_item(tp);
+	ASSERT(lidp);
+	while (lidp) {
+		/*
+		 * Skip items which aren't dirty in this transaction.
+		 */
+		if (!(lidp->lid_flags & XFS_LID_DIRTY)) {
+			lidp = xfs_trans_next_item(tp, lidp);
+			continue;
+		}
+		/* Skip items that do not have any vectors for writing */
+		if (!lidp->lid_size) {
+			lidp = xfs_trans_next_item(tp, lidp);
+			continue;
+		}
+		IOP_FORMAT(lidp->lid_item, lv->lv_iovecp);
+		lv->lv_niovecs = lidp->lid_size;
+		lv->lv_item = lidp->lid_item;
+
+		lidp = xfs_trans_next_item(tp, lidp);
+		lv = lv->lv_next;
+	}
+}
+
+static int
+xfs_trans_commit_cil(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_lsn_t		*commit_lsn,
+	int			flags)
+{
+	struct xfs_log_vec	*log_vector;
+
+	/*
+	 * Get each log item to allocate a vector structure for
+	 * the log item to to pass to the log write code.
+	 */
+	log_vector = xfs_trans_alloc_log_vecs(tp);
+	if (!log_vector)
+		return ENOMEM;
+
+	/*
+	 * Fill in the log_vector and pin the logged items, and
+	 * then write the transaction to the log. We have to lock
+	 * out CIL flushes from this point as we are going to pin
+	 */
+	xfs_trans_fill_log_vecs(tp, log_vector);
+
+	return xfs_log_commit_cil(mp, tp, log_vector, commit_lsn, flags);
+
+}
 
 /*
  * xfs_trans_commit
@@ -1204,7 +1330,11 @@ _xfs_trans_commit(
 		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
 
-	error = xfs_trans_commit_iclog(mp, tp, &commit_lsn, flags);
+	if (mp->m_flags & XFS_MOUNT_DELAYLOG)
+		error = xfs_trans_commit_cil(mp, tp, &commit_lsn, flags);
+	else
+		error = xfs_trans_commit_iclog(mp, tp, &commit_lsn, flags);
+
 	if (error == ENOMEM) {
 		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 		error = XFS_ERROR(EIO);
@@ -1242,7 +1372,7 @@ out_unreserve:
 			error = XFS_ERROR(EIO);
 	}
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
-	xfs_trans_free_items(tp, error ? XFS_TRANS_ABORT : 0);
+	xfs_trans_free_items(tp, NULLCOMMITLSN, error ? XFS_TRANS_ABORT : 0);
 	xfs_trans_free(tp);
 
 	XFS_STATS_INC(xs_trans_empty);
@@ -1320,7 +1450,7 @@ xfs_trans_cancel(
 	/* mark this thread as no longer being in a transaction */
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 
-	xfs_trans_free_items(tp, flags);
+	xfs_trans_free_items(tp, NULLCOMMITLSN, flags);
 	xfs_trans_free(tp);
 }
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index ff7e9e6..b1ea20c 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -106,7 +106,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_GROWFSRT_FREE		39
 #define	XFS_TRANS_SWAPEXT		40
 #define	XFS_TRANS_SB_COUNT		41
-#define	XFS_TRANS_TYPE_MAX		41
+#define	XFS_TRANS_CHECKPOINT		42
+#define	XFS_TRANS_TYPE_MAX		42
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 #define XFS_TRANS_TYPES \
@@ -148,6 +149,7 @@ typedef struct xfs_trans_header {
 	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
 	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
 	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
+	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
 	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
 	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
 	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
@@ -829,6 +831,10 @@ typedef struct xfs_log_item {
 							/* buffer item iodone */
 							/* callback func */
 	struct xfs_item_ops		*li_ops;	/* function list */
+
+	/* delayed logging */
+	struct list_head		li_cil;		/* CIL pointers */
+	struct xfs_log_vec		*li_lv;		/* active log vector */
 } xfs_log_item_t;
 
 #define	XFS_LI_IN_AIL	0x1
diff --git a/fs/xfs/xfs_trans_item.c b/fs/xfs/xfs_trans_item.c
index 2937a1e..f11d37d 100644
--- a/fs/xfs/xfs_trans_item.c
+++ b/fs/xfs/xfs_trans_item.c
@@ -299,6 +299,7 @@ xfs_trans_next_item(xfs_trans_t *tp, xfs_log_item_desc_t *lidp)
 void
 xfs_trans_free_items(
 	xfs_trans_t	*tp,
+	xfs_lsn_t	commit_lsn,
 	int		flags)
 {
 	xfs_log_item_chunk_t	*licp;
@@ -311,7 +312,7 @@ xfs_trans_free_items(
 	 * Special case the embedded chunk so we don't free it below.
 	 */
 	if (!xfs_lic_are_all_free(licp)) {
-		(void) xfs_trans_unlock_chunk(licp, 1, abort, NULLCOMMITLSN);
+		(void) xfs_trans_unlock_chunk(licp, 1, abort, commit_lsn);
 		xfs_lic_all_free(licp);
 		licp->lic_unused = 0;
 	}
@@ -322,7 +323,7 @@ xfs_trans_free_items(
 	 */
 	while (licp != NULL) {
 		ASSERT(!xfs_lic_are_all_free(licp));
-		(void) xfs_trans_unlock_chunk(licp, 1, abort, NULLCOMMITLSN);
+		(void) xfs_trans_unlock_chunk(licp, 1, abort, commit_lsn);
 		next_licp = licp->lic_next;
 		kmem_free(licp);
 		licp = next_licp;
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 901dc0f..330fa5f 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -35,9 +35,15 @@ struct xfs_log_item_desc	*xfs_trans_find_item(struct xfs_trans *,
 struct xfs_log_item_desc	*xfs_trans_first_item(struct xfs_trans *);
 struct xfs_log_item_desc	*xfs_trans_next_item(struct xfs_trans *,
 					     struct xfs_log_item_desc *);
-void				xfs_trans_free_items(struct xfs_trans *, int);
-void				xfs_trans_unlock_items(struct xfs_trans *,
-							xfs_lsn_t);
+
+void	xfs_trans_unlock_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn);
+void	xfs_trans_free_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn,
+				int flags);
+
+void	xfs_trans_item_committed(struct xfs_log_item *lip,
+				xfs_lsn_t commit_lsn, int aborted);
+void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
+void	xfs_trans_free(struct xfs_trans *tp);
 
 /*
  * AIL traversal cursor.
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
