Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE663C18E5B
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6C2420752
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:51:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZLxc3UAw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731616AbgCPOvq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:51:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgCPOvq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:51:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TLsTbknoGwww1fS9CdEYfWZmbz+yhcRDhJfnXsoxH5Q=; b=ZLxc3UAw7ZxGE4ts7ngPjmg2Wa
        niZitxpORo25IOO6L3BIWJRjr/VqXseqt/C+zQJBipjiZL0fexobt9+DBtWcTnX0CWMvEqNhbM2ZH
        N1TrkruK9u+F2gBcHDzOP7npHWluyh69TSuygEASjeuJBGcX3t8uBD5gDwji7lHi0WHBx7LJMAVzl
        +02jsT4iU+pb1ZLVErgdsUfRQ3Tk3pAFEyiKUdK6osMiF0ypgPmTctEx786nisZa69CkksRpYMpYZ
        XRlTYfLwq5p5pgEght2lK2snRtVeTasGeXCebwbUtSyj2ITZfGj0sQV1N1kFaTIFTujQZRi7Kk8eX
        YmNqdsjw==;
Received: from [2001:4bb8:188:30cd:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDr5l-00008W-Ol; Mon, 16 Mar 2020 14:51:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/14] xfs: merge xlog_state_clean_iclog into xlog_state_iodone_process_iclog
Date:   Mon, 16 Mar 2020 15:42:30 +0100
Message-Id: <20200316144233.900390-12-hch@lst.de>
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

Merge xlog_state_clean_iclog into its only caller, which makes the iclog
I/O completion handling a little easier to follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a38d495b6e81..899c324d07e2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2625,22 +2625,6 @@ xlog_covered_state(
 	return XLOG_STATE_COVER_NEED;
 }
 
-STATIC void
-xlog_state_clean_iclog(
-	struct xlog		*log,
-	struct xlog_in_core	*dirty_iclog)
-{
-	int			iclogs_changed = 0;
-
-	dirty_iclog->ic_state = XLOG_STATE_DIRTY;
-
-	xlog_state_activate_iclogs(log, &iclogs_changed);
-	wake_up_all(&dirty_iclog->ic_force_wait);
-
-	if (iclogs_changed)
-		log->l_covered_state = xlog_covered_state(log, iclogs_changed);
-}
-
 STATIC xfs_lsn_t
 xlog_get_lowest_lsn(
 	struct xlog		*log)
@@ -2744,6 +2728,7 @@ xlog_state_iodone_process_iclog(
 	struct xlog_in_core	*iclog)
 {
 	xfs_lsn_t		header_lsn, lowest_lsn;
+	int			iclogs_changed = 0;
 
 	/*
 	 * Now that we have an iclog that is in the DONE_SYNC state, do one more
@@ -2758,7 +2743,13 @@ xlog_state_iodone_process_iclog(
 
 	xlog_state_set_callback(log, iclog, header_lsn);
 	xlog_state_do_iclog_callbacks(log, iclog);
-	xlog_state_clean_iclog(log, iclog);
+
+	iclog->ic_state = XLOG_STATE_DIRTY;
+	xlog_state_activate_iclogs(log, &iclogs_changed);
+
+	wake_up_all(&iclog->ic_force_wait);
+	if (iclogs_changed)
+		log->l_covered_state = xlog_covered_state(log, iclogs_changed);
 	return true;
 }
 
-- 
2.24.1

