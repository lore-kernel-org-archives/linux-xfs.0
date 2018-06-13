Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56516 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935719AbeFMWvC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jun 2018 18:51:02 -0400
Date: Wed, 13 Jun 2018 15:50:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] generic/223: port t_stripealign to FIEMAP
Message-ID: <20180613225057.GB9432@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Since XFS has deprecated FIBMAP on FSDAX filesystems, we can't use
FIBMAP to verify stripe alignment anymore.  FIEMAP has existed for quite
some time now, so port it to use that instead, and only fall back to
FIBMAP if FIEMAP doesn't exist.

Tested-by: ross.zwisler@linux.intel.com
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 src/t_stripealign.c |   72 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 61 insertions(+), 11 deletions(-)

diff --git a/src/t_stripealign.c b/src/t_stripealign.c
index 05ed36b5..690f743a 100644
--- a/src/t_stripealign.c
+++ b/src/t_stripealign.c
@@ -17,8 +17,13 @@
 #include <fcntl.h>
 #include <stdio.h>
 #include <sys/ioctl.h>
+#include <linux/fiemap.h>
+#include <linux/fs.h>
 
-#define FIBMAP          _IO(0x00, 1)    /* bmap access */
+#define FIEMAP_EXTENT_ACCEPTABLE	(FIEMAP_EXTENT_LAST | \
+		FIEMAP_EXTENT_DATA_ENCRYPTED | FIEMAP_EXTENT_ENCODED | \
+		FIEMAP_EXTENT_UNWRITTEN | FIEMAP_EXTENT_MERGED | \
+		FIEMAP_EXTENT_SHARED)
 
 /*
  * If only filename given, print first block.
@@ -28,11 +33,14 @@
 
 int main(int argc, char ** argv)
 {
-	int	fd;
-	int	ret;
-	int	sunit = 0;	/* in blocks */
-	char	*filename;
-	unsigned int	block = 0;
+	struct stat		sb;
+	struct fiemap		*fie;
+	struct fiemap_extent	*fe;
+	int			fd;
+	int			ret;
+	int			sunit = 0;	/* in blocks */
+	char			*filename;
+	unsigned long long	block;
 
         if (argc < 3) {
                 printf("Usage: %s <filename> <sunit in blocks>\n", argv[0]);
@@ -48,21 +56,63 @@ int main(int argc, char ** argv)
                 return 1;
         }
 
-	ret = ioctl(fd, FIBMAP, &block);
-	if (ret < 0) {
+	ret = fstat(fd, &sb);
+	if (ret) {
+		perror(filename);
 		close(fd);
-		perror("fibmap");
 		return 1;
 	}
 
-	close(fd);
+	fie = calloc(1, sizeof(struct fiemap) + sizeof(struct fiemap_extent));
+	if (!fie) {
+		close(fd);
+		perror("malloc");
+		return 1;
+	}
+	fie->fm_length = 1;
+	fie->fm_flags = FIEMAP_FLAG_SYNC;
+	fie->fm_extent_count = 1;
+
+	ret = ioctl(fd, FS_IOC_FIEMAP, fie);
+	if (ret < 0) {
+		unsigned int	bmap = 0;
+
+		ret = ioctl(fd, FIBMAP, &bmap);
+		if (ret < 0) {
+			perror("fibmap");
+			free(fie);
+			close(fd);
+			return 1;
+		}
+		block = bmap;
+		goto check;
+	}
 
+
+	if (fie->fm_mapped_extents != 1) {
+		printf("%s: no extents?\n", filename);
+		free(fie);
+		close(fd);
+		return 1;
+	}
+	fe = &fie->fm_extents[0];
+	if (fe->fe_flags & ~FIEMAP_EXTENT_ACCEPTABLE) {
+		printf("%s: bad flags 0x%x\n", filename, fe->fe_flags);
+		free(fie);
+		close(fd);
+		return 1;
+	}
+
+	block = fie->fm_extents[0].fe_physical / sb.st_blksize;
+check:
 	if (block % sunit) {
-		printf("%s: Start block %u not multiple of sunit %u\n",
+		printf("%s: Start block %llu not multiple of sunit %u\n",
 			filename, block, sunit);
 		return 1;
 	} else
 		printf("%s: well-aligned\n", filename);
+	free(fie);
+	close(fd);
 
 	return 0;
 }
