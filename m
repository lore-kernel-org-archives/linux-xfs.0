Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDC5C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 05:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiCIFal (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 00:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiCIFak (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 00:30:40 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CF603F8A2
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 21:29:41 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A8FE953109E
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 16:29:40 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-003H5Z-Sp
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 16:29:39 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-00BJXb-RV
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 16:29:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/16] xfs: xlog_write() no longer needs contwr state
Date:   Wed,  9 Mar 2022 16:29:35 +1100
Message-Id: <20220309052937.2696447-15-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220309052937.2696447-1-david@fromorbit.com>
References: <20220309052937.2696447-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62283b44
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ca8a9313d9c5..da660e09aa5c 100644
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
@@ -2277,8 +2276,7 @@ xlog_write_get_more_iclog_space(
 	uint32_t		*log_offset,
 	uint32_t		len,
 	uint32_t		*record_cnt,
-	uint32_t		*data_cnt,
-	int			*contwr)
+	uint32_t		*data_cnt)
 {
 	struct xlog_in_core	*iclog = *iclogp;
 	struct xlog		*log = iclog->ic_log;
@@ -2292,8 +2290,8 @@ xlog_write_get_more_iclog_space(
 	if (error)
 		return error;
 
-	error = xlog_state_get_iclog_space(log, len, &iclog,
-				ticket, contwr, log_offset);
+	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
+					log_offset);
 	if (error)
 		return error;
 	*record_cnt = 0;
@@ -2316,8 +2314,7 @@ xlog_write_partial(
 	uint32_t		*log_offset,
 	uint32_t		*len,
 	uint32_t		*record_cnt,
-	uint32_t		*data_cnt,
-	int			*contwr)
+	uint32_t		*data_cnt)
 {
 	struct xlog_in_core	*iclog = *iclogp;
 	struct xlog_op_header	*ophdr;
@@ -2345,7 +2342,7 @@ xlog_write_partial(
 					sizeof(struct xlog_op_header)) {
 			error = xlog_write_get_more_iclog_space(ticket,
 					&iclog, log_offset, *len, record_cnt,
-					data_cnt, contwr);
+					data_cnt);
 			if (error)
 				return error;
 		}
@@ -2397,7 +2394,7 @@ xlog_write_partial(
 			error = xlog_write_get_more_iclog_space(ticket,
 					&iclog, log_offset,
 					*len + sizeof(struct xlog_op_header),
-					record_cnt, data_cnt, contwr);
+					record_cnt, data_cnt);
 			if (error)
 				return error;
 
@@ -2492,7 +2489,6 @@ xlog_write(
 {
 	struct xlog_in_core	*iclog = NULL;
 	struct xfs_log_vec	*lv = log_vector;
-	int			contwr = 0;
 	uint32_t		record_cnt = 0;
 	uint32_t		data_cnt = 0;
 	int			error = 0;
@@ -2506,7 +2502,7 @@ xlog_write(
 	}
 
 	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
-					   &contwr, &log_offset);
+					   &log_offset);
 	if (error)
 		return error;
 
@@ -2529,7 +2525,7 @@ xlog_write(
 		    lv->lv_bytes > iclog->ic_size - log_offset) {
 			error = xlog_write_partial(lv, ticket, &iclog,
 					&log_offset, &len, &record_cnt,
-					&data_cnt, &contwr);
+					&data_cnt);
 			if (error) {
 				/*
 				 * We have no iclog to release, so just return
@@ -2909,7 +2905,6 @@ xlog_state_get_iclog_space(
 	int			len,
 	struct xlog_in_core	**iclogp,
 	struct xlog_ticket	*ticket,
-	int			*continued_write,
 	int			*logoffsetp)
 {
 	int		  log_offset;
@@ -2987,13 +2982,10 @@ xlog_state_get_iclog_space(
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

