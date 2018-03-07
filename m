Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56956 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754052AbeCGSlU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Mar 2018 13:41:20 -0500
Subject: [RFC PATCH 17/16] xfs_spaceman: only produce info for root of mounted
 xfs
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f85deeb7-b9f3-9be2-9684-f241da880302@sandeen.net>
Date: Wed, 7 Mar 2018 12:34:24 -0600
MIME-Version: 1.0
In-Reply-To: <151993157539.22223.6269629008244777191.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

Previously, xfs_info / xfs_growfs would only operate if
pointed at the root of a mounted xfs filesystem, and not a
file within that filesystem. (Although the ioctl will allow it,
the utility does not, to avoid errors and confusion).

When the info capability was moved to xfs_spaceman, this restriction
got lost.

And now that xfs_db can print xfs_info-like info about image files
and devices, the potential exists for misdirecting the request
and running the ioctl on a file and getting the underlying fs
info, rather than using libxfs to parse the image itself, if
the wrong tool is used to point at the file.

Add a new function to (ab)use XFS_IOC_FSINUMBERS to determine
whether the thing we've been pointed at is in fact the root
directory of a mounted xfs filesystem.  If not, don't proceed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I need to look, perhaps this could simplify growfs as well.
I'm not sure I've put this in the right place (libfrog?) either,
but for the sake of discsussion ...

diff --git a/include/libfrog.h b/include/libfrog.h
index 2d8055b..f7cd00a 100644
--- a/include/libfrog.h
+++ b/include/libfrog.h
@@ -18,6 +18,9 @@
 #ifndef __LIBFROG_UTIL_H_
 #define __LIBFROG_UTIL_H_
 
+#include <stdbool.h>
+
 unsigned int	log2_roundup(unsigned int i);
+bool		fd_is_xfs_root(int fd);
 
 #endif /* __LIBFROG_UTIL_H_ */
diff --git a/libfrog/util.c b/libfrog/util.c
index 4896e4b..4913f38 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "platform_defs.h"
+#include "libxfs.h"
 #include "libfrog.h"
 
 /*
@@ -34,3 +35,44 @@ log2_roundup(unsigned int i)
 	}
 	return rval;
 }
+
+/* Test whether a given fd is the root of a mounted xfs filesystem */
+bool
+fd_is_xfs_root(
+	int			fd)
+{
+	struct xfs_fsop_bulkreq	igrpreq = {0};
+	struct xfs_inogrp	inogrp;
+	__u64			igrp_ino = 0;
+	__s32			igrplen = 0;
+	__u64			first_ino;
+	struct stat		statbuf;
+
+	igrpreq.lastip  = &igrp_ino;
+	igrpreq.icount = 1;
+	igrpreq.ubuffer = &inogrp;
+	igrpreq.ocount  = &igrplen;
+
+	if (ioctl(fd, XFS_IOC_FSINUMBERS, &igrpreq))
+		return false;
+
+	/* find the first allocated inode */
+	while (!ioctl(fd, XFS_IOC_FSINUMBERS, &igrpreq)) {
+		if (inogrp.xi_alloccount)
+			break;
+        }
+
+	/* The ioctl failed ... */
+	if (!inogrp.xi_alloccount)
+		return false;
+
+	first_ino = inogrp.xi_startino + libxfs_lowbit64(inogrp.xi_allocmask);
+
+	if (fstat(fd, &statbuf))
+		return false;
+
+	if (first_ino != statbuf.st_ino)
+		return false;
+
+	return true;
+}
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a23a28d..79a0bd7 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -25,6 +25,8 @@
  * it can be included in both the internal and external libxfs header files
  * without introducing any depenencies between the two.
  */
+#define xfs_lowbit32			libxfs_lowbit32
+#define xfs_lowbit64			libxfs_lowbit64
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
 
diff --git a/spaceman/info.c b/spaceman/info.c
index 6557b54..df088f4 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -44,6 +44,13 @@ info_f(
 	struct xfs_fsop_geom	geo;
 	int			error;
 
+	if (!fd_is_xfs_root(file->fd)) {
+		fprintf(stderr, _("%s: %s is not a mounted XFS filesystem\n"),
+			progname, file->name);
+		exitcode = 1;
+		return 0;
+	}
+
 	/* get the current filesystem size & geometry */
 	error = ioctl(file->fd, XFS_IOC_FSGEOMETRY, &geo);
 	if (error) {

