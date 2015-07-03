Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B6A87FCD
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 05:15:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CD1E4AC00F
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 03:15:07 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id yLPdPTK0JB0RcCkj (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 03:15:02 -0700 (PDT)
Received: from [88.128.80.19] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZAxzn-0002X9-7r
	for xfs@oss.sgi.com; Fri, 03 Jul 2015 10:15:01 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/13] xfsprogs: simplify internal includes
Date: Fri,  3 Jul 2015 12:12:15 +0200
Message-Id: <1435918341-10128-8-git-send-email-hch@lst.de>
In-Reply-To: <1435918341-10128-1-git-send-email-hch@lst.de>
References: <1435918341-10128-1-git-send-email-hch@lst.de>
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

We don't need the xfs/ prefix for local includes if we just add the libxfs
directory to the include path.  Once that is done we only need to link the
installed headers into include/xfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c            |  2 +-
 db/addr.c                  |  2 +-
 db/agf.c                   |  2 +-
 db/agfl.c                  |  2 +-
 db/agi.c                   |  2 +-
 db/attr.c                  |  2 +-
 db/attrset.c               |  2 +-
 db/attrshort.c             |  2 +-
 db/bit.c                   |  2 +-
 db/block.c                 |  2 +-
 db/bmap.c                  |  2 +-
 db/bmroot.c                |  2 +-
 db/btblock.c               |  2 +-
 db/check.c                 |  2 +-
 db/command.c               |  2 +-
 db/convert.c               |  2 +-
 db/debug.c                 |  2 +-
 db/dir2.c                  |  2 +-
 db/dir2sf.c                |  2 +-
 db/dquot.c                 |  2 +-
 db/echo.c                  |  2 +-
 db/faddr.c                 |  2 +-
 db/field.c                 |  2 +-
 db/flist.c                 |  2 +-
 db/fprint.c                |  2 +-
 db/frag.c                  |  2 +-
 db/freesp.c                |  2 +-
 db/hash.c                  |  2 +-
 db/help.c                  |  2 +-
 db/init.c                  |  2 +-
 db/inode.c                 |  2 +-
 db/input.c                 |  2 +-
 db/io.c                    |  2 +-
 db/malloc.c                |  2 +-
 db/metadump.c              |  4 +--
 db/output.c                |  2 +-
 db/print.c                 |  2 +-
 db/quit.c                  |  2 +-
 db/sb.c                    |  4 +--
 db/sig.c                   |  2 +-
 db/strvec.c                |  2 +-
 db/symlink.c               |  2 +-
 db/text.c                  |  2 +-
 db/type.c                  |  2 +-
 db/write.c                 |  2 +-
 estimate/xfs_estimate.c    |  2 +-
 fsr/xfs_fsr.c              | 12 +++----
 growfs/xfs_growfs.c        |  4 +--
 include/Makefile           |  2 +-
 include/builddefs.in       |  2 +-
 include/input.h            |  2 +-
 include/libxfs.h           | 86 +++++++++++++++++++++++-----------------------
 include/libxlog.h          |  2 +-
 include/path.h             |  2 +-
 include/project.h          |  2 +-
 include/xfs_inode.h        |  4 +--
 io/attr.c                  |  6 ++--
 io/bmap.c                  |  4 +--
 io/fadvise.c               |  6 ++--
 io/fiemap.c                |  4 +--
 io/file.c                  |  6 ++--
 io/freeze.c                |  6 ++--
 io/fsync.c                 |  4 +--
 io/getrusage.c             |  6 ++--
 io/imap.c                  |  6 ++--
 io/init.c                  |  6 ++--
 io/inject.c                |  6 ++--
 io/link.c                  |  6 ++--
 io/madvise.c               |  6 ++--
 io/mincore.c               |  6 ++--
 io/mmap.c                  |  6 ++--
 io/open.c                  |  6 ++--
 io/parent.c                | 14 ++++----
 io/pread.c                 |  6 ++--
 io/prealloc.c              |  6 ++--
 io/pwrite.c                |  6 ++--
 io/readdir.c               |  6 ++--
 io/resblks.c               |  6 ++--
 io/seek.c                  |  6 ++--
 io/sendfile.c              |  6 ++--
 io/shutdown.c              |  6 ++--
 io/sync.c                  |  4 +--
 io/sync_file_range.c       |  6 ++--
 io/truncate.c              |  6 ++--
 libdisk/drivers.h          |  2 +-
 libhandle/handle.c         |  6 ++--
 libhandle/jdm.c            |  8 ++---
 libxcmd/command.c          |  6 ++--
 libxcmd/help.c             |  4 +--
 libxcmd/input.c            |  4 +--
 libxcmd/paths.c            |  6 ++--
 libxcmd/projects.c         |  2 +-
 libxcmd/quit.c             |  4 +--
 libxfs/Makefile            | 12 +++----
 libxfs/crc32.c             |  4 +--
 libxfs/darwin.c            |  2 +-
 libxfs/freebsd.c           |  2 +-
 libxfs/init.c              |  2 +-
 libxfs/irix.c              |  2 +-
 libxfs/libxfs_priv.h       | 24 ++++++-------
 libxfs/radix-tree.c        |  2 +-
 libxfs/rdwr.c              |  2 +-
 libxlog/util.c             |  4 +--
 libxlog/xfs_log_recover.c  |  4 +--
 logprint/log_copy.c        |  4 +--
 logprint/log_dump.c        |  4 +--
 logprint/log_misc.c        |  4 +--
 logprint/log_print_all.c   |  4 +--
 logprint/log_print_trans.c |  4 +--
 logprint/logprint.c        |  4 +--
 mdrestore/xfs_mdrestore.c  |  2 +-
 mkfs/fstyp.c               |  2 +-
 mkfs/maxtrres.c            |  2 +-
 mkfs/proto.c               |  2 +-
 mkfs/xfs_mkfs.c            |  2 +-
 quota/edit.c               |  4 +--
 quota/free.c               |  2 +-
 quota/init.c               |  6 ++--
 quota/path.c               |  4 +--
 quota/project.c            |  4 +--
 quota/quot.c               |  2 +-
 quota/quota.c              |  2 +-
 quota/quota.h              |  6 ++--
 quota/report.c             |  2 +-
 quota/state.c              |  2 +-
 repair/agheader.c          |  2 +-
 repair/attr_repair.c       |  2 +-
 repair/avl.c               |  2 +-
 repair/avl64.c             |  2 +-
 repair/bmap.c              |  2 +-
 repair/btree.c             |  2 +-
 repair/dino_chunks.c       |  2 +-
 repair/dinode.c            |  2 +-
 repair/dir2.c              |  2 +-
 repair/globals.c           |  2 +-
 repair/incore.c            |  2 +-
 repair/incore_bmc.c        |  2 +-
 repair/incore_ext.c        |  2 +-
 repair/incore_ino.c        |  2 +-
 repair/init.c              |  2 +-
 repair/phase1.c            |  2 +-
 repair/phase2.c            |  4 +--
 repair/phase3.c            |  2 +-
 repair/phase4.c            |  2 +-
 repair/phase5.c            |  2 +-
 repair/phase6.c            |  2 +-
 repair/phase7.c            |  2 +-
 repair/prefetch.c          |  2 +-
 repair/progress.c          |  2 +-
 repair/rt.c                |  2 +-
 repair/sb.c                |  4 +--
 repair/scan.c              |  2 +-
 repair/threads.c           |  2 +-
 repair/versions.c          |  2 +-
 repair/xfs_repair.c        |  4 +--
 rtcp/xfs_rtcp.c            |  2 +-
 156 files changed, 308 insertions(+), 312 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 44a32e8..4a5a8a6 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <pthread.h>
