Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 569A5C4332B
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FBC620735
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:07:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m/Pd4xev"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgCWNHa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:07:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33922 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728252AbgCWNHa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 09:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/wsHST6E0Sv3JTqHjQT4jk0yO4byaODbmb9rwJK4mHc=; b=m/Pd4xev304VPYbPIDUWUO6pAM
        lyoHoVgcIR17r9KpbXb4boWU0z0MY5SFMQMV/ejMhpz8hMrMDQ/cXYVPuYysYgzpBxbahudcGPyLS
        5rUqlpkhydvc5wiVdhPBzkYgwSo8qzwRmChIxs7r7RcUicOk1WoV3cPdPUohHA3qYArhvt09fJqoV
        /TrxLSxJee0ppPim1NOLhbUxUqsXXMgkHjTz6hgWKyeUaxgtGz3OlvIc/A/RToYW7pVcIokDTBRX5
        6Ye+JtFC4NpHe7k6n5oGR5LyJI789+A7zVeKYyFviFf/uv/EGy2jCQHmtTAL6FcWtpNf6GU02LrVV
        jJLaMV2A==;
Received: from [2001:4bb8:18c:2a9e:999c:283e:b14a:9189] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGMni-0005jp-15; Mon, 23 Mar 2020 13:07:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 7/9] xfs: rename the log unmount writing functions.
Date:   Mon, 23 Mar 2020 14:07:04 +0100
Message-Id: <20200323130706.300436-8-hch@lst.de>
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

The naming and calling conventions are a bit of a mess. Clean it up
so the call chain looks like:

	xfs_log_unmount_write(mp)
	  xlog_unmount_write(log)
	    xlog_write_unmount_record(log, ticket)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5a23a84973bb..d0d9f27ef90c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -477,7 +477,7 @@ xfs_log_reserve(
  * transaction context that has already done the accounting for us.
  */
 static int
-xlog_write_unmount(
+xlog_write_unmount_record(
 	struct xlog		*log,
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*lsn,
@@ -831,10 +831,10 @@ xlog_wait_on_iclog(
  * log.
  */
 static void
-xfs_log_write_unmount_record(
-	struct xfs_mount	*mp)
+xlog_unmount_write(
+	struct xlog		*log)
 {
-	struct xlog		*log = mp->m_log;
+	struct xfs_mount	*mp = log->l_mp;
 	struct xlog_in_core	*iclog;
 	struct xlog_ticket	*tic = NULL;
 	xfs_lsn_t		lsn;
@@ -858,7 +858,7 @@ xfs_log_write_unmount_record(
 		flags &= ~XLOG_UNMOUNT_TRANS;
 	}
 
-	error = xlog_write_unmount(log, tic, &lsn, flags);
+	error = xlog_write_unmount_record(log, tic, &lsn, flags);
 	/*
 	 * At this point, we're umounting anyway, so there's no point in
 	 * transitioning log state to IOERROR. Just continue...
@@ -924,7 +924,7 @@ xfs_log_unmount_write(
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
 	xfs_log_unmount_verify_iclog(log);
-	xfs_log_write_unmount_record(mp);
+	xlog_unmount_write(log);
 }
 
 /*
-- 
2.25.1

