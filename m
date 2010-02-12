Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CKmYkT026463 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:48:35 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201002122049.o1CKnjAf024589@stout.americas.sgi.com>
Date: Fri, 12 Feb 2010 14:49:45 -0600
Subject: [PATCH] xfsprogs: fix some warnings
MIME-Version: 1.0
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

Fix a couple of build warnings.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 ltp/fsx.c    |    2 +-
 src/loggen.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: b/ltp/fsx.c
===================================================================
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1038,7 +1038,7 @@ __aio_rw(int rw, int fd, char *buf, unsi
 			fprintf(stderr, "bad io length: %lu instead of %u\n",
 					res, len);
 		else {
-			fprintf(stderr, "errcode=%d\n", -res);
+			fprintf(stderr, "errcode=%ld\n", -res);
 			fprintf(stderr, "aio_rw: async io failed: %s\n",
 					strerror(-res));
 			ret = res;
Index: b/src/loggen.c
===================================================================
--- a/src/loggen.c
+++ b/src/loggen.c
@@ -240,6 +240,7 @@ loggen_empty(int count)
     blfs.blf_type       = XFS_LI_BUF;
     blfs.blf_size       = 2;
     blfs.blf_flags      = XFS_BLI_CANCEL;
+    blfs.blf_len        = 0;
     blfs.blf_blkno      = 1;
     blfs.blf_map_size   = 1;
     blfs.blf_data_map[0]= 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
