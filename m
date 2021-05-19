Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B119C4363E
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E6A161040
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346400AbhESMOr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:14:47 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:41511 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353345AbhESMOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:44 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 9E60380B77D
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002m1Q-7u
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002SHV-Vl
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 22/39] xfs:_introduce xlog_write_partial()
Date:   Wed, 19 May 2021 22:13:00 +1000
Message-Id: <20210519121317.585244-23-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=GViwONXXP1nJWGu3hDoA:9
        a=td_Dx5RzoQVeXwyY:21 a=oR0m_YiOs8cWm6em:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Handle writing of a logvec chain into an iclog that doesn't have
enough space to fit it all. The iclog has already been changed to
WANT_SYNC by xlog_get_iclog_space(), so the entire remaining space
in the iclog is exclusively owned by this logvec chain.

The difference between the single and partial cases is that
we end up with partial iovec writes in the iclog and have to split
a log vec regions across two iclogs. The state handling for this is
currently awful and so we're building up the pieces needed to
handle this more cleanly one at a time.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 504 ++++++++++++++++++++++-------------------------
 1 file changed, 240 insertions(+), 264 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3b74d21e3786..98a3e2e4f1e0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2110,166 +2110,250 @@ xlog_print_trans(
 	}
 }
 
-static xlog_op_header_t *
-xlog_write_setup_ophdr(
-	struct xlog_op_header	*ophdr,
-	struct xlog_ticket	*ticket)
-{
-	ophdr->oh_clientid = XFS_TRANSACTION;
-	ophdr->oh_res2 = 0;
-	ophdr->oh_flags = 0;
-	return ophdr;
-}
-
 /*
- * Set up the parameters of the region copy into the log. This has
- * to handle region write split across multiple log buffers - this
- * state is kept external to this function so that this code can
- * be written in an obvious, self documenting manner.
+ * Write whole log vectors into a single iclog which is guaranteed to have
+ * either sufficient space for the entire log vector chain to be written or
+ * exclusive access to the remaining space in the iclog.
+ *
+ * Return the number of iovecs and data written into the iclog, as well as
+ * a pointer to the logvec that doesn't fit in the log (or NULL if we hit the
+ * end of the chain.
  */
