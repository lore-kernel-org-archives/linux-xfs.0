Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B5007CB1
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 11:17:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D40A7304059
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 09:17:40 -0700 (PDT)
Received: from mail-pf0-f196.google.com (mail-pf0-f196.google.com
	[209.85.192.196]) by cuda.sgi.com with ESMTP id
	1dQkdxQiAF65umsq (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2016 09:17:39 -0700 (PDT)
Received: by mail-pf0-f196.google.com with SMTP id x3so7873421pfb.0
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 09:17:39 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 3/8] block: mark 1st parameter of bvec_iter_advance as const
Date: Thu, 31 Mar 2016 00:17:12 +0800
Message-Id: <1459354637-17415-4-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1459354637-17415-1-git-send-email-ming.lei@canonical.com>
References: <1459354637-17415-1-git-send-email-ming.lei@canonical.com>
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
 include/linux/bvec_iter.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/bvec_iter.h b/include/linux/bvec_iter.h
index 29c459d..9f0dcb2 100644
--- a/include/linux/bvec_iter.h
+++ b/include/linux/bvec_iter.h
@@ -45,7 +45,8 @@
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
