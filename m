Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF0A87F5A
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 20:45:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C0B4430405F
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 18:45:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jAtWaqGo2oGZ5D3J for <xfs@oss.sgi.com>;
	Thu, 15 Oct 2015 18:45:20 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Zmu4u-00019v-VR
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1Zmu4u-00006F-Tf
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] cleanup: use system uuid.h headers
Date: Fri, 16 Oct 2015 12:44:59 +1100
Message-Id: <1444959901-31319-7-git-send-email-david@fromorbit.com>
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

Another bunch of support pulled in from the xfs headers, but would
never have worked correctly on any platform other than Linux as dump
doe snot use the abstractions that xfsprogs wraps around the uuid
interfaces. Hence just make it work on Linux for now, as it's
already relying on native support.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/fs.c           | 1 +
 common/global.c       | 1 +
 common/inventory.c    | 1 +
 dump/content.c        | 1 +
 dump/var.c            | 1 +
 inventory/inv_api.c   | 1 +
 inventory/inv_fstab.c | 1 +
 inventory/inv_mgr.c   | 1 +
 inventory/inv_stobj.c | 1 +
 inventory/testmain.c  | 1 +
 invutil/cmenu.c       | 1 +
 invutil/fstab.c       | 1 +
 invutil/invidx.c      | 1 +
 invutil/invutil.c     | 1 +
 invutil/list.c        | 1 +
 invutil/menu.c        | 1 +
 invutil/screen.c      | 1 +
 invutil/stobj.c       | 1 +
 restore/content.c     | 1 +
 19 files changed, 19 insertions(+)

diff --git a/common/fs.c b/common/fs.c
index 184f08d..e600e38 100644
--- a/common/fs.c
+++ b/common/fs.c
@@ -30,6 +30,7 @@
 #include <sys/ioctl.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
diff --git a/common/global.c b/common/global.c
index ea7ad6d..ca11368 100644
--- a/common/global.c
+++ b/common/global.c
@@ -25,6 +25,7 @@
 #include <errno.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
diff --git a/common/inventory.c b/common/inventory.c
index 83e1ebb..d1b810c 100644
--- a/common/inventory.c
+++ b/common/inventory.c
@@ -28,6 +28,7 @@
 #include <stdio.h>
 #include <sys/stat.h>
 #include <assert.h>
+#include <uuid/uuid.h>
 
 #include "types.h"
 #include "inventory_priv.h"
diff --git a/dump/content.c b/dump/content.c
index fcd7dd7..15fb357 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -34,6 +34,7 @@
 #include <malloc.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #ifdef linux
 #include <xfs/xqm.h>
diff --git a/dump/var.c b/dump/var.c
index d3fa3be..6dd6a70 100644
--- a/dump/var.c
+++ b/dump/var.c
@@ -25,6 +25,7 @@
 #include <errno.h>
 #include <dirent.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index 888c425..acca40b 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -30,6 +30,7 @@
 #include <sys/stat.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
diff --git a/inventory/inv_fstab.c b/inventory/inv_fstab.c
index 1c2bf3d..56d6b8f 100644
--- a/inventory/inv_fstab.c
+++ b/inventory/inv_fstab.c
@@ -29,6 +29,7 @@
 #include <sys/dir.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index e521f24..79d4bb1 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -27,6 +27,7 @@
 #include <sys/dir.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 0763d0b..9619476 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -30,6 +30,7 @@
 #include <sys/mman.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
diff --git a/inventory/testmain.c b/inventory/testmain.c
index 3f742e4..ecddf54 100644
--- a/inventory/testmain.c
+++ b/inventory/testmain.c
@@ -24,6 +24,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <assert.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
diff --git a/invutil/cmenu.c b/invutil/cmenu.c
index ce23d28..e60fd22 100644
--- a/invutil/cmenu.c
+++ b/invutil/cmenu.c
@@ -25,6 +25,7 @@
 #include <signal.h>
 #include <sys/stat.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "types.h"
 #include "mlog.h"
diff --git a/invutil/fstab.c b/invutil/fstab.c
index ac8f775..4284cd1 100644
--- a/invutil/fstab.c
+++ b/invutil/fstab.c
@@ -25,6 +25,7 @@
 #include <ncurses.h>
 #include <sys/mman.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "types.h"
 #include "mlog.h"
diff --git a/invutil/invidx.c b/invutil/invidx.c
index 44c5e7f..67efdf7 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -26,6 +26,7 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "types.h"
 #include "mlog.h"
diff --git a/invutil/invutil.c b/invutil/invutil.c
index e1c8868..06bdeda 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -28,6 +28,7 @@
 #include <sys/mman.h>
 #include <string.h>
 #include <libgen.h>
+#include <uuid/uuid.h>
 
 #include "types.h"
 #include "mlog.h"
diff --git a/invutil/list.c b/invutil/list.c
index 0157102..ae5d9b7 100644
--- a/invutil/list.c
+++ b/invutil/list.c
@@ -19,6 +19,7 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 #include <ncurses.h>
+#include <uuid/uuid.h>
 
 #include "list.h"
 #include "cmenu.h"
diff --git a/invutil/menu.c b/invutil/menu.c
index a0d2d0e..c050359 100644
--- a/invutil/menu.c
+++ b/invutil/menu.c
@@ -20,6 +20,7 @@
 #include <xfs/jdm.h>
 #include <ncurses.h>
 #include <ctype.h>
+#include <uuid/uuid.h>
 
 #include "types.h"
 #include "cmenu.h"
diff --git a/invutil/screen.c b/invutil/screen.c
index c4b79d8..6e913a7 100644
--- a/invutil/screen.c
+++ b/invutil/screen.c
@@ -22,6 +22,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <ncurses.h>
+#include <uuid/uuid.h>
 
 #include "cmenu.h"
 
diff --git a/invutil/stobj.c b/invutil/stobj.c
index eb04385..f389c53 100644
--- a/invutil/stobj.c
+++ b/invutil/stobj.c
@@ -25,6 +25,7 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "types.h"
 #include "mlog.h"
diff --git a/restore/content.c b/restore/content.c
index 5e6e88e..d4fe350 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -38,6 +38,7 @@
 #include <pthread.h>
 #include <assert.h>
 #include <string.h>
+#include <uuid/uuid.h>
 
 #include "config.h"
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
