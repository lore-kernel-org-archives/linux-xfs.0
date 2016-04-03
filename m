Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A9C377CA6
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 11:31:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D5DB8F8039
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 09:31:34 -0700 (PDT)
Received: from mail-pf0-f171.google.com (mail-pf0-f171.google.com
	[209.85.192.171]) by cuda.sgi.com with ESMTP id
	rSl4whLVNDQ6WW97 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Apr 2016 09:31:33 -0700 (PDT)
Received: by mail-pf0-f171.google.com with SMTP id e128so105176846pfe.3
	for <xfs@oss.sgi.com>; Sun, 03 Apr 2016 09:31:33 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 2/8] block: move two bvec structure into bvec.h
Date: Mon,  4 Apr 2016 00:31:03 +0800
Message-Id: <1459701069-31406-3-git-send-email-ming.lei@canonical.com>
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

This patch moves 'struct bio_vec' and 'struct bvec_iter'
into 'include/linux/bvec.h', then always include this header
into 'include/linux/blk_types.h'.

With this change, both 'struct bvec_iter' and bvec iterator
helpers don't depend on CONFIG_BLOCK any more, then we can
use bvec iterator to implement iterate_bvec(): lib/iov_iter.c.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 include/linux/bio.h       |  1 -
 include/linux/blk_types.h | 22 +---------------------
 include/linux/bvec.h      | 20 +++++++++++++++++++-
 3 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 78cf737..7f998ac 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -31,7 +31,6 @@
 
 /* struct bio, bio_vec and BIO_* flags are defined in blk_types.h */
 #include <linux/blk_types.h>
-#include <linux/bvec.h>
 
 #define BIO_DEBUG
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 86a38ea..a8d8e1f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -6,6 +6,7 @@
 #define __LINUX_BLK_TYPES_H
 
 #include <linux/types.h>
+#include <linux/bvec.h>
 
 struct bio_set;
 struct bio;
@@ -17,28 +18,7 @@ struct cgroup_subsys_state;
 typedef void (bio_end_io_t) (struct bio *);
 typedef void (bio_destructor_t) (struct bio *);
 
-/*
- * was unsigned short, but we might as well be ready for > 64kB I/O pages
- */
-struct bio_vec {
-	struct page	*bv_page;
-	unsigned int	bv_len;
-	unsigned int	bv_offset;
-};
-
 #ifdef CONFIG_BLOCK
-
-struct bvec_iter {
-	sector_t		bi_sector;	/* device address in 512 byte
-						   sectors */
-	unsigned int		bi_size;	/* residual I/O count */
-
-	unsigned int		bi_idx;		/* current index into bvl_vec */
-
-	unsigned int            bi_bvec_done;	/* number of bytes completed in
-						   current bvec */
-};
-
 /*
  * main unit of I/O for the block layer and lower layers (ie drivers and
  * stacking drivers)
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 29c459d..e111124 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -20,7 +20,25 @@
 #ifndef __LINUX_BVEC_ITER_H
 #define __LINUX_BVEC_ITER_H
 
-#include <linux/blk_types.h>
+/*
+ * was unsigned short, but we might as well be ready for > 64kB I/O pages
+ */
+struct bio_vec {
+	struct page	*bv_page;
+	unsigned int	bv_len;
+	unsigned int	bv_offset;
+};
+
+struct bvec_iter {
+	sector_t		bi_sector;	/* device address in 512 byte
+						   sectors */
+	unsigned int		bi_size;	/* residual I/O count */
+
+	unsigned int		bi_idx;		/* current index into bvl_vec */
+
+	unsigned int            bi_bvec_done;	/* number of bytes completed in
+						   current bvec */
+};
 
 /*
  * various member access, note that bio_data should of course not be used
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
