Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D42BC197A0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 356476115B
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240512AbhKIBxu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:53:50 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36353 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240844AbhKIBxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:53:47 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2809C104F1CF
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:50:59 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006ZYU-Id
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:50:58 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006UdL-HS
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:50:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/16] xfs: xlog_write() no longer needs contwr state
Date:   Tue,  9 Nov 2021 12:50:53 +1100
Message-Id: <20211109015055.1547604-15-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015055.1547604-1-david@fromorbit.com>
References: <20211109015055.1547604-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6189d403
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=K4jvhJFr1avL_kiYnQUA:9 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19
        a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19 a=AjGcO6oz07-iQ99wixmX:22
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
 fs/xfs/xfs_log.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d6ef555b1310..406c14dbe926 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -49,7 +49,6 @@ xlog_state_get_iclog_space(
 	int			len,
 	struct xlog_in_core	**iclog,
 	struct xlog_ticket	*ticket,
-	int			*continued_write,
 	int			*logoffsetp);
 STATIC void
 xlog_grant_push_ail(
@@ -2279,8 +2278,7 @@ xlog_write_get_more_iclog_space(
 	uint32_t		*log_offset,
 	uint32_t		len,
 	uint32_t		*record_cnt,
-	uint32_t		*data_cnt,
-	int			*contwr)
+	uint32_t		*data_cnt)
 {
 	struct xlog_in_core	*iclog = *iclogp;
 	struct xlog		*log = iclog->ic_log;
@@ -2294,8 +2292,8 @@ xlog_write_get_more_iclog_space(
 	if (error)
 		return error;
 
-	error = xlog_state_get_iclog_space(log, len, &iclog,
-				ticket, contwr, log_offset);
+	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
+					log_offset);
 	if (error)
 		return error;
 	*record_cnt = 0;
@@ -2318,8 +2316,7 @@ xlog_write_partial(
 	uint32_t		*log_offset,
 	uint32_t		*len,
 	uint32_t		*record_cnt,
-	uint32_t		*data_cnt,
-	int			*contwr)
+	uint32_t		*data_cnt)
 {
 	struct xlog_in_core	*iclog = *iclogp;
 	struct xlog_op_header	*ophdr;
@@ -2347,7 +2344,7 @@ xlog_write_partial(
 					sizeof(struct xlog_op_header)) {
 			error = xlog_write_get_more_iclog_space(ticket,
 					&iclog, log_offset, *len, record_cnt,
-					data_cnt, contwr);
+					data_cnt);
 			if (error)
 				return error;
 		}
@@ -2399,7 +2396,7 @@ xlog_write_partial(
 			error = xlog_write_get_more_iclog_space(ticket,
 					&iclog, log_offset,
 					*len + sizeof(struct xlog_op_header),
-					record_cnt, data_cnt, contwr);
+					record_cnt, data_cnt);
 			if (error)
 				return error;
 
@@ -2494,7 +2491,6 @@ xlog_write(
 {
 	struct xlog_in_core	*iclog = NULL;
 	struct xfs_log_vec	*lv = log_vector;
-	int			contwr = 0;
 	uint32_t		record_cnt = 0;
 	uint32_t		data_cnt = 0;
 	int			error = 0;
@@ -2508,7 +2504,7 @@ xlog_write(
 	}
 
 	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
-					   &contwr, &log_offset);
+					   &log_offset);
 	if (error)
 		return error;
 
@@ -2531,7 +2527,7 @@ xlog_write(
 		    lv->lv_bytes > iclog->ic_size - log_offset) {
 			error = xlog_write_partial(lv, ticket, &iclog,
 					&log_offset, &len, &record_cnt,
-					&data_cnt, &contwr);
+					&data_cnt);
 			if (error) {
 				/*
 				 * We have no iclog to release, so just return
@@ -2911,7 +2907,6 @@ xlog_state_get_iclog_space(
 	int			len,
 	struct xlog_in_core	**iclogp,
 	struct xlog_ticket	*ticket,
-	int			*continued_write,
 	int			*logoffsetp)
 {
 	int		  log_offset;
@@ -2989,13 +2984,10 @@ xlog_state_get_iclog_space(
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
2.33.0

