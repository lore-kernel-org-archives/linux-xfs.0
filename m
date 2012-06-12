Return-Path: <xfs-bounces@oss.sgi.com>
Received: from tinguely (eagdhcp-232-130.americas.sgi.com [128.162.232.130])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5CJg4YV029972 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 14:42:04 -0500
Received: from tinguely (localhost [127.0.0.1])
	by tinguely (8.14.5/8.14.5) with ESMTP id q5CJg34I003848
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 14:42:03 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Received: (from tinguely@localhost)
	by tinguely (8.14.5/8.14.5/Submit) id q5CJg3ai003847
	for xfs@oss.sgi.com; Tue, 12 Jun 2012 14:42:03 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20120612193013.126828430@sgi.com>
Date: Tue, 12 Jun 2012 14:30:00 -0500
From: tinguely@sgi.com
Subject: [PATCH] (repost) xfs: rename log structure and remove xlog_t
References: <20120612192959.058783650@sgi.com>
Content-Disposition: inline; filename=xfs-rename-struct-log-to-xlog.patch
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

Subject: [PATCH] (repost) xfs: rename log structure and remove xlog_t

The other copy had wrap errors.

Rename the log structure to xlog and drop the xlog_t type definition.
This will make it easier to distinguish the XFS log from other logs in Linux.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>

---
 fs/xfs/xfs_log.c         |  130 +++++++++++++++++++++++------------------------
 fs/xfs/xfs_log_cil.c     |   22 +++----
 fs/xfs/xfs_log_priv.h    |   30 +++++-----
 fs/xfs/xfs_log_recover.c |   98 +++++++++++++++++------------------
 fs/xfs/xfs_mount.h       |    4 -
 fs/xfs/xfs_trace.h       |   18 +++---
 6 files changed, 151 insertions(+), 151 deletions(-)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -38,45 +38,45 @@
 kmem_zone_t	*xfs_log_ticket_zone;
 
 /* Local miscellaneous function prototypes */
-STATIC int	 xlog_commit_record(struct log *log, struct xlog_ticket *ticket,
+STATIC int	 xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
 				    xlog_in_core_t **, xfs_lsn_t *);
