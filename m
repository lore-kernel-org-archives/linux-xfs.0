Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4EEA87CD2
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 12:26:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C49C3AC002
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:59 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id GHL5XaohaXy5q3sL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:58 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 0444920470
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:57 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3sBTDh3hQjz104J
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:56 +0200 (CEST)
Resent-Message-ID: <20160813172459.GJ3858@nyan>
Resent-To: xfs@oss.sgi.com
Message-Id: <fed5ab5ee1d11271fb94baf795e6372b0b4d06d0.1471107858.git.felix.janda@posteo.de>
In-Reply-To: <cover.1471107858.git.felix.janda@posteo.de>
References: <cover.1471107858.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 13 Aug 2016 18:22:27 +0200
Subject: [PATCHv2 xfsprogs 12/14] replace statvfs64 by equivalent statvfs
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
 fsr/xfs_fsr.c    | 8 ++++----
 include/darwin.h | 1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 9cffa1b..517b75f 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -89,7 +89,7 @@ static void fsrallfs(char *mtab, int howlong, char *leftofffile);
 static void fsrall_cleanup(int timeout);
 static int  getnextents(int);
 int xfsrtextsize(int fd);
-int xfs_getrt(int fd, struct statvfs64 *sfbp);
+int xfs_getrt(int fd, struct statvfs *sfbp);
 char * gettmpname(char *fname);
 char * getparent(char *fname);
 int fsrprintf(const char *fmt, ...);
@@ -888,7 +888,7 @@ fsrfile_common(
 	xfs_bstat_t	*statp)
 {
 	int		error;
-	struct statvfs64 vfss;
+	struct statvfs  vfss;
 	struct fsxattr	fsx;
 	unsigned long	bsize;
 
@@ -940,7 +940,7 @@ fsrfile_common(
 	 * Note that xfs_bstat.bs_blksize returns the filesystem blocksize,
 	 * not the optimal I/O size as struct stat.
 	 */
-	if (statvfs64(fsname ? fsname : fname, &vfss) < 0) {
+	if (statvfs(fsname ? fsname : fname, &vfss) < 0) {
 		fsrprintf(_("unable to get fs stat on %s: %s\n"),
 			fname, strerror(errno));
 		return -1;
@@ -1700,7 +1700,7 @@ xfs_getgeom(int fd, xfs_fsop_geom_v1_t * fsgeom)
  * Get xfs realtime space information
  */
 int
-xfs_getrt(int fd, struct statvfs64 *sfbp)
+xfs_getrt(int fd, struct statvfs *sfbp)
 {
 	unsigned long	bsize;
 	unsigned long	factor;
diff --git a/include/darwin.h b/include/darwin.h
index fb13915..495b44b 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -216,7 +216,6 @@ static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
 #  include <sys/param.h>
 #include <sys/ucred.h>
 #include <errno.h>
-#define statvfs64	statfs
 #define		_PATH_MOUNTED   "/etc/mtab"
 
 struct mntent
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
