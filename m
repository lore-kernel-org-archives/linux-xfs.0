Return-Path: <xfs-bounces@oss.sgi.com>
Received: from tinguely (eagdhcp-232-130.americas.sgi.com [128.162.232.130])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5EGd60D002884 for <xfs@oss.sgi.com>; Thu, 14 Jun 2012 11:39:06 -0500
Received: from tinguely (localhost [127.0.0.1])
	by tinguely (8.14.5/8.14.5) with ESMTP id q5EGd6NV002858
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2012 11:39:06 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Received: (from tinguely@localhost)
	by tinguely (8.14.5/8.14.5/Submit) id q5EGd6B1002857
	for xfs@oss.sgi.com; Thu, 14 Jun 2012 11:39:06 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20120614142430.963813265@sgi.com>
Date: Thu, 14 Jun 2012 09:22:15 -0500
From: tinguely@sgi.com
Subject: [PATCH 1/2 v2] xfs: rename log structure and remove xlog_t typedef.
References: <20120614142214.445982138@sgi.com>
Content-Disposition: inline;
	filename=1-2-xfs-rename-struct-log-to-xlog-v2.patch
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

From: Mark Tinguely <tinguely@sgi.com>

Rename the XFS log structure to xlog to help crash distinquish it from the
other logs in Linux.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>

---
 fs/xfs/xfs_log.c         |   76 +++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_log_cil.c     |   22 ++++++-------
 fs/xfs/xfs_log_priv.h    |   46 +++++++++++++++++++---------
 fs/xfs/xfs_log_recover.c |   38 +++++++++++------------
 fs/xfs/xfs_mount.h       |    4 +-
 fs/xfs/xfs_trace.h       |   18 +++++------
 6 files changed, 116 insertions(+), 88 deletions(-)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -38,13 +38,21 @@
 kmem_zone_t	*xfs_log_ticket_zone;
 
 /* Local miscellaneous function prototypes */
-STATIC int	 xlog_commit_record(struct log *log, struct xlog_ticket *ticket,
-				    xlog_in_core_t **, xfs_lsn_t *);
+STATIC int
+xlog_commit_record(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket,
+	struct xlog_in_core	**iclog,
+	xfs_lsn_t		*commitlsnp);
+
 STATIC xlog_t *  xlog_alloc_log(xfs_mount_t	*mp,
 				xfs_buftarg_t	*log_target,
 				xfs_daddr_t	blk_offset,
 				int		num_bblks);
-STATIC int	 xlog_space_left(struct log *log, atomic64_t *head);
+STATIC int
+xlog_space_left(
+	struct xlog		*log,
+	atomic64_t		*head);
 STATIC int	 xlog_sync(xlog_t *log, xlog_in_core_t *iclog);
 STATIC void	 xlog_dealloc_log(xlog_t *log);
 
@@ -64,8 +72,10 @@ STATIC void xlog_state_switch_iclogs(xlo
 				     int		eventual_size);
 STATIC void xlog_state_want_sync(xlog_t	*log, xlog_in_core_t *iclog);
 
