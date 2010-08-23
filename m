Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7N4hLDs111135 for <xfs@oss.sgi.com>; Sun, 22 Aug 2010 23:43:22 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BE841753408
	for <xfs@oss.sgi.com>; Sun, 22 Aug 2010 21:43:52 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	sDKn5GZCROJ3Et5i for <xfs@oss.sgi.com>;
	Sun, 22 Aug 2010 21:43:52 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] writeback: write_cache_pages doesn't terminate at nr_to_write
	<= 0
Date: Mon, 23 Aug 2010 14:43:40 +1000
Message-Id: <1282538620-10824-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

I noticed XFS writeback in 2.6.36-rc1 was much slower than it should have
been. Enabling writeback tracing showed:

    flush-253:16-8516  [007] 1342952.351608: wbc_writepage: bdi 253:16: towrt=1024 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-8516  [007] 1342952.351654: wbc_writepage: bdi 253:16: towrt=1023 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-8516  [000] 1342952.369520: wbc_writepage: bdi 253:16: towrt=0 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-8516  [000] 1342952.369542: wbc_writepage: bdi 253:16: towrt=-1 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
    flush-253:16-8516  [000] 1342952.369549: wbc_writepage: bdi 253:16: towrt=-2 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0

Writeback is not terminating in background writeback if ->writepage is
returning with wbc->nr_to_write == 0, resulting in sub-optimal single page
writeback on XFS.

Fix the write_cache_pages loop to terminate correctly when this situation
occurs and so prevent this sub-optimal background writeback pattern. This
improves sustained sequential buffered write performance from around
250MB/s to 750MB/s for a 100GB file on an XFS filesystem on my 8p test VM.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mm/page-writeback.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7262aac..f069782 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -984,22 +984,16 @@ continue_unlock:
 				}
 			}
 
-			if (wbc->nr_to_write > 0) {
-				if (--wbc->nr_to_write == 0 &&
-				    wbc->sync_mode == WB_SYNC_NONE) {
-					/*
-					 * We stop writing back only if we are
-					 * not doing integrity sync. In case of
-					 * integrity sync we have to keep going
-					 * because someone may be concurrently
-					 * dirtying pages, and we might have
-					 * synced a lot of newly appeared dirty
-					 * pages, but have not synced all of the
-					 * old dirty pages.
-					 */
-					done = 1;
-					break;
-				}
+			/*
+			 * We stop writing back only if we are not doing
+			 * integrity sync. In case of integrity sync we have to
+			 * keep going until we have written all the pages
+			 * we tagged for writeback prior to entering this loop.
+			 */
+			if (--wbc->nr_to_write <= 0 &&
+			    wbc->sync_mode == WB_SYNC_NONE) {
+				done = 1;
+				break;
 			}
 		}
 		pagevec_release(&pvec);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
