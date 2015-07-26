Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 080D27F73
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 11:17:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ACB5730404E
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 09:17:09 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id pLxDtl4nLl7PZEUo (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 09:17:07 -0700 (PDT)
Received: from p5de57ec4.dip0.t-ipconnect.de ([93.229.126.196] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat
	Linux)) id 1ZJObn-0000SG-I5
	for xfs@oss.sgi.com; Sun, 26 Jul 2015 16:17:07 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/10] xfsprogs: don't install platform_defs.h
Date: Sun, 26 Jul 2015 18:13:29 +0200
Message-Id: <1437927209-31354-11-git-send-email-hch@lst.de>
In-Reply-To: <1437927209-31354-1-git-send-email-hch@lst.de>
References: <1437927209-31354-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

platform_defs.h is a generated header file, which causes all kinds of
problems when installed on multiarch systems, and requires workarounds
in distribution packages.  Instead move the small parts of it needed
in the installed xfs.h into xfs.h and keep platform_defs.h private
to xfsprogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/Makefile           |  4 ++--
 include/libxfs.h           |  1 +
 include/linux.h            |  1 +
 include/path.h             |  2 +-
 include/platform_defs.h.in | 27 ---------------------------
 include/project.h          |  1 +
 include/xfs.h              | 28 +++++++++++++++++++++++++++-
 io/attr.c                  |  1 -
 io/bmap.c                  |  2 +-
 io/fadvise.c               |  1 -
 io/fiemap.c                |  2 +-
 io/file.c                  |  1 -
 io/freeze.c                |  1 -
 io/fsync.c                 |  2 +-
 io/getrusage.c             |  1 -
 io/imap.c                  |  1 -
 io/init.c                  |  2 +-
 io/inject.c                |  1 -
 io/io.h                    |  2 ++
 io/link.c                  |  1 -
 io/madvise.c               |  1 -
 io/mincore.c               |  1 -
 io/mmap.c                  |  1 -
 io/open.c                  |  1 -
 io/parent.c                |  1 -
 io/pread.c                 |  1 -
 io/prealloc.c              |  1 -
 io/pwrite.c                |  1 -
 io/readdir.c               |  1 -
 io/resblks.c               |  1 -
 io/seek.c                  |  1 -
 io/sendfile.c              |  1 -
 io/shutdown.c              |  1 -
 io/sync.c                  |  2 +-
 io/sync_file_range.c       |  1 -
 io/truncate.c              |  1 -
 libhandle/handle.c         |  1 +
 libhandle/jdm.c            |  1 +
 libxcmd/command.c          |  2 +-
 libxcmd/help.c             |  2 +-
 libxcmd/input.c            |  2 +-
 libxcmd/quit.c             |  2 +-
 libxfs/crc32.c             |  1 +
 libxfs/libxfs_priv.h       |  1 +
 libxfs/radix-tree.c        |  1 +
 45 files changed, 49 insertions(+), 63 deletions(-)

diff --git a/include/Makefile b/include/Makefile
index 778317e..e2a4b09 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -38,12 +38,12 @@ LIBHFILES = libxfs.h \
 	command.h \
 	input.h \
 	path.h \
-	project.h
+	project.h \
+	platform_defs.h \
 
 HFILES = handle.h \
 	jdm.h \
 	$(PKG_PLATFORM).h \
-	platform_defs.h \
 	xfs.h \
 	xqm.h \
 	xfs_arch.h
diff --git a/include/libxfs.h b/include/libxfs.h
index 1fb2d6d..b1604e2 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -21,6 +21,7 @@
 
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"
+#include "xfs.h"
 
 #include "list.h"
 #include "hlist.h"
diff --git a/include/linux.h b/include/linux.h
index cb6298f..8804c2d 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -26,6 +26,7 @@
 #include <inttypes.h>
 #include <malloc.h>
 #include <getopt.h>
+#include <errno.h>
 #include <endian.h>
 #include <stdbool.h>
 #include <asm/types.h>
diff --git a/include/path.h b/include/path.h
index 58955ef..46a887e 100644
--- a/include/path.h
+++ b/include/path.h
@@ -18,7 +18,7 @@
 #ifndef __PATH_H__
 #define __PATH_H__
 
-#include "xfs.h"
+#include "platform_defs.h"
 
 /*
  * XFS Filesystem Paths
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index db6cb2e..fc7e01a 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -38,20 +38,6 @@
 
 typedef struct filldir		filldir_t;
 
-#if defined(__linux__)
-#include <xfs/linux.h>
-#elif defined(__FreeBSD__)
-#include <xfs/freebsd.h>
-#elif defined(__FreeBSD_kernel__)
-#include <xfs/gnukfreebsd.h>
-#elif defined(__APPLE__)
-#include <xfs/darwin.h>
-#elif defined(__sgi__) || defined(__sgi)
-#include <xfs/irix.h>
-#else
-# error unknown platform... have fun porting!
-#endif
-
 /* long and pointer must be either 32 bit or 64 bit */
 #undef SIZEOF_LONG
 #undef SIZEOF_CHAR_P
