Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53130 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbfBMJxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 04:53:33 -0500
From: Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH v2 3/9] md:raid1: set mirrors correctly
Date: Wed, 13 Feb 2019 17:50:38 +0800
Message-Id: <20190213095044.29628-4-bob.liu@oracle.com>
In-Reply-To: <20190213095044.29628-1-bob.liu@oracle.com>
References: <20190213095044.29628-1-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, Bob Liu <bob.liu@oracle.com>

In stack layer case, the mirror of upper layer device is the sum of mirrors of
all lower layer devices.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/md/raid1.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1e5a51f22332..0de28714e9b5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3050,6 +3050,7 @@ static int raid1_run(struct mddev *mddev)
 	struct md_rdev *rdev;
 	int ret;
 	bool discard_supported = false;
+	unsigned long mirrors = 0;
 
 	if (mddev->level != 1) {
 		pr_warn("md/raid1:%s: raid level not set to mirroring (%d)\n",
@@ -3084,11 +3085,15 @@ static int raid1_run(struct mddev *mddev)
 	rdev_for_each(rdev, mddev) {
 		if (!mddev->gendisk)
 			continue;
+		mirrors += blk_queue_get_mirrors(bdev_get_queue(rdev->bdev));
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
 		if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
 			discard_supported = true;
 	}
+	if (mddev->queue)
+		if (!blk_queue_set_mirrors(mddev->queue, mirrors))
+			return -EINVAL;
 
 	mddev->degraded = 0;
 	for (i=0; i < conf->raid_disks; i++)
-- 
2.17.1
