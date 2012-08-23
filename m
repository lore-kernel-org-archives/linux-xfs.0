Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54VsS135792 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:32 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kT707sTTdkYIoqME for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:17 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbU-0003JM-Uo
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:12 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbK-0003iF-Rm
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 083/102] xfs: fix incorrect b_offset initialisation
Date: Thu, 23 Aug 2012 15:02:41 +1000
Message-Id: <1345698180-13612-84-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

Upstream commit: ead360c50d33772f45943792893a58865adf3638

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
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 5487eaa..3e9946c 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -219,7 +219,6 @@ _xfs_buf_get_pages(
 {
 	/* Make sure that we have a page list */
 	if (bp->b_pages == NULL) {
-		bp->b_offset = xfs_buf_poff(bp->b_file_offset);
 		bp->b_page_count = page_count;
 		if (page_count <= XB_PAGES) {
 			bp->b_pages = bp->b_page_array;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
