Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322DCC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 09:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA8E92388E
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 09:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbhAUJLt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 04:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbhAUJLY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 04:11:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55722C061793;
        Thu, 21 Jan 2021 01:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=i6Dde36ggmoorkkDA8BX+rEq6/brHc3OpzN1LILZN5k=; b=JKIL0Z5NZve0hPKuRlGDntJk75
        +cYDthyvh3XVQ/JMF4HpGw891LUyPPodc+1qpujwjLl/8+e0FrLFyKcxi5nSIsBYroE08OX8GbZ5f
        L3AfD/Fm0rv0T4NJ4RiqIXstnKIzUnJzr6heqSxw1WWGB3N5XEHgDBp//47XaL22z/EeNIukOTSEv
        DiMqPPEvdDEeG9dM41EkjJlAuCsKWP+m0UmMk1UUmz1oqwppGtXYZvUYc2PwceOIxg8vchzmHUmtQ
        5uuwfn377J5acAhu/iY9cr2zhlR9z2UqFhLdhRVh4y4iOvYaO8tF5/wmu7GbjrKteOVPyjM1tU6a/
        1y1Lun+A==;
Received: from [2001:4bb8:188:1954:d5b3:2657:287:e45f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2VyV-00GqZr-4U; Thu, 21 Jan 2021 09:10:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, avi@scylladb.com,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 08/11] iomap: rename the flags variable in __iomap_dio_rw
Date:   Thu, 21 Jan 2021 09:59:03 +0100
Message-Id: <20210121085906.322712-9-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121085906.322712-1-hch@lst.de>
References: <20210121085906.322712-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rename flags to iomap_flags to make the usage a little more clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/direct-io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 933f234d5becd0..604103ab76f9c5 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -427,7 +427,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	size_t count = iov_iter_count(iter);
 	loff_t pos = iocb->ki_pos;
 	loff_t end = iocb->ki_pos + count - 1, ret = 0;
-	unsigned int flags = IOMAP_DIRECT;
+	unsigned int iomap_flags = IOMAP_DIRECT;
 	struct blk_plug plug;
 	struct iomap_dio *dio;
 
@@ -461,7 +461,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		if (iter_is_iovec(iter))
 			dio->flags |= IOMAP_DIO_DIRTY;
 	} else {
-		flags |= IOMAP_WRITE;
+		iomap_flags |= IOMAP_WRITE;
 		dio->flags |= IOMAP_DIO_WRITE;
 
 		/* for data sync or sync, we need sync completion processing */
@@ -483,7 +483,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 			ret = -EAGAIN;
 			goto out_free_dio;
 		}
-		flags |= IOMAP_NOWAIT;
+		iomap_flags |= IOMAP_NOWAIT;
 	}
 
 	ret = filemap_write_and_wait_range(mapping, pos, end);
@@ -514,7 +514,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 
 	blk_start_plug(&plug);
 	do {
-		ret = iomap_apply(inode, pos, count, flags, ops, dio,
+		ret = iomap_apply(inode, pos, count, iomap_flags, ops, dio,
 				iomap_dio_actor);
 		if (ret <= 0) {
 			/* magic error code to fall back to buffered I/O */
-- 
2.29.2

