Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	TVD_PH_BODY_META_ALL,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E86C4332B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C0AF64E4D
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhBWDfb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:35:31 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35864 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230486AbhBWDf3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 22:35:29 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 75CF01041060
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 14:34:46 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEOTF-0001km-TS
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 14:34:45 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lEOTF-00Di0O-Ls
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 14:34:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: remove need_start_rec parameter from xlog_write()
Date:   Tue, 23 Feb 2021 14:34:40 +1100
Message-Id: <20210223033442.3267258-7-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210223033442.3267258-1-david@fromorbit.com>
References: <20210223033442.3267258-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=U2sKdf1BhhSb6LhUA4oA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The CIL push is the only call to xlog_write that sets this variable
to true. The other callers don't need a start rec, and they tell
xlog_write what to do by passing the type of ophdr they need written
in the flags field. The need_start_rec parameter essentially tells
xlog_write to to write an extra ophdr with a XLOG_START_TRANS type,
so get rid of the variable to do this and pass XLOG_START_TRANS as
the flag value into xlog_write() from the CIL push.

$ size fs/xfs/xfs_log.o*
  text	   data	    bss	    dec	    hex	filename
 27595	    560	      8	  28163	   6e03	fs/xfs/xfs_log.o.orig
 27454	    560	      8	  28022	   6d76	fs/xfs/xfs_log.o.patched

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 44 +++++++++++++++++++++----------------------
 fs/xfs/xfs_log_cil.c  |  3 ++-
 fs/xfs/xfs_log_priv.h |  3 +--
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 493454c98c6f..6c3fb6dcb505 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -871,9 +871,7 @@ xlog_wait_on_iclog_lsn(
 static int
 xlog_write_unmount_record(
 	struct xlog		*log,
-	struct xlog_ticket	*ticket,
-	xfs_lsn_t		*lsn,
-	uint			flags)
+	struct xlog_ticket	*ticket)
 {
 	struct xfs_unmount_log_format ulf = {
 		.magic = XLOG_UNMOUNT_TYPE,
@@ -890,7 +888,7 @@ xlog_write_unmount_record(
 
 	/* account for space used by record data */
 	ticket->t_curr_res -= sizeof(ulf);
-	return xlog_write(log, &vec, ticket, lsn, NULL, flags, false);
+	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
 }
 
 /*
@@ -904,15 +902,13 @@ xlog_unmount_write(
 	struct xfs_mount	*mp = log->l_mp;
 	struct xlog_in_core	*iclog;
 	struct xlog_ticket	*tic = NULL;
-	xfs_lsn_t		lsn;
-	uint			flags = XLOG_UNMOUNT_TRANS;
 	int			error;
 
 	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
 	if (error)
 		goto out_err;
 
-	error = xlog_write_unmount_record(log, tic, &lsn, flags);
+	error = xlog_write_unmount_record(log, tic);
 	/*
 	 * At this point, we're umounting anyway, so there's no point in
 	 * transitioning log state to IOERROR. Just continue...
@@ -1604,8 +1600,7 @@ xlog_commit_record(
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return -EIO;
 
-	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS,
-			   false);
+	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
 	if (error)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
@@ -2202,13 +2197,16 @@ static int
 xlog_write_calc_vec_length(
 	struct xlog_ticket	*ticket,
 	struct xfs_log_vec	*log_vector,
-	bool			need_start_rec)
+	uint			optype)
 {
 	struct xfs_log_vec	*lv;
-	int			headers = need_start_rec ? 1 : 0;
+	int			headers = 0;
 	int			len = 0;
 	int			i;
 
+	if (optype & XLOG_START_TRANS)
+		headers++;
+
 	for (lv = log_vector; lv; lv = lv->lv_next) {
 		/* we don't write ordered log vectors */
 		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
@@ -2428,8 +2426,7 @@ xlog_write(
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*start_lsn,
 	struct xlog_in_core	**commit_iclog,
-	uint			flags,
-	bool			need_start_rec)
+	uint			optype)
 {
 	struct xlog_in_core	*iclog = NULL;
 	struct xfs_log_vec	*lv = log_vector;
@@ -2457,8 +2454,9 @@ xlog_write(
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	}
 
-	len = xlog_write_calc_vec_length(ticket, log_vector, need_start_rec);
-	*start_lsn = 0;
+	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
+	if (start_lsn)
+		*start_lsn = 0;
 	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
 		void		*ptr;
 		int		log_offset;
@@ -2472,7 +2470,7 @@ xlog_write(
 		ptr = iclog->ic_datap + log_offset;
 
 		/* start_lsn is the first lsn written to. That's all we need. */
-		if (!*start_lsn)
+		if (start_lsn && !*start_lsn)
 			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 
 		/*
@@ -2485,6 +2483,7 @@ xlog_write(
 			int			copy_len;
 			int			copy_off;
 			bool			ordered = false;
+			bool			wrote_start_rec = false;
 
 			/* ordered log vectors have no regions to write */
 			if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
@@ -2502,13 +2501,15 @@ xlog_write(
 			 * write a start record. Only do this for the first
 			 * iclog we write to.
 			 */
-			if (need_start_rec) {
+			if (optype & XLOG_START_TRANS) {
 				xlog_write_start_rec(ptr, ticket);
 				xlog_write_adv_cnt(&ptr, &len, &log_offset,
 						sizeof(struct xlog_op_header));
+				optype &= ~XLOG_START_TRANS;
+				wrote_start_rec = true;
 			}
 
-			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, flags);
+			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, optype);
 			if (!ophdr)
 				return -EIO;
 
@@ -2539,14 +2540,13 @@ xlog_write(
 			}
 			copy_len += sizeof(struct xlog_op_header);
 			record_cnt++;
-			if (need_start_rec) {
+			if (wrote_start_rec) {
 				copy_len += sizeof(struct xlog_op_header);
 				record_cnt++;
-				need_start_rec = false;
 			}
 			data_cnt += contwr ? copy_len : 0;
 
-			error = xlog_write_copy_finish(log, iclog, flags,
+			error = xlog_write_copy_finish(log, iclog, optype,
 						       &record_cnt, &data_cnt,
 						       &partial_copy,
 						       &partial_copy_len,
@@ -2590,7 +2590,7 @@ xlog_write(
 	spin_lock(&log->l_icloglock);
 	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
 	if (commit_iclog) {
-		ASSERT(flags & XLOG_COMMIT_TRANS);
+		ASSERT(optype & XLOG_COMMIT_TRANS);
 		*commit_iclog = iclog;
 	} else {
 		error = xlog_state_release_iclog(log, iclog);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 8bcacd463f06..4093d2d0db7c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -827,7 +827,8 @@ xlog_cil_push_work(
 	 */
 	wait_for_completion(&bdev_flush);
 
-	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0, true);
+	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL,
+				XLOG_START_TRANS);
 	if (error)
 		goto out_abort_free_ticket;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index a7ac85aaff4e..10a41b1dd895 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -480,8 +480,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
 		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
-		struct xlog_in_core **commit_iclog, uint flags,
-		bool need_start_rec);
+		struct xlog_in_core **commit_iclog, uint optype);
 int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
 		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
-- 
2.28.0

