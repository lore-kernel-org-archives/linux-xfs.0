Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97EC9C3F2DC
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B3CC21739
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725271AbgCDHyI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:54:08 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43854 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728530AbgCDHyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 02:54:08 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3FE057EA120
        for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2020 18:54:03 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0007lQ-QB
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0005cT-MO
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/11] xfs: don't try to write a start record into every iclog
Date:   Wed,  4 Mar 2020 18:53:51 +1100
Message-Id: <20200304075401.21558-2-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200304075401.21558-1-david@fromorbit.com>
References: <20200304075401.21558-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=Go1iWFsYnf0d6w-0-8gA:9 a=l7ea9jAn6xmV8bzw:21 a=zP2MfwOD-wjrT4dR:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The xlog_write() function iterates over iclogs until it completes
writing all the log vectors passed in. The ticket tracks whether
a start record has been written or not, so only the first iclog gets
a start record. We only ever pass single use tickets to
xlog_write() we only ever need to write a start record once per
xlog_write() call.

Hence we don't need to store whether we should write a start record
in the ticket as the callers provide all the information we need to
determine if a start record should be written. For the moment, we
have to ensure that we clear the XLOG_TIC_INITED appropriately so
the code in xfs_log_done() still works correctly for committing
transactions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 68 +++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6006d94a581..5b0568a86c07 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2148,23 +2148,21 @@ xlog_print_trans(
 }
 
 /*
- * Calculate the potential space needed by the log vector.  Each region gets
- * its own xlog_op_header_t and may need to be double word aligned.
+ * Calculate the potential space needed by the log vector.  We may need a
+ * start record, and each region gets its own xlog_op_header_t and may need to
+ * be double word aligned.
  */
 static int
 xlog_write_calc_vec_length(
 	struct xlog_ticket	*ticket,
-	struct xfs_log_vec	*log_vector)
+	struct xfs_log_vec	*log_vector,
+	bool			need_start_rec)
 {
 	struct xfs_log_vec	*lv;
-	int			headers = 0;
+	int			headers = need_start_rec ? 1 : 0;
 	int			len = 0;
 	int			i;
 
-	/* acct for start rec of xact */
-	if (ticket->t_flags & XLOG_TIC_INITED)
-		headers++;
-
 	for (lv = log_vector; lv; lv = lv->lv_next) {
 		/* we don't write ordered log vectors */
 		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
@@ -2186,27 +2184,16 @@ xlog_write_calc_vec_length(
 	return len;
 }
 
-/*
- * If first write for transaction, insert start record  We can't be trying to
- * commit if we are inited.  We can't have any "partial_copy" if we are inited.
- */
-static int
+static void
 xlog_write_start_rec(
 	struct xlog_op_header	*ophdr,
 	struct xlog_ticket	*ticket)
 {
-	if (!(ticket->t_flags & XLOG_TIC_INITED))
-		return 0;
-
 	ophdr->oh_tid	= cpu_to_be32(ticket->t_tid);
 	ophdr->oh_clientid = ticket->t_clientid;
 	ophdr->oh_len = 0;
 	ophdr->oh_flags = XLOG_START_TRANS;
 	ophdr->oh_res2 = 0;
-
-	ticket->t_flags &= ~XLOG_TIC_INITED;
-
-	return sizeof(struct xlog_op_header);
 }
 
 static xlog_op_header_t *
@@ -2404,25 +2391,29 @@ xlog_write(
 	int			record_cnt = 0;
 	int			data_cnt = 0;
 	int			error = 0;
+	int			start_rec_size = sizeof(struct xlog_op_header);
 
 	*start_lsn = 0;
 
-	len = xlog_write_calc_vec_length(ticket, log_vector);
 
 	/*
 	 * Region headers and bytes are already accounted for.
 	 * We only need to take into account start records and
 	 * split regions in this function.
 	 */
-	if (ticket->t_flags & XLOG_TIC_INITED)
+	if (ticket->t_flags & XLOG_TIC_INITED) {
 		ticket->t_curr_res -= sizeof(xlog_op_header_t);
+		ticket->t_flags &= ~XLOG_TIC_INITED;
+	}
 
 	/*
 	 * Commit record headers need to be accounted for. These
 	 * come in as separate writes so are easy to detect.
 	 */
-	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
+	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
 		ticket->t_curr_res -= sizeof(xlog_op_header_t);
+		start_rec_size = 0;
+	}
 
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
@@ -2431,6 +2422,8 @@ xlog_write(
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	}
 
+	len = xlog_write_calc_vec_length(ticket, log_vector, start_rec_size);
+
 	index = 0;
 	lv = log_vector;
 	vecp = lv->lv_iovecp;
@@ -2446,9 +2439,20 @@ xlog_write(
 		ASSERT(log_offset <= iclog->ic_size - 1);
 		ptr = iclog->ic_datap + log_offset;
 
-		/* start_lsn is the first lsn written to. That's all we need. */
+		/*
+		 * Before we start formatting log vectors, we need to write a
+		 * start record and record the lsn of the iclog that we write
+		 * the start record into. Only do this for the first iclog we
+		 * write to.
+		 */
 		if (!*start_lsn)
 			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+		if (start_rec_size) {
+			xlog_write_start_rec(ptr, ticket);
+			xlog_write_adv_cnt(&ptr, &len, &log_offset,
+					start_rec_size);
+			record_cnt++;
+		}
 
 		/*
 		 * This loop writes out as many regions as can fit in the amount
@@ -2457,7 +2461,6 @@ xlog_write(
 		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
 			struct xfs_log_iovec	*reg;
 			struct xlog_op_header	*ophdr;
-			int			start_rec_copy;
 			int			copy_len;
 			int			copy_off;
 			bool			ordered = false;
@@ -2473,13 +2476,6 @@ xlog_write(
 			ASSERT(reg->i_len % sizeof(int32_t) == 0);
 			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
 
-			start_rec_copy = xlog_write_start_rec(ptr, ticket);
-			if (start_rec_copy) {
-				record_cnt++;
-				xlog_write_adv_cnt(&ptr, &len, &log_offset,
-						   start_rec_copy);
-			}
-
 			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, flags);
 			if (!ophdr)
 				return -EIO;
@@ -2509,10 +2505,15 @@ xlog_write(
 				xlog_write_adv_cnt(&ptr, &len, &log_offset,
 						   copy_len);
 			}
-			copy_len += start_rec_copy + sizeof(xlog_op_header_t);
+			copy_len += sizeof(xlog_op_header_t);
 			record_cnt++;
 			data_cnt += contwr ? copy_len : 0;
 
+			if (start_rec_size) {
+				copy_len += start_rec_size;
+				start_rec_size = 0;
+			}
+
 			error = xlog_write_copy_finish(log, iclog, flags,
 						       &record_cnt, &data_cnt,
 						       &partial_copy,
@@ -2550,6 +2551,7 @@ xlog_write(
 				break;
 			}
 		}
+		start_rec_size = 0;
 	}
 
 	ASSERT(len == 0);
-- 
2.24.0.rc0

