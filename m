Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3S6olRa210791 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 01:50:48 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED0371D48AAB
	for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 23:52:51 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id k4AQVFmygbnlvr6N for
	<xfs@oss.sgi.com>; Tue, 27 Apr 2010 23:52:51 -0700 (PDT)
From: Tao Ma <tao.ma@oracle.com>
Subject: [PATCH] xfstests: Add query fiemap count test.
Date: Wed, 28 Apr 2010 14:50:50 +0800
Message-Id: <1272437450-4654-1-git-send-email-tao.ma@oracle.com>
In-Reply-To: <20100428015035.GC9783@dastard>
References: <20100428015035.GC9783@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>, Tao Ma <tao.ma@oracle.com>, Alex Elder <aelder@sgi.com>

According to Documentation/filesystems/fiemap.txt, If fm_extent_count
is zero, then the fm_extents[] array is ignored (no extents will be
returned), and the fm_mapped_extents count will hold the number of
extents needed.

This is broken by commit 97db39a1f6f69e906e98118392400de5217aa33a.
So add this test case in fiemap tester to avoid future regression.

Cc: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alex Elder <aelder@sgi.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 src/fiemap-tester.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
index 8be7ddf..9d57a7e 100644
--- a/src/fiemap-tester.c
+++ b/src/fiemap-tester.c
@@ -406,6 +406,20 @@ check_hole(struct fiemap *fiemap, int fd, __u64 logical_offset, int blocksize)
 	return 0;
 }
 
+static int query_fiemap_count(int fd, int blocks, int blocksize)
+{
+	struct fiemap fiemap = { 0, };
+
+	fiemap.fm_length = blocks * blocksize;
+
+	if (ioctl(fd, FS_IOC_FIEMAP, (unsigned long)&fiemap) < 0) {
+		perror("FIEMAP query ioctl failed");
+		return -1;
+	}
+
+	return 0;
+}
+
 static int
 compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize)
 {
@@ -415,6 +429,9 @@ compare_fiemap_and_map(int fd, char *map, int blocks, int blocksize)
 	__u64 map_start, map_length;
 	int i, c;
 
+	if (query_fiemap_count(fd, blocks, blocksize) < 0)
+		return -1;
+
 	blocks_to_map = (random() % blocks) + 1;
 	fiebuf = malloc(sizeof(struct fiemap) +
 			(blocks_to_map * sizeof(struct fiemap_extent)));
-- 
1.6.3.3.334.g916e1.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