@@ -76,19 +62,6 @@ typedef unsigned short umode_t;
 #endif
 #include <locale.h>
 
-#ifdef DEBUG
-# define ASSERT(EX)	assert(EX)
-#else
-# define ASSERT(EX)	((void) 0)
-#endif
-
-/*
- * sparse kernel source annotations
- */
-#ifndef __user
-#define __user
-#endif
-
 #define IRIX_DEV_BITSMAJOR      14
 #define IRIX_DEV_BITSMINOR      18
 #define IRIX_DEV_MAXMAJ         0x1ff
diff --git a/include/project.h b/include/project.h
index 63bdffd..77ed06b 100644
--- a/include/project.h
+++ b/include/project.h
@@ -18,6 +18,7 @@
 #ifndef __PROJECT_H__
 #define __PROJECT_H__
 
+#include "platform_defs.h"
 #include "xfs.h"
 
 extern int setprojid(const char *__name, int __fd, prid_t __id);
diff --git a/include/xfs.h b/include/xfs.h
index e32c4a8..bc94068 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -33,7 +33,33 @@
 #ifndef __XFS_H__
 #define __XFS_H__
 
-#include <xfs/platform_defs.h>
+#if defined(__linux__)
+#include <xfs/linux.h>
+#elif defined(__FreeBSD__)
+#include <xfs/freebsd.h>
+#elif defined(__FreeBSD_kernel__)
+#include <xfs/gnukfreebsd.h>
+#elif defined(__APPLE__)
+#include <xfs/darwin.h>
+#elif defined(__sgi__) || defined(__sgi)
+#include <xfs/irix.h>
+#else
+# error unknown platform... have fun porting!
+#endif
+
+#ifdef DEBUG
+# define ASSERT(EX)	assert(EX)
+#else
+# define ASSERT(EX)	((void) 0)
+#endif
+
+/*
+ * sparse kernel source annotations
+ */
+#ifndef __user
+#define __user
+#endif
+
 #include <xfs/xfs_types.h>
 #include <xfs/xfs_fs.h>
 
diff --git a/io/attr.c b/io/attr.c
index bc1ab56..7cbcc3c 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/bmap.c b/io/bmap.c
index 432ddb7..cbeed3b 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
+#include "platform_defs.h"
 #include "command.h"
 #include "init.h"
 #include "io.h"
diff --git a/io/fadvise.c b/io/fadvise.c
index fa586d3..d59d1ff 100644
--- a/io/fadvise.c
+++ b/io/fadvise.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/fiemap.c b/io/fiemap.c
index 8482c99..17b38a4 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
+#include "platform_defs.h"
 #include "command.h"
 #include <linux/fiemap.h>
 #include <linux/fs.h>
diff --git a/io/file.c b/io/file.c
index 91dd38e..d4bc4f8 100644
--- a/io/file.c
+++ b/io/file.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include <sys/mman.h>
diff --git a/io/freeze.c b/io/freeze.c
index 90f5b66..3d0d2a4 100644
--- a/io/freeze.c
+++ b/io/freeze.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/fsync.c b/io/fsync.c
index 6c93dff..9fe5e2f 100644
--- a/io/fsync.c
+++ b/io/fsync.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
+#include "platform_defs.h"
 #include "command.h"
 #include "init.h"
 #include "io.h"
diff --git a/io/getrusage.c b/io/getrusage.c
index 28b8453..bccf94c 100644
--- a/io/getrusage.c
+++ b/io/getrusage.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include <sys/time.h>
diff --git a/io/imap.c b/io/imap.c
index 7c24bcd..34901cb 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/init.c b/io/init.c
index 70214f9..13f35c4 100644
--- a/io/init.c
+++ b/io/init.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
+#include "platform_defs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/inject.c b/io/inject.c
index 23eb4a2..90ccda8 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/io.h b/io/io.h
index db8b513..b115e4a 100644
--- a/io/io.h
+++ b/io/io.h
@@ -16,6 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include "xfs.h"
+
 /*
  * Read/write patterns (default is always "forward")
  */
