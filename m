Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:7357 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966532AbeE2TvN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 15:51:13 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 3/7] dm: fix test for DAX device support
Date: Tue, 29 May 2018 13:51:02 -0600
Message-Id: <20180529195106.14268-4-ross.zwisler@linux.intel.com>
In-Reply-To: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

Currently device_supports_dax() just checks to see if the QUEUE_FLAG_DAX
flag is set on the device's request queue to decide whether or not the
device supports filesystem DAX.  This is insufficient because there are
devices like PMEM namespaces in raw mode which have QUEUE_FLAG_DAX set but
which don't actually support DAX.

This means that you could create a dm-linear device, for example, where the
first part of the dm-linear device was a PMEM namespace in fsdax mode and
the second part was a PMEM namespace in raw mode.  Both DM and the
filesystem you put on that dm-linear device would think the whole device
supports DAX, which would lead to bad behavior once your raw PMEM namespace
part using DAX needed struct page for something.

Fix this by using bdev_dax_supported() like filesystems do at mount time.
This checks for raw mode and also performs other tests like checking to
make sure the dax_direct_access() path works.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: commit 545ed20e6df6 ("dm: add infrastructure for DAX support")
---
 drivers/md/dm-table.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0589a4da12bb..5bb994b012ca 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -885,9 +885,7 @@ EXPORT_SYMBOL_GPL(dm_table_set_type);
 static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
 			       sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
-
-	return q && blk_queue_dax(q);
+	return bdev_dax_supported(dev->bdev, PAGE_SIZE);
 }
 
 static bool dm_table_supports_dax(struct dm_table *t)
-- 
2.14.3

