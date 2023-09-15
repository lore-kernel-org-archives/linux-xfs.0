Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B383C2B9FB
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Sep 2023 21:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237812AbjIOVdb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237741AbjIOVdO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2023 17:33:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DFC196;
        Fri, 15 Sep 2023 14:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Xh7vw1sTfFAIIC7IdEzQuwsZlBUzUqtsvV+NboGq3ok=; b=0ZL4HQvXbqYv52GWetOWj1OK8M
        qehjk4nrJDZukU81QHh6aQ1MpjX0zuIEdK/YETV8xtJeSmbP+fLIjxkHQr3NUETmJkeDDsxRq95tC
        gTXX0uy1loUeReAIlfUj/l1GoMohmYcpCBZs6l5RKmd8IymdTF4A4OGGE0RV+busvY7J+BbWHOi1h
        Ncpwxsfc/OZNdgKT07yd7fGALHiScD5AU2AFoMkxWwGI2hxxBROmEXf/Z3zFm9/d0xMXCoJg6/AgS
        ZCDcRbUYLeYCuz69jWzTUkc8rxWS9JErmsumGG0/ip2aQXTV9gS2PwV+plIt72OMKHM2Q1ekB0DKF
        XeYU/3sw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qhGQq-00BQnM-0U;
        Fri, 15 Sep 2023 21:32:56 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     hch@infradead.org, djwong@kernel.org, dchinner@redhat.com,
        kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com
Cc:     willy@infradead.org, brauner@kernel.org, hare@suse.de,
        ritesh.list@gmail.com, rgoldwyn@suse.com, jack@suse.cz,
        ziy@nvidia.com, ryan.roberts@arm.com, patches@lists.linux.dev,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, p.raghav@samsung.com,
        da.gomez@samsung.com, dan.helmick@samsung.com, mcgrof@kernel.org
Subject: [RFC v2 02/10] bdev: dynamically set aops to enable LBS support
Date:   Fri, 15 Sep 2023 14:32:46 -0700
Message-Id: <20230915213254.2724586-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230915213254.2724586-1-mcgrof@kernel.org>
References: <20230915213254.2724586-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to support large block devices where block size > page size
we must be able to support an aops which does support blocks > ps
and the block layer needs this on its address space operations. We
have to sets of aops and only one which does support bs > ps right
now and that is when we use iomap on the aops for the block device
cache.

If the min order has not yet been set and the target filesystem does
require bs > ps allow for the inode for the block device cache to use
the iomap aops.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 block/bdev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index 6e62d8a992e6..63b4d7dd8075 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -126,6 +126,7 @@ static void set_init_blocksize(struct block_device *bdev)
 {
 	unsigned int bsize = bdev_logical_block_size(bdev);
 	loff_t size = i_size_read(bdev->bd_inode);
+	int order, folio_order;
 
 	while (bsize < PAGE_SIZE) {
 		if (size & bsize)
@@ -133,6 +134,13 @@ static void set_init_blocksize(struct block_device *bdev)
 		bsize <<= 1;
 	}
 	bdev->bd_inode->i_blkbits = blksize_bits(bsize);
+	order = bdev->bd_inode->i_blkbits - PAGE_SHIFT;
+	folio_order = mapping_min_folio_order(bdev->bd_inode->i_mapping);
+	if (order > 0 && folio_order == 0) {
+		mapping_set_folio_orders(bdev->bd_inode->i_mapping, order,
+					 MAX_PAGECACHE_ORDER);
+		bdev->bd_inode->i_data.a_ops = &def_blk_aops_iomap;
+	}
 }
 
 int set_blocksize(struct block_device *bdev, int size)
-- 
2.39.2