diff --git a/io/link.c b/io/link.c
index 7fb81e1..ccf8e69 100644
--- a/io/link.c
+++ b/io/link.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/madvise.c b/io/madvise.c
index b30d28b..1d8b53c 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include <sys/mman.h>
diff --git a/io/mincore.c b/io/mincore.c
index 670d4c8..9e0d3a6 100644
--- a/io/mincore.c
+++ b/io/mincore.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include <sys/mman.h>
diff --git a/io/mmap.c b/io/mmap.c
index 33747c1..f26276e 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include <sys/mman.h>
diff --git a/io/open.c b/io/open.c
index 33d9f8d..ac5a5e0 100644
--- a/io/open.c
+++ b/io/open.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/parent.c b/io/parent.c
index a374b3e..abc3402 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "path.h"
diff --git a/io/pread.c b/io/pread.c
index 9205e34..1c77c41 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -17,7 +17,6 @@
  */
 
 #include <sys/uio.h>
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include <ctype.h>
diff --git a/io/prealloc.c b/io/prealloc.c
index b60d2dc..713ea7b 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -19,7 +19,6 @@
 #if defined(HAVE_FALLOCATE)
 #include <linux/falloc.h>
 #endif
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/pwrite.c b/io/pwrite.c
index c9d2b1a..10f78e4 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -17,7 +17,6 @@
  */
 
 #include <sys/uio.h>
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/readdir.c b/io/readdir.c
index f8b2755..7b0edbc 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/resblks.c b/io/resblks.c
index df032d5..73318ae 100644
--- a/io/resblks.c
+++ b/io/resblks.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/seek.c b/io/seek.c
index 39dab61..35a369e 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -16,7 +16,6 @@
  * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include <sys/types.h>
diff --git a/io/sendfile.c b/io/sendfile.c
index 744b618..5c1638f 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include <sys/sendfile.h>
diff --git a/io/shutdown.c b/io/shutdown.c
index b75278a..d8507cc 100644
--- a/io/shutdown.c
+++ b/io/shutdown.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/sync.c b/io/sync.c
index 0e7b82d..28e3a15 100644
--- a/io/sync.c
+++ b/io/sync.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
+#include "platform_defs.h"
 #include "command.h"
 #include "init.h"
 #include "io.h"
diff --git a/io/sync_file_range.c b/io/sync_file_range.c
index 8e66773..7e4f3e6 100644
--- a/io/sync_file_range.c
+++ b/io/sync_file_range.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/io/truncate.c b/io/truncate.c
index 5b2ac01..f2df168 100644
--- a/io/truncate.c
+++ b/io/truncate.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
 #include "command.h"
 #include "input.h"
 #include "init.h"
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 7313e3b..b1c0c10 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -17,6 +17,7 @@
  */
 
 #include <libgen.h>
+#include "platform_defs.h"
 #include "xfs.h"
 #include "handle.h"
 #include "parent.h"
diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index 13196d1..d804423 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include "platform_defs.h"
 #include "xfs.h"
 #include "handle.h"
 #include "jdm.h"
diff --git a/libxcmd/command.c b/libxcmd/command.c
index 5d0649b..42a77e9 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
+#include "platform_defs.h"
 #include "command.h"
 #include "input.h"
 
diff --git a/libxcmd/help.c b/libxcmd/help.c
index 023b830..fad0ab9 100644
--- a/libxcmd/help.c
+++ b/libxcmd/help.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
+#include "platform_defs.h"
 #include "command.h"
 
 static cmdinfo_t help_cmd;
diff --git a/libxcmd/input.c b/libxcmd/input.c
index 966a7ff..c505ab3 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
+#include "platform_defs.h"
 #include "input.h"
 #include <ctype.h>
 #include <stdbool.h>
diff --git a/libxcmd/quit.c b/libxcmd/quit.c
index 0a2dd40..0183b8f 100644
--- a/libxcmd/quit.c
+++ b/libxcmd/quit.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs.h"
+#include "platform_defs.h"
 #include "command.h"
 
 static cmdinfo_t quit_cmd;
diff --git a/libxfs/crc32.c b/libxfs/crc32.c
index b2c7ec0..783d62e 100644
--- a/libxfs/crc32.c
+++ b/libxfs/crc32.c
@@ -34,6 +34,7 @@
  */
 
 #include "platform_defs.h"
+#include "xfs.h"
 #include "xfs_arch.h"
 #include "crc32defs.h"
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 7a29fd7..1b01764 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -59,6 +59,7 @@
 
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"
+#include "xfs.h"
 
 #include "list.h"
 #include "hlist.h"
diff --git a/libxfs/radix-tree.c b/libxfs/radix-tree.c
index 9e395be..4d44ab4 100644
--- a/libxfs/radix-tree.c
+++ b/libxfs/radix-tree.c
@@ -19,6 +19,7 @@
  */
 
 #include "platform_defs.h"
+#include "xfs.h"
 #include "radix-tree.h"
 
 #ifndef ARRAY_SIZE
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
