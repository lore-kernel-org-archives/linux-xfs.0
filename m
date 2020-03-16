Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F4CC2BB1D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F065C20752
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Mso31FDh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgCPOvl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:51:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57672 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgCPOvl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wheVG5B0kOSmAUn9rE1vmn5CRhPhTt2G9LEGlfEo7C4=; b=Mso31FDhX3hiQrdKQYKwEhNuiM
        9rqqoMMcmy2wNdhPvB1ezmguyIKXTfK5Mm02vEP0RGT40obiD/2Hs5XkZMb2oNmvWFdn/TOcAiFpZ
        qUiHcfg7KHgDk5bhl0vSpQbQ6H26b3JhVOzaxoAWYWfYX+A6Zt1YqNW0WBUk1EBncTnSnmVrRPJoM
        WI5WTUDuPQhZCGN3XCyPsW8B1NAninJZjLMc8+giMHomineIvMZxHgzoYPCkcpgNB0xaWyYlLDuwZ
        sARKwe71+w0WmHNRDxDKeECi9yeeznFWUt96ZGXbZLySYhO54fZmRt6nJSb9cNfWoLk83S8gun04P
        0RkY3UfQ==;
Received: from [2001:4bb8:188:30cd:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDr5h-00007v-0a; Mon, 16 Mar 2020 14:51:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/14] xfs: move log shut down handling out of xlog_state_iodone_process_iclog
Date:   Mon, 16 Mar 2020 15:42:28 +0100
Message-Id: <20200316144233.900390-10-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316144233.900390-1-hch@lst.de>
References: <20200316144233.900390-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move handling of a shut down log out of xlog_state_iodone_process_iclog
and into xlog_state_do_callback so that it can be moved into an entirely
separate branch.  While doing so switch to using XLOG_FORCED_SHUTDOWN to
check the shutdown condition global to the log instead of the per-iclog
flag, and make sure the comments match reality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 64 ++++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c534d7007aa3..4efaa248a03d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2746,8 +2746,7 @@ xlog_state_do_iclog_callbacks(
 static bool
 xlog_state_iodone_process_iclog(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	bool			*ioerror)
+	struct xlog_in_core	*iclog)
 {
 	xfs_lsn_t		lowest_lsn;
 	xfs_lsn_t		header_lsn;
@@ -2759,15 +2758,6 @@ xlog_state_iodone_process_iclog(
 		 * Skip all iclogs in the ACTIVE & DIRTY states:
 		 */
 		return false;
-	case XLOG_STATE_IOERROR:
-		/*
-		 * Between marking a filesystem SHUTDOWN and stopping the log,
-		 * we do flush all iclogs to disk (if there wasn't a log I/O
-		 * error). So, we do want things to go smoothly in case of just
-		 * a SHUTDOWN w/o a LOG_IO_ERROR.
-		 */
-		*ioerror = true;
-		return false;
 	case XLOG_STATE_DONE_SYNC:
 		/*
 		 * Now that we have an iclog that is in the DONE_SYNC state, do
@@ -2795,39 +2785,41 @@ STATIC void
 xlog_state_do_callback(
 	struct xlog		*log)
 {
-	struct xlog_in_core	*iclog;
-	struct xlog_in_core	*first_iclog;
 	bool			cycled_icloglock;
-	bool			ioerror;
 	int			flushcnt = 0;
 	int			repeats = 0;
 
+	/*
+	 * Scan all iclogs starting with the one pointed to by the log.  Reset
+	 * this starting point each time the log is unlocked (during callbacks).
+	 *
+	 * Keep looping through iclogs until one full pass is made without
+	 * running any callbacks.
+	 *
+	 * If the log has been shut down, still perform the callbacks once per
+	 * iclog to abort all log items, but don't bother to restart the loop
+	 * after dropping the log as no new callbacks can show up.
+	 */
 	spin_lock(&log->l_icloglock);
 	do {
-		/*
-		 * Scan all iclogs starting with the one pointed to by the
-		 * log.  Reset this starting point each time the log is
-		 * unlocked (during callbacks).
-		 *
-		 * Keep looping through iclogs until one full pass is made
-		 * without running any callbacks.
-		 */
-		first_iclog = log->l_iclog;
-		iclog = log->l_iclog;
+		struct xlog_in_core	*first_iclog = log->l_iclog;
+		struct xlog_in_core	*iclog = first_iclog;
+
 		cycled_icloglock = false;
-		ioerror = false;
 		repeats++;
 
 		do {
-			if (xlog_state_iodone_process_iclog(log, iclog,
-							&ioerror))
+			if (XLOG_FORCED_SHUTDOWN(log)) {
+				xlog_state_do_iclog_callbacks(log, iclog);
+				wake_up_all(&iclog->ic_force_wait);
+				continue;
+			}
+
+			if (xlog_state_iodone_process_iclog(log, iclog))
 				break;
 
-			if (iclog->ic_state != XLOG_STATE_CALLBACK &&
-			    iclog->ic_state != XLOG_STATE_IOERROR) {
-				iclog = iclog->ic_next;
+			if (iclog->ic_state != XLOG_STATE_CALLBACK)
 				continue;
-			}
 
 			/*
 			 * Running callbacks will drop the icloglock which means
@@ -2835,12 +2827,8 @@ xlog_state_do_callback(
 			 */
 			cycled_icloglock = true;
 			xlog_state_do_iclog_callbacks(log, iclog);
-			if (XLOG_FORCED_SHUTDOWN(log))
-				wake_up_all(&iclog->ic_force_wait);
-			else
-				xlog_state_clean_iclog(log, iclog);
-			iclog = iclog->ic_next;
-		} while (first_iclog != iclog);
+			xlog_state_clean_iclog(log, iclog);
+		} while ((iclog = iclog->ic_next) != first_iclog);
 
 		if (repeats > 5000) {
 			flushcnt += repeats;
@@ -2849,7 +2837,7 @@ xlog_state_do_callback(
 				"%s: possible infinite loop (%d iterations)",
 				__func__, flushcnt);
 		}
-	} while (!ioerror && cycled_icloglock);
+	} while (cycled_icloglock);
 
 	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
 	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
-- 
2.24.1

