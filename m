Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7AB007F60
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 20:45:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A47930405F
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 18:45:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hB52cffFAGi4ne6n for <xfs@oss.sgi.com>;
	Thu, 15 Oct 2015 18:45:21 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Zmu4v-00019z-0e
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1Zmu4u-00006P-Vq
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] cleanup: Kill unnecessary xfs includes
Date: Fri, 16 Oct 2015 12:45:01 +1100
Message-Id: <1444959901-31319-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1444959901-31319-1-git-send-email-david@fromorbit.com>
References: <1444959901-31319-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Remove all the unneccessary xfsprogs header includes by replacing
them with explicit includes and platform specific definitions in
config.h.in.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/arch_xlate.c     |  7 +++----
 common/arch_xlate.h     |  3 ---
 common/cldmgr.c         |  3 ---
 common/content_common.c |  6 ++----
 common/dlog.c           |  4 +---
 common/drive.c          |  7 +++----
 common/drive_minrmt.c   |  6 ++----
 common/drive_scsitape.c |  6 ++----
 common/drive_simple.c   |  6 +++++-
 common/fs.c             |  3 +--
 common/global.c         |  7 +++----
 common/hsmapi.c         | 13 +++++++++++--
 common/hsmapi.h         | 12 ++++++------
 common/lock.c           |  4 +---
 common/main.c           |  7 +++----
 common/media.c          |  3 ---
 common/mlog.c           |  6 ++----
 common/openutil.c       |  3 +--
 common/path.c           |  2 --
 common/qlock.c          |  4 +---
 common/ring.c           |  3 ---
 common/stream.c         |  3 ---
 common/types.h          |  9 +++++++++
 common/util.c           |  6 ++----
 dump/content.c          |  5 ++---
 dump/inomap.c           |  6 ++----
 dump/inomap.h           |  5 +++--
 dump/var.c              |  3 ---
 include/config.h.in     |  4 ++++
 inventory/inv_files.c   |  3 ---
 invutil/list.c          |  3 +--
 invutil/menu.c          |  3 +--
 restore/bag.c           |  3 ---
 restore/content.c       |  7 +++----
 restore/mmap.c          |  1 -
 restore/tree.c          |  9 +++++----
 restore/win.c           |  3 ---
 37 files changed, 79 insertions(+), 109 deletions(-)

diff --git a/common/arch_xlate.c b/common/arch_xlate.c
index f8aa50f..1b8e687 100644
--- a/common/arch_xlate.c
+++ b/common/arch_xlate.c
@@ -16,11 +16,10 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-#include <assert.h>
-
+#include <sys/param.h>
 #include <strings.h>
+#include <assert.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
diff --git a/common/arch_xlate.h b/common/arch_xlate.h
index fa201cd..80e847f 100644
--- a/common/arch_xlate.h
+++ b/common/arch_xlate.h
@@ -19,9 +19,6 @@
 #ifndef ARCH_XLATE_H
 #define ARCH_XLATE_H
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <strings.h>
 #include "types.h"
 #include "global.h"
diff --git a/common/cldmgr.c b/common/cldmgr.c
index 624da62..2890092 100644
--- a/common/cldmgr.c
+++ b/common/cldmgr.c
@@ -16,9 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <unistd.h>
 #include <sys/wait.h>
 #include <sys/ipc.h>
diff --git a/common/content_common.c b/common/content_common.c
index 99b1a4b..8f84e56 100644
--- a/common/content_common.c
+++ b/common/content_common.c
@@ -16,9 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
+#include <stdio.h>
 #include <unistd.h>
 #include <sys/stat.h>
 #include <time.h>
@@ -27,11 +25,11 @@
 #include <signal.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
 #include "types.h"
-#include "util.h"
 #include "mlog.h"
 #include "dlog.h"
 #include "cldmgr.h"
diff --git a/common/dlog.c b/common/dlog.c
index cb5c11a..032e6f7 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -16,9 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
+#include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
diff --git a/common/drive.c b/common/drive.c
index 9fb0bb7..5fe6867 100644
--- a/common/drive.c
+++ b/common/drive.c
@@ -16,18 +16,17 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
+#include <stdio.h>
+#include <unistd.h>
 #include <sys/stat.h>
 #include <time.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
 #include "types.h"
-#include "util.h"
 #include "mlog.h"
 #include "dlog.h"
 #include "path.h"
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 848d794..32dc404 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -16,12 +16,10 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
+#include <sys/param.h>
 #include <sys/ipc.h>
 #include <sys/sem.h>
 #include <sys/prctl.h>
@@ -33,11 +31,11 @@
 #include <sched.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
 #include "types.h"
