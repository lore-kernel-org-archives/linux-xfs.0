Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF70C4332B
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 06:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBC6020781
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 06:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LXqMxpZC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgCTGxZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 02:53:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42064 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgCTGxZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 02:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4IzcXT2wkNgF0gbbF9riXXoqDK2bYoU2E+N9+j8nOFg=; b=LXqMxpZCHSsA3G4PBZ67UmNvqp
        r+LJMGEenlTEkUbvLW6PYxuszLMJGAsUV35EUeYlJxDYCLcrrkErF+zN/1iaOmiVo7uOkImGXmv7I
        H0xt2wYF4LAGWOxVFjsbJozcYRX29zUmTvhn/AMN79E34SswTG2QkWHq/KlZPAgtUQG4bZzEHOBiG
        dAqyRXZb8SvllXKz5L7hyRL3C7FZgxS667XGYr7it3t+QuGu/W/y3QuMAZJikMrt4glqZPV7iCoZD
        fXJhTnyzguNUTiIzCYwm4Iz5UoyWRthcwfT2Gv9dxoTNYjX0tsjZ4wGZcsaq3HblcUZDidWj6pDeC
        8bzS+x+Q==;
Received: from [2001:4bb8:188:30cd:a410:8a7:7f20:5c9c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jFBX2-0006Fd-OD; Fri, 20 Mar 2020 06:53:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/8] xfs: simplify log shutdown checking in xfs_log_release_iclog
Date:   Fri, 20 Mar 2020 07:53:07 +0100
Message-Id: <20200320065311.28134-5-hch@lst.de>
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

There is no need to check for the ioerror state before the lock, as
the shutdown case is not a fast path.  Also remove the call to force
shutdown the file system, as it must have been shut down already
for an iclog to be in the ioerror state.  Also clean up the flow of
the function a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 17ba92b115ea..7af9c292540b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -602,24 +602,16 @@ xfs_log_release_iclog(
 	struct xlog_in_core	*iclog)
 {
 	struct xlog		*log = iclog->ic_log;
-	bool			sync;
-
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
-		goto error;
+	bool			sync = false;
 
 	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
-		if (iclog->ic_state == XLOG_STATE_IOERROR) {
-			spin_unlock(&log->l_icloglock);
-			goto error;
-		}
-		sync = __xlog_state_release_iclog(log, iclog);
+		if (iclog->ic_state != XLOG_STATE_IOERROR)
+			sync = __xlog_state_release_iclog(log, iclog);
 		spin_unlock(&log->l_icloglock);
-		if (sync)
-			xlog_sync(log, iclog);
 	}
-	return;
-error:
-	xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+
+	if (sync)
+		xlog_sync(log, iclog);
 }
 
 /*
-- 
2.25.1

