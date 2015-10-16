Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 90BBC7F60
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 20:45:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 535BC30405F
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 18:45:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Y9ydzHYaK3NzeYAE for <xfs@oss.sgi.com>;
	Thu, 15 Oct 2015 18:45:21 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Zmu4u-00019r-SJ
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:04 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1Zmu4u-00005v-RX
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/8] build: don't rely on xfs/xfs.h to include necessary
	headers
Date: Fri, 16 Oct 2015 12:44:55 +1100
Message-Id: <1444959901-31319-3-git-send-email-david@fromorbit.com>
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

>From xfsprogs 4.2.0, the xfs headers no long include lots of
xfsprogs specific build information. xfsdump hasbeen implicitly
relying on those header for a clean build, rather than having it's
own definitions. Hence we need to add the missing bits to
config.h.in and include it in all the files that require the
specific help that the xfs headers used to provide.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/arch_xlate.c     |  4 ++++
 common/arch_xlate.h     |  1 +
 common/cldmgr.c         |  4 ++++
 common/content_common.c |  4 ++++
 common/dlog.c           |  4 ++++
 common/drive.c          |  3 +++
 common/drive_minrmt.c   |  5 +++++
 common/drive_scsitape.c |  5 +++++
 common/drive_simple.c   |  5 +++++
 common/fs.c             |  4 ++++
 common/global.c         |  4 ++++
 common/hsmapi.c         |  4 ++++
 common/lock.c           |  2 ++
 common/main.c           |  5 +++++
 common/media.c          |  2 ++
 common/mlog.c           |  3 +++
 common/openutil.c       |  5 +++++
 common/path.c           |  7 +++++++
 common/qlock.c          |  2 ++
 common/ring.c           |  2 ++
 common/stream.c         |  3 +++
 common/util.c           |  5 +++++
 dump/content.c          |  5 +++++
 dump/inomap.c           |  5 +++++
 dump/var.c              |  5 +++++
 include/config.h.in     | 45 +++++++++++++++++++++++++++++++++++----------
 inventory/inv_api.c     |  5 +++++
 inventory/inv_core.c    |  5 +++++
 inventory/inv_files.c   |  3 +++
 inventory/inv_fstab.c   |  5 +++++
 inventory/inv_idx.c     |  5 +++++
 inventory/inv_mgr.c     |  5 +++++
 inventory/inv_oref.c    |  2 ++
 inventory/inv_stobj.c   |  5 +++++
 inventory/testmain.c    |  4 ++++
 invutil/cmenu.c         |  3 +++
 invutil/fstab.c         |  3 +++
 invutil/invidx.c        |  4 ++++
 invutil/invutil.c       |  4 ++++
 invutil/screen.c        |  3 +++
 invutil/stobj.c         |  4 ++++
 librmt/rmtabort.c       |  1 +
 librmt/rmtclose.c       |  1 +
 librmt/rmtcommand.c     |  2 ++
 librmt/rmtfstat.c       |  2 ++
 librmt/rmtioctl.c       | 10 ++++++----
 librmt/rmtlib.h         |  3 ---
 librmt/rmtlseek.c       |  2 ++
 librmt/rmtmsg.c         |  5 +++++
 librmt/rmtopen.c        |  4 +++-
 librmt/rmtread.c        |  2 ++
 librmt/rmtstatus.c      |  2 ++
 librmt/rmtwrite.c       |  2 ++
 restore/bag.c           |  2 ++
 restore/content.c       |  5 +++++
 restore/dirattr.c       |  5 +++++
 restore/inomap.c        |  5 +++++
 restore/namreg.c        |  5 +++++
 restore/node.c          |  4 ++++
 restore/tree.c          |  7 +++++++
 restore/win.c           |  2 ++
 61 files changed, 256 insertions(+), 18 deletions(-)

diff --git a/common/arch_xlate.c b/common/arch_xlate.c
index e6f897e..f8aa50f 100644
--- a/common/arch_xlate.c
+++ b/common/arch_xlate.c
@@ -20,6 +20,10 @@
 #include <xfs/jdm.h>
 #include <assert.h>
 
+#include <strings.h>
+
+#include "config.h"
+
 #include "arch_xlate.h"
 #include "types.h"
 #include "global.h"
diff --git a/common/arch_xlate.h b/common/arch_xlate.h
index 35333c6..fa201cd 100644
--- a/common/arch_xlate.h
+++ b/common/arch_xlate.h
@@ -22,6 +22,7 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <strings.h>
 #include "types.h"
 #include "global.h"
 #include "content.h"
