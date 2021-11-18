Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C224C4321E
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 23:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 734D161360
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 23:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbhKRXQ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Nov 2021 18:16:58 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57629 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233051AbhKRXQ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Nov 2021 18:16:57 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9D8538A127A
        for <linux-xfs@vger.kernel.org>; Fri, 19 Nov 2021 10:13:54 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mnqbK-00AThf-38
        for linux-xfs@vger.kernel.org; Fri, 19 Nov 2021 10:13:54 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mnqbK-008bpr-2C
        for linux-xfs@vger.kernel.org;
        Fri, 19 Nov 2021 10:13:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/16] xfs: xlog_write() doesn't need optype anymore
Date:   Fri, 19 Nov 2021 10:13:51 +1100
Message-Id: <20211118231352.2051947-16-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211118231352.2051947-1-david@fromorbit.com>
References: <20211118231352.2051947-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6196de32
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=D1V7Bn537i_hQWbBFjsA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So remove it from the interface and callers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 99ef13f1b248..ad98e4df0e2c 100644
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

