Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AC6D77CA2
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:32:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 71E808F8039
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:32:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id l596yVqit5FiSdXz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:32:38 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 02/45] block: add REQ_OP definitions and helpers
Date: Sun,  5 Jun 2016 14:31:42 -0500
Message-Id: <1465155145-10812-3-git-send-email-mchristi@redhat.com>
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

The following patches separate the operation (WRITE, READ, DISCARD,
etc) from the rq_flag_bits flags. This patch adds definitions for
request/bio operations (REQ_OPs) and adds request/bio accessors to
get/set the op.

In this patch the REQ_OPs match the REQ rq_flag_bits ones
for compat reasons while all the code is converted to use the
op accessors in the set. In the last patches the op will become a
number and the accessors and helpers in this patch will be dropped
or updated.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 include/linux/bio.h       |  3 +++
 include/linux/blk_types.h | 24 ++++++++++++++++++++++++
 include/linux/blkdev.h    | 10 +++++++++-
 include/linux/fs.h        | 26 ++++++++++++++++++++++++--
 4 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 3bde942..09c5308 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -44,6 +44,9 @@
 #define BIO_MAX_SIZE		(BIO_MAX_PAGES << PAGE_SHIFT)
 #define BIO_MAX_SECTORS		(BIO_MAX_SIZE >> 9)
 
+#define bio_op(bio)				(op_from_rq_bits((bio)->bi_rw))
+#define bio_set_op_attrs(bio, op, flags)	((bio)->bi_rw |= (op | flags))
+
 /*
  * upper 16 bits of bi_rw define the io priority of this bio
  */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 77e5d81..6e60baa 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -242,6 +242,30 @@ enum rq_flag_bits {
 #define REQ_HASHED		(1ULL << __REQ_HASHED)
 #define REQ_MQ_INFLIGHT		(1ULL << __REQ_MQ_INFLIGHT)
 
+enum req_op {
+	REQ_OP_READ,
+	REQ_OP_WRITE		= REQ_WRITE,
+	REQ_OP_DISCARD		= REQ_DISCARD,
+	REQ_OP_WRITE_SAME	= REQ_WRITE_SAME,
+};
+
+/*
+ * tmp cpmpat. Users used to set the write bit for all non reads, but
+ * we will be dropping the bitmap use for ops. Support both until
+ * the end of the patchset.
+ */
+static inline int op_from_rq_bits(u64 flags)
+{
+	if (flags & REQ_OP_DISCARD)
+		return REQ_OP_DISCARD;
+	else if (flags & REQ_OP_WRITE_SAME)
+		return REQ_OP_WRITE_SAME;
+	else if (flags & REQ_OP_WRITE)
+		return REQ_OP_WRITE;
+	else
+		return REQ_OP_READ;
+}
+
 typedef unsigned int blk_qc_t;
 #define BLK_QC_T_NONE	-1U
 #define BLK_QC_T_SHIFT	16
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3d9cf32..49c2dbc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -200,6 +200,13 @@ struct request {
 	struct request *next_rq;
 };
 
+#define req_op(req)		(op_from_rq_bits((req)->cmd_flags))
+#define req_set_op(req, op)	((req)->cmd_flags |= op)
+#define req_set_op_attrs(req, op, flags) do {	\
+	req_set_op(req, op);			\
+	(req)->cmd_flags |= flags;		\
+} while (0)
+
 static inline unsigned short req_get_ioprio(struct request *req)
 {
 	return req->ioprio;
@@ -597,7 +604,8 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
-#define rq_data_dir(rq)		((int)((rq)->cmd_flags & 1))
+#define rq_data_dir(rq) \
+	(op_is_write(op_from_rq_bits(rq->cmd_flags)) ? WRITE : READ)
 
 /*
  * Driver can handle struct request, if it either has an old style
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 65e4c51..62ca2f9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2465,14 +2465,36 @@ extern bool is_bad_inode(struct inode *);
 
 #ifdef CONFIG_BLOCK
 /*
+ * tmp cpmpat. Users used to set the write bit for all non reads, but
+ * we will be dropping the bitmap use for ops. Support both until
+ * the end of the patchset.
+ */
+static inline bool op_is_write(unsigned long flags)
+{
+	if (flags & (REQ_OP_WRITE | REQ_OP_WRITE_SAME | REQ_OP_DISCARD))
+		return true;
+	else
+		return false;
+}
+
+/*
  * return READ, READA, or WRITE
  */
-#define bio_rw(bio)		((bio)->bi_rw & (RW_MASK | RWA_MASK))
+static inline int bio_rw(struct bio *bio)
+{
+	if (op_is_write(op_from_rq_bits(bio->bi_rw)))
+		return WRITE;
+
+	return bio->bi_rw & RWA_MASK;
+}
 
 /*
  * return data direction, READ or WRITE
  */
-#define bio_data_dir(bio)	((bio)->bi_rw & 1)
+static inline int bio_data_dir(struct bio *bio)
+{
+	return op_is_write(op_from_rq_bits(bio->bi_rw)) ? WRITE : READ;
+}
 
 extern void check_disk_size_change(struct gendisk *disk,
 				   struct block_device *bdev);
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
