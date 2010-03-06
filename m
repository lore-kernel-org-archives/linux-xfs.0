Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o261oRZt041919 for <xfs@oss.sgi.com>; Fri, 5 Mar 2010 19:50:27 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09AB421F4C1
	for <xfs@oss.sgi.com>; Fri,  5 Mar 2010 17:51:51 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	XD3QdK9jBzaNDUVN for <xfs@oss.sgi.com>;
	Fri, 05 Mar 2010 17:51:51 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	16277272-1927428
	for <xfs@oss.sgi.com>; Sat, 06 Mar 2010 12:21:50 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NnjBE-0007SZ-1m
	for xfs@oss.sgi.com; Sat, 06 Mar 2010 12:51:48 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NnjB5-0001Eh-G9
	for xfs@oss.sgi.com; Sat, 06 Mar 2010 12:51:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 9/9] xfs: factor xlog_write and make use of new log vector
	structure
Date: Sat,  6 Mar 2010 12:51:24 +1100
Message-Id: <1267840284-4652-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1267840284-4652-1-git-send-email-david@fromorbit.com>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
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

xlog_write is a mess that takes a lot of effort to understand. It is
a mass of nested loops with 4 space indents to get it to fit in 80 columns
and lots of funky variables that aren't obvious what they mean or do.

