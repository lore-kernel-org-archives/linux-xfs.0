Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F7B0C4167B
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 05:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiCIFaq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 00:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiCIFap (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 00:30:45 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B7163D1E0
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 21:29:46 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id ABF1110E2685
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 16:29:40 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-003H5U-QJ
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 16:29:39 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-00BJXQ-OZ
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 16:29:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/16] xfs: introduce xlog_write_partial()
Date:   Wed,  9 Mar 2022 16:29:33 +1100
Message-Id: <20220309052937.2696447-13-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220309052937.2696447-1-david@fromorbit.com>
References: <20220309052937.2696447-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62283b45
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=H7cDGxPyYqgxfkR3S30A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Re-implement writing of a log vector that does not fit into the
current iclog. The iclog will already be in XLOG_STATE_WANT_SYNC
because xlog_get_iclog_space() will have reserved all the remaining
iclog space for us, hence we can simply iterate over the iovecs in
the log vector getting more iclog space until the entire log vector
is written.

Handling this partial write case separately means we do need to pass
unnecessary state around for the common, fast path case when the log
vector fits entirely within the current iclog. It isolates the
complexity and allows us to modify and improve the partial write
case without impacting the simple fast path.

This change includes several improvements incorporated from patches
written by Christoph Hellwig.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log.c      | 424 +++++++++++++++++++-----------------------
 fs/xfs/xfs_log_priv.h |   8 -
 2 files changed, 196 insertions(+), 236 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6d93b2c96262..7dd2bcc7819b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2260,7 +2260,8 @@ xlog_write_full(
 {
 	int			index;
 
-	ASSERT(*log_offset + *len <= iclog->ic_size);
+	ASSERT(*log_offset + *len <= iclog->ic_size ||
+		iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
 	/*
 	 * Ordered log vectors have no regions to write so this
@@ -2276,111 +2277,177 @@ xlog_write_full(
 	}
 }
 
-static xlog_op_header_t *
-xlog_write_setup_ophdr(
-	struct xlog_op_header	*ophdr,
-	struct xlog_ticket	*ticket)
+static int
+xlog_write_get_more_iclog_space(
+	struct xlog_ticket	*ticket,
+	struct xlog_in_core	**iclogp,
+	uint32_t		*log_offset,
+	uint32_t		len,
+	uint32_t		*record_cnt,
+	uint32_t		*data_cnt,
+	int			*contwr)
 {
-	ophdr->oh_clientid = XFS_TRANSACTION;
-	ophdr->oh_res2 = 0;
-	ophdr->oh_flags = 0;
-	return ophdr;
+	struct xlog_in_core	*iclog = *iclogp;
+	struct xlog		*log = iclog->ic_log;
+	int			error;
+
+	spin_lock(&log->l_icloglock);
+	ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC);
+	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
+	error = xlog_state_release_iclog(log, iclog, 0);
+	spin_unlock(&log->l_icloglock);
+	if (error)
+		return error;
+
+	error = xlog_state_get_iclog_space(log, len, &iclog,
+				ticket, contwr, log_offset);
+	if (error)
+		return error;
+	*record_cnt = 0;
+	*data_cnt = 0;
+	*iclogp = iclog;
+	return 0;
 }
 
 /*
- * Set up the parameters of the region copy into the log. This has
- * to handle region write split across multiple log buffers - this
- * state is kept external to this function so that this code can
- * be written in an obvious, self documenting manner.
+ * Write log vectors into a single iclog which is smaller than the current chain
+ * length. We write until we cannot fit a full record into the remaining space
+ * and then stop. We return the log vector that is to be written that cannot
+ * wholly fit in the iclog.
  */
 static int
-xlog_write_setup_copy(
+xlog_write_partial(
+	struct xfs_log_vec	*lv,
 	struct xlog_ticket	*ticket,
-	struct xlog_op_header	*ophdr,
-	int			space_available,
-	int			space_required,
-	int			*copy_off,
-	int			*copy_len,
-	int			*last_was_partial_copy,
-	int			*bytes_consumed)
-{
-	int			still_to_copy;
-
-	still_to_copy = space_required - *bytes_consumed;
-	*copy_off = *bytes_consumed;
-
-	if (still_to_copy <= space_available) {
-		/* write of region completes here */
-		*copy_len = still_to_copy;
-		ophdr->oh_len = cpu_to_be32(*copy_len);
-		if (*last_was_partial_copy)
-			ophdr->oh_flags |= (XLOG_END_TRANS|XLOG_WAS_CONT_TRANS);
-		*last_was_partial_copy = 0;
-		*bytes_consumed = 0;
-		return 0;
-	}
+	struct xlog_in_core	**iclogp,
+	uint32_t		*log_offset,
+	uint32_t		*len,
+	uint32_t		*record_cnt,
+	uint32_t		*data_cnt,
+	int			*contwr)
+{
+	struct xlog_in_core	*iclog = *iclogp;
+	struct xlog		*log = iclog->ic_log;
+	struct xlog_op_header	*ophdr;
+	int			index = 0;
+	uint32_t		rlen;
+	int			error;
 
-	/* partial write of region, needs extra log op header reservation */
-	*copy_len = space_available;
-	ophdr->oh_len = cpu_to_be32(*copy_len);
-	ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
-	if (*last_was_partial_copy)
-		ophdr->oh_flags |= XLOG_WAS_CONT_TRANS;
-	*bytes_consumed += *copy_len;
-	(*last_was_partial_copy)++;
+	/* walk the logvec, copying until we run out of space in the iclog */
+	for (index = 0; index < lv->lv_niovecs; index++) {
+		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
+		uint32_t		reg_offset = 0;
 
-	/* account for new log op header */
-	ticket->t_curr_res -= sizeof(struct xlog_op_header);
+		/*
+		 * The first region of a continuation must have a non-zero
+		 * length otherwise log recovery will just skip over it and
+		 * start recovering from the next opheader it finds. Because we
+		 * mark the next opheader as a continuation, recovery will then
+		 * incorrectly add the continuation to the previous region and
+		 * that breaks stuff.
+		 *
+		 * Hence if there isn't space for region data after the
+		 * opheader, then we need to start afresh with a new iclog.
+		 */
+		if (iclog->ic_size - *log_offset <=
+					sizeof(struct xlog_op_header)) {
+			error = xlog_write_get_more_iclog_space(ticket,
+					&iclog, log_offset, *len, record_cnt,
+					data_cnt, contwr);
+			if (error)
+				return error;
+		}
 
-	return sizeof(struct xlog_op_header);
-}
+		ophdr = reg->i_addr;
+		rlen = min_t(uint32_t, reg->i_len, iclog->ic_size - *log_offset);
 
-static int
-xlog_write_copy_finish(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	uint			flags,
-	int			*record_cnt,
-	int			*data_cnt,
-	int			*partial_copy,
-	int			*partial_copy_len,
-	int			log_offset)
-{
-	int			error;
+		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
+		if (rlen != reg->i_len)
+			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
+
+		xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
+		xlog_write_iovec(iclog, log_offset, reg->i_addr,
+				rlen, len, record_cnt, data_cnt);
+
+		/* If we wrote the whole region, move to the next. */
+		if (rlen == reg->i_len)
+			continue;
 
-	if (*partial_copy) {
 		/*
-		 * This iclog has already been marked WANT_SYNC by
-		 * xlog_state_get_iclog_space.
+		 * We now have a partially written iovec, but it can span
+		 * multiple iclogs so we loop here. First we release the iclog
+		 * we currently have, then we get a new iclog and add a new
+		 * opheader. Then we continue copying from where we were until
+		 * we either complete the iovec or fill the iclog. If we
+		 * complete the iovec, then we increment the index and go right
+		 * back to the top of the outer loop. if we fill the iclog, we
+		 * run the inner loop again.
+		 *
+		 * This is complicated by the tail of a region using all the
+		 * space in an iclog and hence requiring us to release the iclog
+		 * and get a new one before returning to the outer loop. We must
+		 * always guarantee that we exit this inner loop with at least
+		 * space for log transaction opheaders left in the current
+		 * iclog, hence we cannot just terminate the loop at the end
+		 * of the of the continuation. So we loop while there is no
+		 * space left in the current iclog, and check for the end of the
+		 * continuation after getting a new iclog.
 		 */
-		spin_lock(&log->l_icloglock);
-		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
-		*record_cnt = 0;
-		*data_cnt = 0;
-		goto release_iclog;
-	}
+		do {
+			/*
+			 * Ensure we include the continuation opheader in the
+			 * space we need in the new iclog by adding that size
+			 * to the length we require. This continuation opheader
+			 * needs to be accounted to the ticket as the space it
+			 * consumes hasn't been accounted to the lv we are
+			 * writing.
+			 */
+			error = xlog_write_get_more_iclog_space(ticket,
+					&iclog, log_offset,
+					*len + sizeof(struct xlog_op_header),
+					record_cnt, data_cnt, contwr);
+			if (error)
+				return error;
+
+			ophdr = iclog->ic_datap + *log_offset;
+			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+			ophdr->oh_clientid = XFS_TRANSACTION;
+			ophdr->oh_res2 = 0;
+			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
 
-	*partial_copy = 0;
-	*partial_copy_len = 0;
+			ticket->t_curr_res -= sizeof(struct xlog_op_header);
+			*log_offset += sizeof(struct xlog_op_header);
+			*data_cnt += sizeof(struct xlog_op_header);
 
-	if (iclog->ic_size - log_offset > sizeof(xlog_op_header_t))
-		return 0;
+			/*
+			 * If rlen fits in the iclog, then end the region
+			 * continuation. Otherwise we're going around again.
+			 */
+			reg_offset += rlen;
+			rlen = reg->i_len - reg_offset;
+			if (rlen <= iclog->ic_size - *log_offset)
+				ophdr->oh_flags |= XLOG_END_TRANS;
+			else
+				ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
 
-	/* no more space in this iclog - push it. */
-	spin_lock(&log->l_icloglock);
-	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
-	*record_cnt = 0;
-	*data_cnt = 0;
+			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
+			ophdr->oh_len = cpu_to_be32(rlen);
 
-	if (iclog->ic_state == XLOG_STATE_ACTIVE)
-		xlog_state_switch_iclogs(log, iclog, 0);
-	else
-		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-			xlog_is_shutdown(log));
-release_iclog:
-	error = xlog_state_release_iclog(log, iclog, 0);
-	spin_unlock(&log->l_icloglock);
-	return error;
+			xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
+			xlog_write_iovec(iclog, log_offset,
+					reg->i_addr + reg_offset,
+					rlen, len, record_cnt, data_cnt);
+
+		} while (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
+	}
+
+	/*
+	 * No more iovecs remain in this logvec so return the next log vec to
+	 * the caller so it can go back to fast path copying.
+	 */
+	*iclogp = iclog;
+	return 0;
 }
 
 /*
@@ -2435,14 +2502,11 @@ xlog_write(
 {
 	struct xlog_in_core	*iclog = NULL;
 	struct xfs_log_vec	*lv = log_vector;
-	struct xfs_log_iovec	*vecp = lv->lv_iovecp;
-	int			index = 0;
-	int			partial_copy = 0;
-	int			partial_copy_len = 0;
 	int			contwr = 0;
 	uint32_t		record_cnt = 0;
 	uint32_t		data_cnt = 0;
 	int			error = 0;
+	int			log_offset;
 
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
@@ -2451,151 +2515,54 @@ xlog_write(
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	}
 
-	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
-		void		*ptr;
-		int		log_offset;
-
-		error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
-						   &contwr, &log_offset);
-		if (error)
-			return error;
+	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
+					   &contwr, &log_offset);
+	if (error)
+		return error;
 
-		ASSERT(log_offset <= iclog->ic_size - 1);
+	ASSERT(log_offset <= iclog->ic_size - 1);
 
-		/*
-		 * If we have a context pointer, pass it the first iclog we are
-		 * writing to so it can record state needed for iclog write
-		 * ordering.
-		 */
-		if (ctx) {
-			xlog_cil_set_ctx_write_state(ctx, iclog);
-			ctx = NULL;
-		}
-
-		/* If this is a single iclog write, go fast... */
-		if (!contwr && lv == log_vector) {
-			while (lv) {
-				xlog_write_full(lv, ticket, iclog, &log_offset,
-						 &len, &record_cnt, &data_cnt);
-				lv = lv->lv_next;
-			}
-			data_cnt = 0;
-			break;
-		}
+	/*
+	 * If we have a context pointer, pass it the first iclog we are
+	 * writing to so it can record state needed for iclog write
+	 * ordering.
+	 */
+	if (ctx)
+		xlog_cil_set_ctx_write_state(ctx, iclog);
 
+	while (lv) {
 		/*
-		 * This loop writes out as many regions as can fit in the amount
-		 * of space which was allocated by xlog_state_get_iclog_space().
+		 * If the entire log vec does not fit in the iclog, punt it to
+		 * the partial copy loop which can handle this case.
 		 */
-		ptr = iclog->ic_datap + log_offset;
-		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
-			struct xfs_log_iovec	*reg;
-			struct xlog_op_header	*ophdr;
-			int			copy_len;
-			int			copy_off;
-			bool			ordered = false;
-			bool			added_ophdr = false;
-
-			/* ordered log vectors have no regions to write */
-			if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
-				ASSERT(lv->lv_niovecs == 0);
-				ordered = true;
-				goto next_lv;
-			}
-
-			reg = &vecp[index];
-			ASSERT(reg->i_len % sizeof(int32_t) == 0);
-			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
-
-			/*
-			 * Regions always have their ophdr at the start of the
-			 * region, except for:
-			 * - a transaction start which has a start record ophdr
-			 *   before the first region ophdr; and
-			 * - the previous region didn't fully fit into an iclog
-			 *   so needs a continuation ophdr to prepend the region
-			 *   in this new iclog.
-			 */
-			ophdr = reg->i_addr;
-			if (optype && index) {
-				optype &= ~XLOG_START_TRANS;
-			} else if (partial_copy) {
-                                ophdr = xlog_write_setup_ophdr(ptr, ticket);
-				xlog_write_adv_cnt(&ptr, &len, &log_offset,
-					   sizeof(struct xlog_op_header));
-				added_ophdr = true;
-			}
-			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
-
-			len += xlog_write_setup_copy(ticket, ophdr,
-						     iclog->ic_size-log_offset,
-						     reg->i_len,
-						     &copy_off, &copy_len,
-						     &partial_copy,
-						     &partial_copy_len);
-			xlog_verify_dest_ptr(log, ptr);
-
-
-			/*
-			 * Wart: need to update length in embedded ophdr not
-			 * to include it's own length.
-			 */
-			if (!added_ophdr) {
-				ophdr->oh_len = cpu_to_be32(copy_len -
-						sizeof(struct xlog_op_header));
-			}
-
-			ASSERT(copy_len > 0);
-			memcpy(ptr, reg->i_addr + copy_off, copy_len);
-			xlog_write_adv_cnt(&ptr, &len, &log_offset, copy_len);
-
-			if (added_ophdr)
-				copy_len += sizeof(struct xlog_op_header);
-			record_cnt++;
-			data_cnt += contwr ? copy_len : 0;
-
-			error = xlog_write_copy_finish(log, iclog, optype,
-						       &record_cnt, &data_cnt,
-						       &partial_copy,
-						       &partial_copy_len,
-						       log_offset);
-			if (error)
+		if (lv->lv_niovecs &&
+		    lv->lv_bytes > iclog->ic_size - log_offset) {
+			error = xlog_write_partial(lv, ticket, &iclog,
+					&log_offset, &len, &record_cnt,
+					&data_cnt, &contwr);
+			if (error) {
+				/*
+				 * We have no iclog to release, so just return
+				 * the error immediately.
+				 */
 				return error;
-
-			/*
-			 * if we had a partial copy, we need to get more iclog
-			 * space but we don't want to increment the region
-			 * index because there is still more is this region to
-			 * write.
-			 *
-			 * If we completed writing this region, and we flushed
-			 * the iclog (indicated by resetting of the record
-			 * count), then we also need to get more log space. If
-			 * this was the last record, though, we are done and
-			 * can just return.
-			 */
-			if (partial_copy)
-				break;
-
-			if (++index == lv->lv_niovecs) {
-next_lv:
-				lv = lv->lv_next;
-				index = 0;
-				if (lv)
-					vecp = lv->lv_iovecp;
-			}
-			if (record_cnt == 0 && !ordered) {
-				if (!lv)
-					return 0;
-				break;
 			}
+		} else {
+			xlog_write_full(lv, ticket, iclog, &log_offset,
+					 &len, &record_cnt, &data_cnt);
 		}
+		lv = lv->lv_next;
 	}
-
 	ASSERT(len == 0);
 
+	/*
+	 * We've already been guaranteed that the last writes will fit inside
+	 * the current iclog, and hence it will already have the space used by
+	 * those writes accounted to it. Hence we do not need to update the
+	 * iclog with the number of bytes written here.
+	 */
 	spin_lock(&log->l_icloglock);
-	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
+	xlog_state_finish_copy(log, iclog, record_cnt, 0);
 	error = xlog_state_release_iclog(log, iclog, 0);
 	spin_unlock(&log->l_icloglock);
 
@@ -3752,11 +3719,12 @@ xlog_verify_iclog(
 					iclog->ic_header.h_cycle_data[idx]);
 			}
 		}
-		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG)
+		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG) {
 			xfs_warn(log->l_mp,
-				"%s: invalid clientid %d op "PTR_FMT" offset 0x%lx",
-				__func__, clientid, ophead,
+				"%s: op %d invalid clientid %d op "PTR_FMT" offset 0x%lx",
+				__func__, i, clientid, ophead,
 				(unsigned long)field_offset);
+		}
 
 		/* check length */
 		p = &ophead->oh_len;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 51254d7f38d6..6e9c7d924363 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -480,14 +480,6 @@ extern struct kmem_cache *xfs_log_ticket_cache;
 struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
 		int count, bool permanent);
 
-static inline void
-xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
-{
-	*ptr += bytes;
-	*len -= bytes;
-	*off += bytes;
-}
-
 void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
-- 
2.33.0

