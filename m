Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5023E7CC7
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 11:17:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A7FC0AC008
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 09:17:50 -0700 (PDT)
Received: from mail-pa0-f68.google.com (mail-pa0-f68.google.com
	[209.85.220.68]) by cuda.sgi.com with ESMTP id hmo6vWpUGy8ADFHu
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Mar 2016 09:17:48 -0700 (PDT)
Received: by mail-pa0-f68.google.com with SMTP id 1so7116669pal.3
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 09:17:48 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 5/8] fs: xfs: replace BIO_MAX_SECTORS with BIO_MAX_PAGES
Date: Thu, 31 Mar 2016 00:17:14 +0800
Message-Id: <1459354637-17415-6-git-send-email-ming.lei@canonical.com>
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

BIO_MAX_PAGES is used as maximum count of bvecs, so
replace BIO_MAX_SECTORS with BIO_MAX_PAGES since
BIO_MAX_SECTORS is to be removed.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 fs/xfs/xfs_buf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9a2191b..b9ecb2d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1161,9 +1161,7 @@ xfs_buf_ioapply_map(
 
 next_chunk:
 	atomic_inc(&bp->b_io_remaining);
-	nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);
-	if (nr_pages > total_nr_pages)
-		nr_pages = total_nr_pages;
+	nr_pages = min(total_nr_pages, BIO_MAX_PAGES);
 
 	bio = bio_alloc(GFP_NOIO, nr_pages);
 	bio->bi_bdev = bp->b_target->bt_bdev;
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
