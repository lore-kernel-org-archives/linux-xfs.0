Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60274C43217
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 443E761151
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbhKIBxv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:53:51 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:49536 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240895AbhKIBxs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:53:48 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 3598A46CA01
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:50:59 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006ZYX-Jq
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:50:58 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006UdP-IU
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:50:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/16] xfs: xlog_write() doesn't need optype anymore
Date:   Tue,  9 Nov 2021 12:50:54 +1100
Message-Id: <20211109015055.1547604-16-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015055.1547604-1-david@fromorbit.com>
References: <20211109015055.1547604-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6189d403
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=h-SXWOXjtDkxYT6DSOkA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So remove it from the interface and callers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 4 +---
 fs/xfs/xfs_log_cil.c  | 6 ++----
 fs/xfs/xfs_log_priv.h | 2 +-
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 406c14dbe926..9c0890d05fc4 100644
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
@@ -2485,7 +2484,6 @@ xlog_write(
 	struct xfs_cil_ctx	*ctx,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
-	uint			optype,
 	uint32_t		len)
 
 {
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 00243939b220..a31fb47c60f8 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -800,8 +800,7 @@ xlog_cil_write_chain(
 	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _START_RECORD);
 	if (error)
 		return error;
-	return xlog_write(log, ctx, chain, ctx->ticket, XLOG_START_TRANS,
-			chain_len);
+	return xlog_write(log, ctx, chain, ctx->ticket, chain_len);
 }
 
 /*
@@ -840,8 +839,7 @@ xlog_cil_write_commit_record(
 
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

