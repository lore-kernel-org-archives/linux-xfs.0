Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q65G2DWw077999 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 11:02:13 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id aZmf0RMHVzMzHNtt
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Jul 2012 09:02:12 -0700 (PDT)
Received: by mail-pb0-f53.google.com with SMTP id rr13so16092919pbb.26
	for <xfs@oss.sgi.com>; Thu, 05 Jul 2012 09:02:12 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 1/2] block: reorganize rounding of max_discard_sectors
Date: Thu,  5 Jul 2012 18:01:43 +0200
Message-Id: <1341504104-1674-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1341504104-1674-1-git-send-email-pbonzini@redhat.com>
References: <1341504104-1674-1-git-send-email-pbonzini@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, snitzer@redhat.com, martin.petersen@oracle.com, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de, vgoyal@redhat.com

Mostly a preparation for the next patch.

In principle this fixes an infinite loop if max_discard_sectors < granularity,
but that really shouldn't happen.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/blk-lib.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2b461b4..16b06f6 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -44,6 +44,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = REQ_WRITE | REQ_DISCARD;
 	unsigned int max_discard_sectors;
+	unsigned int granularity;
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
@@ -54,18 +55,18 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
+	/* Zero-sector (unknown) and one-sector granularities are the same.  */
+	granularity = max(q->limits.discard_granularity >> 9, 1U);
+
 	/*
 	 * Ensure that max_discard_sectors is of the proper
 	 * granularity
 	 */
 	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+	max_discard_sectors = round_down(max_discard_sectors, granularity);
 	if (unlikely(!max_discard_sectors)) {
 		/* Avoid infinite loop below. Being cautious never hurts. */
 		return -EOPNOTSUPP;
-	} else if (q->limits.discard_granularity) {
-		unsigned int disc_sects = q->limits.discard_granularity >> 9;
-
-		max_discard_sectors &= ~(disc_sects - 1);
 	}
 
 	if (flags & BLKDEV_DISCARD_SECURE) {
-- 
1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
