Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754753AbdEHUpJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 May 2017 16:45:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4966F7F4BA
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2017 20:45:09 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 134915DC19
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2017 20:45:09 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/3] xfs: dump transaction usage details on log reservation overrun
Date: Mon,  8 May 2017 16:45:07 -0400
Message-Id: <1494276307-36887-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1494276307-36887-1-git-send-email-bfoster@redhat.com>
References: <1494276307-36887-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

If a transaction log reservation overrun occurs, the ticket data
associated with the reservation is dumped in xfs_log_commit_cil().
This occurs long after the transaction items and details have been
removed from the transaction and effectively lost. This limited set
of ticket data provides very little information to support debugging
transaction overruns based on the typical report.

To improve transaction log reservation overrun reporting, create a
helper to dump transaction details such as log items, log vector
data, etc., as well as the underlying ticket data for the
transaction. Move the overrun detection from xfs_log_commit_cil() to
xlog_cil_insert_items() so it occurs prior to migration of the
logged items to the CIL. Call the new helper such that it is able to
dump this transaction data before it is lost.

Also, warn on overrun to provide callstack context for the offending
transaction and include a few additional messages from
xlog_cil_insert_items() to display the reservation consumed locally
for overhead such as log vector headers, split region headers and
the context ticket. This provides a complete general breakdown of
the reservation consumption of a transaction when/if it happens to
overrun the reservation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c      | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_cil.c  | 24 ++++++++++++++++++------
 fs/xfs/xfs_log_priv.h |  1 +
 3 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8b283f7..c8d0481 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2048,6 +2048,55 @@ xlog_print_tic_res(
 }
 
 /*
+ * Print a summary of the transaction.
+ */
+void
+xlog_print_trans(
+	struct xfs_trans		*tp)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_log_item_desc	*lidp;
+
+	/* dump core transaction and ticket info */
+	xfs_warn(mp, "transaction summary:");
+	xfs_warn(mp, "  flags	= 0x%x", tp->t_flags);
+
+	xlog_print_tic_res(mp, tp->t_ticket);
+
+	/* dump each log item */
+	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
+		struct xfs_log_item	*lip = lidp->lid_item;
+		struct xfs_log_vec	*lv = lip->li_lv;
+		struct xfs_log_iovec	*vec;
+		int			i;
+
+		xfs_warn(mp, "log item: ");
+		xfs_warn(mp, "  type	= 0x%x", lip->li_type);
+		xfs_warn(mp, "  flags	= 0x%x", lip->li_flags);
+		if (!lv)
+			continue;
+		xfs_warn(mp, "  niovecs	= %d", lv->lv_niovecs);
+		xfs_warn(mp, "  size	= %d", lv->lv_size);
+		xfs_warn(mp, "  bytes	= %d", lv->lv_bytes);
+		xfs_warn(mp, "  buf len	= %d", lv->lv_buf_len);
+
+		/* dump each iovec for the log item */
+		vec = lv->lv_iovecp;
+		for (i = 0; i < lv->lv_niovecs; i++) {
+			int dumplen = min(vec->i_len, 32);
+
+			xfs_warn(mp, "  iovec[%d]", i);
+			xfs_warn(mp, "    type	= 0x%x", vec->i_type);
+			xfs_warn(mp, "    len	= %d", vec->i_len);
+			xfs_warn(mp, "    first %d bytes of iovec[%d]:", dumplen, i);
+			xfs_hex_dump(vec->i_addr, dumplen);;
+
+			vec++;
+		}
+	}
+}
+
+/*
  * Calculate the potential space needed by the log vector.  Each region gets
  * its own xlog_op_header_t and may need to be double word aligned.
  */
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 8de3baa..04b3892 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -460,6 +460,21 @@ xlog_cil_insert_items(
 	ctx->space_used += len;
 
 	/*
+	 * If we've overrun the reservation, dump the tx details before we move
+	 * the log items. Shutdown is imminent...
+	 */
+	if (WARN_ON(tp->t_ticket->t_curr_res < 0)) {
+		xfs_warn(log->l_mp, "Transaction log reservation overrun:");
+		xfs_warn(log->l_mp,
+			 "  log items: %d bytes (iov hdrs: %d bytes)",
+			 len, iovhdr_res);
+		xfs_warn(log->l_mp, "  split region headers: %d bytes",
+			 split_res);
+		xfs_warn(log->l_mp, "  ctx ticket: %d bytes", ctx_res);
+		xlog_print_trans(tp);
+	}
+
+	/*
 	 * Now (re-)position everything modified at the tail of the CIL.
 	 * We do this here so we only need to take the CIL lock once during
 	 * the transaction commit.
@@ -481,6 +496,9 @@ xlog_cil_insert_items(
 	}
 
 	spin_unlock(&cil->xc_cil_lock);
+
+	if (tp->t_ticket->t_curr_res < 0)
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 }
 
 static void
@@ -988,12 +1006,6 @@ xfs_log_commit_cil(
 
 	xlog_cil_insert_items(log, tp);
 
-	/* check we didn't blow the reservation */
-	if (tp->t_ticket->t_curr_res < 0) {
-		xlog_print_tic_res(mp, tp->t_ticket);
-		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
-	}
-
 	tp->t_commit_lsn = cil->xc_ctx->sequence;
 	if (commit_lsn)
 		*commit_lsn = tp->t_commit_lsn;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index c2604a5..62113a5 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -456,6 +456,7 @@ xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
 }
 
 void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
+void	xlog_print_trans(struct xfs_trans *);
 int
 xlog_write(
 	struct xlog		*log,
-- 
2.7.4

