Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 203DB7CA4
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 11:31:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E88338F8039
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 09:31:28 -0700 (PDT)
Received: from mail-pf0-f182.google.com (mail-pf0-f182.google.com
	[209.85.192.182]) by cuda.sgi.com with ESMTP id
	2dibqpFGS8X2CErz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Apr 2016 09:31:27 -0700 (PDT)
Received: by mail-pf0-f182.google.com with SMTP id e128so105175753pfe.3
	for <xfs@oss.sgi.com>; Sun, 03 Apr 2016 09:31:27 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 1/8] block: move bvec iterator into include/linux/bvec.h
Date: Mon,  4 Apr 2016 00:31:02 +0800
Message-Id: <1459701069-31406-2-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1459701069-31406-1-git-send-email-ming.lei@canonical.com>
References: <1459701069-31406-1-git-send-email-ming.lei@canonical.com>
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
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <ming.lei@canonical.com>, Philipp Reisner <philipp.reisner@linbit.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

bvec iterator helpers should be used to implement by
iterate_bvec():lib/iov_iter.c too, and move them into
one header, so that we can keep bvec iterator header
out of CONFIG_BLOCK. Then we can remove the reinventing
of wheel in iterate_bvec().

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 include/linux/bio.h  | 51 +-----------------------------------
 include/linux/bvec.h | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 50 deletions(-)
 create mode 100644 include/linux/bvec.h

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 88bc64f..78cf737 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -31,6 +31,7 @@
 
 /* struct bio, bio_vec and BIO_* flags are defined in blk_types.h */
 #include <linux/blk_types.h>
+#include <linux/bvec.h>
 
 #define BIO_DEBUG
 
@@ -57,29 +58,6 @@
 	(bio)->bi_rw |= ((unsigned long) (prio) << BIO_PRIO_SHIFT);	\
 } while (0)
 
-/*
- * various member access, note that bio_data should of course not be used
- * on highmem page vectors
- */
-#define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
-
-#define bvec_iter_page(bvec, iter)				\
-	(__bvec_iter_bvec((bvec), (iter))->bv_page)
-
-#define bvec_iter_len(bvec, iter)				\
-	min((iter).bi_size,					\
-	    __bvec_iter_bvec((bvec), (iter))->bv_len - (iter).bi_bvec_done)
-
-#define bvec_iter_offset(bvec, iter)				\
-	(__bvec_iter_bvec((bvec), (iter))->bv_offset + (iter).bi_bvec_done)
-
-#define bvec_iter_bvec(bvec, iter)				\
-((struct bio_vec) {						\
-	.bv_page	= bvec_iter_page((bvec), (iter)),	\
-	.bv_len		= bvec_iter_len((bvec), (iter)),	\
-	.bv_offset	= bvec_iter_offset((bvec), (iter)),	\
-})
-
 #define bio_iter_iovec(bio, iter)				\
 	bvec_iter_bvec((bio)->bi_io_vec, (iter))
 
@@ -193,33 +171,6 @@ static inline void *bio_data(struct bio *bio)
 #define bio_for_each_segment_all(bvl, bio, i)				\
 	for (i = 0, bvl = (bio)->bi_io_vec; i < (bio)->bi_vcnt; i++, bvl++)
 
-static inline void bvec_iter_advance(struct bio_vec *bv, struct bvec_iter *iter,
-				     unsigned bytes)
-{
-	WARN_ONCE(bytes > iter->bi_size,
-		  "Attempted to advance past end of bvec iter\n");
-
-	while (bytes) {
-		unsigned len = min(bytes, bvec_iter_len(bv, *iter));
-
-		bytes -= len;
-		iter->bi_size -= len;
-		iter->bi_bvec_done += len;
-
-		if (iter->bi_bvec_done == __bvec_iter_bvec(bv, *iter)->bv_len) {
-			iter->bi_bvec_done = 0;
-			iter->bi_idx++;
-		}
-	}
-}
-
-#define for_each_bvec(bvl, bio_vec, iter, start)			\
-	for (iter = (start);						\
-	     (iter).bi_size &&						\
-		((bvl = bvec_iter_bvec((bio_vec), (iter))), 1);	\
-	     bvec_iter_advance((bio_vec), &(iter), (bvl).bv_len))
-
-
 static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 				    unsigned bytes)
 {
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
new file mode 100644
index 0000000..29c459d
--- /dev/null
+++ b/include/linux/bvec.h
@@ -0,0 +1,74 @@
+/*
+ * bvec iterator
+ *
+ * Copyright (C) 2001 Ming Lei <ming.lei@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public Licens
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-
+ */
+#ifndef __LINUX_BVEC_ITER_H
+#define __LINUX_BVEC_ITER_H
+
+#include <linux/blk_types.h>
+
+/*
+ * various member access, note that bio_data should of course not be used
+ * on highmem page vectors
+ */
+#define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
+
+#define bvec_iter_page(bvec, iter)				\
+	(__bvec_iter_bvec((bvec), (iter))->bv_page)
+
+#define bvec_iter_len(bvec, iter)				\
+	min((iter).bi_size,					\
+	    __bvec_iter_bvec((bvec), (iter))->bv_len - (iter).bi_bvec_done)
+
+#define bvec_iter_offset(bvec, iter)				\
+	(__bvec_iter_bvec((bvec), (iter))->bv_offset + (iter).bi_bvec_done)
+
+#define bvec_iter_bvec(bvec, iter)				\
+((struct bio_vec) {						\
+	.bv_page	= bvec_iter_page((bvec), (iter)),	\
+	.bv_len		= bvec_iter_len((bvec), (iter)),	\
+	.bv_offset	= bvec_iter_offset((bvec), (iter)),	\
+})
+
+static inline void bvec_iter_advance(struct bio_vec *bv, struct bvec_iter *iter,
+				     unsigned bytes)
+{
+	WARN_ONCE(bytes > iter->bi_size,
+		  "Attempted to advance past end of bvec iter\n");
+
+	while (bytes) {
+		unsigned len = min(bytes, bvec_iter_len(bv, *iter));
+
+		bytes -= len;
+		iter->bi_size -= len;
+		iter->bi_bvec_done += len;
+
+		if (iter->bi_bvec_done == __bvec_iter_bvec(bv, *iter)->bv_len) {
+			iter->bi_bvec_done = 0;
+			iter->bi_idx++;
+		}
+	}
+}
+
+#define for_each_bvec(bvl, bio_vec, iter, start)			\
+	for (iter = (start);						\
+	     (iter).bi_size &&						\
+		((bvl = bvec_iter_bvec((bio_vec), (iter))), 1);	\
+	     bvec_iter_advance((bio_vec), &(iter), (bvl).bv_len))
+
+#endif /* __LINUX_BVEC_ITER_H */
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
