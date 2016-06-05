Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 085637D0E
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:33:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1014304043
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:33:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DFDkXmO2CpLi6hlI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:33:34 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 27/45] md: use bio op accessors
Date: Sun,  5 Jun 2016 14:32:07 -0500
Message-Id: <1465155145-10812-28-git-send-email-mchristi@redhat.com>
In-Reply-To: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

Separate the op from the rq_flag_bits and have md
set/get the bio using bio_set_op_attrs/bio_op.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/md/bitmap.c      |  2 +-
 drivers/md/dm-raid.c     |  5 +++--
 drivers/md/linear.c      |  2 +-
 drivers/md/md.c          | 12 ++++++------
 drivers/md/md.h          |  3 ++-
 drivers/md/raid0.c       |  2 +-
 drivers/md/raid1.c       | 32 +++++++++++++++-----------------
 drivers/md/raid10.c      | 48 +++++++++++++++++++++++-------------------------
 drivers/md/raid5-cache.c | 26 ++++++++++++++++----------
 drivers/md/raid5.c       | 40 ++++++++++++++++++++--------------------
 10 files changed, 88 insertions(+), 84 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index bc6dced..6fff794 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -162,7 +162,7 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
 
 		if (sync_page_io(rdev, target,
 				 roundup(size, bdev_logical_block_size(rdev->bdev)),
-				 page, READ, true)) {
+				 page, REQ_OP_READ, 0, true)) {
 			page->index = index;
 			return 0;
 		}
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 5253274..8cbac62 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -792,7 +792,7 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 	if (rdev->sb_loaded)
 		return 0;
 
