Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 737A57CD3
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 14:17:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DAE9BAC002
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:17:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BWKblN99oPiZavlA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:17:19 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 25/42] target: set bi_op to REQ_OP
Date: Fri, 15 Apr 2016 14:16:00 -0500
Message-Id: <1460747777-8479-26-git-send-email-mchristi@redhat.com>
In-Reply-To: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
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

This patch has the target modules use bio->bi_op for REQ_OPs and
rq_flag_bits to bio->bi_rw.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c | 30 +++++++++++++++---------------
 drivers/target/target_core_pscsi.c  |  2 +-
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c25109c..5e60dbc 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -312,7 +312,8 @@ static void iblock_bio_done(struct bio *bio)
 }
 
 static struct bio *
-iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num, int rw)
+iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num, int op,
+	       int op_flags)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(cmd->se_dev);
 	struct bio *bio;
@@ -334,7 +335,8 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num, int rw)
 	bio->bi_private = cmd;
 	bio->bi_end_io = &iblock_bio_done;
 	bio->bi_iter.bi_sector = lba;
-	bio->bi_rw = rw;
+	bio->bi_op = op;
+	bio->bi_rw = op_flags;
 
 	return bio;
 }
@@ -480,7 +482,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		goto fail;
 	cmd->priv = ibr;
 
-	bio = iblock_get_bio(cmd, block_lba, 1, WRITE);
+	bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE, 0);
 	if (!bio)
 		goto fail_free_ibr;
 
@@ -493,7 +495,8 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
 				!= sg->length) {
 
-			bio = iblock_get_bio(cmd, block_lba, 1, WRITE);
+			bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE,
+					     0);
 			if (!bio)
 				goto fail_put_bios;
 
@@ -679,8 +682,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	struct scatterlist *sg;
 	u32 sg_num = sgl_nents;
 	unsigned bio_cnt;
-	int rw = 0;
-	int i;
+	int i, op, op_flags = 0;
 
 	if (data_direction == DMA_TO_DEVICE) {
 		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -689,18 +691,15 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		 * Force writethrough using WRITE_FUA if a volatile write cache
 		 * is not enabled, or if initiator set the Force Unit Access bit.
 		 */
+		op = REQ_OP_WRITE;
 		if (test_bit(QUEUE_FLAG_FUA, &q->queue_flags)) {
 			if (cmd->se_cmd_flags & SCF_FUA)
-				rw = WRITE_FUA;
+				op_flags = WRITE_FUA;
 			else if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
-				rw = WRITE_FUA;
-			else
-				rw = WRITE;
-		} else {
-			rw = WRITE;
+				op_flags = WRITE_FUA;
 		}
 	} else {
-		rw = READ;
+		op = REQ_OP_READ;
 	}
 
 	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
@@ -714,7 +713,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		return 0;
 	}
 
-	bio = iblock_get_bio(cmd, block_lba, sgl_nents, rw);
+	bio = iblock_get_bio(cmd, block_lba, sgl_nents, op, op_flags);
 	if (!bio)
 		goto fail_free_ibr;
 
@@ -738,7 +737,8 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 				bio_cnt = 0;
 			}
 
-			bio = iblock_get_bio(cmd, block_lba, sg_num, rw);
+			bio = iblock_get_bio(cmd, block_lba, sg_num, op,
+					     op_flags);
 			if (!bio)
 				goto fail_put_bios;
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index de18790..2cf915c 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -922,7 +922,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 					goto fail;
 
 				if (rw)
-					bio->bi_rw |= REQ_WRITE;
+					bio->bi_op = REQ_OP_WRITE;
 
 				pr_debug("PSCSI: Allocated bio: %p,"
 					" dir: %s nr_vecs: %d\n", bio,
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
