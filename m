Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C8BFB7F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 19:15:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B42E68F8084
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 17:15:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5inuqX3joabPBKH9 for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 17:15:19 -0700 (PDT)
Message-ID: <53852A98.7000809@sandeen.net>
Date: Tue, 27 May 2014 19:15:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2, RFC] mkfs.xfs: don't call blkid_get_topology on regular
	files
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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 37c05a9..74180c9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -454,12 +454,26 @@ static void get_topology(
 	struct fs_topology	*ft,
 	int			force_overwrite)
 {
-	if (!xi->disfile) {
-		const char *dfile = xi->volname ? xi->volname : xi->dname;
+	int is_a_file = 0;
+	struct stat statbuf;
+	char *dfile = xi->volname ? xi->volname : xi->dname;
 
+	if (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))
+		is_a_file = 1;
+
+	if (!xi->disfile && !is_a_file) {
 		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
 				   &ft->lsectorsize, &ft->psectorsize,
 				   force_overwrite);
+	} else {
+		int fd;
+		long long dummy;
+
+		fd = open(dfile, O_RDONLY);
+		if (fd >= 0) {
+			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
+			close(fd);
+		}
 	}
 
 	if (xi->rtname && !xi->risfile) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
