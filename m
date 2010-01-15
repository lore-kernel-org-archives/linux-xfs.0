Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0FMv9eA137880 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 16:57:19 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 946A116B70E
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 14:57:53 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id fUUptFnTBNxFYJRF for
	<xfs@oss.sgi.com>; Fri, 15 Jan 2010 14:57:53 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 0B8AA96E28B
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 16:57:52 -0600 (CST)
Message-ID: <4B50F2F0.4050909@sandeen.net>
Date: Fri, 15 Jan 2010 16:57:52 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] mkfs: get size of device properly
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Ok, one more.

I've been having too many problems w/ xfstests today to have run
the last patch through xfstests but should have at least run
032.  :(

Anyway, last change wasn't valid to test the size of a device
node; total brain fart.  After this I'm testing the hell out
of the next patch I send, I promise!

--------

Test device node size properly in check_overwrite, st_size
is only valid for regular files.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0743976..689425d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -297,18 +297,23 @@ check_overwrite(
 	const char	*type;
 	blkid_probe	pr = NULL;
 	int		ret;
-	struct stat	statbuf;
+	int		fd;
+	long long	size;
+	int		bsz;
 
 	if (!device || !*device)
 		return 0;
 
 	ret = -1; /* will reset on success of all setup calls */
 
-	if (stat(device, &statbuf) < 0)
+	fd = open(device, O_RDONLY);
+	if (fd < 0)
 		goto out;
+	platform_findsizes(device, fd, &size, &bsz);
+	close(fd);
 
 	/* nothing to overwrite on a 0-length device */
-	if (statbuf.st_size == 0) {
+	if (size == 0) {
 		ret = 0;
 		goto out;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
