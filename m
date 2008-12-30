Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUN9Foi007376 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 17:09:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDC6917996E4
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 15:09:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id OEpBlETy6ViRiH40 for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 15:09:13 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LHni5-0000Gg-2z
	for xfs@oss.sgi.com; Tue, 30 Dec 2008 23:09:13 +0000
Message-Id: <20081230230912.986540000@bombadil.infradead.org>
References: <20081230230810.986105000@bombadil.infradead.org>
Date: Tue, 30 Dec 2008 18:08:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] xfstests: fix compiler warnings
Content-Disposition: inline; filename=xfstests-compile-warnings
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Include all nessecary headers, use the correct format strings and don't
redefine _GNU_SOURCE.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests/dmapi/src/suite2/src/mmap.c
===================================================================
--- xfstests/dmapi/src/suite2/src/mmap.c	2008-12-30 14:49:11.000000000 +0000
+++ xfstests/dmapi/src/suite2/src/mmap.c	2008-12-30 14:49:18.000000000 +0000
@@ -41,6 +41,7 @@
 #include <string.h>
 #include <errno.h>
 #include <getopt.h>
+#include <stdlib.h>
 
 
 char * Progname;
Index: xfstests/src/ftrunc.c
===================================================================
--- xfstests/src/ftrunc.c	2008-12-30 14:40:01.000000000 +0000
+++ xfstests/src/ftrunc.c	2008-12-30 14:40:49.000000000 +0000
@@ -21,6 +21,8 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
 
 int
 main(argc, argv)
Index: xfstests/src/trunc.c
===================================================================
--- xfstests/src/trunc.c	2008-12-30 14:40:51.000000000 +0000
+++ xfstests/src/trunc.c	2008-12-30 14:43:15.000000000 +0000
@@ -23,6 +23,8 @@
 #include <errno.h>
 #include <time.h>
 #include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
 
 #define O_DIRECT	040000
 
@@ -65,10 +67,10 @@
 		}
 	}
 
-	err = posix_memalign(&buf, ALIGNMENT, BUFSIZE);
+	err = posix_memalign((void **)&buf, ALIGNMENT, BUFSIZE);
 	if (err < 0) perror("posix_memalign failed");
 
-	err = posix_memalign(&goodbuf, ALIGNMENT, BUFSIZE);
+	err = posix_memalign((void **)&goodbuf, ALIGNMENT, BUFSIZE);
 	if (err < 0) perror("posix_memalign failed");
 
 	err = unlink(filename);
Index: xfstests/src/looptest.c
===================================================================
--- xfstests/src/looptest.c	2008-12-30 14:51:21.000000000 +0000
+++ xfstests/src/looptest.c	2008-12-30 14:51:31.000000000 +0000
@@ -28,8 +28,6 @@
  
 /* dxm - 28/2/2 */
 
-#define _GNU_SOURCE
-
 #include <stdio.h>
 #include <stdlib.h>
 #include <malloc.h>
Index: xfstests/src/bulkstat_unlink_test.c
===================================================================
--- xfstests/src/bulkstat_unlink_test.c	2008-12-30 14:53:09.000000000 +0000
+++ xfstests/src/bulkstat_unlink_test.c	2008-12-30 14:53:37.000000000 +0000
@@ -164,7 +164,7 @@
 				for (j=0; j < nfiles; j += stride) {
 					if (ret[i].bs_ino == inodelist[j]) {
 						/* oops ... */
-						printf("failed. Unlinked inode %ld returned by bulkstat\n", inodelist[j]);
+						printf("failed. Unlinked inode %llu returned by bulkstat\n", (unsigned long long)inodelist[j]);
 						exit(1);
 					}
 				}
Index: xfstests/src/bulkstat_unlink_test_modified.c
===================================================================
--- xfstests/src/bulkstat_unlink_test_modified.c	2008-12-30 14:52:02.000000000 +0000
+++ xfstests/src/bulkstat_unlink_test_modified.c	2008-12-30 14:52:22.000000000 +0000
@@ -160,9 +160,10 @@
 		    if ((ret[i].bs_ino == inodelist[j]) &&
 			(ret[i].bs_gen == genlist[j])) {
 			/* oops, the same inode with old gen number */
-			printf("Unlinked inode %ld with generation %d "
+			printf("Unlinked inode %llu with generation %d "
 			       "returned by bulkstat\n",
-				inodelist[j], genlist[j]);
+				(unsigned long long)inodelist[j],
+				 genlist[j]);
 			exit(1);
 		    }
 		    if ((ret[i].bs_ino == inodelist[j])) {
Index: xfstests/src/locktest.c
===================================================================
--- xfstests/src/locktest.c	2008-12-30 14:54:51.000000000 +0000
+++ xfstests/src/locktest.c	2008-12-30 14:55:24.000000000 +0000
@@ -797,7 +797,7 @@
     int		c;
     struct sockaddr_in	myAddr;
     struct linger	noLinger = {1, 0};
-    char	*host;
+    char	*host = NULL;
     char	*endnum;
     int		errflag = 0;
     char	*p;
Index: xfstests/src/makeextents.c
===================================================================
--- xfstests/src/makeextents.c	2008-12-30 14:55:38.000000000 +0000
+++ xfstests/src/makeextents.c	2008-12-30 14:58:16.000000000 +0000
@@ -119,7 +119,9 @@
 				return 1;
 			}
 			if (verbose_opt) {
-				printf("truncating back to %lu\n", NUMHOLES_TO_SIZE(num_holes));
+				printf("truncating back to %llu\n",
+				       (unsigned long long)
+					NUMHOLES_TO_SIZE(num_holes));
 			}
 			return 0;
 		}
@@ -128,7 +130,8 @@
 		curr_holes = 0;
 	}
 	if (curr_holes != 0 && verbose_opt) {
-		printf("creating %lu more holes\n", num_holes - curr_holes);
+		printf("creating %llu more holes\n",
+			(unsigned long long)num_holes - curr_holes);
 	}
 		
 	/* create holes by seeking and writing */
@@ -147,7 +150,8 @@
 		}
 
 		if (verbose_opt && ((i+1) % status_num == 0)) {
-			printf("seeked and wrote %lu times\n", i+1);
+			printf("seeked and wrote %llu times\n",
+				(unsigned long long)i + 1);
 		}
 	}
 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
