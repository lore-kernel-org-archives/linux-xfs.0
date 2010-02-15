Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1FNXb17097926 for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 17:33:37 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46C901CD1D45
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 15:34:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id pbGDsm4z0svwWpvR for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2010 15:34:55 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NhASs-0007WY-TH
	for xfs@oss.sgi.com; Mon, 15 Feb 2010 23:34:54 +0000
Date: Mon, 15 Feb 2010 18:34:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: stop passing opaque handles to xfs_log.c routines
Message-ID: <20100215233454.GB28817@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Currenly we pass opaque xfs_log_ticket_t handles instead of struct
xlog_ticket pointers, and void pointers instead of struct xlog_in_core
pointers to various log manager functions.  Instead pass properly
typed pointers after adding forward declarations for them to
xfs_log.h, and adjust the touched function prototypes to the standard
XFS style while at it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-02-15 16:01:08.401004450 +0100
+++ xfs/fs/xfs/xfs_log.c	2010-02-15 16:19:03.710254904 +0100
@@ -60,7 +60,7 @@ STATIC int	 xlog_space_left(xlog_t *log,
 STATIC int	 xlog_sync(xlog_t *log, xlog_in_core_t *iclog);
 STATIC void	 xlog_dealloc_log(xlog_t *log);
 STATIC int	 xlog_write(xfs_mount_t *mp, xfs_log_iovec_t region[],
-			    int nentries, xfs_log_ticket_t tic,
+			    int nentries, struct xlog_ticket *tic,
 			    xfs_lsn_t *start_lsn,
 			    xlog_in_core_t **commit_iclog,
 			    uint flags);
@@ -243,14 +243,14 @@ xlog_tic_add_region(xlog_ticket_t *tic, 
  * out when the next write occurs.
  */
 xfs_lsn_t
-xfs_log_done(xfs_mount_t	*mp,
-	     xfs_log_ticket_t	xtic,
-	     void		**iclog,
-	     uint		flags)
-{
-	xlog_t		*log    = mp->m_log;
-	xlog_ticket_t	*ticket = (xfs_log_ticket_t) xtic;
-	xfs_lsn_t	lsn	= 0;
+xfs_log_done(
+	struct xfs_mount	*mp,
+	struct xlog_ticket	*ticket,
+	struct xlog_in_core	**iclog,
+	uint			flags)
+{
+	struct log		*log = mp->m_log;
+	xfs_lsn_t		lsn = 0;
 
 	if (XLOG_FORCED_SHUTDOWN(log) ||
 	    /*
@@ -258,8 +258,7 @@ xfs_log_done(xfs_mount_t	*mp,
 	     * If we get an error, just continue and give back the log ticket.
 	     */
 	    (((ticket->t_flags & XLOG_TIC_INITED) == 0) &&
-	     (xlog_commit_record(mp, ticket,
-				 (xlog_in_core_t **)iclog, &lsn)))) {
+	     (xlog_commit_record(mp, ticket, iclog, &lsn)))) {
 		lsn = (xfs_lsn_t) -1;
 		if (ticket->t_flags & XLOG_TIC_PERM_RESERV) {
 			flags |= XFS_LOG_REL_PERM_RESERV;
@@ -289,7 +288,7 @@ xfs_log_done(xfs_mount_t	*mp,
 	}
 
 	return lsn;
-}	/* xfs_log_done */
+}
 
 /*
  * Attaches a new iclog I/O completion callback routine during
@@ -298,11 +297,11 @@ xfs_log_done(xfs_mount_t	*mp,
  * executing the callback at an appropriate time.
  */
 int
-xfs_log_notify(xfs_mount_t	  *mp,		/* mount of partition */
-	       void		  *iclog_hndl,	/* iclog to hang callback off */
-	       xfs_log_callback_t *cb)
+xfs_log_notify(
+	struct xfs_mount	*mp,
+	struct xlog_in_core	*iclog,
+	xfs_log_callback_t	*cb)
 {
-	xlog_in_core_t	  *iclog = (xlog_in_core_t *)iclog_hndl;
 	int	abortflg;
 
 	spin_lock(&iclog->ic_callback_lock);
@@ -316,16 +315,14 @@ xfs_log_notify(xfs_mount_t	  *mp,		/* mo
 	}
 	spin_unlock(&iclog->ic_callback_lock);
 	return abortflg;
-}	/* xfs_log_notify */
+}
 
 int
-xfs_log_release_iclog(xfs_mount_t *mp,
-		      void	  *iclog_hndl)
+xfs_log_release_iclog(
+	struct xfs_mount	*mp,
+	struct xlog_in_core	*iclog)
 {
-	xlog_t *log = mp->m_log;
-	xlog_in_core_t	  *iclog = (xlog_in_core_t *)iclog_hndl;
-
-	if (xlog_state_release_iclog(log, iclog)) {
+	if (xlog_state_release_iclog(mp->m_log, iclog)) {
 		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 		return EIO;
 	}
@@ -344,17 +341,18 @@ xfs_log_release_iclog(xfs_mount_t *mp,
  * reservation, we prevent over allocation problems.
  */
 int
-xfs_log_reserve(xfs_mount_t	 *mp,
-		int		 unit_bytes,
-		int		 cnt,
-		xfs_log_ticket_t *ticket,
-		__uint8_t	 client,
-		uint		 flags,
-		uint		 t_type)
+xfs_log_reserve(
+	struct xfs_mount	*mp,
+	int		 	unit_bytes,
+	int		 	cnt,
+	struct xlog_ticket	**ticket,
+	__uint8_t	 	client,
+	uint		 	flags,
+	uint		 	t_type)
 {
-	xlog_t		*log = mp->m_log;
-	xlog_ticket_t	*internal_ticket;
-	int		retval = 0;
+	struct log		*log = mp->m_log;
+	struct xlog_ticket	*internal_ticket;
+	int			retval = 0;
 
 	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
 	ASSERT((flags & XFS_LOG_NOSLEEP) == 0);
@@ -367,7 +365,7 @@ xfs_log_reserve(xfs_mount_t	 *mp,
 
 	if (*ticket != NULL) {
 		ASSERT(flags & XFS_LOG_PERM_RESERV);
-		internal_ticket = (xlog_ticket_t *)*ticket;
+		internal_ticket = *ticket;
 
 		trace_xfs_log_reserve(log, internal_ticket);
 
@@ -519,7 +517,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	xlog_in_core_t	 *first_iclog;
 #endif
 	xfs_log_iovec_t  reg[1];
-	xfs_log_ticket_t tic = NULL;
+	xlog_ticket_t	*tic = NULL;
 	xfs_lsn_t	 lsn;
 	int		 error;
 
@@ -656,24 +654,24 @@ xfs_log_unmount(xfs_mount_t *mp)
  * transaction occur with one call to xfs_log_write().
  */
 int
-xfs_log_write(xfs_mount_t *	mp,
-	      xfs_log_iovec_t	reg[],
-	      int		nentries,
-	      xfs_log_ticket_t	tic,
-	      xfs_lsn_t		*start_lsn)
+xfs_log_write(
+	struct xfs_mount	*mp,
+	struct xfs_log_iovec	reg[],
+	int			nentries,
+	struct xlog_ticket	*tic,
+	xfs_lsn_t		*start_lsn)
 {
-	int	error;
-	xlog_t *log = mp->m_log;
+	struct log		*log = mp->m_log;
+	int			error;
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return XFS_ERROR(EIO);
 
-	if ((error = xlog_write(mp, reg, nentries, tic, start_lsn, NULL, 0))) {
+	error = xlog_write(mp, reg, nentries, tic, start_lsn, NULL, 0);
+	if (error)
 		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
-	}
 	return error;
-}	/* xfs_log_write */
-
+}
 
 void
 xfs_log_move_tail(xfs_mount_t	*mp,
@@ -1642,16 +1640,16 @@ xlog_print_tic_res(xfs_mount_t *mp, xlog
  *	bytes have been written out.
  */
 STATIC int
-xlog_write(xfs_mount_t *	mp,
-	   xfs_log_iovec_t	reg[],
-	   int			nentries,
-	   xfs_log_ticket_t	tic,
-	   xfs_lsn_t		*start_lsn,
-	   xlog_in_core_t	**commit_iclog,
-	   uint			flags)
+xlog_write(
+	struct xfs_mount	*mp,
+	struct xfs_log_iovec	reg[],
+	int			nentries,
+	struct xlog_ticket	*ticket,
+	xfs_lsn_t		*start_lsn,
+	struct xlog_in_core	**commit_iclog,
+	uint			flags)
 {
     xlog_t	     *log = mp->m_log;
-    xlog_ticket_t    *ticket = (xlog_ticket_t *)tic;
     xlog_in_core_t   *iclog = NULL;  /* ptr to current in-core log */
     xlog_op_header_t *logop_head;    /* ptr to log operation header */
     __psint_t	     ptr;	     /* copy address into data region */
@@ -1765,7 +1763,7 @@ xlog_write(xfs_mount_t *	mp,
 	    default:
 		xfs_fs_cmn_err(CE_WARN, mp,
 		    "Bad XFS transaction clientid 0x%x in ticket 0x%p",
-		    logop_head->oh_clientid, tic);
+		    logop_head->oh_clientid, ticket);
 		return XFS_ERROR(EIO);
 	    }
 
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2010-02-15 16:04:04.821253578 +0100
+++ xfs/fs/xfs/xfs_log.h	2010-02-15 16:17:49.702005288 +0100
@@ -110,8 +110,6 @@ typedef struct xfs_log_iovec {
 	uint		i_type;		/* type of region */
 } xfs_log_iovec_t;
 
-typedef void* xfs_log_ticket_t;
-
 /*
  * Structure used to pass callback function and the function's argument
  * to the log manager.
@@ -126,10 +124,12 @@ typedef struct xfs_log_callback {
 #ifdef __KERNEL__
 /* Log manager interfaces */
 struct xfs_mount;
+struct xlog_in_core;
 struct xlog_ticket;
+
 xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
-		       xfs_log_ticket_t ticket,
-		       void		**iclog,
+		       struct xlog_ticket *ticket,
+		       struct xlog_in_core **iclog,
 		       uint		flags);
 int	  _xfs_log_force(struct xfs_mount *mp,
 			 uint		flags,
@@ -151,21 +151,21 @@ int	  xfs_log_mount_finish(struct xfs_mo
 void	  xfs_log_move_tail(struct xfs_mount	*mp,
 			    xfs_lsn_t		tail_lsn);
 int	  xfs_log_notify(struct xfs_mount	*mp,
-			 void			*iclog,
+			 struct xlog_in_core	*iclog,
 			 xfs_log_callback_t	*callback_entry);
 int	  xfs_log_release_iclog(struct xfs_mount *mp,
-			 void			 *iclog_hndl);
+			 struct xlog_in_core	 *iclog);
 int	  xfs_log_reserve(struct xfs_mount *mp,
 			  int		   length,
 			  int		   count,
-			  xfs_log_ticket_t *ticket,
+			  struct xlog_ticket **ticket,
 			  __uint8_t	   clientid,
 			  uint		   flags,
 			  uint		   t_type);
 int	  xfs_log_write(struct xfs_mount *mp,
 			xfs_log_iovec_t  region[],
 			int		 nentries,
-			xfs_log_ticket_t ticket,
+			struct xlog_ticket *ticket,
 			xfs_lsn_t	 *start_lsn);
 int	  xfs_log_unmount_write(struct xfs_mount *mp);
 void      xfs_log_unmount(struct xfs_mount *mp);
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2010-02-15 16:03:47.325254137 +0100
+++ xfs/fs/xfs/xfs_trans.h	2010-02-15 16:03:58.259255254 +0100
@@ -910,7 +910,7 @@ typedef struct xfs_trans {
 	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
 	unsigned int		t_rtx_res;	/* # of rt extents resvd */
 	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
-	xfs_log_ticket_t	t_ticket;	/* log mgr ticket */
+	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
 	xfs_lsn_t		t_lsn;		/* log seq num of start of
 						 * transaction. */
 	xfs_lsn_t		t_commit_lsn;	/* log seq num of end of
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-02-15 16:00:43.396254066 +0100
+++ xfs/fs/xfs/xfs_trans.c	2010-02-15 16:21:36.924460729 +0100
@@ -796,7 +796,7 @@ _xfs_trans_commit(
 	int			sync;
 #define	XFS_TRANS_LOGVEC_COUNT	16
 	xfs_log_iovec_t		log_vector_fast[XFS_TRANS_LOGVEC_COUNT];
-	void			*commit_iclog;
+	struct xlog_in_core	*commit_iclog;
 	int			shutdown;
 
 	commit_lsn = -1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
