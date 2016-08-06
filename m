Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 829C77CDC
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:35:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 452908F8035
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:35:48 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id kG2k0HFHiNgVuHbX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:35:46 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 0AFB120850
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:45 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s6XQS4DGbz104R
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:44 +0200 (CEST)
Message-Id: <903a519209407e8815607e741bf24027b07408ca.1470555003.git.felix.janda@posteo.de>
In-Reply-To: <cover.1470555003.git.felix.janda@posteo.de>
References: <cover.1470555003.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 6 Aug 2016 12:45:45 +0200
Subject: [PATCH xfsprogs 04/14] replace lstat64 by equivalent lstat
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 fsr/xfs_fsr.c    | 4 ++--
 include/darwin.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 2eaf1e7..6099dc2 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -327,7 +327,7 @@ main(int argc, char **argv)
 		for (; optind < argc; optind++) {
 			argname = argv[optind];
 
-			if (lstat64(argname, &sb) < 0) {
+			if (lstat(argname, &sb) < 0) {
 				fprintf(stderr,
 					_("%s: could not stat: %s: %s\n"),
 					progname, argname, strerror(errno));
@@ -510,7 +510,7 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
 	fs = fsbase;
 
 	/* where'd we leave off last time? */
-	if (lstat64(leftofffile, &sb) == 0) {
+	if (lstat(leftofffile, &sb) == 0) {
 		if ( (fd = open(leftofffile, O_RDONLY)) == -1 ) {
 			fsrprintf(_("%s: open failed\n"), leftofffile);
 		}
diff --git a/include/darwin.h b/include/darwin.h
index 1666294..6d24957 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -222,7 +222,6 @@ static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
 #include <sys/ucred.h>
 #include <errno.h>
 #define statvfs64 statfs
-#define lstat64 lstat
 #define		_PATH_MOUNTED   "/etc/mtab"
 
 struct mntent
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