diff --git a/db/addr.c b/db/addr.c
index a3ac5d6..e835dbb 100644
--- a/db/addr.c
+++ b/db/addr.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "addr.h"
 #include "command.h"
 #include "type.h"
diff --git a/db/agf.c b/db/agf.c
index e144bd6..e10526d 100644
--- a/db/agf.c
+++ b/db/agf.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "type.h"
 #include "faddr.h"
diff --git a/db/agfl.c b/db/agfl.c
index b821b13..472873e 100644
--- a/db/agfl.c
+++ b/db/agfl.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "type.h"
 #include "faddr.h"
diff --git a/db/agi.c b/db/agi.c
index 634429e..285a3c5 100644
--- a/db/agi.c
+++ b/db/agi.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "type.h"
 #include "faddr.h"
diff --git a/db/attr.c b/db/attr.c
index e14e32e..897834b 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "bit.h"
 #include "type.h"
 #include "faddr.h"
diff --git a/db/attrset.c b/db/attrset.c
index 1afadd2..ec9da5a 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "attrset.h"
 #include "io.h"
diff --git a/db/attrshort.c b/db/attrshort.c
index 7dc5640..d82559c 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "type.h"
 #include "faddr.h"
 #include "fprint.h"
diff --git a/db/bit.c b/db/bit.c
index b85ed6a..24872bf 100644
--- a/db/bit.c
+++ b/db/bit.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "bit.h"
 
 #undef setbit	/* defined in param.h on Linux */
diff --git a/db/block.c b/db/block.c
index 9319cce..4a357ce 100644
--- a/db/block.c
+++ b/db/block.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "block.h"
 #include "bmap.h"
 #include "command.h"
diff --git a/db/bmap.c b/db/bmap.c
index 60d6a80..92057b4 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "type.h"
 #include "fprint.h"
diff --git a/db/bmroot.c b/db/bmroot.c
index 95be2dd..0950e19 100644
--- a/db/bmroot.c
+++ b/db/bmroot.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "type.h"
 #include "faddr.h"
 #include "fprint.h"
diff --git a/db/btblock.c b/db/btblock.c
index 1953e05..46140fc 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "type.h"
 #include "faddr.h"
 #include "fprint.h"
diff --git a/db/check.c b/db/check.c
index c109f20..afeea32 100644
--- a/db/check.c
+++ b/db/check.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <math.h>
 #include <sys/time.h>
 #include "bmap.h"
diff --git a/db/command.c b/db/command.c
index eb1efb6..2189e00 100644
--- a/db/command.c
+++ b/db/command.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "addr.h"
 #include "attrset.h"
 #include "block.h"
diff --git a/db/convert.c b/db/convert.c
index d2bf1a9..09f9225 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "convert.h"
 #include "output.h"
diff --git a/db/debug.c b/db/debug.c
index 13a319f..2875858 100644
--- a/db/debug.c
+++ b/db/debug.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "debug.h"
 #include "output.h"
diff --git a/db/dir2.c b/db/dir2.c
index 75aaed5..7f69e6f 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "bit.h"
 #include "type.h"
 #include "faddr.h"
diff --git a/db/dir2sf.c b/db/dir2sf.c
index 831d6f2..a56590b 100644
--- a/db/dir2sf.c
+++ b/db/dir2sf.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "type.h"
 #include "faddr.h"
 #include "fprint.h"
diff --git a/db/dquot.c b/db/dquot.c
index 6118256..3adde3b 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "bit.h"
 #include "bmap.h"
 #include "command.h"
diff --git a/db/echo.c b/db/echo.c
index f2b7ab8..9a8ae72 100644
--- a/db/echo.c
+++ b/db/echo.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "echo.h"
 #include "output.h"
