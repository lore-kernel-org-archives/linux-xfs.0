Return-Path: <xfs-bounces@oss.sgi.com>
Received: from tinguely (eagdhcp-232-130.americas.sgi.com [128.162.232.130])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5EGd90R002899 for <xfs@oss.sgi.com>; Thu, 14 Jun 2012 11:39:09 -0500
Received: from tinguely (localhost [127.0.0.1])
	by tinguely (8.14.5/8.14.5) with ESMTP id q5EGd9dj002862
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2012 11:39:09 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Received: (from tinguely@localhost)
	by tinguely (8.14.5/8.14.5/Submit) id q5EGd9xf002861
	for xfs@oss.sgi.com; Thu, 14 Jun 2012 11:39:09 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20120614142431.050160180@sgi.com>
Date: Thu, 14 Jun 2012 09:22:16 -0500
From: tinguely@sgi.com
Subject: [PATCH 2/2 v2] xfs: rename log structure and remove xlog_t typedef.
References: <20120614142214.445982138@sgi.com>
Content-Disposition: inline;
	filename=2-2-xfs-rename-struct-log-to-xlog-v2.patch
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

Remove the xlog_t type definitions.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>

---
 fs/xfs/xfs_log.c         |  223 ++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_log_priv.h    |   18 ++-
 fs/xfs/xfs_log_recover.c |  140 +++++++++++++++--------------
 3 files changed, 224 insertions(+), 157 deletions(-)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -45,51 +45,85 @@ xlog_commit_record(
 	struct xlog_in_core	**iclog,
 	xfs_lsn_t		*commitlsnp);
 
-STATIC xlog_t *  xlog_alloc_log(xfs_mount_t	*mp,
-				xfs_buftarg_t	*log_target,
-				xfs_daddr_t	blk_offset,
-				int		num_bblks);
+STATIC struct xlog *
+xlog_alloc_log(
+	struct xfs_mount	*mp,
+	struct xfs_buftarg	*log_target,
+	xfs_daddr_t		blk_offset,
+	int			num_bblks);
 STATIC int
 xlog_space_left(
 	struct xlog		*log,
 	atomic64_t		*head);
-STATIC int	 xlog_sync(xlog_t *log, xlog_in_core_t *iclog);
-STATIC void	 xlog_dealloc_log(xlog_t *log);
+STATIC int
+xlog_sync(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog);
+STATIC void
+xlog_dealloc_log(
+	struct xlog		*log);
 
 /* local state machine functions */
 STATIC void xlog_state_done_syncing(xlog_in_core_t *iclog, int);
-STATIC void xlog_state_do_callback(xlog_t *log,int aborted, xlog_in_core_t *iclog);
-STATIC int  xlog_state_get_iclog_space(xlog_t		*log,
-				       int		len,
-				       xlog_in_core_t	**iclog,
-				       xlog_ticket_t	*ticket,
-				       int		*continued_write,
-				       int		*logoffsetp);
-STATIC int  xlog_state_release_iclog(xlog_t		*log,
-				     xlog_in_core_t	*iclog);
-STATIC void xlog_state_switch_iclogs(xlog_t		*log,
-				     xlog_in_core_t *iclog,
-				     int		eventual_size);
-STATIC void xlog_state_want_sync(xlog_t	*log, xlog_in_core_t *iclog);
+STATIC void
+xlog_state_do_callback(
+	struct xlog		*log,
+	int			aborted,
+	struct xlog_in_core	*iclog);
+STATIC int
+xlog_state_get_iclog_space(
+	struct xlog		*log,
+	int			len,
+	struct xlog_in_core	**iclog,
+	struct xlog_ticket	*ticket,
+	int			*continued_write,
+	int			*logoffsetp);
+STATIC int
+xlog_state_release_iclog(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog);
+STATIC void
+xlog_state_switch_iclogs(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	int			eventual_size);
+STATIC void
+xlog_state_want_sync(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog);
 
 STATIC void
 xlog_grant_push_ail(
-	struct xlog	*log,
-	int		need_bytes);
-STATIC void xlog_regrant_reserve_log_space(xlog_t	 *log,
-					   xlog_ticket_t *ticket);
-STATIC void xlog_ungrant_log_space(xlog_t	 *log,
-				   xlog_ticket_t *ticket);
+	struct xlog		*log,
+	int			need_bytes);
+STATIC void
+xlog_regrant_reserve_log_space(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket);
+STATIC void
+xlog_ungrant_log_space(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket);
 
 #if defined(DEBUG)
