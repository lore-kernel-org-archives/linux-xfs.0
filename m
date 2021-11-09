Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C78C43219
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A342F61181
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239580AbhKIBxr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:53:47 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36137 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240094AbhKIBxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:53:46 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 01B24105C16A
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:50:58 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006ZY0-5d
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:50:58 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006UcV-4W
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:50:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/16] xfs: embed the xlog_op_header in the commit record
Date:   Tue,  9 Nov 2021 12:50:43 +1100
Message-Id: <20211109015055.1547604-5-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015055.1547604-1-david@fromorbit.com>
References: <20211109015055.1547604-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6189d403
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=Oc_qpV5cMpSWUF8m4ooA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove the final case where xlog_write() has to prepend an opheader
to a log transaction. Similar to the start record, the commit record
is just an empty opheader with a XLOG_COMMIT_TRANS type, so we can
just make this the payload for the region being passed to
xlog_write() and remove the special handling in xlog_write() for
the commit record.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c     | 22 ++++++----------------
 fs/xfs/xfs_log_cil.c | 11 +++++++++--
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e5515d0c85c4..f789acd2f755 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2281,11 +2281,10 @@ xlog_write_calc_vec_length(
 
 	/* Don't account for regions with embedded ophdrs */
 	if (optype && headers > 0) {
-		if (optype & XLOG_UNMOUNT_TRANS)
-			headers--;
+		headers--;
 		if (optype & XLOG_START_TRANS) {
-			ASSERT(headers >= 2);
-			headers -= 2;
+			ASSERT(headers >= 1);
+			headers--;
 		}
 	}
 
@@ -2486,14 +2485,6 @@ xlog_write(
 	int			data_cnt = 0;
 	int			error = 0;
 
-	/*
-	 * If this is a commit or unmount transaction, we don't need a start
-	 * record to be written.  We do, however, have to account for the commit
-	 * header that gets written. Hence we always have to account for an
-	 * extra xlog_op_header here for commit records.
-	 */
-	if (optype & XLOG_COMMIT_TRANS)
-		ticket->t_curr_res -= sizeof(struct xlog_op_header);
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
 		     "ctx ticket reservation ran out. Need to up reservation");
@@ -2550,14 +2541,13 @@ xlog_write(
 			/*
 			 * The XLOG_START_TRANS has embedded ophdrs for the
 			 * start record and transaction header. They will always
-			 * be the first two regions in the lv chain.
+			 * be the first two regions in the lv chain. Commit and
+			 * unmount records also have embedded ophdrs.
 			 */
-			if (optype & XLOG_START_TRANS) {
+			if (optype) {
 				ophdr = reg->i_addr;
 				if (index)
 					optype &= ~XLOG_START_TRANS;
-			} else if (optype & XLOG_UNMOUNT_TRANS) {
-				ophdr = reg->i_addr;
 			} else {
 				ophdr = xlog_write_setup_ophdr(log, ptr,
 							ticket, optype);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 560af08d81dc..56c456263639 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -810,9 +810,14 @@ xlog_cil_write_commit_record(
 	struct xfs_cil_ctx	*ctx)
 {
 	struct xlog		*log = ctx->cil->xc_log;
+	struct xlog_op_header	ophdr = {
+		.oh_clientid = XFS_TRANSACTION,
+		.oh_tid = cpu_to_be32(ctx->ticket->t_tid),
+		.oh_flags = XLOG_COMMIT_TRANS,
+	};
 	struct xfs_log_iovec	reg = {
-		.i_addr = NULL,
-		.i_len = 0,
+		.i_addr = &ophdr,
+		.i_len = sizeof(struct xlog_op_header),
 		.i_type = XLOG_REG_TYPE_COMMIT,
 	};
 	struct xfs_log_vec	vec = {
@@ -828,6 +833,8 @@ xlog_cil_write_commit_record(
 	if (error)
 		return error;
 
+	/* account for space used by record data */
+	ctx->ticket->t_curr_res -= reg.i_len;
 	error = xlog_write(log, ctx, &vec, ctx->ticket, XLOG_COMMIT_TRANS);
 	if (error)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
-- 
2.33.0

