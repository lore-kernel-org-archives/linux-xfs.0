Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TCOKRM092059 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 07:24:20 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HMgH0XfPqRV2b6XB for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 05:24:19 -0700 (PDT)
Received: from [192.168.1.2] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SDEOo-0003fF-Hb
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:24:18 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SDEOT-0003NU-Ks
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:23:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/8] xfs: fix incorrect b_offset initialisation
Date: Thu, 29 Mar 2012 23:23:49 +1100
Message-Id: <1333023835-12856-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1333023835-12856-1-git-send-email-david@fromorbit.com>
References: <1333023835-12856-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_buf.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2122b0f..9063461 100644
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
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