Break it down into understandable chunks, format them properly and propagate
the new log vector structure into it to support chaining of log vectors.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c |  503 ++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 318 insertions(+), 185 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index afb27cf..38b4dc4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1632,6 +1632,193 @@ xlog_print_tic_res(xfs_mount_t *mp, xlog_ticket_t *ticket)
 }
 
 /*
+ * Calculate the potential space needed by the log vector.  Each region gets
+ * its own xlog_op_header_t and may need to be double word aligned. If regions
+ * get split, we'll account for the extra headers then.
+ */
+static int
+xlog_write_calc_vec_length(
+	struct xlog_ticket *ticket,
+	struct xfs_log_vec *log_vector)
+{
+	struct xfs_log_vec *lv;
+	int		headers = 0;
+	int		len = 0;
+	int		index;
+
+	if (ticket->t_flags & XLOG_TIC_INITED)
+		headers++;
+
+	for (lv = log_vector; lv; lv = lv->lv_next) {
+		struct xfs_log_iovec	*vecp;
+
+		headers += lv->lv_niovecs;
+		vecp = lv->lv_iovecp;
+		for (index = 0; index < lv->lv_niovecs; index++) {
+			len += vecp->i_len;
+			xlog_tic_add_region(ticket, vecp->i_len, vecp->i_type);
+			vecp++;
+		}
+	}
+
+	ticket->t_res_num_ophdrs += headers;
+	len += headers * sizeof(xlog_op_header_t);
+
+	return len;
+}
+
+/*
+ * If first write for transaction, insert start record.  We can't be trying to
+ * commit if we are inited.  We can't have any "partial_copy" if we are inited.
+ */
+static int
+xlog_write_start_rec(
+	__psint_t	ptr,
+	xlog_ticket_t	*ticket)
+{
+	xlog_op_header_t *logop_head;
+
+	if (!(ticket->t_flags & XLOG_TIC_INITED))
+		return 0;
+	logop_head = (xlog_op_header_t *)ptr;
+	logop_head->oh_tid = cpu_to_be32(ticket->t_tid);
+	logop_head->oh_clientid = ticket->t_clientid;
+	logop_head->oh_len = 0;
+	logop_head->oh_flags = XLOG_START_TRANS;
+	logop_head->oh_res2 = 0;
+	ticket->t_flags &= ~XLOG_TIC_INITED;
+	return sizeof(xlog_op_header_t);
+}
+
+static xlog_op_header_t *
+xlog_write_setup_ophdr(
+	struct log	*log,
+	__psint_t	ptr,
+	xlog_ticket_t	*ticket,
+	uint		flags)
+{
+	xlog_op_header_t *logop_head;
+
+	/* Copy log operation header directly into data section */
+	logop_head = (xlog_op_header_t *)ptr;
+	logop_head->oh_tid = cpu_to_be32(ticket->t_tid);
+	logop_head->oh_clientid = ticket->t_clientid;
+	logop_head->oh_res2 = 0;
+
+	/* are we copying a commit or unmount record? */
+	logop_head->oh_flags = flags;
+
+	/*
+	 * We've seen logs corrupted with bad transaction client ids.  This
+	 * makes sure that XFS doesn't generate them on.  Turn this into an EIO
+	 * and shut down the filesystem.
+	 */
+	switch (logop_head->oh_clientid)  {
+	case XFS_TRANSACTION:
+	case XFS_VOLUME:
+	case XFS_LOG:
+		break;
+	default:
+		xfs_fs_cmn_err(CE_WARN, log->l_mp,
+			"Bad XFS transaction clientid 0x%x in ticket 0x%p",
+			logop_head->oh_clientid, ticket);
+		return NULL;
+	}
+	return logop_head;
+}
+
+
+/*
+ * Set up the parameters of the region copy into the log. This has
+ * to handle region write split across multiple log buffers - this
+ * state is kept external to this function so that this code can
+ * can be written in an obvious, self documenting manner.
+ */
+static int
+xlog_write_setup_copy(
+	xlog_ticket_t	*ticket,
+	xlog_op_header_t *ophdr,
+	int		space_available,
+	int		space_required,
+	int		*copy_off,
+	int		*copy_len,
+	int		*last_was_partial_copy,
+	int		*bytes_consumed)
+{
+	int	still_to_copy;
+
+	still_to_copy = space_required - *bytes_consumed;
+	*copy_off = *bytes_consumed;
+
+	if (still_to_copy <= space_available) {
+		/* write of region completes here */
+		*copy_len = still_to_copy;
+		ophdr->oh_len = cpu_to_be32(*copy_len);
+		if (*last_was_partial_copy)
+			ophdr->oh_flags |= (XLOG_END_TRANS|XLOG_WAS_CONT_TRANS);
+		*last_was_partial_copy = 0;
+		*bytes_consumed = 0;
+		return 0;
+	}
+
+	/* partial write of region, needs extra log op header reservation */
+	*copy_len = space_available;
+	ophdr->oh_len = cpu_to_be32(*copy_len);
+	ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
+	if (*last_was_partial_copy)
+		ophdr->oh_flags |= XLOG_WAS_CONT_TRANS;
+	*bytes_consumed += *copy_len;
+	(*last_was_partial_copy)++;
+	ticket->t_curr_res -= sizeof(xlog_op_header_t);
+	ticket->t_res_num_ophdrs++;
+	return sizeof(xlog_op_header_t);
+}
+
+static int
+xlog_write_copy_finish(
+	xlog_t		*log,
+	xlog_in_core_t	*iclog,
+	uint		flags,
+	int		*record_cnt,
+	int		*data_cnt,
+	int		*partial_copy,
+	int		*partial_copy_len,
+	int		log_offset,
+	xlog_in_core_t	**commit_iclog)
+{
+	if (*partial_copy) {
+		/*
+		 * iclog has already been marked WANT_SYNC by
+		 * xlog_state_get_iclog_space
+		 */
+		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
+		*record_cnt = 0;
+		*data_cnt = 0;
+		return xlog_state_release_iclog(log, iclog);
+	}
+
+	*partial_copy = 0;
+	*partial_copy_len = 0;
+
+	if (iclog->ic_size - log_offset <= sizeof(xlog_op_header_t)) {
+		/* no more space in this iclog - push it. */
+		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
+		*record_cnt = 0;
+		*data_cnt = 0;
+
+		spin_lock(&log->l_icloglock);
+		xlog_state_want_sync(log, iclog);
+		spin_unlock(&log->l_icloglock);
+
+		if (!commit_iclog)
+			return xlog_state_release_iclog(log, iclog);
+		ASSERT(flags & XLOG_COMMIT_TRANS);
+		*commit_iclog = iclog;
+	}
+	return 0;
+}
+
+/*
  * Write some region out to in-core log
  *
  * This will be called when writing externally provided regions or when
@@ -1680,203 +1867,149 @@ xlog_write(
 	struct xlog_in_core	**commit_iclog,
 	uint			flags)
 {
-    xlog_in_core_t   *iclog = NULL;  /* ptr to current in-core log */
-    xlog_op_header_t *logop_head;    /* ptr to log operation header */
-    __psint_t	     ptr;	     /* copy address into data region */
-    int		     len;	     /* # xlog_write() bytes 2 still copy */
-    int		     index;	     /* region index currently copying */
-    int		     log_offset;     /* offset (from 0) into data region */
-    int		     start_rec_copy; /* # bytes to copy for start record */
-    int		     partial_copy;   /* did we split a region? */
-    int		     partial_copy_len;/* # bytes copied if split region */
-    int		     need_copy;	     /* # bytes need to memcpy this region */
-    int		     copy_len;	     /* # bytes actually memcpy'ing */
-    int		     copy_off;	     /* # bytes from entry start */
-    int		     contwr;	     /* continued write of in-core log? */
-    int		     error;
-    int		     record_cnt = 0, data_cnt = 0;
-    struct xfs_log_iovec *reg = log_vector->lv_iovecp;
-    int		     nentries = log_vector->lv_niovecs;
-
-    partial_copy_len = partial_copy = 0;
-
-    /* Calculate potential maximum space.  Each region gets its own
-     * xlog_op_header_t and may need to be double word aligned.
-     */
-    len = 0;
-    if (ticket->t_flags & XLOG_TIC_INITED) {    /* acct for start rec of xact */
-	len += sizeof(xlog_op_header_t);
-	ticket->t_res_num_ophdrs++;
-    }
-
-    for (index = 0; index < nentries; index++) {
-	len += sizeof(xlog_op_header_t);	    /* each region gets >= 1 */
-	ticket->t_res_num_ophdrs++;
-	len += reg[index].i_len;
-	xlog_tic_add_region(ticket, reg[index].i_len, reg[index].i_type);
-    }
-    contwr = *start_lsn = 0;
+	xlog_in_core_t	*iclog = NULL;  /* ptr to current in-core log */
+	xlog_op_header_t *logop_head;	/* ptr to log operation header */
+	struct xfs_log_iovec *vecp;
+	struct xfs_log_vec *lv;
+	__psint_t	ptr;		/* copy address into data region */
+	int		len = 0;	/* # xlog_write() bytes 2 still copy */
+	int		index;		/* region index currently copying */
+	int		log_offset;	/* offset (from 0) into data region */
+	int		start_rec_copy;	/* # bytes to copy for start record */
+	int		partial_copy;	/* did we split a region? */
+	int		partial_copy_len;/* # bytes copied if split region */
+	int		copy_len;	/* # bytes actually memcpy'ing */
+	int		copy_off;	/* # bytes from entry start */
+	int		contwr = 0;	/* continued write of in-core log? */
+	int		error = 0;
+	int		record_cnt = 0;
+	int		data_cnt = 0;
+
+	partial_copy_len = partial_copy = 0;
+	if (commit_iclog)
+		*commit_iclog = NULL;
+
+	len += xlog_write_calc_vec_length(ticket, log_vector);
 