-#include "util.h"
 #include "qlock.h"
 #include "cldmgr.h"
 #include "mlog.h"
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 06ba2f4..56b8c2d 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -16,12 +16,10 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
+#include <sys/param.h>
 #include <sys/ipc.h>
 #include <sys/sem.h>
 #include <sys/prctl.h>
@@ -33,11 +31,11 @@
 #include <sched.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
 #include "types.h"
-#include "util.h"
 #include "qlock.h"
 #include "cldmgr.h"
 #include "mlog.h"
diff --git a/common/drive_simple.c b/common/drive_simple.c
index 45bc28c..b4e41da 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -22,6 +22,7 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
+#include <sys/param.h>
 #include <fcntl.h>
 #include <time.h>
 #include <errno.h>
@@ -29,11 +30,14 @@
 #include <sched.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
+#include <xfs/xfs.h>
+#include <xfs/jdm.h>	/* needed only for util.h include */
 
 #include "config.h"
 
 #include "types.h"
-#include "util.h"
+#include "util.h"	/* needed onyl for I/O routines */
 #include "stream.h"
 #include "mlog.h"
 #include "global.h"
diff --git a/common/fs.c b/common/fs.c
index e600e38..60cf0fd 100644
--- a/common/fs.c
+++ b/common/fs.c
@@ -16,8 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
 #include "config.h"
 
 #include <unistd.h>
@@ -31,6 +29,7 @@
 #include <assert.h>
 #include <string.h>
 #include <uuid/uuid.h>
+#include <xfs/xfs.h>
 
 #include "config.h"
 
diff --git a/common/global.c b/common/global.c
index ca11368..e70b8a0 100644
--- a/common/global.c
+++ b/common/global.c
@@ -16,9 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <unistd.h>
 #include <sys/stat.h>
 #include <time.h>
@@ -26,11 +23,13 @@
 #include <assert.h>
 #include <string.h>
 #include <uuid/uuid.h>
+#include <xfs/xfs.h>
+#include <xfs/jdm.h> /* only for util.h include */
 
 #include "config.h"
 
 #include "types.h"
-#include "util.h"
+#include "util.h" /* only for strncpyterm */
 #include "mlog.h"
 #include "dlog.h"
 #include "global.h"
diff --git a/common/hsmapi.c b/common/hsmapi.c
index 489223d..6054773 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -16,15 +16,24 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <string.h>
+#include <errno.h>
+#include <assert.h>
+#include <uuid/uuid.h>
 #include <attr/attributes.h>
+#include <xfs/xfs.h>
 #include <xfs/jdm.h>
-#include <assert.h>
 
 #include <string.h>
 
 #include "config.h"
 
+#include "types.h"
 #include "hsmapi.h"
 #include "mlog.h"
 
diff --git a/common/hsmapi.h b/common/hsmapi.h
index b6d035d..63933af 100644
--- a/common/hsmapi.h
+++ b/common/hsmapi.h
@@ -19,13 +19,13 @@
 #ifndef HSMAPI_H
 #define HSMAPI_H
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
 #include "types.h"
 #include "global.h"
 #include "content.h"
 #include "content_inode.h"
 
+struct xfs_bstat;
+
 #define	HSM_API_VERSION_1	1	/* only version supported so far */
 
 typedef	void	hsm_fs_ctxt_t;		/* opaque HSM filesystem context */
@@ -94,7 +94,7 @@ extern int
 HsmEstimateFileSpace(
 	hsm_fs_ctxt_t	*fscontextp,
 	hsm_f_ctxt_t	*fcontextp,
-const	xfs_bstat_t	*statp,
+const	struct xfs_bstat	*statp,
 	off64_t		*bytes,
 	int		accurate);
 
@@ -117,7 +117,7 @@ const	xfs_bstat_t	*statp,
 extern int
 HsmEstimateFileOffset(
 	hsm_fs_ctxt_t	*contextp,
-const	xfs_bstat_t	*statp,
+const	struct xfs_bstat	*statp,
 	off64_t		bytecount,
 	off64_t		*byteoffset);
 
