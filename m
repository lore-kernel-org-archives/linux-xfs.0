Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4786C10F00
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7927620848
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NwP7i3Bd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgCFObm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 09:31:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39434 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgCFObl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:31:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mSzvQ4nOT9G0jvA6fGXyviaeQaAFuw3gUrLegIbJh64=; b=NwP7i3BdKKuuabLRTLXlGvSyxV
        lmdggvlDzgoBw0+ACqQiVd+99gGkGq8WBgUkW9OcrxSCByZe89L90rUe/PX3KapS7XCE/xSkCCi7N
        oA2cQ+Q07JaI/xAfz0aLH/ZquhKVD9yz3SihzuW5HPfI/K3WUG2UvIkbxS3vqeJnbsQHiTw+crSTl
        cjozNjywWzG6izCCL/E8EJ0u/go2OKxCXEpPuIyC1cx10CIfrYQjOU+31aMqkS/HahpQShWJaSiM0
        Q8ZKZOzn5Udz3gTZd13v2tYzNU7UsxFKpq2cdwlUPP3iy/+Am6nkjKLBc+T8SSnJre9QjZQUZ+ifI
        s7NkqxFA==;
Received: from [162.248.129.185] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAE0r-0008I8-I8; Fri, 06 Mar 2020 14:31:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/7] xfs: factor out a xlog_state_activate_iclog helper
Date:   Fri,  6 Mar 2020 07:31:35 -0700
Message-Id: <20200306143137.236478-6-hch@lst.de>
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

Factor out the code to mark an iclog a active into a new helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 68 +++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 45f7a6eaddea..d1accad13af4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2536,6 +2536,38 @@ xlog_write(
  *****************************************************************************
  */
 
+static void
+xlog_state_activate_iclog(
+	struct xlog_in_core	*iclog,
+	int			*changed)
+{
+	ASSERT(list_empty_careful(&iclog->ic_callbacks));
+
+	/*
+	 * If the number of ops in this iclog indicate it just contains the
+	 * dummy transaction, we can change state into IDLE (the second time
+	 * around). Otherwise we should change the state into NEED a dummy.
+	 * We don't need to cover the dummy.
+	 */
+	if (!*changed &&
+	    iclog->ic_header.h_num_logops == cpu_to_be32(XLOG_COVER_OPS)) {
+		*changed = 1;
+	} else {
+		/*
+		 * We have two dirty iclogs so start over.  This could also be
+		 * num of ops indicating this is not the dummy going out.
+		 */
+		*changed = 2;
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
  * An iclog has just finished IO completion processing, so we need to update
  * the iclog state and propagate that up into the overall log state. Hence we
@@ -2567,38 +2599,10 @@ xlog_state_clean_iclog(
 	/* Walk all the iclogs to update the ordered active state. */
 	iclog = log->l_iclog;
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
+		if (iclog->ic_state == XLOG_STATE_DIRTY)
+			xlog_state_activate_iclog(iclog, &changed);
+		else if (iclog->ic_state != XLOG_STATE_ACTIVE)
+			break;
 		iclog = iclog->ic_next;
 	} while (iclog != log->l_iclog);
 
-- 
2.24.1