diff --git a/common/cldmgr.c b/common/cldmgr.c
index df33a3f..88fd7fd 100644
--- a/common/cldmgr.c
+++ b/common/cldmgr.c
@@ -19,6 +19,7 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
 #include <sys/wait.h>
 #include <sys/ipc.h>
 #include <sys/sem.h>
@@ -26,6 +27,9 @@
 #include <errno.h>
 #include <pthread.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "exit.h"
 #include "types.h"
diff --git a/common/content_common.c b/common/content_common.c
index 65be31f..99b1a4b 100644
--- a/common/content_common.c
+++ b/common/content_common.c
@@ -19,12 +19,16 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
 #include <sys/stat.h>
 #include <time.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <signal.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "util.h"
diff --git a/common/dlog.c b/common/dlog.c
index 6220cfe..dac4e64 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -19,6 +19,7 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
 #include <sys/select.h>
@@ -27,6 +28,9 @@
 #include <errno.h>
 #include <signal.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "mlog.h"
diff --git a/common/drive.c b/common/drive.c
index f9ba851..afef147 100644
--- a/common/drive.c
+++ b/common/drive.c
@@ -22,6 +22,9 @@
 #include <sys/stat.h>
 #include <time.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "util.h"
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 6d58f1f..51685dc 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -19,6 +19,8 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/stat.h>
 #include <sys/ipc.h>
 #include <sys/sem.h>
@@ -30,6 +32,9 @@
 #include <malloc.h>
 #include <sched.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "util.h"
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 3f45d01..eade6ac 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -19,6 +19,8 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/stat.h>
 #include <sys/ipc.h>
 #include <sys/sem.h>
@@ -30,6 +32,9 @@
 #include <malloc.h>
 #include <sched.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "util.h"
diff --git a/common/drive_simple.c b/common/drive_simple.c
index 2e57d8c..69fce4b 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -19,6 +19,8 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <time.h>
@@ -26,6 +28,9 @@
 #include <malloc.h>
 #include <sched.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "util.h"
diff --git a/common/fs.c b/common/fs.c
index b77f6cc..2cd2f72 100644
--- a/common/fs.c
+++ b/common/fs.c
@@ -20,6 +20,7 @@
 #include <xfs/jdm.h>
 #include "config.h"
 
+#include <unistd.h>
 #include <sys/stat.h>
 #include <sys/statvfs.h>
 #include <time.h>
@@ -28,6 +29,9 @@
 #include <mntent.h>
 #include <sys/ioctl.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "mlog.h"
diff --git a/common/global.c b/common/global.c
index ed844cc..319d4df 100644
--- a/common/global.c
+++ b/common/global.c
@@ -19,10 +19,14 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
 #include <sys/stat.h>
 #include <time.h>
 #include <errno.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "util.h"
diff --git a/common/hsmapi.c b/common/hsmapi.c
index 0bca9ff..ed29370 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -21,6 +21,10 @@
 #include <xfs/jdm.h>
 #include <assert.h>
 
+#include <string.h>
+
+#include "config.h"
+
 #include "hsmapi.h"
 #include "mlog.h"
 
diff --git a/common/lock.c b/common/lock.c
index 347f6cd..a237931 100644
--- a/common/lock.c
+++ b/common/lock.c
@@ -20,6 +20,8 @@
 #include <xfs/jdm.h>
 #include <assert.h>
 
+#include "config.h"
+
 #include "types.h"
 #include "qlock.h"
 #include "mlog.h"
diff --git a/common/main.c b/common/main.c
index f392856..3b82a76 100644
--- a/common/main.c
+++ b/common/main.c
@@ -19,6 +19,8 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <sys/prctl.h>
@@ -34,6 +36,9 @@
 #include <sched.h>
 #include <pthread.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "exit.h"
 #include "types.h"
diff --git a/common/media.c b/common/media.c
index 53b94d1..7d17405 100644
--- a/common/media.c
+++ b/common/media.c
@@ -28,6 +28,8 @@
 #include <getopt.h>
 #include <assert.h>
 
+#include "config.h"
+
 #include "types.h"
 #include "util.h"
 #include "mlog.h"
diff --git a/common/mlog.c b/common/mlog.c
index c546036..1fef185 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -28,6 +28,9 @@
 #include <getopt.h>
 #include <pthread.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "qlock.h"
