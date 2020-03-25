Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D93C2D0E6
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 18:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 525BB2076F
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 18:49:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BUJjRSFl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgCYSt5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 14:49:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55124 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgCYSt4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 14:49:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Si3/WDTJvRNBgIkkMy9DmgJd//g6sw8OatDExN+N9HM=; b=BUJjRSFlDQ6FUHEHU7ZYE+emDG
        S/V2TzsSEPNiAA5sbpdtXu0bqKXzBIJx8yxzV17Uf64Rtbzf6toa4SKwh+wp/PM1rnCaUVCdroivv
        pYdn15VX6IWH0rx/pWWcNm7nwSUXrJiRGGrqMhbgZAVMkCxmqOyzap3L/G5AEWuJu7RDnPcTXRcOq
        9EA4zu+8St3BCnJlvHtqlpafuACAxmJQ4HEfrEO/QVi6Pi4I1VumvJdIxezXUaDR1tnB0gRWrqbSh
        PmD4Hptr1LcY4g6ofGU1c0nVH33Grx39LiPbnHhpwaI1mzeWcRX+TRG84SD/4KTpZwUtH6oyDTKRO
        ZkQ91o0A==;
Received: from [2001:4bb8:18c:2a9e:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHB6C-000377-8Q; Wed, 25 Mar 2020 18:49:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 7/8] xfs: refactor unmount record writing
Date:   Wed, 25 Mar 2020 19:43:04 +0100
Message-Id: <20200325184305.1361872-8-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200325184305.1361872-1-hch@lst.de>
References: <20200325184305.1361872-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Separate out the unmount record writing from the rest of the
ticket and log state futzing necessary to make it work. This is
a no-op, just makes the code cleaner and places the unmount record
formatting and writing alongside the commit record formatting and
writing code.

We can also get rid of the ticket flag clearing before the
xlog_write() call because it no longer cares about the state of
XLOG_TIC_INITED.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c | 49 ++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index aca470296fc5..95e1174bf3c5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -795,32 +795,44 @@ xlog_wait_on_iclog(
 }
 
 /*
- * Final log writes as part of unmount.
- *
- * Mark the filesystem clean as unmount happens.  Note that during relocation
- * this routine needs to be executed as part of source-bag while the
- * deallocation must not be done until source-end.
+ * Write out an unmount record using the ticket provided. We have to account for
+ * the data space used in the unmount ticket as this write is not done from a
+ * transaction context that has already done the accounting for us.
  */
-
-/* Actually write the unmount record to disk. */
-static void
-xfs_log_write_unmount_record(
-	struct xfs_mount	*mp)
+static int
+xlog_write_unmount_record(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket,
+	xfs_lsn_t		*lsn,
+	uint			flags)
 {
-	/* the data section must be 32 bit size aligned */
-	struct xfs_unmount_log_format magic = {
+	struct xfs_unmount_log_format ulf = {
 		.magic = XLOG_UNMOUNT_TYPE,
 	};
 	struct xfs_log_iovec reg = {
-		.i_addr = &magic,
-		.i_len = sizeof(magic),
+		.i_addr = &ulf,
+		.i_len = sizeof(ulf),
 		.i_type = XLOG_REG_TYPE_UNMOUNT,
 	};
 	struct xfs_log_vec vec = {
 		.lv_niovecs = 1,
 		.lv_iovecp = &reg,
 	};
-	struct xlog		*log = mp->m_log;
+
+	/* account for space used by record data */
+	ticket->t_curr_res -= sizeof(ulf);
+	return xlog_write(log, &vec, ticket, lsn, NULL, flags, false);
+}
+
+/*
+ * Mark the filesystem clean by writing an unmount record to the head of the
+ * log.
+ */
+static void
+xlog_unmount_write(
+	struct xlog		*log)
+{
+	struct xfs_mount	*mp = log->l_mp;
 	struct xlog_in_core	*iclog;
 	struct xlog_ticket	*tic = NULL;
 	xfs_lsn_t		lsn;
@@ -844,10 +856,7 @@ xfs_log_write_unmount_record(
 		flags &= ~XLOG_UNMOUNT_TRANS;
 	}
 
-	/* remove inited flag, and account for space used */
-	tic->t_flags = 0;
-	tic->t_curr_res -= sizeof(magic);
-	error = xlog_write(log, &vec, tic, &lsn, NULL, flags, false);
+	error = xlog_write_unmount_record(log, tic, &lsn, flags);
 	/*
 	 * At this point, we're umounting anyway, so there's no point in
 	 * transitioning log state to IOERROR. Just continue...
@@ -913,7 +922,7 @@ xfs_log_unmount_write(
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
 	xfs_log_unmount_verify_iclog(log);
-	xfs_log_write_unmount_record(mp);
+	xlog_unmount_write(log);
 }
 
 /*
-- 
2.25.1