diff --git a/db/faddr.c b/db/faddr.c
index 17451c2..e368d0d 100644
--- a/db/faddr.c
+++ b/db/faddr.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "type.h"
 #include "fprint.h"
 #include "faddr.h"
diff --git a/db/field.c b/db/field.c
index f68809a..843c385 100644
--- a/db/field.c
+++ b/db/field.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "type.h"
 #include "faddr.h"
 #include "fprint.h"
diff --git a/db/flist.c b/db/flist.c
index 848478e..84065a2 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "type.h"
 #include "faddr.h"
 #include "fprint.h"
diff --git a/db/fprint.c b/db/fprint.c
index f36cdc8..f2b3794 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <ctype.h>
 #include <time.h>
 #include "type.h"
diff --git a/db/frag.c b/db/frag.c
index 309db7f..1cc922e 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <sys/time.h>
 #include "bmap.h"
 #include "command.h"
diff --git a/db/freesp.c b/db/freesp.c
index b0fc95e..27e9f5a 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "freesp.h"
 #include "io.h"
diff --git a/db/hash.c b/db/hash.c
index e02857f..c535fc9 100644
--- a/db/hash.c
+++ b/db/hash.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "addr.h"
 #include "command.h"
 #include "type.h"
diff --git a/db/help.c b/db/help.c
index d6a56b0..59a7ba6 100644
--- a/db/help.c
+++ b/db/help.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "help.h"
 #include "output.h"
diff --git a/db/init.c b/db/init.c
index 8efd883..9537a38 100644
--- a/db/init.c
+++ b/db/init.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <signal.h>
 #include "command.h"
 #include "init.h"
diff --git a/db/inode.c b/db/inode.c
index e4d80ae..e86dabd 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "type.h"
 #include "faddr.h"
diff --git a/db/input.c b/db/input.c
index ec1b986..a90de6c 100644
--- a/db/input.c
+++ b/db/input.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <signal.h>
 #include "command.h"
 #include "input.h"
diff --git a/db/io.c b/db/io.c
index 0f360a8..9fa52b8 100644
--- a/db/io.c
+++ b/db/io.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "type.h"
 #include "faddr.h"
diff --git a/db/malloc.c b/db/malloc.c
index 00cbfe1..9037bc1 100644
--- a/db/malloc.c
+++ b/db/malloc.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "init.h"
 #include "malloc.h"
 #include "output.h"
diff --git a/db/metadump.c b/db/metadump.c
index f606e35..08899da 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 #include "bmap.h"
 #include "command.h"
 #include "metadump.h"
diff --git a/db/output.c b/db/output.c
index 8f6e9cd..14f7c4a 100644
--- a/db/output.c
+++ b/db/output.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <stdarg.h>
 #include "command.h"
 #include "output.h"
diff --git a/db/print.c b/db/print.c
index 9f08b9f..3ff2548 100644
--- a/db/print.c
+++ b/db/print.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "type.h"
 #include "faddr.h"
diff --git a/db/quit.c b/db/quit.c
index 7d352a6..1103a7a 100644
--- a/db/quit.c
+++ b/db/quit.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "command.h"
 #include "quit.h"
 
diff --git a/db/sb.c b/db/sb.c
index 2b78136..1a28cf2 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 #include "command.h"
 #include "type.h"
 #include "faddr.h"
diff --git a/db/sig.c b/db/sig.c
index 025c603..031567e 100644
--- a/db/sig.c
+++ b/db/sig.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <signal.h>
 #include "sig.h"
 
diff --git a/db/strvec.c b/db/strvec.c
index 3fa10be..dd83448 100644
--- a/db/strvec.c
+++ b/db/strvec.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "strvec.h"
 #include "output.h"
 #include "malloc.h"
diff --git a/db/symlink.c b/db/symlink.c
index 01719a7..ce96556 100644
--- a/db/symlink.c
+++ b/db/symlink.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "type.h"
 #include "faddr.h"
 #include "fprint.h"
diff --git a/db/text.c b/db/text.c
index a0d4c89..f6c623c 100644
--- a/db/text.c
+++ b/db/text.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <ctype.h>
 #include "block.h"
 #include "bmap.h"
diff --git a/db/type.c b/db/type.c
index b150b53..37e0882 100644
--- a/db/type.c
+++ b/db/type.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "block.h"
 #include "command.h"
 #include "type.h"
diff --git a/db/write.c b/db/write.c
index 6a33dba..9f5b423 100644
--- a/db/write.c
+++ b/db/write.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <ctype.h>
 #include <time.h>
 #include "bit.h"
diff --git a/estimate/xfs_estimate.c b/estimate/xfs_estimate.c
index 636691b..65b7168 100644
--- a/estimate/xfs_estimate.c
+++ b/estimate/xfs_estimate.c
@@ -21,7 +21,7 @@
  *
  * XXX: assumes dirv1 format.
  */
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <sys/stat.h>
 #include <ftw.h>
 
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index efc17a8..7c1d776 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -16,12 +16,12 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
-#include "xfs/xfs.h"
-#include "xfs/xfs_types.h"
-#include "xfs/jdm.h"
-#include "xfs/xfs_bmap_btree.h"
-#include "xfs/xfs_attr_sf.h"
+#include "libxfs.h"
+#include "xfs.h"
+#include "xfs_types.h"
+#include "jdm.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_attr_sf.h"
 
 #include <fcntl.h>
 #include <errno.h>
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 309b915..56315f9 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
-#include "xfs/path.h"
+#include "libxfs.h"
+#include "path.h"
 
 static void
 usage(void)
diff --git a/include/Makefile b/include/Makefile
index bd8b0ca..778317e 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -65,7 +65,7 @@ disk:
 include $(BUILDRULES)
 
 # set up include/xfs header directory
