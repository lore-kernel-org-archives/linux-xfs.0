Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54188 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbfBVQrc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Feb 2019 11:47:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MGiAV2158986
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 16:47:31 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2qp81erevq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 16:47:30 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1MGlP7B011316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 16:47:25 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1MGlOp5030474
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 16:47:25 GMT
Subject: [PATCH 1/4] xfs_restore: refactor open-coded file creation code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Feb 2019 08:47:24 -0800
Message-ID: <155085404462.5141.11851529133557195388.stgit@magnolia>
In-Reply-To: <155085403848.5141.1866278990901950186.stgit@magnolia>
References: <155085403848.5141.1866278990901950186.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a helper to unlink, recreate, and reserve space in a file so that
we don't have two open-coded versions.  We lose the broken ALLOCSP code
since it never worked anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 restore/dirattr.c |   97 ++++++++++++++++++-----------------------------------
 restore/dirattr.h |    2 +
 restore/namreg.c  |   70 +++-----------------------------------
 3 files changed, 41 insertions(+), 128 deletions(-)


diff --git a/restore/dirattr.c b/restore/dirattr.c
index 5368664..0fb2877 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -55,6 +55,37 @@
 #include "openutil.h"
 #include "mmap.h"
 
+/* Create a file, try to reserve space for it, and return the fd. */
+int
+create_filled_file(
+	const char	*pathname,
+	off64_t		size)
+{
+	struct flock64	fl = {
+		.l_len = size,
+	};
+	int		fd;
+	int		ret;
+
+	(void)unlink(pathname);
+
+	fd = open(pathname, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR);
+	if (fd < 0)
+		return fd;
+
+	ret = ioctl(fd, XFS_IOC_RESVSP64, &fl);
+	if (ret && errno != ENOTTY)
+		mlog(MLOG_VERBOSE | MLOG_NOTE,
+_("attempt to reserve %lld bytes for %s using %s failed: %s (%d)\n"),
+				size, pathname, "XFS_IOC_RESVSP64",
+				strerror(errno), errno);
+	if (ret == 0)
+		goto done;
+
+done:
+	return fd;
+}
+
 /* structure definitions used locally ****************************************/
 
 /* node handle limits
@@ -238,13 +269,8 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
 			return BOOL_FALSE;
 		}
 	} else {
-		/* create the dirattr file, first unlinking any older version
-		 * laying around
-		 */
-		(void)unlink(dtp->dt_pathname);
-		dtp->dt_fd = open(dtp->dt_pathname,
-				   O_RDWR | O_CREAT | O_EXCL,
-				   S_IRUSR | S_IWUSR);
+		dtp->dt_fd = create_filled_file(dtp->dt_pathname,
+			DIRATTR_PERS_SZ + (dircnt * sizeof(struct dirattr)));
 		if (dtp->dt_fd < 0) {
 			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "could not create directory attributes file %s: "
@@ -253,63 +279,6 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
 			      strerror(errno));
 			return BOOL_FALSE;
 		}
-
-		/* reserve space for the backing store. try to use RESVSP64.
-		 * if doesn't work, try ALLOCSP64. the former is faster, as
-		 * it does not zero the space.
-		 */
-		{
-		bool_t successpr;
-		unsigned int ioctlcmd;
-		int loglevel;
-		size_t trycnt;
-
-		for (trycnt = 0,
-		      successpr = BOOL_FALSE,
-		      ioctlcmd = XFS_IOC_RESVSP64,
-		      loglevel = MLOG_VERBOSE
-		      ;
-		      ! successpr && trycnt < 2
-		      ;
-		      trycnt++,
-		      ioctlcmd = XFS_IOC_ALLOCSP64,
-		      loglevel = max(MLOG_NORMAL, loglevel - 1)) {
-			off64_t initsz;
-			struct flock64 flock64;
-			int rval;
-
-			if (! ioctlcmd) {
-				continue;
-			}
-
-			initsz = (off64_t)DIRATTR_PERS_SZ
-				 +
-				 ((off64_t)dircnt * sizeof(dirattr_t));
-			flock64.l_whence = 0;
-			flock64.l_start = 0;
-			flock64.l_len = initsz;
-			rval = ioctl(dtp->dt_fd, ioctlcmd, &flock64);
-			if (rval) {
-				if (errno != ENOTTY) {
-					mlog(loglevel | MLOG_NOTE, _(
-					      "attempt to reserve %lld bytes for %s "
-					      "using %s "
-					      "failed: %s (%d)\n"),
-					      initsz,
-					      dtp->dt_pathname,
-					      ioctlcmd == XFS_IOC_RESVSP64
-					      ?
-					      "XFS_IOC_RESVSP64"
-					      :
-					      "XFS_IOC_ALLOCSP64",
-					      strerror(errno),
-					      errno);
-				}
-			} else {
-				successpr = BOOL_TRUE;
-			}
-		}
-		}
 	}
 
 	/* mmap the persistent descriptor
diff --git a/restore/dirattr.h b/restore/dirattr.h
index dd37a98..e81e69c 100644
--- a/restore/dirattr.h
+++ b/restore/dirattr.h
@@ -88,4 +88,6 @@ extern bool_t dirattr_cb_extattr(dah_t dah,
 				  extattrhdr_t *ahdrp,
 				  void *ctxp);
 
+int create_filled_file(const char *pathname, off64_t size);
+
 #endif /* DIRATTR_H */