@@ -181,7 +181,7 @@ HsmDeleteFileContext(
 extern int
 HsmInitFileContext(
 	hsm_f_ctxt_t	*contextp,
-const	xfs_bstat_t	*statp);
+const	struct xfs_bstat	*statp);
 
 
 /******************************************************************************
@@ -201,7 +201,7 @@ const	xfs_bstat_t	*statp);
 extern int
 HsmModifyInode(
 	hsm_f_ctxt_t	*contextp,
-	xfs_bstat_t	*statp);
+	struct xfs_bstat	*statp);
 
 
 /******************************************************************************
diff --git a/common/lock.c b/common/lock.c
index a237931..9826581 100644
--- a/common/lock.c
+++ b/common/lock.c
@@ -15,10 +15,8 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
 #include <assert.h>
+#include <sys/types.h>
 
 #include "config.h"
 
diff --git a/common/main.c b/common/main.c
index e381e85..3848499 100644
--- a/common/main.c
+++ b/common/main.c
@@ -16,12 +16,11 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
+#include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
+#include <sys/param.h>
 #include <sys/wait.h>
 #include <sys/prctl.h>
 #include <sys/resource.h>
@@ -37,6 +36,7 @@
 #include <pthread.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
@@ -44,7 +44,6 @@
 #include "types.h"
 #include "stream.h"
 #include "cldmgr.h"
-#include "util.h"
 #include "getopt.h"
 #include "mlog.h"
 #include "qlock.h"
diff --git a/common/media.c b/common/media.c
index fceb78d..02fde9c 100644
--- a/common/media.c
+++ b/common/media.c
@@ -16,9 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <time.h>
diff --git a/common/mlog.c b/common/mlog.c
index c8b3129..b520131 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -16,19 +16,18 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <sys/types.h>
 #include <stdio.h>
 #include <stdarg.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <sys/types.h>
 #include <time.h>
 #include <getopt.h>
 #include <pthread.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
@@ -39,7 +38,6 @@
 #include "cldmgr.h"
 #include "getopt.h"
 #include "exit.h"
-#include "util.h"
 #include "global.h"
 #include "drive.h"
 
diff --git a/common/openutil.c b/common/openutil.c
index 6cc0efa..fcb52fc 100644
--- a/common/openutil.c
+++ b/common/openutil.c
@@ -15,9 +15,8 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
 
+#include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
diff --git a/common/path.c b/common/path.c
index b73121d..b234de1 100644
--- a/common/path.c
+++ b/common/path.c
@@ -16,9 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
 #include <assert.h>
-
 #include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
diff --git a/common/qlock.c b/common/qlock.c
index 0583a63..c770116 100644
--- a/common/qlock.c
+++ b/common/qlock.c
@@ -16,9 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
+#include <stdlib.h>
 #include <pthread.h>
 #include <semaphore.h>
 #include <assert.h>
diff --git a/common/ring.c b/common/ring.c
index bb90901..f5055ee 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -16,9 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <sys/types.h>
 #include <sys/mman.h>
 #include <errno.h>
diff --git a/common/stream.c b/common/stream.c
index 549bf59..3047886 100644
--- a/common/stream.c
+++ b/common/stream.c
@@ -16,9 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <pthread.h>
 #include <assert.h>
 #include <string.h>
diff --git a/common/types.h b/common/types.h
index f902828..ebdacdd 100644
--- a/common/types.h
+++ b/common/types.h
@@ -23,6 +23,13 @@
  */
 #include <stdint.h>
 
+/*
+ * type macros that were naively put into xfs/jdm.h, then used in places that
+ * have nothing to do with file handle operations.
+ */
+#define sizeofmember( t, m )	sizeof( ( ( t * )0 )->m )
+#define offsetofmember( t, m )	( ( size_t )( char * )&( ( ( t * )0 )->m ) )
+
 #define XFSDUMP_DIRPATH	inv_basepath()
 
 /*
@@ -51,6 +58,8 @@ typedef int32_t time32_t;
 
 typedef uint64_t xfs_ino_t;
 
+#define constpp        char * const *
+
 /* limits
  */
 #define	MKMAX( t, s )	( ( t )						\
diff --git a/common/util.c b/common/util.c
index 0d49d5c..bbca758 100644
--- a/common/util.c
+++ b/common/util.c
@@ -16,10 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-#include "config.h"
-
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
@@ -29,6 +25,8 @@
 #include <dirent.h>
 #include <assert.h>
 #include <string.h>
+#include <xfs/xfs.h>
+#include <xfs/jdm.h>
 
 #include "config.h"
 
diff --git a/dump/content.c b/dump/content.c
index 15fb357..1e86292 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -16,9 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
@@ -36,6 +33,8 @@
 #include <string.h>
 #include <uuid/uuid.h>
 
+#include <xfs/xfs.h>
+#include <xfs/jdm.h>
 #ifdef linux
 #include <xfs/xqm.h>
 #endif
diff --git a/dump/inomap.c b/dump/inomap.c
index 4e57a78..1dacf35 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -16,10 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-#include <malloc.h>
-
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
@@ -29,6 +25,8 @@
 #include <sys/ioctl.h>
 #include <assert.h>
 #include <string.h>
