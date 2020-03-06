Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BDFC10F25
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97FD12072D
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TGMFWknT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgCFObn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 09:31:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39442 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgCFObn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:31:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=eCXaL8KdyMEPxUiQBKztikRQ/PPImF5/+Ftx+hESWGk=; b=TGMFWknT7ziHkuUnXaYusTyQUm
        6yNgVLKN3tBTe6RiMwJFY8kgBVj5Fs0PQxjKSAudd1etTCBEnV2QMmz7/nt0rURI0BG4dj8P7j+9z
        qCmQlXjlKH8Rx+L3Ol5yfMwZp1WaTPpMRyfk70CaaeCZH/TgHsYWZBCmPf0zNXuzdicpXPa0fFu8z
        XXlMkZT0nbGxJ7bfGiI4h9dOjA/eNHVEepuH70uE/wgAEP0spwem0YifVIwpDAbP/gzi1G31OqCcq
        9XmkRd2gTyyGtSmYuqtQqRwfjBP/+yVys9fL28lRmVHpJCchAzkrWhf/AvmyAZSlbixgJD6neVFgj
        z/OeWtqQ==;
Received: from [162.248.129.185] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAE0s-0008IS-NI; Fri, 06 Mar 2020 14:31:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/7] xfs: cleanup xlog_state_clean_iclog
Date:   Fri,  6 Mar 2020 07:31:36 -0700
Message-Id: <20200306143137.236478-7-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306143137.236478-1-hch@lst.de>
References: <20200306143137.236478-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use the shutdown flag in the log to bypass the iclog processing
instead of looking at the ioerror flag, and slightly simplify the
while loop processing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d1accad13af4..fae5107099b1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2582,30 +2582,29 @@ xlog_state_activate_iclog(
  *
  * Caller must hold the icloglock before calling us.
  *
- * State Change: !IOERROR -> DIRTY -> ACTIVE
+ * State Change: CALLBACK -> DIRTY -> ACTIVE
  */
 STATIC void
 xlog_state_clean_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*dirty_iclog)
 {
-	struct xlog_in_core	*iclog;
 	int			changed = 0;
 
-	/* Prepare the completed iclog. */
-	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
-		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
+	if (!XLOG_FORCED_SHUTDOWN(log)) {
+		struct xlog_in_core	*iclog = log->l_iclog;
 
-	/* Walk all the iclogs to update the ordered active state. */
-	iclog = log->l_iclog;
-	do {
-		if (iclog->ic_state == XLOG_STATE_DIRTY)
-			xlog_state_activate_iclog(iclog, &changed);
-		else if (iclog->ic_state != XLOG_STATE_ACTIVE)
-			break;
-		iclog = iclog->ic_next;
-	} while (iclog != log->l_iclog);
+		/* Prepare the completed iclog. */
+		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
 
+		/* Walk all the iclogs to update the ordered active state. */
+		do {
+			if (iclog->ic_state == XLOG_STATE_DIRTY)
+				xlog_state_activate_iclog(iclog, &changed);
+			else if (iclog->ic_state != XLOG_STATE_ACTIVE)
+				break;
+		} while ((iclog = iclog->ic_next) != log->l_iclog);
+	}
 
 	/*
 	 * Wake up threads waiting in xfs_log_force() for the dirty iclog
-- 
2.24.1

