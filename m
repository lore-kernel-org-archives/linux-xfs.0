Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3M6lhax186658 for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 01:47:44 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] xfs: fix xfs_alloc_ioend_bio code to try and get atleast a
	smaller bio
Date: Wed, 22 Apr 2009 12:15:17 +0530
References: <200904151609.30677.knikanth@suse.de>
	<20090420010237.GF16929@discord.disaster>
In-Reply-To: <20090420010237.GF16929@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904221215.18335.knikanth@suse.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Jens Axboe <jens.axboe@oracle.com>

The intent of the code in xfs_alloc_ioend_bio() is that if we can't get a
large bio immediately, try a smaller one which is more likely to succeed when
we are under memory pressure. i.e. we will get IO moving faster than if we
waited for a maximally sized biovec to be allocated. But GFP_NOIO implies
__GFP_WAIT which would return only if it can allocate the bio. So the first
attempt to get a larger bio itself would return only after it succeeds, which
makes the logic useless.

Change it to try with GFP_NOWAIT for a bio. If not possible wait for it.

See http://oss.sgi.com/archives/xfs-masters/2009-04/msg00027.html for the
discussion.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 7ec89fc..002ce7f 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -419,12 +419,15 @@ xfs_alloc_ioend_bio(
 	struct buffer_head	*bh)
 {
 	struct bio		*bio;
-	int			nvecs = bio_get_nr_vecs(bh->b_bdev);
+	int			nr_iovecs = bio_get_nr_vecs(bh->b_bdev);
+	int			nvecs = nr_iovecs;
 
 	do {
-		bio = bio_alloc(GFP_NOIO, nvecs);
-		nvecs >>= 1;
-	} while (!bio);
+		bio = bio_alloc(GFP_NOWAIT, nvecs);
+	} while (!bio && (nvecs >>= 1));
+
+	if (unlikely(!bio))
+		bio = bio_alloc(GFP_NOIO, nr_iovecs);
 
 	ASSERT(bio->bi_private == NULL);
 	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
