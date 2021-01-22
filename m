Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D06C7C433E9
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 17:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9805223A79
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 17:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbhAVR1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 12:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729501AbhAVQsU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jan 2021 11:48:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D4CC061788
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jan 2021 08:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=Xt/4VePDBBA1eN6G2ZG7tbUsafp1TF2lfBN4a5cT+7Y=; b=UkpriqQ4qmDZ6Hoeg53iOt1Oll
        7Y6H7i+l/eDtio+MzuhiR5JjHobAVk0JLjVgiPele3hvMVkZ4FQQ9Wkb0eTOVHmKV/k2IJH3vqGxa
        4EYrMHpCIx3MBgq6rymC6BCaCBgndFa8rotCOghdJ3atDX1aEIxLPzH63EYVwJzormbTRAFxtnQ/g
        eCnka5y6LIAWHpuyZmhTSZc2S/AFEJQzaU/xL0ddPhaTOpJQbLC6yAJs5O9MfeBOlgku1UaBUOh6e
        vQPmFkxtcdFPj8+OSU5qGhiuDpldVsbI1sf3mkdu2vubilI+y7VS7MouYSBvkQL/nRm8cDJy4nR5B
        ja9EYudg==;
Received: from [2001:4bb8:188:1954:662b:86d3:ab5f:ac21] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2zaH-000yXx-3L
        for linux-xfs@vger.kernel.org; Fri, 22 Jan 2021 16:46:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: reduce ilock acquisitions in xfs_file_fsync
Date:   Fri, 22 Jan 2021 17:46:43 +0100
Message-Id: <20210122164643.620257-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210122164643.620257-1-hch@lst.de>
References: <20210122164643.620257-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the inode is not pinned by the time fsync is called we don't need the
ilock to protect against concurrent clearing of ili_fsync_fields as the
inode won't need a log flush or clearing of these fields.  Not taking
the iolock allows for full concurrency of fsync and thus O_DSYNC
completions with io_uring/aio write submissions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 588232c77f11e0..ffe2d7c37e26cd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -200,7 +200,14 @@ xfs_file_fsync(
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_blkdev_issue_flush(mp->m_ddev_targp);
 
-	error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
+	/*
+	 * Any inode that has dirty modifications in the log is pinned.  The
+	 * racy check here for a pinned inode while not catch modifications
+	 * that happen concurrently to the fsync call, but fsync semantics
+	 * only require to sync previously completed I/O.
+	 */
+	if (xfs_ipincount(ip))
+		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
 
 	/*
 	 * If we only have a single device, and the log force about was
-- 
2.29.2

