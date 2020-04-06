Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A67A8C2BA1A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 23:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7615520753
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 23:24:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OsMIIyBe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgDFXYy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 19:24:54 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37643 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgDFXYx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 19:24:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586215494; x=1617751494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JpG8RoP9sjPTQZUZuotmMtyZZCorxEdnwJjh+t5ypTA=;
  b=OsMIIyBeiuPOAr/NbavqL9+WAElK0g7xymfnTBoDqr3xOhF0nryh1oQ9
   ICHO/UeeJoObFvgmyIefdHkL11Hla8zvOFsiLytzreiu4udy/vAQXdpXm
   8EgqLP6iFQhXyEbL8+F11+McRi8Gd6YpBKBF1UqK/EptWH0vMZOMtIedQ
   mYrWPN/jwKOflDditIxf4pzA1XXo8k8YFPLQwyIVHCkDWV1/r4O16lL7K
   0KmzBO1g0Ro9FS72RKwevPHkVaZn0SLRy05tu2qHPCUmuFlQ+ZmBTdX0F
   UNeKvIB1vjTVSRvKwZYxJSErNGJiesHDJq3CuVxVjM6akL7WBR5bZ/zQ7
   A==;
IronPort-SDR: C8UYAH5PI750knnFDRV6ynEtfXzknRbasfFaSjgZhM7wpePeZLa65lB4Etm4YF5pTbZIq/ySKL
 lBP0+n1Rh84+prIvYKimrFNRHf7EcfhA6/GDuIkgaKGnqH+TWPiA6f5FROtmQWMPJnGBHwVllS
 htiWLkyB2XCcyGXOXmPefl95XgsMVM2AcwkQlQYf1u6V/lWERw2baxOVa1psWnkhldUvsfbZZ0
 caPQtQF1Q5LT5EhIPbqMg93/wE4GsGUG4Zr8a+4Fbj0gFAHAyEYCKxxdanrHI9u/CHZ1AD+vuy
 mZ4=
X-IronPort-AV: E=Sophos;i="5.72,352,1580745600"; 
   d="scan'208";a="135040044"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Apr 2020 07:24:53 +0800
IronPort-SDR: uOQqPRCfVQYUyffa+Da6AL6VlMcx467wLqzleNfh5S8n2sb8dZfPkuhTYEkrExedgUFjaQfk/E
 pihQISXeNrIxSahDPyvOI2xM+fl0vSV1NaBcRBrGbQ2YGzj/61XYSgchdHfGt5xQkiQ0cJ54MO
 hPPyBppl+yrshixQoM+0DGPmOfgPAlLr22i7B6z+LpKuOuUuQsvh/C+hR2IJ6rzfAujZ5oBRWW
 /cFcNbnTnSGDwkb9y+hY8GZgzaskX2ZGIxii1gVltlfuXTT04yEhRfzyE8R5MKMMKzu1k3a8Nd
 Sl32qvPN07BW1TrFhsBWIYA9
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 16:15:36 -0700
IronPort-SDR: sr81OS6lHPZ4EdneRsod66M1Mt/uuvWXuOJbFcNL75UR21aCvXqasA3oRCh2hAuo5Rw7Y8w8wg
 TCcoj60shMB4C8sFKwy+KyBR9KzTgzZAi7rhL2JQ3BRbiXTjKE2R30+oi+vzzlMdsbdA438LXe
 ZjuUM2I2F1sp+pF/YaIqDDBpaDoT6Sc/+YQLB85WaGXVJ8BqgxGfVPIWNwI/BOQWP4Jb8bG0AP
 WE9lbOTxjL71lFGn5aiMp0S0LoYAdPElGfT/1j9+c+C6vcBqBVixyqGATPbeCdEDc2T5ouelv8
 j4o=
WDCIronportException: Internal
Received: from iouring.labspan.wdc.com (HELO iouring.sc.wdc.com) ([10.6.138.107])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Apr 2020 16:24:52 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, danil.kipnis@cloud.ionos.com,
        jinpu.wang@cloud.ionos.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 1/2] block: add bio based rw helper for data buffer
Date:   Mon,  6 Apr 2020 16:24:39 -0700
Message-Id: <20200406232440.4027-2-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200406232440.4027-1-chaitanya.kulkarni@wdc.com>
References: <20200406232440.4027-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

One of the common application for the file systems and drivers to map
the buffer to the bio and issue I/Os on the block device.