-	if (!sync_page_io(rdev, 0, size, rdev->sb_page, READ, 1)) {
+	if (!sync_page_io(rdev, 0, size, rdev->sb_page, REQ_OP_READ, 0, 1)) {
 		DMERR("Failed to read superblock of device at position %d",
 		      rdev->raid_disk);
 		md_error(rdev->mddev, rdev);
@@ -1651,7 +1651,8 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 	for (i = 0; i < rs->md.raid_disks; i++) {
 		r = &rs->dev[i].rdev;
 		if (test_bit(Faulty, &r->flags) && r->sb_page &&
-		    sync_page_io(r, 0, r->sb_size, r->sb_page, READ, 1)) {
+		    sync_page_io(r, 0, r->sb_size, r->sb_page, REQ_OP_READ, 0,
+				 1)) {
 			DMINFO("Faulty %s device #%d has readable super block."
 			       "  Attempting to revive it.",
 			       rs->raid_type->name, i);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index b7fe7e9..1ad3f48 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -252,7 +252,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 		split->bi_iter.bi_sector = split->bi_iter.bi_sector -
 			start_sector + data_offset;
 
-		if (unlikely((split->bi_rw & REQ_DISCARD) &&
+		if (unlikely((bio_op(split) == REQ_OP_DISCARD) &&
 			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
 			/* Just ignore it */
 			bio_endio(split);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index fb3950b..bd4844f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -394,7 +394,7 @@ static void submit_flushes(struct work_struct *ws)
 			bi->bi_end_io = md_end_flush;
 			bi->bi_private = rdev;
 			bi->bi_bdev = rdev->bdev;
-			bi->bi_rw = WRITE_FLUSH;
+			bio_set_op_attrs(bi, REQ_OP_WRITE, WRITE_FLUSH);
 			atomic_inc(&mddev->flush_pending);
 			submit_bio(bi);
 			rcu_read_lock();
@@ -743,7 +743,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	bio_add_page(bio, page, size, 0);
 	bio->bi_private = rdev;
 	bio->bi_end_io = super_written;
-	bio->bi_rw = WRITE_FLUSH_FUA;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_FLUSH_FUA);
 
 	atomic_inc(&mddev->pending_writes);
 	submit_bio(bio);
@@ -756,14 +756,14 @@ void md_super_wait(struct mddev *mddev)
 }
 
 int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
-		 struct page *page, int rw, bool metadata_op)
+		 struct page *page, int op, int op_flags, bool metadata_op)
 {
 	struct bio *bio = bio_alloc_mddev(GFP_NOIO, 1, rdev->mddev);
 	int ret;
 
 	bio->bi_bdev = (metadata_op && rdev->meta_bdev) ?
 		rdev->meta_bdev : rdev->bdev;
-	bio->bi_rw = rw;
+	bio_set_op_attrs(bio, op, op_flags);
 	if (metadata_op)
 		bio->bi_iter.bi_sector = sector + rdev->sb_start;
 	else if (rdev->mddev->reshape_position != MaxSector &&
@@ -789,7 +789,7 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 	if (rdev->sb_loaded)
 		return 0;
 
-	if (!sync_page_io(rdev, 0, size, rdev->sb_page, READ, true))
+	if (!sync_page_io(rdev, 0, size, rdev->sb_page, REQ_OP_READ, 0, true))
 		goto fail;
 	rdev->sb_loaded = 1;
 	return 0;
@@ -1475,7 +1475,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 			return -EINVAL;
 		bb_sector = (long long)offset;
 		if (!sync_page_io(rdev, bb_sector, sectors << 9,
-				  rdev->bb_page, READ, true))
+				  rdev->bb_page, REQ_OP_READ, 0, true))
 			return -EIO;
 		bbp = (u64 *)page_address(rdev->bb_page);
 		rdev->badblocks.shift = sb->bblog_shift;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b5c4be7..2e0918f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -618,7 +618,8 @@ extern void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 			   sector_t sector, int size, struct page *page);
 extern void md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
-			struct page *page, int rw, bool metadata_op);
+			struct page *page, int op, int op_flags,
+			bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
 extern void md_new_event(struct mddev *mddev);
 extern int md_allow_write(struct mddev *mddev);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 34783a3..051a10c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -488,7 +488,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 		split->bi_iter.bi_sector = sector + zone->dev_start +
 			tmp_dev->data_offset;
 
-		if (unlikely((split->bi_rw & REQ_DISCARD) &&
+		if (unlikely((bio_op(split) == REQ_OP_DISCARD) &&
 			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
 			/* Just ignore it */
 			bio_endio(split);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index bc95d4d..a342723 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -759,7 +759,7 @@ static void flush_pending_writes(struct r1conf *conf)
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
 			bio->bi_next = NULL;
-			if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+			if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
 			    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 				/* Just ignore it */
 				bio_endio(bio);
@@ -1033,7 +1033,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		bio->bi_next = NULL;
-		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
 		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 			/* Just ignore it */
 			bio_endio(bio);
@@ -1053,12 +1053,11 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
 	int i, disks;
 	struct bitmap *bitmap;
 	unsigned long flags;
+	const int op = bio_op(bio);
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
-	const unsigned long do_discard = (bio->bi_rw
-					  & (REQ_DISCARD | REQ_SECURE));
-	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
+	const unsigned long do_sec = (bio->bi_rw & REQ_SECURE);
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
 	struct raid1_plug_cb *plug = NULL;
@@ -1166,7 +1165,7 @@ read_again:
 			mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = raid1_end_read_request;
-		read_bio->bi_rw = READ | do_sync;
+		bio_set_op_attrs(read_bio, op, do_sync);
 		read_bio->bi_private = r1_bio;
 
 		if (max_sectors < r1_bio->sectors) {
@@ -1376,8 +1375,7 @@ read_again:
 				   conf->mirrors[i].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw =
-			WRITE | do_flush_fua | do_sync | do_discard | do_same;
+		bio_set_op_attrs(mbio, op, do_flush_fua | do_sync | do_sec);
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
@@ -1771,7 +1769,7 @@ static void end_sync_write(struct bio *bio)
 static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
 			    int sectors, struct page *page, int rw)
 {
-	if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
+	if (sync_page_io(rdev, sector, sectors << 9, page, rw, 0, false))
 		/* success */
 		return 1;
 	if (rw == WRITE) {
@@ -1825,7 +1823,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				rdev = conf->mirrors[d].rdev;
 				if (sync_page_io(rdev, sect, s<<9,
 						 bio->bi_io_vec[idx].bv_page,
-						 READ, false)) {
+						 REQ_OP_READ, 0, false)) {
 					success = 1;
 					break;
 				}
@@ -2030,7 +2028,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 		      !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
 			continue;
 
-		wbio->bi_rw = WRITE;
+		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
 		wbio->bi_end_io = end_sync_write;
 		atomic_inc(&r1_bio->remaining);
 		md_sync_acct(conf->mirrors[i].rdev->bdev, bio_sectors(wbio));
@@ -2090,7 +2088,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			    is_badblock(rdev, sect, s,
 					&first_bad, &bad_sectors) == 0 &&
 			    sync_page_io(rdev, sect, s<<9,
-					 conf->tmppage, READ, false))
+					 conf->tmppage, REQ_OP_READ, 0, false))
 				success = 1;
 			else {
 				d++;
@@ -2201,7 +2199,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 			wbio = bio_clone_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
 		}
 
-		wbio->bi_rw = WRITE;
+		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
 		wbio->bi_iter.bi_sector = r1_bio->sector;
 		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
 
@@ -2344,7 +2342,7 @@ read_more:
 		bio->bi_iter.bi_sector = r1_bio->sector + rdev->data_offset;
 		bio->bi_bdev = rdev->bdev;
 		bio->bi_end_io = raid1_end_read_request;
-		bio->bi_rw = READ | do_sync;
+		bio_set_op_attrs(bio, REQ_OP_READ, do_sync);
 		bio->bi_private = r1_bio;
 		if (max_sectors < r1_bio->sectors) {
 			/* Drat - have to split this up more */
@@ -2572,7 +2570,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (i < conf->raid_disks)
 				still_degraded = 1;
 		} else if (!test_bit(In_sync, &rdev->flags)) {
-			bio->bi_rw = WRITE;
+			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 			bio->bi_end_io = end_sync_write;
 			write_targets ++;
 		} else {
@@ -2599,7 +2597,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 					if (disk < 0)
 						disk = i;
 				}
-				bio->bi_rw = READ;
+				bio_set_op_attrs(bio, REQ_OP_READ, 0);
 				bio->bi_end_io = end_sync_read;
 				read_targets++;
 			} else if (!test_bit(WriteErrorSeen, &rdev->flags) &&
@@ -2611,7 +2609,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 				 * if we are doing resync or repair. Otherwise, leave
 				 * this device alone for this sync request.
 				 */
-				bio->bi_rw = WRITE;
+				bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 				bio->bi_end_io = end_sync_write;
 				write_targets++;
 			}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0be6497..615045a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -865,7 +865,7 @@ static void flush_pending_writes(struct r10conf *conf)
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
 			bio->bi_next = NULL;
-			if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+			if (unlikely((bio_op(bio) ==  REQ_OP_DISCARD) &&
 			    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 				/* Just ignore it */
 				bio_endio(bio);
@@ -1041,7 +1041,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		bio->bi_next = NULL;
-		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		if (unlikely((bio_op(bio) ==  REQ_OP_DISCARD) &&
 		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 			/* Just ignore it */
 			bio_endio(bio);
@@ -1058,12 +1058,11 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 	struct r10bio *r10_bio;
 	struct bio *read_bio;
 	int i;
+	const int op = bio_op(bio);
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_fua = (bio->bi_rw & REQ_FUA);
-	const unsigned long do_discard = (bio->bi_rw
-					  & (REQ_DISCARD | REQ_SECURE));
-	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
+	const unsigned long do_sec = (bio->bi_rw & REQ_SECURE);
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
@@ -1156,7 +1155,7 @@ read_again:
 			choose_data_offset(r10_bio, rdev);
 		read_bio->bi_bdev = rdev->bdev;
 		read_bio->bi_end_io = raid10_end_read_request;
-		read_bio->bi_rw = READ | do_sync;
+		bio_set_op_attrs(read_bio, op, do_sync);
 		read_bio->bi_private = r10_bio;
 
 		if (max_sectors < r10_bio->sectors) {
@@ -1363,8 +1362,7 @@ retry_write:
 							      rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
-			mbio->bi_rw =
-				WRITE | do_sync | do_fua | do_discard | do_same;
+			bio_set_op_attrs(mbio, op, do_sync | do_fua | do_sec);
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -1406,8 +1404,7 @@ retry_write:
 						   r10_bio, rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
-			mbio->bi_rw =
-				WRITE | do_sync | do_fua | do_discard | do_same;
+			bio_set_op_attrs(mbio, op, do_sync | do_fua | do_sec);
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -1992,10 +1989,10 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 		tbio->bi_vcnt = vcnt;
 		tbio->bi_iter.bi_size = fbio->bi_iter.bi_size;
-		tbio->bi_rw = WRITE;
 		tbio->bi_private = r10_bio;
 		tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;
 		tbio->bi_end_io = end_sync_write;
+		bio_set_op_attrs(tbio, REQ_OP_WRITE, 0);
 
 		bio_copy_data(tbio, fbio);
 
@@ -2078,7 +2075,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 				  addr,
 				  s << 9,
 				  bio->bi_io_vec[idx].bv_page,
-				  READ, false);
+				  REQ_OP_READ, 0, false);
 		if (ok) {
 			rdev = conf->mirrors[dw].rdev;
 			addr = r10_bio->devs[1].addr + sect;
@@ -2086,7 +2083,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 					  addr,
 					  s << 9,
 					  bio->bi_io_vec[idx].bv_page,
-					  WRITE, false);
+					  REQ_OP_WRITE, 0, false);
 			if (!ok) {
 				set_bit(WriteErrorSeen, &rdev->flags);
 				if (!test_and_set_bit(WantReplacement,
@@ -2213,7 +2210,7 @@ static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
 	if (is_badblock(rdev, sector, sectors, &first_bad, &bad_sectors)
 	    && (rw == READ || test_bit(WriteErrorSeen, &rdev->flags)))
 		return -1;
-	if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
+	if (sync_page_io(rdev, sector, sectors << 9, page, rw, 0, false))
 		/* success */
 		return 1;
 	if (rw == WRITE) {
@@ -2299,7 +2296,8 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 						       r10_bio->devs[sl].addr +
 						       sect,
 						       s<<9,
-						       conf->tmppage, READ, false);
+						       conf->tmppage,
+						       REQ_OP_READ, 0, false);
 				rdev_dec_pending(rdev, mddev);
 				rcu_read_lock();
 				if (success)
@@ -2474,7 +2472,7 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 				   choose_data_offset(r10_bio, rdev) +
 				   (sector - r10_bio->sector));
 		wbio->bi_bdev = rdev->bdev;
-		wbio->bi_rw = WRITE;
+		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
 
 		if (submit_bio_wait(wbio) < 0)
 			/* Failure! */
@@ -2550,7 +2548,7 @@ read_more:
 	bio->bi_iter.bi_sector = r10_bio->devs[slot].addr
 		+ choose_data_offset(r10_bio, rdev);
 	bio->bi_bdev = rdev->bdev;
-	bio->bi_rw = READ | do_sync;
+	bio_set_op_attrs(bio, REQ_OP_READ, do_sync);
 	bio->bi_private = r10_bio;
 	bio->bi_end_io = raid10_end_read_request;
 	if (max_sectors < r10_bio->sectors) {
@@ -3040,7 +3038,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				biolist = bio;
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_read;
-				bio->bi_rw = READ;
+				bio_set_op_attrs(bio, REQ_OP_READ, 0);
 				from_addr = r10_bio->devs[j].addr;
 				bio->bi_iter.bi_sector = from_addr +
 					rdev->data_offset;
@@ -3066,7 +3064,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 					biolist = bio;
 					bio->bi_private = r10_bio;
 					bio->bi_end_io = end_sync_write;
-					bio->bi_rw = WRITE;
+					bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 					bio->bi_iter.bi_sector = to_addr
 						+ rdev->data_offset;
 					bio->bi_bdev = rdev->bdev;
@@ -3095,7 +3093,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				biolist = bio;
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_write;
-				bio->bi_rw = WRITE;
+				bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 				bio->bi_iter.bi_sector = to_addr +
 					rdev->data_offset;
 				bio->bi_bdev = rdev->bdev;
@@ -3215,7 +3213,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			biolist = bio;
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_read;
-			bio->bi_rw = READ;
+			bio_set_op_attrs(bio, REQ_OP_READ, 0);
 			bio->bi_iter.bi_sector = sector +
 				conf->mirrors[d].rdev->data_offset;
 			bio->bi_bdev = conf->mirrors[d].rdev->bdev;
@@ -3237,7 +3235,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			biolist = bio;
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_write;
-			bio->bi_rw = WRITE;
+			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 			bio->bi_iter.bi_sector = sector +
 				conf->mirrors[d].replacement->data_offset;
 			bio->bi_bdev = conf->mirrors[d].replacement->bdev;
@@ -4322,7 +4320,7 @@ read_more:
 			       + rdev->data_offset);
 	read_bio->bi_private = r10_bio;
 	read_bio->bi_end_io = end_sync_read;
-	read_bio->bi_rw = READ;
+	bio_set_op_attrs(read_bio, REQ_OP_READ, 0);
 	read_bio->bi_flags &= (~0UL << BIO_RESET_BITS);
 	read_bio->bi_error = 0;
 	read_bio->bi_vcnt = 0;
@@ -4356,7 +4354,7 @@ read_more:
 			rdev2->new_data_offset;
 		b->bi_private = r10_bio;
 		b->bi_end_io = end_reshape_write;
-		b->bi_rw = WRITE;
+		bio_set_op_attrs(b, REQ_OP_WRITE, 0);
 		b->bi_next = blist;
 		blist = b;
 	}
@@ -4524,7 +4522,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
 					       addr,
 					       s << 9,
 					       bvec[idx].bv_page,
-					       READ, false);
+					       REQ_OP_READ, 0, false);
 			if (success)
 				break;
 		failed:
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 0b01453..9265138 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -261,7 +261,7 @@ static struct bio *r5l_bio_alloc(struct r5l_log *log)
 {
 	struct bio *bio = bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES, log->bs);
 
-	bio->bi_rw = WRITE;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	bio->bi_bdev = log->rdev->bdev;
 	bio->bi_iter.bi_sector = log->rdev->data_offset + log->log_start;
 
@@ -686,7 +686,7 @@ void r5l_flush_stripe_to_raid(struct r5l_log *log)
 	bio_reset(&log->flush_bio);
 	log->flush_bio.bi_bdev = log->rdev->bdev;
 	log->flush_bio.bi_end_io = r5l_log_flush_endio;
-	log->flush_bio.bi_rw = WRITE_FLUSH;
+	bio_set_op_attrs(&log->flush_bio, REQ_OP_WRITE, WRITE_FLUSH);
 	submit_bio(&log->flush_bio);
 }
 
@@ -882,7 +882,8 @@ static int r5l_read_meta_block(struct r5l_log *log,
 	struct r5l_meta_block *mb;
 	u32 crc, stored_crc;
 
-	if (!sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page, READ, false))
+	if (!sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page, REQ_OP_READ, 0,
+			  false))
 		return -EIO;
 
 	mb = page_address(page);
@@ -927,7 +928,8 @@ static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
 					     &disk_index, sh);
 
 			sync_page_io(log->rdev, *log_offset, PAGE_SIZE,
-				     sh->dev[disk_index].page, READ, false);
+				     sh->dev[disk_index].page, REQ_OP_READ, 0,
+				     false);
 			sh->dev[disk_index].log_checksum =
 				le32_to_cpu(payload->checksum[0]);
 			set_bit(R5_Wantwrite, &sh->dev[disk_index].flags);
