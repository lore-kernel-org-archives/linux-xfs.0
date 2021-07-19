Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87660C07E9B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 10:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7175B60FED
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 10:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbhGSJ7L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 05:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbhGSJ7L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jul 2021 05:59:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2627AC061574;
        Mon, 19 Jul 2021 02:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=3v1eAlXcJTzkiBY7xr6VnHSJGGh1jdArlOsDvTzzCcA=; b=ehISl62Ccvj3pUinsa2VLti8BZ
        HOIbC5bpn+Clu15Tql0whSnHUcr1i7YCsf6il7NCvWpTDyYcyzq96TNlTgz5/vuL/lPHStN67wzbp
        7Tbq4JDqtLh/ukeuElfUbssvdPQm6LUxnnbsRnznFN3O4n6qkslI4Vvtua6xhnXWYmJW4FCW6evBP
        j42vqU4ndgpaGW2dxC+ZrVMporAHbQHGq++jkSvUMtiT9qXwVI3zsIDIBAqzha/SDT+ZOS3NCwbO9
        icqyeCBXIOcPt4hFLZVJ+SifU4LPjhoo+lFHFlDFZ6+sr4HGZLA9Yr8F6b/0PUxOaCFYmMYoJhTb+
        oyy9to0Q==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5Qee-006kbA-Ic; Mon, 19 Jul 2021 10:37:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, nvdimm@lists.linux.dev,
        cluster-devel@redhat.com
Subject: [PATCH 03/27] iomap: mark the iomap argument to iomap_sector const
Date:   Mon, 19 Jul 2021 12:34:56 +0200
Message-Id: <20210719103520.495450-4-hch@lst.de>
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
 include/linux/iomap.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 093519d91cc9cc..f9c36df6a3061b 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -91,8 +91,7 @@ struct iomap {
 	const struct iomap_page_ops *page_ops;
 };
 
-static inline sector_t
-iomap_sector(struct iomap *iomap, loff_t pos)
+static inline sector_t iomap_sector(const struct iomap *iomap, loff_t pos)
 {
 	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
 }
-- 
2.30.2

