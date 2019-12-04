Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8244CC43603
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55638207DD
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 17:30:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p0ywopLY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfLDRaU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:30:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44082 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDRaU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Dec 2019 12:30:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=o2u6ahUKk5YnlzAhhnIv03zPWih6TebFsPhg9/xixUE=; b=p0ywopLYTwPh2jnd/OYHrqJ7m
        p7MAS+aczijoQ9LibMzIAj+NVtoy0LidtJEZ2SWz+7F1ELWIIZCMEuRoP3YuMbLbFflOsm4f3I3oS
        Fov+KxPNIF9gRosWa/gel0MTc8EIqR+TA3/IKhQ2fD+sAZQzinWu71ZwQ6ZXiIwcfk0024wFgdK2A
        H8QqDx0Dxf6SYBV+WLnv2iTd2sQZD4tyjRsRGRENZ0s/jgbg87QhQfv55dmDtcy/3NKYSeEwDPiEg
        s0pb6iYVumUOwC9lyj/iOOEHNlTV9Zn+r/+2Xm8qfES3wrWx6u6zcSWEfcif0F9QXZoXPh+CPVejZ
        Zaa+wrybg==;
Received: from 213-225-4-219.nat.highway.a1.net ([213.225.4.219] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1icYTj-0000FP-W5; Wed, 04 Dec 2019 17:30:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     jstancek@redhat.com
Subject: [PATCH] xfs: fix sub-page uptodate handling
Date:   Wed,  4 Dec 2019 18:28:04 +0100
Message-Id: <20191204172804.6589-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

bio complentions can race when a page spans more than one file system
block.  Add a spinlock to synchronize marking the page uptodate.

Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 512856a88106..340c15400423 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -28,6 +28,7 @@
 struct iomap_page {
 	atomic_t		read_count;
 	atomic_t		write_count;
+	spinlock_t		uptodate_lock;
 	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
 };
 
@@ -51,6 +52,7 @@ iomap_page_create(struct inode *inode, struct page *page)
 	iop = kmalloc(sizeof(*iop), GFP_NOFS | __GFP_NOFAIL);
 	atomic_set(&iop->read_count, 0);
 	atomic_set(&iop->write_count, 0);
+	spin_lock_init(&iop->uptodate_lock);
 	bitmap_zero(iop->uptodate, PAGE_SIZE / SECTOR_SIZE);
 
 	/*
@@ -139,25 +141,38 @@ iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
 }
 
 static void
-iomap_set_range_uptodate(struct page *page, unsigned off, unsigned len)
+iomap_iop_set_range_uptodate(struct page *page, unsigned off, unsigned len)
 {
 	struct iomap_page *iop = to_iomap_page(page);
 	struct inode *inode = page->mapping->host;
 	unsigned first = off >> inode->i_blkbits;
 	unsigned last = (off + len - 1) >> inode->i_blkbits;
-	unsigned int i;
 	bool uptodate = true;
+	unsigned long flags;
+	unsigned int i;
 
-	if (iop) {
-		for (i = 0; i < PAGE_SIZE / i_blocksize(inode); i++) {
-			if (i >= first && i <= last)
-				set_bit(i, iop->uptodate);
-			else if (!test_bit(i, iop->uptodate))
-				uptodate = false;
-		}
+	spin_lock_irqsave(&iop->uptodate_lock, flags);
+	for (i = 0; i < PAGE_SIZE / i_blocksize(inode); i++) {
+		if (i >= first && i <= last)
+			set_bit(i, iop->uptodate);
+		else if (!test_bit(i, iop->uptodate))
+			uptodate = false;
 	}
 
-	if (uptodate && !PageError(page))
+	if (uptodate)
+		SetPageUptodate(page);
+	spin_unlock_irqrestore(&iop->uptodate_lock, flags);
+}
+
+static void
+iomap_set_range_uptodate(struct page *page, unsigned off, unsigned len)
+{
+	if (PageError(page))
+		return;
+
+	if (page_has_private(page))
+		iomap_iop_set_range_uptodate(page, off, len);
+	else
 		SetPageUptodate(page);
 }
 
-- 
2.20.1