-STATIC void	xlog_verify_dest_ptr(xlog_t *log, char *ptr);
+STATIC void
+xlog_verify_dest_ptr(
+	struct xlog		*log,
+	char			*ptr);
 STATIC void
 xlog_verify_grant_tail(
-	struct xlog	*log);
-STATIC void	xlog_verify_iclog(xlog_t *log, xlog_in_core_t *iclog,
-				  int count, boolean_t syncing);
-STATIC void	xlog_verify_tail_lsn(xlog_t *log, xlog_in_core_t *iclog,
-				     xfs_lsn_t tail_lsn);
+	struct xlog *log);
+STATIC void
+xlog_verify_iclog(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	int			count,
+	boolean_t		syncing);
+STATIC void
+xlog_verify_tail_lsn(
+	struct log		*log,
+	struct xlog_in_core	*iclog,
+	xfs_lsn_t		tail_lsn);
 #else
 #define xlog_verify_dest_ptr(a,b)
 #define xlog_verify_grant_tail(a)
@@ -97,7 +131,9 @@ STATIC void	xlog_verify_tail_lsn(xlog_t
 #define xlog_verify_tail_lsn(a,b,c)
 #endif
 
-STATIC int	xlog_iclogs_empty(xlog_t *log);
+STATIC int
+xlog_iclogs_empty(
+	struct xlog		*log);
 
 static void
 xlog_grant_sub_space(
@@ -684,7 +720,7 @@ xfs_log_mount_finish(xfs_mount_t *mp)
 int
 xfs_log_unmount_write(xfs_mount_t *mp)
 {
-	xlog_t		 *log = mp->m_log;
+	struct xlog	 *log = mp->m_log;
 	xlog_in_core_t	 *iclog;
 #ifdef DEBUG
 	xlog_in_core_t	 *first_iclog;
@@ -892,7 +928,7 @@ int
 xfs_log_need_covered(xfs_mount_t *mp)
 {
 	int		needed = 0;
-	xlog_t		*log = mp->m_log;
+	struct xlog	*log = mp->m_log;
 
 	if (!xfs_fs_writable(mp))
 		return 0;
@@ -1023,9 +1059,9 @@ xlog_space_left(
 void
 xlog_iodone(xfs_buf_t *bp)
 {
-	xlog_in_core_t	*iclog = bp->b_fspriv;
-	xlog_t		*l = iclog->ic_log;
-	int		aborted = 0;
+	struct xlog_in_core	*iclog = bp->b_fspriv;
+	struct xlog		*l = iclog->ic_log;
+	int			aborted = 0;
 
 	/*
 	 * Race to shutdown the filesystem if we see an error.
@@ -1066,8 +1102,9 @@ xlog_iodone(xfs_buf_t *bp)
  */
 
 STATIC void
-xlog_get_iclog_buffer_size(xfs_mount_t	*mp,
-			   xlog_t	*log)
+xlog_get_iclog_buffer_size(
+	struct xfs_mount	*mp,
+	struct xlog		*log)
 {
 	int size;
 	int xhdrs;
@@ -1128,13 +1165,14 @@ done:
  * Its primary purpose is to fill in enough, so recovery can occur.  However,
  * some other stuff may be filled in too.
  */
-STATIC xlog_t *
-xlog_alloc_log(xfs_mount_t	*mp,
-	       xfs_buftarg_t	*log_target,
-	       xfs_daddr_t	blk_offset,
-	       int		num_bblks)
+STATIC struct xlog *
+xlog_alloc_log(
+	struct xfs_mount	*mp,
+	struct xfs_buftarg	*log_target,
+	xfs_daddr_t		blk_offset,
+	int			num_bblks)
 {
-	xlog_t			*log;
+	struct xlog		*log;
 	xlog_rec_header_t	*head;
 	xlog_in_core_t		**iclogp;
 	xlog_in_core_t		*iclog, *prev_iclog=NULL;
@@ -1143,7 +1181,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	int			error = ENOMEM;
 	uint			log2_size = 0;
 
-	log = kmem_zalloc(sizeof(xlog_t), KM_MAYFAIL);
+	log = kmem_zalloc(sizeof(struct xlog), KM_MAYFAIL);
 	if (!log) {
 		xfs_warn(mp, "Log allocation failed: No memory!");
 		goto out;
@@ -1433,8 +1471,9 @@ xlog_bdstrat(
  */
 
 STATIC int
-xlog_sync(xlog_t		*log,
-	  xlog_in_core_t	*iclog)
+xlog_sync(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog)
 {
 	xfs_caddr_t	dptr;		/* pointer to byte sized element */
 	xfs_buf_t	*bp;
@@ -1583,7 +1622,8 @@ xlog_sync(xlog_t		*log,
  * Deallocate a log structure
  */
 STATIC void
-xlog_dealloc_log(xlog_t *log)
+xlog_dealloc_log(
+	struct xlog	*log)
 {
 	xlog_in_core_t	*iclog, *next_iclog;
 	int		i;
@@ -1615,10 +1655,11 @@ xlog_dealloc_log(xlog_t *log)
  */
 /* ARGSUSED */
 static inline void
-xlog_state_finish_copy(xlog_t		*log,
-		       xlog_in_core_t	*iclog,
-		       int		record_cnt,
-		       int		copy_bytes)
+xlog_state_finish_copy(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	int			record_cnt,
+	int			copy_bytes)
 {
 	spin_lock(&log->l_icloglock);
 
@@ -2141,7 +2182,8 @@ xlog_write(
  * State Change: DIRTY -> ACTIVE
  */
 STATIC void
-xlog_state_clean_log(xlog_t *log)
+xlog_state_clean_log(
+	struct xlog *log)
 {
 	xlog_in_core_t	*iclog;
 	int changed = 0;
@@ -2221,7 +2263,7 @@ xlog_state_clean_log(xlog_t *log)
 
 STATIC xfs_lsn_t
 xlog_get_lowest_lsn(
-	xlog_t		*log)
+	struct xlog	*log)
 {
 	xlog_in_core_t  *lsn_log;
 	xfs_lsn_t	lowest_lsn, lsn;
@@ -2244,9 +2286,9 @@ xlog_get_lowest_lsn(
 
 STATIC void
 xlog_state_do_callback(
-	xlog_t		*log,
-	int		aborted,
-	xlog_in_core_t	*ciclog)
+	struct xlog		*log,
+	int			aborted,
+	struct xlog_in_core	*ciclog)
 {
 	xlog_in_core_t	   *iclog;
 	xlog_in_core_t	   *first_iclog;	/* used to know when we've
@@ -2466,7 +2508,7 @@ xlog_state_done_syncing(
 	xlog_in_core_t	*iclog,
 	int		aborted)
 {
-	xlog_t		   *log = iclog->ic_log;
+	struct xlog	   *log = iclog->ic_log;
 
 	spin_lock(&log->l_icloglock);
 
@@ -2520,12 +2562,13 @@ xlog_state_done_syncing(
  *		is copied.
  */
 STATIC int
-xlog_state_get_iclog_space(xlog_t	  *log,
-			   int		  len,
-			   xlog_in_core_t **iclogp,
-			   xlog_ticket_t  *ticket,
-			   int		  *continued_write,
-			   int		  *logoffsetp)
+xlog_state_get_iclog_space(
+	struct xlog		*log,
+	int			len,
+	struct xlog_in_core	**iclogp,
+	struct xlog_ticket	*ticket,
+	int			*continued_write,
+	int			*logoffsetp)
 {
 	int		  log_offset;
 	xlog_rec_header_t *head;
@@ -2630,8 +2673,9 @@ restart:
  * move grant reservation head forward.
  */
 STATIC void
-xlog_regrant_reserve_log_space(xlog_t	     *log,
-			       xlog_ticket_t *ticket)
+xlog_regrant_reserve_log_space(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket)
 {
 	trace_xfs_log_regrant_reserve_enter(log, ticket);
 
@@ -2676,8 +2720,9 @@ xlog_regrant_reserve_log_space(xlog_t
  * in the current reservation field.
  */
 STATIC void
-xlog_ungrant_log_space(xlog_t	     *log,
-		       xlog_ticket_t *ticket)
+xlog_ungrant_log_space(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket)
 {
 	int	bytes;
 
@@ -2716,8 +2761,8 @@ xlog_ungrant_log_space(xlog_t	     *log,
  */
 STATIC int
 xlog_state_release_iclog(
-	xlog_t		*log,
-	xlog_in_core_t	*iclog)
+	struct xlog		*log,
+	struct xlog_in_core	*iclog)
 {
 	int		sync = 0;	/* do we sync? */
 
@@ -2767,9 +2812,10 @@ xlog_state_release_iclog(
  * that every data block.  We have run out of space in this log record.
  */
 STATIC void
-xlog_state_switch_iclogs(xlog_t		*log,
-			 xlog_in_core_t *iclog,
-			 int		eventual_size)
+xlog_state_switch_iclogs(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	int			eventual_size)
 {
 	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
 	if (!eventual_size)
@@ -3113,7 +3159,9 @@ xfs_log_force_lsn(
  * disk.
  */
 STATIC void
-xlog_state_want_sync(xlog_t *log, xlog_in_core_t *iclog)
+xlog_state_want_sync(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog)
 {
 	assert_spin_locked(&log->l_icloglock);
 
@@ -3157,7 +3205,7 @@ xfs_log_ticket_get(
 /*
  * Allocate and initialise a new log ticket.
  */
-xlog_ticket_t *
+struct xlog_ticket *
 xlog_ticket_alloc(
 	struct xlog	*log,
 	int		unit_bytes,
@@ -3345,9 +3393,10 @@ xlog_verify_grant_tail(
 
 /* check if it will fit */
 STATIC void
-xlog_verify_tail_lsn(xlog_t	    *log,
-		     xlog_in_core_t *iclog,
-		     xfs_lsn_t	    tail_lsn)
+xlog_verify_tail_lsn(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	xfs_lsn_t		tail_lsn)
 {
     int blocks;
 
@@ -3384,10 +3433,11 @@ xlog_verify_tail_lsn(xlog_t	    *log,
  *	the cycle numbers agree with the current cycle number.
  */
 STATIC void
-xlog_verify_iclog(xlog_t	 *log,
-		  xlog_in_core_t *iclog,
-		  int		 count,
-		  boolean_t	 syncing)
+xlog_verify_iclog(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	int			count,
+	boolean_t		syncing)
 {
 	xlog_op_header_t	*ophead;
 	xlog_in_core_t		*icptr;
@@ -3481,7 +3531,7 @@ xlog_verify_iclog(xlog_t	 *log,
  */
 STATIC int
 xlog_state_ioerror(
-	xlog_t	*log)
+	struct xlog	*log)
 {
 	xlog_in_core_t	*iclog, *ic;
 
@@ -3526,7 +3576,7 @@ xfs_log_force_umount(
 	struct xfs_mount	*mp,
 	int			logerror)
 {
-	xlog_t		*log;
+	struct xlog	*log;
 	int		retval;
 
 	log = mp->m_log;
@@ -3633,7 +3683,8 @@ xfs_log_force_umount(
 }
 
 STATIC int
-xlog_iclogs_empty(xlog_t *log)
+xlog_iclogs_empty(
+	struct xlog	*log)
 {
 	xlog_in_core_t	*iclog;
 
Index: b/fs/xfs/xfs_log_priv.h
===================================================================
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -487,7 +487,7 @@ struct xlog_grant_head {
  * overflow 31 bits worth of byte offset, so using a byte number will mean
  * that round off problems won't occur when releasing partial reservations.
  */
-typedef struct xlog {
+struct xlog {
 	/* The following fields don't need locking */
 	struct xfs_mount	*l_mp;	        /* mount point */
 	struct xfs_ail		*l_ailp;	/* AIL log is working with */
@@ -540,7 +540,7 @@ typedef struct xlog {
 	char			*l_iclog_bak[XLOG_MAX_ICLOGS];
 #endif
 
-} xlog_t;
+};
 
 #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
 	((log)->l_buf_cancel_table + ((__uint64_t)blkno % XLOG_BC_TABLE_SIZE))
@@ -548,9 +548,17 @@ typedef struct xlog {
 #define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
 
 /* common routines */
-extern int	 xlog_recover(xlog_t *log);
-extern int	 xlog_recover_finish(xlog_t *log);
-extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
+extern int
+xlog_recover(
+	struct xlog		*log);
+extern int
+xlog_recover_finish(
+	struct xlog		*log);
+extern void
+xlog_pack_data(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	int);
 
 extern kmem_zone_t *xfs_log_ticket_zone;
 struct xlog_ticket *
Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -43,10 +43,18 @@
 #include "xfs_utils.h"
 #include "xfs_trace.h"
 
-STATIC int	xlog_find_zeroed(xlog_t *, xfs_daddr_t *);
-STATIC int	xlog_clear_stale_blocks(xlog_t *, xfs_lsn_t);
+STATIC int
+xlog_find_zeroed(
+	struct xlog	*,
+	xfs_daddr_t	*);
+STATIC int
+xlog_clear_stale_blocks(
+	struct xlog	*,
+	xfs_lsn_t);
 #if defined(DEBUG)
-STATIC void	xlog_recover_check_summary(xlog_t *);
+STATIC void
+xlog_recover_check_summary(
+	struct xlog *);
 #else
 #define	xlog_recover_check_summary(log)
 #endif
@@ -74,7 +82,7 @@ struct xfs_buf_cancel {
 
 static inline int
 xlog_buf_bbcount_valid(
-	xlog_t		*log,
+	struct xlog	*log,
 	int		bbcount)
 {
 	return bbcount > 0 && bbcount <= log->l_logBBsize;
@@ -87,7 +95,7 @@ xlog_buf_bbcount_valid(
  */
 STATIC xfs_buf_t *
 xlog_get_bp(
-	xlog_t		*log,
+	struct xlog	*log,
 	int		nbblks)
 {
 	struct xfs_buf	*bp;
@@ -138,10 +146,10 @@ xlog_put_bp(
  */
 STATIC xfs_caddr_t
 xlog_align(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
-	xfs_buf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	xfs_daddr_t	offset = blk_no & ((xfs_daddr_t)log->l_sectBBsize - 1);
 
@@ -155,10 +163,10 @@ xlog_align(
  */
 STATIC int
 xlog_bread_noalign(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
-	xfs_buf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	int		error;
 
@@ -189,10 +197,10 @@ xlog_bread_noalign(
 
 STATIC int
 xlog_bread(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
-	xfs_buf_t	*bp,
+	struct xfs_buf	*bp,
 	xfs_caddr_t	*offset)
 {
 	int		error;
@@ -211,10 +219,10 @@ xlog_bread(
  */
 STATIC int
 xlog_bread_offset(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	blk_no,		/* block to read from */
 	int		nbblks,		/* blocks to read */
-	xfs_buf_t	*bp,
+	struct xfs_buf	*bp,
 	xfs_caddr_t	offset)
 {
 	xfs_caddr_t	orig_offset = bp->b_addr;
@@ -241,10 +249,10 @@ xlog_bread_offset(
  */
 STATIC int
 xlog_bwrite(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
-	xfs_buf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	int		error;
 
@@ -378,8 +386,8 @@ xlog_recover_iodone(
  */
 STATIC int
 xlog_find_cycle_start(
-	xlog_t		*log,
-	xfs_buf_t	*bp,
+	struct xlog	*log,
+	struct xfs_buf	*bp,
 	xfs_daddr_t	first_blk,
 	xfs_daddr_t	*last_blk,
 	uint		cycle)
@@ -421,7 +429,7 @@ xlog_find_cycle_start(
  */
 STATIC int
 xlog_find_verify_cycle(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	start_blk,
 	int		nbblks,
 	uint		stop_on_cycle_no,
@@ -490,7 +498,7 @@ out:
  */
 STATIC int
 xlog_find_verify_log_record(
-	xlog_t			*log,
+	struct xlog		*log,
 	xfs_daddr_t		start_blk,
 	xfs_daddr_t		*last_blk,
 	int			extra_bblks)
@@ -600,7 +608,7 @@ out:
  */
 STATIC int
 xlog_find_head(
-	xlog_t 		*log,
+	struct xlog	*log,
 	xfs_daddr_t	*return_head_blk)
 {
 	xfs_buf_t	*bp;
@@ -871,7 +879,7 @@ validate_head:
  */
 STATIC int
 xlog_find_tail(
-	xlog_t			*log,
+	struct xlog		*log,
 	xfs_daddr_t		*head_blk,
 	xfs_daddr_t		*tail_blk)
 {
@@ -1080,7 +1088,7 @@ done:
  */
 STATIC int
 xlog_find_zeroed(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	*blk_no)
 {
 	xfs_buf_t	*bp;
@@ -1183,7 +1191,7 @@ bp_err:
  */
 STATIC void
 xlog_add_record(
-	xlog_t			*log,
+	struct xlog		*log,
 	xfs_caddr_t		buf,
 	int			cycle,
 	int			block,
@@ -1205,7 +1213,7 @@ xlog_add_record(
 
 STATIC int
 xlog_write_log_records(
-	xlog_t		*log,
+	struct xlog	*log,
 	int		cycle,
 	int		start_block,
 	int		blocks,
@@ -1305,7 +1313,7 @@ xlog_write_log_records(
  */
 STATIC int
 xlog_clear_stale_blocks(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_lsn_t	tail_lsn)
 {
 	int		tail_cycle, head_cycle;
@@ -2050,11 +2058,11 @@ xfs_qm_dqcheck(
  */
 STATIC void
 xlog_recover_do_dquot_buffer(
-	xfs_mount_t		*mp,
-	xlog_t			*log,
-	xlog_recover_item_t	*item,
-	xfs_buf_t		*bp,
-	xfs_buf_log_format_t	*buf_f)
+	struct xfs_mount		*mp,
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f)
 {
 	uint			type;
 
@@ -2108,9 +2116,9 @@ xlog_recover_do_dquot_buffer(
  */
 STATIC int
 xlog_recover_buffer_pass2(
-	xlog_t			*log,
-	struct list_head	*buffer_list,
-	xlog_recover_item_t	*item)
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item)
 {
 	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
 	xfs_mount_t		*mp = log->l_mp;
@@ -2189,9 +2197,9 @@ xlog_recover_buffer_pass2(
 
 STATIC int
 xlog_recover_inode_pass2(
-	xlog_t			*log,
-	struct list_head	*buffer_list,
-	xlog_recover_item_t	*item)
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item)
 {
 	xfs_inode_log_format_t	*in_f;
 	xfs_mount_t		*mp = log->l_mp;
@@ -2452,14 +2460,14 @@ error:
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
-	xlog_recover_item_t	*item)
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
 {
 	xfs_qoff_logformat_t	*qoff_f = item->ri_buf[0].i_addr;
 	ASSERT(qoff_f);
@@ -2483,9 +2491,9 @@ xlog_recover_quotaoff_pass1(
  */
 STATIC int
 xlog_recover_dquot_pass2(
-	xlog_t			*log,
-	struct list_head	*buffer_list,
-	xlog_recover_item_t	*item)
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item)
 {
 	xfs_mount_t		*mp = log->l_mp;
 	xfs_buf_t		*bp;
@@ -2578,9 +2586,9 @@ xlog_recover_dquot_pass2(
  */
 STATIC int
 xlog_recover_efi_pass2(
-	xlog_t			*log,
-	xlog_recover_item_t	*item,
-	xfs_lsn_t		lsn)
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
 {
 	int			error;
 	xfs_mount_t		*mp = log->l_mp;
@@ -2616,8 +2624,8 @@ xlog_recover_efi_pass2(
  */
 STATIC int
 xlog_recover_efd_pass2(
-	xlog_t			*log,
-	xlog_recover_item_t	*item)
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
 {
 	xfs_efd_log_format_t	*efd_formatp;
 	xfs_efi_log_item_t	*efip = NULL;
@@ -2812,9 +2820,9 @@ xlog_recover_unmount_trans(
  */
 STATIC int
 xlog_recover_process_data(
-	xlog_t			*log,
+	struct xlog		*log,
 	struct hlist_head	rhash[],
-	xlog_rec_header_t	*rhead,
+	struct xlog_rec_header	*rhead,
 	xfs_caddr_t		dp,
 	int			pass)
 {
@@ -2986,7 +2994,7 @@ abort_error:
  */
 STATIC int
 xlog_recover_process_efis(
-	xlog_t			*log)
+	struct xlog	*log)
 {
 	xfs_log_item_t		*lip;
 	xfs_efi_log_item_t	*efip;
@@ -3147,7 +3155,7 @@ xlog_recover_process_one_iunlink(
  */
 STATIC void
 xlog_recover_process_iunlinks(
-	xlog_t		*log)
+	struct xlog	*log)
 {
 	xfs_mount_t	*mp;
 	xfs_agnumber_t	agno;
@@ -3209,9 +3217,9 @@ xlog_recover_process_iunlinks(
 #ifdef DEBUG
 STATIC void
 xlog_pack_data_checksum(
-	xlog_t		*log,
-	xlog_in_core_t	*iclog,
-	int		size)
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	int			size)
 {
 	int		i;
 	__be32		*up;
@@ -3234,8 +3242,8 @@ xlog_pack_data_checksum(
  */
 void
 xlog_pack_data(
-	xlog_t			*log,
-	xlog_in_core_t		*iclog,
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
 	int			roundoff)
 {
 	int			i, j, k;
@@ -3274,9 +3282,9 @@ xlog_pack_data(
 
 STATIC void
 xlog_unpack_data(
-	xlog_rec_header_t	*rhead,
+	struct xlog_rec_header	*rhead,
 	xfs_caddr_t		dp,
-	xlog_t			*log)
+	struct xlog		*log)
 {
 	int			i, j, k;
 
@@ -3299,8 +3307,8 @@ xlog_unpack_data(
 
 STATIC int
 xlog_valid_rec_header(
-	xlog_t			*log,
-	xlog_rec_header_t	*rhead,
+	struct xlog		*log,
+	struct xlog_rec_header	*rhead,
 	xfs_daddr_t		blkno)
 {
 	int			hlen;
@@ -3343,7 +3351,7 @@ xlog_valid_rec_header(
  */
 STATIC int
 xlog_do_recovery_pass(
-	xlog_t			*log,
+	struct xlog		*log,
 	xfs_daddr_t		head_blk,
 	xfs_daddr_t		tail_blk,
 	int			pass)
@@ -3595,7 +3603,7 @@ xlog_do_recovery_pass(
  */
 STATIC int
 xlog_do_log_recovery(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	head_blk,
 	xfs_daddr_t	tail_blk)
 {
@@ -3646,7 +3654,7 @@ xlog_do_log_recovery(
  */
 STATIC int
 xlog_do_recover(
-	xlog_t		*log,
+	struct xlog	*log,
 	xfs_daddr_t	head_blk,
 	xfs_daddr_t	tail_blk)
 {
@@ -3721,7 +3729,7 @@ xlog_do_recover(
  */
 int
 xlog_recover(
-	xlog_t		*log)
+	struct xlog	*log)
 {
 	xfs_daddr_t	head_blk, tail_blk;
 	int		error;
@@ -3767,7 +3775,7 @@ xlog_recover(
  */
 int
 xlog_recover_finish(
-	xlog_t		*log)
+	struct xlog	*log)
 {
 	/*
 	 * Now we're ready to do the transactions needed for the
@@ -3814,7 +3822,7 @@ xlog_recover_finish(
  */
 void
 xlog_recover_check_summary(
-	xlog_t		*log)
+	struct xlog	*log)
 {
 	xfs_mount_t	*mp;
 	xfs_agf_t	*agfp;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
