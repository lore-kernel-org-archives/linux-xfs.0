Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9ACF17F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 14:25:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 863A78F8059
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 12:25:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qUFvivJTeLJylutg for
	<xfs@oss.sgi.com>; Thu, 27 Feb 2014 12:25:29 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1RKPS96018254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 15:25:28 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1RKPRH1009056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 15:25:28 -0500
Message-ID: <530F9F37.8020408@redhat.com>
Date: Thu, 27 Feb 2014 14:25:27 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_io: don't leak fd in open -Tr failure case
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
To: xfs-oss <xfs@oss.sgi.com>

Coverity spotted this.

It complained that we didn't close the fd before returning in
this case of incompatible options, but it seems like we should
just test for the incompatible flags before even trying to open
the file, no?

(The open would have failed in any case, but with a somewhat
cryptic "Invalid argument" - so it's probably better to state
it plainly and bail immediately.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

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