@@ -935,7 +937,8 @@ static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
 		} else {
 			disk_index = sh->pd_idx;
 			sync_page_io(log->rdev, *log_offset, PAGE_SIZE,
-				     sh->dev[disk_index].page, READ, false);
+				     sh->dev[disk_index].page, REQ_OP_READ, 0,
+				     false);
 			sh->dev[disk_index].log_checksum =
 				le32_to_cpu(payload->checksum[0]);
 			set_bit(R5_Wantwrite, &sh->dev[disk_index].flags);
@@ -945,7 +948,7 @@ static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
 				sync_page_io(log->rdev,
 					     r5l_ring_add(log, *log_offset, BLOCK_SECTORS),
 					     PAGE_SIZE, sh->dev[disk_index].page,
-					     READ, false);
+					     REQ_OP_READ, 0, false);
 				sh->dev[disk_index].log_checksum =
 					le32_to_cpu(payload->checksum[1]);
 				set_bit(R5_Wantwrite,
@@ -987,11 +990,13 @@ static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
 		rdev = rcu_dereference(conf->disks[disk_index].rdev);
 		if (rdev)
 			sync_page_io(rdev, stripe_sect, PAGE_SIZE,
-				     sh->dev[disk_index].page, WRITE, false);
+				     sh->dev[disk_index].page, REQ_OP_WRITE, 0,
+				     false);
 		rrdev = rcu_dereference(conf->disks[disk_index].replacement);
 		if (rrdev)
 			sync_page_io(rrdev, stripe_sect, PAGE_SIZE,
-				     sh->dev[disk_index].page, WRITE, false);
+				     sh->dev[disk_index].page, REQ_OP_WRITE, 0,
+				     false);
 	}
 	raid5_release_stripe(sh);
 	return 0;
