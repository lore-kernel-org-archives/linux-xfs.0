Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B6D527F50
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 12:20:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 949308F8033
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 10:20:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TLqVMzMJ4JLBA15J for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 10:20:17 -0700 (PDT)
Message-ID: <55844CC3.3080007@sandeen.net>
Date: Fri, 19 Jun 2015 12:09:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: PATCH V2] mkfs.xfs: always use underlying fs sector size when mkfs'ing
	a file
References: <55820229.1010701@redhat.com>
In-Reply-To: <55820229.1010701@redhat.com>
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

If we are mkfs'ing a file, and that file is on a 4k sector filesystem,
we should make the fs image file with the same sector size, or things
may fail when they try to do direct IO in 512 byte chunks (depending
on whether it is a 512e or "hard" 4k device).

Earlier commits attempted this to some degree:

5a7d59 xfsprogs: try to handle mkfs of a file on 4k sector device
3800a2 mkfs.xfs: don't call blkid_get_topology on existing regular files

but inexplicably missed the case where mkfs.xfs with "-d file" was
specified.

One more try; in get_topology(), try to get the underlying fs sector
size in *all* cases where we are mkfs'ing a file, and set the sector size
accordingly.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Handle the !ENABLE_BLKID case as well

Jan, if this collides with your work, let's talk - I would like to 
try to fix things up short term even if there's a big rework in
progress, but we should probably coordinate ...

Christoph, yes, we should probably eliminate HAVE_BLKID, but for
now it's easy enough to fix both spots, and that's separate work -
I can send a patch for it as well.

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e2a052d..c184a63 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -462,31 +462,35 @@ static void get_topology(
 	struct fs_topology	*ft,
 	int			force_overwrite)
 {
-	if (!xi->disfile) {
-		char *dfile = xi->volname ? xi->volname : xi->dname;
-		struct stat statbuf;
+	struct stat statbuf;
+	char *dfile = xi->volname ? xi->volname : xi->dname;
 
-		/*
-		 * If our target is a regular file, and xi->disfile isn't
-		 * set (i.e. no "-d file" invocation), use platform_findsizes
-		 * to try to obtain the underlying filesystem's requirements
-		 * for direct IO; we'll set our sector size to that if possible.
-		 */
-		if (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode)) {
-			int fd;
-			long long dummy;
-
-			fd = open(dfile, O_RDONLY);
-			if (fd >= 0) {
-				platform_findsizes(dfile, fd, &dummy,
-						   &ft->lsectorsize);
-				close(fd);
-			}
-		} else {
-			blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
-					   &ft->lsectorsize, &ft->psectorsize,
-					   force_overwrite);
-		}
+	/*
+	 * If our target is a regular file, use platform_findsizes
+	 * to try to obtain the underlying filesystem's requirements
+	 * for direct IO; we'll set our sector size to that if possible.
+	 */
+	if (xi->disfile ||
+	    (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
+		int fd;
+		int flags = O_RDONLY;
+		long long dummy;
+
+		/* with xi->disfile we may not have the file yet! */
+		if (xi->disfile)
+			flags |= O_CREAT;
+
+		fd = open(dfile, flags, 0666);
+		if (fd >= 0) {
+			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
+			close(fd);
+			ft->psectorsize = ft->lsectorsize;
+		} else
+			ft->psectorsize = ft->lsectorsize = BBSIZE;
+	} else {
+		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
+				   &ft->lsectorsize, &ft->psectorsize,
+				   force_overwrite);
 	}
 
 	if (xi->rtname && !xi->risfile) {
@@ -525,11 +529,32 @@ static void get_topology(
 	struct fs_topology	*ft,
 	int			force_overwrite)
 {
-
+	struct stat statbuf;
 	char *dfile = xi->volname ? xi->volname : xi->dname;
 	int bsz = BBSIZE;
 
-	if (!xi->disfile) {
+        /*
+	 * If our target is a regular file, use platform_findsizes
+	 * to try to obtain the underlying filesystem's requirements
+	 * for direct IO; we'll set our sector size to that if possible.
+	 */
+	if (xi->disfile ||
+	    (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
+		int fd;
+		int flags = O_RDONLY;
+		long long dummy;
+
+		/* with xi->disfile we may not have the file yet! */
+		if (xi->disfile)
+			flags |= O_CREAT;
+
+		fd = open(dfile, flags, 0666);
+		/* If this fails we just fall back to BBSIZE */
+		if (fd >= 0) {
+			platform_findsizes(dfile, fd, &dummy, &bsz);
+			close(fd);
+		}
+	} else {
 		int fd;
 		long long dummy;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
