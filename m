Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDC5C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1BCE61355
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 19:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhESTKm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 15:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhESTKm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 15:10:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCEBC06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 12:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=A6dlVzYJIeYGYyCnq1KE9flTvZ5HhXDH6pfk/XKu0BQ=; b=kZ4nLRrCKeE8qDx/4W7Y4nf7Bn
        BsUVAVHXL/NEL9EIBq0cZbQNqBaeHw2c/80sgo1Heunjr+75F4BlgQwBJbSOn9TYCWtDn/rh3cKqI
        8UtqqiW2PQIYirprboR1gJvXkv0Qnv62ZjSgs8Pvv1UeRkLSpqp2Rt0QWqKZfFt3h9Jnei6FHpu4V
        BcQL6jUYqgyr8Lq2/+g0A/AI+iV6b48OsxY7SRUBWOyjO7CmU/fSPTXm4opWlR3AnIJI6tiIpwQF2
        Uf1Zo6ni3MJjVFEGRuZTg1KssoqCqhviAmXocwWJHKOmXiPeKc9Nxz5UuNb9/zXNwTDKUbInDPEc3
        xXFQwM2A==;
Received: from [2001:4bb8:180:5add:9e44:3522:a0e8:f6e] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRZJ-00Fisb-Rn; Wed, 19 May 2021 19:09:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/11] xfs: remove the xb_page_found stat counter in xfs_buf_alloc_pages
Date:   Wed, 19 May 2021 21:08:54 +0200
Message-Id: <20210519190900.320044-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519190900.320044-1-hch@lst.de>
References: <20210519190900.320044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We did not find any page, we're allocating them all from the page
allocator.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9c64c374411081..76240d84d58b61 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -436,8 +436,6 @@ xfs_buf_alloc_pages(
 			goto retry;
 		}
 
-		XFS_STATS_INC(bp->b_mount, xb_page_found);
-
 		nbytes = min_t(size_t, size, PAGE_SIZE);
 		size -= nbytes;
 		bp->b_pages[i] = page;
-- 
2.30.2

