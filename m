Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EC8E529E20
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 14:22:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 70BB3AC005
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:22:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vKPCRkWztK49b4WB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:22:10 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 12/35] gfs2: set bi_op to REQ_OP
Date: Mon, 11 Jan 2016 14:21:10 -0600
Message-Id: <1452543693-4440-13-git-send-email-mchristi@redhat.com>
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

This patch has gfs2 set the bio bi_op to a REQ_OP, and
rq_flag_bits to bi_rw.

This patch is compile tested only.

v2:

Bob, I did not add your signed off, because there was
the gfs2_submit_bhs changes since last time you reviewed
it.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/gfs2/log.c        |  8 ++++----
 fs/gfs2/lops.c       | 12 +++++++-----
 fs/gfs2/lops.h       |  2 +-
 fs/gfs2/meta_io.c    |  8 +++++---
 fs/gfs2/ops_fstype.c |  1 +
 5 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 0ff028c..e58ccef0 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -657,7 +657,7 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags)
 	struct gfs2_log_header *lh;
 	unsigned int tail;
 	u32 hash;
-	int rw = WRITE_FLUSH_FUA | REQ_META;
+	int op_flags = WRITE_FLUSH_FUA | REQ_META;
 	struct page *page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
 	enum gfs2_freeze_state state = atomic_read(&sdp->sd_freeze_state);
 	lh = page_address(page);
@@ -682,12 +682,12 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags)
 	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags)) {
 		gfs2_ordered_wait(sdp);
 		log_flush_wait(sdp);
-		rw = WRITE_SYNC | REQ_META | REQ_PRIO;
+		op_flags = WRITE_SYNC | REQ_META | REQ_PRIO;
 	}
 
 	sdp->sd_log_idle = (tail == sdp->sd_log_flush_head);
 	gfs2_log_write_page(sdp, page);
-	gfs2_log_flush_bio(sdp, rw);
+	gfs2_log_flush_bio(sdp, REQ_OP_WRITE, op_flags);
 	log_flush_wait(sdp);
 
 	if (sdp->sd_log_tail != tail)
@@ -738,7 +738,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl,
 
 	gfs2_ordered_write(sdp);
 	lops_before_commit(sdp, tr);
-	gfs2_log_flush_bio(sdp, WRITE);
+	gfs2_log_flush_bio(sdp, REQ_OP_WRITE, 0);
 
 	if (sdp->sd_log_head != sdp->sd_log_flush_head) {
 		log_flush_wait(sdp);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index ce28242..c1099b4 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -230,17 +230,19 @@ static void gfs2_end_log_write(struct bio *bio)
 /**
  * gfs2_log_flush_bio - Submit any pending log bio
  * @sdp: The superblock
- * @rw: The rw flags
+ * @op: REQ_OP
+ * @op_flags: rq_flag_bits
  *
  * Submit any pending part-built or full bio to the block device. If
  * there is no pending bio, then this is a no-op.
  */
 
-void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int rw)
+void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int op, int op_flags)
 {
 	if (sdp->sd_log_bio) {
 		atomic_inc(&sdp->sd_log_in_flight);
-		sdp->sd_log_bio->bi_rw = rw;
+		sdp->sd_log_bio->bi_op = op;
+		sdp->sd_log_bio->bi_rw = op_flags;
 		submit_bio(sdp->sd_log_bio);
 		sdp->sd_log_bio = NULL;
 	}
@@ -300,7 +302,7 @@ static struct bio *gfs2_log_get_bio(struct gfs2_sbd *sdp, u64 blkno)
 		nblk >>= sdp->sd_fsb2bb_shift;
 		if (blkno == nblk)
 			return bio;
-		gfs2_log_flush_bio(sdp, WRITE);
+		gfs2_log_flush_bio(sdp, REQ_OP_WRITE, 0);
 	}
 
 	return gfs2_log_alloc_bio(sdp, blkno);
@@ -329,7 +331,7 @@ static void gfs2_log_write(struct gfs2_sbd *sdp, struct page *page,
 	bio = gfs2_log_get_bio(sdp, blkno);
 	ret = bio_add_page(bio, page, size, offset);
 	if (ret == 0) {
-		gfs2_log_flush_bio(sdp, WRITE);
+		gfs2_log_flush_bio(sdp, REQ_OP_WRITE, 0);
 		bio = gfs2_log_alloc_bio(sdp, blkno);
 		ret = bio_add_page(bio, page, size, offset);
 		WARN_ON(ret == 0);
diff --git a/fs/gfs2/lops.h b/fs/gfs2/lops.h
index a65a7ba..e529f53 100644
--- a/fs/gfs2/lops.h
+++ b/fs/gfs2/lops.h
@@ -27,7 +27,7 @@ extern const struct gfs2_log_operations gfs2_databuf_lops;
 
 extern const struct gfs2_log_operations *gfs2_log_ops[];
 extern void gfs2_log_write_page(struct gfs2_sbd *sdp, struct page *page);
-extern void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int rw);
+extern void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int op, int op_flags);
 extern void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh);
 
 static inline unsigned int buf_limit(struct gfs2_sbd *sdp)
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 96c8140..f790f38 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -213,7 +213,8 @@ static void gfs2_meta_read_endio(struct bio *bio)
  * Submit several consecutive buffer head I/O requests as a single bio I/O
  * request.  (See submit_bh_wbc.)
  */
-static void gfs2_submit_bhs(int rw, struct buffer_head *bhs[], int num)
+static void gfs2_submit_bhs(int op, int op_flags, struct buffer_head *bhs[],
+			    int num)
 {
 	struct buffer_head *bh = bhs[0];
 	struct bio *bio;
@@ -230,7 +231,8 @@ static void gfs2_submit_bhs(int rw, struct buffer_head *bhs[], int num)
 		bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
 	}
 	bio->bi_end_io = gfs2_meta_read_endio;
-	bio->bi_rw = rw;
+	bio->bi_op = op;
+	bio->bi_rw = op_flags;
 	submit_bio(bio);
 }
 
@@ -281,7 +283,7 @@ int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno, int flags,
 		}
 	}
 
-	gfs2_submit_bhs(READ_SYNC | REQ_META | REQ_PRIO, bhs, num);
+	gfs2_submit_bhs(REQ_OP_READ, READ_SYNC | REQ_META | REQ_PRIO, bhs, num);
 	if (!(flags & DIO_WAIT))
 		return 0;
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 4872a61..f3e1e0e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -246,6 +246,7 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
 
 	bio->bi_end_io = end_bio_io_page;
 	bio->bi_private = page;
+	bio->bi_op = REQ_OP_READ;
 	bio->bi_rw = READ_SYNC | REQ_META;
 	submit_bio(bio);
 	wait_on_page_locked(page);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
