Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 42D3A7F47
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 10:35:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1832130405F
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 08:35:55 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EVS0SVDIddynxNOc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2016 08:35:54 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 25CE032D3AF
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 16:35:54 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u0EGZrjk028172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 11:35:53 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libxfs: don't pass negative errnos to strerror()
Message-ID: <5697CE69.3050905@redhat.com>
Date: Thu, 14 Jan 2016 10:35:53 -0600
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

The error negation work in 12b5319 tripped up a little bit
when we're reporting errors via strerror().  By negating
the error before passing it to strerror, we get i.e.

   mkfs.xfs: pwrite64 failed: Unknown error -22

Keep the error positive, but return -error, just as we
do in the else clauses in these functions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7a04985..7b23394 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -913,12 +913,12 @@ __read_buf(int fd, void *buf, int len, off64_t offset, int flags)
 
 	sts = pread64(fd, buf, len, offset);
 	if (sts < 0) {
-		int error = -errno;
+		int error = errno;
 		fprintf(stderr, _("%s: read failed: %s\n"),
 			progname, strerror(error));
 		if (flags & LIBXFS_EXIT_ON_FAILURE)
 			exit(1);
-		return error;
+		return -error;
 	} else if (sts != len) {
 		fprintf(stderr, _("%s: error - read only %d of %d bytes\n"),
 			progname, sts, len);
@@ -1081,12 +1081,12 @@ __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
 
 	sts = pwrite64(fd, buf, len, offset);
 	if (sts < 0) {
-		int error = -errno;
+		int error = errno;
 		fprintf(stderr, _("%s: pwrite64 failed: %s\n"),
 			progname, strerror(error));
 		if (flags & LIBXFS_B_EXIT)
 			exit(1);
-		return error;
+		return -error;
 	} else if (sts != len) {
 		fprintf(stderr, _("%s: error - pwrite64 only %d of %d bytes\n"),
 			progname, sts, len);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
