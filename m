Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FFr7kJ061599 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 10:53:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D593142E949
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:54:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6bp21Wp5mYtdwIMz for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:54:43 -0700 (PDT)
Message-Id: <20100315155442.491694830@bombadil.infradead.org>
Date: Mon, 15 Mar 2010 11:51:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] xfs: factor xlog_write
References: <20100315155151.642965370@bombadil.infradead.org>
Content-Disposition: inline; filename=xlog_write-refactor
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

xlog_write is a mess that takes a lot of effort to understand. It is
a mass of nested loops with 4 space indents to get it to fit in 80 columns
and lots of funky variables that aren't obvious what they mean or do.

Break it down into understandable chunks.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-03-15 12:54:37.860004031 +0100
+++ xfs/fs/xfs/xfs_log.c	2010-03-15 12:56:54.180255392 +0100
@@ -1616,6 +1616,193 @@ xlog_print_tic_res(xfs_mount_t *mp, xlog
 }
 
 /*
+ * Calculate the potential space needed by the log vector.  Each region gets
+ * its own xlog_op_header_t and may need to be double word aligned.
+ */
+static int
+xlog_write_calc_vec_length(
+	struct xlog_ticket	*ticket,
+	struct xfs_log_iovec	reg[],
+	int			nentries)
+{
+	int			headers = 0;
+	int			len = 0;
+	int			i;
+
+	/* acct for start rec of xact */
+	if (ticket->t_flags & XLOG_TIC_INITED)
+		headers++;
+
+	for (i = 0; i < nentries; i++) {
+		/* each region gets >= 1 */
+		headers++;
+
+		len += reg[i].i_len;
+		xlog_tic_add_region(ticket, reg[i].i_len, reg[i].i_type);
+	}
+
+	ticket->t_res_num_ophdrs += headers;
+	len += headers * sizeof(struct xlog_op_header);
+
+	return len;
+}
+
+/*
+ * If first write for transaction, insert start record  We can't be trying to
+ * commit if we are inited.  We can't have any "partial_copy" if we are inited.
+ */
+static int
+xlog_write_start_rec(
+	__psint_t		ptr,
+	struct xlog_ticket	*ticket)
+{
+	struct xlog_op_header	*ophdr = (struct xlog_op_header *)ptr;
+
+	if (!(ticket->t_flags & XLOG_TIC_INITED))
+		return 0;
+
+	ophdr->oh_tid	= cpu_to_be32(ticket->t_tid);
+	ophdr->oh_clientid = ticket->t_clientid;
+	ophdr->oh_len = 0;
+	ophdr->oh_flags = XLOG_START_TRANS;
+	ophdr->oh_res2 = 0;
+
+	ticket->t_flags &= ~XLOG_TIC_INITED;
+
+	return sizeof(struct xlog_op_header);
+}
+
+static xlog_op_header_t *
+xlog_write_setup_ophdr(
+	struct log		*log,
+	__psint_t		ptr,
+	struct xlog_ticket	*ticket,
+	uint			flags)
+{
+	struct xlog_op_header	*ophdr = (struct xlog_op_header *)ptr;
+
+	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+	ophdr->oh_clientid = ticket->t_clientid;
+	ophdr->oh_res2 = 0;
+
+	/* are we copying a commit or unmount record? */
+	ophdr->oh_flags = flags;
+
+	/*
+	 * We've seen logs corrupted with bad transaction client ids.  This
+	 * makes sure that XFS doesn't generate them on.  Turn this into an EIO
+	 * and shut down the filesystem.
+	 */
+	switch (ophdr->oh_clientid)  {
+	case XFS_TRANSACTION:
+	case XFS_VOLUME:
+	case XFS_LOG:
+		break;
+	default:
+		xfs_fs_cmn_err(CE_WARN, log->l_mp,
+			"Bad XFS transaction clientid 0x%x in ticket 0x%p",
+			ophdr->oh_clientid, ticket);
+		return NULL;
+	}
+
+	return ophdr;
+}
+
+/*
+ * Set up the parameters of the region copy into the log. This has
+ * to handle region write split across multiple log buffers - this
+ * state is kept external to this function so that this code can
+ * can be written in an obvious, self documenting manner.
+ */
+static int
+xlog_write_setup_copy(
+	struct xlog_ticket	*ticket,
+	struct xlog_op_header	*ophdr,
+	int			space_available,
+	int			space_required,
+	int			*copy_off,
+	int			*copy_len,
+	int			*last_was_partial_copy,
+	int			*bytes_consumed)
+{
+	int			still_to_copy;
+
+	still_to_copy = space_required - *bytes_consumed;
+	*copy_off = *bytes_consumed;
+
+	if (still_to_copy <= space_available) {
+		/* write of region completes here */
+		*copy_len = still_to_copy;
+		ophdr->oh_len = cpu_to_be32(*copy_len);
+		if (*last_was_partial_copy)
+			ophdr->oh_flags|= (XLOG_END_TRANS|XLOG_WAS_CONT_TRANS);
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
+
+	/* account for new log op header */
+	ticket->t_curr_res -= sizeof(struct xlog_op_header);
+	ticket->t_res_num_ophdrs++;
+
+	return sizeof(struct xlog_op_header);
+}
+
+static int
+xlog_write_copy_finish(
+	struct log		*log,
+	struct xlog_in_core	*iclog,
+	uint			flags,
+	int			*record_cnt,
+	int			*data_cnt,
+	int			*partial_copy,
+	int			*partial_copy_len,
+	int			log_offset,
+	struct xlog_in_core	**commit_iclog)
+{
+	if (*partial_copy) {
+		/*
+		 * This iclog has already been marked WANT_SYNC by
+		 * xlog_state_get_iclog_space.
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
+
+	return 0;
+}
+
+/*
  * Write some region out to in-core log
  *
  * This will be called when writing externally provided regions or when
@@ -1675,7 +1862,6 @@ xlog_write(
     int		     start_rec_copy; /* # bytes to copy for start record */
     int		     partial_copy;   /* did we split a region? */
     int		     partial_copy_len;/* # bytes copied if split region */
-    int		     need_copy;	     /* # bytes need to memcpy this region */
     int		     copy_len;	     /* # bytes actually memcpy'ing */
     int		     copy_off;	     /* # bytes from entry start */
     int		     contwr;	     /* continued write of in-core log? */
@@ -1683,24 +1869,9 @@ xlog_write(
     int		     record_cnt = 0, data_cnt = 0;
 
     partial_copy_len = partial_copy = 0;
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
     contwr = *start_lsn = 0;
 
+    len = xlog_write_calc_vec_length(ticket, reg, nentries);
     if (ticket->t_curr_res < len) {
 	xlog_print_tic_res(mp, ticket);
 #ifdef DEBUG
@@ -1734,81 +1905,23 @@ xlog_write(
 	while (index < nentries) {
 	    ASSERT(reg[index].i_len % sizeof(__int32_t) == 0);
 	    ASSERT((__psint_t)ptr % sizeof(__int32_t) == 0);
-	    start_rec_copy = 0;
 
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
+	    start_rec_copy = xlog_write_start_rec(ptr, ticket);
+	    if (start_rec_copy) {
 		record_cnt++;
-
-		start_rec_copy = sizeof(xlog_op_header_t);
 		xlog_write_adv_cnt(ptr, len, log_offset, start_rec_copy);
 	    }
 
-	    /* Copy log operation header directly into data section */
-	    logop_head			= (xlog_op_header_t *)ptr;
-	    logop_head->oh_tid		= cpu_to_be32(ticket->t_tid);
-	    logop_head->oh_clientid	= ticket->t_clientid;
-	    logop_head->oh_res2		= 0;
-
-	    /* header copied directly */
+	    logop_head = xlog_write_setup_ophdr(log, ptr, ticket, flags);
+	    if (!logop_head)
+	    	return XFS_ERROR(EIO);
 	    xlog_write_adv_cnt(ptr, len, log_offset, sizeof(xlog_op_header_t));
 
-	    /* are we copying a commit or unmount record? */
-	    logop_head->oh_flags = flags;
-
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
-		xfs_fs_cmn_err(CE_WARN, mp,
-		    "Bad XFS transaction clientid 0x%x in ticket 0x%p",
-		    logop_head->oh_clientid, ticket);
-		return XFS_ERROR(EIO);
-	    }
-
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
+	    len += xlog_write_setup_copy(ticket, logop_head,
+	    				 iclog->ic_size - log_offset,
+					 reg[index].i_len, &copy_off,
+					 &copy_len, &partial_copy,
+					 &partial_copy_len);
 	    xlog_verify_dest_ptr(log, ptr);
 
 	    /* copy region */
@@ -1820,34 +1933,34 @@ xlog_write(
 	    copy_len += start_rec_copy + sizeof(xlog_op_header_t);
 	    record_cnt++;
 	    data_cnt += contwr ? copy_len : 0;
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
-		}
-	    } /* if (partial_copy) */
+
+	    error = xlog_write_copy_finish(log, iclog, flags,
+	    				   &record_cnt, &data_cnt,
+					   &partial_copy, &partial_copy_len,
+					   log_offset, commit_iclog);
+	    if (error)
+	    	return error;
+
+	    /*
+	     * if we had a partial copy, we need to get more iclog
+	     * space but we don't want to increment the region
+	     * index because there is still more is this region to write.
+	     *
+	     * If we completed writing this region, and we flushed
+	     * the iclog (indicated by resetting of the record
+	     * count), then we also need to get more log space. If
+	     * this was the last record, though, we are done and
+	     * can just return.
+	     */
+	    if (partial_copy)
+	    	break;
+
+	    index++;
+	    if (record_cnt == 0) {
+		if (index == nentries)
+		    return 0;
+		break;
+	    }
 	} /* while (index < nentries) */
     } /* for (index = 0; index < nentries; ) */
     ASSERT(len == 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