diff --git a/restore/namreg.c b/restore/namreg.c
index 89fa5ef..d0d5e89 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -37,6 +37,10 @@
 #include "namreg.h"
 #include "openutil.h"
 #include "mmap.h"
+#include "global.h"
+#include "content.h"
+#include "content_inode.h"
+#include "dirattr.h"
 
 /* structure definitions used locally ****************************************/
 
@@ -153,13 +157,8 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
 			return BOOL_FALSE;
 		}
 	} else {
-		/* create the namreg file, first unlinking any older version
-		 * laying around
-		 */
-		(void)unlink(ntp->nt_pathname);
-		ntp->nt_fd = open(ntp->nt_pathname,
-				   O_RDWR | O_CREAT | O_EXCL,
-				   S_IRUSR | S_IWUSR);
+		ntp->nt_fd = create_filled_file(ntp->nt_pathname,
+			NAMREG_PERS_SZ + (inocnt * NAMREG_AVGLEN));
 		if (ntp->nt_fd < 0) {
 			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "could not create name registry file %s: "
@@ -168,63 +167,6 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
 			      strerror(errno));
 			return BOOL_FALSE;
 		}
-
-		/* reserve space for the backing store. try to use RESVSP64.
-		 * if doesn't work, try ALLOCSP64. the former is faster, as
-		 * it does not zero the space.
-		 */
-		{
-		bool_t successpr;
-		unsigned int ioctlcmd;
-		int loglevel;
-		size_t trycnt;
-
-		for (trycnt = 0,
-		      successpr = BOOL_FALSE,
-		      ioctlcmd = XFS_IOC_RESVSP64,
-		      loglevel = MLOG_VERBOSE
-		      ;
-		      ! successpr && trycnt < 2
-		      ;
-		      trycnt++,
-		      ioctlcmd = XFS_IOC_ALLOCSP64,
-		      loglevel = max(MLOG_NORMAL, loglevel - 1)) {
-			off64_t initsz;
-			struct flock64 flock64;
-			int rval;
-
-			if (! ioctlcmd) {
-				continue;
-			}
-
-			initsz = (off64_t)NAMREG_PERS_SZ
-				 +
-				 ((off64_t)inocnt * NAMREG_AVGLEN);
-			flock64.l_whence = 0;
-			flock64.l_start = 0;
-			flock64.l_len = initsz;
-			rval = ioctl(ntp->nt_fd, ioctlcmd, &flock64);
-			if (rval) {
-				if (errno != ENOTTY) {
-					mlog(loglevel | MLOG_NOTE, _(
-					      "attempt to reserve %lld bytes for %s "
-					      "using %s "
-					      "failed: %s (%d)\n"),
-					      initsz,
-					      ntp->nt_pathname,
-					      ioctlcmd == XFS_IOC_RESVSP64
-					      ?
-					      "XFS_IOC_RESVSP64"
-					      :
-					      "XFS_IOC_ALLOCSP64",
-					      strerror(errno),
-					      errno);
-				}
-			} else {
-				successpr = BOOL_TRUE;
-			}
-		}
-		}
 	}
 
 	/* mmap the persistent descriptor
