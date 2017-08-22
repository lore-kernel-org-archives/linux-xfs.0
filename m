Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34596 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751290AbdHVVQt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 17:16:49 -0400
Subject: [PATCH 2/3] xfs_io: get foreign blocksize & sector size in openfile
References: <2b5a5742-5343-671f-8b89-9d1dc9841c17@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e8e53975-5482-3846-f528-08fc5db97517@sandeen.net>
Date: Tue, 22 Aug 2017 16:16:48 -0500
MIME-Version: 1.0
In-Reply-To: <2b5a5742-5343-671f-8b89-9d1dc9841c17@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Use statvfs to fill in geometry block size and sector
size in openfile() for "foreign" (non-xfs) files.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/open.c b/io/open.c
index f2ea7c3..b0dcabc 100644
--- a/io/open.c
+++ b/io/open.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <sys/statvfs.h>
 #include "command.h"
 #include "input.h"
 #include "init.h"
@@ -94,13 +95,25 @@ openfile(
                }
        }
 
-       if (!geom || !platform_test_xfs_fd(fd))
+       if (!geom)
                return fd;
 
-       if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
-               perror("XFS_IOC_FSGEOMETRY");
-               close(fd);
-               return -1;
+       if (platform_test_xfs_fd(fd)) {
+               if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
+                       perror("XFS_IOC_FSGEOMETRY");
+                       close(fd);
+                       return -1;
+               }
+       } else {        /* Fill in block & sector size for cvtnum */
+               struct statvfs  statbuf;
+
+               if (fstatvfs(fd, &statbuf) < 0) {
+                       perror("fstatvfs");
+                       close(fd);
+                       return -1;
+               }
+               geom->blocksize = statbuf.f_bsize;
+               geom->sectsize = 512;
        }
 
        if (!(flags & IO_READONLY) && (flags & IO_REALTIME)) {
