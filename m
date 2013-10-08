Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 188D07F6C
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 10:17:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9069304032
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 08:17:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bWswoR9mS4EhNgbU for
	<xfs@oss.sgi.com>; Tue, 08 Oct 2013 08:17:52 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r98FHpVX026580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 8 Oct 2013 11:17:51 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r98FHopH010749
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 8 Oct 2013 11:17:50 -0400
Message-ID: <5254221E.1000503@redhat.com>
Date: Tue, 08 Oct 2013 10:17:50 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: restrict platform_test_xfs_fd to regular files
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

If a special file (block, char, pipe etc) resides on an
xfs filesystem, platform_test_xfs_[fd|path] will return
true, but a subsequent xfsctl will fail, because the file
operations to support the xfs ioctls are not set up on such
files (see i_fop assignments in xfs_setup_inode()).

>From the xfsctl manpage it's pretty clear that these functions
are supposed to return true iff a subsequent xfsctl can be
handled, so it makes sense to exclude special files.

This was showing up in xfstest generic/306, which creates
the dev/null block device on an xfstest an tries to pwrite
to it with xfs_io - which emitted a warning when the xfsctl
trying to get geometry failed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/linux.h b/include/linux.h
index 5bb91cd..502fd1f 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -34,20 +34,38 @@ static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
 	return ioctl(fd, cmd, p);
 }
 
+/*
+ * platform_test_xfs_*() implies that xfsctl will succeed on the file;
+ * on Linux, at least, special files don't get xfs file ops,
+ * so return 0 for those
+ */
+
 static __inline__ int platform_test_xfs_fd(int fd)
 {
-	struct statfs buf;
-	if (fstatfs(fd, &buf) < 0)
+	struct statfs statfsbuf;
+	struct stat statbuf;
+
+	if (fstatfs(fd, &statfsbuf) < 0)
+		return 0;
+	if (fstat(fd, &statbuf) < 0)
 		return 0;
-	return (buf.f_type == 0x58465342);	/* XFSB */
+	if (!S_ISREG(statbuf.st_mode) && !S_ISDIR(statbuf.st_mode))
+		return 0;
+	return (statfsbuf.f_type == 0x58465342);	/* XFSB */
 }
 
 static __inline__ int platform_test_xfs_path(const char *path)
 {
-	struct statfs buf;
-	if (statfs(path, &buf) < 0)
+	struct statfs statfsbuf;
+	struct stat statbuf;
+
+	if (statfs(path, &statfsbuf) < 0)
+		return 0;
+	if (stat(path, &statbuf) < 0)
+		return 0;
+	if (!S_ISREG(statbuf.st_mode) && !S_ISDIR(statbuf.st_mode))
 		return 0;
-	return (buf.f_type == 0x58465342);	/* XFSB */
+	return (statfsbuf.f_type == 0x58465342);	/* XFSB */
 }
 
 static __inline__ int platform_fstatfs(int fd, struct statfs *buf)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
