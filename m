Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325ADC3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07C0121670
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PZenZRzA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfH3PDb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 11:03:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44328 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbfH3PDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 11:03:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+u7q9SAdE+sULaMVsu/w2nPWeQ/Xu7Zw4HzIXUzGRTE=; b=PZenZRzADV3WE3b1cs5CTKfrq
        +Z/vhKjiStDqwueWBbBO2eK7dR3IVve47CFRGBwKq/DfpB6Yp6X3/TnaTzFWAv72nHX+Wu2Wv3fsD
        nlszvDLtVNaoNXXtpjiNA8XFtZ0VKrqDrTgcaYBD388oBMwCBwBoUCCyGnnuckSduYQXE8rMSwjTD
        t/5YOt4wwZEKP6LHhGbgaUDaJQzeL9syzcthQgs3BuIVQXxSKqoyUnJrCUo6A0t9mTdzHDHt7b12i
        9qkhRAghff9KwziXBNcdok/K7kFTSRrMl6g8yxXcM+AMjEXMLkPe6pYtQU5x1MRu2z+AzdTF/gDLa
        ro1xht78g==;
Received: from [2001:4bb8:180:3f4c:863:2ead:e9d4:da9f] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i3iQz-0004kt-Pt; Fri, 30 Aug 2019 15:03:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Murphy Zhou <jencce.kernel@gmail.com>
Subject: [PATCH v2] xfsprogs: provide a few compatibility typedefs
Date:   Fri, 30 Aug 2019 17:03:27 +0200
Message-Id: <20190830150327.20874-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add back four typedefs that allow xfsdump to compile against the
headers from the latests xfsprogs.

Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/xfs.h b/include/xfs.h
index f2f675df..35435b18 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -37,4 +37,13 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
 #include <xfs/xfs_types.h>
 #include <xfs/xfs_fs.h>
 
+/*
+ * Backards compatibility for users of this header, now that the kernel
+ * removed these typedefs from xfs_fs.h.
+ */
+typedef struct xfs_bstat xfs_bstat_t;
+typedef struct xfs_fsop_bulkreq xfs_fsop_bulkreq_t;
+typedef struct xfs_fsop_geom_v1 xfs_fsop;
+typedef struct xfs_inogrp xfs_inogrp_t;
+
 #endif	/* __XFS_H__ */
-- 
2.20.1

