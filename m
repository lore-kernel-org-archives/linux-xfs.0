Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 85FD17CC9
	for <xfs@oss.sgi.com>; Mon,  4 Apr 2016 01:57:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4534E8F8035
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2016 23:57:20 -0700 (PDT)
Received: from mail-pf0-f174.google.com (mail-pf0-f174.google.com
	[209.85.192.174]) by cuda.sgi.com with ESMTP id
	O4F6p6PaNEHJywFy (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Apr 2016 23:57:19 -0700 (PDT)
Received: by mail-pf0-f174.google.com with SMTP id c20so29154761pfc.1
	for <xfs@oss.sgi.com>; Sun, 03 Apr 2016 23:57:19 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v3 7/8] block: drbd: avoid to use BIO_MAX_SIZE
Date: Mon,  4 Apr 2016 14:56:33 +0800
Message-Id: <1459752994-2205-8-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1459752994-2205-1-git-send-email-ming.lei@canonical.com>
References: <1459752994-2205-1-git-send-email-ming.lei@canonical.com>
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

drbd is the only user of BIO_MAX_SIZE, so use BIO_MAX_PAGES
instead.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/drbd/drbd_int.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c227fd4..10bfff1 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1327,14 +1327,14 @@ struct bm_extent {
 #endif
 #endif
 
-/* BIO_MAX_SIZE is 256 * PAGE_CACHE_SIZE,
+/* Estimate max bio size as 256 * PAGE_CACHE_SIZE,
  * so for typical PAGE_CACHE_SIZE of 4k, that is (1<<20) Byte.
  * Since we may live in a mixed-platform cluster,
  * we limit us to a platform agnostic constant here for now.
  * A followup commit may allow even bigger BIO sizes,
  * once we thought that through. */
 #define DRBD_MAX_BIO_SIZE (1U << 20)
-#if DRBD_MAX_BIO_SIZE > BIO_MAX_SIZE
+#if DRBD_MAX_BIO_SIZE > (BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
 #error Architecture not supported: DRBD_MAX_BIO_SIZE > BIO_MAX_SIZE
 #endif
 #define DRBD_MAX_BIO_SIZE_SAFE (1U << 12)       /* Works always = 4k */
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
