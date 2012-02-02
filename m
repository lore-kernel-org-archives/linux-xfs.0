Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q126LfEl035529 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 00:21:42 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Ud0DBq1XqWIQk74n for <xfs@oss.sgi.com>;
	Wed, 01 Feb 2012 22:21:38 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Rsq2v-0002L3-Qs
	for xfs@oss.sgi.com; Thu, 02 Feb 2012 17:21:25 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1Rsq2k-0002SU-4N
	for xfs@oss.sgi.com; Thu, 02 Feb 2012 17:21:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_io: fix fiemap loop continuation
Date: Thu,  2 Feb 2012 17:21:14 +1100
Message-Id: <1328163674-9420-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When the fiemap command needs to retrieve more extents from the
kernel via a subsequent IO, it calculates the next logical block to
retrieve in file system block units. the fiemap needs the start
offset in bytes, not filesystem blocks.  Hence if the fiemap command
can loop forever retrieving the same blocks if the logical offset
offset of the next block in filesystem block units is smaller than
the number of bytes in a filessytem block. i.e. it will just loop
retreiving the first 32 extents from offset block zero.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 io/fiemap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index 066e693..99296dd 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -108,7 +108,7 @@ print_verbose(
 	       boff_w, bbuf, tot_w, len, flg_w, flgbuf);
 
 	(*cur_extent)++;
-	*last_logical = lstart + len;
+	*last_logical = extent->fe_logical + extent->fe_length;
 }
 
 static void
@@ -151,7 +151,7 @@ print_plain(
 	else
 		printf("\n");
 	(*cur_extent)++;
-	*last_logical = lstart + len;
+	*last_logical = extent->fe_logical + extent->fe_length;
 }
 
 int
@@ -252,7 +252,7 @@ fiemap_f(
 		memset(fiemap, 0, map_size);
 		fiemap->fm_flags = fiemap_flags;
 		fiemap->fm_start = last_logical;
-		fiemap->fm_length = -1;
+		fiemap->fm_length = -1LL;
 		fiemap->fm_extent_count = num_extents;
 
 		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
-- 
1.7.8.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
