Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2067C7CB1
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2016 19:40:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C2459304039
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2016 17:40:19 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id s6RnkgHBAubK4SS4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 28 Sep 2016 17:40:17 -0700 (PDT)
Subject: [PATCH 2/3] block: require write_same and discard requests align to
	logical block size
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Sep 2016 17:39:44 -0700
Message-ID: <147510958448.8940.14280630935441533825.stgit@birch.djwong.org>
In-Reply-To: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
References: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: axboe@kernel.dk, akpm@linux-foundation.org, darrick.wong@oracle.com
Cc: hch@infradead.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, bart.vanassche@sandisk.com, Christoph Hellwig <hch@lst.de>

Make sure that the offset and length arguments that we're using to
construct WRITE SAME and DISCARD requests are actually aligned to the
logical block size.  Failure to do this causes other errors in other
parts of the block layer or the SCSI layer because disks don't support
partial logical block writes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-lib.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/block/blk-lib.c b/block/blk-lib.c
index 083e56f..46fe924 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -31,6 +31,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	unsigned int granularity;
 	enum req_op op;
 	int alignment;
+	sector_t bs_mask;
 
 	if (!q)
 		return -ENXIO;
@@ -50,6 +51,10 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		op = REQ_OP_DISCARD;
 	}
 
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
+
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
 	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
@@ -150,10 +155,15 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 	unsigned int max_write_same_sectors;
 	struct bio *bio = NULL;
 	int ret = 0;
+	sector_t bs_mask;
 
 	if (!q)
 		return -ENXIO;
 
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
+
 	/* Ensure that max_write_same_sectors doesn't overflow bi_size */
 	max_write_same_sectors = UINT_MAX >> 9;
 
@@ -202,6 +212,11 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	int ret;
 	struct bio *bio = NULL;
 	unsigned int sz;
+	sector_t bs_mask;
+
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
 
 	while (nr_sects != 0) {
 		bio = next_bio(bio, min(nr_sects, (sector_t)BIO_MAX_PAGES),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