-static int
-xlog_write_setup_copy(
+static struct xfs_log_vec *
+xlog_write_single(
+	struct xfs_log_vec	*log_vector,
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
-
-	/* partial write of region, needs extra log op header reservation */
-	*copy_len = space_available;
-	ophdr->oh_len = cpu_to_be32(*copy_len);
-	ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
-	if (*last_was_partial_copy)
-		ophdr->oh_flags |= XLOG_WAS_CONT_TRANS;
-	*bytes_consumed += *copy_len;
-	(*last_was_partial_copy)++;
-
-	/* account for new log op header */
-	ticket->t_curr_res -= sizeof(struct xlog_op_header);
-
-	return sizeof(struct xlog_op_header);
-}
-
-static int
-xlog_write_copy_finish(
-	struct xlog		*log,
 	struct xlog_in_core	*iclog,
-	uint			flags,
-	int			*record_cnt,
-	int			*data_cnt,
-	int			*partial_copy,
-	int			*partial_copy_len,
-	int			log_offset,
-	struct xlog_in_core	**commit_iclog)
+	uint32_t		*log_offset,
+	uint32_t		*len,
+	uint32_t		*record_cnt,
+	uint32_t		*data_cnt)
 {
-	int			error;
+	struct xfs_log_vec	*lv;
+	void			*ptr;
+	int			index;
+
+	ASSERT(*log_offset + *len <= iclog->ic_size ||
+		iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
-	if (*partial_copy) {
+	ptr = iclog->ic_datap + *log_offset;
+	for (lv = log_vector; lv; lv = lv->lv_next) {
 		/*
-		 * This iclog has already been marked WANT_SYNC by
-		 * xlog_state_get_iclog_space.
+		 * If the entire log vec does not fit in the iclog, punt it to
+		 * the partial copy loop which can handle this case.
 		 */
-		spin_lock(&log->l_icloglock);
-		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
-		*record_cnt = 0;
-		*data_cnt = 0;
-		goto release_iclog;
-	}
+		if (lv->lv_niovecs &&
+		    lv->lv_bytes > iclog->ic_size - *log_offset)
+			break;
 
-	*partial_copy = 0;
-	*partial_copy_len = 0;
+		/*
+		 * Ordered log vectors have no regions to write so this
+		 * loop will naturally skip them.
+		 */
+		for (index = 0; index < lv->lv_niovecs; index++) {
+			struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
+			struct xlog_op_header	*ophdr = reg->i_addr;
 
-	if (iclog->ic_size - log_offset <= sizeof(xlog_op_header_t)) {
-		/* no more space in this iclog - push it. */
-		spin_lock(&log->l_icloglock);
-		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
-		*record_cnt = 0;
-		*data_cnt = 0;
+			ASSERT(reg->i_len % sizeof(int32_t) == 0);
+			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
 
-		if (iclog->ic_state == XLOG_STATE_ACTIVE)
-			xlog_state_switch_iclogs(log, iclog, 0);
-		else
-			ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-			       iclog->ic_state == XLOG_STATE_IOERROR);
-		if (!commit_iclog)
-			goto release_iclog;
-		spin_unlock(&log->l_icloglock);
-		ASSERT(flags & XLOG_COMMIT_TRANS);
-		*commit_iclog = iclog;
+			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+			ophdr->oh_len = cpu_to_be32(reg->i_len -
+						sizeof(struct xlog_op_header));
+			memcpy(ptr, reg->i_addr, reg->i_len);
+			xlog_write_adv_cnt(&ptr, len, log_offset, reg->i_len);
+			(*record_cnt)++;
+			*data_cnt += reg->i_len;
+		}
 	}
+	ASSERT(*len == 0 || lv);
+	return lv;
+}
 
-	return 0;
+static int
+xlog_write_get_more_iclog_space(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket,
+	struct xlog_in_core	**iclogp,
+	uint32_t		*log_offset,
+	uint32_t		len,
+	uint32_t		*record_cnt,
+	uint32_t		*data_cnt,
+	int			*contwr)
+{
+	struct xlog_in_core	*iclog = *iclogp;
+	int			error;
 
-release_iclog:
+	spin_lock(&log->l_icloglock);
+	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
+	ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
+	       iclog->ic_state == XLOG_STATE_IOERROR);
 	error = xlog_state_release_iclog(log, iclog);
 	spin_unlock(&log->l_icloglock);
-	return error;
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
- * Write log vectors into a single iclog which is guaranteed by the caller
- * to have enough space to write the entire log vector into. Return the number
- * of log vectors written into the iclog.
+ * Write log vectors into a single iclog which is smaller than the current chain
+ * length. We write until we cannot fit a full record into the remaining space
+ * and then stop. We return the log vector that is to be written that cannot
+ * wholly fit in the iclog.
  */
-static int
-xlog_write_single(
+static struct xfs_log_vec *
+xlog_write_partial(
+	struct xlog		*log,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
-	struct xlog_in_core	*iclog,
-	uint32_t		log_offset,
-	uint32_t		len)
+	struct xlog_in_core	**iclogp,
+	uint32_t		*log_offset,
+	uint32_t		*len,
+	uint32_t		*record_cnt,
+	uint32_t		*data_cnt,
+	int			*contwr)
 {
-	struct xfs_log_vec	*lv;
+	struct xlog_in_core	*iclog = *iclogp;
+	struct xfs_log_vec	*lv = log_vector;
+	struct xfs_log_iovec	*reg;
+	struct xlog_op_header	*ophdr;
 	void			*ptr;
 	int			index = 0;
-	int			record_cnt = 0;
+	uint32_t		rlen;
+	int			error;
 
-	ASSERT(log_offset + len <= iclog->ic_size);
+	/* walk the logvec, copying until we run out of space in the iclog */
+	ptr = iclog->ic_datap + *log_offset;
+	for (index = 0; index < lv->lv_niovecs; index++) {
+		uint32_t	reg_offset = 0;
+
+		reg = &lv->lv_iovecp[index];
+		ASSERT(reg->i_len % sizeof(int32_t) == 0);
 
-	ptr = iclog->ic_datap + log_offset;
-	for (lv = log_vector; lv; lv = lv->lv_next) {
 		/*
-		 * Ordered log vectors have no regions to write so this
-		 * loop will naturally skip them.
+		 * The first region of a continuation must have a non-zero
+		 * length otherwise log recovery will just skip over it and
+		 * start recovering from the next opheader it finds. Because we
+		 * mark the next opheader as a continuation, recovery will then
+		 * incorrectly add the continuation to the previous region and
+		 * that breaks stuff.
+		 *
+		 * Hence if there isn't space for region data after the
+		 * opheader, then we need to start afresh with a new iclog.
 		 */
-		for (index = 0; index < lv->lv_niovecs; index++) {
-			struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
-			struct xlog_op_header	*ophdr = reg->i_addr;
+		if (iclog->ic_size - *log_offset <=
+					sizeof(struct xlog_op_header)) {
+			error = xlog_write_get_more_iclog_space(log, ticket,
+					&iclog, log_offset, *len, record_cnt,
+					data_cnt, contwr);
+			if (error)
+				return ERR_PTR(error);
+			ptr = iclog->ic_datap + *log_offset;
+		}
 
-			ASSERT(reg->i_len % sizeof(int32_t) == 0);
-			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
+		ophdr = reg->i_addr;
+		rlen = min_t(uint32_t, reg->i_len, iclog->ic_size - *log_offset);
+
+		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
+		if (rlen != reg->i_len)
+			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
+
+		ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
+		xlog_verify_dest_ptr(log, ptr);
+		memcpy(ptr, reg->i_addr, rlen);
+		xlog_write_adv_cnt(&ptr, len, log_offset, rlen);
+		(*record_cnt)++;
+		*data_cnt += rlen;
+
+		/* If we wrote the whole region, move to the next. */
+		if (rlen == reg->i_len)
+			continue;
+
+		/*
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
+		 */
+		do {
+			/*
+			 * Account for the continuation opheader before we get
+			 * a new iclog. This is necessary so that we reserve
+			 * space in the iclog for it.
+			 */
+			*len += sizeof(struct xlog_op_header);
+			ticket->t_curr_res -= sizeof(struct xlog_op_header);
+
+			error = xlog_write_get_more_iclog_space(log, ticket,
+					&iclog, log_offset, *len, record_cnt,
+					data_cnt, contwr);
+			if (error)
+				return ERR_PTR(error);
+			ptr = iclog->ic_datap + *log_offset;
 
+			ophdr = ptr;
 			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
-			ophdr->oh_len = cpu_to_be32(reg->i_len -
+			ophdr->oh_clientid = XFS_TRANSACTION;
+			ophdr->oh_res2 = 0;
+			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
+
+			xlog_write_adv_cnt(&ptr, len, log_offset,
 						sizeof(struct xlog_op_header));
-			memcpy(ptr, reg->i_addr, reg->i_len);
-			xlog_write_adv_cnt(&ptr, &len, &log_offset, reg->i_len);
-			record_cnt++;
-		}
+			*data_cnt += sizeof(struct xlog_op_header);
+
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
+
+			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
+			ophdr->oh_len = cpu_to_be32(rlen);
+
+			xlog_verify_dest_ptr(log, ptr);
+			memcpy(ptr, reg->i_addr + reg_offset, rlen);
+			xlog_write_adv_cnt(&ptr, len, log_offset, rlen);
+			(*record_cnt)++;
+			*data_cnt += rlen;
+
+		} while (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
 	}
-	ASSERT(len == 0);
-	return record_cnt;
-}
 
+	/*
+	 * No more iovecs remain in this logvec so return the next log vec to
+	 * the caller so it can go back to fast path copying.
+	 */
+	*iclogp = iclog;
+	return lv->lv_next;
+}
 
 /*
  * Write some region out to in-core log
@@ -2323,14 +2407,11 @@ xlog_write(
 {
 	struct xlog_in_core	*iclog = NULL;
 	struct xfs_log_vec	*lv = log_vector;
-	struct xfs_log_iovec	*vecp = lv->lv_iovecp;
-	int			index = 0;
-	int			partial_copy = 0;
-	int			partial_copy_len = 0;
 	int			contwr = 0;
 	int			record_cnt = 0;
 	int			data_cnt = 0;
 	int			error = 0;
+	int			log_offset;
 
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
@@ -2339,146 +2420,40 @@ xlog_write(
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	}
 
-	if (start_lsn)
-		*start_lsn = 0;
-	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
-		void		*ptr;
-		int		log_offset;
-
-		error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
-						   &contwr, &log_offset);
-		if (error)
-			return error;
-
-		ASSERT(log_offset <= iclog->ic_size - 1);
+	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
+					   &contwr, &log_offset);
+	if (error)
+		return error;
 
-		/* Start_lsn is the first lsn written to. */
-		if (start_lsn && !*start_lsn)
-			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+	/* start_lsn is the LSN of the first iclog written to. */
+	if (start_lsn)
+		*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 
-		/* If this is a single iclog write, go fast... */
-		if (!contwr && lv == log_vector) {
-			record_cnt = xlog_write_single(lv, ticket, iclog,
-						log_offset, len);
-			len = 0;
-			data_cnt = len;
+	while (lv) {
+		lv = xlog_write_single(lv, ticket, iclog, &log_offset,
+					&len, &record_cnt, &data_cnt);
+		if (!lv)
 			break;
-		}
-
-		/*
-		 * This loop writes out as many regions as can fit in the amount
-		 * of space which was allocated by xlog_state_get_iclog_space().
-		 */
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
-						       log_offset,
-						       commit_iclog);
-			if (error)
-				return error;
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
-			}
+		ASSERT(!(optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)));
+		lv = xlog_write_partial(log, lv, ticket, &iclog, &log_offset,
+					&len, &record_cnt, &data_cnt, &contwr);
+		if (IS_ERR_OR_NULL(lv)) {
+			error = PTR_ERR_OR_ZERO(lv);
+			break;
 		}
 	}
+	ASSERT((len == 0 && !lv) || error);
 
-	ASSERT(len == 0);
-
+	/*
+	 * We've already been guaranteed that the last writes will fit inside
+	 * the current iclog, and hence it will already have the space used by
+	 * those writes accounted to it. Hence we do not need to update the
+	 * iclog with the number of bytes written here.
+	 */
+	ASSERT(!contwr || XLOG_FORCED_SHUTDOWN(log));
 	spin_lock(&log->l_icloglock);
-	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
+	xlog_state_finish_copy(log, iclog, record_cnt, 0);
 	if (commit_iclog) {
 		ASSERT(optype & XLOG_COMMIT_TRANS);
 		*commit_iclog = iclog;
@@ -3633,11 +3608,12 @@ xlog_verify_iclog(
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
-- 
2.31.1

