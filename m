Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35703 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbdH3Ov1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:51:27 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 04/14] fsx: fix path of .fsx* files
Date: Wed, 30 Aug 2017 17:51:36 +0300
Message-Id: <1504104706-11965-5-git-send-email-amir73il@gmail.com>
In-Reply-To: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

When command line arg -P <dirpath> is used, compose the
path for .fsxgood .fsxlog .fsxops files from dirpath and
work file basename.

This fix is ported from LTP.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 ltp/fsx.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 572df75..1502905 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1581,7 +1581,7 @@ usage(void)
 "	-L: fsxLite - no file creations & no file size changes\n\
 	-N numops: total # operations to do (default infinity)\n\
 	-O: use oplen (see -o flag) for every op (default random)\n\
-	-P: save .fsxlog and .fsxgood files in dirpath (default ./)\n\
+	-P: save .fsxlog .fsxops and .fsxgood files in dirpath (default ./)\n\
 	-S seed: for random # generator (default 1) 0 gets timestamp\n\
 	-W: mapped write operations DISabled\n\
         -R: read() system calls only (mapped reads disabled)\n\
@@ -1761,6 +1761,7 @@ main(int argc, char **argv)
 	char	*endp;
 	char goodfile[1024];
 	char logfile[1024];
+	int dirpath = 0;
 	struct stat statbuf;
 
 	goodfile[0] = 0;
@@ -1902,6 +1903,9 @@ main(int argc, char **argv)
 			strcat(goodfile, "/");
 			strncpy(logfile, optarg, sizeof(logfile));
 			strcat(logfile, "/");
+			strncpy(opsfile, optarg, sizeof(logfile));
+			strcat(opsfile, "/");
+			dirpath = 1;
 			break;
                 case 'R':
                         mapped_reads = 0;
@@ -1978,21 +1982,21 @@ main(int argc, char **argv)
 		}
 	}
 #endif
-	strncat(goodfile, fname, 256);
+	strncat(goodfile, dirpath ? basename(fname) : fname, 256);
 	strcat (goodfile, ".fsxgood");
 	fsxgoodfd = open(goodfile, O_RDWR|O_CREAT|O_TRUNC, 0666);
 	if (fsxgoodfd < 0) {
 		prterr(goodfile);
 		exit(92);
 	}
-	strncat(logfile, fname, 256);
+	strncat(logfile, dirpath ? basename(fname) : fname, 256);
 	strcat (logfile, ".fsxlog");
 	fsxlogf = fopen(logfile, "w");
 	if (fsxlogf == NULL) {
 		prterr(logfile);
 		exit(93);
 	}
-	strncat(opsfile, fname, 256);
+	strncat(opsfile, dirpath ? basename(fname) : fname, 256);
 	strcat(opsfile, ".fsxops");
 	unlink(opsfile);
 
-- 
2.7.4

