Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:23718 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754813AbeFZR7g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jun 2018 13:59:36 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 2/3] dax: bdev_dax_supported() check for QUEUE_FLAG_DAX
Date: Tue, 26 Jun 2018 11:59:31 -0600
Message-Id: <20180626175932.8899-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org

Add an explicit check for QUEUE_FLAG_DAX to __bdev_dax_supported().  This
is needed for DM configurations where the first element in the dm-linear or
dm-stripe target supports DAX, but other elements do not.  Without this
check __bdev_dax_supported() will pass for such devices, letting a
filesystem on that device mount with the DAX option.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/dax/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 903d9c473749..45276abf03aa 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -86,6 +86,7 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
 {
 	struct dax_device *dax_dev;
 	bool dax_enabled = false;
+	struct request_queue *q;
 	pgoff_t pgoff;
 	int err, id;
 	void *kaddr;
@@ -99,6 +100,13 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
 		return false;
 	}
 
+	q = bdev_get_queue(bdev);
+	if (!q || !blk_queue_dax(q)) {
+		pr_debug("%s: error: request queue doesn't support dax\n",
+				bdevname(bdev, buf));
+		return false;
+	}
+
 	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
 	if (err) {
 		pr_debug("%s: error: unaligned partition for dax\n",
-- 
2.14.4

