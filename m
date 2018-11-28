Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49868 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbeK1Owl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 09:52:41 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v1 3/7] md: raid1: handle bi_rw_hint accordingly
Date: Tue, 27 Nov 2018 20:49:47 -0700
Message-Id: <1543376991-5764-4-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com, allison.henderson@oracle.com

From: Bob Liu <bob.liu@oracle.com>

* nr_mirrors that raid1 device support should be @raid_disks, init it properly.
* Recording i/o went to which mirror in bio->bi_rw_hint.
* Read from specific real device if bi_rw_hint was set.

Todo:
 * Support more drivers.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/md/raid1.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fedf8c0..d2bdd0e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -553,7 +553,8 @@ static sector_t align_to_barrier_unit_end(sector_t start_sector,
  *
  * The rdev for the device selected will have nr_pending incremented.
  */
-static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sectors)
+static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sectors,
+			unsigned short disk_hint)
 {
 	const sector_t this_sector = r1_bio->sector;
 	int sectors;
@@ -566,6 +567,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 	struct md_rdev *rdev;
 	int choose_first;
 	int choose_next_idle;
+	int max_disks;
 
 	rcu_read_lock();
 	/*
@@ -593,7 +595,20 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 	else
 		choose_first = 0;
 
-	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
+	if (disk_hint) {
+		disk = disk_hint - 1;
+		/*
+		 * Consider replacement as a special case, use original device to
+		 * indicate which mirror this i/o was happened.
+		 */
+		if (disk >= conf->raid_disks)
+			disk -= conf->raid_disks;
+		max_disks = disk + 1;
+	} else {
+		disk = 0;
+		max_disks = conf->raid_disks * 2;
+	}
+	for (; disk < max_disks; disk++) {
 		sector_t dist;
 		sector_t first_bad;
 		int bad_sectors;
@@ -1234,7 +1249,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	 * make_request() can abort the operation when read-ahead is being
 	 * used and no empty request is available.
 	 */
-	rdisk = read_balance(conf, r1_bio, &max_sectors);
+	rdisk = read_balance(conf, r1_bio, &max_sectors, bio->bi_rw_hint);
 
 	if (rdisk < 0) {
 		/* couldn't find anywhere to read from */
@@ -1247,6 +1262,10 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		raid_end_bio_io(r1_bio);
 		return;
 	}
+
+	/* Recording i/o went to which real device. */
+	bio->bi_rw_hint = rdisk;
+
 	mirror = conf->mirrors + rdisk;
 
 	if (print_msg)
@@ -1279,6 +1298,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	r1_bio->read_disk = rdisk;
 
 	read_bio = bio_clone_fast(bio, gfp, &mddev->bio_set);
+	/*
+	 * Clear bi_rw_hint, because it was set last i/o went to which real
+	 * device.
+	 */
+	read_bio->bi_rw_hint = 0;
 
 	r1_bio->bios[rdisk] = read_bio;
 
@@ -3078,6 +3102,7 @@ static int raid1_run(struct mddev *mddev)
 	if (mddev->queue) {
 		blk_queue_max_write_same_sectors(mddev->queue, 0);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
+		blk_queue_set_mirrors(mddev->queue, mddev->raid_disks);
 	}
 
 	rdev_for_each(rdev, mddev) {
-- 
2.7.4
