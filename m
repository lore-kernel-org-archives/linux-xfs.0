Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F5AC11D0C
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C039724670
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:39:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cq2RcJd2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgBTPjY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 10:39:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53872 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbgBTPjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 10:39:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=OvI+c+gdio9w2mZ9MT9r14k/giJcL/H/mFdmPPx5LKU=; b=Cq2RcJd2pMFuwgF7MYCs/PJ9kI
        um0gbJEb62Ps3NQLGHvDjlVFKC/7XSjUG5I4DbfHyA4gYU7baTdRZVnwsZcXvaAtpv6Y6OxnfZuA6
        HNBPOUGWdjWvZcY+A2QShK3FnwtAEU33vJqKcXcoSwu1w8ZBvc6JZQz+An3ai+/C70J7n0TwqY+IE
        WEEo2YJyx2EybXLOtd0nSUHkR3WJTCgZXpGMDDxgYUrq6mVB1UkyqOx0aLf7qGJh5Tyhu06iYJoQ8
        5AvPuzk9IvExvATD/t56spVIH3GYJsTdkiVn5ZgMA1JTCBQs4oSTT1i9y1DPblj4jftW74Q80Vuuk
        kqX6rGlw==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4nv9-0001mt-Rb
        for linux-xfs@vger.kernel.org; Thu, 20 Feb 2020 15:39:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: ratelimit xfs_buf_ioerror_alert messages
Date:   Thu, 20 Feb 2020 07:39:20 -0800
Message-Id: <20200220153921.383899-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220153921.383899-1-hch@lst.de>
References: <20200220153921.383899-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use printk_ratelimit() to limit the amount of messages printed from
xfs_buf_ioerror_alert.  Without that a failing device causes a large
number of errors that doesn't really help debugging the underling
issue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 217e4f82a44a..0ceaa172545b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1238,7 +1238,7 @@ xfs_buf_ioerror_alert(
 	struct xfs_buf		*bp,
 	xfs_failaddr_t		func)
 {
-	xfs_alert(bp->b_mount,
+	xfs_alert_ratelimited(bp->b_mount,
 "metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
 			func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
 			-bp->b_error);
-- 
2.24.1