diff --git a/common/openutil.c b/common/openutil.c
index c3b8d9a..9df42ae 100644
--- a/common/openutil.c
+++ b/common/openutil.c
@@ -18,11 +18,16 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/stat.h>
 #include <limits.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "mlog.h"
diff --git a/common/path.c b/common/path.c
index e40c473..b73121d 100644
--- a/common/path.c
+++ b/common/path.c
@@ -19,6 +19,13 @@
 #include <xfs/xfs.h>
 #include <assert.h>
 
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "config.h"
+
 #include "path.h"
 
 struct pem {
diff --git a/common/qlock.c b/common/qlock.c
index d88917c..1b466d6 100644
--- a/common/qlock.c
+++ b/common/qlock.c
@@ -23,6 +23,8 @@
 #include <semaphore.h>
 #include <assert.h>
 
+#include "config.h"
+
 #include "types.h"
 #include "qlock.h"
 #include "mlog.h"
diff --git a/common/ring.c b/common/ring.c
index f3de7c4..37a2d1d 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -29,6 +29,8 @@
 #include <malloc.h>
 #include <assert.h>
 
+#include "config.h"
+
 #include "types.h"
 #include "qlock.h"
 #include "cldmgr.h"
diff --git a/common/stream.c b/common/stream.c
index 0db1be3..90d315a 100644
--- a/common/stream.c
+++ b/common/stream.c
@@ -21,6 +21,9 @@
 
 #include <pthread.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "exit.h"
diff --git a/common/util.c b/common/util.c
index 1dc6d6c..af48162 100644
--- a/common/util.c
+++ b/common/util.c
@@ -20,12 +20,17 @@
 #include <xfs/jdm.h>
 #include "config.h"
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <dirent.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "util.h"
diff --git a/dump/content.c b/dump/content.c
index 3682358..5d630bb 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -19,6 +19,8 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/stat.h>
 #include <sys/prctl.h>
 #include <time.h>
@@ -31,6 +33,7 @@
 #include <sys/quota.h>
 #include <malloc.h>
 #include <assert.h>
+#include <string.h>
 
 #ifdef linux
 #include <xfs/xqm.h>
@@ -38,6 +41,8 @@
 
 #include <attr/attributes.h>
 
+#include "config.h"
+
 #include "hsmapi.h"
 
 #include "exit.h"
diff --git a/dump/inomap.c b/dump/inomap.c
index 7a3069f..dacf954 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -20,12 +20,17 @@
 #include <xfs/jdm.h>
 #include <malloc.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/stat.h>
 #include <errno.h>
 #include <time.h>
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "util.h"
diff --git a/dump/var.c b/dump/var.c
index 8370fa4..ceb7e3a 100644
--- a/dump/var.c
+++ b/dump/var.c
@@ -19,9 +19,14 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/stat.h>
 #include <errno.h>
 #include <dirent.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "fs.h"
diff --git a/include/config.h.in b/include/config.h.in
index 7cc4f2a..ef66ed9 100644
--- a/include/config.h.in
+++ b/include/config.h.in
@@ -6,19 +6,44 @@
 #ifndef __CONFIG_H__
 #define __CONFIG_H__
 
+/* long and pointer must be either 32 bit or 64 bit */
+#undef SIZEOF_LONG
+#undef SIZEOF_CHAR_P
+#define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
+
+/* Check whether to define umode_t ourselves. */
+#ifndef HAVE_UMODE_T
+typedef unsigned short umode_t;
+#endif
+
 /* Define if you want gettext (I18N) support */
 #undef ENABLE_GETTEXT
-
-#ifndef _
-# ifdef ENABLE_GETTEXT
-#  include <libintl.h>
-#   define _(x)			gettext(x)
-# else
-#  define _(x)			(x)
-#  define textdomain(d)		do { } while (0)
-#  define bindtextdomain(d,dir)	do { } while (0)
-# endif
+#ifdef ENABLE_GETTEXT
+# include <libintl.h>
+# define _(x)                   gettext(x)
+# define N_(x)			 x
+#else
+# define _(x)                   (x)
+# define N_(x)			 x
+# define textdomain(d)          do { } while (0)
+# define bindtextdomain(d,dir)  do { } while (0)
 #endif
 #include <locale.h>
 
+#define IRIX_DEV_BITSMAJOR      14
+#define IRIX_DEV_BITSMINOR      18
+#define IRIX_DEV_MAXMAJ         0x1ff
+#define IRIX_DEV_MAXMIN         0x3ffff
+#define IRIX_DEV_MAJOR(dev)	((int)(((unsigned)(dev) >> IRIX_DEV_BITSMINOR) \
+					& IRIX_DEV_MAXMAJ))
+#define IRIX_DEV_MINOR(dev)	((int)((dev) & IRIX_DEV_MAXMIN))
+#define IRIX_MKDEV(major,minor)	((xfs_dev_t)(((major) << IRIX_DEV_BITSMINOR) \
+					| (minor&IRIX_DEV_MAXMIN)))
+#define IRIX_DEV_TO_KDEVT(dev)	makedev(IRIX_DEV_MAJOR(dev),IRIX_DEV_MINOR(dev))
+
+#ifndef min
+#define min(a,b)	(((a)<(b))?(a):(b))
+#define max(a,b)	(((a)>(b))?(a):(b))
+#endif
+
 #endif	/* __CONFIG_H__ */
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index bd473e9..b564d2f 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -19,6 +19,8 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <fcntl.h>
 #include <time.h>
 #include <stdlib.h>
