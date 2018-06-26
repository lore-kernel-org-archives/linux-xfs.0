Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:31782 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751101AbeFZTBf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jun 2018 15:01:35 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 3/3] dm: prevent DAX mounts if not supported
Date: Tue, 26 Jun 2018 13:01:29 -0600
Message-Id: <20180626190129.18112-1-ross.zwisler@linux.intel.com>
In-reply-to: <20180626175932.8899-4-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org

Currently device_supports_dax() just checks to see if the QUEUE_FLAG_DAX
flag is set on the device's request queue to decide whether or not the
device supports filesystem DAX.  Really we should be using
bdev_dax_supported() like filesystems do at mount time.  This performs
other tests like checking to make sure the dax_direct_access() path works.

Conditionally set QUEUE_FLAG_DAX on the DM device's request queue based on
whether all underlying devices support DAX.  Now that bdev_dax_supported()
explicitly checks for this flag, this will ensure that filesystems built
upon DM devices will only be able to mount with DAX if all underlying
devices also support DAX.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: commit 545ed20e6df6 ("dm: add infrastructure for DAX support")
Cc: stable@vger.kernel.org

---

Changes in v4:
 * Set/clear QUEUE_FLAG_DAX in dm_table_set_restrictions(). (Mike)
---
 drivers/md/dm-table.c | 7 ++++---
 drivers/md/dm.c       | 3 +--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 938766794c2e..3d0e2c198f06 100644
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
@@ -1907,6 +1905,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 
 	if (dm_table_supports_dax(t))
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
+	else
+		blk_queue_flag_clear(QUEUE_FLAG_DAX, q);
+
 	if (dm_table_supports_dax_write_cache(t))
 		dax_write_cache(t->md->dax_dev, true);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e65429a29c06..bef5a3f243ed 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1056,8 +1056,7 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	if (len < 1)
 		goto out;
 	nr_pages = min(len, nr_pages);
-	if (ti->type->direct_access)
-		ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
+	ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
 
  out:
 	dm_put_live_table(md, srcu_idx);
-- 
2.14.4