-STATIC xlog_t *  xlog_alloc_log(xfs_mount_t	*mp,
+STATIC struct xlog *  xlog_alloc_log(xfs_mount_t	*mp,
 				xfs_buftarg_t	*log_target,
 				xfs_daddr_t	blk_offset,
 				int		num_bblks);
-STATIC int	 xlog_space_left(struct log *log, atomic64_t *head);
-STATIC int	 xlog_sync(xlog_t *log, xlog_in_core_t *iclog);
-STATIC void	 xlog_dealloc_log(xlog_t *log);
+STATIC int	 xlog_space_left(struct xlog *log, atomic64_t *head);
+STATIC int	 xlog_sync(struct xlog *log, xlog_in_core_t *iclog);
+STATIC void	 xlog_dealloc_log(struct xlog *log);
 
 /* local state machine functions */
 STATIC void xlog_state_done_syncing(xlog_in_core_t *iclog, int);
-STATIC void xlog_state_do_callback(xlog_t *log,int aborted, xlog_in_core_t *iclog);
-STATIC int  xlog_state_get_iclog_space(xlog_t		*log,
+STATIC void xlog_state_do_callback(struct xlog *log,int aborted, xlog_in_core_t *iclog);
+STATIC int  xlog_state_get_iclog_space(struct xlog	*log,
 				       int		len,
 				       xlog_in_core_t	**iclog,
 				       xlog_ticket_t	*ticket,
 				       int		*continued_write,
 				       int		*logoffsetp);
-STATIC int  xlog_state_release_iclog(xlog_t		*log,
+STATIC int  xlog_state_release_iclog(struct xlog	*log,
 				     xlog_in_core_t	*iclog);
-STATIC void xlog_state_switch_iclogs(xlog_t		*log,
+STATIC void xlog_state_switch_iclogs(struct xlog	*log,
 				     xlog_in_core_t *iclog,
 				     int		eventual_size);
-STATIC void xlog_state_want_sync(xlog_t	*log, xlog_in_core_t *iclog);
+STATIC void xlog_state_want_sync(struct xlog	*log, xlog_in_core_t *iclog);
 
-STATIC void xlog_grant_push_ail(struct log	*log,
+STATIC void xlog_grant_push_ail(struct xlog	*log,
 				int		need_bytes);
-STATIC void xlog_regrant_reserve_log_space(xlog_t	 *log,
+STATIC void xlog_regrant_reserve_log_space(struct xlog	 *log,
 					   xlog_ticket_t *ticket);
-STATIC void xlog_ungrant_log_space(xlog_t	 *log,
+STATIC void xlog_ungrant_log_space(struct xlog	 *log,
 				   xlog_ticket_t *ticket);
 
 #if defined(DEBUG)
-STATIC void	xlog_verify_dest_ptr(xlog_t *log, char *ptr);
-STATIC void	xlog_verify_grant_tail(struct log *log);
-STATIC void	xlog_verify_iclog(xlog_t *log, xlog_in_core_t *iclog,
+STATIC void	xlog_verify_dest_ptr(struct xlog *log, char *ptr);
+STATIC void	xlog_verify_grant_tail(struct xlog *log);
+STATIC void	xlog_verify_iclog(struct xlog *log, xlog_in_core_t *iclog,
 				  int count, boolean_t syncing);
-STATIC void	xlog_verify_tail_lsn(xlog_t *log, xlog_in_core_t *iclog,
+STATIC void	xlog_verify_tail_lsn(struct xlog *log, xlog_in_core_t *iclog,
 				     xfs_lsn_t tail_lsn);
 #else
 #define xlog_verify_dest_ptr(a,b)
@@ -85,11 +85,11 @@ STATIC void	xlog_verify_tail_lsn(xlog_t
 #define xlog_verify_tail_lsn(a,b,c)
 #endif
 
-STATIC int	xlog_iclogs_empty(xlog_t *log);
+STATIC int	xlog_iclogs_empty(struct xlog *log);
 
 static void
 xlog_grant_sub_space(
-	struct log	*log,
+	struct xlog	*log,
 	atomic64_t	*head,
 	int		bytes)
 {
@@ -115,7 +115,7 @@ xlog_grant_sub_space(
 
 static void
 xlog_grant_add_space(
-	struct log	*log,
+	struct xlog	*log,
 	atomic64_t	*head,
 	int		bytes)
 {
@@ -165,7 +165,7 @@ xlog_grant_head_wake_all(
 
 static inline int
 xlog_ticket_reservation(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_grant_head	*head,
 	struct xlog_ticket	*tic)
 {
@@ -182,7 +182,7 @@ xlog_ticket_reservation(
 
 STATIC bool
 xlog_grant_head_wake(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_grant_head	*head,
 	int			*free_bytes)
 {
@@ -204,7 +204,7 @@ xlog_grant_head_wake(
 
 STATIC int
 xlog_grant_head_wait(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_grant_head	*head,
 	struct xlog_ticket	*tic,
 	int			need_bytes)
@@ -256,7 +256,7 @@ shutdown:
  */
 STATIC int
 xlog_grant_head_check(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_grant_head	*head,
 	struct xlog_ticket	*tic,
 	int			*need_bytes)
@@ -323,7 +323,7 @@ xfs_log_regrant(
 	struct xfs_mount	*mp,
 	struct xlog_ticket	*tic)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	int			need_bytes;
 	int			error = 0;
 
@@ -389,7 +389,7 @@ xfs_log_reserve(
 	bool			permanent,
 	uint		 	t_type)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	struct xlog_ticket	*tic;
 	int			need_bytes;
 	int			error = 0;
@@ -465,7 +465,7 @@ xfs_log_done(
 	struct xlog_in_core	**iclog,
 	uint			flags)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	xfs_lsn_t		lsn = 0;
 
 	if (XLOG_FORCED_SHUTDOWN(log) ||
@@ -672,7 +672,7 @@ xfs_log_mount_finish(xfs_mount_t *mp)
 int
 xfs_log_unmount_write(xfs_mount_t *mp)
 {
-	xlog_t		 *log = mp->m_log;
+	struct xlog	 *log = mp->m_log;
 	xlog_in_core_t	 *iclog;
 #ifdef DEBUG
 	xlog_in_core_t	 *first_iclog;
@@ -838,7 +838,7 @@ void
 xfs_log_space_wake(
 	struct xfs_mount	*mp)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	int			free_bytes;
 
 	if (XLOG_FORCED_SHUTDOWN(log))
@@ -880,7 +880,7 @@ int
 xfs_log_need_covered(xfs_mount_t *mp)
 {
 	int		needed = 0;
-	xlog_t		*log = mp->m_log;
+	struct xlog	*log = mp->m_log;
 
 	if (!xfs_fs_writable(mp))
 		return 0;
@@ -916,7 +916,7 @@ xfs_lsn_t
 xlog_assign_tail_lsn_locked(
 	struct xfs_mount	*mp)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	struct xfs_log_item	*lip;
 	xfs_lsn_t		tail_lsn;
 
@@ -965,7 +965,7 @@ xlog_assign_tail_lsn(
  */
 STATIC int
 xlog_space_left(
-	struct log	*log,
+	struct xlog	*log,
 	atomic64_t	*head)
 {
 	int		free_bytes;
@@ -1012,7 +1012,7 @@ void
 xlog_iodone(xfs_buf_t *bp)
 {
 	xlog_in_core_t	*iclog = bp->b_fspriv;
-	xlog_t		*l = iclog->ic_log;
+	struct xlog	*l = iclog->ic_log;
 	int		aborted = 0;
 
 	/*
@@ -1055,7 +1055,7 @@ xlog_iodone(xfs_buf_t *bp)
 
 STATIC void
 xlog_get_iclog_buffer_size(xfs_mount_t	*mp,
-			   xlog_t	*log)
+			   struct xlog	*log)
 {
 	int size;
 	int xhdrs;
@@ -1116,13 +1116,13 @@ done:
  * Its primary purpose is to fill in enough, so recovery can occur.  However,
  * some other stuff may be filled in too.
  */
-STATIC xlog_t *
+STATIC struct xlog *
 xlog_alloc_log(xfs_mount_t	*mp,
 	       xfs_buftarg_t	*log_target,
 	       xfs_daddr_t	blk_offset,
 	       int		num_bblks)
 {
-	xlog_t			*log;
+	struct xlog		*log;
 	xlog_rec_header_t	*head;
 	xlog_in_core_t		**iclogp;
 	xlog_in_core_t		*iclog, *prev_iclog=NULL;
@@ -1131,7 +1131,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	int			error = ENOMEM;
 	uint			log2_size = 0;
 
-	log = kmem_zalloc(sizeof(xlog_t), KM_MAYFAIL);
+	log = kmem_zalloc(sizeof(struct xlog), KM_MAYFAIL);
 	if (!log) {
 		xfs_warn(mp, "Log allocation failed: No memory!");
 		goto out;
@@ -1277,7 +1277,7 @@ out:
  */
 STATIC int
 xlog_commit_record(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	**iclog,
 	xfs_lsn_t		*commitlsnp)
@@ -1311,7 +1311,7 @@ xlog_commit_record(
  */
 STATIC void
 xlog_grant_push_ail(
-	struct log	*log,
+	struct xlog	*log,
 	int		need_bytes)
 {
 	xfs_lsn_t	threshold_lsn = 0;
@@ -1421,7 +1421,7 @@ xlog_bdstrat(
  */
 
 STATIC int
-xlog_sync(xlog_t		*log,
+xlog_sync(struct xlog		*log,
 	  xlog_in_core_t	*iclog)
 {
 	xfs_caddr_t	dptr;		/* pointer to byte sized element */
@@ -1571,7 +1571,7 @@ xlog_sync(xlog_t		*log,
  * Deallocate a log structure
  */
 STATIC void
-xlog_dealloc_log(xlog_t *log)
+xlog_dealloc_log(struct xlog *log)
 {
 	xlog_in_core_t	*iclog, *next_iclog;
 	int		i;
@@ -1603,7 +1603,7 @@ xlog_dealloc_log(xlog_t *log)
  */
 /* ARGSUSED */
 static inline void
-xlog_state_finish_copy(xlog_t		*log,
+xlog_state_finish_copy(struct xlog	*log,
 		       xlog_in_core_t	*iclog,
 		       int		record_cnt,
 		       int		copy_bytes)
@@ -1790,7 +1790,7 @@ xlog_write_start_rec(
 
 static xlog_op_header_t *
 xlog_write_setup_ophdr(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_op_header	*ophdr,
 	struct xlog_ticket	*ticket,
 	uint			flags)
@@ -1873,7 +1873,7 @@ xlog_write_setup_copy(
 
 static int
 xlog_write_copy_finish(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_in_core	*iclog,
 	uint			flags,
 	int			*record_cnt,
@@ -1958,7 +1958,7 @@ xlog_write_copy_finish(
  */
 int
 xlog_write(
-	struct log		*log,
+	struct xlog		*log,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*start_lsn,
@@ -2129,7 +2129,7 @@ xlog_write(
  * State Change: DIRTY -> ACTIVE
  */
 STATIC void
-xlog_state_clean_log(xlog_t *log)
+xlog_state_clean_log(struct xlog *log)
 {
 	xlog_in_core_t	*iclog;
 	int changed = 0;
@@ -2209,7 +2209,7 @@ xlog_state_clean_log(xlog_t *log)
 
 STATIC xfs_lsn_t
 xlog_get_lowest_lsn(
-	xlog_t		*log)
+	struct xlog	*log)
 {
 	xlog_in_core_t  *lsn_log;
 	xfs_lsn_t	lowest_lsn, lsn;
@@ -2232,7 +2232,7 @@ xlog_get_lowest_lsn(
 
 STATIC void
 xlog_state_do_callback(
-	xlog_t		*log,
+	struct xlog	*log,
 	int		aborted,
 	xlog_in_core_t	*ciclog)
 {
@@ -2454,7 +2454,7 @@ xlog_state_done_syncing(
 	xlog_in_core_t	*iclog,
 	int		aborted)
 {
-	xlog_t		   *log = iclog->ic_log;
+	struct xlog	   *log = iclog->ic_log;
 
 	spin_lock(&log->l_icloglock);
 
@@ -2508,7 +2508,7 @@ xlog_state_done_syncing(
  *		is copied.
  */
 STATIC int
-xlog_state_get_iclog_space(xlog_t	  *log,
+xlog_state_get_iclog_space(struct xlog	  *log,
 			   int		  len,
 			   xlog_in_core_t **iclogp,
 			   xlog_ticket_t  *ticket,
@@ -2618,7 +2618,7 @@ restart:
  * move grant reservation head forward.
  */
 STATIC void
-xlog_regrant_reserve_log_space(xlog_t	     *log,
+xlog_regrant_reserve_log_space(struct xlog   *log,
 			       xlog_ticket_t *ticket)
 {
 	trace_xfs_log_regrant_reserve_enter(log, ticket);
@@ -2664,7 +2664,7 @@ xlog_regrant_reserve_log_space(xlog_t
  * in the current reservation field.
  */
 STATIC void
-xlog_ungrant_log_space(xlog_t	     *log,
+xlog_ungrant_log_space(struct xlog   *log,
 		       xlog_ticket_t *ticket)
 {
 	int	bytes;
@@ -2704,7 +2704,7 @@ xlog_ungrant_log_space(xlog_t	     *log,
  */
 STATIC int
 xlog_state_release_iclog(
-	xlog_t		*log,
+	struct xlog	*log,
 	xlog_in_core_t	*iclog)
 {
 	int		sync = 0;	/* do we sync? */
@@ -2755,7 +2755,7 @@ xlog_state_release_iclog(
  * that every data block.  We have run out of space in this log record.
  */
 STATIC void
-xlog_state_switch_iclogs(xlog_t		*log,
+xlog_state_switch_iclogs(struct xlog	*log,
 			 xlog_in_core_t *iclog,
 			 int		eventual_size)
 {
@@ -2821,7 +2821,7 @@ _xfs_log_force(
 	uint			flags,
 	int			*log_flushed)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	struct xlog_in_core	*iclog;
 	xfs_lsn_t		lsn;
 
@@ -2969,7 +2969,7 @@ _xfs_log_force_lsn(
 	uint			flags,
 	int			*log_flushed)
 {
-	struct log		*log = mp->m_log;
+	struct xlog		*log = mp->m_log;
 	struct xlog_in_core	*iclog;
 	int			already_slept = 0;
 
@@ -3101,7 +3101,7 @@ xfs_log_force_lsn(
  * disk.
  */
 STATIC void
-xlog_state_want_sync(xlog_t *log, xlog_in_core_t *iclog)
+xlog_state_want_sync(struct xlog *log, xlog_in_core_t *iclog)
 {
 	assert_spin_locked(&log->l_icloglock);
 
@@ -3147,7 +3147,7 @@ xfs_log_ticket_get(
  */
 xlog_ticket_t *
 xlog_ticket_alloc(
-	struct log	*log,
+	struct xlog	*log,
 	int		unit_bytes,
 	int		cnt,
 	char		client,
@@ -3278,7 +3278,7 @@ xlog_ticket_alloc(
  */
 void
 xlog_verify_dest_ptr(
-	struct log	*log,
+	struct xlog	*log,
 	char		*ptr)
 {
 	int i;
@@ -3307,7 +3307,7 @@ xlog_verify_dest_ptr(
  */
 STATIC void
 xlog_verify_grant_tail(
-	struct log	*log)
+	struct xlog	*log)
 {
 	int		tail_cycle, tail_blocks;
 	int		cycle, space;
@@ -3333,7 +3333,7 @@ xlog_verify_grant_tail(
 
 /* check if it will fit */
 STATIC void
-xlog_verify_tail_lsn(xlog_t	    *log,
+xlog_verify_tail_lsn(struct xlog	    *log,
 		     xlog_in_core_t *iclog,
 		     xfs_lsn_t	    tail_lsn)
 {
@@ -3372,7 +3372,7 @@ xlog_verify_tail_lsn(xlog_t	    *log,
  *	the cycle numbers agree with the current cycle number.
  */
 STATIC void
-xlog_verify_iclog(xlog_t	 *log,
+xlog_verify_iclog(struct xlog	 *log,
 		  xlog_in_core_t *iclog,
 		  int		 count,
 		  boolean_t	 syncing)
@@ -3469,7 +3469,7 @@ xlog_verify_iclog(xlog_t	 *log,
  */
 STATIC int
 xlog_state_ioerror(
-	xlog_t	*log)
+	struct xlog	*log)
 {
 	xlog_in_core_t	*iclog, *ic;
 
@@ -3514,7 +3514,7 @@ xfs_log_force_umount(
 	struct xfs_mount	*mp,
 	int			logerror)
 {
-	xlog_t		*log;
+	struct xlog		*log;
 	int		retval;
 
 	log = mp->m_log;
@@ -3621,7 +3621,7 @@ xfs_log_force_umount(
 }
 
 STATIC int
-xlog_iclogs_empty(xlog_t *log)
+xlog_iclogs_empty(struct xlog *log)
 {
 	xlog_in_core_t	*iclog;
 
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
+struct xlog {
 	/* The following fields don't need locking */
 	struct xfs_mount	*l_mp;	        /* mount point */
 	struct xfs_ail		*l_ailp;	/* AIL log is working with */
@@ -540,7 +540,7 @@ typedef struct log {
 	char			*l_iclog_bak[XLOG_MAX_ICLOGS];
 #endif
 
-} xlog_t;
+};
 
 #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
 	((log)->l_buf_cancel_table + ((__uint64_t)blkno % XLOG_BC_TABLE_SIZE))
@@ -548,12 +548,12 @@ typedef struct log {
 #define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
 
 /* common routines */
-extern int	 xlog_recover(xlog_t *log);
-extern int	 xlog_recover_finish(xlog_t *log);
-extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
+extern int	 xlog_recover(struct xlog *log);
+extern int	 xlog_recover_finish(struct xlog *log);
+extern void	 xlog_pack_data(struct xlog *log, xlog_in_core_t *iclog, int);
 
 extern kmem_zone_t *xfs_log_ticket_zone;
-struct xlog_ticket *xlog_ticket_alloc(struct log *log, int unit_bytes,
+struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
 				int count, char client, bool permanent,
 				xfs_km_flags_t alloc_flags);
 
@@ -567,7 +567,7 @@ xlog_write_adv_cnt(void **ptr, int *len,
 }
 
 void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
-int	xlog_write(struct log *log, struct xfs_log_vec *log_vector,
+int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
 				struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
 				xlog_in_core_t **commit_iclog, uint flags);
 
@@ -629,17 +629,17 @@ xlog_assign_grant_head(atomic64_t *head,
 /*
  * Committed Item List interfaces
  */
-int	xlog_cil_init(struct log *log);
-void	xlog_cil_init_post_recovery(struct log *log);
-void	xlog_cil_destroy(struct log *log);
+int	xlog_cil_init(struct xlog *log);
+void	xlog_cil_init_post_recovery(struct xlog *log);
+void	xlog_cil_destroy(struct xlog *log);
 
 /*
  * CIL force routines
  */
-xfs_lsn_t xlog_cil_force_lsn(struct log *log, xfs_lsn_t sequence);
+xfs_lsn_t xlog_cil_force_lsn(struct xlog *log, xfs_lsn_t sequence);
 
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
@@ -43,10 +43,10 @@
 #include "xfs_utils.h"
 #include "xfs_trace.h"
 
-STATIC int	xlog_find_zeroed(xlog_t *, xfs_daddr_t *);
-STATIC int	xlog_clear_stale_blocks(xlog_t *, xfs_lsn_t);
+STATIC int	xlog_find_zeroed(struct xlog *, xfs_daddr_t *);
+STATIC int	xlog_clear_stale_blocks(struct xlog *, xfs_lsn_t);
 #if defined(DEBUG)
-STATIC void	xlog_recover_check_summary(xlog_t *);
+STATIC void	xlog_recover_check_summary(struct xlog *);
 #else
 #define	xlog_recover_check_summary(log)
 #endif
@@ -74,7 +74,7 @@ struct xfs_buf_cancel {
 
 static inline int
 xlog_buf_bbcount_valid(
-	xlog_t		*log,
+	struct xlog	*log,
 	int		bbcount)
 {
 	return bbcount > 0 && bbcount <= log->l_logBBsize;
@@ -87,7 +87,7 @@ xlog_buf_bbcount_valid(
  */
 STATIC xfs_buf_t *
 xlog_get_bp(
-	xlog_t		*log,
+	struct xlog	*log,
 	int		nbblks)
 {
 	struct xfs_buf	*bp;
@@ -138,7 +138,7 @@ xlog_put_bp(
  */
 STATIC xfs_caddr_t
 xlog_align(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
 	xfs_buf_t	*bp)
@@ -155,7 +155,7 @@ xlog_align(
  */
 STATIC int
 xlog_bread_noalign(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
 	xfs_buf_t	*bp)
@@ -189,7 +189,7 @@ xlog_bread_noalign(
 
 STATIC int
 xlog_bread(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
 	xfs_buf_t	*bp,
@@ -211,7 +211,7 @@ xlog_bread(
  */
 STATIC int
 xlog_bread_offset(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	blk_no,		/* block to read from */
 	int		nbblks,		/* blocks to read */
 	xfs_buf_t	*bp,
@@ -241,7 +241,7 @@ xlog_bread_offset(
  */
 STATIC int
 xlog_bwrite(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
 	xfs_buf_t	*bp)
@@ -378,7 +378,7 @@ xlog_recover_iodone(
  */
 STATIC int
 xlog_find_cycle_start(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_buf_t	*bp,
 	xfs_daddr_t	first_blk,
 	xfs_daddr_t	*last_blk,
@@ -421,7 +421,7 @@ xlog_find_cycle_start(
  */
 STATIC int
 xlog_find_verify_cycle(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	start_blk,
 	int		nbblks,
 	uint		stop_on_cycle_no,
@@ -490,7 +490,7 @@ out:
  */
 STATIC int
 xlog_find_verify_log_record(
-	xlog_t			*log,
+	struct xlog		*log,
 	xfs_daddr_t		start_blk,
 	xfs_daddr_t		*last_blk,
 	int			extra_bblks)
@@ -600,7 +600,7 @@ out:
  */
 STATIC int
 xlog_find_head(
-	xlog_t 		*log,
+	struct xlog	*log,
 	xfs_daddr_t	*return_head_blk)
 {
 	xfs_buf_t	*bp;
@@ -871,7 +871,7 @@ validate_head:
  */
 STATIC int
 xlog_find_tail(
-	xlog_t			*log,
+	struct xlog			*log,
 	xfs_daddr_t		*head_blk,
 	xfs_daddr_t		*tail_blk)
 {
@@ -1080,7 +1080,7 @@ done:
  */
 STATIC int
 xlog_find_zeroed(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	*blk_no)
 {
 	xfs_buf_t	*bp;
@@ -1183,7 +1183,7 @@ bp_err:
  */
 STATIC void
 xlog_add_record(
-	xlog_t			*log,
+	struct xlog		*log,
 	xfs_caddr_t		buf,
 	int			cycle,
 	int			block,
@@ -1205,7 +1205,7 @@ xlog_add_record(
 
 STATIC int
 xlog_write_log_records(
-	xlog_t		*log,
+	struct xlog	*log,
 	int		cycle,
 	int		start_block,
 	int		blocks,
@@ -1305,7 +1305,7 @@ xlog_write_log_records(
  */
 STATIC int
 xlog_clear_stale_blocks(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_lsn_t	tail_lsn)
 {
 	int		tail_cycle, head_cycle;
@@ -1471,7 +1471,7 @@ xlog_recover_add_item(
 
 STATIC int
 xlog_recover_add_to_cont_trans(
-	struct log		*log,
+	struct xlog		*log,
 	xlog_recover_t		*trans,
 	xfs_caddr_t		dp,
 	int			len)
@@ -1517,7 +1517,7 @@ xlog_recover_add_to_cont_trans(
  */
 STATIC int
 xlog_recover_add_to_trans(
-	struct log		*log,
+	struct xlog		*log,
 	xlog_recover_t		*trans,
 	xfs_caddr_t		dp,
 	int			len)
@@ -1588,7 +1588,7 @@ xlog_recover_add_to_trans(
  */
 STATIC int
 xlog_recover_reorder_trans(
-	struct log		*log,
+	struct xlog		*log,
 	xlog_recover_t		*trans,
 	int			pass)
 {
@@ -1642,7 +1642,7 @@ xlog_recover_reorder_trans(
  */
 STATIC int
 xlog_recover_buffer_pass1(
-	struct log		*log,
+	struct xlog		*log,
 	xlog_recover_item_t	*item)
 {
 	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
@@ -1696,7 +1696,7 @@ xlog_recover_buffer_pass1(
  */
 STATIC int
 xlog_check_buffer_cancelled(
-	struct log		*log,
+	struct xlog		*log,
 	xfs_daddr_t		blkno,
 	uint			len,
 	ushort			flags)
@@ -2051,7 +2051,7 @@ xfs_qm_dqcheck(
 STATIC void
 xlog_recover_do_dquot_buffer(
 	xfs_mount_t		*mp,
-	xlog_t			*log,
+	struct xlog		*log,
 	xlog_recover_item_t	*item,
 	xfs_buf_t		*bp,
 	xfs_buf_log_format_t	*buf_f)
@@ -2108,7 +2108,7 @@ xlog_recover_do_dquot_buffer(
  */
 STATIC int
 xlog_recover_buffer_pass2(
-	xlog_t			*log,
+	struct xlog		*log,
 	struct list_head	*buffer_list,
 	xlog_recover_item_t	*item)
 {
@@ -2189,7 +2189,7 @@ xlog_recover_buffer_pass2(
 
 STATIC int
 xlog_recover_inode_pass2(
-	xlog_t			*log,
+	struct xlog		*log,
 	struct list_head	*buffer_list,
 	xlog_recover_item_t	*item)
 {
@@ -2452,13 +2452,13 @@ error:
 }
 
 /*
- * Recover QUOTAOFF records. We simply make a note of it in the xlog_t
+ * Recover QUOTAOFF records. We simply make a note of it in the xlog
  * structure, so that we know not to do any dquot item or dquot buffer recovery,
  * of that type.
  */
 STATIC int
 xlog_recover_quotaoff_pass1(
-	xlog_t			*log,
+	struct xlog		*log,
 	xlog_recover_item_t	*item)
 {
 	xfs_qoff_logformat_t	*qoff_f = item->ri_buf[0].i_addr;
@@ -2483,7 +2483,7 @@ xlog_recover_quotaoff_pass1(
  */
 STATIC int
 xlog_recover_dquot_pass2(
-	xlog_t			*log,
+	struct xlog		*log,
 	struct list_head	*buffer_list,
 	xlog_recover_item_t	*item)
 {
@@ -2578,7 +2578,7 @@ xlog_recover_dquot_pass2(
  */
 STATIC int
 xlog_recover_efi_pass2(
-	xlog_t			*log,
+	struct xlog		*log,
 	xlog_recover_item_t	*item,
 	xfs_lsn_t		lsn)
 {
@@ -2616,7 +2616,7 @@ xlog_recover_efi_pass2(
  */
 STATIC int
 xlog_recover_efd_pass2(
-	xlog_t			*log,
+	struct xlog		*log,
 	xlog_recover_item_t	*item)
 {
 	xfs_efd_log_format_t	*efd_formatp;
@@ -2689,7 +2689,7 @@ xlog_recover_free_trans(
 
 STATIC int
 xlog_recover_commit_pass1(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_recover	*trans,
 	xlog_recover_item_t	*item)
 {
@@ -2716,7 +2716,7 @@ xlog_recover_commit_pass1(
 
 STATIC int
 xlog_recover_commit_pass2(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_recover	*trans,
 	struct list_head	*buffer_list,
 	xlog_recover_item_t	*item)
@@ -2753,7 +2753,7 @@ xlog_recover_commit_pass2(
  */
 STATIC int
 xlog_recover_commit_trans(
-	struct log		*log,
+	struct xlog		*log,
 	struct xlog_recover	*trans,
 	int			pass)
 {
@@ -2793,7 +2793,7 @@ out:
 
 STATIC int
 xlog_recover_unmount_trans(
-	struct log		*log,
+	struct xlog		*log,
 	xlog_recover_t		*trans)
 {
 	/* Do nothing now */
@@ -2812,7 +2812,7 @@ xlog_recover_unmount_trans(
  */
 STATIC int
 xlog_recover_process_data(
-	xlog_t			*log,
+	struct xlog		*log,
 	struct hlist_head	rhash[],
 	xlog_rec_header_t	*rhead,
 	xfs_caddr_t		dp,
@@ -2986,7 +2986,7 @@ abort_error:
  */
 STATIC int
 xlog_recover_process_efis(
-	xlog_t			*log)
+	struct xlog		*log)
 {
 	xfs_log_item_t		*lip;
 	xfs_efi_log_item_t	*efip;
@@ -3147,7 +3147,7 @@ xlog_recover_process_one_iunlink(
  */
 STATIC void
 xlog_recover_process_iunlinks(
-	xlog_t		*log)
+	struct xlog		*log)
 {
 	xfs_mount_t	*mp;
 	xfs_agnumber_t	agno;
@@ -3209,7 +3209,7 @@ xlog_recover_process_iunlinks(
 #ifdef DEBUG
 STATIC void
 xlog_pack_data_checksum(
-	xlog_t		*log,
+	struct xlog	*log,
 	xlog_in_core_t	*iclog,
 	int		size)
 {
@@ -3234,7 +3234,7 @@ xlog_pack_data_checksum(
  */
 void
 xlog_pack_data(
-	xlog_t			*log,
+	struct xlog		*log,
 	xlog_in_core_t		*iclog,
 	int			roundoff)
 {
@@ -3276,7 +3276,7 @@ STATIC void
 xlog_unpack_data(
 	xlog_rec_header_t	*rhead,
 	xfs_caddr_t		dp,
-	xlog_t			*log)
+	struct xlog		*log)
 {
 	int			i, j, k;
 
@@ -3299,7 +3299,7 @@ xlog_unpack_data(
 
 STATIC int
 xlog_valid_rec_header(
-	xlog_t			*log,
+	struct xlog		*log,
 	xlog_rec_header_t	*rhead,
 	xfs_daddr_t		blkno)
 {
@@ -3343,7 +3343,7 @@ xlog_valid_rec_header(
  */
 STATIC int
 xlog_do_recovery_pass(
-	xlog_t			*log,
+	struct xlog		*log,
 	xfs_daddr_t		head_blk,
 	xfs_daddr_t		tail_blk,
 	int			pass)
@@ -3595,7 +3595,7 @@ xlog_do_recovery_pass(
  */
 STATIC int
 xlog_do_log_recovery(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	head_blk,
 	xfs_daddr_t	tail_blk)
 {
@@ -3646,7 +3646,7 @@ xlog_do_log_recovery(
  */
 STATIC int
 xlog_do_recover(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	head_blk,
 	xfs_daddr_t	tail_blk)
 {
@@ -3721,7 +3721,7 @@ xlog_do_recover(
  */
 int
 xlog_recover(
-	xlog_t		*log)
+	struct xlog	*log)
 {
 	xfs_daddr_t	head_blk, tail_blk;
 	int		error;
@@ -3767,7 +3767,7 @@ xlog_recover(
  */
 int
 xlog_recover_finish(
-	xlog_t		*log)
+	struct xlog	*log)
 {
 	/*
 	 * Now we're ready to do the transactions needed for the
@@ -3814,7 +3814,7 @@ xlog_recover_finish(
  */
 void
 xlog_recover_check_summary(
-	xlog_t		*log)
+	struct xlog	*log)
 {
 	xfs_mount_t	*mp;
 	xfs_agf_t	*agfp;
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
