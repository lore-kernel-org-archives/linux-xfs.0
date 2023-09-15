Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4293CD37AE
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Sep 2023 22:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbjIOWoP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 18:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238102AbjIOWn4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2023 18:43:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37329271B;
        Fri, 15 Sep 2023 15:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=kAhu3RhQYAb+8x8i6cEfQIaFhfRyBt/UYtL6yvE2uiU=; b=ipX40f4//V/ZCGGZ4czyigk+tq
        Y1pEa4+9a0xgZHI9HB4D4Tfrictfi7SMy0XGAfRV739gQESHHurrBTlm5Ua+EE3iZV0tsx6IKqvwZ
        IiC6jCE6msF7T92DFE/znIds6/zZgcrifjXuvn0EcmNskZ6gPaGreeyH5rJC6lgqaAeL6P7rfVtkG
        DMPIuRQ+bZaIIBLKq7iwAyTitwD25b+3/vJUJ6ZlqhptkqgEUnJsMCFqyWqs7kD/j4JUp8wQpiPG0
        Ac3VauQPjIuDinZl/qGvSMQdchK2QEx+UkGmAc0m6gGcpDATkelTsHLTVh8nggDwFVZd4JhiP4A92
        z2qI6tpQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qhHXM-00BUtM-2g;
        Fri, 15 Sep 2023 22:43:44 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        christoph.boehmwalder@linbit.com, hch@infradead.org,
        djwong@kernel.org, minchan@kernel.org, senozhatsky@chromium.org
Cc:     patches@lists.linux.dev, linux-block@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, hare@suse.de, p.raghav@samsung.com,
        da.gomez@samsung.com, rohan.puri@samsung.com,
        rpuri.linux@gmail.com, kbusch@kernel.org, mcgrof@kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 1/4] drbd: use PAGE_SECTORS_SHIFT and PAGE_SECTORS
Date:   Fri, 15 Sep 2023 15:43:40 -0700
Message-Id: <20230915224343.2740317-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230915224343.2740317-1-mcgrof@kernel.org>
References: <20230915224343.2740317-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace common constants with generic versions.
This produces no functional changes.

Acked-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/drbd/drbd_bitmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 85ca000a0564..1a1782f55e61 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1000,7 +1000,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 	unsigned int len;
 
 	first_bm_sect = device->ldev->md.md_offset + device->ldev->md.bm_offset;
-	on_disk_sector = first_bm_sect + (((sector_t)page_nr) << (PAGE_SHIFT-SECTOR_SHIFT));
+	on_disk_sector = first_bm_sect + (((sector_t)page_nr) << PAGE_SECTORS_SHIFT);
 
 	/* this might happen with very small
 	 * flexible external meta data device,
@@ -1008,7 +1008,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 	last_bm_sect = drbd_md_last_bitmap_sector(device->ldev);
 	if (first_bm_sect <= on_disk_sector && last_bm_sect >= on_disk_sector) {
 		sector_t len_sect = last_bm_sect - on_disk_sector + 1;
-		if (len_sect < PAGE_SIZE/SECTOR_SIZE)
+		if (len_sect < PAGE_SECTORS)
 			len = (unsigned int)len_sect*SECTOR_SIZE;
 		else
 			len = PAGE_SIZE;
-- 
2.39.2

