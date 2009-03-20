Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2K7RSbq148324 for <xfs@oss.sgi.com>; Fri, 20 Mar 2009 02:27:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D82A51C58AAE
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2009 00:26:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DmI6LJfQs00pNu5u for
	<xfs@oss.sgi.com>; Fri, 20 Mar 2009 00:26:49 -0700 (PDT)
Date: Fri, 20 Mar 2009 03:26:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs_io: fix extent array reallocation
Message-ID: <20090320072618.GA26571@infradead.org>
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
To: xfs@oss.sgi.com, moosh009@gmail.com

From: Tomasz Majkowski <moosh009@gmail.com>

The XFS_IOC_FSGETXATTRA ioctl only returns the number of allocated
extents, so when we reallocate the extent array in the bmap command
we have to account for the worst case where there is a whole between
each two allocated extents.  Also add some slack to that case to
allow for a file growing while we are racing with it.


Index: xfsprogs-dev/io/bmap.c
===================================================================
--- xfsprogs-dev.orig/io/bmap.c	2009-03-20 06:28:33.000000000 +0000
+++ xfsprogs-dev/io/bmap.c	2009-03-20 06:29:52.000000000 +0000
@@ -217,8 +217,8 @@
 			exitcode = 1;
 			return 0;
 		}
-		if (fsx.fsx_nextents >= map_size-1) {
-			map_size = 2*(fsx.fsx_nextents+1);
+		if (2 * fsx.fsx_nextents > map_size) {
+			map_size = 2 * fsx.fsx_nextents + 1;
 			map = realloc(map, map_size*sizeof(*map));
 			if (map == NULL) {
 				fprintf(stderr,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
