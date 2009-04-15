Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3F5AaEP247404 for <xfs@oss.sgi.com>; Wed, 15 Apr 2009 00:10:46 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH 6/7] xfs: Remove code handling bio_alloc failure with
	__GFP_WAIT
Date: Wed, 15 Apr 2009 10:36:48 +0530
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904151036.49241.knikanth@suse.de>
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
To: xfs-masters@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Remove code handling bio_alloc failure with __GFP_WAIT.
GFP_NOIO implies __GFP_WAIT.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 7ec89fc..fb4f516 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -421,10 +421,7 @@ xfs_alloc_ioend_bio(
 	struct bio		*bio;
 	int			nvecs = bio_get_nr_vecs(bh->b_bdev);
 
-	do {
-		bio = bio_alloc(GFP_NOIO, nvecs);
-		nvecs >>= 1;
-	} while (!bio);
+	bio = bio_alloc(GFP_NOIO, nvecs);
 
 	ASSERT(bio->bi_private == NULL);
 	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
