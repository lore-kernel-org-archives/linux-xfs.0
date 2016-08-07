Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9DE607CE1
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:35:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 42E7A304048
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:35:51 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id P7lOYlh7p99psCMZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:35:49 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 5522D20A85
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:48 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s6XQW6LB0z104K
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:47 +0200 (CEST)
Message-Id: <f4fc0b97ae8cdb30f1e0b0d55521f136877b33f5.1470555003.git.felix.janda@posteo.de>
In-Reply-To: <cover.1470555003.git.felix.janda@posteo.de>
References: <cover.1470555003.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sun, 7 Aug 2016 08:24:40 +0200
Subject: [PATCH xfsprogs 11/14] replace statvfs64 by equivalent statvfs
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

For this it was necessary to change a workaround for missing
f_brsize on Mac OS X.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 fsr/xfs_fsr.c    | 16 ++++------------
 include/darwin.h |  4 ++--
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 98390e7..f3cc07e 100644
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
+	struct statvfs vfss;
 	struct fsxattr	fsx;
 	unsigned long	bsize;
 
@@ -940,16 +940,12 @@ fsrfile_common(
 	 * Note that xfs_bstat.bs_blksize returns the filesystem blocksize,
 	 * not the optimal I/O size as struct stat.
 	 */
-	if (statvfs64(fsname ? fsname : fname, &vfss) < 0) {
+	if (statvfs(fsname ? fsname : fname, &vfss) < 0) {
 		fsrprintf(_("unable to get fs stat on %s: %s\n"),
 			fname, strerror(errno));
 		return -1;
 	}
-#ifndef statvfs64
 	bsize = vfss.f_frsize ? vfss.f_frsize : vfss.f_bsize;
-#else
-	bsize = vfss.f_bsize;
-#endif
 	if (statp->bs_blksize * statp->bs_blocks >
 	    vfss.f_bfree * bsize - minimumfree) {
 		fsrprintf(_("insufficient freespace for: %s: "
@@ -1704,7 +1700,7 @@ xfs_getgeom(int fd, xfs_fsop_geom_v1_t * fsgeom)
  * Get xfs realtime space information
  */
 int
-xfs_getrt(int fd, struct statvfs64 *sfbp)
+xfs_getrt(int fd, struct statvfs *sfbp)
 {
 	unsigned long	bsize;
 	unsigned long	factor;
@@ -1717,11 +1713,7 @@ xfs_getrt(int fd, struct statvfs64 *sfbp)
 		close(fd);
 		return -1;
 	}
-#ifndef statvfs64
 	bsize = (sfbp->f_frsize ? sfbp->f_frsize : sfbp->f_bsize);
-#else
-	bsize = sfbp->f_bsize;
-#endif
 	factor = fsgeom.blocksize / bsize;         /* currently this is == 1 */
 	sfbp->f_bfree = (cnt.freertx * fsgeom.rtextsize) * factor;
 	return 0;
diff --git a/include/darwin.h b/include/darwin.h
index fb13915..bd1a112 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -216,8 +216,8 @@ static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
 #  include <sys/param.h>
 #include <sys/ucred.h>
 #include <errno.h>
-#define statvfs64	statfs
-#define		_PATH_MOUNTED   "/etc/mtab"
+#define f_frsize	f_bsize
+#define _PATH_MOUNTED	"/etc/mtab"
 
 struct mntent
 {
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
