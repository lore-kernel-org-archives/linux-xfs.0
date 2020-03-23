Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B129C4332B
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E7692072D
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:07:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="acEiykL/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgCWNH2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:07:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgCWNH1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 09:07:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=WIzyjVxJdtVvlNChIM4KaeVAJW/PchNrQrRYeQWhBwM=; b=acEiykL/FgrO7RlE6Tyu+OxC3P
        Di9sDMhWwXuW5iCmE5XNIZOu/5q1w2668/yeKSbRYycP83DQ2X6Wg1WIAY7XyJLnhd35iddrVgkQd
        thFrm17flsiSQx+oHPImwDsrDL/gdkX2N6Il0/fqV4kDBabIV3N068bjPklraNCjNyAE3ztsNZjSd
        vqXoyqBzvs8T7Fz/sZ1a14C9Gtqydbc5kMXt1Ts0NjhoFlssqLfD21wluzjHSZozITFh81fuQhsdc
        MokXa3glwS589ObwwPNrN9OVFuGvt5wO4NreLk2dYolKtVnoFTyfJlqZr8K3ES5hSTc3Xq7DBkOT8
        OmG8zF5w==;
Received: from [2001:4bb8:18c:2a9e:999c:283e:b14a:9189] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGMnf-0005jU-C0; Mon, 23 Mar 2020 13:07:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 6/9] xfs: factor out unmount record writing
Date:   Mon, 23 Mar 2020 14:07:03 +0100
Message-Id: <20200323130706.300436-7-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323130706.300436-1-hch@lst.de>
References: <20200323130706.300436-1-hch@lst.de>
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
---
 fs/xfs/xfs_log.c | 59 ++++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e34aaa7d3da3..5a23a84973bb 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -471,6 +471,38 @@ xfs_log_reserve(
  *		marked as with WANT_SYNC.
  */
 
+/*
+ * Write out an unmount record using the ticket provided. We have to account for
+ * the data space used in the unmount ticket as this write is not done from a
+ * transaction context that has already done the accounting for us.
+ */
+static int
+xlog_write_unmount(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket,
+	xfs_lsn_t		*lsn,
+	uint			flags)
+{
+	/* the data section must be 32 bit size aligned */
+	struct xfs_unmount_log_format magic = {
+		.magic = XLOG_UNMOUNT_TYPE,
+	};
+	struct xfs_log_iovec reg = {
+		.i_addr = &magic,
+		.i_len = sizeof(magic),
+		.i_type = XLOG_REG_TYPE_UNMOUNT,
+	};
+	struct xfs_log_vec vec = {
+		.lv_niovecs = 1,
+		.lv_iovecp = &reg,
+	};
+
+	/* account for space used by record data */
+	ticket->t_curr_res -= sizeof(magic);
+
+	return xlog_write(log, &vec, ticket, lsn, NULL, flags);
+}
+
 static bool
 __xlog_state_release_iclog(
 	struct xlog		*log,
@@ -795,31 +827,13 @@ xlog_wait_on_iclog(
 }
 
 /*
- * Final log writes as part of unmount.
- *
- * Mark the filesystem clean as unmount happens.  Note that during relocation
- * this routine needs to be executed as part of source-bag while the
- * deallocation must not be done until source-end.
+ * Mark the filesystem clean by writing an unmount record to the head of the
+ * log.
  */
-
-/* Actually write the unmount record to disk. */
 static void
 xfs_log_write_unmount_record(
 	struct xfs_mount	*mp)
 {
-	/* the data section must be 32 bit size aligned */
-	struct xfs_unmount_log_format magic = {
-		.magic = XLOG_UNMOUNT_TYPE,
-	};
-	struct xfs_log_iovec reg = {
-		.i_addr = &magic,
-		.i_len = sizeof(magic),
-		.i_type = XLOG_REG_TYPE_UNMOUNT,
-	};
-	struct xfs_log_vec vec = {
-		.lv_niovecs = 1,
-		.lv_iovecp = &reg,
-	};
 	struct xlog		*log = mp->m_log;
 	struct xlog_in_core	*iclog;
 	struct xlog_ticket	*tic = NULL;
@@ -844,10 +858,7 @@ xfs_log_write_unmount_record(
 		flags &= ~XLOG_UNMOUNT_TRANS;
 	}
 
-	/* remove inited flag, and account for space used */
-	tic->t_flags = 0;
-	tic->t_curr_res -= sizeof(magic);
-	error = xlog_write(log, &vec, tic, &lsn, NULL, flags);
+	error = xlog_write_unmount(log, tic, &lsn, flags);
 	/*
 	 * At this point, we're umounting anyway, so there's no point in
 	 * transitioning log state to IOERROR. Just continue...
-- 
2.25.1

