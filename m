Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD6AC0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26CE62075E
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OGfcbq5y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731577AbgCPOvg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:51:36 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57656 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgCPOvg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:51:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=or0HmCakARX90E/i52GuvIU7WIEDqsXBhdHF750qPtI=; b=OGfcbq5yRVH85pDRFEl3WUQlRj
        erIfCteN9FnbXTxn2OrqRJxnW3wy9IYzMeFXy7yyH/4e3snHPq1aEH3qR3/Vu6Ouh5tObF9VCqrqi
        T7JX1d3kX25kjd6WLl3p9PzvZ2fl7sbr/IpLZ6l3YpWCXiK15/Z2ov772REEOx9+a7FzEqS93pdQq
        AwFV793VXnYcvlV/eG4U6wTP8jlgPjHST7GOUlNxoTbHhCvY7SNraolyM9x+Kn89kKEMeTA9EnbhV
        0BSNQfT9OmtVEn2nbvMZ7LxQ5ZUCyJBAxPOT5Fa5L044QKsCrsrQ+As0R9yCsNRrlwtBuf6teQjPq
        L01jTaDg==;
Received: from [2001:4bb8:188:30cd:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDr5c-00007H-37; Mon, 16 Mar 2020 14:51:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/14] xfs: move the ioerror check out of xlog_state_clean_iclog
Date:   Mon, 16 Mar 2020 15:42:26 +0100
Message-Id: <20200316144233.900390-8-hch@lst.de>
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

Use the shutdown flag in the log to bypass xlog_state_clean_iclog
entirely in case of a shut down log.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 23979d08a2a3..c490c5b0d8b7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2632,8 +2632,7 @@ xlog_state_clean_iclog(
 {
 	int			iclogs_changed = 0;
 
-	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
-		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
+	dirty_iclog->ic_state = XLOG_STATE_DIRTY;
 
 	xlog_state_activate_iclogs(log, &iclogs_changed);
 	wake_up_all(&dirty_iclog->ic_force_wait);
@@ -2836,8 +2835,10 @@ xlog_state_do_callback(
 			 */
 			cycled_icloglock = true;
 			xlog_state_do_iclog_callbacks(log, iclog);
-
-			xlog_state_clean_iclog(log, iclog);
+			if (XLOG_FORCED_SHUTDOWN(log))
+				wake_up_all(&iclog->ic_force_wait);
+			else
+				xlog_state_clean_iclog(log, iclog);
 			iclog = iclog->ic_next;
 		} while (first_iclog != iclog);
 
-- 
2.24.1