@@ -1063,7 +1068,8 @@ static int r5l_log_write_empty_meta_block(struct r5l_log *log, sector_t pos,
 	crc = crc32c_le(log->uuid_checksum, mb, PAGE_SIZE);
 	mb->checksum = cpu_to_le32(crc);
 
-	if (!sync_page_io(log->rdev, pos, PAGE_SIZE, page, WRITE_FUA, false)) {
+	if (!sync_page_io(log->rdev, pos, PAGE_SIZE, page, REQ_OP_WRITE,
+			  WRITE_FUA, false)) {
 		__free_page(page);
 		return -EIO;
 	}
@@ -1138,7 +1144,7 @@ static int r5l_load_log(struct r5l_log *log)
 	if (!page)
 		return -ENOMEM;
 
-	if (!sync_page_io(rdev, cp, PAGE_SIZE, page, READ, false)) {
+	if (!sync_page_io(rdev, cp, PAGE_SIZE, page, REQ_OP_READ, 0, false)) {
 		ret = -EIO;
 		goto ioerr;
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8959e6d..e35c163 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -806,7 +806,8 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 	dd_idx = 0;
 	while (dd_idx == sh->pd_idx || dd_idx == sh->qd_idx)
 		dd_idx++;
-	if (head->dev[dd_idx].towrite->bi_rw != sh->dev[dd_idx].towrite->bi_rw)
+	if (head->dev[dd_idx].towrite->bi_rw != sh->dev[dd_idx].towrite->bi_rw ||
+	    bio_op(head->dev[dd_idx].towrite) != bio_op(sh->dev[dd_idx].towrite))
 		goto unlock_out;
 
 	if (head->batch_head) {
@@ -891,29 +892,28 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 	if (r5l_write_stripe(conf->log, sh) == 0)
 		return;
 	for (i = disks; i--; ) {
-		int rw;
+		int op, op_flags = 0;
 		int replace_only = 0;
 		struct bio *bi, *rbi;
 		struct md_rdev *rdev, *rrdev = NULL;
 
 		sh = head_sh;
 		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags)) {
+			op = REQ_OP_WRITE;
 			if (test_and_clear_bit(R5_WantFUA, &sh->dev[i].flags))
-				rw = WRITE_FUA;
-			else
-				rw = WRITE;
+				op_flags = WRITE_FUA;
 			if (test_bit(R5_Discard, &sh->dev[i].flags))
-				rw |= REQ_DISCARD;
+				op = REQ_OP_DISCARD;
 		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
-			rw = READ;
+			op = REQ_OP_READ;
 		else if (test_and_clear_bit(R5_WantReplace,
 					    &sh->dev[i].flags)) {
-			rw = WRITE;
+			op = REQ_OP_WRITE;
 			replace_only = 1;
 		} else
 			continue;
 		if (test_and_clear_bit(R5_SyncIO, &sh->dev[i].flags))
-			rw |= REQ_SYNC;
+			op_flags |= REQ_SYNC;
 
 again:
 		bi = &sh->dev[i].req;
@@ -927,7 +927,7 @@ again:
 			rdev = rrdev;
 			rrdev = NULL;
 		}
-		if (rw & WRITE) {
+		if (op_is_write(op)) {
 			if (replace_only)
 				rdev = NULL;
 			if (rdev == rrdev)
@@ -953,7 +953,7 @@ again:
 		 * need to check for writes.  We never accept write errors
 		 * on the replacement, so we don't to check rrdev.
 		 */
-		while ((rw & WRITE) && rdev &&
+		while (op_is_write(op) && rdev &&
 		       test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
 			int bad_sectors;
@@ -995,8 +995,8 @@ again:
 
 			bio_reset(bi);
 			bi->bi_bdev = rdev->bdev;
-			bi->bi_rw = rw;
-			bi->bi_end_io = (rw & WRITE)
+			bio_set_op_attrs(bi, op, op_flags);
+			bi->bi_end_io = op_is_write(op)
 				? raid5_end_write_request
 				: raid5_end_read_request;
 			bi->bi_private = sh;
@@ -1027,7 +1027,7 @@ again:
 			 * If this is discard request, set bi_vcnt 0. We don't
 			 * want to confuse SCSI because SCSI will replace payload
 			 */
-			if (rw & REQ_DISCARD)
+			if (op == REQ_OP_DISCARD)
 				bi->bi_vcnt = 0;
 			if (rrdev)
 				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
@@ -1047,8 +1047,8 @@ again:
 
 			bio_reset(rbi);
 			rbi->bi_bdev = rrdev->bdev;
-			rbi->bi_rw = rw;
-			BUG_ON(!(rw & WRITE));
+			bio_set_op_attrs(rbi, op, op_flags);
+			BUG_ON(!op_is_write(op));
 			rbi->bi_end_io = raid5_end_write_request;
 			rbi->bi_private = sh;
 
@@ -1076,7 +1076,7 @@ again:
 			 * If this is discard request, set bi_vcnt 0. We don't
 			 * want to confuse SCSI because SCSI will replace payload
 			 */
-			if (rw & REQ_DISCARD)
+			if (op == REQ_OP_DISCARD)
 				rbi->bi_vcnt = 0;
 			if (conf->mddev->gendisk)
 				trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
@@ -1085,7 +1085,7 @@ again:
 			generic_make_request(rbi);
 		}
 		if (!rdev && !rrdev) {
-			if (rw & WRITE)
+			if (op_is_write(op))
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
@@ -1623,7 +1623,7 @@ again:
 					set_bit(R5_WantFUA, &dev->flags);
 				if (wbi->bi_rw & REQ_SYNC)
 					set_bit(R5_SyncIO, &dev->flags);
-				if (wbi->bi_rw & REQ_DISCARD)
+				if (bio_op(wbi) == REQ_OP_DISCARD)
 					set_bit(R5_Discard, &dev->flags);
 				else {
 					tx = async_copy_data(1, wbi, &dev->page,
@@ -5176,7 +5176,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 			return;
 	}
 
-	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
+	if (unlikely(bio_op(bi) == REQ_OP_DISCARD)) {
 		make_discard_request(mddev, bi);
 		return;
 	}
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