-install-headers: $(addsuffix -hdrs, $(HFILES) $(PHFILES) $(DKHFILES) $(LIBHFILES))
+install-headers: $(addsuffix -hdrs, $(PHFILES) $(DKHFILES) $(HFILES))
 
 %-hdrs: xfs
 	$(Q)$(LN_S) -f $(PWD)/include/$* xfs/$*
diff --git a/include/builddefs.in b/include/builddefs.in
index 7e9f53d..6ee95b7 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -134,7 +134,7 @@ endif
 
 GCFLAGS = $(OPTIMIZER) $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
-	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include
+	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
 
 ifeq ($(ENABLE_GETTEXT),yes)
 GCFLAGS += -DENABLE_GETTEXT
diff --git a/include/input.h b/include/input.h
index ae273ad..d02170f 100644
--- a/include/input.h
+++ b/include/input.h
@@ -21,7 +21,7 @@
 #include <pwd.h>
 #include <grp.h>
 #include <sys/types.h>
-#include "xfs/project.h"
+#include "project.h"
 #include <stdbool.h>
 
 extern char	**breakline(char *input, int *count);
diff --git a/include/libxfs.h b/include/libxfs.h
index eda664f..1fb2d6d 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -19,26 +19,26 @@
 #ifndef __LIBXFS_H__
 #define __LIBXFS_H__
 
-#include "xfs/libxfs_api_defs.h"
-#include "xfs/platform_defs.h"
+#include "libxfs_api_defs.h"
+#include "platform_defs.h"
 
-#include "xfs/list.h"
-#include "xfs/hlist.h"
-#include "xfs/cache.h"
-#include "xfs/bitops.h"
-#include "xfs/kmem.h"
-#include "xfs/radix-tree.h"
-#include "xfs/atomic.h"
+#include "list.h"
+#include "hlist.h"
+#include "cache.h"
+#include "bitops.h"
+#include "kmem.h"
+#include "radix-tree.h"
+#include "atomic.h"
 
-#include "xfs/xfs_types.h"
-#include "xfs/xfs_fs.h"
-#include "xfs/xfs_arch.h"
+#include "xfs_types.h"
+#include "xfs_fs.h"
+#include "xfs_arch.h"
 
-#include "xfs/xfs_shared.h"
-#include "xfs/xfs_format.h"
-#include "xfs/xfs_log_format.h"
-#include "xfs/xfs_quota_defs.h"
-#include "xfs/xfs_trans_resv.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_quota_defs.h"
+#include "xfs_trans_resv.h"
 
 
 /* CRC stuff, buffer API dependent on it */
@@ -48,33 +48,33 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #define crc32(c,p,l)	crc32_le((c),(unsigned char const *)(p),(l))
 #define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
 
-#include "xfs/xfs_cksum.h"
+#include "xfs_cksum.h"
 
 /*
  * This mirrors the kernel include for xfs_buf.h - it's implicitly included in
  * every files via a similar include in the kernel xfs_linux.h.
  */
-#include "xfs/libxfs_io.h"
-
-#include "xfs/xfs_bit.h"
-#include "xfs/xfs_sb.h"
-#include "xfs/xfs_mount.h"
-#include "xfs/xfs_da_format.h"
-#include "xfs/xfs_da_btree.h"
-#include "xfs/xfs_dir2.h"
-#include "xfs/xfs_bmap_btree.h"
-#include "xfs/xfs_alloc_btree.h"
-#include "xfs/xfs_ialloc_btree.h"
-#include "xfs/xfs_attr_sf.h"
-#include "xfs/xfs_inode_fork.h"
-#include "xfs/xfs_inode_buf.h"
-#include "xfs/xfs_inode.h"
-#include "xfs/xfs_alloc.h"
-#include "xfs/xfs_btree.h"
-#include "xfs/xfs_btree_trace.h"
-#include "xfs/xfs_bmap.h"
-#include "xfs/xfs_trace.h"
-#include "xfs/xfs_trans.h"
+#include "libxfs_io.h"
+
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_inode_fork.h"
+#include "xfs_inode_buf.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_btree.h"
+#include "xfs_btree_trace.h"
+#include "xfs_bmap.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
@@ -173,11 +173,11 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 extern int		libxfs_nproc(void);
 extern unsigned long	libxfs_physmem(void);	/* in kilobytes */
 
-#include "xfs/xfs_ialloc.h"
+#include "xfs_ialloc.h"
 
-#include "xfs/xfs_attr_leaf.h"
-#include "xfs/xfs_attr_remote.h"
-#include "xfs/xfs_trans_space.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_attr_remote.h"
+#include "xfs_trans_space.h"
 
 #define XFS_INOBT_IS_FREE_DISK(rp,i)		\
 			((be64_to_cpu((rp)->ir_free) & XFS_INOBT_MASK(i)) != 0)
diff --git a/include/libxlog.h b/include/libxlog.h
index 0c55a86..05b16e8 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -44,7 +44,7 @@ struct xlog {
 	int		l_sectBBsize;   /* size of log sector in 512 byte chunks */
 };
 
-#include "xfs/xfs_log_recover.h"
+#include "xfs_log_recover.h"
 
 /*
  * macros mapping kernel code to user code
diff --git a/include/path.h b/include/path.h
index c8746cb..58955ef 100644
--- a/include/path.h
+++ b/include/path.h
@@ -18,7 +18,7 @@
 #ifndef __PATH_H__
 #define __PATH_H__
 
-#include "xfs/xfs.h"
+#include "xfs.h"
 
 /*
  * XFS Filesystem Paths
diff --git a/include/project.h b/include/project.h
index a458a61..63bdffd 100644
--- a/include/project.h
+++ b/include/project.h
@@ -18,7 +18,7 @@
 #ifndef __PROJECT_H__
 #define __PROJECT_H__
 
-#include "xfs/xfs.h"
+#include "xfs.h"
 
 extern int setprojid(const char *__name, int __fd, prid_t __id);
 extern int getprojid(const char *__name, int __fd, prid_t *__id);
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 303efe0..71c0fb4 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -20,8 +20,8 @@
 #define __XFS_INODE_H__
 
 /* These match kernel side includes */
