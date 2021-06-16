Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85007C48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F43461359
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 16:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhFPQgV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 12:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhFPQfS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 12:35:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CD4C061760
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 09:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=TMBZEHOKd/MSVAMcTKo8Tui3DPavBxLZKDAba96SRvk=; b=RpGqkfQysf02RRE6xd0kfFzMfs
        o/0dYFpvXLrF169fJxzI8l3XNNeLjQELhRW+y2kWrxBJACANoEfXHskCMTah51MLweNYRTI0/wBk7
        jnCsLwA0MmHWZ/FDzDs0yJdtBg7OFYPVg05FENBk2rklL/OnyKZ6+uhZR3Ny6QJ6oHkwinZAMiSYn
        BYCL+KJ+ls4W1TmhPIlUBtRf3N1NvPBoBpVs488D/YX/8jeyMi7c67cLPii5ZIkarQPrVSEwExy79
        lZY4UBO5tzHLdWMS5ex66+fmZQ/7Xw0i8ESKR4tiVbU9HCLRSsycsBZKpTFTqnWgfgkx9fpt9nZgI
        WrYYmQ/A==;
Received: from [2001:4bb8:19b:fdce:84d:447:81f0:ca60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltYTF-008G2E-7T
        for linux-xfs@vger.kernel.org; Wed, 16 Jun 2021 16:32:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfs: list entry elements don't need to be initialized
Date:   Wed, 16 Jun 2021 18:32:06 +0200
Message-Id: <20210616163212.1480297-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210616163212.1480297-1-hch@lst.de>
References: <20210616163212.1480297-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

list_add does not require the added element to be initialized.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8999c78f3ac6d9..32cb0fc459a364 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -851,7 +851,7 @@ xlog_write_unmount_record(
 		.lv_iovecp = &reg,
 	};
 	LIST_HEAD(lv_chain);
-	INIT_LIST_HEAD(&vec.lv_list);
+
 	list_add(&vec.lv_list, &lv_chain);
 
 	BUILD_BUG_ON((sizeof(struct xlog_op_header) +
@@ -1587,7 +1587,7 @@ xlog_commit_record(
 	};
 	int	error;
 	LIST_HEAD(lv_chain);
-	INIT_LIST_HEAD(&vec.lv_list);
+
 	list_add(&vec.lv_list, &lv_chain);
 
 	if (XLOG_FORCED_SHUTDOWN(log))
-- 
2.30.2

