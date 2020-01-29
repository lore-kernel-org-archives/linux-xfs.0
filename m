Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B36EC33CB2
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 06:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBF1B20708
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 06:49:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y+Ek/TK7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgA2Gtb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 01:49:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43066 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgA2Gtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 01:49:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Jwcm3EybhJoixusZ+7B7Ht2NyrKET5NCZJKhVTHy2yE=; b=Y+Ek/TK7V0P/5vlrQAjFGF7Do
        CFiN0ugG/ckx0shvarUNIulqG02bLcpHHxPYEYQhAQe0fL1XXY4Wuky24klQoR1dU6NtqIEi6ya7G
        lpYbEuMabHwVimoBu96JyvA+Ds3/XCw7kEqEmhETdO2ZJQS0gEqzpPP4Rr1hjlElkY1lhXidj1zQ3
        u+gkDdKYzLPFFbLbJ3debl5aW8DiOwklffFuqcBtw2wsYcY4XINl8BCZASFv1ZNXQBWek+mVo1kan
        JoamKED0h8qWZQECyEhm046OnracdW36HB7WHiF2L1T+MI/g2pFVWzwoTen6VdXu2tByAPnoEEtok
        WfAT/pDOA==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwhAI-0001T2-QL
        for linux-xfs@vger.kernel.org; Wed, 29 Jan 2020 06:49:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfsprogs: remove the SIZEOF_CHAR_P substitution in platform_defs.h.in
Date:   Wed, 29 Jan 2020 07:49:20 +0100
Message-Id: <20200129064923.43088-3-hch@lst.de>
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

SIZEOF_CHAR_P is not used anywhere in the code, so remove the reference
to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h.in | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 6cc56e31..ff0a6a4e 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -28,7 +28,6 @@ typedef struct filldir		filldir_t;
 
 /* long and pointer must be either 32 bit or 64 bit */
 #undef SIZEOF_LONG
-#undef SIZEOF_CHAR_P
 #define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
 
 /* Check whether to define umode_t ourselves. */
-- 
2.24.1

