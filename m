Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4D2C4332D
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 06:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 376D720782
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 06:53:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s0HMy7uv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgCTGxc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 02:53:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42110 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgCTGxc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 02:53:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VFAa4lvgK6lS6cQcibZxTVGiFYXunj3K5/CPwIIwgsA=; b=s0HMy7uvNDYuwsg6XX/kyMFGZw
        OMgOuxZJb7xncsLbq1zu5sxdRQgj2kevkYVlor+IJ5ezaOjsvOOgXctKQt3gmIGf5Wlh5+mI9a7iP
        3C7IWkNkNQxrrDQ+BhKHBH1e3RAEFn2Q/stQOijSP8dU+k6cJSVsFH2uBqoWC8yX/668589CSNEwb
        zvYUWZHjcVjHbCutpI81wudFYG/a/wdvvMA4bTt9iV59q9cjQOrQsFqbjvWse962W3gXcpyLiOQko
        FrO1dmMk8UVkCAFaPQHNKslgL2/LyEZ2fhdQ+1SrLRRpYPIjALUrPb390Z5J4x8RBP/i3UjkTxaGf
        wpzrhU3Q==;
Received: from [2001:4bb8:188:30cd:a410:8a7:7f20:5c9c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jFBX9-0006Gn-Tm; Fri, 20 Mar 2020 06:53:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 7/8] xfs: move the ioerror check out of xlog_state_clean_iclog
Date:   Fri, 20 Mar 2020 07:53:10 +0100
Message-Id: <20200320065311.28134-8-hch@lst.de>
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

Use the shutdown flag in the log to bypass xlog_state_clean_iclog
entirely in case of a shut down log.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6facbb91b8a8..7e39835d9852 100644
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
@@ -2838,8 +2837,10 @@ xlog_state_do_callback(
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
2.25.1