@@ -27,6 +29,9 @@
 #include <stdio.h>
 #include <sys/stat.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "mlog.h"
diff --git a/inventory/inv_core.c b/inventory/inv_core.c
index a83e7ef..7020f7f 100644
--- a/inventory/inv_core.c
+++ b/inventory/inv_core.c
@@ -19,6 +19,7 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
 #include <sys/file.h>
 #include <sys/stat.h>
 #include <time.h>
@@ -26,6 +27,10 @@
 #include <errno.h>
 #include <sys/dir.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
+
 #include "types.h"
 #include "inv_priv.h"
 
diff --git a/inventory/inv_files.c b/inventory/inv_files.c
index 34b7aac..409ee0d 100644
--- a/inventory/inv_files.c
+++ b/inventory/inv_files.c
@@ -24,6 +24,9 @@
 #include <sys/stat.h>
 #include <sys/dir.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 
 /*----------------------------------------------------------------------*/
diff --git a/inventory/inv_fstab.c b/inventory/inv_fstab.c
index e87152f..8263852 100644
--- a/inventory/inv_fstab.c
+++ b/inventory/inv_fstab.c
@@ -19,6 +19,8 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/file.h>
 #include <sys/stat.h>
 #include <time.h>
@@ -26,6 +28,9 @@
 #include <fcntl.h>
 #include <sys/dir.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "mlog.h"
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index edb72b3..0378c5a 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -19,6 +19,7 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <stdlib.h>
 #include <time.h>
 #include <fcntl.h>
 #include <errno.h>
@@ -26,6 +27,10 @@
 #include <sys/stat.h>
 #include <sys/dir.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
+
 #include "types.h"
 #include "mlog.h"
 #include "inv_priv.h"
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index 926b4c8..f1341b9 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -19,12 +19,17 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
 #include <time.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <sys/stat.h>
 #include <sys/dir.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
+
 #include "types.h"
 #include "mlog.h"
 #include "inv_priv.h"
diff --git a/inventory/inv_oref.c b/inventory/inv_oref.c
index b6cd61d..ebcae95 100644
--- a/inventory/inv_oref.c
+++ b/inventory/inv_oref.c
@@ -20,6 +20,8 @@
 #include <xfs/jdm.h>
 #include <assert.h>
 
+#include "config.h"
+
 #include "inv_priv.h"
 #include "inv_oref.h"
 
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 42969b1..bae2fc5 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -19,6 +19,8 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <time.h>
 #include <fcntl.h>
 #include <errno.h>
@@ -27,6 +29,9 @@
 #include <sys/dir.h>
 #include <sys/mman.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "timeutil.h"
diff --git a/inventory/testmain.c b/inventory/testmain.c
index d8c61e2..51b7774 100644
--- a/inventory/testmain.c
+++ b/inventory/testmain.c
@@ -19,10 +19,14 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <stdio.h>
 #include <sys/file.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <assert.h>
+
+#include "config.h"
+
 #include "types.h"
 #include "mlog.h"
 #include "getopt.h"
diff --git a/invutil/cmenu.c b/invutil/cmenu.c
index ff4abef..ce23d28 100644
--- a/invutil/cmenu.c
+++ b/invutil/cmenu.c
@@ -19,9 +19,12 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <ncurses.h>
 #include <signal.h>
 #include <sys/stat.h>
+#include <string.h>
 
 #include "types.h"
 #include "mlog.h"