-    if (ticket->t_curr_res < len) {
-	xlog_print_tic_res(log->l_mp, ticket);
+	ticket->t_curr_res -= len;
+	if (ticket->t_curr_res < 0) {
+		xlog_print_tic_res(log->l_mp, ticket);
 #ifdef DEBUG
-	xlog_panic(
-		"xfs_log_write: reservation ran out. Need to up reservation");
+		xlog_panic("xfs_log_write: "
+				"reservation ran out. Need to up reservation");
 #else
-	/* Customer configurable panic */
-	xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, log->l_mp,
-		"xfs_log_write: reservation ran out. Need to up reservation");
-	/* If we did not panic, shutdown the filesystem */
-	xfs_force_shutdown(log->l_mp, SHUTDOWN_CORRUPT_INCORE);
+		/* Customer configurable panic */
+		xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, log->l_mp,
+				"xfs_log_write: "
+				"reservation ran out. Need to up reservation");
+		/* If we did not panic, shutdown the filesystem */
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_CORRUPT_INCORE);
 #endif
-    } else
-	ticket->t_curr_res -= len;
-
-    for (index = 0; index < nentries; ) {
-	if ((error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
-					       &contwr, &log_offset)))
-		return error;
-
-	ASSERT(log_offset <= iclog->ic_size - 1);
-	ptr = (__psint_t) ((char *)iclog->ic_datap+log_offset);
+	}
 
