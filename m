Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077F7C4361B
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC9066109F
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241404AbhESMOr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:14:47 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:49711 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353353AbhESMOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:44 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id B302D10A5FD
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002m1T-9O
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002SHY-1M
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 23/39] xfs: xlog_write() no longer needs contwr state
Date:   Wed, 19 May 2021 22:13:01 +1000
Message-Id: <20210519121317.585244-24-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=0CMaWtTLTcrcxSC13TsA:9 a=AjGcO6oz07-iQ99wixmX:22
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 98a3e2e4f1e0..574078985f0a 100644
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
@@ -2178,8 +2177,7 @@ xlog_write_get_more_iclog_space(
 	uint32_t		*log_offset,
 	uint32_t		len,
 	uint32_t		*record_cnt,
-	uint32_t		*data_cnt,
-	int			*contwr)
+	uint32_t		*data_cnt)
 {
 	struct xlog_in_core	*iclog = *iclogp;
 	int			error;
@@ -2193,8 +2191,8 @@ xlog_write_get_more_iclog_space(
 	if (error)
 		return error;
 
-	error = xlog_state_get_iclog_space(log, len, &iclog,
-				ticket, contwr, log_offset);
+	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
+					log_offset);
 	if (error)
 		return error;
 	*record_cnt = 0;
@@ -2218,8 +2216,7 @@ xlog_write_partial(
 	uint32_t		*log_offset,
 	uint32_t		*len,
 	uint32_t		*record_cnt,
-	uint32_t		*data_cnt,
-	int			*contwr)
+	uint32_t		*data_cnt)
 {
 	struct xlog_in_core	*iclog = *iclogp;
 	struct xfs_log_vec	*lv = log_vector;
@@ -2253,7 +2250,7 @@ xlog_write_partial(
 					sizeof(struct xlog_op_header)) {
 			error = xlog_write_get_more_iclog_space(log, ticket,
 					&iclog, log_offset, *len, record_cnt,
-					data_cnt, contwr);
+					data_cnt);
 			if (error)
 				return ERR_PTR(error);
 			ptr = iclog->ic_datap + *log_offset;
@@ -2309,7 +2306,7 @@ xlog_write_partial(
 
 			error = xlog_write_get_more_iclog_space(log, ticket,
 					&iclog, log_offset, *len, record_cnt,
-					data_cnt, contwr);
+					data_cnt);
 			if (error)
 				return ERR_PTR(error);
 			ptr = iclog->ic_datap + *log_offset;
@@ -2407,7 +2404,6 @@ xlog_write(
 {
 	struct xlog_in_core	*iclog = NULL;
 	struct xfs_log_vec	*lv = log_vector;
-	int			contwr = 0;
 	int			record_cnt = 0;
 	int			data_cnt = 0;
 	int			error = 0;
@@ -2421,7 +2417,7 @@ xlog_write(
 	}
 
 	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
-					   &contwr, &log_offset);
+					   &log_offset);
 	if (error)
 		return error;
 
@@ -2437,7 +2433,7 @@ xlog_write(
 
 		ASSERT(!(optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)));
 		lv = xlog_write_partial(log, lv, ticket, &iclog, &log_offset,
-					&len, &record_cnt, &data_cnt, &contwr);
+					&len, &record_cnt, &data_cnt);
 		if (IS_ERR_OR_NULL(lv)) {
 			error = PTR_ERR_OR_ZERO(lv);
 			break;
@@ -2451,7 +2447,6 @@ xlog_write(
 	 * those writes accounted to it. Hence we do not need to update the
 	 * iclog with the number of bytes written here.
 	 */
-	ASSERT(!contwr || XLOG_FORCED_SHUTDOWN(log));
 	spin_lock(&log->l_icloglock);
 	xlog_state_finish_copy(log, iclog, record_cnt, 0);
 	if (commit_iclog) {
@@ -2855,7 +2850,6 @@ xlog_state_get_iclog_space(
 	int			len,
 	struct xlog_in_core	**iclogp,
 	struct xlog_ticket	*ticket,
-	int			*continued_write,
 	int			*logoffsetp)
 {
 	int		  log_offset;
@@ -2931,13 +2925,10 @@ xlog_state_get_iclog_space(
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
2.31.1

