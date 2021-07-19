Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15ACC12002
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 10:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA63F60FF4
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 10:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236349AbhGSKBT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 06:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbhGSKBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jul 2021 06:01:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A03AC061574;
        Mon, 19 Jul 2021 02:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=IVnh1SP/p9y49gxhVcv0uKCVfDciQP/EepWPo92LCdI=; b=VM29E3hQaGpu3mIuKVBOb81ilP
        4UUlPyD6Q84veOsS9zf2c2xj3W+nGb4Adc44mQnMk5lPRla9xyd5OCpl6z0Y6Wo1QdH9BIIUX6gm+
        dOpmY5lcWJSKPYHgcRy0sra64cxkxVSKv/Tm2bCTVhKYcYtW5dOodOKHjBM45JtGGLdobUtX4W+wu
        E4+cwmAVxfv/AlReoqiPBsUuZZIOofYImNT/SQ8ZVbzUoL1POC5YWHvGtJA2p6XUoEPh894yET49Y
        SOCWjy7CxED+xUJdVjtUwMlrpvEGmNKIwRUxCyhDRHbFr6ohF6Rbp0IrShxo3tIza/zQVTQ7XlH1T
        KqYpE3Iw==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5Qg5-006kgh-NS; Mon, 19 Jul 2021 10:39:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, nvdimm@lists.linux.dev,
        cluster-devel@redhat.com
Subject: [PATCH 05/27] fsdax: mark the iomap argument to dax_iomap_sector as const
Date:   Mon, 19 Jul 2021 12:34:58 +0200
Message-Id: <20210719103520.495450-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719103520.495450-1-hch@lst.de>
References: <20210719103520.495450-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index da41f9363568e0..4d63040fd71f56 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1005,7 +1005,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
-static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
+static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
 {
 	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
 }
-- 
2.30.2

