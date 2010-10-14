Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EEqiK2024492 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 09:52:44 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BFB0330407B
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 07:53:54 -0700 (PDT)
Subject: [PATCH 05/11] xfstests: randholes: hide some Irix/Linux
	differences more tidily
From: Alex Elder <aelder@sgi.com>
Date: Thu, 14 Oct 2010 09:50:19 -0500
Message-ID: <1287067819.2362.217.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: xfs@oss.sgi.com

Define a macro "xfscntl()" that effectively hides the differences
between the Linux xfsctl() and Irix fcntl() kernel interfaces.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 src/randholes.c |   75 +++++++++++++++++---------------------------------------
 1 file changed, 24 insertions(+), 51 deletions(-)

Index: b/src/randholes.c
===================================================================
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -46,6 +46,22 @@ struct fsxattr rtattr;
 
 #define	READ_XFER	10	/* block to read at a time when checking */
 
+/*
+ * Define xfscntl() to mask the difference between the Linux
+ * and the Irix fcntl() interfaces to XFS for user space.  The
+ * "cmd" argument is just the last part of the command, e.g.
+ * pass FSGETXATTR in place of either XFS_IOC_FSGETXATTR (Linux)
+ * F_FSGETXATTR (Irix).
+ *
+ */
+#ifdef	__sgi__	/* Irix */
+#  define xfscntl(filename, fd, cmd, arg) \
+		fcntl((fd), F_ ## cmd, (arg))
+#else	/* ! __sgi__ */
+#  define xfscntl(filename, fd, cmd, arg) \
+		xfsctl((filename), (fd), XFS_IOC_ ## cmd, (arg))
+#endif	/* ! __sgi__ */
+
 void
 usage(char *progname)
 {
@@ -139,21 +155,10 @@ writeblks(char *fname, int fd)
 			fl.l_len = blocksize;
 			fl.l_whence = 0;
 
-#ifdef XFS_IOC_RESVSP64
-			if (xfsctl(fname, fd, XFS_IOC_RESVSP64, &fl) < 0) {
-				perror("xfsctl(XFS_IOC_RESVSP64)");
+			if (xfscntl(fname, fd, RESVSP64, &fl) < 0) {
+				perror("xfsnctl(RESVSP64)");
 				exit(1);
 			}
-#else
-#ifdef F_RESVSP64
-                        if (fcntl(fd, F_RESVSP64, &fl) < 0) {
-                                perror("fcntl(F_RESVSP64)");
-                                exit(1);
-                        }
-#else
-bozo!
-#endif
-#endif
 			continue;
 		}
 		SETBIT(valid, block);
@@ -353,9 +358,8 @@ main(int argc, char *argv[])
 	}
 
 	if (rt) {
-#ifdef XFS_IOC_FSGETXATTR
-		if (xfsctl(filename, fd, XFS_IOC_FSGETXATTR, &rtattr) < 0) {
-			perror("xfsctl(XFS_IOC_FSGETXATTR)");
+		if (xfscntl(filename, fd, FSGETXATTR, &rtattr) < 0) {
+			perror("xfsnctl(FSGETXATTR)");
 			return 1;
 		}
 		if ((rtattr.fsx_xflags & XFS_XFLAG_REALTIME) == 0 ||
@@ -363,49 +367,18 @@ main(int argc, char *argv[])
 			rtattr.fsx_xflags |= XFS_XFLAG_REALTIME;
 			if (extsize)
 				rtattr.fsx_extsize = extsize * blocksize;
-			if (xfsctl(filename, fd, XFS_IOC_FSSETXATTR, &rtattr) < 0) {
-				perror("xfsctl(XFS_IOC_FSSETXATTR)");
+			if (xfscntl(filename, fd, FSSETXATTR, &rtattr) < 0) {
+				perror("xfscntl(FSSETXATTR)");
 				return 1;
 			}
 		}
-#else
-#ifdef F_FSGETXATTR
-                if (fcntl(fd, F_FSGETXATTR, &rtattr) < 0) {
-                        perror("fcntl(F_FSGETXATTR)");
-                        return 1;
-                }
-                if ((rtattr.fsx_xflags & XFS_XFLAG_REALTIME) == 0 ||
-                    (extsize && rtattr.fsx_extsize != extsize * blocksize)) {
-                        rtattr.fsx_xflags |= XFS_XFLAG_REALTIME;
-                        if (extsize)
-                                rtattr.fsx_extsize = extsize * blocksize;
-                        if (fcntl(fd, F_FSSETXATTR, &rtattr) < 0) {
-                                perror("fcntl(F_FSSETXATTR)");
-                                return 1;
-                        }
-                }
-#else
-bozo!
-#endif
-#endif
 	}
 
 	if (direct) {
-#ifdef XFS_IOC_DIOINFO
-		if (xfsctl(filename, fd, XFS_IOC_DIOINFO, &diob) < 0) {
-			perror("xfsctl(XFS_IOC_FIOINFO)");
+		if (xfscntl(filename, fd, DIOINFO, &diob) < 0) {
+			perror("xfscntl(FIOINFO)");
 			return 1;
 		}
-#else
-#ifdef F_DIOINFO
-                if (fcntl(fd, F_DIOINFO, &diob) < 0) {
-                        perror("fcntl(F_FIOINFO)");
-                        return 1;
-                }
-#else
-bozo!
-#endif
-#endif
 		if (blocksize % diob.d_miniosz) {
 			fprintf(stderr,
 				"blocksize %d must be a multiple of %d for direct I/O\n",


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
