Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67868C47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5368F613E6
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhFCFZT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 01:25:19 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:56556 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229840AbhFCFZT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 01:25:19 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id A941C10227C
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jun 2021 15:22:51 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofoh-008Mr4-58
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:51 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lofog-000imL-Tb
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 24/39] xfs: xlog_write() doesn't need optype anymore
Date:   Thu,  3 Jun 2021 15:22:25 +1000
Message-Id: <20210603052240.171998-25-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603052240.171998-1-david@fromorbit.com>
References: <20210603052240.171998-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=JnHvY13FuJIPsMKcdksA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So remove it from the interface and callers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 14 ++++----------
 fs/xfs/xfs_log_cil.c  |  2 +-
 fs/xfs/xfs_log_priv.h |  2 +-
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 574078985f0a..65b28fce4db4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -863,8 +863,7 @@ xlog_write_unmount_record(
 	 */
 	if (log->l_targ != log->l_mp->m_ddev_targp)
 		blkdev_issue_flush(log->l_targ->bt_bdev);
-	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS,
-				reg.i_len);
+	return xlog_write(log, &vec, ticket, NULL, NULL, reg.i_len);
 }
 
 /*
@@ -1588,8 +1587,7 @@ xlog_commit_record(
 
 	/* account for space used by record data */
 	ticket->t_curr_res -= reg.i_len;
-	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS,
-				reg.i_len);
+	error = xlog_write(log, &vec, ticket, lsn, iclog, reg.i_len);
 	if (error)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
@@ -2399,7 +2397,6 @@ xlog_write(
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*start_lsn,
 	struct xlog_in_core	**commit_iclog,
-	uint			optype,
 	uint32_t		len)
 {
 	struct xlog_in_core	*iclog = NULL;
@@ -2431,7 +2428,6 @@ xlog_write(
 		if (!lv)
 			break;
 
-		ASSERT(!(optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)));
 		lv = xlog_write_partial(log, lv, ticket, &iclog, &log_offset,
 					&len, &record_cnt, &data_cnt);
 		if (IS_ERR_OR_NULL(lv)) {
@@ -2449,12 +2445,10 @@ xlog_write(
 	 */
 	spin_lock(&log->l_icloglock);
 	xlog_state_finish_copy(log, iclog, record_cnt, 0);
-	if (commit_iclog) {
-		ASSERT(optype & XLOG_COMMIT_TRANS);
+	if (commit_iclog)
 		*commit_iclog = iclog;
-	} else {
+	else
 		error = xlog_state_release_iclog(log, iclog);
-	}
 	spin_unlock(&log->l_icloglock);
 
 	return error;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 68bec4b81052..b051f3c44ec1 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -907,7 +907,7 @@ xlog_cil_push_work(
 	 * write head.
 	 */
 	error = xlog_write(log, &lvhdr, ctx->ticket, &ctx->start_lsn, NULL,
-				XLOG_START_TRANS, num_bytes);
+				num_bytes);
 	if (error)
 		goto out_abort_free_ticket;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index eba905c273b0..a16ffdc8ae97 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -459,7 +459,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
 		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
-		struct xlog_in_core **commit_iclog, uint optype, uint32_t len);
+		struct xlog_in_core **commit_iclog, uint32_t len);
 int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
 		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
 
-- 
2.31.1

