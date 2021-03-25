Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E78DC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 20:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47235619FF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 20:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhCYUSM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 16:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhCYUR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 16:17:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5BAC06174A
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 13:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=5sYu+3j89dTdYt5i9a2Ve1TcoMJHlbbvhwDf3xY9Nr8=; b=WykyVGWont44eSbjPk3urZXgPF
        WqpGLogyTApxrsJQloCczxldpJ9QZ/nHavNSNdpT6FFJdtevkGeZEZglU89mv853Uuic5I3Ofx6Mr
        Ka514JqIYn1J7qNjYV04C5/UfJyOZBoC/kF02++n8MbIHWDCHiDGYRJSsPwPt1Fawuu1wxiyz7A4W
        K+hnEzwDsBGRilJ6qkMbGpzbpyACnv4uqz94BHv8XxH6v1SOyyktNbv6h8Fg4ExjaemGN3o2Qb0GU
        VK+JmUy8CWU5L3K1uCSQgB0D61Rsyi6bZ9Qxi3rNvEwCxYWsKokKN3EZGduJg6qP+pssGjl354Giw
        yBCnzXNA==;
Received: from [2001:4bb8:191:f692:97ff:1e47:aee2:c7e5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lPWQV-004xlU-Hh; Thu, 25 Mar 2021 20:17:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] iomap: improve the warnings from iomap_swapfile_activate
Date:   Thu, 25 Mar 2021 21:17:53 +0100
Message-Id: <20210325201753.1292361-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Print the path name of the swapfile that failed to active to ease
debugging the problem and to avoid a scare if xfstests hits these
cases.  Also reword one warning a bit, as the error is not about
a file being on multiple devices, but one that has at least an
extent outside the main device known to the VFS and swap code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/swapfile.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
index a648dbf6991e4e..1dc63beae0c5b8 100644
--- a/fs/iomap/swapfile.c
+++ b/fs/iomap/swapfile.c
@@ -18,6 +18,7 @@ struct iomap_swapfile_info {
 	uint64_t highest_ppage;		/* highest physical addr seen (pages) */
 	unsigned long nr_pages;		/* number of pages collected */
 	int nr_extents;			/* extent count */
+	struct file *file;
 };
 
 /*
@@ -70,6 +71,18 @@ static int iomap_swapfile_add_extent(struct iomap_swapfile_info *isi)
 	return 0;
 }
 
+static int iomap_swapfile_fail(struct iomap_swapfile_info *isi, const char *str)
+{
+	char *buf, *p = ERR_PTR(-ENOMEM);
+
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (buf)
+		p = file_path(isi->file, buf, PATH_MAX);
+	pr_err("swapon: file %s %s\n", IS_ERR(p) ? "<unknown>" : p, str);
+	kfree(buf);
+	return -EINVAL;
+}
+
 /*
  * Accumulate iomaps for this swap file.  We have to accumulate iomaps because
  * swap only cares about contiguous page-aligned physical extents and makes no
@@ -89,28 +102,20 @@ static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
 		break;
 	case IOMAP_INLINE:
 		/* No inline data. */
-		pr_err("swapon: file is inline\n");
-		return -EINVAL;
+		return iomap_swapfile_fail(isi, "is inline");
 	default:
-		pr_err("swapon: file has unallocated extents\n");
-		return -EINVAL;
+		return iomap_swapfile_fail(isi, "has unallocated extents");
 	}
 
 	/* No uncommitted metadata or shared blocks. */
-	if (iomap->flags & IOMAP_F_DIRTY) {
-		pr_err("swapon: file is not committed\n");
-		return -EINVAL;
-	}
-	if (iomap->flags & IOMAP_F_SHARED) {
-		pr_err("swapon: file has shared extents\n");
-		return -EINVAL;
-	}
+	if (iomap->flags & IOMAP_F_DIRTY)
+		return iomap_swapfile_fail(isi, "is not committed");
+	if (iomap->flags & IOMAP_F_SHARED)
+		return iomap_swapfile_fail(isi, "has shared extents");
 
 	/* Only one bdev per swap file. */
-	if (iomap->bdev != isi->sis->bdev) {
-		pr_err("swapon: file is on multiple devices\n");
-		return -EINVAL;
-	}
+	if (iomap->bdev != isi->sis->bdev)
+		return iomap_swapfile_fail(isi, "outside the main device");
 
 	if (isi->iomap.length == 0) {
 		/* No accumulated extent, so just store it. */
@@ -139,6 +144,7 @@ int iomap_swapfile_activate(struct swap_info_struct *sis,
 	struct iomap_swapfile_info isi = {
 		.sis = sis,
 		.lowest_ppage = (sector_t)-1ULL,
+		.file = swap_file,
 	};
 	struct address_space *mapping = swap_file->f_mapping;
 	struct inode *inode = mapping->host;
-- 
2.30.1

