Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F94F7CA0
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 01:12:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 308B7304059
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:12:57 -0700 (PDT)
Received: from mail-pf0-f194.google.com (mail-pf0-f194.google.com
	[209.85.192.194]) by cuda.sgi.com with ESMTP id
	IHUlgKx8FU6z49E3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:12:55 -0700 (PDT)
Received: by mail-pf0-f194.google.com with SMTP id q129so34518446pfb.3
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:12:55 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 4/8] iov_iter: use bvec iterator to implement iterate_bvec()
Date: Tue, 22 Mar 2016 14:12:25 +0800
Message-Id: <1458627149-12988-5-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1458627149-12988-1-git-send-email-ming.lei@canonical.com>
References: <1458627149-12988-1-git-send-email-ming.lei@canonical.com>
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
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <ming.lei@canonical.com>, Philipp Reisner <philipp.reisner@linbit.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

bvec has provided one iterator already, so not necessary
to invent a new wheel for this job.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 lib/iov_iter.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 5fecddc..5e1b224 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -3,6 +3,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/bvec_iter.h>
 #include <net/checksum.h>
 
 #define iterate_iovec(i, n, __v, __p, skip, STEP) {	\
@@ -57,35 +58,25 @@
 }
 
 #define iterate_bvec(i, n, __v, __p, skip, STEP) {	\
-	size_t wanted = n;				\
+	struct bvec_iter __bi, __start;			\
+	__start.bi_size = n;				\
+	__start.bi_bvec_done = skip;			\
+	__start.bi_idx = 0;				\
 	__p = i->bvec;					\
-	__v.bv_len = min_t(size_t, n, __p->bv_len - skip);	\
-	if (likely(__v.bv_len)) {			\
-		__v.bv_page = __p->bv_page;		\
-		__v.bv_offset = __p->bv_offset + skip; 	\
+	for_each_bvec(__v, __p, __bi, __start) {	\
 		(void)(STEP);				\
-		skip += __v.bv_len;			\
-		n -= __v.bv_len;			\
 	}						\
-	while (unlikely(n)) {				\
-		__p++;					\
-		__v.bv_len = min_t(size_t, n, __p->bv_len);	\
-		if (unlikely(!__v.bv_len))		\
-			continue;			\
-		__v.bv_page = __p->bv_page;		\
-		__v.bv_offset = __p->bv_offset;		\
-		(void)(STEP);				\
+	if (!__bi.bi_idx)				\
+		skip += __v.bv_len;			\
+	else						\
 		skip = __v.bv_len;			\
-		n -= __v.bv_len;			\
-	}						\
-	n = wanted;					\
 }
 
 #define iterate_all_kinds(i, n, v, I, B, K) {			\
 	size_t skip = i->iov_offset;				\
 	if (unlikely(i->type & ITER_BVEC)) {			\
 		const struct bio_vec *bvec;			\
-		struct bio_vec v;				\
+		struct bio_vec v = { 0 };			\
 		iterate_bvec(i, n, v, bvec, skip, (B))		\
 	} else if (unlikely(i->type & ITER_KVEC)) {		\
 		const struct kvec *kvec;			\
@@ -102,7 +93,7 @@
 	size_t skip = i->iov_offset;				\
 	if (unlikely(i->type & ITER_BVEC)) {			\
 		const struct bio_vec *bvec;			\
-		struct bio_vec v;				\
+		struct bio_vec v = { 0 };			\
 		iterate_bvec(i, n, v, bvec, skip, (B))		\
 		if (skip == bvec->bv_len) {			\
 			bvec++;					\
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
