Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:33575 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752625AbdIEVZB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 17:25:01 -0400
Received: by mail-pg0-f44.google.com with SMTP id t3so11701069pgt.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2017 14:25:01 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] loop: set physical block size to logical block size
Date: Tue,  5 Sep 2017 14:24:47 -0700
Message-Id: <8b3faca77b098c23827e48fc8f5b2ad973f3c23d.1504646604.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: kernel-team@fb.com, Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>, Karel Zak <kzak@redhat.com>, Milan Broz <gmazyland@gmail.com>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Commit 6c6b6f28b333 ("loop: set physical block size to PAGE_SIZE")
caused mkfs.xfs to barf on ppc64 [1]. Always using PAGE_SIZE as the
physical block size still makes the most sense semantically, but let's
just lie and always set it to the same value as the logical block size
(same goes for io_min). In the future we might want to at least bump up
io_min to PAGE_SIZE but I'm sick of these stupid changes so let's play
it safe.

1: https://marc.info/?l=linux-xfs&m=150459024723753&w=2

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 drivers/block/loop.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 78c47c4b584d..85de67334695 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1036,6 +1036,8 @@ static int loop_clr_fd(struct loop_device *lo)
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
 	blk_queue_logical_block_size(lo->lo_queue, 512);
+	blk_queue_physical_block_size(lo->lo_queue, 512);
+	blk_queue_io_min(lo->lo_queue, 512);
 	if (bdev) {
 		bdput(bdev);
 		invalidate_bdev(bdev);
@@ -1330,6 +1332,8 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 	blk_mq_freeze_queue(lo->lo_queue);
 
 	blk_queue_logical_block_size(lo->lo_queue, arg);
+	blk_queue_physical_block_size(lo->lo_queue, arg);
+	blk_queue_io_min(lo->lo_queue, arg);
 	loop_update_dio(lo);
 
 	blk_mq_unfreeze_queue(lo->lo_queue);
@@ -1777,8 +1781,6 @@ static int loop_add(struct loop_device **l, int i)
 	}
 	lo->lo_queue->queuedata = lo;
 
-	blk_queue_physical_block_size(lo->lo_queue, PAGE_SIZE);
-
 	blk_queue_max_hw_sectors(lo->lo_queue, BLK_DEF_MAX_SECTORS);
 
 	/*
-- 
2.14.1

