Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B312C4332E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 06:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D91A320777
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 06:53:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NBw41uxn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgCTGxa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 02:53:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42098 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgCTGxa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 02:53:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HUQUnKejNfBbZBsIrWmsA8h3Ps4w7k+1G2VJRz8heII=; b=NBw41uxna4yAyALrPNtSP48y2k
        E3Omwhp1rJHZRArPVoA1lYzrxumJ+DOgTAAnw9GtZok54qLeNfPWMVFhnaY1HMtnpOM8JH/Xp5XM5
        uNNy/G7WJo4QqEm0lZ9JnvQQEQZYkLm7mQnQsd8e9x7s8/o1xo4gf4wCieUPJmV7bMYR2tazlvV1q
        eG0R1mAnRAYc4pRC3LfZ+eO7zlz0exGueybd4fU0hsYIpaAQR8h6aVw25VRqpT2u+fhksTWsnm07V
        bcBLCELLjH7k+Yd9P/mMPBBJlw9vGTvXUhDLFgC6CFcoeFQQtlzq13hfux41QJaHNwtSc6icx0FUL
        3PU5E1qQ==;
Received: from [2001:4bb8:188:30cd:a410:8a7:7f20:5c9c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jFBX7-0006GN-I4; Fri, 20 Mar 2020 06:53:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfs: refactor xlog_state_clean_iclog
Date:   Fri, 20 Mar 2020 07:53:09 +0100
Message-Id: <20200320065311.28134-7-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200320065311.28134-1-hch@lst.de>
References: <20200320065311.28134-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor out a few self-contained helpers from xlog_state_clean_iclog, and
update the documentation so it primarily documents why things happens
instead of how.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 180 +++++++++++++++++++++++------------------------
 1 file changed, 88 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4f9303524efb..6facbb91b8a8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2540,111 +2540,107 @@ xlog_write(
  *****************************************************************************
  */
 
+static void
+xlog_state_activate_iclog(
+	struct xlog_in_core	*iclog,
+	int			*iclogs_changed)
+{
+	ASSERT(list_empty_careful(&iclog->ic_callbacks));
+
+	/*
+	 * If the number of ops in this iclog indicate it just contains the
+	 * dummy transaction, we can change state into IDLE (the second time
+	 * around). Otherwise we should change the state into NEED a dummy.
+	 * We don't need to cover the dummy.
+	 */
+	if (*iclogs_changed == 0 &&
+	    iclog->ic_header.h_num_logops == cpu_to_be32(XLOG_COVER_OPS)) {
+		*iclogs_changed = 1;
+	} else {
+		/*
+		 * We have two dirty iclogs so start over.  This could also be
+		 * num of ops indicating this is not the dummy going out.
+		 */
+		*iclogs_changed = 2;
+	}
+
+	iclog->ic_state	= XLOG_STATE_ACTIVE;
+	iclog->ic_offset = 0;
+	iclog->ic_header.h_num_logops = 0;
+	memset(iclog->ic_header.h_cycle_data, 0,
+		sizeof(iclog->ic_header.h_cycle_data));
+	iclog->ic_header.h_lsn = 0;
+}
+
 /*
- * An iclog has just finished IO completion processing, so we need to update
- * the iclog state and propagate that up into the overall log state. Hence we
- * prepare the iclog for cleaning, and then clean all the pending dirty iclogs
- * starting from the head, and then wake up any threads that are waiting for the
- * iclog to be marked clean.
- *
- * The ordering of marking iclogs ACTIVE must be maintained, so an iclog
- * doesn't become ACTIVE beyond one that is SYNCING.  This is also required to
- * maintain the notion that we use a ordered wait queue to hold off would be
- * writers to the log when every iclog is trying to sync to disk.
- *
- * Caller must hold the icloglock before calling us.
- *
- * State Change: !IOERROR -> DIRTY -> ACTIVE
+ * Loop through all iclogs and mark all iclogs currently marked DIRTY as
+ * ACTIVE after iclog I/O has completed.
  */
-STATIC void
-xlog_state_clean_iclog(
+static void
+xlog_state_activate_iclogs(
 	struct xlog		*log,
-	struct xlog_in_core	*dirty_iclog)
+	int			*iclogs_changed)
 {
-	struct xlog_in_core	*iclog;
-	int			changed = 0;
-
-	/* Prepare the completed iclog. */
-	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
-		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
+	struct xlog_in_core	*iclog = log->l_iclog;
 
-	/* Walk all the iclogs to update the ordered active state. */
-	iclog = log->l_iclog;
 	do {
-		if (iclog->ic_state == XLOG_STATE_DIRTY) {
-			iclog->ic_state	= XLOG_STATE_ACTIVE;
-			iclog->ic_offset       = 0;
-			ASSERT(list_empty_careful(&iclog->ic_callbacks));
-			/*
-			 * If the number of ops in this iclog indicate it just
-			 * contains the dummy transaction, we can
-			 * change state into IDLE (the second time around).
-			 * Otherwise we should change the state into
-			 * NEED a dummy.
-			 * We don't need to cover the dummy.
-			 */
-			if (!changed &&
-			   (be32_to_cpu(iclog->ic_header.h_num_logops) ==
-			   		XLOG_COVER_OPS)) {
-				changed = 1;
-			} else {
-				/*
-				 * We have two dirty iclogs so start over
-				 * This could also be num of ops indicates
-				 * this is not the dummy going out.
-				 */
-				changed = 2;
-			}
-			iclog->ic_header.h_num_logops = 0;
-			memset(iclog->ic_header.h_cycle_data, 0,
-			      sizeof(iclog->ic_header.h_cycle_data));
-			iclog->ic_header.h_lsn = 0;
-		} else if (iclog->ic_state == XLOG_STATE_ACTIVE)
-			/* do nothing */;
-		else
-			break;	/* stop cleaning */
-		iclog = iclog->ic_next;
-	} while (iclog != log->l_iclog);
-
+		if (iclog->ic_state == XLOG_STATE_DIRTY)
+			xlog_state_activate_iclog(iclog, iclogs_changed);
+		/*
+		 * The ordering of marking iclogs ACTIVE must be maintained, so
+		 * an iclog doesn't become ACTIVE beyond one that is SYNCING.
+		 */
+		else if (iclog->ic_state != XLOG_STATE_ACTIVE)
+			break;
+	} while ((iclog = iclog->ic_next) != log->l_iclog);
+}
 
+static int
+xlog_covered_state(
+	int			prev_state,
+	int			iclogs_changed)
+{
 	/*
-	 * Wake up threads waiting in xfs_log_force() for the dirty iclog
-	 * to be cleaned.
+	 * We usually go to NEED. But we go to NEED2 if the changed indicates we
+	 * are done writing the dummy record.  If we are done with the second
+	 * dummy recored (DONE2), then we go to IDLE.
 	 */
-	wake_up_all(&dirty_iclog->ic_force_wait);
+	switch (prev_state) {
+	case XLOG_STATE_COVER_IDLE:
+	case XLOG_STATE_COVER_NEED:
+	case XLOG_STATE_COVER_NEED2:
+		break;
+	case XLOG_STATE_COVER_DONE:
+		if (iclogs_changed == 1)
+			return XLOG_STATE_COVER_NEED2;
+		break;
+	case XLOG_STATE_COVER_DONE2:
+		if (iclogs_changed == 1)
+			return XLOG_STATE_COVER_IDLE;
+		break;
+	default:
+		ASSERT(0);
+	}
 
-	/*
-	 * Change state for the dummy log recording.
-	 * We usually go to NEED. But we go to NEED2 if the changed indicates
-	 * we are done writing the dummy record.
-	 * If we are done with the second dummy recored (DONE2), then
-	 * we go to IDLE.
-	 */
-	if (changed) {
-		switch (log->l_covered_state) {
-		case XLOG_STATE_COVER_IDLE:
-		case XLOG_STATE_COVER_NEED:
-		case XLOG_STATE_COVER_NEED2:
-			log->l_covered_state = XLOG_STATE_COVER_NEED;
-			break;
+	return XLOG_STATE_COVER_NEED;
+}
 
-		case XLOG_STATE_COVER_DONE:
-			if (changed == 1)
-				log->l_covered_state = XLOG_STATE_COVER_NEED2;
-			else
-				log->l_covered_state = XLOG_STATE_COVER_NEED;
-			break;
+STATIC void
+xlog_state_clean_iclog(
+	struct xlog		*log,
+	struct xlog_in_core	*dirty_iclog)
+{
+	int			iclogs_changed = 0;
 
-		case XLOG_STATE_COVER_DONE2:
-			if (changed == 1)
-				log->l_covered_state = XLOG_STATE_COVER_IDLE;
-			else
-				log->l_covered_state = XLOG_STATE_COVER_NEED;
-			break;
+	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
+		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
 
-		default:
-			ASSERT(0);
-		}
+	xlog_state_activate_iclogs(log, &iclogs_changed);
+	wake_up_all(&dirty_iclog->ic_force_wait);
+
+	if (iclogs_changed) {
+		log->l_covered_state = xlog_covered_state(log->l_covered_state,
+				iclogs_changed);
 	}
 }
 
-- 
2.25.1

