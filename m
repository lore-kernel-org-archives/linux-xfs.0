Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9D6C43219
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Apr 2022 04:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbiDIEy1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Apr 2022 00:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236854AbiDIExn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Apr 2022 00:53:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475DBBB933;
        Fri,  8 Apr 2022 21:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fGcL4rT6o55inYg+xD7k4NQPOksglZvB+PFSEP+xhA8=; b=x49SryV2SEOzb+YKli0UJZwys7
        Znb1rsPTkSfYcHPVo9D6b2U83E7uqw2G98XO8zYfl/hKwrvVhicKgqjDvuZYTEB489P843L//CwDT
        gqCbBf9JUwJ6J0Nu3a/lcC/IfwnnEVdVHN84pWvuhxzJiYH6crHhPnTIzf9dIWY5MLhKlVfzyM0Vq
        bwRuU6hgXkjUYp1qcxu8V6Fo824rSDUIbNTnNROyu48YrBGf3oVsysJ9CQPrqpevcWLNQdLnu2N4C
        4XspCM6we8vYPn8dRLL0TG98f118C88z+RALpryzLlARTzoVN3y6dQTJp4lOBr41BAbVo0sl+miwh
        a6JWWqsQ==;
Received: from 213-147-167-116.nat.highway.webapn.at ([213.147.167.116] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nd345-0020fc-8h; Sat, 09 Apr 2022 04:51:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        nbd@other.debian.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 08/27] btrfs: use bdev_max_active_zones instead of open coding it
Date:   Sat,  9 Apr 2022 06:50:24 +0200
Message-Id: <20220409045043.23593-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 1b1b310c3c510..f72cad7391a11 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -350,7 +350,6 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_zoned_device_info *zone_info = NULL;
 	struct block_device *bdev = device->bdev;
-	struct request_queue *queue = bdev_get_queue(bdev);
 	unsigned int max_active_zones;
 	unsigned int nactive;
 	sector_t nr_sectors;
@@ -410,7 +409,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	if (!IS_ALIGNED(nr_sectors, zone_sectors))
 		zone_info->nr_zones++;
 
-	max_active_zones = queue_max_active_zones(queue);
+	max_active_zones = bdev_max_active_zones(bdev);
 	if (max_active_zones && max_active_zones < BTRFS_MIN_ACTIVE_ZONES) {
 		btrfs_err_in_rcu(fs_info,
 "zoned: %s: max active zones %u is too small, need at least %u active zones",
-- 
2.30.2

