Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FFr8tX061617 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 10:53:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D254142E949
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:54:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lhRajKesEx0JkRat for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:54:43 -0700 (PDT)
Message-Id: <20100315155443.134658877@bombadil.infradead.org>
Date: Mon, 15 Mar 2010 11:51:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] xfs: introduce new internal log vector structure
References: <20100315155151.642965370@bombadil.infradead.org>
Content-Disposition: inline; filename=xlog-vectors
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
To: david@fromorbit.com
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The current log IO vector structure is a flat array and not
extensible. To make it possible to keep separate log IO vectors for
individual log items, we need a method of chaining log IO vectors
together.

Introduce a new log vector type that can be used to wrap the
existing log IO vectors on use that internally to the log. This
means that the existing external interface (xfs_log_write) does not
change and hence no changes to the transaction commit code are
required.
    
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-03-15 13:41:50.000000000 +0100
+++ xfs/fs/xfs/xfs_log.c	2010-03-15 13:43:23.056255602 +0100
@@ -50,7 +50,7 @@ kmem_zone_t	*xfs_log_ticket_zone;
 	  (off) += (bytes);}
 
 /* Local miscellaneous function prototypes */
-STATIC int	 xlog_commit_record(xfs_mount_t *mp, xlog_ticket_t *ticket,
+STATIC int	 xlog_commit_record(struct log *log, struct xlog_ticket *ticket,
 				    xlog_in_core_t **, xfs_lsn_t *);
 STATIC xlog_t *  xlog_alloc_log(xfs_mount_t	*mp,
 				xfs_buftarg_t	*log_target,
@@ -59,11 +59,9 @@ STATIC xlog_t *  xlog_alloc_log(xfs_moun
 STATIC int	 xlog_space_left(xlog_t *log, int cycle, int bytes);
 STATIC int	 xlog_sync(xlog_t *log, xlog_in_core_t *iclog);
 STATIC void	 xlog_dealloc_log(xlog_t *log);
-STATIC int	 xlog_write(xfs_mount_t *mp, xfs_log_iovec_t region[],
-			    int nentries, struct xlog_ticket *tic,
-			    xfs_lsn_t *start_lsn,
-			    xlog_in_core_t **commit_iclog,
-			    uint flags);
+STATIC int	 xlog_write(struct log *log, struct xfs_log_vec *log_vector,
+			    struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
+			    xlog_in_core_t **commit_iclog, uint flags);
 
 /* local state machine functions */
 STATIC void xlog_state_done_syncing(xlog_in_core_t *iclog, int);
@@ -258,7 +256,7 @@ xfs_log_done(
 	     * If we get an error, just continue and give back the log ticket.
 	     */
 	    (((ticket->t_flags & XLOG_TIC_INITED) == 0) &&
-	     (xlog_commit_record(mp, ticket, iclog, &lsn)))) {
+	     (xlog_commit_record(log, ticket, iclog, &lsn)))) {
 		lsn = (xfs_lsn_t) -1;
 		if (ticket->t_flags & XLOG_TIC_PERM_RESERV) {
 			flags |= XFS_LOG_REL_PERM_RESERV;
@@ -516,18 +514,10 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 #ifdef DEBUG
 	xlog_in_core_t	 *first_iclog;
 #endif
-	xfs_log_iovec_t  reg[1];
 	xlog_ticket_t	*tic = NULL;
 	xfs_lsn_t	 lsn;
 	int		 error;
 
-	/* the data section must be 32 bit size aligned */
-	struct {
-	    __uint16_t magic;
-	    __uint16_t pad1;
-	    __uint32_t pad2; /* may as well make it 64 bits */
-	} magic = { XLOG_UNMOUNT_TYPE, 0, 0 };
-
 	/*
 	 * Don't write out unmount record on read-only mounts.
 	 * Or, if we are doing a forced umount (typically because of IO errors).
@@ -549,16 +539,30 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	} while (iclog != first_iclog);
 #endif
 	if (! (XLOG_FORCED_SHUTDOWN(log))) {
-		reg[0].i_addr = (void*)&magic;
-		reg[0].i_len  = sizeof(magic);
-		reg[0].i_type = XLOG_REG_TYPE_UNMOUNT;
-
 		error = xfs_log_reserve(mp, 600, 1, &tic,
 					XFS_LOG, 0, XLOG_UNMOUNT_REC_TYPE);
 		if (!error) {
+			/* the data section must be 32 bit size aligned */
+			struct {
+			    __uint16_t magic;
+			    __uint16_t pad1;
+			    __uint32_t pad2; /* may as well make it 64 bits */
+			} magic = {
+				.magic = XLOG_UNMOUNT_TYPE,
+			};
+			struct xfs_log_iovec reg = {
+				.i_addr = (void *)&magic,
+				.i_len = sizeof(magic),
+				.i_type = XLOG_REG_TYPE_UNMOUNT,
+			};
+			struct xfs_log_vec vec = {
+				.lv_niovecs = 1,
+				.lv_iovecp = &reg,
+			};
+
 			/* remove inited flag */
-			((xlog_ticket_t *)tic)->t_flags = 0;
-			error = xlog_write(mp, reg, 1, tic, &lsn,
+			tic->t_flags = 0;
+			error = xlog_write(log, &vec, tic, &lsn,
 					   NULL, XLOG_UNMOUNT_TRANS);
 			/*
 			 * At this point, we're umounting anyway,
@@ -679,11 +683,15 @@ xfs_log_write(
 {
 	struct log		*log = mp->m_log;
 	int			error;
+	struct xfs_log_vec	vec = {
+		.lv_niovecs = nentries,
+		.lv_iovecp = reg,
+	};
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return XFS_ERROR(EIO);
 
-	error = xlog_write(mp, reg, nentries, tic, start_lsn, NULL, 0);
+	error = xlog_write(log, &vec, tic, start_lsn, NULL, 0);
 	if (error)
 		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
@@ -1176,26 +1184,31 @@ out:
  * ticket.  Return the lsn of the commit record.
  */
 STATIC int
-xlog_commit_record(xfs_mount_t  *mp,
-		   xlog_ticket_t *ticket,
-		   xlog_in_core_t **iclog,
-		   xfs_lsn_t	*commitlsnp)
+xlog_commit_record(
+	struct log		*log,
+	struct xlog_ticket	*ticket,
+	struct xlog_in_core	**iclog,
+	xfs_lsn_t		*commitlsnp)
 {
-	int		error;
-	xfs_log_iovec_t	reg[1];
-
-	reg[0].i_addr = NULL;
-	reg[0].i_len = 0;
-	reg[0].i_type = XLOG_REG_TYPE_COMMIT;
+	struct xfs_mount *mp = log->l_mp;
+	int	error;
+	struct xfs_log_iovec reg = {
+		.i_addr = NULL,
+		.i_len = 0,
+		.i_type = XLOG_REG_TYPE_COMMIT,
+	};
+	struct xfs_log_vec vec = {
+		.lv_niovecs = 1,
+		.lv_iovecp = &reg,
+	};
 
 	ASSERT_ALWAYS(iclog);
-	if ((error = xlog_write(mp, reg, 1, ticket, commitlsnp,
-			       iclog, XLOG_COMMIT_TRANS))) {
+	error = xlog_write(log, &vec, ticket, commitlsnp, iclog,
+					XLOG_COMMIT_TRANS);
+	if (error)
 		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
-	}
 	return error;
-}	/* xlog_commit_record */
-
+}
 
 /*
  * Push on the buffer cache code if we ever use more than 75% of the on-disk
@@ -1622,9 +1635,9 @@ xlog_print_tic_res(xfs_mount_t *mp, xlog
 static int
 xlog_write_calc_vec_length(
 	struct xlog_ticket	*ticket,
-	struct xfs_log_iovec	reg[],
-	int			nentries)
+	struct xfs_log_vec	*log_vector)
 {
+	struct xfs_log_vec	*lv;
 	int			headers = 0;
 	int			len = 0;
 	int			i;
@@ -1633,12 +1646,15 @@ xlog_write_calc_vec_length(
 	if (ticket->t_flags & XLOG_TIC_INITED)
 		headers++;
 
-	for (i = 0; i < nentries; i++) {
-		/* each region gets >= 1 */
-		headers++;
+	for (lv = log_vector; lv; lv = lv->lv_next) {
+		headers += lv->lv_niovecs;
+
+		for (i = 0; i < lv->lv_niovecs; i++) {
+			struct xfs_log_iovec	*vecp = &lv->lv_iovecp[i];
 
-		len += reg[i].i_len;
-		xlog_tic_add_region(ticket, reg[i].i_len, reg[i].i_type);
+			len += vecp->i_len;
+			xlog_tic_add_region(ticket, vecp->i_len, vecp->i_type);
+		}
 	}
 
 	ticket->t_res_num_ophdrs += headers;
@@ -1844,16 +1860,16 @@ xlog_write_copy_finish(
  */
 STATIC int
 xlog_write(
-	struct xfs_mount	*mp,
-	struct xfs_log_iovec	reg[],
-	int			nentries,
+	struct log		*log,
+	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*start_lsn,
 	struct xlog_in_core	**commit_iclog,
 	uint			flags)
 {
-	struct log		*log = mp->m_log;
 	struct xlog_in_core	*iclog = NULL;
+	struct xfs_log_iovec	*vecp;
+	struct xfs_log_vec	*lv;
 	int			len;
 	int			index;
 	int			partial_copy = 0;
@@ -1865,25 +1881,28 @@ xlog_write(
 
 	*start_lsn = 0;
 
-	len = xlog_write_calc_vec_length(ticket, reg, nentries);
+	len = xlog_write_calc_vec_length(ticket, log_vector);
 	if (ticket->t_curr_res < len) {
-		xlog_print_tic_res(mp, ticket);
+		xlog_print_tic_res(log->l_mp, ticket);
 #ifdef DEBUG
 		xlog_panic(
 	"xfs_log_write: reservation ran out. Need to up reservation");
 #else
 		/* Customer configurable panic */
-		xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, mp,
+		xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, log->l_mp,
 	"xfs_log_write: reservation ran out. Need to up reservation");
 
 		/* If we did not panic, shutdown the filesystem */
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_CORRUPT_INCORE);
 #endif
 	}
 
 	ticket->t_curr_res -= len;
 
-	for (index = 0; index < nentries; ) {
+	index = 0;
+	lv = log_vector;
+	vecp = lv->lv_iovecp;
+	while (lv && index < lv->lv_niovecs) {
 		__psint_t	ptr;
 		int		log_offset;
 
@@ -1903,13 +1922,14 @@ xlog_write(
 		 * This loop writes out as many regions as can fit in the amount
 		 * of space which was allocated by xlog_state_get_iclog_space().
 		 */
-		while (index < nentries) {
+		while (lv && index < lv->lv_niovecs) {
+			struct xfs_log_iovec	*reg = &vecp[index];
 			struct xlog_op_header	*ophdr;
 			int			start_rec_copy;
 			int			copy_len;
 			int     		copy_off;
 
-			ASSERT(reg[index].i_len % sizeof(__int32_t) == 0);
+			ASSERT(reg->i_len % sizeof(__int32_t) == 0);
 			ASSERT((__psint_t)ptr % sizeof(__int32_t) == 0);
 
 			start_rec_copy = xlog_write_start_rec(ptr, ticket);
@@ -1928,7 +1948,7 @@ xlog_write(
 
 			len += xlog_write_setup_copy(ticket, ophdr,
 						     iclog->ic_size-log_offset,
-						     reg[index].i_len,
+						     reg->i_len,
 						     &copy_off, &copy_len,
 						     &partial_copy,
 						     &partial_copy_len);
@@ -1936,7 +1956,7 @@ xlog_write(
 
 			/* copy region */
 			ASSERT(copy_len >= 0);
-			memcpy((xfs_caddr_t)ptr, reg[index].i_addr + copy_off,
+			memcpy((xfs_caddr_t)ptr, reg->i_addr + copy_off,
 			       copy_len);
 			xlog_write_adv_cnt(ptr, len, log_offset, copy_len);
 
@@ -1968,9 +1988,14 @@ xlog_write(
 			if (partial_copy)
 				break;
 
-			index++;
+			if (++index == lv->lv_niovecs) {
+				lv = lv->lv_next;
+				index = 0;
+				if (lv)
+					vecp = lv->lv_iovecp;
+			}
 			if (record_cnt == 0) {
-				if (index == nentries)
+				if (!lv)
 					return 0;
 				break;
 			}
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2010-03-15 13:41:44.000000000 +0100
+++ xfs/fs/xfs/xfs_log.h	2010-03-15 13:41:53.138032456 +0100
@@ -110,6 +110,12 @@ typedef struct xfs_log_iovec {
 	uint		i_type;		/* type of region */
 } xfs_log_iovec_t;
 
+struct xfs_log_vec {
+	struct xfs_log_vec	*lv_next;	/* next lv in build list */
+	int			lv_niovecs;	/* number of iovecs in lv */
+	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
+};
+
 /*
  * Structure used to pass callback function and the function's argument
  * to the log manager.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