+#include <xfs/xfs.h>
+#include <xfs/jdm.h>
 
 #include "config.h"
 
diff --git a/dump/inomap.h b/dump/inomap.h
index f222642..fb9bbf7 100644
--- a/dump/inomap.h
+++ b/dump/inomap.h
@@ -29,6 +29,7 @@
  * the 64 inos beginning with the starting ino. two bits are available
  * for each ino.
  */
+struct xfs_bstat;
 
 /* inomap_build - this function allocates and constructs an in-memory
  * representation of the bitmap. it prunes from the map inos of files not
@@ -46,9 +47,9 @@
  * fall at file boundaries. returns BOOL_FALSE if error encountered (should
  * abort the dump; else returns BOOL_TRUE.
  */
-extern bool_t inomap_build( jdm_fshandle_t *fshandlep,
+extern bool_t inomap_build( void *fshandlep,
 			    int fsfd,
-			    xfs_bstat_t *rootstatp,
+			    struct xfs_bstat *rootstatp,
 			    bool_t last,
 	      		    time32_t lasttime,
 			    bool_t resume,
diff --git a/dump/var.c b/dump/var.c
index 6dd6a70..645caab 100644
--- a/dump/var.c
+++ b/dump/var.c
@@ -16,9 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
diff --git a/include/config.h.in b/include/config.h.in
index ef66ed9..3b35d83 100644
--- a/include/config.h.in
+++ b/include/config.h.in
@@ -46,4 +46,8 @@ typedef unsigned short umode_t;
 #define max(a,b)	(((a)>(b))?(a):(b))
 #endif
 
+#ifndef NBBY
+#define NBBY 8
+#endif
+
 #endif	/* __CONFIG_H__ */
diff --git a/inventory/inv_files.c b/inventory/inv_files.c
index 409ee0d..46f6b8f 100644
--- a/inventory/inv_files.c
+++ b/inventory/inv_files.c
@@ -16,9 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <time.h>
 #include <errno.h>
 #include <sys/stat.h>
diff --git a/invutil/list.c b/invutil/list.c
index ae5d9b7..46fb291 100644
--- a/invutil/list.c
+++ b/invutil/list.c
@@ -16,8 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
+#include <stdlib.h>
 #include <ncurses.h>
 #include <uuid/uuid.h>
 
diff --git a/invutil/menu.c b/invutil/menu.c
index c050359..f81f9b6 100644
--- a/invutil/menu.c
+++ b/invutil/menu.c
@@ -16,8 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
+#include <errno.h>
 #include <ncurses.h>
 #include <ctype.h>
 #include <uuid/uuid.h>
diff --git a/restore/bag.c b/restore/bag.c
index 3927877..55bba73 100644
--- a/restore/bag.c
+++ b/restore/bag.c
@@ -16,9 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <sys/types.h>
 #include <stdlib.h>
 #include <memory.h>
diff --git a/restore/content.c b/restore/content.c
index d4fe350..7c4a81f 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -16,9 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/socket.h>
@@ -39,12 +36,14 @@
 #include <assert.h>
 #include <string.h>
 #include <uuid/uuid.h>
+#include <xfs/xfs.h>
+#include <xfs/jdm.h>	/* only for util.h */
 
 #include "config.h"
 
 #include "types.h"
 #include "timeutil.h"
-#include "util.h"
+#include "util.h"	/* only for r/w routines, ALIGN_PTR */
 #include "cldmgr.h"
 #include "qlock.h"
 #include "lock.h"
diff --git a/restore/mmap.c b/restore/mmap.c
index e8536c2..29dd3d7 100644
--- a/restore/mmap.c
+++ b/restore/mmap.c
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
 #include <unistd.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
diff --git a/restore/tree.c b/restore/tree.c
index 363f0f1..0336e77 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -16,13 +16,13 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
+#include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
+#include <errno.h>
 #include <sys/mman.h>
 #include <sys/types.h>
+#include <sys/param.h>
 #include <fcntl.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
@@ -34,12 +34,13 @@
 #include <sys/ioctl.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
+#include <xfs/xfs.h>
 
 #include "config.h"
 
 #include "types.h"
 #include "exit.h"
-#include "util.h"
 #include "cldmgr.h"
 #include "path.h"
 #include "openutil.h"
diff --git a/restore/win.c b/restore/win.c
index e6c0be3..e5bf708 100644
--- a/restore/win.c
+++ b/restore/win.c
@@ -16,9 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <xfs/xfs.h>
-#include <xfs/jdm.h>
-
 #include <sys/types.h>
 #include <sys/mman.h>
 #include <time.h>
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
