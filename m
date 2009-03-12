Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CFEJmh084668 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 10:14:40 -0500
Received: from attica.americas.sgi.com (attica.americas.sgi.com
	[128.162.236.44])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5147F304067
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 08:13:57 -0700 (PDT)
From: Felix Blyakher <felixb@sgi.com>
Subject: [PATCH] Fix xfs debug build breakage
Date: Thu, 12 Mar 2009 09:54:15 -0500
Message-Id: <1236869655-14757-1-git-send-email-felixb@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Fix xfs debug build breakage by pushing xfs_error.h after
xfs_mount.h, which it depends on.

Signed-off-by: Felix Blyakher <felixb@sgi.com>
---
 fs/xfs/support/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/support/debug.c b/fs/xfs/support/debug.c
index 930bb34..3f3610a 100644
--- a/fs/xfs/support/debug.c
+++ b/fs/xfs/support/debug.c
@@ -17,7 +17,6 @@
  */
 #include <xfs.h>
 #include "debug.h"
-#include "xfs_error.h"
 
 /* xfs_mount.h drags a lot of crap in, sorry.. */
 #include "xfs_sb.h"
@@ -25,6 +24,7 @@
 #include "xfs_ag.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
+#include "xfs_error.h"
 
 static char		message[1024];	/* keep it off the stack */
 static DEFINE_SPINLOCK(xfs_err_lock);
-- 
1.5.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