-#include "xfs/xfs_inode_buf.h"
-#include "xfs/xfs_inode_fork.h"
+#include "xfs_inode_buf.h"
+#include "xfs_inode_fork.h"
 
 struct xfs_trans;
 struct xfs_mount;
diff --git a/io/attr.c b/io/attr.c
index dfae36e..bc1ab56 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/bmap.c b/io/bmap.c
index d96f7d4..432ddb7 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
+#include "xfs.h"
+#include "command.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/fadvise.c b/io/fadvise.c
index 3b76ab9..fa586d3 100644
--- a/io/fadvise.c
+++ b/io/fadvise.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/fiemap.c b/io/fiemap.c
index 363d1d9..8482c99 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
+#include "xfs.h"
+#include "command.h"
 #include <linux/fiemap.h>
 #include <linux/fs.h>
 #include "init.h"
diff --git a/io/file.c b/io/file.c
index 0eadcab..91dd38e 100644
--- a/io/file.c
+++ b/io/file.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include <sys/mman.h>
 #include "init.h"
 #include "io.h"
diff --git a/io/freeze.c b/io/freeze.c
index a12ed67..90f5b66 100644
--- a/io/freeze.c
+++ b/io/freeze.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/fsync.c b/io/fsync.c
index d9c45f1..6c93dff 100644
--- a/io/fsync.c
+++ b/io/fsync.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
+#include "xfs.h"
+#include "command.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/getrusage.c b/io/getrusage.c
index 35dc4bf..28b8453 100644
--- a/io/getrusage.c
+++ b/io/getrusage.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include <sys/time.h>
 #include <sys/resource.h>
 #include "init.h"
diff --git a/io/imap.c b/io/imap.c
index a615467..7c24bcd 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/init.c b/io/init.c
index 78a49b6..70214f9 100644
--- a/io/init.c
+++ b/io/init.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/inject.c b/io/inject.c
index f0aaf97..23eb4a2 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/link.c b/io/link.c
index 092e0d4..7fb81e1 100644
--- a/io/link.c
+++ b/io/link.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/madvise.c b/io/madvise.c
index 4f3f91b..b30d28b 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include <sys/mman.h>
 #include "init.h"
 #include "io.h"
diff --git a/io/mincore.c b/io/mincore.c
index 234e0a1..670d4c8 100644
--- a/io/mincore.c
+++ b/io/mincore.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include <sys/mman.h>
 #include "init.h"
 #include "io.h"
diff --git a/io/mmap.c b/io/mmap.c
index 06f678f..33747c1 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include <sys/mman.h>
 #include <signal.h>
 #include "init.h"
diff --git a/io/open.c b/io/open.c
index 795adeb..33d9f8d 100644
--- a/io/open.c
+++ b/io/open.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/parent.c b/io/parent.c
index e883f65..a374b3e 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -16,13 +16,13 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
-#include "xfs/path.h"
-#include "xfs/parent.h"
-#include "xfs/handle.h"
-#include "xfs/jdm.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
+#include "path.h"
+#include "parent.h"
+#include "handle.h"
+#include "jdm.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/pread.c b/io/pread.c
index 280cc9d..9205e34 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -17,9 +17,9 @@
  */
 
 #include <sys/uio.h>
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include <ctype.h>
 #include "init.h"
 #include "io.h"
diff --git a/io/prealloc.c b/io/prealloc.c
index e458a92..b60d2dc 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -19,9 +19,9 @@
 #if defined(HAVE_FALLOCATE)
 #include <linux/falloc.h>
 #endif
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/pwrite.c b/io/pwrite.c
index 69f67af..c9d2b1a 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -17,9 +17,9 @@
  */
 
 #include <sys/uio.h>
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/readdir.c b/io/readdir.c
index 20b8898..f8b2755 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/resblks.c b/io/resblks.c
index 197f7e8..df032d5 100644
--- a/io/resblks.c
+++ b/io/resblks.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/seek.c b/io/seek.c
index 9b281d5..39dab61 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -16,9 +16,9 @@
  * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include <sys/types.h>
 #include <unistd.h>
 #include "init.h"
diff --git a/io/sendfile.c b/io/sendfile.c
index 22a5a4f..744b618 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include <sys/sendfile.h>
 #include "init.h"
 #include "io.h"
diff --git a/io/shutdown.c b/io/shutdown.c
index 2c86cf9..b75278a 100644
--- a/io/shutdown.c
+++ b/io/shutdown.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/sync.c b/io/sync.c
index c7bbbf1..0e7b82d 100644
--- a/io/sync.c
+++ b/io/sync.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
+#include "xfs.h"
+#include "command.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/sync_file_range.c b/io/sync_file_range.c
index 6366331..8e66773 100644
--- a/io/sync_file_range.c
+++ b/io/sync_file_range.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/io/truncate.c b/io/truncate.c
index 401d2a5..5b2ac01 100644
--- a/io/truncate.c
+++ b/io/truncate.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "io.h"
 
diff --git a/libdisk/drivers.h b/libdisk/drivers.h
index 22ac1ea..4d10568 100644
--- a/libdisk/drivers.h
+++ b/libdisk/drivers.h
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <sys/stat.h>
 #include <volume.h>
 
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 54e6f71..7313e3b 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -17,9 +17,9 @@
  */
 
 #include <libgen.h>
