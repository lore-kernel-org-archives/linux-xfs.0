Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69161C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B7622184D
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jh/MhfBd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgEIRBa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgEIRBa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:01:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949D6C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=9E3VqAGTF09M6irbDOY3RL7A9Gjw3bQrCc3PjWL7ODE=; b=jh/MhfBdZ7Hi0YpkP1eRPtEkRN
        wGCxvEko7N9nEIQqo99GzpFXPxGwNfv4wXA8axUcLvRxrwhtW0FTxUzf6VMlUfMRLABfuKrO3ZuNV
        CDAolQQluDDT0Jr6X4gIl4cnkl6lWTGXeB4sQIwf6UZP2mKd0SxLJTddzxDC1sn65yce31xWrdE67
        hveHUZMipLPkSpO+G8kqL7GkXus6/e2Ljh9TVu2cJy/TxD3mUc9rbRG9QR5dfiLVvi/WRBJkwoBTF
        3l4esKbeQh9tBvXWPYDFyVk9RWY4siZTD2s+hMiH/nRKgm1KLwzIDeuIOOPpfli9+NiwoNnHsZ/wd
        n8W+iKsg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSqv-00063C-W8; Sat, 09 May 2020 17:01:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/8] libxfs: use tabs instead of spaces in div_u64
Date:   Sat,  9 May 2020 19:01:18 +0200
Message-Id: <20200509170125.952508-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509170125.952508-1-hch@lst.de>
References: <20200509170125.952508-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 8d717d91..5688284d 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -263,8 +263,8 @@ div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
  */
 static inline uint64_t div_u64(uint64_t dividend, uint32_t divisor)
 {
-        uint32_t remainder;
-        return div_u64_rem(dividend, divisor, &remainder);
+	uint32_t remainder;
+	return div_u64_rem(dividend, divisor, &remainder);
 }
 
 /**
-- 
2.26.2

