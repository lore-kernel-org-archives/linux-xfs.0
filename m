Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 040397CB0
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 11:17:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C0A5AC008
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 09:17:40 -0700 (PDT)
Received: from mail-pa0-f65.google.com (mail-pa0-f65.google.com
	[209.85.220.65]) by cuda.sgi.com with ESMTP id jVqP3JPTLtfOsdiZ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Mar 2016 09:17:35 -0700 (PDT)
Received: by mail-pa0-f65.google.com with SMTP id hn5so5332729pac.2
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 09:17:35 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 2/8] block: make 'struct bvec_iter' not depend on
	CONFIG_BLOCK
Date: Thu, 31 Mar 2016 00:17:11 +0800
Message-Id: <1459354637-17415-3-git-send-email-ming.lei@canonical.com>
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

We will use bvec iterator to implement iterate_bvec(): lib/iov_iter.c.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 include/linux/blk_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 86a38ea..fd8527b 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -26,8 +26,6 @@ struct bio_vec {
 	unsigned int	bv_offset;
 };
 
-#ifdef CONFIG_BLOCK
-
 struct bvec_iter {
 	sector_t		bi_sector;	/* device address in 512 byte
 						   sectors */
@@ -39,6 +37,8 @@ struct bvec_iter {
 						   current bvec */
 };
 
+#ifdef CONFIG_BLOCK
+
 /*
  * main unit of I/O for the block layer and lower layers (ie drivers and
  * stacking drivers)
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