-#include "xfs/xfs.h"
-#include "xfs/handle.h"
-#include "xfs/parent.h"
+#include "xfs.h"
+#include "handle.h"
+#include "parent.h"
 
 /* just pick a value we know is more than big enough */
 #define	MAXHANSIZ	64
diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index 2f2f3fd..13196d1 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -16,10 +16,10 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/handle.h"
-#include "xfs/jdm.h"
-#include "xfs/parent.h"
+#include "xfs.h"
+#include "handle.h"
+#include "jdm.h"
+#include "parent.h"
 
 /* internal fshandle - typecast to a void for external use */
 #define FSHANDLE_SZ		8
diff --git a/libxcmd/command.c b/libxcmd/command.c
index 148e58b..5d0649b 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "command.h"
+#include "input.h"
 
 cmdinfo_t	*cmdtab;
 int		ncmds;
diff --git a/libxcmd/help.c b/libxcmd/help.c
index bcd5641..023b830 100644
--- a/libxcmd/help.c
+++ b/libxcmd/help.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
+#include "xfs.h"
+#include "command.h"
 
 static cmdinfo_t help_cmd;
 static void help_onecmd(const char *cmd, const cmdinfo_t *ct);
diff --git a/libxcmd/input.c b/libxcmd/input.c
index 83aeeb5..966a7ff 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/input.h"
+#include "xfs.h"
+#include "input.h"
 #include <ctype.h>
 #include <stdbool.h>
 
diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index c0b1ddb..c56b06b 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -24,9 +24,9 @@
 #include <unistd.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-#include "xfs/path.h"
-#include "xfs/input.h"
-#include "xfs/project.h"
+#include "path.h"
+#include "input.h"
+#include "project.h"
 #include <limits.h>
 
 extern char *progname;
diff --git a/libxcmd/projects.c b/libxcmd/projects.c
index b00e4c8..24ef70a 100644
--- a/libxcmd/projects.c
+++ b/libxcmd/projects.c
@@ -19,7 +19,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include "xfs/project.h"
+#include "project.h"
 
 #define PROJID		"/etc/projid"
 #define PROJECT_PATHS	"/etc/projects"
diff --git a/libxcmd/quit.c b/libxcmd/quit.c
index 0921bbb..0a2dd40 100644
--- a/libxcmd/quit.c
+++ b/libxcmd/quit.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xfs.h"
-#include "xfs/command.h"
+#include "xfs.h"
+#include "command.h"
 
 static cmdinfo_t quit_cmd;
 
diff --git a/libxfs/Makefile b/libxfs/Makefile
index ebbe40e..95de27e 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -17,7 +17,7 @@ PKGHFILES = xfs_fs.h \
 	xfs_format.h \
 	xfs_log_format.h
 
-LIBHFILES = \
+HFILES = \
 	xfs_alloc.h \
 	xfs_alloc_btree.h \
 	xfs_attr_leaf.h \
@@ -40,11 +40,8 @@ LIBHFILES = \
 	xfs_trans_resv.h \
 	xfs_trans_space.h \
 	libxfs_io.h \
-	libxfs_api_defs.h
-
-
-# headers with build dependencies
-HFILES = init.h \
+	libxfs_api_defs.h \
+	init.h \
 	crc32defs.h \
 	crc32table.h \
 	libxfs_priv.h \
@@ -90,7 +87,6 @@ CFILES = cache.c \
 CFILES += $(PKG_PLATFORM).c
 PCFILES = darwin.c freebsd.c irix.c linux.c
 LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
-LSRCFILES += $(LIBHFILES)
 LSRCFILES += gen_crc32table.c
 
 #
@@ -135,7 +131,7 @@ include $(BUILDRULES)
 install: default
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 
-install-headers: $(addsuffix -hdrs, $(PKGHFILES) $(LIBHFILES))
+install-headers: $(addsuffix -hdrs, $(PKGHFILES))
 
 %-hdrs:
 	$(Q)$(LN_S) -f $(PWD)/libxfs/$* $(TOPDIR)/include/xfs/$*
diff --git a/libxfs/crc32.c b/libxfs/crc32.c
index 63b1467..b2c7ec0 100644
--- a/libxfs/crc32.c
+++ b/libxfs/crc32.c
@@ -33,8 +33,8 @@
  * match the hardware acceleration available on Intel CPUs.
  */
 
-#include "xfs/platform_defs.h"
-#include "xfs/xfs_arch.h"
+#include "platform_defs.h"
+#include "xfs_arch.h"
 #include "crc32defs.h"
 
 /* types specifc to this file */
diff --git a/libxfs/darwin.c b/libxfs/darwin.c
index f4a3898..b9c314f 100644
--- a/libxfs/darwin.c
+++ b/libxfs/darwin.c
@@ -21,7 +21,7 @@
 #include <sys/mount.h>
 #include <sys/ioctl.h>
 #include <sys/sysctl.h>
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 
 int platform_has_uuid = 1;
 extern char *progname;
diff --git a/libxfs/freebsd.c b/libxfs/freebsd.c
index ec131db..6c9f089 100644
--- a/libxfs/freebsd.c
+++ b/libxfs/freebsd.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <sys/stat.h>
 #include <sys/disk.h>
 #include <sys/mount.h>
diff --git a/libxfs/init.c b/libxfs/init.c
index d287c1d..2859f94 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -31,7 +31,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 
-#include "xfs/libxfs.h"		/* for now */
+#include "libxfs.h"		/* for now */
 
 char *progname = "libxfs";	/* default, changed by each tool */
 
