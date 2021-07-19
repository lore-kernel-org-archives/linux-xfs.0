Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2461AC07E9B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 10:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07DC6600EF
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 10:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbhGSKQr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 06:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235471AbhGSKQq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jul 2021 06:16:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B783DC061574;
        Mon, 19 Jul 2021 03:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=pIweo/AL/gcZqzgCAsUa+XaqbXIAEc0CYS2F7Cx/rGI=; b=Hb5XWsAj78LHHIVExcj3fZnRTF
        NQ1gOC8MH1JCD9Ss0LMh+4uZdIQ8ia9rsMZ3KEMVbIGAT77ExxaqqkB3Pr9QwDhuzt1fDuvFqj7n0
        8FAjFaKcb+ATiVRv4sHR25hO4FY2VR0CEZ/BipB0gQ6kjHyH2vI2ZXp6KkOEtazLuUDDea4VYgfUU
        vP2XbX8qjWfeu0u7iyDJOpTl2DwGdvqZ0FEzMUvXGmEezpYYJPP4EQw0XH/DueA9BQPLJhD1Mw5Id
        8JtPZTQpuIsF0uqKejrDYrCOR7PNImXdcQwlNvkZKhV91b4xi7tk7nUSDGobFpO/usITnbmryqqcV
        pRpKhlaQ==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5QuO-006lsP-Q0; Mon, 19 Jul 2021 10:54:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, nvdimm@lists.linux.dev,
        cluster-devel@redhat.com
Subject: [PATCH 16/27] iomap: switch iomap_bmap to use iomap_iter
Date:   Mon, 19 Jul 2021 12:35:09 +0200
Message-Id: <20210719103520.495450-17-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719103520.495450-1-hch@lst.de>
References: <20210719103520.495450-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rewrite the ->bmap implementation based on iomap_iter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/fiemap.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
index acad09a8c188df..60daadba16c149 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -92,35 +92,30 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 }
 EXPORT_SYMBOL_GPL(iomap_fiemap);
 
-static loff_t
-iomap_bmap_actor(struct inode *inode, loff_t pos, loff_t length,
-		void *data, struct iomap *iomap, struct iomap *srcmap)
-{
-	sector_t *bno = data, addr;
-
-	if (iomap->type == IOMAP_MAPPED) {
-		addr = (pos - iomap->offset + iomap->addr) >> inode->i_blkbits;
-		*bno = addr;
-	}
-	return 0;
-}
-
 /* legacy ->bmap interface.  0 is the error return (!) */
 sector_t
 iomap_bmap(struct address_space *mapping, sector_t bno,
 		const struct iomap_ops *ops)
 {
-	struct inode *inode = mapping->host;
-	loff_t pos = bno << inode->i_blkbits;
-	unsigned blocksize = i_blocksize(inode);
+	struct iomap_iter iter = {
+		.inode	= mapping->host,
+		.pos	= (loff_t)bno << mapping->host->i_blkbits,
+		.len	= i_blocksize(mapping->host),
+		.flags	= IOMAP_REPORT,
+	};
 	int ret;
 
 	if (filemap_write_and_wait(mapping))
 		return 0;
 
 	bno = 0;
-	ret = iomap_apply(inode, pos, blocksize, 0, ops, &bno,
-			  iomap_bmap_actor);
+	while ((ret = iomap_iter(&iter, ops)) > 0) {
+		if (iter.iomap.type != IOMAP_MAPPED)
+			continue;
+		bno = (iter.pos - iter.iomap.offset + iter.iomap.addr) >>
+				mapping->host->i_blkbits;
+	}
+
 	if (ret)
 		return 0;
 	return bno;
-- 
2.30.2