-STATIC void xlog_grant_push_ail(struct log	*log,
-				int		need_bytes);
+STATIC void
+xlog_grant_push_ail(
+	struct xlog	*log,
+	int		need_bytes);
 STATIC void xlog_regrant_reserve_log_space(xlog_t	 *log,
 					   xlog_ticket_t *ticket);
 STATIC void xlog_ungrant_log_space(xlog_t	 *log,
@@ -73,7 +83,9 @@ STATIC void xlog_ungrant_log_space(xlog_
 
 #if defined(DEBUG)
 STATIC void	xlog_verify_dest_ptr(xlog_t *log, char *ptr);
-STATIC void	xlog_verify_grant_tail(struct log *log);
+STATIC void
+xlog_verify_grant_tail(
+	struct xlog	*log);
 STATIC void	xlog_verify_iclog(xlog_t *log, xlog_in_core_t *iclog,
 				  int count, boolean_t syncing);
 STATIC void	xlog_verify_tail_lsn(xlog_t *log, xlog_in_core_t *iclog,
@@ -89,9 +101,9 @@ STATIC int	xlog_iclogs_empty(xlog_t *log
 
 static void
 xlog_grant_sub_space(
-	struct log	*log,
-	atomic64_t	*head,
-	int		bytes)
+	struct xlog		*log,
+	atomic64_t		*head,
+	int			bytes)
 {
 	int64_t	head_val = atomic64_read(head);
 	int64_t new, old;
@@ -115,9 +127,9 @@ xlog_grant_sub_space(
 
 static void
 xlog_grant_add_space(
-	struct log	*log,
-	atomic64_t	*head,
-	int		bytes)
+	struct xlog		*log,
+	atomic64_t		*head,
+	int			bytes)
 {
 	int64_t	head_val = atomic64_read(head);
 	int64_t new, old;
@@ -165,7 +177,7 @@ xlog_grant_head_wake_all(
 
 static inline int
 xlog_ticket_reservation(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_grant_head	*head,
 	struct xlog_ticket	*tic)
 {
@@ -182,7 +194,7 @@ xlog_ticket_reservation(
 
 STATIC bool
 xlog_grant_head_wake(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_grant_head	*head,
 	int			*free_bytes)
 {
@@ -204,7 +216,7 @@ xlog_grant_head_wake(
 
 STATIC int
 xlog_grant_head_wait(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_grant_head	*head,
 	struct xlog_ticket	*tic,
 	int			need_bytes)
@@ -256,7 +268,7 @@ shutdown:
  */
 STATIC int
 xlog_grant_head_check(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_grant_head	*head,
 	struct xlog_ticket	*tic,
 	int			*need_bytes)
@@ -323,7 +335,7 @@ xfs_log_regrant(
 	struct xfs_mount	*mp,
 	struct xlog_ticket	*tic)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	int			need_bytes;
 	int			error = 0;
 
@@ -389,7 +401,7 @@ xfs_log_reserve(
 	bool			permanent,
 	uint		 	t_type)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	struct xlog_ticket	*tic;
 	int			need_bytes;
 	int			error = 0;
@@ -465,7 +477,7 @@ xfs_log_done(
 	struct xlog_in_core	**iclog,
 	uint			flags)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	xfs_lsn_t		lsn = 0;
 
 	if (XLOG_FORCED_SHUTDOWN(log) ||
@@ -838,7 +850,7 @@ void
 xfs_log_space_wake(
 	struct xfs_mount	*mp)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	int			free_bytes;
 
 	if (XLOG_FORCED_SHUTDOWN(log))
@@ -916,7 +928,7 @@ xfs_lsn_t
 xlog_assign_tail_lsn_locked(
 	struct xfs_mount	*mp)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	struct xfs_log_item	*lip;
 	xfs_lsn_t		tail_lsn;
 
@@ -965,7 +977,7 @@ xlog_assign_tail_lsn(
  */
 STATIC int
 xlog_space_left(
-	struct log	*log,
+	struct xlog	*log,
 	atomic64_t	*head)
 {
 	int		free_bytes;
@@ -1277,7 +1289,7 @@ out:
  */
 STATIC int
 xlog_commit_record(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	**iclog,
 	xfs_lsn_t		*commitlsnp)
@@ -1311,7 +1323,7 @@ xlog_commit_record(
  */
 STATIC void
 xlog_grant_push_ail(
-	struct log	*log,
+	struct xlog	*log,
 	int		need_bytes)
 {
 	xfs_lsn_t	threshold_lsn = 0;
@@ -1790,7 +1802,7 @@ xlog_write_start_rec(
 
 static xlog_op_header_t *
 xlog_write_setup_ophdr(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_op_header	*ophdr,
 	struct xlog_ticket	*ticket,
 	uint			flags)
@@ -1873,7 +1885,7 @@ xlog_write_setup_copy(
 
 static int
 xlog_write_copy_finish(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_in_core	*iclog,
 	uint			flags,
 	int			*record_cnt,
@@ -1958,7 +1970,7 @@ xlog_write_copy_finish(
  */
 int
 xlog_write(
-	struct log		*log,
+	struct xlog		*log,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*start_lsn,
@@ -2821,7 +2833,7 @@ _xfs_log_force(
 	uint			flags,
 	int			*log_flushed)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	struct xlog_in_core	*iclog;
 	xfs_lsn_t		lsn;
 
@@ -2969,7 +2981,7 @@ _xfs_log_force_lsn(
 	uint			flags,
 	int			*log_flushed)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	struct xlog_in_core	*iclog;
 	int			already_slept = 0;
 
@@ -3147,7 +3159,7 @@ xfs_log_ticket_get(
  */
 xlog_ticket_t *
 xlog_ticket_alloc(
-	struct log	*log,
+	struct xlog	*log,
 	int		unit_bytes,
 	int		cnt,
 	char		client,
@@ -3278,7 +3290,7 @@ xlog_ticket_alloc(
  */
 void
 xlog_verify_dest_ptr(
-	struct log	*log,
+	struct xlog	*log,
 	char		*ptr)
 {
 	int i;
@@ -3307,7 +3319,7 @@ xlog_verify_dest_ptr(
  */
 STATIC void
 xlog_verify_grant_tail(
-	struct log	*log)
+	struct xlog	*log)
 {
 	int		tail_cycle, tail_blocks;
 	int		cycle, space;
Index: b/fs/xfs/xfs_log_cil.c
===================================================================
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -44,7 +44,7 @@
  */
 static struct xlog_ticket *
 xlog_cil_ticket_alloc(
-	struct log	*log)
+	struct xlog	*log)
 {
 	struct xlog_ticket *tic;
 
@@ -72,7 +72,7 @@ xlog_cil_ticket_alloc(
  */
 void
 xlog_cil_init_post_recovery(
-	struct log	*log)
+	struct xlog	*log)
 {
 	log->l_cilp->xc_ctx->ticket = xlog_cil_ticket_alloc(log);
 	log->l_cilp->xc_ctx->sequence = 1;
@@ -182,7 +182,7 @@ xlog_cil_prepare_log_vecs(
  */
 STATIC void
 xfs_cil_prepare_item(
-	struct log		*log,
+	struct xlog		*log,
 	struct xfs_log_vec	*lv,
 	int			*len,
 	int			*diff_iovecs)
@@ -231,7 +231,7 @@ xfs_cil_prepare_item(
  */
 static void
 xlog_cil_insert_items(
-	struct log		*log,
+	struct xlog		*log,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket)
 {
@@ -373,7 +373,7 @@ xlog_cil_committed(
  */
 STATIC int
 xlog_cil_push(
-	struct log		*log)
+	struct xlog		*log)
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_log_vec	*lv;
@@ -601,7 +601,7 @@ xlog_cil_push_work(
  */
 static void
 xlog_cil_push_background(
-	struct log	*log)
+	struct xlog	*log)
 {
 	struct xfs_cil	*cil = log->l_cilp;
 
@@ -629,7 +629,7 @@ xlog_cil_push_background(
 
 static void
 xlog_cil_push_foreground(
-	struct log	*log,
+	struct xlog	*log,
 	xfs_lsn_t	push_seq)
 {
 	struct xfs_cil	*cil = log->l_cilp;
@@ -683,7 +683,7 @@ xfs_log_commit_cil(
 	xfs_lsn_t		*commit_lsn,
 	int			flags)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	int			log_flags = 0;
 	struct xfs_log_vec	*log_vector;
 
@@ -754,7 +754,7 @@ xfs_log_commit_cil(
  */
 xfs_lsn_t
 xlog_cil_force_lsn(
-	struct log	*log,
+	struct xlog	*log,
 	xfs_lsn_t	sequence)
 {
 	struct xfs_cil		*cil = log->l_cilp;
@@ -833,7 +833,7 @@ xfs_log_item_in_current_chkpt(
  */
 int
 xlog_cil_init(
-	struct log	*log)
+	struct xlog	*log)
 {
 	struct xfs_cil	*cil;
 	struct xfs_cil_ctx *ctx;
@@ -869,7 +869,7 @@ xlog_cil_init(
 
 void
 xlog_cil_destroy(
-	struct log	*log)
+	struct xlog	*log)
 {
 	if (log->l_cilp->xc_ctx) {
 		if (log->l_cilp->xc_ctx->ticket)
Index: b/fs/xfs/xfs_log_priv.h
===================================================================
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -19,7 +19,7 @@
 #define __XFS_LOG_PRIV_H__
 
 struct xfs_buf;
-struct log;
+struct xlog;
 struct xlog_ticket;
 struct xfs_mount;
 
@@ -352,7 +352,7 @@ typedef struct xlog_in_core {
 	struct xlog_in_core	*ic_next;
 	struct xlog_in_core	*ic_prev;
 	struct xfs_buf		*ic_bp;
-	struct log		*ic_log;
+	struct xlog		*ic_log;
 	int			ic_size;
 	int			ic_offset;
 	int			ic_bwritecnt;
@@ -409,7 +409,7 @@ struct xfs_cil_ctx {
  * operations almost as efficient as the old logging methods.
  */
 struct xfs_cil {
-	struct log		*xc_log;
+	struct xlog		*xc_log;
 	struct list_head	xc_cil;
 	spinlock_t		xc_cil_lock;
 	struct xfs_cil_ctx	*xc_ctx;
@@ -487,7 +487,7 @@ struct xlog_grant_head {
  * overflow 31 bits worth of byte offset, so using a byte number will mean
  * that round off problems won't occur when releasing partial reservations.
  */
-typedef struct log {
+typedef struct xlog {
 	/* The following fields don't need locking */
 	struct xfs_mount	*l_mp;	        /* mount point */
 	struct xfs_ail		*l_ailp;	/* AIL log is working with */
@@ -553,9 +553,14 @@ extern int	 xlog_recover_finish(xlog_t *
 extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
 
 extern kmem_zone_t *xfs_log_ticket_zone;
-struct xlog_ticket *xlog_ticket_alloc(struct log *log, int unit_bytes,
-				int count, char client, bool permanent,
-				xfs_km_flags_t alloc_flags);
+struct xlog_ticket *
+xlog_ticket_alloc(
+	struct xlog	*log,
+	int		unit_bytes,
+	int		count,
+	char		client,
+	bool		permanent,
+	xfs_km_flags_t	alloc_flags);
 
 
 static inline void
@@ -567,9 +572,14 @@ xlog_write_adv_cnt(void **ptr, int *len,
 }
 
 void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
-int	xlog_write(struct log *log, struct xfs_log_vec *log_vector,
-				struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
-				xlog_in_core_t **commit_iclog, uint flags);
+int
+xlog_write(
+	struct xlog		*log,
+	struct xfs_log_vec	*log_vector,
+	struct xlog_ticket	*tic,
+	xfs_lsn_t		*start_lsn,
+	struct xlog_in_core	**commit_iclog,
+	uint			flags);
 
 /*
  * When we crack an atomic LSN, we sample it first so that the value will not
@@ -629,17 +639,23 @@ xlog_assign_grant_head(atomic64_t *head,
 /*
  * Committed Item List interfaces
  */
-int	xlog_cil_init(struct log *log);
-void	xlog_cil_init_post_recovery(struct log *log);
-void	xlog_cil_destroy(struct log *log);
+int
+xlog_cil_init(struct xlog *log);
+void
+xlog_cil_init_post_recovery(struct xlog *log);
+void
+xlog_cil_destroy(struct xlog *log);
 
 /*
  * CIL force routines
  */
-xfs_lsn_t xlog_cil_force_lsn(struct log *log, xfs_lsn_t sequence);
+xfs_lsn_t
+xlog_cil_force_lsn(
+	struct xlog *log,
+	xfs_lsn_t sequence);
 
 static inline void
-xlog_cil_force(struct log *log)
+xlog_cil_force(struct xlog *log)
 {
 	xlog_cil_force_lsn(log, log->l_cilp->xc_current_sequence);
 }
Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1471,8 +1471,8 @@ xlog_recover_add_item(
 
 STATIC int
 xlog_recover_add_to_cont_trans(
-	struct log		*log,
-	xlog_recover_t		*trans,
+	struct xlog		*log,
+	struct xlog_recover	*trans,
 	xfs_caddr_t		dp,
 	int			len)
 {
@@ -1517,8 +1517,8 @@ xlog_recover_add_to_cont_trans(
  */
 STATIC int
 xlog_recover_add_to_trans(
-	struct log		*log,
-	xlog_recover_t		*trans,
+	struct xlog		*log,
+	struct xlog_recover	*trans,
 	xfs_caddr_t		dp,
 	int			len)
 {
@@ -1588,8 +1588,8 @@ xlog_recover_add_to_trans(
  */
 STATIC int
 xlog_recover_reorder_trans(
-	struct log		*log,
-	xlog_recover_t		*trans,
+	struct xlog		*log,
+	struct xlog_recover	*trans,
 	int			pass)
 {
 	xlog_recover_item_t	*item, *n;
@@ -1642,8 +1642,8 @@ xlog_recover_reorder_trans(
  */
 STATIC int
 xlog_recover_buffer_pass1(
-	struct log		*log,
-	xlog_recover_item_t	*item)
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
 {
 	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
 	struct list_head	*bucket;
@@ -1696,7 +1696,7 @@ xlog_recover_buffer_pass1(
  */
 STATIC int
 xlog_check_buffer_cancelled(
-	struct log		*log,
+	struct xlog		*log,
 	xfs_daddr_t		blkno,
 	uint			len,
 	ushort			flags)
@@ -2689,9 +2689,9 @@ xlog_recover_free_trans(
 
 STATIC int
 xlog_recover_commit_pass1(
-	struct log		*log,
-	struct xlog_recover	*trans,
-	xlog_recover_item_t	*item)
+	struct xlog			*log,
+	struct xlog_recover		*trans,
+	struct xlog_recover_item	*item)
 {
 	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS1);
 
@@ -2716,10 +2716,10 @@ xlog_recover_commit_pass1(
 
 STATIC int
 xlog_recover_commit_pass2(
-	struct log		*log,
-	struct xlog_recover	*trans,
-	struct list_head	*buffer_list,
-	xlog_recover_item_t	*item)
+	struct xlog			*log,
+	struct xlog_recover		*trans,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item)
 {
 	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
 
@@ -2753,7 +2753,7 @@ xlog_recover_commit_pass2(
  */
 STATIC int
 xlog_recover_commit_trans(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_recover	*trans,
 	int			pass)
 {
@@ -2793,8 +2793,8 @@ out:
 
 STATIC int
 xlog_recover_unmount_trans(
-	struct log		*log,
-	xlog_recover_t		*trans)
+	struct xlog		*log,
+	struct xlog_recover	*trans)
 {
 	/* Do nothing now */
 	xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
Index: b/fs/xfs/xfs_mount.h
===================================================================
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -53,7 +53,7 @@ typedef struct xfs_trans_reservations {
 
 #include "xfs_sync.h"
 
-struct log;
+struct xlog;
 struct xfs_mount_args;
 struct xfs_inode;
 struct xfs_bmbt_irec;
@@ -133,7 +133,7 @@ typedef struct xfs_mount {
 	uint			m_readio_blocks; /* min read size blocks */
 	uint			m_writeio_log;	/* min write size log bytes */
 	uint			m_writeio_blocks; /* min write size blocks */
-	struct log		*m_log;		/* log specific stuff */
+	struct xlog		*m_log;		/* log specific stuff */
 	int			m_logbufs;	/* number of log buffers */
 	int			m_logbsize;	/* size of each log buffer */
 	uint			m_rsumlevels;	/* rt summary levels */
Index: b/fs/xfs/xfs_trace.h
===================================================================
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -32,7 +32,7 @@ struct xfs_da_node_entry;
 struct xfs_dquot;
 struct xfs_log_item;
 struct xlog_ticket;
-struct log;
+struct xlog;
 struct xlog_recover;
 struct xlog_recover_item;
 struct xfs_buf_log_format;
@@ -762,7 +762,7 @@ DEFINE_DQUOT_EVENT(xfs_dqflush_force);
 DEFINE_DQUOT_EVENT(xfs_dqflush_done);
 
 DECLARE_EVENT_CLASS(xfs_loggrant_class,
-	TP_PROTO(struct log *log, struct xlog_ticket *tic),
+	TP_PROTO(struct xlog *log, struct xlog_ticket *tic),
 	TP_ARGS(log, tic),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -830,7 +830,7 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 
 #define DEFINE_LOGGRANT_EVENT(name) \
 DEFINE_EVENT(xfs_loggrant_class, name, \
-	TP_PROTO(struct log *log, struct xlog_ticket *tic), \
+	TP_PROTO(struct xlog *log, struct xlog_ticket *tic), \
 	TP_ARGS(log, tic))
 DEFINE_LOGGRANT_EVENT(xfs_log_done_nonperm);
 DEFINE_LOGGRANT_EVENT(xfs_log_done_perm);
@@ -1664,7 +1664,7 @@ DEFINE_SWAPEXT_EVENT(xfs_swap_extent_bef
 DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after);
 
 DECLARE_EVENT_CLASS(xfs_log_recover_item_class,
-	TP_PROTO(struct log *log, struct xlog_recover *trans,
+	TP_PROTO(struct xlog *log, struct xlog_recover *trans,
 		struct xlog_recover_item *item, int pass),
 	TP_ARGS(log, trans, item, pass),
 	TP_STRUCT__entry(
@@ -1698,7 +1698,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_item
 
 #define DEFINE_LOG_RECOVER_ITEM(name) \
 DEFINE_EVENT(xfs_log_recover_item_class, name, \
-	TP_PROTO(struct log *log, struct xlog_recover *trans, \
+	TP_PROTO(struct xlog *log, struct xlog_recover *trans, \
 		struct xlog_recover_item *item, int pass), \
 	TP_ARGS(log, trans, item, pass))
 
@@ -1709,7 +1709,7 @@ DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_
 DEFINE_LOG_RECOVER_ITEM(xfs_log_recover_item_recover);
 
 DECLARE_EVENT_CLASS(xfs_log_recover_buf_item_class,
-	TP_PROTO(struct log *log, struct xfs_buf_log_format *buf_f),
+	TP_PROTO(struct xlog *log, struct xfs_buf_log_format *buf_f),
 	TP_ARGS(log, buf_f),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -1739,7 +1739,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_buf_
 
 #define DEFINE_LOG_RECOVER_BUF_ITEM(name) \
 DEFINE_EVENT(xfs_log_recover_buf_item_class, name, \
-	TP_PROTO(struct log *log, struct xfs_buf_log_format *buf_f), \
+	TP_PROTO(struct xlog *log, struct xfs_buf_log_format *buf_f), \
 	TP_ARGS(log, buf_f))
 
 DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_not_cancel);
@@ -1752,7 +1752,7 @@ DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_reco
 DEFINE_LOG_RECOVER_BUF_ITEM(xfs_log_recover_buf_dquot_buf);
 
 DECLARE_EVENT_CLASS(xfs_log_recover_ino_item_class,
-	TP_PROTO(struct log *log, struct xfs_inode_log_format *in_f),
+	TP_PROTO(struct xlog *log, struct xfs_inode_log_format *in_f),
 	TP_ARGS(log, in_f),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -1790,7 +1790,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_ino_
 )
 #define DEFINE_LOG_RECOVER_INO_ITEM(name) \
 DEFINE_EVENT(xfs_log_recover_ino_item_class, name, \
-	TP_PROTO(struct log *log, struct xfs_inode_log_format *in_f), \
+	TP_PROTO(struct xlog *log, struct xfs_inode_log_format *in_f), \
 	TP_ARGS(log, in_f))
 
 DEFINE_LOG_RECOVER_INO_ITEM(xfs_log_recover_inode_recover);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