diff --git a/libxfs/irix.c b/libxfs/irix.c
index 69e6d81..65aaa7e 100644
--- a/libxfs/irix.c
+++ b/libxfs/irix.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <diskinfo.h>
 #include <sys/sysmp.h>
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 445a6dc..7a29fd7 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -58,20 +58,20 @@
 				 (ip)->d_ops, hdr, loghead)
 
 #include "libxfs_api_defs.h"
-#include "xfs/platform_defs.h"
+#include "platform_defs.h"
 
-#include "xfs/list.h"
-#include "xfs/hlist.h"
-#include "xfs/cache.h"
-#include "xfs/bitops.h"
-#include "xfs/kmem.h"
-#include "xfs/radix-tree.h"
-#include "xfs/atomic.h"
+#include "list.h"
+#include "hlist.h"
+#include "cache.h"
+#include "bitops.h"
+#include "kmem.h"
+#include "radix-tree.h"
+#include "atomic.h"
 
-#include "xfs/xfs_types.h"
-#include "xfs/xfs_arch.h"
+#include "xfs_types.h"
+#include "xfs_arch.h"
 
-#include "xfs/xfs_fs.h"
+#include "xfs_fs.h"
 
 /* CRC stuff, buffer API dependent on it */
 extern uint32_t crc32_le(uint32_t crc, unsigned char const *p, size_t len);
@@ -80,7 +80,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #define crc32(c,p,l)	crc32_le((c),(unsigned char const *)(p),(l))
 #define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
 
-#include "xfs/xfs_cksum.h"
+#include "xfs_cksum.h"
 
 /*
  * This mirrors the kernel include for xfs_buf.h - it's implicitly included in
diff --git a/libxfs/radix-tree.c b/libxfs/radix-tree.c
index c859f28..9e395be 100644
--- a/libxfs/radix-tree.c
+++ b/libxfs/radix-tree.c
@@ -18,7 +18,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include "xfs/platform_defs.h"
+#include "platform_defs.h"
 #include "radix-tree.h"
 
 #ifndef ARRAY_SIZE
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 4e0c75b..4f8212f 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -30,7 +30,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 
-#include "xfs/libxfs.h"		/* for LIBXFS_EXIT_ON_FAILURE */
+#include "libxfs.h"		/* for LIBXFS_EXIT_ON_FAILURE */
 
 /*
  * Important design/architecture note:
diff --git a/libxlog/util.c b/libxlog/util.c
index a0e35cc..2feae82 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 
 int print_exit;
 int print_skip_uuid;
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index a80c431..ef7cf68 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -15,8 +15,8 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 
 #define xfs_readonly_buftarg(buftarg)			(0)
 
diff --git a/logprint/log_copy.c b/logprint/log_copy.c
index ea55a1f..1cc4c21 100644
--- a/logprint/log_copy.c
+++ b/logprint/log_copy.c
@@ -15,8 +15,8 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 
 #include "logprint.h"
 
diff --git a/logprint/log_dump.c b/logprint/log_dump.c
index efcf62e..2bccb50 100644
--- a/logprint/log_dump.c
+++ b/logprint/log_dump.c
@@ -15,8 +15,8 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 
 #include "logprint.h"
 
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 7ea6edc..fd30679 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -15,8 +15,8 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 
 #include "logprint.h"
 
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 6569968..9f1a7ab 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -15,8 +15,8 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 
 #include "logprint.h"
 
diff --git a/logprint/log_print_trans.c b/logprint/log_print_trans.c
index cbd7a9c..9bf2b37 100644
--- a/logprint/log_print_trans.c
+++ b/logprint/log_print_trans.c
@@ -15,8 +15,8 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 
 #include "logprint.h"
 
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 2ad2ec0..a5c9b32 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -18,8 +18,8 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 
 #include "logprint.h"
 
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index ea7298d..5764616 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "xfs_metadump.h"
 
 char 		*progname;
diff --git a/mkfs/fstyp.c b/mkfs/fstyp.c
index 7410516..7f3da06 100644
--- a/mkfs/fstyp.c
+++ b/mkfs/fstyp.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <disk/fstyp.h>
 
 /*
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index f6bcec0..e1d5ee9 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -24,7 +24,7 @@
  * directory block size.
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "xfs_mkfs.h"
 
 int
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 17308bc..cb34b28 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <sys/stat.h>
 #include "xfs_mkfs.h"
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 11e9f4b..80cdd10 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <ctype.h>
 #ifdef ENABLE_BLKID
 #include <blkid/blkid.h>
diff --git a/quota/edit.c b/quota/edit.c
index 0170d51..d226e89 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -19,8 +19,8 @@
 #include <pwd.h>
 #include <grp.h>
 #include <ctype.h>
-#include "xfs/input.h"
-#include "xfs/command.h"
+#include "input.h"
+#include "command.h"
 #include "init.h"
 #include "quota.h"
 
diff --git a/quota/free.c b/quota/free.c
index 72ab503..dcbe8ce 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/command.h"
+#include "command.h"
 #include "init.h"
 #include "quota.h"
 
diff --git a/quota/init.c b/quota/init.c
index 019e2c5..52f7941 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/path.h"
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "path.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 
 char	*progname;
diff --git a/quota/path.c b/quota/path.c
index 9a35332..bdb8c98 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "quota.h"
 
diff --git a/quota/project.c b/quota/project.c
index f30c6c6..17a83b0 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/command.h"
-#include "xfs/input.h"
+#include "command.h"
+#include "input.h"
 #include "init.h"
 #include "quota.h"
 
diff --git a/quota/quot.c b/quota/quot.c
index be41026..9116e48 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/command.h"
+#include "command.h"
 #include <ctype.h>
 #include <pwd.h>
 #include <grp.h>
diff --git a/quota/quota.c b/quota/quota.c
index d249740..f6b24c3 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/command.h"
+#include "command.h"
 #include <ctype.h>
 #include <pwd.h>
 #include <grp.h>
diff --git a/quota/quota.h b/quota/quota.h
index 974747f..a905ce5 100644
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -16,9 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/xqm.h"
-#include "xfs/path.h"
-#include "xfs/project.h"
+#include "xqm.h"
+#include "path.h"
+#include "project.h"
 #include <stdbool.h>
 
 /*
diff --git a/quota/report.c b/quota/report.c
index 7c3cf45..3d84447 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/command.h"
+#include "command.h"
 #include <sys/types.h>
 #include <pwd.h>
 #include <grp.h>
diff --git a/quota/state.c b/quota/state.c
index b1827b6..0173f40 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/command.h"
+#include "command.h"
 #include "init.h"
 #include "quota.h"
 
diff --git a/repair/agheader.c b/repair/agheader.c
index a216afa..c79031f 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "globals.h"
 #include "agheader.h"
 #include "protos.h"
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index e2bfd44..62f80e7 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "globals.h"
 #include "err_protos.h"
 #include "attr_repair.h"
diff --git a/repair/avl.c b/repair/avl.c
index 83e3087..e3843ae 100644
--- a/repair/avl.c
+++ b/repair/avl.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl.h"
 
 #define CERT	ASSERT
diff --git a/repair/avl64.c b/repair/avl64.c
index 64f5358..51cd624 100644
--- a/repair/avl64.c
+++ b/repair/avl64.c
@@ -17,7 +17,7 @@
  */
 
 #include <stdio.h>
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl64.h"
 
 #define CERT	ASSERT
