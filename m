Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o89BB2xs097086 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 06:11:02 -0500
Received: from gir.skynet.ie (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3ABEC5C270
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 04:11:46 -0700 (PDT)
Received: from gir.skynet.ie (gir.skynet.ie [193.1.99.77]) by cuda.sgi.com
	with ESMTP id LJwzmAZDxlQcRGrg for <xfs@oss.sgi.com>;
	Thu, 09 Sep 2010 04:11:46 -0700 (PDT)
Date: Thu, 9 Sep 2010 12:11:32 +0100
From: Mel Gorman <mel@csn.ul.ie>
Subject: [RFC PATCH] fs,xfs: Use __GFP_MOVABLE for XFS buffers
Message-ID: <20100909111131.GO29263@csn.ul.ie>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

Fragmentation avoidance in the kernel depends on reclaimable and movable
allocations being marked-up at page allocation time. Reclaimable allocations
refer to slab caches such as inode caches which can be reclaimed although
not necessarily in a targetted fashion. Movable pages are those pages that
can be moved to backing storage (during page reclaim) or migrated.

When testing against XFS, it was noticed that large page allocation rates
against XFS were far lower than expected in comparison to ext3. Investigation
showed that buffer pages allocated by XFS are placed on the LRU but not
marked __GFP_MOVABLE at allocation time.

This patch updates xb_to_gfp() to specify __GFP_MOVABLE and is correct iff
all pages allocated from a mask derived from xb_to_gfp() are guaranteed to
be movable be it via page reclaim or page migration. It needs an XFS expert
to make that determination but when applied, huge page allocation success
rates are similar to those seen on tests backed by ext3.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index ea79072..93f3fb0 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -67,7 +67,7 @@ struct workqueue_struct *xfsconvertd_workqueue;
 
 #define xb_to_gfp(flags) \
 	((((flags) & XBF_READ_AHEAD) ? __GFP_NORETRY : \
-	  ((flags) & XBF_DONT_BLOCK) ? GFP_NOFS : GFP_KERNEL) | __GFP_NOWARN)
+	  ((flags) & XBF_DONT_BLOCK) ? GFP_NOFS : GFP_KERNEL) | __GFP_NOWARN | __GFP_MOVABLE)
 
 #define xb_to_km(flags) \
 	 (((flags) & XBF_DONT_BLOCK) ? KM_NOFS : KM_SLEEP)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
