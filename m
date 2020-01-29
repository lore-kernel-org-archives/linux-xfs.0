Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1E7C33CB2
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 06:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C6FA20708
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 06:49:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hKjRCOkA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgA2Gtg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 01:49:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43080 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgA2Gtg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 01:49:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gBZB3KppZ4QBoVpHGIOFPKet9GTGXtzkxdWnhAT7HVE=; b=hKjRCOkAKiuLO7h7lioRrm6dR
        uON79ny4jTAcmsaKMqMyxyCxCkvyfZ1vpS3XTx8MG3amRhyKYfChiXMT2rwxqrWbLlTBJo/lkK0e0
        8c1tA09gDtjzZ/QzD061TwAc9kciogPd3Vvm04E6xe+nSu21nhN5cjEFRO9aZqA7f0wp1IaEuYBdI
        jB9V9NeYu+AadfoYzTdY3g3MCghL5qHJIytT9IOST7iWodCtlvfsAWX+ipcegqJ1Mdq6Ag72qAasq
        KejjZyc08fnVEL3w3UpIjxN6tzUaIkpmALgMO/w4z83iWJSL2HTTflZL4Os7/N/BQfhpbu9DrtZkB
        EHs2bfB0g==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwhAN-0001Ta-TZ
        for linux-xfs@vger.kernel.org; Wed, 29 Jan 2020 06:49:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfsprogs: remove the SIZEOF_LONG substitution in platform_defs.h.in
Date:   Wed, 29 Jan 2020 07:49:22 +0100
Message-Id: <20200129064923.43088-5-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129064923.43088-1-hch@lst.de>
References: <20200129064923.43088-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

BITS_PER_LONG is now only checked in C expressions, so we can simply
define it based on sizeof(long).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h.in | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index ff0a6a4e..36006cbf 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -26,9 +26,7 @@
 
 typedef struct filldir		filldir_t;
 
-/* long and pointer must be either 32 bit or 64 bit */
-#undef SIZEOF_LONG
-#define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
+#define BITS_PER_LONG (sizeof(long) * CHAR_BIT)
 
 /* Check whether to define umode_t ourselves. */
 #ifndef HAVE_UMODE_T
-- 
2.24.1

