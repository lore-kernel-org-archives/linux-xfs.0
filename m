Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 40E167CB2
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 11:31:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE20E304032
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 09:31:40 -0700 (PDT)
Received: from mail-pa0-f52.google.com (mail-pa0-f52.google.com
	[209.85.220.52]) by cuda.sgi.com with ESMTP id TNRtVXotG7ElQm1q
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 Apr 2016 09:31:39 -0700 (PDT)
Received: by mail-pa0-f52.google.com with SMTP id fe3so126907090pab.1
	for <xfs@oss.sgi.com>; Sun, 03 Apr 2016 09:31:39 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 3/8] block: mark 1st parameter of bvec_iter_advance as const
Date: Mon,  4 Apr 2016 00:31:04 +0800
Message-Id: <1459701069-31406-4-git-send-email-ming.lei@canonical.com>
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

bvec_iter_advance() only writes the parameter of iterator,
so the base address of bvec can be marked as const safely.

Without the change, we can see compiling warning in the
following patch for implementing iterate_bvec(): lib/iov_iter.c
with bvec iterator.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 include/linux/bvec.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index e111124..0c6fa42 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -63,7 +63,8 @@ struct bvec_iter {
 	.bv_offset	= bvec_iter_offset((bvec), (iter)),	\
 })
 
-static inline void bvec_iter_advance(struct bio_vec *bv, struct bvec_iter *iter,
+static inline void bvec_iter_advance(const struct bio_vec *bv,
+				     struct bvec_iter *iter,
 				     unsigned bytes)
 {
 	WARN_ONCE(bytes > iter->bi_size,
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
