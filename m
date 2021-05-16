Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 341E4C43460
	for <linux-xfs@archiver.kernel.org>; Sun, 16 May 2021 15:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A3061182
	for <linux-xfs@archiver.kernel.org>; Sun, 16 May 2021 15:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbhEPPGJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 May 2021 11:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbhEPPGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 May 2021 11:06:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3194C061573;
        Sun, 16 May 2021 08:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=CTEnXBDAU5VgOXas+ZpUCpolUQxSg2nvik9eRBrz2KY=; b=QlCTm0HRiYaur5pKQfxx5+Op1a
        5XKpMmGM15CdRnaTgMsaUJb850RxqUxFRgnzkCL7a18nIKdXuI/QIA3E45SCiu/vFjfzd7SXW8Iz1
        NhWpVb5h745Z96ECQPLhX5Nit8LCKMS5oQwkY/DIfdD/8i05dtIxWLqDrT7mIEQ2xFtakfzGVfT6a
        dX1ilXialPKQ4Tw7S5LGY4OPrfq0+SJX6ejrf88poX8IpMbqR17jFfcaCYEh7LYmEe542iSk7LRbH
        GDScCucAqFiZa5wm6bOuCBOOU+SFqTHXfYUoYN2zB9pH0UpecAH+jCTceGY+T8xeU/rjhMSUvPema
        sTGl7jsg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1liIK0-00C5m2-8O; Sun, 16 May 2021 15:04:50 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Jan Stancek <jstancek@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5.4] iomap: fix sub-page uptodate handling
Date:   Sun, 16 May 2021 16:03:28 +0100
Message-Id: <20210516150328.2881778-1-willy@infradead.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 1cea335d1db1ce6ab71b3d2f94a807112b738a0f upstream

bio completions can race when a page spans more than one file system
block.  Add a spinlock to synchronize marking the page uptodate.

Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap/buffered-io.c | 34 ++++++++++++++++++++++++----------
 include/linux/iomap.h  |  1 +
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 80867a1a94f2..5c73751adb2d 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -30,6 +30,7 @@ iomap_page_create(struct inode *inode, struct page *page)
 	iop = kmalloc(sizeof(*iop), GFP_NOFS | __GFP_NOFAIL);
 	atomic_set(&iop->read_count, 0);
 	atomic_set(&iop->write_count, 0);
+	spin_lock_init(&iop->uptodate_lock);
 	bitmap_zero(iop->uptodate, PAGE_SIZE / SECTOR_SIZE);
 
 	/*
@@ -118,25 +119,38 @@ iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
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
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 7aa5d6117936..53b16f104081 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -139,6 +139,7 @@ loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
 struct iomap_page {
 	atomic_t		read_count;
 	atomic_t		write_count;
+	spinlock_t		uptodate_lock;
 	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
 };
 
-- 
2.30.2

