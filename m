Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C84C4332E
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1524E65017
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhCEFMy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:12:54 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58883 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229669AbhCEFMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:12:15 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 99E988280CB
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-00Fbom-Sx
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-000lZo-L0
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 22/45] xfs: embed the xlog_op_header in the commit record
Date:   Fri,  5 Mar 2021 16:11:20 +1100
Message-Id: <20210305051143.182133-23-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=o5Hyw1bTQpth9r4-HlMA:9
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
---
 fs/xfs/xfs_log.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 94711b9ff007..c2e69a1f5cad 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1529,9 +1529,14 @@ xlog_commit_record(
 	struct xlog_in_core	**iclog,
 	xfs_lsn_t		*lsn)
 {
+	struct xlog_op_header	ophdr = {
+		.oh_clientid = XFS_TRANSACTION,
+		.oh_tid = cpu_to_be32(ticket->t_tid),
+		.oh_flags = XLOG_COMMIT_TRANS,
+	};
 	struct xfs_log_iovec reg = {
-		.i_addr = NULL,
-		.i_len = 0,
+		.i_addr = &ophdr,
+		.i_len = sizeof(struct xlog_op_header),
 		.i_type = XLOG_REG_TYPE_COMMIT,
 	};
 	struct xfs_log_vec vec = {
@@ -1543,6 +1548,8 @@ xlog_commit_record(
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return -EIO;
 
+	/* account for space used by record data */
+	ticket->t_curr_res -= reg.i_len;
 	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
 	if (error)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
@@ -2148,11 +2155,10 @@ xlog_write_calc_vec_length(
 
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
 
@@ -2362,14 +2368,6 @@ xlog_write(
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
@@ -2433,14 +2431,13 @@ xlog_write(
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
-- 
2.28.0

