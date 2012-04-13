Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DCBRX7037944 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 07:11:27 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IoDX4tAY579ahoO7 for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 05:11:25 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SIfLO-00030u-3p
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:14 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SIfLE-0003OD-0s
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/18] xfs: fix incorrect b_offset initialisation
Date: Fri, 13 Apr 2012 22:10:51 +1000
Message-Id: <1334319061-12968-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-1-git-send-email-david@fromorbit.com>
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Because we no longer use the page cache for buffering, there is no
direct block number to page offset relationship anymore.
xfs_buf_get_pages is still setting up b_offset as if there was some
relationship, and that is leading to incorrectly setting up
*uncached* buffers that don't overwrite b_offset once they've had
pages allocated.

For cached buffers, the first block of the buffer is always at offset
zero into the allocated memory. This is true for sub-page sized
buffers, as well as for multiple-page buffers.

For uncached buffers, b_offset is only non-zero when we are
associating specific memory to the buffers, and that is set
correctly by the code setting up the buffer.

Hence remove the setting of b_offset in xfs_buf_get_pages, because
it is now always the wrong thing to do.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_buf.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 841eec3..e7dab7d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -221,7 +221,6 @@ _xfs_buf_get_pages(
 {
 	/* Make sure that we have a page list */
 	if (bp->b_pages == NULL) {
-		bp->b_offset = xfs_buf_poff(bp->b_file_offset);
 		bp->b_page_count = page_count;
 		if (page_count <= XB_PAGES) {
 			bp->b_pages = bp->b_page_array;
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
