Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22BFC07E9D
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 10:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9677860200
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 10:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbhGSKDt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 06:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236416AbhGSKDs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jul 2021 06:03:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB95C061574;
        Mon, 19 Jul 2021 02:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=4xDAFG58FBQ6OYFgDPj9OQJz0LEGp6VMc+9ZWmE7SNY=; b=GYC171KoAwX2LD6CcnHWvMY1bO
        HzRaW1BtQkY7c9AVBsdY86AKvkKqiQXfrp+DBRzGZHm0Lg7x9DbTXHM6DkmyCSAHDN8YIDH2b6wYf
        cp59gb3cYVuDD2tH2bB8d5Ervx+L2uFK5vpzVI7duQAbsYojgbajpp7QPmis0ulSgXaISfaqlLsNq
        iru6gpAOGTBntUhboz3VbCXEGYRJ7+x2HCakhCUnsEiet6meL2vS/y/hUBMfd0yLrREfd7ZM4zYdv
        6kYyDbmLGQISsvD6OmG9yoJ9MFQq2lR2ynCujJBR60KaTq9LPX6PzKrcjeB7K+5h32Lm3NZ4+cR9E
        w65R7k9A==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5QiZ-006kqc-Us; Mon, 19 Jul 2021 10:41:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, nvdimm@lists.linux.dev,
        cluster-devel@redhat.com
Subject: [PATCH 07/27] iomap: mark the iomap argument to iomap_read_page_sync const
Date:   Mon, 19 Jul 2021 12:35:00 +0200
Message-Id: <20210719103520.495450-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719103520.495450-1-hch@lst.de>
References: <20210719103520.495450-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

iomap_read_page_sync never modifies the passed in iomap, so mark
it const.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index e47380259cf7e1..8c26cf7cbd72b0 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -535,7 +535,7 @@ iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 
 static int
 iomap_read_page_sync(loff_t block_start, struct page *page, unsigned poff,
-		unsigned plen, struct iomap *iomap)
+		unsigned plen, const struct iomap *iomap)
 {
 	struct bio_vec bvec;
 	struct bio bio;
-- 
2.30.2