diff --git a/invutil/fstab.c b/invutil/fstab.c
index acbe94b..ac8f775 100644
--- a/invutil/fstab.c
+++ b/invutil/fstab.c
@@ -19,9 +19,12 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <signal.h>
 #include <ncurses.h>
 #include <sys/mman.h>
+#include <string.h>
 
 #include "types.h"
 #include "mlog.h"
diff --git a/invutil/invidx.c b/invutil/invidx.c
index 8de137c..b6ce4fa 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -19,9 +19,13 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
 #include <ncurses.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
+#include <string.h>
 
 #include "types.h"
 #include "mlog.h"
diff --git a/invutil/invutil.c b/invutil/invutil.c
index b75db14..e1c8868 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -19,11 +19,15 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <errno.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <time.h>
 #include <sys/mman.h>
+#include <string.h>
+#include <libgen.h>
 
 #include "types.h"
 #include "mlog.h"
diff --git a/invutil/screen.c b/invutil/screen.c
index 12074f0..c4b79d8 100644
--- a/invutil/screen.c
+++ b/invutil/screen.c
@@ -18,6 +18,9 @@
 
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
+
+#include <stdio.h>
+#include <string.h>
 #include <ncurses.h>
 
 #include "cmenu.h"
diff --git a/invutil/stobj.c b/invutil/stobj.c
index a74ba0f..eb04385 100644
--- a/invutil/stobj.c
+++ b/invutil/stobj.c
@@ -18,9 +18,13 @@
 
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
+
+#include <unistd.h>
+#include <stdlib.h>
 #include <ncurses.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
+#include <string.h>
 
 #include "types.h"
 #include "mlog.h"
diff --git a/librmt/rmtabort.c b/librmt/rmtabort.c
index 3efa651..a7db4b1 100644
--- a/librmt/rmtabort.c
+++ b/librmt/rmtabort.c
@@ -21,6 +21,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <unistd.h>
 #include "rmtlib.h"
 
 /*
diff --git a/librmt/rmtclose.c b/librmt/rmtclose.c
index a155366..97f53c7 100644
--- a/librmt/rmtclose.c
+++ b/librmt/rmtclose.c
@@ -21,6 +21,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <unistd.h>
 #include "rmtlib.h"
 
 static int _rmt_close(int);
diff --git a/librmt/rmtcommand.c b/librmt/rmtcommand.c
index fbd7a6a..82c9032 100644
--- a/librmt/rmtcommand.c
+++ b/librmt/rmtcommand.c
@@ -22,6 +22,8 @@
  */
 
 #include <errno.h>
+#include <unistd.h>
+#include <string.h>
 
 #include "rmtlib.h"
 
diff --git a/librmt/rmtfstat.c b/librmt/rmtfstat.c
index 3506567..92a49d7 100644
--- a/librmt/rmtfstat.c
+++ b/librmt/rmtfstat.c
@@ -24,6 +24,8 @@
 #include "rmtlib.h"
 
 #include <errno.h>
+#include <unistd.h>
+#include <stdio.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 
diff --git a/librmt/rmtioctl.c b/librmt/rmtioctl.c
index 4c108fb..bd6f887 100644
--- a/librmt/rmtioctl.c
+++ b/librmt/rmtioctl.c
@@ -21,17 +21,19 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <unistd.h>
 #include <errno.h>
-
-#include "rmtlib.h"
-#include "swap.h"
-
 #include <sys/types.h>
 #include <sys/ioctl.h>
 #include <sys/mtio.h>
 #include <sys/param.h>
 #include <assert.h>
 
+#include "config.h"
+#include "rmtlib.h"
+#include "swap.h"
+
+
 /*
  * uses old_mtget IRIX structure since we don't bother
  * sending the "V" version command.
diff --git a/librmt/rmtlib.h b/librmt/rmtlib.h
index bc6961c..1f877ca 100644
--- a/librmt/rmtlib.h
+++ b/librmt/rmtlib.h
@@ -27,9 +27,6 @@
  *
  */
 
