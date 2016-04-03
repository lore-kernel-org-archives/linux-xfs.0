Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF4F77CB5
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 11:31:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39773AC002
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 09:31:48 -0700 (PDT)
Received: from mail-pa0-f42.google.com (mail-pa0-f42.google.com
	[209.85.220.42]) by cuda.sgi.com with ESMTP id bfeFIy8T6OnCgy3q
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 Apr 2016 09:31:46 -0700 (PDT)
Received: by mail-pa0-f42.google.com with SMTP id td3so126459911pab.2
	for <xfs@oss.sgi.com>; Sun, 03 Apr 2016 09:31:46 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 4/8] iov_iter: use bvec iterator to implement iterate_bvec()
Date: Mon,  4 Apr 2016 00:31:05 +0800
Message-Id: <1459701069-31406-5-git-send-email-ming.lei@canonical.com>
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

bvec has provided one iterator already, so not necessary
to reinvent a new wheel for this job.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 lib/iov_iter.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 5fecddc..c8691ac 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -57,35 +57,25 @@
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
@@ -102,7 +92,7 @@
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
