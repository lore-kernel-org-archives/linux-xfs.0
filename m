Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752402AbdEHUpJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 May 2017 16:45:09 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1F1ED7F4B8
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2017 20:45:09 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F134F171C9
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2017 20:45:08 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/3] xfs: separate shutdown from ticket reservation print helper
Date: Mon,  8 May 2017 16:45:05 -0400
Message-Id: <1494276307-36887-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1494276307-36887-1-git-send-email-bfoster@redhat.com>
References: <1494276307-36887-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xlog_print_tic_res() pre-dates delayed logging and the committed
items list (CIL) and thus retains some factoring warts, such as hard
coded function names in the output and the fact that it induces a
shutdown.

In preparation for more detailed logging of regular transaction
overrun situations, refactor xlog_print_tic_res() to be slightly
more generic. Reword some of the warning messages and pull the
shutdown into the callers.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c     | 12 ++++++------
 fs/xfs/xfs_log_cil.c |  4 +++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3731f13..8b283f7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2024,7 +2024,7 @@ xlog_print_tic_res(
 	};
 #undef REG_TYPE_STR
 
-	xfs_warn(mp, "xlog_write: reservation summary:");
+	xfs_warn(mp, "ticket reservation summary:");
 	xfs_warn(mp, "  unit res    = %d bytes",
 		 ticket->t_unit_res);
 	xfs_warn(mp, "  current res = %d bytes",
@@ -2045,10 +2045,6 @@ xlog_print_tic_res(
 			    "bad-rtype" : res_type_str[r_type]),
 			    ticket->t_res_arr[i].r_len);
 	}
-
-	xfs_alert_tag(mp, XFS_PTAG_LOGRES,
-		"xlog_write: reservation ran out. Need to up reservation");
-	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 }
 
 /*
@@ -2321,8 +2317,12 @@ xlog_write(
 	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
 		ticket->t_curr_res -= sizeof(xlog_op_header_t);
 
-	if (ticket->t_curr_res < 0)
+	if (ticket->t_curr_res < 0) {
+		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
+		     "ctx ticket reservation ran out. Need to up reservation");
 		xlog_print_tic_res(log->l_mp, ticket);
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+	}
 
 	index = 0;
 	lv = log_vector;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 82f1cbc..52fe042 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -987,8 +987,10 @@ xfs_log_commit_cil(
 	xlog_cil_insert_items(log, tp);
 
 	/* check we didn't blow the reservation */
-	if (tp->t_ticket->t_curr_res < 0)
+	if (tp->t_ticket->t_curr_res < 0) {
 		xlog_print_tic_res(mp, tp->t_ticket);
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+	}
 
 	tp->t_commit_lsn = cil->xc_ctx->sequence;
 	if (commit_lsn)
-- 
2.7.4