-
-#include <xfs/xfs.h>
-
 /*
  *	Note that local vs remote file descriptors are distinquished
  *	by adding a bias to the remote descriptors.  This is a quick
diff --git a/librmt/rmtlseek.c b/librmt/rmtlseek.c
index 8903886..bf8c0fa 100644
--- a/librmt/rmtlseek.c
+++ b/librmt/rmtlseek.c
@@ -21,7 +21,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <stdio.h>
 #include <sys/types.h>
+#include <unistd.h>
 #include "rmtlib.h"
 
 static off_t _rmt_lseek(int, off_t, int);
diff --git a/librmt/rmtmsg.c b/librmt/rmtmsg.c
index 17addd1..d28a1f2 100644
--- a/librmt/rmtmsg.c
+++ b/librmt/rmtmsg.c
@@ -21,6 +21,11 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "config.h"
 #include "rmtlib.h"
 
 /*
diff --git a/librmt/rmtopen.c b/librmt/rmtopen.c
index 6a05ab3..4bf9383 100644
--- a/librmt/rmtopen.c
+++ b/librmt/rmtopen.c
@@ -24,13 +24,15 @@
 #include <unistd.h>
 #include <errno.h>
 #include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
 #include <string.h>
 #include <sys/signal.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 
-
+#include "config.h"
 #include "rmtlib.h"
 
 #define RMT_DEBUG_FILE "/tmp/librmt_debug" /* file for debug output on server */
diff --git a/librmt/rmtread.c b/librmt/rmtread.c
index d5a840e..3456901 100644
--- a/librmt/rmtread.c
+++ b/librmt/rmtread.c
@@ -21,6 +21,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <stdio.h>
+#include <unistd.h>
 #include <errno.h>
 
 #include "rmtlib.h"
diff --git a/librmt/rmtstatus.c b/librmt/rmtstatus.c
index 8528bc4..21d909d 100644
--- a/librmt/rmtstatus.c
+++ b/librmt/rmtstatus.c
@@ -21,6 +21,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <stdlib.h>
+#include <unistd.h>
 #include <errno.h>
 
 #include "rmtlib.h"
diff --git a/librmt/rmtwrite.c b/librmt/rmtwrite.c
index c42b1ab..9e5a1a3 100644
--- a/librmt/rmtwrite.c
+++ b/librmt/rmtwrite.c
@@ -21,6 +21,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <unistd.h>
+#include <stdio.h>
 #include <errno.h>
 
 #include "rmtlib.h"
diff --git a/restore/bag.c b/restore/bag.c
index 8c7a216..3927877 100644
--- a/restore/bag.c
+++ b/restore/bag.c
@@ -24,6 +24,8 @@
 #include <memory.h>
 #include <assert.h>
 
+#include "config.h"
+
 #include "types.h"
 #include "mlog.h"
 #include "bag.h"
diff --git a/restore/content.c b/restore/content.c
index 4796aea..b02e38a 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -19,6 +19,8 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/socket.h>
 #include <sys/un.h>
 #include <sys/mman.h>
@@ -35,6 +37,9 @@
 #include <malloc.h>
 #include <pthread.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "timeutil.h"
diff --git a/restore/dirattr.c b/restore/dirattr.c
index c829808..a15abe5 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -29,6 +29,8 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
@@ -37,6 +39,9 @@
 #include <fcntl.h>
 #include <dirent.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "util.h"
diff --git a/restore/inomap.c b/restore/inomap.c
index 2c62afc..e5bcb55 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -19,6 +19,8 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <errno.h>
@@ -27,6 +29,9 @@
 #include <dirent.h>
 #include <time.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "util.h"
diff --git a/restore/namreg.c b/restore/namreg.c
index c64833d..18ba6d9 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -19,12 +19,17 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "lock.h"
diff --git a/restore/node.c b/restore/node.c
index f0297a5..046f2f6 100644
--- a/restore/node.c
+++ b/restore/node.c
@@ -19,12 +19,16 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/mman.h>
 #include <errno.h>
 #include <memory.h>
 #include <limits.h>
 #include <assert.h>
 
+#include "config.h"
+
 #include "types.h"
 #include "mlog.h"
 #include "win.h"
diff --git a/restore/tree.c b/restore/tree.c
index d377590..98f6952 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -19,7 +19,11 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <unistd.h>
+#include <stdlib.h>
 #include <sys/mman.h>
+#include <sys/types.h>
+#include <fcntl.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
 #include <utime.h>
@@ -29,6 +33,9 @@
 #include <dirent.h>
 #include <sys/ioctl.h>
 #include <assert.h>
+#include <string.h>
+
+#include "config.h"
 
 #include "types.h"
 #include "exit.h"
diff --git a/restore/win.c b/restore/win.c
index a9f0239..3ca2af8 100644
--- a/restore/win.c
+++ b/restore/win.c
@@ -27,6 +27,8 @@
 #include <errno.h>
 #include <assert.h>
 
+#include "config.h"
+
 #include "types.h"
 #include "mlog.h"
 #include "qlock.h"
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
