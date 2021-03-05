Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083B5C43332
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7DDC65014
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhCEFMz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:12:55 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:41258 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229646AbhCEFMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:12:15 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id B019F78A78B
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kh-00FbpA-6z
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:51 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-000laC-Uw
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 30/45] xfs: xlog_write() no longer needs contwr state
Date:   Fri,  5 Mar 2021 16:11:28 +1100
Message-Id: <20210305051143.182133-31-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=0CMaWtTLTcrcxSC13TsA:9
        a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The rework of xlog_write() no longer requires xlog_get_iclog_state()
to tell it about internal iclog space reservation state to direct it
on what to do. Remove this parameter.

$ size fs/xfs/xfs_log.o.*
   text	   data	    bss	    dec	    hex	filename
  26520	    560	      8	  27088	   69d0	fs/xfs/xfs_log.o.orig
  26384	    560	      8	  26952	   6948	fs/xfs/xfs_log.o.patched

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 10916b99bf0f..8f4f7ae84358 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -47,7 +47,6 @@ xlog_state_get_iclog_space(
 	int			len,
 	struct xlog_in_core	**iclog,
 	struct xlog_ticket	*ticket,
-	int			*continued_write,
 	int			*logoffsetp);
 STATIC void
 xlog_grant_push_ail(
@@ -2167,8 +2166,7 @@ xlog_write_get_more_iclog_space(
 	uint32_t		*log_offset,
 	uint32_t		len,
 	uint32_t		*record_cnt,
-	uint32_t		*data_cnt,
-	int			*contwr)
+	uint32_t		*data_cnt)
 {
 	struct xlog_in_core	*iclog = *iclogp;
 	int			error;
@@ -2182,8 +2180,8 @@ xlog_write_get_more_iclog_space(
 	if (error)
 		return error;
 
-	error = xlog_state_get_iclog_space(log, len, &iclog,
-				ticket, contwr, log_offset);
+	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
+					log_offset);
 	if (error)
 		return error;
 	*record_cnt = 0;
@@ -2207,8 +2205,7 @@ xlog_write_partial(
 	uint32_t		*log_offset,
 	uint32_t		*len,
 	uint32_t		*record_cnt,
-	uint32_t		*data_cnt,
-	int			*contwr)
+	uint32_t		*data_cnt)
 {
 	struct xlog_in_core	*iclog = *iclogp;
 	struct xfs_log_vec	*lv = log_vector;
@@ -2242,7 +2239,7 @@ xlog_write_partial(
 					sizeof(struct xlog_op_header)) {
 			error = xlog_write_get_more_iclog_space(log, ticket,
 					&iclog, log_offset, *len, record_cnt,
-					data_cnt, contwr);
+					data_cnt);
 			if (error)
 				return ERR_PTR(error);
 			ptr = iclog->ic_datap + *log_offset;
@@ -2298,7 +2295,7 @@ xlog_write_partial(
 			}
 			error = xlog_write_get_more_iclog_space(log, ticket,
 					&iclog, log_offset, *len, record_cnt,
-					data_cnt, contwr);
+					data_cnt);
 			if (error)
 				return ERR_PTR(error);
 			ptr = iclog->ic_datap + *log_offset;
@@ -2396,7 +2393,6 @@ xlog_write(
 {
 	struct xlog_in_core	*iclog = NULL;
 	struct xfs_log_vec	*lv = log_vector;
-	int			contwr = 0;
 	int			record_cnt = 0;
 	int			data_cnt = 0;
 	int			error = 0;
@@ -2410,7 +2406,7 @@ xlog_write(
 	}
 
 	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
-					   &contwr, &log_offset);
+					   &log_offset);
 	if (error)
 		return error;
 
@@ -2425,10 +2421,8 @@ xlog_write(
 	 * is correctly maintained in the storage media. This will always
 	 * fit in the iclog we have been already been passed.
 	 */
-	if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
+	if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
 		iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
-		ASSERT(!contwr);
-	}
 
 	while (lv) {
 		lv = xlog_write_single(lv, ticket, iclog, &log_offset,
@@ -2438,7 +2432,7 @@ xlog_write(
 
 		ASSERT(!(optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)));
 		lv = xlog_write_partial(log, lv, ticket, &iclog, &log_offset,
-					&len, &record_cnt, &data_cnt, &contwr);
+					&len, &record_cnt, &data_cnt);
 		if (IS_ERR_OR_NULL(lv)) {
 			error = PTR_ERR_OR_ZERO(lv);
 			break;
@@ -2452,7 +2446,6 @@ xlog_write(
 	 * those writes accounted to it. Hence we do not need to update the
 	 * iclog with the number of bytes written here.
 	 */
-	ASSERT(!contwr || XLOG_FORCED_SHUTDOWN(log));
 	spin_lock(&log->l_icloglock);
 	xlog_state_finish_copy(log, iclog, record_cnt, 0);
 	if (commit_iclog) {
@@ -2856,7 +2849,6 @@ xlog_state_get_iclog_space(
 	int			len,
 	struct xlog_in_core	**iclogp,
 	struct xlog_ticket	*ticket,
-	int			*continued_write,
 	int			*logoffsetp)
 {
 	int		  log_offset;
@@ -2932,13 +2924,10 @@ xlog_state_get_iclog_space(
 	 * iclogs (to mark it taken), this particular iclog will release/sync
 	 * to disk in xlog_write().
 	 */
-	if (len <= iclog->ic_size - iclog->ic_offset) {
-		*continued_write = 0;
+	if (len <= iclog->ic_size - iclog->ic_offset)
 		iclog->ic_offset += len;
-	} else {
-		*continued_write = 1;
+	else
 		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
-	}
 	*iclogp = iclog;
 
 	ASSERT(iclog->ic_offset <= iclog->ic_size);
-- 
2.28.0

