Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19345C4332B
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9CDF65013
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCEFM2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:12:28 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:55935 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229609AbhCEFMJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:12:09 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 9F4B86309C
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-00Fboj-Rm
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-000lZl-Jz
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 21/45] xfs: embed the xlog_op_header in the unmount record
Date:   Fri,  5 Mar 2021 16:11:19 +1100
Message-Id: <20210305051143.182133-22-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=3V92cHclhPhCIjMfKr4A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Remove another case where xlog_write() has to prepend an opheader to
a log transaction. The unmount record + ophdr is smaller than the
minimum amount of space guaranteed to be free in an iclog (2 *
sizeof(ophdr)) and so we don't have to care about an unmount record
being split across 2 iclogs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b2f9fb1b4fed..94711b9ff007 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -798,12 +798,22 @@ xlog_write_unmount_record(
 	struct xlog		*log,
 	struct xlog_ticket	*ticket)
 {
-	struct xfs_unmount_log_format ulf = {
-		.magic = XLOG_UNMOUNT_TYPE,
+	struct  {
+		struct xlog_op_header ophdr;
+		struct xfs_unmount_log_format ulf;
+	} unmount_rec = {
+		.ophdr = {
+			.oh_clientid = XFS_LOG,
+			.oh_tid = cpu_to_be32(ticket->t_tid),
+			.oh_flags = XLOG_UNMOUNT_TRANS,
+		},
+		.ulf = {
+			.magic = XLOG_UNMOUNT_TYPE,
+		},
 	};
 	struct xfs_log_iovec reg = {
-		.i_addr = &ulf,
-		.i_len = sizeof(ulf),
+		.i_addr = &unmount_rec,
+		.i_len = sizeof(unmount_rec),
 		.i_type = XLOG_REG_TYPE_UNMOUNT,
 	};
 	struct xfs_log_vec vec = {
@@ -812,7 +822,7 @@ xlog_write_unmount_record(
 	};
 
 	/* account for space used by record data */
-	ticket->t_curr_res -= sizeof(ulf);
+	ticket->t_curr_res -= sizeof(unmount_rec);
 
 	/*
 	 * For external log devices, we need to flush the data device cache
@@ -2138,6 +2148,8 @@ xlog_write_calc_vec_length(
 
 	/* Don't account for regions with embedded ophdrs */
 	if (optype && headers > 0) {
+		if (optype & XLOG_UNMOUNT_TRANS)
+			headers--;
 		if (optype & XLOG_START_TRANS) {
 			ASSERT(headers >= 2);
 			headers -= 2;
@@ -2352,12 +2364,11 @@ xlog_write(
 
 	/*
 	 * If this is a commit or unmount transaction, we don't need a start
-	 * record to be written.  We do, however, have to account for the
-	 * commit or unmount header that gets written. Hence we always have
-	 * to account for an extra xlog_op_header here for commit and unmount
-	 * records.
+	 * record to be written.  We do, however, have to account for the commit
+	 * header that gets written. Hence we always have to account for an
+	 * extra xlog_op_header here for commit records.
 	 */
-	if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
+	if (optype & XLOG_COMMIT_TRANS)
 		ticket->t_curr_res -= sizeof(struct xlog_op_header);
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
@@ -2428,6 +2439,8 @@ xlog_write(
 				ophdr = reg->i_addr;
 				if (index)
 					optype &= ~XLOG_START_TRANS;
+			} else if (optype & XLOG_UNMOUNT_TRANS) {
+				ophdr = reg->i_addr;
 			} else {
 				ophdr = xlog_write_setup_ophdr(log, ptr,
 							ticket, optype);
@@ -2458,7 +2471,7 @@ xlog_write(
 			/*
 			 * Copy region.
 			 *
-			 * Commit and unmount records just log an opheader, so
+			 * Commit records just log an opheader, so
 			 * we can have empty payloads with no data region to
 			 * copy.  Hence we only copy the payload if the vector
 			 * says it has data to copy.
-- 
2.28.0

