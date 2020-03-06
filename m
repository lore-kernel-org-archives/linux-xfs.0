Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B19EC10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C960C20717
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:31:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q9Ldg5P2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCFObi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 09:31:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39410 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgCFObi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:31:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ARbSQ59WsV2gqhk23CbSj4t5Gc5h+SfHwDpVXULTHqw=; b=Q9Ldg5P21Q+vkEyKeA6zZsa8Km
        0kRbCZEtoDd93bjleBAdsAPGVIT6Doh4pAz16kwpvoKrgNcMcnoMnBrAuoS9eVEO0TMDyYr8IkaMX
        FnWXqLiRQiltSJEoFlqmBn0av4QfSotEothbU5/ZKjnlDIuwhCkuAUFeeXgo50nQ4moq3F2mziEQe
        8z5IAJRAYu/M3Yps7VJcOhEUKGaTA5KEVpQ6oZgPjwOX6edEcnaHj/G2pqHza55f6dNrtsU+8qTF6
        9Lijm08rvTE7kFK//4odmRYgQYaTtMk6+JDXPWpP6wGiZnRf7NoD9U4KHIgndshU85JldXs/Bx7J7
        MNwuTs+g==;
Received: from [162.248.129.185] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAE0n-0008H7-TC; Fri, 06 Mar 2020 14:31:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/7] xfs: remove dead code from xfs_log_unmount_write
Date:   Fri,  6 Mar 2020 07:31:32 -0700
Message-Id: <20200306143137.236478-3-hch@lst.de>
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

When the log is shut down all iclogs are in the XLOG_STATE_IOERROR state,
which means that xlog_state_want_sync and xlog_state_release_iclog are
no-ops.  Remove the whole section of code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 35 +++--------------------------------
 1 file changed, 3 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fa499ddedb94..b56432d4a9b8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -984,38 +984,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		iclog = iclog->ic_next;
 	} while (iclog != first_iclog);
 #endif
-	if (! (XLOG_FORCED_SHUTDOWN(log))) {
-		xfs_log_write_unmount_record(mp);
-	} else {
-		/*
-		 * We're already in forced_shutdown mode, couldn't
-		 * even attempt to write out the unmount transaction.
-		 *
-		 * Go through the motions of sync'ing and releasing
-		 * the iclog, even though no I/O will actually happen,
-		 * we need to wait for other log I/Os that may already
-		 * be in progress.  Do this as a separate section of
-		 * code so we'll know if we ever get stuck here that
-		 * we're in this odd situation of trying to unmount
-		 * a file system that went into forced_shutdown as
-		 * the result of an unmount..
-		 */
-		spin_lock(&log->l_icloglock);
-		iclog = log->l_iclog;
-		atomic_inc(&iclog->ic_refcnt);
-		xlog_state_want_sync(log, iclog);
-		xlog_state_release_iclog(log, iclog);
-		switch (iclog->ic_state) {
-		case XLOG_STATE_ACTIVE:
-		case XLOG_STATE_DIRTY:
-		case XLOG_STATE_IOERROR:
-			spin_unlock(&log->l_icloglock);
-			break;
-		default:
-			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
-			break;
-		}
-	}
+	if (XLOG_FORCED_SHUTDOWN(log))
+		return;
+	xfs_log_write_unmount_record(mp);
 }
 
 /*
-- 
2.24.1

