Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 597E929E09
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 14:22:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 339AB8F804B
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:22:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7F0kVTeRCAcUn0Aa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:22:19 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 16/35] nilfs: set bi_op to REQ_OP
Date: Mon, 11 Jan 2016 14:21:14 -0600
Message-Id: <1452543693-4440-17-git-send-email-mchristi@redhat.com>
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

This patch has nilfs set the bio bi_op to a REQ_OP, and
rq_flag_bits to bi_rw.

This patch is compile tested only.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/nilfs2/segbuf.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 7666f1d..7b13e14 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -350,7 +350,8 @@ static void nilfs_end_bio_write(struct bio *bio)
 }
 
 static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
-				   struct nilfs_write_info *wi, int mode)
+				   struct nilfs_write_info *wi, int mode,
+				   int mode_flags)
 {
 	struct bio *bio = wi->bio;
 	int err;
@@ -368,7 +369,8 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 
 	bio->bi_end_io = nilfs_end_bio_write;
 	bio->bi_private = segbuf;
-	bio->bi_rw = mode;
+	bio->bi_op = mode;
+	bio->bi_rw = mode_flags;
 	submit_bio(bio);
 	segbuf->sb_nbio++;
 
@@ -442,7 +444,7 @@ static int nilfs_segbuf_submit_bh(struct nilfs_segment_buffer *segbuf,
 		return 0;
 	}
 	/* bio is FULL */
-	err = nilfs_segbuf_submit_bio(segbuf, wi, mode);
+	err = nilfs_segbuf_submit_bio(segbuf, wi, mode, 0);
 	/* never submit current bh */
 	if (likely(!err))
 		goto repeat;
@@ -466,19 +468,19 @@ static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 {
 	struct nilfs_write_info wi;
 	struct buffer_head *bh;
-	int res = 0, rw = WRITE;
+	int res = 0;
 
 	wi.nilfs = nilfs;
 	nilfs_segbuf_prepare_write(segbuf, &wi);
 
 	list_for_each_entry(bh, &segbuf->sb_segsum_buffers, b_assoc_buffers) {
-		res = nilfs_segbuf_submit_bh(segbuf, &wi, bh, rw);
+		res = nilfs_segbuf_submit_bh(segbuf, &wi, bh, REQ_OP_WRITE);
 		if (unlikely(res))
 			goto failed_bio;
 	}
 
 	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
-		res = nilfs_segbuf_submit_bh(segbuf, &wi, bh, rw);
+		res = nilfs_segbuf_submit_bh(segbuf, &wi, bh, REQ_OP_WRITE);
 		if (unlikely(res))
 			goto failed_bio;
 	}
@@ -488,8 +490,8 @@ static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 		 * Last BIO is always sent through the following
 		 * submission.
 		 */
-		rw |= REQ_SYNC;
-		res = nilfs_segbuf_submit_bio(segbuf, &wi, rw);
+		res = nilfs_segbuf_submit_bio(segbuf, &wi, REQ_OP_WRITE,
+					      REQ_SYNC);
 	}
 
  failed_bio:
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
