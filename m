Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 85AAC29E0A
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 14:22:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4CBA1304059
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:22:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hImtH46H8LHOIt2n (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:22:32 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 22/35] drbd: set bi_op to REQ_OP
Date: Mon, 11 Jan 2016 14:21:20 -0600
Message-Id: <1452543693-4440-23-git-send-email-mchristi@redhat.com>
In-Reply-To: <1452543693-4440-1-git-send-email-mchristi@redhat.com>
References: <1452543693-4440-1-git-send-email-mchristi@redhat.com>
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

This patch has drbd set the bio bi_op to a REQ_OP, and rq_flag_bits
to bi_rw.

Lars and Philip, I might have split this patch up a little weird.
Thisi patch handles setting up the bio, and then patch 30
(0030-block-fs-drivers-do-not-test-bi_rw-for-REQ_OPs.patch) handles
where were check/read bio->bi_rw.

This patch is compile tested only.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/block/drbd/drbd_actlog.c   | 29 ++++++++++++++++-------------
 drivers/block/drbd/drbd_bitmap.c   |  6 +++---
 drivers/block/drbd/drbd_int.h      |  4 ++--
 drivers/block/drbd/drbd_main.c     |  5 +++--
 drivers/block/drbd/drbd_receiver.c | 37 +++++++++++++++++++++++++------------
 drivers/block/drbd/drbd_worker.c   |  3 ++-
 6 files changed, 51 insertions(+), 33 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 6069e15..2fa8534 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -137,19 +137,19 @@ void wait_until_done_or_force_detached(struct drbd_device *device, struct drbd_b
 
 static int _drbd_md_sync_page_io(struct drbd_device *device,
 				 struct drbd_backing_dev *bdev,
-				 sector_t sector, int rw)
+				 sector_t sector, int op)
 {
 	struct bio *bio;
 	/* we do all our meta data IO in aligned 4k blocks. */
 	const int size = 4096;
-	int err;
+	int err, op_flags = 0;
 
 	device->md_io.done = 0;
 	device->md_io.error = -ENODEV;
 
-	if ((rw & WRITE) && !test_bit(MD_NO_FUA, &device->flags))
-		rw |= REQ_FUA | REQ_FLUSH;
-	rw |= REQ_SYNC | REQ_NOIDLE;
+	if ((op == REQ_OP_WRITE) && !test_bit(MD_NO_FUA, &device->flags))
+		op_flags |= REQ_FUA | REQ_FLUSH;
+	op_flags |= REQ_SYNC | REQ_NOIDLE;
 
 	bio = bio_alloc_drbd(GFP_NOIO);
 	bio->bi_bdev = bdev->md_bdev;
@@ -159,9 +159,10 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 		goto out;
 	bio->bi_private = device;
 	bio->bi_end_io = drbd_md_endio;
-	bio->bi_rw = rw;
+	bio->bi_op = op;
+	bio->bi_rw = op_flags;
 
-	if (!(rw & WRITE) && device->state.disk == D_DISKLESS && device->ldev == NULL)
+	if (op != REQ_OP_WRITE && device->state.disk == D_DISKLESS && device->ldev == NULL)
 		/* special case, drbd_md_read() during drbd_adm_attach(): no get_ldev */
 		;
 	else if (!get_ldev_if_state(device, D_ATTACHING)) {
@@ -174,7 +175,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	bio_get(bio); /* one bio_put() is in the completion handler */
 	atomic_inc(&device->md_io.in_use); /* drbd_md_put_buffer() is in the completion handler */
 	device->md_io.submit_jif = jiffies;
-	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
+	if (drbd_insert_fault(device, (op == REQ_OP_WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
 		bio_io_error(bio);
 	else
 		submit_bio(bio);
@@ -188,7 +189,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 }
 
 int drbd_md_sync_page_io(struct drbd_device *device, struct drbd_backing_dev *bdev,
-			 sector_t sector, int rw)
+			 sector_t sector, int op)
 {
 	int err;
 	D_ASSERT(device, atomic_read(&device->md_io.in_use) == 1);
@@ -197,19 +198,21 @@ int drbd_md_sync_page_io(struct drbd_device *device, struct drbd_backing_dev *bd
 
 	dynamic_drbd_dbg(device, "meta_data io: %s [%d]:%s(,%llus,%s) %pS\n",
 	     current->comm, current->pid, __func__,
-	     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ",
+	     (unsigned long long)sector, (op == REQ_OP_WRITE) ? "WRITE" : "READ",
 	     (void*)_RET_IP_ );
 
 	if (sector < drbd_md_first_sector(bdev) ||
 	    sector + 7 > drbd_md_last_sector(bdev))
 		drbd_alert(device, "%s [%d]:%s(,%llus,%s) out of range md access!\n",
 		     current->comm, current->pid, __func__,
-		     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
+		     (unsigned long long)sector,
+		     (op == REQ_OP_WRITE) ? "WRITE" : "READ");
 
-	err = _drbd_md_sync_page_io(device, bdev, sector, rw);
+	err = _drbd_md_sync_page_io(device, bdev, sector, op);
 	if (err) {
 		drbd_err(device, "drbd_md_sync_page_io(,%llus,%s) failed with error %d\n",
-		    (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ", err);
+		    (unsigned long long)sector,
+		    (op == REQ_OP_WRITE) ? "WRITE" : "READ", err);
 	}
 	return err;
 }
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index e8959fe..126bf4a 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -980,7 +980,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 	struct drbd_bitmap *b = device->bitmap;
 	struct page *page;
 	unsigned int len;
-	unsigned int rw = (ctx->flags & BM_AIO_READ) ? READ : WRITE;
+	unsigned int op = (ctx->flags & BM_AIO_READ) ? REQ_OP_READ : REQ_OP_WRITE;
 
 	sector_t on_disk_sector =
 		device->ldev->md.md_offset + device->ldev->md.bm_offset;
@@ -1011,9 +1011,9 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 	bio_add_page(bio, page, len, 0);
 	bio->bi_private = ctx;
 	bio->bi_end_io = drbd_bm_endio;
-	bio->bi_rw = rw;
+	bio->bi_op = op;
 
-	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD)) {
+	if (drbd_insert_fault(device, (op == REQ_OP_WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD)) {
 		bio_io_error(bio);
 	} else {
 		submit_bio(bio);
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 34bc84e..5204079 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1507,7 +1507,7 @@ extern int drbd_resync_finished(struct drbd_device *device);
 extern void *drbd_md_get_buffer(struct drbd_device *device, const char *intent);
 extern void drbd_md_put_buffer(struct drbd_device *device);
 extern int drbd_md_sync_page_io(struct drbd_device *device,
-		struct drbd_backing_dev *bdev, sector_t sector, int rw);
+		struct drbd_backing_dev *bdev, sector_t sector, int op);
 extern void drbd_ov_out_of_sync_found(struct drbd_device *, sector_t, int);
 extern void wait_until_done_or_force_detached(struct drbd_device *device,
 		struct drbd_backing_dev *bdev, unsigned int *done);
@@ -1557,7 +1557,7 @@ extern bool drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector
 		bool throttle_if_app_is_waiting);
 extern int drbd_submit_peer_request(struct drbd_device *,
 				    struct drbd_peer_request *, const unsigned,
-				    const int);
+				    const unsigned, const int);
 extern int drbd_free_peer_reqs(struct drbd_device *, struct list_head *);
 extern struct drbd_peer_request *drbd_alloc_peer_req(struct drbd_peer_device *, u64,
 						     sector_t, unsigned int,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 5b43dfb..f6626e5 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3061,7 +3061,7 @@ void drbd_md_write(struct drbd_device *device, void *b)
 	D_ASSERT(device, drbd_md_ss(device->ldev) == device->ldev->md.md_offset);
 	sector = device->ldev->md.md_offset;
 
-	if (drbd_md_sync_page_io(device, device->ldev, sector, WRITE)) {
+	if (drbd_md_sync_page_io(device, device->ldev, sector, REQ_OP_WRITE)) {
 		/* this was a try anyways ... */
 		drbd_err(device, "meta data update failed!\n");
 		drbd_chk_io_error(device, 1, DRBD_META_IO_ERROR);
@@ -3263,7 +3263,8 @@ int drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev)
 	 * Affects the paranoia out-of-range access check in drbd_md_sync_page_io(). */
 	bdev->md.md_size_sect = 8;
 
-	if (drbd_md_sync_page_io(device, bdev, bdev->md.md_offset, READ)) {
+	if (drbd_md_sync_page_io(device, bdev, bdev->md.md_offset,
+				 REQ_OP_READ)) {
 		/* NOTE: can't do normal error processing here as this is
 		   called BEFORE disk is attached */
 		drbd_err(device, "Error while reading metadata.\n");
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1957fe8..880de0d 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1398,7 +1398,8 @@ void drbd_bump_write_ordering(struct drbd_resource *resource, struct drbd_backin
 /* TODO allocate from our own bio_set. */
 int drbd_submit_peer_request(struct drbd_device *device,
 			     struct drbd_peer_request *peer_req,
-			     const unsigned rw, const int fault_type)
+			     const unsigned op, const unsigned op_flags,
+			     const int fault_type)
 {
 	struct bio *bios = NULL;
 	struct bio *bio;
@@ -1450,7 +1451,8 @@ next_bio:
 	/* > peer_req->i.sector, unless this is the first bio */
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = device->ldev->backing_bdev;
-	bio->bi_rw = rw;
+	bio->bi_op = op;
+	bio->bi_rw = op_flags;
 	bio->bi_private = peer_req;
 	bio->bi_end_io = drbd_peer_request_endio;
 
@@ -1458,7 +1460,7 @@ next_bio:
 	bios = bio;
 	++n_bios;
 
-	if (rw & REQ_DISCARD) {
+	if (op == REQ_OP_DISCARD) {
 		bio->bi_iter.bi_size = data_size;
 		goto submit;
 	}
@@ -1830,7 +1832,8 @@ static int recv_resync_read(struct drbd_peer_device *peer_device, sector_t secto
 	spin_unlock_irq(&device->resource->req_lock);
 
 	atomic_add(pi->size >> 9, &device->rs_sect_ev);
-	if (drbd_submit_peer_request(device, peer_req, WRITE, DRBD_FAULT_RS_WR) == 0)
+	if (drbd_submit_peer_request(device, peer_req, REQ_OP_WRITE, 0,
+				     DRBD_FAULT_RS_WR) == 0)
 		return 0;
 
 	/* don't care for the reason here */
@@ -2152,12 +2155,19 @@ static int wait_for_and_update_peer_seq(struct drbd_peer_device *peer_device, co
 /* see also bio_flags_to_wire()
  * DRBD_REQ_*, because we need to semantically map the flags to data packet
  * flags and back. We may replicate to other kernel versions. */
-static unsigned long wire_flags_to_bio(u32 dpf)
+static unsigned long wire_flags_to_bio_flags(u32 dpf)
 {
 	return  (dpf & DP_RW_SYNC ? REQ_SYNC : 0) |
 		(dpf & DP_FUA ? REQ_FUA : 0) |
-		(dpf & DP_FLUSH ? REQ_FLUSH : 0) |
-		(dpf & DP_DISCARD ? REQ_DISCARD : 0);
+		(dpf & DP_FLUSH ? REQ_FLUSH : 0);
+}
+
+static unsigned long wire_flags_to_bio_op(u32 dpf)
+{
+	if (dpf & DP_DISCARD)
+		return REQ_OP_DISCARD;
+	else
+		return REQ_OP_WRITE;
 }
 
 static void fail_postponed_requests(struct drbd_device *device, sector_t sector,
@@ -2303,7 +2313,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	struct drbd_peer_request *peer_req;
 	struct p_data *p = pi->data;
 	u32 peer_seq = be32_to_cpu(p->seq_num);
-	int rw = WRITE;
+	int op, op_flags;
 	u32 dp_flags;
 	int err, tp;
 
@@ -2342,14 +2352,15 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	peer_req->flags |= EE_APPLICATION;
 
 	dp_flags = be32_to_cpu(p->dp_flags);
-	rw |= wire_flags_to_bio(dp_flags);
+	op = wire_flags_to_bio_op(dp_flags);
+	op_flags = wire_flags_to_bio_flags(dp_flags);
 	if (pi->cmd == P_TRIM) {
 		struct request_queue *q = bdev_get_queue(device->ldev->backing_bdev);
 		peer_req->flags |= EE_IS_TRIM;
 		if (!blk_queue_discard(q))
 			peer_req->flags |= EE_IS_TRIM_USE_ZEROOUT;
 		D_ASSERT(peer_device, peer_req->i.size > 0);
-		D_ASSERT(peer_device, rw & REQ_DISCARD);
+		D_ASSERT(peer_device, op == REQ_OP_DISCARD);
 		D_ASSERT(peer_device, peer_req->pages == NULL);
 	} else if (peer_req->pages == NULL) {
 		D_ASSERT(device, peer_req->i.size == 0);
@@ -2433,7 +2444,8 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 		peer_req->flags |= EE_CALL_AL_COMPLETE_IO;
 	}
 
-	err = drbd_submit_peer_request(device, peer_req, rw, DRBD_FAULT_DT_WR);
+	err = drbd_submit_peer_request(device, peer_req, op, op_flags,
+				       DRBD_FAULT_DT_WR);
 	if (!err)
 		return 0;
 
@@ -2723,7 +2735,8 @@ submit_for_resync:
 submit:
 	update_receiver_timing_details(connection, drbd_submit_peer_request);
 	inc_unacked(device);
-	if (drbd_submit_peer_request(device, peer_req, READ, fault_type) == 0)
+	if (drbd_submit_peer_request(device, peer_req, REQ_OP_READ, 0,
+				     fault_type) == 0)
 		return 0;
 
 	/* don't care for the reason here */
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index eff716c..f92f533 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -392,7 +392,8 @@ static int read_for_csum(struct drbd_peer_device *peer_device, sector_t sector,
 	spin_unlock_irq(&device->resource->req_lock);
 
 	atomic_add(size >> 9, &device->rs_sect_ev);
-	if (drbd_submit_peer_request(device, peer_req, READ, DRBD_FAULT_RS_RD) == 0)
+	if (drbd_submit_peer_request(device, peer_req, REQ_OP_READ, 0,
+				     DRBD_FAULT_RS_RD) == 0)
 		return 0;
 
 	/* If it failed because of ENOMEM, retry should help.  If it failed
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
