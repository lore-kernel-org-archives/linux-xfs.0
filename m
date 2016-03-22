Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A41D47CA4
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 01:12:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22C80AC005
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:12:50 -0700 (PDT)
Received: from mail-pf0-f196.google.com (mail-pf0-f196.google.com
	[209.85.192.196]) by cuda.sgi.com with ESMTP id
	LQNirH17apCDcFDS (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:12:48 -0700 (PDT)
Received: by mail-pf0-f196.google.com with SMTP id x3so33961910pfb.0
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:12:48 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 2/8] block: make 'struct bvec_iter' not depend on CONFIG_BLOCK
Date: Tue, 22 Mar 2016 14:12:23 +0800
Message-Id: <1458627149-12988-3-git-send-email-ming.lei@canonical.com>
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

We will use bvec iterator to implement iterate_bvec(): lib/iov_iter.c.

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