-	/* start_lsn is the first lsn written to. That's all we need. */
-	if (! *start_lsn)
-	    *start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+	index = 0;
+	lv = log_vector;
+	vecp = lv->lv_iovecp;
+	while (lv && index < lv->lv_niovecs) {
 
-	/* This loop writes out as many regions as can fit in the amount
-	 * of space which was allocated by xlog_state_get_iclog_space().
-	 */
-	while (index < nentries) {
-	    ASSERT(reg[index].i_len % sizeof(__int32_t) == 0);
-	    ASSERT((__psint_t)ptr % sizeof(__int32_t) == 0);
-	    start_rec_copy = 0;
-
-	    /* If first write for transaction, insert start record.
-	     * We can't be trying to commit if we are inited.  We can't
-	     * have any "partial_copy" if we are inited.
-	     */
-	    if (ticket->t_flags & XLOG_TIC_INITED) {
-		logop_head		= (xlog_op_header_t *)ptr;
-		logop_head->oh_tid	= cpu_to_be32(ticket->t_tid);
-		logop_head->oh_clientid = ticket->t_clientid;
-		logop_head->oh_len	= 0;
-		logop_head->oh_flags    = XLOG_START_TRANS;
-		logop_head->oh_res2	= 0;
-		ticket->t_flags		&= ~XLOG_TIC_INITED;	/* clear bit */
-		record_cnt++;
-
-		start_rec_copy = sizeof(xlog_op_header_t);
-		xlog_write_adv_cnt(ptr, len, log_offset, start_rec_copy);
-	    }
+		error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
+						       &contwr, &log_offset);
+		if (error)
+			return error;
 
-	    /* Copy log operation header directly into data section */
-	    logop_head			= (xlog_op_header_t *)ptr;
-	    logop_head->oh_tid		= cpu_to_be32(ticket->t_tid);
-	    logop_head->oh_clientid	= ticket->t_clientid;
-	    logop_head->oh_res2		= 0;
+		ASSERT(log_offset <= iclog->ic_size - 1);
+		ptr = (__psint_t) ((char *)iclog->ic_datap + log_offset);
 
-	    /* header copied directly */
-	    xlog_write_adv_cnt(ptr, len, log_offset, sizeof(xlog_op_header_t));
+		/* start_lsn is the first lsn written to. That's all we need. */
+		if (start_lsn)
+			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 
-	    /* are we copying a commit or unmount record? */
-	    logop_head->oh_flags = flags;
+		/*
+		 * This loop writes out as many regions as can fit in the amount
+		 * of space which was allocated by xlog_state_get_iclog_space().
+		 */
+		while (lv && index < lv->lv_niovecs) {
+			struct xfs_log_iovec *reg = &vecp[index];
+
+			ASSERT(reg->i_len % sizeof(__int32_t) == 0);
+			ASSERT((__psint_t)ptr % sizeof(__int32_t) == 0);
+			start_rec_copy = 0;
+
+			start_rec_copy = xlog_write_start_rec(ptr, ticket);
+			if (start_rec_copy) {
+				record_cnt++;
+				xlog_write_adv_cnt(ptr, len, log_offset,
+							start_rec_copy);
+			}
 
-	    /*
-	     * We've seen logs corrupted with bad transaction client
-	     * ids.  This makes sure that XFS doesn't generate them on.
-	     * Turn this into an EIO and shut down the filesystem.
-	     */
-	    switch (logop_head->oh_clientid)  {
-	    case XFS_TRANSACTION:
-	    case XFS_VOLUME:
-	    case XFS_LOG:
-		break;
-	    default:
-		xfs_fs_cmn_err(CE_WARN, log->l_mp,
-		    "Bad XFS transaction clientid 0x%x in ticket 0x%p",
-		    logop_head->oh_clientid, ticket);
-		return XFS_ERROR(EIO);
-	    }
+			logop_head = xlog_write_setup_ophdr(log, ptr,
+							ticket, flags);
+			if (!logop_head)
+				return XFS_ERROR(EIO);
+			xlog_write_adv_cnt(ptr, len, log_offset,
+						sizeof(xlog_op_header_t));
+
+			len += xlog_write_setup_copy(ticket, logop_head,
+					iclog->ic_size - log_offset,
+					reg->i_len, &copy_off, &copy_len,
+					&partial_copy, &partial_copy_len);
+
+			xlog_verify_dest_ptr(log, ptr);
+
+			/* copy region */
+			ASSERT(copy_len >= 0);
+			memcpy((void *)ptr, reg->i_addr + copy_off, copy_len);
+			xlog_write_adv_cnt(ptr, len, log_offset, copy_len);
+
+			/* copy_len is total bytes copied, including headers */
+			copy_len += start_rec_copy + sizeof(xlog_op_header_t);
+			record_cnt++;
+			data_cnt += contwr ? copy_len : 0;
+
+			error = xlog_write_copy_finish(log, iclog, flags,
+					&record_cnt, &data_cnt,
+					&partial_copy, &partial_copy_len,
+					log_offset, commit_iclog);
+			if (error)
+				return error;
 
-	    /* Partial write last time? => (partial_copy != 0)
-	     * need_copy is the amount we'd like to copy if everything could
-	     * fit in the current memcpy.
-	     */
-	    need_copy =	reg[index].i_len - partial_copy_len;
-
-	    copy_off = partial_copy_len;
-	    if (need_copy <= iclog->ic_size - log_offset) { /*complete write */
-	        copy_len = need_copy;
-		logop_head->oh_len = cpu_to_be32(copy_len);
-		if (partial_copy)
-		    logop_head->oh_flags|= (XLOG_END_TRANS|XLOG_WAS_CONT_TRANS);
-		partial_copy_len = partial_copy = 0;
-	    } else {					    /* partial write */
-		copy_len = iclog->ic_size - log_offset;
-		logop_head->oh_len = cpu_to_be32(copy_len);
-		logop_head->oh_flags |= XLOG_CONTINUE_TRANS;
-		if (partial_copy)
-			logop_head->oh_flags |= XLOG_WAS_CONT_TRANS;
-		partial_copy_len += copy_len;
-		partial_copy++;
-		len += sizeof(xlog_op_header_t); /* from splitting of region */
-		/* account for new log op header */
-		ticket->t_curr_res -= sizeof(xlog_op_header_t);
-		ticket->t_res_num_ophdrs++;
-	    }
-	    xlog_verify_dest_ptr(log, ptr);
-
-	    /* copy region */
-	    ASSERT(copy_len >= 0);
-	    memcpy((xfs_caddr_t)ptr, reg[index].i_addr + copy_off, copy_len);
-	    xlog_write_adv_cnt(ptr, len, log_offset, copy_len);
-
-	    /* make copy_len total bytes copied, including headers */
-	    copy_len += start_rec_copy + sizeof(xlog_op_header_t);
-	    record_cnt++;
-	    data_cnt += contwr ? copy_len : 0;
-	    if (partial_copy) {			/* copied partial region */
-		    /* already marked WANT_SYNC by xlog_state_get_iclog_space */
-		    xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
-		    record_cnt = data_cnt = 0;
-		    if ((error = xlog_state_release_iclog(log, iclog)))
-			    return error;
-		    break;			/* don't increment index */
-	    } else {				/* copied entire region */
-		index++;
-		partial_copy_len = partial_copy = 0;
-
-		if (iclog->ic_size - log_offset <= sizeof(xlog_op_header_t)) {
-		    xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
-		    record_cnt = data_cnt = 0;
-		    spin_lock(&log->l_icloglock);
-		    xlog_state_want_sync(log, iclog);
-		    spin_unlock(&log->l_icloglock);
-		    if (commit_iclog) {
-			ASSERT(flags & XLOG_COMMIT_TRANS);
-			*commit_iclog = iclog;
-		    } else if ((error = xlog_state_release_iclog(log, iclog)))
-			   return error;
-		    if (index == nentries)
-			    return 0;		/* we are done */
-		    else
-			    break;
+			/*
+			 * if we had a partial copy, we need to get more iclog
+			 * space but we don't want to increment the region
+			 * index because there is still more is this region to
+			 * write.
+			 *
+			 * If we completed writing this region, and we flushed
+			 * the iclog (indicated by resetting of the record
+			 * count), then we also need to get more log space. If
+			 * this was the last record, though, we are done and
+			 * can just return.
+			 */
+			if (partial_copy)
+				break;
+			if (++index == lv->lv_niovecs) {
+				lv = lv->lv_next;
+				index = 0;
+				if (lv)
+					vecp = lv->lv_iovecp;
+			}
+			if (record_cnt == 0) {
+				if (!lv)
+					return 0; /* last region, done! */
+				break;
+			}
 		}
-	    } /* if (partial_copy) */
-	} /* while (index < nentries) */
-    } /* for (index = 0; index < nentries; ) */
-    ASSERT(len == 0);
-
-    xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
-    if (commit_iclog) {
-	ASSERT(flags & XLOG_COMMIT_TRANS);
-	*commit_iclog = iclog;
-	return 0;
-    }
-    return xlog_state_release_iclog(log, iclog);
-}	/* xlog_write */
+	}
+	ASSERT(len == 0);
 
+	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
+	if (commit_iclog) {
+		ASSERT(flags & XLOG_COMMIT_TRANS);
+		*commit_iclog = iclog;
+		return 0;
+	}
+	return xlog_state_release_iclog(log, iclog);
+}
 
 /*****************************************************************************
  *
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
