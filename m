Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABF9F29E55
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 14:55:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 713B28F8035
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 12:55:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CyuD25ZPEUPusNN0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 12:55:12 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 31/35] block, fs: remove old REQ definitions.
Date: Tue,  5 Jan 2016 14:53:34 -0600
Message-Id: <1452027218-32303-32-git-send-email-mchristi@redhat.com>
In-Reply-To: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
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

We no longer use REQ_WRITE. REQ_WRITE_SAME and REQ_DISCARD,
so this patch removes them.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 include/linux/blk_types.h   | 19 +++++--------------
 include/linux/fs.h          | 21 +++++++++++----------
 include/trace/events/f2fs.h |  1 -
 3 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 6e49c91..bb30c2b 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -151,7 +151,6 @@ struct bio {
  */
 enum rq_flag_bits {
 	/* common flags */
-	__REQ_WRITE,		/* not set, read. set, write */
 	__REQ_FAILFAST_DEV,	/* no driver retries of device errors */
 	__REQ_FAILFAST_TRANSPORT, /* no driver retries of transport errors */
 	__REQ_FAILFAST_DRIVER,	/* no driver retries of driver errors */
@@ -159,9 +158,7 @@ enum rq_flag_bits {
 	__REQ_SYNC,		/* request is sync (sync write or read) */
 	__REQ_META,		/* metadata io request */
 	__REQ_PRIO,		/* boost priority in cfq */
-	__REQ_DISCARD,		/* request to discard sectors */
 	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
-	__REQ_WRITE_SAME,	/* write same block many times */
 
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
 	__REQ_INTEGRITY,	/* I/O includes block integrity payload */
@@ -197,28 +194,22 @@ enum rq_flag_bits {
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
-	 REQ_SECURE | REQ_INTEGRITY)
+	(REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | REQ_NOIDLE | \
+	 REQ_FLUSH | REQ_FUA | REQ_SECURE | REQ_INTEGRITY)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
-#define BIO_NO_ADVANCE_ITER_MASK	(REQ_DISCARD|REQ_WRITE_SAME)
-
 /* This mask is used for both bio and request merge checking */
 #define REQ_NOMERGE_FLAGS \
 	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | REQ_FLUSH_SEQ)
@@ -250,9 +241,9 @@ enum rq_flag_bits {
 
 enum req_op {
 	REQ_OP_READ,
-	REQ_OP_WRITE		= REQ_WRITE,
-	REQ_OP_DISCARD		= REQ_DISCARD,
-	REQ_OP_WRITE_SAME	= REQ_WRITE_SAME,
+	REQ_OP_WRITE,
+	REQ_OP_DISCARD,		/* request to discard sectors */
+	REQ_OP_WRITE_SAME,	/* write same block many times */
 };
 
 typedef unsigned int blk_qc_t;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 85007cd..d57a5b5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -151,9 +151,10 @@ typedef void (dax_iodone_t)(struct buffer_head *bh_map, int uptodate);
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
@@ -192,19 +193,19 @@ typedef void (dax_iodone_t)(struct buffer_head *bh_map, int uptodate);
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
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index ddf4144..ed3fc87 100644
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
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
