Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93DAC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 765702071B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:40:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kSsNGxmn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbgCLOkI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:40:08 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54960 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgCLOkH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:40:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=oRVZ/dN/nMP+98/E7lOu5ZV2QHeDEvN+UTRnLKnvKXM=; b=kSsNGxmnse7XoqPQ6ljd/A3E6k
        bNyuioFH8NJ8D+wHBf2Wi2r35XAjogNHmB1L1I9xcgsc26/mOhxqPEB+JX+dX8VA2tSf6pndNm4qr
        rjPgLhGFTJliZnmMo9pA3uoLuglj2bJ4dPfwd8mknARg5VA9Upq5smNrMFma9BMQ08TLib83VNk+5
        h6N1FNvt6vFZXF/oXApI/xHEgmUrxIgBhJCD66LkF52jEX8w5AjvnuQtg3hrGXE1o3iVPRquFHKTC
        ikImfIGcO6FVSkNAm9BuMbb2w+XAyN50dG8/Qw929o5DYHc2paF+sd5OTyxwcAKD+QWzvFXQEa3VB
        ldonQkaQ==;
Received: from [2001:4bb8:184:5cad:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCP0J-0007eQ-8G; Thu, 12 Mar 2020 14:40:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: remove the unused XLOG_UNMOUNT_REC_TYPE define
Date:   Thu, 12 Mar 2020 15:39:56 +0100
Message-Id: <20200312143959.583781-3-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312143959.583781-1-hch@lst.de>
References: <20200312143959.583781-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_priv.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index e400170ff4af..2b0aec37e73e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -525,12 +525,6 @@ xlog_cil_force(struct xlog *log)
 	xlog_cil_force_lsn(log, log->l_cilp->xc_current_sequence);
 }
 
-/*
- * Unmount record type is used as a pseudo transaction type for the ticket.
- * It's value must be outside the range of XFS_TRANS_* values.
- */
-#define XLOG_UNMOUNT_REC_TYPE	(-1U)
-
 /*
  * Wrapper function for waiting on a wait queue serialised against wakeups
  * by a spinlock. This matches the semantics of all the wait queues used in the
-- 
2.24.1

