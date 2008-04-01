Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 18:11:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m321Aoh0014887
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 18:11:08 -0700
Date: Wed, 2 Apr 2008 09:14:39 +1000
From: David Chinner <dgc@sgi.com>
Subject: [Patch] Remove xlog_ticket allocator
Message-ID: <20080401231439.GU103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Remove the xlog_ticket allocator

The ticket allocator is just a simple slab implementation
internal to the log. It requires the icloglock to be held
when manipulating it and this contributes to contention
on that lock.

Just kill the entire allocator and use a memory zone instead.
While there, allow us to gracefully fail allocation with ENOMEM.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_log.c      |  137 ++++----------------------------------------------
 fs/xfs/xfs_log_priv.h |    9 +--
 fs/xfs/xfs_vfsops.c   |   12 ++--
 fs/xfs/xfsidbg.c      |   11 +---
 4 files changed, 25 insertions(+), 144 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2008-03-13 13:58:08.866070224 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2008-03-13 14:03:38.448138656 +1100
@@ -41,6 +41,7 @@
 #include "xfs_inode.h"
 #include "xfs_rw.h"
 
+kmem_zone_t	*xfs_log_ticket_zone;
 
 #define xlog_write_adv_cnt(ptr, len, off, bytes) \
 	{ (ptr) += (bytes); \
@@ -73,8 +74,6 @@ STATIC int  xlog_state_get_iclog_space(x
 				       xlog_ticket_t	*ticket,
 				       int		*continued_write,
 				       int		*logoffsetp);
-STATIC void xlog_state_put_ticket(xlog_t	*log,
-				  xlog_ticket_t *tic);
 STATIC int  xlog_state_release_iclog(xlog_t		*log,
 				     xlog_in_core_t	*iclog);
 STATIC void xlog_state_switch_iclogs(xlog_t		*log,
@@ -101,7 +100,6 @@ STATIC void xlog_ungrant_log_space(xlog_
 
 
 /* local ticket functions */
-STATIC void		xlog_state_ticket_alloc(xlog_t *log);
 STATIC xlog_ticket_t	*xlog_ticket_get(xlog_t *log,
 					 int	unit_bytes,
 					 int	count,
@@ -330,7 +328,7 @@ xfs_log_done(xfs_mount_t	*mp,
 		 */
 		xlog_trace_loggrant(log, ticket, "xfs_log_done: (non-permanent)");
 		xlog_ungrant_log_space(log, ticket);
-		xlog_state_put_ticket(log, ticket);
+		xlog_ticket_put(log, ticket);
 	} else {
 		xlog_trace_loggrant(log, ticket, "xfs_log_done: (permanent)");
 		xlog_regrant_reserve_log_space(log, ticket);
@@ -469,6 +467,8 @@ xfs_log_reserve(xfs_mount_t	 *mp,
 		/* may sleep if need to allocate more tickets */
 		internal_ticket = xlog_ticket_get(log, unit_bytes, cnt,
 						  client, flags);
+		if (!internal_ticket)
+			return XFS_ERROR(ENOMEM);
 		internal_ticket->t_trans_type = t_type;
 		*ticket = internal_ticket;
 		xlog_trace_loggrant(log, internal_ticket, 
@@ -693,7 +693,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		if (tic) {
 			xlog_trace_loggrant(log, tic, "unmount rec");
 			xlog_ungrant_log_space(log, tic);
-			xlog_state_put_ticket(log, tic);
+			xlog_ticket_put(log, tic);
 		}
 	} else {
 		/*
@@ -1208,7 +1208,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	spin_lock_init(&log->l_icloglock);
 	spin_lock_init(&log->l_grant_lock);
 	initnsema(&log->l_flushsema, 0, "ic-flush");
-	xlog_state_ticket_alloc(log);  /* wait until after icloglock inited */
 
 	/* log record size must be multiple of BBSIZE; see xlog_rec_header_t */
 	ASSERT((XFS_BUF_SIZE(bp) & BBMASK) == 0);
@@ -1541,7 +1540,6 @@ STATIC void
 xlog_dealloc_log(xlog_t *log)
 {
 	xlog_in_core_t	*iclog, *next_iclog;
-	xlog_ticket_t	*tic, *next_tic;
 	int		i;
 
 	iclog = log->l_iclog;
@@ -1562,22 +1560,6 @@ xlog_dealloc_log(xlog_t *log)
 	spinlock_destroy(&log->l_icloglock);
 	spinlock_destroy(&log->l_grant_lock);
 
-	/* XXXsup take a look at this again. */
-	if ((log->l_ticket_cnt != log->l_ticket_tcnt)  &&
-	    !XLOG_FORCED_SHUTDOWN(log)) {
-		xfs_fs_cmn_err(CE_WARN, log->l_mp,
-			"xlog_dealloc_log: (cnt: %d, total: %d)",
-			log->l_ticket_cnt, log->l_ticket_tcnt);
-		/* ASSERT(log->l_ticket_cnt == log->l_ticket_tcnt); */
-
-	} else {
-		tic = log->l_unmount_free;
-		while (tic) {
-			next_tic = tic->t_next;
-			kmem_free(tic, PAGE_SIZE);
-			tic = next_tic;
-		}
-	}
 	xfs_buf_free(log->l_xbuf);
 #ifdef XFS_LOG_TRACE
 	if (log->l_trace != NULL) {
@@ -2798,18 +2780,6 @@ xlog_ungrant_log_space(xlog_t	     *log,
 
 
 /*
- * Atomically put back used ticket.
- */
-STATIC void
-xlog_state_put_ticket(xlog_t	    *log,
-		      xlog_ticket_t *tic)
-{
-	spin_lock(&log->l_icloglock);
-	xlog_ticket_put(log, tic);
-	spin_unlock(&log->l_icloglock);
-}	/* xlog_state_put_ticket */
-
-/*
  * Flush iclog to disk if this is the last reference to the given iclog and
  * the WANT_SYNC bit is set.
  *
@@ -3179,92 +3149,19 @@ xlog_state_want_sync(xlog_t *log, xlog_i
  */
 
 /*
- *	Algorithm doesn't take into account page size. ;-(
- */
-STATIC void
-xlog_state_ticket_alloc(xlog_t *log)
-{
-	xlog_ticket_t	*t_list;
-	xlog_ticket_t	*next;
-	xfs_caddr_t	buf;
-	uint		i = (PAGE_SIZE / sizeof(xlog_ticket_t)) - 2;
-
-	/*
-	 * The kmem_zalloc may sleep, so we shouldn't be holding the
-	 * global lock.  XXXmiken: may want to use zone allocator.
-	 */
-	buf = (xfs_caddr_t) kmem_zalloc(PAGE_SIZE, KM_SLEEP);
-
-	spin_lock(&log->l_icloglock);
-
-	/* Attach 1st ticket to Q, so we can keep track of allocated memory */
-	t_list = (xlog_ticket_t *)buf;
-	t_list->t_next = log->l_unmount_free;
-	log->l_unmount_free = t_list++;
-	log->l_ticket_cnt++;
-	log->l_ticket_tcnt++;
-
-	/* Next ticket becomes first ticket attached to ticket free list */
-	if (log->l_freelist != NULL) {
-		ASSERT(log->l_tail != NULL);
-		log->l_tail->t_next = t_list;
-	} else {
-		log->l_freelist = t_list;
-	}
-	log->l_ticket_cnt++;
-	log->l_ticket_tcnt++;
-
-	/* Cycle through rest of alloc'ed memory, building up free Q */
-	for ( ; i > 0; i--) {
-		next = t_list + 1;
-		t_list->t_next = next;
-		t_list = next;
-		log->l_ticket_cnt++;
-		log->l_ticket_tcnt++;
-	}
-	t_list->t_next = NULL;
-	log->l_tail = t_list;
-	spin_unlock(&log->l_icloglock);
-}	/* xlog_state_ticket_alloc */
-
-
-/*
- * Put ticket into free list
- *
- * Assumption: log lock is held around this call.
+ * Free a used ticket.
  */
 STATIC void
 xlog_ticket_put(xlog_t		*log,
 		xlog_ticket_t	*ticket)
 {
 	sv_destroy(&ticket->t_sema);
-
-	/*
-	 * Don't think caching will make that much difference.  It's
-	 * more important to make debug easier.
-	 */
-#if 0
-	/* real code will want to use LIFO for caching */
-	ticket->t_next = log->l_freelist;
-	log->l_freelist = ticket;
-	/* no need to clear fields */
-#else
-	/* When we debug, it is easier if tickets are cycled */
-	ticket->t_next     = NULL;
-	if (log->l_tail) {
-		log->l_tail->t_next = ticket;
-	} else {
-		ASSERT(log->l_freelist == NULL);
-		log->l_freelist = ticket;
-	}
-	log->l_tail	    = ticket;
-#endif /* DEBUG */
-	log->l_ticket_cnt++;
+	kmem_zone_free(xfs_log_ticket_zone, ticket);
 }	/* xlog_ticket_put */
 
 
 /*
- * Grab ticket off freelist or allocation some more
+ * Allocate and initialise a new log ticket.
  */
 STATIC xlog_ticket_t *
 xlog_ticket_get(xlog_t		*log,
@@ -3276,21 +3173,9 @@ xlog_ticket_get(xlog_t		*log,
 	xlog_ticket_t	*tic;
 	uint		num_headers;
 
- alloc:
-	if (log->l_freelist == NULL)
-		xlog_state_ticket_alloc(log);		/* potentially sleep */
-
-	spin_lock(&log->l_icloglock);
-	if (log->l_freelist == NULL) {
-		spin_unlock(&log->l_icloglock);
-		goto alloc;
-	}
-	tic		= log->l_freelist;
-	log->l_freelist	= tic->t_next;
-	if (log->l_freelist == NULL)
-		log->l_tail = NULL;
-	log->l_ticket_cnt--;
-	spin_unlock(&log->l_icloglock);
+	tic = kmem_zone_zalloc(xfs_log_ticket_zone, KM_SLEEP|KM_MAYFAIL);
+	if (!tic)
+		return NULL;
 
 	/*
 	 * Permanent reservations have up to 'cnt'-1 active log operations
Index: 2.6.x-xfs-new/fs/xfs/xfs_log_priv.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log_priv.h	2008-03-13 13:59:10.806160556 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_log_priv.h	2008-03-13 14:06:58.110733971 +1100
@@ -242,7 +242,7 @@ typedef struct xlog_res {
 
 typedef struct xlog_ticket {
 	sv_t		   t_sema;	 /* sleep on this semaphore      : 20 */
- 	struct xlog_ticket *t_next;	 /*			         :4|8 */
+	struct xlog_ticket *t_next;	 /*			         :4|8 */
 	struct xlog_ticket *t_prev;	 /*				 :4|8 */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
 	int		   t_curr_res;	 /* current reservation in bytes : 4  */
@@ -406,13 +406,8 @@ typedef struct log {
 	sema_t			l_flushsema;    /* iclog flushing semaphore */
 	int			l_flushcnt;	/* # of procs waiting on this
 						 * sema */
-	int			l_ticket_cnt;	/* free ticket count */
-	int			l_ticket_tcnt;	/* total ticket count */
 	int			l_covered_state;/* state of "covering disk
 						 * log entries" */
-	xlog_ticket_t		*l_freelist;    /* free list of tickets */
-	xlog_ticket_t		*l_unmount_free;/* kmem_free these addresses */
-	xlog_ticket_t		*l_tail;        /* free list of tickets */
 	xlog_in_core_t		*l_iclog;       /* head log queue	*/
 	spinlock_t		l_icloglock;    /* grab to change iclog state */
 	xfs_lsn_t		l_tail_lsn;     /* lsn of 1st LR with unflushed
@@ -478,6 +473,8 @@ extern struct xfs_buf *xlog_get_bp(xlog_
 extern void	 xlog_put_bp(struct xfs_buf *);
 extern int	 xlog_bread(xlog_t *, xfs_daddr_t, int, struct xfs_buf *);
 
+extern kmem_zone_t	*xfs_log_ticket_zone;
+
 /* iclog tracing */
 #define XLOG_TRACE_GRAB_FLUSH  1
 #define XLOG_TRACE_REL_FLUSH   2
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2008-03-13 13:58:08.866070224 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2008-03-13 13:59:59.208010688 +1100
@@ -68,15 +68,17 @@ xfs_init(void)
 	/*
 	 * Initialize all of the zone allocators we use.
 	 */
+	xfs_log_ticket_zone = kmem_zone_init(sizeof(xlog_ticket_t),
+						"xfs_log_ticket");
 	xfs_bmap_free_item_zone = kmem_zone_init(sizeof(xfs_bmap_free_item_t),
-						 "xfs_bmap_free_item");
+						"xfs_bmap_free_item");
 	xfs_btree_cur_zone = kmem_zone_init(sizeof(xfs_btree_cur_t),
-					    "xfs_btree_cur");
-	xfs_trans_zone = kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");
-	xfs_da_state_zone =
-		kmem_zone_init(sizeof(xfs_da_state_t), "xfs_da_state");
+						"xfs_btree_cur");
+	xfs_da_state_zone = kmem_zone_init(sizeof(xfs_da_state_t),
+						"xfs_da_state");
 	xfs_dabuf_zone = kmem_zone_init(sizeof(xfs_dabuf_t), "xfs_dabuf");
 	xfs_ifork_zone = kmem_zone_init(sizeof(xfs_ifork_t), "xfs_ifork");
+	xfs_trans_zone = kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");
 	xfs_acl_zone_init(xfs_acl_zone, "xfs_acl");
 	xfs_mru_cache_init();
 	xfs_filestream_init();
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2008-03-13 13:07:25.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2008-03-13 14:10:13.489855395 +1100
@@ -5607,9 +5607,9 @@ xfsidbg_xiclog(xlog_in_core_t *iclog)
 		be32_to_cpu(iclog->ic_header.h_magicno),
 		be32_to_cpu(iclog->ic_header.h_cycle),
 		be32_to_cpu(iclog->ic_header.h_version),
-		be64_to_cpu(iclog->ic_header.h_lsn));
+		(unsigned long long)be64_to_cpu(iclog->ic_header.h_lsn));
 	kdb_printf("tail_lsn: 0x%Lx  len: %d  prev_block: %d  num_ops: %d\n",
-		be64_to_cpu(iclog->ic_header.h_tail_lsn),
+		(unsigned long long)be64_to_cpu(iclog->ic_header.h_tail_lsn),
 		be32_to_cpu(iclog->ic_header.h_len),
 		be32_to_cpu(iclog->ic_header.h_prev_block),
 		be32_to_cpu(iclog->ic_header.h_num_logops));
@@ -5829,11 +5829,8 @@ xfsidbg_xlog(xlog_t *log)
 	};
 
 	kdb_printf("xlog at 0x%p\n", log);
-	kdb_printf("&flushsm: 0x%p  flushcnt: %d tic_cnt: %d	 tic_tcnt: %d  \n",
-		&log->l_flushsema, log->l_flushcnt,
-		log->l_ticket_cnt, log->l_ticket_tcnt);
-	kdb_printf("freelist: 0x%p  tail: 0x%p	ICLOG: 0x%p  \n",
-		log->l_freelist, log->l_tail, log->l_iclog);
+	kdb_printf("&flushsm: 0x%p  flushcnt: %d  ICLOG: 0x%p  \n",
+		&log->l_flushsema, log->l_flushcnt, log->l_iclog);
 	kdb_printf("&icloglock: 0x%p  tail_lsn: %s  last_sync_lsn: %s \n",
 		&log->l_icloglock, xfs_fmtlsn(&log->l_tail_lsn),
 		xfs_fmtlsn(&log->l_last_sync_lsn));
