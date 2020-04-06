Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C51BC2BA1A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 23:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D78620753
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 23:25:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BSv8rDCG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgDFXZG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 19:25:06 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:45333 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgDFXZF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 19:25:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586215504; x=1617751504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yJMVJjs8Tg8tTHOw21er81hvgxe/6jLJlylymC8JZPw=;
  b=BSv8rDCGUzkZocjARNbMV0abXtzncQoMLBWKKEtFNFTNpxNNJ3C1IUNq
   aXsCNOxRrLT6cOExJfqCdg1lR6DS9bJjJhJlW9+Tf3HhzN92zPOkhxpQ2
   rH9jgRUkcTCYtRUUiiu74uc5mgtTmoXhnIgCk0KqhTy9uFfy5vo/O1gj3
   mlhDL9ic3lyK17H7NFdSvS4O0+afkI15jGFzYldE7lVUx58E/06QeCwG9
   yfFShd7oQIwNMSBZmCZnmfhnA948p9Dtijejneybe/t6aPN50i92QjS01
   4yzdGDG/N8DafWkjLYvXMp4J4GaDFtSZ7i2HyWBtZqh12yJT6SFut8aNX
   g==;
IronPort-SDR: tanPFpRBP6MWqDH0A4VjAQOzOkZ4DwJpsd2l5k3hBKIpEUNY5VW4XfHa+Y5czzHc6D7NELnG08
 2lGsU6WMYurWHu82mwtOK9In0jGJr2xqm6MS3uXMpzn4ElRjvuDNNf9kIWs9a91ADcdkQLVYJn
 vQa+JvZueWMGhukUysldoDbcvtuxBM7sujd48BtXRKKz1+LaQ2yctnFg0fQjBfwhxxW6m6vjH0
 zhUleX97g3fFR2rfNaVldV3kYwLWnjMauYPWd3VPLArWz0hOFWvXvMBd4LUCUNzOZZ5sXPD+6j
 fj4=
X-IronPort-AV: E=Sophos;i="5.72,352,1580745600"; 
   d="scan'208";a="243262378"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Apr 2020 07:25:04 +0800
IronPort-SDR: mtuxDEISxvLjv3wD9YeAIW0s/NTwmyr6SkheNyEm1jw9EZiCi5IQQUIyg9EUjwU0E0puNstNLi
 dCQB0/lA7haqAw08IzA9OSsRnRyebj9TGvroz1PachcbP0belkhSQkEyHsC+GjazmflFTX5vsD
 0KFu/g4jqYz53lSq5aS0h4e+F9Q0qtoa4u/iyldIvxha6FDmDsAPRGU/EpdVmaW/U0rhNp3fWB
 7Uuwr6R3PkdTuZKDwP5ABqwRXLaVrhgjzuoslT8XFJ/hvBQgctswGOu8UjmV1xF1pgp6TnaIro
 MmlNfLmeexeD+SfOGxZ8TV1j
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 16:15:48 -0700
IronPort-SDR: UT1OC9+Myzt65Sjpee3DgDcEGTJifMJOTfJJmZfVX2KP03f75hZQl9N+1kJ4af+P91Mcr7Ue2K
 K0MfePtROV8wE1amcpHFwzXijuGLn03nAXcqoywHjWAyzPeW8WRxPL+GcihVCrVL4BhFFany/4
 XZ0B9hDE6TD/lAaf3vmmO7oe2kxWLasZ79G/ycRdyjlUQ8VbIOZ/EICmJcGA8TzoDRER3M/F/M
 BoI2Q+V1BsjpQ4jad9PjGG/jzmxVYTNA++3DM3Bt3IVUT1MQzVGC+fKUq/VAIR8jUdfHoqLaG8
 /M0=
WDCIronportException: Internal
Received: from iouring.labspan.wdc.com (HELO iouring.sc.wdc.com) ([10.6.138.107])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Apr 2020 16:25:04 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, danil.kipnis@cloud.ionos.com,
        jinpu.wang@cloud.ionos.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 2/2] xfs: use block layer helper for rw
Date:   Mon,  6 Apr 2020 16:24:40 -0700
Message-Id: <20200406232440.4027-3-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200406232440.4027-1-chaitanya.kulkarni@wdc.com>
References: <20200406232440.4027-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The existing routine xfs_rw_bdev has block layer bio-based code which
maps the data buffer allocated with kmalloc or vmalloc to the READ/WRITE
bios. Use a block layer helper from the previous patch to avoid code
duplication.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/xfs/xfs_bio_io.c | 47 ++-------------------------------------------
 1 file changed, 2 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index e2148f2d5d6b..b04c398fb99c 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -4,11 +4,6 @@
  */
 #include "xfs.h"
 
-static inline unsigned int bio_max_vecs(unsigned int count)
-{
-	return min_t(unsigned, howmany(count, PAGE_SIZE), BIO_MAX_PAGES);
-}
-
 int
 xfs_rw_bdev(
 	struct block_device	*bdev,
@@ -18,44 +13,6 @@ xfs_rw_bdev(
 	unsigned int		op)
 
 {
-	unsigned int		is_vmalloc = is_vmalloc_addr(data);
-	unsigned int		left = count;
-	int			error;
-	struct bio		*bio;
-
-	if (is_vmalloc && op == REQ_OP_WRITE)
-		flush_kernel_vmap_range(data, count);
-
-	bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
-	bio_set_dev(bio, bdev);
-	bio->bi_iter.bi_sector = sector;
-	bio->bi_opf = op | REQ_META | REQ_SYNC;
-
-	do {
-		struct page	*page = kmem_to_page(data);
-		unsigned int	off = offset_in_page(data);
-		unsigned int	len = min_t(unsigned, left, PAGE_SIZE - off);
-
-		while (bio_add_page(bio, page, len, off) != len) {
-			struct bio	*prev = bio;
-
-			bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
-			bio_copy_dev(bio, prev);
-			bio->bi_iter.bi_sector = bio_end_sector(prev);
-			bio->bi_opf = prev->bi_opf;
-			bio_chain(prev, bio);
-
-			submit_bio(prev);
-		}
-
-		data += len;
-		left -= len;
-	} while (left > 0);
-
-	error = submit_bio_wait(bio);
-	bio_put(bio);
-
-	if (is_vmalloc && op == REQ_OP_READ)
-		invalidate_kernel_vmap_range(data, count);
-	return error;
+	return blkdev_issue_rw(bdev, data, sector, count, op, REQ_META,
+			       GFP_KERNEL);
 }
-- 
2.22.1

