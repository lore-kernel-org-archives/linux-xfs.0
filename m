Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60524C43219
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 05:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiCIFap (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 00:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiCIFan (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 00:30:43 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9353C3FBD4
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 21:29:44 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AD5C810E26E1
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 16:29:40 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-003H5c-Tx
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 16:29:39 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-00BJXg-SW
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 16:29:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/16] xfs: xlog_write() doesn't need optype anymore
Date:   Wed,  9 Mar 2022 16:29:36 +1100
Message-Id: <20220309052937.2696447-16-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220309052937.2696447-1-david@fromorbit.com>
References: <20220309052937.2696447-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62283b45
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=D1V7Bn537i_hQWbBFjsA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So remove it from the interface and callers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log.c      | 4 +---
 fs/xfs/xfs_log_cil.c  | 6 ++----
 fs/xfs/xfs_log_priv.h | 2 +-
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index da660e09aa5c..9a49acd94516 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -966,8 +966,7 @@ xlog_write_unmount_record(
 	/* account for space used by record data */
 	ticket->t_curr_res -= sizeof(unmount_rec);
 
-	return xlog_write(log, NULL, &vec, ticket, XLOG_UNMOUNT_TRANS,
-			reg.i_len);
+	return xlog_write(log, NULL, &vec, ticket, reg.i_len);
 }
 
 /*
@@ -2483,7 +2482,6 @@ xlog_write(
 	struct xfs_cil_ctx	*ctx,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
-	uint			optype,
 	uint32_t		len)
 
 {
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index d4251c4ede25..f887184c77a4 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -824,8 +824,7 @@ xlog_cil_write_chain(
 	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _START_RECORD);
 	if (error)
 		return error;
-	return xlog_write(log, ctx, chain, ctx->ticket, XLOG_START_TRANS,
-			chain_len);
+	return xlog_write(log, ctx, chain, ctx->ticket, chain_len);
 }
 
 /*
@@ -864,8 +863,7 @@ xlog_cil_write_commit_record(
 
 	/* account for space used by record data */
 	ctx->ticket->t_curr_res -= reg.i_len;
-	error = xlog_write(log, ctx, &vec, ctx->ticket, XLOG_COMMIT_TRANS,
-			reg.i_len);
+	error = xlog_write(log, ctx, &vec, ctx->ticket, reg.i_len);
 	if (error)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 8c98b57e2a63..3008c0c884c7 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -480,7 +480,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
 		struct xfs_log_vec *log_vector, struct xlog_ticket *tic,
-		uint optype, uint32_t len);
+		uint32_t len);
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
-- 
2.33.0

