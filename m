Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N55GSc136155 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:16 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	IIBdMYUSmBGqaEl3 for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:06:02 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pc9-0003Kq-LJ
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:53 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pc9-0003jr-Hf
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 102/102] xfs: handle EOF correctly in xfs_vm_writepage
Date: Thu, 23 Aug 2012 15:03:00 +1000
Message-Id: <1345698180-13612-103-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 6b7a03f03a2f8b1629133e35729eba4727fae3cc

We need to zero out part of a page which beyond EOF before setting uptodate,
otherwise, mapread or write will see non-zero data beyond EOF.

Based on the code in fs/buffer.c and the following ext4 commit:

  ext4: handle EOF correctly in ext4_bio_write_page()

And yes, I wish we had a good test case for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 42eaf00..8c2ed74 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -978,11 +978,26 @@ xfs_vm_writepage(
 	end_index = offset >> PAGE_CACHE_SHIFT;
 	last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
 	if (page->index >= end_index) {
-		if ((page->index >= end_index + 1) ||
-		    !(i_size_read(inode) & (PAGE_CACHE_SIZE - 1))) {
+		unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);
+
+		/*
+		 * Just skip the page if it is fully outside i_size, e.g. due
+		 * to a truncate operation that is in progress.
+		 */
+		if (page->index >= end_index + 1 || offset_into_page == 0) {
 			unlock_page(page);
 			return 0;
 		}
+
+		/*
+		 * The page straddles i_size.  It must be zeroed out on each
+		 * and every writepage invocation because it may be mmapped.
+		 * "A file is mapped in multiples of the page size.  For a file
+		 * that is not a multiple of the  page size, the remaining
+		 * memory is zeroed when mapped, and writes to that region are
+		 * not written out to the file."
+		 */
+		zero_user_segment(page, offset_into_page, PAGE_CACHE_SIZE);
 	}
 
 	end_offset = min_t(unsigned long long,
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
