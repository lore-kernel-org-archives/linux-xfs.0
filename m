Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 57C657CA0
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:33:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0DDC4304043
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:33:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id afOHA0wUjKhHHiZ3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:33:18 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 20/45] nilfs: use bio op accessors
Date: Sun,  5 Jun 2016 14:32:00 -0500
Message-Id: <1465155145-10812-21-git-send-email-mchristi@redhat.com>
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

Separate the op from the rq_flag_bits and have nilfs
set/get the bio using bio_set_op_attrs/bio_op.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/segbuf.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 0f62909..a962d7d 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -346,7 +346,8 @@ static void nilfs_end_bio_write(struct bio *bio)
 }
 
 static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
-				   struct nilfs_write_info *wi, int mode)
+				   struct nilfs_write_info *wi, int mode,
+				   int mode_flags)
 {
 	struct bio *bio = wi->bio;
 	int err;
@@ -364,7 +365,7 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 
 	bio->bi_end_io = nilfs_end_bio_write;
 	bio->bi_private = segbuf;
-	bio->bi_rw = mode;
+	bio_set_op_attrs(bio, mode, mode_flags);
 	submit_bio(bio);
 	segbuf->sb_nbio++;
 
@@ -438,7 +439,7 @@ static int nilfs_segbuf_submit_bh(struct nilfs_segment_buffer *segbuf,
 		return 0;
 	}
 	/* bio is FULL */
-	err = nilfs_segbuf_submit_bio(segbuf, wi, mode);
+	err = nilfs_segbuf_submit_bio(segbuf, wi, mode, 0);
 	/* never submit current bh */
 	if (likely(!err))
 		goto repeat;
@@ -462,19 +463,19 @@ static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
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
@@ -484,8 +485,8 @@ static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
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
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
