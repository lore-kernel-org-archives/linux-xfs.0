Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 93A7B7F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 14:41:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D4E4AC003
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 12:41:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id px295TKuRdxazPiX for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 12:41:52 -0800 (PST)
Message-ID: <530FA30F.70805@sandeen.net>
Date: Thu, 27 Feb 2014 14:41:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs_io: test for invalid -Tr flag combination before open
References: <530F9F37.8020408@redhat.com>
In-Reply-To: <530F9F37.8020408@redhat.com>
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

Coverity spotted this.

It complained that we didn't close the fd before returning in
the error case of incompatible options, but in reality, we wouldn't
have gotten that far because open(O_RDONLY|O_TMPFILE) would be
rejected with EINVAL.

So the error handling test would never actually be true.

Fix this by moving the error checking prior to the open so
the user gets a more useful error message than "Invalid Argument."

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: New summary & commit message

diff --git a/io/open.c b/io/open.c
index 6bb0d46..c106fa7 100644
--- a/io/open.c
+++ b/io/open.c
@@ -342,6 +342,11 @@ open_f(
 	if (optind != argc - 1)
 		return command_usage(&open_cmd);
 
+	if ((flags & (IO_READONLY|IO_TMPFILE)) == (IO_READONLY|IO_TMPFILE)) {
+		fprintf(stderr, _("-T and -r options are incompatible\n"));
+		return -1;
+	}
+
 	fd = openfile(argv[optind], &geometry, flags, mode);
 	if (fd < 0)
 		return 0;
@@ -349,11 +354,6 @@ open_f(
 	if (!platform_test_xfs_fd(fd))
 		flags |= IO_FOREIGN;
 
-	if ((flags & (IO_READONLY|IO_TMPFILE)) == (IO_READONLY|IO_TMPFILE)) {
-		fprintf(stderr, _("-T and -r options are incompatible\n"));
-		return -1;
-	}
-
 	addfile(argv[optind], fd, &geometry, flags);
 	return 0;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
