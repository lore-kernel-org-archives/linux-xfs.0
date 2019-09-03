Return-Path: <SRS0=8CmW=W6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C86C3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 12:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A466D215EA
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 12:58:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jyujePWH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfICM6s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 08:58:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53442 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728587AbfICM6s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Sep 2019 08:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GhN3+WoxNvQMngqF1ztQTG3k+kEspfiMsAZgttnYtCU=; b=jyujePWHMjtkTx2aHb5Utnb/u
        c20iwgMfJeNNB+vDmnNIapvYhN+1nc78XVx/mi14NmX9GEHXsgyEgWW84VpmYnDAdVhTI1bZpfi3W
        yjAkLyAKlYlpcC+S0QvixZGDogxJMW5OqK2BiHkDjrM9VidJi94bJIzR320UBx0ClwqOkvQ/YLEz+
        BMrbZDb4jy01SguRv/vZF1ndnd4u/lATQAo6Vb2tPlaNfVEGDFzdX1p4yHzi26fKzIDThfqt6bGHP
        gPQZ274EakNTKOb/i+d8KWezjfMNqKBz2WIOGXGJl6WgkjgnxO5WOpYyyTM/Qo30FzhGp2TShbMrC
        lnXxppLNA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i58OV-0002EP-BG; Tue, 03 Sep 2019 12:58:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Murphy Zhou <jencce.kernel@gmail.com>
Subject: [PATCH v3] xfsprogs: provide a few compatibility typedefs
Date:   Tue,  3 Sep 2019 14:58:45 +0200
Message-Id: <20190903125845.3117-1-hch@lst.de>
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
index f2f675df..9c03d6bd 100644
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
+typedef struct xfs_fsop_geom_v1 xfs_fsop_geom_v1_t;
+typedef struct xfs_inogrp xfs_inogrp_t;
+
 #endif	/* __XFS_H__ */
-- 
2.20.1

