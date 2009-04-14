Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3EBAeVq182391 for <xfs@oss.sgi.com>; Tue, 14 Apr 2009 06:10:51 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH 5/6] Handle possible bio_alloc failure in xfs
Date: Tue, 14 Apr 2009 16:36:45 +0530
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904141636.45463.knikanth@suse.de>
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
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Handle bio_alloc failure in xfs.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
@@ -1196,6 +1196,8 @@ _xfs_buf_ioapply(
 	      (XBF_READ|_XBF_PAGE_LOCKED)) &&
 	    (blocksize >= PAGE_CACHE_SIZE)) {
 		bio = bio_alloc(GFP_NOIO, 1);
+		if (unlikely(!bio))
+			goto out_enomem;
 
 		bio->bi_bdev = bp->b_target->bt_bdev;
 		bio->bi_sector = sector - (offset >> BBSHIFT);
@@ -1217,6 +1219,9 @@ next_chunk:
 		nr_pages = total_nr_pages;
 
 	bio = bio_alloc(GFP_NOIO, nr_pages);
+	if (unlikely(!bio))
+		goto out_enomem;
+
 	bio->bi_bdev = bp->b_target->bt_bdev;
 	bio->bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
@@ -1247,6 +1252,11 @@ submit_io:
 		bio_put(bio);
 		xfs_buf_ioerror(bp, EIO);
 	}
+	return;
+
+out_enomem:
+	xfs_buf_ioerror(bp, ENOMEM);
+	
 }
 
 int



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
