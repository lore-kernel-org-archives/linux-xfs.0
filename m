Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N55Cmg136115 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:12 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	T7MTRRHlba3x0jxL for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pbp-0003K5-Ac
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pbp-0003j2-89
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 092/102] xfs: xfs_vm_writepage clear iomap_valid when
Date: Thu, 23 Aug 2012 15:02:50 +1000
Message-Id: <1345698180-13612-93-git-send-email-david@fromorbit.com>
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

From: Alain Renaud <arenaud@sgi.com>

Upstream commit: 66f9311381b4772003d595fb6c518f1647450db0
 !buffer_uptodate (REV2)

On filesytems with a block size smaller than PAGE_SIZE we currently have
a problem with unwritten extents.  If a we have multi-block page for
which an unwritten extent has been allocated, and only some of the
buffers have been written to, and they are not contiguous, we can expose
stale data from disk in the blocks between the writes after extent
conversion.

Example of a page with unwritten and real data.
buffer  content
0       empty  b_state = 0
1       DATA   b_state = 0x1023 Uptodate,Dirty,Mapped,Unwritten
2       DATA   b_state = 0x1023 Uptodate,Dirty,Mapped,Unwritten
3       empty  b_state = 0
4       empty  b_state = 0
5       DATA   b_state = 0x1023 Uptodate,Dirty,Mapped,Unwritten
6       DATA   b_state = 0x1023 Uptodate,Dirty,Mapped,Unwritten
7       empty  b_state = 0

Buffers 1, 2, 5, and 6 have been written to, leaving 0, 3, 4, and 7
empty.  Currently buffers 1, 2, 5, and 6 are added to a single ioend,
and when IO has completed, extent conversion creates a real extent from
block 1 through block 6, leaving 0 and 7 unwritten.  However buffers 3
and 4 were not written to disk, so stale data is exposed from those
blocks on a subsequent read.

Fix this by setting iomap_valid = 0 when we find a buffer that is not
Uptodate.  This ensures that buffers 5 and 6 are not added to the same
ioend as buffers 1 and 2.  Later these blocks will be converted into two
separate real extents, leaving the blocks in between unwritten.

Signed-off-by: Alain Renaud <arenaud@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 33abd52..c16caf2 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1032,10 +1032,15 @@ xfs_vm_writepage(
 				imap_valid = 0;
 			}
 		} else {
-			if (PageUptodate(page)) {
+			if (PageUptodate(page))
 				ASSERT(buffer_mapped(bh));
-				imap_valid = 0;
-			}
+			/*
+			 * This buffer is not uptodate and will not be
+			 * written to disk.  Ensure that we will put any
+			 * subsequent writeable buffers into a new
+			 * ioend.
+			 */
+			imap_valid = 0;
 			continue;
 		}
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
