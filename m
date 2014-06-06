Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 680227F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 14:21:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3DCBA304062
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 12:21:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YYuKkhlzwSMxAn7C for <xfs@oss.sgi.com>;
	Fri, 06 Jun 2014 12:21:20 -0700 (PDT)
Message-ID: <539214B4.7010303@sandeen.net>
Date: Fri, 06 Jun 2014 14:21:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2 V3] mkfs.xfs: don't call blkid_get_topology on existing
	regular files
References: <53852A05.5040006@redhat.com>
In-Reply-To: <53852A05.5040006@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

If we encounter a target that's really a regular file,
even without "-d file..." on the cmdline, call
platform_findsizes() instead of blkid_get_topology to
try to discover the "sector size" via the fsgeom() call.

Otherwise mkfs.xfs will try to do direct IO with a default
512 sector size, and if the underlying file has different
DIO requirements, mkfs will fail.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V3: only call platform_findsizes if xi->disfile isn't set,
and our target is a regular file: i.e. only in the 
"mkfs.xfs <existing regular file>" case.

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 188b6b3..c85258a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -457,11 +457,30 @@ static void get_topology(
 	int			force_overwrite)
 {
 	if (!xi->disfile) {
-		const char *dfile = xi->volname ? xi->volname : xi->dname;
+		char *dfile = xi->volname ? xi->volname : xi->dname;
+		struct stat statbuf;
 
-		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
-				   &ft->lsectorsize, &ft->psectorsize,
-				   force_overwrite);
+		/*
+		 * If our target is a regular file, and xi->disfile isn't
+		 * set (i.e. no "-d file" invocation), use platform_findsizes
+		 * to try to obtain the underlying filesystem's requirements
+		 * for direct IO; we'll set our sector size to that if possible.
+		 */
+		if (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode)) {
+			int fd;
+			long long dummy;
+
+			fd = open(dfile, O_RDONLY);
+			if (fd >= 0) {
+				platform_findsizes(dfile, fd, &dummy,
+						   &ft->lsectorsize);
+				close(fd);
+			}
+		} else {
+			blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
+					   &ft->lsectorsize, &ft->psectorsize,
+					   force_overwrite);
+		}
 	}
 
 	if (xi->rtname && !xi->risfile) {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
