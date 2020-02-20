Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C99C11D0B
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0513B207FD
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:39:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VzsPRNxg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgBTPjY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 10:39:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53884 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbgBTPjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 10:39:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=3twHW/DTVm8fOZNFR/pFtRseMFbKkTs2wYclRJqI/nE=; b=VzsPRNxggYrP9EX6jOUxRu67Dm
        /Aenhkt5DSmdhB0+CuRlbOI1yuuTwpKJNEVeY1ZGC8exgllmq5tqnV0W69NMs4I3Qez6O3euJ3Qga
        y79qD7JbiqCNABwZy6d4iGZnG0Ga4kFfcBL2mavAxP1gqhpEfIy7AMvGpKR20+y7c7nLuhap0beT9
        5XWTnYyKXe9nP6mAq2VwIWo7p20i3KTlTQGDTqHjbu/LiMuzHj7mmFWmTjluMWjBAVIvv0hLqo6m+
        MVnh3LVcXPgA4xv4yPcCGxqxvRSpWnSpOGlRqexvU8EPBe5Ed5CsfS6QHvCXhjegyLzZSfseEUGLT
        upnTFr1w==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4nvA-0001nC-66
        for linux-xfs@vger.kernel.org; Thu, 20 Feb 2020 15:39:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: ratelimit xfs_discard_page messages
Date:   Thu, 20 Feb 2020 07:39:21 -0800
Message-Id: <20200220153921.383899-3-hch@lst.de>
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
xfs_discard_page.  Without that a failing device causes a large
number of errors that doesn't really help debugging the underling
issue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 58e937be24ce..9d9cebf18726 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -539,7 +539,7 @@ xfs_discard_page(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		goto out_invalidate;
 
-	xfs_alert(mp,
+	xfs_alert_ratelimited(mp,
 		"page discard on page "PTR_FMT", inode 0x%llx, offset %llu.",
 			page, ip->i_ino, offset);
 
-- 
2.24.1