diff --git a/repair/bmap.c b/repair/bmap.c
index c5c50c3..2655632 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "err_protos.h"
 #include "bmap.h"
 
diff --git a/repair/btree.c b/repair/btree.c
index bc4ed98..66fb40b 100644
--- a/repair/btree.c
+++ b/repair/btree.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "btree.h"
 
 /*
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index d484a1d..7dbaca6 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
diff --git a/repair/dinode.c b/repair/dinode.c
index 09db966..c6303fa 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
diff --git a/repair/dir2.c b/repair/dir2.c
index c89f478..187e069 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl.h"
 #include "globals.h"
 #include "incore.h"
diff --git a/repair/globals.c b/repair/globals.c
index d0ca3fb..9619220 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 
 #define EXTERN
 #include "globals.h"
diff --git a/repair/incore.c b/repair/incore.c
index d5ecfd6..cb57316 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl.h"
 #include "btree.h"
 #include "globals.h"
diff --git a/repair/incore_bmc.c b/repair/incore_bmc.c
index c1e855d..de142ee 100644
--- a/repair/incore_bmc.c
+++ b/repair/incore_bmc.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl.h"
 #include "globals.h"
 #include "incore.h"
diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index c15e57d..cac379c 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl.h"
 #include "btree.h"
 #include "globals.h"
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 7e19657..32d7678 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl.h"
 #include "globals.h"
 #include "incore.h"
diff --git a/repair/init.c b/repair/init.c
index a7547cb..609229c 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "globals.h"
 #include "agheader.h"
 #include "protos.h"
diff --git a/repair/phase1.c b/repair/phase1.c
index bd9adcb..126d0b3 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "globals.h"
 #include "agheader.h"
 #include "protos.h"
diff --git a/repair/phase2.c b/repair/phase2.c
index 04c1295..4c270e5 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
diff --git a/repair/phase3.c b/repair/phase3.c
index 4751e56..20786af 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "threads.h"
 #include "prefetch.h"
 #include "avl.h"
diff --git a/repair/phase4.c b/repair/phase4.c
index 8d3525c..e0571e8 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "threads.h"
 #include "prefetch.h"
 #include "avl.h"
diff --git a/repair/phase5.c b/repair/phase5.c
index 9b3d73b..b9a64b9 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
diff --git a/repair/phase6.c b/repair/phase6.c
index 9a5cba7..672c6f1 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "threads.h"
 #include "prefetch.h"
 #include "avl.h"
diff --git a/repair/phase7.c b/repair/phase7.c
index 56c0379..b1e3a55 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 08c0394..8b261ae 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -1,4 +1,4 @@
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <pthread.h>
 #include "avl.h"
 #include "btree.h"
diff --git a/repair/progress.c b/repair/progress.c
index 1b27924..27cbaef 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -1,5 +1,5 @@
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "globals.h"
 #include "progress.h"
 #include "err_protos.h"
diff --git a/repair/rt.c b/repair/rt.c
index b412a0f..3290d2c 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
diff --git a/repair/sb.c b/repair/sb.c
index f6a1f15..4eef14a 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 #include "agheader.h"
 #include "globals.h"
 #include "protos.h"
diff --git a/repair/scan.c b/repair/scan.c
index e9a8ab4..dd61046 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
diff --git a/repair/threads.c b/repair/threads.c
index a5fb856..631531f 100644
--- a/repair/threads.c
+++ b/repair/threads.c
@@ -1,4 +1,4 @@
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 #include <pthread.h>
 #include <signal.h>
 #include "threads.h"
diff --git a/repair/versions.c b/repair/versions.c
index 0bf4ab3..fb1b3e4 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 
 #define EXTERN
 #include "versions.h"
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index df1fd78..db703d0 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -16,8 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
-#include "xfs/libxlog.h"
+#include "libxfs.h"
+#include "libxlog.h"
 #include <sys/resource.h>
 #include "avl.h"
 #include "avl64.h"
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index 7f48060..f604b46 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -16,7 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include "xfs/libxfs.h"
+#include "libxfs.h"
 
 int rtcp(char *, char *, int);
 int xfsrtextsize(char *path);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
