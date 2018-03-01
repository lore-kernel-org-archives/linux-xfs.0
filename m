Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55588 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161161AbeCATNc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 14:13:32 -0500
Subject: [PATCH 05/16] xfs_scrub: fix #include ordering to avoid build
 failure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Mar 2018 11:13:26 -0800
Message-ID: <151993160650.22223.13639058352038800793.stgit@magnolia>
In-Reply-To: <151993157539.22223.6269629008244777191.stgit@magnolia>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, Mikael Magnusson <mikachu@gmail.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix the ordering of the header includes in all the scrub source.  We put
xfs.h first so that it will pull in include/linux.h which pulls in
linux/fs.h + whatever overrides are necessary (currently limited to
struct fsxattr) to make things work on this platform, and then we remove
the #includes for anything that will get pulled (directly or indirectly)
by xfs.h for cleanliness.  Without this, a user compiling new xfsprogs
on a system with a 4.7 kernel gets this:

Building scrub
    [CC]     disk.o
In file included from ../include/xfs.h:37:0,
                 from disk.c:40:
../include/xfs/linux.h:185:8: error: redefinition of 'struct fsxattr'
 struct fsxattr {
        ^~~~~~~
In file included from disk.c:31:0:
/usr/include/linux/fs.h:155:8: note: originally defined here
 struct fsxattr {
        ^~~~~~~
gmake[2]: *** [../include/buildrules:60: disk.o] Error 1
gmake[1]: *** [include/buildrules:36: scrub] Error 2
make: *** [Makefile:77: default] Error 2

Reported-by: Mikael Magnusson <mikachu@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/bitmap.c      |    5 +----
 scrub/common.c      |    5 +----
 scrub/counter.c     |    2 +-
 scrub/disk.c        |    9 +--------
 scrub/filemap.c     |    6 +-----
 scrub/fscounters.c  |    5 +----
 scrub/inodes.c      |    4 +---
 scrub/phase1.c      |   10 +---------
 scrub/phase2.c      |    5 +----
 scrub/phase3.c      |    5 +----
 scrub/phase4.c      |    6 +-----
 scrub/phase5.c      |    5 +----
 scrub/phase6.c      |    5 +----
 scrub/phase7.c      |    5 +----
 scrub/progress.c    |    4 +---
 scrub/read_verify.c |    5 +----
 scrub/scrub.c       |    6 +-----
 scrub/spacemap.c    |    5 +----
 scrub/unicrash.c    |    5 +----
 scrub/vfs.c         |    4 +---
 scrub/xfs_scrub.c   |    5 +----
 21 files changed, 21 insertions(+), 90 deletions(-)


diff --git a/scrub/bitmap.c b/scrub/bitmap.c
index a88fd0e..212c3b8 100644
--- a/scrub/bitmap.c
+++ b/scrub/bitmap.c
@@ -17,13 +17,10 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
-#include <stdbool.h>
+#include "xfs.h"
 #include <stdint.h>
 #include <stdlib.h>
-#include <errno.h>
 #include <assert.h>
-#include <inttypes.h>
 #include <pthread.h>
 #include "platform_defs.h"
 #include "avl64.h"
diff --git a/scrub/common.c b/scrub/common.c
index 672f286..32f7642 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -17,14 +17,11 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+#include "xfs.h"
 #include <pthread.h>
-#include <stdbool.h>
 #include <sys/statvfs.h>
 #include <syslog.h>
 #include "platform_defs.h"
-#include "xfs.h"
-#include "xfs_fs.h"
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/counter.c b/scrub/counter.c
index ced3cf3..0e28f0f 100644
--- a/scrub/counter.c
+++ b/scrub/counter.c
@@ -17,9 +17,9 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
+#include "xfs.h"
 #include <stdint.h>
 #include <stdlib.h>
-#include <stdbool.h>
 #include <string.h>
 #include <assert.h>
 #include <pthread.h>
diff --git a/scrub/disk.c b/scrub/disk.c
index e12175c..798b4a0 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -17,18 +17,13 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+#include "xfs.h"
 #include <stdint.h>
 #include <stdlib.h>
-#include <stdbool.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/ioctl.h>
 #include <sys/statvfs.h>
-#include <sys/vfs.h>
-#include <linux/fs.h>
 #ifdef HAVE_SG_IO
 # include <scsi/sg.h>
 #endif
@@ -37,9 +32,7 @@
 #endif
 #include "platform_defs.h"
 #include "libfrog.h"
-#include "xfs.h"
 #include "path.h"
-#include "xfs_fs.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "disk.h"
diff --git a/scrub/filemap.c b/scrub/filemap.c
index f42a6ba..056b3b0 100644
--- a/scrub/filemap.c
+++ b/scrub/filemap.c
@@ -17,17 +17,13 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
-#include <stdbool.h>
+#include "xfs.h"
 #include <stdint.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
 #include <sys/types.h>
-#include <sys/stat.h>
 #include <sys/statvfs.h>
-#include "xfs.h"
-#include "xfs_fs.h"
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index ecdf4c6..05bf95e 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -17,15 +17,12 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
-#include <stdbool.h>
+#include "xfs.h"
 #include <stdint.h>
 #include <stdlib.h>
 #include <sys/statvfs.h>
 #include "platform_defs.h"
-#include "xfs.h"
 #include "xfs_arch.h"
-#include "xfs_fs.h"
 #include "xfs_format.h"
 #include "path.h"
 #include "workqueue.h"
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 744b003..ccfb9e0 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -17,14 +17,12 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
-#include <stdbool.h>
+#include "xfs.h"
 #include <stdint.h>
 #include <stdlib.h>
 #include <pthread.h>
 #include <sys/statvfs.h>
 #include "platform_defs.h"
-#include "xfs.h"
 #include "xfs_arch.h"
 #include "xfs_format.h"
 #include "handle.h"
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 6cd5442..5ddce6e 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -17,30 +17,22 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
-#include <mntent.h>
+#include "xfs.h"
 #include <unistd.h>
 #include <sys/types.h>
-#include <sys/stat.h>
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <sys/statvfs.h>
-#include <sys/vfs.h>
 #include <fcntl.h>
 #include <dirent.h>
 #include <stdint.h>
-#include <stdbool.h>
 #include <pthread.h>
-#include <errno.h>
-#include <linux/fs.h>
 #include "libfrog.h"
 #include "workqueue.h"
 #include "input.h"
 #include "path.h"
 #include "handle.h"
 #include "bitops.h"
-#include "xfs_arch.h"
-#include "xfs_format.h"
 #include "avl64.h"
 #include "list.h"
 #include "xfs_scrub.h"
diff --git a/scrub/phase2.c b/scrub/phase2.c
index edf66df..ad736bf 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -17,13 +17,10 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+#include "xfs.h"
 #include <stdint.h>
-#include <stdbool.h>
 #include <sys/types.h>
-#include <sys/stat.h>
 #include <sys/statvfs.h>
-#include "xfs.h"
 #include "list.h"
 #include "path.h"
 #include "workqueue.h"
diff --git a/scrub/phase3.c b/scrub/phase3.c
index a0ee5d9..68c95e6 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -17,13 +17,10 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+#include "xfs.h"
 #include <stdint.h>
-#include <stdbool.h>
 #include <sys/types.h>
-#include <sys/stat.h>
 #include <sys/statvfs.h>
-#include "xfs.h"
 #include "list.h"
 #include "path.h"
 #include "workqueue.h"
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 1fb8da9..8573036 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -17,15 +17,11 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+#include "xfs.h"
 #include <stdint.h>
-#include <stdbool.h>
 #include <dirent.h>
 #include <sys/types.h>
-#include <sys/stat.h>
 #include <sys/statvfs.h>
-#include "xfs.h"
-#include "xfs_fs.h"
 #include "list.h"
 #include "path.h"
 #include "workqueue.h"
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 703b279..0ef6339 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -17,17 +17,14 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+#include "xfs.h"
 #include <stdint.h>
-#include <stdbool.h>
 #include <dirent.h>
 #include <sys/types.h>
-#include <sys/stat.h>
 #include <sys/statvfs.h>
 #ifdef HAVE_LIBATTR
 # include <attr/attributes.h>
 #endif
-#include "xfs.h"
 #include "handle.h"
 #include "list.h"
 #include "path.h"
diff --git a/scrub/phase6.c b/scrub/phase6.c
index e255eef..b533cbb 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -17,13 +17,10 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+#include "xfs.h"
 #include <stdint.h>
-#include <stdbool.h>
 #include <dirent.h>
 #include <sys/statvfs.h>
-#include "xfs.h"
-#include "xfs_fs.h"
 #include "handle.h"
 #include "path.h"
 #include "ptvar.h"
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 460ca8a..50d04ae 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -17,13 +17,10 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+#include "xfs.h"
 #include <stdint.h>
-#include <stdbool.h>
 #include <stdlib.h>
 #include <sys/statvfs.h>
-#include "xfs.h"
-#include "xfs_fs.h"
 #include "path.h"
 #include "ptvar.h"
 #include "xfs_scrub.h"
diff --git a/scrub/progress.c b/scrub/progress.c
index 61b9c60..e9e720b 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -17,13 +17,11 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include "libxfs.h"
-#include <stdio.h>
+#include "xfs.h"
 #include <dirent.h>
 #include <pthread.h>
 #include <sys/statvfs.h>
 #include <time.h>
-#include "../repair/threads.h"
 #include "path.h"
 #include "disk.h"
 #include "read_verify.h"
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index ae2e85f..d7bcc17 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -17,15 +17,12 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+#include "xfs.h"
 #include <stdint.h>
-#include <stdbool.h>
 #include <stdlib.h>
 #include <sys/statvfs.h>
 #include "workqueue.h"
 #include "path.h"
-#include "xfs.h"
-#include "xfs_fs.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "counter.h"
diff --git a/scrub/scrub.c b/scrub/scrub.c
index ff5357c..9e82675 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -17,17 +17,13 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
-#include <stdbool.h>
+#include "xfs.h"
 #include <stdint.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
 #include <sys/types.h>
-#include <sys/stat.h>
 #include <sys/statvfs.h>
-#include "xfs.h"
-#include "xfs_fs.h"
 #include "list.h"
 #include "path.h"
 #include "xfs_scrub.h"
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index f631913..3621035 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -17,15 +17,12 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
-#include <stdbool.h>
+#include "xfs.h"
 #include <stdint.h>
 #include <string.h>
 #include <pthread.h>
 #include <sys/statvfs.h>
 #include "workqueue.h"
-#include "xfs.h"
-#include "xfs_fs.h"
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index ce3e7f9..0b5d1fa 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -17,17 +17,14 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+#include "xfs.h"
 #include <stdint.h>
-#include <stdbool.h>
 #include <stdlib.h>
 #include <dirent.h>
 #include <sys/types.h>
-#include <sys/stat.h>
 #include <sys/statvfs.h>
 #include <unistr.h>
 #include <uninorm.h>
-#include "xfs.h"
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 0c5b353..cfb5878 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -17,13 +17,11 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+#include "xfs.h"
 #include <stdint.h>
-#include <stdbool.h>
 #include <dirent.h>
 #include <sys/types.h>
 #include <sys/statvfs.h>
-#include "xfs.h"
 #include "handle.h"
 #include "path.h"
 #include "workqueue.h"
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 53a105a..df58db5 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -17,16 +17,13 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+#include "xfs.h"
 #include <pthread.h>
-#include <stdbool.h>
 #include <stdlib.h>
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <sys/statvfs.h>
 #include "platform_defs.h"
-#include "xfs.h"
-#include "xfs_fs.h"
 #include "input.h"
 #include "path.h"
 #include "xfs_scrub.h"

