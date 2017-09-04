Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51804 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753120AbdIDBSL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 21:18:11 -0400
Date: Sun, 3 Sep 2017 18:18:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/2] libxfs: remove getcwd/chdir dance from initialization
Message-ID: <20170904011806.GA4660@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Back in the old days of Irix, the library saved and restored chdir so
that (I guess?) check_open can change directory without screwing up our
ability to use relative paths.  However, there's nothing in Linux that
actually does this, so just rip out the getcwd/chdir stuff since we
absolute device paths work just fine without it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/init.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index d77a9e6..15e8bbb 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -240,13 +240,11 @@ int
 libxfs_init(libxfs_init_t *a)
 {
 	char		*blockfile;
-	char		curdir[MAXPATHLEN];
 	char		*dname;
 	char		dpath[25];
 	int		fd;
 	char		*logname;
 	char		logpath[25];
-	int		needcd;
 	char		*rawfile;
 	char		*rtname;
 	char		rtpath[25];
@@ -262,8 +260,6 @@ libxfs_init(libxfs_init_t *a)
 	a->dsize = a->lbsize = a->rtbsize = 0;
 	a->dbsize = a->logBBsize = a->logBBstart = a->rtsize = 0;
 
-	(void)getcwd(curdir,MAXPATHLEN);
-	needcd = 0;
 	fd = -1;
 	flags = (a->isreadonly | a->isdirect);
 
@@ -277,14 +273,11 @@ libxfs_init(libxfs_init_t *a)
 	if (a->volname) {
 		if(!check_open(a->volname,flags,&rawfile,&blockfile))
 			goto done;
-		needcd = 1;
 		fd = open(rawfile, O_RDONLY);
 		dname = a->dname = a->volname;
 		a->volname = NULL;
 	}
 	if (dname) {
-		if (dname[0] != '/' && needcd)
-			chdir(curdir);
 		if (a->disfile) {
 			a->ddev= libxfs_device_open(dname, a->dcreat, flags,
 						    a->setblksize);
@@ -300,12 +293,9 @@ libxfs_init(libxfs_init_t *a)
 			platform_findsizes(rawfile, a->dfd,
 					   &a->dsize, &a->dbsize);
 		}
-		needcd = 1;
 	} else
 		a->dsize = 0;
 	if (logname) {
-		if (logname[0] != '/' && needcd)
-			chdir(curdir);
 		if (a->lisfile) {
 			a->logdev = libxfs_device_open(logname,
 					a->lcreat, flags, a->setblksize);
@@ -321,12 +311,9 @@ libxfs_init(libxfs_init_t *a)
 			platform_findsizes(rawfile, a->logfd,
 					   &a->logBBsize, &a->lbsize);
 		}
-		needcd = 1;
 	} else
 		a->logBBsize = 0;
 	if (rtname) {
-		if (rtname[0] != '/' && needcd)
-			chdir(curdir);
 		if (a->risfile) {
 			a->rtdev = libxfs_device_open(rtname,
 					a->rcreat, flags, a->setblksize);
@@ -342,7 +329,6 @@ libxfs_init(libxfs_init_t *a)
 			platform_findsizes(rawfile, a->rtfd,
 					   &a->rtsize, &a->rtbsize);
 		}
-		needcd = 1;
 	} else
 		a->rtsize = 0;
 	if (a->dsize < 0) {
@@ -360,8 +346,6 @@ libxfs_init(libxfs_init_t *a)
 			progname);
 		goto done;
 	}
-	if (needcd)
-		chdir(curdir);
 	if (!libxfs_bhash_size)
 		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
 	libxfs_bcache = cache_init(a->bcache_flags, libxfs_bhash_size,