This is a prep patch which adds two helper functions for block layer
which allows file-systems and the drivers to map data buffer on to the
bios and issue bios synchronously using blkdev_issue_rw() or
asynchronously using __blkdev_issue_rw().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-lib.c        | 105 +++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |   7 +++
 2 files changed, 112 insertions(+)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 5f2c429d4378..451c367fc0d6 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -405,3 +405,108 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_zeroout);
+
+/**
+ * __blkdev_ssue_rw - issue read/write bios from buffer asynchronously
+ * @bdev:	blockdev to read/write
+ * @buf:	data buffer
+ * @sector:	start sector
+ * @nr_sects:	number of sectors
+ * @op:	REQ_OP_READ or REQ_OP_WRITE
+ * @opf:	flags
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @biop:	pointer to anchor bio
+ *
+ * Description:
+ *  Generic helper function to map data buffer into bios for read and write ops.
+ *  Returns pointer to the anchored last bio for caller to submit asynchronously
+ *  or synchronously.
+ */
+int __blkdev_issue_rw(struct block_device *bdev, char *buf, sector_t sector,
+		      sector_t nr_sects, unsigned op, unsigned opf,
+		      gfp_t gfp_mask, struct bio **biop)
+{
+	bool vm = is_vmalloc_addr(buf) ? true : false;
+	struct bio *bio = *biop;
+	unsigned int nr_pages;
+	struct page *page;
+	unsigned int off;
+	unsigned int len;
+	int bi_size;
+
+	if (!bdev_get_queue(bdev))
+		return -ENXIO;
+
+	if (bdev_read_only(bdev))
+		return -EPERM;
+
+	if (!(op == REQ_OP_READ || op == REQ_OP_WRITE))
+		return -EINVAL;
+
+	while (nr_sects != 0) {
+		nr_pages = __blkdev_sectors_to_bio_pages(nr_sects);
+
+		bio = blk_next_bio(bio, nr_pages, gfp_mask);
+		bio->bi_iter.bi_sector = sector;
+		bio_set_dev(bio, bdev);
+		bio_set_op_attrs(bio, op, 0);
+
+		while (nr_sects != 0) {
+			off = offset_in_page(buf);
+			page = vm ? vmalloc_to_page(buf) : virt_to_page(buf);
+			len = min((sector_t) PAGE_SIZE, nr_sects << 9);
+
+			bi_size = bio_add_page(bio, page, len, off);
+
+			nr_sects -= bi_size >> 9;
+			sector += bi_size >> 9;
+			buf += bi_size;
+
+			if (bi_size < len)
+				break;
+		}
+		cond_resched();
+	}
+	*biop = bio;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__blkdev_issue_rw);
+
+/**
+ * blkdev_execute_rw_sync - issue read/write bios from buffer synchronously
+ * @bdev:	blockdev to read/write
+ * @buf:	data buffer
+ * @sector:	start sector
+ * @count:	number of bytes
+ * @op:	REQ_OP_READ or REQ_OP_WRITE
+ * @opf:	flags
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *  Generic helper function to map data buffer buffer into bios for read and
+ *  write requests.
+ */
+int blkdev_issue_rw(struct block_device *b, char *buf, sector_t sector,
+		     unsigned count, unsigned op, unsigned opf, gfp_t mask)
+{
+	unsigned int is_vmalloc = is_vmalloc_addr(buf);
+	sector_t nr_sects = count >> 9;
+	struct bio *bio = NULL;
+	int error;
+
+	if (is_vmalloc && op == REQ_OP_WRITE)
+		flush_kernel_vmap_range(buf, count);
+
+	opf |= REQ_SYNC;
+	error = __blkdev_issue_rw(b, buf, sector, nr_sects, op, opf, mask, &bio);
+	if (!error && bio) {
+		error = submit_bio_wait(bio);
+		bio_put(bio);
+	}
+
+	if (is_vmalloc && op == REQ_OP_READ)
+		invalidate_kernel_vmap_range(buf, count);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(blkdev_issue_rw);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 32868fbedc9e..cb315b301ad9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1248,6 +1248,13 @@ static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
 				    gfp_mask, 0);
 }
 
+extern int __blkdev_issue_rw(struct block_device *bdev, char *buf,
+			     sector_t sector, sector_t nr_sects, unsigned op,
+			     unsigned opf, gfp_t gfp_mask, struct bio **biop);
+extern int blkdev_issue_rw(struct block_device *b, char *buf, sector_t sector,
+			   unsigned count, unsigned op, unsigned opf,
+			   gfp_t mask);
+
 extern int blk_verify_command(unsigned char *cmd, fmode_t mode);
 
 enum blk_default_limits {
-- 
2.22.1

