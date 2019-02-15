Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394341AbfBOLQT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Feb 2019 06:16:19 -0500
From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V15 11/18] block: loop: pass multi-page bvec to iov_iter
Date: Fri, 15 Feb 2019 19:13:17 +0800
Message-Id: <20190215111324.30129-12-ming.lei@redhat.com>
In-Reply-To: <20190215111324.30129-1-ming.lei@redhat.com>
References: <20190215111324.30129-1-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Ming Lei <ming.lei@redhat.com>

iov_iter is implemented on bvec itererator helpers, so it is safe to pass
multi-page bvec to it, and this way is much more efficient than passing one
page in each bvec.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/loop.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index cf5538942834..8ef583197414 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -511,21 +511,22 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		     loff_t pos, bool rw)
 {
 	struct iov_iter iter;
+	struct req_iterator rq_iter;
 	struct bio_vec *bvec;
 	struct request *rq = blk_mq_rq_from_pdu(cmd);
 	struct bio *bio = rq->bio;
 	struct file *file = lo->lo_backing_file;
+	struct bio_vec tmp;
 	unsigned int offset;
-	int segments = 0;
+	int nr_bvec = 0;
 	int ret;
 
+	rq_for_each_bvec(tmp, rq, rq_iter)
+		nr_bvec++;
+
 	if (rq->bio != rq->biotail) {
-		struct req_iterator iter;
-		struct bio_vec tmp;
 
-		__rq_for_each_bio(bio, rq)
-			segments += bio_segments(bio);
-		bvec = kmalloc_array(segments, sizeof(struct bio_vec),
+		bvec = kmalloc_array(nr_bvec, sizeof(struct bio_vec),
 				     GFP_NOIO);
 		if (!bvec)
 			return -EIO;
@@ -534,10 +535,10 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		/*
 		 * The bios of the request may be started from the middle of
 		 * the 'bvec' because of bio splitting, so we can't directly
-		 * copy bio->bi_iov_vec to new bvec. The rq_for_each_segment
+		 * copy bio->bi_iov_vec to new bvec. The rq_for_each_bvec
 		 * API will take care of all details for us.
 		 */
-		rq_for_each_segment(tmp, rq, iter) {
+		rq_for_each_bvec(tmp, rq, rq_iter) {
 			*bvec = tmp;
 			bvec++;
 		}
@@ -551,11 +552,10 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 		 */
 		offset = bio->bi_iter.bi_bvec_done;
 		bvec = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
-		segments = bio_segments(bio);
 	}
 	atomic_set(&cmd->ref, 2);
 
-	iov_iter_bvec(&iter, rw, bvec, segments, blk_rq_bytes(rq));
+	iov_iter_bvec(&iter, rw, bvec, nr_bvec, blk_rq_bytes(rq));
 	iter.iov_offset = offset;
 
 	cmd->iocb.ki_pos = pos;
-- 
2.9.5
