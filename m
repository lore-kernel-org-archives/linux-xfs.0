Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A2A137CFF
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:34:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2AC1FAC003
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:34:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YMqfpHLeOpdFADIi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:34:09 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 42/45] block, fs,
	drivers: remove REQ_OP compat defs and related code
Date: Sun,  5 Jun 2016 14:32:22 -0500
Message-Id: <1465155145-10812-43-git-send-email-mchristi@redhat.com>
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

This patch drops the compat definition of req_op where it matches
the rq_flag_bits definitions, and drops the related old and compat
code that allowed users to set either the op or flags for the operation.

We also then store the operation in the bi_rw/cmd_flags field similar
to how we used to store the bio ioprio where it sat in the upper bits
of the field.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/scsi/sd.c           |  2 +-
 include/linux/bio.h         |  3 ---
 include/linux/blk_types.h   | 52 +++++++++++++++++----------------------------
 include/linux/blkdev.h      | 14 ++++++++----
 include/linux/fs.h          | 37 +++++++++++++-------------------
 include/trace/events/f2fs.h |  1 -
 6 files changed, 46 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c8dc221..fad86ad 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1012,7 +1012,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_6;
 	} else {
-		scmd_printk(KERN_ERR, SCpnt, "Unknown command %d,%llx\n",
+		scmd_printk(KERN_ERR, SCpnt, "Unknown command %llu,%llx\n",
 			    req_op(rq), (unsigned long long) rq->cmd_flags);
 		goto out;
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 35108c2..0bbb2e3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -44,9 +44,6 @@
 #define BIO_MAX_SIZE		(BIO_MAX_PAGES << PAGE_SHIFT)
 #define BIO_MAX_SECTORS		(BIO_MAX_SIZE >> 9)
 
-#define bio_op(bio)				(op_from_rq_bits((bio)->bi_rw))
-#define bio_set_op_attrs(bio, op, flags)	((bio)->bi_rw |= (op | flags))
-
 #define bio_prio(bio)			(bio)->bi_ioprio
 #define bio_set_prio(bio, prio)		((bio)->bi_ioprio = prio)
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 5efb6f1..23c1ab2 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -48,7 +48,9 @@ struct bio {
 	struct block_device	*bi_bdev;
 	unsigned int		bi_flags;	/* status, command, etc */
 	int			bi_error;
-	unsigned int		bi_rw;		/* READ/WRITE */
+	unsigned int		bi_rw;		/* bottom bits req flags,
+						 * top bits REQ_OP
+						 */
 	unsigned short		bi_ioprio;
 
 	struct bvec_iter	bi_iter;
@@ -106,6 +108,16 @@ struct bio {
 	struct bio_vec		bi_inline_vecs[0];
 };
 
+#define BIO_OP_SHIFT	(8 * sizeof(unsigned int) - REQ_OP_BITS)
+#define bio_op(bio)	((bio)->bi_rw >> BIO_OP_SHIFT)
+
+#define bio_set_op_attrs(bio, op, op_flags) do {		\
+	WARN_ON(op >= (1 << REQ_OP_BITS));			\
+	(bio)->bi_rw &= ((1 << BIO_OP_SHIFT) - 1);		\
+	(bio)->bi_rw |= ((unsigned int) (op) << BIO_OP_SHIFT);	\
+	(bio)->bi_rw |= op_flags;				\
+} while (0)
+
 #define BIO_RESET_BYTES		offsetof(struct bio, bi_max_vecs)
 
 /*
@@ -144,7 +156,6 @@ struct bio {
  */
 enum rq_flag_bits {
 	/* common flags */
-	__REQ_WRITE,		/* not set, read. set, write */
 	__REQ_FAILFAST_DEV,	/* no driver retries of device errors */
 	__REQ_FAILFAST_TRANSPORT, /* no driver retries of transport errors */
 	__REQ_FAILFAST_DRIVER,	/* no driver retries of driver errors */
@@ -152,9 +163,7 @@ enum rq_flag_bits {
 	__REQ_SYNC,		/* request is sync (sync write or read) */
 	__REQ_META,		/* metadata io request */
 	__REQ_PRIO,		/* boost priority in cfq */
-	__REQ_DISCARD,		/* request to discard sectors */
-	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
-	__REQ_WRITE_SAME,	/* write same block many times */
+	__REQ_SECURE,		/* secure discard (used with REQ_OP_DISCARD) */
 
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
 	__REQ_INTEGRITY,	/* I/O includes block integrity payload */
@@ -190,28 +199,22 @@ enum rq_flag_bits {
 	__REQ_NR_BITS,		/* stops here */
 };
 
-#define REQ_WRITE		(1ULL << __REQ_WRITE)
 #define REQ_FAILFAST_DEV	(1ULL << __REQ_FAILFAST_DEV)
 #define REQ_FAILFAST_TRANSPORT	(1ULL << __REQ_FAILFAST_TRANSPORT)
 #define REQ_FAILFAST_DRIVER	(1ULL << __REQ_FAILFAST_DRIVER)
 #define REQ_SYNC		(1ULL << __REQ_SYNC)
 #define REQ_META		(1ULL << __REQ_META)
 #define REQ_PRIO		(1ULL << __REQ_PRIO)
-#define REQ_DISCARD		(1ULL << __REQ_DISCARD)
-#define REQ_WRITE_SAME		(1ULL << __REQ_WRITE_SAME)
 #define REQ_NOIDLE		(1ULL << __REQ_NOIDLE)
 #define REQ_INTEGRITY		(1ULL << __REQ_INTEGRITY)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
-	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
-	 REQ_DISCARD | REQ_WRITE_SAME | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | \
-	 REQ_SECURE | REQ_INTEGRITY | REQ_NOMERGE)
+	(REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | REQ_NOIDLE | \
+	 REQ_FLUSH | REQ_FUA | REQ_SECURE | REQ_INTEGRITY | REQ_NOMERGE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
-#define BIO_NO_ADVANCE_ITER_MASK	(REQ_DISCARD|REQ_WRITE_SAME)
-
 /* This mask is used for both bio and request merge checking */
 #define REQ_NOMERGE_FLAGS \
 	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | REQ_FLUSH_SEQ)
@@ -243,27 +246,12 @@ enum rq_flag_bits {
 
 enum req_op {
 	REQ_OP_READ,
-	REQ_OP_WRITE		= REQ_WRITE,
-	REQ_OP_DISCARD		= REQ_DISCARD,
-	REQ_OP_WRITE_SAME	= REQ_WRITE_SAME,
+	REQ_OP_WRITE,
+	REQ_OP_DISCARD,		/* request to discard sectors */
+	REQ_OP_WRITE_SAME,	/* write same block many times */
 };
 
-/*
- * tmp cpmpat. Users used to set the write bit for all non reads, but
- * we will be dropping the bitmap use for ops. Support both until
- * the end of the patchset.
- */
-static inline int op_from_rq_bits(u64 flags)
-{
-	if (flags & REQ_OP_DISCARD)
-		return REQ_OP_DISCARD;
-	else if (flags & REQ_OP_WRITE_SAME)
-		return REQ_OP_WRITE_SAME;
-	else if (flags & REQ_OP_WRITE)
-		return REQ_OP_WRITE;
-	else
-		return REQ_OP_READ;
-}
+#define REQ_OP_BITS 2
 
 typedef unsigned int blk_qc_t;
 #define BLK_QC_T_NONE	-1U
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4937c05..78ae3db 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -200,8 +200,15 @@ struct request {
 	struct request *next_rq;
 };
 
-#define req_op(req)		(op_from_rq_bits((req)->cmd_flags))
-#define req_set_op(req, op)	((req)->cmd_flags |= op)
+#define REQ_OP_SHIFT (8 * sizeof(u64) - REQ_OP_BITS)
+#define req_op(req)  ((req)->cmd_flags >> REQ_OP_SHIFT)
+
+#define req_set_op(req, op) do {				\
+	WARN_ON(op >= (1 << REQ_OP_BITS));			\
+	(req)->cmd_flags &= ((1ULL << REQ_OP_SHIFT) - 1);	\
+	(req)->cmd_flags |= ((u64) (op) << REQ_OP_SHIFT);	\
+} while (0)
+
 #define req_set_op_attrs(req, op, flags) do {	\
 	req_set_op(req, op);			\
 	(req)->cmd_flags |= flags;		\
@@ -604,8 +611,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
-#define rq_data_dir(rq) \
-	(op_is_write(op_from_rq_bits(rq->cmd_flags)) ? WRITE : READ)
+#define rq_data_dir(rq)		(op_is_write(req_op(rq)) ? WRITE : READ)
 
 /*
  * Driver can handle struct request, if it either has an old style
diff --git a/include/linux/fs.h b/include/linux/fs.h
index af6f3c7..ccd1664 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -152,9 +152,10 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define CHECK_IOVEC_ONLY -1
 
 /*
- * The below are the various read and write types that we support. Some of
+ * The below are the various read and write flags that we support. Some of
  * them include behavioral modifiers that send information down to the
- * block layer and IO scheduler. Terminology:
+ * block layer and IO scheduler. They should be used along with a req_op.
+ * Terminology:
  *
  *	The block layer uses device plugging to defer IO a little bit, in
  *	the hope that we will see more IO very shortly. This increases
@@ -193,19 +194,19 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
  *			non-volatile media on completion.
  *
  */
-#define RW_MASK			REQ_WRITE
+#define RW_MASK			REQ_OP_WRITE
 #define RWA_MASK		REQ_RAHEAD
 
-#define READ			0
+#define READ			REQ_OP_READ
 #define WRITE			RW_MASK
 #define READA			RWA_MASK
 
-#define READ_SYNC		(READ | REQ_SYNC)
-#define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE)
-#define WRITE_ODIRECT		(WRITE | REQ_SYNC)
-#define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH)
-#define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FUA)
-#define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
+#define READ_SYNC		REQ_SYNC
+#define WRITE_SYNC		(REQ_SYNC | REQ_NOIDLE)
+#define WRITE_ODIRECT		REQ_SYNC
+#define WRITE_FLUSH		(REQ_SYNC | REQ_NOIDLE | REQ_FLUSH)
+#define WRITE_FUA		(REQ_SYNC | REQ_NOIDLE | REQ_FUA)
+#define WRITE_FLUSH_FUA		(REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
 
 /*
  * Attribute flags.  These should be or-ed together to figure out what
@@ -2464,17 +2465,9 @@ extern void make_bad_inode(struct inode *);
 extern bool is_bad_inode(struct inode *);
 
 #ifdef CONFIG_BLOCK
-/*
- * tmp cpmpat. Users used to set the write bit for all non reads, but
- * we will be dropping the bitmap use for ops. Support both until
- * the end of the patchset.
- */
-static inline bool op_is_write(unsigned long flags)
+static inline bool op_is_write(unsigned int op)
 {
-	if (flags & (REQ_OP_WRITE | REQ_OP_WRITE_SAME | REQ_OP_DISCARD))
-		return true;
-	else
-		return false;
+	return op == REQ_OP_READ ? false : true;
 }
 
 /*
@@ -2482,7 +2475,7 @@ static inline bool op_is_write(unsigned long flags)
  */
 static inline int bio_rw(struct bio *bio)
 {
-	if (op_is_write(op_from_rq_bits(bio->bi_rw)))
+	if (op_is_write(bio_op(bio)))
 		return WRITE;
 
 	return bio->bi_rw & RWA_MASK;
@@ -2493,7 +2486,7 @@ static inline int bio_rw(struct bio *bio)
  */
 static inline int bio_data_dir(struct bio *bio)
 {
-	return op_is_write(op_from_rq_bits(bio->bi_rw)) ? WRITE : READ;
+	return op_is_write(bio_op(bio)) ? WRITE : READ;
 }
 
 extern void check_disk_size_change(struct gendisk *disk,
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 733b896..30efa44 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -31,7 +31,6 @@ TRACE_DEFINE_ENUM(BG_GC);
 TRACE_DEFINE_ENUM(LFS);
 TRACE_DEFINE_ENUM(SSR);
 TRACE_DEFINE_ENUM(__REQ_RAHEAD);
-TRACE_DEFINE_ENUM(__REQ_WRITE);
 TRACE_DEFINE_ENUM(__REQ_SYNC);
 TRACE_DEFINE_ENUM(__REQ_NOIDLE);
 TRACE_DEFINE_ENUM(__REQ_FLUSH);
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
