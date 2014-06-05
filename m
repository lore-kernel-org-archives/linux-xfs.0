Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E83617F47
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 14:15:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8FC5BAC005
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 12:15:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LydxKwbY02SgmG07 for <xfs@oss.sgi.com>;
	Thu, 05 Jun 2014 12:15:04 -0700 (PDT)
Message-ID: <5390C1B7.7050106@sandeen.net>
Date: Thu, 05 Jun 2014 14:15:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2 V2] mkfs.xfs: don't call blkid_get_topology on regular
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

V2: Lose local "isa_file" flag, just switch based on 
(xi->disfile) or (stat works & S_ISREG)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 188b6b3..3b8bf67 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -456,9 +456,25 @@ static void get_topology(
 	struct fs_topology	*ft,
 	int			force_overwrite)
 {
-	if (!xi->disfile) {
-		const char *dfile = xi->volname ? xi->volname : xi->dname;
+	struct stat statbuf;
+	char *dfile = xi->volname ? xi->volname : xi->dname;
 
+	/*
+	 * Don't call blkid for topology if this is a "-d file" target, or
+	 * if we've simply been pointed at a regular file.  platform_findsizes
+	 * will attempt to find the underlying sector size of the host fs.
+	 */
+	if (xi->disfile ||
+	    (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
+		int fd;
+		long long dummy;
+
+		fd = open(dfile, O_RDONLY);
+		if (fd >= 0) {
+			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
+			close(fd);
+		}
+	} else {
 		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
 				   &ft->lsectorsize, &ft->psectorsize,
 				   force_overwrite);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
