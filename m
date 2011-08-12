Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7CIX6nG075611 for <xfs@oss.sgi.com>; Fri, 12 Aug 2011 13:33:07 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201108121833.p7CIX3Ep018936@stout.americas.sgi.com>
Date: Fri, 12 Aug 2011 13:33:02 -0500
Subject: [PATCH] xfs: don't expect xfs headers to be in subdirectories
MIME-Version: 1.0
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

From: Christoph Hellwig <hch@lst.de>

Fix up some #include directives in preparation for moving a few
header files out of xfs source subdirectories.

While at it, switch the quoting convention used for included files
in "xfs_linux.h".

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/Makefile                 |    2 +-
 fs/xfs/linux-2.6/xfs_linux.h    |   27 +++++++++++++--------------
 fs/xfs/linux-2.6/xfs_quotaops.c |    2 +-
 fs/xfs/linux-2.6/xfs_trace.c    |    4 ++--
 fs/xfs/xfs.h                    |    3 ++-
 5 files changed, 19 insertions(+), 19 deletions(-)

Index: b/fs/xfs/Makefile
===================================================================
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -16,7 +16,7 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
-ccflags-y := -I$(src) -I$(src)/linux-2.6
+ccflags-y := -I$(src) -I$(src)/linux-2.6 -I$(src)/quota -I$(src)/support
 ccflags-$(CONFIG_XFS_DEBUG) += -g
 
 XFS_LINUX := linux-2.6
Index: b/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -32,13 +32,12 @@
 # define XFS_BIG_INUMS	0
 #endif
 
-#include <xfs_types.h>
+#include "xfs_types.h"
 
-#include <kmem.h>
-#include <mrlock.h>
-#include <time.h>
-
-#include <support/uuid.h>
+#include "kmem.h"
+#include "mrlock.h"
+#include "time.h"
+#include "uuid.h"
 
 #include <linux/semaphore.h>
 #include <linux/mm.h>
@@ -78,14 +77,14 @@
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
-#include <xfs_vnode.h>
-#include <xfs_stats.h>
-#include <xfs_sysctl.h>
-#include <xfs_iops.h>
-#include <xfs_aops.h>
-#include <xfs_super.h>
-#include <xfs_buf.h>
-#include <xfs_message.h>
+#include "xfs_vnode.h"
+#include "xfs_stats.h"
+#include "xfs_sysctl.h"
+#include "xfs_iops.h"
+#include "xfs_aops.h"
+#include "xfs_super.h"
+#include "xfs_buf.h"
+#include "xfs_message.h"
 
 #ifdef __BIG_ENDIAN
 #define XFS_NATIVE_HOST 1
Index: b/fs/xfs/linux-2.6/xfs_quotaops.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_quotaops.c
+++ b/fs/xfs/linux-2.6/xfs_quotaops.c
@@ -25,7 +25,7 @@
 #include "xfs_trans.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
-#include "quota/xfs_qm.h"
+#include "xfs_qm.h"
 #include <linux/quota.h>
 
 
Index: b/fs/xfs/linux-2.6/xfs_trace.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_trace.c
+++ b/fs/xfs/linux-2.6/xfs_trace.c
@@ -43,8 +43,8 @@
 #include "xfs_quota.h"
 #include "xfs_iomap.h"
 #include "xfs_aops.h"
-#include "quota/xfs_dquot_item.h"
-#include "quota/xfs_dquot.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 #include "xfs_log_recover.h"
 #include "xfs_inode_item.h"
 
Index: b/fs/xfs/xfs.h
===================================================================
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -24,5 +24,6 @@
 #define XFS_BUF_LOCK_TRACKING 1
 #endif
 
-#include <linux-2.6/xfs_linux.h>
+#include "xfs_linux.h"
+
 #endif	/* __XFS_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
